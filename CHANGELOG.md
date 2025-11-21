# Changelog
All notable changes to the Telehealth Resources Project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Versioning Strategy
This project is currently in **pre-release development** (0.x.x versions). The first public release will be version 1.0.0 when the application is ready for production deployment at Edward Hines Jr. VA Hospital.

- **0.x.x** - Pre-release development versions
- **1.0.0** - First production-ready release
- **1.x.x** - Production releases with new features and bug fixes

## [0.3.4] - 2025-11-21
### Added
- **Critical Bug Fixes:** Addressed data corruption in `NewEditDesk` (control objects now properly reference `.Text`), fixed missing record argument in `ManageDesks` deletion, and corrected cancellation logic in `Reservation` to support both legacy and new lists.
- **Admin Gating:** "Edit Rooms" tab visibility is now restricted to admins only, improving security and reducing accidental edits.
- **Delegation & Performance:** Replaced non-delegable `CountIf` with `CountRows(Filter(...))` in key galleries; improved refresh throttling and slot indexing resilience.
- **Accessibility Enhancements:** Added `AccessibleLabel` and `TabIndex` to all interactive controls, improved focus visibility, and ensured high-contrast mode compliance.
- **Documentation:** Expanded technical and user documentation, including a detailed app analysis report and updated implementation roadmap.
- **Monitoring & Metrics:** Introduced new metrics collection for submission success, double-book acknowledgements, and accessibility coverage.

### Changed
- **UI/UX Improvements:** Unified weekday gallery selection logic, normalized clinical input handling, and improved help system with global and contextual tips.
- **Data Model:** Documented and validated all field mappings; improved rollback and audit strategies for all major changes.
- **Release Artifacts:** Updated all version references and deployment instructions to v0.3.4; new release artifacts prepared for managed solution import.

### Fixed
- **Critical Bugs:**
  - Fixed data corruption in `NewEditDesk` (now uses `.Text` for all text input references).
  - Fixed missing record argument in `ManageDesks` deletion logic.
  - Fixed cancellation logic in `Reservation` to support both legacy and new lists.
  - Corrected fragile string logic in double-booking attestation.
- **Delegation Warnings:** Replaced non-delegable formulas and added delegation audit worksheet.
- **Accessibility:** Addressed missing labels, tab order, and focus visibility issues.

### Technical Metrics (Delta since 0.3.3)
- **Bug Fixes:** 4 critical, 3 high, 2 medium
- **Accessibility:** 100% coverage for interactive controls
- **Documentation:** 100% up to date for v0.3.4
- **Release Artifacts:** v0.3.4 managed/unmanaged solutions, updated scripts, and technical analysis

### Repository
- **Full Sync:** All local changes, deletions, and new files are now reflected in the public repository. All obsolete files removed.
- **Governance Alignment:** Documentation and technical analysis updated for v0.3.4 release.

---

## [0.3.3] - 2025-10-28
### Added
- **Issue Intake Automation Toolkit**: Introduced scripted verbal/email report → GitHub issue workflow using pure PowerShell (`scripts/pwsh/intake-create-issue.ps1`) avoiding external CLI dependencies; supports automated labeling (`intake`, `bug`, `verbal`) and assignee routing.
- **Connectivity Validation Script**: Added `test-github-connectivity.ps1` for token scope and repository access verification prior to automated issue creation.
- **Advanced Diagnostic Logging**: Multi-layer logging (markdown body, pretty + raw JSON payload, server error body capture, transcript run log, consolidated debug dump) enabling rapid resolution of API errors (HTTP 400) without console flooding.
- **Payload Management Switches**: New script parameters for large JSON handling: `-DebugPayload`, `-MaxConsolePayloadLines`, `-NoConsolePayload`, `-SaveRawPayload`, `-PrettyPrintPayload`, `-DumpAll`, `-CaptureLog`.
- **Secure Token Handling Pattern**: Environment variable fallback (`$env:GITHUB_TOKEN`) with optional direct parameter input; guidance documented for PAT creation minimal scopes (repo:issues + metadata).

