#define SP_IMPLEMENTATION
#include "sp.h"

typedef struct {
  sp_str_t surname;
  sp_str_t instrument;
} person_t;

s32 main(s32 num_args, const c8** args) {
  sp_da(s32) i = SP_NULLPTR;
  sp_dyn_array_push(i, 69);
  sp_dyn_array_push(i, 420);
  sp_dyn_array_push(i, 69);
  sp_dyn_array_push(i, 69);
  sp_dyn_array_push(i, 69);

  sp_da(sp_str_t) s = SP_NULLPTR;
  sp_dyn_array_push(s, sp_str_lit("jerry"));
  sp_dyn_array_push(s, sp_str_lit("jerry"));
  sp_dyn_array_push(s, sp_str_lit("jerry"));
  sp_dyn_array_push(s, sp_str_lit("jerry"));
  sp_dyn_array_push(s, sp_str_lit("jerry"));

  sp_da(person_t) p = SP_NULLPTR;
  sp_dyn_array_push(p, ((person_t){.surname = sp_str_lit("garcia"), .instrument = sp_str_lit("guitar")}));
  sp_dyn_array_push(p, ((person_t){.surname = sp_str_lit("weir"), .instrument = sp_str_lit("rhythm guitar")}));
  sp_dyn_array_push(p, ((person_t){.surname = sp_str_lit("lesh"), .instrument = sp_str_lit("bass")}));
  sp_dyn_array_push(p, ((person_t){.surname = sp_str_lit("kreutzmann"), .instrument = sp_str_lit("drums")}));

  SP_EXIT_SUCCESS();
}
