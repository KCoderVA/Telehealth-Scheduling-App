<#
High‑level script purpose (around lines 1–40)
------------------------------------------------
This PowerShell script is designed to take a "verbal" or "email" problem report
from a hospital employee and turn it into a properly formatted GitHub issue in
the Telehealth Scheduling App repository.

At a very high level, the script does all of the following:

1. Accepts detailed information about the employee and the problem
    (see the param block around lines 25–47).
2. Normalizes the text so that special quotation marks and dashes do not cause
    problems later when building files or web addresses (Normalize‑Text function
    around lines 60–84).
3. Creates a markdown file on disk that contains a human‑readable copy of the
    entire intake (lines ~95–132). This becomes the main body of the GitHub issue.
4. If a screenshot path is provided, copies it into an archive folder and logs
    what happened (lines ~86–94).
5. If there is no GitHub token, builds a web address (URL) that pre‑fills the
    GitHub "New Issue" page with the title and body, and then opens the browser
    (lines ~134–149). This lets a human finish creating the issue.
6. If there is a GitHub token, builds a JavaScript Object Notation (JSON)
    payload in memory and sends it to the GitHub application programming
    interface (API) using Invoke‑RestMethod (lines ~173–239). This creates the
    issue automatically.
7. Optionally records extra diagnostic information, such as:
    - A pretty printed JSON payload file.
    - A minified JSON payload file.
    - A combined text file that shows key parameters and the markdown body.
    These pieces are handled in the sections around lines 151–207.

The comments that follow throughout the script explain each major section,
subsection, and important line in plain language. Whenever a value is used in
more than one place, the comment will mention the earlier line where that
value was first created. For example, when [System.Uri]::EscapeDataString is
used around line 138 to URL‑encode $rawBody, the comments will also point back
to the earlier line (~136) where $rawBody is first assigned from the markdown
file.
#>
[CmdletBinding()]
param(
    # Token used to authenticate to GitHub (see usage in the $headers
    # hashtable around lines 156–164). If this is blank, the script will look
    # for an environment variable named GITHUB_TOKEN around lines 51–54.
    [string]$Token,

    # Employee name reported in "Last, First" or similar format. This is
    # mandatory because it is written into the markdown file at
    # "**Employee:**" on lines ~112–116 and also appears in the debug dump
    # block around lines 186–204.
    [Parameter(Mandatory=$true)][string]$Employee,

    # Employee e‑mail address. This is optional. When it is not empty, it is
    # written into the markdown file (line ~113) and into the debug dump
    # around line 194.
    [string]$Email,

    # Department or service line describing where the employee works. This is
    # used in the markdown file as "**Department:**" and in the debug dump.
    [string]$Dept,

    # Phone number or phone extension for follow‑up contact, used in the
    # markdown file and debug logs.
    [string]$Phone,

    # Severity of the issue. The ValidateSet on this line restricts the
    # allowed values to four choices: low, moderate, high, and critical.
    # This is later shown in the markdown file as "**Severity:**" and can be
    # used by humans to triage the issue (lines ~110–112).
    [ValidateSet('low','moderate','high','critical')][string]$Severity='moderate',

    # Short title that summarizes the issue. This is mandatory and it is:
    #   1. Shown at the top of the markdown file as an H1 heading (line ~108).
    #   2. Reused when constructing the GitHub issue title (lines ~168–172).
    #   3. Included in the browser URL flow when there is no token
    #      (lines ~136–141).
    [Parameter(Mandatory=$true)][string]$Title,

    # Long‑form description or quoted complaint from the user. This is
    # mandatory and is stored under the "Description (Quoted Complaint)"
    # section of the markdown file (lines ~118–121).
    [Parameter(Mandatory=$true)][string]$Description,

    # Step‑by‑step instructions explaining how to reproduce the issue. This
    # has a default text value so that it is never completely blank. These
    # steps are written into the "Reproduction Steps" section of the
    # markdown file (lines ~123–126).
    [string]$Steps='(not provided)',

    # Any extra notes, such as context about the clinic session, who else was
    # present, or anything that does not fit in the earlier fields. This is
    # written into the markdown file under "Additional Notes" if provided
    # (lines ~114–116) and also measured for length in the debug dump
    # (lines ~199–201).
    [string]$Extra,

    # Optional path to a screenshot image on disk. This is evaluated around
    # lines 86–94. If the file is found, it is copied into the archive
    # folder and a short note describing what happened is stored into the
    # $screenshotNote variable.
    [string]$Screenshot,

    # When -DebugPayload is passed, the script can print the JSON body that
    # will be sent to GitHub to the console and it may control how many
    # lines are shown (see lines ~151–172).
    [switch]$DebugPayload,

    # When -CaptureLog is passed, the script starts a transcript using
    # Start-Transcript and writes all console output into a log file. The
    # transcript is started around lines 72–79 and is stopped near the end of
    # the script (lines ~246–255).
    [switch]$CaptureLog,

    # When -DumpAll is passed, the script writes a combined debug text file
    # that includes: parameters, paths to payload files, markdown content, and
    # the JSON payload itself. This block is implemented around lines
    # 186–207.
    [switch]$DumpAll,

    # This integer controls how many lines of JSON are printed when
    # -DebugPayload is used. It is read in the console‑printing block around
    # lines 151–172.
    [int]$MaxConsolePayloadLines = 300,

    # If -NoConsolePayload is set together with -DebugPayload, the script will
    # avoid printing the JSON payload to the console (lines ~168–172) but
    # will still write payload files to disk for later inspection.
    [switch]$NoConsolePayload,

    # When -SaveRawPayload is used, a second JSON file is created that uses a
    # compact, minified format (no extra line breaks). This is useful when the
    # payload will be inspected by other tools (lines ~176–184).
    [switch]$SaveRawPayload,

    # When -PrettyPrintPayload is passed together with -DebugPayload, the
    # script forces the pretty printed JSON to be shown in the console instead
    # of the minified version (see conditional assignment to $jsonForConsole
    # around lines 153–158).
    [switch]$PrettyPrintPayload
)

