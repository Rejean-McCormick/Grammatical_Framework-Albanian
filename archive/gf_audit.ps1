<# gf_audit.ps1 — v3.2 (robust, fewer false positives, ALWAYS produces ALL_SCAN_LOGS.TXT)

Fixes vs v3:
  - Eliminates "Cannot bind argument ... because it is an empty string." by allowing empty strings/empty arrays
    (blank lines at start of file, empty files, comment-stripped lines).
  - Keeps ALL_SCAN_LOGS.TXT (uppercase) updated incrementally during the run.
  - Still builds ALL_LOGS.TXT (uppercase) at the end (even on partial runs).

Key GF syntax (codex):
  \x,y -> t     = function abstraction (lambda)
  \\x,y => t    = table abstraction

Outputs per run:
  master.log
  logs\scan\<safe-file>.scan.txt
  logs\compile\<safe-file>.out.txt + .err.txt
  summary.csv / summary.json
  top_errors.txt
  ALL_SCAN_LOGS.TXT   (single combined scan log, uppercase)
  ALL_LOGS.TXT        (combined everything, uppercase)
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
  [string]$ProjectRoot,

  [Parameter(Mandatory=$true)]
  [Alias("RglDist")]
  [string]$RglRoot,

  [Parameter(Mandatory=$false)]
  [string]$GfExe = "gf",

  [Parameter(Mandatory=$false)]
  [string]$OutRoot = (Join-Path $PWD "_gf_audit"),

  [Parameter(Mandatory=$false)]
  [string]$ScanDir = "lib\src\albanian",

  [Parameter(Mandatory=$false)]
  [string]$ScanGlob = "*.gf",

  # Leave empty to auto-build from detected RGL folders
  [Parameter(Mandatory=$false)]
  [string]$GfPath = "",

  [Parameter(Mandatory=$false)]
  [switch]$EmitCpuStats,

  [Parameter(Mandatory=$false)]
  [int]$MaxFiles = 0,

  # Hard stop for each gf invocation
  [Parameter(Mandatory=$false)]
  [int]$TimeoutSec = 60,

  [Parameter(Mandatory=$false)]
  [switch]$SkipVersionProbe,

  # Useful if you just want scan output
  [Parameter(Mandatory=$false)]
  [switch]$NoCompile
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

function New-RunDir([string]$base) {
  $ts = Get-Date -Format "yyyyMMdd_HHmmss"
  $run = Join-Path $base ("run_" + $ts)
  New-Item -ItemType Directory -Force -Path $run | Out-Null
  foreach ($d in @("logs","logs\compile","logs\scan","artifacts","artifacts\gfo","artifacts\out")) {
    New-Item -ItemType Directory -Force -Path (Join-Path $run $d) | Out-Null
  }
  return $run
}

function Write-Master([string]$MasterLog, [string]$msg) {
  $line = "{0}  {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"), $msg
  $line | Out-File -FilePath $MasterLog -Append -Encoding utf8
  Write-Host $line
}

function Resolve-Gf([string]$gf) {
  try { (Get-Command $gf -ErrorAction Stop).Source }
  catch { throw "Cannot find gf executable '$gf'. Pass -GfExe with full path." }
}

function Safe-Name([string]$relPath) {
  ($relPath -replace '[\\/:*?"<>| ]', '_')
}

function First-Existing([string[]]$paths) {
  foreach ($p in $paths) { if (Test-Path $p) { return $p } }
  $null
}

function Run-ProcTimeout(
  [string]$Exe,
  [string[]]$ArgList,
  [string]$WorkDir,
  [string]$StdOutPath,
  [string]$StdErrPath,
  [int]$TimeoutSec
) {
  $p = Start-Process -FilePath $Exe `
    -ArgumentList $ArgList `
    -WorkingDirectory $WorkDir `
    -NoNewWindow `
    -PassThru `
    -RedirectStandardOutput $StdOutPath `
    -RedirectStandardError  $StdErrPath

  $timedOut = $false
  try {
    Wait-Process -Id $p.Id -Timeout $TimeoutSec -ErrorAction Stop | Out-Null
  } catch {
    $timedOut = $true
    try { Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue } catch {}
  }

  try { $p.Refresh() } catch {}
  $exitCode = if ($timedOut) { 997 } else { $p.ExitCode }
  return [pscustomobject]@{ ExitCode=$exitCode; TimedOut=$timedOut }
}

