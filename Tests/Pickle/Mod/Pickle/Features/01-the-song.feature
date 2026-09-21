# What only a running game can say about Anima Song.
#
# Everything provable without the game is proved without it, by _tools/Run-Functional-Tests.ps1:
# twenty checks in a couple of seconds against the installed game's own assembly and def files -
# the overrides, the patch's xpath run on the real anima tree def, the six defs looked up by name,
# the French memory handle, the Keyed parity. None of that appears here. A run confiscates the
# machine for tens of minutes; a scenario restating a unit test buys nothing with it.
#
# What is left is the five things that only exist while the game ticks:
#
#   - the comp actually ON a spawned tree, and its toggle in the gizmo bar. The offline suite runs
#     the patch operation over the def document; whether the loaded game ends up with the comp on
#     the tree it spawned, and shows it, is another question - and a PatchOperationConditional that
#     matched nothing says so in no way at all.
#   - the walk, and where the colonist sits. TryFindSeat is a radial sweep with line of sight and a
#     reachability test; nothing but a map answers it.
#   - the halo, which the job maintains tick by tick. A mote with needsMaintenance dies within a few
#     ticks if nobody pings it, and at ultrafast the job receives deltas worth 2 or 3 instead of 1.
#     This is exactly where it would start to blink or die.
#   - the toggle biting at once, and surviving a save and a reload, since it is stored on the tree.
#   - the seventh colonist refused in the MENU. A free cell is not a free slot: the ring holds sixty
#     cells and the job allows six pawns. Before the menu learnt to test the cap, the seventh walked
#     all the way over and ended on "TryMakePreToilReservations() returned false for a non-queued
#     job". That fix has never been replayed since it was written.
#
# THE TREE IS THE FIXTURE'S OWN. Pickle ships test-colony.rws, which holds a Royalty anima tree at
# (70, 132) with eight clear cells around it and no roof. Spawning one would test the spawner; this
# is the tree the game placed.
#
# NO STEP HERE SPELLS AN ENGLISH LABEL. The toggle is found by the translation of its own key and a
# refusal by the translation of the key the mod chose for it, so every scenario below holds in
# whichever language the pass was staged with - which is what makes the two -Language passes worth
# running at all.
Feature: listening to an anima tree sing

  Background:
    Given the save "test-colony" is loaded

  # The foundation: without the comp on the tree, nothing else in the mod exists.
  Scenario: the patch lands on the tree the game spawned
    Then Anima Song: the tree at x=70 z=132 carries the song comp
    When Anima Song: I select the tree at x=70 z=132
    Then Anima Song: the toggle of the selected tree is on
    And Anima Song: the tree at x=70 z=132 allows listening
    And no errors were logged

  # Both soft dependencies, and the only scenario whose expectation changes between the two passes:
  # it reads the modlist and demands Phytokin's recording and icon when Phytokin is there, Royalty's
  # when it is not. A lookup by def name that has silently fallen back fails here.
  Scenario: the song and the icon follow the modlist
    When Anima Song: I select the tree at x=70 z=132
    Then Anima Song: the song and the toggle icon come from the loaded mods
    And no errors were logged

  # The order, the walk, the seat, and the halo the job has to keep alive.
  # @timeout on every scenario that walks: a step with no timeout of its own gets the scenario's tag,
  # then FIVE seconds - and the fixture's colonists stand some sixty cells from the tree, which is
  # more than five seconds of walking. The first run (2026-09-21) lost three scenarios to that
  # alone, at "sits in the ring", while the three that carried a tag passed.
  @same-world @timeout:120
  Scenario: an ordered colonist walks out, sits in the ring, and the tree sings
    Given a colonist "Listener" exists
    And game speed is ultrafast
    When Anima Song: "Listener" is ordered to listen to the tree at x=70 z=132
    Then Anima Song: "Listener" is listening to the tree at x=70 z=132
    And Anima Song: "Listener" sits in the ring of the tree at x=70 z=132
    And Anima Song: the tree at x=70 z=132 is singing
    And Anima Song: the halo of the tree at x=70 z=132 is alive
    And no errors were logged

  # The halo again, after time has actually passed at speed. The check above catches a halo that
  # never starts; this one catches a halo that dies under deltas worth more than one tick.
  @same-world @timeout:120
  Scenario: the halo survives a stretch of ultrafast
    Given a colonist "Sitter" exists
    And game speed is ultrafast
    When Anima Song: "Sitter" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Sitter" sits in the ring of the tree at x=70 z=132
    And I wait 600 ticks
    Then Anima Song: "Sitter" is listening to the tree at x=70 z=132
    And Anima Song: the halo of the tree at x=70 z=132 stays alive
    And Anima Song: the tree at x=70 z=132 is singing

  # The two speeds a player actually uses. RimWorld's own are Normal 1x, Fast 3x, Superfast 6x and
  # Ultrafast 15x, and the "3x" TESTING.md scenario 4 and the mod's comments speak of is FAST. The
  # scenario above is the harsh case; these are the promised ones, and they are what tells a halo
  # that blinks only at a speed nobody plays at from one that blinks for everybody. The first run of
  # the sampler (2026-09-21, English 4 of 40 frames, French 13 of 40) was at ultrafast only.
  #
  # The colonist walks at ultrafast, because sixty cells at normal speed is a long time to hold the
  # machine, and the speed is set back only once they are sitting.
  @same-world @timeout:180
  Scenario: the halo holds at normal speed
    Given a colonist "Steady" exists
    And game speed is ultrafast
    When Anima Song: "Steady" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Steady" sits in the ring of the tree at x=70 z=132
    And game speed is normal
    And I wait 300 ticks
    Then Anima Song: "Steady" is listening to the tree at x=70 z=132
    And Anima Song: the halo of the tree at x=70 z=132 stays alive

  @same-world @timeout:180
  Scenario: the halo holds at 3x, the fast speed
    Given a colonist "Brisk" exists
    And game speed is ultrafast
    When Anima Song: "Brisk" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Brisk" sits in the ring of the tree at x=70 z=132
    And game speed is fast
    And I wait 300 ticks
    Then Anima Song: "Brisk" is listening to the tree at x=70 z=132
    And Anima Song: the halo of the tree at x=70 z=132 stays alive

  # The witness the three scenarios above lack. They found the halo up in 2 to 13 frames of 40 at every
  # speed, and a frame sampler cannot say why. This one reads the halo AFTER EVERY TICK, together with how
  # long ago the job last pinged the tree, so the two candidate causes separate: a job that pings less
  # often than the mote lives (age climbs to 2 or 3 between pings), a mote that dies despite a ping on
  # every tick (age 0 throughout, halo down), or a sampler that was simply wrong (halo up throughout).
  # The distribution is in the failure message and attached to the report whatever the verdict.
  @same-world @timeout:180
  Scenario: the halo, followed tick by tick at normal speed
    Given a colonist "Tally" exists
    And game speed is ultrafast
    When Anima Song: "Tally" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Tally" sits in the ring of the tree at x=70 z=132
    And game speed is normal
    And I wait 60 ticks
    Then Anima Song: the halo of the tree at x=70 z=132 is followed tick by tick for 300 ticks

  @same-world @timeout:180
  Scenario: the halo, followed tick by tick at 3x, the fast speed
    Given a colonist "Metre" exists
    And game speed is ultrafast
    When Anima Song: "Metre" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Metre" sits in the ring of the tree at x=70 z=132
    And game speed is fast
    And I wait 60 ticks
    Then Anima Song: the halo of the tree at x=70 z=132 is followed tick by tick for 300 ticks

  # The memory, which is gained in the job's finish action after half an in-game hour of sitting -
  # 1250 ticks. The offline suite proves the ThoughtDef and its French handle exist; only a sitting
  # grants it.
  @same-world @timeout:180
  Scenario: a full sitting leaves a memory, and a glance leaves none
    Given a colonist "Rememberer" exists
    And a colonist "Passerby" exists
    # Joy kept low on purpose: the job ends early on full joy - JoyTickCheckEnd with
    # JoyTickFullJoyAction.EndJob - and a colonist who arrives nearly satisfied would stand up
    # before the 1250 ticks the memory needs, failing this scenario for a reason that is not a fault.
    And "Rememberer" needs "Joy" is set to 10 percent
    And "Passerby" needs "Joy" is set to 10 percent
    And game speed is ultrafast
    When Anima Song: "Rememberer" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Rememberer" sits in the ring of the tree at x=70 z=132
    And I wait 1400 ticks
    And Anima Song: "Passerby" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Passerby" sits in the ring of the tree at x=70 z=132
    And I wait 60 ticks
    And I draft "Passerby"
    Then Anima Song: "Passerby" is not listening to the tree at x=70 z=132
    And "Passerby" has no thought "AnimaSong_Heard"
    When I draft "Rememberer"
    Then Anima Song: "Rememberer" is not listening to the tree at x=70 z=132
    And "Rememberer" has thought "AnimaSong_Heard"

  # The toggle has to clear the ring NOW - that is what it is for, before a psychic linking ritual -
  # and it is stored on the tree, so it has to come back after a reload.
  @same-world @timeout:120
  Scenario: the toggle empties the ring at once and survives a reload
    Given a colonist "Told" exists
    And game speed is ultrafast
    When Anima Song: "Told" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Told" sits in the ring of the tree at x=70 z=132
    And Anima Song: I select the tree at x=70 z=132
    And Anima Song: I press the toggle of the selected tree
    Then Anima Song: the tree at x=70 z=132 forbids listening
    And Anima Song: "Told" is not listening to the tree at x=70 z=132
    And Anima Song: the tree at x=70 z=132 is not singing
    And Anima Song: the order offered to "Told" for the tree at x=70 z=132 is refused because "AnimaSong_OrderForbidden"
    When I save and reload
    And Anima Song: I select the tree at x=70 z=132
    Then Anima Song: the tree at x=70 z=132 forbids listening
    And Anima Song: the toggle of the selected tree is off
    And no errors were logged

  # Hearing is the mod's only requirement, deliberately: a blind colonist still hears the tree.
  #
  # Deliberately NOT @same-world, and this is not tidiness. The refusals are tested in order and
  # "listening forbidden" comes first, so running this after the toggle scenario - which ends with
  # the tree forbidden - would produce the forbidden refusal and never reach the hearing one. The
  # Background reloads the fixture, which brings the toggle back on.
  Scenario: a colonist who cannot hear is refused in the menu
    Given a colonist "Deafened" exists
    And Anima Song: "Deafened" is made deaf
    Then Anima Song: the order offered to "Deafened" for the tree at x=70 z=132 is refused because "AnimaSong_OrderCannotHear"

  # The cap, and the fix that has never been replayed. Six sit; the seventh is refused BEFORE the
  # walk, in the menu, and comes back the moment a slot frees. A free cell is not a free slot.
  @timeout:300
  Scenario: six listeners fill the ring and the seventh is refused before walking
    Given a colonist "Ring-1" exists
    And a colonist "Ring-2" exists
    And a colonist "Ring-3" exists
    And a colonist "Ring-4" exists
    And a colonist "Ring-5" exists
    And a colonist "Ring-6" exists
    And a colonist "Ring-7" exists
    And game speed is ultrafast
    When Anima Song: "Ring-1" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Ring-2" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Ring-3" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Ring-4" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Ring-5" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Ring-6" is ordered to listen to the tree at x=70 z=132
    Then Anima Song: 6 listeners sit on 6 different cells around the tree at x=70 z=132
    And Anima Song: the order offered to "Ring-7" for the tree at x=70 z=132 is refused because "AnimaSong_OrderFull"
    # The base game says, in its own words, that this check belongs in the menu. Its absence is the
    # only thing this line would catch, and it catches it as a warning, not a failure.
    And no warning matching "TryMakePreToilReservations" was logged
    When I draft "Ring-1"
    Then Anima Song: "Ring-1" is not listening to the tree at x=70 z=132
    And Anima Song: the order offered to "Ring-7" for the tree at x=70 z=132 is available
