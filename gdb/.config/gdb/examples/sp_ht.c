#define SP_IMPLEMENTATION
#include "sp.h"

typedef struct {
  sp_str_t surname;
  sp_str_t instrument;
} person_t;

s32 main(s32 num_args, const c8** args) {
  // Test different hash table types
  sp_ht(s32, s32) int_ht = SP_NULLPTR;
  sp_ht(sp_str_t, s32) str_ht = SP_NULLPTR;
  sp_ht(sp_str_t, person_t) person_ht = SP_NULLPTR;
  
  sp_ht_init(int_ht);
  sp_ht_init(str_ht);
  sp_ht_init(person_ht);
  sp_ht_set_fns(str_ht, sp_ht_on_hash_str_key, sp_ht_on_compare_str_key);
  sp_ht_set_fns(person_ht, sp_ht_on_hash_str_key, sp_ht_on_compare_str_key);
  
  sp_ht_insert(int_ht, 42, 100);
  sp_ht_insert(int_ht, 84, 200);
  
  sp_ht_insert(str_ht, SP_LIT("hello"), 1);
  sp_ht_insert(str_ht, SP_LIT("world"), 2);
  
  person_t jerry = {SP_LIT("garcia"), SP_LIT("guitar")};
  person_t phil = {SP_LIT("lesh"), SP_LIT("bass")};
  sp_ht_insert(person_ht, SP_LIT("jerry"), jerry);
  sp_ht_insert(person_ht, SP_LIT("phil"), phil);
  
  // Set breakpoints here to inspect
  SP_LOG("int_ht size: {}", SP_FMT_U32(sp_ht_size(int_ht)));
  SP_LOG("str_ht size: {}", SP_FMT_U32(sp_ht_size(str_ht)));
  SP_LOG("person_ht size: {}", SP_FMT_U32(sp_ht_size(person_ht)));
  
  sp_ht_free(int_ht);
  sp_ht_free(str_ht);
  sp_ht_free(person_ht);
  
  SP_EXIT_SUCCESS();
}