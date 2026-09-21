using System.Collections.Generic;
using RimWorld;
using UnityEngine;
using Verse;
using Verse.AI;
using Verse.Sound;

namespace AnimaSong
{
    public class CompProperties_AnimaSong : CompProperties
    {
        public CompProperties_AnimaSong()
        {
            compClass = typeof(CompAnimaSong);
        }
    }

    /// <summary>
    /// What the anima tree knows about its own song: the player's toggle, when it last sang, and
    /// the halo that shows while someone is listening.
    ///
    /// WHY A COMPONENT AND NOT A STATIC FIELD. The first version kept the cooldown in a static
    /// <c>Dictionary&lt;int, int&gt;</c> on the job driver: lost on reload, and wrong when moving
    /// from one game to another without restarting. Here the state lives on the tree and travels
    /// with the save.
    ///
    /// WHY THIS COMPONENT DOES NOT TICK. Plants use `tickerType` Long - 2000 ticks, see
    /// `Plants_Bases.xml`. A `needsMaintenance` mote dies unless it is maintained every handful of
    /// ticks. So it is the JOB DRIVER that calls <see cref="NotifyListening"/> on every listening
    /// tick; the tree itself has nothing to do while nobody listens.
    /// </summary>
    public class CompAnimaSong : ThingComp
    {
        /// <summary>
        /// The tree does not sing again for every newcomer. Phytokin's sound is an `onCamera`
        /// one-shot at volume 15, heard across the whole map: six colonists sitting down one after
        /// another would fire six overlapping orchestras.
        /// </summary>
        private const int SongCooldownTicks = 5000;

        /// <summary>
        /// Grace period before deciding nobody is listening any more. The driver does not ping on
        /// every single tick: `tickIntervalAction` receives a delta worth 2 or 3 at higher game
        /// speeds.
        /// </summary>
        private const int ListeningGraceTicks = 10;

        /// <summary>
        /// Scale factors, not sizes: a mote is drawn at `graphicData.drawSize * Scale`.
        /// `Mote_PsyfocusPulse` measures 2.35 cells, calibrated for a meditating pawn - at 2.2 the
        /// halo covers the tree AND the ring of listeners, which is exactly the point. The flash
        /// fleck is already 2.5 cells wide: we enlarge it just enough for the tree.
        /// </summary>
        private const float AuraScale = 2.2f;

        private const float FlashScale = 1.6f;

        private bool listeningAllowed = true;
        private int lastSongTick = -1;
        private int lastListenTick = -1;

        private Mote auraMote;

        private static SoundDef songSound;
        private static bool songResolved;

        private static Texture2D gizmoIcon;
        private static bool gizmoIconResolved;

        public bool ListeningAllowed => listeningAllowed;

        /// <summary>True while at least one colonist is sitting and listening, grace aside.</summary>
        public bool Singing =>
            lastListenTick >= 0 && Find.TickManager.TicksGame - lastListenTick <= ListeningGraceTicks;

        public override void PostExposeData()
        {
            base.PostExposeData();
            Scribe_Values.Look(ref listeningAllowed, "AnimaSong.listeningAllowed", true);
            Scribe_Values.Look(ref lastSongTick, "AnimaSong.lastSongTick", -1);
        }

        public override IEnumerable<Gizmo> CompGetGizmosExtra()
        {
            yield return new Command_Toggle
            {
                defaultLabel = "AnimaSong_AllowListening".Translate(),
                defaultDesc = "AnimaSong_AllowListeningDesc".Translate(),
                icon = GizmoIcon,
                isActive = () => listeningAllowed,
                toggleAction = delegate { listeningAllowed = !listeningAllowed; }
            };
        }

