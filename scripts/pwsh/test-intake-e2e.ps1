# Copyright 2025 Kyle J. Coder
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

<#
.SYNOPSIS
    End-to-end test for PAT-powered intake automation workflow.

.DESCRIPTION
    Comprehensive test suite that validates the complete intake workflow:
    - GitHub API connectivity and token validation
    - Issue creation with proper labels and assignees
    - Archive file generation (markdown, JSON payloads)
    - Error handling and recovery scenarios
    - Cleanup and verification of artifacts

.PARAMETER Token
    GitHub Personal Access Token. If not provided, falls back to $env:GITHUB_TOKEN.

.PARAMETER SkipIssueCreation
    Skip actual issue creation on GitHub (dry-run mode for testing without API calls).

.PARAMETER CleanupAfterTest
    Remove generated test artifacts after successful completion.

.PARAMETER Verbose
    Enable detailed diagnostic output during test execution.

.EXAMPLE
    pwsh -File scripts/pwsh/test-intake-e2e.ps1 -Token $env:GITHUB_TOKEN

.EXAMPLE
    pwsh -File scripts/pwsh/test-intake-e2e.ps1 -SkipIssueCreation -CleanupAfterTest
#>

[CmdletBinding()]
param(
    [string]$Token,
    [switch]$SkipIssueCreation,
    [switch]$CleanupAfterTest,
    [switch]$VerboseOutput
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Test configuration
$testStartTime = Get-Date
$testTimestamp = Get-Date -Format 'yyyy-MM-dd-HHmmss'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent (Split-Path -Parent $scriptDir)
$archiveDir = Join-Path $projectRoot 'archive/issue-intake'

# Test results tracking
$testResults = @{
    Total = 0
    Passed = 0
    Failed = 0
    Skipped = 0
    Details = @()
}

function Write-TestHeader {
    param([string]$Message)
    Write-Host "`n═══════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  $Message" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════`n" -ForegroundColor Cyan
}

function Write-TestResult {
    param(
        [string]$TestName,
        [bool]$Passed,
        [string]$Message = '',
        [bool]$Skipped = $false
    )
    
    $testResults.Total++
    
    if ($Skipped) {
        $testResults.Skipped++
        Write-Host "⊘ SKIP: $TestName" -ForegroundColor Yellow
        if ($Message) { Write-Host "  └─ $Message" -ForegroundColor DarkGray }
    } elseif ($Passed) {
        $testResults.Passed++
        Write-Host "✓ PASS: $TestName" -ForegroundColor Green
        if ($Message) { Write-Host "  └─ $Message" -ForegroundColor DarkGray }
    } else {
        $testResults.Failed++
        Write-Host "✗ FAIL: $TestName" -ForegroundColor Red
        if ($Message) { Write-Host "  └─ $Message" -ForegroundColor Yellow }
    }
    
    $testResults.Details += @{
        Name = $TestName
        Passed = $Passed
        Skipped = $Skipped
        Message = $Message
        Timestamp = Get-Date
    }
}

function Test-GitHubConnectivity {
    Write-TestHeader "Test 1: GitHub API Connectivity"
    
    try {
        if ([string]::IsNullOrWhiteSpace($Token)) {
            Write-TestResult "Token validation" $false "No token provided or found in environment"
            return $false
        }
        
        Write-TestResult "Token validation" $true "Token present (length: $($Token.Length))"
        
        $headers = @{
            Authorization = "Bearer $Token"
            'User-Agent' = 'TelehealthIssueAutomation-Test'
            Accept = 'application/vnd.github+json'
        }
        
        if ($VerboseOutput) {
            Write-Host "  Testing connectivity to GitHub API..." -ForegroundColor DarkGray
        }
        
        $resp = Invoke-RestMethod -Method Get -Uri 'https://api.github.com/repos/KCoderVA/Telehealth-Scheduling-App' -Headers $headers
        
        if ($resp.full_name) {
            Write-TestResult "API connectivity" $true "Repository: $($resp.full_name), Open issues: $($resp.open_issues_count)"
            return $true
        } else {
            Write-TestResult "API connectivity" $false "Unexpected response format"
            return $false
        }
    } catch {
        Write-TestResult "API connectivity" $false "Exception: $($_.Exception.Message)"
        return $false
    }
}

function Test-IntakeScriptExecution {
    Write-TestHeader "Test 2: Intake Script Execution"
    
    $intakeScript = Join-Path $scriptDir 'intake-create-issue.ps1'
    
    # Verify script exists
    if (-not (Test-Path $intakeScript)) {
        Write-TestResult "Script existence" $false "intake-create-issue.ps1 not found at: $intakeScript"
        return $false
    }
    Write-TestResult "Script existence" $true "Found at: $intakeScript"
    
    # Test parameters
    $testParams = @{
        Employee = "Token Test User"
        Email = "test@va.gov"
        Dept = "Telehealth"
        Phone = "(555) 123-4567"
        Severity = "moderate"
        Title = "PAT end-to-end test"
        Description = "Testing intake-create-issue.ps1 with stored GITHUB_TOKEN"
        Steps = "Open app, reproduce, then report"
        Extra = "PAT-powered automation test"
        DebugPayload = $true
        SaveRawPayload = $true
    }
    
    if (-not $SkipIssueCreation) {
        $testParams['Token'] = $Token
    }
    
    try {
        if ($VerboseOutput) {
            Write-Host "  Executing intake script with test parameters..." -ForegroundColor DarkGray
        }
        
        # Capture output
        $output = & $intakeScript @testParams 2>&1
        
        if ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE) {
            Write-TestResult "Script execution" $true "Completed successfully"
            
            if ($VerboseOutput) {
                Write-Host "`n  Script Output:" -ForegroundColor DarkGray
                $output | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
            }
            
            return $true
        } else {
            Write-TestResult "Script execution" $false "Exit code: $LASTEXITCODE"
            Write-Host "  Output: $output" -ForegroundColor Yellow
            return $false
        }
    } catch {
        Write-TestResult "Script execution" $false "Exception: $($_.Exception.Message)"
        return $false
    }
}