# Global error and strictness settings (lines ~49–56)
# ---------------------------------------------------
# $ErrorActionPreference = 'Stop' tells PowerShell to treat all non‑handled
# errors as terminating errors. This means the script will stop running as
# soon as an error occurs instead of silently continuing.
#
# Set-StrictMode -Version Latest enables strict rules about how variables and
# expressions may be used. For example, it prevents the use of variables that
# have not been declared yet. This helps catch mistakes early.
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

if (-not $Token -or [string]::IsNullOrWhiteSpace($Token)) {
    # If the caller did not supply a -Token value in the param block above,
    # or if the value is only blank spaces, this block tries to read a token
    # from the environment variable GITHUB_TOKEN instead.
    #
    # This allows the script to be used in two ways:
    #   1. Pass -Token "value" directly.
    #   2. Set GITHUB_TOKEN once in the shell and omit -Token on each call.
    $Token = $env:GITHUB_TOKEN
}

$timestamp = Get-Date -Format 'yyyy-MM-dd-HHmmss'
$rootArchiveDir = Join-Path -Path '.' -ChildPath 'archive/issue-intake'
if (-not (Test-Path $rootArchiveDir)) { New-Item -ItemType Directory -Path $rootArchiveDir | Out-Null }

# Create a dedicated subfolder per intake so all related artifacts stay together
$archiveDir = Join-Path $rootArchiveDir ("issue-intake-" + $timestamp)
if (-not (Test-Path $archiveDir)) { New-Item -ItemType Directory -Path $archiveDir | Out-Null }

# Optional transcript logging (lines ~72–79)
# -----------------------------------------
# The following section is only used when the -CaptureLog switch is set in the
# param block (see that definition around line 40). If enabled, the script
# starts a PowerShell transcript which writes every console message to a log
# file in the same archive folder as the markdown and JSON payloads.
$transcriptFile = $null
if ($CaptureLog) {
    $transcriptFile = Join-Path $archiveDir ('issue-intake-runlog-' + $timestamp + '.log')
    try { Start-Transcript -Path $transcriptFile -Force | Out-Null } catch { Write-Host ('WARN: Could not start transcript: ' + $_.Exception.Message) -ForegroundColor Yellow }
}

