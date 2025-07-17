# PowerApps HTML Preview - One-Click Delete Utility
# Safely deletes a preview file by moving it to the recycle bin

param(
    [Parameter(Mandatory=$true)]
    [string]$FileName
)

# Get script directory and preview directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PreviewsDir = Join-Path $ScriptDir "generated_previews"

function Write-DeleteLog {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    if ($Level -eq "ERROR") {
        Write-Host "[$Timestamp] ❌ $Message" -ForegroundColor Red
    } elseif ($Level -eq "SUCCESS") {
        Write-Host "[$Timestamp] ✅ $Message" -ForegroundColor Green
    } else {
        Write-Host "[$Timestamp] ℹ️ $Message" -ForegroundColor Gray
    }
}

# Display header
Write-Host ""
Write-Host "🗑️ PowerApps One-Click File Deletion" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Validate input
if ([string]::IsNullOrWhiteSpace($FileName)) {
    Write-DeleteLog "No filename provided for deletion" "ERROR"
    exit 1
}

# Construct full file path
$FullPath = Join-Path $PreviewsDir $FileName

# Check if file exists
if (!(Test-Path $FullPath)) {
    Write-DeleteLog "File not found: $FileName" "ERROR"
    Write-DeleteLog "Path checked: $FullPath" "INFO"
    exit 1
}

try {
    # Load the Microsoft.VisualBasic assembly for recycle bin functionality
    Add-Type -AssemblyName Microsoft.VisualBasic

    # Move file to recycle bin
    [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($FullPath, 'OnlyErrorDialogs', 'SendToRecycleBin')

    # Success message
    Write-DeleteLog "SUCCESS: File deleted and sent to recycle bin!" "SUCCESS"
    Write-Host ""
    Write-Host "File: $FileName" -ForegroundColor Yellow
    Write-Host "Location: $PreviewsDir" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "💡 The file has been moved to your recycle bin and can be recovered if needed." -ForegroundColor Gray

} catch {
    Write-DeleteLog "Failed to delete file: $($_.Exception.Message)" "ERROR"
    Write-Host ""
    Write-Host "💡 You may need to close the file if it's open in a browser or editor." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
