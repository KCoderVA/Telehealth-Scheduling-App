# Development Setup Guide

## Prerequisites
- Windows 10/11 with PowerShell 5.1+
- Visual Studio Code with recommended extensions
- Microsoft 365 Business/Enterprise license
- SharePoint Online access
- PowerApps Developer license (or included in M365)

## Required VS Code Extensions

### Essential Extensions (Already Installed)
- ✅ **Power Platform Tools** (`microsoft-isvexptools.powerplatform-vscode`)
- ✅ **Power Fx** (`powerappstools.powerfx`)
- ✅ **Power Query** (`powerquery.vscode-powerquery`)
- ✅ **Power Platform Connectors** (`daniellaskewitz.power-platform-connectors`)
- ✅ **Dataverse DevTools** (`danish-naglekar.dataverse-devtools`)
- ✅ **SQL Server** (`ms-mssql.mssql`)
- ✅ **Power BI** (`gerhardbrueckl.powerbi-vscode`)

### Development Tools
- ✅ **GitHub Copilot** (`github.copilot`)
- ✅ **Path IntelliSense** (`christian-kohler.path-intellisense`)
- ✅ **YAML Support** (`redhat.vscode-yaml`)
- ✅ **Docs Authoring** (`docsmsft.docs-markdown`)

## Environment Setup

### 1. PowerApps Development Environment
```powershell
# Open PowerApps Studio
start https://make.powerapps.com/

# Create new environment (if needed)
# Navigate to Admin center > Environments > New
```

### 2. SharePoint Site Setup
```powershell
# Open SharePoint Admin Center
start https://admin.microsoft.com/sharepoint

# Create new team site for telehealth resources
# Configure permissions and access
```

### 3. Local Development Setup
```powershell
# Initialize Git repository
git init

# Create initial commit
git add .
git commit -m "Initial project setup"

# Create local backup directory
mkdir backups
```

## VS Code Tasks
Use the following tasks via Command Palette (`Ctrl+Shift+P`) > "Tasks: Run Task":

- **Initialize Git Repository**: Set up version control
- **Git Add All Changes**: Stage all changes
- **Git Commit**: Commit with custom message
- **Open PowerApps Studio**: Quick access to PowerApps development
- **Open SharePoint Admin**: Quick access to SharePoint administration
- **Open Power Automate**: Quick access to Power Automate development
- **Create Project Backup**: Generate timestamped backup

## Project Structure
```
telehealth-resources-project/
├── docs/                     # Documentation
├── src/                      # Source code
│   ├── powerapps/           # PowerApps canvas app files
│   ├── power-automate/      # Flow definitions
│   └── sharepoint/          # SharePoint configurations
├── data/                     # Current schedule data
├── legacy/                   # Legacy VBA and Excel files
└── backups/                 # Local backups (auto-created)
```

## Development Workflow
1. **Planning**: Update requirements and documentation
2. **SharePoint Setup**: Create lists and configure permissions
3. **PowerApps Development**: Build canvas app interface
4. **Power Automate**: Create approval workflows
5. **Testing**: Validate functionality and user experience
6. **Deployment**: Deploy to production environment
7. **Migration**: Transition from legacy system

## Best Practices
- Commit changes frequently with descriptive messages
- Test in development environment before production
- Document all custom configurations
- Follow hospital naming conventions
- Regular backups before major changes
