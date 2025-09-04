# PowerShell Profile Optimization for Telehealth Project
# Copyright 2025 Kyle J. Coder - Telehealth Resources Project
# Licensed under the Apache License, Version 2.0
# Save this to your PowerShell profile for enhanced productivity

#Requires -Version 5.1

[CmdletBinding()]
param()

# Set strict mode for better error handling
Set-StrictMode -Version Latest

# Function to quickly navigate to project directory
function Set-TelehealthLocation {
    <#
    .SYNOPSIS
        Navigate to the Telehealth Project directory
    .DESCRIPTION
        Quickly changes location to the main project directory and displays status
    .EXAMPLE
        tele
        # Navigates to project directory and shows git status
    #>
    [CmdletBinding()]
    param()

    try {
        $ProjectPath = "s:\Informatics\Data Team\Coder - Informatics\App Programing\Telehealth Schedule & Booking"
        if (Test-Path $ProjectPath) {
            Set-Location $ProjectPath
            Write-Host "📍 Telehealth Project Directory" -ForegroundColor Green

            # Show git status if available
            if (Get-Command git -ErrorAction SilentlyContinue) {
                Write-Host "Git Status:" -ForegroundColor Yellow
                git status --porcelain --branch | Select-Object -First 5
            }
        } else {
            Write-Warning "Project directory not found: $ProjectPath"
        }
    }
    catch {
        Write-Error "Failed to navigate to project directory: $_"
    }
}

# Create alias for convenience
Set-Alias -Name tele -Value Set-TelehealthLocation

# Function to open all Power Platform tools
function Start-PowerPlatformTools {
    <#
    .SYNOPSIS
        Open all Power Platform development tools
    .DESCRIPTION
        Opens PowerApps Studio, Power Automate, SharePoint Admin, and Power Platform Admin Center
    .PARAMETER IncludeAdmin
        Include admin tools (default: true)
    .EXAMPLE
        Start-PowerPlatformTools
        # Opens all Power Platform tools
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch]$IncludeAdmin = $true
    )

    try {
        Write-Host "🚀 Opening Power Platform Tools..." -ForegroundColor Yellow

        # Core development tools
        $Tools = @(
            @{ Name = "PowerApps Studio"; Url = "https://make.powerapps.com/" },
            @{ Name = "Power Automate"; Url = "https://make.powerautomate.com/" }
        )

        # Add admin tools if requested
        if ($IncludeAdmin) {
            $Tools += @(
                @{ Name = "SharePoint Admin"; Url = "https://admin.microsoft.com/sharepoint" },
                @{ Name = "Power Platform Admin"; Url = "https://admin.powerplatform.microsoft.com/" }
            )
        }

        foreach ($Tool in $Tools) {
            Write-Verbose "Opening $($Tool.Name)..."
            Start-Process $Tool.Url
            Start-Sleep -Milliseconds 500  # Prevent browser overload
        }

        Write-Host "✅ All tools opened!" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to open Power Platform tools: $_"
    }
}

# Create alias for convenience
Set-Alias -Name open-powerplatform -Value Start-PowerPlatformTools

