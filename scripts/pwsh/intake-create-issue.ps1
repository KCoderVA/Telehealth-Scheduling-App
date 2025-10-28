<#
Purpose: Create a GitHub issue for a verbal/email intake with robust quoting & UTF-8 handling.
Usage (parameters correspond to VS Code task inputs; any may be blank):
    pwsh -File scripts/pwsh/intake-create-issue.ps1 -Token $env:GITHUB_TOKEN -Employee "Doe, Jane" -Email "jane.doe@va.gov" -Dept "Telehealth" -Phone "(555) 123-4567" -Severity moderate -Title "Fix booking overlap" -Description "Quoted user text" -Steps "Open app -> ..." -Extra "Reported by phone" -Screenshot "C:\path\img.png" -DebugPayload -DumpAll -SaveRawPayload

Key Switches Added (diagnostics / large payload handling):
    -DebugPayload           Show payload in console (pretty by default unless -PrettyPrintPayload omitted).
    -MaxConsolePayloadLines Limit lines printed (default 300) to avoid flooding terminal.
    -NoConsolePayload       Suppress console print entirely (files still written).
    -PrettyPrintPayload     Force pretty printed JSON in console (default if ConvertTo-Json already pretty).
    -SaveRawPayload         Also save a minified (compressed) JSON payload file alongside pretty one.
    -DumpAll                Produce consolidated debug dump (parameters + markdown + payload paths + payload).
    -CaptureLog             Start transcript capturing all console output to a run log file.

Behavior:
    - Archives markdown body + optional screenshot to ./archive/issue-intake/
    - Always saves pretty payload JSON; saves raw minified payload with -SaveRawPayload
    - Consolidated debug dump references payload files and switches used when -DumpAll
    - If no token: opens pre-filled browser issue creation page and exits 0.
    - If token: creates issue via REST API with labels: intake, bug, verbal.