# Normalize smart quotes and punctuation (function Normalize‑Text, lines ~60–84)
# -----------------------------------------------------------------------------
# Many e‑mails and word processors use "smart quotes" and fancy dash
# characters that are different from plain ASCII double quotes, single quotes,
# and hyphens. These characters can cause trouble when building JSON, when
# writing markdown files, or when later copying and pasting values.
#
# The Normalize‑Text function accepts a string and replaces several specific
# Unicode characters with simpler plain text equivalents. It is used for
# multiple fields later in the script (see the assignments to $Title,
# $Description, $Steps, $Extra, $Employee, $Dept, and $Phone around
# lines 86–92).
function Normalize-Text($text) {
    if ($null -eq $text) {
        return ''
    }

    # Build a lookup map that says "when you see this special character, use
    # that simpler character instead". The keys are Unicode characters and
    # the values are plain ASCII replacements.
    $map = @{}
    $map.Add([char]0x201C, '"') # “
    $map.Add([char]0x201D, '"') # ”
    $map.Add([char]0x2018, "'") # ‘
    $map.Add([char]0x2019, "'") # ’
    $map.Add([char]0x2014, '-')  # —
    $map.Add([char]0x2013, '-')  # –

    $out = $text
    foreach ($k in $map.Keys) {
        # For each special character key in the map, perform a regular
        # expression replacement on the entire text. The call to
        # [regex]::Escape ensures that the special character is treated
        # literally and not as a regular expression symbol.
        $out = $out -replace [regex]::Escape([string]$k), $map[$k]
    }
    return $out
}

# Apply Normalize‑Text to all user‑supplied strings (lines ~86–92)
# ----------------------------------------------------------------
# Each of the following assignments calls Normalize‑Text on the corresponding
# variable and stores the cleaned version back into the same variable name.
# This means that all later sections of the script always work with the
# normalized forms.
$Title        = Normalize-Text $Title
$Description  = Normalize-Text $Description
$Steps        = Normalize-Text $Steps
$Extra        = Normalize-Text $Extra
$Employee     = Normalize-Text $Employee
$Dept         = Normalize-Text $Dept
$Phone        = Normalize-Text $Phone

# Screenshot handling and note creation (lines ~94–107)
# -----------------------------------------------------
# The $screenshotNote variable is used later when building both the
# markdown file (lines ~112–116) and the debug dump (around line 201).
# It tells the reader whether a screenshot was archived successfully or
# whether the path was missing.
$screenshotNote = ''
if ($Screenshot) {
    if (Test-Path $Screenshot) {
        # Build a destination path inside the archive directory that uses the
        # word "screenshot_", followed by the timestamp, followed by the
        # original file extension. This ensures screenshots do not overwrite
        # each other and are grouped with the intake they belong to.
        $dest = Join-Path $archiveDir ( 'screenshot_' + $timestamp + [IO.Path]::GetExtension($Screenshot) )
        Copy-Item $Screenshot $dest -Force
        $screenshotNote = 'Screenshot archived: ' + $dest
    } else {
        $screenshotNote = 'Screenshot path provided but not found: ' + $Screenshot
    }
}

# Path to the markdown file that will hold the full intake body (line ~108)
# -------------------------------------------------------------------------
# This file is later used in three important places:
#   1. The content is written once below using [IO.File]::WriteAllLines
#      (lines ~129–132).
#   2. When no token is present, the entire markdown file is read into
#      $rawBody (line ~136) and then encoded for use in a GitHub web address
#      (lines ~137–140).
#   3. When a token is present, the markdown file content becomes the "body"
#      field of the JSON payload that is sent to GitHub (line ~166).
$mdFile = Join-Path $archiveDir ('issue-intake-' + $timestamp + '.md')

# Build the markdown content line by line (lines ~110–127)
# --------------------------------------------------------
# The $lines array collects each line of the markdown document in order.
# When writing fields like Severity or Employee, the script uses markdown
# formatting such as "**Severity:**" for bold labels.
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

# Configure Unicode encoding for files and write the markdown (lines ~129–132)
# ---------------------------------------------------------------------------
# $utf8NoBom uses UTF‑8 encoding without a byte order mark. This produces
# clean text files that still support international characters.
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllLines($mdFile, $lines, $utf8NoBom)
Write-Host ('Prepared issue body: ' + $mdFile) -ForegroundColor Cyan