# Function for enhanced git operations
function Invoke-GitQuickCommit {
    <#
    .SYNOPSIS
        Perform quick git add, commit, and optional push
    .DESCRIPTION
        Streamlined git workflow for rapid development cycles with proper error handling
    .PARAMETER Message
        Commit message (required)
    .PARAMETER Push
        Also push to remote after commit
    .PARAMETER All
        Add all files including untracked (default: only tracked files)
    .EXAMPLE
        Invoke-GitQuickCommit -Message "Update PowerApps screen layout"
        # Commits tracked changes with message
    .EXAMPLE
        git-quick "Fix booking validation" -Push -All
        # Commits all changes, includes untracked files, and pushes to remote
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [Parameter()]
        [switch]$Push,

        [Parameter()]
        [switch]$All
    )

    try {
        # Verify we're in a git repository
        if (-not (Test-Path .git)) {
            throw "Not in a git repository. Run 'git init' first."
        }

        # Add files based on parameter
        if ($All) {
            Write-Verbose "Adding all files (including untracked)..."
            git add .
        } else {
            Write-Verbose "Adding tracked files only..."
            git add -u
        }

        # Check if there are changes to commit
        $Status = git status --porcelain
        if (-not $Status) {
            Write-Warning "No changes to commit"
            return
        }

        # Commit changes
        Write-Verbose "Committing changes with message: $Message"
        git commit -m $Message

        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Changes committed: $Message" -ForegroundColor Green

            # Push if requested
            if ($Push) {
                Write-Verbose "Pushing to remote..."
                git push
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "✅ Changes pushed to remote" -ForegroundColor Green
                } else {
                    Write-Warning "Commit successful, but push failed. Check remote connection."
                }
            }
        } else {
            throw "Git commit failed"
        }
    }
    catch {
        Write-Error "Git operation failed: $_"
    }
}

# Create aliases for convenience
Set-Alias -Name git-quick -Value Invoke-GitQuickCommit

# Function to create enhanced project backup
function New-TelehealthBackup {
    <#
    .SYNOPSIS
        Create comprehensive project backup
    .DESCRIPTION
        Creates timestamped ZIP backup of essential project files with exclusions for temp files
    .PARAMETER IncludeLogs
        Include log files in backup (default: false)
    .PARAMETER BackupPath
        Custom backup directory (default: .\backups)
    .EXAMPLE
        New-TelehealthBackup
        # Creates standard backup in .\backups directory
    .EXAMPLE
        backup-project -IncludeLogs -BackupPath "\\server\backups"
        # Creates backup with logs in network location
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch]$IncludeLogs,

        [Parameter()]
        [string]$BackupPath = ".\backups"
    )

    try {
        # Ensure backup directory exists
        if (-not (Test-Path $BackupPath)) {
            Write-Verbose "Creating backup directory: $BackupPath"
            New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
        }

        # Generate timestamp for unique filename
        $Timestamp = Get-Date -Format "yyyy-MM-dd-HHmm"
        $BackupFileName = "TelehealthProject-$Timestamp.zip"
        $FullBackupPath = Join-Path $BackupPath $BackupFileName

        # Define items to include in backup
        $BackupItems = @(
            '.\src',
            '.\docs',
            '.\data',
            '.\legacy',
            '.\README.md',
            '.\CHANGELOG.md',
            '.\CONTRIBUTING.md',
            '.\SECURITY.md',
            '.\LICENSE',
            '.\.github',
            '.\.vscode\tasks.json',
            '.\Telehealth Resources Project.code-workspace'
        )

        # Add logs if requested
        if ($IncludeLogs) {
            $BackupItems += '.\logs'
        }

        # Filter to only existing items
        $ExistingItems = $BackupItems | Where-Object { Test-Path $_ }

        if ($ExistingItems.Count -eq 0) {
            throw "No backup items found. Check project structure."
        }

        Write-Host "📦 Creating backup: $BackupFileName" -ForegroundColor Yellow
        Write-Verbose "Backup location: $FullBackupPath"
        Write-Verbose "Items to backup: $($ExistingItems.Count)"

        # Create the backup
        Compress-Archive -Path $ExistingItems -DestinationPath $FullBackupPath -Force

        # Verify backup was created
        if (Test-Path $FullBackupPath) {
            $BackupSize = (Get-Item $FullBackupPath).Length / 1MB
            Write-Host "✅ Backup created successfully!" -ForegroundColor Green
            Write-Host "   File: $BackupFileName" -ForegroundColor Cyan
            Write-Host "   Size: $($BackupSize.ToString('F2')) MB" -ForegroundColor Cyan
            Write-Host "   Location: $BackupPath" -ForegroundColor Cyan
        } else {
            throw "Backup file was not created"
        }
    }
    catch {
        Write-Error "Failed to create backup: $_"
    }
}

