---
localization: complete
settings_audit: not_applicable
translation_en: complete
translation_fr: complete
mod:          Anima Song
packageId:    nelim.animasong
repo:         Rimworld-Anima-Song
visibility:   public
detached:     yes
stage:        published
workflow_stage: published
licence:      original
licence_at:   Original creation by Nelim; MIT in LICENSE and Mod/LICENSE, copyright (c) 2026 Nelim; credits in ATTRIBUTION.md
upstream_mod_remotes: N/A
dependencies: declared
showcase:     complete
tested_on:    2026-09-29, whole suite in English, French and with Phytokin on the published code (last code change 5967dd2); sound, studio and removal passes 2026-09-26..28, on the build before it
workshop:     3806709272
remaining:
  - unverified: the three conditional passes (sound, studio, removal) ran before 5967dd2 (a log-once guard, no behaviour change); they stand as sole proof but were not replayed on the published build
  - unverified: each sound report (09-27) holds one red, the scenario of the other modlist; replay each pass with the scenario selected by name for a report with no red
session:      local_b972f1a7-9f09-4a1f-a952-6a1a8f96d623
updated:      2026-10-01, French review validated by Virginie (translation_fr complete)
---

# Anima Song — status

Every former manual check of `TESTING.md` is now automated and green, or not applicable (table there, "What is
left of the manual checks"). Run-by-run history through 1.0.2 is in `git log` and the GitHub releases
(`docs/runs/README.md`); `docs/runs/` starts fresh from here.

## Publications

| Version | Content | Tag / release | Steam upload |
| --- | --- | --- | --- |
| 1.0.0 | First release | `v1.0.0` on `0529c10` | ManifestID `6527602686281192937`, 2026-09-28 |
| 1.0.1 | Fix: `StampAhead` logs once instead of silently repeating the halo flicker if the reflected field is gone | `v1.0.1` on `bca2c3f` | ManifestID `9109123286002546468` |
| 1.0.2 | Description: Phytokin origin paragraph reframed in the owner's own words | `v1.0.2` on `84d7fa8` | ManifestID `4870569081021350798` |
| — | Description, hand-edited on Steam 2026-09-29: Workshop links added, no AI tool credited in Thanks | no version, no tag/release — a description-only change is not a minor bump | edited directly on the page |

**The item is public since 2026-09-29**, description edited directly on the Steam page by the owner. Rollback
target if a published revision turns out red: switch the item back to private (owner, 2026-09-25; no earlier good
version exists to republish instead).

## Publish mechanics

`Rimworld-Release-Admin/scripts/dispatch-publish.sh vbardales/Rimworld-Anima-Song publish-tag.yml <SHA> <version>
[--description]`; only Virginie approves `steam-production`. A description-only change is edited directly on the
Steam page instead: no minor version for wording. A `Mod/` change that touches code still needs a fresh dry-run of
the exact commit before a publish is dispatched. The CI creates the tag and GitHub release after a successful
upload; visibility and the gallery stay manual, the owner's.

## Still open

The French review by Virginie (see Translation audit); the regression pass otherwise stands: `9e8d` English,
`d20b` French, `a0ab` Phytokin, all green, 26–27/34 passed each, 0 failed; the 7–8 skips per run are Phytokin/
sound/studio/removal scenarios needing their own staged pass, not this one, and not a regression.

## Translation audit

French lives in two files: `Mod/Languages/French/Keyed/AnimaSong.xml` (gizmo, right-click order, its disabled
reasons, inspect lines) and `Mod/Languages/French/DefInjected/ThoughtDef/AnimaSong.xml` (the listening memory's
label and description). No grammar/Rules files.

**2026-09-30, session pass (TRANSLATIONS.md section 3, French gender agreement):** every French text read for a
past participle or adjective agreeing with the pawn. One defect found: the memory description used "je me suis
assis", masculine only, with no switch. Reworded to "j'ai pris le temps de l'écouter" — no agreement needed,
reads naturally, meaning kept (English: "I sat and listened"). Everything else is either non-agreeing
(infinitives, "n'entend pas", "Chante.") or a generic plural ("les colons", "Ceux qui écoutent"), not a
single-pawn gendered form, so no switch is owed there. `translation_fr` stayed `partial` then: this session's own
reading is not the review TRANSLATIONS.md requires.

**Done 2026-10-01:** Virginie read and validated the two French files (after rewording `AnimaSong_AllowListeningDesc`); `translation_fr` is `complete`.

## Audit, 2026-10-01 (revision `3cf4884`, working tree: `TRANSLATIONS_REVIEW.md` untracked, now committed)

`published` stands: nothing before it fails. Checked, not taken from the old status:

- **No `@wip`** in `Tests/Pickle/Mod` (the one hit is a comment). **All `@requires` scenarios have run**: Phytokin in the 09-29 Phytokin pass
  (27/34, its scenario passed); sound (3) 09-27, studio (3) 09-26, removal (1) 09-28, each in its own pass. No manual test left
  (`TESTING.md`, "What is left of the manual checks"). Two reservations, in `remaining`: those passes predate `5967dd2`, and each sound
  report holds one expected red.
- **`.dds`**: none tracked, none ever committed (`git log --all -- '*.dds'` empty), none on disk; `*.dds` already ignored.
- **Evidence**: none tracked; `Tests/Pickle/Evidence/` ignored explicitly; trimmed from 147 MB to 2 MB, list in `docs/runs/README.md`.
  No field of this file points to a deleted report.
- **Upstream**: original mod, no source mod, `upstream_mod_remotes: N/A` stands (no repository to base code on or send PRs to).
- **Publish id**: `Mod/About/PublishedFileId.txt` = `3806709272`; `CHANGELOG.md` now carries the `[0.1.0]` entry (creation of the publishIdFile,
  `25751bc`) under 1.0.0.
- **Local folder icons**: `Art/ModIcon.ico` exists; `Art/Preview.ico` was missing on 2026-10-01 and was added by the owner on 2026-10-02, so the reference in `Mod/desktop.ini` now resolves. `Mod/` holds
  `desktop.ini` untracked and ignored (`Mod/**/desktop.ini`, `Mod/**/*.ico` added), so Steam does not receive it.
- **Rerun**: `_tools/Run-Functional-Tests.ps1`, 22 passed, 0 failed. **Not rerun**: the game (never launched by this session).


## Preview source migration — 2026-10-02

Copy, typography, layout and palette are consolidated in `Art/Preview.config.json`. The canonical inputs are `Art/Preview-source.png`, `Art/echo.png` and `Art/ModIcon-source.png`; the shared renderer writes temporary diagnostics under ignored `Art/.render/`. Existing distributed Preview, gallery and ICO outputs were preserved because they were present and coherent; no render was run for this migration. Superseded JSON files and generated QA intermediates were removed. Nothing published.

## Code review, 2026-10-05

`/code-review` (low effort, one diff pass, no verification) of `Mod/` and `Source/` from `25751bc` (0.1.0) to `1314c4c`: no finding. Diff only, nothing played in game; the Pickle runs of 2026-09-29 remain the in-game proof.

## Art regenerated, 2026-10-05

On the owner's request, after her new `Art/ModIcon-source.png`: `Art/Preview.config.json` gained `"modIconSource"`, `Render-Preview.cjs` wrote `Mod/About/ModIcon.png` (128 x 128, 35 KB) and `Mod/About/Preview.png` (747 KB), `Art/Gallery/0-preview.png` recopied byte for byte, `Art/ModIcon.ico` and `Art/Preview.ico` rebuilt as four-entry PNG icons (16, 32, 48, 256) with the recipe of `STYLE_RIMWORLD.md`. The 35 KB of the ModIcon is above the 20-30 KB the style guide gives; not checked at 32 px by a person. `Mod/` changed (two images), so the next publish needs its own dry-run. `.build/` (old intermediates and run folders, all ignored) deleted from the root.
