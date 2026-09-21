# Captures a person has to look at. Nothing here asserts anything about an image.
#
# @review is this project's convention from AUDIT.md, not a Pickle tag, and it changes no
# behaviour. A green scenario below means the trajectory ran, never that the picture shows what it
# was meant to show: the halo, the waves of light, and whether the ring of listeners reads as a ring
# at all are judgements, and no assertion states them. AUDIT.md is explicit that a green @review
# does not count as a visual verification performed.
#
# @watch makes the wait steps pass REAL time instead of ticks. A run drives sixty ticks per rendered
# frame by default, so a wait counted in ticks passes almost no frames - and RimWorld's camera eases
# toward a new zoom per frame, not per tick. Without this tag the camera is still on its way when
# the shutter goes.
#
# TWO PASSES, TWO LANGUAGES. The second scenario photographs the tree's own interface - the toggle
# and the inspect line - in whichever language the pass was staged with. It is the evidence for
# TESTING.md scenario 13, and it is only worth anything with dev mode on: outside dev mode RimWorld
# shows clean English for a missing key, and the defect becomes invisible. In dev mode the fallback
# comes out in the deliberately accented form - a to a-grave, c to c-cedilla, n to n-with-tail - so
# a missing key is legible in the image. Clean English in the middle of a French run is the other
# symptom, and the worse one: it is a string that never went through Translate at all.
@review @watch
Feature: what the song looks like

  Background:
    Given the save "test-colony" is loaded
    And dev mode is enabled

  @timeout:180
  Scenario: the ring, the halo, and the waves of light
    Given a colonist "Shot-1" exists
    And a colonist "Shot-2" exists
    And a colonist "Shot-3" exists
    And game speed is ultrafast
    When Anima Song: "Shot-1" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Shot-2" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Shot-3" is ordered to listen to the tree at x=70 z=132
    Then Anima Song: 3 listeners sit on 3 different cells around the tree at x=70 z=132
    And Anima Song: the halo of the tree at x=70 z=132 is alive
    # Zoomed before it is aimed, and given real time to arrive. A wave of light leaves the trunk
    # every 120 ticks, so the wait also buys the chance of catching one in flight.
    When I zoom all the way in
    And I move the camera to (70, 132)
    And I wait 200 ticks
    Then the camera is looking at (70, 132)
    And Anima Song: the halo of the tree at x=70 z=132 is alive
    Then I take a screenshot "the ring listening, halo and waves"

  # THE HALO FILMED ONE PICTURE PER TICK. The two tick-by-tick scenarios of 01-the-song.feature give the
  # numbers; this one gives the pictures, so a person can see what a halo that is up one tick in fifteen
  # actually looks like, and whether it flashes or is simply never noticed.
  #
  # It uses the steps of PickleTools/FilmTicks, which film only BETWEEN the two of them (Pickle's @film films
  # from the first step, so the walk would use up its cap) and decide each picture from the tick counter.
  # They are not part of the mod under test: the pass that stages them is named, and the scenario is @wip so
  # every other pass skips it - without the mod its two steps would be undefined.
  #   -DepMap wsl-deps.film.map -pickle-include-wip, with a filter
  @wip @timeout:300
  Scenario: the halo filmed one picture per tick, with the camera on the tree
    Given a colonist "Reel" exists
    And game speed is ultrafast
    When Anima Song: "Reel" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Reel" sits in the ring of the tree at x=70 z=132
    And game speed is normal
    And I zoom all the way in
    And I move the camera to (70, 132)
    And I wait 60 ticks
    And Nelim's Pickle Tools: I film every 1 ticks as "halo per tick"
    And I wait 90 ticks
    And Nelim's Pickle Tools: I stop filming
    Then Anima Song: "Reel" is listening to the tree at x=70 z=132

  # The mod's own words, in the language this pass runs in. What to look for when the image comes
  # back: accented gibberish, which is dev mode saying a key is missing from the active language;
  # clean English inside a French run, which is a string hardcoded in C# or XML; a raw key; a
  # visible {0}; and anything clipped by its box.
  @same-world @timeout:120
  Scenario: the tree's interface in the language of this pass
    Given a colonist "Shot-4" exists
    And game speed is ultrafast
    When Anima Song: "Shot-4" is ordered to listen to the tree at x=70 z=132
    And Anima Song: "Shot-4" sits in the ring of the tree at x=70 z=132
    And Anima Song: I select the tree at x=70 z=132
    And I zoom all the way in
    And I move the camera to (70, 132)
    And I wait 200 ticks
    Then Anima Song: the tree at x=70 z=132 is singing
    Then I take a screenshot "tree selected while singing - toggle and inspect line"
    # The same interface with listening forbidden, which is the other inspect line and the state the
    # toggle reads in reverse.
    When Anima Song: I press the toggle of the selected tree
    And I wait 60 ticks
    Then Anima Song: the tree at x=70 z=132 forbids listening
    Then I take a screenshot "tree selected with listening forbidden"
