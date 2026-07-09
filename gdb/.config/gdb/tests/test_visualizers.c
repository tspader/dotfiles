// Fixture for the GDB visualizer tests (sp_da.py / sp_ht.py / sp_om.py).
// Built and driven by run_tests.py. The debugger breaks on sp_test_break()
// once every container below is populated.
#define SP_IMPLEMENTATION
#include "sp.h"
#include "sp_om.h"

typedef struct { s32 x; s32 y; } point_t;

// Stable breakpoint target: break here instead of on a line number so the
// fixture can be edited without breaking the harness.
SP_NOINLINE void sp_test_break(void) {}

int main(void) {
  sp_mem_t mem = sp_mem_arena_as_allocator(sp_mem_arena_new_ex(sp_mem_os_new(), 65536, 0));

  // dynamic array of ints
  sp_da(s32) nums = SP_NULLPTR;
  sp_da_init(mem, nums);
  for (s32 i = 0; i < 5; i++) sp_da_push(nums, i * 10);

  // dynamic array of strings
  sp_da(sp_str_t) strs = SP_NULLPTR;
  sp_da_init(mem, strs);
  sp_da_push(strs, sp_str_lit("alpha"));
  sp_da_push(strs, sp_str_lit("beta"));
  sp_da_push(strs, sp_str_lit("gamma"));

  // dynamic array of structs
  sp_da(point_t) pts = SP_NULLPTR;
  sp_da_init(mem, pts);
  sp_da_push(pts, ((point_t){1, 2}));
  sp_da_push(pts, ((point_t){3, 4}));

  // hash table s32 -> s32
  sp_ht(s32, s32) ht = SP_NULLPTR;
  sp_ht_init(mem, ht);
  sp_ht_insert(ht, 69, 420);
  sp_ht_insert(ht, 1, 2);
  sp_ht_insert(ht, 7, 8);

  // ordered map: str -> s32 (insertion order: first, second, third)
  sp_str_om(s32) om = SP_NULLPTR;
  sp_str_om_init(om);
  sp_str_om_insert(om, sp_str_lit("first"), 100);
  sp_str_om_insert(om, sp_str_lit("second"), 200);
  sp_str_om_insert(om, sp_str_lit("third"), 300);

  sp_test_break();

  (void)nums; (void)strs; (void)pts; (void)ht; (void)om;
  return 0;
}
