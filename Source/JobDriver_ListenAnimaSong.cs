using System.Collections.Generic;
using RimWorld;
using Verse;
using Verse.AI;

namespace AnimaSong
{
    /// <summary>
    /// The base game's "sit facing a building" driver, retyped onto a <c>Thing</c>, plus the song
    /// and the memory.
    ///
    /// The one reason this file exists: <c>JobDriver_SitFacingBuilding</c> declares
    /// <c>private Building Building => (Building)base.TargetThingA;</c>. An anima tree is a
    /// <c>Plant</c>, and the cast throws. Everything below is taken from it unchanged - seat
    /// reservation, facing the target, comfort from the cell, ending on full joy.
    ///
    /// THE SONG IS NOT HERE, IT IS ON THE TREE. Sound, flash, halo and cooldown live in
    /// <see cref="CompAnimaSong"/>: they belong to the tree, not to the listener, and six listeners
    /// must trigger a single song. The driver only wakes it and keeps it alive - a
    /// `needsMaintenance` mote needs a regular tick, and a plant only ticks every 2000.
    /// </summary>
    public class JobDriver_ListenAnimaSong : JobDriver
    {
        private const TargetIndex TreeIndex = TargetIndex.A;
        private const TargetIndex SeatIndex = TargetIndex.B;

        /// <summary>Half an in-game hour: below that, you walked past, you did not listen.</summary>
        private const int MinTicksForThought = 1250;

        /// <summary>
        /// One wave from the tree to the listener every two in-game seconds. Any closer and the
        /// ring of listeners ends up looking like blinking fairy lights.
        /// </summary>
        private const int PulseIntervalTicks = 120;

        private int ticksListened;
        private int ticksSincePulse;

        private Thing Tree => TargetThingA;

        private CompAnimaSong Song => Tree?.TryGetComp<CompAnimaSong>();

        public override void ExposeData()
        {
            base.ExposeData();
            Scribe_Values.Look(ref ticksListened, "AnimaSong.ticksListened", 0);
        }

        public override bool TryMakePreToilReservations(bool errorOnFailed)
        {
            if (!pawn.Reserve(job.targetA, job, job.def.joyMaxParticipants, 0, null, errorOnFailed))
            {
                return false;
            }
            return pawn.ReserveSittableOrSpot(job.targetB.Cell, job, errorOnFailed);
        }

        protected override IEnumerable<Toil> MakeNewToils()
        {
            this.EndOnDespawnedOrNull(TreeIndex);

            // The player's toggle has to bite immediately: cutting listening off before a linking
            // ritual is meant to clear the ring now, not in an hour.
            this.FailOn(delegate
            {
                CompAnimaSong song = Song;
                return song != null && !song.ListeningAllowed;
            });

            yield return Toils_Goto.Goto(SeatIndex, PathEndMode.OnCell);

            var toil = ToilMaker.MakeToil("ListenAnimaSong");
            toil.initAction = delegate { Song?.TrySing(); };
            toil.tickIntervalAction = delegate (int delta)
            {
                ticksListened += delta;
                pawn.rotationTracker.FaceTarget(Tree);
                pawn.GainComfortFromCellIfPossible(delta);

                CompAnimaSong song = Song;
                song?.NotifyListening();

                ticksSincePulse += delta;
                if (ticksSincePulse >= PulseIntervalTicks)
                {
                    ticksSincePulse = 0;
                    song?.ThrowSongPulse(pawn);
                }

                JoyUtility.JoyTickCheckEnd(pawn, delta, JoyTickFullJoyAction.EndJob);
            };
            toil.handlingFacing = true;
            toil.defaultCompleteMode = ToilCompleteMode.Delay;
            toil.defaultDuration = job.def.joyDuration;
            toil.AddFinishAction(delegate
            {
                if (ticksListened < MinTicksForThought) return;

                var thought = AnimaSongDefOf.AnimaSong_Heard;
                if (thought != null)
                {
                    pawn.needs?.mood?.thoughts?.memories?.TryGainMemory(thought);
                }
                JoyUtility.TryGainRecRoomThought(pawn);
            });
            yield return toil;
        }
    }
}
