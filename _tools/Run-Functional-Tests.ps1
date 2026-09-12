<#
.SYNOPSIS
  Asks the installed game whether it still does what this mod hands it to do. No RimWorld launched.

.DESCRIPTION
  This mod owns very little of its own behaviour. The walking, the sitting, the joy gain and the
  search for a target all belong to the base game's recreation code; what the mod adds is a joy
  giver that subclasses it, a driver that retypes one cast, a comp on a plant, and four defs. Every
  one of those hand-offs fails SILENTLY when the game moves underneath it: an override that stops
  overriding is never called, a patch whose xpath misses is a PatchOperationConditional that says
  nothing, and a def looked up with GetNamedSilentFail is exactly that, silent.

  So the questions are:

    - do the mod's overrides still override, or have they become methods nobody calls?
    - are the three claims the design rests on still true of Assembly-CSharp - the search going
      through listerThings, CanInteractWith ignoring def.building, and the vanilla driver's hard
      cast to Building?
    - does the patch still land on the anima tree, and leave the def in one piece?
    - do the six defs this mod looks up by name still exist?
    - does the French memory key still match the handle the game builds from the stage label?

  All of it by reflection and IL against the installed game's own Assembly-CSharp, plus the real
  Core and Royalty def files. Nothing is asserted from memory.

  What this file does NOT do: anything that needs the game running. No mote is drawn here, no
  colonist sits down, no sound plays. TESTING.md holds those, and this file does not replace it.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
#>
param(
    [string]$Managed  = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\RimWorldWin64_Data\Managed',
    [string]$GameData = 'C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Data'
)

$ErrorActionPreference = 'Stop'
$ModRoot = Split-Path -Parent $PSScriptRoot
$Mod     = Join-Path $ModRoot 'Mod'

# ---------------------------------------------------------------------------------------------
# Harness
# ---------------------------------------------------------------------------------------------

$script:pass = 0; $script:fail = 0; $script:n = 0
function Test-That([string]$name, [scriptblock]$body) {
    $script:n++
    try {
        $r = & $body
        if (($r -is [string]) -and ($r -eq 'skip')) {
            Write-Host ("  {0,2}. SKIP  {1}" -f $script:n, $name) -ForegroundColor DarkGray
            return
        }
        if ($r) { $script:pass++; Write-Host ("  {0,2}. ok    {1}" -f $script:n, $name) -ForegroundColor DarkGreen }
        else    { $script:fail++; Write-Host ("  {0,2}. FAIL  {1}" -f $script:n, $name) -ForegroundColor Red }
    } catch {
        $script:fail++
        Write-Host ("  {0,2}. FAIL  {1}" -f $script:n, $name) -ForegroundColor Red
        Write-Host ("        {0}" -f $_.Exception.Message) -ForegroundColor DarkRed
    }
}
function Note([string]$text) { Write-Host ("        " + $text) -ForegroundColor DarkGray }

# Always with -Encoding UTF8: Windows PowerShell 5.1 reads a BOM-less file through the system code
# page, and a test looking for an accented word finds mojibake instead.
function Read-Text([string]$p) { Get-Content $p -Raw -Encoding UTF8 }

# ---------------------------------------------------------------------------------------------
# The game, by reflection
# ---------------------------------------------------------------------------------------------

# Assembly-CSharp names Unity assemblies that are not next to this script. An unresolvable name
# asked for twice recurses to a stack overflow rather than an error, hence the memo; the null
# guard matters because the handler lives on the process AppDomain, which outlives this script.
$script:probeDirs = @($Managed, (Join-Path $Mod 'Assemblies'))
$script:probed = @{}
$script:asmResolver = [System.ResolveEventHandler]{
    param($sender, $e)
    if ($null -eq $script:probed) { return $null }
    $short = $e.Name.Split(',')[0]
    if ($script:probed.ContainsKey($short)) { return $null }
    $script:probed[$short] = $true
    foreach ($d in $script:probeDirs) {
        $p = Join-Path $d "$short.dll"
        if (Test-Path $p) { return [System.Reflection.Assembly]::LoadFrom($p) }
    }
    return $null
}
[System.AppDomain]::CurrentDomain.add_AssemblyResolve($script:asmResolver)

