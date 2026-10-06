Never copy text literally; always link ranges from the session transcript
when applicable:

```
> recall issues note
Add a note

usage:
  recall issues note $key [$body] [options]

arguments
  key  string issue key such as RECALL-3 (required)
  body string markdown; anchor lines quote messages

options
      --quote     string  message to quote: a uuid or a recall session … --around … line
      --from      string  exact text the excerpt starts with
      --to        string  exact text the excerpt ends with
      --db        string  database path (default from config)
      --skip-sync boolean skip index refresh
  -h, --help      boolean Show help
```

Generally, you should not link LLM prose. Default to LLM prose has a low
signal to noise ratio, and by definition if an LLM wrote it, an LLM can
produce it again. When I want you to link LLM prose to an issue, I'll ask.

If any of the work in the issue was shaped by something the user said, link
it. This could be design constraints, use cases, implementation notes, style
preferences, or corrections (just for example, nonexhaustive). If the issue is
correcting another LLM's mistake, or if something you proposed wasn't right,
you'll want to link the context since future LLMs will likely default to the
same output as you did.

Never add links without providing framing. Usually, one sentence is plenty.

Always make sure that blocker and parent links are correct, if applicable.

Issue descriptions should be low prose. Be selective about the prose you choose
to include, and be concise in how you express what is included.

Unless requested should avoid specifying the precise code changes needed.
Provide references to relevant files and symbols, and describe code changes
rather than prescribe them. When an issue or work item inside an issue could
be implemented in different ways, include a very concise description of why
the given way was chosen.

Format issue bodies and comments as Markdown (e.g. use headings, bulleted
lists, etc. when appropriate)
