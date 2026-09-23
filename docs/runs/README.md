# Runs

What each Pickle run of this mod showed, in text. **The evidence itself is on disk and ignored by git**:
`.build/pickle-run-<date>-<time>-<what>/` holds the report (`summary.md`, `junit.xml`, the log, the captures and the
films it produced), copied out of the runner's shared folder before the next session's run overwrote it. A capture is
about 3 MB, a run leaves a dozen, and none of it is needed to read what was concluded: that is what these files say.

Rules kept here:

- `exitReason` is read before any number, and the scenarios played are counted against the ones written.
- A run that wrote no report is listed as such; nothing is concluded from it.
- A green `@review` scenario says the trajectory ran, not that the picture was looked at.

| File | Covers |
| --- | --- |
| [2026-09-21.md](2026-09-21.md) | The first day of runs: the suite written, two passes, two languages, the halo found and measured, the film |
