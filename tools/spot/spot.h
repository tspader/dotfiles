#ifndef SPOT_H
#define SPOT_H

#include "sp.h"

#define SPOT_MAX_DIRS 1024
#define SPOT_STAMP_LEN 19

typedef enum {
  SPOT_REQUEST_NEW,
  SPOT_REQUEST_GO,
  SPOT_REQUEST_KEEP,
  SPOT_REQUEST_LS,
} spot_request_kind_t;

typedef enum {
  SPOT_KEEP_CWD,
  SPOT_KEEP_INDEX,
} spot_keep_target_t;

typedef struct {
  spot_request_kind_t kind;
  union {
    struct {
      const c8* name;
    } new;
    struct {
      u32 index;
    } go;
    struct {
      const c8* name;
      spot_keep_target_t target;
      u32 index;
    } keep;
  };
} spot_request_t;

typedef enum {
  SPOT_ERR_NONE,
  SPOT_ERR_EMPTY,
  SPOT_ERR_OUT_OF_RANGE,
  SPOT_ERR_NOT_IN_HOME,
  SPOT_ERR_EXISTS,
} spot_err_kind_t;

typedef enum {
  SPOT_RESULT_NEW,
  SPOT_RESULT_GO,
  SPOT_RESULT_KEEP,
  SPOT_RESULT_LS,
  SPOT_RESULT_ERR,
} spot_result_kind_t;

typedef struct {
  sp_str_t name;
  sp_str_t path;
} spot_dir_t;

typedef struct {
  spot_result_kind_t kind;
  union {
    struct {
      sp_str_t path;
    } new;
    struct {
      sp_str_t path;
    } go;
    struct {
      sp_str_t from;
      sp_str_t to;
    } keep;
    struct {
      sp_da(spot_dir_t) dirs;
    } ls;
    struct {
      spot_err_kind_t kind;
    } err;
  };
} spot_result_t;

typedef struct {
  const c8* home;
  const c8* cwd;
  sp_tm_date_time_t now;
  const c8* dirs [SPOT_MAX_DIRS];
  const c8* kept [SPOT_MAX_DIRS];
} spot_state_t;

bool           spot_name_is_stamped(sp_str_t name);
sp_str_t       spot_stamp(sp_mem_t mem, sp_tm_date_time_t now);
sp_str_t       spot_tmp_path(sp_mem_t mem, sp_str_t home);
sp_str_t       spot_keep_path(sp_mem_t mem, sp_str_t home);
spot_result_t  spot_run(sp_mem_t mem, spot_state_t* state, spot_request_t request);

SP_PRIVATE spot_result_t spot_fail(spot_err_kind_t kind) {
  return (spot_result_t) {
    .kind = SPOT_RESULT_ERR,
    .err = {
      .kind = kind,
    },
  };
}

SP_PRIVATE s32 spot_dir_compare(const void* a, const void* b) {
  const spot_dir_t* da = sp_cast(const spot_dir_t*, a);
  const spot_dir_t* db = sp_cast(const spot_dir_t*, b);
  return sp_str_compare_alphabetical(db->name, da->name);
}

bool spot_name_is_stamped(sp_str_t name) {
  sp_str_t pattern = sp_str_lit("####-##-##T##-##-##");
  if (name.len < SPOT_STAMP_LEN) return false;
  sp_for(it, SPOT_STAMP_LEN) {
    c8 c = name.data[it];
    c8 p = pattern.data[it];
    if (p == '#') {
      if (c < '0' || c > '9') return false;
    }
    else if (c != p) {
      return false;
    }
  }
  if (name.len == SPOT_STAMP_LEN) return true;
  return name.data[SPOT_STAMP_LEN] == '-' && name.len > SPOT_STAMP_LEN + 1;
}

sp_str_t spot_stamp(sp_mem_t mem, sp_tm_date_time_t now) {
  return sp_fmt(
    mem, "{:0>4}-{:0>2}-{:0>2}T{:0>2}-{:0>2}-{:0>2}",
    sp_fmt_int(now.year), sp_fmt_int(now.month), sp_fmt_int(now.day),
    sp_fmt_int(now.hour), sp_fmt_int(now.minute), sp_fmt_int(now.second)
  ).value;
}

sp_str_t spot_tmp_path(sp_mem_t mem, sp_str_t home) {
  return sp_fs_join_path(mem, home, sp_str_lit("tmp"));
}

