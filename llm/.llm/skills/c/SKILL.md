# Build
- `spn build` if there is a `spn.toml` in the root directory

## Rules
- Build static paths at program startup and keep them in a global struct:
```c
typedef struct {
  sp_str_t executable;
  sp_str_t storage;
  // ...etc
} myprefix_paths_t;
```
- Always use the `sp.h` skill when (either with your `Skill` tool or with `./doc/llm/sp/SKILL.md`)