function Test-ArchiveFileGeneration {
    Write-TestHeader "Test 3: Archive File Generation"
    
    if (-not (Test-Path $archiveDir)) {
        Write-TestResult "Archive directory" $false "Directory not found: $archiveDir"
        return $false
    }
    Write-TestResult "Archive directory" $true "Found at: $archiveDir"
    
    # Find most recent files
    $recentFiles = @(Get-ChildItem -Path $archiveDir -File | 
        Where-Object { $_.LastWriteTime -gt $testStartTime.AddSeconds(-10) } |
        Sort-Object LastWriteTime -Descending)
    
    if ($recentFiles.Count -eq 0 -or $null -eq $recentFiles) {
        Write-TestResult "Archive files" $false "No files generated in archive directory"
        return $false
    }
    
    Write-TestResult "Archive files" $true "Generated $($recentFiles.Count) file(s)"
    
    # Verify markdown file
    $mdFile = $recentFiles | Where-Object { $_.Extension -eq '.md' } | Select-Object -First 1
    if ($mdFile) {
        Write-TestResult "Markdown file" $true "Created: $($mdFile.Name)"
        
        # Validate markdown content
        $mdContent = Get-Content $mdFile.FullName -Raw
        $requiredFields = @('Severity:', 'Employee:', 'Department:', 'Timestamp:', 'Description', 'Reproduction Steps')
        $missingFields = @()
        
        foreach ($field in $requiredFields) {
            if ($mdContent -notlike "*$field*") {
                $missingFields += $field
            }
        }
        
        if ($missingFields.Count -eq 0) {
            Write-TestResult "Markdown content" $true "All required fields present"
        } else {
            Write-TestResult "Markdown content" $false "Missing fields: $($missingFields -join ', ')"
        }
    } else {
        Write-TestResult "Markdown file" $false "No markdown file generated"
    }
    
    # Verify JSON payload files (only expected when token is provided)
    $jsonPretty = $recentFiles | Where-Object { $_.Name -like '*payload-*.json' -and $_.Name -notlike '*-raw-*' } | Select-Object -First 1
    if ($jsonPretty) {
        Write-TestResult "JSON payload (pretty)" $true "Created: $($jsonPretty.Name)"
        
        # Validate JSON structure
        try {
            $jsonContent = Get-Content $jsonPretty.FullName -Raw | ConvertFrom-Json
            
            $hasTitle = $null -ne $jsonContent.title
            $hasBody = $null -ne $jsonContent.body
            $hasLabels = $null -ne $jsonContent.labels -and $jsonContent.labels.Count -gt 0
            
            if ($hasTitle -and $hasBody -and $hasLabels) {
                Write-TestResult "JSON structure" $true "Valid: title, body, labels present"
            } else {
                Write-TestResult "JSON structure" $false "Missing: title=$hasTitle, body=$hasBody, labels=$hasLabels"
            }
        } catch {
            Write-TestResult "JSON structure" $false "Invalid JSON: $($_.Exception.Message)"
        }
    } else {
        if ($SkipIssueCreation -or [string]::IsNullOrWhiteSpace($Token)) {
            Write-TestResult "JSON payload (pretty)" $false "Not generated (expected when no token provided)" $true
        } else {
            Write-TestResult "JSON payload (pretty)" $false "No pretty JSON file generated"
        }
    }
    
    $jsonRaw = $recentFiles | Where-Object { $_.Name -like '*payload-raw-*.json' } | Select-Object -First 1
    if ($jsonRaw) {
        Write-TestResult "JSON payload (raw)" $true "Created: $($jsonRaw.Name)"
    } else {
        if ($SkipIssueCreation -or [string]::IsNullOrWhiteSpace($Token)) {
            Write-TestResult "JSON payload (raw)" $false "Not generated (expected when no token provided)" $true
        } else {
            Write-TestResult "JSON payload (raw)" $false "No raw JSON file generated (SaveRawPayload may not be enabled)"
        }
    }
    
    return $true
}

