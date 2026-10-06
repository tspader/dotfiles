/*
  spot: timestamped scratch directories

  - spot new [name]   create a dir in tmp/ named by an ISO timestamp (plus optional name), print its path
  - spot go [n]       print the path of the nth most recent tmp dir (0 = newest)
  - spot keep <name>  promote a tmp dir by moving it to keep/<name>
  - spot ls           list tmp dirs, newest first, with indices
  - spot path <cmd>   plumbing: same commands, but stdout only ever carries a path;
                      help is routed to stderr so wrappers can trust what they capture

  A shell wrapper cd's to whatever spot path prints on stdout.
*/
#define SP_IMPLEMENTATION
#include "sp.h"
#include "sp/sp_cli.h"
#include "spot.h"

typedef struct {
  sp_mem_t mem;
  const c8* home;
  struct {
    const c8* name;
  } new;
  struct {
    u32 index;
  } go;
  struct {
    const c8* name;
    s32 index;
  } keep;
} spot_app_t;

SP_PRIVATE sp_str_t spot_app_home(spot_app_t* app) {
  if (app->home) return sp_cstr_as_str(app->home);
  return sp_fs_join_path(app->mem, sp_fs_get_storage_path(app->mem), sp_str_lit("spot"));
}

SP_PRIVATE void spot_app_collect(spot_app_t* app, sp_str_t base, const c8** names) {
  u32 count = 0;
  sp_da(sp_fs_entry_t) entries = sp_fs_collect(app->mem, base);
  sp_da_for(entries, it) {
    if (entries[it].kind != SP_FS_KIND_DIR) continue;
    if (count >= SPOT_MAX_DIRS - 1) break;
    names[count++] = sp_str_to_cstr(app->mem, entries[it].name);
  }
}

SP_PRIVATE void spot_app_state(spot_app_t* app, spot_state_t* state) {
  sp_str_t home = spot_app_home(app);
  state->home = sp_str_to_cstr(app->mem, home);
  state->cwd = sp_str_to_cstr(app->mem, sp_fs_get_cwd(app->mem));
  state->now = sp_tm_get_date_time();
  spot_app_collect(app, spot_tmp_path(app->mem, home), state->dirs);
  spot_app_collect(app, spot_keep_path(app->mem, home), state->kept);
}

SP_PRIVATE sp_cli_result_t spot_app_fail(sp_cli_t* cli, spot_err_kind_t err) {
  switch (err) {
    case SPOT_ERR_NONE:         return SP_CLI_OK;
    case SPOT_ERR_EMPTY:        return sp_cli_set_error_c(cli, "no spot directories");
    case SPOT_ERR_OUT_OF_RANGE: return sp_cli_set_error_c(cli, "index out of range");
    case SPOT_ERR_NOT_IN_HOME:  return sp_cli_set_error_c(cli, "not inside a spot directory");
    case SPOT_ERR_EXISTS:       return sp_cli_set_error_c(cli, "directory already exists");
  }
  sp_unreachable_return(SP_CLI_ERR);
}

SP_PRIVATE spot_result_t spot_app_run(sp_cli_t* cli, spot_request_t request) {
  spot_app_t* app = sp_cast(spot_app_t*, cli->user_data);
  spot_state_t* state = sp_alloc_type(app->mem, spot_state_t);
  spot_app_state(app, state);
  return spot_run(app->mem, state, request);
}

//////////////
// HANDLERS //
//////////////
sp_cli_result_t spot_cmd_new(sp_cli_t* cli) {
  spot_app_t* app = sp_cast(spot_app_t*, cli->user_data);
  spot_result_t result = spot_app_run(cli, (spot_request_t) {
    .kind = SPOT_REQUEST_NEW,
    .new = {
      .name = app->new.name,
    },
  });
  if (result.kind == SPOT_RESULT_ERR) return spot_app_fail(cli, result.err.kind);

  if (sp_fs_create_dir(result.new.path)) {
    return sp_cli_set_error_c(cli, "failed to create directory");
  }
  sp_log("{}", sp_fmt_str(result.new.path));
  return SP_CLI_OK;
}

sp_cli_result_t spot_cmd_go(sp_cli_t* cli) {
  spot_app_t* app = sp_cast(spot_app_t*, cli->user_data);
  spot_result_t result = spot_app_run(cli, (spot_request_t) {
    .kind = SPOT_REQUEST_GO,
    .go = {
      .index = app->go.index,
    },
  });
  if (result.kind == SPOT_RESULT_ERR) return spot_app_fail(cli, result.err.kind);

  sp_log("{}", sp_fmt_str(result.go.path));
  return SP_CLI_OK;
}

