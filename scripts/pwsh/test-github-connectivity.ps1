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

<#!
Purpose: Minimal, robust GitHub API connectivity test for verbal intake workflow.
Behavior:
- If no token supplied (param or $env:GITHUB_TOKEN), exits 0 after informative message.
- If token supplied, performs authenticated request to repo endpoint and prints status.
- Uses only core PowerShell (Invoke-RestMethod) to remain enterprise friendly.
#>

[CmdletBinding()]
param(env:GITHUB_TOKEN = 'YOUR_TOKEN_VALUE'      # do NOT commit thisenv:GITHUB_TOKEN = 'YOUR_TOKEN_VALUE'      # do NOT commit this
    [string]$Token
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($Token)) {
    # Fallback to environment variable if param not provided
    $Token = $env:GITHUB_TOKEN
}

if ([string]::IsNullOrWhiteSpace($Token)) {
    Write-Host "INFO: No token provided. Skipping authenticated API test (browser fallback will work for issue creation)." -ForegroundColor Yellow
    exit 0
}

$headers = @{ Authorization = 'Bearer ' + $Token; 'User-Agent' = 'TelehealthIssueAutomation'; Accept = 'application/vnd.github+json' }

try {
    $resp = Invoke-RestMethod -Method Get -Uri 'https://api.github.com/repos/KCoderVA/Telehealth-Scheduling-App' -Headers $headers
    if ($resp.full_name) {
    Write-Host ("SUCCESS: API connectivity OK for repo: " + $resp.full_name) -ForegroundColor Green
    Write-Host ("   Default branch: " + $resp.default_branch) -ForegroundColor Cyan
    Write-Host ("   Open issues: " + $resp.open_issues_count) -ForegroundColor Cyan
        exit 0
    } else {
    Write-Host "ERROR: Unexpected response (missing full_name)." -ForegroundColor Red
        exit 2
    }
} catch {
    Write-Host ("ERROR: API call failed: " + $_.Exception.Message) -ForegroundColor Red
    exit 3
}
