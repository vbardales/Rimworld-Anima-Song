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
stage:        done
licence:      original
licence_at:   Original creation by Nelim; MIT in LICENSE and Mod/LICENSE, copyright (c) 2026 Nelim; credits in ATTRIBUTION.md
dependencies: declared
showcase:     complete
tested_on:
workshop:     3806709272
remaining:
  - defect: the halo lives less than one tick - measured 2026-09-21 (tick by tick, mote state read each tick): the mote is alive only on a tick sampled after the job's ping (age 0), and destroyed on every sample taken at age 1 or more, in view or not (camera off the tree: alive 19, destroyed 281 of 300, pings every 15 ticks; camera on it: alive 300 of 300 when sampled at age 0, and an earlier run sampled at age 1 found it up on 0 of 300). Reading: CompAnimaSong.NotifyListening calls Maintain() only in the branch where the mote already exists, so a fresh mote is never maintained and dies at its first tick, then the next ping makes another; it is never visible because its fade-in restarts every tick. Fix committed 2026-09-21 (b8d7f25: Maintain() right after the mote is made); its six scenarios are queued and have no result yet
  - unverified: Pickle suite, pass A in English and in French - 9 of 10 scenarios green in each, the tenth being the halo above; captures opened, no image yet proves the halo visible
  - unverified: Pickle pass B in French, and Phytokin's own VRE_AnimaSong ability still working beside the mod (TESTING.md scenario 11, pass B) - pass B ran in English only and does not exercise their ability
  - unverified: the fourteen scenarios of TESTING.md - two played whole (1, 5) and seven in part by the Pickle suite in the headless game (table in TESTING.md), four not played (3, 9, 10, 14), one faulty and fixed but not confirmed (4); none has been played by a person on the Windows game
  - unverified: the halo, maintained tick by tick by the job, at 3x speed
  - unverified: English and French in-game display of every inventoried text, including all four refusal reasons and the memory stage handle; TESTING.md scenario 13
session:      local_5e30f42a-ec8b-4932-9f21-00964209cc65
updated:      2026-09-23, suite reviewed and fixed (25 scenarios, none of the new ones run), docs/runs added
---

# Anima Song — status

## Review of the suite, and what changed — 2026-09-23

A review of the Pickle work found eight things; the ones that mattered are fixed and none was run yet.
- **Five halo scenarios could never be green**: they read the halo with the camera on the base, where the job pings once
  every 15 ticks and the mote dies the tick after each ping, whatever the mod does. Replaced by three scenarios (1x, 3x,
  15x) that put the camera on the tree first. The off-screen behaviour stays recorded here as an observation, not as a
  failing test. The frame-sampled halo steps are removed.
- **A timeout hid its own message**: `WaitUntil` throws, so the assertion after it never ran. Seven waits now go through
  one helper that fails with where the pawn stands and what it is doing.
- **The cooldown note could read too early** (before the first song): it now waits until the tree is singing.
- Smaller: a missing null check on a reflected field, "tree in view" read once instead of per tick, two copy-pasted
  helpers merged, and the text check compares key sets instead of a hard-coded count of ten.

The suite is now **25 scenarios** (10 + 3 + 12). Run-by-run summaries are in `docs/runs/`; the evidence itself stays on disk,
under `.build/`, ignored by git, as do `evidence/`, `*.webm` and `*.dds`. No `.dds` file was tracked in this repository.

## Prepublished, and three new criteria for `tested` — 2026-09-23

The owner created the Workshop item: `Mod/About/PublishedFileId.txt` holds **3806709272**, committed at once (`25751bc`),
and the id is recorded in the `workshop` field. Steam keeps a new item private. The stage stays **`done`**: this is a
fact about the upload, not a claim that the gates between `done` and `prepublished` are met - they are not, see
below. `CHANGELOG.md` now opens on `0.1.0`, whose one entry is that file's creation. The tag and the GitHub release for
0.1.0 are still owed. `PUBLICATION.md` is not written.

The owner set three conditions for passing to `tested`:
1. **No scenario left `@wip`.** One is: the halo film, played only with `-pickle-include-wip` in the pass of
   `wsl-deps.film.map`. Not met.
2. **Every conditional scenario has run.** The one condition this suite has is Phytokin, present or not: pass A and pass B
   ran on 2026-09-21, before the halo fix and with 12 scenarios of today's 16. Not met until they are rerun on the final DLL.
3. **No manual test left to validate: all green.** The fourteen scenarios of `TESTING.md` are not: see the table there.
   Not met.

**The halo verification never ran.** The six halo scenarios queued on 2026-09-21 at 23:29 aborted on 2026-09-22 at 08:03,
exit 1, before playing anything: the runner tried to refresh its ticket and the ticket file no longer existed
(`Run-PickleWsl.ps1` line 205, `Get-Item` on a missing path). The likely cause is that the machine slept for hours and
the queue reaped the ticket as stale, but that was not verified. So **the `Maintain()` fix (`b8d7f25`) has still not
been played**. The item was created while it was unplayed; what the upload carried was not checked.

## Where `done -> tested` stands — 2026-09-21 (23:35)

Stage stays `done`. This is the criteria of the `done -> tested` step read against what exists tonight, so that whoever
continues (the Pickle runs, or the person who plays the rest) knows what is left. It claims nothing new.

| Criterion | State |
| --- | --- |
| The functional scenarios are executed in game and pass | **Not met.** Of the fourteen of `TESTING.md`, one is played whole (1), one more whole (5); seven are played in part (2, 6, 7, 8, 11, 12, 13); one is found faulty and fixed but not confirmed (4); four are not played (3, 9, 10, 14). The table in `TESTING.md` says which part of each |
| The Pickle suites run and are green, and their `@review` captures were actually opened | **Not met.** Ten of twelve scenarios green in the last full runs; the failures were the halo. The fix is committed (`b8d7f25`) and the six halo scenarios are queued against it, **no result yet**. Nine captures opened in this conversation: none shows a halo |
| Played scenarios counted against features discovered, `exitReason` read first | Done for every run recorded here |
| Logs checked | **Partly.** `no errors were logged` is asserted in eight scenarios; no full read of a real session's `Player.log` |
| Interface checked in French and in English | **Partly.** See scenario 13 |
| Options, persistence and the MainButtons shortcut | Not applicable to settings (`settings_audit: not_applicable`); the toggle's persistence through a save and reload is played |
| New game and existing save | **Existing save only** (the fixture). No new colony |
| Corrections followed by the regression tests | **Pending**: the halo fix and its six scenarios |

What a person has to do, in order of value: play scenarios 3, 9, 10 and 14 (none has been watched by anything), the
remainder of 2, 6, 7, 8, 11, 12 and 13 listed in `TESTING.md`, and look at the halo on the Windows game at 1x and 3x,
because the Linux game cannot say whether it is drawn. Nothing here launches that game.

## The halo filmed by PickleTools' steps — 2026-09-21 (22:42)

Stage unchanged, `done`. Pass `film` (`wsl-deps.film.map`), Workshop Pickle, 12 mods staged and loaded, filtered to
the filmed scenario with `-pickle-include-wip`: 1 scenario played for 1 written, `exitReason: passed`. The steps of
`PickleTools/FilmTicks` were found and ran; the film sits in `screenshots/film/pickletools--halo-per-tick/`, copied
to `.build/pickle-run-2026-09-21-2242-toolfilm/`. **56 pictures in 5.7 s**, encoded to 53 frames (three lost between
capture and encode, unexplained).