function Test-ErrorHandling {
    Write-TestHeader "Test 4: Error Handling Scenarios"
    
    # Test with invalid token (only if not skipping issue creation)
    if ($SkipIssueCreation) {
        Write-TestResult "Invalid token handling" $false "Skipped due to SkipIssueCreation flag" $true
    } else {
        $intakeScript = Join-Path $scriptDir 'intake-create-issue.ps1'
        
        try {
            if ($VerboseOutput) {
                Write-Host "  Testing with invalid token..." -ForegroundColor DarkGray
            }
            
            $testParams = @{
                Token = "ghp_invalid_token_12345678901234567890"
                Employee = "Test User"
                Title = "Error test"
                Description = "Testing error handling"
                Steps = "N/A"
            }
            
            $output = & $intakeScript @testParams 2>&1
            
            # Should fail with invalid token
            if ($LASTEXITCODE -ne 0) {
                Write-TestResult "Invalid token handling" $true "Correctly rejected invalid token"
            } else {
                Write-TestResult "Invalid token handling" $false "Should have failed with invalid token"
            }
        } catch {
            Write-TestResult "Invalid token handling" $true "Exception caught as expected: $($_.Exception.Message)"
        }
    }
    
    # Test with missing required parameters
    $intakeScript = Join-Path $scriptDir 'intake-create-issue.ps1'
    
    try {
        if ($VerboseOutput) {
            Write-Host "  Testing with missing parameters..." -ForegroundColor DarkGray
        }
        
        # Missing Employee, Title, Description (all required)
        $output = & $intakeScript -Employee "" -Title "" -Description "" 2>&1
        
        # Should fail due to validation
        if ($LASTEXITCODE -ne 0 -or $output -match "cannot be null or empty") {
            Write-TestResult "Missing parameters" $true "Correctly rejected missing required parameters"
        } else {
            Write-TestResult "Missing parameters" $false "Should have failed with missing parameters"
        }
    } catch {
        # PowerShell may throw before script runs
        Write-TestResult "Missing parameters" $true "Parameter validation triggered: $($_.Exception.Message)"
    }
    
    return $true
}

