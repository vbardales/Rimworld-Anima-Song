# Protocols read, and in which version

Refreshed 2026-10-01 (audit pass) by the Anima Song session. Version = last commit that touched the file in its own
repository (`git log -1 --format='%h %ad' -- <file>`), plus `modified, not committed` when `git status --short -- <file>`
shows `M`. A file whose version below is unchanged is not read again; one whose last commit differs is.

"Read" means in full, "diff" means only what moved since the version of 2026-09-25 (`git diff <old> <new>`), "skimmed"
means searched for the rules that touch a published, tested mod.

## Read, and useful

| File | Version | How | What it changed for this mod |
| --- | --- | --- | --- |
| `AGENTS.md` | `90d51374` 2026-09-25 | read (unchanged since 09-25) | Evidence: keep the latest report per scenario of the current revision; history = one line per run in `docs/runs/`; never delete a report a `STATUS.md` field points to |
| `AUDIT.md` | `90d51374` 2026-09-25 | read in full | Step 9 `tested` conditions (no `@wip`, every `@requires` scenario ran, no manual test left); step 11 prepublication `0.1.0` and `CHANGELOG`; session title `<packageId sans nelim.> / <workflow_stage>`; evidence on disk, never in git |
| `PUBLISHING.md` | `90d51374` 2026-09-25 | read (unchanged) | One-shot items, gallery, `PublishedFileId.txt`, topics; commit messages in English |
| `TRANSLATIONS.md` | `90d51374` 2026-09-25 | read (unchanged) | l10n gate, French gender agreement (section 3), systematic French review by the owner |
| `MOD_SETTINGS.md` | `90d51374` 2026-09-25 | read (unchanged) | `settings_audit: not_applicable`: no setting, no page, no MainButtons shortcut |
| `STYLE_RIMWORLD.md` | `90d51374` 2026-09-25 | read (unchanged) | Preview and ModIcon are the owner's to generate; captures for the Workshop page |
| `WORKSHOP_COMMENTS.md` | `08878789` 2026-09-29 | skimmed (post-publication thank-you comments, already posted 2026-09-29) | Nothing new to write; one comment per recipient, under 1000 characters |
| `PickleTools/README.md` | `ff20d89` 2026-09-29, **modified, not committed** | skimmed | The tools table (SoundCapture, ScreenshotStudio) already used by the suite |
| `PickleTools/Headless/README.md` | `ed4e73a` 2026-09-26 | diff from `b2712fc` | Exit 139 is the game's own SIGSEGV; a run's settings stay for the next run of the same mod; **a pass map must end with a newline** (the last line is silently lost otherwise): checked below |
| `PickleTools/docs/steps.md` | `da7c3b0` 2026-09-28, **modified, not committed** | skimmed | Step catalogue; SoundCapture steps used by `04-the-song-heard.feature` |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | `3c03f51` 2026-09-26 | diff from `2ce34a3` | Rewritten around "Rules that never bend": dry-run of the exact SHA, `publish` takes the 40-character SHA, only the owner approves `steam-production`, the CI makes tag and release, `dispatch-publish.sh` refuses without a green dry-run. Nothing to publish this pass |
| `Rimworld-Ticket-Dispatcher/docs/WELCOME.md` | `77ca9d7` 2026-09-27 | diff from `4130d70` | `path:` of a local mod is the folder holding `About/About.xml`; load order is the staging order; **no `desktop.ini` or `.ico` in `Mod/`** (done in `.gitignore`); a gallery pass must zoom enough; sessions file moved to `.pickle-state\` |
| `Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` | `d07b2b8` 2026-09-26 | skimmed | Options of `Submit-PickleRun.ps1`, exit codes; no run submitted this pass |

## Read, not useful for this mod

| File | Version | Why |
| --- | --- | --- |
| `scripts/SEARCHING.md` | `90d51374` 2026-09-25 | Searching the Workshop corpus: this mod never needed it |

## Not applicable to this mod

`BACKLOG.md`, `NOTES.md`, `BUGS.md`: this mod has none. `README.md`, `ATTRIBUTION.md` (root and `Mod/` copy, identical by hash),
`LICENSE` (MIT), `Mod/About/About.xml`, `PUBLICATION.md`, `TESTING.md`, `CHANGELOG.md`, `STATUS.md`, `docs/runs/`, `Tests/Pickle/`: this
mod's own files, read or written in this audit (see `STATUS.md`, "Audit, 2026-10-01").

## Checked from the diffs

- Pass maps end with a newline: see the last byte of each of the six `Tests/Pickle/wsl-deps*.map` is `0a` (checked 2026-10-01).
- `Mod/` tracks no `desktop.ini` or `.ico` (the local `Mod/desktop.ini` is ignored).
