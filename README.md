# Anima Song

Colonists can go and listen to an anima tree sing, as recreation. RimWorld 1.6, Royalty required.

## What the mod does

An eleventh recreation type, produced by something you already own. Any colonist — psycaster or
not, blind or not, but not deaf — walks out to an anima tree, sits down on the ground in a ring
around it, and listens. The tree sings while they sit; when they get up they carry the memory for
a day.

| | |
| --- | --- |
| Recreation type | `AnimaSong_Song`, an eleventh one |
| Job length | 4000 ticks, ending early on full joy |
| Listeners at once | up to 6 |
| Where they sit | a ring 2 to 5 cells from the trunk, line of sight required, unroofed |
| Memory | +3 mood for 1 day, multiplied by psychic sensitivity, does not stack |
| Cost to build | none — you need an anima tree |

Two controls. Select a colonist and right-click the tree: **Listen to the anima song** sends them
out to sit, instead of waiting for them to choose it during recreation time. The option greys out
with its reason when the pawn cannot hear, when the ring is full, or when listening is forbidden.

Select the tree instead and a toggle appears: **Allow listening**. Turn it off and the joy giver
skips that tree, the order greys out, and anyone already listening stands up at once — useful to
clear the ring before a psychic linking ritual, or when the tree grows somewhere you would rather
nobody sat.

While someone is listening, the tree wears a soft teal glow under a pulsing psychic halo, and sends a wave of light out
to each listener every two seconds, so you can tell from across the map that it is singing.

## Why an eleventh type is worth more than a tenth building

The base game has ten recreation types and only four of them come from a building. Expectations
ask for up to six *different* types, and tolerance is counted per type, not per building: a
colonist who has played chess all week is just as tired of poker. A new type is therefore worth
far more than another building of a type you already had — and this one costs nothing, which
quietly rewards a tribal start.

The memory is deliberately weaker than Phytokin's own +8 over two days: theirs is a
once-a-quadrum ability, this is repeatable.

## Soft dependencies

With **Vanilla Races Expanded - Phytokin** installed, the tree sings Phytokin's own recording and
the toggle wears their anima song icon. Without it, Royalty's anima linking sound and ritual icon
are used instead. Nothing is copied and no assembly is referenced: both are looked up by def name
at runtime. See `ATTRIBUTION.md`.

Royalty is required, since the anima tree is a Royalty plant.

## How it hooks in

Four small classes and one patch, no Harmony.

**`JoyGiver_ListenAnimaSong`** derives from `JoyGiver_InteractBuilding`. The name misleads:
`JoyGiver.GetSearchSet` goes through `map.listerThings.ThingsOfDef`, not `listerBuildings`, and
`CanInteractWith` never touches `def.building` — so that half works on a plant unchanged. What it
overrides is seat picking: the vanilla adjacent-cell variant keeps only the four cardinal cells,
which would cap the audience at four and trample the anima grass the linking ritual depends on.

**`JobDriver_ListenAnimaSong`** exists for one reason: `JobDriver_SitFacingBuilding` declares
`private Building Building => (Building)base.TargetThingA;`, and an anima tree is a `Plant`. The
rest is that driver's behaviour, retyped onto a `Thing`.

**The right-click order** needs no Harmony either. `ThingWithComps.GetFloatMenuOptions` polls
every comp through `CompFloatMenuOptions`, and `FloatMenuOptionProvider_FromThing` hands it any
clicked thing without filtering on buildings — so a plant carrying a comp gets its own menu entry
for free. Both ways of starting the job pick the seat through the same `AnimaSongSeats.TryFindSeat`,
so an ordered listener sits exactly where an autonomous one would.

**`CompAnimaSong`** lives on the tree, added by `Patches/AnimaTree.xml`. It owns the toggle, the
song cooldown (5000 ticks, so six colonists sitting down in a row do not stack six orchestras),
the sound and the visual effects. It does not tick: plants tick every 2000 ticks, while a
`needsMaintenance` mote is destroyed on the first tick nobody maintained it. The job driver maintains
the halo on each listening tick, and **`HaloKeeper`**, a component on the map, keeps it up on the ticks
the job skips at higher game speeds (its maintenance is stamped one tick ahead, since the mote's own
tick comes before the map's). Royalty's halo is a pure distortion with a transparent texture, so the
mod adds a second mote of its own, `AnimaSong_HaloGlow`: a soft ring in the teal of the tree's leaves,
from a texture of the mod's, tinted by the def's colour.

## Status

Played by an automated in-game suite (25 scenarios, in English, in French and with Phytokin; see
`TESTING.md` and `docs/runs/`), **not yet watched by a person on the Windows game**. `TESTING.md`,
beside this file and outside the published folder, lists the fourteen scenarios, which of them a
machine has played and what is left for a person.

Beside it sits a suite that needs no game:

```
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
```

Twenty-two checks against the installed game's own assembly and def files, in a couple of seconds.
It asks whether the overrides still override, whether the three claims this design rests on are
still true of the base game, whether the patch still lands on the anima tree, whether the defs
looked up by name at runtime (and the shader of the halo glow) still exist, and whether the glow's
def and texture are sound. What it cannot answer is anything only the screen can show, which is
what `TESTING.md` is for.

## Save data

None of its own. The toggle and the song cooldown are stored on the tree, in the save. Adding the
mod to a save that never had it is what every test run does. Removing it from a save has not been
tested yet; the memory it leaves would expire within a day.

## Licence

MIT (`LICENSE`). Attribution in `ATTRIBUTION.md`.

If I do not answer within a reasonable time after being contacted, anyone may freely update this
or any other of my mods, including publishing a continuation of it. All credit must be preserved.
