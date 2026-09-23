using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml.Linq;
using RimWorks.Pickle;
using RimWorld;
using UnityEngine;
using Verse;
using Verse.AI;

namespace AnimaSong.PickleSteps
{
    /// <summary>
    /// What was left of TESTING.md once the first steps class had covered the walk, the seat, the toggle, the
    /// memory and the halo: the real right-click, the drafted colonist, the blind one, the cooldown, the giver that
    /// starts the job on its own, the tolerance the new recreation kind builds, the ring walled in, a tree under a
    /// roof, the Keyed and DefInjected texts read back in the language of the pass, and Phytokin's ability left alone.
    ///
    /// Same rules as <see cref="AnimaSongSteps"/>: every text starts with "Anima Song:", cells are x=.. z=..,
    /// and no step spells an English label.
    /// </summary>
    [PickleSteps]
    public class AnimaSongRemainingSteps
    {
        private sealed class SongNote
        {
            public int Tick;
        }

        private static readonly System.Reflection.FieldInfo LastSongTick =
            typeof(CompAnimaSong).GetField("lastSongTick",
                System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance);

        // ------------------------------------------------------------------ the menu, for real

        /// <summary>
        /// The right-click as the game makes it: the menu maker is asked for the options at the tree's position
        /// with the colonist selected, and the entry must be among them. The first steps class calls the comp
        /// directly; this goes through <c>FloatMenuMakerMap</c>, which is what a click does.
        /// </summary>
        [Then("Anima Song: right-clicking the tree at x={int} z={int} with {string} selected offers the listening order")]
        public void RightClickOffers(PickleContext ctx, int x, int z, string nickname)
        {
            Thing tree = AnimaSongSteps.TreeAt(ctx, x, z);
            Pawn pawn = AnimaSongSteps.Colonist(ctx, nickname);
            string label = "AnimaSong_ListenOrder".Translate();

            List<FloatMenuOption> options = FloatMenuMakerMap.GetOptions(
                new List<Pawn> { pawn }, tree.DrawPos, out FloatMenuContext _);
            ctx.Assert(options != null && options.Any(o => !o.Disabled && o.Label != null && o.Label.StartsWith(label)),
                $"the menu at the tree holds no live \"{label}\" entry; it holds: " +
                string.Join(" | ", (options ?? new List<FloatMenuOption>()).Select(o => o.Label)));
        }

        [Then("Anima Song: no order is offered to {string} for the tree at x={int} z={int}")]
        public void NoOrderOffered(PickleContext ctx, string nickname, int x, int z)
        {
            Thing tree = AnimaSongSteps.TreeAt(ctx, x, z);
            Pawn pawn = AnimaSongSteps.Colonist(ctx, nickname);
            CompAnimaSong comp = tree.TryGetComp<CompAnimaSong>();
            ctx.Assert(comp != null, "the anima tree carries no CompAnimaSong");
            int count = comp.CompFloatMenuOptions(pawn).Count();
            ctx.Assert(count == 0, $"{nickname} was offered {count} order(s); a drafted colonist gets none");
        }

        /// <summary>
        /// Blindness, by taking both eyes. The mod asks for Hearing and nothing else, so a colonist who cannot see
        /// must still be able to listen: this is the removal that proves the requirement is not wider than it says.
        /// </summary>
        [Given("Anima Song: {string} is made blind")]
        public void MakeBlind(PickleContext ctx, string nickname)
        {
            Pawn pawn = AnimaSongSteps.Colonist(ctx, nickname);
            List<BodyPartRecord> eyes = pawn.RaceProps.body.AllParts.Where(p => p.def.defName == "Eye").ToList();
            ctx.Require(eyes.Count > 0, $"{nickname}'s body has no part named Eye");
            foreach (BodyPartRecord eye in eyes)
            {
                pawn.health.AddHediff(HediffDefOf.MissingBodyPart, eye);
            }

            ctx.Assert(!pawn.health.capacities.CapableOf(PawnCapacityDefOf.Sight),
                $"{nickname} still sees after losing {eyes.Count} eyes");
            ctx.Assert(pawn.health.capacities.CapableOf(PawnCapacityDefOf.Hearing),
                $"{nickname} lost hearing along with sight: the scenario would prove nothing");
        }

        // ------------------------------------------------------------------ the song fires once

