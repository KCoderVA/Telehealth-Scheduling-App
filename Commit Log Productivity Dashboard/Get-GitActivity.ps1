# Git Activity Dashboard Backend
# Copyright 2025 Kyle J. Coder
# Licensed under the Apache License, Version 2.0

param(
    [string]$StartDate,
    [string]$EndDate,
    [string]$OutputFormat = "json"
)

function Find-GitRepository {
    # Start from current directory and walk up to find .git folder
    $currentDir = Get-Location
    $searchDir = $currentDir.Path

    Write-Host "🔍 Searching for git repository starting from: $searchDir" -ForegroundColor Yellow

    do {
        $gitPath = Join-Path $searchDir ".git"
        Write-Host "   Checking: $gitPath" -ForegroundColor Gray

        if (Test-Path $gitPath) {
            Write-Host "✅ Found git repository at: $searchDir" -ForegroundColor Green
            return $searchDir
        }

        # Move up one directory
        $parentDir = Split-Path $searchDir -Parent
        if ($parentDir -eq $searchDir) {
            # We've reached the root
            break
        }
        $searchDir = $parentDir

    } while ($searchDir)

    Write-Host "❌ No git repository found in directory tree" -ForegroundColor Red
    return $null
}

function Get-GitActivity {
    param(
        [string]$Since,
        [string]$Until
    )

    try {
        Write-Host "🔍 Analyzing git repository from $Since to $Until..." -ForegroundColor Cyan

        # Auto-detect git repository location
        $gitRoot = Find-GitRepository
        if (-not $gitRoot) {
            throw "No git repository found. Please place this dashboard in a git repository or its subdirectory."
        }

        Write-Host "📂 Git repository detected at: $gitRoot" -ForegroundColor Green
        Push-Location $gitRoot

        # Get commit data with statistics
        $gitLogCommand = "git log --since=`"$Since`" --until=`"$Until`" --pretty=format:`"%H|%an|%ae|%ad|%s`" --date=iso --stat --numstat"
        $logOutput = Invoke-Expression $gitLogCommand 2>$null

        if (-not $logOutput) {
            Write-Warning "No commits found in the specified date range."
            return @{
                summary = @{
                    totalCommits = 0
                    filesChanged = 0
                    linesAdded = 0
                    linesRemoved = 0
                    productivityScore = 0
                }
                commits = @()
            }
        }

        # Parse commit data
        $commits = @()
        $totalLinesAdded = 0
        $totalLinesRemoved = 0
        $totalFilesChanged = 0

        # Get basic commit count
        $commitCount = (git log --since="$Since" --until="$Until" --oneline | Measure-Object).Count

        # Get detailed commit information
        $commitDetails = git log --since="$Since" --until="$Until" --pretty=format:"%H|%an|%ae|%ad|%s" --date=iso

        foreach ($line in $commitDetails) {
            if ($line -match "^([a-f0-9]+)\|(.+?)\|(.+?)\|(.+?)\|(.+)$") {
                $hash = $matches[1]
                $author = $matches[2]
                $email = $matches[3]
                $date = $matches[4]
                $message = $matches[5]

                # Get file stats for this specific commit
                $statOutput = git show --stat --format="" $hash
                $filesInCommit = 0
                $additionsInCommit = 0
                $deletionsInCommit = 0

                foreach ($statLine in $statOutput) {
                    if ($statLine -match "(\d+) files? changed") {
                        $filesInCommit = [int]$matches[1]
                    }
                    if ($statLine -match "(\d+) insertions?") {
                        $additionsInCommit = [int]$matches[1]
                    }
                    if ($statLine -match "(\d+) deletions?") {
                        $deletionsInCommit = [int]$matches[1]
                    }
                }

                $commits += @{
                    hash = $hash.Substring(0, 7)
                    fullHash = $hash
                    author = $author
                    email = $email
                    date = $date
                    message = $message
                    filesChanged = $filesInCommit
                    linesAdded = $additionsInCommit
                    linesRemoved = $deletionsInCommit
                }

                $totalFilesChanged += $filesInCommit
                $totalLinesAdded += $additionsInCommit
                $totalLinesRemoved += $deletionsInCommit
            }
        }

        # Calculate productivity score (commits + lines added, weighted)
        $productivityScore = [math]::Min(100, [math]::Round(($commitCount * 10) + ($totalLinesAdded / 100)))

        $result = @{
            summary = @{
                totalCommits = $commitCount
                filesChanged = $totalFilesChanged
                linesAdded = $totalLinesAdded
                linesRemoved = $totalLinesRemoved
                productivityScore = $productivityScore
                dateRange = "$Since to $Until"
                generatedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            }
            commits = $commits | Sort-Object { [datetime]$_.date } -Descending
        }

        return $result

    } catch {
        Write-Error "Error analyzing git repository: $_"
        return $null
    } finally {
        # Return to original directory
        if ($gitRoot) {
            Pop-Location
        }
    }
}

