# SharePoint Integration

This directory contains SharePoint List schemas, configurations, and integration documentation for the Telehealth Resources Project.

## Current Implementation

### SharePoint Lists Architecture
The system uses **3 primary SharePoint Lists** to replace the legacy Excel-based scheduling:

#### 1. Desks List (Room/Resource Management)
- **Purpose**: Master catalog of available telehealth rooms and equipment
- **Key Fields**: Room Name, Building, Capacity, Equipment Type, Status
- **Integration**: Feeds room selection dropdown in PowerApps

#### 2. Reservations List (Booking Requests)
- **Purpose**: Central repository for all booking requests and approvals
- **Key Fields**: Request Date, Room, Time Slot, Requestor, Status, Manager Approval
- **Integration**: Primary data source for PowerApps booking workflow

#### 3. Admin Settings List (Configuration)
- **Purpose**: System configuration and business rules
- **Key Fields**: Approval Rules, Email Templates, Holiday Calendar, System Settings
- **Integration**: Controls PowerApps behavior and Power Automate workflows

### Excel Online Bridge (Transition Period)
- **Aurora120 Table**: Current schedule data import
- **Aurora121 Table**: Legacy reporting integration
- **Migration Status**: Phase 1 - Parallel operation with SharePoint

## File Structure

```
sharepoint/
├── current-data-sources.md    # Detailed field mappings and schemas
├── list-configurations/       # Planned: JSON schema definitions
├── content-types/            # Planned: Custom content type definitions
└── permissions/              # Planned: Security and access control docs
```

## Integration Points

### PowerApps Canvas App
- **Read Operations**: Room availability, current bookings, user preferences
- **Write Operations**: New booking requests, profile updates, status changes
- **Real-time Sync**: Instant updates across all connected devices

### Power Automate Workflows
- **Approval Routing**: Automatic manager notification and approval tracking
- **Email Notifications**: Status updates, confirmations, and reminders
- **Data Validation**: Business rule enforcement and conflict checking
- **Calendar Integration**: Outlook calendar synchronization

### Office 365 Integration
- **Authentication**: Seamless SSO with hospital Active Directory
- **User Profiles**: Automatic user information population
- **Teams Integration**: Meeting room booking coordination
- **Email**: Automated notifications and approval requests

## Security & Compliance

### Data Protection
- **Encryption**: All data encrypted in transit and at rest
- **Access Control**: Role-based permissions aligned with hospital security
- **Audit Trail**: Complete logging of all booking activities
- **HIPAA Compliance**: Healthcare data protection standards

### Permission Model
- **End Users**: Create requests, view own bookings, cancel reservations
- **Managers**: Approve requests, view team bookings, manage room settings
- **Administrators**: Full system access, user management, configuration changes

## Development Status

### ✅ Completed
- [x] SharePoint List creation and basic schema design
- [x] PowerApps connection and data source configuration
- [x] Initial field mapping from Excel to SharePoint
- [x] Basic CRUD operations in PowerApps

### 🔄 In Progress
- [ ] Advanced business rule validation
- [ ] Power Automate approval workflow implementation
- [ ] Email template creation and testing
- [ ] User acceptance testing with hospital staff

### 📋 Planned (Phase 2)
- [ ] Advanced reporting and analytics
- [ ] Mobile app optimization
- [ ] Integration with hospital calendar systems
- [ ] Automated room utilization reporting

---
*For detailed field mappings and technical specifications, see `current-data-sources.md`*