#>
[CmdletBinding()]
param(
    [string]$Token,
    [Parameter(Mandatory=$true)][string]$Employee,
    [string]$Email,
    [string]$Dept,
    [string]$Phone,
    [ValidateSet('low','moderate','high','critical')][string]$Severity='moderate',
    [Parameter(Mandatory=$true)][string]$Title,
    [Parameter(Mandatory=$true)][string]$Description,
    [string]$Steps='(not provided)',
    [string]$Extra,
    [string]$Screenshot,
    [switch]$DebugPayload,
    [switch]$CaptureLog,
    [switch]$DumpAll,
    [int]$MaxConsolePayloadLines = 300,
    [switch]$NoConsolePayload,
    [switch]$SaveRawPayload,
    [switch]$PrettyPrintPayload
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

if (-not $Token -or [string]::IsNullOrWhiteSpace($Token)) {
    $Token = $env:GITHUB_TOKEN
}

$timestamp = Get-Date -Format 'yyyy-MM-dd-HHmmss'
$archiveDir = Join-Path -Path '.' -ChildPath 'archive/issue-intake'
if (-not (Test-Path $archiveDir)) { New-Item -ItemType Directory -Path $archiveDir | Out-Null }

# Optional transcript logging
$transcriptFile = $null
if ($CaptureLog) {
    $transcriptFile = Join-Path $archiveDir ('issue-intake-runlog-' + $timestamp + '.log')
    try { Start-Transcript -Path $transcriptFile -Force | Out-Null } catch { Write-Host ('WARN: Could not start transcript: ' + $_.Exception.Message) -ForegroundColor Yellow }
}

# Normalize smart quotes and curly punctuation to ASCII to avoid downstream escaping issues
function Normalize-Text($text){
    if ($null -eq $text) { return '' }
    $map = @{
        '“'='"'; '”'='"'; '‘'="'"; '’'="'"; '—'='-'; '–'='-'
    }
    $out = $text
    foreach($k in $map.Keys){ $out = $out -replace [regex]::Escape($k), $map[$k] }
    return $out
}

$Title        = Normalize-Text $Title
$Description  = Normalize-Text $Description
$Steps        = Normalize-Text $Steps
$Extra        = Normalize-Text $Extra
$Employee     = Normalize-Text $Employee
$Dept         = Normalize-Text $Dept
$Phone        = Normalize-Text $Phone

$screenshotNote = ''
if ($Screenshot) {
    if (Test-Path $Screenshot) {
        $dest = Join-Path $archiveDir ( 'screenshot_' + $timestamp + [IO.Path]::GetExtension($Screenshot) )
        Copy-Item $Screenshot $dest -Force
        $screenshotNote = 'Screenshot archived: ' + $dest
    } else {
        $screenshotNote = 'Screenshot path provided but not found: ' + $Screenshot
    }
}

$mdFile = Join-Path $archiveDir ('issue-intake-' + $timestamp + '.md')

$lines = @()
$lines += '# Intake: ' + $Title
$lines += "**Severity:** $Severity"
$lines += "**Employee:** $Employee"
if ($Email) { $lines += "**Email:** $Email" }
if ($Dept) { $lines += "**Department:** $Dept" }
if ($Phone) { $lines += "**Phone:** $Phone" }
$lines += "**Timestamp:** $timestamp"
if ($screenshotNote) { $lines += "**Screenshot:** $screenshotNote" }
if ($Extra) { $lines += "**Additional Notes:** $Extra" }
$lines += ''
$lines += '---'
$lines += '### Description (Quoted Complaint)'
$lines += $Description
$lines += ''
$lines += '### Reproduction Steps'
$lines += $Steps
$lines += ''
$lines += '### Internal Handling'
$lines += '_Status: Intake created locally and submitted._'

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllLines($mdFile, $lines, $utf8NoBom)
Write-Host ('Prepared issue body: ' + $mdFile) -ForegroundColor Cyan

if (-not $Token -or [string]::IsNullOrWhiteSpace($Token)) {
    Add-Type -AssemblyName System.Web
    $rawBody   = Get-Content $mdFile -Raw
    $encodedTitle = [System.Uri]::EscapeDataString('intake: ' + $Title)
    $encodedBody  = [System.Uri]::EscapeDataString($rawBody)
    $url = 'https://github.com/KCoderVA/Telehealth-Scheduling-App/issues/new?title=' + $encodedTitle + '&body=' + $encodedBody
    Write-Host 'No token detected; opening browser for manual issue creation (add labels intake, bug, verbal).' -ForegroundColor Yellow
    start $url
    exit 0
}

$headers = @{
    Authorization = 'Bearer ' + $Token
    'User-Agent'  = 'TelehealthIssueAutomation'
    Accept        = 'application/vnd.github+json'
    'Content-Type' = 'application/json'
}
$payload = [ordered]@{
    title = 'intake: ' + $Title
    body  = (Get-Content $mdFile -Raw)
    labels = @('intake','bug','verbal')
    assignees = @('KCoderVA')
}
$json = $payload | ConvertTo-Json -Depth 6

# Optionally pretty-print (current ConvertTo-Json already pretty; provide minified raw)
$rawJson = ($payload | ConvertTo-Json -Depth 6 -Compress)

if ($DebugPayload -and -not $NoConsolePayload) {
    Write-Host '--- DEBUG PAYLOAD BEGIN ---' -ForegroundColor Yellow
    $jsonForConsole = if ($PrettyPrintPayload) { $json } else { $rawJson }
    $jsonLines = $jsonForConsole -split "`r?`n"
    if ($jsonLines.Count -le $MaxConsolePayloadLines) {
        $jsonForConsole | Write-Host
    } else {
        ($jsonLines | Select-Object -First $MaxConsolePayloadLines) -join [Environment]::NewLine | Write-Host
        Write-Host ("--- TRUNCATED: showing {0}/{1} lines (adjust -MaxConsolePayloadLines or use -DumpAll/-SaveRawPayload). ---" -f $MaxConsolePayloadLines,$jsonLines.Count) -ForegroundColor Yellow
    }
    Write-Host '--- DEBUG PAYLOAD END ---' -ForegroundColor Yellow
} elseif ($DebugPayload -and $NoConsolePayload) {
    Write-Host 'DEBUG: Console payload output suppressed by -NoConsolePayload (payload still saved to files).' -ForegroundColor Yellow
}

# Persist payload JSON for troubleshooting (pretty + raw if requested)
$payloadFilePretty = Join-Path $archiveDir ('issue-intake-payload-' + $timestamp + '.json')
[IO.File]::WriteAllText($payloadFilePretty, $json, $utf8NoBom)
Write-Host ('Payload JSON (pretty) saved: ' + $payloadFilePretty) -ForegroundColor DarkGray
$payloadFileRaw = $null
if ($SaveRawPayload) {
    $payloadFileRaw = Join-Path $archiveDir ('issue-intake-payload-raw-' + $timestamp + '.json')
    [IO.File]::WriteAllText($payloadFileRaw, $rawJson, $utf8NoBom)
    Write-Host ('Payload JSON (raw) saved: ' + $payloadFileRaw) -ForegroundColor DarkGray
}

# Consolidated debug dump (parameters + markdown + payload) when requested
$dumpFile = $null
if ($DumpAll) {
    $dumpFile = Join-Path $archiveDir ('issue-intake-debugdump-' + $timestamp + '.txt')
    try {
        $paramReport = @()
        $paramReport += '=== Intake Debug Dump ==='
        $paramReport += 'Timestamp: ' + (Get-Date -Format o)
        $paramReport += 'Script Version: 1.1'
        $paramReport += 'Employee: ' + $Employee
        $paramReport += 'Email: ' + ($Email ?? '')
        $paramReport += 'Dept: ' + ($Dept ?? '')
        $paramReport += 'Phone: ' + ($Phone ?? '')
        $paramReport += 'Severity: ' + $Severity
        $paramReport += 'Title: ' + $Title
        $paramReport += 'Steps: ' + $Steps
        $paramReport += 'Extra length: ' + ((($Extra)?.Length) ?? 0)
        $paramReport += 'Screenshot note: ' + ($screenshotNote ?? '')
        $paramReport += 'Token Present: ' + ([bool]$Token)
        if ($Token) { $paramReport += 'Token Length: ' + $Token.Length }
        $paramReport += 'Markdown File: ' + $mdFile
    $paramReport += 'Payload Pretty File: ' + $payloadFilePretty
    if ($payloadFileRaw) { $paramReport += 'Payload Raw File: ' + $payloadFileRaw }
    $paramReport += 'Console Payload Printed: ' + ([bool](-not $NoConsolePayload -and $DebugPayload))
    $paramReport += 'PrettyPrintPayload Switch: ' + ([bool]$PrettyPrintPayload)
    $paramReport += 'SaveRawPayload Switch: ' + ([bool]$SaveRawPayload)
        $paramReport += ''
        $paramReport += '--- Markdown Body ---'
        $paramReport += (Get-Content $mdFile -Raw)
        $paramReport += '--- End Markdown Body ---'
        $paramReport += ''
        $paramReport += '--- JSON Payload ---'
        $paramReport += $json
        $paramReport += '--- End JSON Payload ---'
        [IO.File]::WriteAllLines($dumpFile, $paramReport, $utf8NoBom)
        Write-Host ('Debug dump saved: ' + $dumpFile) -ForegroundColor DarkGray
    } catch {
        Write-Host ('WARN: Failed to write debug dump: ' + $_.Exception.Message) -ForegroundColor Yellow
    }
}

try {
    $resp = Invoke-RestMethod -Method Post -Uri 'https://api.github.com/repos/KCoderVA/Telehealth-Scheduling-App/issues' -Headers $headers -Body $json
    if ($resp.number) {
        Write-Host ('Issue created: #' + $resp.number) -ForegroundColor Green
        Write-Host ('URL: ' + $resp.html_url) -ForegroundColor Cyan
        exit 0
    } else {
        Write-Host 'ERROR: Issue creation returned no number.' -ForegroundColor Red
        if ($DebugPayload) { Write-Host 'DEBUG: Response object had no number property.' -ForegroundColor Yellow }
        exit 2
    }
} catch {
    $statusCode = $null
    $responseBody = $null
    if ($_.Exception.Response -and $_.Exception.Response -is [System.Net.WebResponse]) {
        try {
            $statusCode = $_.Exception.Response.StatusCode.value__
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            $reader.Close()
        } catch {}
    }
    Write-Host ('ERROR: Issue creation failed: ' + $_.Exception.Message) -ForegroundColor Red
    if ($statusCode) { Write-Host ('HTTP Status Code: ' + $statusCode) -ForegroundColor Red }
    if ($responseBody) { Write-Host '--- Server Response Body (Raw) ---' -ForegroundColor DarkGray; Write-Host $responseBody -ForegroundColor DarkGray; Write-Host '--- End Response Body ---' -ForegroundColor DarkGray }
    if ($responseBody) {
        try {
            $errorFile = Join-Path $archiveDir ('issue-intake-error-' + $timestamp + '.txt')
            [IO.File]::WriteAllText($errorFile, $responseBody, $utf8NoBom)
            Write-Host ('Saved server response body: ' + $errorFile) -ForegroundColor Yellow
            if ($DumpAll -and $dumpFile) {
                try {
                    Add-Content -Path $dumpFile -Value "`r`n--- Server Response Body ---`r`n$responseBody`r`n--- End Server Response Body ---" -Encoding UTF8
                } catch {}
            }
        } catch {}
    }
    if ($DebugPayload -and -not $NoConsolePayload) { Write-Host 'DEBUG: Payload JSON was:' -ForegroundColor Yellow; Write-Host $json }
    if ($CaptureLog -and $transcriptFile) { try { Stop-Transcript | Out-Null } catch {} }
    exit 3
}

if ($CaptureLog -and $transcriptFile) {
    try { Stop-Transcript | Out-Null } catch {}
    Write-Host ('Full run log saved: ' + $transcriptFile) -ForegroundColor DarkGray
}
