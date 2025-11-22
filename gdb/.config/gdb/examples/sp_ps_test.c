#define SP_IMPLEMENTATION
#include "sp.h"

s32 main(s32 num_args, const c8** args) {
  // Test sp_ps_config_t
  sp_ps_config_t config = SP_ZERO_INITIALIZE();
  config.command = SP_LIT("echo");
  config.args[0] = SP_LIT("hello");
  config.args[1] = SP_LIT("world");
  config.cwd = SP_LIT("/tmp");
  
  // Test sp_ps_t
  sp_ps_t process = sp_ps_create(config);
  
  // Set breakpoints here to inspect
  SP_LOG("Process created with pid: {}", SP_FMT_S32(process.pid));
  
  return 0;
}