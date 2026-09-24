# Runs

What each Pickle run of this mod showed, in text. **The evidence itself is on disk and ignored by git**:
`.build/pickle-run-<date>-<time>-<what>/` holds the report (`summary.md`, `junit.xml`, the log, the captures and the
films it produced), copied out of the runner's shared folder before the next session's run overwrote it. A capture is
about 3 MB, a run leaves a dozen, and none of it is needed to read what was concluded: that is what these files say.

## Which proofs to keep, and which to drop

The disk is full and the runner's report folder is shared by every mod (root `AGENTS.md`, "Test evidence"). For this mod:

- **Keep, per run:** `summary.md` and `junit.xml` (a few KB: what played, what failed) and one line in the table of the
  day's file. Nothing else is needed to read the conclusion.
- **Keep, only if nothing else proves it:** one **minified** picture (JPEG, 1280 px wide, about 60 KB, never the 3 MB PNG)
  for a check that only a picture answers and that a later run did not repeat. Today: the ring, halo and waves with
  Phytokin active (the spiral icon). The `@review` captures of a run of the current build replace it.
- **Drop as soon as a newer run of the same build replaces them:** the PNG captures, `messages.ndjson` (several MB),
  `Player.log`, the films and contact sheets (`film.webm`, `sheet-*.png`; the film tool's own proof lives in PickleTools),
  and `summary.json` (a copy of `summary.md`).
- **A run of a superseded build proves nothing about the current one.** After a change to `Source/` or to the steps, the
  older folders go once a run of the new build exists; until then they are the only record of what the old build did.
- **Never in git:** `.build/`, `evidence/`, `*.webm`, `*.dds`. The repository holds these text files and nothing else.

Rules kept here:

- `exitReason` is read before any number, and the scenarios played are counted against the ones written.
- A run that wrote no report is listed as such; nothing is concluded from it.
- A green `@review` scenario says the trajectory ran, not that the picture was looked at.

| File | Covers |
| --- | --- |
| [2026-09-21.md](2026-09-21.md) | The first day of runs: the suite written, two passes, two languages, the halo found and measured, the film |
| [2026-09-23.md](2026-09-23.md) | The first run of the 25 scenarios, the halo found faulty twice over and fixed, and a first keeper that changed nothing |