# Function for comprehensive project status
function Get-TelehealthProjectStatus {
    <#
    .SYNOPSIS
        Display comprehensive project status information
    .DESCRIPTION
        Shows git status, recent activity, file counts, and project health indicators
    .PARAMETER Detailed
        Show detailed file analysis and structure
    .EXAMPLE
        Get-TelehealthProjectStatus
        # Shows basic project status
    .EXAMPLE
        project-status -Detailed
        # Shows detailed project analysis
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch]$Detailed
    )

    try {
        Write-Host "`n=== Telehealth Project Status ===" -ForegroundColor Green
        Write-Host "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray

        # Git status section
        if (Get-Command git -ErrorAction SilentlyContinue) {
            Write-Host "`n📊 Git Repository Status:" -ForegroundColor Yellow

            # Current branch
            $CurrentBranch = git branch --show-current
            Write-Host "   Branch: $CurrentBranch" -ForegroundColor Cyan

            # Uncommitted changes
            $GitStatus = git status --porcelain
            if ($GitStatus) {
                Write-Host "   Uncommitted changes: $($GitStatus.Count) files" -ForegroundColor Red
                $GitStatus | Select-Object -First 5 | ForEach-Object {
                    Write-Host "     $_" -ForegroundColor Gray
                }
                if ($GitStatus.Count -gt 5) {
                    Write-Host "     ... and $($GitStatus.Count - 5) more" -ForegroundColor Gray
                }
            } else {
                Write-Host "   Working directory clean ✅" -ForegroundColor Green
            }

            # Recent commits
            Write-Host "`n� Recent Commits:" -ForegroundColor Yellow
            git log --oneline -5 | ForEach-Object {
                Write-Host "   $_" -ForegroundColor Gray
            }
        } else {
            Write-Host "`n⚠️  Git not available" -ForegroundColor Red
        }

        # Project structure overview
        Write-Host "`n📁 Project Structure:" -ForegroundColor Yellow
        $MainDirs = @('src', 'docs', 'data', 'legacy', '.github', '.vscode')
        foreach ($Dir in $MainDirs) {
            if (Test-Path $Dir) {
                $FileCount = (Get-ChildItem $Dir -Recurse -File).Count
                Write-Host "   $Dir/: $FileCount files ✅" -ForegroundColor Green
            } else {
                Write-Host "   $Dir/: Missing ❌" -ForegroundColor Red
            }
        }

        # File counts and sizes
        if ($Detailed) {
            Write-Host "`n📈 Detailed Analysis:" -ForegroundColor Yellow

            # PowerApps files
            $PowerAppsFiles = Get-ChildItem -Path ".\src\powerapps" -Recurse -File -ErrorAction SilentlyContinue
            if ($PowerAppsFiles) {
                Write-Host "   PowerApps Components: $($PowerAppsFiles.Count) files" -ForegroundColor Cyan
            }

            # Documentation files
            $DocFiles = Get-ChildItem -Path ".\docs" -Include "*.md" -Recurse -ErrorAction SilentlyContinue
            if ($DocFiles) {
                Write-Host "   Documentation: $($DocFiles.Count) markdown files" -ForegroundColor Cyan
            }

            # Data files
            $DataFiles = Get-ChildItem -Path ".\data" -File -ErrorAction SilentlyContinue
            if ($DataFiles) {
                $DataSize = ($DataFiles | Measure-Object -Property Length -Sum).Sum / 1MB
                Write-Host "   Data Files: $($DataFiles.Count) files ($($DataSize.ToString('F2')) MB)" -ForegroundColor Cyan
            }
        }

        # Health indicators
        Write-Host "`n🏥 Project Health:" -ForegroundColor Yellow
        $HealthChecks = @(
            @{ Name = "README.md"; Path = ".\README.md" },
            @{ Name = "CHANGELOG.md"; Path = ".\CHANGELOG.md" },
            @{ Name = "LICENSE"; Path = ".\LICENSE" },
            @{ Name = "VS Code Workspace"; Path = ".\Telehealth Resources Project.code-workspace" },
            @{ Name = "Git Repository"; Path = ".\.git" }
        )

        foreach ($Check in $HealthChecks) {
            if (Test-Path $Check.Path) {
                Write-Host "   $($Check.Name): ✅" -ForegroundColor Green
            } else {
                Write-Host "   $($Check.Name): ❌" -ForegroundColor Red
            }
        }

        Write-Host "`n" # Final spacing
    }
    catch {
        Write-Error "Failed to get project status: $_"
    }
}