sp_cli_result_t spot_cmd_keep(sp_cli_t* cli) {
  spot_app_t* app = sp_cast(spot_app_t*, cli->user_data);
  spot_result_t result = spot_app_run(cli, (spot_request_t) {
    .kind = SPOT_REQUEST_KEEP,
    .keep = {
      .name = app->keep.name,
      .target = app->keep.index >= 0 ? SPOT_KEEP_INDEX : SPOT_KEEP_CWD,
      .index = app->keep.index >= 0 ? sp_cast(u32, app->keep.index) : 0,
    },
  });
  if (result.kind == SPOT_RESULT_ERR) return spot_app_fail(cli, result.err.kind);

  if (sp_fs_create_dir(sp_fs_parent_path(result.keep.to))) {
    return sp_cli_set_error_c(cli, "failed to create keep directory");
  }
  if (sp_sys_rename_s(sp_sys_get_root(0), result.keep.from, sp_sys_get_root(0), result.keep.to)) {
    return sp_cli_set_error_c(cli, "failed to rename directory");
  }
  sp_log("{}", sp_fmt_str(result.keep.to));
  return SP_CLI_OK;
}

sp_cli_result_t spot_cmd_ls(sp_cli_t* cli) {
  spot_result_t result = spot_app_run(cli, (spot_request_t) {
    .kind = SPOT_REQUEST_LS,
  });
  if (result.kind == SPOT_RESULT_ERR) return spot_app_fail(cli, result.err.kind);

  sp_da_for(result.ls.dirs, it) {
    sp_log("{.yellow} {.cyan}", sp_fmt_uint(it), sp_fmt_str(result.ls.dirs[it].name));
  }
  return SP_CLI_OK;
}

s32 run(s32 num_args, const c8** args) {
  sp_mem_heap_t* heap = sp_mem_heap_new();
  spot_app_t app = {
    .mem = sp_mem_heap_as_allocator(heap),
    .keep = {
      .index = -1,
    },
  };

  struct {
    sp_cli_cmd_t new;
    sp_cli_cmd_t go;
    sp_cli_cmd_t keep;
    sp_cli_cmd_t ls;
    sp_cli_cmd_t path;
  } c = {
    .path = {
      .name = "path",
      .summary = "Run a command, printing only its path (for shell wrappers)",
      .commands = { &c.new, &c.go, &c.keep },
    },
    .new = {
      .name = "new",
      .summary = "Create a scratch directory and print its path",
      .args = {
        {
          .name = "name",
          .arity = SP_CLI_ARG_OPTIONAL,
          .summary = "Suffix appended to the timestamp",
          .ptr = &app.new.name,
        },
      },
      .handler = spot_cmd_new,
    },
    .go = {
      .name = "go",
      .summary = "Print the path of the nth most recent directory",
      .args = {
        {
          .name = "n",
          .arity = SP_CLI_ARG_OPTIONAL,
          .kind = SP_CLI_OPT_U32,
          .summary = "How far back to go (0 = newest)",
          .ptr = &app.go.index,
        },
      },
      .handler = spot_cmd_go,
    },
    .keep = {
      .name = "keep",
      .summary = "Promote a directory by giving it a name",
      .opts = {
        {
          .brief = "n",
          .name = "index",
          .kind = SP_CLI_OPT_S32,
          .summary = "Promote the nth most recent instead of the current directory",
          .placeholder = "N",
          .ptr = &app.keep.index,
        },
      },
      .args = {
        {
          .name = "name",
          .summary = "The name to promote it with",
          .ptr = &app.keep.name,
        },
      },
      .handler = spot_cmd_keep,
    },
    .ls = {
      .name = "ls",
      .summary = "List scratch directories, newest first",
      .handler = spot_cmd_ls,
    },
  };

  sp_cli_cmd_t root = {
    .name = "spot",
    .summary = "Timestamped scratch directories",
    .env = {
      {
        .name = "SPOT_HOME",
        .summary = "Where spot stores directories (default ~/.local/share/spot)",
        .ptr = &app.home,
      },
    },
    .commands = { &c.new, &c.go, &c.keep, &c.ls, &c.path },
  };

  sp_cli_desc_t cli = {
    .root = &root,
    .args = args,
    .num_args = num_args,
    .user_data = &app,
  };

  sp_cli_t parsed = sp_cli_parse(cli);
  if (!parsed.status) {
    parsed.status = sp_cli_dispatch(&parsed);
  }

  bool plumbing = false;
  sp_for(it, parsed.depth) {
    if (parsed.path[it] == &c.path) plumbing = true;
  }

  sp_io_stream_writer_t out = sp_io_get_std_out();
  sp_io_stream_writer_t err = sp_io_get_std_err();

  switch (parsed.status) {
    case SP_CLI_OK:
    case SP_CLI_CONTINUE: {
      return 0;
    }
    case SP_CLI_HELP: {
      sp_cli_write_help(plumbing ? &err.base : &out.base, &parsed);
      return 0;
    }
    case SP_CLI_ERR: {
      sp_cli_view_t view = sp_cli_view(&parsed);
      sp_cli_write_diagnostic(&err.base, parsed.err, "error", parsed.theme.error);
      sp_cli_write_synopsis(&err.base, &parsed, &view);
      sp_fmt_io(&err.base, "\n");
      sp_fmt_io(&err.base, "Use {.cyan} for full usage", sp_fmt_cstr("--help"));
      sp_fmt_io(&err.base, "\n");
      return 1;
    }
  }
  sp_unreachable_return(1);
}
SP_MAIN(run)