The game ran about 16 ticks a second during the filmed stretch, so the software renderer drew **one picture per
1.6 ticks, not per tick**. I looked at 48 consecutive frames cropped on the tree: the colonist stands beside the
tree, and **no halo shows in any of them**, no flash, nothing that changes between frames. That agrees with the
reading of the state data below (a mote that never survives a tick, and never fades in), and it is equally what a
shader that the software renderer does not draw would give. The film cannot tell those two apart.

## The halo lives less than one tick — 2026-09-21 (22:28)

Stage unchanged, `done`. English, filtered by a comma list that matched two scenarios: the off-screen tick-by-tick
one and the camera-on-the-tree one. `exitReason: failed`, 1 passed (camera on the tree) and 1 failed (off screen).
Copies in `.build/pickle-run-2026-09-21-2228-states/`. **A filter with a comma is a list of terms, not one phrase**:
mine ran the off-screen scenario again as well, by accident.

The step now records three states per tick. What it read:

| | Tree in view | Halo alive on | Field state | Ticks since the last ping |
| --- | --- | --- | --- | --- |
| Camera off the tree | no | 19 of 300 | alive 19, **destroyed 281**, never null | 0 to 14, every 15 ticks |
| Camera on the tree | yes | **300 of 300** | alive 300 | 0 on all 300 |

**It never was null: the mote is made every time and is dead again by the next sample.** And the two camera runs stop
contradicting each other once the ping age is read next to the state: **the halo is alive on exactly the samples taken
at age 0 - the same tick as a ping - and destroyed on every sample taken at age 1 or more.** Off screen that is 19
alive among 19 age-0 samples and 281 destroyed among the rest. On screen at 21:57 the samples fell at age 1, all
destroyed (0 of 300); at 22:28 they fell at age 0, all alive (300 of 300). Where Pickle's tick wait returns relative
to the pawn's tick differs from run to run, which is all that changed. Sampling alone could not have shown it.

**Reading, not yet proven by a fix.** `CompAnimaSong.NotifyListening` creates the mote when it is missing or destroyed
and calls `Maintain()` only in the `else` branch, when it already exists. A `needsMaintenance` mote that was never
maintained dies at its first tick, so by the next ping it is destroyed, the ping makes a new one, and `Maintain()` is
never reached. The halo would then exist for less than a tick, every tick, and its 0.2 s fade-in would restart each
time: never visible. That fits every measurement above, the six captures, and the film. The fix is one line -
call `Maintain()` after creating the mote too. **Made afterwards** (`b8d7f25`, the shipped DLL changed); see "Where `done -> tested` stands".

**A limit on this reading.** The states are read from the comp's own field; that the mote is *drawn* is not shown by
them. The Linux game renders under a software renderer, and a distortion shader such as `PsyfocusMeditationPulse`
might not show there even for a healthy mote. A fix would need a capture that shows the halo, or a run on the
Windows game by hand, to be called verified.

## Camera on the tree — 2026-09-21 (21:57)

Stage unchanged, `done`. English, filtered to `::with the camera on the tree`: 2 scenarios played, because two
names carry those words - the tick-by-tick one and the filmed one, which ran on the Workshop Pickle where its
`@film-ticks:1` tag is unknown and ignored. `exitReason: failed`, 1 passed (the film scenario, which asserts only
that the colonist listens) and 1 failed. Copies in `.build/pickle-run-2026-09-21-2157-camera/`.

| Camera | Ticks since the last ping (of 300) | Halo up on |
| --- | --- | --- |
| Off the tree (21:28) | 0 to 14, twenty of each - one ping in fifteen | 20 of 300 |
| **On the tree** | **1 on every one of the 300 - a ping every tick** | **0 of 300** |

The off-screen hypothesis is half right: **the job does ping every tick when the tree is on screen**, so the 15-tick
cadence was what an unwatched tree gets. But **that is not what was hiding the halo**: with a ping on every tick the
halo is up on none of the 300 ticks, and the capture (`...with-the-camera-on-the-tree--step10.png`, camera on the
tree at normal speed, the colonist standing beside it) shows no halo at all, not even the faint disc of an earlier
French capture. What the player sees, with the camera on the tree, is nothing. This is worse than the off-screen
case, where the halo at least came up on the ping tick.

**Why is not known.** The step read the mote field as up or down; it now reads three states - field `null` (the mote
was never made, or `MoteMaker` returned nothing), `destroyed` (made, dead by the time of the reading), `alive` - and
whether `Mote_PsyfocusPulse` exists and whether the tree is in the camera's view rect. It is rebuilt and **not yet
rerun**. The finding stays: on screen the halo is absent, with the job pinging normally; the cause is open.

The scenario that films the same stretch one picture per tick is queued on a local Pickle build
(`Documents\pickle-local\anima-film-mod`, `@film-ticks:1`); nothing from it is in.

## The tick-by-tick sampler, first result — 2026-09-21 (21:28)

Stage unchanged, `done`. English, filtered to `::followed tick by tick`: 2 scenarios played for 2 written,
`exitReason: failed`, both failed, as tests. Report copied to `.build/pickle-run-2026-09-21-2128-tick/`.
A first launch at 19:58 had been terminated after 62 s with exit 143 and wrote no report; **its cause is
unknown**. It is not this result.

| Speed | Halo up on | Ticks since the last ping (age: how many of 300) |
| --- | --- | --- |
| Normal | 20 of 300 | 0 to 14, twenty of each |
| Fast (3x) | 48 of 300 | 0:48, 1:60, 4:60, 7:60, 10:60, 13:12 (each sample spans 3 ticks at 3x, so the ages step by 3): the same 15-tick cycle |

**The job pings the tree once every 15 ticks, on a perfect sawtooth, and the halo is up on exactly the ping
tick**: 20 of 300 is one in fifteen. The mote is `needsMaintenance` and dies within a tick or two of its last
`Maintain()`, so it is alive for about 7 % of the time and dark the other 93 %, and it never lives long enough to
finish its 0.2 s fade-in. That matches every capture: no halo readable. **This is measured, not inferred** - the
age counter is the comp's own `lastListenTick`, read after each tick. The comment in `CompAnimaSong` expects
deltas of 2 or 3 at higher speed; what the game delivers here is 15.

**What is still open, and it is the important part.** In both scenarios the camera stayed on the base, sixty cells
from the tree, because nothing moved it. If RimWorld 1.6 ticks off-screen pawns at an interval, 15 ticks is the
cadence of an *unwatched* tree and says nothing about the tree a player is looking at. I have not established
that rule; it is a hypothesis that fits a perfectly regular 15. A third scenario, the same question at normal speed
with the camera zoomed in on the tree, is written for it and **not yet run**. The suite is 15 scenarios.
Until that runs, the finding is: *the job pings every 15 ticks when the tree is not on screen, and the halo is
dark most of the time then* - a defect only if the on-screen tree behaves the same way.

## Pickle pass B, with Phytokin — 2026-09-21 (17:17)

