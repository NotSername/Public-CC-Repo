# 04 - Using AI to Write Lua for ComputerCraft

![image](https://github.com/NotSername/Public-CC-Repo/blob/main/images/11.jpg?raw=false)

Yes, you can absolutely use AI tools (Claude, ChatGPT, Copilot, etc.) to write
CC: Tweaked Lua. This module isn't a script to run. It's a guide to doing it.

## Why it mostly works

CC: Tweaked has been around for a long time and has a lot of public code,
documentation, and forum posts so most AI models have decent exposure to
its API patterns: `turtle.*`, `peripheral.*`, `textutils.*`, the event loop
via `os.pullEvent`, and so on.

## Where it goes wrong

- **API hallucination.** CC: Tweaked has its own dialect of Lua APIs that
  don't exist in vanilla Lua or other game mod APIs. Models sometimes blend
  them e.g. inventing a `turtle.craftAll()` that doesn't exist, or mixing
  up `textutils.serialize` (CC's own format) with `textutils.serializeJSON`
  (actual JSON) these are NOT interchangeable, and it's a frequent mistake.
- **Version drift.** CC: Tweaked's API has evolved over the years (and is
  different from the original, now-discontinued "ComputerCraft" mod in some
  places). An AI might give you a method from an older or different version.
- **Peripheral mod coverage is uneven.** Vanilla CC: Tweaked turtle/computer
  APIs are well covered. Third-party peripheral mods (Advanced Peripherals,
  Plethora, Computronics, etc.) are less consistently represented, so
  double-check method names against that mod's specific docs.

## How to use AI well for this

1. **Always cross-check against [tweaked.cc](https://tweaked.cc/)** The
   official docs. If a method isn't listed there, it might be from a
   peripheral mod (check that mod's docs) or it might be made up.
2. **Paste the actual error, not a description of it.** CC error messages
   are genuinely informative:
   ```
   bios.lua:14: attempt to call nil
   ```
   tells an AI (or a person) a lot more than "it's not working." Tracebacks
   include the file and line number, always include both.
3. **Ask for small pieces, not whole systems.** "Write me a function that
   pulls a specific item from a chest into a given turtle slot" gets a more
   correct, checkable result than "write me a full storage system."
4. **Use AI to explain unfamiliar APIs**, not just generate code. Asking
   "what does `turtle.compareTo` do and how is it different from
   `turtle.compare`?" builds understanding you'll need later anyway.
5. **Test incrementally.** Run small snippets in isolation rather than
   pasting a 200-line program and hoping. CC's `lua` REPL (just type `lua`
   in the computer's terminal) is great for testing one function at a time.

## Try it yourself next

- Talk with your new born clanker and experience his brain dead wonders.