# Function to clean temporary files with better error handling
function Remove-TelehealthTempFiles {
    <#
    .SYNOPSIS
        Clean temporary files from the project
    .DESCRIPTION
        Removes various temporary files created during development
    .EXAMPLE
        Remove-TelehealthTempFiles
        # Cleans all temporary files
    #>
    [CmdletBinding()]
    param()

    try {
        $TempPatterns = @(
            "~$*",
            "*.tmp",
            "*.temp",
            "*.bak",
            "*.backup",
            "*_preview.html",
            "*_preview_*.html"
        )

        Write-Host "🧹 Cleaning temporary files..." -ForegroundColor Yellow

        $RemovedCount = 0
        foreach ($Pattern in $TempPatterns) {
            $Files = Get-ChildItem -Path . -Recurse -Include $Pattern -ErrorAction SilentlyContinue
            foreach ($File in $Files) {
                try {
                    Remove-Item $File.FullName -Force
                    $RemovedCount++
                    Write-Verbose "Removed: $($File.Name)"
                }
                catch {
                    Write-Warning "Could not remove: $($File.Name) - $_"
                }
            }
        }

        Write-Host "✅ Cleaned $RemovedCount temporary files!" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to clean temporary files: $_"
    }
}

# Enhanced prompt for project directory
function prompt {
    $CurrentPath = (Get-Location).Path
    if ($CurrentPath -like "*Telehealth Schedule & Booking*") {
        Write-Host "🏥 " -NoNewline -ForegroundColor Green
        Write-Host "Telehealth " -NoNewline -ForegroundColor White
        Write-Host "$(Split-Path -Leaf $CurrentPath) " -NoNewline -ForegroundColor Cyan
        Write-Host ">" -NoNewline -ForegroundColor Yellow
        return " "
    }
    return "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}

# Create all aliases for convenience
Set-Alias -Name project-status -Value Get-TelehealthProjectStatus
Set-Alias -Name clean-temp -Value Remove-TelehealthTempFiles
Set-Alias -Name pp -Value Start-PowerPlatformTools
Set-Alias -Name gq -Value Invoke-GitQuickCommit
Set-Alias -Name ps -Value Get-TelehealthProjectStatus
Set-Alias -Name bp -Value New-TelehealthBackup
Set-Alias -Name ct -Value Remove-TelehealthTempFiles

# Display welcome message when profile loads
Write-Host "`n🏥 Telehealth Project PowerShell Profile Loaded" -ForegroundColor Green
Write-Host "Available commands:" -ForegroundColor Yellow
Write-Host "  tele              - Navigate to project directory" -ForegroundColor Cyan
Write-Host "  pp                - Open Power Platform tools" -ForegroundColor Cyan
Write-Host "  gq 'message'      - Quick git commit" -ForegroundColor Cyan
Write-Host "  bp                - Create project backup" -ForegroundColor Cyan
Write-Host "  ps                - Show project status" -ForegroundColor Cyan
Write-Host "  ct                - Clean temporary files" -ForegroundColor Cyan
Write-Host ""