        /// <summary>
        /// The right-click order: "Listen to the anima song". Without it the song is only ever
        /// heard when a colonist decides on their own, during recreation time - which can take days
        /// to happen, and leaves the player with no way to see the thing they installed the mod for.
        ///
        /// NO HARMONY NEEDED. <c>ThingWithComps.GetFloatMenuOptions</c> polls every comp through
        /// <c>CompFloatMenuOptions</c>, and <c>FloatMenuOptionProvider_FromThing</c> passes any
        /// clicked thing to it without filtering on buildings. A plant carrying a comp therefore
        /// gets its own menu entry for free.
        ///
        /// The seat is picked by <see cref="AnimaSongSeats"/>, the same code the joy giver uses, so
        /// an ordered listener sits where an autonomous one would - and it is picked again inside
        /// the delegate, since the ring can fill up between the menu opening and the click.
        ///
        /// THE SIX-LISTENER CAP HAS TO BE TESTED HERE. A free cell is not a free slot: the ring
        /// holds some sixty cells, while the job only allows <c>joyMaxParticipants</c> pawns, and
        /// that limit is enforced nowhere until the job reserves the tree at start. Left untested,
        /// a seventh colonist would walk all the way over and end on
        /// <c>Log.Warning("TryMakePreToilReservations() returned false for a non-queued job right
        /// after StartJob(). This should have been checked before.")</c> - the base game saying, in
        /// its own words, that the check belongs in the menu. The autonomous path never had the
        /// problem: <c>JoyGiver_InteractBuilding.CanInteractWith</c> opens on
        /// <c>pawn.CanReserve(t, def.jobDef.joyMaxParticipants)</c>, which is the call copied here.
        /// </summary>
        public override IEnumerable<FloatMenuOption> CompFloatMenuOptions(Pawn myPawn)
        {
            if (parent == null || !parent.Spawned || myPawn == null) yield break;

            // Drafted is a combat posture: sitting down to listen is not an order to give there.
            if (myPawn.Drafted) yield break;

            JobDef listen = AnimaSongDefOf.AnimaSong_Listen;
            if (listen == null) yield break;

            string reason = null;
            if (!listeningAllowed)
            {
                reason = "AnimaSong_OrderForbidden".Translate();
            }
            else if (!myPawn.health.capacities.CapableOf(PawnCapacityDefOf.Hearing))
            {
                reason = "AnimaSong_OrderCannotHear".Translate();
            }
            else if (!myPawn.CanReserve(parent, listen.joyMaxParticipants))
            {
                reason = "AnimaSong_OrderFull".Translate();
            }
            // Last, because it is the expensive one: a radial sweep with a line of sight and a
            // reachability test on every cell.
            else if (!AnimaSongSeats.TryFindSeat(myPawn, parent, out IntVec3 _))
            {
                reason = "AnimaSong_OrderNoSeat".Translate();
            }

            var option = new FloatMenuOption("AnimaSong_ListenOrder".Translate(), delegate
            {
                // Tested again on the click, both of them: between the menu opening and the choice,
                // another colonist can have taken the last slot or the last seat.
                if (!myPawn.CanReserve(parent, listen.joyMaxParticipants)) return;
                if (!AnimaSongSeats.TryFindSeat(myPawn, parent, out IntVec3 seat)) return;
                Job job = JobMaker.MakeJob(listen, parent, seat);
                myPawn.jobs.TryTakeOrderedJob(job, JobTag.Misc);
            });

            if (reason != null)
            {
                option.Disabled = true;
                option.Label = "AnimaSong_ListenOrderDisabled".Translate(reason);
            }

            yield return FloatMenuUtility.DecoratePrioritizedTask(option, myPawn, parent);
        }

        public override string CompInspectStringExtra()
        {
            if (!listeningAllowed) return "AnimaSong_InspectNotAllowed".Translate();
            if (Singing) return "AnimaSong_InspectSinging".Translate();
            return null;
        }

