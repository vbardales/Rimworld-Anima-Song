# The pictures of the Workshop page, PUBLICATION.md. Same pattern as the other mods': each scenario loads PickleTools' disposable
# screenshot fixture, the Nelim zen meadow studio, frames its open glade, grows an anima tree at (154, 98), and takes the picture.
# Nothing asserts about an image: a person opens each one, and a passing scenario says only that the route ran.
#
# The studio's colonists stand there without clothes, so each one that shows is dressed in a robe first. The robes are made of
# materials whose colours stand out from the teal glow and the green meadow (Devilstrand deep red, plain leather brown,
# Synthread), so each listener reads as a person on the thumbnail (owner, 2026-10-01; PUBLICATION.md). Not played yet: the
# pictures are to be opened and judged after the next `studio` pass.
#
# Owner's note on the first run (2026-09-26, images approved as they stood): "the tree singing" reads a little too wide -
# the camera at (154, 98) is not exactly where the three listeners end up sitting. Zoom in closer next time this scenario
# is redone.
#
# 1 the tree singing, with its glow and its listeners, no interface (the game's screenshot mode on)
# 2 the right-click menu that offers the order, the interface kept
# 3 the tree selected with its toggle, developer mode off, the interface kept
#
# `@requires:nelim.pickletools.screenshotstudio`: only the pass of `-DepMap wsl-deps.studio.map`, in English, plays this feature;
# every other pass skips it. Aim at it with `-Filter '05-workshop-captures'`.
@requires:nelim.pickletools.screenshotstudio
@workshop @review
Feature: the pictures of the Workshop page

  @timeout:240
  Scenario: the tree singing, with its glow and its listeners
    Given the save "nelim-zen-meadow-studio" is loaded
    And Nelim's Pickle Tools: I frame the studio "flowers"
    And Anima Song: an anima tree grows at x=154 z=98
    And game speed is ultrafast
    And I destroy the gear of "Miel"
    And I dress "Miel" in "Apparel_Robe" made of "Devilstrand"
    And I destroy the gear of "Flore"
    And I dress "Flore" in "Apparel_Robe" made of "Leather_Plain"
    And I destroy the gear of "Soleil"
    And I dress "Soleil" in "Apparel_Robe" made of "Synthread"
    And "Miel" needs "Joy" is set to 10 percent
    And "Flore" needs "Joy" is set to 10 percent
    And "Soleil" needs "Joy" is set to 10 percent
    When Anima Song: "Miel" is ordered to listen to the tree at x=154 z=98
    And Anima Song: "Flore" is ordered to listen to the tree at x=154 z=98
    And Anima Song: "Soleil" is ordered to listen to the tree at x=154 z=98
    Then Anima Song: 3 listeners sit on 3 different cells around the tree at x=154 z=98
    And Anima Song: the halo of the tree at x=154 z=98 is alive
    When game speed is normal
    And I zoom all the way in
    And I move the camera to (154, 98)
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I wait 120 ticks
    Then Anima Song: the halo of the tree at x=154 z=98 is alive
    And I take a screenshot "workshop 1 - the tree singing"

  @timeout:120
  Scenario: the right-click menu that offers the order
    Given the save "nelim-zen-meadow-studio" is loaded
    And Nelim's Pickle Tools: I frame the studio "flowers"
    And Anima Song: an anima tree grows at x=154 z=98
    And I destroy the gear of "Miel"
    And I dress "Miel" in "Apparel_Robe" made of "Devilstrand"
    When I zoom all the way in
    And I move the camera to (154, 98)
    And I wait 60 ticks
    And Anima Song: the right-click menu of the tree at x=154 z=98 is open for "Miel"
    And I wait 30 ticks
    Then I take a screenshot "workshop 2 - the right-click menu"
    When Anima Song: the right-click menu is closed

  @timeout:120
  Scenario: the tree selected with its toggle
    Given the save "nelim-zen-meadow-studio" is loaded
    And Nelim's Pickle Tools: I frame the studio "flowers"
    And Anima Song: an anima tree grows at x=154 z=98
    When I zoom all the way in
    And I move the camera to (154, 98)
    And Anima Song: I select the tree at x=154 z=98
    And Nelim's Pickle Tools: developer mode is turned off for the capture
    And I wait 60 ticks
    Then I take a screenshot "workshop 3 - the tree selected"
