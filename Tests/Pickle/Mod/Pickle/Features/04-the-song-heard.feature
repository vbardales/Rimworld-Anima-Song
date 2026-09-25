# The song, on a recording. PickleTools' SoundCapture records the monitor of the audio sink between two steps and measures the
# loudest sample: "not silent" says the game's sound reached the sink, not that it is the right sound. The file it writes,
# `sound.wav`, sits beside the report so that a person can listen to it, which is the check the owner asked for on the
# song (manual check B of TESTING.md), and the previous scenario of 03 says which def the game was asked to play.
#
# Conditional on the tool: skipped in every pass that does not stage it (`wsl-deps.sound.map`), so it is the one scenario
# that pass adds. The colonists start some sixty cells from the tree, so the recording starts BEFORE the order and covers the
# walk at ultrafast, then the song when the first one sits; the tool takes 1 to 45 real seconds.
@review
Feature: the song, recorded

  Background:
    Given the save "test-colony" is loaded

  @requires:nelim.pickletools.soundcapture @timeout:240
  Scenario: the song is on the recording
    Given a colonist "Recorded" exists
    And "Recorded" needs "Joy" is set to 10 percent
    And game speed is ultrafast
    When Nelim's Pickle Tools: I record the sound as "the song"
    And Anima Song: "Recorded" is ordered to listen to the tree at x=70 z=132
    And Nelim's Pickle Tools: I let 40 real seconds go by
    And Nelim's Pickle Tools: I stop recording the sound
    Then Anima Song: "Recorded" sits in the ring of the tree at x=70 z=132
    And Nelim's Pickle Tools: the sound recorded as "the song" is not silent
