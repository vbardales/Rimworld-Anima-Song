using System.Collections.Generic;
using Verse;

namespace AnimaSong
{
    /// <summary>
    /// Keeps the halo of a singing tree alive between the pings of its listeners.
    ///
    /// A `needsMaintenance` mote is destroyed on the first tick nobody maintained it, and the listener's
    /// job only pings the tree from `tickIntervalAction`, whose delta is 2 or more at higher game speeds
    /// (and 15 for a pawn nobody watches). Measured with Pickle at ultrafast on 2026-09-23: the ping was
    /// one tick old and the halo already destroyed on 112 samples of 300. The tree cannot tick itself
    /// (plants tick every 2000 ticks), so the map does it: one tick a map, one `Maintain()` for each tree
    /// pinged within <see cref="CompAnimaSong.HaloGraceTicks"/>.
    /// Nothing here is saved: after a load the next ping registers the tree again.
    /// </summary>
    public class HaloKeeper : MapComponent
    {
        private readonly List<CompAnimaSong> singing = new List<CompAnimaSong>();

        public HaloKeeper(Map map) : base(map)
        {
        }

        public void Track(CompAnimaSong comp)
        {
            if (!singing.Contains(comp)) singing.Add(comp);
        }

        public override void MapComponentTick()
        {
            for (int i = singing.Count - 1; i >= 0; i--)
            {
                if (!singing[i].KeepHaloAlive()) singing.RemoveAt(i);
            }
        }
    }
}