function Show-TestSummary {
    Write-TestHeader "Test Summary"
    
    $duration = (Get-Date) - $testStartTime
    
    Write-Host "Test Execution Summary:" -ForegroundColor Cyan
    Write-Host "  Total Tests:    $($testResults.Total)" -ForegroundColor White
    Write-Host "  Passed:         $($testResults.Passed)" -ForegroundColor Green
    Write-Host "  Failed:         $($testResults.Failed)" -ForegroundColor $(if ($testResults.Failed -eq 0) { 'Green' } else { 'Red' })
    Write-Host "  Skipped:        $($testResults.Skipped)" -ForegroundColor Yellow
    Write-Host "  Duration:       $($duration.TotalSeconds.ToString('F2'))s" -ForegroundColor White
    Write-Host ""
    
    $passRate = if ($testResults.Total -gt 0) { 
        [math]::Round(($testResults.Passed / $testResults.Total) * 100, 2) 
    } else { 0 }
    
    Write-Host "  Pass Rate:      $passRate%" -ForegroundColor $(if ($passRate -ge 80) { 'Green' } elseif ($passRate -ge 50) { 'Yellow' } else { 'Red' })
    Write-Host ""
    
    if ($testResults.Failed -eq 0) {
        Write-Host "✓ All tests passed successfully!" -ForegroundColor Green
        return 0
    } else {
        Write-Host "✗ Some tests failed. Review output above for details." -ForegroundColor Red
        return 1
    }
}

function Invoke-TestCleanup {
    Write-TestHeader "Test Cleanup"
    
    if (-not $CleanupAfterTest) {
        Write-Host "Cleanup skipped (use -CleanupAfterTest to enable)" -ForegroundColor Yellow
        return
    }
    
    try {
        $recentFiles = @(Get-ChildItem -Path $archiveDir -File | 
            Where-Object { $_.LastWriteTime -gt $testStartTime.AddSeconds(-10) })
        
        if ($recentFiles.Count -gt 0 -and $null -ne $recentFiles) {
            Write-Host "Removing $($recentFiles.Count) test artifact(s)..." -ForegroundColor Cyan
            $recentFiles | ForEach-Object {
                if ($VerboseOutput) {
                    Write-Host "  Removing: $($_.Name)" -ForegroundColor DarkGray
                }
                Remove-Item $_.FullName -Force
            }
            Write-Host "✓ Cleanup completed" -ForegroundColor Green
        } else {
            Write-Host "No test artifacts to clean up" -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "Warning: Cleanup failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# ═══════════════════════════════════════════════════════
# Main Test Execution
# ═══════════════════════════════════════════════════════

Write-Host "`n╔═══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  PAT End-to-End Test Suite                           ║" -ForegroundColor Cyan
Write-Host "║  Telehealth Issue Intake Automation                  ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "Test Configuration:" -ForegroundColor White
Write-Host "  Timestamp:            $testTimestamp" -ForegroundColor DarkGray
Write-Host "  Skip Issue Creation:  $SkipIssueCreation" -ForegroundColor DarkGray
Write-Host "  Cleanup After Test:   $CleanupAfterTest" -ForegroundColor DarkGray
Write-Host "  Verbose Output:       $VerboseOutput" -ForegroundColor DarkGray
Write-Host ""

# Resolve token
if ([string]::IsNullOrWhiteSpace($Token)) {
    $Token = $env:GITHUB_TOKEN
    if ([string]::IsNullOrWhiteSpace($Token)) {
        Write-Host "⚠ No token provided or found in \$env:GITHUB_TOKEN" -ForegroundColor Yellow
        Write-Host "  Continuing with limited test coverage (connectivity tests will be skipped)" -ForegroundColor Yellow
        Write-Host ""
    }
}

# Run test suite
try {
    $connectivityOk = Test-GitHubConnectivity
    $executionOk = Test-IntakeScriptExecution
    $archiveOk = Test-ArchiveFileGeneration
    $errorHandlingOk = Test-ErrorHandling
    
    # Show summary
    $exitCode = Show-TestSummary
    
    # Cleanup if requested
    if ($CleanupAfterTest) {
        Invoke-TestCleanup
    }
    
    exit $exitCode
} catch {
    Write-Host "`n✗ Test suite failed with exception:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor DarkGray
    exit 1
}
