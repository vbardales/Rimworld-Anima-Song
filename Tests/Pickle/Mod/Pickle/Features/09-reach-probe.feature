# Temporary 1.7 diagnostic (ticket 2d08 follow-up): why do colonists not reach the ring at x=70 z=132 on the 1.7 map?
# The log step writes `[reach]` and `[reach-cell]` lines (region id, region type, room id, walkable, standable...) in
# stdout.txt. Same region id for both cells = connected (slow ticks); two region ids with canReach=False = the map or the
# spawn is cut. Delete this file once the cause is known. Needs nelim.pickletools.colonistrace (ReachSteps, PiT 2026-11-17).

Feature: 1.7 reachability probe of the anima tree ring

  @requires:nelim.pickletools.colonistrace @timeout:120
  Scenario: where is the spawn cell of a colonist, and can it reach the tree
    Given a colonist "Song-1" exists
    When Nelim's Pickle Tools: the reach of "Song-1" to (70, 132) is written to the log
    And game speed is ultrafast
    And I wait 600 ticks
    Then Nelim's Pickle Tools: "Song-1" can reach (70, 132)