sp_str_t spot_keep_path(sp_mem_t mem, sp_str_t home) {
  return sp_fs_join_path(mem, home, sp_str_lit("keep"));
}

SP_PRIVATE sp_da(spot_dir_t) spot_collect(sp_mem_t mem, spot_state_t* state) {
  sp_da(spot_dir_t) dirs = sp_da_new(mem, spot_dir_t);
  sp_str_t base = spot_tmp_path(mem, sp_cstr_as_str(state->home));
  sp_carr_for(state->dirs, it) {
    if (!state->dirs[it]) break;
    sp_str_t name = sp_cstr_as_str(state->dirs[it]);
    if (!spot_name_is_stamped(name)) continue;
    sp_da_push(dirs, ((spot_dir_t) {
      .name = name,
      .path = sp_fs_join_path(mem, base, name),
    }));
  }
  sp_da_sort(dirs, spot_dir_compare);
  return dirs;
}

spot_result_t spot_run(sp_mem_t mem, spot_state_t* state, spot_request_t request) {
  sp_str_t home = sp_cstr_as_str(state->home);
  sp_da(spot_dir_t) dirs = spot_collect(mem, state);

  switch (request.kind) {
    case SPOT_REQUEST_NEW: {
      sp_str_t name = spot_stamp(mem, state->now);
      if (request.new.name && !sp_str_empty(sp_cstr_as_str(request.new.name))) {
        name = sp_fmt(mem, "{}-{}", sp_fmt_str(name), sp_fmt_cstr(request.new.name)).value;
      }
      sp_da_for(dirs, it) {
        if (sp_str_equal(dirs[it].name, name)) return spot_fail(SPOT_ERR_EXISTS);
      }
      return (spot_result_t) {
        .kind = SPOT_RESULT_NEW,
        .new = {
          .path = sp_fs_join_path(mem, spot_tmp_path(mem, home), name),
        },
      };
    }
    case SPOT_REQUEST_GO: {
      if (sp_da_empty(dirs)) return spot_fail(SPOT_ERR_EMPTY);
      if (request.go.index >= sp_da_size(dirs)) return spot_fail(SPOT_ERR_OUT_OF_RANGE);
      return (spot_result_t) {
        .kind = SPOT_RESULT_GO,
        .go = {
          .path = dirs[request.go.index].path,
        },
      };
    }
    case SPOT_REQUEST_KEEP: {
      spot_dir_t from = sp_zero_s(spot_dir_t);
      switch (request.keep.target) {
        case SPOT_KEEP_INDEX: {
          if (sp_da_empty(dirs)) return spot_fail(SPOT_ERR_EMPTY);
          if (request.keep.index >= sp_da_size(dirs)) return spot_fail(SPOT_ERR_OUT_OF_RANGE);
          from = dirs[request.keep.index];
          break;
        }
        case SPOT_KEEP_CWD: {
          if (!state->cwd) return spot_fail(SPOT_ERR_NOT_IN_HOME);
          sp_str_t cwd = sp_cstr_as_str(state->cwd);
          sp_da_for(dirs, it) {
            sp_str_t path = dirs[it].path;
            if (sp_str_equal(cwd, path)) {
              from = dirs[it];
              break;
            }
            if (cwd.len > path.len && sp_str_starts_with(cwd, path) && sp_fs_is_sep(cwd.data[path.len])) {
              from = dirs[it];
              break;
            }
          }
          if (sp_str_empty(from.name)) return spot_fail(SPOT_ERR_NOT_IN_HOME);
          break;
        }
      }
      sp_str_t name = sp_cstr_as_str(request.keep.name);
      sp_carr_for(state->kept, it) {
        if (!state->kept[it]) break;
        if (sp_str_equal(sp_cstr_as_str(state->kept[it]), name)) return spot_fail(SPOT_ERR_EXISTS);
      }
      return (spot_result_t) {
        .kind = SPOT_RESULT_KEEP,
        .keep = {
          .from = from.path,
          .to = sp_fs_join_path(mem, spot_keep_path(mem, home), name),
        },
      };
    }
    case SPOT_REQUEST_LS: {
      return (spot_result_t) {
        .kind = SPOT_RESULT_LS,
        .ls = {
          .dirs = dirs,
        },
      };
    }
  }
  sp_unreachable_return(spot_fail(SPOT_ERR_NONE));
}

#endif