        /// <summary>
        /// Remembers when the tree last sang. The sound and the flash sit behind the cooldown's early return in
        /// <c>TrySing</c>, so a <c>lastSongTick</c> that does not move is a song that was not sung: it is the
        /// only observable of "no new sound, no new flash" in a game that has no speakers.
        /// </summary>
        [When("Anima Song: I note when the tree at x={int} z={int} last sang")]
        public void NoteSong(PickleContext ctx, int x, int z)
        {
            ctx.Assert(LastSongTick != null, "CompAnimaSong.lastSongTick no longer exists: this step has to follow it");
            int tick = (int)LastSongTick.GetValue(AnimaSongSteps.SongAt(ctx, x, z));
            ctx.Set(new SongNote { Tick = tick });
        }

        [Then("Anima Song: the tree at x={int} z={int} has not sung since I noted it")]
        public void NotSungSince(PickleContext ctx, int x, int z)
        {
            int noted = ctx.Get<SongNote>().Tick;
            int now = (int)LastSongTick.GetValue(AnimaSongSteps.SongAt(ctx, x, z));
            ctx.Assert(now == noted, $"the tree sang again inside its cooldown: last song at tick {noted}, now {now}");
        }

        [Then("Anima Song: the tree at x={int} z={int} has sung again since I noted it")]
        public void SungSince(PickleContext ctx, int x, int z)
        {
            int noted = ctx.Get<SongNote>().Tick;
            int now = (int)LastSongTick.GetValue(AnimaSongSteps.SongAt(ctx, x, z));
            ctx.Assert(now > noted, $"the tree is still silent: last song at tick {noted}, and still {now}");
        }

        /// <summary>The value a reload has to give back: the cooldown is saved with the tree, not held in a static.</summary>
        [Then("Anima Song: the tree at x={int} z={int} last sang at the tick I noted")]
        public void SangAtNoted(PickleContext ctx, int x, int z)
        {
            int noted = ctx.Get<SongNote>().Tick;
            int now = (int)LastSongTick.GetValue(AnimaSongSteps.SongAt(ctx, x, z));
            ctx.Assert(now == noted, $"the cooldown did not survive the save: it was {noted}, it reads {now}");
        }

        // ------------------------------------------------------------------ the giver, and what it builds

        /// <summary>
        /// The autonomous route, without waiting on a die roll. <c>baseChance</c> decides how often recreation time
        /// picks this giver; what the giver does when it IS picked is <c>TryGiveJob</c>, and that is deterministic:
        /// it finds the tree, a seat and a reservation, or it gives nothing.
        /// </summary>
        [Then("Anima Song: the recreation giver offers {string} the tree at x={int} z={int}")]
        public void GiverOffers(PickleContext ctx, string nickname, int x, int z)
        {
            Thing tree = AnimaSongSteps.TreeAt(ctx, x, z);
            Pawn pawn = AnimaSongSteps.Colonist(ctx, nickname);
            Job job = Giver(ctx).Worker.TryGiveJob(pawn);
            ctx.Assert(job != null, $"the giver offered {nickname} nothing, with the tree open and unroofed");
            ctx.Assert(job.def == AnimaSongDefOf.AnimaSong_Listen && job.targetA.Thing == tree,
                $"the giver offered {nickname} {job.def.defName} on {job.targetA.Thing}, not the listening job on the tree");
        }

        [Then("Anima Song: the recreation giver offers {string} nothing")]
        public void GiverOffersNothing(PickleContext ctx, string nickname)
        {
            Pawn pawn = AnimaSongSteps.Colonist(ctx, nickname);
            Job job = Giver(ctx).Worker.TryGiveJob(pawn);
            ctx.Assert(job == null,
                $"the giver still offers {nickname} {job?.def.defName} on {job?.targetA.Thing}");
        }

        private static JoyGiverDef Giver(PickleContext ctx)
        {
            JoyGiverDef def = DefDatabase<JoyGiverDef>.GetNamedSilentFail("AnimaSong_Listen");
            ctx.Assert(def != null, "the JoyGiverDef AnimaSong_Listen does not exist: Royalty is not loaded");
            return def;
        }

        /// <summary>
        /// The new recreation kind reaches the tolerance system. Tolerance is counted per kind and rises when
        /// joy of that kind is gained, so a colonist who has sat and gained joy must hold a positive tolerance
        /// for it: if the JoyKindDef never reached the need, this stays at zero.
        /// </summary>
        [Then("Anima Song: {string} has built tolerance for the anima song")]
        public void BuiltTolerance(PickleContext ctx, string nickname)
        {
            Pawn pawn = AnimaSongSteps.Colonist(ctx, nickname);
            JoyKindDef kind = DefDatabase<JoyKindDef>.GetNamedSilentFail("AnimaSong_Song");
            ctx.Assert(kind != null, "the JoyKindDef AnimaSong_Song does not exist");
            float tolerance = pawn.needs.joy.tolerances[kind];
            ctx.Assert(tolerance > 0f, $"{nickname}'s tolerance for the anima song is {tolerance}: the kind builds none");
        }

