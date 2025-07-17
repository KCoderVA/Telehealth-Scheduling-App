# Data Directory

This directory contains the primary data sources and master schedules for the Telehealth Resources Project.

## Current Files

### Excel Master Schedules
- **2025.07.11 Telehealth Master Schedule July 2025.xlsx** - Current production schedule (July 2025)
- **2025.07.10 TeleHealth Master Schedule 2025.xlsx** - Annual master schedule template
- **2025.07.03 TeleHealth Master Schedule (test copy).xlsx** - Test/development copy for safe testing

### Power BI Reports
- **Utilization.pbix** - Room utilization analytics and reporting dashboard

## Data Management Guidelines

### File Naming Convention
- Use ISO date format: `YYYY.MM.DD`
- Include descriptive purpose: `Master Schedule`, `test copy`, etc.
- Maintain version control through descriptive names

### Data Sources Integration
These Excel files serve as the current master data source during the transition period to SharePoint Lists. See `/src/sharepoint/current-data-sources.md` for detailed mapping between Excel columns and SharePoint list fields.

### Backup & Version Control
- Excel files are tracked in git for change history
- Power BI files (.pbix) are included in git (compressed format)
- Weekly backups created automatically via VS Code tasks

## Migration Status
- **Current State**: Excel-based master scheduling
- **Target State**: SharePoint Lists with Power Platform integration
- **Migration Phase**: 1 of 3 (Analysis & Planning Complete)

## Usage Notes
- Excel files remain read-only during SharePoint transition
- All booking requests flow through PowerApps → SharePoint workflow
- Power BI reports will transition to use SharePoint data sources in Phase 2

---
*For technical details on data structure and field mappings, see `/docs/migration-implementation-plan.md`*
