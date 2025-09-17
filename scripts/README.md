# Development Scripts Directory

This directory contains automation scripts and development utilities for the Telehealth Resources Project.

## Directory Structure

```
scripts/
├── pwsh/                # PowerShell automation and development scripts
└── vba/                 # Legacy VBA migration utilities
```

## PowerShell Scripts (`pwsh/`)

### Core Development Automation
- **powershell-profile.ps1**: Enhanced PowerShell profile with project-specific functions and enterprise-grade error handling
- **Pre-Commit-Cleanup.ps1**: Repository quality assurance and validation automation with comprehensive workspace validation
- **workspace-cleanup.ps1**: Project organization and file management utilities with automated archival
- **generate-inventory.ps1**: Recursive directory analysis and project inventory generation

### Development Workflow Integration
- Project structure validation and organization
- Automated backup and cleanup processes
- Git workflow automation and commit validation
- VS Code task integration and development environment setup

### Usage
```powershell
# Load project PowerShell profile with enhanced functions
. .\scripts\pwsh\powershell-profile.ps1

# Run comprehensive pre-commit cleanup and validation
.\scripts\pwsh\Pre-Commit-Cleanup.ps1

# Organize workspace files with automated archival
.\scripts\pwsh\workspace-cleanup.ps1

# Generate project inventory and analysis
.\scripts\pwsh\generate-inventory.ps1
```

### VS Code Task Integration
Scripts are integrated with VS Code tasks for automated execution:
- **🧹 Pre-Commit Cleanup & Validation**: Automated quality assurance
- **📈 Project Status Check**: Comprehensive repository health analysis
- **🔍 Validate Project Structure**: Project organization verification
- **📦 Create Project Backup**: Timestamped backup creation

## VBA Scripts (`vba/`)

### Legacy System Migration
- **ConsolidateOakLawnTables.vb**: VBA code for Oak Lawn table consolidation and data processing
- **ConsolidateOakLawnYearlySchedule.vb**: Annual schedule consolidation utilities
- **VBScript_ConferenceRoomScheduling_2025.08.19.vb**: Conference room scheduling business logic
- Migration utilities for transitioning from Excel/VBA to Power Platform
- Business logic documentation and analysis for Power Fx translation
- Data transformation and import/export scripts for SharePoint integration

### Integration Notes
- Scripts support transition from Excel/VBA to PowerApps/SharePoint architecture
- Business logic preserved and documented for Power Fx translation
- Maintains backward compatibility during migration phase with parallel operation
- Reference [Power Fx Documentation](https://docs.microsoft.com/en-us/power-platform/power-fx/) for formula conversion
- Integration with [SharePoint REST API](https://docs.microsoft.com/en-us/sharepoint/dev/sp-add-ins/get-to-know-the-sharepoint-rest-service) for data migration

## Development Standards

### PowerShell Best Practices
- CmdletBinding and proper parameter handling
- Comprehensive error handling and logging
- Help documentation and usage examples
- Enterprise-grade script organization

### Version Control
- All scripts tracked in git repository
- Semantic versioning for major script updates
- Documentation of script dependencies and requirements
- Testing procedures for script validation

### Security & Compliance
- Scripts follow VA Government Cloud security requirements
- No hardcoded credentials or sensitive information
- Audit logging for automated operations
- HIPAA compliance for healthcare data processing

## Integration with Project Workflow

### VS Code Tasks
Scripts are integrated with VS Code tasks (`.vscode/tasks.json`) for:
- **Automated project setup and configuration**: 15 specialized tasks for development workflow
- **Quality assurance and validation workflows**: Pre-commit hooks with comprehensive validation
- **Backup and cleanup automation**: Timestamped backups with size reporting
- **Development environment maintenance**: PowerShell profile integration and module management
- **Power Platform Tools**: Direct links to PowerApps Studio, SharePoint Admin, and Power Automate
- **Repository Health**: Automated Git status, structure validation, and documentation updates

### Continuous Integration
- Pre-commit hooks for repository quality
- Automated documentation updates
- Project structure validation
- File organization and cleanup

---
*For VS Code task configuration, see `.vscode/tasks.json` in the project root*