function Append-SectionUtf8([string]$Dest, [string]$Title, [string]$SrcPath) {
  $enc = [System.Text.Encoding]::UTF8
  $nl  = "`r`n"
  $hdr = $nl + ("="*78) + $nl + "BEGIN: $Title" + $nl + "PATH: $SrcPath" + $nl + ("="*78) + $nl
  [System.IO.File]::AppendAllText($Dest, $hdr, $enc)

  if (Test-Path $SrcPath) {
    $body = Get-Content -Path $SrcPath -Raw -ErrorAction SilentlyContinue
    if ($null -ne $body) { [System.IO.File]::AppendAllText($Dest, $body + $nl, $enc) }
  } else {
    [System.IO.File]::AppendAllText($Dest, "[MISSING]" + $nl, $enc)
  }

  $ftr = ("="*78) + $nl + "END: $Title" + $nl + ("="*78) + $nl
  [System.IO.File]::AppendAllText($Dest, $ftr, $enc)
}

# --- GF-aware preprocessing: strip comments; mask string contents (for syntax scans) ---
# Returns:
#   NoComments            (strings preserved)
#   NoCommentsNoStrings   (string contents blanked, quote delimiters kept)
function Process-GfLine {
  param(
    [Parameter(Mandatory=$true)]
    [AllowNull()]
    [AllowEmptyString()]
    [string]$Line,

    [Parameter(Mandatory=$true)]
    [ref]$InBlockComment
  )

  if ($null -eq $Line) { $Line = "" }

  $keep  = New-Object System.Text.StringBuilder
  $nostr = New-Object System.Text.StringBuilder

  $inStr = $false
  $i = 0
  while ($i -lt $Line.Length) {
    $ch = $Line[$i]
    $next = if ($i+1 -lt $Line.Length) { $Line[$i+1] } else { [char]0 }

    if ($InBlockComment.Value) {
      if ($ch -eq '-' -and $next -eq '}') {
        $InBlockComment.Value = $false
        $keep.Append('  ')  | Out-Null
        $nostr.Append('  ') | Out-Null
        $i += 2
        continue
      } else {
        $keep.Append(' ')  | Out-Null
        $nostr.Append(' ') | Out-Null
        $i++
        continue
      }
    }

    if ($inStr) {
      if ($ch -eq '\' -and $next -ne [char]0) {
        $keep.Append($ch).Append($next) | Out-Null
        $nostr.Append(' ').Append(' ') | Out-Null
        $i += 2
        continue
      }
      if ($ch -eq '"') {
        $inStr = $false
        $keep.Append('"')  | Out-Null
        $nostr.Append('"') | Out-Null
        $i++
        continue
      }
      $keep.Append($ch)  | Out-Null
      $nostr.Append(' ') | Out-Null
      $i++
      continue
    }

    if ($ch -eq '{' -and $next -eq '-') {
      $InBlockComment.Value = $true
      $keep.Append('  ')  | Out-Null
      $nostr.Append('  ') | Out-Null
      $i += 2
      continue
    }

    if ($ch -eq '-' -and $next -eq '-') {
      while ($i -lt $Line.Length) {
        $keep.Append(' ')  | Out-Null
        $nostr.Append(' ') | Out-Null
        $i++
      }
      break
    }

    if ($ch -eq '"') {
      $inStr = $true
      $keep.Append('"')  | Out-Null
      $nostr.Append('"') | Out-Null
      $i++
      continue
    }

    $keep.Append($ch)  | Out-Null
    $nostr.Append($ch) | Out-Null
    $i++
  }

  [pscustomobject]@{
    NoComments = $keep.ToString()
    NoCommentsNoStrings = $nostr.ToString()
  }
}

