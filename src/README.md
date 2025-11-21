# Source Code Directory

This directory contains the source code, configurations, and implementations for the Telehealth Resources Project Power Platform solution.

## Directory Structure

```
src/
├── power-apps/          # PowerApps Canvas App components (version-controlled)
│   ├── v0.1.x/         # Legacy versions (archived)
│   │   └── v0.1.3/     # Version 0.1.3 (archived)
│   └── v0.3.x/         # Current development branch (promoted 2025-11-21; v0.3.4)
│       └── v0.3.4/     # Version 0.3.4 release (November 21, 2025)
│           ├── .unpacked/   # Power Platform CLI source files
│           ├── .zip/        # Archive packages for deployment
│           └── .msapp/      # Binary application files
├── pwsh/                # PowerShell automation and development scripts
├── sharepoint/          # SharePoint List schemas and configurations
└── power-automate/      # Power Automate Flow definitions
```

## Development Workflow

### PowerApps Development
1. **Design**: Use PowerApps Studio web interface ([make.powerapps.com](https://make.powerapps.com/))
2. **Export**: Download .msapp files to `/power-apps/v0.3.x/v0.3.3/.msapp/`
3. **Source Control**: Use Power Platform CLI to maintain .unpacked/ source files
4. **Version Control**: Semantic versioning with separate directories for major releases
5. **Testing**: Use HTML Previewer tool for rapid development (legacy v0.1.x)
6. **Documentation**: Reference [Microsoft Canvas Apps Documentation](https://docs.microsoft.com/en-us/powerapps/maker/canvas-apps/)

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
- **578 Telehealth Resource App v0.3.4**: Adds Issue Intake automation scripts, diagnostic artifact generation; builds upon dynamic grid & approval flow (November 21, 2025)
- **Version-Controlled Source**: Power Platform CLI integration for collaborative development
- **SharePoint Integration**: 3 lists + Excel Online bridge for data management (2.85+ MB active data)
- **Security Model**: VA Government Cloud compliance with role-based access and HIPAA compliance
- **Asset Management**: Professional multimedia organization with 11+ Excel schedules and PowerBI dashboards
- **GitHub Pages Deployment**: Interactive project overview at [kcoderva.github.io/Telehealth-Scheduling-App](https://kcoderva.github.io/Telehealth-Scheduling-App/)

### Development Tools
- PowerShell automation scripts with enterprise-grade error handling
- JSON screen definitions and component specifications
- Automated backup and cleanup utilities (15 VS Code tasks)
- Professional asset management and multimedia organization
- [Power Platform CLI](https://docs.microsoft.com/en-us/power-platform/developer/cli/introduction) integration
- VS Code task integration with quality assurance automation

## Getting Started

1. **Review Architecture**: See `/docs/migration-implementation-plan.md`
2. **Setup Environment**: Follow `/docs/setup.md`
3. **PowerApps Development**: Use Power Platform CLI for v0.3.x development (legacy HTML Previewer retained in `/power-apps/v0.1.x/` for historical reference)
4. **SharePoint Lists**: Review current schema in `/sharepoint/current-data-sources.md`
5. **External Resources**: Reference [Power Platform Documentation](https://docs.microsoft.com/en-us/power-platform/) for best practices
6. **Asset Management**: Review `/assets/README.md` for multimedia and presentation resources
7. **Interactive Overview**: View comprehensive documentation at [kcoderva.github.io/Telehealth-Scheduling-App](https://kcoderva.github.io/Telehealth-Scheduling-App/)

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
