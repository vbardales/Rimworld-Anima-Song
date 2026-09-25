using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using RimWorks.Pickle;
using RimWorld;
using UnityEngine;
using Verse;
using Verse.AI;

namespace AnimaSong.PickleSteps
{
    /// <summary>
    /// The handful of things Pickle's vanilla steps cannot reach: the mod's comp on the tree, its
    /// gizmo, the right-click order, the halo, and where the listeners sit.
    ///
    /// Every step text starts with "Anima Song:". Pickle loads the steps of every active suite into
    /// one namespace, and two suites declaring the same text make healthy scenarios fail with
    /// "Ambiguous step". Nothing here is written as parentheses or slashes either, which Cucumber
    /// expressions read as optional text and alternatives: cells are spelled x=.. z=...
    ///
    /// Nothing here reads a translated word. The gizmo is found by the translation of its own key
    /// and a refusal by the translation of the key the mod chose, so the same feature holds in any
    /// language the run was staged with.
    /// </summary>
    [PickleSteps]
    public class AnimaSongSteps
    {
        private const string PhytokinId = "vanillaracesexpanded.phytokin";
        private const string PhytokinSound = "VRE_AnimaSongSound";
        private const string RoyaltySound = "AnimaTreeLink";
        private const string PhytokinIcon = "UI/Abilities/AnimaSong";
        private const string RoyaltyIcon = "UI/Icons/Rituals/AnimaTreeLinking";

        // ------------------------------------------------------------------ finding things

        internal static Map CurrentMap(PickleContext ctx)
        {
            ctx.Require(Current.Game != null && Find.CurrentMap != null, "load a save first");
            return Find.CurrentMap;
        }

        internal static Thing TreeAt(PickleContext ctx, int x, int z)
        {
            Map map = CurrentMap(ctx);
            var cell = new IntVec3(x, 0, z);
            Thing tree = cell.GetThingList(map).FirstOrDefault(t => t.def.defName == "Plant_TreeAnima");
            ctx.Assert(tree != null,
                $"no Plant_TreeAnima at ({x}, {z}); the cell holds: " +
                string.Join(", ", cell.GetThingList(map).Select(t => t.def.defName)));
            return tree;
        }

        internal static CompAnimaSong SongAt(PickleContext ctx, int x, int z)
        {
            Thing tree = TreeAt(ctx, x, z);
            CompAnimaSong comp = tree.TryGetComp<CompAnimaSong>();
            ctx.Assert(comp != null,
                "the anima tree carries no CompAnimaSong: Patches/AnimaTree.xml did not land on it");
            return comp;
        }

        internal static Pawn Colonist(PickleContext ctx, string nickname)
        {
            Pawn pawn = CurrentMap(ctx).mapPawns.FreeColonists.FirstOrDefault(p =>
                p.Name is NameTriple triple && triple.Nick == nickname);
            ctx.Assert(pawn != null, $"no colonist nicknamed \"{nickname}\"");
            return pawn;
        }

        internal static bool IsListening(Pawn pawn, Thing tree)
        {
            Job job = pawn.CurJob;
            return job != null && job.def == AnimaSongDefOf.AnimaSong_Listen && job.targetA.Thing == tree;
        }

        internal static IEnumerable<Pawn> ListenersOf(Map map, Thing tree)
        {
            return map.mapPawns.AllPawnsSpawned.Where(p => IsListening(p, tree));
        }

        internal static bool InRing(Pawn pawn, Thing tree)
        {
            float d = pawn.Position.DistanceTo(tree.Position);
            return d >= AnimaSongSeats.MinRadius - 0.01f && d <= AnimaSongSeats.MaxRadius + 0.01f;
        }

        /// <summary>
        /// Waits for a condition and, when it never comes true, fails with what the world looks like NOW.
        /// <c>PickleContext.WaitUntil</c> throws <see cref="TimeoutException"/> when it times out, so an
        /// <c>Assert</c> written after a bare <c>await WaitUntil(...)</c> is reached only when the wait already
        /// succeeded: the message that names where a pawn stands would never be seen, and a stuck colonist
        /// would read as "Step ... timed out" and nothing else.
        /// </summary>
        internal static async Task WaitOrExplain(PickleContext ctx, Func<bool> condition, float seconds, Func<string> explain)
        {
            try
            {
                await ctx.WaitUntil(condition, seconds);
            }
            catch (TimeoutException)
            {
                ctx.Assert(false, $"after {seconds:0} s: {explain()}");
            }
        }

