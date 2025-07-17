# PowerApps HTML Previewer - Simple GUI Launcher
Add-Type -AssemblyName System.Windows.Forms

Write-Host "PowerApps HTML Previewer - GUI Launcher" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

# Show welcome message
[System.Windows.Forms.MessageBox]::Show("Welcome to PowerApps HTML Previewer!`n`nClick OK to select a PowerApps JSON file.", "PowerApps HTML Previewer", "OK", "Information")

# Create file picker
Write-Host "Opening file picker dialog..." -ForegroundColor Cyan
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.Title = "Select PowerApps JSON File"
$OpenFileDialog.Filter = "JSON files (*.json)|*.json|All files (*.*)|*.*"
$OpenFileDialog.FilterIndex = 1
$OpenFileDialog.Multiselect = $false

# Show dialog
$result = $OpenFileDialog.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    Write-Host "Selected file: $($OpenFileDialog.FileName)" -ForegroundColor Green

    # Call converter
    $ConverterScript = Join-Path $PSScriptRoot "PowerApps-Converter.ps1"
    try {
        & $ConverterScript -InputFile $OpenFileDialog.FileName
        [System.Windows.Forms.MessageBox]::Show("HTML preview generated successfully!", "Success", "OK", "Information")
        exit 0
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error generating preview: $($_.Exception.Message)", "Error", "OK", "Error")
        exit 1
    }
} else {
    Write-Host "No file selected" -ForegroundColor Yellow
    exit 1
}
