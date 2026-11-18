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
workflow_stage: writeShotlist[1.1.0]
licence:      original
licence_at:   Original creation by Nelim; MIT in LICENSE and Mod/LICENSE, copyright (c) 2026 Nelim; credits in ATTRIBUTION.md
upstream_mod_remotes: N/A
dependencies: declared
showcase:     complete
tested_1_7:   yes
tested_on:    2026-10-10, English full pass on the roofed-tree fix (5fa7c4a): 26 of 27 passed, the one red replayed green twice; French interface and texts on dd3de9d (7398); French and Phytokin full passes not replayed on the fix (non-regression after the commit); earlier: 2026-09-29 whole suite in English, French and with Phytokin, sound, studio and removal passes 2026-09-26..28
workshop:     3806709272
publication_changelog_review_sha: 7170e131a60b986d1f993a037c6136d15068cc76
code_review_sha: af0687ea5105f2cdea14ff2761d920f6dc048532
echo_review_sha: 70f6c760c3663834a2b800302ae81a480e8c9416
social_preview_sha256: ace9cafd1a9e02e5d3934460e3776f096099d0f37820a70233c96ead0eb6bbd1
remaining:
  - done 2026-11-18: 1.6 ticket f8bd GREEN 1 of 1 (ordered walk alone, rebuilt steps DLL, 18.8 s, summary.json passed): the red of 05bd and b579 was the stale or first-run steps DLL, not the mod; 1.6 `exists near` side closed; evidence p16-near2, p16-near3, p16-near4 read and deleted; next: non-regression pass on the next build, housekeeping below
  - done 2026-11-18: 1.7 whole suite English: ef14 (ColonistRace 38f99e28+, a4d433a, azure) 21 of 24 passed, 3 reds (ordered walk, halo normal speed, full sitting) = test side only: Listener and Passerby still used the plain `exists` spawn, halo step at its 180 s limit; fixed in 01-the-song.feature (`exists near (72, 132)`, halo `@timeout:300`), replayed 0de3: 3 of 3 passed; mod files unchanged between the two runs; `tested_1_7: yes` (English only); `<li>1.7</li>`, version and CHANGELOG only at the publication gesture (same commit as the Preview redo); 1.6 warning: scenarios using `exists near` need the 1.6 ColonistRace DLL of 38f99e28+ (non-regression pass); next: housekeeping below
  - done 2026-11-18: housekeeping: sync-nsb-npt, STATUS.md trimmed, evidence under 2 MB (deleted nonreg-en 2026-10-10, p16-singing2, p17-walk-repo4: covered by newer greens; nonreg-fr and nonreg-phytokin stay, sole proof of 6 to 7 scenarios until a non-regression pass on a published build); code review 8.m: git diff d211a04..HEAD -- Mod holds only About.xml wording (two descriptions), no finding, code_review_sha = HEAD
  - open: 8.f (audit replay 2026-11-16): sound, studio and removal replays done 2026-11-17 (see done line); nothing left here but the 1.7 pass and the gallery; gallery work resumes at shootGallery
  - done 2026-11-18: SaB answered (via TM): Soren, Miel and Ryu all validated and free in a gallery scene (VALIDE.md); Ryu is Thin Male, a body the owner marked NOT OK for VTW trousers (awaiting a VTW fix), so shots with his trousers may change: DECISION for B and E (ring of three): Nelim, Soren, Miel (daily outfits: Miel overalls orange `#C58A3A` and cream chest wrap, with or without the green builders jacket, Soren as in the colonists table); Ryu dropped for B and E; scenarios B and E rewritten at shootGallery with Miel built inline from her VALIDE.md block, tell SaB the scenario used so it keeps its log; no game run before shootGallery
  - open: protocols read 2026-11-18 (f8fee9c): when all gallery captures are candidates (4 or more at score-gallery), ask the owner `🟠 À toi, maintenant : lance /mod-workflow:rate-gallery` (the session no longer writes or burns subtitles alone, AUDIT 9.e bis, GALLERY.md); Preview at mountPreview uses the gallery block with `Art/Gallery-clean/` originals (STYLE_RIMWORLD.md)
  - open: gallery prep (Audit via TM, 2026-10-18): shooting plan and scenarios A dawn, E dusk, F night written in `05-workshop-captures.feature` (@wip, NOT played, steps resolve per Check-Steps), noon scenario gained a peacock and a labrador, subtitles drafted in `PUBLICATION.md`; shot list reviewed 2026-10-18 (listener facing fixed: z grows north, seat z 155 faces South, z 149 faces North; zoom 6 on dawn and night; dusk and night subtitles reworded; rated 4 of 5, not played); to do at shootGallery: play, open each capture against the plan, confirm animal kinds and `Face_Stars`, ask NPT (via TM) for an animal-facing step if backs show; 9a/9b at prepareRelease (the mod adds no props, apparel or hairstyles: nothing for `GALLERY-PROPS.md` beyond "seen in a capture" for what gets played); no game run before shootGallery
  - open: 1.7 diagnostic closed 2026-11-17 (first run ff31: 18 of 24, six reds; cause = spawn cell of the plain `exists` step, not the mod, not 1.7; fixed by PiT step `exists near (x, z)`, 38f99e28; replays 7409 and b702 green, 0de3 green after the test-side fix); full history in Docs/runs/status-journal-2026-11.md
  - open: 1.1.0 (RimWorld 1.7): the 1.7 install ships English only, so 1.7 passes are English and `tested_1_7: yes` holds for English only (AUDIT.md, 2026-10-13); `tested_1_7` not yet recorded; first diagnostic 9f17 not conclusive; the walk alone PASSED on 1.7 2026-11-07 (a538, net472 DLL, evidence p17-walk-repo4); still to play on 1.7: SaveSteps has no `net10.0` build (scenarios 03, 06 not reached); test the current `net472` DLL on 1.7 (Pickle on 1.7 and NPT/SB 1.7 prerequisites first, AUDIT.md); if it fails, add `1.7/` (`net10.0`) and a `<v1.7>` block in `LoadFolders.xml`; `<li>1.7</li>` in `supportedVersions`, version, `CHANGELOG.md` only after a green 1.7 run
  - done 2026-11-05: 7b Preview redo: config migrated to the new format (`description`, `background`, automatic title fit 41 px), echo centered, clear of title and copy line, opened and checked; Preview.png, Art/Gallery/0-preview.png, Preview.ico committed
  - unverified: user report 2026-10-08 (Markizo, Workshop): idle colonists did not visit an anima tree replanted in a gravship room; cause found (the giver skipped roofed trees), fixed in 1.0.3 (v1.0.3), reporter told on the Workshop page 2026-10-10 (stated by the owner), issue 1 closed; reporter confirmed on the Workshop page 2026-10-11 ("now it works just fine", relayed by the owner); his room being roofed stays unverified
  - unverified: after the 1.0.3 upload (2026-10-10): the public page re-read, description updated (DALL-E and the Replantable thanks show), four gallery slots shown; the content of images 1 to 3 on the page not compared with Art/Gallery; Markizo told and the Replantable thank-you posted (stated by the owner, 2026-10-10); non-regression English d3e2 green (27 of 37 passed, 0 failed, 10 skipped by @requires), French 5a3a green (27 of 37 passed, 0 failed), Phytokin dc8f stalled after 11 green (exit 3, a save load hung), replayed as 3926