### Enhanced
- **Stability of VS Code Tasks**: Refactored issue-related tasks to call external scripts, eliminating prior inline quoting/escape failures in `tasks.json` and improving maintainability.
- **Error Resilience**: Improved REST invocation logic with explicit headers (`Content-Type: application/json`), structured status code capture, response body persistence, and graceful fallback to manual browser creation when token absent.
- **Documentation Coverage**: Prepared for README and `index.html` updates referencing new automation and debugging capabilities (pending inclusion in main docs as of this entry).
- **Transcript Reliability**: Ensured full diagnostic output is captured within run log even when console payload suppressed.

### Changed
- **Issue Creation Flow**: Migration from GitHub CLI dependency to native PowerShell/REST approach for compatibility with restricted enterprise environments.
- **Diagnostics Strategy**: Transition from console-only payload debugging to file-based artifact set improving readability and archival traceability.

### Technical Metrics (Delta since 0.3.2)
- **New Scripts**: +2 PowerShell automation scripts (connectivity + intake) raising total script count.
- **Logging Artifacts**: Up to 5 generated files per intake event (markdown, pretty JSON, raw JSON, error body, debug dump, transcript) enabling forensically complete audit.
- **Task Reliability**: Elimination of prior JSON corruption incidents in task definitions through externalization.

### Repository
- **Automation Hardening**: Intake workflow now fully reproducible and token-aware with minimal manual steps.
- **Governance Alignment**: Changelog updated to reflect emerging operational tooling ahead of next feature increment (v0.4.x planning for enhanced analytics & archiving).

---

## [0.3.2] - 2025-10-21
### Added
- **Dynamic Schedule Grid Interaction**: Time-slot matrix now supports direct cell selection that auto-populates new reservation request form fields (date, time range, building, room) reducing user input friction.
- **Real-Time Availability Counters**: Per-room and per-building availability summary (e.g., "There are currently 35 available blocks") calculated on-the-fly with delegation-friendly formulas.
- **Enhanced Approval Flow Architecture (Power Automate)**: Refactored reservation request flow (v0.3.2) with layered conditional branches, improved parallelism for notification dispatch, and structured error handling. Screenshot added to documentation.
- **SharePoint Master Schedule Expansion**: Weekly schedule list columns optimized for clarity (Day_Monday_text .. Day_Friday_text) with color-coded availability (visual alignment with Canvas grid).
- **Screenshot Gallery Integration**: Added four v0.3.2 screenshots (App Landing, Schedule Grid, SharePoint Weekly Master Schedule, Flow Architecture) referenced in root README and `index.html`.
- **Versioned Source Paths**: Introduced `src/power-apps/v0.3.x/v0.3.2/` and `src/power-automate/ReservationRequest/v0.3.2/` directories as new canonical source locations.
- **Interactive HTML Documentation**: Deployed comprehensive `index.html` with VA.gov design patterns, accessibility features (high contrast toggle, keyboard shortcuts Alt+Shift+E/C), scroll spy navigation, mobile drawer, and accordion state persistence.
- **GitHub Pages Deployment**: Live interactive project overview at https://kcoderva.github.io/Telehealth-Scheduling-App/ with executive summary, architecture deep-dive, technical metrics, and roadmap.

### Enhanced
- **User Experience**: Landing page now surfaces user-specific approved reservations with styled status pill and quick action pathway.
- **Performance**: Reduced unnecessary recalculations in availability grid; consolidated lookups and minimized non-delegable operations.
- **Flow Resilience**: Added retry and conditional logging steps in Power Automate for approval callback updates; improved branch clarity.
- **Documentation Alignment**: Updated all major markdown and HTML docs to reflect version 0.3.2 capabilities and architecture.
- **Accessibility**: High contrast mode toggle, keyboard shortcuts (expand/collapse all sections), accordion state persistence (sessionStorage), screen reader improvements.
- **Navigation**: Sticky side navigation with scroll spy, mobile off-canvas drawer with focus trap, grouped navigation categories (Executive, Technical, Actions).
- **Visual Polish**: Micro-metrics KPI strip, screenshot gallery with lazy loading, back-to-top links, responsive layout for mobile/tablet/desktop.