if (-not $Token -or [string]::IsNullOrWhiteSpace($Token)) {
    # No GitHub token path (lines ~134–149)
    # -------------------------------------
    # In this branch the script does NOT call the GitHub API directly. Instead
    # it constructs a special web address that pre‑fills the "New Issue" form
    # in the browser.

    # Add-Type is used here in case we needed extra web utilities, but the
    # core encoding work is performed by [System.Uri]::EscapeDataString below
    # (lines ~138–140).
    Add-Type -AssemblyName System.Web

    # On this line, $rawBody is first defined by reading the entire markdown
    # file created earlier at line ~108. This is the full issue body, with
    # headings, description, steps, and internal notes.
    $rawBody   = Get-Content $mdFile -Raw

    # On line ~138, [System.Uri]::EscapeDataString('intake: ' + $Title)
    # encodes the combined text "intake: " plus the normalized title from
    # earlier (see $Title normalization around lines 86–92). This encoding
    # process replaces characters that are unsafe in URLs (spaces, quotes,
    # and others) with percent‑encoded forms.
    $encodedTitle = [System.Uri]::EscapeDataString('intake: ' + $Title)

    # On line ~139, [System.Uri]::EscapeDataString($rawBody) performs the
    # same safe URL encoding for the entire markdown body that was loaded
    # from disk on line ~136. The result $encodedBody is suitable for
    # placement in a query string without breaking the URL.
    $encodedBody  = [System.Uri]::EscapeDataString($rawBody)

    # Combine the encoded title and encoded body into a full GitHub
    # "New Issue" URL. When this URL is opened in a web browser, GitHub
    # automatically fills the title and description fields with these values.
    $url = 'https://github.com/KCoderVA/Telehealth-Scheduling-App/issues/new?title=' + $encodedTitle + '&body=' + $encodedBody

    Write-Host 'No token detected; opening browser for manual issue creation (add labels intake, bug, verbal).' -ForegroundColor Yellow
    start $url
    exit 0
}

# HTTP headers for the GitHub API call (lines ~156–164)
# -----------------------------------------------------
# This hashtable contains the values that tell GitHub who we are and what
# kind of data we are sending. The Authorization line uses the token that
# was either passed in the param block or taken from the environment
# (see the earlier conditional around lines 49–54).
$headers = @{
    Authorization = 'Bearer ' + $Token
    'User-Agent'  = 'TelehealthIssueAutomation'
    Accept        = 'application/vnd.github+json'
    'Content-Type' = 'application/json'
}
# JSON payload construction for the GitHub issue (lines ~165–173)
# ---------------------------------------------------------------
# This ordered hashtable becomes the JSON object sent to GitHub when the
# Invoke‑RestMethod call is made in the try block around lines 213–233.
# The body field reads the markdown file content created earlier at
# line ~108.
$payload = [ordered]@{
    title = 'intake: ' + $Title
    body  = (Get-Content $mdFile -Raw)
    labels = @('intake','bug','verbal')
    assignees = @('KCoderVA')
}

# $json holds a human‑readable (pretty printed) representation of the payload.
$json = $payload | ConvertTo-Json -Depth 6

# Optionally pretty‑print (current ConvertTo‑Json already pretty; provide minified raw)
# -------------------------------------------------------------------------------
# $rawJson is the same data as $json but in a compressed, single‑line form.
# This is useful for logging and for the -SaveRawPayload option.
$rawJson = ($payload | ConvertTo-Json -Depth 6 -Compress)

if ($DebugPayload -and -not $NoConsolePayload) {
    # Console JSON preview (lines ~151–172)
    # -------------------------------------
    # When -DebugPayload is set without -NoConsolePayload, this block prints
    # either the pretty JSON ($json) or the compressed JSON ($rawJson) to the
    # console. The number of lines shown is limited by $MaxConsolePayloadLines
    # from the param block.
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
    # This branch still creates payload files but avoids filling the terminal
    # with JSON text.
    Write-Host 'DEBUG: Console payload output suppressed by -NoConsolePayload (payload still saved to files).' -ForegroundColor Yellow
}

