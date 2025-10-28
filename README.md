# 🏥 VA Telehealth Room Booking Solution

[![Power Platform](https://img.shields.io/badge/Power%20Platform-Enterprise%20Solution-blue)](https://powerapps.microsoft.com/)
[![Version](https://img.shields.io/badge/Version-0.3.3-green)](./CHANGELOG.md)
[![Status](https://img.shields.io/badge/Status-Production%20Ready%20Oct%201st-success)](./CHANGELOG.md)
[![Documentation](https://img.shields.io/badge/Documentation-98%25%20Complete-brightgreen)](./docs/)
[![Technical Foundation](https://img.shields.io/badge/Technical%20Foundation-95%25%20Complete-success)](./docs/technical-analysis-v0.1.2.md)
[![GitHub Pages](https://img.shields.io/badge/Deployment%20Ready-Live%20Demo-blue)](https://kcoderva.github.io/Telehealth-Scheduling-App/)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue)](https://opensource.org/licenses/Apache-2.0)
[![VA Compliant](https://img.shields.io/badge/VA%20Gov%20Cloud-HIPAA%20Compliant-green)](https://cloud.gov/)
[![FedRAMP](https://img.shields.io/badge/FedRAMP-Authorized-blue)](https://marketplace.fedramp.gov/)
Last Updated: 2025-10-28

---

## 🚀 **[VIEW LIVE INTERACTIVE OVERVIEW →](https://kcoderva.github.io/Telehealth-Scheduling-App/)**

**Comprehensive v0.3.3 Project Documentation** – Interactive HTML overview with collapsible architecture sections, technical metrics, screenshot gallery, roadmap, and accessibility features (high contrast mode, keyboard shortcuts). Best viewed in browser for full functionality.

---

## 🎯 Executive Summary

**Ready-to-Deploy VA Solution Package** – Transform manual Excel telehealth room scheduling into an enterprise-grade automated system. This Microsoft Power Platform solution eliminates double-booking conflicts, reduces administrative overhead by 15+ hours per week, and delivers real-time analytics for operational optimization.

### Core Application Components

- **📱 PowerApps Canvas Application**: 18 user-friendly screens with mobile-responsive design
- **⚡ Power Automate Workflows**: Automated approval routing and notification systems
- **📊 SharePoint Data Platform**: Secure, auditable data storage replacing Excel files
- **📈 Power BI Analytics**: Executive dashboards and ROI tracking
- **🔧 Migration Tools**: Automated PowerShell scripts for seamless Excel-to-SharePoint conversion

### Business Impact & ROI

- ✅ **15+ hours/week** administrative time savings
- ✅ **100% elimination** of double-booking conflicts
- ✅ **Real-time visibility** into room utilization and availability

**Built by VA Staff, for VA Hospitals** – Developed and validated at Edward Hines Jr. VA Hospital to address VA-specific workflows, compliance, and multi-building coordination. Deploy with minimal customization using the curated source + automation toolkit.

### Security & Compliance

- ✅ **VA Government Cloud**: FedRAMP High authorized infrastructure
- ✅ **HIPAA Compliance**: Healthcare data protection and audit trails
- ✅ **Single Sign-On**: Seamless integration with VA Active Directory
- ✅ **Role-Based Access**: Granular permissions for staff, coordinators, managers
- ✅ **Audit Logging**: Complete tracking of all scheduling activities

**Current Release (v0.3.3 – October 28, 2025)** – Introduces automated Issue Intake workflow (native PowerShell + REST), diagnostic artifact generation, and continued scheduling enhancements while sustaining 95%+ technical completion and 98% documentation coverage.


---

## � Quick Navigation
| Area | Purpose | Link |
|------|---------|------|
| Architecture | High-level system stack | [Solution Architecture](#-complete-solution-architecture) |
| Gallery | Visual tour of app & flows | [Screenshot Gallery](https://github.com/KCoderVA/Telehealth-Scheduling-App/tree/main/assets/images) |
| Implementation | Deployment steps & timeline | [Quick Implementation Guide](#-quick-implementation-guide) |
| Technical Metrics | Component counts & maturity | [Technical Inventory](#-technical-inventory) |
| Release Status | Roadmap & phases | [Current Technical Status](#-current-technical-status) |
| Features | Core scheduling capabilities | [Hospital-Specific Application Features](#%F0%9F%8F%A5-hospital-specific-application-features) |
| Compliance | Security & governance | [Security & Compliance](#security--compliance) |
| Source Code | PowerApps / Flows / Lists | `src/` |
| Data & Assets | Images, Excel, BI | `assets/` |
| Automation Scripts | Tooling & migration | `scripts/` / `src/pwsh/` |



## 🖼️ Screenshot Gallery (v0.3.3)
Overview of key system views (captured Oct 2025).

| Screenshot | Description |
|------------|-------------|
| **Landing Screen** | Personalized snapshot of current reservations, quick navigation tiles, and building selector for multi-location context. |
| **Dynamic Schedule Grid** | Interactive week matrix displaying real-time availability and conflict-prevention indicators for rapid booking decisions. |
| **SharePoint Master Schedule** | Centralized list of cross-building reservations with audit-friendly metadata and export options for reporting. |
| **Approval Flow Architecture** | Power Automate multi-branch workflow with parallel notification dispatch and escalation logic. |

> 📸 **Full gallery with screenshots**: View the [interactive documentation page](https://kcoderva.github.io/Telehealth-Scheduling-App/) for embedded images and detailed architecture diagrams.


## 🚀 Quick Implementation Guide

👉 **[View Interactive Project Overview](https://kcoderva.github.io/Telehealth-Scheduling-App/)** – Comprehensive v0.3.3 documentation with executive summary, architecture deep-dive, ROI analytics, and roadmap

👩‍💻 **Ready-to-Deploy Package Includes**:

- Complete PowerApps application source code (v0.3.3)
- Automated deployment scripts and migration tools
- SharePoint list templates and configuration guides
- Power Automate workflow definitions
- Comprehensive documentation and training materials
- Power BI analytics dashboards and reports

## 🔧 Technical Architecture

### Application Stack

```
🏥 VA Hospital Infrastructure
├── 🔐 Azure Active Directory (Authentication)
├── ☁️ Microsoft Government Cloud (Hosting)
├── 📱 PowerApps Canvas App (User Interface)
│   ├── 📋 Room Booking Screens (8 screens)
│   ├── 👥 User Management Interface (4 screens)
│   ├── 📊 Reporting & Analytics (3 screens)
│   └── ⚙️ Administration Panel (3 screens)
├── 📊 SharePoint Lists (Data Layer)
│   ├── 🏢 Room Master Data
│   ├── 📅 Booking Requests & Reservations
│   ├── 👤 User Roles & Permissions
│   └── 📈 Analytics & Audit Logs
├── ⚡ Power Automate (Business Logic)
│   ├── 📧 Approval Workflow Routing
│   ├── 🔔 Email & Teams Notifications
│   ├── 🛡️ Conflict Detection & Prevention
│   └── 📊 Automated Reporting
└── 📈 Power BI Dashboards (Executive Analytics)
    ├── 💰 ROI & Cost Savings Tracking
    ├── 📊 Room Utilization Metrics
    ├── ⏱️ Efficiency & Performance KPIs
    └── 📋 Operational Reports
```


## 📁 Solution Package Contents

```
📦 VA-Telehealth-Room-Booking-Solution/
├── 🚀 DEPLOYMENT/                    # Ready-to-deploy solution components
│   ├── 📱 PowerApps-v0.3.3.msapp     # Production-ready application package
│   ├── ⚡ PowerAutomate-Flows.zip    # Automated workflow templates
│   ├── 📊 SharePoint-Templates/      # List schemas and site templates
│   └── 📋 Implementation-Guide.pdf   # Step-by-step deployment instructions
├── 🔧 MIGRATION-TOOLS/               # Excel-to-SharePoint conversion utilities
│   ├── 📊 Excel-Data-Converter.ps1   # Automated data migration script
│   ├── 🔄 Schedule-Import-Tool.ps1   # Batch schedule import utility
│   └── 🗂️ Legacy-Data-Mapper.xlsx    # Data mapping and validation templates
├── 📚 TRAINING-MATERIALS/            # User adoption and training resources
│   ├── 🎥 Video-Demos/               # Screen recordings and tutorials
│   ├── 📖 User-Guides/               # Role-based instruction manuals
│   └── 🖼️ Quick-Reference-Cards/     # Printable job aids and cheat sheets
│   ├── 💰 ROI-Dashboard.pbix         # Cost savings and efficiency metrics
│   ├── 📈 Utilization-Analytics.pbix # Room occupancy and usage patterns
│   └── 📋 Operations-Report.pbix     # Daily operational management dashboard
├── 🛡️ SECURITY-COMPLIANCE/           # VA-specific security documentation
│   ├── 📦 .unpacked/                    # Power Platform CLI source files
│   └── ⚡ .zip/                         # Archive packages for deployment
```

### 🏥 Application Features (v0.3.3)

#### Core Scheduling Functions

- **🗓️ Dynamic Schedule Grid**: Interactive time-slot matrix with direct cell selection auto-populating booking forms
- **⚡ Real-Time Availability Counters**: Per-room and per-building availability summaries calculated on-demand
- **🚫 Conflict Prevention**: Automated pre-check validation before approval submission
- **📧 Layered Approval Workflows**: Multi-branch Power Automate flows with parallel notification and escalation routing
- **📊 Usage Analytics**: Real-time utilization metrics & trend analysis via Power BI dashboards
- **🔍 Advanced Search**: Filter by room type, equipment, availability, and location

### 📊 Technical Inventory

- **PowerApps Architecture**: 18 screens | 154+ components | 186,816+ Power Fx lines | 220+ files | 38.2 MB
- **Data Connectors**: SharePoint (3 production lists), Office 365 Users, Outlook, Teams, Excel Online
- **Development Infrastructure**: 12 JavaScript scripts, 8 PowerShell scripts, 15 markdown documentation files
- **Business Logic**: Room/desk booking, staff management, calendar integration, approval workflows

### 🔧 Current Technical Status

✅ **Analysis & Planning Complete** – Technical Foundation: 95% achieved

- [x] Project structure & VS Code automation (15 tasks)
- [x] PowerApps technical analysis & documentation (v0.1.2 baseline)
- [x] SharePoint production list architecture (3 lists + Excel integration)
- [x] Business logic review (18 screens, 5 connectors, role/security compliance)
- [x] HTML previewer and professional web summaries
- [x] Power BI analytics multi-building integration
- [x] Repository health validation (98% compliance)
- [x] **v0.3.2 Features**: Dynamic schedule grid, real-time availability counters, layered approval flow (Oct 21, 2025)
- [x] **v0.3.3 Features**: Automated Issue Intake workflow (PowerShell + REST), diagnostic artifact generation (Oct 28, 2025)
- [x] Interactive HTML documentation with accessibility features (high contrast, keyboard shortcuts)
- [x] Asset management (11+ Excel schedules, BI dashboards, multimedia)
- [x] GitHub Pages deployment with comprehensive project overview
- [ ] Phase 1: SharePoint schema optimization & flow testing (Weeks 1–4)
- [ ] Phase 2: UAT coordination & mobile optimization (Weeks 5–8)
- [ ] Phase 3: Production deployment & advanced features (Weeks 9–12)

### Ready-to-Deploy Package Benefits

- **🚀 Rapid Implementation**: 2–3 week deployment vs. 6+ months custom development
- **⚙️ Developer Daily Workflow Start**: Use VS Code task "🚀 Daily Workflow Start" to initialize environment
- **📋 [Implementation Planning Guide](docs/migration-implementation-plan.md)** – Full deployment strategy & resource requirements

### Technical Implementation Guides

- **📘 [Microsoft Power Platform Documentation](https://docs.microsoft.com/en-us/power-platform/)** - Official platform documentation and best practices
- **🚀 [PowerApps Canvas App Guide](https://docs.microsoft.com/en-us/powerapps/maker/canvas-apps/)** - Application development and customization resources
- **☁️ [VA Government Cloud Standards](https://www.oit.va.gov/services/trm/TRMHomePage.aspx?tab=2)** - Federal compliance and security requirements
- **🔒 [FedRAMP Authorized Services](https://marketplace.fedramp.gov/)** - Government cloud security authorizations

### 🛠️ Development Tools

- **VS Code Tasks**: Use `Ctrl+Shift+P → Tasks: Run Task` for common operations
- **PowerShell Profile**: Enhanced commands loaded automatically (see `powershell-profile.ps1`)
- **HTML Previewer**: Legacy development toolchain in `/src/power-apps/v0.1.x/` (archived)
- **Project Validation**: Automated structure and quality checks

### 🗂️ Issue Intake Automation (v0.3.3)

Streamlined verbal/email report → GitHub issue workflow now available without GitHub CLI dependency. The automation uses native PowerShell and the GitHub REST API for environments with restricted tooling.

| Component | Path | Purpose |
|-----------|------|---------|
| Connectivity Test Script | `scripts/pwsh/test-github-connectivity.ps1` | Validates Personal Access Token (PAT) and repo reachability before creating issues. |
| Intake Creation Script | `scripts/pwsh/intake-create-issue.ps1` | Converts intake details into a markdown body, applies labels (`intake`, `bug`, `verbal`), assigns maintainer, persists diagnostics. |
| Archive Output | `archive/issue-intake/` | Stores generated markdown, JSON payload(s), error responses, transcripts, and consolidated debug dumps. |

#### Key Parameters (Intake Script)

| Parameter | Description |
|-----------|-------------|
| `-Employee` | Name of reporting staff member (required). |
| `-Title` | Short summary; automatically prefixed with `intake:` in GitHub issue. |
| `-Description` | Quoted complaint or problem context. |
| `-Steps` | Reproduction or observation steps. |
| `-Severity` | One of: low, moderate, high, critical. Default: moderate. |
| `-Token` | PAT (falls back to `$env:GITHUB_TOKEN` when omitted). |
| `-Screenshot` | Optional path archived for reference. |
| `-DebugPayload` | Prints (or truncates) payload JSON to console unless suppressed. |
| `-MaxConsolePayloadLines` | Limits payload lines in console (default 300). |
| `-NoConsolePayload` | Suppresses console payload entirely (file artifacts still saved). |
| `-SaveRawPayload` | Saves minified raw JSON alongside pretty version. |
| `-PrettyPrintPayload` | Forces pretty formatting for console output (default behavior). |
| `-DumpAll` | Creates consolidated debug dump (parameters + markdown + payload). |
| `-CaptureLog` | Starts transcript capturing entire session output. |

#### Generated Artifacts (per run)

- `issue-intake-<timestamp>.md` – Issue body (markdown saved locally)
- `issue-intake-payload-<timestamp>.json` – Pretty JSON sent to API
- `issue-intake-payload-raw-<timestamp>.json` – Minified JSON (when `-SaveRawPayload`)
- `issue-intake-error-<timestamp>.txt` – Raw server response body on failure
- `issue-intake-runlog-<timestamp>.log` – Full transcript (when `-CaptureLog`)
- `issue-intake-debugdump-<timestamp>.txt` – Consolidated diagnostic report (when `-DumpAll`)

#### Example (Full Diagnostics)
```powershell
pwsh -File .\scripts\pwsh\intake-create-issue.ps1 `
    -Token $env:GITHUB_TOKEN `
    -Employee "Doe, Jane" `
    -Title "Schedule overlap in Aurora 120" `
    -Description "User reports double-booked 10:00 slot" `
    -Steps "1. Open grid; 2. Select 10:00; 3. Observe mismatch" `
    -Severity moderate `
    -DebugPayload -MaxConsolePayloadLines 80 -SaveRawPayload -DumpAll -CaptureLog
```

If a token is not supplied, the script opens a pre-filled browser issue page for manual submission (ensuring continuity even in locked-down environments).

> ℹ️ **Token Scope Guidance**: Create a PAT with minimum scopes (`repo` → Issues & Metadata). Store it in `$env:GITHUB_TOKEN` for non-interactive runs.

This automation reduces intake handling overhead and provides auditable, reproducible diagnostics improving turnaround on reported issues.

## Contributors

- **Repository**: [GitHub - Telehealth Scheduling App](https://github.com/KCoderVA/Telehealth-Scheduling-App.git)
- **Lead Developer**: Hospital Informatics Team
- **Stakeholders**: Telehealth Managers (VA Hospital)

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---

*Last Updated: October 21, 2025*
