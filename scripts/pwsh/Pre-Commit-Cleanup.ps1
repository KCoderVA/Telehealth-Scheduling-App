# Pre-Commit Repository Cleanup Script
# Copyright 2025 Kyle J. Coder
# Licensed under the Apache License, Version 2.0

<#
.SYNOPSIS
    Comprehensive cleanup and validation script for Telehealth Resources Project
.DESCRIPTION
    Prepares the repository for clean commit to GitHub by validating structure,
    cleaning temporary files, updating documentation dates, and ensuring quality
.PARAMETER SkipValidation
    Skip project structure validation
.PARAMETER SkipCleanup
    Skip temporary file cleanup
.EXAMPLE
    .\scripts\Pre-Commit-Cleanup.ps1
    # Runs full cleanup and validation
#>

[CmdletBinding()]
param(
    [Parameter()]
    [switch]$SkipValidation,

    [Parameter()]
    [switch]$SkipCleanup
)

#Requires -Version 5.1
Set-StrictMode -Version Latest

# Initialize error tracking
$ErrorCount = 0
$WarningCount = 0

Write-Host "Repository Pre-Commit Cleanup" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Green
Write-Host "Started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

# Function to report errors and warnings
function Write-ValidationResult {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )

    switch ($Type) {
        "Error" {
            Write-Host "   ERROR: $Message" -ForegroundColor Red
            $script:ErrorCount++
        }
        "Warning" {
            Write-Host "   WARNING: $Message" -ForegroundColor Yellow
            $script:WarningCount++
        }
        "Success" {
            Write-Host "   SUCCESS: $Message" -ForegroundColor Green
        }
        "Info" {
            Write-Host "   INFO: $Message" -ForegroundColor Cyan
        }
    }
}

# 1. Clean temporary files
if (-not $SkipCleanup) {
    Write-Host "Cleaning Temporary Files..." -ForegroundColor Yellow

    $TempPatterns = @(
        "~$*",
        "*.tmp",
        "*.temp",
        "*.bak",
        "*.backup",
        "*_preview.html",
        "*_preview_*.html",
        "*.log"
    )

    $RemovedCount = 0
    foreach ($Pattern in $TempPatterns) {
        try {
            $Files = Get-ChildItem -Path . -Recurse -Include $Pattern -ErrorAction SilentlyContinue
            foreach ($File in $Files) {
                Remove-Item $File.FullName -Force -ErrorAction SilentlyContinue
                $RemovedCount++
            }
        }
        catch {
            Write-ValidationResult "Could not clean pattern $Pattern" "Warning"
        }
    }

    if ($RemovedCount -gt 0) {
        Write-ValidationResult "Cleaned $RemovedCount temporary files" "Success"
    } else {
        Write-ValidationResult "No temporary files found to clean" "Info"
    }
    Write-Host ""
}

# 2. Update documentation dates
Write-Host "Updating Documentation Dates..." -ForegroundColor Yellow

$CurrentDate = Get-Date -Format 'MMMM dd, yyyy'
$DocsToUpdate = @(
    @{ Path = "README.md"; Pattern = 'Last Updated: .*'; Replacement = "Last Updated: $CurrentDate" },
    @{ Path = "CONTRIBUTING.md"; Pattern = '\*Last Updated: .*\*'; Replacement = "*Last Updated: $CurrentDate*" },
    @{ Path = "SECURITY.md"; Pattern = '\*Last Updated: .*\*'; Replacement = "*Last Updated: $CurrentDate*" },
    @{ Path = "PROJECT-INDEX.md"; Pattern = '\*\*Last Updated: .*\*\*'; Replacement = "**Last Updated: $CurrentDate**" }
)

foreach ($Doc in $DocsToUpdate) {
    if (Test-Path $Doc.Path) {
        try {
            $Content = Get-Content $Doc.Path -Raw
            if ($Content -match $Doc.Pattern) {
                $UpdatedContent = $Content -replace $Doc.Pattern, $Doc.Replacement
                $UpdatedContent | Set-Content $Doc.Path -NoNewline
                Write-ValidationResult "Updated date in $($Doc.Path)" "Success"
            } else {
                Write-ValidationResult "No date pattern found in $($Doc.Path)" "Info"
            }
        }
        catch {
            Write-ValidationResult "Failed to update $($Doc.Path)" "Error"
        }
    } else {
        Write-ValidationResult "$($Doc.Path) not found" "Warning"
    }
}
Write-Host ""

# 3. Validate project structure
if (-not $SkipValidation) {
    Write-Host "Validating Project Structure..." -ForegroundColor Yellow

    # Required files
    $RequiredFiles = @(
        "README.md",
        "CHANGELOG.md",
        "LICENSE",
        "CONTRIBUTING.md",
        "SECURITY.md",
        ".gitignore"
    )

    foreach ($File in $RequiredFiles) {
        if (Test-Path $File) {
            Write-ValidationResult "$File exists" "Success"
        } else {
            Write-ValidationResult "$File is missing" "Error"
        }
    }

    # Required directories
    $RequiredDirs = @("src", "docs", "data", "legacy", ".github", ".vscode")

    foreach ($Dir in $RequiredDirs) {
        if (Test-Path $Dir) {
            $FileCount = (Get-ChildItem $Dir -Recurse -File -ErrorAction SilentlyContinue).Count
            Write-ValidationResult "$Dir/ exists with $FileCount files" "Success"
        } else {
            Write-ValidationResult "$Dir/ directory is missing" "Error"
        }
    }
    Write-Host ""
}

# 4. Git repository validation
Write-Host "Git Repository Status..." -ForegroundColor Yellow

if (Test-Path ".git") {
    Write-ValidationResult "Git repository initialized" "Success"

    # Check for large files
    try {
        $LargeFiles = Get-ChildItem -Recurse -File | Where-Object { $_.Length -gt 10MB }
        if ($LargeFiles) {
            Write-ValidationResult "Found $($LargeFiles.Count) files larger than 10MB" "Warning"
        } else {
            Write-ValidationResult "No excessively large files found" "Success"
        }
    }
    catch {
        Write-ValidationResult "Could not check file sizes" "Warning"
    }
} else {
    Write-ValidationResult "Git repository not initialized" "Error"
}
Write-Host ""

# 5. Final summary
Write-Host "Cleanup Summary" -ForegroundColor Green
Write-Host "===============" -ForegroundColor Green

if ($ErrorCount -eq 0 -and $WarningCount -eq 0) {
    Write-Host "SUCCESS: Repository is ready for commit!" -ForegroundColor Green
} elseif ($ErrorCount -eq 0) {
    Write-Host "WARNING: Repository has minor issues but is ready" -ForegroundColor Yellow
    Write-Host "   $WarningCount warnings found" -ForegroundColor Yellow
} else {
    Write-Host "ERROR: Repository has issues that should be addressed" -ForegroundColor Red
    Write-Host "   $ErrorCount errors and $WarningCount warnings found" -ForegroundColor Red
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "   1. Review any errors or warnings above" -ForegroundColor Cyan
Write-Host "   2. Run: git add ." -ForegroundColor Cyan
Write-Host "   3. Run: git commit -m 'message'" -ForegroundColor Cyan
Write-Host "   4. Add remote: git remote add origin https://github.com/KCoderVA/Telehealth-Scheduling-App.git" -ForegroundColor Cyan
Write-Host "   5. Push: git push -u origin master" -ForegroundColor Cyan

Write-Host ""
Write-Host "Completed: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