function Export-GitActivityReport {
    param(
        [hashtable]$Data,
        [string]$Format = "json"
    )

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

    switch ($Format.ToLower()) {
        "json" {
            $fileName = "git_activity_report_$timestamp.json"
            $Data | ConvertTo-Json -Depth 10 | Out-File -FilePath $fileName -Encoding UTF8
            Write-Host "📁 JSON report exported to: $fileName" -ForegroundColor Green
        }
        "csv" {
            $fileName = "git_activity_report_$timestamp.csv"
            $Data.commits | ForEach-Object {
                [PSCustomObject]@{
                    Hash = $_.hash
                    Author = $_.author
                    Date = $_.date
                    Message = $_.message
                    FilesChanged = $_.filesChanged
                    LinesAdded = $_.linesAdded
                    LinesRemoved = $_.linesRemoved
                }
            } | Export-Csv -Path $fileName -NoTypeInformation
            Write-Host "📁 CSV report exported to: $fileName" -ForegroundColor Green
        }
        "html" {
            $fileName = "git_activity_report_$timestamp.html"
            $htmlContent = Generate-HtmlReport -Data $Data
            $htmlContent | Out-File -FilePath $fileName -Encoding UTF8
            Write-Host "📁 HTML report exported to: $fileName" -ForegroundColor Green
        }
    }

    return $fileName
}

function Generate-HtmlReport {
    param([hashtable]$Data)

    $summary = $Data.summary
    $commits = $Data.commits

    $commitRows = ""
    foreach ($commit in $commits) {
        $commitRows += "<tr><td style='font-family: monospace; background: #f8f9fa;'>$($commit.hash)</td><td>$($commit.date)</td><td>$($commit.message)</td><td style='text-align: center;'>$($commit.filesChanged)</td><td style='text-align: center; color: green;'>+$($commit.linesAdded)</td><td style='text-align: center; color: red;'>-$($commit.linesRemoved)</td></tr>"
    }

    return @"
<!DOCTYPE html>
<html>
<head>
    <title>Git Activity Report - $($summary.dateRange)</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { text-align: center; margin-bottom: 30px; }
        .summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 8px; text-align: center; }
        .card h3 { font-size: 2rem; margin: 0; }
        .card p { margin: 5px 0 0 0; opacity: 0.9; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f8f9fa; font-weight: 600; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 Git Activity Report</h1>
            <p>Generated: $($summary.generatedAt) | Range: $($summary.dateRange)</p>
        </div>

        <div class="summary">
            <div class="card">
                <h3>$($summary.totalCommits)</h3>
                <p>Total Commits</p>
            </div>
            <div class="card">
                <h3>$($summary.filesChanged)</h3>
                <p>Files Changed</p>
            </div>
            <div class="card">
                <h3>+$($summary.linesAdded)</h3>
                <p>Lines Added</p>
            </div>
            <div class="card">
                <h3>$($summary.productivityScore)%</h3>
                <p>Productivity Score</p>
            </div>
        </div>

        <h2>📝 Detailed Commit History</h2>
        <table>
            <thead>
                <tr>
                    <th>Hash</th>
                    <th>Date</th>
                    <th>Message</th>
                    <th>Files</th>
                    <th>Added</th>
                    <th>Removed</th>
                </tr>
            </thead>
            <tbody>
                $commitRows
            </tbody>
        </table>
    </div>
</body>
</html>
"@
}

# Main execution
if ($PSCmdlet.MyInvocation.BoundParameters.Count -eq 0) {
    Write-Host "🚀 Git Activity Dashboard Backend" -ForegroundColor Cyan
    Write-Host "Usage: .\Get-GitActivity.ps1 -StartDate '2025-07-16' -EndDate '2025-07-17' -OutputFormat 'json'" -ForegroundColor Yellow
    Write-Host ""

    # Default to last 7 days if no parameters
    $EndDate = Get-Date -Format "yyyy-MM-dd"
    $StartDate = (Get-Date).AddDays(-7).ToString("yyyy-MM-dd")

    Write-Host "📅 Using default date range: $StartDate to $EndDate" -ForegroundColor Green
}

if ($StartDate -and $EndDate) {
    $activity = Get-GitActivity -Since $StartDate -Until $EndDate

    if ($activity) {
        Write-Host "✅ Analysis complete!" -ForegroundColor Green
        Write-Host "📊 Summary:" -ForegroundColor Yellow
        Write-Host "   Commits: $($activity.summary.totalCommits)" -ForegroundColor White
        Write-Host "   Files: $($activity.summary.filesChanged)" -ForegroundColor White
        Write-Host "   Lines Added: +$($activity.summary.linesAdded)" -ForegroundColor Green
        Write-Host "   Lines Removed: -$($activity.summary.linesRemoved)" -ForegroundColor Red
        Write-Host "   Productivity Score: $($activity.summary.productivityScore)%" -ForegroundColor Cyan

        # Export report
        $exportedFile = Export-GitActivityReport -Data $activity -Format $OutputFormat

        # Also create a JSON file for the HTML dashboard
        $jsonFile = "git-activity-data.json"
        $activity | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonFile -Encoding UTF8
        Write-Host "📱 Dashboard data file created: $jsonFile" -ForegroundColor Magenta
    }
}