        // The gizmo the player would click: the selected tree's own toggle, found by the translation
        // of the key it is labelled with.
        private static Command_Toggle SelectedToggle(PickleContext ctx)
        {
            Thing selected = Find.Selector.SingleSelectedThing;
            ctx.Assert(selected != null, "nothing, or more than one thing, is selected: select the tree first");
            string label = "AnimaSong_AllowListening".Translate();
            var toggle = selected.GetGizmos().OfType<Command_Toggle>().FirstOrDefault(c => c.defaultLabel == label);
            ctx.Assert(toggle != null,
                $"the selected {selected.def.defName} shows no \"{label}\" toggle; its gizmos: " +
                string.Join(", ", selected.GetGizmos().OfType<Command>().Select(c => c.defaultLabel)));
            return toggle;
        }

        private static FloatMenuOption ListenOption(PickleContext ctx, Pawn pawn, Thing tree)
        {
            CompAnimaSong comp = tree.TryGetComp<CompAnimaSong>();
            ctx.Assert(comp != null, "the anima tree carries no CompAnimaSong");
            var options = comp.CompFloatMenuOptions(pawn).ToList();
            ctx.Assert(options.Count == 1,
                $"the tree offered {pawn.LabelShort} {options.Count} orders instead of one" +
                (pawn.Drafted ? " (the colonist is drafted, which offers none)" : ""));
            return options[0];
        }

        /// <summary>
        /// Why the seat search found nothing, cell by cell in the order the mod's own search asks: how many cells of the ring fail each
        /// test, and where the colonist stands. A refusal that reads only "no free spot" cost two runs on 2026-09-25 (the song scenario)
        /// and told nothing about which test emptied the ring.
        /// </summary>
        internal static string WhyNoSeat(Pawn pawn, Thing tree)
        {
            Map map = pawn.Map;
            int ring = 0, forbidden = 0, notStandable = 0, cannotReserve = 0, noSight = 0, cannotReach = 0, ok = 0;
            foreach (IntVec3 cell in GenRadial.RadialCellsAround(tree.Position, AnimaSongSeats.MaxRadius, true))
            {
                if ((cell - tree.Position).LengthHorizontal < AnimaSongSeats.MinRadius) continue;
                if (!cell.InBounds(map)) continue;
                ring++;
                if (cell.IsForbidden(pawn)) { forbidden++; continue; }
                if (!cell.Standable(map)) { notStandable++; continue; }
                if (!pawn.CanReserveSittableOrSpot(cell)) { cannotReserve++; continue; }
                if (!GenSight.LineOfSight(cell, tree.Position, map, true)) { noSight++; continue; }
                if (!pawn.CanReach(cell, PathEndMode.OnCell, Danger.None)) { cannotReach++; continue; }
                ok++;
            }
            return $"{pawn.LabelShort} stands at {pawn.Position} (spawned {pawn.Spawned}, downed {pawn.Downed}, drafted {pawn.Drafted}), " +
                   $"the tree at {tree.Position}; ring cells {ring}: forbidden {forbidden}, not standable {notStandable}, " +
                   $"cannot reserve {cannotReserve}, no line of sight {noSight}, cannot reach {cannotReach}, free {ok}";
        }


        // ------------------------------------------------------------------ orders and clicks

        [When("Anima Song: {string} is ordered to listen to the tree at x={int} z={int}")]
        public void OrderListen(PickleContext ctx, string nickname, int x, int z)
        {
            Thing tree = TreeAt(ctx, x, z);
            Pawn pawn = Colonist(ctx, nickname);
            FloatMenuOption option = ListenOption(ctx, pawn, tree);
            ctx.Assert(!option.Disabled, $"the order is greyed out for {nickname}: {option.Label}. " + WhyNoSeat(pawn, tree));
            // The click on the menu entry, the one the delegate the mod handed the menu.
            option.Chosen(true, null);
        }

