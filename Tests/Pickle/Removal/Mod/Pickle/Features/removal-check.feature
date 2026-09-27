# TESTING.md, scenario E: a game saved with Anima Song active still loads once the mod, and its test companion, are gone.
# This suite carries no dependency on Anima Song (its About.xml names only Pickle), so it stays playable with the mod removed.
Feature: A game saved with Anima Song, loaded without it

  Scenario: the save with a listener loads and runs without the mod
    Given mod "nelim.animasong" is not loaded
    And the save "pickle-animasong-save-check" is loaded
    And game speed is fast
    When I wait 250 ticks
    Then no errors were logged
    And the engine is alive
    When I save and reload as "pickle-animasong-removal-check-reloaded"
    Then no errors were logged
    And the engine is alive
