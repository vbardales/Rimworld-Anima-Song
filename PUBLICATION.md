# Publication sheet

**Written 2026-09-24, fail-fast policy added 2026-09-25. The mod is at `done`; the stage is not `tested` yet (`STATUS.md`). The Workshop item exists
(`3806709272`, created by the 0.1.0 prepublication of 2026-09-23, private as Steam creates them) and
`Mod/About/PublishedFileId.txt` is committed (`25751bc`). What is still ahead: the items below marked TO DO, the manual
checks that lead to `tested`, the upload of 1.0.0 by the CI, the switch to public, and the one thanks.**
This sheet holds what the Workshop page asks for and the repository holds nowhere else, so that it can be used again at
the next update and by whoever picks the mod up.

This is an **update of an existing item**, not a first creation (`../PUBLISHING.md`, "Publier par la CI", and
`Rimworld-Release-Admin/docs/OPERATIONS.md`). Steam holds what the in-game prepublication sent on 2026-09-23; which commit
of `Mod/` that was is not recorded, and it certainly predates the halo's last fix (`c04edcc`, 2026-09-24). Version 1.0.0
therefore uploads a payload that differs from the one on the page: the DLL at least.

## Before the upload

- **Repository.** Working tree clean and pushed, and the distributed DLL matches the sources: rebuild
  `dotnet build Source/AnimaSong.csproj -c Release` and compare the SHA256 of `Mod/Assemblies/AnimaSong.dll` with the
  committed one. Rebuilt on 2026-09-25 at `43f9092`: identical, SHA256 `4A61285D…65E4` (built from `Source/`, glow included).
- **Publication policy: fail fast** (owner, 2026-09-25; `../PUBLISHING.md` "À chaque mise à jour", `../AUDIT.md` step
  `prepublished -> published`; the model is `../WorkStudio/PUBLICATION.md`). Publish after the dry-run of the exact commit and
  the owner's approval of `steam-production`, **then** let the Pickle tests still open speak; if one comes back red, roll
  back and, later, fix. **What fail fast skips is only the wait for the game runs still queued behind other sessions.** It
  does **not** skip, and both are **indispensable before the publish is launched** (owner, 2026-09-25):
  1. **the Workshop gallery**: the images of the page are taken, opened and put in `Art/WorkshopScreenshots/` first;
  2. **the owner's manual validations** of `TESTING.md` (the halo drawn on screen, the song heard, Phytokin's own ability
     soothing, `baseChance`, removing the mod from a save, the French pane, a real click), their results written in the table
     of that file and in `STATUS.md`.
  The item stays private after the upload until the owner switches it to public herself; the gates of the pipeline do not
  move: dry-run, full SHA, only Virginie approves. **Both are open on 2026-09-25**, so the `publish` of the dry-run of
  `7ef3894` is not launched.
- **Rollback target, chosen with the owner on 2026-09-25: switch the item back to private.** There is no earlier good
  version to publish again (`v1.0.0` will be the first tag, and the item holds only the 0.1.0 prepublication content, which
  predates the halo fixes), so a red result on the published 1.0.0 is answered by **hiding it, not by uploading an older
  build**: the owner sets the item's visibility back to private by hand on the Steam page (RimWorld and the CI never call
  `SetItemVisibility`, so neither can do it), a session records the red result as a defect of 1.0.0 in `STATUS.md` and
  `docs/runs/`, and the fix is a later publication of its own, made public again only once its tests are green. Nothing
  reaches players while the item is private, which is why this is enough for a first version. Once 1.0.0 is uploaded and
  tagged, **its tag is the rollback target of the next update**, and this choice is made again then.
- **Still open after the publication**, to run right after it in small tickets (the only part fail fast lets wait): a final
  full pass on the published commit (English, French, Phytokin; the last full runs predate the glow and the right-click
  scenario). Already green on the build with the glow: the halo scenarios (3 of 3, 2026-09-25), the tree's interface in
  French, the ring and halo capture, the right-click menu in its three states.
- **CHANGELOG.** `## [1.0.0] — 2026-09-25`, dated (the dry-run needs it): the release notes of the GitHub release are that
  section. The tag `v1.0.0` and the release are created **by the CI after a successful upload**, on the exact SHA it
  uploaded, never by hand.
