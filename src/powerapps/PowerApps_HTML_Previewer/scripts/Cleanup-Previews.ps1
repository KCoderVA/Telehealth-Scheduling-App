# PowerApps HTML Preview Cleanup Utility
# Automatically deletes preview files and provides management options

param(
    [Parameter(Mandatory=$false)]
    [string]$SpecificFile,

    [Parameter(Mandatory=$false)]
    [switch]$CleanupOld,

    [Parameter(Mandatory=$false)]
    [int]$DaysOld = 7,

    [Parameter(Mandatory=$false)]
    [switch]$Interactive
)

# Get the directory where this script is located
$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$PreviewsDir = Join-Path $ScriptDirectory "generated_previews"

function Show-Header {
    Write-Host "🗑️ PowerApps HTML Preview Cleanup Utility" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Gray
}

function Remove-SpecificFile {
    param([string]$FileName)

    $FilePath = Join-Path $PreviewsDir $FileName

    if (Test-Path $FilePath) {
        try {
            Remove-Item $FilePath -Force
            Write-Host "✅ Deleted: $FileName" -ForegroundColor Green
            return $true
        } catch {
            Write-Host "❌ Error deleting $FileName : $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "⚠️ File not found: $FileName" -ForegroundColor Yellow
        return $false
    }
}

function Remove-OldFiles {
    param([int]$Days)

    $CutoffDate = (Get-Date).AddDays(-$Days)
    $HtmlFiles = Get-ChildItem -Path $PreviewsDir -Filter "*.html" | Where-Object { $_.LastWriteTime -lt $CutoffDate }

    if ($HtmlFiles.Count -eq 0) {
        Write-Host "📁 No files older than $Days days found." -ForegroundColor Green
        return
    }

    Write-Host "🔍 Found $($HtmlFiles.Count) files older than $Days days:" -ForegroundColor Yellow
    $HtmlFiles | ForEach-Object { Write-Host "  - $($_.Name) ($(($_.LastWriteTime).ToString('yyyy-MM-dd')))" -ForegroundColor Gray }

    if ($Interactive) {
        $Confirm = Read-Host "`nDelete these files? [y/N]"
        if ($Confirm -notmatch '^[Yy]') {
            Write-Host "❌ Cleanup cancelled." -ForegroundColor Yellow
            return
        }
    }

    $DeletedCount = 0
    foreach ($File in $HtmlFiles) {
        try {
            Remove-Item $File.FullName -Force
            Write-Host "✅ Deleted: $($File.Name)" -ForegroundColor Green
            $DeletedCount++
        } catch {
            Write-Host "❌ Error deleting $($File.Name): $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    Write-Host "`n📊 Cleanup Summary: $DeletedCount/$($HtmlFiles.Count) files deleted." -ForegroundColor Cyan
}

function Show-InteractiveMenu {
    Show-Header

    if (!(Test-Path $PreviewsDir)) {
        Write-Host "❌ Preview directory not found: $PreviewsDir" -ForegroundColor Red
        return
    }

    $HtmlFiles = Get-ChildItem -Path $PreviewsDir -Filter "*.html"

    if ($HtmlFiles.Count -eq 0) {
        Write-Host "📁 No HTML preview files found." -ForegroundColor Green
        return
    }

    Write-Host "`n📋 Available HTML Preview Files:" -ForegroundColor White
    for ($i = 0; $i -lt $HtmlFiles.Count; $i++) {
        $File = $HtmlFiles[$i]
        $Size = [math]::Round($File.Length / 1KB, 1)
        Write-Host "  [$($i+1)] $($File.Name) (${Size}KB, $($File.LastWriteTime.ToString('yyyy-MM-dd HH:mm')))" -ForegroundColor Gray
    }

    Write-Host "`n🔧 Options:" -ForegroundColor White
    Write-Host "  [A] Delete ALL preview files" -ForegroundColor Yellow
    Write-Host "  [O] Delete files older than 7 days" -ForegroundColor Yellow
    Write-Host "  [Q] Quit" -ForegroundColor Gray

    $Choice = Read-Host "`nEnter your choice (number, A, O, or Q)"

    switch ($Choice.ToUpper()) {
        'A' {
            $Confirm = Read-Host "⚠️ Delete ALL $($HtmlFiles.Count) preview files? [y/N]"
            if ($Confirm -match '^[Yy]') {
                $DeletedCount = 0
                foreach ($File in $HtmlFiles) {
                    try {
                        Remove-Item $File.FullName -Force
                        Write-Host "✅ Deleted: $($File.Name)" -ForegroundColor Green
                        $DeletedCount++
                    } catch {
                        Write-Host "❌ Error deleting $($File.Name): $($_.Exception.Message)" -ForegroundColor Red
                    }
                }
                Write-Host "`n📊 Deleted $DeletedCount/$($HtmlFiles.Count) files." -ForegroundColor Cyan
            } else {
                Write-Host "❌ Operation cancelled." -ForegroundColor Yellow
            }
        }
        'O' {
            Remove-OldFiles -Days 7
        }
        'Q' {
            Write-Host "👋 Goodbye!" -ForegroundColor Green
        }
        default {
            try {
                $Index = [int]$Choice - 1
                if ($Index -ge 0 -and $Index -lt $HtmlFiles.Count) {
                    $FileToDelete = $HtmlFiles[$Index]
                    $Confirm = Read-Host "Delete '$($FileToDelete.Name)'? [y/N]"
                    if ($Confirm -match '^[Yy]') {
                        Remove-SpecificFile -FileName $FileToDelete.Name
                    } else {
                        Write-Host "❌ Deletion cancelled." -ForegroundColor Yellow
                    }
                } else {
                    Write-Host "❌ Invalid selection." -ForegroundColor Red
                }
            } catch {
                Write-Host "❌ Invalid input. Please enter a number, A, O, or Q." -ForegroundColor Red
            }
        }
    }
}

# Main execution
if (!(Test-Path $PreviewsDir)) {
    Write-Host "❌ Generated previews directory not found: $PreviewsDir" -ForegroundColor Red
    exit 1
}

Show-Header

if ($SpecificFile) {
    Write-Host "🎯 Deleting specific file: $SpecificFile" -ForegroundColor Yellow
    $Success = Remove-SpecificFile -FileName $SpecificFile
    if ($Success) {
        Write-Host "✅ File deletion completed!" -ForegroundColor Green
    }
    exit ($Success ? 0 : 1)
}

if ($CleanupOld) {
    Write-Host "🧹 Cleaning up files older than $DaysOld days..." -ForegroundColor Yellow
    Remove-OldFiles -Days $DaysOld
    exit 0
}

if ($Interactive -or (!$SpecificFile -and !$CleanupOld)) {
    Show-InteractiveMenu
} else {
    Write-Host "Usage:" -ForegroundColor White
    Write-Host "  .\Cleanup-Previews.ps1                    # Interactive menu" -ForegroundColor Gray
    Write-Host "  .\Cleanup-Previews.ps1 -SpecificFile 'file.html'  # Delete specific file" -ForegroundColor Gray
    Write-Host "  .\Cleanup-Previews.ps1 -CleanupOld -DaysOld 7      # Delete files older than 7 days" -ForegroundColor Gray
}
