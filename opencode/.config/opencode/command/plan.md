---
description: make a concise plan
---

$ARGUMENTS

make a plan; use the following format

```markdown
# problem
minimal problem description
# solution
minimal overview of solution; be comprehensive, include everything, but keep the granularity appropriate
# plan
## phase 1
### tasks
- task
- task
### references
- foo.c:69
- sp_foo_t
### unit tests
- minimal description of test
- minimal description of test
### manual tests
- minimal description of test
- minimal description of test
## phase 2
...
```
- you may omit `unit tests` or `manual tests` or `references` as is appropriate
  - do not make up useless tests for the sake of having tested.
  - do not make up references if they are not strictly needed.
  - be critical of any tests added. tests must be maintained; they must provide value.
  - ensure that the test surface is exactly the functionality needed to be confident. nothing more, nothing less
- each phase is meant to be implemented clean room, with a fresh LLM. keep this in mind when writing.
- be minimal. be concise. do not write the code in the plan; pseudocode at most.
