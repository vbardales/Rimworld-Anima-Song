# TESTING.md scenario E, first half: saves a game with one listener seated, then hands the file to the removal companion
# (`Tests/Pickle/Removal/Mod`), which has no dependency on Anima Song. The second launch, `-ThenWithout nelim.animasong,
# nelim.animasong.pickletests -Then removal-check`, loads it with both taken out of the mod list.
@requires:nelim.animasong.pickleremoval
Feature: a save with Anima Song, prepared for removal

  @timeout:120
  Scenario: a save with a listener, handed to the removal companion
    Given the save "test-colony" is loaded
    And a colonist "Handoff" exists
    And "Handoff" needs "Joy" is set to 10 percent
    And game speed is ultrafast
    When Anima Song: "Handoff" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Handoff" sits in the ring of the tree at x=70 z=132
    And Anima Song: the game is saved to a file
    And Anima Song: the saved file is handed to the mod "nelim.animasong.pickleremoval"
    Then no errors were logged
