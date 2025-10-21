# Project Assets Directory

This directory contains multimedia assets, documentation materials, and presentation resources for the Telehealth Resources Project.

## Directory Structure

```
assets/
├── excel/               # Spreadsheet templates and data exports
├── images/              # Screenshots, diagrams, and visual documentation
├── pbi/                 # Power BI dashboard files and reports
├── powerpoint/          # Presentation materials and stakeholder briefings
└── videos/              # Demo recordings and training materials
```

## Asset Categories

### Excel Templates & Reports
- **Telehealth Master Schedules**: 11+ Excel files with current scheduling data (2.85+ MB active data)
  - `2025.09.02 Telehealth Master Schedule July 2025 (working copy).xlsx` - Current working copy
  - `2025.09.02 Telehealth Master Schedule July 2025.xlsx` - Production version
  - Multiple monthly versions from July through September 2025
  - `TestCalendar(OakLawn).csv/.xlsx` - Oak Lawn facility test data
- **Data export templates for SharePoint integration**: Migration utilities and import/export tools
- **Analysis spreadsheets and calculation workbooks**: Supporting business logic and validation
- **Legacy system migration utilities**: Excel-to-SharePoint conversion tools

### Visual Documentation
- **Application screenshots and UI mockups**: PowerApps interface documentation and user experience design
- **System architecture diagrams and flowcharts**: Technical documentation supporting `/src/` and `/docs/` directories
- **User interface design assets and branding materials**: VA-compliant design resources and accessibility materials
- **Process workflow visualizations**: Business logic flow charts for stakeholder presentations
- **Current Images**: `2025.08.12 CBOC Telehealth Room Utilization (ISC).png` - Utilization analytics visualization
- **Healthcare Analytics**: Visual representations of room occupancy, scheduling patterns, and performance metrics

### Power BI Analytics
- **Hines - Provider Productivity.pbix**: Comprehensive provider productivity analytics and performance metrics
- **Utilization.pbix**: Room utilization dashboards and occupancy insights for multiple hospital buildings
- **Hospital utilization dashboards**: Real-time monitoring of telehealth room usage and availability
- **Performance metrics and KPI reporting**: Executive-level reporting for Edward Hines Jr. VA Hospital management
- **Provider productivity analytics**: Healthcare staff performance tracking and optimization insights
- **Room occupancy and scheduling insights**: Multi-building analytics for 6+ hospital locations
- **Integration**: Dashboards support data sources from Excel schedules and SharePoint lists
- **Reference**: [Power BI Documentation](https://docs.microsoft.com/en-us/power-bi/) for dashboard development

### Presentation Materials
- Stakeholder briefing presentations
- Project status reports and executive summaries
- Training materials and user guides
- System demonstrations and feature overviews

### Video Resources
- Application demonstration recordings
- Training videos for end users
- Development process documentation
- User acceptance testing sessions

## Usage Guidelines

### File Organization
- **Use descriptive filenames with date stamps (YYYY.MM.DD format)**: Consistent naming convention across all asset types
- Organize by project phase or functional area
- Maintain version control for presentation materials
- Archive outdated assets to preserve project history

### Asset Management
- **Keep source files (.pptx, .pbix) for editing capability**: Maintain master copies for ongoing development
- **Export presentation formats (.pdf, .mp4) for distribution**: Stakeholder-ready formats for meetings and training
- **Optimize file sizes for GitHub repository storage**: Current total asset size: 2.85+ MB with efficient organization
- **Document asset relationships and dependencies**: Cross-references to documentation in `/docs/` and source code in `/src/`
- **Version Control**: Asset versioning aligned with project releases (currently v0.3.2)
- **Integration with Documentation**: Assets support technical analysis, user guides, and stakeholder presentations

### Quality Standards
- **Maintain professional presentation quality**: Enterprise-grade materials suitable for VA healthcare environment
- **Follow VA branding guidelines and accessibility requirements**: WCAG 2.1 AA compliance for all visual materials
- **Ensure HIPAA compliance for any healthcare-related content**: Protected health information safeguards and audit trails
- **Test multimedia assets across different devices and platforms**: Multi-device compatibility for hospital environments
- **Professional Standards**: Reference [VA Web Standards](https://www.va.gov/web/standards/) for compliance
- **Healthcare Accessibility**: Compliance with [Section 508](https://www.section508.gov/) accessibility requirements

## Integration with Project Documentation
- **Assets support documentation in `/docs/` directory**: Visual materials enhance technical specifications and user guides
- **Screenshots referenced in technical analysis reports**: UI documentation supporting development and testing
- **Presentations align with project milestones in CHANGELOG.md**: Executive briefings synchronized with version releases (v0.3.2)
- **Video content supplements user training materials**: Interactive demonstrations for healthcare staff adoption
- **PowerBI Integration**: Analytics dashboards linked from project homepage at [GitHub Pages](https://kcoderva.github.io/Telehealth-Scheduling-App/)
- **Cross-Reference Architecture**: Assets directly support source code documentation in `/src/README.md` and project governance in `/docs/README.md`

---
*For specific asset usage in documentation, see `/docs/` directory README files*