        /// <summary>
        /// The song itself: the sound, plus the psychic flash Phytokin already throws on its target
        /// (`CompProperties_AbilityFleckOnTarget`, fleck `PsycastPsychicEffect`). Does nothing if
        /// the tree sang less than <see cref="SongCooldownTicks"/> ago.
        /// </summary>
        public void TrySing()
        {
            if (parent == null || !parent.Spawned) return;

            int now = Find.TickManager.TicksGame;
            // `now < lastSongTick`: the tick counter has gone backwards (developer tools). The
            // stored value is meaningless, so throw it away rather than muzzle the tree.
            if (lastSongTick >= 0 && now >= lastSongTick && now - lastSongTick < SongCooldownTicks) return;
            lastSongTick = now;

            SongSound?.PlayOneShot(new TargetInfo(parent));

            FleckDef flash = DefDatabase<FleckDef>.GetNamedSilentFail("PsycastPsychicEffect");
            if (flash != null)
            {
                FleckMaker.AttachedOverlay(parent, flash, Vector3.zero, FlashScale);
            }
        }

        /// <summary>
        /// Called on every tick by the driver, for one listener. Maintains the tree's pulsing halo -
        /// the only thing on screen that says the song is under way.
        /// </summary>
        public void NotifyListening()
        {
            lastListenTick = Find.TickManager.TicksGame;

            if (parent == null || !parent.Spawned) return;

            ThingDef aura = DefDatabase<ThingDef>.GetNamedSilentFail("Mote_PsyfocusPulse");
            if (aura == null) return;

            if (auraMote == null || auraMote.Destroyed)
            {
                auraMote = MoteMaker.MakeAttachedOverlay(parent, aura, Vector3.zero, AuraScale);
            }

            // Maintained on the tick it is made too, not only on the next ping. `Mote.lastMaintainTick`
            // starts at 0 and only `Maintain()` writes it, and `Mote.TimeInterval` destroys a
            // `needsMaintenance` mote on any tick after the last maintained one (`fadeOutUnmaintained` is
            // false for this def). A fresh mote that waited for the next ping was already dead by then:
            // it lived under a tick, was remade on every ping, and its fade-in restarted each time, so the
            // halo never showed. Measured tick by tick with Pickle on 2026-09-21: alive on the sample taken
            // at the tick of a ping, destroyed on every sample after it.
            auraMote?.Maintain();
        }

        /// <summary>
        /// A wave leaving the tree and reaching the listener: the anima linking ritual's own mote,
        /// reused as is. Thrown now and then by the driver, it needs no maintenance - it lives half
        /// a second and fades.
        /// </summary>
        public void ThrowSongPulse(Pawn listener)
        {
            if (parent == null || !parent.Spawned || listener == null || !listener.Spawned) return;

            ThingDef pulse = DefDatabase<ThingDef>.GetNamedSilentFail("Mote_PsychicLinkPulse");
            if (pulse == null) return;

            MoteMaker.MakeInteractionOverlay(pulse, parent, listener);
        }

        /// <summary>
        /// The song of Vanilla Races Expanded - Phytokin if it is there, otherwise Royalty's anima
        /// linking sound. Soft dependency by def name: no assembly reference, so the mod loads and
        /// works without Phytokin - it simply sings something else.
        /// </summary>
        private static SoundDef SongSound
        {
            get
            {
                if (songResolved) return songSound;
                songResolved = true;
                songSound = DefDatabase<SoundDef>.GetNamedSilentFail("VRE_AnimaSongSound")
                            ?? DefDatabase<SoundDef>.GetNamedSilentFail("AnimaTreeLink");
                return songSound;
            }
        }

        /// <summary>
        /// Same soft dependency for the icon: Phytokin's ability icon when their mod is present,
        /// otherwise Royalty's anima linking ritual icon.
        /// </summary>
        private static Texture2D GizmoIcon
        {
            get
            {
                if (gizmoIconResolved) return gizmoIcon;
                gizmoIconResolved = true;
                gizmoIcon = ContentFinder<Texture2D>.Get("UI/Abilities/AnimaSong", false)
                            ?? ContentFinder<Texture2D>.Get("UI/Icons/Rituals/AnimaTreeLinking", false);
                return gizmoIcon;
            }
        }
    }
}
