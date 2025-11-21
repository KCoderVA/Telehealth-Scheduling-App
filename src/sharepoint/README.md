# SharePoint Data Sources & Schemas

This directory contains the core data sources (CSV files) that power the Telehealth Room Booking application. These files serve as the local data store, mirroring the structure of the SharePoint lists used in the production environment.

## Current Data Architecture
The system uses **3 primary CSV files** as data sources, organized into subdirectories representing their corresponding SharePoint Lists.

### 1. `App_User_List/`
- **Purpose**: Contains a master list of application users and their demographic information. This is used for populating user profiles, roles, and permissions within the Power App.
- **Files**:
    - `App_User_List.csv`: The primary data file for user information.
    - `App_User_List - Copy.csv`: A backup or working copy.

### 2. `MasterSchedule/`
- **Purpose**: This is the central data store for all telehealth rooms, their properties, and the combined master schedule of all bookings.
- **Files**:
    - `TelehealthMasterSched_CombiTable.csv`: A combined table containing room master data and all booking records.
    - `_phi_TelehealthMasterSched_CombiTable.csv`: A version of the master schedule potentially containing Protected Health Information (PHI), used for specific, secure workflows.
    - `LIST TelehealthMasterSched_CombiTable.url`: A link to the live SharePoint list.

### 3. `ReservationLog/`
- **Purpose**: A log of all booking and reservation activities. This serves as an audit trail and is used for reporting and conflict resolution.
- **Files**:
    - `App_ReservationLog.csv`: The primary log file for all reservation events.
    - `_phi_App_ReservationLog.csv`: A version of the log containing PHI.
    - `LIST App_ReservationLog.url`: A link to the live SharePoint list.

## File Structure

```
sharepoint/
├── App_User_List/
│   ├── App_User_List.csv
│   └── App_User_List - Copy.csv
├── MasterSchedule/
│   ├── TelehealthMasterSched_CombiTable.csv
│   ├── _phi_TelehealthMasterSched_CombiTable.csv
│   └── LIST TelehealthMasterSched_CombiTable.url
├── ReservationLog/
│   ├── App_ReservationLog.csv
│   ├── _phi_App_ReservationLog.csv
│   └── LIST App_ReservationLog.url
├── README.md                  # This file
└── current-data-sources.md    # Detailed field mappings and schemas for the CSV files
```

## Integration Points

### PowerApps Canvas App
- **Data Source**: The Power App directly connects to these CSV files (or the corresponding SharePoint lists) to manage room availability, display schedules, and process booking requests.

### Power Automate Workflows
- **Data Processing**: Flows are used to read from and write to these data sources for tasks like:
    - Automated approval routing.
    - Email and Teams notifications.
    - Data validation and conflict checking.
    - Synchronization between local CSVs and live SharePoint lists.

## Security & Compliance
- **PHI Data**: Files prefixed with `_phi_` contain sensitive patient information and must be handled in accordance with HIPAA and VA data security policies.
- **Access Control**: In the live SharePoint environment, access to these lists is strictly controlled via role-based permissions.

---
*For detailed field mappings and technical specifications, see `current-data-sources.md`*
