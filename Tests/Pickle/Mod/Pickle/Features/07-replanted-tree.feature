# A user report (2026-10-08): with Replantable Anima Trees (Continued), after extracting and replanting the tree, colonists stop listening on their own.
# This feature only probes (the log carries the [AnimaSongProbe] lines); it asserts nothing about the cause yet.
@requires:Spuffy.AnimaReplant
Feature: a replanted anima tree

  @timeout:300
  Scenario: the tree moved the way a replanting mod does
    Given the save "Nelims-tribe" is loaded
    And Nelim's Sanctuary: I am at the sanctuary "bare-clearing"
    And Anima Song: an anima tree grows at x=195 z=152
    When Anima Song: the text files of the mod "Spuffy.AnimaReplant" are logged
    And Anima Song: the tree at x=195 z=152 is minified and replanted at x=175 z=140 and probed
    Then Anima Song: the tree at x=175 z=140 carries the song comp
    # The user report is about colonists going on their own: bored (joy 10 percent), and the only tree they can pick is the replanted one.
    Given Anima Song: every other anima tree than the one at x=175 z=140 forbids listening
    And Anima Song: the schedule of "Nelim" is joy all day
    And "Nelim" needs "Joy" is set to 10 percent
    And game speed is ultrafast
    When I wait 600 ticks
    And Anima Song: "Nelim" sits in the ring of the tree at x=175 z=140
    Then Anima Song: "Nelim" is listening to the tree at x=175 z=140

  @timeout:300
  Scenario: the replanted tree, saved and reloaded, is still visited on its own
    Given the save "Nelims-tribe" is loaded
    And Nelim's Sanctuary: I am at the sanctuary "bare-clearing"
    And Anima Song: an anima tree grows at x=195 z=152
    When Anima Song: the tree at x=195 z=152 is minified and replanted at x=175 z=140 and probed
    Then Anima Song: the tree at x=175 z=140 carries the song comp
    When I save and reload
    # The user report is about colonists going on their own: bored (joy 10 percent), and the only tree they can pick is the replanted one.
    Given Anima Song: every other anima tree than the one at x=175 z=140 forbids listening
    And Anima Song: the schedule of "Nelim" is joy all day
    And "Nelim" needs "Joy" is set to 10 percent
    And game speed is ultrafast
    When I wait 600 ticks
    And Anima Song: "Nelim" sits in the ring of the tree at x=175 z=140
    Then Anima Song: "Nelim" is listening to the tree at x=175 z=140