session:      local_c4b5f23a-99dd-41be-8ab8-4bb76043da8d
updated:      2026-11-18, writeShotlist[1.1.0] (8.a to 8.m done: evidence under 2 MB, code review d211a04..HEAD holds only About.xml wording, no finding; B and E recast Nelim, Soren, Miel; earlier history in git log)
protocols_read_sha: 2b16552b1c489cd8537d600a08630cb582a11b68
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

## Journal

The dated sections of 2026-10 (audit, preview migration, code reviews, art, gallery, sanctuary move, French review, echo) moved to `Docs/runs/status-journal-2026-10.md` on 2026-11-18.

## NSB (sync 2026-11-18, writeShotlist[1.1.0])

Reads: Places read: 2026-11-18 Tribe read: 2026-11-18 Steps read: 2026-11-18. Sync 2026-11-18 (second, NSB log since 2026-11-17): places docs unchanged; new `RECONSTRUCTION-SAUVEGARDE.md` = plan only (rebuild of the Sanctuary save as `Nelims-tribe-v2`, nothing built, doors not passed: no change for our fixture `Nelims-tribe-decor-mods-z3` before it ships); VALIDE.md: Miel Aveline now validated (daily looks, 2026-11-17), Daichi and Dalia validated (babies, not used), Iori profile changes (not used); BiB gene renames (not used); NPT log since 2026-11-18: no change to steps.md or catalogues. Nothing to update in shotlist or scenarios (stage playTests, notes only); for shootGallery: Miel is now a validated alternative to Ryu for the ring of three (B, E), to weigh at write-shotlist. Older syncs: Docs/runs/status-journal-2026-11.md.

