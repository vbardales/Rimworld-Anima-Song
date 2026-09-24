# Attribution

No third-party file is copied into this mod, and no third-party assembly is referenced. What
follows is what was studied, and what is called by name at runtime.

## Vanilla Races Expanded - Phytokin, by Oskar Potocki, Sarg Bjornson and the Vanilla Expanded team

https://steamcommunity.com/sharedfiles/filedetails/?id=2927323805

The idea comes from their `VRE_AnimaSong` ability: a genetically gifted Phytokin points at an
anima tree and makes it sing a psychic orchestra, once a quadrum. **That ability is not touched,
patched or altered by this mod.** Anima Song adds a way to *listen* — anyone, repeatably, as
recreation — and deliberately weakens the reward for it: +3 mood for one day here, against their
+8 over two days.

Two of their assets are looked up **by def name at runtime**, and only if the mod is present:

* the sound `VRE_AnimaSongSound`, so that the tree sings their recording rather than a
  substitute (without Phytokin, Royalty's own `AnimaTreeLink` is used instead);
* the texture `UI/Abilities/AnimaSong`, used as the icon of the tree's toggle (without Phytokin,
  Royalty's `UI/Icons/Rituals/AnimaTreeLinking` is used instead).

Nothing is copied: no sound file, no texture, no code, no def. Both lookups use
`GetNamedSilentFail` and degrade to a vanilla fallback, which is why this mod loads and works
with Phytokin absent. If the Vanilla Expanded team would rather their assets were not called at
all, say so and the fallback becomes the only path.

## RimWorld, by Ludeon Studios

The job driver is `Verse.AI.JobDriver_SitFacingBuilding` rewritten, not inherited: that class
declares `private Building Building => (Building)base.TargetThingA;`, a hard cast that throws on
a `Plant`. The rewrite keeps its behaviour — seat reservation, facing the target, comfort from
the cell, ending on full joy — retyped onto a `Thing`. The joy giver derives from
`RimWorld.JoyGiver_InteractBuilding`, which despite its name searches `map.listerThings` and
never touches `def.building`.

The visual effects are Royalty's own defs, used unmodified: `Mote_PsyfocusPulse` for the halo
around the singing tree, `Mote_PsychicLinkPulse` (the anima linking ritual's wave) for the pulse
travelling from the tree to each listener, and Core's `PsycastPsychicEffect` fleck — the same one
Phytokin's ability throws on its target.

Royalty is required: the anima tree is a Royalty plant.

## Tools

Code and documentation written with Claude Code (Anthropic); preview image generated with an
image model, under human direction and review. The mod has been played by an automated in-game test suite in a headless game (`TESTING.md`); a person has not yet played it.

**Licence:** MIT (`LICENSE`).
