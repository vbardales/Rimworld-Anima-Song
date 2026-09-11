using System.Collections.Generic;
using RimWorld;
using Verse;
using Verse.AI;

namespace AnimaSong
{
    /// <summary>
    /// Where a listener sits. Shared by the two ways of starting the job - the colonist going on
    /// their own during recreation time, and the player ordering it from the tree's right-click
    /// menu - so that both sit in the same ring under the same rules.
    /// </summary>
    public static class AnimaSongSeats
    {
        /// <summary>The foot of the tree is left clear: that is where the anima grass grows.</summary>
        public const float MinRadius = 2f;

        public const float MaxRadius = 5f;

        private static readonly List<IntVec3> tmpCells = new List<IntVec3>();

        /// <summary>
        /// Picks a free cell in the ring around the tree, in sight of it and reachable. Two passes,
        /// like the vanilla giver: a seat is preferred, the ground will do. In front of an anima
        /// tree the ground is the normal case, but a bench put there should win when there is one.
        /// </summary>
        public static bool TryFindSeat(Pawn pawn, Thing tree, out IntVec3 seat)
        {
            seat = IntVec3.Invalid;

            Map map = pawn?.Map;
            if (map == null || tree == null || !tree.Spawned || tree.Map != map) return false;

            tmpCells.Clear();
            foreach (var cell in GenRadial.RadialCellsAround(tree.Position, MaxRadius, true))
            {
                if ((cell - tree.Position).LengthHorizontal < MinRadius) continue;
                tmpCells.Add(cell);
            }
            tmpCells.Shuffle();

            for (var pass = 0; pass < 2; pass++)
            {
                foreach (var cell in tmpCells)
                {
                    if (!cell.InBounds(map)) continue;
                    if (cell.IsForbidden(pawn)) continue;
                    if (!cell.Standable(map)) continue;
                    if (!pawn.CanReserveSittableOrSpot(cell)) continue;

                    // In sight of the tree: you do not listen through a wall.
                    if (!GenSight.LineOfSight(cell, tree.Position, map, true)) continue;

                    if (pass == 0)
                    {
                        var edifice = cell.GetEdifice(map);
                        if (edifice == null || !edifice.def.building.isSittable) continue;
                    }

                    if (!pawn.CanReach(cell, PathEndMode.OnCell, Danger.None)) continue;

                    tmpCells.Clear();
                    seat = cell;
                    return true;
                }
            }

            tmpCells.Clear();
            return false;
        }
    }
}
