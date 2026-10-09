# Steps of two origins, told apart by their prefix: `Nelim's Sanctuary:` (SanctuaryBacklot: the named places, animals, bare floor, genes) and `Nelim's Pickle Tools:` (PickleTools: decor, camera framing, hair, dyed clothes, body type, hidden overlays, presentation mode); `Anima Song:` steps are this mod's own (Tests/Pickle/Source).
# The pictures of the Workshop page, PUBLICATION.md. Played on the shared gallery scene, the Sanctuaire de Nelim (SanctuaryBacklot/docs/GALERIE.md,
# Heat: the map is held at 20 degrees so nobody sweats or blushes (the biome is 40C).
# Faces: `"X" facial expression is "<FaceAnimationDef>"` (PickleTools ColonistRace, 2026-10-08, NOT PLAYED: NPT's ticket 2532 says whether the expression holds during a capture); SocialRelax tried for the three listeners.
# Eyes: Nelim has the brown eyes of EyeGenes3 by default in the fixture (nothing to set); the companions get their own with `has the gene "Eyes_<colour>"`. Faces: no step sets an expression; Facial Animation draws a face from the pawn's current JOB, and it maps none to the listening job, so the faces stay neutral (to be read on the picture).
# SanctuaryBacklot/docs/SANCTUAIRE-LIEUX.md): `the save "Nelims-tribe" is loaded`, then `I am at the sanctuary "bare-clearing"`, a scene made with the Pickle Tools session for this mod (2026-10-06): the podium square of `emerald-clearing` without its green rug (the floor is bared by the step itself), centre (195, 152), x 191-204, z 147-157 free, brown earth, no roof, no smiley, no black edge; the vanometric pile at x 205 is out of frame at zoom 5. Earlier tries: `emerald-clearing` (the teal halo drowned in the green rug) and `calm-zone` (not a scene agreed with them).
# The Sanctuaire has a single colonist, Nelim (the owner, the protagonist of the series): she is the first listener of picture 1, with two companions made by the scenario (Flore, Soleil). Her hairstyle, hair colour and robe are set for the picture (the owner agreed, 2026-10-07); her body is left alone. Nothing asserts about an
# image: a person opens each one, and a passing scenario says only that the route ran.
#
# The series is a staged photograph, except the menus (PUBLISHING.md, rule of 2026-10-02). Its little story: a quiet noon in the clearing,
# Nelim has come out to the anima tree with two friends, a torch lamp lit beside them and daylilies at their feet. One common set (the clearing, the
# tree, the lamp, the lilies, set down by StageDecor and taken away again); the subjects are chosen, not random: three different bodies,
# robes dyed in three colours that stand out from the teal glow and the brown earth (plum, saffron, ivory), each with its own hairstyle and hair colour. Pawns are set with the steps of PickleTools ColonistRace (hairstyle, hair colour, dyed clothes, body type, TMW 2026-10-07). No tattoo: none would mean anything here.
# Pictures 2 and 3 are
# menus and a selected tree with its interface: screenshots of what they are, not staged.
#
# 1 the tree singing, with its glow and its listeners, no interface (the game's screenshot mode on)
# 2 the right-click menu that offers the order, the interface kept
# 3 the tree selected with its toggle, developer mode off, the interface kept
#
# Owner's note on the first run (2026-09-26): the camera reads a little wide; zoom in closer when the scenario is redone.
#
# `@requires:nelim.pickletools.screenshotstudio`: only the pass of `-DepMap wsl-deps.sanctuary.map`, in English, plays this feature;
# every other pass skips it. Aim at it with `-Filter '05-workshop-captures'`. NOT played on `bare-clearing` yet. Positions (estimated by the Pickle Tools session on a capture, not on the file): the tree at (195, 152); the listeners 4 cells out; the lamp and the lilies 5 to 6 cells out, outside the ring (2 to 5 cells) so that they take no seat; the camera on the tree at zoom 5 (18 x 10 cells; the limit is lifted after `I am at the sanctuary`).
@requires:nelim.pickletools.screenshotstudio
@workshop @review
Feature: the pictures of the Workshop page

  @timeout:240
  Scenario: the tree singing, with its glow and its listeners
    Given the save "Nelims-tribe" is loaded
    And Nelim's Sanctuary: I am at the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are removed from the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are kept out of the sanctuary "bare-clearing"
    And I set the hour to 12
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Anima Song: an anima tree grows at x=195 z=152
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (200, 156)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (200, 156) is lit
    And Nelim's Pickle Tools: I place the decor "Plant_Daylily" at (192, 155)
    And Nelim's Pickle Tools: I place the decor "Plant_Daylily" at (198, 148)
    And Nelim's Pickle Tools: I place the decor "Plant_Daylily" at (190, 148)
    And Nelim's Pickle Tools: I place the decor "Plant_Daylily" at (200, 154)
    And a colonist "Flore" exists
    And a colonist "Soleil" exists
    And Nelim's Pickle Tools: "Flore" body type is Thin
    And Nelim's Pickle Tools: "Soleil" body type is Male
    And Nelim's Pickle Tools: I place the decor "Stool" at (195, 155)
    And Nelim's Pickle Tools: I place the decor "Stool" at (191, 152)
    And Nelim's Pickle Tools: I place the decor "Stool" at (199, 152)
    And Nelim's Pickle Tools: "Nelim" stands at (195, 155) facing South
    And Nelim's Pickle Tools: "Flore" stands at (191, 152) facing East
    And Nelim's Pickle Tools: "Soleil" stands at (199, 152) facing West
    And game speed is ultrafast
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Bob"
    And Nelim's Pickle Tools: "Nelim" hair colour is rgb (120, 40, 30)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Robe" dyed rgb (140, 40, 90)
    And Nelim's Pickle Tools: "Nelim" facial expression is "SocialRelax"
    And Nelim's Pickle Tools: "Flore" has the gene "Eyes_Blue"
    And Nelim's Pickle Tools: "Flore" hairstyle is "Mop"
    And Nelim's Pickle Tools: "Flore" hair colour is rgb (235, 235, 230)
    And Nelim's Pickle Tools: "Flore" wears "Apparel_Robe" dyed rgb (235, 180, 50)
    And Nelim's Pickle Tools: "Flore" facial expression is "SocialRelax"
    And Nelim's Pickle Tools: "Soleil" has the gene "Eyes_Green"
    And Nelim's Pickle Tools: "Soleil" hairstyle is "Afro"
    And Nelim's Pickle Tools: "Soleil" hair colour is rgb (200, 150, 60)
    And Nelim's Pickle Tools: "Soleil" wears "Apparel_Robe" dyed rgb (240, 235, 215)
    And Nelim's Pickle Tools: "Soleil" facial expression is "SocialRelax"
    And "Nelim" needs "Joy" is set to 10 percent
    And "Flore" needs "Joy" is set to 10 percent
    And "Soleil" needs "Joy" is set to 10 percent
    When Anima Song: "Nelim" is ordered to listen to the tree at x=195 z=152 from the seat (195, 155)
    And Anima Song: "Flore" is ordered to listen to the tree at x=195 z=152 from the seat (191, 152)
    And Anima Song: "Soleil" is ordered to listen to the tree at x=195 z=152 from the seat (199, 152)
    Then Anima Song: 3 listeners sit on 3 different cells around the tree at x=195 z=152
    And Anima Song: the halo of the tree at x=195 z=152 is alive
    And Nelim's Pickle Tools: I frame the cell (195, 152) at zoom 5
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I wait 30 ticks
    Then Anima Song: the halo of the tree at x=195 z=152 is alive
    And Anima Song: 3 listeners sit on 3 different cells around the tree at x=195 z=152
    And I take a screenshot "workshop 1 - the tree singing"
    When Nelim's Pickle Tools: the decor is removed

  @timeout:120
  Scenario: the right-click menu that offers the order
    Given the save "Nelims-tribe" is loaded
    And Nelim's Sanctuary: I am at the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are removed from the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are kept out of the sanctuary "bare-clearing"
    And I set the hour to 12
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Anima Song: an anima tree grows at x=195 z=152
    And Anima Song: "Nelim" stands 4 cells from the tree at x=195 z=152
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Bob"
    And Nelim's Pickle Tools: "Nelim" hair colour is rgb (120, 40, 30)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Robe" dyed rgb (140, 40, 90)
    When Nelim's Pickle Tools: I frame the cell (195, 152) at zoom 5
    And Nelim's Pickle Tools: the resource readout is hidden
    And Nelim's Pickle Tools: the learning helper is hidden
    And Nelim's Pickle Tools: the alerts are hidden
    And I wait 5 ticks
    And Anima Song: the right-click menu of the tree at x=195 z=152 is open for "Nelim"
    And I wait 30 ticks
    Then I take a screenshot "workshop 2 - the right-click menu"
    When Anima Song: the right-click menu is closed

  @timeout:120
  Scenario: the tree selected with its toggle
    Given the save "Nelims-tribe" is loaded
    And Nelim's Sanctuary: I am at the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are removed from the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are kept out of the sanctuary "bare-clearing"
    And I set the hour to 12
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Anima Song: an anima tree grows at x=195 z=152
    When Nelim's Pickle Tools: I frame the cell (195, 152) at zoom 5
    And Anima Song: I select the tree at x=195 z=152
    And Nelim's Pickle Tools: the resource readout is hidden
    And Nelim's Pickle Tools: the learning helper is hidden
    And Nelim's Pickle Tools: developer mode is turned off for the capture
    And I wait 60 ticks
    Then I take a screenshot "workshop 3 - the tree selected"
