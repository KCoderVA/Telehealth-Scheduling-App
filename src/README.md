# Source Code Directory

This directory contains the source code, configurations, and implementations for the Telehealth Resources Project Power Platform solution.

## Directory Structure

```
src/
├── powerapps/           # PowerApps Canvas App components and tools
├── sharepoint/          # SharePoint List schemas and configurations
└── power-automate/      # Power Automate Flow definitions (planned)
```

## Development Workflow

### PowerApps Development
1. **Design**: Use PowerApps Studio web interface
2. **Export**: Download .msapp files regularly to `/powerapps/`
3. **Version Control**: Commit exported files and screen definitions
4. **Testing**: Use HTML Previewer tool for rapid development

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
- **578 Telehealth Resource App**: 18 functional screens
- **HTML Previewer System**: Complete development toolchain
- **SharePoint Integration**: 3 lists + Excel Online bridge
- **Security Model**: VA Government Cloud compliance

### Development Tools
- PowerShell automation scripts
- JSON screen definitions
- Automated backup and cleanup utilities
- VS Code task integration

## Getting Started

1. **Review Architecture**: See `/docs/migration-implementation-plan.md`
2. **Setup Environment**: Follow `/docs/setup.md`
3. **PowerApps Development**: Use HTML Previewer in `/powerapps/PowerApps_HTML_Previewer/`
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
