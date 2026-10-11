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
workflow_stage: followUp[1.0.3]
licence:      original
licence_at:   Original creation by Nelim; MIT in LICENSE and Mod/LICENSE, copyright (c) 2026 Nelim; credits in ATTRIBUTION.md
upstream_mod_remotes: N/A
dependencies: declared
showcase:     complete
tested_on:    2026-10-10, English full pass on the roofed-tree fix (5fa7c4a): 26 of 27 passed, the one red replayed green twice; French interface and texts on dd3de9d (7398); French and Phytokin full passes not replayed on the fix (non-regression after the commit); earlier: 2026-09-29 whole suite in English, French and with Phytokin, sound, studio and removal passes 2026-09-26..28
workshop:     3806709272
publication_changelog_review_sha: 7170e131a60b986d1f993a037c6136d15068cc76
code_review_sha: 7170e131a60b986d1f993a037c6136d15068cc76
echo_review_sha: ad20f6082d917ed14f463fdb2c330ac75c55ad14
social_preview_sha256: d1409840fb49d96b0bbaf7b2fba77049036390c8abc1a9f2025e8261a8e0dce4
remaining:
  - unverified: user report 2026-10-08 (Markizo, Workshop): idle colonists did not visit an anima tree replanted in a gravship room; cause found (the giver skipped roofed trees), fixed in 1.0.3 (v1.0.3), reporter told on the Workshop page 2026-10-10 (stated by the owner), issue 1 closed; reporter confirmed on the Workshop page 2026-10-11 ("now it works just fine", relayed by the owner); his room being roofed stays unverified
  - unverified: after the 1.0.3 upload (2026-10-10): the public page re-read, description updated (DALL-E and the Replantable thanks show), four gallery slots shown; the content of images 1 to 3 on the page not compared with Art/Gallery; Markizo told and the Replantable thank-you posted (stated by the owner, 2026-10-10); non-regression English d3e2 green (27 of 37 passed, 0 failed, 10 skipped by @requires), French 5a3a green (27 of 37 passed, 0 failed), Phytokin dc8f still queued
  - unverified: the three conditional passes (sound, studio, removal) ran before 5967dd2 (a log-once guard, no behaviour change); they stand as sole proof but were not replayed on the published build
  - unverified: each sound report (09-27) holds one red, the scenario of the other modlist; replay each pass with the scenario selected by name for a report with no red
session:      local_ae6c16b5-ec90-4f74-83f7-1d66630344c3
updated:      2026-10-10, followUp[1.0.3]: 1.0.3 uploaded (ManifestID 2330636768476916889), tag v1.0.3 on 5b21606; non-regression: English d3e2 and French 5a3a green, Phytokin dc8f queued; to do by hand: gallery images 1 to 3 on the Steam page, thank-you message, answer to Markizo
protocols_read_sha: 6dd52ef3922884f0f42526e9e07e3a07ac9fa2b1
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
| 1.0.3 | Roofed anima trees are now offered to idle colonists (reported by Markizo); French/English text fixes; new ModIcon and header image; description resent by the CI (Replantable thanks, DALL-E, Phytokin link); gallery images 1 to 3 redone (manual upload) | `v1.0.3` on `5b21606`, release published 2026-10-10 | ManifestID `2330636768476916889`, 2026-10-10 (publish run 38085429954, dry-run 38085370562; preview and description sent) |
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
(infinitives, "n'entend pas", "Chante.") or a generic plural ("les colons", "Les personnes déjà à l'écoute"), not a
single-pawn gendered form, so no switch is owed there. `translation_fr` stayed `partial` then: this session's own
reading is not the review TRANSLATIONS.md requires.

**Done 2026-10-01:** Virginie read and validated the two French files (after rewording `AnimaSong_AllowListeningDesc`); `translation_fr` is `complete`.

## Audit, 2026-10-01 (revision `3cf4884`, working tree: `FRENCH_REVIEW.md` untracked, now committed)

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
- **Rerun**: `scripts/Run-Functional-Tests.ps1`, 22 passed, 0 failed. **Not rerun**: the game (never launched by this session).


## Preview source migration — 2026-10-02

Copy, typography, layout and palette are consolidated in `Art/Preview.config.json`. The canonical inputs are `Art/Preview-source.png`, `Art/echo.png` and `Art/ModIcon-source.png`; the shared renderer writes temporary diagnostics under ignored `Art/.render/`. Existing distributed Preview, gallery and ICO outputs were preserved because they were present and coherent; no render was run for this migration. Superseded JSON files and generated QA intermediates were removed. Nothing published.

## Code review, 2026-10-05

`/code-review` (low effort, one diff pass, no verification) of `Mod/` and `Source/` from `25751bc` (0.1.0) to `1314c4c`: no finding. Diff only, nothing played in game; the Pickle runs of 2026-09-29 remain the in-game proof.

## Art regenerated, 2026-10-05

