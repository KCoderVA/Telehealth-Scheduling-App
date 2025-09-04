# Source Code Directory

This directory contains the source code, configurations, and implementations for the Telehealth Resources Project Power Platform solution.

## Directory Structure

```
src/
├── power-apps/          # PowerApps Canvas App components (version-controlled)
│   ├── v0.1.x/         # Legacy versions (archived)
│   │   └── v0.1.3/     # Version 0.1.3 (archived)
│   └── v0.2.x/         # Current development branch
│       └── v0.2.0/     # Version 0.2.0 release
│           ├── .unpacked/   # Power Platform CLI source files
│           ├── .zip/        # Archive packages for deployment
│           └── .msapp/      # Binary application files
├── pwsh/                # PowerShell automation and development scripts
├── sharepoint/          # SharePoint List schemas and configurations
└── power-automate/      # Power Automate Flow definitions (planned)
```

## Development Workflow

### PowerApps Development
1. **Design**: Use PowerApps Studio web interface
2. **Export**: Download .msapp files to `/power-apps/v0.2.x/v0.2.0/.msapp/`
3. **Source Control**: Use Power Platform CLI to maintain .unpacked/ source files
4. **Version Control**: Semantic versioning with separate directories for major releases
5. **Testing**: Use HTML Previewer tool for rapid development (legacy v0.1.x)

### SharePoint Configuration
- List schemas and field definitions
- Content type configurations
- Permission and security settings
- Integration documentation

### Power Automate Flows (Planned)
- Approval workflow definitions
- Email notification templates
- Integration with external systems
- Error handling and logging

## Key Features

### Production-Ready Components
- **578 Telehealth Resource App v0.2.0**: 18 functional screens with enhanced UI
- **Version-Controlled Source**: Power Platform CLI integration for collaborative development
- **SharePoint Integration**: 3 lists + Excel Online bridge for data management
- **Security Model**: VA Government Cloud compliance with role-based access

### Development Tools
- PowerShell automation scripts
- JSON screen definitions
- Automated backup and cleanup utilities
- VS Code task integration

## Getting Started

1. **Review Architecture**: See `/docs/migration-implementation-plan.md`
2. **Setup Environment**: Follow `/docs/setup.md`
3. **PowerApps Development**: Use Power Platform CLI for v0.2.x development (legacy HTML Previewer in `/power-apps/v0.1.x/`)
4. **SharePoint Lists**: Review current schema in `/sharepoint/current-data-sources.md`

## Quality Standards

### Code Organization
- Clear separation of concerns (UI, data, workflows)
- Comprehensive documentation for all components
- Version control for all exported solutions
- Regular backup of development progress

### Security & Compliance
- VA Government Cloud deployment patterns
- O365 authentication integration
- HIPAA-compliant data handling
- Role-based access control implementation

---
*For detailed technical specifications, see individual README files in each subdirectory*
