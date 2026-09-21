# Anima Song — in-game test scenarios

No person has ever played this mod on the Windows game. The build is clean, the XML checkers are clean and
the translation keys resolve on paper; since 2026-09-21 a Pickle suite has also watched part of it run in a
headless Linux game (see the table below). This file is the list of what has to be watched, and what counts
as a pass.

It is not shipped: it lives beside `Mod/`, never inside it, so Steam never receives it.

Some of what these scenarios would catch is now caught earlier, without the game. `_tools/Run-Functional-Tests.ps1`
checks the hand-offs against the installed game's assembly and def files: the overrides, the patch's
xpath on the real anima tree def, the six defs looked up by name, the French memory key. Run it
first — a red line there explains a scenario that would have failed below, and costs seconds rather
than a colony. It proves nothing about what happens on screen, which is why the fourteen below
stand unchanged.

Since 2026-09-21 a second layer sits between the two: `Tests/Pickle/`, a Gherkin suite run inside a
running game. It automates the part of the list below that a machine can judge — the patch landing
on a spawned tree, the walk and the seat, the halo under ultrafast, the memory after a full
sitting, the toggle biting at once and surviving a reload, the deaf refusal, and the six-listener
cap with its seventh refused in the menu — and it attaches captures for the rest. Its README says
which scenarios below it covers, which it deliberately leaves alone, and why. **It was run on
2026-09-21**, in the headless Linux game: the table below says what each scenario got from it. The
fourteen scenarios here stay the reference, and the judgements — whether the halo reads, whether the
French comes out in French — remain a person's.

## What the Pickle suite has already played, 2026-09-21

Read this before playing anything by hand: it says which of the fourteen scenarios a machine has watched and which
are still yours. "Played" means the scenario ran in the headless WSL game on the fixture's anima tree, in English and
in French unless said otherwise, and passed; it does not mean the whole scenario as written below was covered.

| # | Scenario | Pickle | What is left for a person |
| --- | --- | --- | --- |
| 1 | The mod loads, and the patch bites | **Played, passed.** The comp is on the spawned tree, its toggle is on the selection, no error logged. Passes A and B | Nothing new in game; a look at the log of a real session |
| 2 | The right-click order | **Partly.** The order is driven through the comp's own menu entry (not a real click), the colonist walks and sits 2 to 5 cells out | The real right-click; the inspect line; the drafted colonist getting no entry; nobody on the trunk's eight cells |
| 3 | The song fires once, then holds its tongue | Not played | All of it (5000-tick cooldown) |
| 4 | The song is visible | **Found a fault, fixed, not yet confirmed.** The halo lived under a tick; `Maintain()` is now called when the mote is made. A rerun is queued | That the halo is drawn on screen, at 1x and 3x: the Linux game renders in software and cannot say |
| 5 | The ring, and the seventh colonist | **Played, passed** in every full run: six on six distinct cells, the seventh refused before walking with the "all listeners" reason, the order back when one leaves | Nothing beyond the log of a real session |
| 6 | The toggle | **Partly.** Off stands the listeners up at once, the order is refused with the "not allowed" reason, the state survives a save and reload | The inspect line by eye; that nobody goes on their own over a day |
| 7 | Who may listen | **Partly.** A deaf colonist is refused with the "cannot hear" reason | A blind colonist listens |
| 8 | The memory | **Partly.** A full sitting leaves the memory, a short one leaves none | It does not stack; it scales with psychic sensitivity |
| 9 | The colonist who decides on their own | Not played | All of it (`baseChance` 2, the recreation type in the tolerance list) |
| 10 | Walls and roofs | Not played | All of it |
| 11 | The two soft dependencies | **Partly.** Pass A (Royalty's sound and icon) and pass B (Phytokin's: the def `VRE_AnimaSongSound` and the texture `UI/Abilities/AnimaSong` resolved) | That the sound is heard; that Phytokin's own `VRE_AnimaSong` still works beside the mod |
| 12 | Saving in the middle | **Partly.** A save and reload with the toggle off | A save with three listeners, and the cooldown surviving |
| 13 | English and French translation | **Partly.** Toggle, its label, the inspect lines and three of the four refusal reasons in both languages (assertions on the translated keys, plus captures opened). The French pane clips the mod's own line | The fourth reason ("no free spot"); the recreation type, the memory label and description, the job report |
| 14 | Adding and removing on a live colony | Not played | All of it |

**No pass was run on a new colony.** The fixture is an existing save.

## Before starting

