using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
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
        private sealed class SavedFile
        {
            public string Path;
        }

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
            AnimaSongSteps.LoseEveryPart(ctx, nickname, "Eye", PawnCapacityDefOf.Sight);
            Pawn pawn = AnimaSongSteps.Colonist(ctx, nickname);
            ctx.Assert(pawn.health.capacities.CapableOf(PawnCapacityDefOf.Hearing),
                $"{nickname} lost hearing along with sight: the scenario would prove nothing");
        }

        // ------------------------------------------------------------------ the right-click menu, on screen

        /// <summary>
        /// Opens the menu a click on the tree would open, so that a picture can be taken of it. The real click
        /// belongs to a mouse and a person: this asks <c>FloatMenuMakerMap</c> what it would list for the selected
        /// colonist (what <see cref="RightClickOffers"/> asserts on) and puts that list on screen as the game does,
        /// as a <see cref="FloatMenu"/>. The mouse of a run is wherever it was left, and a floating menu opens at the
        /// mouse and closes once the mouse is far from it, so it is placed beside the tree and kept open.
        /// </summary>
        [When("Anima Song: the right-click menu of the tree at x={int} z={int} is open for {string}")]
        public void OpenRightClickMenu(PickleContext ctx, int x, int z, string nickname)
        {
            Thing tree = AnimaSongSteps.TreeAt(ctx, x, z);
            Pawn pawn = AnimaSongSteps.Colonist(ctx, nickname);
            CloseFloatMenus();

            Find.Selector.ClearSelection();
            Find.Selector.Select(pawn, false, true);

            List<FloatMenuOption> options = FloatMenuMakerMap.GetOptions(
                new List<Pawn> { pawn }, tree.DrawPos, out FloatMenuContext _);
            ctx.Assert(options != null && options.Count > 0, $"the menu at the tree holds nothing for {nickname}");

            var menu = new FloatMenu(options) { vanishIfMouseDistant = false };
            Find.WindowStack.Add(menu);
            Vector2 at = GenMapUI.LabelDrawPosFor(tree, 0f);
            menu.windowRect = new Rect(
                Mathf.Clamp(at.x + 40f, 0f, UI.screenWidth - menu.windowRect.width),
                Mathf.Clamp(at.y - 20f, 0f, UI.screenHeight - menu.windowRect.height),
                menu.windowRect.width, menu.windowRect.height);
        }

        [When("Anima Song: the right-click menu is closed")]
        public void CloseRightClickMenu(PickleContext ctx)
        {
            CloseFloatMenus();
        }

        private static void CloseFloatMenus()
        {
            foreach (FloatMenu open in Find.WindowStack.Windows.OfType<FloatMenu>().ToList())
            {
                Find.WindowStack.TryRemove(open, false);
            }
        }


        // ------------------------------------------------------------------ where a colonist starts

        /// <summary>
        /// Puts a colonist a few cells from the tree, on a standable cell they can reach. The fixture spawns a new colonist at a cell
        /// the scenario does not choose, and on 2026-09-25 that cell was (94, 197) with the tree at (70, 132): every one of the ring's 72
        /// cells was unreachable from it, so the order was refused with "no free spot" (two runs, then a third with the seat diagnostics).
        /// A scenario about the SOUND has no use for a sixty-cell walk, and a recording is short: it places the colonist instead.
        /// </summary>
        [Given("Anima Song: {string} stands {int} cells from the tree at x={int} z={int}")]
        public void StandsNearTree(PickleContext ctx, string nickname, int distance, int x, int z)
        {
            Thing tree = AnimaSongSteps.TreeAt(ctx, x, z);
            Pawn pawn = AnimaSongSteps.Colonist(ctx, nickname);
            Map map = pawn.Map;

            IntVec3 spot = IntVec3.Invalid;
            foreach (IntVec3 cell in GenRadial.RadialCellsAround(tree.Position, distance + 1.5f, true)
                         .Where(c => (c - tree.Position).LengthHorizontal >= distance - 0.5f))
            {
                if (cell.InBounds(map) && cell.Standable(map) && !cell.IsForbidden(pawn) && !cell.Roofed(map) &&
                    map.reachability.CanReach(cell, tree.Position, PathEndMode.Touch, TraverseParms.For(pawn)))
                {
                    spot = cell;
                    break;
                }
            }
            ctx.Assert(spot.IsValid, $"no standable, reachable cell {distance} cells from the tree at ({x}, {z}); the ring is walled in or the tree is cut off");

            pawn.Position = spot;
            pawn.Notify_Teleported(true, true);
            ctx.Assert(pawn.Position == spot, $"{nickname} was not moved to {spot}");
        }

        // ------------------------------------------------------------------ what the mod leaves in a save

        /// <summary>
        /// Saves the game to a file of its own (the game's own saver) and remembers its name for the step that reads it.
        /// </summary>
        [When("Anima Song: the game is saved to a file")]
        public void SaveToAFile(PickleContext ctx)
        {
            const string name = "pickle-animasong-save-check";
            GameDataSaveLoader.SaveGame(name);
            string path = GenFilePaths.FilePathForSavedGame(name);
            ctx.Assert(File.Exists(path), $"the game did not write {path}");
            ctx.Set(new SavedFile { Path = path });
        }

        /// <summary>
        /// What the mod says it stores in a save, and nothing else: the toggle and the cooldown on the tree, the listening counter of
        /// a job in progress and its driver, the class name of the halo keeper (the game writes the name of every map component, this one
        /// holds no data), the three defs it names (job, joy kind, memory), and the mod's own id in the header that
        /// lists the active mods. The check reads every word of the saved file that names the mod, and lists them, so that a
        /// forgotten field or a def saved by mistake shows in the report. What the game does with such a save when the mod is gone
        /// is the game's, not asserted here.
        /// </summary>
        [Then("Anima Song: the saved file mentions the mod only through what it says it stores")]
        public void SaveMentionsOnlyWhatItStores(PickleContext ctx)
        {
            string path = ctx.Get<SavedFile>().Path;
            string text = File.ReadAllText(path);
            var words = new System.Text.RegularExpressions.Regex(@"[A-Za-z0-9_.]*[Aa]nima[ ]?[Ss]ong[A-Za-z0-9_.]*")
                .Matches(text).Cast<System.Text.RegularExpressions.Match>().Select(m => m.Value).ToList();
            var allowed = new System.Text.RegularExpressions.Regex(
                @"^(AnimaSong\.(listeningAllowed|lastSongTick|ticksListened)|AnimaSong\.JobDriver_ListenAnimaSong|AnimaSong\.HaloKeeper|AnimaSong_(Listen|Song|Heard)|nelim\.animasong(\.pickletests)?|Anima Song( - Pickle tests)?)$");
            var groups = words.GroupBy(w => w).OrderBy(g => g.Key).ToList();
            string listing = string.Join("; ", groups.Select(g => $"{g.Key} x{g.Count()}"));
            ctx.Attach("what the save says of the mod", listing);
            File.Delete(path);
            var stray = groups.Where(g => !allowed.IsMatch(g.Key)).Select(g => g.Key).ToList();
            ctx.Assert(groups.Count > 0, "the saved file never names the mod: the check reads nothing");
            ctx.Assert(stray.Count == 0, $"the save names the mod in places it does not say it stores: {string.Join(", ", stray)}. All: {listing}");
        }

        // ------------------------------------------------------------------ the inspect line, and the waves

        /// <summary>
        /// The mod's own line is in the tree's inspect text: whatever the language of the pass, the text the game builds for the
        /// selected tree contains what the comp adds to it. The pane it is drawn in scrolls and, in French, the captures show that line
        /// below the fold of the pane, so a picture cannot say it is there; the text can.
        /// </summary>
        [Then("Anima Song: the inspect text of the tree at x={int} z={int} carries the mod's line")]
        public void InspectTextCarriesTheLine(PickleContext ctx, int x, int z)
        {
            Thing tree = AnimaSongSteps.TreeAt(ctx, x, z);
            CompAnimaSong comp = tree.TryGetComp<CompAnimaSong>();
            ctx.Assert(comp != null, "the anima tree carries no CompAnimaSong");
            string line = comp.CompInspectStringExtra();
            ctx.Assert(!string.IsNullOrEmpty(line), "the comp has no inspect line to show in this state");
            string text = tree.GetInspectString();
            ctx.Assert(text.Contains(line), $"the inspect text of the tree does not carry the mod's line \"{line}\"; it reads: {text.Replace("\n", " | ")}");
        }

        /// <summary>
        /// A wave of light is in flight from the tree to a listener: the anima linking pulse the driver throws every two seconds, seen
        /// as a live mote of that def on the map. What the software renderer draws of it is another question (the capture's).
        /// </summary>
        [Then("Anima Song: a wave of light is travelling from the tree at x={int} z={int}")]
        public async Task WaveInFlight(PickleContext ctx, int x, int z)
        {
            Thing tree = AnimaSongSteps.TreeAt(ctx, x, z);
            Map map = tree.Map;
            // Motes are not in the map's thing lister (the first run saw 0 of them, the halo included): the game draws them from the
            // dynamic draw manager's list.
            var drawField = typeof(DynamicDrawManager).GetField("drawThings",
                System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Public);
            ctx.Assert(drawField != null, "DynamicDrawManager.drawThings no longer exists: this step has to follow it");
            Func<List<Thing>> drawn = () => (List<Thing>)drawField.GetValue(map.dynamicDrawManager);
            await AnimaSongSteps.WaitOrExplain(ctx,
                () => drawn().Any(t => t.def.defName == "Mote_PsychicLinkPulse"),
                20f,
                () => "no Mote_PsychicLinkPulse among the things the map draws after 20 s of listening; it draws " +
                      drawn().Count(t => t.def.category == ThingCategory.Mote) + " mote(s)");
        }

        // ------------------------------------------------------------------ what else the game plays

        private static float? mutedMusic, mutedAmbient;

        /// <summary>
        /// Turns the game's music and ambient sounds off for the scenario, so that a recording of the audio output holds what the
        /// mod asks for and not the background music the game plays on its own: the first video with sound (2026-09-25) was never
        /// silent from its first second to its last, which says nothing about the song. The master volume is PickleTools' step
        /// (`the game volume is N percent`); this leaves the game's own sound effects, the song among them, at their level. Put back
        /// after the scenario.
        /// </summary>
        [Given("Anima Song: the music and the ambience are muted")]
        public void MuteMusicAndAmbience(PickleContext ctx)
        {
            mutedMusic = Prefs.VolumeMusic;
            mutedAmbient = Prefs.VolumeAmbient;
            Prefs.VolumeMusic = 0f;
            Prefs.VolumeAmbient = 0f;
        }

        [AfterScenario]
        public void RestoreMusicAndAmbience()
        {
            if (mutedMusic.HasValue) Prefs.VolumeMusic = mutedMusic.Value;
            if (mutedAmbient.HasValue) Prefs.VolumeAmbient = mutedAmbient.Value;
            mutedMusic = null;
            mutedAmbient = null;
        }

        // ------------------------------------------------------------------ the song fires once

        /// <summary>
        /// Remembers when the tree last sang. The sound and the flash sit behind the cooldown's early return in
        /// <c>TrySing</c>, so a <c>lastSongTick</c> that does not move is a song that was not sung: it is the
        /// only observable of "no new sound, no new flash" in a game that has no speakers.
        /// </summary>
        [When("Anima Song: I note when the tree at x={int} z={int} last sang")]
        public async Task NoteSong(PickleContext ctx, int x, int z)
        {
            CompAnimaSong comp = AnimaSongSteps.SongAt(ctx, x, z);

            // The listener's seat is reached a tick or more BEFORE the listen toil's first tick, and TrySing runs
            // in that toil's initAction: read straight after "sits in the ring" the field can still be -1, and the
            // first song would land after the note. The tree is singing once a listening tick has run.
            await AnimaSongSteps.WaitOrExplain(ctx, () => comp.Singing, 30f,
                () => "nobody is listening yet, so the tree has not had its first song to note");
            ctx.Set(new SongNote { Tick = ReadLastSong(ctx, comp) });
        }

        private static int ReadLastSong(PickleContext ctx, CompAnimaSong comp)
        {
            ctx.Assert(LastSongTick != null, "CompAnimaSong.lastSongTick no longer exists: this step has to follow it");
            return (int)LastSongTick.GetValue(comp);
        }

        [Then("Anima Song: the tree at x={int} z={int} has not sung since I noted it")]
        public void NotSungSince(PickleContext ctx, int x, int z)
        {
            int noted = ctx.Get<SongNote>().Tick;
            int now = ReadLastSong(ctx, AnimaSongSteps.SongAt(ctx, x, z));
            ctx.Assert(now == noted, $"the tree sang again inside its cooldown: last song at tick {noted}, now {now}");
        }

        [Then("Anima Song: the tree at x={int} z={int} has sung again since I noted it")]
        public void SungSince(PickleContext ctx, int x, int z)
        {
            int noted = ctx.Get<SongNote>().Tick;
            int now = ReadLastSong(ctx, AnimaSongSteps.SongAt(ctx, x, z));
            ctx.Assert(now > noted, $"the tree is still silent: last song at tick {noted}, and still {now}");
        }

        /// <summary>The value a reload has to give back: the cooldown is saved with the tree, not held in a static.</summary>
        [Then("Anima Song: the tree at x={int} z={int} last sang at the tick I noted")]
        public void SangAtNoted(PickleContext ctx, int x, int z)
        {
            int noted = ctx.Get<SongNote>().Tick;
            int now = ReadLastSong(ctx, AnimaSongSteps.SongAt(ctx, x, z));
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
                SpawnWall(map, cell);
                walls++;
            }

            ctx.Assert(walls > 0, "no standable cell in the ring: nothing was walled");
        }

        private static void SpawnWall(Map map, IntVec3 cell)
        {
            GenSpawn.Spawn(ThingMaker.MakeThing(ThingDefOf.Wall, GenStuff.DefaultStuffFor(ThingDefOf.Wall)), cell, map);
        }

        [Given("Anima Song: a wall stands north of the tree at x={int} z={int}")]
        public void WallNorth(PickleContext ctx, int x, int z)
        {
            Thing tree = AnimaSongSteps.TreeAt(ctx, x, z);
            for (int dx = -3; dx <= 3; dx++)
            {
                IntVec3 cell = new IntVec3(tree.Position.x + dx, 0, tree.Position.z + 2);
                if (!cell.InBounds(tree.Map) || !cell.Standable(tree.Map)) continue;
                SpawnWall(tree.Map, cell);
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
            ctx.Assert(expected.Count > 0, $"{keyedDir} holds no entry");
            var wrong = new List<string>();
            // The other language's file must hold the same keys: a key added to one and forgotten in the other is
            // exactly the omission this step exists to catch, and a fixed count would only say "11, expected 10".
            string otherDir = Path.Combine(mod.RootDir, "Languages", french ? "English" : "French", "Keyed");
            var otherKeys = ReadLanguageData(Directory.GetFiles(otherDir, "*.xml")).Keys;
            foreach (string missing in expected.Keys.Except(otherKeys)) wrong.Add($"{missing}: absent from the {(french ? "English" : "French")} Keyed file");
            foreach (string missing in otherKeys.Except(expected.Keys)) wrong.Add($"{missing}: absent from the {languageDir} Keyed file");
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

            // Every Def field the French resources translate must be one this step reads from the live def:
            // a fifth translated field would otherwise pass unchecked.
            foreach (string untranslated in wantDefs.Keys.Except(live.Keys))
                wrong.Add($"{untranslated}: translated in {languageDir} but not read back by this step");

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