        [When("Anima Song: I select the tree at x={int} z={int}")]
        public void SelectTree(PickleContext ctx, int x, int z)
        {
            Thing tree = TreeAt(ctx, x, z);
            Find.Selector.ClearSelection();
            Find.Selector.Select(tree, playSound: false, forceDesignatorDeselect: false);
        }

        [When("Anima Song: I press the toggle of the selected tree")]
        public void PressToggle(PickleContext ctx)
        {
            SelectedToggle(ctx).toggleAction();
        }

        /// <summary>
        /// Deafness, by taking both ears rather than by naming a hediff a scenario would have to
        /// spell. Hearing is the mod's only requirement - a blind colonist still hears the tree -
        /// so this is the one capacity a scenario has to be able to remove.
        /// </summary>
        [Given("Anima Song: {string} is made deaf")]
        public void MakeDeaf(PickleContext ctx, string nickname)
        {
            LoseEveryPart(ctx, nickname, "Ear", PawnCapacityDefOf.Hearing);
        }

        /// <summary>
        /// Takes every body part of a defName from a colonist and asserts the capacity that rests on it is gone.
        /// Deafness and blindness are the same removal with two names: a scenario should not have to spell a hediff.
        /// </summary>
        internal static void LoseEveryPart(PickleContext ctx, string nickname, string partDefName, PawnCapacityDef lost)
        {
            Pawn pawn = Colonist(ctx, nickname);
            List<BodyPartRecord> parts = pawn.RaceProps.body.AllParts
                .Where(p => p.def.defName == partDefName).ToList();
            ctx.Require(parts.Count > 0, $"{nickname}'s body has no part named {partDefName}");
            foreach (BodyPartRecord part in parts)
            {
                pawn.health.AddHediff(HediffDefOf.MissingBodyPart, part);
            }

            ctx.Assert(!pawn.health.capacities.CapableOf(lost),
                $"{nickname} still has {lost.defName} after losing {parts.Count} x {partDefName}");
        }

        // ------------------------------------------------------------------ the tree

        [Then("Anima Song: the tree at x={int} z={int} carries the song comp")]
        public void CarriesComp(PickleContext ctx, int x, int z)
        {
            SongAt(ctx, x, z);
        }

        [Then("Anima Song: the tree at x={int} z={int} allows listening")]
        public void Allows(PickleContext ctx, int x, int z)
        {
            ctx.Assert(SongAt(ctx, x, z).ListeningAllowed, "listening is forbidden on the tree");
        }

        [Then("Anima Song: the tree at x={int} z={int} forbids listening")]
        public void Forbids(PickleContext ctx, int x, int z)
        {
            ctx.Assert(!SongAt(ctx, x, z).ListeningAllowed, "listening is still allowed on the tree");
        }

        [Then("Anima Song: the toggle of the selected tree is on")]
        public void ToggleOn(PickleContext ctx)
        {
            ctx.Assert(SelectedToggle(ctx).isActive(), "the toggle reads off");
        }

        [Then("Anima Song: the toggle of the selected tree is off")]
        public void ToggleOff(PickleContext ctx)
        {
            ctx.Assert(!SelectedToggle(ctx).isActive(), "the toggle reads on");
        }

        /// <summary>
        /// Both soft dependencies at once, and the one place the two passes differ. With Phytokin in
        /// the modlist the tree must sing its recording and wear its icon; without, Royalty's. The
        /// expectation is derived from the modlist, so the same scenario holds in both passes.
        /// If Phytokin is active and its def is gone, the lookup by name has silently fallen back,
        /// which is exactly the drift this scenario exists to see.
        /// </summary>
        [Then("Anima Song: the song and the toggle icon come from the loaded mods")]
        public void SoftDependencies(PickleContext ctx)
        {
            bool phytokin = ModsConfig.IsActive(PhytokinId);
            string wantSound = phytokin ? PhytokinSound : RoyaltySound;
            string wantIcon = phytokin ? PhytokinIcon : RoyaltyIcon;

            var soundProperty = typeof(CompAnimaSong).GetProperty("SongSound",
                System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Static);
            ctx.Assert(soundProperty != null, "CompAnimaSong.SongSound no longer exists: this step has to follow it");
            var sound = soundProperty.GetValue(null, null) as SoundDef;
            ctx.Assert(sound != null && sound.defName == wantSound,
                $"Phytokin active: {phytokin}; the tree sings \"{sound?.defName ?? "nothing"}\", expected \"{wantSound}\"");

            Texture2D expected = ContentFinder<Texture2D>.Get(wantIcon, false);
            ctx.Assert(expected != null, $"the texture at {wantIcon} cannot be loaded: nothing to compare the toggle with");
            Texture icon = SelectedToggle(ctx).icon;
            ctx.Assert(ReferenceEquals(icon, expected),
                $"Phytokin active: {phytokin}; the toggle does not wear the icon at {wantIcon}");
        }

