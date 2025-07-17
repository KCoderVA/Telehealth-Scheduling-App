# Commit Log Productivity Dashboard

**A portable, self-contained git activity reporting solution**

---

## 🎯 Overview

This is a **completely portable** git dashboard system that can be copied to any git repository to provide instant development activity reporting. The system automatically detects the git repository location and generates comprehensive productivity reports.

### ✨ Key Features
- **🔄 Auto-Detection** - Automatically finds git repository from any subfolder location
- **📊 Visual Dashboard** - Interactive HTML interface with charts and metrics
- **📅 Flexible Date Ranges** - Custom periods or quick selectors (today, this week, etc.)
- **📁 Multiple Export Formats** - JSON, CSV, and HTML report generation
- **🚀 One-Click Launch** - Batch file for non-technical users
- **📱 Mobile Responsive** - Works on desktop, tablet, and mobile devices
- **🔒 Secure & Local** - No external dependencies or data transmission

---

## 📦 What's Included

### Core Files
- **`git-activity-dashboard.html`** - Main interactive dashboard
- **`Get-GitActivity.ps1`** - PowerShell script for git data extraction
- **`git-dashboard-api.js`** - JavaScript bridge for data processing
- **`Launch-Git-Dashboard.bat`** - User-friendly launcher script

### Documentation
- **`MANAGER-GUIDE.md`** - Complete guide for supervisors and managers
- **`GIT-DASHBOARD-README.md`** - Technical documentation and setup guide
- **`README.md`** - This file (portable version overview)

### Generated Data Files *(created when run)*
- **`git-activity-data.json`** - Live dashboard data
- **`git_activity_report_[timestamp].json`** - Archived reports

---

## 🚀 Quick Start

### Option 1: One-Click Launch (Recommended)
1. **Copy this entire folder** to any git repository (root or subfolder)
2. **Double-click** `Launch-Git-Dashboard.bat`
3. **Select date range** (or use default last 7 days)
4. **Dashboard opens automatically** in your browser

### Option 2: Manual Execution
1. Open PowerShell in this folder
2. Run: `.\Get-GitActivity.ps1 -StartDate "2025-07-10" -EndDate "2025-07-17"`
3. Open `git-activity-dashboard.html` in any browser
4. Use dashboard controls for different views

---

## 📊 Dashboard Features

### Summary Cards
- **Total Commits** - Development activity frequency
- **Files Modified** - Project scope and breadth
- **Lines Added** - Code productivity (new development)
- **Productivity Score** - Algorithmic assessment (0-100%)

### Detailed Reports
- **Commit Timeline** - Chronological development history
- **File Statistics** - Lines added/removed per commit
- **Professional Messages** - Business context and accomplishments
- **Export Options** - Save reports for records and sharing

### Interactive Controls
- **Date Pickers** - Custom range selection
- **Quick Filters** - Today, Yesterday, This Week, Last Month, etc.
- **Report Types** - Summary only, Detailed only, or Both views
- **Real-time Refresh** - Update with latest commits

---

## 🔧 Portability Features

### Auto-Repository Detection
The dashboard automatically:
- **Searches upward** from its location to find `.git` folder
- **Works from any subfolder** within a git repository
- **Handles relative paths** correctly regardless of placement
- **Provides clear error messages** if no git repository is found

### Copy & Paste Setup
1. **Copy entire folder** to new git repository
2. **No configuration needed** - works immediately
3. **Maintains all functionality** across different projects
4. **Independent operation** - no external dependencies

---

## 📈 Use Cases

### For Developers
- **Daily standup prep** - Quick activity summary
- **Code review preparation** - See what changed and when
- **Personal productivity tracking** - Monitor development velocity
- **Project documentation** - Export reports for records

### For Managers
- **Team oversight** - Non-intrusive activity monitoring
- **Performance reviews** - Objective productivity metrics
- **Project planning** - Assess development capacity and speed
- **Client reporting** - Professional activity summaries

