# Changelog

Format inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This file serves the repository and the writing of Steam patch notes; RimWorld does not display it in game.

## [1.0.0] — 2026-09-25

The CI creates the `v1.0.0` tag and the matching GitHub release after a successful upload (never by hand).

First version. RimWorld 1.6, Royalty required.

### Added

- A new recreation type, `AnimaSong_Song`: any colonist able to hear can walk out to an anima tree, sit down in a ring 2 to 5 cells from the trunk, and listen to it sing. Up to six listeners at once, outdoors only, line of sight required.
- A memory worth +3 mood for one day, multiplied by psychic sensitivity and not stacking — deliberately weaker than the +8 over two days of Phytokin's own once-a-quadrum ability.
- A visible song: while anyone is listening the tree wears a soft teal glow (the colour of its leaves, from a texture of the mod's own) under Royalty's pulsing psychic halo, and a wave of light travels from the trunk to each listener every two seconds.
- A right-click order, **Listen to the anima song**: select a colonist, click the tree, and they go and sit, instead of waiting for recreation time to come round. Greyed out with its reason when the pawn cannot hear, when the ring is full, when no free spot is left, or when listening is forbidden.
- A toggle on the tree, **Allow listening**. Turned off, the joy giver skips that tree and current listeners stand up at once.
- French translation.
- Parameterized English and French disabled-order text, so translations control the complete menu label.

### Notes

- Soft dependency on Vanilla Races Expanded - Phytokin: with it, the tree sings Phytokin's own recording and the toggle wears their icon; without it, Royalty's anima linking sound and ritual icon are used. Both are looked up by def name, no assembly reference. Phytokin's own ability is not touched.
- The toggle and the song cooldown are stored on the tree and travel with the save. No other save data.
- The halo is a maintained mote, and the base game destroys such a mote on the first tick nobody maintained it. The listener's job maintains it, and a component on the map keeps it up on the ticks the job skips at higher game speeds, so it holds at normal speed, Fast and Ultrafast.
- Played by an automated in-game suite (25 scenarios, English, French, and with Phytokin) in a headless game; see `TESTING.md`. **Not yet watched by a person on the Windows game**: that the halo is drawn on screen, that the song is heard, that Phytokin's own ability soothes beside it, and removing the mod from an existing save are still to be checked.

## [0.1.0] — 2026-09-23

Prepublication: the first upload to the Steam Workshop, made to create the item and obtain its `PublishedFileId.txt`. Steam creates every new item private, and RimWorld never changes that.

### Added

- `Mod/About/PublishedFileId.txt`, holding the Workshop item ID `3806709272`, committed in `25751bc`. Without it the next upload would create a second item.

### Notes

- The content of this upload is what 1.0.0 describes, at an earlier stage: it predates the last halo fix (the component on the map, `c04edcc`). The `tested` and `prepublished` states have not been reached: see `STATUS.md`.