# GetTypes() always throws here - Unity is missing - but the exception carries every type it did
# resolve, which is all of them but a handful. PowerShell wraps it, so both shapes are caught.
function Get-AssemblyTypes([string]$path) {
    $a = [System.Reflection.Assembly]::LoadFrom($path)
    try     { return $a.GetTypes() }
    catch [System.Reflection.ReflectionTypeLoadException] { return $_.Exception.Types | Where-Object { $_ } }
    catch   { return $_.Exception.InnerException.Types | Where-Object { $_ } }
}

$gameTypes = Get-AssemblyTypes (Join-Path $Managed 'Assembly-CSharp.dll')
$modDll    = Join-Path $Mod 'Assemblies\AnimaSong.dll'
$modTypes  = @(Get-AssemblyTypes $modDll)

$TypeIndex = @{}
foreach ($t in $gameTypes) {
    if ($t.Name -and -not $TypeIndex.ContainsKey($t.Name)) { $TypeIndex[$t.Name] = $t }
    if ($t.FullName -and -not $TypeIndex.ContainsKey($t.FullName)) { $TypeIndex[$t.FullName] = $t }
}
$BF = [System.Reflection.BindingFlags]'Public,NonPublic,Instance,Static'

# Reading one method's instructions. Three questions are asked of a body below - what does it
# call, what does it cast to, which fields does it touch - and all three are the same walk over
# the IL with a token resolved against the declaring module. ResolveMember throws on a token that
# belongs to a generic context it cannot rebuild, so every resolution is guarded: a body that
# cannot be read at all comes back empty, which fails a test rather than passing it silently.
Add-Type -TypeDefinition @'
using System;using System.Collections.Generic;using System.Reflection;
public static class AsIl {
  // 0x28 call, 0x6F callvirt, 0x73 newobj, 0x74 castclass, 0x75 isinst,
  // 0x7B ldfld, 0x7C ldflda, 0x7D stfld, 0x7E ldsfld, 0x7F ldsflda, 0x80 stsfld.
  static bool IsCall(byte op)  { return op == 0x28 || op == 0x6F || op == 0x73; }
  static bool IsCast(byte op)  { return op == 0x74 || op == 0x75; }
  static bool IsField(byte op) { return op >= 0x7B && op <= 0x80; }

  public static string[] Members(MethodBase m, string kind) {
    var res = new List<string>();
    byte[] il;
    try { var b = m.GetMethodBody(); if (b == null) return res.ToArray(); il = b.GetILAsByteArray(); }
    catch { return res.ToArray(); }
    if (il == null) return res.ToArray();
    Module mod = m.Module;
    for (int i = 0; i + 4 < il.Length; i++) {
      byte op = il[i];
      bool want = kind == "call" ? IsCall(op) : kind == "cast" ? IsCast(op) : IsField(op);
      if (!want) continue;
      int tok = BitConverter.ToInt32(il, i + 1);
      string name = null;
      try {
        if (IsCast(op)) { Type t = mod.ResolveType(tok); name = t.FullName; }
        else {
          MemberInfo mi = mod.ResolveMember(tok);
          if (mi != null && mi.DeclaringType != null) name = mi.DeclaringType.Name + "." + mi.Name;
        }
      } catch { }
      if (name != null && !res.Contains(name)) res.Add(name);
    }
    return res.ToArray();
  }
}
'@

function Calls-Of ($m)  { @([AsIl]::Members($m, 'call')) }
function Casts-Of ($m)  { @([AsIl]::Members($m, 'cast')) }
function Fields-Of ($m) { @([AsIl]::Members($m, 'field')) }