Rules of 2026-11-05 applied. Owner, 2026-11-09: "reviens vers le sanctuaire". The invented companions (Flore, Soleil, Oren, Ysa) and the labrador Biscuit are dropped: they were written 2026-10-05 when NSB held one colonist; their only argument was visual contrast (robe and hair colours against the teal glow, three body types), which NSB colonists can give. Mod adds no animal (rule 5: nothing to show). Shotlist E (dusk, five listeners) is re-cast at write-shotlist with validated NSB colonists only (Nelim, Soren, Ryu: Miel has no validated look or outfit in VALIDE.md, 2026-11-09).

| Place | Shots | Changes for the gallery | Last read |
| --- | --- | --- | --- |
| `bare-clearing` (195, 152), zone libre | A, B, E, F (C, D UI) | tree grown by the mod, decor (stools, torch lamps, daylilies, anima grass) set and removed | 2026-11-09 (row only) |

| Colonist | Shots | Outfit | Last read of profile | Exceptions |
| --- | --- | --- | --- | --- |
| Nelim | A to F | robe and cape, dye chosen per shot (outfit, free) | not opened | none: played with her roster hair (`Roo_HD_Hair_Highpony`), the Bob and hair-colour overrides are dropped (rule 3) |
| Soren | B, E | validated daily: shirt #708090, vest #6B4F3A, trousers #3C4650 | VALIDE.md section read | none |
| Ryu "Blue" Sai | B, E | validated daily: shirt #1F3A34, trousers #A0522D, brown boots | VALIDE.md section read | none (replaces Miel, no validated look) |

