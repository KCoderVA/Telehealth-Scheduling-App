# Git Activity Dashboard System

**A comprehensive HTML-based reporting solution for git repository activity tracking**

---

## 🎯 System Overview

This system provides an elegant, browser-based dashboard that automatically analyzes git commit history and presents development activity in both summary and detailed views. Designed specifically for management reporting and team accountability.

### Key Features
- **📊 Visual Dashboard** - Interactive HTML interface with charts and metrics
- **🔄 Real-time Data** - Pulls live data from local git repository
- **📅 Date Range Filtering** - Flexible time period selection
- **📁 Export Capabilities** - Generate reports in JSON, CSV, and HTML formats
- **🚀 One-Click Launch** - Batch file automation for non-technical users
- **📱 Mobile Responsive** - Works on desktop, tablet, and mobile devices

---

## 📦 System Components

### Core Files
1. **`git-activity-dashboard.html`** - Main dashboard interface
2. **`Get-GitActivity.ps1`** - PowerShell backend for git data extraction
3. **`git-dashboard-api.js`** - JavaScript bridge connecting frontend to backend
4. **`Launch-Git-Dashboard.bat`** - User-friendly launcher script
5. **`MANAGER-GUIDE.md`** - Comprehensive guide for supervisors/managers

### Generated Files
- **`git-activity-data.json`** - Live data file updated by PowerShell script
- **`git_activity_report_[timestamp].json`** - Exported report archives
- **Generated exports** - CSV, HTML, and JSON report files

---

## 🚀 Quick Start

### For Managers/Supervisors
1. Double-click `Launch-Git-Dashboard.bat`
2. Choose date range (or use default last 7 days)
3. Dashboard opens automatically in browser
4. View activity summary and detailed reports

### For Developers
1. Run: `.\Get-GitActivity.ps1 -StartDate "YYYY-MM-DD" -EndDate "YYYY-MM-DD"`
2. Open `git-activity-dashboard.html` in browser
3. Use dashboard controls for different views and exports

---

## 📊 Dashboard Features

### Summary View
- **Total Commits** - Development activity frequency
- **Files Modified** - Scope of work across project
- **Lines Added/Removed** - Code productivity metrics
- **Productivity Score** - Algorithmic assessment (0-100%)

### Detailed View
- **Commit Timeline** - Chronological development history
- **File Statistics** - Per-commit file and line change data
- **Professional Messages** - Commit descriptions with business context
- **Hash References** - Git commit identifiers for tracking

### Interactive Controls
- **Date Pickers** - Custom range selection
- **Quick Filters** - Today, Yesterday, This Week, This Month, etc.
- **Report Types** - Summary only, Detailed only, or Both
- **Export Options** - Multiple format support for different use cases

---

## 🔧 Technical Architecture

### Frontend (HTML/JavaScript)
- **Responsive Design** - Bootstrap-style CSS grid system
- **Real-time Updates** - Live data loading from JSON files
- **Interactive Charts** - Visual summary cards with metrics
- **Export Engine** - Client-side file generation

### Backend (PowerShell)
- **Git Integration** - Direct repository analysis using git commands
- **Data Processing** - Commit parsing and statistical analysis
- **JSON Generation** - Structured data output for dashboard consumption
- **Error Handling** - Comprehensive validation and user feedback

### Data Flow
```
Git Repository → PowerShell Script → JSON Data File → HTML Dashboard → User Reports
```

---

## 📈 Metrics & Analytics

### Productivity Scoring Algorithm
```
Productivity Score = min(100, (commits × 10) + (lines_added ÷ 100))
```

### Key Performance Indicators
- **Commit Frequency** - Regular development activity
- **Code Volume** - Lines of code produced
- **File Diversity** - Breadth of project involvement
- **Message Quality** - Professional commit documentation

### Business Intelligence
- **Trend Analysis** - Activity patterns over time
- **Workload Assessment** - Developer capacity and output
- **Project Velocity** - Feature development speed
- **Quality Metrics** - Code changes and refactoring ratios

