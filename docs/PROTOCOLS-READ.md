# Protocols read, and in which version

Written 2026-09-25 by the Anima Song session, on the owner's request, so that a document that has not moved is not read
again and one that has can be spotted. Version = the last commit that touched the file in its own repository
(`git log -1 --format='%h %ad' -- <file>`), and whether it had uncommitted changes when read (`git status --short`).
Read in full unless said otherwise. Re-read a file when its last commit is no longer the one below.

## Read, and useful

| File | Version read | What this mod's work took from it |
| --- | --- | --- |
| `AGENTS.md` | `90d51374` 2026-09-25, clean | Evidence rules (keep the latest report per scenario for the current revision, `docs/runs/` as one text line per run, never as folders); publish by CI, dry-run of the exact SHA, only the owner approves, tag and release by the CI |
| `AUDIT.md` | `90d51374` 2026-09-25, clean | The whole chain. Rules that changed what I did: **"test manuel" = what is left to tick by hand must be automated and green, or listed non applicable with its reason** (step 9), not "things the owner plays"; **fail fast**: no red without a green replay, the gallery and the owner's manual validations before the `publish`, the rollback target chosen beforehand; **SoundCapture tests run in the WSL like the others** (the "alone, on Windows" rule was withdrawn the same day, 2026-09-25; I had read it before that and cancelled a request for nothing); **a request carries no SHA, so the mod tree stays frozen until `RUN_DONE` and the SHA goes in `-Label`**; no watcher, no `Monitor`, no cron; session title `<mod> / <stage>` |
| `PUBLISHING.md` | `90d51374` 2026-09-25, clean | The gallery folder holds only the images to upload, named `01-`, `02-`, ... (and is the `--gallery-dir`); the one-shot items (description, packageId, `PublishedFileId.txt`); the 1.0.0 production steps done by the owner by hand (visibility, comments, "Watch all activity" of the mod and its parents); GitHub topics `rimworld rimworld-mod mod` for a public repository; the `ATTRIBUTION.md` copy in `Mod/` compared by hash; commit messages and comments in English |
| `TRANSLATIONS.md` | `90d51374` 2026-09-25, clean | The l10n gate and `localization`, `translation_en`, `translation_fr` in `STATUS.md`; the new glow mote adds no text, so nothing to inventory |
| `STYLE_RIMWORLD.md` | `90d51374` 2026-09-25, clean | Read for the Preview rules; **it says `AnimaSong/About/Preview.png` "a dérivé" (anime-like tree and colonists)**. Not acted on: a Preview is the owner's to regenerate. Also: captures for the Workshop page must be assembled by the scenario, with no dev tools, no debug overlay, no Pickle panel |
| `PickleTools/docs/steps.md` | `7268217` 2026-09-25 | The tools' step catalogue: SoundCapture (`the game is playing the sound {string}`, `I film with sound as`, `the game volume is {int} percent`), ScreenshotMode (`developer mode is turned off for the capture`), ScreenshotStudio (`I frame the studio`), FilmTicks, InspectTabs |
| `PickleTools/SoundCapture/README.md` | `1ffef12` 2026-09-25 17:22 | Eleven steps: record the sink, film with sound (`film-sound.mp4`), set the game volume (the WSL profile mutes it), and three that assert what the game itself holds as playing (`the game is playing the sound {string}`); runs in the WSL |
| `PickleTools/README.md` | `d20db95` 2026-09-25, clean | The table of tools (SoundCapture, ScreenshotStudio, FilmTicks, InspectTabs, ScreenshotMode...); pass maps name a tool with `path:PickleTools/<Tool>/Mod` |
| `PickleTools/Headless/README.md` | `b2712fc` 2026-09-25, clean | Filter terms, `-DepMap`, `-Then` and **`-ThenWithout`** (a launch that loads a save without the mod that made it: the way to automate "removing the mod from a save", written and not yet seen running), evidence, "nothing is edited while a run is going" |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | `2ce34a3` 2026-09-25, clean | Dry-run: read the log, the private item's page is not readable so the description is read by hand; `--gallery-dir`; the environment needs a reviewer and the two secrets; the gallery is manual |
| `Rimworld-Ticket-Dispatcher/docs/WELCOME.md` | `4130d70` 2026-09-25, **modified, not committed** | One test for a fix, everything for an initial or final pass; the dispatcher wakes the session |
| `Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` | **no git history** (untracked, `??`) | Every option of `Submit-PickleRun.ps1`, the exit codes (139 is not in the table: the game's own SIGSEGV), `-EvidenceDir` under the mod, no `report.html`/`messages.ndjson` kept |

## Read, not useful for this mod

| File | Version read | Why |
| --- | --- | --- |
| `scripts/SEARCHING.md` | `90d51374` 2026-09-25, clean | Searching the ten thousand mods of the Workshop corpus: this mod never needed it |

## Not found

| File | Note |
| --- | --- |
| `Docs/steps.md` | Pickle's own catalogue lives in its repository (GitHub), not here. **PickleTools has its own: `PickleTools/docs/steps.md`** (generated, `7268217` 2026-09-25, 80 steps, one table per tool): read it before writing a step. It shows that my `Anima Song: the game plays the tree's song...` duplicates part of `the game is playing the sound {string}` (SoundCapture); the tool's step is to be used instead (owner, 2026-09-25: "ne réécris pas, utilise l'outil") |
| `BACKLOG.md`, `NOTES.md`, `BUGS.md` | This mod has none |

## This mod's own files

| File | Version | Note |
| --- | --- | --- |
| `STATUS.md`, `PUBLICATION.md`, `TESTING.md`, `CHANGELOG.md`, `docs/runs/`, `Tests/Pickle/` | written by this session; last commit of `PUBLICATION.md` and `STATUS.md` `6143398`..`dbb8a16`, then edited on 2026-09-25 (see `git log`) | Not read again: written and re-read during the work |
| `README.md` | `a1c3a79`-era, read 2026-09-25 | **Was stale** (never run in game, twenty checks, six defs, the halo maintained by the job alone): corrected on 2026-09-25 |
| `ATTRIBUTION.md` (root and `Mod/`) | `c2271f8` | Both copies identical, compared by hash |
| `LICENSE` | `6143398` | MIT |
| `Mod/About/About.xml` | `6143398` | Description sent once, to compare with the public page once the item is public |