        [Then("Anima Song: {string} holds {int} memory of the anima song")]
        public void HoldsMemories(PickleContext ctx, string nickname, int expected)
        {
            Pawn pawn = AnimaSongSteps.Colonist(ctx, nickname);
            int count = pawn.needs.mood.thoughts.memories.Memories.Count(m => m.def == AnimaSongDefOf.AnimaSong_Heard);
            ctx.Assert(count == expected, $"{nickname} holds {count} memories of the anima song, expected {expected}");
        }

        // ------------------------------------------------------------------ the tree and its surroundings

        /// <summary>
        /// Every standable cell of the ring gets a wall, so that no seat exists: the fourth refusal, "no free
        /// spot", is reached only when the hearing and the reservation both pass and the sweep still finds nothing.
        /// </summary>
        [Given("Anima Song: the ring around the tree at x={int} z={int} is walled in")]
        public void WallTheRing(PickleContext ctx, int x, int z)
        {
            Thing tree = AnimaSongSteps.TreeAt(ctx, x, z);
            Map map = tree.Map;
            int walls = 0;
            foreach (IntVec3 cell in GenRadial.RadialCellsAround(tree.Position, AnimaSongSeats.MaxRadius, true).ToList())
            {
                if ((cell - tree.Position).LengthHorizontal < AnimaSongSeats.MinRadius) continue;
                if (!cell.InBounds(map) || !cell.Standable(map)) continue;
                GenSpawn.Spawn(ThingMaker.MakeThing(ThingDefOf.Wall, GenStuff.DefaultStuffFor(ThingDefOf.Wall)), cell, map);
                walls++;
            }

            ctx.Assert(walls > 0, "no standable cell in the ring: nothing was walled");
        }

        [Given("Anima Song: a wall stands north of the tree at x={int} z={int}")]
        public void WallNorth(PickleContext ctx, int x, int z)
        {
            Thing tree = AnimaSongSteps.TreeAt(ctx, x, z);
            for (int dx = -3; dx <= 3; dx++)
            {
                IntVec3 cell = new IntVec3(tree.Position.x + dx, 0, tree.Position.z + 2);
                if (!cell.InBounds(tree.Map) || !cell.Standable(tree.Map)) continue;
                GenSpawn.Spawn(ThingMaker.MakeThing(ThingDefOf.Wall, GenStuff.DefaultStuffFor(ThingDefOf.Wall)), cell, tree.Map);
            }
        }

        [Given("Anima Song: the tree at x={int} z={int} is roofed over")]
        public void RoofTree(PickleContext ctx, int x, int z)
        {
            Thing tree = AnimaSongSteps.TreeAt(ctx, x, z);
            tree.Map.roofGrid.SetRoof(tree.Position, RoofDefOf.RoofConstructed);
            ctx.Assert(tree.Position.Roofed(tree.Map), "the tree's cell is still unroofed after setting a roof");
        }

        /// <summary>Nobody listens through a wall, and nobody listens under a roof: read on the cells the listeners took.</summary>
        [Then("Anima Song: every listener of the tree at x={int} z={int} has it in sight")]
        public void ListenersSeeTheTree(PickleContext ctx, int x, int z)
        {
            Thing tree = AnimaSongSteps.TreeAt(ctx, x, z);
            List<Pawn> listeners = AnimaSongSteps.ListenersOf(tree.Map, tree).ToList();
            ctx.Assert(listeners.Count > 0, "nobody is listening: nothing to check");
            foreach (Pawn pawn in listeners)
            {
                ctx.Assert(GenSight.LineOfSight(pawn.Position, tree.Position, tree.Map, true),
                    $"{pawn.LabelShort} sits at {pawn.Position} with no line of sight to the trunk");
                ctx.Assert(!pawn.Position.Roofed(tree.Map), $"{pawn.LabelShort} sits under a roof at {pawn.Position}");
            }
        }

        // ------------------------------------------------------------------ the texts, in the language of the pass

