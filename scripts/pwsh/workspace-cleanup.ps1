
# =====================================================================================================
# workspace-cleanup.ps1
# -----------------------------------------------------------------------------------------------------
# Power Platform Workspace Cleanup & Archiving Script
# -----------------------------------------------------------------------------------------------------
# Purpose:
#   - Safely archives temporary, test, and non-public files from the workspace to the archive folder.
#   - Maintains original directory structure in the archive.
#   - Excludes public (git-tracked) files and protected folders from cleanup.
#   - Provides detailed logging, error handling, and dry-run (WhatIf) support.
#   - Ensures compliance with VA Healthcare security and audit requirements.
#
# Usage:
#   - Run from the workspace root or specify -Root parameter.
#   - Use -WhatIf to preview actions without making changes.
#
# Workspace root: "S:\Informatics\Data Team\Coder - Informatics\App Programing\Employee Recognition App"
# Author: Kyle J. Coder
# License: Apache License, Version 2.0
# =====================================================================================================


# -----------------------------------------------------------------------------------------------------
# PARAMETERS
# -----------------------------------------------------------------------------------------------------
#   $Root   : The root directory of the workspace (defaults to current location)
#   $WhatIf : If specified, performs a dry run (no files are moved or deleted)
# -----------------------------------------------------------------------------------------------------
param(
    [string]$Root = (Get-Location).Path,
    [switch]$WhatIf
)


