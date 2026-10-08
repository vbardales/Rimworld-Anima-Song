# Runs

What each Pickle run of this mod showed, in text. **The evidence itself is on disk and ignored by git**:
`Tests/Pickle/Evidence/pickle-run-<date>-<what>/` holds the report, copied out of the runner's shared folder before the
next session's run overwrote it, then trimmed to what still proves something (last section). A capture is
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
- **Never in git:** `.build/`, `Tests/Pickle/Evidence/`, `*.webm`, `*.dds` (none was ever tracked; checked 2026-10-01). The repository holds these text files and nothing else.

Rules kept here:

- `exitReason` is read before any number, and the scenarios played are counted against the ones written.
- A run that wrote no report is listed as such; nothing is concluded from it.
- A green `@review` scenario says the trajectory ran, not that the picture was looked at.

| File | Covers |
| --- | --- |
| — | 2026-09-13 through 2026-09-29: dev, tests, and publishes 1.0.0–1.0.2, all in `git log` and the GitHub releases; a description-only wording pass went straight onto the Steam page by hand (`CHANGELOG.md`), no version for it; item public 2026-09-29. Next dated file starts the next work. |

## Evidence kept on disk, 2026-10-01 (147 MB trimmed to 2 MB; per folder: `summary.md`, `junit.xml`, pictures as 1280 px JPEG)

| Folder | Why it stays |
| --- | --- |
| `pickle-run-2026-09-29-full-en`, `-full-fr`, `-full-phytokin` | The only whole-suite passes, on the published code (last change to `Mod/`/`Source/` code: `5967dd2`); 26, 26 and 27 of 34 passed, 0 failed, 7-8 skipped by `@requires` |
| `pickle-run-2026-09-27-sound-royalty`, `-sound-phytokin` | Sole proof of `04-the-song-heard.feature` (`@requires:nelim.pickletools.soundcapture`); predate `5967dd2` (a log-once guard, no behaviour change). Each report holds one red scenario, the one for the *other* modlist (STATUS.md, `remaining`) |
| `pickle-run-2026-09-26-workshop` | Sole proof of `05-workshop-captures.feature` (`@requires:nelim.pickletools.screenshotstudio`), 3 of 3 passed; predates `5967dd2` |
| `pickle-run-2026-09-28-removal` | Sole proof of the removal chain (write pass, then the companion without the mod), 1 of 1 each; predates `5967dd2` |

Dropped, each replaced by a later run of the same scenarios: `2026-09-25-song-played-2` and `-3` (red, early sound tries),
`2026-09-26-interface-fr` and `-save-content` (now in `full-fr` and `full-en`), `2026-09-27-removal` (red first tries,
replaced by 09-28), `2026-09-28-waves` (now in the full runs).

2026-10-06: `pickle-run-2026-10-07-ring` (ticket 1993, 3 of 3 passed, JPEG 1280 px) replaces the two earlier sanctuary runs, deleted (the first two red on undefined steps, then green on `emerald-clearing` with poor pictures). It is the only proof of the gallery scene agreed with Pickle Tools; the pictures are not yet approved.

2026-10-08: `pickle-run-2026-10-08-backlot2` (ticket 135f, 3 of 3 passed, JPEG 1280 px) replaces `-backlot` (92b4, red on an undefined gene step, deleted). Of its three pictures only the menu is a gallery candidate (`PUBLICATION.md`, last section).

2026-10-08: `pickle-run-2026-10-08-ring2` (ticket 08d7, 1 of 1 passed, scenario 1 only, listeners placed on three sides) replaces `2026-10-07-ring` (deleted). The picture shows the faces and eyes, but the three listeners all stand east of the tree and the lilies are small: not a candidate yet (`PUBLICATION.md`).

2026-10-08: `pickle-run-2026-10-08-cool` (ticket 19c9, 3 of 3 passed, map held at 20 degrees, JPEG 1280 px) replaces `-backlot2` and `-ring2` (deleted). No sweat any more ("Outdoors 20C" in the menu picture), but the listeners still do not form a ring: image 1 is not a candidate (`PUBLICATION.md`).
