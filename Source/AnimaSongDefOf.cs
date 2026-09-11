using RimWorld;
using Verse;

namespace AnimaSong
{
    [DefOf]
    public static class AnimaSongDefOf
    {
        /// <summary>
        /// Deliberately NOT conditional on Royalty, unlike the mod's three other defs. A missing
        /// DefOf field makes `DefOfHelper` shout at startup; this memory names no Royalty def, so it
        /// can always load, even if it is never used.
        /// </summary>
        public static ThoughtDef AnimaSong_Heard;

        /// <summary>
        /// The listening job, named here so the right-click order can start it. Conditional on
        /// Royalty, like the def itself: with no anima tree there is nothing to click.
        /// </summary>
        [MayRequire("Ludeon.RimWorld.Royalty")]
        public static JobDef AnimaSong_Listen;

        static AnimaSongDefOf()
        {
            DefOfHelper.EnsureInitializedInCtor(typeof(AnimaSongDefOf));
        }
    }
}
