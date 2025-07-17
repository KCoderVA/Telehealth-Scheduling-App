# Changelog
All notable changes to the Telehealth Resources Project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- PowerApps HTML Previewer system with GUI launcher

## [1.0.0] - 2025-07-17
### Added
- Initial telehealth room booking PowerApps application (578 Telehealth Resource App)
- SharePoint integration with 3 lists (Desks, Reservations, Admin)
- Office 365 authentication and user management
- Excel Online bridge for legacy data (Aurora120/121 tables)
- Complete PowerApps HTML Previewer development tool
- VS Code workspace optimization for Power Platform development
- Comprehensive project documentation and migration strategy

### Technical Details
- 18 functional screens serving Edward Hines Jr. VA Hospital
- 10 reusable components with complex business logic
- 5 data connectors (SharePoint, O365, Teams, Outlook, Excel)
- VA Government Cloud deployment with security compliance
- 186 total project files (34.68 MB)

### Changed
- Project structure reorganized with logical src/, docs/, data/, legacy/ directories
- README.md enhanced with project analysis summary
- VS Code workspace optimized for Power Platform development

### Fixed
- PowerApps HTML Previewer deletion system fully functional
- File picker navigation issues resolved
- Timestamped filename generation preventing conflicts

### Security
- VA Government Cloud compliance documented
- Office 365 SSO integration architecture established
- HIPAA-compliant data handling patterns implemented

### Technical Notes
- See `docs/technical-analysis-v1.0.0.md` for detailed technical findings
- Git commit history provides granular change tracking
- 17 technical debt items identified for future releases

---

## [0.1.0] - 2025-07-16
### Added
- Project initialization and basic workspace setup
- Documentation framework and folder structure

---

## Format Guidelines
- **Added** for new features
- **Changed** for changes in existing functionality
- **Deprecated** for soon-to-be removed features
- **Removed** for now removed features
- **Fixed** for any bug fixes
- **Security** in case of vulnerabilities
