# Publication sheet

This mod is **published** (`STATUS.md`: 1.0.0 through 1.0.2, item public since 2026-09-29). This sheet holds what the
Workshop page asks for and the repository holds nowhere else, so it can be used at the next update. Full history of how
it got here: `git log` and the GitHub releases (`docs/runs/README.md`).

## How to publish an update

**Mode: the CI** (public mod; `../PUBLISHING.md`, "Deux modes de publication"): `publish-tag.yml`, a dry-run of the exact commit, `publish` with the 40-character SHA, `steam-production` approved by Virginie alone.

1. Rebuild (`dotnet build Source/AnimaSong.csproj -c Release`), commit, push. Any `Mod/` change (including the
   generated `<description>`, via `node .github/scripts/sync-about-description.mjs --write`) needs a fresh dry-run.
2. `gh workflow run publish-tag.yml -f mode=dry-run -f ref=<SHA> -f version=<x.y.z> [-f update_description=true]`; read
   the log, not only the tick (staged files, change note, description if sent, `DRY RUN: nothing was sent to Steam`).
3. `Rimworld-Release-Admin/scripts/dispatch-publish.sh vbardales/Rimworld-Anima-Song publish-tag.yml <SHA> <version>
   [--description]`; refuses without a green dry-run of that exact SHA. **Only Virginie approves `steam-production`.**
4. After a successful upload the CI creates the tag and GitHub release; the gallery and visibility stay manual, hers.
5. Record the run ids, SHA and what SteamCMD said in `STATUS.md`.

**The CI sends all of `Mod/`** (`About`, `Assemblies`, `Defs`, `Languages`, `Patches`, `Royalty`, `LoadFolders.xml`,
`ATTRIBUTION.md`, `LICENSE`; no `.steamignore`). Its four opt-in inputs (`update_preview`, `update_description`,
`update_title`, `update_tags`) are off by default; visibility is never sent.

**Rollback target:** switch the item back to private by hand (owner, 2026-09-25); no earlier good version exists to
republish instead. Once a version is tagged, that tag becomes the rollback target of the next one.

## Steam description

The one source of the Workshop description (owner, 2026-09-25): the CI converts this block to Steam BBCode and generates the
plain-text `<description>` of `Mod/About/About.xml` from it, and every dry-run and publish stops if they differ. Written from the
`About.xml` text of 2026-09-27 with headings instead of capital lines and the links as Markdown links. No code fence inside;
the last line is the source link. 3.9 KB against Steam's 8000-byte limit.

