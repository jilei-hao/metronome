---
name: explain
description: Deep-dive explanation in plain language — short answer first, then how it works step by step, a worked example, and the traps. Grounded in the actual code or docs, not memory.
argument-hint: "[topic, file, or question]"
disable-model-invocation: true
---

# Explain

Deep dive into: $ARGUMENTS

If that's empty, explain what the conversation was just about. If that isn't
clear either, ask what to explain and stop.

The reader is an engineer who wants to understand this, not just use it.
Deep means more understanding, not more words: every paragraph should teach
something the ones before it didn't. Aim for something that can be read in
one sitting. If the topic is bigger than that, explain the core and list the
rest under "Go deeper".

## 1. Pin down the question

Work out what the reader is actually unsure about and what they already know;
the conversation usually tells you. If the topic could mean two quite
different things (hooks in React vs. hooks in Claude Code), ask one short
question first. Otherwise pick the likely reading and say which one in your
first line.

## 2. Read the source before explaining it

Read the real code, config, or docs involved first. An explanation written
from memory can sound right and still be wrong, and a deep dive is exactly
where the reader will trust the details.

- Cite what you read as `path:line`, so the reader can check it.
- For tools, libraries, and APIs, prefer the current official docs over what
  you remember. Versions drift.
- Keep what you checked apart from what you inferred. Say "I think" or
  "I didn't check" where that's true.

## 3. Use this shape

Go in this order. Skip any part that doesn't fit the topic; a missing section
is better than a padded one.

1. **Short answer** — 1–3 sentences. The reader could stop here and still
   have the right idea.
2. **Why it exists** — the problem it solves, and what goes wrong without it.
3. **How it works** — the mechanism as numbered steps, in the order things
   actually happen. Use the real names from the reader's code, not
   placeholders.
4. **Diagram** — only when the order of steps or the structure is the point.
   A small text diagram (boxes and arrows, about a dozen nodes at most) in a
   code block. Skip it if the steps already make the flow obvious.
5. **Worked example** — trace one concrete input through those steps, showing
   the actual values at each stage.
6. **Why it's built this way** — the trade-off behind the design, the main
   alternative, and why it lost. Name the relevant best practice or pattern,
   and say what it means.
7. **Traps** — where it breaks, what people commonly get wrong, and how you'd
   notice.
8. **Go deeper** — 2–3 specific next questions, or files and docs to read
   (`path:line` or links). Not "let me know if you have questions".

## 4. Keep the language plain

- Open each section with its point, then back it up.
- Short sentences, one idea each. Everyday words over formal ones: "use", not
  "leverage"; "because", not "due to the fact that".
- Keep the technical terms, since the reader needs them for docs and for
  talking to colleagues, but say what each one means the first time.
- Concrete before abstract: show the real code or example, then generalize.
- Use an analogy only if it fits closely, and say where it stops fitting.
- Name who does what: "Claude Code runs the hook", not "the hook is run".

One before/after to show the tone. It's an illustration, not a template:

> **Before:** The hook leverages exit-code semantics to enforce deterministic
> gating of tool invocations.
>
> **After:** A hook is a script that Claude Code runs before a tool call. If
> the script exits with code 2, the call is blocked, whatever Claude intended.

## 5. Afterwards

This skill's text stays in the conversation after it runs. Treat it as
covering this one explanation: answer later questions at normal length unless
the reader asks to go deeper again.