### For Teams
- **Sprint reviews** - Comprehensive development activity
- **Retrospectives** - Analyze productivity patterns
- **Knowledge sharing** - See who worked on what
- **Quality assurance** - Track code changes and patterns

---

## 🔒 Security & Privacy

### Local Processing Only
- **No external API calls** - all data stays on your network
- **No cloud services** - completely self-contained
- **No personal data collection** - only professional git metrics
- **File system permissions** - uses existing access controls

### Hospital/Enterprise Ready
- **VA compliant** - meets federal security requirements
- **Audit trail** - complete activity logging
- **Network drive compatible** - works on shared storage
- **Configurable retention** - manage report archiving

---

## 🛠️ Technical Requirements

### Prerequisites
- **Windows PowerShell 5.1+** (pre-installed on Windows 10/11)
- **Git installed** and accessible from command line
- **Modern web browser** (Chrome, Edge, Firefox, Safari)
- **Git repository** (local or network accessible)

### Compatibility
- **Windows 10/11** - Full functionality
- **Network drives** - Works on shared storage
- **Multiple repositories** - Copy to any number of projects
- **Team sharing** - Multiple users can access same dashboard

---

## 🔍 Troubleshooting

### Common Issues

**"No git repository found"**
- Ensure this folder is placed within a git repository
- Check that `.git` folder exists somewhere above this location
- Verify git is installed: run `git --version` in command prompt

**"PowerShell script failed"**
- Right-click batch file → "Run as Administrator"
- Check execution policy: `Get-ExecutionPolicy` in PowerShell
- Ensure git commands work: run `git log` manually

**"Dashboard shows demo data"**
- Run `Launch-Git-Dashboard.bat` first to generate real data
- Check that `git-activity-data.json` was created
- Refresh browser page after running PowerShell script

### Performance Tips
- **Large repositories** - Use shorter date ranges (1-2 weeks)
- **Many commits** - Consider filtering by author if needed
- **Network drives** - Copy to local drive for faster processing
- **Old data** - Archive old reports to save disk space

---

## 📋 Customization

### Date Range Defaults
Edit `Launch-Git-Dashboard.bat` to change default date ranges:
```batch
REM Set default to last 14 days instead of 7
for /f %%i in ('powershell -command "(Get-Date).AddDays(-14).ToString('yyyy-MM-dd')"') do set START_DATE=%%i
```

### Dashboard Branding
Edit `git-activity-dashboard.html` to customize:
- **Colors and themes** - Modify CSS variables
- **Company branding** - Update header and titles
- **Metric calculations** - Adjust productivity scoring

### Export Templates
Edit `Get-GitActivity.ps1` to customize report formats:
- **Add new export formats** (PDF, Excel, etc.)
- **Include additional git metadata** (branches, tags, etc.)
- **Modify productivity algorithms** - Custom scoring logic

---

## 📞 Support

### For Technical Issues
- Check `GIT-DASHBOARD-README.md` for detailed troubleshooting
- Verify all prerequisite software is installed
- Test git commands manually: `git log --oneline --since="1 week ago"`

### For Usage Questions
- Review `MANAGER-GUIDE.md` for comprehensive usage instructions
- Try different date ranges and report types
- Use browser developer tools (F12) to check for JavaScript errors

---

## 🚀 Getting Started Checklist

- [ ] Copy this entire folder to a git repository
- [ ] Double-click `Launch-Git-Dashboard.bat` to test
- [ ] Select appropriate date range for your needs
- [ ] Verify dashboard opens and shows data
- [ ] Try different report types and export options
- [ ] Share folder location with team members as needed

---

**Version**: 1.0.0 - Portable Edition
**Last Updated**: July 17, 2025
**Compatibility**: Any git repository on Windows systems
**License**: Apache 2.0

---

*This dashboard is designed to be copied and used across multiple git repositories. Each copy operates independently and automatically adapts to its local git repository.*