$defsXml  = New-Object System.Xml.XmlDocument; $defsXml.Load((Join-Path $Mod 'Defs\AnimaSong.xml'))
$patchXml = New-Object System.Xml.XmlDocument; $patchXml.Load((Join-Path $Mod 'Patches\AnimaTree.xml'))
$plantsXml = Join-Path $GameData 'Royalty\Defs\ThingDefs_Plants\Plants_Wild.xml'

Write-Host ""
Write-Host "Anima Song - functional tests" -ForegroundColor Cyan
Write-Host ""

# ---------------------------------------------------------------------------------------------
# 0. The harness itself
# ---------------------------------------------------------------------------------------------
Write-Host " Harness" -ForegroundColor Cyan

# A test written in the negative - "no method reads this", "this cast is gone" - passes for free
# when its inputs are empty. Everything below reads from these, so they are counted first.
Test-That "the game, the mod assembly, the defs and the patch all loaded" {
    Note ("game types {0}, mod types {1}, defs {2}, patch operations {3}" -f `
        $gameTypes.Count, $modTypes.Count, $defsXml.SelectNodes('/Defs/*').Count, $patchXml.SelectNodes('/Patch/Operation').Count)
    ($gameTypes.Count -gt 10000) -and ($modTypes.Count -ge 5) -and
    ($defsXml.SelectNodes('/Defs/*').Count -eq 4) -and ($patchXml.SelectNodes('/Patch/Operation').Count -eq 1) -and
    (Test-Path $plantsXml)
}

# The IL reader is the other input that can go quiet. A method everyone agrees calls something,
# read back as calling nothing, would make three tests below pass for the wrong reason.
Test-That "the IL reader reads a body it is known to read" {
    $t = $TypeIndex['JoyGiver_InteractBuilding']
    $m = $t.GetMethod('CanInteractWith', $BF)
    $calls = Calls-Of $m
    Note ("JoyGiver_InteractBuilding.CanInteractWith calls {0} distinct members" -f $calls.Count)
    $calls.Count -ge 3
}

# ---------------------------------------------------------------------------------------------
# 1. The mod's own code, and what it is allowed to touch
# ---------------------------------------------------------------------------------------------
Write-Host " The mod's own code" -ForegroundColor Cyan

# The publicizer trap, which cost two other mods in this collection their silent failures.
# Krafs.Publicizer grants itself access through [assembly: IgnoresAccessChecksTo], written into
# the AssemblyInfo the SDK generates - and GenerateAssemblyInfo is false here, which deletes that
# file. The grant is then never applied, the build stays clean, and the CLR throws at the first
# real access. This mod declares no publicizer at all, so the trap cannot arm; the proof is a
# compile rather than an argument.
Test-That "the source compiles against the un-publicized game assembly" {
    if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) { Note 'dotnet not on PATH'; return 'skip' }
    $probe = Join-Path ([System.IO.Path]::GetTempPath()) ('as-access-' + [guid]::NewGuid().ToString('N').Substring(0,8))
    New-Item -ItemType Directory $probe | Out-Null
    try {
        Copy-Item (Join-Path $ModRoot 'Source\*.cs') $probe
        @"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Library</OutputType><TargetFramework>net48</TargetFramework>
    <AssemblyName>AsAccessProbe</AssemblyName>
    <GenerateAssemblyInfo>false</GenerateAssemblyInfo>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="Assembly-CSharp"><HintPath>$Managed\Assembly-CSharp.dll</HintPath><Private>false</Private></Reference>
    <Reference Include="UnityEngine.CoreModule"><HintPath>$Managed\UnityEngine.CoreModule.dll</HintPath><Private>false</Private></Reference>
    <Reference Include="UnityEngine"><HintPath>$Managed\UnityEngine.dll</HintPath><Private>false</Private></Reference>
  </ItemGroup>
</Project>
"@ | Set-Content (Join-Path $probe 'Probe.csproj') -Encoding UTF8
        $out = & dotnet build (Join-Path $probe 'Probe.csproj') -c Release -v q --nologo 2>&1 | Out-String
        $errors = @([regex]::Matches($out, '(?m)error CS\d+.*$') | ForEach-Object { $_.Value })
        if ($errors) { Note ($errors | Select-Object -First 3) }
        # CS0122 is the one that matters - "inaccessible due to its protection level".
        $errors.Count -eq 0
    } finally { Remove-Item $probe -Recurse -Force -ErrorAction SilentlyContinue }
}

# The invariant that would speak the day someone adds a publicizer here without knowing what it
# needs. Either both or neither: a publicizer with no grant is the silent failure, a grant with no
# publicizer is harmless but means the csproj changed under this test. Read the attribute through
# reflection, never by grepping the DLL - the type name is in the bytes either way, which is
# exactly the shape of the trap.
Test-That "no access grant is claimed that the build could not have applied" {
    $data = [System.Reflection.Assembly]::LoadFrom($modDll).GetCustomAttributesData()
    $grant = @($data | Where-Object { $_.AttributeType.Name -eq 'IgnoresAccessChecksToAttribute' })
    $publicized = (Read-Text (Join-Path $ModRoot 'Source\AnimaSong.csproj')) -match '<Publicize\b'
    Note ("publicizer declared: {0}; access grant present: {1}" -f $publicized, ($grant.Count -gt 0))
    $publicized -eq ($grant.Count -gt 0)
}

# An override that stops overriding is the quietest failure of the lot: the class still compiles,
# the def still names it, and the game calls the base method forever. GetBaseDefinition is what
# tells them apart - it returns the method itself when nothing was overridden.
Test-That "the joy giver's TryGivePlayJob really overrides the vanilla one" {
    $ours = ($modTypes | Where-Object { $_.Name -eq 'JoyGiver_ListenAnimaSong' }) | Select-Object -First 1
    $m = $ours.GetMethod('TryGivePlayJob', $BF)
    $base = $m.GetBaseDefinition()
    Note ("base class {0}; override resolves to {1}.{2}" -f $ours.BaseType.Name, $base.DeclaringType.Name, $base.Name)
    ($ours.BaseType.Name -eq 'JoyGiver_InteractBuilding') -and ($base.DeclaringType.Name -eq 'JoyGiver_InteractBuilding')
}

Test-That "the driver's two overrides really override, and it is a JobDriver" {
    $ours = ($modTypes | Where-Object { $_.Name -eq 'JobDriver_ListenAnimaSong' }) | Select-Object -First 1
    $toils = $ours.GetMethod('MakeNewToils', $BF)
    $resv  = $ours.GetMethod('TryMakePreToilReservations', $BF)
    Note ("base class {0}" -f $ours.BaseType.Name)
    ($ours.BaseType.Name -eq 'JobDriver') -and
    ($toils.GetBaseDefinition().DeclaringType.Name -eq 'JobDriver') -and
    ($resv.GetBaseDefinition().DeclaringType.Name -eq 'JobDriver')
}

# The comp's properties class has to name its comp class, or the tree carries a CompProperties
# that builds nothing. It is set in the constructor, so the check instantiates rather than reads.
Test-That "the comp properties still point back at the comp" {
    $props = ($modTypes | Where-Object { $_.Name -eq 'CompProperties_AnimaSong' }) | Select-Object -First 1
    $comp  = ($modTypes | Where-Object { $_.Name -eq 'CompAnimaSong' }) | Select-Object -First 1
    $inst = [System.Activator]::CreateInstance($props)
    $field = $props.BaseType.GetField('compClass', $BF)
    Note ("compClass = {0}; comp derives from {1}" -f $field.GetValue($inst).Name, $comp.BaseType.Name)
    ($field.GetValue($inst) -eq $comp) -and ($comp.BaseType.Name -eq 'ThingComp')
}

# ---------------------------------------------------------------------------------------------
# 2. The three claims the design rests on
# ---------------------------------------------------------------------------------------------
Write-Host " What the base game still does" -ForegroundColor Cyan

# CLAIM ONE. A joy giver aimed at a plant works because the search goes through listerThings, not
# listerBuildings. If a future version routes it through listerBuildings, the giver keeps loading
# and simply never finds a tree - no error anywhere.
Test-That "the joy giver's search set still comes from listerThings, not listerBuildings" {
    $m = $TypeIndex['JoyGiver'].GetMethod('GetSearchSet', $BF)
    $calls  = Calls-Of $m
    $fields = Fields-Of $m
    $lister  = @($calls + $fields) -match 'ThingsOfDef|listerThings'
    $builder = @($calls + $fields) -match 'ListerBuildings|listerBuildings'
    Note ("listerThings hits {0}; listerBuildings hits {1}" -f $lister.Count, $builder.Count)
    ($lister.Count -ge 1) -and ($builder.Count -eq 0)
}

# CLAIM TWO. The same giver's per-target checks never look at def.building, which is the other
# half of "a plant passes". A def.building read appearing here would start rejecting the tree,
# again with no message.
Test-That "CanInteractWith still never reads def.building" {
    $m = $TypeIndex['JoyGiver_InteractBuilding'].GetMethod('CanInteractWith', $BF)
    $fields = Fields-Of $m
    $building = @($fields) -match '^ThingDef\.building$'
    Note ("fields read: {0}" -f (($fields | Select-Object -First 8) -join ', '))
    $building.Count -eq 0
}

# The same method is where the six-listener cap is enforced for a colonist deciding on their own,
# and the call the right-click order copies. If it stopped reserving with joyMaxParticipants, the
# menu's own check would be guarding something the game no longer enforces.
Test-That "CanInteractWith still reserves with the job's joyMaxParticipants" {
    $m = $TypeIndex['JoyGiver_InteractBuilding'].GetMethod('CanInteractWith', $BF)
    $fields = Fields-Of $m
    Note ("joyMaxParticipants read here: {0}" -f (@($fields) -match 'joyMaxParticipants').Count)
    (@($fields) -match 'joyMaxParticipants').Count -ge 1
}

# CLAIM THREE, and the reason JobDriver_ListenAnimaSong exists at all. The vanilla sit-and-face
# driver casts its target to Building. The day that cast goes, this mod's driver is redundant -
# which is worth knowing, and is the opposite of a failure.
Test-That "the vanilla sit-facing driver still hard-casts its target to Building" {
    $t = $TypeIndex['JobDriver_SitFacingBuilding']
    $getter = $t.GetProperty('Building', $BF).GetGetMethod($true)
    $casts = Casts-Of $getter
    Note ("casts to: {0}" -f ($casts -join ', '))
    @($casts) -contains 'Verse.Building'
}

# The right-click order is free of Harmony only because ThingWithComps asks every comp for menu
# options. A plant carrying a comp gets its entry from that call and nothing else.
Test-That "ThingWithComps still asks its comps for float menu options" {
    # The method is an iterator, so its own body only builds a state machine: the calls live in
    # the compiler-generated nested class's MoveNext. Reading the outer body alone finds a
    # constructor and nothing else, which would pass a "does not call" test for free.
    $t = $TypeIndex['ThingWithComps']
    $state = @($t.GetNestedTypes($BF) | Where-Object { $_.Name -like '*GetFloatMenuOptions*' }) | Select-Object -First 1
    if (-not $state) { Note 'no state machine found for the iterator'; return $false }
    $calls = Calls-Of $state.GetMethod('MoveNext', $BF)
    Note ("{0}.MoveNext calls {1} members" -f $state.Name, $calls.Count)
    @($calls) -match 'CompFloatMenuOptions'
}

# A comp on a plant is legal only because Plant is a ThingWithComps. This is what lets the patch
# below add a comp to a def that is not a building.
Test-That "Plant still derives from ThingWithComps" {
    $p = $TypeIndex['Plant']
    $chain = @(); $t = $p
    while ($t -and $t.Name -ne 'Object') { $chain += $t.Name; $t = $t.BaseType }
    Note ($chain -join ' -> ')
    $chain -contains 'ThingWithComps'
}

# ---------------------------------------------------------------------------------------------
# 3. The defs, against the real ones
# ---------------------------------------------------------------------------------------------
Write-Host " The defs and the patch" -ForegroundColor Cyan

# Six defs are fetched by name at runtime, every one of them with GetNamedSilentFail or a
# ContentFinder that returns null rather than complaining. A rename in a future version costs the
# song, the halo, the wave or the memory's scaling, and nothing in the log would say so.
Test-That "the six defs looked up by name are still there" {
    $wanted = @{
        'AnimaTreeLink'         = 'SoundDef'     # the song, without Phytokin
        'Mote_PsyfocusPulse'    = 'ThingDef'     # the halo
        'Mote_PsychicLinkPulse' = 'ThingDef'     # the wave to each listener
        'PsycastPsychicEffect'  = 'FleckDef'     # the flash when the song starts
        'PsychicSensitivity'    = 'StatDef'      # what multiplies the memory
        'Hearing'               = 'PawnCapacityDef'
    }
    $missing = @()
    $files = Get-ChildItem $GameData -Recurse -Filter *.xml -File -ErrorAction SilentlyContinue
    $text = New-Object System.Text.StringBuilder
    foreach ($f in $files) { [void]$text.Append((Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue)) }
    $all = $text.ToString()
    foreach ($k in $wanted.Keys) { if ($all -notmatch ('<defName>' + [regex]::Escape($k) + '</defName>')) { $missing += $k } }
    Note ("checked {0} def names over {1} xml files; missing: {2}" -f $wanted.Count, $files.Count, $(if ($missing) { $missing -join ', ' } else { 'none' }))
    $missing.Count -eq 0
}

# The patch's target. A PatchOperationConditional whose xpath matches nothing applies nothing and
# reports nothing - the mod would load clean and do absolutely nothing, since the gizmo, the menu
# entry and the whole song live on that comp.
Test-That "the anima tree still exists and still carries a comps node" {
    $x = New-Object System.Xml.XmlDocument; $x.Load($plantsXml)
    $tree  = $x.SelectSingleNode('Defs/ThingDef[defName="Plant_TreeAnima"]')
    $comps = $x.SelectSingleNode('Defs/ThingDef[defName="Plant_TreeAnima"]/comps')
    Note ("def found: {0}; comps children: {1}" -f ($null -ne $tree), $(if ($comps) { $comps.ChildNodes.Count } else { 0 }))
    ($null -ne $tree) -and ($null -ne $comps)
}

# Not "the xpath looks right" but "run it and see". The shipped operation is read out of the mod's
# own patch file and applied to a copy of the real def: one node added, under comps, and the def
# still holds everything it held before.
Test-That "the shipped patch operation, run on the real def, adds exactly one comp" {
    $x = New-Object System.Xml.XmlDocument; $x.Load($plantsXml)
    $op    = $patchXml.SelectSingleNode('/Patch/Operation')
    $xpath = $op.SelectSingleNode('match/xpath').InnerText
    $value = $op.SelectSingleNode('match/value')
    $target = $x.SelectNodes($xpath)
    if ($target.Count -ne 1) { Note ("xpath matched {0} nodes" -f $target.Count); return $false }
    $before = $target[0].ChildNodes.Count
    foreach ($child in $value.ChildNodes) {
        $imported = $x.ImportNode($child, $true)
        [void]$target[0].AppendChild($imported)
    }
    $after = $target[0].ChildNodes.Count
    $added = $x.SelectNodes('Defs/ThingDef[defName="Plant_TreeAnima"]/comps/li[@Class="AnimaSong.CompProperties_AnimaSong"]')
    Note ("comps {0} -> {1}; our li found {2} time(s)" -f $before, $after, $added.Count)
    ($after -eq $before + 1) -and ($added.Count -eq 1) -and
    ($null -ne $x.SelectSingleNode('Defs/ThingDef[defName="Plant_TreeAnima"]/label'))
}

# The claim the store page and the README both make, and the reason this mod exists. It is
# recomputed rather than repeated: ten recreation types in Core, and four of them produced by a
# building a player can actually own. An eleventh type is worth more than a tenth building only
# while that stays true.
#
# Counting rule, and it is the whole difficulty. Eleven ThingDef nodes in Core name a joyKind, for
# five distinct values - but one of those, HighCulture, is named only by MusicalInstrumentBase, an
# abstract parent whose concrete instruments ship with Royalty. Count abstract defs and the answer
# is five, which is the figure a neighbouring mod's tests use for its own sentence. Count what a
# colonist can walk up to in a Core-only game and it is four. The description says four, so four is
# what is checked, and this note is here so the next reader does not "fix" it to five.
Test-That "Core still has ten recreation types, four of them from a building" {
    $kinds = 0; $fromBuilding = @{}; $abstractOnly = @{}
    foreach ($f in Get-ChildItem (Join-Path $GameData 'Core\Defs') -Recurse -Filter *.xml -File) {
        $x = New-Object System.Xml.XmlDocument
        try { $x.Load($f.FullName) } catch { continue }
        $kinds += $x.SelectNodes('/Defs/JoyKindDef').Count
        foreach ($d in $x.SelectNodes('/Defs/ThingDef[building/joyKind]')) {
            $kind = $d.SelectSingleNode('building/joyKind').InnerText
            if ($d.GetAttribute('Abstract') -eq 'True') { $abstractOnly[$kind] = $true } else { $fromBuilding[$kind] = $true }
        }
    }
    $onlyAbstract = @($abstractOnly.Keys | Where-Object { -not $fromBuilding.ContainsKey($_) })
    Note ("JoyKindDef in Core: {0}; from a concrete building: {1} ({2}); abstract only: {3}" -f `
        $kinds, $fromBuilding.Count, (($fromBuilding.Keys | Sort-Object) -join ', '), $(if ($onlyAbstract) { $onlyAbstract -join ', ' } else { 'none' }))
    ($kinds -eq 10) -and ($fromBuilding.Count -eq 4)
}

