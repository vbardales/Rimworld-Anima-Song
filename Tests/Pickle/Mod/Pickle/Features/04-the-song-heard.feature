# The song, heard. Nothing here is a step of this mod's: they are PickleTools' SoundCapture steps (PickleTools/docs/steps.md), staged by
# `wsl-deps.sound.map`, so every scenario is tagged @requires:nelim.pickletools.soundcapture and is skipped in every other pass. Two
# levels of proof, and one thing left to a person:
#   - what the GAME does: the sound def this modlist calls for is among the sounds it is playing (a live sustainer or a playing
#     one-shot started from it). No audio device is involved;
#   - what reaches the audio OUTPUT: the sink is recorded while the song plays and its loudest sample measured;
#   - whether it is the RIGHT sound, and whether the picture and the sound keep in step, is for a person to say from `film-sound.mp4`.
# The WSL profile mutes the game (volumeMaster 0), so a scenario that records sets the volume first; the sound then also plays on
# the owner's speakers for the seconds of the recording, which is why they are few (`AUDIT.md`, SoundCapture).
#
# The colonist is PLACED beside the tree: the fixture spawns a new colonist where the scenario does not choose, and on 2026-09-25 that
# was sixty cells away with no way through, so the order was refused ("no free spot around the tree").
@review
Feature: the song, heard

  Background:
    Given the save "test-colony" is loaded

  # Without Phytokin: Royalty's anima linking sound.
  @requires:nelim.pickletools.soundcapture @timeout:180
  Scenario: the game plays Royalty's anima linking sound when the first listener sits
    Given a colonist "Choir" exists
    And "Choir" needs "Joy" is set to 10 percent
    And Anima Song: "Choir" stands 8 cells from the tree at x=70 z=132
    And game speed is ultrafast
    When Anima Song: "Choir" is ordered to listen to the tree at x=70 z=132
    Then Nelim's Pickle Tools: the game is playing the sound "AnimaTreeLink"

  # With Phytokin: their recording. Played in the pass that stages both (`wsl-deps.sound-phytokin.map`), selected by name, since the
  # scenario above would fail there for the right reason: the tree sings Phytokin's sound, not Royalty's.
  @requires:nelim.pickletools.soundcapture @timeout:180
  Scenario: the game plays Phytokin's recording when the first listener sits
    Given a colonist "Choir" exists
    And "Choir" needs "Joy" is set to 10 percent
    And Anima Song: "Choir" stands 8 cells from the tree at x=70 z=132
    And game speed is ultrafast
    When Anima Song: "Choir" is ordered to listen to the tree at x=70 z=132
    Then Nelim's Pickle Tools: the game is playing the sound "VRE_AnimaSongSound"

  # The video with its sound, for a person to watch and listen to: the tree with its glow, a listener who sits, the song. The
  # recording is a few seconds, and starts before the order so that the start of the song is on it.
  @requires:nelim.pickletools.soundcapture @timeout:240
  Scenario: the song on a video with its sound
    Given a colonist "Recorded" exists
    And "Recorded" needs "Joy" is set to 10 percent
    And Anima Song: "Recorded" stands 6 cells from the tree at x=70 z=132
    And Nelim's Pickle Tools: the game volume is 80 percent
    And I zoom all the way in
    And I move the camera to (70, 132)
    And I wait 120 ticks
    When Nelim's Pickle Tools: I film with sound as "the song"
    And Anima Song: "Recorded" is ordered to listen to the tree at x=70 z=132
    And Nelim's Pickle Tools: I let 12 real seconds go by
    And Nelim's Pickle Tools: I stop filming with sound
    Then Anima Song: "Recorded" sits in the ring of the tree at x=70 z=132
    And Nelim's Pickle Tools: the sound recorded as "the song" is not silent
