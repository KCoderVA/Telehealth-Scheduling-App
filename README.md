# Telehealth Resources Project

## Overview
A comprehensive PowerApps-based solution for booking and managing telehealth conference rooms across hospital outlying buildings. This system enables staff to view current room schedules, check availability, and submit reservation requests through an intuitive canvas app interface.

## Project Goals
- **PowerApps Canvas App**: Graphical user interface for room booking
- **SharePoint Integration**: Master schedule storage and reservation tracking
- **Power Automate Workflows**: Automated approval routing to Telehealth Managers
- **Legacy System Migration**: Transition from Excel-based to SharePoint-based scheduling

## Architecture
```
├── PowerApps Canvas App (Frontend)
├── SharePoint Lists (Data Storage)
│   ├── Room Schedules/Calendar Views
│   └── Reservation Requests
├── Power Automate Flows (Automation)
│   ├── Request Routing
│   └── Approval Workflows
└── Legacy Excel Integration (Transition Phase)
```

## Project Structure
```
telehealth-resources-project/
├── docs/                     # Documentation and specifications
├── src/                      # Source code and configurations
│   ├── powerapps/           # PowerApps canvas app files
│   ├── power-automate/      # Flow definitions and configurations
│   └── sharepoint/          # SharePoint list schemas and configurations
├── data/                     # Sample data and test datasets
├── legacy/                   # Legacy VBA and Excel files
└── LICENSE                   # Apache 2.0 License
```

## Current Status
✅ **Analysis & Planning Complete**
- [x] Project structure created and VS Code workspace optimized
- [x] PowerApps application unpacked and analyzed (578 Telehealth Resource App)
- [x] SharePoint data sources documented (3 lists + Excel integration)
- [x] Business logic analysis complete (17 screens, 5 connectors)
- [x] 12-week migration & enhancement plan created
- [ ] Phase 1: Modernization and error resolution (Weeks 1-4)
- [ ] Phase 2: Enhanced functionality and workflows (Weeks 5-8)
- [ ] Phase 3: Advanced features and mobile optimization (Weeks 9-12)

### Key Findings
- **Current App**: Functional MVP with 17 screens serving telehealth team
- **Technical Debt**: 17 binding errors, legacy runtime, Excel dependencies
- **Architecture**: VA Government Cloud deployment with proper security
- **Enhancement Opportunities**: Automated approvals, Teams integration, analytics

## Getting Started
1. Review detailed analysis in `/docs/migration-implementation-plan.md`
2. Examine unpacked PowerApps structure in `/src/powerapps/`
3. Review SharePoint data architecture in `/src/sharepoint/current-data-sources.md`
4. Follow Phase 1 implementation tasks for immediate improvements

## Contributors
- Hospital Informatics Team
- Telehealth Managers (Stakeholders)

## License
This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---
*Last Updated: July 16, 2025*