# ---------------------------------------------------------------------------------------------
# 4. The translation, where a wrong key is invisible
# ---------------------------------------------------------------------------------------------
Write-Host " The translation" -ForegroundColor Cyan

# A DefInjected path that resolves to nothing injects nothing and says nothing: the English text
# simply stays on screen. The memory's two keys address the stage by the HANDLE the game builds
# from its label, not by index and not by the label itself, so the handle is rebuilt here with the
# game's own code rather than guessed.
#
# The game's own NormalizedHandle is NOT called here, and the reason is worth writing down: its
# body calls String.Trim(char), which exists in the runtime RimWorld ships and not in the .NET
# Framework that Windows PowerShell 5.1 runs on, so invoking it throws MissingMethodException.
# What is checked instead is that the method is still there under that name - a rename means the
# rule may have moved and this key needs looking at again - and that the shipped keys hold the
# stage's own label with its spaces turned into underscores, computed from the def rather than
# typed in, so renaming the stage reddens this. The authority on handles stays the monorepo's
# Check-DefInjected.ps1, which is calibrated against the game's own translations.
Test-That "the French memory keys still match the handle built from the stage label" {
    $label = $defsXml.SelectSingleNode('/Defs/ThoughtDef/stages/li/label').InnerText
    $u = $TypeIndex['TranslationHandleUtility']
    $norm = if ($u) { $u.GetMethod('NormalizedHandle', $BF) } else { $null }
    $handle = $label -replace '\s+', '_'
    $fr = Read-Text (Join-Path $Mod 'Languages\French\DefInjected\ThoughtDef\AnimaSong.xml')
    $expectLabel = "AnimaSong_Heard.stages.$handle.label"
    $expectDesc  = "AnimaSong_Heard.stages.$handle.description"
    Note ("stage label '{0}' -> handle '{1}'; TranslationHandleUtility.NormalizedHandle present: {2}" -f `
        $label, $handle, ($null -ne $norm))
    ($null -ne $norm) -and
    ($fr -match [regex]::Escape("<$expectLabel>")) -and ($fr -match [regex]::Escape("<$expectDesc>"))
}

# English is the game's fallback, so it is the file that must be complete; a French key with no
# English twin is a string nobody outside a French game will ever see.
Test-That "the English and French keyed files hold the same keys" {
    $keys = {
        param($p)
        $x = New-Object System.Xml.XmlDocument; $x.Load($p)
        @($x.SelectNodes('/LanguageData/*') | ForEach-Object { $_.Name }) | Sort-Object
    }
    $en = & $keys (Join-Path $Mod 'Languages\English\Keyed\AnimaSong.xml')
    $fr = & $keys (Join-Path $Mod 'Languages\French\Keyed\AnimaSong.xml')
    Note ("English {0} keys, French {1}" -f $en.Count, $fr.Count)
    ($en.Count -gt 0) -and (-not (Compare-Object $en $fr))
}

# The two defs gated on Royalty have their French translation in the folder LoadFolders only adds
# when Royalty is there. Move either one back to the root and it aims at a def that does not
# exist - silently, again.
Test-That "the Royalty-gated defs keep their translation behind the same gate" {
    $gated = @($defsXml.SelectNodes('/Defs/*[@MayRequire="Ludeon.RimWorld.Royalty"]') | ForEach-Object { $_.Name })
    $royaltyDir = Join-Path $Mod 'Royalty\Languages\French\DefInjected'
    $folders = @(Get-ChildItem $royaltyDir -Directory | ForEach-Object { $_.Name })
    $loadFolders = Read-Text (Join-Path $Mod 'LoadFolders.xml')
    Note ("gated def types: {0}; translated under Royalty/: {1}" -f ($gated -join ', '), ($folders -join ', '))
    # JoyKindDef and JobDef are gated and translated; the JoyGiverDef shows no text.
    ($gated -contains 'JoyKindDef') -and ($gated -contains 'JobDef') -and
    ($folders -contains 'JoyKindDef') -and ($folders -contains 'JobDef') -and
    ($loadFolders -match 'IfModActive="Ludeon\.RimWorld\.Royalty"') -and ($loadFolders -match '<li>/</li>')
}

# ---------------------------------------------------------------------------------------------
Write-Host ""
Write-Host ("  {0} passed, {1} failed, {2} total" -f $script:pass, $script:fail, $script:n) `
    -ForegroundColor $(if ($script:fail) { 'Red' } else { 'Green' })
Write-Host ""
[System.AppDomain]::CurrentDomain.remove_AssemblyResolve($script:asmResolver)
if ($script:fail) { exit 1 }

# ---------------------------------------------------------------------------------------------
# What this file can and cannot be seen to fail
#
# Written 2026-09-12, after a neighbouring session's false alarm about the publicizer trap. Test 3
# is the one that answered it, and it can never be seen red here: with no publicizer in the csproj
# the reference package keeps the game's own accessibility, so an illegal access is a compile error
# on both sides and the probe is never built at all. It earns its place as the standing proof that
# this mod takes nothing it was not granted, and test 4 is what would speak first if a publicizer
# were ever added.
#
# Tests 8 to 13 ask questions about Assembly-CSharp itself - is this cast still there, does this
# method still read that field. No edit of this mod reaches them; reddening one means renaming what
# it asks for and watching it name what it can no longer find. That is a weaker claim than a real
# mutation and is worth saying rather than leaving a reader to assume otherwise.
#
# What is deliberately absent. The toggle's fallback icon, UI/Icons/Rituals/AnimaTreeLinking, is
# not checked: Royalty ships its textures inside an asset bundle, so there is no file on disk to
# look for and ContentFinder needs the game running. It is scenario 11 of TESTING.md and stays
# there. So does everything else that only the screen can answer - the halo surviving 3x speed, the
# seventh colonist greyed out in the menu, the memory landing after half an hour of listening.
