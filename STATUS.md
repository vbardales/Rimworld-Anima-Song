---
localization: complete
settings_audit: not_applicable
ecosystem_line: 1.1
translation_en: complete
translation_fr: complete
mod:          Anima Song
packageId:    nelim.animasong
repo:         Rimworld-Anima-Song
visibility:   public
detached:     yes
workflow_stage: shootGallery[1.1.0]
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
 - done 2026-11-22 (ATTRIBUTION and rate-gallery, session verdict): `ATTRIBUTION.md` has its "Gallery set" section (10 external mods, defs checked in the feature file; body mods not tied to a def, not listed); rate-gallery plus score-gallery rerun: 1, 4, 5, 6 candidates (notes about 4), subtitles written and burned; open: credit line in the Steam description (and `WORKSHOP_COMMENTS.md` if the mod keeps one), faces and eyes still without the VTE and VEFA look, owner review of the whole gallery before mountPreview
 - open 2026-11-22 (owner, in chat: "1, 5, 6 non corrigés (ajouter VEFA et VTE)"): shots 1, 5, 6 are REDO on eyes, owner review only (not a validation); 1 and 6 are no longer candidates; question sent to PiT (is `enableExperimentalEyeTextures` true in the seed, which EyeballTypeDef and LidTypeDef give the VEFA and VTE eyes, steps for Nelim, Soren, Miel); on the answer edit scenes A, E, F, refile one ticket, replace finals only if the eyes show, redo subtitles; 4-noon not named by the owner
 - open 2026-11-22 (PiT answer, ticket 2c19 filed on label "gallery A E F VEFA and VTE eyes"): seed `Mod_3753978140_MovingVanillaEyesMod.xml` now sets `enableExperimentalEyeTextures` True (its patches add the VEFA eyes only then); scenes A, E, F set `eyeballs are` (EyeNormal; Miel EyeSmall, EyeThin/Empathetic dropped) and `lids are` (LidCheerful Nelim and Miel, LidAlmond Soren) then log `the face parts of` each pawn: a texture path `Things/Pawn/VanillaExperimental/` proves VEFA applied; VTE adds lids and mouths only, no eyeball; F now Nelim seated in profile at (199, 152) facing West (back view hid the eyes), header updated; on RUN_DONE: read `[face-parts]` in Player.log, open the three captures, replace 1, 5, 6 only if the eyes show and no Log.Error, redo subtitles, delete the run folder
  - done 2026-11-22 (ticket 2c19 GREEN 3 of 3, evidence Tests/Pickle/Inbox/gallery-eyes5, kept until the finals are decided): `[face-parts]` proves VEFA applied (`Things/Pawn/VanillaExperimental/Eyes/Normal`, Lids Cheerful), no Log.Error from the mods (only FMOD clip noise); captures: A Nelim front, eyes closed with lashes, smile; E Nelim, Soren, Miel eyes closed with lashes; F Nelim profile, eyes closed; the listening pose shuts the eyes, so no open eye shows but the VEFA lids are drawn; DECIDED by the session (owner: "c'est toi qui décides"): the 2c19 takes replace finals 1, 5, 6 (VEFA and VTE lids drawn, Soren shirt kept in 5); clean originals 1440 x 810 truecolor PNG in `Art/Gallery-clean/` (256-colour quantization shifted the colours, so not used), subtitles burned again with the same lines, each under 2 MB, `Art/Gallery/` 7.76 MB; run folder deleted; open: owner review of the whole gallery before mountPreview, `gallery_validated_sha` absent
  - open 2026-11-22 (owner, in chat: "grimace de Nelim en 1, pas de sourcils"; cause read in the 2c19 `[face-parts]`: scene A had no face step for Nelim, so SkinBandaid (orange patch on the cheek), AKN_BrowCourageous (thin, under the fringe) and MouthSmile came from the save; E and F the same with SkinNormal and AKN_MouthCourageous): 1, 5, 6 are REDO on Nelim's face; scenes A, B, E, F now set `face skin is "SkinNormal"`, `brows are "BrowNormal"`, `mouth is "MouthLipsSmirk"` (her NSB canon) before the expression; ticket ffc3 filed (label "gallery A E F Nelim face", evidence Tests/Pickle/Inbox/gallery-face6); on RUN_DONE: read `[face-parts]`, open the three captures, replace finals 1, 5, 6 only if the face reads well (brows visible, no Bandaid), redo the clean originals and subtitles, delete the run folder; the verdict "four candidates" below is withdrawn for 1, 5, 6 until then
  - open 2026-11-22 (owner, in chat: shot 4 still KO for the same reason, wrong face type, "mettre BiB pour gène VTE/VEFA ?"): 4-noon is REDO on Soren and Miel faces (heads Male_AverageWide, Female_AverageWide); owner approves a BiB gene on them as a try (express validation of the colonist change); PiT answered (read from files, not played): a BiB gene does NOT make VTE or VEFA draw (BiB has BiB_BodyVanilla and BiB_BodyWdi, body textures only, plus four face-pack genes, none for VTE or VEFA; BiB is not in `wsl-deps.gallery.map`); no head-type filter found in VTE or VEFA defs, so "wrong face type" is unproven; prove first with `[face-parts]` of Soren and Miel (ticket ffc3 scene E logs both; VEFA path starts `Things/Pawn/VanillaExperimental/`); if the parts are drawn, the problem is placement or look on the VTW head; steps to try after: `eyeballs are "EyeNormal"`, `lids are "LidCheerful"`, `face head shape is "HeadSquare"` (Soren) or `"HeadPointy"` or `"Beauty2"` (Miel), `face is held neutral`; changing the game head type has no step (TM request); on ffc3 RUN_DONE read the E logs, then edit B (and E), refile, replace 4 only if the faces read well
  - done 2026-11-22 (rate-gallery plus score-gallery after the 2c19 swap, session verdict): 1-dawn, 4-noon, 5-dusk, 6-night opened clean and subtitled, all four candidate (plan 5, image 4.5, adequacy 4.5, understanding 4.5, decoration 4.5); notes: eyes closed while listening (VEFA lids drawn), A seated instead of one step from the seat (partly), F profile instead of back (header updated); not verified: 268 px thumbnail check; open: owner validation of the whole gallery before mountPreview (`gallery_validated_sha` absent), then the stage move through replay-audit
  - done 2026-11-22 (ticket 4667 GREEN, E ACCEPTED, session verdict): `5-dusk.png` final replaced (clean original in Art/Gallery-clean, 1440 x 810, 256 colours; subtitle burned, line unchanged); `[render-rebuilt] Soren: worn 2, ApparelBody children 2`: the shirt was dropped by the saved apparel policy before, fixed by the step `follows an apparel policy that allows everything` (Soren, Miel); run folder deleted; A, B, E, F finals now all redone; open: faces and eyes plan (PiT), owner review of the whole gallery
  - open 2026-11-22 (gallery state, session verdict, replaces the dated lines of 2026-11-19 to 2026-11-22): finals accepted with subtitles burned and clean originals (1440 x 810, 256 colours): `1-dawn` (A, Nelim canon Roo_HD_Hair_Highpony reads as a top knot from the front, set by the step, not a defect), `4-noon` (B, ticket 8fd8: ring of three, trousers and shirt drawn, ponytail), `6-night` (F); `5-dusk` (E, ticket 4667: Soren shirt and trousers drawn); the scene B `sit` failure of tickets 3104 and de21 (same scenario version, red twice then green 8fd8) is an unexplained flake, TEMP end-condition log never fired and was reverted; owner review of 2026-11-22 (NOT a validation, `gallery_validated_sha` absent): Nelim hair in 1 and 6, Soren bare bottom and wrong faces and eyes in 4 and 5; 1, 4, 5, 6 are now redone; faces and eyes (Soren, Miel) still show the look without the dropped eyes mod; gallery hash not recomputed (`Get-GalleryHash.ps1` errored)
   - done 2026-11-22 (eyes plan, ticket ac05 GREEN 2 of 2, run folder deleted): with `sd.fa.movingvanillaeyes` (3753978140) back via `Tests/Pickle/wsl-deps.gallery-eyes.map` no Log.Error in Player.log, so nothing to send PiT; captures judged: B take Soren bare torso (worse than the accepted final), E take Soren blue shirt, eyes visible, Miel eyes closed, not clearly better; accepted finals stay; "the tree singing" 3 green (b650, 8fd8, ac05) and 2 red (3104, de21), unexplained flake; open: faces and eyes of Soren and Miel in the finals still show the look without the mod, owner review of the whole gallery
 - done 2026-11-22 (tickets 16c1, 84e9, af85 all GREEN, VTE and VEFA loaded, no Log.Error, `render-rebuilt` Soren worn 2 in B and E): A and F takes equal their finals; af85 B take: Soren shirt drawn, green eye open, Miel orange eyes, no bubble, but Shogun, squirrel and Z cut at the frame edge, so not clean; af85 E take: Soren and Miel eyes closed, no better; no take beats a final, finals 4-noon and 5-dusk stay, subtitles unchanged; run folders deleted; the scenario fixes (apparel policy in B, SocialRelax held in B and E) stay; "the tree singing" 6 green, 2 red (3104, de21, unexplained flake); open: faces and eyes of Soren and Miel in the finals still show the look without the eye mods, owner review of the whole gallery
 - open 2026-11-22 (VTE and VEFA eyes, SaB answer): VTE = VanillaExpanded.VTEXE.FacialAnims (2816938779), VEFA = sd.fa.movingvanillaeyes (3753978140, Moving Vanilla Eyes); the EyeGenes3 gene stays the colour, canon, no roster change; `wsl-deps.gallery.map` now carries vk.addeyes.EX, VEFA, Moshii.NLFA.InitFix, ccj.nlfaloadfix plus the seed `Tests/Pickle/config/gallery/Mod_3753978140_MovingVanillaEyesMod.xml` (enableBlushLimiting False); `wsl-deps.gallery-eyes.map` deleted; ticket 16c1 (A, B, E, F, evidence Tests/Pickle/Inbox/gallery-eyes2) filed: on RUN_DONE open the four captures, check the eyes drawn by VTE and VEFA, grep Log.Error, replace the finals only if a capture beats them (redo subtitles then), delete the run folder
 - open 2026-11-22 (owner, in chat): the eyes of the gallery pawns must be VTE and VEFA (today: gene colours Eyes_DarkBrown, Eyes_DarkGreen, Eyes_Orange from EyeGenes3, default eyeballs; neither is named in the scenario); CATALOG-REQUEST sent to Cat through TM to identify both mods (ids, DepMap lines, how an eye is chosen, NPT step); then 1, 4, 5, 6 are REDO on eyes (adequacy), refile after the answer; accepted finals stay until a capture beats them
 - done 2026-11-22 (rate-gallery plus score-gallery, session verdict): 1-dawn, 4-noon, 5-dusk, 6-night opened clean and subtitled, all four candidate (image and adequacy about 4), subtitles readable on one line and hide no subject; open notes: green rug strip at the frame edge in 1 and 6 (zoom 6 leaves the bare square), faces still neutral, owner review of the whole gallery before mountPreview
  - open: protocols read 2026-11-18 (f8fee9c): when all gallery captures are candidates (4 or more at score-gallery), run `rate-gallery` itself with the Skill tool (rule of 2026-11-19, AUDIT 9.e bis, GALLERY.md), no question to the owner; Preview at mountPreview uses the gallery block with `Art/Gallery-clean/` originals (STYLE_RIMWORLD.md)
  - open: 1.7 diagnostic closed 2026-11-17 (first run ff31: 18 of 24, six reds; cause = spawn cell of the plain `exists` step, not the mod, not 1.7; fixed by PiT step `exists near (x, z)`, 38f99e28; replays 7409 and b702 green, 0de3 green after the test-side fix);
  - open: 1.1.0 (RimWorld 1.7): the 1.7 install ships English only, so 1.7 passes are English and `tested_1_7: yes` holds for English only (AUDIT.md, 2026-10-13); `tested_1_7` not yet recorded; first diagnostic 9f17 not conclusive; the walk alone PASSED on 1.7 2026-11-07 (a538, net472 DLL, evidence p17-walk-repo4); still to play on 1.7: SaveSteps has no `net10.0` build (scenarios 03, 06 not reached); test the current `net472` DLL on 1.7 (Pickle on 1.7 and NPT/SB 1.7 prerequisites first, AUDIT.md); if it fails, add `1.7/` (`net10.0`) and a `<v1.7>` block in `LoadFolders.xml`; `<li>1.7</li>` in `supportedVersions`, version, `CHANGELOG.md` only after a green 1.7 run
  - unverified: user report 2026-10-08 (Markizo, Workshop): idle colonists did not visit an anima tree replanted in a gravship room; cause found (the giver skipped roofed trees), fixed in 1.0.3 (v1.0.3), reporter told on the Workshop page 2026-10-10 (stated by the owner), issue 1 closed; reporter confirmed on the Workshop page 2026-10-11 ("now it works just fine", relayed by the owner); his room being roofed stays unverified
  - unverified: after the 1.0.3 upload (2026-10-10): the public page re-read, description updated (DALL-E and the Replantable thanks show), four gallery slots shown; the content of images 1 to 3 on the page not compared with Art/Gallery; Markizo told and the Replantable thank-you posted (stated by the owner, 2026-10-10); non-regression English d3e2 green (27 of 37 passed, 0 failed, 10 skipped by @requires), French 5a3a green (27 of 37 passed, 0 failed), Phytokin dc8f stalled after 11 green (exit 3, a save load hung), replayed as 3926