        /// <summary>
        /// Every owned text, read back from the game in the language the pass was staged in and compared with the
        /// mod's own resource file: the ten Keyed entries, and the four Def fields that DefInjected translates.
        /// Not a spelling of the expected text in this file: it is read from <c>Languages/</c>, so a text corrected
        /// there is corrected here, and a key that resolves to the wrong language - or to the accented fallback
        /// dev mode shows for a missing one - fails on the difference. Passes in English and in French, and only
        /// says anything in the language it runs in, which is why the suite is played once per language.
        /// </summary>
        [Then("Anima Song: every text of the mod reads as its resource file says, in the language of this pass")]
        public void TextsFollowTheLanguage(PickleContext ctx)
        {
            ModContentPack mod = LoadedModManager.RunningModsListForReading
                .FirstOrDefault(m => m.PackageIdPlayerFacing.Equals("nelim.animasong", StringComparison.OrdinalIgnoreCase));
            ctx.Assert(mod != null, "the mod nelim.animasong is not among the running mods");

            string folder = LanguageDatabase.activeLanguage.folderName;
            bool french = folder.StartsWith("French", StringComparison.OrdinalIgnoreCase);
            string languageDir = french ? "French" : "English";

            // Keyed: every key, no parameter but the one the disabled order takes.
            string keyedDir = Path.Combine(mod.RootDir, "Languages", languageDir, "Keyed");
            var expected = ReadLanguageData(Directory.GetFiles(keyedDir, "*.xml"));
            ctx.Assert(expected.Count == 10, $"{keyedDir} holds {expected.Count} entries, expected 10");
            var wrong = new List<string>();
            foreach (KeyValuePair<string, string> entry in expected)
            {
                string actual = entry.Key == "AnimaSong_ListenOrderDisabled"
                    ? entry.Key.Translate("REASON").ToString()
                    : entry.Key.Translate().ToString();
                string want = entry.Key == "AnimaSong_ListenOrderDisabled" ? entry.Value.Replace("{0}", "REASON") : entry.Value;
                if (actual != want) wrong.Add($"{entry.Key}: reads \"{actual}\", the {languageDir} file says \"{want}\"");
            }

            // Def fields. English is the Def's own value; French is injected from the DefInjected files.
            string defsFile = Path.Combine(mod.RootDir, "Defs", "AnimaSong.xml");
            var defs = XDocument.Load(defsFile).Root;
            var live = new Dictionary<string, string>
            {
                ["AnimaSong_Song.label"] = DefDatabase<JoyKindDef>.GetNamedSilentFail("AnimaSong_Song")?.label,
                ["AnimaSong_Listen.reportString"] = DefDatabase<JobDef>.GetNamedSilentFail("AnimaSong_Listen")?.reportString,
                ["AnimaSong_Heard.stages.anima_song.label"] = AnimaSongDefOf.AnimaSong_Heard?.stages?.FirstOrDefault()?.label,
                ["AnimaSong_Heard.stages.anima_song.description"] = AnimaSongDefOf.AnimaSong_Heard?.stages?.FirstOrDefault()?.description,
            };
            var wantDefs = new Dictionary<string, string>();
            if (french)
            {
                var files = new List<string>();
                files.AddRange(Directory.GetFiles(Path.Combine(mod.RootDir, "Languages", "French", "DefInjected"), "*.xml", SearchOption.AllDirectories));
                string royalty = Path.Combine(mod.RootDir, "Royalty", "Languages", "French", "DefInjected");
                if (Directory.Exists(royalty)) files.AddRange(Directory.GetFiles(royalty, "*.xml", SearchOption.AllDirectories));
                wantDefs = ReadLanguageData(files);
            }
            else
            {
                wantDefs["AnimaSong_Song.label"] = defs.Descendants("JoyKindDef").First().Element("label").Value;
                wantDefs["AnimaSong_Listen.reportString"] = defs.Descendants("JobDef").First().Element("reportString").Value;
                XElement stage = defs.Descendants("ThoughtDef").First().Descendants("li").First();
                wantDefs["AnimaSong_Heard.stages.anima_song.label"] = stage.Element("label").Value;
                wantDefs["AnimaSong_Heard.stages.anima_song.description"] = stage.Element("description").Value;
            }

            foreach (KeyValuePair<string, string> entry in live)
            {
                ctx.Assert(wantDefs.ContainsKey(entry.Key), $"the {languageDir} resources hold no entry for {entry.Key}");
                if (entry.Value != wantDefs[entry.Key])
                    wrong.Add($"{entry.Key}: the live def reads \"{entry.Value}\", the {languageDir} resource says \"{wantDefs[entry.Key]}\"");
            }

            ctx.Assert(wrong.Count == 0, $"in {folder}: " + string.Join("; ", wrong));
        }

        private static Dictionary<string, string> ReadLanguageData(IEnumerable<string> files)
        {
            var result = new Dictionary<string, string>();
            foreach (string file in files)
            {
                foreach (XElement node in XDocument.Load(file).Root.Elements())
                {
                    // Keyed and DefInjected text writes a line break as the two characters \n.
                    result[node.Name.LocalName] = node.Value.Replace("\\n", "\n");
                }
            }

            return result;
        }
    }
}
