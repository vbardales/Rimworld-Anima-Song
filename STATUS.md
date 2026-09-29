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
licence:      original
licence_at:   Original creation by Nelim; MIT in LICENSE and Mod/LICENSE, copyright (c) 2026 Nelim; credits in ATTRIBUTION.md
upstream_mod_remotes: N/A
dependencies: declared
showcase:     complete
tested_on:    2026-09-24, and every published revision through 1.0.2 (git log, GitHub releases)
workshop:     3806709272
remaining:
  - open: read the results of tickets d20b (French) and a0ab (Phytokin), final regression pass filed 2026-09-29 on 9824ce7; 9e8d (English) done, 26/34 passed, 0 failed, 8 skipped (Phytokin/sound/studio/removal scenarios, need their own staged passes, not a regression)
session:      local_eac16dff-a498-49b5-9ce4-f8e38ba872ef
updated:      2026-09-29, no minor version for a description-only edit; 1.0.3/1.0.4 folded into the hand-edited text, no tag/release for either
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

- The final regression pass (`9e8d`, `d20b`, `a0ab`).
