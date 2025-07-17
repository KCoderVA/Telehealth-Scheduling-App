# PowerApps HTML Preview File Deletion Service
# Runs in background to monitor and process file deletion requests

param(
    [Parameter(Mandatory=$false)]
    [switch]$StartService,

    [Parameter(Mandatory=$false)]
    [switch]$StopService,

    [Parameter(Mandatory=$false)]
    [string]$DeleteFile
)

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PreviewsDir = Join-Path $ScriptDir "generated_previews"
$TriggerDir = Join-Path $ScriptDir ".triggers"
$ServicePid = Join-Path $ScriptDir ".deletion_service.pid"

# Ensure directories exist
if (!(Test-Path $PreviewsDir)) { New-Item -ItemType Directory -Path $PreviewsDir -Force | Out-Null }
if (!(Test-Path $TriggerDir)) { New-Item -ItemType Directory -Path $TriggerDir -Force | Out-Null }

function Write-ServiceLog {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] [$Level] $Message"
    if ($Level -eq "ERROR") {
        Write-Host $LogEntry -ForegroundColor Red
    } elseif ($Level -eq "SUCCESS") {
        Write-Host $LogEntry -ForegroundColor Green
    } else {
        Write-Host $LogEntry -ForegroundColor Gray
    }
}

function Start-DeletionMonitor {
    Write-ServiceLog "Starting PowerApps HTML Preview Deletion Service..."

    # Create service PID file
    $PID | Out-File -FilePath $ServicePid -Force

    # Main monitoring loop
    try {
        while ($true) {
            # Check for trigger files
            $TriggerFiles = Get-ChildItem -Path $TriggerDir -Filter "*.delete" -ErrorAction SilentlyContinue

            foreach ($TriggerFile in $TriggerFiles) {
                try {
                    $Content = Get-Content -Path $TriggerFile.FullName -Raw -ErrorAction Stop

                    # Parse trigger content: DELETE_REQUEST|filename|timestamp
                    if ($Content -match "^DELETE_REQUEST\|(.+)\|(\d+)$") {
                        $TargetFile = $Matches[1]
                        $RequestTime = $Matches[2]

                        Write-ServiceLog "Processing deletion request for: $TargetFile"

                        # Construct full path
                        $FullPath = Join-Path $PreviewsDir $TargetFile

                        if (Test-Path $FullPath) {
                            # Move to recycle bin
                            Add-Type -AssemblyName Microsoft.VisualBasic
                            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($FullPath, 'OnlyErrorDialogs', 'SendToRecycleBin')
                            Write-ServiceLog "Successfully deleted: $TargetFile" "SUCCESS"
                        } else {
                            Write-ServiceLog "File not found: $TargetFile" "ERROR"
                        }

                        # Remove trigger file
                        Remove-Item -Path $TriggerFile.FullName -Force -ErrorAction SilentlyContinue
                    }
                } catch {
                    Write-ServiceLog "Error processing trigger file $($TriggerFile.Name): $($_.Exception.Message)" "ERROR"
                    # Remove problematic trigger file
                    Remove-Item -Path $TriggerFile.FullName -Force -ErrorAction SilentlyContinue
                }
            }

            # Sleep before next check
            Start-Sleep -Milliseconds 500
        }
    } catch {
        Write-ServiceLog "Service error: $($_.Exception.Message)" "ERROR"
    } finally {
        # Cleanup PID file
        if (Test-Path $ServicePid) {
            Remove-Item -Path $ServicePid -Force -ErrorAction SilentlyContinue
        }
    }
}

function Stop-DeletionService {
    if (Test-Path $ServicePid) {
        try {
            $ServiceProcessId = Get-Content -Path $ServicePid -ErrorAction Stop
            $Process = Get-Process -Id $ServiceProcessId -ErrorAction SilentlyContinue
            if ($Process) {
                $Process.Kill()
                Write-ServiceLog "Stopped deletion service (PID: $ServiceProcessId)" "SUCCESS"
            }
            Remove-Item -Path $ServicePid -Force -ErrorAction SilentlyContinue
        } catch {
            Write-ServiceLog "Error stopping service: $($_.Exception.Message)" "ERROR"
        }
    } else {
        Write-ServiceLog "No deletion service found running"
    }
}

function Remove-PreviewFile {
    param([string]$FileName)

    if (!$FileName) {
        Write-ServiceLog "No filename provided for deletion" "ERROR"
        return
    }

    $FullPath = Join-Path $PreviewsDir $FileName

    if (Test-Path $FullPath) {
        try {
            Add-Type -AssemblyName Microsoft.VisualBasic
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($FullPath, 'OnlyErrorDialogs', 'SendToRecycleBin')
            Write-ServiceLog "Successfully deleted: $FileName" "SUCCESS"
        } catch {
            Write-ServiceLog "Error deleting file $FileName : $($_.Exception.Message)" "ERROR"
        }
    } else {
        Write-ServiceLog "File not found: $FileName" "ERROR"
    }
}

# Main execution logic
if ($StopService) {
    Stop-DeletionService
} elseif ($DeleteFile) {
    Remove-PreviewFile -FileName $DeleteFile
} elseif ($StartService) {
    Start-DeletionMonitor
} else {
    # Default: Start the service
    Write-ServiceLog "🔧 Starting deletion service for one-click file deletion..."
    Start-DeletionMonitor
}