# -----------------------------------------------------------------------------------------------------
# FUNCTION: Get-RelativePath
#   Returns the relative path from $base to $full, normalizing path separators.
# -----------------------------------------------------------------------------------------------------
function Get-RelativePath($base, $full) {
    return $full.Substring($base.Length).TrimStart('\', '/')
}


# -----------------------------------------------------------------------------------------------------
# INITIALIZATION
# -----------------------------------------------------------------------------------------------------
#   - Set timestamp for logging and archive file naming
#   - Define archive root directory
# -----------------------------------------------------------------------------------------------------
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$archiveRoot = Join-Path $Root 'archive'


# -----------------------------------------------------------------------------------------------------
# GIT-TRACKED FILE EXCLUSION
# -----------------------------------------------------------------------------------------------------
#   - Collect all files tracked by git to exclude them from archiving (public files)
#   - Only run once for efficiency
#   - Handles non-git workspaces gracefully
# -----------------------------------------------------------------------------------------------------

# Progress indicator for git-tracked file exclusion
Write-Host "0% complete: Starting git-tracked file exclusion..." -ForegroundColor Cyan
$gitTrackedFiles = @{}
try {
    $gitRoot = & git rev-parse --show-toplevel 2>$null
    Write-Host "25% complete: Located git root..." -ForegroundColor Cyan
    if ($LASTEXITCODE -eq 0 -and $gitRoot) {
        $gitFiles = & git ls-files -z | ForEach-Object { $_ -split "\0" } | Where-Object { $_ -ne '' }
        Write-Host "50% complete: Loaded git file list..." -ForegroundColor Cyan
        $totalGitFiles = $gitFiles.Count
        $gitProgressStep = [Math]::Max([Math]::Floor($totalGitFiles / 4), 1)
        $gitIndex = 0
        foreach ($gfile in $gitFiles) {
            # Normalize path separators for Windows compatibility
            $norm = $gfile -replace '/', '\'
            $gitTrackedFiles[$norm.ToLower()] = $true
            $gitIndex++
            if ($gitIndex -eq [Math]::Floor($totalGitFiles / 2)) {
                Write-Host "75% complete: Processed half of git file list..." -ForegroundColor Cyan
            }
        }
        Write-Host "100% complete: Git exclusion ready. Loaded $($gitTrackedFiles.Count) git-tracked files." -ForegroundColor Cyan
        Write-Host "[INFO] Loaded $($gitTrackedFiles.Count) git-tracked files." -ForegroundColor DarkGray
    }
    else {
        Write-Host "[WARN] Not a git repository or git not available. Skipping git-tracked exclusion." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "[WARN] Failed to collect git-tracked files: $_" -ForegroundColor Yellow
}



# -----------------------------------------------------------------------------------------------------
# ARCHIVE PATTERNS & FOLDER EXCLUSIONS
# -----------------------------------------------------------------------------------------------------
#   - $archivePatterns: List of glob patterns for files to archive (temp, backup, test, etc.)
#   - $regexPatterns  : Combined regex for efficient matching
#   - $excludeFolders : Folders to always exclude from cleanup (archive, git, VS Code, etc.)
# -----------------------------------------------------------------------------------------------------
$archivePatterns = @(
    '*.tmp', '*.temp', '*.bak', '*.backup', '*.log', '*.zip', '*.7z', '*.tar', '*.gz', '*.rar',
    '*_test.*', '*TEMP*', '*-test.*', '*_dev.*', '*-dev.*', '*_draft.*', '*-draft.*', '*_old.*', '*-old.*', '*TEMP-*', '*_copy.*', '*-copy.*', '*_export*', '*-export*', '*_exported*', '*-exported*', '*.ps1~', '*.md~', '*.xlsx~', '*.docx~', '*.pptx~', '*.csv~', '*.tmp.*', '*.swp', '*.swo', '*.tmpfile', '*.tempfile', '*.cache', '*.DS_Store', 'Thumbs.db', 'ehthumbs.db'
)

# Convert glob patterns to a single regex for fast matching
$regexPatterns = ($archivePatterns | ForEach-Object {
        $_ -replace '\.', '\\.' -replace '\*', '.*'
    }) -join '|'

# List of folders to exclude from file archiving (but not from empty directory cleanup)
$excludeFolders = @('archive', '.git', '.github', '.vscode', 'src')

# List of specific files to exempt from archiving (full paths, case-insensitive)
$explicitExemptFiles = @(
    "$Root\README.md",
    "$Root\CHANGELOG.md",
    "$Root\LICENSE",
    "$Root\.gitignore",
    "$Root\docs\SECURITY.md",
    "$Root\docs\PROJECT_STATUS.md",
    "$Root\docs\CONTRIBUTING.md",
    "$Root\docs\NOTICE",
    "$Root\.vscode\tasks.json",
    "$Root\.vscode\settings.json",
    "$Root\.vscode\restricted-operations.json",
    "$Root\.vscode\workspace-safety.config",
    "$Root\.github\copilot-instructions.md",
    "$Root\.github\workflows\repository-health.yml",
    "$Root\.github\workflows\changelog-validation.yml",
    "$Root\.github\workflows\changelog-enforcement.yml",
    "$Root\.gitmessage",
    "$Root\src\solution.xml"
)


# -----------------------------------------------------------------------------------------------------
# FUNCTION: Get-FilesToArchive
#   - Recursively finds all files matching archive patterns, excluding protected folders and git-tracked files.
#   - Returns a list of files to be archived.
# -----------------------------------------------------------------------------------------------------
function Get-FilesToArchive {
    param($root, $patterns, $excludeFolders)
    $excludePaths = $excludeFolders | ForEach-Object { Join-Path $root $_ }
    $explicitExempt = $explicitExemptFiles | ForEach-Object { $_.ToLower() }
    Get-ChildItem -Path $root -Recurse -File | Where-Object {
        $file = $_
        # Exclude protected folders (archive, .git, etc.)
        foreach ($exclude in $excludePaths) {
            if ($file.FullName -like "$exclude*") { return $false }
        }
        # Exclude explicit exempt files (case-insensitive)
        if ($explicitExempt -contains $file.FullName.ToLower()) { return $false }
        # Exclude files tracked in git (public) using pre-collected list
        if ($gitTrackedFiles.Count -gt 0) {
            $relPath = Get-RelativePath $root $file.FullName
            $relPathNorm = $relPath -replace '/', '\'
            if ($gitTrackedFiles.ContainsKey($relPathNorm.ToLower())) { return $false }
        }
        # Match archive patterns using regex
        if ($file.Name -match $regexPatterns) { return $true }
        return $false
    }
}

# Get the list of files to archive for this run
$filesToArchive = Get-FilesToArchive -root $Root -patterns $archivePatterns -excludeFolders $excludeFolders



# -----------------------------------------------------------------------------------------------------
# LOGGING & COUNTERS
# -----------------------------------------------------------------------------------------------------
#   - Set up log file in docs/logs/ for audit trail
#   - Track number of files archived and errors encountered
#   - Define text file extensions for comment insertion
# -----------------------------------------------------------------------------------------------------
$archivedCount = 0
$errorCount = 0
$textExtensions = @('.ps1', '.txt', '.csv', '.md', '.json', '.xml', '.log', '.yaml', '.yml', '.ini', '.bat', '.sh', '.psm1', '.psd1')



# Prepare log directory and file (always create, even if no files to archive)
$logDir = Join-Path $Root 'docs/logs'
if (!(Test-Path $logDir)) {
    try {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    catch {
        Write-Host "[ERROR] Could not create log directory: $logDir" -ForegroundColor Red
    }
}
$logFile = Join-Path $logDir 'ScriptLog_workspace-cleanup.txt'
$logTime = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$logHeader = "`n--- Workspace Cleanup Log: $logTime ---`n"

# Function to write a timestamped log entry
function Write-LogEntry {
    param([string]$entry)
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Add-Content -Path $logFile -Value ("[$ts] $entry")
}

try {
    Add-Content -Path $logFile -Value $logHeader
    Write-LogEntry "Files found to archive: $($filesToArchive.Count)"
}
catch {
    Write-Host "[ERROR] Could not write to log file: $logFile" -ForegroundColor Red
}

Write-Host "[INFO] Found $($filesToArchive.Count) file(s) to archive..." -ForegroundColor Cyan
try {
    Write-LogEntry "[INFO] Found $($filesToArchive.Count) file(s) to archive..."
}
catch {}



# -----------------------------------------------------------------------------------------------------
# ARCHIVING LOOP
# -----------------------------------------------------------------------------------------------------
#   - For each file to archive:
#       * Recreate directory structure in archive if needed
#       * Prevent overwriting by appending timestamp if file exists
#       * For text files, prepend archive comment
#       * For binary files, copy as-is
#       * Remove read-only attribute before deletion
#       * Log all actions and errors
#       * Support dry-run mode (WhatIf)
# -----------------------------------------------------------------------------------------------------

# Progress indicator for file archiving loop
$totalFiles = $filesToArchive.Count
$progressStep = [Math]::Max([Math]::Floor($totalFiles / 10), 1)
$fileIndex = 0
foreach ($file in $filesToArchive) {
    try {
        $relativePath = Get-RelativePath $Root $file.FullName
        $archivePath = Join-Path $archiveRoot $relativePath
        $archiveDir = Split-Path $archivePath -Parent
        if (!(Test-Path $archiveDir)) {
            if ($WhatIf) {
                Write-Host "[DRY RUN] Would create archive directory: $archiveDir" -ForegroundColor DarkGray
                Write-LogEntry "[DRY RUN] Would create archive directory: $archiveDir"
            }
            else {
                New-Item -ItemType Directory -Path $archiveDir -Force -ErrorAction Stop | Out-Null
                Write-Host "[INFO] Created archive directory: $archiveDir" -ForegroundColor DarkGray
                Write-LogEntry "[INFO] Created archive directory: $archiveDir"
            }
        }
        # Prevent overwriting: append timestamp if file exists in archive
        $finalArchivePath = $archivePath
        if (Test-Path $archivePath) {
            $timestampSuffix = (Get-Date -Format 'yyyyMMddHHmmss')
            $finalArchivePath = "$archivePath.$timestampSuffix"
        }
        $comment = "# Archived automatically with workspace-cleanup.ps1 script on $timestamp from $($file.DirectoryName)"
        $ext = [IO.Path]::GetExtension($file.Name).ToLower()
        if ($WhatIf) {
            Write-Host "[DRY RUN] Would archive $($file.FullName) -> $finalArchivePath" -ForegroundColor Cyan
            Write-LogEntry "[DRY RUN] Would archive $($file.FullName) -> $finalArchivePath"
        }
        else {
            if ($textExtensions -contains $ext) {
                # For text files, add archive comment at the top
                Set-Content -Path $finalArchivePath -Value $comment -ErrorAction Stop
                Add-Content -Path $finalArchivePath -Value (Get-Content $file.FullName -ErrorAction Stop)
            }
            else {
                # For binary files, copy as-is
                Copy-Item $file.FullName -Destination $finalArchivePath -Force -ErrorAction Stop
            }
            # Remove read-only attribute if set before deletion
            if ($file.Attributes -band [System.IO.FileAttributes]::ReadOnly) {
                $file.Attributes = $file.Attributes -bxor [System.IO.FileAttributes]::ReadOnly
            }
            Remove-Item $file.FullName -Force -ErrorAction Stop
            $msg = "[ARCHIVED] $($file.FullName) -> $finalArchivePath"
            Write-Host $msg -ForegroundColor Green
            Write-LogEntry $msg
            $archivedCount++
        }
    }
    catch {
        $errmsg = "[ERROR] Failed to archive $($file.FullName): $_"
        Write-Host $errmsg -ForegroundColor Red
        Write-LogEntry $errmsg
        $errorCount++
    }
    $fileIndex++
    if ($totalFiles -gt 0 -and (($fileIndex % $progressStep) -eq 0 -or $fileIndex -eq $totalFiles)) {
        $percent = [Math]::Round((($fileIndex) / $totalFiles) * 100)
        Write-Host "$percent% complete: Processed $fileIndex of $totalFiles files..." -ForegroundColor Cyan
    }
}


# -----------------------------------------------------------------------------------------------------
# SUMMARY OUTPUT
# -----------------------------------------------------------------------------------------------------
#   - Print and log summary of actions taken and errors encountered
# -----------------------------------------------------------------------------------------------------
$summary1 = "[SUMMARY] Workspace cleanup complete."
$summary2 = "[SUMMARY] Archived $archivedCount file(s) to $archiveRoot."
Write-Host $summary1 -ForegroundColor Cyan
Write-Host $summary2 -ForegroundColor Green
try {
    Write-LogEntry $summary1
    Write-LogEntry $summary2
    if ($errorCount -gt 0) {
        $summary3 = "[SUMMARY] Encountered $errorCount error(s) during archiving. See above for details."
        Write-Host $summary3 -ForegroundColor Yellow
        Write-LogEntry $summary3
    }
    else {
        Write-LogEntry "[SUMMARY] No errors encountered during archiving."
    }
}
catch {
    Write-Host "[ERROR] Could not write summary to log file: $logFile" -ForegroundColor Red
}


# -----------------------------------------------------------------------------------------------------
# EMPTY DIRECTORY CLEANUP
# -----------------------------------------------------------------------------------------------------
#   - After archiving, find and optionally remove empty directories (regardless of location)
#   - Prompts user for confirmation before deletion (unless in dry-run mode)
#   - Handles read-only attributes and logs all actions
# -----------------------------------------------------------------------------------------------------
$emptyDirs = Get-ChildItem $Root -Directory -Recurse | Where-Object {
    # Check for any visible or hidden files or subdirectories
    ($_.GetFileSystemInfos('*', 'AllDirectories').Count -eq 0) -or ($_.Name -match 'TEMP')
}
if ($emptyDirs.Count -gt 0) {
    Write-Host "[INFO] Found $($emptyDirs.Count) empty directories after archiving (including exempted folders)." -ForegroundColor Cyan
    foreach ($dir in $emptyDirs) {
        $confirm = Read-Host "Delete empty directory '$($dir.FullName)'? (y/N)"
        if ($confirm -eq 'y' -or $confirm -eq 'Y') {
            try {
                if ($WhatIf) {
                    Write-Host "[DRY RUN] Would remove empty directory: $($dir.FullName)" -ForegroundColor Cyan
                    Write-LogEntry "[DRY RUN] Would remove empty directory: $($dir.FullName)"
                }
                else {
                    # Remove read-only attribute if set before deletion
                    if ($dir.Attributes -band [System.IO.FileAttributes]::ReadOnly) {
                        $dir.Attributes = $dir.Attributes -bxor [System.IO.FileAttributes]::ReadOnly
                    }
                    Remove-Item $dir.FullName -Force -ErrorAction Stop
                    Write-Host "[REMOVED] $($dir.FullName)" -ForegroundColor Green
                    Write-LogEntry "[REMOVED] $($dir.FullName)"
                }
            }
            catch {
                $errmsg = "[ERROR] Failed to remove empty directory $($dir.FullName): $_"
                Write-Host $errmsg -ForegroundColor Red
                Write-LogEntry $errmsg
            }
        }
        else {
            Write-Host "[SKIPPED] $($dir.FullName)" -ForegroundColor Yellow
            Write-LogEntry "[SKIPPED] $($dir.FullName)"
        }
    }
}


# -----------------------------------------------------------------------------------------------------
# Sort the log file entries (excluding the header) by timestamp before final summary
try {
    $logLines = Get-Content $logFile
    $headerLineCount = ($logLines | Select-String -Pattern '--- Workspace Cleanup Log:' | Measure-Object).Count
    if ($headerLineCount -gt 0) {
        $header = $logLines[0..($headerLineCount - 1)]
        $entries = $logLines[$headerLineCount..($logLines.Count - 1)]
        $sorted = $entries | Sort-Object { $_.Substring(1, 19) } # sort by timestamp
        Set-Content -Path $logFile -Value ($header + $sorted)
    }
}
catch {
    Write-Host "[ERROR] Could not sort log file: $logFile" -ForegroundColor Red
}
# =====================================================================================================
# END OF SCRIPT
# -----------------------------------------------------------------------------------------------------
# This script is designed for safe, auditable, and compliant workspace cleanup in Power Platform projects.
# For questions or improvements, see project documentation or contact the author.
# =====================================================================================================
