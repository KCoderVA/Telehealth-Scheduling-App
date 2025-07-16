# Telehealth Resources Project - AI Coding Agent Instructions

## Project Overview
This is a **hospital telehealth room booking system** transitioning from Excel/VBA to Microsoft Power Platform. The system manages conference room reservations across multiple hospital buildings with approval workflows for telehealth managers.

## Architecture & Data Flow
```
PowerApps Canvas App → SharePoint Lists → Power Automate → Email Approvals
     ↓                      ↓                  ↓
Mobile/Desktop UI    Room Schedules      Manager Workflows
                    Booking Requests     
```

**Critical Integration Points:**
- Legacy Excel schedules in `/data/` (current master data source)
- VBA automation in `/legacy/` (existing booking logic to replicate)
- Hospital Active Directory (authentication requirement)
- Email systems (approval notifications)

## Project Structure & Key Files
```
├── src/powerapps/          # Canvas app components (.msapp exports)
├── src/power-automate/     # Flow definitions (JSON exports)
├── src/sharepoint/         # List schemas and configurations
├── data/                   # Excel master schedules (current system)
├── legacy/                 # VBA code showing existing business logic
└── docs/                   # Requirements and setup guides
```

## Development Workflow & Tools

### VS Code Tasks (Use Ctrl+Shift+P → "Tasks: Run Task")
- **"Open PowerApps Studio"** - Direct link to make.powerapps.com
- **"Open SharePoint Admin"** - Access admin.microsoft.com/sharepoint
- **"Open Power Automate"** - Quick access to make.powerautomate.com
- **"Git Commit"** - Prompts for commit message (essential for solution tracking)
- **"Create Project Backup"** - Generates timestamped ZIP backups

### Power Platform Development Pattern
1. **Design in Browser**: Use PowerApps Studio web interface
2. **Export Solutions**: Download .msapp and flow definitions regularly
3. **Store in /src/**: Place exported files in appropriate subdirectories
4. **Document Changes**: Update CHANGELOG.md with functional changes

## Hospital-Specific Constraints & Patterns

### Security Requirements
- **Role-Based Access**: Different permissions for staff vs managers
- **Audit Trails**: All booking actions must be logged
- **Data Governance**: Compliance with hospital policies (see docs/requirements.md)
- **M365 Ecosystem Only**: No external services allowed

### Business Logic Patterns (from legacy/VBA_ConferenceRoomScheduling_Fixed.vb)
- **Multi-Building Support**: Separate tabs/lists per building
- **Time Slot Management**: Specific time blocks per day
- **Conflict Detection**: Check overlapping bookings
- **Manager Assignment**: Different approval chains per building

### SharePoint List Design Strategy
Create **separate lists** for:
- `RoomMasterData` (buildings, rooms, equipment)
- `BookingRequests` (pending approvals)
- `ApprovedBookings` (calendar integration)

## File Type Associations & Extensions
- `.fx` files → Power Fx language (PowerApps formulas)
- `.msapp` files → PowerApps applications (binary, use PowerApps Studio)
- `.pbix` files → Power BI reports (use Power BI Desktop)
- `.json` files in power-automate/ → Flow export definitions

## Critical Development Commands
```powershell
# Quick development environment setup
git add . && git commit -m "Save progress before major changes"

# Access development tools
start https://make.powerapps.com/        # Canvas app development
start https://admin.microsoft.com/sharepoint  # SharePoint administration
start https://make.powerautomate.com/    # Flow development
```

## Common Pitfalls & Patterns
- **PowerApps Delegation**: Large SharePoint lists require delegation-friendly formulas
- **Flow Timeouts**: Complex approval workflows need error handling
- **Excel Integration**: Use Power Automate for Excel-to-SharePoint migration
- **Mobile Responsiveness**: Canvas apps must work on hospital mobile devices
- **Version Control**: Export solutions regularly - Power Platform doesn't auto-save code

## Testing Strategy
- **Dev Environment**: Separate PowerApps environment for testing
- **Parallel Operation**: Run alongside Excel system during transition
- **Load Testing**: 50+ concurrent users requirement (see docs/requirements.md)
- **Mobile Testing**: Verify on hospital's approved mobile devices

When working on this project, always consider the **hospital context** - users are busy medical staff who need simple, reliable tools that integrate seamlessly with existing hospital workflows.