On the owner's request, after her new `Art/ModIcon-source.png`: `Art/Preview.config.json` gained `"modIconSource"`, `Render-Preview.cjs` wrote `Mod/About/ModIcon.png` (128 x 128, 35 KB) and `Mod/About/Preview.png` (747 KB), `Art/Gallery/0-preview.png` recopied byte for byte, `Art/ModIcon.ico` and `Art/Preview.ico` rebuilt as four-entry PNG icons (16, 32, 48, 256) with the recipe of `STYLE_RIMWORLD.md`. The 35 KB of the ModIcon is above the 20-30 KB the style guide gives; not checked at 32 px by a person. `Mod/` changed (two images), so the next publish needs its own dry-run. `.build/` (old intermediates and run folders, all ignored) deleted from the root.

## Gallery on the Sanctuaire and icons, 2026-10-05

The gallery scenario (`05-workshop-captures.feature`) is rewritten for the shared Sanctuaire de Nelim fixture (`SanctuaryBacklot/docs/GALERIE.md`): `Nelims-tribe`, the `podium` square, a lit torch lamp and daylilies set down by StageDecor, three made colonists. **Written, not played**: the final fixture is installed since 2026-10-06 (no "fixture prête" message waited for); the place was chosen among all of `SANCTUAIRE-LIEUX.md` (`emerald-clearing`: bare earth, 14 x 14, photographed; `calm-zone` would suit the name but its size and floor are unconfirmed; the other places are built or planted); and the studio pass (`wsl-deps.studio.map`, deleted; ticket `b8a9` no longer in the queue, no evidence folder) is replaced by `wsl-deps.sanctuary.map`. `Art/ModIcon.ico` and `Art/Preview.ico` regenerated by the fixed `Render-Preview.cjs` (six frames, 256 to 16).

## Gallery place changed, 2026-10-06

First sanctuary runs (`3b38` red on two undefined things, fixed; `bfe0` green): the pictures were read and judged poor, because `emerald-clearing` is a vivid green rug (the teal halo drowns in it) and the camera floor kept the pawns tiny. The scenario now plays on `calm-zone` (cream, about 9 x 9 usable) framed at zoom 7 on the tree, lifted by `I am at the sanctuary`. Written, not played.

## Gallery scene agreed with Pickle Tools, 2026-10-06

`calm-zone` was my own pick and not a scene agreed with them; the scene was defined with the Pickle Tools session: `bare-clearing` (the podium square without its green rug, centre (195, 152), brown earth, no smiley, animals removed by a step). The scenario now plays there at zoom 5, tree at (195, 152). Written, not played on it; coordinates were estimated by them on a capture.

Run `1993` on `bare-clearing` (3 of 3 passed), pictures read 2026-10-06: the halo reads clearly on the brown earth, the torch is lit, the three robes stand out (red, orange, pale blue). Not good yet: the pawns are not seated in a ring (one is about seven cells out), the lilies are not visible, and pictures 2 and 3 carry the whole interface, a "The psychic soothe is ending" message and, on 3, red anima-link lines. Owner paused pawn generations; nothing replayed.

Run `3f03` (pawns with Nelim as protagonist, hair and dyed robes; 2 of 2 passed), pictures read 2026-10-07: colours now read (plum, ivory, saffron robes; red, golden, silver hair) and the halo is clear on the earth. Still not good: the three are not seated around the tree (Soleil half behind the canopy, Flore beside the torch about nine cells out, Nelim to the left), the lilies are not visible, and picture 2 carries the whole interface with Nelim cutting grass out of frame. Picture 3 stands from run `1993`. Nothing replaced in `Art/Gallery/` yet.