- **The workflow, written 2026-09-25, is what dispatches.** It comes from
  `Rimworld-Release-Admin/scripts/generate-publish-workflow.sh` (the single source), run from the mod repository with
  `--workshop-id 3806709272 --package-id nelim.animasong --release-title "Anima Song {version}" --require Assemblies/AnimaSong.dll --gallery-dir Art/WorkshopScreenshots`
  (the DLL sits at the root of `Mod/`, no `1.6/` folder; the gallery folder does not exist yet and only lists images in the
  dry-run as a reminder). It wrote `.github/workflows/publish-tag.yml`, `script-tests.yml`, `.github/scripts`,
  `.github/tests` and `publish.config.json`; its 49 tests pass locally (`node --test .github/tests/*.test.mjs`). The GitHub
  environment `steam-production` exists with a reviewer and the two secrets (`STEAM_USERNAME`, `STEAM_CONFIG_VDF_B64`),
  read-only check of 2026-09-25. Once it is on `main`: `dry-run` first, on the exact commit, its log read for the
  `publish template:` and `options:` lines; the run id and the SHA go into `STATUS.md`. `publish` takes the full
  40-character SHA (`Rimworld-Release-Admin/scripts/dispatch-publish.sh vbardales/Rimworld-Anima-Song publish-tag.yml <SHA> 1.0.0`,
  which refuses without a green dry-run of that SHA); **only Virginie approves `steam-production`**. The dry-run also needs
  `## [1.0.0]` in `CHANGELOG.md` to be dated, the change note below to be a fenced block under `### 1.0.0`, and no tag
  `v1.0.0`. **Any commit after the dry-run changes the SHA and needs a new one**: the workflow and the dated CHANGELOG are
  in the commit that is dry-run, so nothing is left to add before it.
- **The CI sends `Mod/`** (everything in it: `About`, `Assemblies`, `Defs`, `Languages`, `Patches`, `Royalty`,
  `LoadFolders.xml`, `ATTRIBUTION.md`, `LICENSE`; there is no `.steamignore` and nothing else to exclude). Its four opt-in
  inputs, `update_preview`, `update_description`, `update_title`, `update_tags`, are **off by default and left off unless
  Virginie asks**; visibility is never sent. So the description and the images below stay hand work on the Steam page,
  unless she turns `update_preview` (the current `Preview.png`) or `update_description` on for that dispatch.

## The description: sent once, current text unverified

`SetItemDescription` ran once, with the 0.1.0 prepublication, so what is in `Mod/About/About.xml` is what the page says
until someone edits it by hand, **if** the page received the layout of today. It was reordered before the prepublication to the
prepublished layout: the body, `IF I GO QUIET` with the adoption clause verbatim, `AI-GENERATED`, `THANKS`, the pointer to
`ATTRIBUTION.md` with the licence, and `[url=…]Source code on GitHub[/url]` last. **TO DO: open the public page once the item
is public and compare it with `About.xml`**; a difference is fixed by hand on the page (an edit of `About.xml` does not reach
it), and `About.xml` should say the same because it is what the mod list shows in game.

Two claims in it to keep true, rather than change:

- *"the mod can be added to or removed from an ongoing game"*: it is a design argument (no save data of its own beyond
  a toggle and a cooldown stored on the tree), and the removal half has **not been played**. Soften it if the owner's manual
  check does not confirm it.
