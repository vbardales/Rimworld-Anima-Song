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

- *"the mod can be added to or removed from an ongoing game"*: **softened, 2026-09-27** (ticket `f0e3`,
  `docs/runs/2026-09-27.md`). A save taken while a colonist is actively running the mod's `JobDriver` crashes on every
  tick once the mod is removed: the game falls back to `Verse.AI.JobDriver` for a class it no longer knows, and that
  base class does not implement the toils. That is the game's own handling of any dropped mod's active job, not
  something this mod can guard against while it is still loaded. `About.xml` now says to stop a listener (draft or
  reassign) before removing the mod, the same as for any job a removed mod would leave stranded. The removal pass
  (`Tests/Pickle/Removal/Mod`) now saves with nobody mid-job, and is green (run `541a`, `docs/runs/2026-09-27.md`).
- *"Royalty is required … Without it the mod loads and adds nothing."* The `MayRequire` gates and the `Royalty/` load folder
  are read in the sources and the offline suite checks the gating; no pass has run without Royalty (a Pickle pass excludes
  only what the runner's mod list leaves out, and Royalty is in it).

## The new CI standards: adopted 2026-09-28 (CI/CD setup session, 2026-09-25), dry-run green

Adopted and pushed on 2026-09-28 (`0529c10`): the `## Steam description` block below, `About.xml`'s `<description>` generated
from it (`sync-about-description.mjs --write`, diff read: headings in normal case, links as Markdown links, nothing else), the
change note's first line `[b]1.0.0[/b]`, and the workflow regenerated from the current template `4e56bb5a2231` (69 tests pass).
Dry-run of that exact commit: run `36390961443`, green, log read (`STATUS.md`).

As it was written to do, kept for reference:

- **One source for the Workshop description.** Write it once, in Markdown, in a fenced block (```markdown, no code fence inside)
  under `## Steam description` of this file; its last line is `[Source code on GitHub](URL)`. The CI converts it to Steam BBCode and
  generates the plain-text `<description>` of `Mod/About/About.xml` from it, and every dry-run and publish stops if `About.xml`
  differs. Regenerate the workflow: `generate-publish-workflow.sh <repo> ... --description-markdown PUBLICATION.md
  --description-heading '^## Steam description$' --about-from-description --replace`, then `node .github/scripts/sync-about-description.mjs`
  reports the drift and `--write` rewrites only the `<description>` element: **read the diff** (the first write changes the
  text). Do not edit `.github/` by hand. It changes the SHA: a new dry-run, whose printed description is read by hand (the item
  is private, so there is no diff against the page).
- **The change note's first line carries the version**: `[b]1.0.0[/b]` or `[h3]1.0.0[/h3]`, or the CI refuses it. The block below
  starts with "First release." and has to be given that first line.
- `dispatch-publish.sh` now refuses without a reviewer and both secret names on `steam-production` (both are there).

## Steam description

The one source of the Workshop description (owner, 2026-09-25): the CI converts this block to Steam BBCode and generates the
plain-text `<description>` of `Mod/About/About.xml` from it, and every dry-run and publish stops if they differ. Written from the
`About.xml` text of 2026-09-27 with headings instead of capital lines and the links as Markdown links. No code fence inside;
the last line is the source link. 3.9 KB against Steam's 8000-byte limit.

```markdown
Colonists can go and listen to an anima tree sing, as recreation.

Vanilla Races Expanded - Phytokin has a lovely ability called anima song: a genetically gifted Phytokin points at an anima tree and makes it sing a psychic orchestra. It fires once a quadrum, and only for them.

This mod does not touch that ability. It adds a way to listen. Any colonist can walk out to an anima tree, sit down in a ring around it, and hear it sing — the way they would use a telescope or watch a television. The song comes from the tree, not from the pawn.

## What it looks like

While someone is listening, the tree wears a soft teal glow and a pulsing psychic halo, and sends a wave of light out to each listener — you can see from across the map that it is singing.

You do not have to wait for a colonist to decide on their own: select one, right-click the tree, and "Listen to the anima song" sends them out to sit. Select the tree instead and a toggle lets you allow or forbid listening entirely — turn it off to clear the ring before a psychic linking ritual, or when the tree grows somewhere you would rather your colonists did not sit. Anyone already listening gets up at once.

## Why this is worth a mod

The base game has ten recreation types and only four of them come from a building. Expectations ask for up to six different types, and tolerance is counted per type, not per building — a colonist who has played chess all week is just as tired of poker. An eleventh type is therefore worth far more than a tenth building of a type you already had. This one costs nothing to build: you only need an anima tree, which quietly rewards a tribal start.

Listening leaves a memory: +3 mood for a day, multiplied by psychic sensitivity, and it does not stack. That is deliberately weaker than Phytokin's own +8 over two days — theirs is a once-a-quadrum ability, this is repeatable.

## Soft dependencies

With Phytokin installed, the tree sings Phytokin's own recording, and the toggle wears their anima song icon. Without it, Royalty's anima linking sound and ritual icon are used instead. Nothing is copied from either mod, and no assembly is referenced: both are looked up by def name at runtime.

Royalty is required, since the anima tree is a Royalty plant. Without it the mod loads and adds nothing.

No save data of its own. The toggle and the song cooldown are stored on the tree, in the save; the mod can be added to an ongoing game freely, and removed from one too, as long as nobody is actively listening at the time — draft or reassign a listening colonist first, the same as you would stop any other job before dropping a mod that added it.

## If I go quiet

If I do not answer within a reasonable time after being contacted, anyone may freely update this or any other of my mods, including publishing a continuation of it. All credit must be preserved.

## AI-generated

This mod's code was written with Claude Code (Anthropic) and its preview image generated with an image model, under human direction and review. Stated openly: designing with these tools is my job.

## Thanks

Oskar Potocki, Sarg Bjornson and the Vanilla Expanded team, for Vanilla Races Expanded - Phytokin, whose anima song ability gave me the idea and whose recording the tree borrows when their mod is present. Their ability is not touched, patched or altered by this mod. If they would rather their assets were not called at all, say so and it stops.

Ludeon Studios, for the anima tree and for the psychic effects this mod reuses unmodified.

Claude Code (Anthropic).

Full attribution, including what was studied and what is looked up at runtime: [ATTRIBUTION.md](https://github.com/vbardales/Rimworld-Anima-Song/blob/main/ATTRIBUTION.md). Released under the MIT licence: [LICENSE](https://github.com/vbardales/Rimworld-Anima-Song/blob/main/LICENSE).

[Source code on GitHub](https://github.com/vbardales/Rimworld-Anima-Song)
```

## Release notes (the change note of each upload)

The change note sent to Steam with an upload, under the heading of its version: the manual workflow reads the block under
`### <version>` (`../PUBLISHING.md`, "Publier par la CI"), and the `## [<version>]` section of `CHANGELOG.md` goes into the
GitHub release. Limit 8000 bytes.

### 1.0.0

```
[b]1.0.0[/b]
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

Steam shows the first one large: put the most demonstrative there, not the prettiest. **Taken and approved, 2026-09-27.**
The three come from the Pickle feature `Tests/Pickle/Mod/Pickle/Features/05-workshop-captures.feature`, played on PickleTools'
Nelim zen meadow studio (run `a32d`, pass `studio`, revision `12e7f67`): an anima tree grown at (154, 98), the studio's own
colonists (Miel, Flore, Soleil), the game's screenshot mode on for the first image so that no interface shows. Each image
was opened and qualified by the owner before being committed. They are JPEG, 1920 x 1080, not cropped (converted from the PNG captures with ffmpeg `-q:v 3` on 2026-09-28: the PNGs were 4.6 to 4.9 MB and the Steam gallery refuses images over 2 MB; the JPEGs are about 740 KB, the interface text still sharp): `Art/WorkshopScreenshots/`,
named `01-…`, `02-…`, `03-…` in the order they go on the page, **and nothing else in that folder**: the folder is uploaded
as it is and is the `--gallery-dir` of the workflow (`../PUBLISHING.md`, "Images").

Owner's note on the first image: the camera at (154, 98) reads a little wide, not exactly where the three listeners end up
seated. Zoom in closer next time this scenario is redone; kept as approved for this version.

| # | File | Shows |
| --- | --- | --- |
| 1 | `01-the-tree-singing.jpg` | The tree singing, its halo up, three listeners nearby, no interface |
| 2 | `02-the-right-click-menu.jpg` | The right-click order on the tree, offered to a selected colonist |
| 3 | `03-the-tree-selected.jpg` | The tree selected, its **Allow listening** toggle in the gizmo bar, developer mode off |

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

## The 1.0.0 goes to production: by the owner, by hand

Neither the CI nor a session does these (`../PUBLISHING.md`, "Mise en production d'une 1.0.0"), and they are recorded in
`STATUS.md` (date, and the three points) before the stage is marked `published`:

1. change the item's visibility, private to public, after subscribing to it and testing the content she receives;
2. subscribe to the item's comments;
3. "Watch all activity" of the mod **and of its parent mods**: Vanilla Races Expanded - Phytokin (`2927323805`) and the
   Royalty page's owner is Ludeon (no Workshop page), so Phytokin.

The same day, for a public repository (`../PUBLISHING.md`, "Topics et image de partage GitHub"): the topics `rimworld`,
`rimworld-mod` and `mod` (`gh repo edit vbardales/Rimworld-Anima-Song --add-topic rimworld --add-topic rimworld-mod
--add-topic mod`) and the social preview image (`Mod/About/Preview.png`, set on the repository's Settings page: no API
sets it). **Checked 2026-09-25: the three topics are set, and the page carries a custom `og:image` on `repository-images.githubusercontent.com`; whether it is the current `Preview.png` was not compared.** Then the Phytokin thanks above.

## After the upload, and it cannot be undone

- **`Mod/About/PublishedFileId.txt` is committed and pushed** (done, `25751bc`): lost, the next upload creates a second item.
- **The item is private** until the owner switches it to public by hand, after subscribing to it and testing the content she
  receives. RimWorld and the CI never call `SetItemVisibility`.
- Check the public page (description, change note, images) and record the evidence in `STATUS.md`: a green GitHub release does
  not prove that Steam is up to date.
- Record the run ids and SHAs of the dry-run and of the publish in `STATUS.md`, then post the message above.
