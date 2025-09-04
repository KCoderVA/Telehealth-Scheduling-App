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
- **powershell-profile.ps1**: Enhanced PowerShell profile with project-specific functions
- **Pre-Commit-Cleanup.ps1**: Repository quality assurance and validation automation
- **workspace-cleanup.ps1**: Project organization and file management utilities

### Development Workflow Integration
- Project structure validation and organization
- Automated backup and cleanup processes
- Git workflow automation and commit validation
- VS Code task integration and development environment setup

### Usage
```powershell
# Load project PowerShell profile
. .\scripts\pwsh\powershell-profile.ps1

# Run pre-commit cleanup
.\scripts\pwsh\Pre-Commit-Cleanup.ps1

# Organize workspace files
.\scripts\pwsh\workspace-cleanup.ps1
```

## VBA Scripts (`vba/`)

### Legacy System Migration
- VBA code from Excel-based scheduling system
- Migration utilities for transitioning to Power Platform
- Business logic documentation and analysis
- Data transformation and import/export scripts

### Integration Notes
- Scripts support transition from Excel/VBA to PowerApps/SharePoint
- Business logic preserved and documented for Power Fx translation
- Maintains backward compatibility during migration phase

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
- Automated project setup and configuration
- Quality assurance and validation workflows
- Backup and cleanup automation
- Development environment maintenance

### Continuous Integration
- Pre-commit hooks for repository quality
- Automated documentation updates
- Project structure validation
- File organization and cleanup

---
*For VS Code task configuration, see `.vscode/tasks.json` in the project root*
