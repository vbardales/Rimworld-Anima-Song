# In-game scenarios, run by Pickle

The scenarios of [TESTING.md](../../TESTING.md) that a running game is needed for, and only those.
`Mod/` is a companion mod, **Anima Song - Pickle tests**, never published: it lives beside `Mod/`,
outside the folder Steam receives.

**Read `_tools/Run-Functional-Tests.ps1` first.** Twenty-one checks against the installed game's own
assembly and def files, in a couple of seconds, needing no RimWorld: the overrides, the three claims
about the base game this design rests on, the patch's xpath run on the real anima tree def, the six
defs looked up by name, the French memory handle, the Keyed parity. A Pickle run confiscates the
machine for tens of minutes. Nothing here restates any of it.

## What is left, and why it needs the game

| Scenario | Why nothing outside the game can say it |
| --- | --- |
| the patch lands on the tree the game spawned | the offline suite runs the patch operation over the def document; whether the loaded game ends up with the comp on a spawned tree, and shows its toggle, is another question — and a `PatchOperationConditional` that matched nothing reports it in no way at all |
| the song and the icon follow the modlist | both are `GetNamedSilentFail` lookups by def name with a Royalty fallback. A fallback that fires when it should not is silent by construction, and only the loaded modlist says which answer is right |
| an ordered colonist walks out, sits in the ring | `AnimaSongSeats.TryFindSeat` is a radial sweep with line of sight and a reachability test. Only a map answers it, and only a walk proves the seat was reachable |
| the halo holds on the tree in view, at 1x, 3x (Fast) and 15x (Ultrafast) | the halo is a `needsMaintenance` mote the job has to maintain, and `Mote.TimeInterval` destroys it on any tick after the last maintained one. Each scenario puts the camera on the tree and reads the halo **after every tick**, with how long ago the job last pinged the tree; it asserts 90 % alive and attaches the distribution. **There is no off-screen scenario**: measured on 2026-09-21, an unwatched tree is pinged once every 15 ticks and the mote is alive on about one tick in fifteen whatever the mod does, so such a scenario could only be red, and nobody sees it. The frame-sampled steps that came first were removed: where a wait returns relative to the pawn's tick changes from run to run, so one mote read 0 of 300 and 300 of 300. Fix committed (`b8d7f25`), **no run yet** |
| a full sitting leaves a memory, a glance leaves none | the memory is granted in the job's finish action, past 1250 ticks of sitting. The def and its French handle are checked offline; only a sitting grants it |
| the toggle empties the ring at once and survives a reload | "at once" is a `FailOn` evaluated while the job runs, and the toggle is `Scribe`d on the tree. A round trip through the save is the only way to read it back |
| a colonist who cannot hear is refused | the refusal reads a live `PawnCapacityDef`, on a pawn with a body |
| six listeners and the seventh refused before walking | **the one that has never been replayed since its fix.** A free cell is not a free slot: the ring holds some sixty cells while the job allows six pawns, and nothing enforces that until the job reserves the tree. Before the menu learnt to test the cap, the seventh walked the whole way and ended on `TryMakePreToilReservations() returned false for a non-queued job` |
| the two `@review` captures | judgements about pictures: whether the ring reads as a ring, whether the halo and the waves are visible, and how the mod's own words come out in the language of the pass |
| a real right-click, a drafted colonist, a blind colonist | `FloatMenuMakerMap` asked at the tree with the colonist selected (what a click does), then a drafted one: no entry; then a colonist with both eyes gone, who must still listen since only Hearing is required. Written 2026-09-23 from `03-the-rest-of-testing-md.feature`, **not yet run** |
| the song fires once, then holds its tongue | the cooldown read as the tree's `lastSongTick`: a second listener inside 5000 ticks leaves it where it was, a third after 5200 moves it. No sound is heard, there are no speakers; the state behind the early return is the observable. **Not yet run** |
| the memory does not stack | two full sittings in a row leave one memory of the anima song. **Not yet run** |
| the giver, the tolerance, the roof, the toggle | `TryGiveJob` of the recreation giver, asked directly: it finds the tree, gives nothing when listening is forbidden or the tree is roofed over, and a sitting builds tolerance for the new kind (the kind reaches the need). `baseChance`, how often recreation time picks the giver, stays the base game's. **Not yet run** |
| a wall to the north, a ring walled in | every listener has the trunk in sight and is unroofed; with every ring cell walled the order is refused with the "no free spot" reason, the fourth one. **Not yet run** |
| a save with three listeners | the tree's cooldown comes back from the save, no error is logged, and the tree sings again. **Not yet run** |
| the texts in the language of the pass | the ten Keyed entries and the four Def fields, read back from the game and compared with the mod's own resource files. Says something only in the language it runs in, so the suite is played once per language. **Not yet run** |
| Phytokin's own ability left alone | `@requires:` Phytokin: skipped in a pass without it, runs in the one with it. Asserts only that this mod patches nothing of theirs; **not** that the ability soothes when cast. **Not yet run** |

