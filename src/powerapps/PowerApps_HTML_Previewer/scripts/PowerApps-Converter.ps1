# PowerApps HTML Previewer - Simplified Core Engine
# Version: 1.1 - Simplified, robust version
param(
    [Parameter(Mandatory=$false)]
    [string]$InputFile,

    [Parameter(Mandatory=$false)]
    [string]$OutputDir = "generated_previews"
)

# Get the directory where this script is located (for portability)
$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$OutputPath = Join-Path $ScriptDirectory $OutputDir

# Ensure output directory exists
if (!(Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

function Convert-PowerAppsToHtml {
    param(
        [string]$JsonFilePath,
        [string]$OutputDirectory
    )

    try {
        # Read and parse JSON
        $jsonContent = Get-Content $JsonFilePath -Raw -Encoding UTF8
        $screenData = $jsonContent | ConvertFrom-Json

        if (!$screenData.TopParent) {
            throw "Invalid PowerApps JSON structure - TopParent not found"
        }

        $screenName = $screenData.TopParent.Name
        Write-Host "Processing PowerApps screen: $screenName" -ForegroundColor Cyan

        # Simple array collections - no ArrayList
        $allControls = @()

        # Simple recursive extraction
        function Get-AllControls($control) {
            $result = @($control)
            if ($control.Children) {
                foreach ($child in $control.Children) {
                    $result += Get-AllControls $child
                }
            }
            return $result
        }

        # Extract all controls
        $allControls = Get-AllControls $screenData.TopParent
        Write-Host "Found $($allControls.Count) controls to process" -ForegroundColor Green

        # Generate HTML elements
        $htmlElements = @()
        $cssRules = @()

        foreach ($control in $allControls) {
            if (!$control -or !$control.Name) { continue }

            # Default properties
            $x = 0; $y = 0; $width = 100; $height = 50
            $text = ""; $fontSize = 14; $zIndex = 1
            $fill = 'rgba(255,255,255,0.8)'; $color = '#000000'

            # Extract properties from Rules
            if ($control.Rules) {
                foreach ($rule in $control.Rules) {
                    if ($rule.Property -and $rule.InvariantScript) {
                        $value = $rule.InvariantScript -replace '^"(.*)"$', '$1'

                        switch ($rule.Property) {
                            'X' {
                                if ($value -match '\d+') { $x = [int]($value -replace '[^0-9]', '') }
                            }
                            'Y' {
                                if ($value -match '\d+') { $y = [int]($value -replace '[^0-9]', '') }
                            }
                            'Width' {
                                if ($value -match '\d+') { $width = [int]($value -replace '[^0-9]', '') }
                            }
                            'Height' {
                                if ($value -match '\d+') { $height = [int]($value -replace '[^0-9]', '') }
                            }
                            'Text' {
                                $text = $value -replace '&', '&amp;' -replace '<', '&lt;' -replace '>', '&gt;'
                            }
                            'Size' {
                                if ($value -match '\d+') { $fontSize = [int]($value -replace '[^0-9]', '') }
                            }
                            'ZIndex' {
                                if ($value -match '\d+') { $zIndex = [int]($value -replace '[^0-9]', '') }
                            }
                        }
                    }
                }
            }

            # Control type and HTML generation
            $templateName = if ($control.Template -and $control.Template.Name) { $control.Template.Name } else { 'unknown' }
            $className = "control-$($control.Name.ToLower() -replace '[^a-z0-9]', '-')"

            # Generate CSS
            $css = @"
.$className {
    position: absolute;
    left: ${x}px;
    top: ${y}px;
    width: ${width}px;
    height: ${height}px;
    background-color: $fill;
    color: $color;
    font-size: ${fontSize}px;
    z-index: $zIndex;
    border: 1px solid rgba(0,0,0,0.1);
    box-sizing: border-box;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 5px;
}
"@

            # Generate HTML based on control type
            $htmlElement = switch ($templateName) {
                'label' {
                    "<div class='$className' title='Label: $($control.Name)'>$text</div>"
                }
                'button' {
                    "<button class='$className' title='Button: $($control.Name)'>$text</button>"
                }
                'rectangle' {
                    "<div class='$className' title='Rectangle: $($control.Name)'></div>"
                }
                'image' {
                    "<div class='$className' title='Image: $($control.Name)'>[IMG]</div>"
                }
                'icon' {
                    "<div class='$className' title='Icon: $($control.Name)'>[ICON]</div>"
                }
                'screen' {
                    "<div class='$className' title='Screen: $($control.Name)' style='background: #f0f0f0;'></div>"
                }
                default {
                    "<div class='$className' title='$templateName : $($control.Name)'>[$templateName]</div>"
                }
            }

            $cssRules += $css
            $htmlElements += @{
                html = $htmlElement
                zIndex = $zIndex
                name = $control.Name
                type = $templateName
            }
        }

        # Sort by z-index and generate final HTML
        $sortedElements = $htmlElements | Sort-Object zIndex
        $htmlBody = ($sortedElements | ForEach-Object { $_.html }) -join "`n            "
        $allCss = $cssRules -join "`n        "

        # Complete HTML document
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $fileTimestamp = Get-Date -Format "yyyy.MM.dd.HH.mm.ss"
        $outputFileName = "${fileTimestamp}_${screenName}.html"
        $finalHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PowerApps Preview: $screenName</title>
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f5f5f5;
        }

        .preview-header {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            position: relative;
        }

        .delete-button {
            position: absolute;
            top: 15px;
            right: 15px;
            background: #e74c3c;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .delete-button:hover {
            background: #c0392b;
        }

        .screen-container {
            position: relative;
            width: 640px;
            height: 1136px;
            margin: 0 auto;
            background-color: white;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            border-radius: 10px;
            overflow: hidden;
            border: 2px solid #ddd;
        }

        $allCss
    </style>
</head>
<body>
    <div class="preview-header">
        <button class="delete-button" onclick="deleteFileAndClose()" title="Delete this preview file and close">🗑️ Delete & Close</button>
        <h1>PowerApps Preview: $screenName</h1>
        <p>Controls: $($allControls.Count) | Generated: $timestamp</p>
    </div>

    <div class="screen-container">
        $htmlBody
    </div>

    <div style="max-width: 640px; margin: 20px auto; padding: 15px; background: white; border-radius: 8px;">
        <h3>Generation Details</h3>
        <p><strong>Screen:</strong> $screenName</p>
        <p><strong>Controls:</strong> $($allControls.Count)</p>
        <p><strong>Generated:</strong> $timestamp</p>
        <p><strong>File:</strong> $outputFileName</p>
    </div>

    <script>
        function deleteFileAndClose() {
            const confirmed = confirm('🗑️ Delete this preview file and close browser?\\n\\nFile: $outputFileName\\n\\nThis action cannot be undone.');

            if (confirmed) {
                // Show processing message
                const overlay = document.createElement('div');
                overlay.style.cssText = 'position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.9); z-index: 10000; display: flex; align-items: center; justify-content: center;';
                overlay.innerHTML =
                    '<div style="background: white; padding: 40px; border-radius: 15px; text-align: center; font-family: Arial, sans-serif; box-shadow: 0 10px 30px rgba(0,0,0,0.3);">' +
                        '<div style="font-size: 48px; margin-bottom: 20px;">🗑️</div>' +
                        '<h3 style="color: #e74c3c; margin: 0 0 15px 0;">Processing Deletion...</h3>' +
                        '<p style="color: #666; margin-bottom: 20px;">Deleting: <strong>$outputFileName</strong></p>' +
                        '<div style="width: 200px; height: 4px; background: #f0f0f0; border-radius: 2px; margin: 20px auto; overflow: hidden;">' +
                            '<div style="width: 100%; height: 100%; background: linear-gradient(90deg, #e74c3c, #c0392b); animation: pulse 1.5s ease-in-out infinite;"></div>' +
                        '</div>' +
                        '<p style="color: #888; font-size: 14px;">Creating deletion script...</p>' +
                    '</div>' +
                    '<style>' +
                        '@keyframes pulse { 0%, 100% { opacity: 0.6; } 50% { opacity: 1; } }' +
                    '</style>';
                document.body.appendChild(overlay);

                // Create and download deletion PowerShell script
                const psScript =
                    '# One-Click File Deletion Script - Auto-generated\\n' +
                    'param([string]$$TargetFile = \\"$outputFileName\\")\\n\\n' +
                    '$$ScriptDir = Split-Path -Parent $$MyInvocation.MyCommand.Path\\n' +
                    '$$FilePath = Join-Path (Join-Path $$ScriptDir \\"generated_previews\\") $$TargetFile\\n\\n' +
                    'Write-Host \\"🗑️ Deleting: $$TargetFile\\" -ForegroundColor Cyan\\n\\n' +
                    'if (Test-Path $$FilePath) {\\n' +
                    '    try {\\n' +
                    '        Add-Type -AssemblyName Microsoft.VisualBasic\\n' +
                    '        [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($$FilePath, \\"OnlyErrorDialogs\\", \\"SendToRecycleBin\\")\\n' +
                    '        Write-Host \\"✅ File deleted successfully!\\" -ForegroundColor Green\\n' +
                    '        Write-Host \\"Sent to recycle bin: $$TargetFile\\" -ForegroundColor White\\n' +
                    '    } catch {\\n' +
                    '        Write-Host \\"❌ Error: $$($_.Exception.Message)\\" -ForegroundColor Red\\n' +
                    '    }\\n' +
                    '} else {\\n' +
                    '    Write-Host \\"⚠️ File not found: $$TargetFile\\" -ForegroundColor Yellow\\n' +
                    '}\\n\\n' +
                    'Write-Host \\"Press any key to close...\\" -ForegroundColor Gray\\n' +
                    '$$null = $$Host.UI.RawUI.ReadKey(\\"NoEcho,IncludeKeyDown\\")\\n\\n' +
                    '# Self-destruct\\n' +
                    'try { Remove-Item $$MyInvocation.MyCommand.Path -Force } catch { }';

                // Download the script
                const blob = new Blob([psScript], { type: 'text/plain' });
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = 'delete_$outputFileName.ps1';
                a.style.display = 'none';
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                URL.revokeObjectURL(url);

                // Update message and instructions
                setTimeout(() => {
                    overlay.innerHTML =
                        '<div style="background: white; padding: 40px; border-radius: 15px; text-align: center; font-family: Arial, sans-serif; box-shadow: 0 10px 30px rgba(0,0,0,0.3);">' +
                            '<div style="font-size: 48px; margin-bottom: 20px;">📥</div>' +
                            '<h3 style="color: #27ae60; margin: 0 0 15px 0;">Deletion Script Downloaded!</h3>' +
                            '<p style="color: #666; margin-bottom: 20px;"><strong>delete_$outputFileName.ps1</strong> saved to Downloads</p>' +
                            '<div style="background: #f8f9fa; padding: 20px; border-radius: 10px; text-align: left; margin: 20px 0; border-left: 4px solid #3498db;">' +
                                '<h4 style="margin-top: 0; color: #2c3e50;">Next Steps:</h4>' +
                                '<ol style="color: #555; line-height: 1.6;">' +
                                    '<li>Move the downloaded script to the <strong>generated_previews</strong> folder</li>' +
                                    '<li>Right-click the script → <strong>Run with PowerShell</strong></li>' +
                                    '<li>The file will be deleted and sent to recycle bin</li>' +
                                '</ol>' +
                            '</div>' +
                            '<div style="margin-top: 30px;">' +
                                '<button onclick="window.close()" style="background: #e74c3c; color: white; border: none; padding: 12px 25px; border-radius: 5px; cursor: pointer; font-size: 16px; margin: 5px;">🚪 Close Browser</button>' +
                                '<button onclick="this.parentElement.parentElement.parentElement.remove()" style="background: #95a5a6; color: white; border: none; padding: 12px 25px; border-radius: 5px; cursor: pointer; font-size: 16px; margin: 5px;">❌ Cancel</button>' +
                            '</div>' +
                        '</div>';
                }, 2000);
            }
        }
    </script>
</body>
</html>
"@

        # Save HTML file with timestamp
        $outputFilePath = Join-Path $OutputDirectory $outputFileName
        $finalHtml | Out-File -FilePath $outputFilePath -Encoding UTF8

        Write-Host "✅ Generated HTML preview: $outputFilePath" -ForegroundColor Green
        return $outputFilePath

    } catch {
        Write-Error "❌ Failed to convert PowerApps file: $($_.Exception.Message)"
        return $null
    }
}

# Main execution logic
if ($InputFile) {
    # Direct file processing mode
    if (!(Test-Path $InputFile)) {
        Write-Error "File not found: $InputFile"
        exit 1
    }

    $result = Convert-PowerAppsToHtml -JsonFilePath $InputFile -OutputDirectory $OutputPath
    if ($result) {
        Write-Host "✅ Preview generated successfully!" -ForegroundColor Green
        Write-Host "Opening preview..." -ForegroundColor Yellow
        Start-Process $result
    }
} else {
    Write-Host "PowerApps HTML Previewer - Core Engine" -ForegroundColor Cyan
    Write-Host "Usage: .\PowerApps-Converter.ps1 -InputFile 'path\to\screen.json'" -ForegroundColor Gray
    Write-Host "Output will be saved to: $OutputPath" -ForegroundColor Gray
}
