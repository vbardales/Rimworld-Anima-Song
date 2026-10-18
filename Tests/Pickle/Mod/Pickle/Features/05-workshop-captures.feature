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
# SHOOTING PLAN, 2026-10-18 (session as director, GALLERY.md; WRITTEN, NOT PLAYED, nothing here is played before shootGallery). One story, one clearing, one tree, the day turning: a day with the singing tree. Protagonist Nelim; one common set (bare-clearing, tree at (195, 152), zoom 5, 20 degrees, game mode off); the set is posed, shot and removed in each scenario.
# Order of the scenarios = order of the story (indexes in Art/Gallery are assigned at the reindex; the noon crowd stays the lead image, the most demonstrative):
#   Orientation (z grows northward, the tree is at z 152): a seat at z 155 is NORTH of the tree and its sitter faces South; a seat at z 149 is SOUTH of it and its sitter faces North; x 191 faces East, x 199 faces West. Run 176a (seat z 155 facing North, back to the tree) was refused.
#   A dawn, hour 6: Nelim alone, plum robe and Cape, seated north of the tree facing it, anima grass fully grown on the ring, a hare and a squirrel at the edge, the tree barely glowing. Says: it sings for one listener too. Tight shot (zoom 6), low sun.
#   B noon, hour 12 (the accepted lead, kept): three listeners (Nelim, Flore, Soleil), torch, daylilies, stools. Says: colonists sit in a ring and the tree answers. Peacock and labrador added at the edge, seen from the front. Wide.
#   C the right-click menu (UI, not staged, kept). D the tree selected with its toggle (UI, not staged, kept).
#   E dusk, hour 18: the ring nearly full, five listeners in five robes (plum, saffron, ivory, indigo, sapphire), a headwrap, an old man with a Wizard beard, a face tattoo (Face_Stars), torch lit, the glow at its strongest. Says: several sit at once (five here), and the glow is what you see from across the map. Wide, low angle on the glow.
#   F night, hour 22: Nelim back alone, a labrador asleep at her feet, the torch low, the halo pulsing. Says: the tree sings after dark too, for one listener and a sleeping dog (the +3 mood memory does not show on a picture, it stays in the text). Tight (zoom 6).
# Looks come from NPT catalogues (PickleTools/ColonistRace/docs: CATALOGUE-LOOKS, CATALOGUE-APPAREL, CATALOGUE-COLOURS, FACE-PARTS): hairstyles Bob, Mop, Afro, Cleopatra, Elder, Princess; beard Wizard; face tattoo Face_Stars; garments Apparel_Robe (Core, dyed), Apparel_Cape, Apparel_Headwrap (Ideology). Palette: robes and hair chosen to stand out from the teal glow and the brown earth. All vanilla or DLC: nothing to add to the pass map and nothing to credit.
# Animals: vanilla kinds Hare, Squirrel, Peacock, LabradorRetriever (names to confirm on the first run, Check-Steps.ps1 then the run). Animals face the camera where the step allows it; no step sets an animal's rotation yet: ask NPT through the TM if the first run shows backs. Diurnal animals by day, the labrador asleep at night.
# Plants: Plant_GrassAnima fully grown on the ring (the grass the linking ritual needs, a nod to the mod's design), set with `the plants from (x, z) to (x, z) are fully grown` (StageDecor, not played yet); Plant_Daylily as before.
# Transitions: the hour changes per image (I set the hour to N), the weather stays Clear, the lamp is lit only from dusk; the one visible thread of the story is Nelim's robe, her seat and the tree, the same corner each time.
# Subtitles (English, one line each, PUBLICATION.md "Gallery subtitles") are drafted there and applied after the reindex.
# Owner's note on the first run (2026-09-26): the camera reads a little wide; zoom in closer when the scenario is redone.
#
# `@requires:nelim.pickletools.screenshotstudio`: only the pass of `-DepMap wsl-deps.sanctuary.map`, in English, plays this feature;
# every other pass skips it. Aim at it with `-Filter '05-workshop-captures'`. NOT played on `bare-clearing` yet. Positions (estimated by the Pickle Tools session on a capture, not on the file): the tree at (195, 152); the listeners 4 cells out; the lamp and the lilies 5 to 6 cells out, outside the ring (2 to 5 cells) so that they take no seat; the camera on the tree at zoom 5 (18 x 10 cells; the limit is lifted after `I am at the sanctuary`).
@requires:nelim.pickletools.screenshotstudio @requires:nelim.pickletools.screenshotmode @requires:nelim.pickletools.stagedecor
@workshop @review
Feature: the pictures of the Workshop page

  @timeout:240 @wip
  Scenario: dawn, one listener and the first light
    Given the save "Nelims-tribe" is loaded
    And Nelim's Sanctuary: I am at the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are removed from the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are kept out of the sanctuary "bare-clearing"
    And I set the hour to 6
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Anima Song: an anima tree grows at x=195 z=152
    And Nelim's Pickle Tools: I place the decor "Plant_GrassAnima" at (193, 156)
    And Nelim's Pickle Tools: I place the decor "Plant_GrassAnima" at (197, 156)
    And Nelim's Pickle Tools: I place the decor "Plant_GrassAnima" at (191, 150)
    And Nelim's Pickle Tools: the plants from (190, 148) to (200, 158) are fully grown
    And Nelim's Pickle Tools: I place the decor "Stool" at (195, 155)
    And Nelim's Pickle Tools: an adult animal of kind "Hare" named "Brume" is spawned at (190, 158)
    And Nelim's Pickle Tools: an adult animal of kind "Squirrel" named "Noisette" is spawned at (200, 157)
    And Nelim's Pickle Tools: "Nelim" stands at (195, 155) facing South
    And game speed is ultrafast
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Bob"
    And Nelim's Pickle Tools: "Nelim" hair colour is rgb (120, 40, 30)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Robe" dyed rgb (140, 40, 90)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Cape" dyed rgb (240, 235, 215)
    And Nelim's Sanctuary: Nelim has her own face
    And "Nelim" needs "Joy" is set to 10 percent
    When Anima Song: "Nelim" is ordered to listen to the tree at x=195 z=152 from the seat (195, 155)
    Then Anima Song: 1 listeners sit on 1 different cells around the tree at x=195 z=152
    And Anima Song: the halo of the tree at x=195 z=152 is alive
    And Nelim's Pickle Tools: I frame the cell (195, 153) at zoom 6
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I wait 60 ticks
    And I take a screenshot "workshop A - dawn"
    When Nelim's Pickle Tools: the decor is removed

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
    And Nelim's Pickle Tools: an adult animal of kind "Peacock" named "Paon" is spawned at (189, 156)
    And Nelim's Pickle Tools: an adult animal of kind "LabradorRetriever" named "Biscuit" is spawned at (201, 156)
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
    And Nelim's Sanctuary: the vanometric cell of the sanctuary is hidden
    And Nelim's Sanctuary: I am at the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are removed from the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are kept out of the sanctuary "bare-clearing"
    And I set the hour to 12
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Anima Song: an anima tree grows at x=195 z=152
    And Nelim's Pickle Tools: the artificial buildings within 30 cells of (195, 152) are hidden
    When Nelim's Pickle Tools: I frame the cell (195, 152) at zoom 5
    And Anima Song: I select the tree at x=195 z=152
    And Nelim's Pickle Tools: the resource readout is hidden
    And Nelim's Pickle Tools: the colonist bar is hidden
    And Nelim's Pickle Tools: the alerts are hidden
    And Nelim's Pickle Tools: the learning helper is hidden
    And Nelim's Pickle Tools: developer mode is turned off for the capture
    And I wait 60 ticks
    And Nelim's Pickle Tools: the letters and the alerts are cleared from the screen
    And Nelim's Pickle Tools: the messages are cleared from the screen
    Then I take a screenshot "workshop 3 - the tree selected"

  @timeout:300 @wip
  Scenario: dusk, five listeners and the glow at its strongest
    Given the save "Nelims-tribe" is loaded
    And Nelim's Sanctuary: I am at the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are removed from the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are kept out of the sanctuary "bare-clearing"
    And I set the hour to 18
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Anima Song: an anima tree grows at x=195 z=152
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (200, 156)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (200, 156) is lit
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (190, 156)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (190, 156) is lit
    And a colonist "Flore" exists
    And a colonist "Soleil" exists
    And a colonist "Oren" exists
    And a colonist "Ysa" exists
    And Nelim's Pickle Tools: "Flore" body type is Thin
    And Nelim's Pickle Tools: "Soleil" body type is Male
    And Nelim's Pickle Tools: "Oren" body type is Fat
    And Nelim's Pickle Tools: "Ysa" body type is Female
    And Nelim's Pickle Tools: I place the decor "Stool" at (195, 155)
    And Nelim's Pickle Tools: I place the decor "Stool" at (191, 152)
    And Nelim's Pickle Tools: I place the decor "Stool" at (199, 152)
    And Nelim's Pickle Tools: I place the decor "Stool" at (193, 149)
    And Nelim's Pickle Tools: I place the decor "Stool" at (197, 149)
    And Nelim's Pickle Tools: "Nelim" stands at (195, 155) facing South
    And Nelim's Pickle Tools: "Flore" stands at (191, 152) facing East
    And Nelim's Pickle Tools: "Soleil" stands at (199, 152) facing West
    And Nelim's Pickle Tools: "Oren" stands at (193, 149) facing North
    And Nelim's Pickle Tools: "Ysa" stands at (197, 149) facing North
    And game speed is ultrafast
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Bob"
    And Nelim's Pickle Tools: "Nelim" hair colour is rgb (120, 40, 30)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Robe" dyed rgb (140, 40, 90)
    And Nelim's Sanctuary: Nelim has her own face
    And Nelim's Pickle Tools: "Flore" hairstyle is "Mop"
    And Nelim's Pickle Tools: "Flore" hair colour is rgb (235, 235, 230)
    And Nelim's Pickle Tools: "Flore" wears "Apparel_Robe" dyed rgb (235, 180, 50)
    And Nelim's Pickle Tools: "Soleil" hairstyle is "Afro"
    And Nelim's Pickle Tools: "Soleil" hair colour is rgb (200, 150, 60)
    And Nelim's Pickle Tools: "Soleil" wears "Apparel_Robe" dyed rgb (240, 235, 215)
    And Nelim's Pickle Tools: "Oren" hairstyle is "Elder"
    And Nelim's Pickle Tools: "Oren" hair colour is rgb (220, 220, 225)
    And Nelim's Pickle Tools: "Oren" beard is "Wizard"
    And Nelim's Pickle Tools: "Oren" wears "Apparel_Robe" dyed rgb (60, 50, 120)
    And Nelim's Pickle Tools: "Oren" wears "Apparel_Headwrap" dyed rgb (230, 120, 40)
    And Nelim's Pickle Tools: "Ysa" hairstyle is "Princess"
    And Nelim's Pickle Tools: "Ysa" hair colour is rgb (240, 170, 200)
    And Nelim's Pickle Tools: "Ysa" face tattoo is "Face_Stars"
    And Nelim's Pickle Tools: "Ysa" wears "Apparel_Robe" dyed rgb (40, 80, 150)
    And "Nelim" needs "Joy" is set to 10 percent
    And "Flore" needs "Joy" is set to 10 percent
    And "Soleil" needs "Joy" is set to 10 percent
    And "Oren" needs "Joy" is set to 10 percent
    And "Ysa" needs "Joy" is set to 10 percent
    When Anima Song: "Nelim" is ordered to listen to the tree at x=195 z=152 from the seat (195, 155)
    And Anima Song: "Flore" is ordered to listen to the tree at x=195 z=152 from the seat (191, 152)
    And Anima Song: "Soleil" is ordered to listen to the tree at x=195 z=152 from the seat (199, 152)
    And Anima Song: "Oren" is ordered to listen to the tree at x=195 z=152 from the seat (193, 149)
    And Anima Song: "Ysa" is ordered to listen to the tree at x=195 z=152 from the seat (197, 149)
    Then Anima Song: 5 listeners sit on 5 different cells around the tree at x=195 z=152
    And Anima Song: the halo of the tree at x=195 z=152 is alive
    And Nelim's Pickle Tools: I frame the cell (195, 152) at zoom 5
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I wait 30 ticks
    Then Anima Song: 5 listeners sit on 5 different cells around the tree at x=195 z=152
    And I take a screenshot "workshop E - dusk"
    When Nelim's Pickle Tools: the decor is removed

  @timeout:240 @wip
  Scenario: night, Nelim alone again and a sleeping dog
    Given the save "Nelims-tribe" is loaded
    And Nelim's Sanctuary: I am at the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are removed from the sanctuary "bare-clearing"
    And Nelim's Sanctuary: the animals are kept out of the sanctuary "bare-clearing"
    And I set the hour to 22
    And I set the weather to "Clear"
    And Nelim's Pickle Tools: the temperature of the map is 20 degrees
    And Anima Song: an anima tree grows at x=195 z=152
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (200, 156)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (200, 156) is lit
    And Nelim's Pickle Tools: I place the decor "Stool" at (195, 155)
    And Nelim's Pickle Tools: an adult animal of kind "LabradorRetriever" named "Biscuit" is spawned at (193, 156)
    And Nelim's Pickle Tools: "Nelim" stands at (195, 155) facing South
    And game speed is ultrafast
    And Nelim's Pickle Tools: "Nelim" hairstyle is "Bob"
    And Nelim's Pickle Tools: "Nelim" hair colour is rgb (120, 40, 30)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Robe" dyed rgb (140, 40, 90)
    And Nelim's Pickle Tools: "Nelim" wears "Apparel_Cape" dyed rgb (240, 235, 215)
    And Nelim's Sanctuary: Nelim has her own face
    And "Nelim" needs "Joy" is set to 10 percent
    When Anima Song: "Nelim" is ordered to listen to the tree at x=195 z=152 from the seat (195, 155)
    Then Anima Song: 1 listeners sit on 1 different cells around the tree at x=195 z=152
    And Anima Song: the halo of the tree at x=195 z=152 is alive
    And Nelim's Pickle Tools: I frame the cell (195, 154) at zoom 6
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I wait 60 ticks
    And I take a screenshot "workshop F - night"
    When Nelim's Pickle Tools: the decor is removed