```markdown
Colonists can go and listen to an anima tree sing, as recreation.

[Vanilla Races Expanded - Phytokin](https://steamcommunity.com/sharedfiles/filedetails/?id=2927323805) has a lovely ability called anima song: a genetically gifted Phytokin points at an anima tree and causes a psychic orchestra to play. It is available only to Phytokin, once per quadrum.

This mod does not touch that ability. It seemed a shame to leave such a lovely effect locked to a genetically gifted colonist and usable only once a quadrum, so here is the toned-down, repeatable version everyone can use: any colonist can walk out to an anima tree, sit down in a ring around it, and hear it sing, the way they would use a telescope or watch a television. The song comes from the tree, not from the pawn.

## What it looks like

While someone is listening, the tree wears a soft teal glow and a pulsing psychic halo, and sends a wave of light out to each listener: you can see from across the map that it is singing.

You do not have to wait for a colonist to decide on their own: select one, right-click the tree, and "Listen to the anima song" sends them out to sit. Select the tree instead and a toggle lets you allow or forbid listening entirely: turn it off to clear the ring before a psychic linking ritual, or when the tree grows somewhere you would rather your colonists did not sit. Anyone already listening gets up at once.

## Why this is worth a mod

The base game has ten recreation types and only four of them come from a building. Expectations ask for up to six different types, and tolerance is counted per type, not per building: a colonist who has played chess all week is just as tired of chess whether the colony owns one table or ten. An eleventh type is therefore worth far more than a tenth building of a type you already had. This one costs nothing to build: you only need an anima tree, which quietly rewards a tribal start.

Listening leaves a memory: +3 mood for a day, multiplied by psychic sensitivity, and it does not stack. That is deliberately weaker than Phytokin's own +8 over two days: theirs is a once-a-quadrum ability, this is repeatable.

## Soft dependencies

With Phytokin installed, the tree sings Phytokin's own recording, and the toggle wears their anima song icon. Without it, Royalty's anima linking sound and ritual icon are used instead. Nothing is copied from either mod, and no assembly is referenced: both are looked up by def name at runtime.

Royalty is required, since the anima tree is a Royalty plant. Without it the mod loads and adds nothing.

Only the listening toggle and the song cooldown are stored on the tree in the save; the mod can be added to an ongoing game freely, and removed from one too, as long as nobody is actively listening at the time: draft or reassign a listening colonist first, the same as you would stop any other job before dropping a mod that added it.

## If I go quiet

If I do not answer within a reasonable time after being contacted, anyone may freely update this or any other of my mods, including publishing a continuation of it. All credit must be preserved.

## AI-generated

This mod's code was written with Claude Code (Anthropic) and its preview image generated with DALL-E (OpenAI), under human direction and review. Stated openly: designing with these tools is my job.

## Thanks

Oskar Potocki, Sarg Bjornson and the Vanilla Expanded team, for [Vanilla Races Expanded - Phytokin](https://steamcommunity.com/sharedfiles/filedetails/?id=2927323805), whose anima song ability gave me the idea and whose recording the tree borrows when their mod is present. Their ability is not touched, patched or altered by this mod. If they would rather their assets were not called at all, say so and it stops.

Ludeon Studios, for the anima tree and for the psychic effects this mod reuses unmodified.

Kaetie_, who continues [Replantable Anima Trees (Continued)](https://steamcommunity.com/sharedfiles/filedetails/?id=3503586725), and Dark Passerida, who made the [original](https://steamcommunity.com/sharedfiles/filedetails/?id=2586765823): with their mod loaded, colonists can still listen to a replanted anima tree, as verified by the test suite. Nothing of theirs is used, patched or required.

[Pickle](https://steamcommunity.com/sharedfiles/filedetails/?id=3791648678) and [Nelim's Pickle Tools](https://steamcommunity.com/sharedfiles/filedetails/?id=3806142401) were used for development and testing only; neither is a dependency of the distributed mod.

Full attribution, including what was studied and what is looked up at runtime: [ATTRIBUTION.md](https://github.com/vbardales/Rimworld-Anima-Song/blob/main/ATTRIBUTION.md). Released under the MIT licence: [LICENSE](https://github.com/vbardales/Rimworld-Anima-Song/blob/main/LICENSE).

[Source code on GitHub](https://github.com/vbardales/Rimworld-Anima-Song)
```

## Release notes (the change note of each upload)

The change note sent to Steam with an upload, under the heading of its version: the manual workflow reads the block under
`### <version>` (`../PUBLISHING.md`, "Publier par la CI"), and the `## [<version>]` section of `CHANGELOG.md` goes into the
GitHub release. Limit 8000 bytes.

Earlier sent notes (1.0.0–1.0.2): the tagged commits `v1.0.0`–`v1.0.2` and their GitHub releases. **A description-only
change is not a minor bump**: 2026-09-29's Workshop-link and Thanks-wording edits went straight onto the Steam page
by hand, no note, no tag (`CHANGELOG.md`, "Workshop page text, 2026-09-29").

Next upload, `1.0.3` (above the tag `v1.0.2`; never published before). `Mod/` changed (two images, French/English texts, and `Mod/Defs/AnimaSong.xml` for the roofed-tree fix), so the dry-run of the exact commit comes first, then Virginie approves `steam-production`. `CHANGELOG.md` carries the 1.0.3 changes under `## [Unreleased]` (numbered and dated only just before the dry-run) (a roofed-tree fix of 2026-10-09 is folded in). The gallery is uploaded manually; the description is sent through CI or updated manually, as decided at `prepareRelease`.

### 1.0.3

```
[b]1.0.3[/b]

[list]
[*] French: the listening memory, the "Allow listening" tooltip and the "full" refusal no longer assume the gender of the colonist, and read more naturally. English: the "full" refusal is clearer.
[*] Colonists now go and listen on their own to an anima tree that has a roof over it (for example in a gravship room). Before, only the manual order worked there.
[*] New ModIcon and a refreshed header image.
[/list]
```

## Dependencies and DLC

Checked in the sources on 2026-09-24, not from intention.

- **Royalty: hard, declared** in `modDependencies` (`Ludeon.RimWorld.Royalty`; no Workshop URL, it is a DLC). The tree is a
  Royalty plant, the patch grafts the component onto it, and the job and the joy kind carry `MayRequire`.
