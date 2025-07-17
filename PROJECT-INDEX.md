# Project Index - Telehealth Resources

Welcome to the comprehensive project index for the Telehealth Resources Project. This document provides a complete overview of all project components, documentation, and resources.

## 📋 Table of Contents
- [Quick Navigation](#quick-navigation)
- [Core Documentation](#core-documentation)
- [Source Code Structure](#source-code-structure)
- [Development Tools](#development-tools)
- [Data & Resources](#data--resources)
- [Getting Started Guide](#getting-started-guide)

## 🧭 Quick Navigation

### Essential Project Files
| File | Purpose | Status |
|------|---------|--------|
| [README.md](README.md) | Project overview and quick start | ✅ Current |
| [CHANGELOG.md](CHANGELOG.md) | Version history and changes | ✅ Current |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Development guidelines and standards | ✅ Current |
| [SECURITY.md](SECURITY.md) | Security policies and compliance | ✅ Current |
| [LICENSE](LICENSE) | Apache 2.0 license terms | ✅ Current |

### Key Directories
| Directory | Contents | File Count | Purpose |
|-----------|----------|------------|---------|
| `/src/` | Source code and configurations | 154+ files | Main development code |
| `/docs/` | Technical documentation | 7 files | Project documentation |
| `/data/` | Excel schedules and Power BI reports | 4 files | Master data sources |
| `/legacy/` | VBA code and legacy systems | 3 files | Reference implementations |
| `/.github/` | GitHub/AI configuration | 2 files | Development automation |
| `/.vscode/` | VS Code workspace settings | 2 files | Development environment |

## 📚 Core Documentation

### Project Planning & Analysis
- **[Migration Implementation Plan](docs/migration-implementation-plan.md)** - 12-week development roadmap
- **[Technical Analysis v1.0.0](docs/technical-analysis-v1.0.0.md)** - Comprehensive system analysis
- **[Requirements Specification](docs/requirements.md)** - Functional and non-functional requirements
- **[Git Workflow Guide](docs/git-workflow-guide.md)** - Version control best practices

### Setup & Configuration
- **[Setup Guide](docs/setup.md)** - Development environment configuration
- **[Screen Preview Guide](docs/screen-preview-guide.md)** - PowerApps preview system usage
- **[Project Optimization Guide](docs/project-optimization-guide.md)** - Performance optimization techniques

### AI & Development Automation
- **[Copilot Instructions](.github/copilot-instructions.md)** - AI coding agent configuration
- **[AI Prompts](.github/ai-prompts.md)** - Predefined AI interaction templates

## 🏗️ Source Code Structure

### PowerApps Components (`/src/powerapps/`)
```
powerapps/
├── screens/                    # Individual screen JSON definitions (18 screens)
├── unpacked/                   # Complete unpacked PowerApps solution
├── PowerApps_HTML_Previewer/   # Development preview system
├── Generate-*.ps1              # Screen generation scripts
└── *.md                        # Technical documentation
```

**Key Features:**
- **578 Telehealth Resource App**: Production application with 18 functional screens
- **HTML Previewer System**: Complete development toolchain with GUI launcher
- **Screen Definitions**: JSON exports for version control and analysis
- **Automation Scripts**: PowerShell tools for development workflow

### SharePoint Integration (`/src/sharepoint/`)
```
sharepoint/
├── current-data-sources.md     # Data architecture documentation
└── README.md                   # Integration overview
```

**Data Architecture:**
- **3 SharePoint Lists**: Desks, Reservations, Admin Settings
- **Excel Online Bridge**: Aurora120/121 tables for legacy support
- **Security Model**: Role-based access with VA compliance

### Power Automate (Planned: `/src/power-automate/`)
- Approval workflows for booking requests
- Email notification templates
- Integration with hospital calendar systems
- Automated escalation processes

## 🛠️ Development Tools

### VS Code Integration
- **[VS Code Workspace](Telehealth Resources Project.code-workspace)** - Optimized workspace configuration
- **[Tasks Configuration](.vscode/tasks.json)** - Automated development tasks with emoji labels
- **Extensions**: Power Platform Tools, PowerFx, GitHub Copilot

### PowerShell Automation
- **[PowerShell Profile](powershell-profile.ps1)** - Enhanced development commands
- **Quick Commands**: `tele`, `pp`, `gq`, `bp`, `ps`, `ct`
- **Error Handling**: Comprehensive try-catch blocks and validation

### VS Code Tasks (Ctrl+Shift+P → Tasks: Run Task)
| Task | Description | Category |
|------|-------------|----------|
| 🚀 Daily Workflow Start | Complete development setup | Build |
| 📈 Project Status Check | Git status and project health | Test |
| 📦 Create Project Backup | Timestamped backup creation | Build |
| 🧹 Clean Temp Files | Remove temporary development files | Build |
| 🔍 Validate Project Structure | Check project organization | Test |
| 📋 Generate Project Report | Create status markdown report | Build |
| 🌐 Open All Power Platform Tools | Launch development tools | Build |

## 📊 Data & Resources

### Master Data Sources (`/data/`)
- **2025.07.11 Telehealth Master Schedule July 2025.xlsx** - Current production schedule
- **2025.07.10 TeleHealth Master Schedule 2025.xlsx** - Annual template
- **2025.07.03 TeleHealth Master Schedule (test copy).xlsx** - Development copy
- **Utilization.pbix** - Power BI analytics dashboard

### Legacy Systems (`/legacy/`)
- **VBA_ConferenceRoomScheduling_Fixed.vb** - Original booking logic
- **ConsolidateOakLawnTables.vb** - Building-specific data processing
- **ConsolidateOakLawnYearlySchedule.vb** - Annual schedule automation

### External Resources
- **[Hines Clinic Utilization - PowerBI](Hines Clinic Utilization (Detailed) - PowerBI.url)** - Analytics dashboard
- **[Project Email Assignment](2025.06.04 - Email Assignment from Brad.msg)** - Original project requirements

## 🚀 Getting Started Guide

### For New Developers
1. **Read Documentation**: Start with [README.md](README.md) and [CONTRIBUTING.md](CONTRIBUTING.md)
2. **Setup Environment**: Follow [Setup Guide](docs/setup.md)
3. **Run Daily Workflow**: Execute VS Code task "🚀 Daily Workflow Start"
4. **Review Architecture**: Study [Technical Analysis](docs/technical-analysis-v1.0.0.md)
5. **Begin Development**: Use PowerApps HTML Previewer for rapid iteration

### For Project Managers
1. **Project Status**: Run VS Code task "📈 Project Status Check"
2. **Progress Tracking**: Review [CHANGELOG.md](CHANGELOG.md) for recent updates
3. **Implementation Plan**: See [Migration Implementation Plan](docs/migration-implementation-plan.md)
4. **Security Compliance**: Review [SECURITY.md](SECURITY.md) for hospital requirements

### For Hospital IT Staff
1. **Security Review**: Start with [SECURITY.md](SECURITY.md)
2. **Compliance**: Verify VA Government Cloud requirements
3. **Data Integration**: Review [SharePoint Integration](src/sharepoint/README.md)
4. **Legacy Migration**: Examine [Legacy Systems](legacy/README.md)

## 📞 Support & Resources

### Project Team
- **Lead Developer**: Hospital Informatics Team
- **Stakeholders**: Telehealth Managers
- **IT Support**: VA Hospital IT Department

### Documentation Standards
- **Format**: Markdown with consistent headers and emoji
- **Updates**: All dates reflect current modifications
- **Validation**: Automated structure checking via VS Code tasks
- **Version Control**: All changes tracked in git with detailed commit messages

### Quality Assurance
- ✅ **Comprehensive Documentation**: All major components documented
- ✅ **Security Compliance**: VA and HIPAA requirements addressed
- ✅ **Development Automation**: VS Code tasks and PowerShell profile
- ✅ **Error Handling**: Robust error management throughout
- ✅ **Version Control**: Complete git history and backup procedures

---

## 📈 Project Metrics

| Metric | Value | Status |
|--------|-------|--------|
| **Total Files** | 186+ | Growing |
| **Documentation Files** | 15+ | Complete |
| **PowerApps Screens** | 18 | Functional |
| **VS Code Tasks** | 12+ | Automated |
| **PowerShell Functions** | 6+ | Enhanced |
| **Security Compliance** | VA + HIPAA | Verified |

---

*This index is automatically maintained and updated with each project release. For the most current information, always refer to the git repository and CHANGELOG.md.*

**Last Updated: July 17, 2025**