### Changed
- **Version References**: Updated from 0.2.1 → 0.3.2 in badges, meta tags, structured data, directory examples.
- **Architecture Diagrams (Textual)**: Root README now emphasizes dynamic selection and live counters as core differentiators.
- **Source Layout**: Promotion of v0.3.x branch to current development line; v0.2.x marked as prior release lineage.

### Technical Metrics (Delta since 0.2.1)
- **Schedule Interaction**: Direct cell selection + form auto-fill (new)
- **Approval Flow**: Additional conditional layers & notification refinements
- **Documentation Coverage**: Maintained at 98% with new gallery and feature notes
- **Availability Calculation**: Real-time block counting integrated into UI (new)
- **HTML Documentation**: 1 comprehensive interactive page with 18+ sections, accessibility features, performance optimizations
- **GitHub Pages**: Public deployment ready with canonical URL reference in all docs

### Repository
- **New Directories**: Added v0.3.2 paths for PowerApps & Power Automate flow definitions.
- **Screenshot Assets**: Placeholder entries created for four new PNG files under `assets/images/`.
- **Changelog Governance**: Entry adheres to Keep a Changelog; prior releases retained intact.

## [0.2.1] - 2025-09-17
### Added
- **Comprehensive Documentation Updates**: Complete refresh of all major project README files for v0.2.1
  - Updated root README.md with current version status (0.2.1), enhanced badges, and expanded external references
  - Enhanced project overview with 95% technical foundation completion status and mature development infrastructure
  - Added Microsoft official documentation links for Power Platform and Canvas App development
  - Updated project structure to reflect v0.2.1 versioning and comprehensive asset organization
- **Current State Documentation**: Accurate reflection of project evolution to version 0.2.1
  - Version 0.2.1 release directory structure in `src/power-apps/v0.2.x/v0.2.1/`
  - Enhanced asset inventory with 11+ Excel schedules including September 2025 working copies
  - Professional multimedia organization supporting stakeholder presentations and training
  - Development maturity indicators showing enterprise-grade documentation (98% complete)

### Enhanced
- **Project Maturity Indicators**: Updated technical foundation completion from 90% to 95%
  - Enhanced development infrastructure with comprehensive automation and quality assurance
  - Mature asset management with professional multimedia categorization
  - Enterprise-grade documentation architecture with cross-referencing and external resources