# Persist payload JSON for troubleshooting (pretty + raw if requested)
# --------------------------------------------------------------------
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
# ------------------------------------------------------------------------
# The -DumpAll switch (defined in the param block near the top of the file)
# causes this section to build a very detailed text report. The purpose of
# this report is to capture:
#   - All of the key parameters that were passed or derived
#   - The exact markdown file contents written earlier (see $mdFile usage
#     around lines ~108–132)
#   - The JSON payload string that will be or was sent to GitHub
#   - The locations of the pretty and raw JSON payload files
#
# If something goes wrong later, you can open this debug dump file and see
# the "story" of what the script believed it was doing at the time of the
# run.
$dumpFile = $null
if ($DumpAll) {
    $dumpFile = Join-Path $archiveDir ('issue-intake-debugdump-' + $timestamp + '.txt')
    try {
        # Start with a fresh string array that will hold each line of the
        # debug dump file, similar to how $lines was used for the markdown
        # body earlier in the script.
        $paramReport = @()
        $paramReport += '=== Intake Debug Dump ==='
        $paramReport += 'Timestamp: ' + (Get-Date -Format o)
        $paramReport += 'Script Version: 1.1'

        # Echo back the main intake parameters so that someone reading the
        # dump file does not have to guess what was passed on the command
        # line or through a Visual Studio Code task.
        $paramReport += 'Employee: ' + $Employee
        $paramReport += 'Email: ' + ($Email | ForEach-Object { if ($_ -ne $null) { $_ } else { '' } })
        $paramReport += 'Dept: ' + ($Dept | ForEach-Object { if ($_ -ne $null) { $_ } else { '' } })
        $paramReport += 'Phone: ' + ($Phone | ForEach-Object { if ($_ -ne $null) { $_ } else { '' } })
        $paramReport += 'Severity: ' + $Severity
        $paramReport += 'Title: ' + $Title
        $paramReport += 'Steps: ' + $Steps
        $extraLength = 0
        if ($null -ne $Extra) { $extraLength = $Extra.Length }
        $paramReport += 'Extra length: ' + $extraLength
        # Include additional context that is not obvious from the main
        # parameters alone, such as whether a screenshot was copied and
        # whether a token was present at all.
        $paramReport += 'Screenshot note: ' + ($screenshotNote | ForEach-Object { if ($_ -ne $null) { $_ } else { '' } })
        $paramReport += 'Token Present: ' + ([bool]$Token)
        if ($Token) { $paramReport += 'Token Length: ' + $Token.Length }

        # Record where the earlier artifacts were written so that someone can
        # easily jump to them from the dump file.
        $paramReport += 'Markdown File: ' + $mdFile
        $paramReport += 'Payload Pretty File: ' + $payloadFilePretty
        if ($payloadFileRaw) { $paramReport += 'Payload Raw File: ' + $payloadFileRaw }

        # These lines reflect how the diagnostic switches were set at the
        # time of the run. They can be helpful when trying to understand
        # why certain console output or files were present or missing.
        $paramReport += 'Console Payload Printed: ' + ([bool](-not $NoConsolePayload -and $DebugPayload))
        $paramReport += 'PrettyPrintPayload Switch: ' + ([bool]$PrettyPrintPayload)
        $paramReport += 'SaveRawPayload Switch: ' + ([bool]$SaveRawPayload)
        $paramReport += ''
        # Copy the entire markdown body into the dump so that a single file
        # contains both the parameter summary above and the exact text that
        # was used as the issue description. This mirrors the content that
        # was originally written to $mdFile near lines 110–127.
        $paramReport += '--- Markdown Body ---'
        $paramReport += (Get-Content $mdFile -Raw)
        $paramReport += '--- End Markdown Body ---'
        $paramReport += ''
        # Finally, append the JSON payload. This allows a reviewer to see
        # exactly what was or would be sent to GitHub in a single place,
        # without having to open the separate .json file.
        $paramReport += '--- JSON Payload ---'
        $paramReport += $json
        $paramReport += '--- End JSON Payload ---'
        [IO.File]::WriteAllLines($dumpFile, $paramReport, $utf8NoBom)
        Write-Host ('Debug dump saved: ' + $dumpFile) -ForegroundColor DarkGray
    } catch {
        Write-Host ('WARN: Failed to write debug dump: ' + $_.Exception.Message) -ForegroundColor Yellow
    }
}