| Animal | Shots | Outfit | Last read | Exceptions |
| --- | --- | --- | --- | --- |
| Shogun (NSB labrador, Nelim's) | B, F | `Apparel_leatherdogcollar` by default | catalogue only | none |
| Hare, Squirrel (A), Peacock (B) | A, B | none | n/a | wild or decor, not covered by rule 2 |

| Included animal (rule 5) | Shots |
| --- | --- |
| none: the mod ships no animal | n/a |

## Shotlist (2026-11-09, plan only, nothing played)

Header of `Tests/Pickle/Mod/Pickle/Features/05-workshop-captures.feature` holds the full lines. Director pass by an Opus sub-agent: kept the empty ring at dawn, the arrival instant (order given, screenshot 20 ticks after), Shogun lying, peacock and hare in the foreground, weather named, halo pulsing cut, zoom 4.5 instead of "low angle", F mirrored from A; dropped the "Soren leaves his seat" instant (no step), replaced by Nelim arriving last.

| # | Scene | a time | b decor | c living | d pawns | e action | f composition | g subject | j mod | plan |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A | dawn, opening | h6 Clear 20C, 20 ticks | 3 empty stools, grass, 4 daylilies, lit torch | hare front, squirrel | Nelim plum robe, ivory cape, smile | arrives one step from seat | zoom 6, tree off-centre, hare foreground | empty ring, tree waits | halo + ring | 5 |
| B | noon, lead | h12 Clear, 90 ticks | stools, torch, daylilies, grass | peacock front, Shogun lying | Nelim, Soren, Ryu named colours, smile | just sat, halo starts | zoom 5, tree off-centre | colonists ring, tree answers | halo + ring | 5 |
| E | dusk | h18 Clear | 2 lit torches, stools, daylilies | Shogun standing, yawning | same three, same outfits | Nelim arrives last | zoom 4.5, grass at frame edges | the day turns, glow | glow from afar | 5 |
| F | night, closing | h22 Clear | close torch, 2 empty stools | Shogun asleep | Nelim back to camera (no smile visible, reason written) | seated, tree beyond | zoom 6, mirror of A | sings after dark | glow vs torch | 5 |

k (series): one story, one day, hours 6 12 18 22; tight, medium, wide, tight; opening A, closing F, rhythm moves: ok. C and D: interface, set aside. Plan means 5 on 4 scenes, by the fixed rule, on paper; main risks: the arrival instant (timing of the screenshot, adjusted on the first run), night brightness (one test capture), a smile not visible from behind in F. Not verified: steps `the animal ... lies at ... facing` and `faces` exist in steps.md (read), their behaviour in this fixture (not played). Existing `Art/Gallery/1-the-tree-singing.jpg` (old cast Flore and Soleil) is stale for B: deleted when the scenario is rewritten (`git rm`, next step).

Gallery log (2026-11-09 to 2026-11-12) moved to Docs/runs/status-journal-2026-11.md. State: scenes A and F are candidates (tickets 9bea, 11fd green, score-gallery 4.5 and 4.5, kept in Tests/Pickle/Parked/gallery-a3 and gallery-af3 until the end-of-gallery review); B and E (ring of three) wait for the SaB go on Soren and Ryu; robe proof: the cape shares the robe layer and hides it, capes removed from A, B, E, F.


## Ecosystem (PiI Steam search 2026-11-13, AUDIT 1.a and 8.0)

Detail: docs/inventory/ecosystem-steam/AnimaSong.md (`ecosystem-links` block added by PiI 2026-11-16: 15 rows, Phytokin 2927323805 parent, its French translation, 13 linked; no new search). No duplicate, fork or replacement: no other mod lets colonists listen to an anima tree sing (5441 folders scanned: only the Phytokin original 2927323805, its French translation, JoyRescue (ours) and our two items hold our defNames or label). Anima neighbours (VPE - Anima, Replantable Anima Trees, Anima Integration, Anima Tree Pet) are not competitors. Only Phytokin stays subscribed (compat pass 8.f); the 3 other study mods are unsubscribed. Replaces the local scan of 2026-11-12 (read only downloaded mods).

Second request, Phytokin variants (PiI, e4ad269, same file, section "Second request"): 8 Phytokin-based mods checked (More Phytokin Xenotypes, Archeankin, HarbingerKin - Phytokin, Phytokin Have Fathers, Anima Theme for VRE: Phytokin, VRE - Phytokin - Anima Theme, Mokas Phytokin have Natural Connection, Phytokin Vanilla Faces). None touches the anima song or our recreation, no shared defName, no duplicate. All 8 unsubscribed; only 2927323805 stays (compat pass 8.f).

TM missions 2026-11-12 (items 0 to 24) read: items 8.k wording, 14 (.gitignore holds desktop.ini, Inbox, Parked, Evidence; Mod/desktop.ini kept), 15 (Art/ closed set, no echo.png), 23 done; TRANSLATION_REVIEW.md exists (f3e23d6); the 2026-11-07 review predates the page-header fix: Audit asked whether to rerun (item 2 vs 21b).

**2026-11-12, review-translation (page 1 of 1, ChatGPT, no correction) on d6f09c6 texts: validated by Virginie ("review validée"). translation_fr: complete stands.**
