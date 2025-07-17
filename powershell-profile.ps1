# PowerShell Profile Optimization for Telehealth Project
# Save this to your PowerShell profile for enhanced productivity

# Function to quickly navigate to project directory
function tele {
    Set-Location "s:\Informatics\Data Team\Coder - Informatics\App Programing\Telehealth Schedule & Booking"
    Write-Host "📍 Telehealth Project Directory" -ForegroundColor Green
}

# Function to open all Power Platform tools
function open-powerplatform {
    Write-Host "🚀 Opening Power Platform Tools..." -ForegroundColor Yellow
    Start-Process "https://make.powerapps.com/"
    Start-Process "https://make.powerautomate.com/"
    Start-Process "https://admin.microsoft.com/sharepoint"
    Start-Process "https://admin.powerplatform.microsoft.com/"
    Write-Host "✅ All tools opened!" -ForegroundColor Green
}

# Function for quick git operations
function git-quick($message = "Quick save") {
    git add .
    git commit -m $message
    Write-Host "✅ Changes committed: $message" -ForegroundColor Green
}

# Function to create project backup
function backup-project {
    $timestamp = Get-Date -Format "yyyy-MM-dd-HHmm"
    $backupPath = ".\backups\TelehealthProject-$timestamp.zip"

    if (!(Test-Path ".\backups")) {
        New-Item -ItemType Directory -Path ".\backups" | Out-Null
    }

    Compress-Archive -Path @(".\src", ".\docs", ".\data", ".\legacy", ".\README.md", ".\CHANGELOG.md", ".\LICENSE", ".\.github") -DestinationPath $backupPath -Force
    Write-Host "✅ Backup created: $backupPath" -ForegroundColor Green
}

# Function to check project status
function project-status {
    Write-Host "=== Telehealth Project Status ===" -ForegroundColor Cyan
    Write-Host "📂 Current Directory: $(Get-Location)" -ForegroundColor Yellow
    Write-Host "🔀 Git Status:" -ForegroundColor Yellow
    git status --short
    Write-Host "📊 Recent Commits:" -ForegroundColor Yellow
    git log --oneline -5
    Write-Host "📁 Project Structure:" -ForegroundColor Yellow
    Get-ChildItem -Directory | Format-Table Name, LastWriteTime
}

# Function to clean temporary files
function clean-temp {
    Get-ChildItem -Path . -Recurse -Include "~$*", "*.tmp", "*.temp", "*.bak" | Remove-Item -Force -ErrorAction SilentlyContinue
    Write-Host "🧹 Temporary files cleaned!" -ForegroundColor Green
}

# Set aliases for common operations
Set-Alias -Name pp -Value open-powerplatform
Set-Alias -Name gq -Value git-quick
Set-Alias -Name ps -Value project-status
Set-Alias -Name bp -Value backup-project
Set-Alias -Name ct -Value clean-temp

# Enhanced prompt for project directory
function prompt {
    $currentPath = (Get-Location).Path
    if ($currentPath -like "*Telehealth Schedule & Booking*") {
        Write-Host "🏥 Telehealth " -NoNewline -ForegroundColor Green
        Write-Host "$(Split-Path -Leaf $currentPath) " -NoNewline -ForegroundColor White
        Write-Host ">" -NoNewline -ForegroundColor Yellow
        return " "
    }
    return "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}

Write-Host "🔧 Telehealth Project PowerShell Profile Loaded!" -ForegroundColor Green
Write-Host "📝 Available commands: tele, pp, gq, ps, bp, ct" -ForegroundColor Cyan
