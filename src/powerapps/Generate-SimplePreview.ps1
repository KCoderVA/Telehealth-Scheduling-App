# PowerApps Screen to HTML Preview Generator (Simplified)
param(
    [Parameter(Mandatory=$true)]
    [string]$ScreenName,

    [Parameter(Mandatory=$false)]
    [string]$OutputDir = "previews"
)

# Create output directory
if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Read screen JSON
$screenFile = "screens\$ScreenName.json"
if (!(Test-Path $screenFile)) {
    Write-Error "Screen file not found: $screenFile"
    exit 1
}

Write-Host "Processing screen: $ScreenName" -ForegroundColor Cyan

$screenJson = Get-Content $screenFile -Raw | ConvertFrom-Json
$controls = @()

# Extract controls from the screen
function Extract-Controls($parentControl) {
    if ($parentControl.Children) {
        foreach ($child in $parentControl.Children) {
            $controls += $child
            Extract-Controls $child
        }
    }
}

Extract-Controls $screenJson.TopParent
$controls += $screenJson.TopParent

Write-Host "Found $($controls.Count) controls" -ForegroundColor Green

# Generate HTML
$htmlElements = @()
$cssRules = @()

foreach ($control in $controls) {
    $props = @{
        x = 0; y = 0; width = 100; height = 50
        fill = 'rgba(255,255,255,0)'; color = '#000000'
        text = ''; fontSize = 14; zIndex = 1
    }

    if ($control.Rules) {
        foreach ($rule in $control.Rules) {
            if ($rule.Property -and $rule.InvariantScript) {
                $value = $rule.InvariantScript -replace '"', ''

                switch ($rule.Property) {
                    'X' { $props.x = [int]($value -replace '[^0-9]', '') }
                    'Y' { $props.y = [int]($value -replace '[^0-9]', '') }
                    'Width' { $props.width = [int]($value -replace '[^0-9]', '') }
                    'Height' { $props.height = [int]($value -replace '[^0-9]', '') }
                    'Text' { $props.text = $value }
                    'Size' { $props.fontSize = [int]($value -replace '[^0-9]', '') }
                    'ZIndex' { $props.zIndex = [int]($value -replace '[^0-9]', '') }
                    'Fill' {
                        if ($value -match 'RGBA\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)') {
                            $props.fill = "rgba($($matches[1]), $($matches[2]), $($matches[3]), $($matches[4]))"
                        }
                    }
                    'Color' {
                        if ($value -match 'RGBA\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)') {
                            $props.color = "rgba($($matches[1]), $($matches[2]), $($matches[3]), $($matches[4]))"
                        }
                    }
                }
            }
        }
    }

    $className = "control-$($control.Name.ToLower())"
    $templateName = $control.Template.Name

    # Generate CSS
    $css = @"
.$className {
    position: absolute;
    left: $($props.x)px;
    top: $($props.y)px;
    width: $($props.width)px;
    height: $($props.height)px;
    background-color: $($props.fill);
    color: $($props.color);
    font-size: $($props.fontSize)px;
    z-index: $($props.zIndex);
    box-sizing: border-box;
    border: 1px solid rgba(0,0,0,0.1);
}
"@
    $cssRules += $css

    # Generate HTML element
    $htmlElement = switch ($templateName) {
        'label' { "<div class='$className' title='$($control.Name)'>$($props.text)</div>" }
        'button' { "<button class='$className' title='$($control.Name)'>$($props.text)</button>" }
        'rectangle' { "<div class='$className' title='Rectangle: $($control.Name)'></div>" }
        'image' { "<div class='$className' title='Image: $($control.Name)'>[IMG]</div>" }
        'icon' { "<div class='$className' title='Icon: $($control.Name)'>⚫</div>" }
        'arrow' { "<div class='$className' title='Arrow: $($control.Name)'>→</div>" }
        'screen' { "<div class='$className' title='Screen: $($control.Name)'></div>" }
        default { "<div class='$className' title='${templateName}: $($control.Name)'>[$templateName]</div>" }
    }

    $htmlElements += @{
        html = $htmlElement
        zIndex = $props.zIndex
    }
}

# Sort by z-index and create final HTML
$sortedElements = $htmlElements | Sort-Object zIndex
$htmlBody = ($sortedElements | ForEach-Object { $_.html }) -join "`n    "
$allCss = $cssRules -join "`n"

$finalHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PowerApps Preview: $ScreenName</title>
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f5f5f5;
        }
        .screen-container {
            position: relative;
            width: 640px;
            height: 1136px;
            margin: 0 auto;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        .screen-info {
            background: #2c3e50;
            color: white;
            padding: 10px;
            margin-bottom: 20px;
            text-align: center;
        }
        $allCss
    </style>
</head>
<body>
    <div class="screen-info">
        <strong>PowerApps Screen Preview:</strong> $ScreenName<br>
        <small>Controls: $($controls.Count) | Generated from JSON</small>
    </div>
    <div class="screen-container">
        $htmlBody
    </div>
</body>
</html>
"@

# Save HTML file
$outputFile = "$OutputDir\$ScreenName.html"
$finalHtml | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "✓ Generated HTML preview: $outputFile" -ForegroundColor Green
Write-Host "Opening preview..." -ForegroundColor Yellow

# Open in browser
Start-Process (Resolve-Path $outputFile)
