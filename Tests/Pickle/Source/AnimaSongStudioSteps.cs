using System.Linq;
using RimWorks.Pickle;
using RimWorld;
using Verse;

namespace AnimaSong.PickleSteps
{
    /// <summary>
    /// What the pictures of the Workshop page need from the mod's side: an anima tree in the studio's glade, which PickleTools'
    /// studio does not hold and Pickle's stock spawn step would only plant as a seedling.
    /// </summary>
    [PickleSteps]
    public class AnimaSongStudioSteps
    {
        [Given("Anima Song: an anima tree grows at x={int} z={int}")]
        public void AnimaTreeGrows(PickleContext ctx, int x, int z)
        {
            Map map = Find.CurrentMap;
            var cell = new IntVec3(x, 0, z);
            ThingDef def = DefDatabase<ThingDef>.GetNamed("Plant_TreeAnima");
            if (!cell.GetThingList(map).Any(t => t.def == def))
            {
                // What grows there already (a flower of the glade) makes room, then the tree is planted fully grown.
                foreach (Thing t in cell.GetThingList(map).Where(t => t.def.category == ThingCategory.Plant).ToList())
                {
                    t.Destroy();
                }

                var tree = (Plant)GenSpawn.Spawn(ThingMaker.MakeThing(def), cell, map);
                tree.Growth = 1f;
            }

            AnimaSongSteps.TreeAt(ctx, x, z);
        }
    }
}