## What is deliberately not here

Until 2026-09-23 this list was longer: the autonomous colonist, the roofed tree and the wall, the fourth refusal and
the mood scaling were left to a person, with reasons that read well. The owner then set the condition for `tested` -
no manual test left to validate - and each of them turned out to have a deterministic form, written in
`03-the-rest-of-testing-md.feature`: the giver's `TryGiveJob` asked directly instead of waiting on `baseChance`, the
roof and the wall spawned by a step, the ring walled in for the fourth refusal, and the memory's multiplier checked
offline as the one field the base game reads (`_tools/Run-Functional-Tests.ps1`, test 21). What stays out, and is
said in `TESTING.md` as still to be validated by a person:

- **That the halo is drawn.** The Linux game renders in software, and a distortion shader such as
  `PsyfocusMeditationPulse` may not show there even for a healthy mote. The scenarios read the mote's state; only the
  Windows game can say what a player sees.
- **That the song is heard.** There are no speakers. The cooldown and the sound's def are checked; what reaches an ear is not.
- **That Phytokin's own ability soothes beside the mod.** The scenario asserts this mod patches nothing of theirs.
- **`baseChance`**, how often recreation time picks the giver. It is the base game's, and a die roll.
- **Adding and removing the mod on a live colony**, scenario 14 in its second half: removing it from a save and loading
  that save again is a modlist change between two games. The first half - a save that never had the mod gains the
  toggle - is what every run does, since the fixture predates the mod.

## Two passes, two languages

`AUDIT.md` asks for a pass **without** the optional mod and one **with**, and for the interface to
be read in French and in English. The language is fixed at staging and never switched inside a run:
`SelectLanguage` reloads every def under the runner and the run dies with it.

```powershell
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod AnimaSong
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod AnimaSong -Language French
```

Only one scenario changes its expectation between the two mod passes, *the song and the icon follow
the modlist*: it reads `ModsConfig` and demands Phytokin's recording and icon when Phytokin is
active, Royalty's when it is not. Every other scenario holds either way.