# --- compile error parsing ---
function Get-CompileSummary {
  param(
    [Parameter(Mandatory=$true)][string]$CombinedText,
    [Parameter(Mandatory=$true)][bool]$TimedOut,
    [Parameter(Mandatory=$true)][int]$ExitCode
  )

  if ($TimedOut) { return [pscustomobject]@{ Kind="TIMEOUT"; First="TIMEOUT (killed)"; Detail="" } }

  if ($CombinedText -match 'Internal error in GeneratePMCFG') {
    $m = [regex]::Match($CombinedText, '^.*Internal error in GeneratePMCFG.*$', 'Multiline')
    $first = if ($m.Success) { $m.Value.Trim() } else { "Internal error in GeneratePMCFG" }
    return [pscustomobject]@{ Kind="INTERNAL"; First=$first; Detail="GeneratePMCFG" }
  }

  if ($CombinedText -match '\bexpected:\s*' -and $CombinedText -match '\binferred:\s*') {
    $h = [regex]::Match($CombinedText, 'Happened in[^\r\n]*', 'Multiline')
    $e = [regex]::Match($CombinedText, '^\s*expected:\s*(.*)$', 'Multiline')
    $i = [regex]::Match($CombinedText, '^\s*inferred:\s*(.*)$', 'Multiline')
    $first  = if ($h.Success) { $h.Value.Trim() } else { "Type error" }
    $detail = ("expected: {0} | inferred: {1}" -f ($e.Groups[1].Value.Trim()), ($i.Groups[1].Value.Trim()))
    return [pscustomobject]@{ Kind="TYPE"; First=$first; Detail=$detail }
  }

  if ($CombinedText -match 'Syntax error|Parse error|Unexpected token') {
    $m = [regex]::Match($CombinedText, '^.*(Syntax error|Parse error|Unexpected token).*$','Multiline')
    return [pscustomobject]@{ Kind="SYNTAX"; First=$m.Value.Trim(); Detail="" }
  }

  if ($ExitCode -ne 0) {
    foreach ($ln in ($CombinedText -split "`r?`n")) {
      $t = ($ln ?? "").Trim()
      if ($t.Length -gt 0 -and $t -notmatch '^- compiling\b' -and $t -notmatch '^(linking|Writing)\b') {
        return [pscustomobject]@{ Kind="OTHER"; First=$t; Detail="" }
      }
    }
    return [pscustomobject]@{ Kind="OTHER"; First="Non-zero exit (no message matched)"; Detail="" }
  }

  [pscustomobject]@{ Kind="OK"; First=""; Detail="" }
}

# --- scan helpers ---
function Get-BraceBalancedEndLine {
  param(
    [Parameter(Mandatory=$true)][int]$StartLine,

    [Parameter(Mandatory=$true)]
    [AllowNull()]
    [AllowEmptyCollection()]
    [AllowEmptyString()]
    [string[]]$LinesNoStr
  )

  if ($null -eq $LinesNoStr) { $LinesNoStr = @() }

  $depth = 0
  $started = $false
  for ($j=$StartLine; $j -lt $LinesNoStr.Count; $j++) {
    $s = $LinesNoStr[$j]
    if ($null -eq $s) { $s = "" }
    for ($k=0; $k -lt $s.Length; $k++) {
      if ($s[$k] -eq '{') { $depth++; $started = $true }
      elseif ($s[$k] -eq '}') { $depth-- }
    }
    if ($started -and $depth -le 0) { return $j }
  }
  return $StartLine
}