# Main GitHub API call and error handling (lines ~213–255)
# --------------------------------------------------------
# This try/catch block is the final step that actually attempts to create
# the GitHub issue using the JSON payload prepared above. Everything before
# this point was preparing data, writing local files, or setting up
# diagnostics.
try {
    # Invoke-RestMethod sends an HTTP POST request to the GitHub issues API
    # endpoint. The -Headers argument uses the $headers hashtable created
    # earlier around lines 156–164, and -Body uses the $json string that was
    # created from the $payload object around lines 165–173.
    $resp = Invoke-RestMethod -Method Post -Uri 'https://api.github.com/repos/KCoderVA/Telehealth-Scheduling-App/issues' -Headers $headers -Body $json
    # If GitHub returns a response that includes an "issue number" field,
    # then the issue was created successfully.
    if ($resp.number) {
        Write-Host ('Issue created: #' + $resp.number) -ForegroundColor Green
        Write-Host ('URL: ' + $resp.html_url) -ForegroundColor Cyan

        # Append GitHub issue linkage back into the local intake markdown for traceability
        # This nested try/catch attempts to append a short summary line back
        # into the local markdown intake file. The added line includes the
        # issue number and the web address of the created GitHub issue. This
        # makes it easy to trace from the local record to the live issue.
        try {
            $linkLine = "**GitHub Issue:** #$($resp.number) - $($resp.html_url)"
            Add-Content -Path $mdFile -Value "`r`n$linkLine" -Encoding UTF8
            Write-Host 'Updated intake file with GitHub issue reference.' -ForegroundColor DarkGray
        } catch {
            Write-Host ('WARN: Failed to update intake markdown with GitHub issue reference: ' + $_.Exception.Message) -ForegroundColor Yellow
        }

        exit 0
    } else {
        # If the response object does not contain a number property, something
        # unexpected happened. The script treats this as an error condition
        # and reports it.
        Write-Host 'ERROR: Issue creation returned no number.' -ForegroundColor Red
        if ($DebugPayload) { Write-Host 'DEBUG: Response object had no number property.' -ForegroundColor Yellow }
        exit 2
    }
} catch {
    # Any exception thrown inside the try block above is caught here. The
    # following lines attempt to extract as much information as possible
    # from the error so that it can be inspected later.
    $statusCode = $null
    $responseBody = $null
    if ($_.Exception.Response -and $_.Exception.Response -is [System.Net.WebResponse]) {
        # If the exception includes a web response object, the script reads
        # the HTTP status code and the raw response body stream so that
        # these can be written to the console and to files. This is very
        # helpful when diagnosing why GitHub rejected the request
        # (for example, bad authentication or validation errors).
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
        # If there is a response body, the script writes it out to its own
        # error text file and, when a debug dump is already present, appends
        # it there as well. This means the exact error message from GitHub is
        # preserved even if the console scrolls away.
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

    # If -DebugPayload was specified, echo the JSON payload that was used so
    # that it can be examined next to the error response.
    if ($DebugPayload -and -not $NoConsolePayload) { Write-Host 'DEBUG: Payload JSON was:' -ForegroundColor Yellow; Write-Host $json }

    # If transcript logging was enabled at the start of the script, make
    # sure the transcript is stopped here in the error path so that the log
    # file is properly closed.
    if ($CaptureLog -and $transcriptFile) { try { Stop-Transcript | Out-Null } catch {} }
    exit 3
}

# Graceful transcript shutdown in the success path (lines ~255–262)
# -----------------------------------------------------------------
# If execution reached this far, the try/catch block did not call exit and
# we are in a "successful" end-of-script state. If -CaptureLog was used,
# the transcript is stopped one last time here and the path to the log file
# is printed for convenience.
if ($CaptureLog -and $transcriptFile) {
    try { Stop-Transcript | Out-Null } catch {}
    Write-Host ('Full run log saved: ' + $transcriptFile) -ForegroundColor DarkGray
}