Stage unchanged, `done`. English, `-DepMap wsl-deps.phytokin.map`: 13 mods staged and loaded (the 11 of
pass A plus Vanilla Expanded Framework and Phytokin), 12 scenarios played for 12 written,
`exitReason: failed`, **9 passed, 3 failed, the same three halo scenarios**. Copies in
`.build/pickle-run-2026-09-21-1717-phytokin/`.

**The soft dependency is confirmed.** "The song and the icon follow the modlist" passed with Phytokin
active: the step derives what it expects from `ModsConfig`, so it demanded `VRE_AnimaSongSound` and the
texture at `UI/Abilities/AnimaSong`, and the tree sang that def and the toggle wore that texture. Before
the run the item was checked on disk: it declares 1.6, its `packageId` is the one the step reads, and its
1.6 folder defines the sound and carries the icon. The capture of the selected tree shows it: the toggle's
icon is a spiral, where pass A's was Royalty's tree head. **It does not show the sound played** - only
that the def the mod resolved is Phytokin's, not that anything was heard - and it does not exercise
Phytokin's own `VRE_AnimaSong` ability beside the mod (TESTING.md scenario 11, pass B), which stays
unverified.

**The halo fails the same way**: up in 2, 3 and 8 of 40 frames at ultrafast, normal and Fast. Loading
Phytokin changes nothing about it, which is consistent with a fault in the job's maintenance, or in the
sampler, rather than in anything the soft dependency touches. The other nine scenarios stayed green.

## Pickle pass A with the halo at three speeds — 2026-09-21 (17:12)

Stage unchanged, `done`. English, 12 scenarios played for 12 written, `exitReason: failed`, **9 passed
and 3 failed - the three halo scenarios**. Report and captures copied to
`.build/pickle-run-2026-09-21-1712/` before the next session's run.

| Speed | Halo up in |
| --- | --- |
| Normal (1x) | 3 of 40 frames |
| Fast (3x, the speed the mod promises) | 8 of 40 |
| Ultrafast (15x) | 5 of 40 (4 of 40 in the earlier English run, 13 of 40 in French) |

The question the two new scenarios were written for is answered, and not the way a speed problem would
answer it: **the halo is mostly absent at every speed, normal included**. The step that waits for it to
come up keeps passing, so it is created; it is then not held. The inspect pane says "Singing." throughout,
so the tree believes someone is listening. Five of the six earlier captures show no halo either.

This is now the best-supported open finding of the suite, and **its cause is not established**. Two readings
remain: the job does not ping the mote often enough (`Mote_PsyfocusPulse` is `needsMaintenance` and dies
within a tick of the last `Maintain()`), which would be a real defect in `JobDriver_ListenAnimaSong`; or the
sampler, which reads at frame boundaries, is a poor witness. A per-tick sampler - one reading after every
single tick, over a few hundred ticks - would show the duty cycle exactly and separate the two. It is not
written. The other nine scenarios stayed green, including the six-listener cap.

## Pickle reruns, English and French — 2026-09-21 (15:18 and 15:24)

Stage unchanged, `done`. Both runs reached their end (`exitReason: failed`), 10 scenarios played for 10
written, **9 passed and 1 failed in each language**. Reports were copied out before the next session's
run could overwrite them, to `.build/pickle-run-2026-09-21-1518/` (English) and `-fr/` (French).

