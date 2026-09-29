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
tested_on:    2026-09-24, and every published revision through 1.0.4 (git log, GitHub releases)
workshop:     3806709272
remaining:
  - open: dispatch the 1.0.4 publish (dry-run green, run 36495696714, SHA f69a75a) so the tag v1.0.4 and GitHub release exist for the description text already live on the Steam page since 2026-09-29
  - open: read the results of the final regression pass filed 2026-09-29 (tickets 9e8d English, d20b French, a0ab Phytokin, on 9824ce7) and record them
  - open: post the Phytokin thank-you comment (PUBLICATION.md, "Thanks to post") now that the item is public
session:      local_eac16dff-a498-49b5-9ce4-f8e38ba872ef
updated:      2026-09-29, STATUS.md/TESTING.md/PUBLICATION.md trimmed to current state (AUDIT.md, "Avant la mise en veille du mod"); full history in docs/runs/
---

# Anima Song — status

Every former manual check of `TESTING.md` is now automated and green, or not applicable (table there, "What is
left of the manual checks"). Run-by-run history through 1.0.4 is in `git log` and the GitHub releases
(`docs/runs/README.md`); `docs/runs/` starts fresh from here.

## Publications

| Version | Content | Tag / release | Steam upload |
| --- | --- | --- | --- |
| 1.0.0 | First release | `v1.0.0` on `0529c10` | ManifestID `6527602686281192937`, 2026-09-28 |
| 1.0.1 | Fix: `StampAhead` logs once instead of silently repeating the halo flicker if the reflected field is gone | `v1.0.1` on `bca2c3f` | ManifestID `9109123286002546468` |
| 1.0.2 | Description: Phytokin origin paragraph reframed in the owner's own words | `v1.0.2` on `84d7fa8` | ManifestID `4870569081021350798` |
| 1.0.3 | Description: Workshop links for Phytokin, Pickle, Nelim's Pickle Tools | never dispatched, superseded by 1.0.4 | — |
| 1.0.4 | Description: no AI tool credited in Thanks | dry-run green (`36495696714`, SHA `f69a75a`), **not dispatched** | — |

**The item is public since 2026-09-29**, description edited directly on the Steam page by the owner (matches the
1.0.4 text). Rollback target if a published revision turns out red: switch the item back to private (owner,
2026-09-25; no earlier good version exists to republish instead).

## Publish mechanics

`Rimworld-Release-Admin/scripts/dispatch-publish.sh vbardales/Rimworld-Anima-Song publish-tag.yml <SHA> <version>
[--description]`; only Virginie approves `steam-production`. A `Mod/` change (including the generated
`<description>`) always needs a fresh dry-run of the exact commit before a publish is dispatched. The CI creates
the tag and GitHub release after a successful upload; visibility and the gallery stay manual, the owner's.

## Still open

- The 1.0.4 dispatch (tag/release for the description already live).
- The final regression pass (`9e8d`, `d20b`, `a0ab`).
- The Phytokin thank-you comment, now that the item is public.
