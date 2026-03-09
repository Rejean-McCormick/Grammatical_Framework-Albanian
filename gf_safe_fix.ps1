<# gf_safe_fix.ps1 — batch-safe fixer for GF AlbanianSQI tree (with dry-run)

Safe batch fixes (opt-in):
  F0) Fix CatSqi MU Bool mismatch:
      - MU.isPre : Prelude.Bool  -> Bool
      - Prelude.False/True -> False/True (only in lindef MU)
  F1) Create missing abstract wrappers inferred from <Base><Lang>Abs pattern:
      Example: ExtraSqiAbs -> base Extra
      Stub: abstract ExtraSqiAbs = Extra ** {}
  F2) Normalize smart quotes to ASCII (optional)
  F3) Convert tabs to spaces (optional)

Dry run:
  -DryRun (recommended) OR -WhatIf
Output:
  Always creates ProjectRoot\_gf_fix_run\run_YYYYMMDD_HHMMSS\fix_report.txt
#>

[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="Medium")]
param(
  [Parameter(Mandatory=$true)]
  [string]$ProjectRoot,

  [Parameter(Mandatory=$false)]
  [Alias("GrammarDir","AlbDir")]
  [string]$ScanDir = "lib\src\albanian",

  [Parameter(Mandatory=$false)]
  [string]$ScanGlob = "*.gf",

  [Parameter(Mandatory=$false)]
  [string]$RglRoot = "",

  # Safe fix toggles
  [Parameter(Mandatory=$false)]
  [switch]$FixCatSqiMU,

  [Parameter(Mandatory=$false)]
  [switch]$CreateMissingAbstracts,

  [Parameter(Mandatory=$false)]
  [switch]$NormalizeQuotes,

  [Parameter(Mandatory=$false)]
  [switch]$TabsToSpaces,

  [Parameter(Mandatory=$false)]
  [int]$TabWidth = 2,

  # Dry run that still writes report/run folder
  [Parameter(Mandatory=$false)]
  [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

function Ensure-Dir([string]$p) { [System.IO.Directory]::CreateDirectory($p) | Out-Null }

function Append-Report([string]$path, [string]$msg) {
  $line = "{0}  {1}`r`n" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"), $msg
  [System.IO.File]::AppendAllText($path, $line, [System.Text.Encoding]::UTF8)
  Write-Host $line.TrimEnd()
}

function Backup-File([string]$Path) {
  $ts = Get-Date -Format "yyyyMMdd_HHmmss"
  $bak = "$Path.bak_$ts"
  Copy-Item -LiteralPath $Path -Destination $bak -Force
  return $bak
}

function Write-FileUtf8CRLF([string]$Path, [string]$Content) {
  $normalized = ($Content -replace "`r?`n", "`r`n")
  Set-Content -LiteralPath $Path -Value $normalized -Encoding utf8
}

function Normalize-SmartQuotes([string]$s) {
  return $s.
    Replace([char]0x201C, '"').  # “
    Replace([char]0x201D, '"').  # ”
    Replace([char]0x2018, "'").  # ‘
    Replace([char]0x2019, "'")   # ’
}

function Tabs-To-Spaces([string]$s, [int]$w) {
  $spaces = " " * [Math]::Max(1,$w)
  return $s.Replace("`t", $spaces)
}

function Parse-ConcreteHeader([string]$text) {
  $rx = [regex]'(?m)^\s*concrete\s+([A-Za-z0-9_]+)\s+of\s+([A-Za-z0-9_]+)\b'
  $ms = $rx.Matches($text)
  $out = New-Object System.Collections.Generic.List[object]
  foreach ($m in $ms) {
    $out.Add([pscustomobject]@{ Concrete=$m.Groups[1].Value; Abstract=$m.Groups[2].Value }) | Out-Null
  }
  return $out
}

function Try-InferBaseFromAbs([string]$absName) {
  # <Base><LangCode>Abs where LangCode is 3 letters like Sqi, Eng, Swe...
  if ($absName -match '^(.+?)([A-Z][a-z]{2})Abs$') { return $Matches[1] }
  return $null
}

function Base-Module-Exists([string]$base, [string]$scanRoot, [string]$rglRoot) {
  if (Test-Path (Join-Path $scanRoot ($base + ".gf"))) { return $true }
  if ([string]::IsNullOrWhiteSpace($rglRoot)) { return $true }
  $dirs = @("abstract","common","prelude","api","present","alltenses","compat")
  foreach ($d in $dirs) {
    $p = Join-Path $rglRoot (Join-Path $d ($base + ".gf"))
    if (Test-Path $p) { return $true }
  }
  return $false
}

function Fix-CatSqi-MU([string]$catPath, [string]$reportPath) {
  if (!(Test-Path $catPath)) {
    Append-Report $reportPath "SKIP: CatSqi not found at $catPath"
    return
  }

  $orig = Get-Content -LiteralPath $catPath -Raw
  $lines = $orig -split "`r?`n"
  $changed = $false

  for ($i=0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]

    if ($line -match '^\s*lincat\s+MU\b') {
      $new = [regex]::Replace($line, '(\bisPre\s*:\s*)Prelude\.Bool\b', '${1}Bool')
      if ($new -ne $line) { $lines[$i] = $new; $changed = $true }
    }

    if ($line -match '^\s*lindef\s+MU\b') {
      $new = $line.Replace("Prelude.False","False").Replace("Prelude.True","True")
      if ($new -ne $line) { $lines[$i] = $new; $changed = $true }
    }
  }

  if (-not $changed) {
    Append-Report $reportPath "CatSqi.gf: MU already consistent (no changes)."
    return
  }

  $patched = ($lines -join "`r`n")
  $action = "Patch CatSqi MU: Prelude.Bool->Bool and Prelude.True/False->True/False"

  if ($DryRun -or $WhatIfPreference) {
    Append-Report $reportPath "WOULD UPDATE: $catPath ($action)"
    return
  }

  if ($PSCmdlet.ShouldProcess($catPath, $action)) {
    $bak = Backup-File $catPath
    Write-FileUtf8CRLF $catPath $patched
    Append-Report $reportPath "UPDATED: $catPath (backup: $bak)"
  } else {
    Append-Report $reportPath "WOULD UPDATE: $catPath ($action)"
  }
}

# ---------------- MAIN ----------------

$ProjectRoot = (Resolve-Path $ProjectRoot).Path
$scanRoot = Join-Path $ProjectRoot $ScanDir
if (!(Test-Path $scanRoot)) { throw "ScanDir not found: $scanRoot" }

if (-not [string]::IsNullOrWhiteSpace($RglRoot)) { $RglRoot = (Resolve-Path $RglRoot).Path }

# Always create run folder + report
$runBase = Join-Path $ProjectRoot "_gf_fix_run"
$ts = Get-Date -Format "yyyyMMdd_HHmmss"
$runDir = Join-Path $runBase ("run_" + $ts)
Ensure-Dir $runDir
$report = Join-Path $runDir "fix_report.txt"

Append-Report $report "RunDir: $runDir"
Append-Report $report "ProjectRoot: $ProjectRoot"
Append-Report $report "ScanRoot: $scanRoot"
Append-Report $report "RglRoot: $RglRoot"
Append-Report $report "Options: FixCatSqiMU=$FixCatSqiMU CreateMissingAbstracts=$CreateMissingAbstracts NormalizeQuotes=$NormalizeQuotes TabsToSpaces=$TabsToSpaces TabWidth=$TabWidth DryRun=$DryRun WhatIf=$WhatIfPreference"

$files = Get-ChildItem -Path $scanRoot -Recurse -File -Filter $ScanGlob | Sort-Object FullName
Append-Report $report ("Found {0} files" -f $files.Count)

# F0: Fix CatSqi MU mismatch (the big blocker)
if ($FixCatSqiMU) {
  $catPath = Join-Path $scanRoot "CatSqi.gf"
  Append-Report $report "Phase F0: patching CatSqi MU (if needed)..."
  Fix-CatSqi-MU $catPath $report
}

# F1: Create missing abstract wrappers inferred from name pattern
if ($CreateMissingAbstracts) {
  Append-Report $report "Phase F1: scanning concretes for missing abstracts..."

  $neededAbs = New-Object 'System.Collections.Generic.HashSet[string]'
  foreach ($f in $files) {
    $txt = Get-Content -LiteralPath $f.FullName -Raw
    foreach ($h in (Parse-ConcreteHeader $txt)) { [void]$neededAbs.Add($h.Abstract) }
  }

  foreach ($absName in ($neededAbs | Sort-Object)) {
    $absPath = Join-Path $scanRoot ($absName + ".gf")
    if (Test-Path $absPath) { continue }

    $base = Try-InferBaseFromAbs $absName
    if ([string]::IsNullOrWhiteSpace($base)) {
      Append-Report $report "SKIP: cannot infer base for missing abstract $absName (not <Base><Lang>Abs)."
      continue
    }

    if (-not (Base-Module-Exists $base $scanRoot $RglRoot)) {
      Append-Report $report "SKIP: inferred base '$base' for $absName not found (refusing to create)."
      continue
    }

    $stub = @"
-- Auto-generated by gf_safe_fix.ps1 on $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
-- Minimal abstract wrapper inferred from name pattern <Base><Lang>Abs.
abstract $absName =
  $base
  ** {}
"@

    $action = "Create missing abstract wrapper $absName.gf (abstract $absName = $base ** {})"

    if ($DryRun -or $WhatIfPreference) {
      Append-Report $report "WOULD CREATE: $absPath  ($action)"
      continue
    }

    if ($PSCmdlet.ShouldProcess($absPath, $action)) {
      Write-FileUtf8CRLF $absPath $stub
      Append-Report $report "CREATED: $absPath"
    } else {
      Append-Report $report "WOULD CREATE: $absPath"
    }
  }
}

# F2/F3: Normalizations across files
Append-Report $report "Phase F2/F3: normalizing files where requested..."

foreach ($f in $files) {
  $orig = Get-Content -LiteralPath $f.FullName -Raw
  $txt = $orig

  if ($NormalizeQuotes) { $txt = Normalize-SmartQuotes $txt }
  if ($TabsToSpaces)    { $txt = Tabs-To-Spaces $txt $TabWidth }

  if ($txt -ne $orig) {
    $action = "Rewrite with normalizations (NormalizeQuotes=$NormalizeQuotes TabsToSpaces=$TabsToSpaces)"
    if ($DryRun -or $WhatIfPreference) {
      Append-Report $report "WOULD UPDATE: $($f.FullName)  ($action)"
      continue
    }

    if ($PSCmdlet.ShouldProcess($f.FullName, $action)) {
      $bak = Backup-File $f.FullName
      Write-FileUtf8CRLF $f.FullName $txt
      Append-Report $report "UPDATED: $($f.FullName) (backup: $bak)"
    } else {
      Append-Report $report "WOULD UPDATE: $($f.FullName)"
    }
  }
}

Append-Report $report "DONE. Report: $report"
Write-Host ""
Write-Host "Fix report: $report"
Write-Host "Run folder:  $runDir"