The three timeout failures of the first run are gone: the `@timeout:` tags did what they were meant
to. The only failure, in both languages, is **the halo**: up in 4 of 40 sampled frames in English and 13
of 40 in French, at ultrafast, against the 90 % the step asks for. The earlier step, which waits for the
halo to come up, passes: it is created, then not held. That is the risk the comments of `CompAnimaSong`
name themselves - the mote dies within a tick unless the job pings it, and at higher speed the job can
receive deltas of 2 or 3. **It is a signal, not a proven defect**: ultrafast is harsher than the 3x the
mod promises, the sampler runs at frame boundaries of Pickle's fast mode, and nothing yet says what
normal speed does. Two scenarios now ask the same question at normal speed and at 3x (RimWorld's Fast), the speeds the mod promises: written straight after these runs and **not yet run** - the suite was 12 scenarios after them and is 14 with the tick-by-tick pair below.

**Captures opened.** Six images, three per language, taken with dev mode on.
- English, ring: three colonists near the tree, **no halo readable**, one faint pale streak beside the
  trunk. English, selected: the inspect pane reads "Singing.", the toggle is ticked. English,
  forbidden: "Listening not allowed.", the toggle carries a red cross.
- French, selected: the toggle reads "Autoriser l'écoute" and the pane is in French. A faint lighter
  disc around the tree and a blue streak at the trunk are visible on that one frame, the only image
  where anything like the halo shows. French, ring: no halo.
- **Clipping, and a reading to make with care.** In French the inspect pane is too short for its own
  text: the mod's line ("Chante." / "Écoute interdite.") is cut at the bottom edge and sits behind the
  pane's scroll bar. Vanilla lines wrap longer in French too, so this is the pane's layout, not a
  string the mod controls, and a player can scroll. It is still the line a French player has to hunt for.
- **Clean English inside the French run, none of it the mod's:** the vanilla gizmo "Commencer anima tree
  linking" and the message "Fallen monolith" come from Royalty and the base game, whose French
  translation in this Linux depot is incomplete. Recorded so nobody attributes them to Anima Song.
- No accented fallback gibberish and no raw key was seen on the mod's own strings.

**What the eighteen green scenarios now show**, in a fixture and on Royalty's sound and icon: the comp
on the tree and its toggle; the song and icon following the modlist; the memory after a full sitting and
none after a glance; the toggle emptying the ring and surviving a reload; the deaf refusal with the right
reason; and the six-listener cap with the seventh refused in the menu. In French, that the toggle label
and the pane are translated. They do **not** show anything with Phytokin, on a new colony or an existing
save, nor that the halo reads. `tested_on` stays empty.

**Pass B.** `Tests/Pickle/wsl-deps.phytokin.map` is written (VEF, then Phytokin, Workshop id 2927323805
read off the item's page, not checked for a 1.6 version). It cannot be staged: the staging copies from the
Windows Workshop folder and Phytokin is not there yet.

## First Pickle run — 2026-09-21

Stage unchanged, `done`: running the suite is a criterion of `done -> tested`, not of `done`.
Pass A only: English, `sans-facultatifs`, WSL under Xvfb, taken through `Run-PickleWsl.ps1` and the
machine queue. Report archived by the runner as `pickle-reports-archive/0921-1300`; a copy of what
was needed (summary, junit, log, the four failure screenshots) is under
`.build/pickle-run-2026-09-21-1300/`, ignored by git.

**Read in this order:** `exitReason: failed` (the run reached its end), 10 scenarios played for 10
written, 6 passed, 4 failed, 0 skipped. The report is from this run: written 13:00, before the next
session's run overwrote the shared folder.

| Scenario | Outcome |
| --- | --- |
| the patch lands on the tree the game spawned | passed |
| the song and the icon follow the modlist | passed |
| an ordered colonist walks out, sits in the ring, and the tree sings | **failed** - step timeout |
| the halo survives a stretch of ultrafast | **failed** - step timeout |
| a full sitting leaves a memory, and a glance leaves none | passed |
| the toggle empties the ring at once and survives a reload | passed |
| a colonist who cannot hear is refused in the menu | passed |
| six listeners fill the ring and the seventh is refused before walking | passed |
| the ring, the halo, and the waves of light | **failed** - "the halo is missing or has died" |
| the tree's interface in the language of this pass | **failed** - step timeout |

**Three of the four failures are the suite's, not the mod's.** Each died at "sits in the ring" after
exactly 5 s: Pickle gives a step the scenario's `@timeout:` tag, then five seconds, and these three
scenarios carried no tag. The three that passed all carry one. The failure screenshot shows why the
walk cannot fit: the fixture's colonists stand in the base, some sixty cells from the tree at
(70, 132). The tag was added to every walking scenario.

**The fourth is not yet understood.** The halo check ran immediately after the listeners were
seated and found no halo. Two readings are open and this run cannot tell them apart: a race in the
step (a listener that has just arrived has not yet taken its first listening tick, so the mote does
not exist yet), or a real defect (the halo is not created or not maintained). The step now waits up
to 10 s for the halo to come up, and a new step samples it over 40 frames and asks for 90 % up, which
is the check that would catch a blink under deltas of 2 or 3. **Until that reruns green, the halo is
unverified, not verified and not broken.**

**What the six passes do and do not show.** They show: the comp lands on the spawned tree and its
toggle is on the selection (visible in the failure screenshot, wearing Royalty's icon); the song and
icon follow the modlist; the memory is granted after a full sitting and refused after a glance; the
toggle empties the ring and is read back after a save and reload; a deaf colonist is refused with the
right reason; and the six-listener cap holds with the seventh refused in the menu, with no
`TryMakePreToilReservations` warning - the fix TESTING.md scenario 5 said had never been replayed.
They show it in English, on Royalty's sound and icon, in a fixture. They do not show it in French, with
Phytokin, on a new colony, or on an existing save. **No `@review` capture has been produced, so no
image has been looked at.**

**A fault outside the mod, found and fixed on the way.** The first launch attempt (12:07) aborted at
staging with no scenario played: `scripts/stage-pickle-wsl.sh` called `copy_steam` on every hard
dependency of the About and stopped on `Ludeon.RimWorld.Royalty`, which is a DLC with no Workshop id.
The DLCs are already activated a few lines above, so the dependency loop now skips `ludeon.rimworld*`.
That is a four-line change in the shared monorepo script, made under the machine lock, and not yet
committed there.

**Next:** rerun pass A with the fixes (in English, then `-Language French`), open the two `@review`
captures, and stage Phytokin for pass B when it is installed.


**Decision: `preTest` -> `done`.** The audit earlier today put the mod back to `preTest` for one
missing criterion: the Pickle (Gherkin) tests were neither written nor justified. They are now
written, in `Tests/Pickle/`, and their scope is argued file by file. Nothing else changed, and
**nothing has been run**: `done` means ready for the final in-game validation, not validated.

### What was added

- `Tests/Pickle/Mod/`, a companion mod **Anima Song - Pickle tests**, never published, beside
  `Mod/` and outside the folder Steam receives. It declares Anima Song, Royalty and Pickle as hard
  dependencies and Phytokin only under `loadAfter`, so a pass without Phytokin stays possible.
- Two feature files, **10 scenarios**: the patch landing on a spawned tree and showing its toggle;
  the sound and icon chosen from the modlist; the walk and the seat in the 2-to-5-cell ring; the
  halo surviving a stretch of ultrafast; the memory after a full sitting and its absence after a
  glance; the toggle emptying the ring at once and surviving a save and reload; the deaf refusal;
  the six-listener cap with the seventh refused in the menu; and two `@review` capture scenarios.
- `Tests/Pickle/Source/`, a step assembly reaching what no vanilla Pickle step can: the comp on the
  tree, its gizmo, the float menu option the mod hands the game, the halo mote, and where the
  listeners sit. Built to `Mod/Pickle/Assemblies/AnimaSong.PickleSteps.dll`; intermediates go to
  `.build/pickle/`, outside both mod folders.
- `Tests/Pickle/README.md`, which argues the scope: what needs a running game and why, and what is
  deliberately left out — the autonomous colonist, whose `baseChance` of 2 would hold the machine
  for a die roll; the roofed tree and the wall, which test the base game; the fourth refusal, which
  needs sixty cells blocked; adding and removing the mod, which is a second game; and the mood
  scaling, which is `effectMultiplyingStat` arithmetic.

### Checks performed, all offline

- `dotnet build Tests/Pickle/Source/AnimaSong.PickleSteps.csproj -c Release`: success, 0 warnings,
  0 errors.
- Both feature files parsed with **Pickle's own `Gherkin.dll`**, the parser the runner uses:
  2 features, 10 scenarios, tags and step counts as intended.
- Every one of the 19 step texts used in the features matches one of the 19 declared step
  attributes exactly, checked by normalising the feature lines to their Cucumber expressions. The
  16 vanilla steps used are each present in Pickle's own shipped features or step patterns.
- The fixture was read rather than assumed: Pickle's `test-colony.rws` holds a Royalty anima tree at
  **(70, 132)** with eight clear cells around it, no roof and no subplants. No tree is spawned.
- No step spells an English label: the toggle is found by the translation of its own Keyed key and
  each refusal by the key the mod chose for it, so the assertions hold in either language pass.

### What this does not claim

**No run, no game, no lock.** RimWorld was not launched, staged or driven, on either side, and the
machine lock was never taken. The suite has never been executed: not one scenario has been seen to
pass, fail, or even be selected. Its ten scenarios are recorded in `remaining` as `unverified`.

Pass B, with Phytokin, **cannot be staged from this machine**: a corpus search over 8,900 mod
folders found `vanillaracesexpanded.phytokin` only inside the About of a mod depending on it, never
as an installed mod's own packageId. The README gives the one-line dep map to write once it is
subscribed; no Workshop id was guessed, since the staging script would then copy somebody else's mod.

### Next gate

`done -> tested`: run the suite in WSL through `scripts/Run-PickleWsl.ps1`, once per language, and
once more with Phytokin when it is installed; read `exitReason` before the numbers, compare
scenarios played against features discovered, and open the `@review` captures. Then the fourteen
`TESTING.md` scenarios the suite deliberately leaves to a person.

## Workflow audit — 2026-09-21

**Decision: `done` -> `preTest`.** Stage values use the workflow's literal names. `preTest`
means every gate through `l10n -> preTest` is established; the `preTest -> done` gate is not,
for one reason only: the Pickle (Gherkin) tests are neither written nor is their absence
justified. This is missing work, not a defect of the mod. No code, asset or documentation
other than this file was changed.

### Scope and revision

- Repository `C:/Users/nelim/Documents/rimworld/AnimaSong` (own `.git`), distributed root `Mod/`.
- Audited HEAD `8d9fbe2e39a55fce31d9855d9c0ac5301b7f14cd`, working tree clean before this edit,
  equal to `origin/main` (`git ls-remote origin HEAD`). `gh repo view`: PUBLIC, non-empty, `main`.
- The audit prompt changed since 2026-09-13: `preTest -> done` now requires the Pickle tests to be
  *written* with their scope justified, and states that no in-game run is needed for `done`.
  That is the only criterion the previous `done` did not cover.
- RimWorld was not launched, not staged and not driven; no lock was taken because nothing was run
  in game. The offline suite below reads the installed game's assemblies and def files only.

### Ordered gates

| Transition | Result |
| --- | --- |
| dansMonoRepo -> horsMonoRepo | **Validated.** Standalone repo, GitHub remote, pushed HEAD, STATUS.md, public / `original` decision, MIT `LICENSE` and `ATTRIBUTION.md` byte-identical to the shipped copies, English README/CHANGELOG. Naming coherent (`Anima Song`, `nelim.animasong`, `AnimaSong`, `Rimworld-Anima-Song`). |
| horsMonoRepo -> ModIcon générée | **Validated.** Fresh isolated rebuild: 0 warnings, 0 errors, DLL SHA256 identical to the shipped one (`F255B868...16B5C`). `Mod/About/ModIcon.png` is 128 x 128 PNG, 29,110 bytes, opened and looked at: winking orange mascot with leaf and note motifs. Style deviations remain waived by the user's 2026-09-13 override. |
| ModIcon générée -> Preview générée | **Validated.** `Mod/About/Preview.png` is 896 x 504 PNG, 538,176 bytes (< 1 MB), SHA256 unchanged (`7cfc743e...6e4`). Opened and looked at. Style accepted by the user on 2026-09-13. |
| Preview générée -> preOptions | **Validated.** Violet rule and badge distinct from the blue scene; English title `Anima Song`, no prefix/suffix; description in English and ends with `[url=https://github.com/vbardales/Rimworld-Anima-Song]Source code on GitHub[/url]`, matching `<url>` and the remote. |
| preOptions -> options | **Validated, `settings_audit: not_applicable`.** Grep of `Source/` and `Mod/` for `ModSettings`, `GetSettings`, `SettingsCategory`, `DoSettingsWindowContents`, `MainButtonDef`, `MainTabWindow`, `Mod` subclasses: no match. No settings page and no shortcut exist. The only player choice, the per-tree toggle, is a gizmo saved on the tree. Toggle effect and save/reload stay in-game checks (scenarios 6, 12). |
| options -> l10n | **Validated.** Source inventory: 10 `.Translate()` keys, all present and non-empty in English and French Keyed files, `{0}` parameter kept; 4 Def fields (English source in the Def, French through 3 DefInjected files, two under the Royalty-gated folder). No hardcoded player-facing text in the five C# files. `Check-DefInjected.ps1`: 4 keys, 0 errors. Runtime display unverified. |
| l10n -> preTest | **Validated.** Only Royalty is required, declared in `modDependencies`; `loadAfter` Core, Royalty, Phytokin; Phytokin is optional, looked up by def name (`GetNamedSilentFail`) with a Royalty fallback; no assembly reference beyond `Krafs.Rimworld.Ref`, no Harmony. `LoadFolders.xml` 1.6 lists `/` and gates `Royalty` on `IfModActive`, matching the `MayRequire` defs. |
| preTest -> done | **Not established at the time of this audit.** Met: fourteen written scenarios (setup, actions, expected result) in `TESTING.md`; build matches the shipped DLL; automated suite 20/20; XML checks clean. **Missing: Pickle (Gherkin) tests.** No `Tests/Pickle` folder exists and no document justifies leaving them out. The mod has surfaces only a running game shows (the comp graft on the tree, the halo at 3x speed, the ring layout, the right-click entry through other mods' windows, persistence across reload), so non-applicability cannot be assumed. *Resolved later the same day: see the section above.* |
| done -> tested | **Unverified**, as before: nothing has been played in game. |

### Commands and observed results

- `dotnet build Source/AnimaSong.csproj --no-restore -c Release -t:Rebuild -p:OutputPath=../.build/audit-2026-09-21/build/`: success, 0 warnings / 0 errors; DLL hash equal to `Mod/Assemblies/AnimaSong.dll`.
- `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`: **20 passed, 0 failed**, against the installed game files; no game launched.
- `../scripts/Check-XmlFields.ps1`: four files, no unknown field. `Check-XmlClasses.ps1`: five types resolved. `Check-DefRefs.ps1`: no missing or mistyped reference, no unresolved parent. `Check-DefInjected.ps1`: 4 keys, 0 errors (two Royalty-folder notices satisfied by the gated folder, also covered by functional test 20).
- `git`/`gh`: HEAD pushed, repository public. `cmp` on LICENSE and ATTRIBUTION.md against `Mod/` copies: identical.

### Work needed to cross `preTest -> done`

Write a Pickle suite (`Tests/Pickle`) limited to what only a running game can show, and record why the
rest stays in `_tools/Run-Functional-Tests.ps1` and `TESTING.md`. Running it is **not** required for
`done`; it is a criterion of `done -> tested`, with its `@review` captures actually opened.

### Optional, not blocking

- Description wording: after this audit, `Mod/About/About.xml` was reordered to the `prepublished` layout (`IF I GO QUIET` with the unchanged adoption clause, `AI-GENERATED`, `THANKS`, the ATTRIBUTION.md line now also pointing to the MIT `LICENSE`, then the final `[url=...]Source code on GitHub[/url]`). Metadata-only edit, XML parses, the closing GitHub link is still last; no build, test or translation result is invalidated. The final read of the description remains part of `tested -> prepublished`.
- `PUBLICATION.md` still belongs to `tested -> prepublished`.
- `v1.0.0` tag and release remain owed until something has run.

## Preview style acceptance and cumulative status — 2026-09-13

The user explicitly accepted the existing Preview style: "j'accepte son style."
This waives the recorded visual-style deviation for the current shipped Preview,
SHA256 `7cfc743e0dc4846ecf1d2c6181df621fee9c0b5faaee43e700b6c2230f2d46e4`.
The prior ModIcon override remains in force. Neither acceptance claims that an
image was corrected; the historical visual observations below remain preserved.

**Current decision: `ModIcon générée` -> `done`.** The Preview gate now passes by
user acceptance plus the verified PNG format, 896 x 504 dimensions and 538,176-byte
size. The palette, title hierarchy and English description checks remain valid,
and the final GitHub link has been corrected and checked. The independently passed
settings audit (justified not applicable), localization, dependencies, written
functional scenarios, successful build, 20 offline tests and XML checks therefore
establish all cumulative gates through `done`. `showcase` is now `complete` under
the two explicit user overrides.

HEAD remains `3328c602f41ba993ae25d5b18dddd4e59a77867a` with the local changes
documented in this audit and follow-ups. The shipped DLL hash was checked again
and still matches the successfully rebuilt artifact:
`F255B868AD643CDFA01E0E316D195F5AEB41B1651A573ED5D275D07CE3116B5C`.
Only this status record changed in this step; no code or asset changed, so no
independent technical result requires rerunning. Earlier statements that the
Preview blocks progress are superseded by this acceptance.

`done` means ready for final in-game validation, not tested in game. The next gate
is `tested`: execute all fourteen TESTING.md scenarios, review logs and FR/EN UI,
cover new and existing saves, the per-tree toggle and persistence, Phytokin
present/absent, and any resulting regression checks. These remain **unverified**;
`tested_on` stays empty. No gameplay pass or publication is claimed.

## Description source link — 2026-09-13

Following the user's request to continue, replaced the bare source URL in
`Mod/About/About.xml` with the required Steam-formatted link at the very end of
the description, after attribution and adoption. XML parsing passed; verified
that the exact link appears once and ends the description. The repository target
was verified live during the audit above. Nothing was published.

The description finding is resolved. This metadata-only edit does not invalidate
the build, settings or in-game localization checks. The Preview style decision
remains pending, so the cumulative stage remains `ModIcon générée`.
Earlier findings below are retained as history.

## Preview compression — 2026-09-13

At the user's request, losslessly recompressed `Mod/About/Preview.png` from
711,863 to **538,176 bytes** (24.4% smaller). PNG format and 896 x 504 dimensions
are unchanged. Decoded pixel buffers were compared byte for byte and are identical;
all non-IDAT PNG chunks were preserved. Existing visual and contrast checks remain
applicable. Updated `Art/preview-qa.json` to reflect the shipped size.

SHA256: `7cfc743e0dc4846ecf1d2c6181df621fee9c0b5faaee43e700b6c2230f2d46e4`.
The original, compression script and result are retained under
`.build/audit-2026-09-13/` as `Preview-before-compression.png`,
`compress-preview.cjs` and `compression.json`. Earlier byte counts and the audit
manifest describe the pre-compression artifact. The existing renderer is unchanged;
rendering again may require this final compression step to recover the smaller size.

The image already met the size limit. This optimization does not resolve or waive
the Preview style finding; `stage: ModIcon générée` remains unchanged.

## ModIcon override — 2026-09-13

The user explicitly accepted the current ModIcon despite the style findings:
"j'override pour ModIcon". The icon's visual-style requirement is waived for this
artifact; its verified format, dimensions and installation remain valid.
This is acceptance by user override, not a claim that the image was corrected.

**Current decision: `horsMonoRepo` -> `ModIcon générée`.** This literal stage name
means the icon gate now passes cumulatively. The next transition, to `Preview générée`,
remains blocked by the Preview findings. The override applies only to ModIcon;
the Preview and description findings and pending in-game tests remain unchanged.
No artifact or code was modified and no technical validation was invalidated.
The audit below is retained as the record preceding this override; its instruction
to correct the icon is superseded and no icon work remains required.

## Cumulative workflow audit — 2026-09-13

**Decision before the ModIcon override: `done` -> `horsMonoRepo`.** Stage values here use the workflow's
literal names, not letter codes. `horsMonoRepo` means the standalone repository gate
passes; the next gate is `ModIcon générée`. Later independent checks below remain
valid but do not override an earlier failed gate. This section supersedes historical
claims of current readiness below; the earlier reports are preserved as history.

Authority: the supplied audit request, then `../PUBLISHING.md`, `../STYLE_RIMWORLD.md`,
`../MOD_SETTINGS.md` and `../TRANSLATIONS.md`. In particular, the request permits the
settings gate to pass by source analysis and applicable offline tests, and does not
require a recorded comparison with a game screenshot or image-generation history.

### Scope and revision

- Repository: `C:/Users/nelim/Documents/rimworld/AnimaSong`, with its own `.git`;
  distributed root: its `Mod/` directory (14 files, including 9 XML files).
  The repository remains physically below the parent workspace but is an independent
  Git repository; moving it elsewhere is not required.
- Audited HEAD: `3328c602f41ba993ae25d5b18dddd4e59a77867a`.
  Initial uncommitted files: `CHANGELOG.md`, `Mod/Assemblies/AnimaSong.dll`,
  both English/French Keyed XML files, `STATUS.md`, `Source/CompAnimaSong.cs`,
  and `TESTING.md`. These changes were included in the audit and preserved.
- Read-only `gh repo view vbardales/Rimworld-Anima-Song --json
  name,visibility,isEmpty,defaultBranchRef,url` confirmed PUBLIC, nonempty, main.
  `git ls-remote origin HEAD` returned the same SHA as local HEAD. No push was made.
- Only `STATUS.md` was edited by this audit. Disposable audit outputs are under
  `.build/audit-2026-09-13/`: build logs, isolated rebuilt DLL, source/distribution
  SHA256 manifest and 32-pixel icon inspection copy. No shipped artifact was changed.

### Ordered gates

| Transition | Result in this audit |
| --- | --- |
| dansMonoRepo -> horsMonoRepo | **Validated.** Independent Git root, configured GitHub origin and pushed commit verified live. Public/original decision is documented; MIT notices and attribution accompany the distribution. Root/shipped LICENSE and ATTRIBUTION copies are respectively byte-identical. English README, attribution and changelog exist. `Anima Song`, `nelim.animasong`, `AnimaSong` and `Rimworld-Anima-Song` form a coherent naming scheme; no renewal/private suffix applies. Attribution distinguishes runtime references from owned content; MIT is not treated as licensing third-party assets. |
| horsMonoRepo -> ModIcon générée | **Defect found.** Source build passes and matches the shipped DLL, but the icon fails the graphic style gate. The 128 x 128 PNG is 29,110 bytes and has the correct winking orange mascot. Direct inspection at 128 and 32 pixels shows a glowing blue/violet ornamental ring, gradients and many tiny leaves/notes/sparkles, contrary to the flat, no-glow, one-or-two-object brief. At 32 pixels the head survives but the surrounding motifs merge. |
| ModIcon générée -> Preview générée | **Independent defect found.** PNG format, 896 x 504 dimensions and 711,863-byte size pass. Inspected the shipped image and 268-pixel preview directly. Fine luminous foliage, radiating filaments and particle-like points around the trunk retain the cinematic treatment excluded by the matte low-detail brief. This is an observed artifact issue, not a demand for generation records. No camera-comparison paperwork is required and none is used as a blocker. |
| Preview générée -> preOptions | **Partly validated.** Violet accent is visibly distinct from the blue ambient/secondary family; ivory text, title, rule and 1.6 badge remain identifiable without clipping. English wording and title hierarchy pass; neither title word is a connecting word and no prefix/suffix is required. The About description's GitHub line is a bare URL before attribution/adoption, rather than the final `[url=...]Source code on GitHub[/url]` required by PUBLISHING.md. |
| preOptions -> options | **Not applicable, justified** for global settings; audit passed as detailed below. |
| options -> l10n | **Validated independently.** All owned text inventoried, 10/10 Keyed entries per language, four English source Def fields and four resolving French injections. Parameters/newlines reviewed; runtime display remains unverified. |
| l10n -> preTest | **Validated independently.** Royalty required and declared, Core/Royalty load order coherent, Phytokin optional with runtime fallback and loadAfter only. No Harmony or third-party assembly dependency. 1.6 LoadFolders retains `/` and gates Royalty translations; MayRequire fields and tree patch are consistent. |
| preTest -> done | **Independent technical checks pass.** Fourteen written functional scenarios include setup, actions and expected results. Existing offline suite reports 20/20; XML checks pass; build matches the delivered DLL. This does not restore cumulative done while artwork gates fail. |
| done -> tested | **Unverified.** No in-game scenario executed in this audit or established by existing results. FR/EN UI, logs, toggle persistence, new colony and existing-save coverage, Phytokin present/absent and gameplay regressions remain pending. |

### Settings audit

`settings_audit: not_applicable`. Reviewed all five C# sources and every shipped XML.
No Mod subclass, ModSettings, GetSettings, SettingsCategory, DoSettingsWindowContents,
MainButtonDef or MainTabWindow exists. There is no inherited settings interface,
empty page or shortcut. No RIMMSQOL or other customization integration is claimed tested.

The useful player choice is **Allow listening per tree**, already exposed by its
Command_Toggle, default true, serialized on that tree through Scribe with the same
default. The joy giver and menu read it; the job's failure condition reads it while
running. This is a map-object command, not global mod configuration. Right-click
listening is an action, not a setting. Six participants, the 2-to-5-cell ring, duration,
cooldown, memory strength and effect timing are deliberate balance/implementation
constants; no documented player requirement calls for global sliders or XML editing.
Adding settings solely to expose those constants would not be justified.
Settings-page input/reset/shortcut tests are therefore not applicable. Actual toggle
effects and save/reload are still unverified gameplay checks (scenarios 6 and 12),
not an implied runtime pass. The offline technical suite was executed after review.

### Commands and observed results

- `dotnet build Source/AnimaSong.csproj --no-restore -c Release -t:Rebuild
  -p:OutputPath=../.build/audit-2026-09-13/build/`: **success, 0 warnings/errors**.
  Initial sandbox attempt failed on SDK directory access (MSB4184); the authorized
  retry succeeded. This was an environment restriction, not a source defect.
  Isolated rebuilt and shipped DLL SHA256 both:
  `F255B868AD643CDFA01E0E316D195F5AEB41B1651A573ED5D275D07CE3116B5C`.
- `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`:
  **20 passed, 0 failed, no skips**, against installed RimWorld **1.6.4871 rev590**.
  Scope: reflection/IL contracts, real Core/Royalty definitions, simulated XML patch,
  localization parity and DLC gating; no live gameplay or Phytokin integration run.
- `powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-XmlFields.ps1
  -ModPath Mod -ExtraAssemblies Mod/Assemblies/AnimaSong.dll`: four files, no unknown fields.
- `powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-XmlClasses.ps1
  -ModPath Mod -TypeLists ../rw16_types.txt -SourceDirs Source`: five referenced types resolved.
  The current DLL's own classes were additionally loaded by the functional suite.
- `powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-DefRefs.ps1
  -ModPath Mod`: no malformed XML, missing/mistyped Def references or unresolved parents.
- `powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-DefInjected.ps1
  -TransMod Mod -ExtraAssemblies Mod/Assemblies/AnimaSong.dll`: four keys, zero errors,
  no unresolved targets. Two Royalty notices are satisfied by the inspected gated folder.
- Fresh XML/source comparison: nine XML files parsed; ten unique nonempty used Keyed
  entries in each language, no omissions; placeholders, markup and escaped newlines
  match. Reviewed all four Def text fields and their French injections. No hardcoded
  owned UI text found. Earlier translation inventory remains applicable.

### Next work and non-blocking recommendations

To reach **ModIcon générée**, change only the icon's rendering to the prescribed simple,
flat, non-glowing mascot/object composition, install the 128 x 128 PNG and inspect it
at 128/32 pixels. The verified build does not need repeating for an image-only change.
The Preview illustration and final description link must then pass their own gates.
No development, image generation, publication or gameplay run was performed here.

Optional test-harness hardening: test 3 in `_tools/Run-Functional-Tests.ps1` searches
only for `error CS...` and ignores the compiler exit code, so a non-C# infrastructure
failure can be reported as success. This audit does not rely on it to prove the build:
the separate successful rebuild and byte comparison establish that criterion directly.
Its IL reader also scans bytes rather than decoding instruction lengths; those checks
are supporting compatibility probes, not proof of gameplay. These limitations do not
invalidate the separately verified build, XML or translation results.

## Translation audit — 2026-09-13

Applied the shared `../PUBLISHING.md` and `../TRANSLATIONS.md` translation gate to
revision `3328c602f41ba993ae25d5b18dddd4e59a77867a` plus the local changes listed here.
The historical `stage: done` is retained; no in-game test or publication is claimed.

Scope: all five `Source/*.cs` files, `Mod/Defs/AnimaSong.xml`,
`Mod/Patches/AnimaTree.xml`, `Mod/LoadFolders.xml`, both Keyed files, and all three
French DefInjected files, including the conditional `Mod/Royalty/` load folder.

| Player-facing surface | Translation source | Coverage |
| --- | --- | --- |
| Toggle and tooltip | `AnimaSong_AllowListening`, `AnimaSong_AllowListeningDesc` | English/French Keyed |
| Enabled and disabled orders | `AnimaSong_ListenOrder`, `AnimaSong_ListenOrderDisabled` | English/French Keyed; disabled template takes reason as `{0}` |
| Four refusal reasons | `AnimaSong_OrderForbidden`, `AnimaSong_OrderCannotHear`, `AnimaSong_OrderFull`, `AnimaSong_OrderNoSeat` | English/French Keyed |
| Singing and forbidden inspect lines | `AnimaSong_InspectSinging`, `AnimaSong_InspectNotAllowed` | English/French Keyed |
| Recreation type | `AnimaSong_Song.label` | English Def; French JoyKindDef injection under Royalty |
| Job report | `AnimaSong_Listen.reportString` | English Def; French JobDef injection under Royalty |
| Memory label and description | `AnimaSong_Heard.stages.anima_song.label` and `.description` | English Def; French ThoughtDef injection at root |

The disabled menu label formerly concatenated translated fragments and punctuation.
It now translates a complete `AnimaSong_ListenOrderDisabled` template with one reason
parameter; both resources were added and `Mod/Assemblies/AnimaSong.dll` rebuilt.
All other owned UI text already used `.Translate()` or translatable Def fields.
The patch adds only a comp, and JoyGiverDef adds no text. No settings, letters, alerts,
custom grammar, additional version folders or dynamically constructed keys were found.
Phytokin supplies only sound/icon assets; no dependency translation keys are reused.
Vanilla-generated job decorations and recreation-room thoughts remain engine-owned.
Internal def names, asset paths, save keys and the toil debug name are not UI text;
About metadata, licences and documentation are outside this gate.

Validation:

- Manual source-to-resource inventory: 10 owned Keyed entries and 4 Def fields.
  English and French wording reviewed; the tooltip keeps its two paragraph breaks.
- PowerShell source/resource comparison extracted literal `.Translate()` calls from
  all source files and compared them with each Keyed XML: 10/10 in both languages,
  no missing, unused, duplicate or empty keys. Placeholder, markup and escaped newline
  sequences match; `{0}` formats correctly in both languages. All shipped XML parses.
- `dotnet build Source/AnimaSong.csproj --no-restore -c Release`: passed with no warnings
  or errors; shipped DLL updated.
- `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`:
  20 passed, 0 failed, including Keyed parity, memory handle and Royalty load gating.
- `powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-DefInjected.ps1
  -TransMod Mod -ExtraAssemblies Mod/Assemblies/AnimaSong.dll`: 4 keys checked,
  0 errors, no unresolved targets. The two Royalty notices are satisfied by the
  conditional load folder, independently covered by functional test 20.

Runtime: English and French display, fallback, formatting and clipping checks remain
**not executed**. Scenario 13 of `TESTING.md` now covers every surface above, all four
refusal reasons, and both Phytokin configurations. Reset affected translation fields
to `unchecked` after future UI, Def, patch or language changes until this audit is repeated.

## Preview overlay — 2026-09-12

- Final asset: `Mod/About/Preview.png`, composed directly in HTML/CSS at 896 × 504,
  711,863 bytes (below 900 KB). Nothing published.
- Retained illustration: `Art/Preview.png`, an unchanged copy of the existing text-free
  `Art/Preview-source.png`. No replacement or generation; the older original remains intact.
  Its clear left-hand space suits the overlay. This pass retains the illustration's existing
  cinematic style; it does not claim to correct the illustration deviations noted in the guide.
- Composition: `Art/preview.html`; parameters and unchanged title/summary:
  `Art/preview-layout.json`; sole colour reference: `Art/preview-palette.json`.
  Reproduce with `Art/render-preview.cjs` (Node.js, Playwright, Sharp and installed Chrome).
- Palette: the veil uses the broad blue-slate ground at the left, sampled over a region,
  while the secondary ink is a lighter coloured blue from that dominant ground/shadow family.
  The vivid violet accent comes from the tree's purple upper branches, with saturation
  increased for the rule and badge. Its violet hue separates it from the dominant blue
  ground and the lighter blue secondary ink; the former cyan accent was too close to that
  ambient family. It represents a repeated feature of the subject rather than an isolated pixel.
  Title and summary share exactly the same ivory ink; the badge uses dark ink.
- Layout: text starts at (50, 54); title 46 px/600, rule 58 × 3 px, summary 21 px/400
  across 430 px. Both words in `Anima Song` carry the identity of the title and stay at
  full size: no prefix, suffix or connecting word requires a 65% span. No tag or reserved
  tag row: original public production. Badge 80 × 80 px,
  digits 26 px/700 rotated 45 degrees; version 1.6 checked against shipped supportedVersions.
  Dark radial veil and text shadows follow STYLE_RIMWORLD.md.
- Actual fonts verified through Chrome's platform-font reporting after `document.fonts.ready`:
  Segoe UI Semibold for the title, Segoe UI for the summary, Segoe UI Bold for the badge.
  No fallback font used.
- QA: `Art/preview-qa.json`, `Art/preview-background.png` (text-free composite for measurement),
  and `Art/preview-268.png`. Contrast checked over every pixel of both text bounding boxes
  on the rendered background: title minimum 8.47:1, summary 12.04:1; badge 6.12:1 on its
  opaque accent. All exceed 4.5:1. Tag contrast is not applicable because no tag is rendered.
  Visually inspected at 896 × 504 and 268 px wide: no overlap or clipping, title and version
  identifiable, rule visible. The violet rule and badge stand out from the blue scene;
  violet accent and light-blue secondary ink are distinct palette families. The small
  summary is intended to be read at full size.

## Verification — 2026-09-12

- **Title:** keep `Anima Song`, without a suffix. This is an additional recreation mod,
  not a continuation of Phytokin. This is an original creation by Nelim, published under MIT,
  so the classification is `original` and no publication suffix is required. The inspiration
  and implementation credits in ATTRIBUTION.md remain applicable.
- **Licence:** MIT, copyright (c) 2026 Nelim. Root `LICENSE` and shipped `Mod/LICENSE`
  are byte-identical. This records the licence declared for this repository, not a grant
  over Phytokin or Ludeon assets; runtime references and the driver adaptation remain credited
  in `ATTRIBUTION.md`.
- **Manual tests:** 14 functional scenarios in `TESTING.md`, with setup, actions and expected
  results, including passes with and without Phytokin. They remain **not executed in game**.
- **Automated tests:** `_tools/Run-Functional-Tests.ps1` rerun successfully: 20 passed,
  0 failed. These are offline integration and compatibility checks, not a gameplay run.
- **XML:** reran the shared `../scripts/Check-XmlFields.ps1`, `Check-XmlClasses.ps1`,
  `Check-DefRefs.ps1` and `Check-DefInjected.ps1` against `Mod/`, supplying the mod DLL
  for reflection and `Source/` for class resolution. No unknown fields, unresolved classes,
  missing or mistyped def references, or translation errors (4 injected keys checked).
  The Royalty translation notices are informational: both files are in the gated folder,
  also covered by automated test 20. The functional suite simulates the patch's addition
  on the installed anima tree XML; actual in-game patch loading remains manual scenario 1.
- **GitHub:** the About URL and attribution link were already present. A direct repository
  link has also been added to the description itself.


Status card, read by a pass over every mod rather than by asking each thread one at a time. It
lives at the root, never inside `Mod/`, so Steam never receives it.

The fields above were read off the disk on 2026-09-12. Every one of them was checked back against
the files. The three the sweep cannot fill are settled here:

- **`stage`** — `done`, confirmed, and the session group says the same. Development is finished,
  the publication paperwork is written, the public repository holds the mod. Nothing waits on
  code. What is left does not belong in this field: the in-game run and the Steam upload are read
  off `tested_on` and `workshop`, both empty.
- **`tested_on`** — left empty, and that is exact: the mod has never been launched. `TESTING.md`
  opens on that sentence. The modlist is nevertheless ready for pass A, Anima Song and Royalty
  active with Phytokin inactive, and the junction under `RimWorld\Mods` resolves to this folder's
  `Mod/`.
- **`remaining`** — the catch-all line the sweep leaves there was true here, so it is spelled out
  rather than replaced. No known defect, no feature missing from the first pass: what is left is
  unverified. The five named lines are the ones whose failure would be silent, or whose fix has
  never been replayed. The comp graft comes first because everything else depends on it, and
  because a `PatchOperationConditional` that matches nothing reports it in no way at all.

**`dependencies` is `declared`, and the Phytokin entry under `loadAfter` does not contradict it.**
Royalty is the only mod this one needs, and the About declares it. Vanilla Races Expanded -
Phytokin is a soft dependency and deliberately not declared: the sound and the toggle's icon are
looked up by def name at runtime, with a Royalty fallback, and no assembly is referenced. The
vocabulary is `declared` when every mod this one needs is named in the About's `modDependencies`,
`to check` when a non-vanilla `loadAfter` suggests a dependency that is not declared, `none` when
the mod needs nothing. An undeclared dependency is not cosmetic: on 2026-09-11 Reequilibrage
animaux took 47 vanilla animals down with it, Muffalo included, because the class it injects
belongs to a mod that was not declared and not loaded.

Outside the three categories, the `v1.0.0` tag and its GitHub release are still owed, as
`CHANGELOG.md` announces. They wait on something having run: dating a version nobody has seen
work would serve no one.

`TESTING.md` stays the source: it says for each scenario what it proves and what its failure
looks like. This card keeps only the balance.

Since 2026-09-12 there is also `_tools/Run-Functional-Tests.ps1`, twenty checks against the
installed game that need no RimWorld running: the overrides, the three claims about the base game
this design rests on, the patch run against the real anima tree def, the six defs looked up by
name, and the French memory handle. All twenty pass. They do not shorten the `remaining` list
above, which is about what only the screen can answer.

The `remaining` categories: `feature` for something missing from the first pass, `defect` for a
known fault left unfixed, `unverified` for what could not be checked.

The `session` field was not touched: it comes from the sweep and names the session group, not this
conversation.

The `licence` vocabulary: `open` an explicitly licensed third-party source, `silent` no licence
and a dead source, `alive` no licence but a living source, `forbidden` a written refusal,
`original` an original production by Nelim. Original authorship is compatible with a MIT
licence and documented inspiration or runtime references; it does not remove attribution
obligations or extend the repository's licence to third-party assets.