function Find-RuntimeStringMatchBlocks {
  param(
    [Parameter(Mandatory=$true)]
    [AllowNull()][AllowEmptyCollection()][AllowEmptyString()]
    [string[]]$LinesNoComments,

    [Parameter(Mandatory=$true)]
    [AllowNull()][AllowEmptyCollection()][AllowEmptyString()]
    [string[]]$LinesNoStr,

    [Parameter(Mandatory=$true)]
    [AllowNull()][AllowEmptyCollection()][AllowEmptyString()]
    [string[]]$OrigLines
  )

  if ($null -eq $LinesNoComments) { $LinesNoComments = @() }
  if ($null -eq $LinesNoStr)      { $LinesNoStr = @() }
  if ($null -eq $OrigLines)       { $OrigLines = @() }

  # We want: a case-header that (eventually) contains ".s" and "of {"
  # and a block containing a literal-branch:  "..." =>
  $rxCase          = [regex]'\bcase\b'
  $rxHeadHasDotS   = [regex]'\.\s*s\b'
  $rxHeadHasOfBrace= [regex]'\bof\s*\{'
  $rxLiteralBranch = [regex]'"[^"]*"\s*=>'

  $hits = New-Object System.Collections.Generic.List[string]

  for ($i=0; $i -lt $LinesNoComments.Count; $i++) {
    $line = ($LinesNoComments[$i] ?? "")
    if (-not $rxCase.IsMatch($line)) { continue }

    # Build a compact header across a few lines until we see "of {"
    $head = $line
    $j = $i
    while ($j+1 -lt $LinesNoComments.Count -and -not $rxHeadHasOfBrace.IsMatch($head) -and $head.Length -lt 800) {
      $j++
      $head += " " + (($LinesNoComments[$j] ?? "") -replace '\s+',' ')
    }

    if (-not ($rxHeadHasOfBrace.IsMatch($head) -and $rxHeadHasDotS.IsMatch($head))) { continue }

    $end = Get-BraceBalancedEndLine -StartLine $i -LinesNoStr $LinesNoStr
    $block = ($LinesNoComments[$i..$end] -join "`n")

    if ($rxLiteralBranch.IsMatch($block)) {
      $firstLine = if ($i -lt $OrigLines.Count) { ($OrigLines[$i] ?? "").Trim() } else { "" }
      $hits.Add(("lines {0}-{1}: {2}" -f ($i+1), ($end+1), $firstLine)) | Out-Null
    }

    $i = $end
  }

  return ,$hits.ToArray()
}

function Find-UntypedBlocksWithStrPatterns {
  param(
    [Parameter(Mandatory=$true)][string]$Kind,  # case|table
    [Parameter(Mandatory=$true)][regex]$StartRx,

    [Parameter(Mandatory=$true)]
    [AllowNull()]
    [AllowEmptyCollection()]
    [AllowEmptyString()]
    [string[]]$LinesNoComments,

    [Parameter(Mandatory=$true)]
    [AllowNull()]
    [AllowEmptyCollection()]
    [AllowEmptyString()]
    [string[]]$LinesNoStr,

    [Parameter(Mandatory=$true)]
    [AllowNull()]
    [AllowEmptyCollection()]
    [AllowEmptyString()]
    [string[]]$OrigLines
  )

  if ($null -eq $LinesNoComments) { $LinesNoComments = @() }
  if ($null -eq $LinesNoStr)      { $LinesNoStr = @() }
  if ($null -eq $OrigLines)       { $OrigLines = @() }

  $rxHasStrPat = [regex]'(_\s*\+\s*".+?"|".+?"\s*\+\s*_)'
  $rxTypedStr  = [regex]':\s*Str\s*>'

  $hits = New-Object System.Collections.Generic.List[string]
  for ($i=0; $i -lt $LinesNoComments.Count; $i++) {
    if (-not $StartRx.IsMatch(($LinesNoComments[$i] ?? ""))) { continue }

    $end = Get-BraceBalancedEndLine -StartLine $i -LinesNoStr $LinesNoStr
    $block = ($LinesNoComments[$i..$end] -join "`n")

    if ($rxHasStrPat.IsMatch($block) -and -not $rxTypedStr.IsMatch($block)) {
      $firstLine = if ($i -lt $OrigLines.Count) { ($OrigLines[$i] ?? "").Trim() } else { "" }
      $hits.Add(("lines {0}-{1}: {2}" -f ($i+1), ($end+1), $firstLine)) | Out-Null
    }

    $i = $end
  }

  return ,$hits.ToArray()
}

# ---------------- MAIN ----------------
$ProjectRoot = (Resolve-Path $ProjectRoot).Path
$RglRoot     = (Resolve-Path $RglRoot).Path
$GfExePath   = Resolve-Gf $GfExe