**Pass B** selects `wsl-deps.phytokin.map`, which names Vanilla Expanded Framework and Vanilla Races
Expanded - Phytokin (Workshop id 2927323805, read off the item's page):

```powershell
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod AnimaSong -DepMap wsl-deps.phytokin.map
```

The staging copies from the Windows Workshop folder, so Phytokin has to be subscribed there. It was
checked on disk on 2026-09-21 before the first pass B: it declares 1.6, its packageId is the one the
step reads, and its 1.6 folder defines the sound and carries the icon.

**`wsl-deps.map`** stages PickleTools' `FilmTicks`, the one tool this suite uses to film, in **every** pass that names
no map of its own; `wsl-deps.phytokin.map` repeats that line, because a named map replaces the default one instead of
adding to it. The tool is staged everywhere because the scenario that films the halo is not `@wip` and never skipped:
a suite that must leave no scenario behind cannot keep one out of some passes. It is test infrastructure, not an
optional integration of the mod, so the bare pass is still a pass without Phytokin.

## No fixture of its own, and no tree spawned

Pickle ships `test-colony.rws` and `the save {string} is loaded` reads it from any active mod's
`Pickle/Fixtures/`. That save already holds a Royalty anima tree at **(70, 132)**, with eight clear
cells around it, no roof and no subplants — checked in the fixture itself. Spawning a tree would
test the spawner; this is the tree the game placed. Every scenario names that cell, so a fixture
that ever loses its tree fails on the first step with the cell's real contents listed, rather than
somewhere further down.

## The step assembly

`Source/` builds `Mod/Pickle/Assemblies/AnimaSong.PickleSteps.dll`, out of the way of the shipped
mod's own intermediates. The steps reach what no vanilla Pickle step can: the comp on the tree, its
gizmo, the float menu option the mod hands the game, the halo mote, and where the listeners sit.
Everything a vanilla step already does — loading the save, making a colonist, drafting, waiting,
saving and reloading, the screenshots, the log assertions — is left to Pickle.

**Every step text starts with `Anima Song:`.** Pickle loads the steps of every active suite into one
namespace, and two suites declaring the same text produce "Ambiguous step" on scenarios that are
perfectly healthy. Cells are spelled `x=70 z=132` rather than `(70, 132)`: Cucumber expressions read
parentheses as optional text and would have to be escaped.

**No step spells an English label.** The toggle is found by the translation of its own key and a
refusal by the translation of the key the mod chose for it, so the assertions hold in whichever
language the pass was staged with. That is what makes the French pass worth running instead of
merely producing French captures.

Rebuild after any change to the mod's own comp:

```powershell
dotnet build Tests/Pickle/Source/AnimaSong.PickleSteps.csproj -c Release
```

The steps assembly is loaded at game start. A report produced without restarting after a rebuild
did not test what was just changed; check the build time against the process time before reading a
failure.

## Setup, once, for a run on the Windows install

Only she runs those. A session stages and runs in WSL, or not at all.

```powershell
New-Item -ItemType Junction -Path "C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Mods\AnimaSongPickleTests" -Target "C:\Users\nelim\Documents\rimworld\AnimaSong\Tests\Pickle\Mod"
```

Then enable it below Anima Song and Pickle.

## Reading a report

- **`exitReason` before the numbers.** A run killed in flight leaves a report that looks like a
  result: `in-progress` above a cheerful count of passes.
- **Scenarios played against features discovered.** `exitReason: passed` says nothing about what was
  never selected. `-IncludeWip` has been seen to *shrink* a selection to a fifth of it while
  reporting success.
- **A green `@review` is not a verification.** It says the trajectory ran. Whether the halo is
  visible, whether the ring reads as a ring, and whether the French comes out in French are
  judgements, and AUDIT.md is explicit that a green `@review` does not count as one having been
  made. Open the images.
- **Copy what you need out of `PickleReports` before the next run.** A run overwrites the previous
  report, captures included; the archive keeps only the last five. Then keep only what
  [docs/runs/README.md](../../docs/runs/README.md) lists as worth keeping (`summary.md`, `junit.xml`, at most one
  minified picture) and delete the rest: a capture is 3 MB and the disk is full.

## Status

**Run on 2026-09-21, and not green.** Pass A in English and in French (10 scenarios, 9 passed each), then
pass A again with the halo scenarios (12 scenarios, 9 passed) and pass B with Phytokin (12 scenarios, 9
passed). The nine that pass are the same in every run; the one that does not is the halo, present in 2 to 13
frames of 40 at every speed and in both passes. The tick-by-tick pair was written afterwards and has not
been run: the suite is 14 scenarios. `STATUS.md` holds the reading of each run and of the captures. Running
the suite is a criterion of `done -> tested`; none of it is claimed as a validation.
