# PowerApps Screen to HTML Preview Generator
# Usage: .\Generate-ScreenPreview.ps1 -ScreenName "DeskSelect" -OutputDir "previews"

param(
    [Parameter(Mandatory=$true)]
    [string]$ScreenName,

    [Parameter(Mandatory=$false)]
    [string]$OutputDir = "previews",

    [Parameter(Mandatory=$false)]
    [string]$ScreensDir = "screens"
)

# Create output directory if it doesn't exist
if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    Write-Host "Created output directory: $OutputDir" -ForegroundColor Green
}

# Find the screen JSON file
$screenFile = Join-Path $ScreensDir "$ScreenName.json"
if (!(Test-Path $screenFile)) {
    Write-Error "Screen file not found: $screenFile"
    exit 1
}

Write-Host "Processing screen: $ScreenName" -ForegroundColor Cyan
Write-Host "Reading from: $screenFile" -ForegroundColor Gray

# Read the screen JSON
try {
    $screenJson = Get-Content $screenFile -Raw | ConvertFrom-Json
    Write-Host "✓ Successfully parsed JSON" -ForegroundColor Green
} catch {
    Write-Error "Failed to parse JSON: $_"
    exit 1
}

# Generate JavaScript code to convert the screen
$jsCode = @"
// Load the converter
const fs = require('fs');
const path = require('path');

// Read the converter class
const converterCode = fs.readFileSync('screen-to-html-converter.js', 'utf8');
eval(converterCode);

// Read the screen JSON
const screenJson = JSON.parse(fs.readFileSync('$($screenFile.Replace('\', '\\'))', 'utf8'));

// Convert to HTML
const converter = new PowerAppsToHtmlConverter();
const html = converter.convertScreenToHtml(screenJson);

// Output the HTML
console.log(html);
"@

# Write temporary JavaScript file
$tempJsFile = "temp_convert_$ScreenName.js"
$jsCode | Out-File -FilePath $tempJsFile -Encoding UTF8

try {
    # Check if Node.js is available
    $nodeCheck = Get-Command node -ErrorAction SilentlyContinue
    if ($nodeCheck) {
        Write-Host "Using Node.js to generate HTML..." -ForegroundColor Yellow
        $html = node $tempJsFile

        if ($LASTEXITCODE -eq 0) {
            # Save the HTML file
            $outputFile = Join-Path $OutputDir "$ScreenName.html"
            $html | Out-File -FilePath $outputFile -Encoding UTF8
            Write-Host "✓ Generated HTML preview: $outputFile" -ForegroundColor Green

            # Try to open in default browser
            $openBrowser = Read-Host "Open preview in browser? (y/n)"
            if ($openBrowser -eq 'y' -or $openBrowser -eq 'Y') {
                Start-Process (Resolve-Path $outputFile)
            }
        } else {
            Write-Error "Node.js execution failed"
        }
    } else {
        Write-Warning "Node.js not found. Generating basic HTML without JavaScript processing..."

        # Fallback: Generate a simpler HTML preview using PowerShell
        $basicHtml = Generate-BasicHtmlPreview -ScreenJson $screenJson -ScreenName $ScreenName
        $outputFile = Join-Path $OutputDir "$ScreenName.html"
        $basicHtml | Out-File -FilePath $outputFile -Encoding UTF8
        Write-Host "✓ Generated basic HTML preview: $outputFile" -ForegroundColor Green
    }
} finally {
    # Clean up temporary file
    if (Test-Path $tempJsFile) {
        Remove-Item $tempJsFile -Force
    }
}

function Generate-BasicHtmlPreview {
    param($ScreenJson, $ScreenName)

    $controls = @()

    # Extract basic control information
    if ($ScreenJson.TopParent.Children) {
        foreach ($control in $ScreenJson.TopParent.Children) {
            $controlInfo = @{
                Name = $control.Name
                Type = $control.Template.Name
                Properties = @{}
            }

            if ($control.Rules) {
                foreach ($rule in $control.Rules) {
                    if ($rule.Property -and $rule.InvariantScript) {
                        $controlInfo.Properties[$rule.Property] = $rule.InvariantScript
                    }
                }
            }

            $controls += $controlInfo
        }
    }

    # Generate basic HTML structure
    $htmlBody = ""
    foreach ($control in $controls) {
        $x = $control.Properties['X'] -replace '"', '' -replace '[^0-9]', ''
        $y = $control.Properties['Y'] -replace '"', '' -replace '[^0-9]', ''
        $width = $control.Properties['Width'] -replace '"', '' -replace '[^0-9]', ''
        $height = $control.Properties['Height'] -replace '"', '' -replace '[^0-9]', ''
        $text = $control.Properties['Text'] -replace '"', ''

        $style = "position: absolute; left: ${x}px; top: ${y}px; width: ${width}px; height: ${height}px; border: 1px dashed #ccc; padding: 5px; background: rgba(240,240,240,0.5);"

        $htmlBody += "<div style='$style' title='$($control.Name) ($($control.Type))'>$text</div>`n"
    }

    return @"
<!DOCTYPE html>
<html>
<head>
    <title>PowerApps Preview: $ScreenName</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; position: relative; }
        .screen-container { position: relative; border: 2px solid #333; margin: 20px 0; }
        .info { background: #f0f0f0; padding: 10px; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="info">
        <strong>Screen:</strong> $ScreenName<br>
        <strong>Controls:</strong> $($controls.Count)<br>
        <strong>Note:</strong> Basic preview - install Node.js for full rendering
    </div>
    <div class="screen-container">
        $htmlBody
    </div>
</body>
</html>
"@
}

Write-Host "`nPreview generation complete!" -ForegroundColor Green
Write-Host "Tips:" -ForegroundColor Yellow
Write-Host "- Install Node.js for enhanced HTML generation with full styling" -ForegroundColor Gray
Write-Host "- Use: .\Generate-ScreenPreview.ps1 -ScreenName 'DeskSelect' -OutputDir 'previews'" -ForegroundColor Gray
