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

        private static Map CurrentMap(PickleContext ctx)
        {
            ctx.Require(Current.Game != null && Find.CurrentMap != null, "load a save first");
            return Find.CurrentMap;
        }

        private static Thing TreeAt(PickleContext ctx, int x, int z)
        {
            Map map = CurrentMap(ctx);
            var cell = new IntVec3(x, 0, z);
            Thing tree = cell.GetThingList(map).FirstOrDefault(t => t.def.defName == "Plant_TreeAnima");
            ctx.Assert(tree != null,
                $"no Plant_TreeAnima at ({x}, {z}); the cell holds: " +
                string.Join(", ", cell.GetThingList(map).Select(t => t.def.defName)));
            return tree;
        }

        private static CompAnimaSong SongAt(PickleContext ctx, int x, int z)
        {
            Thing tree = TreeAt(ctx, x, z);
            CompAnimaSong comp = tree.TryGetComp<CompAnimaSong>();
            ctx.Assert(comp != null,
                "the anima tree carries no CompAnimaSong: Patches/AnimaTree.xml did not land on it");
            return comp;
        }

        private static Pawn Colonist(PickleContext ctx, string nickname)
        {
            Pawn pawn = CurrentMap(ctx).mapPawns.FreeColonists.FirstOrDefault(p =>
                p.Name is NameTriple triple && triple.Nick == nickname);
            ctx.Assert(pawn != null, $"no colonist nicknamed \"{nickname}\"");
            return pawn;
        }

        private static bool IsListening(Pawn pawn, Thing tree)
        {
            Job job = pawn.CurJob;
            return job != null && job.def == AnimaSongDefOf.AnimaSong_Listen && job.targetA.Thing == tree;
        }

        private static IEnumerable<Pawn> ListenersOf(Map map, Thing tree)
        {
            return map.mapPawns.AllPawnsSpawned.Where(p => IsListening(p, tree));
        }

        private static bool InRing(Pawn pawn, Thing tree)
        {
            float d = pawn.Position.DistanceTo(tree.Position);
            return d >= AnimaSongSeats.MinRadius - 0.01f && d <= AnimaSongSeats.MaxRadius + 0.01f;
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

        // ------------------------------------------------------------------ orders and clicks

        [When("Anima Song: {string} is ordered to listen to the tree at x={int} z={int}")]
        public void OrderListen(PickleContext ctx, string nickname, int x, int z)
        {
            Thing tree = TreeAt(ctx, x, z);
            Pawn pawn = Colonist(ctx, nickname);
            FloatMenuOption option = ListenOption(ctx, pawn, tree);
            ctx.Assert(!option.Disabled, $"the order is greyed out for {nickname}: {option.Label}");
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
            Pawn pawn = Colonist(ctx, nickname);
            List<BodyPartRecord> ears = pawn.RaceProps.body.AllParts
                .Where(p => p.def.defName == "Ear").ToList();
            ctx.Require(ears.Count > 0, $"{nickname}'s body has no part named Ear");
            foreach (BodyPartRecord ear in ears)
            {
                pawn.health.AddHediff(HediffDefOf.MissingBodyPart, ear);
            }
            ctx.Assert(!pawn.health.capacities.CapableOf(PawnCapacityDefOf.Hearing),
                $"{nickname} still hears after losing {ears.Count} ears");
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
            await ctx.WaitUntil(() => comp.Singing, 30f);
            ctx.Assert(comp.Singing, "nobody is listening: the tree is silent");
        }

        [Then("Anima Song: the tree at x={int} z={int} is not singing")]
        public async Task NotSinging(PickleContext ctx, int x, int z)
        {
            CompAnimaSong comp = SongAt(ctx, x, z);
            await ctx.WaitUntil(() => !comp.Singing, 30f);
            ctx.Assert(!comp.Singing, "the tree is still singing after everyone left");
        }

        /// <summary>
        /// The halo is a mote the job has to maintain tick by tick, and it dies within a few ticks
        /// if nobody does. Read from the comp's own field: nothing else in the game says whether it
        /// is alive at this instant.
        /// </summary>
        [Then("Anima Song: the halo of the tree at x={int} z={int} is alive")]
        public void HaloAlive(PickleContext ctx, int x, int z)
        {
            CompAnimaSong comp = SongAt(ctx, x, z);
            var field = typeof(CompAnimaSong).GetField("auraMote",
                System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance);
            ctx.Assert(field != null, "CompAnimaSong.auraMote no longer exists: this step has to follow it");
            var halo = field.GetValue(comp) as Mote;
            ctx.Assert(halo != null && !halo.Destroyed, "the halo is missing or has died");
        }

        // ------------------------------------------------------------------ the listeners

        [Then("Anima Song: {string} is listening to the tree at x={int} z={int}")]
        public async Task IsListening(PickleContext ctx, string nickname, int x, int z)
        {
            Thing tree = TreeAt(ctx, x, z);
            Pawn pawn = Colonist(ctx, nickname);
            await ctx.WaitUntil(() => IsListening(pawn, tree), 30f);
            ctx.Assert(IsListening(pawn, tree),
                $"{nickname} is doing {pawn.CurJob?.def.defName ?? "nothing"}, not listening to this tree");
        }

        [Then("Anima Song: {string} is not listening to the tree at x={int} z={int}")]
        public async Task IsNotListening(PickleContext ctx, string nickname, int x, int z)
        {
            Thing tree = TreeAt(ctx, x, z);
            Pawn pawn = Colonist(ctx, nickname);
            await ctx.WaitUntil(() => !IsListening(pawn, tree), 30f);
            ctx.Assert(!IsListening(pawn, tree), $"{nickname} is still listening");
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
            await ctx.WaitUntil(() => IsListening(pawn, tree) && InRing(pawn, tree) && !pawn.pather.Moving, 90f);
            ctx.Assert(IsListening(pawn, tree), $"{nickname} is not listening any more");
            ctx.Assert(InRing(pawn, tree),
                $"{nickname} stands {pawn.Position.DistanceTo(tree.Position):0.0} cells from the trunk, outside the ring");
        }

        [Then("Anima Song: {int} listeners sit on {int} different cells around the tree at x={int} z={int}")]
        public async Task ListenersOnDistinctCells(PickleContext ctx, int listeners, int cells, int x, int z)
        {
            Map map = CurrentMap(ctx);
            Thing tree = TreeAt(ctx, x, z);
            Func<List<Pawn>> seated = () => ListenersOf(map, tree).Where(p => !p.pather.Moving && InRing(p, tree)).ToList();
            await ctx.WaitUntil(() => seated().Count >= listeners, 120f);

            List<Pawn> sitting = seated();
            ctx.Assert(ListenersOf(map, tree).Count() == listeners,
                $"{ListenersOf(map, tree).Count()} colonists are listening, expected {listeners}");
            ctx.Assert(sitting.Count == listeners,
                $"{sitting.Count} of {listeners} listeners sit in the ring; the others: " +
                string.Join(", ", ListenersOf(map, tree).Except(sitting).Select(p => $"{p.LabelShort} at {p.Position}")));
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
