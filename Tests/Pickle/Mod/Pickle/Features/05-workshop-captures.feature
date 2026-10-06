# The pictures of the Workshop page, PUBLICATION.md. Played on the shared gallery scene, the Sanctuaire de Nelim (PickleTools/docs/GALERIE.md,
# docs/SANCTUAIRE-LIEUX.md): `the save "Nelims-tribe" is loaded`, then `I am at the sanctuary "podium"`, the 14 x 14 bare square the mods stage on.
# The Sanctuaire has a single colonist, Nelim (the owner); the people of the pictures are made by the scenario. Nothing asserts about an
# image: a person opens each one, and a passing scenario says only that the route ran.
#
# The series is a staged photograph, except the menus (PUBLISHING.md, rule of 2026-10-02). Its little story: a quiet noon at the podium,
# three friends have come out to the anima tree, a torch lamp lit beside them and daylilies at their feet. One common set (the podium, the
# tree, the lamp, the lilies, set down by StageDecor and taken away again); the subjects are chosen, not random: three different bodies,
# robes of three materials that stand out from the teal glow and the bare earth (Devilstrand deep red, plain leather brown, Synthread). Hair is
# left alone: this mod adds no hairstyle, and no step sets a hair colour. No tattoo: none would mean anything here. Pictures 2 and 3 are
# menus and a selected tree with its interface: screenshots of what they are, not staged.
#
# 1 the tree singing, with its glow and its listeners, no interface (the game's screenshot mode on)
# 2 the right-click menu that offers the order, the interface kept
# 3 the tree selected with its toggle, developer mode off, the interface kept
#
# Owner's note on the first run (2026-09-26): the camera reads a little wide; zoom in closer when the scenario is redone.
#
# `@requires:nelim.pickletools.screenshotstudio`: only the pass of `-DepMap wsl-deps.sanctuary.map`, in English, plays this feature;
# every other pass skips it. Aim at it with `-Filter '05-workshop-captures'`. NOT played yet: written 2026-10-05 for the Sanctuaire, whose
# final fixture was not installed (wait for the Pickle Tools session's "fixture prête"). Positions: the tree at (196, 152), the middle of the podium; the
# listeners 4 cells out, the lamp and the lilies 7 cells out at the corners, outside the ring (2 to 5 cells) so that they take no seat; the podium is bare
# earth, not a green meadow. Unchecked until the first run: that the cells 4 out are free, and the def names of the decor.
@requires:nelim.pickletools.screenshotstudio
@workshop @review
Feature: the pictures of the Workshop page

  @timeout:240
  Scenario: the tree singing, with its glow and its listeners
    Given the save "Nelims-tribe" is loaded
    And Nelim's Pickle Tools: I am at the sanctuary "podium"
    And I set the hour to 12
    And I set the weather to "Clear"
    And Anima Song: an anima tree grows at x=196 z=152
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (202, 156)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (202, 156) is lit
    And Nelim's Pickle Tools: I place the decor "Plant_Daylily" at (191, 157)
    And Nelim's Pickle Tools: I place the decor "Plant_Daylily" at (201, 147)
    And a colonist "Miel" exists
    And a colonist "Flore" exists
    And a colonist "Soleil" exists
    And Nelim's Pickle Tools: "Miel" body type is Female
    And Nelim's Pickle Tools: "Flore" body type is Thin
    And Nelim's Pickle Tools: "Soleil" body type is Male
    And Anima Song: "Miel" stands 4 cells from the tree at x=196 z=152
    And Anima Song: "Flore" stands 4 cells from the tree at x=196 z=152
    And Anima Song: "Soleil" stands 4 cells from the tree at x=196 z=152
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
    When Anima Song: "Miel" is ordered to listen to the tree at x=196 z=152
    And Anima Song: "Flore" is ordered to listen to the tree at x=196 z=152
    And Anima Song: "Soleil" is ordered to listen to the tree at x=196 z=152
    Then Anima Song: 3 listeners sit on 3 different cells around the tree at x=196 z=152
    And Anima Song: the halo of the tree at x=196 z=152 is alive
    When game speed is normal
    And I zoom all the way in
    And I move the camera to (196, 152)
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I wait 120 ticks
    Then Anima Song: the halo of the tree at x=196 z=152 is alive
    And I take a screenshot "workshop 1 - the tree singing"
    When Nelim's Pickle Tools: the decor is removed

  @timeout:120
  Scenario: the right-click menu that offers the order
    Given the save "Nelims-tribe" is loaded
    And Nelim's Pickle Tools: I am at the sanctuary "podium"
    And I set the hour to 12
    And I set the weather to "Clear"
    And Anima Song: an anima tree grows at x=196 z=152
    And a colonist "Miel" exists
    And Anima Song: "Miel" stands 4 cells from the tree at x=196 z=152
    And I destroy the gear of "Miel"
    And I dress "Miel" in "Apparel_Robe" made of "Devilstrand"
    When I zoom all the way in
    And I move the camera to (196, 152)
    And I wait 60 ticks
    And Anima Song: the right-click menu of the tree at x=196 z=152 is open for "Miel"
    And I wait 30 ticks
    Then I take a screenshot "workshop 2 - the right-click menu"
    When Anima Song: the right-click menu is closed

  @timeout:120
  Scenario: the tree selected with its toggle
    Given the save "Nelims-tribe" is loaded
    And Nelim's Pickle Tools: I am at the sanctuary "podium"
    And I set the hour to 12
    And I set the weather to "Clear"
    And Anima Song: an anima tree grows at x=196 z=152
    When I zoom all the way in
    And I move the camera to (196, 152)
    And Anima Song: I select the tree at x=196 z=152
    And Nelim's Pickle Tools: developer mode is turned off for the capture
    And I wait 60 ticks
    Then I take a screenshot "workshop 3 - the tree selected"