        // ------------------------------------------------------------------ the song

        [Then("Anima Song: the tree at x={int} z={int} is singing")]
        public async Task Singing(PickleContext ctx, int x, int z)
        {
            CompAnimaSong comp = SongAt(ctx, x, z);
            await WaitOrExplain(ctx, () => comp.Singing, 30f,
                () => "nobody is listening: the tree is silent");
        }

        [Then("Anima Song: the tree at x={int} z={int} is not singing")]
        public async Task NotSinging(PickleContext ctx, int x, int z)
        {
            CompAnimaSong comp = SongAt(ctx, x, z);
            await WaitOrExplain(ctx, () => !comp.Singing, 30f,
                () => "the tree is still singing after everyone left");
        }

        /// <summary>
        /// The halo is a mote the job has to maintain tick by tick, and it dies within a few ticks
        /// if nobody does. Read from the comp's own field: nothing else in the game says whether it
        /// is alive at this instant.
        /// </summary>
        private static bool HaloIsUp(PickleContext ctx, CompAnimaSong comp)
        {
            return MoteIsUp(ctx, comp, "auraMote") && MoteIsUp(ctx, comp, "glowMote");
        }

        /// <summary>One of the tree's two halo motes (Royalty's pulse, the mod's own glow), by its field name.</summary>
        private static bool MoteIsUp(PickleContext ctx, CompAnimaSong comp, string fieldName)
        {
            var field = typeof(CompAnimaSong).GetField(fieldName,
                System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance);
            ctx.Assert(field != null, $"CompAnimaSong.{fieldName} no longer exists: this step has to follow it");
            var mote = field.GetValue(comp) as Mote;
            return mote != null && !mote.Destroyed;
        }

        /// <summary>
        /// Comes up within a few seconds. Not "is up this very instant": a listener that has just
        /// arrived has not yet taken its first listening tick, so the halo does not exist yet - the
        /// first run of this suite (2026-09-21) failed exactly there, right after the seat was
        /// reached. Whether it then STAYS up is the next step's question.
        /// </summary>
        [Then("Anima Song: the halo of the tree at x={int} z={int} is alive")]
        public async Task HaloAlive(PickleContext ctx, int x, int z)
        {
            CompAnimaSong comp = SongAt(ctx, x, z);
            await WaitOrExplain(ctx, () => HaloIsUp(ctx, comp), 10f,
                () => "the halo never came up, though somebody is listening");
        }

