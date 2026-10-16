# Diagnostic for the RimWorld 1.7 pass (docs/runs/2026-10-13-1.7.md): on 1.7 the ordered colonist does not close in on the ring.
# This control sends a colonist to the same cell with a vanilla Goto job, no mod code, to tell a 1.7 pathing or test-map
# problem from a mod defect. @wip: not part of any pass; played alone with -IncludeWip, then deleted.
Feature: control, a vanilla walk on the test colony

  Background:
    Given the save "test-colony" is loaded

  @wip @same-world @timeout:120
  Scenario: control, a colonist walks to the tree with a vanilla Goto job
    Given a colonist "Walker" exists
    And game speed is ultrafast
    When Anima Song: control: "Walker" is sent walking to x=68 z=129
    Then Anima Song: control: "Walker" is within 6 cells of x=68 z=129