session:      local_f0c91329-9f7d-466a-a59d-00d4fb78d1f2
updated:      2026-11-22, shootGallery[1.1.0] (replay: first open 9.a, B redo awaiting PiT answer on shirt and Paon)
protocols_read_sha: eb450c3abf107ca40f72982d8842800810dad94c
---

# Anima Song — status

Every former manual check of `TESTING.md` is now automated and green, or not applicable (table there, "What is
left of the manual checks"). Run-by-run history through 1.0.2 is in `git log` and the GitHub releases
(`Docs/runs/pickle.md` to come: one line per run).

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


## NSB (sync 2026-11-22, shootGallery[1.1.0])

Sync 2026-11-22 (NSB log since 2026-11-18, four commits): places docs unchanged; VALIDE.md gained one line (Jiro wardrobe photos kept as reference, Jiro not used); runs/pickle.md and status journals only; NSB steps.md gained two Given steps, `Nelim's Sanctuary: a colonist "Miel" exists as in the roster` and `... "Soren" exists as in the roster` (roster look, no apparel), plus `Nelim has her own face` now MouthLipsSmirk (not used by us). Nothing to change in shotlist or scenarios now; option after ticket 8fd8 RUN_DONE: replace the hand-built Miel and Soren blocks of scene B and E (`a colonist "X" of kind "Colonist" exists` plus gene, body, face steps) by the two roster steps, then dress as today.

Reads: Places read: 2026-11-22 Tribe read: 2026-11-22 Steps read: 2026-11-22 (NPT 11-20 to 11-21, nothing used by our scenarios: ClickDiagnostics `the open windows are logged`, `the buttons drawn are logged`; ScreenshotStudio `the animal X is made wild`, `is designated for taming`; ColonistRace `X turns toward Y` and `X faces the cell (x, z)`; StageDecor `the things on the area ... are logged`; earlier NPT 11-20: ScreenshotStudio lighting steps `the sun light of the map is dimmed to at most X, lamps kept`, `the glow of the lamps is scaled to N percent`, `the light at (x, z) is logged`, compiled not played, not used now, option if dusk or night brightness fails; NPT since 11-18: StageDecor blueprint cell step, kija clothes set, ColonistRace backstory fix: nothing we use). Sync 2026-11-18 (second, NSB log since 2026-11-17): places docs unchanged; new `RECONSTRUCTION-SAUVEGARDE.md` = plan only (rebuild of the Sanctuary save as `Nelims-tribe-v2`, nothing built, doors not passed: no change for our fixture `Nelims-tribe-decor-mods-z3` before it ships); VALIDE.md: Miel Aveline now validated (daily looks, 2026-11-17), Daichi and Dalia validated (babies, not used), Iori profile changes (not used); BiB gene renames (not used); NPT log since 2026-11-18: no change to steps.md or catalogues. Nothing to update in shotlist or scenarios (stage playTests, notes only); for shootGallery: Miel is now a validated alternative to Ryu for the ring of three (B, E), to weigh at write-shotlist.

Rules of 2026-11-05 applied. Owner, 2026-11-09: "reviens vers le sanctuaire". The invented companions (Flore, Soleil, Oren, Ysa) and the labrador Biscuit are dropped: they were written 2026-10-05 when NSB held one colonist; their only argument was visual contrast (robe and hair colours against the teal glow, three body types), which NSB colonists can give. Mod adds no animal (rule 5: nothing to show). Shotlist E (dusk, five listeners) is re-cast at write-shotlist with validated NSB colonists only (2026-11-09: Nelim, Soren, Ryu; re-cast 2026-11-18 after the SaB answer: Nelim, Soren, Miel Aveline, Ryu dropped because Thin Male trousers are not OK for VTW yet).

| Place | Shots | Changes for the gallery | Last read |
| --- | --- | --- | --- |
| `bare-clearing` (195, 152), zone libre | A, B, E, F (C, D UI) | tree grown by the mod, decor (stools, torch lamps, daylilies, anima grass) set and removed | 2026-11-09 (row only) |

| Colonist | Shots | Outfit | Last read of profile | Exceptions |
| --- | --- | --- | --- | --- |
| Nelim | A to F | robe and cape, dye chosen per shot (outfit, free) | not opened | none: played with her roster hair (`Roo_HD_Hair_Highpony`), the Bob and hair-colour overrides are dropped (rule 3) |
| Soren | B, E | validated daily: shirt #708090, vest #6B4F3A, trousers #3C4650 | VALIDE.md section read | none |
| Miel Aveline | B, E | validated daily "salopette" (VALIDE.md 2026-11-17): UnderWhere_Chestwrap #F0E8D6, VAE_Apparel_Overalls #C58A3A, VAE_Footwear_Boots #6B4F3A, VanityCase_LipstickCaramel; Thin Female body is a VTW go temporaire | VALIDE.md section and MIEL-PROFIL.md read 2026-11-18 | none: roster looks as written (SaB: validated and free) |
| Ryu "Blue" Sai | none (dropped 2026-11-18) | Thin Male trousers not OK for VTW, a shot of his trousers may change | VALIDE.md section read | none |

| Animal | Shots | Outfit | Last read | Exceptions |
| --- | --- | --- | --- | --- |
| Shogun (NSB labrador, Nelim's) | B, F | `Apparel_leatherdogcollar` by default | catalogue only | none |
| Hare, Squirrel (A, B) | A, B | none | n/a | wild or decor, not covered by rule 2 |

| Included animal (rule 5) | Shots |
| --- | --- |
| none: the mod ships no animal | n/a |

## Shotlist (2026-11-09, plan only, nothing played)

Header of `Tests/Pickle/Mod/Pickle/Features/05-workshop-captures.feature` holds the full lines. Director pass by an Opus sub-agent: kept the empty ring at dawn, the arrival instant (order given, screenshot 20 ticks after), Shogun lying, peacock and hare in the foreground, weather named, halo pulsing cut, zoom 4.5 instead of "low angle", F mirrored from A; dropped the "Soren leaves his seat" instant (no step), replaced by Nelim arriving last.

| # | Scene | a time | b decor | c living | d pawns | e action | f composition | g subject | j mod | plan |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A | dawn, opening | h6 Clear 20C, 20 ticks | 3 empty stools, grass, 4 daylilies, lit torch | hare front, squirrel | Nelim plum robe, ivory cape, smile | arrives one step from seat | zoom 6, tree off-centre, hare foreground | empty ring, tree waits | halo + ring | 5 |
| B | noon, lead | h12 Clear, 90 ticks | stools, torch, daylilies, grass | Shogun lying (Z), squirrel Noisette lying (peacock dropped 2026-11-22, cause unfound) | Nelim plum robe, Soren slate shirt, Miel cream wrap and orange overalls, smile | just sat, halo starts | zoom 5, tree off-centre | colonists ring, tree answers | halo + ring | 5 |
| E | dusk | h18 Clear | 2 lit torches, stools, daylilies | Shogun standing, yawning | Nelim, Soren, Miel, same outfits | Nelim arrives last | zoom 4.5, grass at frame edges | the day turns, glow | glow from afar | 5 |
| F | night, closing | h22 Clear | close torch, 2 empty stools | Shogun asleep | Nelim back to camera (no smile visible, reason written) | seated, tree beyond | zoom 6, mirror of A | sings after dark | glow vs torch | 5 |

k (series): one story, one day, hours 6 12 18 22; tight, medium, wide, tight; opening A, closing F, rhythm moves: ok. C and D: interface, set aside. Plan means 5 on 4 scenes, by the fixed rule, on paper; main risks: the arrival instant (timing of the screenshot, adjusted on the first run), night brightness (one test capture), a smile not visible from behind in F. Not verified: steps `the animal ... lies at ... facing` and `faces` exist in steps.md (read), their behaviour in this fixture (not played). Existing `Art/Gallery/1-the-tree-singing.jpg` (old cast Flore and Soleil) is stale for B: deleted when the scenario is rewritten (`git rm`, next step).

2026-11-18, writeShotlist: B and E recast Nelim, Soren, Miel (Ryu out), scenarios B and E rewritten in 05-workshop-captures.feature (Miel built as in NSB sanctuary-miel-wardrobe: Female, Thin, Female_AverageWide, GES_Skin_Chocolate, Hair_DarkBlack, Eyes_Orange, Roo_Royal_NaturalcurlsHD, SacredGrass tattoo, SkinEyeshadow, salopette look with Caramel lipstick), `wsl-deps.gallery.map` gains Malistaticy.UnderWhere and nelim.vanitycase (Pickle map only, no About.xml dependency); no director pass by an Opus sub-agent this time (plan of 2026-11-09 already passed it, only a pawn swapped); Check-ShotlistVsScenario OK, Check-Steps: every step resolves; score-gallery on the plan (no capture opened this run): A 5, B 5, E 5, F 5, k ok, mean 5; image notes of A and F stay the 2026-11-12 ones (4.5, candidates); risks: the arrival instant (screenshot timing), Miel orange eyes and eyeshadow may not show with SocialRelax at zoom 4.5 to 5, Thin Female body under VTW go temporaire; first ticket: B alone, then E, shootGallery next (9.0 bis gates: plan 5 done, scenarios written, drift check 0).
State: scenes A and F are candidates (tickets 9bea, 11fd green, score-gallery 4.5 and 4.5; 2026-11-18 Parked treated: captures resized to 1440 x 810 PNG under 2 MB into `Art/Gallery/1-candidate-dawn.png` (A) and `Art/Gallery/6-candidate-night.png` (F), final index of the series A to F = 1 to 6 (menus C and D now `2-` and `3-`, renumbered at rate-gallery), Parked emptied, run reports deleted; the full-size originals (1920 x 1080) are gone, a refused image is replayed); B and E (ring of three) wait for the SaB go on Soren and Ryu; robe proof: the cape shares the robe layer and hides it, capes removed from A, B, E, F.


## Ecosystem (PiI Steam search 2026-11-13, AUDIT 1.a and 8.0)

Detail: docs/inventory/ecosystem-steam/AnimaSong.md (`ecosystem-links` block added by PiI 2026-11-16: 15 rows, Phytokin 2927323805 parent, its French translation, 13 linked; no new search). No duplicate, fork or replacement: no other mod lets colonists listen to an anima tree sing (5441 folders scanned: only the Phytokin original 2927323805, its French translation, JoyRescue (ours) and our two items hold our defNames or label). Anima neighbours (VPE - Anima, Replantable Anima Trees, Anima Integration, Anima Tree Pet) are not competitors. Only Phytokin stays subscribed (compat pass 8.f); the 3 other study mods are unsubscribed. Replaces the local scan of 2026-11-12 (read only downloaded mods).

Second request, Phytokin variants (PiI, e4ad269, same file, section "Second request"): 8 Phytokin-based mods checked (More Phytokin Xenotypes, Archeankin, HarbingerKin - Phytokin, Phytokin Have Fathers, Anima Theme for VRE: Phytokin, VRE - Phytokin - Anima Theme, Mokas Phytokin have Natural Connection, Phytokin Vanilla Faces). None touches the anima song or our recreation, no shared defName, no duplicate. All 8 unsubscribed; only 2927323805 stays (compat pass 8.f).

Refresh 2026-11-19 (PiI, DELTA since 2026-11-13, same file, section "Refresh 2026-11-19"): Phytokin original 2927323805 unchanged (last update 2026-10-14); no fork, replacement, duplicate, patch or retexture since. Two translations of the original added to the `ecosystem-links` block: Russian 2927850559 (1.4 to 1.7) and Spanish 2938609408 (1.4, dead). Correction: the French pack 2927405383 was last updated 2026-10-05, not 2026-11-12. Translations of the original are not part of this mod's languages (English and French only); a Russian pack of ours would be a choice at the next `localize`, not owed now.

Owner decision 2026-11-20: the Phytokin translations RU 2927850559 and ES 2938609408 are dropped (red cross in the `ecosystem-links` block); our mod ships no Phytokin text, so nothing to integrate.

TM missions 2026-11-12 (items 0 to 24) read: items 8.k wording, 14 (.gitignore holds desktop.ini, Inbox, Parked, Evidence; Mod/desktop.ini kept), 15 (Art/ closed set, no echo.png), 23 done; TRANSLATION_REVIEW.md exists (f3e23d6); the 2026-11-07 review predates the page-header fix: Audit asked whether to rerun (item 2 vs 21b).

**2026-11-12, review-translation (page 1 of 1, ChatGPT, no correction) on d6f09c6 texts: validated by Virginie ("review validée"). translation_fr: complete stands.**