- **Vanilla Races Expanded - Phytokin, Oskar Potocki, Sarg Bjornson and the Vanilla Expanded team,
  `vanillaracesexpanded.phytokin`, Workshop `2927323805`: soft, `loadAfter` only.** The code reads the sound
  `VRE_AnimaSongSound` and the texture `UI/Abilities/AnimaSong` by def name (`GetNamedSilentFail`), never an assembly. Pass B of
  the Pickle suite, with Phytokin (and Vanilla Expanded Framework, `2023507013`, which Phytokin itself needs) staged, is
  green; the bare pass falls back to Royalty's sound and icon and is green too. Vanilla Expanded Framework is **not** a
  dependency of this mod and is not declared.
- **DLC: Royalty only.** `supportedVersions` is `1.6`; `LoadFolders.xml` has one branch, `IfModActive="Ludeon.RimWorld.Royalty"`
  for the French DefInjected files of the two Royalty-gated defs. Every Pickle pass runs on Core plus the five DLC, which
  shows the mod does not object to them, not that it needs them.
- **Incompatibilities: none declared** (`incompatibleWith` absent, and neither README nor CHANGELOG claims one).
- **Not checked from here:** whether the Phytokin page lists a 1.6 build; its `About.xml` was verified on disk (declares
  1.6, the `packageId` is the one the step reads).

## Captures for the Workshop page

Steam shows the first one large: put the most demonstrative there, not the prettiest. The images of `Art/Gallery/` are the ones of the 2026-10-10 redo (below), JPEG 1920 x 1080 (converted from the PNG captures: the Steam gallery refuses images over 2 MB), named `1-…`, `2-…`, `3-…` in the order they go on the page after `0-preview.png` (see "The preview image"), **and nothing else in that folder**: the folder is uploaded as it is and is the `--gallery-dir` of the workflow (`../PUBLISHING.md`, "Images"). The gallery upload stays manual, the owner's.

| # | File | Source | Shows |
| --- | --- | --- | --- |
| 0 | `0-preview.png` | Copy of `Preview.png` (`../PUBLISHING.md`, "Images") | The header image |
| 1 | `1-the-tree-singing.jpg` | Backlot `bare-clearing`, run `342d` | The tree singing, its halo up, three listeners seated on stools in a ring, no interface |
| 2 | `2-the-right-click-menu.jpg` | Backlot, run `19c9` (20 degrees) | The right-click order on the tree, offered to a selected colonist |
| 3 | `3-the-tree-selected.jpg` | Backlot `bare-clearing`, run `4e27` | The tree selected, its **Allow listening** toggle in the gizmo bar, developer mode off |

## The preview image

`Mod/About/Preview.png` (896 × 504, regenerated 2026-10-05, opened 2026-10-07): the title, its summary, a glowing anima tree at night
with five colonists seated in a ring and a thin line of light from the trunk to each, and the ModIcon (a winking orange face) in the
bottom-left corner. It is an image-model illustration under human direction, and says so in `AI-GENERATED`. The CI does not send it
unless `update_preview` is turned on: **either Virginie turns it on for the dispatch, or the image is set by hand on the Steam page.**
`Mod/About/ModIcon.png` (128 × 128, the mod list's own icon, regenerated from the owner's new `Art/ModIcon-source.png`) was opened too.