Run `fc87` (3 of 3 passed), pictures read 2026-10-07, replaces the two earlier gallery runs (deleted): the frame is zoom 5, about 107 px a cell, so the three listeners are 3 to 4 cells out, in the ring, as asserted; the halo, the three dyed robes and hair colours, and the torch read well. Left to the owner: they all sit on the north side rather than all around the tree, and the lilies do not show. Pictures 2 and 3 now hide the resource list and the learning helper; the "The psychic soothe is ending" message, the red focus lines of picture 3 and a French "Begin liaison d'arbre anima" label (not this mod's) remain. Nothing copied to `Art/Gallery/` yet: the owner approves first.

## Sanctuary moved to SanctuaryBacklot, 2026-10-08

The Sanctuaire has its own repository, `SanctuaryBacklot` (`nelim.sanctuarybacklot`, steps prefixed `Nelim's Sanctuary:`). The gallery scenario now takes its places, animal clean-up and genes from it, and its decor, camera, hair, clothes and overlay steps from Nelim's Pickle Tools (`Nelim's Pickle Tools:`); the header of `05-workshop-captures.feature` tells the two apart. `Tests/Pickle/wsl-deps.sanctuary.map` is the Backlot's minimum list (body, trouser and face mods, EyeGenes3) plus `nelim.sanctuarybacklot` and the screenshot mode, with its seeds in `Tests/Pickle/config/sanctuary/`; docs links point to `SanctuaryBacklot/docs/`. Nelim gets her brown eyes with `has the gene "Eyes_Brown"`. `SanctuaryBacklot/Check-Steps.ps1`: all patterns compile, none ambiguous, every Sanctuary line of this feature resolves. Written, not played: the heavier mod list has not been staged for this mod yet.

## Housekeeping, 2026-10-08

`_tools/` moved to `scripts/` (`Run-Functional-Tests.ps1`, 22 passed, 0 failed after the move; README, TESTING and Tests/Pickle/README follow). Root now holds only `.git`, `.gitattributes`, `.github`, `.gitignore`. `Art/.render/` is ignored. Last code review: `1314c4c` (no finding); `Mod/` and `Source/` have changed since only by `Mod/About/ModIcon.png` and `Preview.png`, no code. Three gallery candidates are in `Art/Gallery/` (see PUBLICATION.md).

## French review, 2026-10-08

The owner re-read the French and English texts after the gender-neutral rewording (`AnimaSong_OrderFull` in both languages, `AnimaSong_AllowListeningDesc`) and validated them: "Anima Song est validé". `translation_fr: complete` stands, now on the current texts (`FRENCH_REVIEW.md`).

Gallery candidates of run `fc87` refused by the owner (2026-10-08) and deleted; regeneration on the Sanctuary Backlot with its whole minimum list, eye colours and facial expressions filed the same day.

## Audit, 2026-10-10 (revision `c53d1a0`, AUDIT.md section 16, up to `playTests[1.0.3]`)

- **3 code:** build clean, `Mod/Assemblies/AnimaSong.dll` byte-identical to a fresh Release build; `CHANGELOG.md` 1.0.3 lists the roofed-tree fix.
- **4 dependencies:** `About.xml` declares Royalty as `modDependencies`, `loadAfter` Core; `LoadFolders.xml` has one `v1.6` block with the Royalty folder gated on `IfModActive`; Phytokin stays soft (looked up by def name). Not re-derived from the sources today beyond reading these files.
- **5 settings:** no settings, no MainButtons entry in `Source/` or `Mod/Defs/` (grep): `not_applicable` stands.
- **6 translations:** `Check-DefInjected.ps1`: 4 keys, 0 errors; `FRENCH_REVIEW.md` regenerated (Virginie's review of 2026-10-08 stands, wording unchanged since).
- **7 tests:** `scripts/Run-Functional-Tests.ps1` 22 passed, 0 failed on `5fa7c4a`; Pickle suite in `Tests/Pickle/Mod/Pickle/Features/`; the mod keeps its scenarios in `TESTING.md`, not a file named `TEST_SCENARIOS.md`.
- **8 playTests:** full English pass `ed83` (37 scenarios, 26 passed, 1 red, 10 skipped by `@requires`); the red replayed alone and green twice (`994e`, `3432`; `0a0c` crashed at startup, exit 139, nothing played). Roofed tree: `0ef3`, `589f`. Code review `1314c4c..c53d1a0` of `Mod/` (the roof line removed from `AnimaSong_Listen`, text, images): no finding, nothing in `Source/` changed. Gallery images 1 to 3 accepted.

## Gallery, 2026-10-10

| # | File | Source | State |
| --- | --- | --- | --- |
| 0 | `0-preview.png` | copy of `Mod/About/Preview.png` | in place |
| 1 | `1-the-tree-singing.jpg` | Backlot `bare-clearing`, run `342d`, stools, 2026-10-09 | accepted by the owner, 2026-10-09 |
| 2 | `2-the-right-click-menu.jpg` | Backlot, run `19c9`, 20C | accepted 2026-10-08 |
| 3 | `3-the-tree-selected.jpg` | Backlot `bare-clearing`, run `4e27`, 2026-10-10 | accepted by the session as director, 2026-10-10 |

Order (session as director): 1 is the most demonstrative (the tree singing with its listeners, the point of the mod), 2 shows how a player orders it, 3 shows the toggle that allows or forbids it. All opened and looked at 2026-10-10; indexes 0 to 3, no gap, no duplicate.

## Echo, 2026-10-10 (AUDIT.md 10.a)

Decision: keep `Art/echo.png`. It is the line-art of the anima tree as the game draws it (the fan of long pale leaves, the buds, the short trunk), and the gallery now shows exactly that tree: the singing tree of image 1 and the selected tree of image 3. The Preview was accepted (opened 2026-10-07, ModIcon badge in the bottom-left corner, 896 x 504, 684 KB, version badge 1.6 = `supportedVersions`); it is not reopened for taste. Recorded in `echo_review_sha`.

## Code review, 2026-10-10 (AUDIT.md 12.a)

`23bf286..7170e13` of `Mod/` and `Source/`: only `Mod/About/About.xml` (description text: Phytokin link, save wording, DALL-E, Replantable thanks) and `Mod/ATTRIBUTION.md` (Replantable section, DALL-E). No code changed since the review of `c53d1a0`. No finding. The roofed-tree fix (`AnimaSong.xml`, no `unroofedOnly`) and the `build/` path change were reviewed earlier (`c53d1a0`); the Pickle runs `589f`, `ed83`, `3432`, `7398` are the in-game proof.
