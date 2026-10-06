#define SP_IMPLEMENTATION
#include "sp.h"
#include "spot.h"

#include "utest.h"

UTEST_MAIN()

#define ur (*utest_result)

#define SPOT_TEST_MAX_DIRS 16

typedef struct {
  spot_err_kind_t err;
  const c8* path;
  const c8* from;
  const c8* to;
  const c8* dirs [SPOT_TEST_MAX_DIRS];
} spot_expect_t;

typedef struct {
  spot_state_t state;
  spot_request_t request;
  spot_expect_t expect;
} spot_test_t;

UTEST_EMPTY_FIXTURE(spot)

void run_spot_test(s32* utest_result, spot_test_t t) {
  sp_mem_heap_t* heap = sp_mem_heap_new();
  sp_mem_t mem = sp_mem_heap_as_allocator(heap);

  if (!t.state.home) t.state.home = "/spot";

  spot_result_t result = spot_run(mem, &t.state, t.request);

  if (t.expect.err) {
    ASSERT_EQ(result.kind, SPOT_RESULT_ERR);
    ASSERT_EQ(result.err.kind, t.expect.err);
    return;
  }

  switch (t.request.kind) {
    case SPOT_REQUEST_NEW: {
      ASSERT_EQ(result.kind, SPOT_RESULT_NEW);
      ASSERT_STREQ(t.expect.path, sp_str_to_cstr(mem, result.new.path));
      break;
    }
    case SPOT_REQUEST_GO: {
      ASSERT_EQ(result.kind, SPOT_RESULT_GO);
      ASSERT_STREQ(t.expect.path, sp_str_to_cstr(mem, result.go.path));
      break;
    }
    case SPOT_REQUEST_KEEP: {
      ASSERT_EQ(result.kind, SPOT_RESULT_KEEP);
      ASSERT_STREQ(t.expect.from, sp_str_to_cstr(mem, result.keep.from));
      ASSERT_STREQ(t.expect.to, sp_str_to_cstr(mem, result.keep.to));
      break;
    }
    case SPOT_REQUEST_LS: {
      ASSERT_EQ(result.kind, SPOT_RESULT_LS);
      u32 expected = 0;
      sp_carr_for(t.expect.dirs, it) {
        if (!t.expect.dirs[it]) break;
        expected++;
      }
      ASSERT_EQ(sp_da_size(result.ls.dirs), expected);
      sp_da_for(result.ls.dirs, it) {
        ASSERT_STREQ(t.expect.dirs[it], sp_str_to_cstr(mem, result.ls.dirs[it].name));
      }
      break;
    }
  }
}

UTEST_F(spot, new_bare) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .now = { 2026, 7, 11, 14, 30, 5 },
    },
    .request = {
      .kind = SPOT_REQUEST_NEW,
    },
    .expect = {
      .path = "/spot/tmp/2026-07-11T14-30-05",
    },
  });
}

UTEST_F(spot, new_pads_single_digits) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .now = { 2026, 1, 2, 3, 4, 5 },
    },
    .request = {
      .kind = SPOT_REQUEST_NEW,
    },
    .expect = {
      .path = "/spot/tmp/2026-01-02T03-04-05",
    },
  });
}

UTEST_F(spot, new_named) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .now = { 2026, 7, 11, 14, 30, 5 },
    },
    .request = {
      .kind = SPOT_REQUEST_NEW,
      .new = { .name = "widget" },
    },
    .expect = {
      .path = "/spot/tmp/2026-07-11T14-30-05-widget",
    },
  });
}

UTEST_F(spot, new_collision) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .now = { 2026, 7, 11, 14, 30, 5 },
      .dirs = { "2026-07-11T14-30-05" },
    },
    .request = {
      .kind = SPOT_REQUEST_NEW,
    },
    .expect = {
      .err = SPOT_ERR_EXISTS,
    },
  });
}

UTEST_F(spot, new_named_collision) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .now = { 2026, 7, 11, 14, 30, 5 },
      .dirs = { "2026-07-11T14-30-05-widget" },
    },
    .request = {
      .kind = SPOT_REQUEST_NEW,
      .new = { .name = "widget" },
    },
    .expect = {
      .err = SPOT_ERR_EXISTS,
    },
  });
}

UTEST_F(spot, go_newest) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .dirs = { "2026-07-10T09-00-00", "2026-07-11T14-30-05" },
    },
    .request = {
      .kind = SPOT_REQUEST_GO,
    },
    .expect = {
      .path = "/spot/tmp/2026-07-11T14-30-05",
    },
  });
}

UTEST_F(spot, go_back) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .dirs = { "2026-07-10T09-00-00", "2026-07-11T14-30-05" },
    },
    .request = {
      .kind = SPOT_REQUEST_GO,
      .go = { .index = 1 },
    },
    .expect = {
      .path = "/spot/tmp/2026-07-10T09-00-00",
    },
  });
}

UTEST_F(spot, go_ignores_unstamped) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .dirs = { "a8XBrL4vn", "zzz", "2026-07-10T09-00-00", "foo" },
    },
    .request = {
      .kind = SPOT_REQUEST_GO,
    },
    .expect = {
      .path = "/spot/tmp/2026-07-10T09-00-00",
    },
  });
}