**The ModIcon rides in the bottom-left corner** (owner's rule, 2026-09-29, `../PUBLISHING.md` "Images"): the `iconBadge` of `Art/Preview.config.json`, drawn by the shared renderer from `Art/ModIcon-source.png` (see `preview-workflow.md`). Bottom-left was chosen as the scene's emptiest corner (no listener silhouette there). `Art/Gallery/0-preview.png` is recopied whenever `Preview.png` is regenerated, or the two diverge silently.

## Content boxes (adult content, violence)

The `Preview.png` and the `ModIcon.png` were opened again on 2026-10-07 (both regenerated 2026-10-05). The Preview shows seated figures in dark silhouette; the ModIcon shows a stylised winking face. The three gallery images were opened on 2026-10-10 and show a tree, three listeners in robes and the interface. None shows nudity, gore or sexual content. Answer **no adult content**. Re-answer only after
opening any image added later, because the boxes commit the page.

## Thanks, posted

**Oskar Potocki, Sarg Bjornson and the Vanilla Expanded team, on Vanilla Races Expanded - Phytokin**
(`https://steamcommunity.com/sharedfiles/filedetails/?id=2927323805`), posted 2026-09-29 (`../WORKSHOP_COMMENTS.md`,
row now `posted`). Royalty and Ludeon Studios have no page on which a comment can be left for a DLC: `not_applicable`.

## Going to production: done, kept as a checklist for the next mod

By the owner, by hand, neither the CI nor a session (`../PUBLISHING.md`, "Mise en production d'une 1.0.0"): switch
visibility private → public after subscribing and testing the content received; subscribe to the item's comments;
"Watch all activity" of the mod and of its parent mods (Phytokin `2927323805`; Royalty has no Workshop page). For the
GitHub repository: topics `rimworld`, `rimworld-mod`, `mod`, and the social preview image set by hand on the
repository's Settings page (no API for it). **Done 2026-09-25/29** for this mod; `PublishedFileId.txt` committed
(`25751bc`), topics set, item public.

**After any upload:** check the public page (description, change note, images) and record it in `STATUS.md`: a
green GitHub release does not prove Steam is up to date.

## The gallery, redone as staged photographs (done 2026-10-10)

`../PUBLISHING.md` (rule of 2026-10-02): every gallery picture is a staged photograph, **except the menus**; the session directs the whole series (`../GALLERY.md`). For this mod:

- **Picture 1** (the tree singing) is staged; pictures 2 (the right-click menu) and 3 (the tree selected, with its gizmo) are interface screenshots, not staged.
- **The scene** is `bare-clearing` of the Sanctuaire de Nelim (the podium square without its green rug, brown earth), played in `SanctuaryBacklot` with `-DepMap wsl-deps.sanctuary.map`; the camera is framed on the tree at zoom 5, the map held at 20 degrees so nobody sweats or blushes.
- **The subjects:** Nelim, the owner's own colonist and the protagonist of the Sanctuaire, is the first listener, with two invented companions (Flore, Soleil: body type, hairstyle, hair colour, dyed robe), a lit torch lamp and daylilies as set. The three sit on stools set by StageDecor, each placed with `stands at ... facing` (a listener does not sit on a bare cell: the driver sets no seated posture). Run `176a` had Nelim facing North, her back to the tree: refused; `342d` (facing South) accepted.
- **Picture 3** hides what the selected tree draws: its `FocusStrengthOffset_ArtificialBuildings` has a radius of 27.9 cells and the tree draws a red line to every artificial building inside it, so the scenario hides the artificial buildings within 30 cells (which also makes roofs collapse: the letters and alerts are cleared before the shot), the colonist bar, the vanometric cell, and clears the messages. The gizmo label "Begin liaison d'arbre anima" (not this mod's: French text in an English pass, maker unknown) stays, accepted by the owner.
- **Candidates and sizes:** a candidate is named `<n>-candidate-<name>`, under 2 MB each and 8 MB for the folder; accepted: `candidate` dropped; refused: deleted. The folder is about 2.4 MB.
- **At the publish (owner, 2026-10-08): send the preview image again.** The 1.0.x dispatch carries `update_preview=true` (`dispatch-publish.sh ... --preview`), so `Mod/About/Preview.png` replaces the header image on the Steam page. The gallery stays a manual upload. The description changed since 1.0.2 (the Replantable Anima Trees thanks): sent with `update_description=true`, or pasted by hand, the owner decides at `prepareRelease`.
## Thanks, posted 2026-10-10

Posted by the owner on 2026-10-10 (stated by her), after the 1.0.3 update was public and Markizo's report was closed. One message, on the Continued page, crediting the maintainer and the original author (`../WORKSHOP_COMMENTS.md`, row `3503586725`, `posted`).

```
Hi Kaetie_ and Dark Passerida: thank you for [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3503586725]Replantable Anima Trees (Continued)[/url] (and for the [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2586765823]original[/url]). A player of my mod Anima Song (colonists sit around an anima tree and listen to it sing) used yours, so I tested the two together: a replanted tree keeps its listening toggle and colonists still go to it. Nothing of yours is used, patched or required, it just made me check :) Have a nice day!
```

- **Image 3 replaced (session as director, 2026-10-10)**: `3-the-tree-selected.jpg` is now the JPEG copy (412 KB, quality 88) of run `4e27` (`pickle-run-2026-10-10-gallery3f`, Backlot `bare-clearing`). The selected tree draws red focus lines to every artificial building within 27.9 cells (its `FocusStrengthOffset_ArtificialBuildings`), so the scenario hides them (`the artificial buildings within 30 cells ... are hidden`, which also makes roofs collapse: the letters and alerts are cleared before the shot), hides the colonist bar and the vanometric cell, and clears the messages. The gizmo label "Begin liaison d'arbre anima" (not this mod's, French text in an English pass) stays, accepted by the owner. It is a UI screenshot, not staged.
