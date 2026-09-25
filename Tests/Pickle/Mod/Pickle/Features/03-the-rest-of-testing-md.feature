# The scenarios of TESTING.md that 01-the-song.feature left to a person, written as scenarios once the owner set
# the condition for `tested`: no manual test left to validate, all green.
#
# What each one stands for, and what it does NOT stand for, so nothing here is read as more than it is:
#
#   2   the real right-click and the drafted colonist   - FloatMenuMakerMap asked at the tree's position, not the
#                                                          click of a mouse on a screen
#   3   the song fires once                              - the cooldown, read as the tree's lastSongTick; no sound is
#                                                          heard, because the game has no speakers here
#   6.3 nobody goes on their own when it is off          - the giver's TryGiveJob, not a day of waiting
#   7   a blind colonist listens
#   8   the memory does not stack
#   9   the colonist who decides on their own            - TryGiveJob and the tolerance the kind builds; baseChance,
#                                                          how often recreation time picks the giver, is the base
#                                                          game's and is not measured
#   10  a wall, a roof                                   - line of sight and the roof read on the listeners' cells
#   11  Phytokin's own ability                           - that this mod patches nothing of theirs; not that the
#                                                          ability soothes when cast
#   12  a save with three listeners
#   13  the texts, and the fourth refusal                - read back in the language of the pass; the suite is played
#                                                          once per language
#
# Still not covered by any scenario, and said so in TESTING.md: 14 (removing the mod from a save and loading it
# again, which needs two games), that the halo is DRAWN (the Linux game renders in software), that a sound is
# HEARD, and that Phytokin's ability soothes.
Feature: the rest of the manual scenarios

  Background:
    Given the save "test-colony" is loaded

  # TESTING.md 2
  @timeout:60
  Scenario: a real right-click offers the order, and a drafted colonist is offered none
    Given a colonist "Clicker" exists
    Then Anima Song: right-clicking the tree at x=70 z=132 with "Clicker" selected offers the listening order
    When I draft "Clicker"
    Then Anima Song: no order is offered to "Clicker" for the tree at x=70 z=132

  # TESTING.md 7: only hearing is required, so a colonist who cannot see still listens.
  @timeout:120
  Scenario: a colonist who cannot see still listens
    Given a colonist "Blind" exists
    And Anima Song: "Blind" is made blind
    And "Blind" needs "Joy" is set to 10 percent
    And game speed is ultrafast
    When Anima Song: "Blind" is ordered to listen to the tree at x=70 z=132
    Then Anima Song: "Blind" sits in the ring of the tree at x=70 z=132

  # TESTING.md 3: the song fires once and then holds its tongue. Joy is kept low so that no colonist stands up
  # on full joy before the next one arrives.
  @timeout:300
  Scenario: the song fires once, then holds its tongue for its cooldown
    Given a colonist "Song-1" exists
    And a colonist "Song-2" exists
    And a colonist "Song-3" exists
    And "Song-1" needs "Joy" is set to 10 percent
    And "Song-2" needs "Joy" is set to 10 percent
    And "Song-3" needs "Joy" is set to 10 percent
    And game speed is ultrafast
    When Anima Song: "Song-1" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Song-1" sits in the ring of the tree at x=70 z=132
    And Anima Song: I note when the tree at x=70 z=132 last sang
    And Anima Song: "Song-2" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Song-2" sits in the ring of the tree at x=70 z=132
    Then Anima Song: the tree at x=70 z=132 has not sung since I noted it
    When I wait 5200 ticks
    And Anima Song: "Song-3" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Song-3" sits in the ring of the tree at x=70 z=132
    Then Anima Song: the tree at x=70 z=132 has sung again since I noted it

  # TESTING.md 8: listening twice in a row does not add up.
  @timeout:300
  Scenario: the memory does not stack
    Given a colonist "Twice" exists
    And "Twice" needs "Joy" is set to 10 percent
    And game speed is ultrafast
    When Anima Song: "Twice" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Twice" sits in the ring of the tree at x=70 z=132
    And I wait 1400 ticks
    And I draft "Twice"
    Then Anima Song: "Twice" holds 1 memory of the anima song
    When I undraft "Twice"
    And "Twice" needs "Joy" is set to 10 percent
    And Anima Song: "Twice" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Twice" sits in the ring of the tree at x=70 z=132
    And I wait 1400 ticks
    And I draft "Twice"
    Then Anima Song: "Twice" holds 1 memory of the anima song

  # TESTING.md 9: the giver that recreation time picks, and the recreation kind reaching the tolerance system.
  @timeout:300
  Scenario: the recreation giver finds the tree on its own, and the new kind builds tolerance
    Given a colonist "Wanderer" exists
    And "Wanderer" needs "Joy" is set to 10 percent
    And game speed is ultrafast
    Then Anima Song: the recreation giver offers "Wanderer" the tree at x=70 z=132
    When Anima Song: "Wanderer" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Wanderer" sits in the ring of the tree at x=70 z=132
    And I wait 600 ticks
    Then Anima Song: "Wanderer" has built tolerance for the anima song

  # TESTING.md 6 step 3: with listening forbidden nobody goes on their own. A day of waiting would only show
  # that nobody came; the giver is asked directly, with an open control first.
  @timeout:120
  Scenario: forbidding listening shuts the giver as well
    Given a colonist "Shut" exists
    And "Shut" needs "Joy" is set to 10 percent
    Then Anima Song: the recreation giver offers "Shut" the tree at x=70 z=132
    When Anima Song: I select the tree at x=70 z=132
    And Anima Song: I press the toggle of the selected tree
    Then Anima Song: the recreation giver offers "Shut" nothing

  # TESTING.md 10 step 2: a tree that has been built over is not offered.
  @timeout:120
  Scenario: a tree under a roof is not offered
    Given a colonist "Sheltered" exists
    And "Sheltered" needs "Joy" is set to 10 percent
    Then Anima Song: the recreation giver offers "Sheltered" the tree at x=70 z=132
    When Anima Song: the tree at x=70 z=132 is roofed over
    Then Anima Song: the recreation giver offers "Sheltered" nothing

  # TESTING.md 10 step 1: no one sits behind a wall.
  @timeout:300
  Scenario: with a wall to the north, every listener still has the tree in sight
    Given a colonist "Wall-1" exists
    And a colonist "Wall-2" exists
    And a colonist "Wall-3" exists
    And Anima Song: a wall stands north of the tree at x=70 z=132
    And game speed is ultrafast
    When Anima Song: "Wall-1" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Wall-2" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Wall-3" is ordered to listen to the tree at x=70 z=132
    Then Anima Song: 3 listeners sit on 3 different cells around the tree at x=70 z=132
    And Anima Song: every listener of the tree at x=70 z=132 has it in sight

  # TESTING.md 13: the fourth refusal, reached only when hearing and the reservation pass and no seat exists.
  @timeout:120
  Scenario: with the ring walled in the order is refused for want of a spot
    Given a colonist "Boxed" exists
    And Anima Song: the ring around the tree at x=70 z=132 is walled in
    Then Anima Song: the order offered to "Boxed" for the tree at x=70 z=132 is refused because "AnimaSong_OrderNoSeat"

  # TESTING.md 12: a save with listeners in the middle of their sitting, then the same tree singing again.
  @timeout:300
  Scenario: a save taken with three listeners loads clean, and the tree sings again
    Given a colonist "Save-1" exists
    And a colonist "Save-2" exists
    And a colonist "Save-3" exists
    And game speed is ultrafast
    When Anima Song: "Save-1" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Save-2" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Save-3" is ordered to listen to the tree at x=70 z=132
    Then Anima Song: 3 listeners sit on 3 different cells around the tree at x=70 z=132
    When Anima Song: I note when the tree at x=70 z=132 last sang
    And I save and reload
    Then Anima Song: the tree at x=70 z=132 last sang at the tick I noted
    And no errors were logged
    Given a colonist "Save-4" exists
    And "Save-4" needs "Joy" is set to 10 percent
    When Anima Song: "Save-4" is ordered to listen to the tree at x=70 z=132
    Then Anima Song: "Save-4" sits in the ring of the tree at x=70 z=132
    And Anima Song: the tree at x=70 z=132 is singing

  # TESTING.md 13: every owned text, in the language of the pass. English and French are two passes, not two
  # scenarios: the language is fixed at staging and never switched inside a run.
  @timeout:60
  Scenario: every text of the mod reads as its resource file says
    Then Anima Song: every text of the mod reads as its resource file says, in the language of this pass

  # TESTING.md 11: their ability is left alone. Conditional: it needs Phytokin, so it is skipped in a pass without it
  # and runs in the one with it.
  @requires:vanillaracesexpanded.phytokin @timeout:60
  Scenario: Phytokin's own anima song ability is left alone
    Then def "VRE_AnimaSong" exists
    And no def "VRE_AnimaSong" was patched