- RimWorld 1.6, Royalty active, Anima Song active. Development mode on, so that silent failures
  become red text.
- The log to read afterwards, and to attach to any report:
  `C:\Users\nelim\AppData\LocalLow\Ludeon Studios\RimWorld by Ludeon Studios\Player.log`
- An anima tree. A tribal start has one; otherwise Debug actions → Spawn thing → `Plant_TreeAnima`,
  on open ground, with room for a ring of five cells around it.
- Two passes are needed, because the sound and the gizmo icon change with the modlist: **pass A**
  without Vanilla Races Expanded - Phytokin, **pass B** with it.

Useful conversions: 60 ticks is one second at normal speed, 2500 ticks is one in-game hour. So the
song's cooldown of 5000 ticks is two hours, the half hour a listener must stay for the memory is
1250 ticks, and a full sitting of 4000 ticks lasts about an hour and a half.

## 1. The mod loads, and the patch bites

The patch grafts `CompAnimaSong` onto `Plant_TreeAnima`. Nothing else in the mod works if it does
not apply, and a `PatchOperationConditional` that finds nothing says so in no way at all.

1. Load a save with the mod active.
2. Select the anima tree.

**Pass:** the gizmo bar shows the **Allow listening** toggle, lit, wearing an icon (which icon
depends on the pass — see scenario 11). Its presence is the only proof the patch applied.
**Fail:** no toggle. Then the xpath missed, and everything below is moot.

Check too that the log holds no red line naming AnimaSong, no `InvalidCastException`, and no
`Could not resolve cross-reference`.

## 2. The right-click order

1. Select one undrafted colonist who can hear.
2. Right-click the tree.

**Pass:** the menu holds **Listen to the anima song**. Clicking it sends the colonist walking, and
they sit down somewhere in the ring, facing the trunk. Their inspect line reads *listening to the
anima song.*

**Watch for:** a colonist who sits on a cell touching the trunk. The ring starts 2 cells out
precisely so the anima grass at the foot is never trampled — the eight cells around the trunk must
stay empty.

Repeat with the colonist **drafted**: the entry must not appear at all.

## 3. The song fires once, and then holds its tongue

The cooldown lives on the tree and is worth 5000 ticks. It exists because Phytokin's recording is an
`onCamera` one-shot at volume 15: six colonists sitting down one after another would stack six
orchestras over each other.

1. Order a first colonist to listen. At the moment they sit: a sound, and a psychic flash on the
   tree.
2. Within the next two in-game hours, order a second one.

**Pass:** the second one sits in silence — no new sound, no new flash.

3. Wait past the two hours and order a third.

**Pass:** the tree sings again.

## 4. The song is visible

1. With one colonist listening, watch the tree.

**Pass:** a psychic halo pulses around the trunk, wide enough to cover the tree and the ring, and a
wave of light leaves the trunk and reaches the listener about every two seconds.

2. Raise the game speed to 3x.

**Pass:** the halo keeps going. It is maintained by the listener's job, tick by tick, and at high
speed that job receives deltas worth 2 or 3 instead of 1 — this is exactly where a halo would start
to blink or die.

3. Order the listener away.

**Pass:** the halo goes out almost at once, within a fraction of a second.

## 5. The ring, and the seventh colonist

The job allows six participants and the ring holds some sixty cells, so a free cell is not a free
slot. The menu tests the reservation itself, and refuses the seventh before the walk rather than at
the end of it.

1. Order six colonists to listen, one after another.

**Pass:** six of them sit, spread around the ring, nobody sharing a cell, nobody against the trunk.

2. Right-click the tree with a seventh colonist selected.

**Pass:** the order is greyed out and reads *(the tree has all the listeners it takes)*. Nobody
walks over, and the log stays silent. What must not appear is
`TryMakePreToilReservations() returned false for a non-queued job`, which is what a seventh
colonist produced before the menu learnt to test the cap.

3. Send one of the six away, then right-click with the seventh again.

**Pass:** the order is live again and they go and take the freed slot.

## 6. The toggle

1. With two or three colonists listening, turn **Allow listening** off.

**Pass:** they stand up immediately, not at the end of their sitting. The tree's inspect pane reads
*Listening not allowed.*

2. Right-click the tree with a colonist selected.

**Pass:** the order is greyed out and reads *(listening not allowed here)*.

3. Leave it off, put a colonist on Recreation time next to the tree, and let an in-game day pass.

**Pass:** they never go and listen on their own.

4. Save, quit to the menu, reload.

