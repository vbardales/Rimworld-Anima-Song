# Diagnostic for the RimWorld 1.7 pass (docs/runs/2026-10-13-1.7.md): a vanilla Goto (no mod code) did not close in on its cell
# in 90 s. Reading to confirm: the game ticks slowly headless, not a pathing defect. This control sends the colonist, then logs
# its movement every 5 s (wall time, ticks gained, speed, cell, job, pather state) with the PickleTools step. No verdict.
# @wip: not part of any pass; played alone with -IncludeWip, then deleted. 1.7 only (wsl-deps.17.map stages ColonistRace net10.0).
Feature: control, a vanilla walk on the test colony, movement logged

  Background:
    Given the save "test-colony" is loaded

  @wip @same-world @timeout:180 @requires:nelim.pickletools.colonistrace
  Scenario: control, a colonist walks with a vanilla Goto job and its movement is logged
    Given a colonist "Walker" exists
    And game speed is ultrafast
    When Anima Song: control: "Walker" is sent walking to x=68 z=129
    And Nelim's Pickle Tools: the movement of the colonist "Walker" is logged for 90 seconds
