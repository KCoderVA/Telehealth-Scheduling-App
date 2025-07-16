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
🚧 **Project Initialization Phase**
- [x] Project structure created
- [ ] SharePoint site and lists setup
- [ ] PowerApps canvas app development
- [ ] Power Automate flow creation
- [ ] Legacy system integration
- [ ] Testing and deployment

## Getting Started
1. Review project documentation in `/docs`
2. Set up SharePoint team site
3. Configure development environment
4. Begin with PowerApps canvas app mockup

## Contributors
- Hospital Informatics Team
- Telehealth Managers (Stakeholders)

## License
This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---
*Last Updated: July 16, 2025*
