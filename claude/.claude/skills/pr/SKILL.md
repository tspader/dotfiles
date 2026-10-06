---
description: Rules that must be read before interacting with a GitHub remote
---

First rule: Never commit or do anything with the gh cli or API or in any way interact with a remote unless given express permission.

# Monitoring
- Use the Monitor tool and the GitHub CLI.
- If monitoring, you have permission to commit and push to re-run if the failure is small. Commit rules:
- Iterate until it's either green, or there's a genuine failure which requires some thought or design.

# Commits
- Never add yourself as a co-author in any way; it should appear like a regular commit from me
- Zero prose, ever. Write a terse commit message in my style. This one line commit message should be the only prose that leaves the machine.

