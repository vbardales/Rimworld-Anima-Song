using RimWorld;
using Verse;
using Verse.AI;

namespace AnimaSong
{
    /// <summary>
    /// Sends a colonist to sit in a ring around an anima tree and listen to it sing, on their own,
    /// during recreation time. The player can also order it from the tree's right-click menu - see
    /// <see cref="CompAnimaSong.CompFloatMenuOptions"/>, which picks the seat the same way.
    ///
    /// WHY WE INHERIT FROM <c>JoyGiver_InteractBuilding</c> TO TARGET A PLANT. The name misleads.
    /// Verified by decompilation: <c>JoyGiver.GetSearchSet</c> goes through
    /// <c>map.listerThings.ThingsOfDef</c> - not <c>listerBuildings</c> - and
    /// <c>CanInteractWith</c> never touches <c>def.building</c>: those are only generic checks on a
    /// Thing (reservation, forbidden, fog, social properness, power, roof). That whole half works
    /// on a tree unchanged.
    ///
    /// What does not work is the vanilla driver: <c>JobDriver_SitFacingBuilding</c> contains
    /// <c>private Building Building => (Building)base.TargetThingA;</c>, a hard cast that throws an
    /// InvalidCastException the moment it is handed a <c>Plant</c>. That, and only that, is where
    /// the base game shuts the door - hence our own driver.
    ///
    /// WHY NOT <c>JoyGiver_InteractBuildingSitAdjacent</c> AS IS. It only keeps the four cardinal
    /// cells touching the object. Around an anima tree that is bad twice over: four listeners at
    /// most, and all of them trampling the anima grass the linking ritual depends on. So we settle
    /// in a ring 2 to 5 cells out, in sight of the tree.
    /// </summary>
    public class JoyGiver_ListenAnimaSong : JoyGiver_InteractBuilding
    {
        protected override Job TryGivePlayJob(Pawn pawn, Thing tree)
        {
            // The gizmo's toggle. We refuse here rather than in `CanInteractWith`: the vanilla
            // giver runs its own generic checks there, and one more override would be paid on every
            // tree tested on every search for recreation.
            var song = tree.TryGetComp<CompAnimaSong>();
            if (song != null && !song.ListeningAllowed) return null;

            if (!AnimaSongSeats.TryFindSeat(pawn, tree, out IntVec3 seat)) return null;

            return JobMaker.MakeJob(def.jobDef, tree, seat);
        }
    }
}