$runDir     = New-RunDir $OutRoot
$masterLog  = Join-Path $runDir "master.log"
$csvPath    = Join-Path $runDir "summary.csv"
$jsonPath   = Join-Path $runDir "summary.json"
$topErrPath = Join-Path $runDir "top_errors.txt"

# Uppercase aggregate logs (requested)
$allScanPath = Join-Path $runDir "ALL_SCAN_LOGS.TXT"
$allLogsPath = Join-Path $runDir "ALL_LOGS.TXT"

# Create ALL_SCAN_LOGS immediately so it exists even on partial runs
"" | Set-Content -Path $allScanPath -Encoding utf8

$results = New-Object System.Collections.Generic.List[object]
$errorBuckets = @{}

function Add-ErrorBucket([string]$msg) {
  $k = ($msg ?? "").Trim()
  if ([string]::IsNullOrWhiteSpace($k)) { return }
  if ($errorBuckets.ContainsKey($k)) { $errorBuckets[$k]++ } else { $errorBuckets[$k] = 1 }
}

$hadFatal = $false
$fatalText = ""

try {
  Write-Master $masterLog "RunDir: $runDir"
  Write-Master $masterLog "ProjectRoot: $ProjectRoot"
  Write-Master $masterLog "RglRoot: $RglRoot"
  Write-Master $masterLog "GfExe: $GfExePath"
  Write-Master $masterLog "TimeoutSec: $TimeoutSec"
  Write-Master $masterLog ("NoCompile: {0}" -f [bool]$NoCompile)
  Write-Master $masterLog "ALL_SCAN_LOGS.TXT: $allScanPath"

  $env:GF_LIB_PATH = $RglRoot
  Write-Master $masterLog "GF_LIB_PATH set to: $env:GF_LIB_PATH"

  $candidates = @("prelude","abstract","common","present","alltenses","compat","api")
  $found = @()
  foreach ($d in $candidates) {
    if (Test-Path (Join-Path $RglRoot $d)) { $found += $d }
  }
  Write-Master $masterLog ("RGL folders found under RglRoot: " + ($found -join ", "))

  $catAny = First-Existing @(
    (Join-Path $RglRoot "abstract\Cat.gf"),
    (Join-Path $RglRoot "abstract\Cat.gfo"),
    (Join-Path $RglRoot "present\Cat.gfo"),
    (Join-Path $RglRoot "alltenses\Cat.gfo")
  )
  Write-Master $masterLog ("Sanity: found Cat module at: {0}" -f ($catAny ?? "<NOT FOUND>"))

  if ([string]::IsNullOrWhiteSpace($GfPath)) {
    $parts = @("lib/src","lib/src/albanian")
    foreach ($d in @("present","alltenses","common","abstract","prelude","compat","api")) {
      if ($found -contains $d) { $parts += $d }
    }
    $GfPath = ($parts -join ":")
  }
  Write-Master $masterLog "GfPath: $GfPath"

  if (-not $SkipVersionProbe) {
    Write-Master $masterLog "Probing: gf --version (timeout 10s)"
    $verOut = Join-Path $runDir "logs\gf_version.out.txt"
    $verErr = Join-Path $runDir "logs\gf_version.err.txt"
    $vp = Run-ProcTimeout -Exe $GfExePath -ArgList @("--version") -WorkDir $ProjectRoot -StdOutPath $verOut -StdErrPath $verErr -TimeoutSec 10
    Write-Master $masterLog ("gf --version exit={0} timedOut={1}" -f $vp.ExitCode, $vp.TimedOut)
  } else {
    Write-Master $masterLog "Skipping gf --version probe."
  }

  Write-Master $masterLog "Enumerating files..."
  $scanRoot = Join-Path $ProjectRoot $ScanDir
  if (!(Test-Path $scanRoot)) { throw "ScanDir not found: $scanRoot" }

  $allFiles = Get-ChildItem -Path $scanRoot -Recurse -File -Filter $ScanGlob | Sort-Object FullName
  if ($MaxFiles -gt 0) { $allFiles = $allFiles | Select-Object -First $MaxFiles }
  Write-Master $masterLog ("Found {0} GF files under {1}" -f $allFiles.Count, $scanRoot)

  # Line patterns (comments removed, strings masked):
  $rxSingleSlashThenEq    = [regex]'(?<!\\)\\(?!\\)(?:(?!->)[^;])*=>'
  $rxDoubleSlashThenDash  = [regex]'\\\\(?:(?!=>)[^;])*->'
  $rxCaseStart  = [regex]'\bcase\b.*\bof\s*\{'
  $rxTableStart = [regex]'\btable\s*\{'

  foreach ($f in $allFiles) {
    $rel  = $f.FullName.Substring($ProjectRoot.Length).TrimStart('\','/')
    $safe = Safe-Name $rel
    Write-Master $masterLog "---- FILE: $rel ----"

    try {
      # Force array (prevents rare scalar behavior)
      $origLines = @(Get-Content -LiteralPath $f.FullName -ErrorAction Stop)

      $inBlock = $false
      $noCom = New-Object System.Collections.Generic.List[string]
      $noComNoStr = New-Object System.Collections.Generic.List[string]

      $trailSpaces = 0
      for ($i=0; $i -lt $origLines.Count; $i++) {
        if (($origLines[$i] ?? "") -match '[ \t]+$') { $trailSpaces++ }
        $p = Process-GfLine -Line ($origLines[$i] ?? "") -InBlockComment ([ref]$inBlock)
        $noCom.Add($p.NoComments) | Out-Null
        $noComNoStr.Add($p.NoCommentsNoStrings) | Out-Null
      }

      $noComArr = $noCom.ToArray()
      $noComNoStrArr = $noComNoStr.ToArray()

      # ---- line-based hits
      $badSingle = New-Object System.Collections.Generic.List[string]
      $badDouble = New-Object System.Collections.Generic.List[string]
      for ($i=0; $i -lt $noComNoStrArr.Length; $i++) {
        $ln = ($noComNoStrArr[$i] ?? "")
        if ($rxSingleSlashThenEq.IsMatch($ln)) {
          $badSingle.Add(("line {0}: {1}" -f ($i+1), ($origLines[$i] ?? "").Trim())) | Out-Null
        }
        if ($rxDoubleSlashThenDash.IsMatch($ln)) {
          $badDouble.Add(("line {0}: {1}" -f ($i+1), ($origLines[$i] ?? "").Trim())) | Out-Null
        }
      }

      # ---- block hits
      $badRuntime = Find-RuntimeStringMatchBlocks -LinesNoComments $noComArr -LinesNoStr $noComNoStrArr -OrigLines $origLines
      $badUntypedCase  = Find-UntypedBlocksWithStrPatterns -Kind "case"  -StartRx $rxCaseStart  -LinesNoComments $noComArr -LinesNoStr $noComNoStrArr -OrigLines $origLines
      $badUntypedTable = Find-UntypedBlocksWithStrPatterns -Kind "table" -StartRx $rxTableStart -LinesNoComments $noComArr -LinesNoStr $noComNoStrArr -OrigLines $origLines

      # ---- write scan log
      $scanLogPath = Join-Path $runDir ("logs\scan\" + $safe + ".scan.txt")
      @(
        "FILE: $($f.FullName)"
        "REL:  $rel"
        ""
        "SCAN SUMMARY:"
        ("SingleSlashThenEq hits: {0}" -f $badSingle.Count)
        ("DoubleSlashThenDash hits: {0}" -f $badDouble.Count)
        ("RuntimeStringMatch hits: {0}" -f $badRuntime.Length)
        ("UntypedCaseWithStrPatterns hits: {0}" -f $badUntypedCase.Length)
        ("UntypedTableWithStrPatterns hits: {0}" -f $badUntypedTable.Length)
        ("TrailingSpaces hits: {0}" -f $trailSpaces)
        ""
        "DETAILS:"
        ""
        "SingleSlashThenEq (only if no '->' before '=>'):"
        ($badSingle.Count -gt 0 ? ($badSingle -join "`n") : "None.")
        ""
        "DoubleSlashThenDash (only if no '=>' before '->'):"
        ($badDouble.Count -gt 0 ? ($badDouble -join "`n") : "None.")
        ""
        'RuntimeStringMatch (case <expr>.s of { "..." => ... }):'
        ($badRuntime.Length -gt 0 ? ($badRuntime -join "`n") : "None.")
        ""
        "UntypedCaseWithStrPatterns (string-pattern rules but missing ': Str>'):"
        ($badUntypedCase.Length -gt 0 ? ($badUntypedCase -join "`n") : "None.")
        ""
        "UntypedTableWithStrPatterns (string-pattern rules but missing ': Str>'):"
        ($badUntypedTable.Length -gt 0 ? ($badUntypedTable -join "`n") : "None.")
      ) | Out-File -FilePath $scanLogPath -Encoding utf8

      # Append immediately to ALL_SCAN_LOGS.TXT (uppercase main scan file)
      Append-SectionUtf8 -Dest $allScanPath -Title ("scan: " + $rel) -SrcPath $scanLogPath

      # ---- compile
      $compileOut = Join-Path $runDir ("logs\compile\" + $safe + ".out.txt")
      $compileErr = Join-Path $runDir ("logs\compile\" + $safe + ".err.txt")

      $exitCode = 0
      $timedOut = $false
      $durMs = 0
      $errKind = "OK"
      $firstErr = ""
      $errDetail = ""

      if (-not $NoCompile) {
        $gfoDir = Join-Path $runDir "artifacts\gfo"
        $outDir = Join-Path $runDir "artifacts\out"

        $args = @("--batch","--make", "--gf-lib-path=$RglRoot", "--path=$GfPath", "--gfo-dir=$gfoDir", "--output-dir=$outDir")
        if ($EmitCpuStats) { $args += "--cpu" }
        $args += $f.FullName

        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $pr = Run-ProcTimeout -Exe $GfExePath -ArgList $args -WorkDir $ProjectRoot -StdOutPath $compileOut -StdErrPath $compileErr -TimeoutSec $TimeoutSec
        $sw.Stop()

        $durMs = [int]$sw.ElapsedMilliseconds
        $exitCode = $pr.ExitCode
        $timedOut = [bool]$pr.TimedOut

        $outTxt = if (Test-Path $compileOut) { Get-Content $compileOut -Raw } else { "" }
        $errTxt = if (Test-Path $compileErr) { Get-Content $compileErr -Raw } else { "" }
        $combined = $outTxt + "`n" + $errTxt

        $sum = Get-CompileSummary -CombinedText $combined -TimedOut $timedOut -ExitCode $exitCode
        $errKind = $sum.Kind
        $firstErr = $sum.First
        $errDetail = $sum.Detail

        if ($exitCode -ne 0 -and $firstErr) { Add-ErrorBucket ("[{0}] {1}" -f $errKind, $firstErr) }
        Write-Master $masterLog ("Compile exit={0} timedOut={1} time={2}ms kind={3} first={4}" -f $exitCode, $timedOut, $durMs, $errKind, ($firstErr ?? ""))
      } else {
        "" | Out-File -FilePath $compileOut -Encoding utf8
        "" | Out-File -FilePath $compileErr -Encoding utf8
        Write-Master $masterLog "Compile skipped (-NoCompile)."
      }

      $results.Add([pscustomobject]@{
        File=$rel;
        ExitCode=$exitCode;
        DurationMs=$durMs;
        Hit_SingleSlashEq=$badSingle.Count;
        Hit_DoubleSlashDash=$badDouble.Count;
        Hit_RuntimeStrMatch=$badRuntime.Length;
        Hit_UntypedCaseStrPat=$badUntypedCase.Length;
        Hit_UntypedTableStrPat=$badUntypedTable.Length;
        Hit_TrailingSpaces=$trailSpaces;
        ScanLog=$scanLogPath;
        CompileOut=$compileOut;
        CompileErr=$compileErr;
        ErrorKind=$errKind;
        FirstError=$firstErr;
        ErrorDetail=$errDetail
      }) | Out-Null
    }
    catch {
      $msg = "FILE ERROR: $rel :: " + $_.Exception.Message
      Write-Master $masterLog $msg
      Add-ErrorBucket ("[SCRIPT] " + $msg)

      # best-effort scan log (still appended to ALL_SCAN_LOGS.TXT)
      $scanLogPath = Join-Path $runDir ("logs\scan\" + $safe + ".scan.txt")
      @(
        "FILE: $($f.FullName)"
        "REL:  $rel"
        ""
        "SCRIPT ERROR while scanning/compiling this file:"
        ($_.Exception.ToString())
        ""
        "STACK:"
        ($_.ScriptStackTrace ?? "")
      ) | Out-File -FilePath $scanLogPath -Encoding utf8

      Append-SectionUtf8 -Dest $allScanPath -Title ("scan: " + $rel + " (SCRIPT ERROR)") -SrcPath $scanLogPath

      $results.Add([pscustomobject]@{
        File=$rel;
        ExitCode=998;
        DurationMs=0;
        Hit_SingleSlashEq=0;
        Hit_DoubleSlashDash=0;
        Hit_RuntimeStrMatch=0;
        Hit_UntypedCaseStrPat=0;
        Hit_UntypedTableStrPat=0;
        Hit_TrailingSpaces=0;
        ScanLog=$scanLogPath;
        CompileOut="";
        CompileErr="";
        ErrorKind="SCRIPT";
        FirstError=$msg;
        ErrorDetail=""
      }) | Out-Null

      continue
    }
  }

  # Summaries
  $results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding utf8
  $results | ConvertTo-Json -Depth 6 | Out-File -FilePath $jsonPath -Encoding utf8
  Write-Master $masterLog "Wrote summary CSV:  $csvPath"
  Write-Master $masterLog "Wrote summary JSON: $jsonPath"

  $top = $errorBuckets.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 120
  @(
    "TOP ERRORS (bucketed by [Kind] FirstError)"
    "========================================="
    ""
    ($top | ForEach-Object { "{0,4}  {1}" -f $_.Value, $_.Key })
  ) | Out-File -FilePath $topErrPath -Encoding utf8
  Write-Master $masterLog "Wrote top errors: $topErrPath"
}
catch {
  $hadFatal = $true
  $fatalText = $_.Exception.ToString()
  try { Write-Master $masterLog ("FATAL: " + $fatalText) } catch {}
}
finally {
  # Build ALL_LOGS.TXT even if something went wrong
  "" | Set-Content -Path $allLogsPath -Encoding utf8
  Append-SectionUtf8 -Dest $allLogsPath -Title "master.log"        -SrcPath $masterLog
  Append-SectionUtf8 -Dest $allLogsPath -Title "ALL_SCAN_LOGS.TXT" -SrcPath $allScanPath

  if (Test-Path $topErrPath) { Append-SectionUtf8 -Dest $allLogsPath -Title "top_errors.txt" -SrcPath $topErrPath }
  if (Test-Path $csvPath)    { Append-SectionUtf8 -Dest $allLogsPath -Title "summary.csv"    -SrcPath $csvPath }
  if (Test-Path $jsonPath)   { Append-SectionUtf8 -Dest $allLogsPath -Title "summary.json"   -SrcPath $jsonPath }

  $verOut = Join-Path $runDir "logs\gf_version.out.txt"
  $verErr = Join-Path $runDir "logs\gf_version.err.txt"
  if (Test-Path $verOut) { Append-SectionUtf8 -Dest $allLogsPath -Title "gf_version.out.txt" -SrcPath $verOut }
  if (Test-Path $verErr) { Append-SectionUtf8 -Dest $allLogsPath -Title "gf_version.err.txt" -SrcPath $verErr }

  $compDirPath = Join-Path $runDir "logs\compile"
  if (Test-Path $compDirPath) {
    Get-ChildItem -Path $compDirPath -File | Sort-Object FullName | ForEach-Object {
      Append-SectionUtf8 -Dest $allLogsPath -Title ("compile: " + $_.Name) -SrcPath $_.FullName
    }
  }

  try { Write-Master $masterLog "Wrote ALL_SCAN_LOGS.TXT: $allScanPath" } catch {}
  try { Write-Master $masterLog "Wrote ALL_LOGS.TXT:     $allLogsPath" } catch {}
}

if ($hadFatal) { throw $fatalText }