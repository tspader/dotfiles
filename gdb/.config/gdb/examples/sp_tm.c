#define SP_IMPLEMENTATION
#include "sp.h"

s32 main(s32 num_args, const c8** args) {
  sp_tm_epoch_t now = sp_tm_now_epoch();
  sp_tm_epoch_t zero = SP_ZERO_INITIALIZE();

  SP_EXIT_SUCCESS();
}