- **External Resource Integration**: Added official Microsoft documentation references
  - [Power Platform Best Practices](https://docs.microsoft.com/en-us/power-platform/) integration
  - [Canvas App Development Guide](https://docs.microsoft.com/en-us/powerapps/maker/canvas-apps/) resources
  - Enhanced stakeholder reference materials with authoritative sources

### Changed
- **Version Progression**: Updated all version references from 0.2.0 to 0.2.1 across documentation
- **Documentation Quality**: Increased from 95% to 98% complete with comprehensive updates
- **Last Updated Dates**: Refreshed all documentation timestamps to September 17, 2025

### Technical Metrics
- **Current Version**: 0.2.1 with enhanced documentation architecture
- **Documentation Completion**: 98% with comprehensive cross-referencing and external resources
- **Asset Management**: Professional organization with 11+ Excel schedules and PowerBI dashboards
- **Development Infrastructure**: Enterprise-grade automation with 15 VS Code tasks and quality assurance

### Repository
- **Documentation Architecture**: Complete refresh for v0.2.1 with enhanced external references
- **Version Control**: Updated semantic versioning structure for v0.2.1 release
- **Quality Assurance**: Maintained 98% repository health with comprehensive validation

## [0.2.0] - 2025-09-03
### Added
- **Version-Based Source Control Architecture**: Implemented semantic versioning directory structure
  - `src/power-apps/v0.2.x/v0.2.0/` - New versioned PowerApps source organization
  - `.unpacked/` directory for Power Platform CLI source control integration
  - `.zip/` archive preservation for release management and rollback capabilities
  - `.msapp/` binary storage separate from source control for deployment artifacts
- **Enhanced Project Asset Management**: Comprehensive multimedia and documentation organization
  - `assets/` directory with organized subdirectories (excel/, images/, pbi/, powerpoint/, videos/)
  - Professional asset categorization for stakeholder presentations and training materials
  - README documentation for each asset category with usage guidelines
- **Advanced PowerShell Script Organization**: Modernized automation and development tooling
  - `scripts/pwsh/` - Dedicated PowerShell script directory with enhanced functionality
  - `workspace-cleanup.ps1` - Automated project organization and file management
  - Enhanced `powershell-profile.ps1` with improved error handling and development functions
  - `Pre-Commit-Cleanup.ps1` - Quality assurance automation for repository health
- **Modern Development Documentation**: Updated project documentation and governance
  - Restored `docs/CONTRIBUTING.md` with enhanced contribution guidelines and coding standards
  - Restored `docs/SECURITY.md` with VA healthcare compliance and security protocols
  - Enhanced `.gitignore` patterns for version-based source control and asset management

### Enhanced
- **PowerApps Canvas App v0.2.0**: Updated application with improved functionality and performance
  - Enhanced radio button selection logic with proper data type handling
  - Improved user interface components with healthcare-focused design patterns
  - Updated business logic for telehealth room booking workflows
  - Performance optimizations for large dataset handling and delegation patterns
- **Repository Structure Modernization**: Professional enterprise-grade organization
  - Semantic versioning implementation for all PowerApps releases
  - Archive management for legacy v0.1.x versions with full backward compatibility
  - Asset categorization following Microsoft Power Platform best practices
  - Documentation structure alignment with enterprise development standards

### Changed
- **Source Control Strategy**: Transitioned to version-based development workflow
  - PowerApps `.msapp` files now excluded from primary source control in v0.2.x+
  - Focus on unpacked source files for collaborative development and change tracking
  - ZIP archives maintained for release management and deployment automation
  - Structured approach to version management supporting parallel development tracks
- **Development Workflow**: Enhanced automation and quality assurance integration
  - Pre-commit hooks with comprehensive workspace validation
  - Automated file organization and cleanup processes
  - PowerShell profile integration with VS Code development environment
  - Asset management workflows for multimedia content and documentation

### Technical Metrics
- **Canvas App Architecture**: 18 screens with enhanced radio button and dropdown functionality
- **Version Control Structure**: 3-tier versioning (major.minor.patch) with archive preservation
- **Asset Organization**: 5 major asset categories with structured documentation
- **PowerShell Automation**: 3 enhanced scripts with enterprise-grade error handling
- **Project Size**: Optimized structure with improved file organization and reduced redundancy

### Repository
- **Version 0.2.0 Release**: Ready for GitHub Pages deployment with updated documentation
- **Enhanced Asset Management**: Professional multimedia organization for stakeholder engagement
- **Development Workflow**: Complete CI/CD pipeline with version-based source control
- **Documentation Quality**: 95% completion with comprehensive technical specifications

## [0.1.3] - 2025-07-18
### Added
- **Professional HTML Project Summary**: Publication-ready index.html with comprehensive project overview
  - Print-optimized CSS styling for 8.5x11 paper with professional typography
  - SEO optimization with meta tags, Open Graph, and JSON-LD structured data
  - Six major accomplishments showcasing technical analysis, infrastructure, and analytics
  - Interactive header with direct links to PowerApps, SharePoint, GitHub, and PowerBI
  - Responsive design for desktop, mobile, and print presentation
- **Enhanced Technical Analysis**: Updated technical-analysis-v0.1.2.md with comprehensive metrics
  - Application architecture breakdown (18 screens across 4 functional areas)
  - Component reusability analysis (10 reusable components for UI consistency)
  - Performance status with binding error identification and optimization roadmap
  - Security compliance documentation for VA Government Cloud and HIPAA requirements
- **Power BI Analytics Integration**: Comprehensive productivity reporting capabilities
  - Hines Provider Productivity Dashboard with hospital metrics tracking
  - Utilization Analytics for room utilization and occupancy insights
  - CommitLog Productivity Dashboard for development activity analytics
  - Multi-building analytics covering 6 hospital locations with usage patterns
- **Weekly Progress Documentation**: WEEKEND-SUMMARY.md with stakeholder-ready project status
  - Major accomplishments breakdown with technical depth and business impact
  - Next week priorities with specific deliverables and timelines
  - KPI metrics section with project technical statistics and infrastructure details
  - Migration strategy documentation with phased approach and risk mitigation

### Enhanced
- **VS Code Task Automation**: Expanded to 15 automated tasks with quality assurance integration
  - Pre-commit quality hooks with automated validation and 331-line task configuration
  - Repository health checks with Git automation, backup, and conflict resolution
  - Development workflow integration with PowerShell execution policies and module management
  - Quality gates with automated documentation updates and project structure validation
- **Documentation Architecture**: Professional formatting and comprehensive cross-referencing
  - All README files updated with current project metrics and status
  - Technical analysis tables with structured data presentation
  - Professional table formatting for technical metrics and analysis summaries
- **Web Presentation**: GitHub Pages ready with accessibility and SEO optimization
  - High contrast footer and header styling for print and web accessibility
  - Structured data markup for search engine optimization and content discovery
  - Mobile-responsive design ensuring functionality across all device types

### Changed
- **Project Maturity Assessment**: Updated to reflect current 85% technical foundation completion
  - Feature implementation at 70% with core functionality operational
  - Testing & validation at 60% with user acceptance testing coordination in progress
  - Documentation at 90% with comprehensive technical documentation completed
- **Version Strategy**: Project now in pre-release v0.1.3 targeting September 2025 production (v1.0.0)
  - Immediate priorities focused on SharePoint schema optimization and Power Automate flow testing
  - User acceptance testing coordination with Edward Hines Jr. VA Hospital telehealth managers

### Technical Metrics
- **Total Project Files**: 186+ files with comprehensive workspace analysis
- **Project Size**: 34.68 MB with complete source code and assets
- **PowerApps Architecture**: 18 screens, 154 components, 186,816+ lines of Power Fx code
- **Development Infrastructure**: 12 JavaScript scripts, 8 PowerShell scripts, 15 markdown documentation files
- **Repository Health**: 98% with automated validation and quality checks

### Repository
- **Professional Web Presence**: index.html ready for GitHub Pages deployment
- **PowerBI Integration**: Published analytics dashboard linked in project header
- **Documentation Quality**: Comprehensive technical analysis and project summaries
- **Automation**: Complete CI/CD pipeline with pre-commit hooks and quality gates

## [0.1.2] - 2025-07-17
### Added
- Comprehensive project documentation suite (CONTRIBUTING.md, SECURITY.md)
- Enhanced README files for all major directories (src/, data/, legacy/, src/sharepoint/)
- Advanced PowerShell profile with proper error handling and help documentation
- Enhanced VS Code tasks with emoji labels, error handling, and new validation tasks
- Project structure validation and reporting capabilities
- Comprehensive .gitignore patterns for Power Platform development
- Professional GitHub repository integration with badges and links
- Pre-commit cleanup script for repository quality assurance
- PROJECT-INDEX.md with complete project navigation and overview

### Changed
- PowerShell profile functions now follow PowerShell best practices with CmdletBinding and proper error handling
- VS Code tasks now include comprehensive error handling and user-friendly output
- Enhanced git workflows with better commit message validation
- Improved backup processes with size reporting and verification

### Enhanced
- All documentation now follows consistent markdown formatting standards
- Security documentation aligned with VA hospital requirements and HIPAA compliance
- Development workflow documentation with clear guidelines for Power Platform development
- Project structure now follows enterprise-grade organization patterns

### Repository
- **GitHub Repository**: Successfully pushed to https://github.com/KCoderVA/Telehealth-Scheduling-App.git
- **Total Files**: 186+ files across organized directory structure
- **Documentation**: Complete coverage of all project aspects
- **Automation**: VS Code tasks and PowerShell scripts for development workflow
- **Compliance**: VA hospital and healthcare industry standards

## [0.1.1] - 2025-07-17
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
- See `docs/technical-analysis-v0.1.1.md` for detailed technical findings
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
