# Contributing to Telehealth Resources Project

Thank you for your interest in contributing to the Telehealth Resources Project! This guide will help you understand our development process and standards.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Power Platform Guidelines](#power-platform-guidelines)

## Code of Conduct

This project operates under hospital IT standards and healthcare compliance requirements. All contributors must:
- Follow HIPAA data protection guidelines
- Maintain professional communication standards
- Respect patient privacy and confidentiality
- Comply with VA hospital security protocols

## Getting Started

### Prerequisites
1. **Microsoft 365 License**: Business/Enterprise with PowerApps access
2. **Hospital Network Access**: VA network authentication required
3. **VS Code Setup**: Follow `/docs/setup.md` for environment configuration
4. **Git Access**: Configured for hospital network and proxy settings

### Initial Setup
```powershell
# Clone the repository
git clone <repository-url>
cd "Telehealth Schedule & Booking"

# Open VS Code workspace
code "Telehealth Resources Project.code-workspace"

# Run initial setup task
# Ctrl+Shift+P → "Tasks: Run Task" → "Daily Workflow Start"
```

## Development Workflow

# 2. Power Platform Development
```powershell
# Start development session
# Use VS Code Task: "Open All Power Platform Tools"

# For PowerApps:
# 1. Design in PowerApps Studio (make.powerapps.com)
# 2. Export .msapp files to /src/power-apps/v0.3.x/v0.3.4/.msapp/
# 3. Use Power Platform CLI to maintain /src/power-apps/v0.3.x/v0.3.4/.unpacked/ source files
# 4. Test with HTML Previewer tool

# For Power Automate:
# 1. Design flows in make.powerautomate.com
# 2. Export flow definitions as JSON
# 3. Store in /src/power-automate/ (when created)
# 4. Document approval logic and email templates
```

### 2. Documentation Updates
- Update `CHANGELOG.md` for all functional changes
- Add comments to complex PowerShell scripts
- Include screenshots for UI changes
- Update technical analysis documents

### 3. Testing Requirements
- Test all PowerApps screens with sample data
- Validate SharePoint List operations
- Verify approval workflows end-to-end
- Test on both desktop and mobile devices

## Coding Standards

### PowerShell Scripts
```powershell
# Use approved verbs and clear parameter names
function Get-TelehealthBooking {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RoomName,

        [Parameter(Mandatory = $true)]
        [datetime]$BookingDate
    )

    # Always include error handling
    try {
        # Implementation here
        Write-Verbose "Processing booking for $RoomName on $BookingDate"
    }
    catch {
        Write-Error "Failed to retrieve booking: $_"
        throw
    }
}
```

### PowerApps Naming Conventions
- **Screens**: PascalCase with descriptive names (`BookingScreen`, `ApprovalScreen`)
- **Controls**: Prefix + PascalCase (`btnSubmit`, `lblTitle`, `galBookings`)
- **Variables**: camelCase with descriptive names (`isBookingValid`, `selectedRoom`)
- **Collections**: PascalCase with "Collection" suffix (`BookingsCollection`)

### SharePoint Lists & Fields
- **List Names**: PascalCase, descriptive (`TelehealthBookings`, `RoomInventory`)
- **Field Names**: PascalCase, no spaces (`BookingDate`, `RequestorEmail`)
- **Choice Fields**: Consistent casing and clear values

## Commit Guidelines

### Commit Message Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- **feat**: New feature or enhancement
- **fix**: Bug fix or error resolution
- **docs**: Documentation changes only
- **style**: Code formatting, no functional changes
- **refactor**: Code restructuring without functionality changes
- **test**: Adding or updating tests
- **chore**: Maintenance tasks, build processes

### Examples
```bash
feat(powerapps): add room availability validation

- Implement real-time availability checking
- Add conflict resolution for double bookings
- Update booking confirmation screen

Closes #123

fix(sharepoint): resolve permission error on booking submission

- Update SharePoint list permissions for end users
- Add error handling for authentication failures
- Test with non-admin user accounts

docs(setup): update VS Code extension requirements

- Add Power Platform Tools extension requirement
- Include proxy configuration steps
- Update PowerShell execution policy instructions
```

## Pull Request Process

### Before Submitting
1. **Update Documentation**: Ensure all changes are documented
2. **Test Thoroughly**: Verify functionality across different user roles
3. **Update CHANGELOG**: Add entry for significant changes
4. **Check File Organization**: Ensure proper directory structure

### PR Description Template
```markdown
## Description
Brief description of changes and motivation

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] PowerApps functionality tested
- [ ] SharePoint integration verified
- [ ] Mobile responsiveness checked
- [ ] User roles and permissions validated

## Screenshots (if applicable)
Include before/after screenshots for UI changes

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review of code completed
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] No sensitive information included
```

## Power Platform Guidelines

### PowerApps Best Practices
- **Performance**: Minimize delegation warnings, use efficient formulas
- **User Experience**: Consistent navigation, clear error messages
- **Accessibility**: Screen reader support, keyboard navigation
- **Mobile First**: Design for mobile, enhance for desktop

### SharePoint Integration
- **Data Types**: Use appropriate column types for data
- **Indexing**: Index frequently queried columns
- **Permissions**: Principle of least privilege
- **Backup**: Regular content export for disaster recovery

### Power Automate Workflows
- **Error Handling**: Comprehensive try-catch blocks
- **Logging**: Detailed run history for troubleshooting
- **Performance**: Efficient API calls, avoid unnecessary loops
- **Security**: Secure handling of sensitive data

## Security Guidelines

### Data Protection
- **No PHI in Code**: Never hardcode patient information
- **Connection Strings**: Use environment variables
- **API Keys**: Store in Azure Key Vault or secure configuration
- **Audit Logging**: Track all data access and modifications

### Hospital Compliance
- **VA Standards**: Follow Department of Veterans Affairs IT guidelines
- **HIPAA Compliance**: Ensure all data handling meets healthcare standards
- **Network Security**: Use hospital-approved connections and protocols
- **Access Control**: Implement role-based security throughout system

## Questions or Issues?

- **Technical Issues**: Create GitHub issue with detailed description
- **Process Questions**: Contact the Informatics Team lead
- **Security Concerns**: Follow hospital IT security reporting procedures
- **Feature Requests**: Discuss with Telehealth Managers before implementation

---

## License

By contributing to this project, you agree that your contributions will be licensed under the Apache License 2.0.

---
*Last Updated: November 21, 2025*