**Pass:** the toggle is still off. It is stored on the tree and travels with the save.

## 7. Who may listen

Only hearing is required — deliberately, so that a blind colonist still hears the tree.

1. Make a colonist deaf (Debug actions → add a hediff destroying both ears).

**Pass:** the right-click order is greyed and reads *(cannot hear)*, and recreation time never sends
them to the tree.

2. Blind a colonist the same way.

**Pass:** they can listen, both on order and on their own.

## 8. The memory

The memory is +3 for one day, multiplied by psychic sensitivity, and does not stack.

1. Let a colonist listen for a full sitting, then read their Needs tab.

**Pass:** a memory labelled *anima song*, worth +3 at psychic sensitivity 1, lasting one day.

2. Order another colonist away after a few seconds, well under half an in-game hour.

**Pass:** no memory at all. Walking past is not listening.

3. Send the first colonist back for a second sitting while the memory is still there.

**Pass:** still one entry, still +3 — it does not add up.

4. Repeat with a psychically deaf colonist (sensitivity 0.5) and with a hypersensitive one.

**Pass:** the mood figure scales with the stat.

## 9. The colonist who decides on their own

This is the part the mod exists for: a new recreation type that fills itself.

1. Set a colonist's recreation need low, put their schedule on Recreation, leave them near the
   unroofed tree in daylight, and let time run.

**Pass:** sooner or later they walk out and sit. The chance is deliberately modest.

2. Open Needs → Recreation and hover the tolerance list.

**Pass:** **anima song** appears there as a type of its own, beside the ten vanilla ones. An
eleventh type is the whole point of the mod; if it does not show up here, the JoyKindDef is not
reaching the tolerance system.

## 10. Walls and roofs

1. Build a wall between a colonist and the tree, leaving the far side open.

**Pass:** they walk around and sit where they can see the trunk; no one sits behind the wall.

2. Roof the tree over (it dies eventually, this is only to see the giver's reaction).

**Pass:** recreation time stops offering that tree.

## 11. The two soft dependencies

Both the sound and the toggle's icon are looked up by def name, with a Royalty fallback. No assembly
is referenced, so this has to be seen from both sides.

**Pass A, without Phytokin:** the toggle wears Royalty's anima linking ritual icon, and the song is
Royalty's anima linking sound.

**Pass B, with Phytokin:** the toggle wears their anima song icon, and the tree sings their
recording. Their own `VRE_AnimaSong` ability must still work exactly as before — cast it once and
check it still soothes. This mod patches nothing of theirs.

## 12. Saving in the middle

1. Save while three colonists are listening. Reload.

**Pass:** the save loads with no red line, the colonists carry on or pick a new job cleanly, the
halo comes back while someone listens, and the tree does not immediately fire a second orchestra —
the cooldown was saved too.

## 13. English and French translation audit

Run this checklist in English, then switch the game to French and repeat it. Record the
game version, language, modlist and result in STATUS.md. These checks have not yet been run.

- Read the toggle and its complete tooltip (including the paragraph break).
- Read the enabled right-click order, then each of its four disabled reasons: listening
  forbidden, cannot hear, all six listener slots reserved, and no reachable free seat.
  For the last case, leave a listener slot free but block all cells in the seating ring.
- Inspect the tree while singing and while listening is forbidden.
- Read the listening job report, the recreation type in the tolerance list, and the
  memory label and full description (scenarios 2, 6, 8 and 9).
- Check for raw keys, accidental English fallback in French, visible `{0}`, broken
  punctuation, missing accents and clipping. Repeat with and without Phytokin;
  its sound/icon integration must not change the mod's text coverage.

**English pass:** all ten Keyed entries and four Def fields display the English resource
text, including a disabled order such as *Listen to the anima song (cannot hear)*.

**French pass:** the toggle reads *Autoriser l'écoute* with its French description, the order reads
*Écouter le chant de l'arbre anima* with its four French reasons, the job line reads *écoute le
chant de l'arbre anima.*, the recreation type is *chant anima*, and the memory is *chant anima*
with its French description.

The memory is the one to watch: its two keys address the stage by the handle the game builds from
the stage's label, not by index, and a key that matches no path fails in silence — English text on
screen is the only symptom.

## 14. Adding and removing on a live colony

The description promises the mod can be added to and removed from an ongoing game.

1. Add it to a save that never had it. **Pass:** the tree gains its toggle, nothing else changes.
2. Remove it and load that save again. **Pass:** the game warns about the missing content, as it
   does for any removed mod, and the colony loads and plays.
