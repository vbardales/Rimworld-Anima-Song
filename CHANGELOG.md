# Changelog

Format inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This file serves the repository and the writing of Steam patch notes; RimWorld does not display it in game.

## [1.0.0] — unreleased

On release: create the `v1.0.0` tag and the matching GitHub release.

First version. RimWorld 1.6, Royalty required.

### Added

- A new recreation type, `AnimaSong_Song`: any colonist able to hear can walk out to an anima tree, sit down in a ring 2 to 5 cells from the trunk, and listen to it sing. Up to six listeners at once, outdoors only, line of sight required.
- A memory worth +3 mood for one day, multiplied by psychic sensitivity and not stacking — deliberately weaker than the +8 over two days of Phytokin's own once-a-quadrum ability.
- A visible song: a pulsing psychic halo around the tree while anyone is listening, and a wave of light travelling from the trunk to each listener every two seconds.
- A right-click order, **Listen to the anima song**: select a colonist, click the tree, and they go and sit, instead of waiting for recreation time to come round. Greyed out with its reason when the pawn cannot hear, when the ring is full, or when listening is forbidden.
- A toggle on the tree, **Allow listening**. Turned off, the joy giver skips that tree and current listeners stand up at once.
- French translation.
- Parameterized English and French disabled-order text, so translations control the complete menu label.

### Notes

- Soft dependency on Vanilla Races Expanded - Phytokin: with it, the tree sings Phytokin's own recording and the toggle wears their icon; without it, Royalty's anima linking sound and ritual icon are used. Both are looked up by def name, no assembly reference.
- The toggle and the song cooldown are stored on the tree and travel with the save. No other save data.
