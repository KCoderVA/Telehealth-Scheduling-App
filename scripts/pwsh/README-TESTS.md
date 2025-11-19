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

# Intake Automation Testing Guide

This directory contains comprehensive end-to-end testing for the PAT (Personal Access Token) powered intake automation workflow.

## Test Scripts

### `test-intake-e2e.ps1`
Comprehensive end-to-end test suite that validates the complete intake workflow including:
- GitHub API connectivity and token validation
- Issue creation with proper labels and assignees
- Archive file generation (markdown, JSON payloads)
- Error handling and recovery scenarios
- Cleanup and verification of artifacts

## Running Tests

### Full Test with Token
Tests the complete workflow including actual issue creation on GitHub:

```powershell
pwsh -ExecutionPolicy Bypass -File ./scripts/pwsh/test-intake-e2e.ps1 -Token $env:GITHUB_TOKEN -VerboseOutput
```

### Dry Run Mode
Tests without creating actual GitHub issues (recommended for development):

```powershell
pwsh -ExecutionPolicy Bypass -File ./scripts/pwsh/test-intake-e2e.ps1 -SkipIssueCreation -VerboseOutput
```

### With Cleanup
Automatically removes test artifacts after successful completion:

```powershell
pwsh -ExecutionPolicy Bypass -File ./scripts/pwsh/test-intake-e2e.ps1 -SkipIssueCreation -CleanupAfterTest
```

## VS Code Tasks

The following test tasks are available in VS Code (Ctrl+Shift+P → "Tasks: Run Task"):

- **🧪 Test: Intake E2E (Full)** - Full test with GitHub API calls
- **🧪 Test: Intake E2E (Dry Run)** - Test without creating issues, auto-cleanup
- **🧪 Test: Intake E2E (With Cleanup)** - Full test with automatic artifact cleanup

## Test Coverage

### Test 1: GitHub API Connectivity
- Validates token presence and format
- Tests API connectivity to the repository
- Verifies repository access permissions

### Test 2: Intake Script Execution
- Verifies script existence and accessibility
- Tests script execution with sample parameters
- Validates exit codes and output

### Test 3: Archive File Generation
- Confirms archive directory creation
- Validates markdown file generation
- Verifies JSON payload files (when token provided)
- Checks file content and structure

### Test 4: Error Handling Scenarios
- Tests invalid token rejection
- Validates missing parameter handling
- Verifies error messages and recovery

## Test Results

The test suite provides detailed output including:
- ✓ **PASS**: Test completed successfully
- ✗ **FAIL**: Test failed with error details
- ⊘ **SKIP**: Test skipped (expected in certain modes)

### Example Output

```
╔═══════════════════════════════════════════════════════╗
║  PAT End-to-End Test Suite                           ║
║  Telehealth Issue Intake Automation                  ║
╚═══════════════════════════════════════════════════════╝

Test Execution Summary:
  Total Tests:    11
  Passed:         7
  Failed:         1
  Skipped:        3
  Duration:       0.19s

  Pass Rate:      63.64%
```

## Test Parameters

### `-Token <string>`
GitHub Personal Access Token for API authentication. Falls back to `$env:GITHUB_TOKEN` if not provided.

### `-SkipIssueCreation`
Run tests without actually creating GitHub issues. Recommended for development and CI/CD pipelines.

### `-CleanupAfterTest`
Automatically remove generated test artifacts after successful test completion.

### `-VerboseOutput`
Enable detailed diagnostic output during test execution, including:
- Script output capture
- Detailed file generation logs
- API request/response details

## Setting Up GitHub Token

### Creating a Personal Access Token

1. Navigate to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token"
3. Select scopes:
   - `repo` (Full control of private repositories)
   - `public_repo` (Access public repositories)
4. Copy the generated token

### Using the Token

#### Environment Variable (Recommended)
```powershell
# Windows PowerShell
$env:GITHUB_TOKEN = "ghp_your_token_here"

# Linux/macOS
export GITHUB_TOKEN="ghp_your_token_here"
```

#### Direct Parameter
```powershell
pwsh -File ./scripts/pwsh/test-intake-e2e.ps1 -Token "ghp_your_token_here"
```

## Troubleshooting

### Token Not Found
If you see "No token provided or found in environment":
- Verify `$env:GITHUB_TOKEN` is set
- Ensure token is not expired
- Check token has required scopes

### Script Execution Failed
If tests fail with execution errors:
- Verify PowerShell execution policy: `Get-ExecutionPolicy`
- Set policy if needed: `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass`
- Check script file permissions

### Archive Files Not Generated
If archive file tests fail:
- Verify `archive/issue-intake/` directory exists
- Check write permissions on the directory
- Ensure adequate disk space

## Continuous Integration

The test suite can be integrated into CI/CD pipelines:

```yaml
# GitHub Actions example
- name: Run Intake E2E Tests
  run: |
    pwsh -ExecutionPolicy Bypass -File ./scripts/pwsh/test-intake-e2e.ps1 `
      -SkipIssueCreation `
      -CleanupAfterTest
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Test Maintenance

### Adding New Tests
To add new test scenarios:
1. Create a new test function following the pattern: `Test-YourScenario`
2. Use `Write-TestResult` to report test outcomes
3. Update test execution in the main section
4. Document the test in this README

### Updating Test Data
Test parameters are defined in the `Test-IntakeScriptExecution` function:
- Employee name
- Department
- Issue severity
- Description and steps

Modify these values to test different scenarios.

## Related Scripts

- **intake-create-issue.ps1** - Main intake automation script
- **test-github-connectivity.ps1** - Standalone connectivity test
- **workspace-cleanup.ps1** - General workspace maintenance

## Support

For issues or questions about the test suite:
1. Review test output for detailed error messages
2. Check CHANGELOG.md for recent changes
3. Consult the main project README.md
4. Open an issue in the GitHub repository

## License

Copyright 2025 Kyle J. Coder

Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for details.