        /// <summary>
        /// The one witness of the halo that holds: one reading after every single tick. A frame sampler was
        /// tried first and removed - where a wait returns relative to the pawn's tick differs from run to run, so
        /// the same mote read 0 of 300 and 300 of 300. Three
        /// numbers per tick - whether the halo is up, and how long ago the job last pinged the tree
        /// (<c>lastListenTick</c>) - so that the two readings of "the halo is mostly absent" separate.
        /// If the age is 0 on every tick and the halo is still down, the job pings and the mote does not
        /// survive it; if the age climbs to 2 or 3 between pings, the job pings less often than the
        /// mote lives, which is a fault in the maintenance; if the halo is up on every tick, the frame
        /// sampler was a poor witness.
        ///
        /// The span is in game ticks. At ultrafast one wait returns per frame, about 30 ticks on, so 300 samples would
        /// outlast the sitting; the ultrafast scenario asks for 1500 ticks, some fifty samples, inside it.
        ///
        /// It asserts the same 90 % as the frame sampler, so it can fail as a test, and it always
        /// leaves the distribution in the failure message and as a report attachment.
        /// </summary>
        [Then("Anima Song: the halo of the tree at x={int} z={int} is followed tick by tick for {int} ticks")]
        public async Task HaloTickByTick(PickleContext ctx, int x, int z, int ticks)
        {
            CompAnimaSong comp = SongAt(ctx, x, z);
            var pingField = typeof(CompAnimaSong).GetField("lastListenTick",
                System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance);
            ctx.Assert(pingField != null, "CompAnimaSong.lastListenTick no longer exists: this step has to follow it");

            var moteField = typeof(CompAnimaSong).GetField("auraMote",
                System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance);
            ctx.Assert(moteField != null, "CompAnimaSong.auraMote no longer exists: this step has to follow it");

            // Why the halo is down matters as much as that it is: a field that is null (the mote was
            // never made, or MoteMaker returned nothing), a mote that is Destroyed (made, then dead by
            // the time of the reading) and a live one are three different faults.
            ThingDef auraDef = DefDatabase<ThingDef>.GetNamedSilentFail("Mote_PsyfocusPulse");

            // Read on every tick, not once before the loop: the camera eases toward its target frame by frame,
            // so "in view" is a property of each sample and a snapshot could describe none of them.
            int inView = 0;
            int up = 0;
            int glowUp = 0;
            var ageCounts = new SortedDictionary<int, int>();
            var stateCounts = new SortedDictionary<string, int>();
            var lines = new List<string>(ticks);
            int startTick = Find.TickManager.TicksGame;
            int samples = 0;
            // The span is game ticks, not samples: at ultrafast a wait returns once a frame, some 30 ticks on, so 300
            // samples would run past the end of the sitting and count the colonist standing up as a dead halo.
            while (Find.TickManager.TicksGame - startTick < ticks && samples < ticks)
            {
                await ctx.WaitTicks(1);
                samples++;
                var mote = moteField.GetValue(comp) as Mote;
                string state = mote == null ? "null" : mote.Destroyed ? "destroyed" : "alive";
                bool halo = state == "alive";
                int now = Find.TickManager.TicksGame;
                int age = now - (int)pingField.GetValue(comp);
                if (halo) up++;
                if (MoteIsUp(ctx, comp, "glowMote")) glowUp++;
                if (Find.CameraDriver.CurrentViewRect.Contains(comp.parent.Position)) inView++;
                ageCounts.TryGetValue(age, out int seen);
                ageCounts[age] = seen + 1;
                stateCounts.TryGetValue(state, out int seenState);
                stateCounts[state] = seenState + 1;
                lines.Add($"{now}\thalo={state}\tage={age}");
            }

            string ages = string.Join(", ", ageCounts.Select(kv => $"{kv.Key}:{kv.Value}"));
            string states = string.Join(", ", stateCounts.Select(kv => $"{kv.Key}:{kv.Value}"));
            string summary = $"halo up on {up} of {samples} samples over {Find.TickManager.TicksGame - startTick} game ticks; field state (state:count): {states}; " +
                             $"ticks since the last ping (age:count): {ages}; " +
                             $"Mote_PsyfocusPulse def {(auraDef == null ? "MISSING" : "present")}; glow mote (the mod's own, tinted) alive on {glowUp} of {samples} samples; tree in view on {inView} of {samples} samples";
            ctx.Attach("halo tick by tick", string.Join("\n", lines) + "\n" + summary);
            ctx.Assert(samples > 0 && up >= samples * 0.9 && glowUp >= samples * 0.9, summary);
        }

        // ------------------------------------------------------------------ the listeners

        [Then("Anima Song: {string} is listening to the tree at x={int} z={int}")]
        public async Task IsListening(PickleContext ctx, string nickname, int x, int z)
        {
            Thing tree = TreeAt(ctx, x, z);
            Pawn pawn = Colonist(ctx, nickname);
            await WaitOrExplain(ctx, () => IsListening(pawn, tree), 30f,
                () => $"{nickname} is doing {pawn.CurJob?.def.defName ?? "nothing"} at {pawn.Position}, not listening to this tree");
        }

