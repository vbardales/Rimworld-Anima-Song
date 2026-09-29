# TESTING.md scenario E, first half: saves a game that has the tree's own data (its toggle's cooldown, a memory of
# listening) but nobody actively listening, then hands the file to the removal companion (`Tests/Pickle/Removal/Mod`),
# which has no dependency on Anima Song. The second launch, `-ThenWithout nelim.animasong,nelim.animasong.pickletests
# -Then removal-check`, loads it with both taken out of the mod list.
#
# Handoff is DRAFTED before the save, not saved mid-listen: a save taken while a colonist is running the mod's own
# JobDriver crashes on every tick once the mod (and its JobDriver class) are gone, the base game falling back to
# Verse.AI.JobDriver for a class it no longer knows (read on 2026-09-27, `f9865ca`). That is the game's
# own handling of any dropped mod's active job, not something this mod can guard against from outside its own code
# while it is still loaded; the mod's About.xml says as much: stop a listener before removing the mod, as for any job
# a removed mod would leave stranded. This scenario tests what the mod answers for: what it leaves in a save once
# nobody is mid-job.
@requires:nelim.animasong.pickleremoval
Feature: a save with Anima Song, prepared for removal

  @timeout:120
  Scenario: a save with the tree's own data, nobody listening, handed to the removal companion
    Given the save "test-colony" is loaded
    And a colonist "Handoff" exists
    And "Handoff" needs "Joy" is set to 10 percent
    And game speed is ultrafast
    When Anima Song: "Handoff" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Handoff" sits in the ring of the tree at x=70 z=132
    And I wait 1400 ticks
    And I draft "Handoff"
    Then Anima Song: "Handoff" holds 1 memory of the anima song
    When Anima Song: the game is saved to a file
    And Anima Song: the saved file is handed to the mod "nelim.animasong.pickleremoval"
    Then no errors were logged