---

## 🔒 Security & Compliance

### Data Privacy
- **Local Processing Only** - No external data transmission
- **Repository Access** - Read-only git history analysis
- **No Personal Data** - Only professional development metrics
- **Secure Storage** - All data remains on local/network drives

### Hospital Compliance
- **VA Security Standards** - Meets healthcare data requirements
- **Audit Trail** - Complete activity logging
- **Access Control** - File-system based permissions
- **Data Retention** - Configurable report archiving

---

## 🛠️ Installation & Setup

### Prerequisites
- Windows PowerShell 5.1 or later
- Git installed and accessible from command line
- Modern web browser (Chrome, Edge, Firefox)
- Access to git repository directory

### Installation Steps
1. Copy all system files to git repository root directory
2. Ensure PowerShell execution policy allows local scripts
3. Test by running `Launch-Git-Dashboard.bat`
4. Verify dashboard opens and displays data

### Configuration
- **Date Ranges** - Modify default ranges in batch launcher
- **Export Formats** - Customize output templates in PowerShell script
- **UI Styling** - Update CSS in HTML dashboard for branding
- **Data Sources** - Configure for multiple repositories if needed

---

## 📋 Usage Scenarios

### Daily Standups
- Quick activity summary for team meetings
- Yesterday's commits and accomplishments
- Current project momentum assessment

### Weekly Reviews
- Comprehensive development activity analysis
- Productivity trend identification
- Resource allocation planning

### Monthly Reporting
- Executive dashboard for management
- Performance evaluation support
- Project milestone tracking

### Ad-hoc Analysis
- Custom date range investigations
- Specific feature development tracking
- Code review preparation

---

## 🔧 Customization Options

### Dashboard Theming
- Color scheme modification
- Logo and branding integration
- Layout customization for different screen sizes

### Data Extensions
- Additional git metadata inclusion
- Integration with project management tools
- Custom productivity algorithms

### Export Enhancements
- PDF report generation
- Excel template integration
- Automated email distribution

### Multi-Repository Support
- Aggregate reporting across projects
- Team-wide activity dashboards
- Organizational development metrics

---

## 🐛 Troubleshooting

### Common Issues
- **PowerShell Execution Policy** - Run as administrator or modify policy
- **Git Command Access** - Ensure git is in system PATH
- **File Permissions** - Verify read/write access to directory
- **Browser Compatibility** - Use modern browser for full functionality

### Debug Mode
- Add `-Verbose` flag to PowerShell script for detailed logging
- Check browser console for JavaScript errors
- Verify JSON data file generation and format

### Performance Optimization
- Large repositories may require date range limiting
- Consider archiving old commits for faster processing
- Use SSD storage for better I/O performance

---

## 📞 Support & Maintenance

### Regular Maintenance
- **Weekly** - Clear old export files to save disk space
- **Monthly** - Verify PowerShell script compatibility
- **Quarterly** - Update dashboard UI for new features

### Version Updates
- Monitor git software updates for compatibility
- Test PowerShell script with new Windows updates
- Update browser compatibility as needed

### Backup Strategy
- Export configuration files regularly
- Archive important reports to permanent storage
- Maintain system documentation currency

---

## 🏥 Hospital Implementation Notes

### Integration with VA Systems
- Compatible with VA network security policies
- Follows federal data handling requirements
- Supports existing IT infrastructure

### Training Requirements
- **Managers** - 15-minute overview using MANAGER-GUIDE.md
- **Developers** - Basic PowerShell and git knowledge
- **IT Support** - Standard Windows administration skills

### Compliance Considerations
- All data processing occurs locally
- No external web services or cloud dependencies
- Full audit trail of all system interactions
- Configurable data retention policies

---

**System Version**: 1.0.0
**Last Updated**: July 17, 2025
**Compatibility**: Windows 10/11, PowerShell 5.1+, Modern Browsers
**License**: Apache 2.0