        [Then("Anima Song: {string} is not listening to the tree at x={int} z={int}")]
        public async Task IsNotListening(PickleContext ctx, string nickname, int x, int z)
        {
            Thing tree = TreeAt(ctx, x, z);
            Pawn pawn = Colonist(ctx, nickname);
            await WaitOrExplain(ctx, () => !IsListening(pawn, tree), 30f,
                () => $"{nickname} is still listening, at {pawn.Position}");
        }

        /// <summary>
        /// Walked there and sat down: on the ring, 2 to 5 cells out, and not against the trunk,
        /// where the anima grass the linking ritual needs would be trampled.
        /// </summary>
        [Then("Anima Song: {string} sits in the ring of the tree at x={int} z={int}")]
        public async Task SitsInRing(PickleContext ctx, string nickname, int x, int z)
        {
            Thing tree = TreeAt(ctx, x, z);
            Pawn pawn = Colonist(ctx, nickname);
            await WaitOrExplain(ctx, () => IsListening(pawn, tree) && InRing(pawn, tree) && !pawn.pather.Moving, 90f,
                () => $"{nickname} is doing {pawn.CurJob?.def.defName ?? "nothing"}, stands at {pawn.Position}, " +
                      $"{pawn.Position.DistanceTo(tree.Position):0.0} cells from the trunk (ring: " +
                      $"{AnimaSongSeats.MinRadius} to {AnimaSongSeats.MaxRadius}), moving: {pawn.pather.Moving}");
        }

        [Then("Anima Song: {int} listeners sit on {int} different cells around the tree at x={int} z={int}")]
        public async Task ListenersOnDistinctCells(PickleContext ctx, int listeners, int cells, int x, int z)
        {
            Map map = CurrentMap(ctx);
            Thing tree = TreeAt(ctx, x, z);
            Func<List<Pawn>> seated = () => ListenersOf(map, tree).Where(p => !p.pather.Moving && InRing(p, tree)).ToList();
            await WaitOrExplain(ctx, () => seated().Count >= listeners, 120f,
                () => $"{seated().Count} of {listeners} listeners sit in the ring; the listeners not seated: " +
                      string.Join(", ", ListenersOf(map, tree).Except(seated()).Select(p => $"{p.LabelShort} at {p.Position}")));

            List<Pawn> sitting = seated();
            ctx.Assert(ListenersOf(map, tree).Count() == listeners,
                $"{ListenersOf(map, tree).Count()} colonists are listening, expected {listeners}");
            ctx.Assert(sitting.Count == listeners,
                $"{sitting.Count} of {listeners} listeners sit in the ring, expected {listeners}");
            int distinct = sitting.Select(p => p.Position).Distinct().Count();
            ctx.Assert(distinct == cells, $"the listeners sit on {distinct} different cells, expected {cells}");
        }

        // ------------------------------------------------------------------ the menu

        [Then("Anima Song: the order offered to {string} for the tree at x={int} z={int} is available")]
        public void OrderAvailable(PickleContext ctx, string nickname, int x, int z)
        {
            FloatMenuOption option = ListenOption(ctx, Colonist(ctx, nickname), TreeAt(ctx, x, z));
            ctx.Assert(!option.Disabled, $"the order is greyed out: {option.Label}");
        }

        /// <summary>
        /// A refusal is named by the key the mod gave it, so it holds in whatever language the run
        /// was staged in: the label must contain that key's translation.
        /// </summary>
        [Then("Anima Song: the order offered to {string} for the tree at x={int} z={int} is refused because {string}")]
        public void OrderRefused(PickleContext ctx, string nickname, int x, int z, string reasonKey)
        {
            FloatMenuOption option = ListenOption(ctx, Colonist(ctx, nickname), TreeAt(ctx, x, z));
            ctx.Assert(option.Disabled, $"the order is offered to {nickname}: {option.Label}");
            string reason = reasonKey.Translate();
            ctx.Assert(option.Label.Contains(reason),
                $"the order is greyed out as \"{option.Label}\", which does not contain the reason \"{reason}\" ({reasonKey})");
        }
    }
}
