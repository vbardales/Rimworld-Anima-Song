# In-game scenarios, run by Pickle

The scenarios of [TESTING.md](../../TESTING.md) that a running game is needed for, and only those.
`Mod/` is a companion mod, **Anima Song - Pickle tests**, never published: it lives beside `Mod/`,
outside the folder Steam receives.

**Read `_tools/Run-Functional-Tests.ps1` first.** Twenty checks against the installed game's own
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
| the halo survives a stretch of ultrafast | the halo is a `needsMaintenance` mote the job pings every tick. It dies within a few ticks if nobody does, and at ultrafast the job receives deltas worth 2 or 3 instead of 1. This is exactly where it blinks or dies |
| the halo holds at normal speed, and at 3x (Fast) | the two speeds a player uses. RimWorld's are Normal 1x, Fast 3x, Superfast 6x, Ultrafast 15x; the scenario above is the harsh case, and these say whether a blinking halo blinks for everybody or only at a speed nobody plays at. Written after the first two runs found the halo up in 4 of 40 frames (English) and 13 of 40 (French) at ultrafast, and **not yet run** |
| a full sitting leaves a memory, a glance leaves none | the memory is granted in the job's finish action, past 1250 ticks of sitting. The def and its French handle are checked offline; only a sitting grants it |
| the toggle empties the ring at once and survives a reload | "at once" is a `FailOn` evaluated while the job runs, and the toggle is `Scribe`d on the tree. A round trip through the save is the only way to read it back |
| a colonist who cannot hear is refused | the refusal reads a live `PawnCapacityDef`, on a pawn with a body |
| six listeners and the seventh refused before walking | **the one that has never been replayed since its fix.** A free cell is not a free slot: the ring holds some sixty cells while the job allows six pawns, and nothing enforces that until the job reserves the tree. Before the menu learnt to test the cap, the seventh walked the whole way and ended on `TryMakePreToilReservations() returned false for a non-queued job` |
| the two `@review` captures | judgements about pictures: whether the ring reads as a ring, whether the halo and the waves are visible, and how the mod's own words come out in the language of the pass |

## What is deliberately not here

- **The autonomous colonist**, TESTING.md scenario 9. `baseChance` is 2 and the pawn has to want
  recreation: a scenario waiting for it would hold the machine for an unbounded time to prove a
  die roll. What can fail silently there — the `JoyGiverDef`, its `joyKind`, `unroofedOnly`, the
  search going through `listerThings` — is checked offline, tests 5 and 8 to 10.
- **The roofed tree and the wall**, scenario 10: pathing and `unroofedOnly` are the base game's,
  and building a wall mid-scenario tests the construction system more than this mod.
- **The fourth refusal, "no free spot"**, which needs some sixty cells blocked to reach. Its text is
  covered by the translation inventory and its place in the chain is a matter of code order. A
  scenario that spent a minute filling the ring with walls would prove the wall.
- **Adding and removing the mod on a live colony**, scenario 14: that is a modlist change, which
  means a second game, and one machine has one game.
- **The mood figure scaling with psychic sensitivity**, scenario 8 step 4: that is
  `effectMultiplyingStat` on the ThoughtDef, the base game's arithmetic, not this mod's.

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

**Pass B is written but cannot be staged from this machine yet.** `wsl-deps.phytokin.map` names
Vanilla Expanded Framework and Vanilla Races Expanded - Phytokin, and the pass selects it with
`-DepMap wsl-deps.phytokin.map`. Phytokin's Workshop id, 2927323805, was read off the item's own page
on 2026-09-21; whether that item is at a 1.6 version was **not** checked. What is missing is the mod on
disk: the staging copies from the Windows Workshop folder only, and a corpus search over 8,900 mod
folders found Phytokin's packageId only inside the About of a mod that depends on it, never as an
installed mod's own. Two ways in: subscribe to it, or download it into a cache the staging reads,
which is what the SkillIcons session was building on 2026-09-21 and which the staging script does not
read yet. There is no `wsl-deps.map` beside the pass, and that is the point — the staging reads that
name on **every** pass, so a suite owning one can never have a pass without its optional mod.

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
  report, captures included; the archive keeps only the last five.

## Status

**Written, never run.** No pass of this suite has been executed, on either side, so nothing below
`preTest -> done` is claimed by it. Its scenarios have not been seen to pass, fail, or even be
selected. Running it is the first step of `done -> tested`.
