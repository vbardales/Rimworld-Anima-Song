---
mod:          Anima Song
packageId:    nelim.animasong
repo:         Rimworld-Anima-Song
visibility:   public
detached:     yes
stage:        done
licence:      original
licence_at:   Original creation by nelim; MIT in LICENSE and Mod/LICENSE, copyright (c) 2026 nelim; credits in ATTRIBUTION.md
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

## Verification — 2026-09-12

- **Title:** keep `Anima Song`, without a suffix. This is an additional recreation mod,
  not a continuation of Phytokin. This is an original creation by nelim, published under MIT,
  so the classification is `original` and no publication suffix is required. The inspiration
  and implementation credits in ATTRIBUTION.md remain applicable.
- **Licence:** MIT, copyright (c) 2026 nelim. Root `LICENSE` and shipped `Mod/LICENSE`
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
`original` an original production by nelim. Original authorship is compatible with a MIT
licence and documented inspiration or runtime references; it does not remove attribution
obligations or extend the repository's licence to third-party assets.
