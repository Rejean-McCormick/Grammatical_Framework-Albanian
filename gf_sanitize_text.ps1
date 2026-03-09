<# gf_sanitize_text.ps1
   Limited-scope, SAFE text sanitation for GF .gf files.
   Dry-run by default. Use -Apply to write changes.
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
  [string]$ProjectRoot,

  [Parameter(Mandatory=$false)]
  [string]$ScanDir = "lib\src\albanian",

  [Parameter(Mandatory=$false)]
  [string]$ScanGlob = "*.gf",

  # Actually write changes
  [Parameter(Mandatory=$false)]
  [switch]$Apply,

  # Optional backups: file.gf.bak
  [Parameter(Mandatory=$false)]
  [switch]$Backup
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

function Count-Matches([string]$text, [string]$pattern) {
  if ([string]::IsNullOrEmpty($text)) { return 0 }
  return [regex]::Matches($text, $pattern).Count
}

# Replace single chars reliably (no regex surprises)
$charMap = @{
  # Double quotes
  ([char]0x201C) = '"'; # “
  ([char]0x201D) = '"'; # ”
  ([char]0x201E) = '"'; # „
  ([char]0x201F) = '"'; # ‟
  ([char]0x00AB) = '"'; # «
  ([char]0x00BB) = '"'; # »

  # Single quotes/apostrophes
  ([char]0x2018) = "'"; # ‘
  ([char]0x2019) = "'"; # ’
  ([char]0x201A) = "'"; # ‚
  ([char]0x201B) = "'"; # ‛

  # Dashes/minus
  ([char]0x2013) = "-"; # –
  ([char]0x2014) = "-"; # —
  ([char]0x2212) = "-"; # −
}

function Sanitize-Text([string]$text) {
  $t = $text

  # 1) Smart quotes + unicode dashes/minus
  foreach ($k in $charMap.Keys) {
    $t = $t.Replace([string]$k, [string]$charMap[$k])
  }

  # 2) Tabs -> two spaces (safe for GF)
  $t = $t.Replace("`t", "  ")

  # 3) Remove trailing spaces/tabs (multiline)
  $t = [regex]::Replace($t, "(?m)[ \t]+$", "")

  return $t
}

$root = (Resolve-Path $ProjectRoot).Path
$scanRoot = Join-Path $root $ScanDir
if (!(Test-Path $scanRoot)) { throw "ScanDir not found: $scanRoot" }

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$files = Get-ChildItem -Path $scanRoot -Recurse -File -Filter $ScanGlob | Sort-Object FullName
if ($files.Count -eq 0) {
  Write-Host "No files found under $scanRoot matching $ScanGlob"
  exit 0
}

Write-Host ("Mode: " + ($(if ($Apply) { "APPLY (writes files)" } else { "DRY RUN (no changes written)" })))
Write-Host ("Root: $scanRoot")
Write-Host ""

$changed = 0
foreach ($f in $files) {
  $orig = [System.IO.File]::ReadAllText($f.FullName, $utf8NoBom)

  $cntSmartQuotes =
    (Count-Matches $orig "[\u2018\u2019\u201A\u201B\u201C\u201D\u201E\u201F\u00AB\u00BB]")
  $cntUnicodeDashes =
    (Count-Matches $orig "[\u2013\u2014\u2212]")
  $cntTabs   = Count-Matches $orig "`t"
  $cntTrail  = Count-Matches $orig "(?m)[ \t]+$"

  # Only touch files that need it
  if (($cntSmartQuotes + $cntUnicodeDashes + $cntTabs + $cntTrail) -eq 0) { continue }

  $new = Sanitize-Text $orig

  if ($new -ne $orig) {
    $changed++

    if ($Apply) {
      if ($Backup) {
        Copy-Item -LiteralPath $f.FullName -Destination ($f.FullName + ".bak") -Force
      }
      [System.IO.File]::WriteAllText($f.FullName, $new, $utf8NoBom)
      Write-Host ("UPDATED: " + $f.FullName)
    } else {
      Write-Host ("WOULD UPDATE: " + $f.FullName)
    }

    Write-Host ("  smartQuotes={0} unicodeDashes={1} tabs={2} trailingWS={3}" -f $cntSmartQuotes, $cntUnicodeDashes, $cntTabs, $cntTrail)
  }
}

Write-Host ""
Write-Host ("Files changed: {0}" -f $changed)
if (-not $Apply) {
  Write-Host "Re-run with -Apply to write changes. Add -Backup to keep .bak copies."
}