- *"Royalty is required … Without it the mod loads and adds nothing."* The `MayRequire` gates and the `Royalty/` load folder
  are read in the sources and the offline suite checks the gating; no pass has run without Royalty (a Pickle pass excludes
  only what the runner's mod list leaves out, and Royalty is in it).

## Release notes (the change note of each upload)

The change note sent to Steam with an upload, under the heading of its version: the manual workflow reads the block under
`### <version>` (`../PUBLISHING.md`, "Publier par la CI"), and the `## [<version>]` section of `CHANGELOG.md` goes into the
GitHub release. Limit 8000 bytes.

### 1.0.0

```
First release. Colonists can walk out to an anima tree, sit in a ring around it and listen to it sing, as a new kind of
recreation: up to six at once, outdoors, in sight of the trunk. Listening leaves a memory (+3 mood for a day, scaled by
psychic sensitivity, not stacking). While anyone listens the tree wears a soft teal glow and a pulsing psychic halo and sends a wave of light to
each listener. Right-click the tree with a colonist selected to send them, or select the tree and use its toggle to forbid
listening (the ring clears at once). With Vanilla Races Expanded - Phytokin the tree sings their recording and the toggle
wears their icon; without it, Royalty's. Phytokin's own ability is not touched. Requires Royalty. RimWorld 1.6, English and
French.
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

Steam shows the first one large: put the most demonstrative there, not the prettiest. **TO DO: none taken yet.** The
Pickle captures of 2026-09-21 were pruned (they were of a build without the halo fix and rendered in software) and the headless
game cannot say whether the halo's distortion shader is drawn, so the first image, the one that shows the song, has to be
taken on a game that draws it: the owner's photographic colony (`nelim-zen-meadow-studio`, package
`nelim.pickletools.screenshotstudio`) with an anima tree and a ring of listeners, or her own game. Each image is opened before
it is uploaded, against what it is meant to show. The page is English, so the English shots are the ones to use; they go
under `Art/WorkshopScreenshots/`, named so that their alphabetical order is the order of the page (`1-…`, `2-…`).

Proposed order: 1. the tree singing, its halo up, listeners seated in the ring with the waves of light; 2. the right-click
order on the tree with a colonist selected (the menu entry, and one greyed out with its reason); 3. the tree selected with
its **Allow listening** toggle in the gizmo bar.

## The preview image

`Mod/About/Preview.png` (896 × 504, opened 2026-09-24): the title, its summary, a glowing anima tree at night with six
colonists seated in a ring and a thin line of light from the trunk to each. It is an image-model illustration under human
direction, and says so in `AI-GENERATED`. The CI does not send it unless `update_preview` is turned on: **either Virginie turns
it on for the dispatch, or the image is set by hand on the Steam page.** `Mod/About/ModIcon.png` (the mod list's own icon)
was opened too.

## Content boxes (adult content, violence)

The `Preview.png` and the `ModIcon.png` were opened on 2026-09-24. Neither shows nudity, gore or anything sexual: seated
figures in dark clothing in the first, a stylised smiling face in the second. Answer **no adult content**. Re-answer only after
opening any image added later, because the boxes commit the page.

## Thanks to post, after the item is public

A link to a private item opens for nobody, so post only once it is public. One recipient, under 1000 characters, BBCode
allowed. The registry (`../WORKSHOP_COMMENTS.md`) is the source of truth for whether a recipient already has a main comment:
**Phytokin (`2927323805`) was absent, and a `drafted` row was added there on 2026-09-24** that covers this mod. Royalty and
Ludeon Studios have no page on which a comment can be left for a DLC: `not_applicable`. Claude Code (Anthropic) is a tool,
not a recipient. The item link is `https://steamcommunity.com/sharedfiles/filedetails/?id=3806709272`.

**Oskar Potocki, Sarg Bjornson and the Vanilla Expanded team, on Vanilla Races Expanded - Phytokin**
(`https://steamcommunity.com/sharedfiles/filedetails/?id=2927323805`), comment page (705 characters):

```
Thank you so much for Phytokin ✨ Your anima song ability, a Phytokin pointing at an anima tree and the whole tree singing a
psychic orchestra, is the reason I made Anima Song 💛 It adds a way for anyone to sit down and *listen* to a tree: a ring of
colonists, a glowing halo, a small memory at the end, deliberately much weaker than yours. Your ability is not touched,
patched or altered, and with Phytokin loaded the tree borrows your recording and your icon, looked up by def name at run
time, nothing copied or shipped. Credited in its attribution file. If you would rather your assets were not called at all,
tell me and it stops. https://steamcommunity.com/sharedfiles/filedetails/?id=3806709272
```

The message is not posted; posting to another author's page is the owner's act. When it is, the registry row goes to `posted`
with the date.

## After the upload, and it cannot be undone

- **`Mod/About/PublishedFileId.txt` is committed and pushed** (done, `25751bc`): lost, the next upload creates a second item.
- **The item is private** until the owner switches it to public by hand, after subscribing to it and testing the content she
  receives. RimWorld and the CI never call `SetItemVisibility`.
- Check the public page (description, change note, images) and record the evidence in `STATUS.md`: a green GitHub release does
  not prove that Steam is up to date.
- Record the run ids and SHAs of the dry-run and of the publish in `STATUS.md`, then post the message above.
