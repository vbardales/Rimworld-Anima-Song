---
mod:          Anima Song
packageId:    nelim.animasong
repo:         Rimworld-Anima-Song
visibility:   public
detached:     yes
stage:        done
licence:      original
licence_at:   an original creation, MIT
dependencies: declared
showcase:     complete
tested_on:
workshop:
remaining:
  - unverified: the fourteen scenarios of TESTING.md, none played
  - unverified: grafting the comp onto the tree, which a PatchOperationConditional can miss without a word
  - unverified: the halo, maintained tick by tick by the job, at 3x speed
  - unverified: the seventh colonist refused in the menu, never replayed since its fix
  - unverified: pass B, with Phytokin - sound and icon looked up by def name
  - unverified: the French translation of the memory, whose key addresses the stage by its handle
session:      local_5e30f42a-ec8b-4932-9f21-00964209cc65
updated:      2026-09-12, the mod's own session
---

# Anima Song — status

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

The `remaining` categories: `feature` for something missing from the first pass, `defect` for a
known fault left unfixed, `unverified` for what could not be checked.

The `session` field was not touched: it comes from the sweep and names the session group, not this
conversation.

The `licence` vocabulary: `open` an explicit licence, `silent` no licence and a dead source,
`alive` no licence but a living source, `forbidden` a written refusal, `original` nothing reused.