UTEST_F(spot, go_named_dirs_sort_by_stamp) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .dirs = { "2026-07-09T08-00-00-spotify", "2026-07-10T09-00-00" },
    },
    .request = {
      .kind = SPOT_REQUEST_GO,
      .go = { .index = 1 },
    },
    .expect = {
      .path = "/spot/tmp/2026-07-09T08-00-00-spotify",
    },
  });
}

UTEST_F(spot, go_empty) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .dirs = { "not-a-stamp" },
    },
    .request = {
      .kind = SPOT_REQUEST_GO,
    },
    .expect = {
      .err = SPOT_ERR_EMPTY,
    },
  });
}

UTEST_F(spot, go_out_of_range) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .dirs = { "2026-07-10T09-00-00" },
    },
    .request = {
      .kind = SPOT_REQUEST_GO,
      .go = { .index = 1 },
    },
    .expect = {
      .err = SPOT_ERR_OUT_OF_RANGE,
    },
  });
}

UTEST_F(spot, keep_cwd) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .cwd = "/spot/tmp/2026-07-11T14-30-05",
      .dirs = { "2026-07-11T14-30-05" },
    },
    .request = {
      .kind = SPOT_REQUEST_KEEP,
      .keep = { .name = "widget" },
    },
    .expect = {
      .from = "/spot/tmp/2026-07-11T14-30-05",
      .to = "/spot/keep/widget",
    },
  });
}

UTEST_F(spot, keep_cwd_nested) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .cwd = "/spot/tmp/2026-07-11T14-30-05/src/deep",
      .dirs = { "2026-07-11T14-30-05" },
    },
    .request = {
      .kind = SPOT_REQUEST_KEEP,
      .keep = { .name = "widget" },
    },
    .expect = {
      .from = "/spot/tmp/2026-07-11T14-30-05",
      .to = "/spot/keep/widget",
    },
  });
}

UTEST_F(spot, keep_cwd_outside_home) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .cwd = "/home/user/project",
      .dirs = { "2026-07-11T14-30-05" },
    },
    .request = {
      .kind = SPOT_REQUEST_KEEP,
      .keep = { .name = "widget" },
    },
    .expect = {
      .err = SPOT_ERR_NOT_IN_HOME,
    },
  });
}

UTEST_F(spot, keep_cwd_sibling_prefix) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .cwd = "/spot/tmp/2026-07-11T14-30-05-widget/src",
      .dirs = { "2026-07-11T14-30-05" },
    },
    .request = {
      .kind = SPOT_REQUEST_KEEP,
      .keep = { .name = "widget" },
    },
    .expect = {
      .err = SPOT_ERR_NOT_IN_HOME,
    },
  });
}

UTEST_F(spot, keep_by_index) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .dirs = { "2026-07-10T09-00-00", "2026-07-11T14-30-05" },
    },
    .request = {
      .kind = SPOT_REQUEST_KEEP,
      .keep = { .name = "widget", .target = SPOT_KEEP_INDEX, .index = 1 },
    },
    .expect = {
      .from = "/spot/tmp/2026-07-10T09-00-00",
      .to = "/spot/keep/widget",
    },
  });
}

UTEST_F(spot, keep_replaces_name) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .dirs = { "2026-07-09T08-00-00-spotify" },
    },
    .request = {
      .kind = SPOT_REQUEST_KEEP,
      .keep = { .name = "player", .target = SPOT_KEEP_INDEX },
    },
    .expect = {
      .from = "/spot/tmp/2026-07-09T08-00-00-spotify",
      .to = "/spot/keep/player",
    },
  });
}

UTEST_F(spot, keep_collision) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .dirs = { "2026-07-11T14-30-05" },
      .kept = { "player", "widget" },
    },
    .request = {
      .kind = SPOT_REQUEST_KEEP,
      .keep = { .name = "widget", .target = SPOT_KEEP_INDEX },
    },
    .expect = {
      .err = SPOT_ERR_EXISTS,
    },
  });
}

UTEST_F(spot, keep_empty) {
  run_spot_test(&ur, (spot_test_t) {
    .request = {
      .kind = SPOT_REQUEST_KEEP,
      .keep = { .name = "widget", .target = SPOT_KEEP_INDEX },
    },
    .expect = {
      .err = SPOT_ERR_EMPTY,
    },
  });
}

UTEST_F(spot, keep_out_of_range) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .dirs = { "2026-07-10T09-00-00" },
    },
    .request = {
      .kind = SPOT_REQUEST_KEEP,
      .keep = { .name = "widget", .target = SPOT_KEEP_INDEX, .index = 3 },
    },
    .expect = {
      .err = SPOT_ERR_OUT_OF_RANGE,
    },
  });
}

UTEST_F(spot, ls_sorted_newest_first) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .dirs = { "2026-07-09T08-00-00-spotify", "junk", "2026-07-11T14-30-05", "2026-07-10T09-00-00" },
    },
    .request = {
      .kind = SPOT_REQUEST_LS,
    },
    .expect = {
      .dirs = { "2026-07-11T14-30-05", "2026-07-10T09-00-00", "2026-07-09T08-00-00-spotify" },
    },
  });
}

UTEST_F(spot, ls_empty) {
  run_spot_test(&ur, (spot_test_t) {
    .state = {
      .dirs = { "junk", "a8XBrL4vn" },
    },
    .request = {
      .kind = SPOT_REQUEST_LS,
    },
    .expect = sp_zero,
  });
}
