# SharePoint Data Sources Documentation

## Connected SharePoint Site
**URL**: https://dvagov.sharepoint.com/sites/vhahin/svc/ci/TelehealthTeamApp
**Environment**: VA Government Cloud

## SharePoint Lists Structure

### 1. List_Desks (Master Room/Desk Data)
**List ID**: `09770055-3583-4d23-92fd-65cc81f2cc18`
**Purpose**: Master inventory of available rooms and desks

**Recommended Field Structure**:
```xml
<Field Name="DeskID" Type="Text" Required="TRUE" />
<Field Name="DeskName" Type="Text" Required="TRUE" />
<Field Name="Location" Type="Choice">
    <CHOICES>
        <CHOICE>Main Hospital</CHOICE>
        <CHOICE>Building A</CHOICE>
        <CHOICE>Building B</CHOICE>
        <CHOICE>Telehealth Suite</CHOICE>
    </CHOICES>
</Field>
<Field Name="RoomNumber" Type="Text" />
<Field Name="Capacity" Type="Number" />
<Field Name="Equipment" Type="MultiChoice">
    <CHOICES>
        <CHOICE>Video Conferencing</CHOICE>
        <CHOICE>Dual Monitors</CHOICE>
        <CHOICE>Whiteboard</CHOICE>
        <CHOICE>Medical Equipment</CHOICE>
    </CHOICES>
</Field>
<Field Name="Status" Type="Choice" Default="Available">
    <CHOICES>
        <CHOICE>Available</CHOICE>
        <CHOICE>Maintenance</CHOICE>
        <CHOICE>Out of Service</CHOICE>
    </CHOICES>
</Field>
<Field Name="Notes" Type="Note" />
```

### 2. List_DeskReservations (Booking Requests)
**List ID**: `b3c3f13a-091b-4c06-a04e-658ea71f297c`
**Purpose**: Track all booking requests and reservations

**Recommended Field Structure**:
```xml
<Field Name="ReservationID" Type="Counter" PrimaryKey="TRUE" />
<Field Name="DeskID" Type="Lookup" List="List_Desks" ShowField="DeskName" />
<Field Name="RequesterEmail" Type="User" />
<Field Name="BookingDate" Type="DateTime" Format="DateOnly" />
<Field Name="StartTime" Type="DateTime" Format="TimeOnly" />
<Field Name="EndTime" Type="DateTime" Format="TimeOnly" />
<Field Name="Duration" Type="Calculated" Formula="=[EndTime]-[StartTime]" />
<Field Name="Purpose" Type="Note" />
<Field Name="ContactNumber" Type="Text" />
<Field Name="ApprovalStatus" Type="Choice" Default="Pending">
    <CHOICES>
        <CHOICE>Pending</CHOICE>
        <CHOICE>Approved</CHOICE>
        <CHOICE>Rejected</CHOICE>
        <CHOICE>Cancelled</CHOICE>
    </CHOICES>
</Field>
<Field Name="BookedFor" Type="User" />
<Field Name="SubmittedDate" Type="DateTime" Default="[today]" />
<Field Name="ApprovalDate" Type="DateTime" />
<Field Name="ApproverComments" Type="Note" />
```

### 3. List_DeskAdmin (Administrative Settings)
**List ID**: `eeefdaf4-6df3-4bfd-95ad-f34f98871328`
**Purpose**: Administrative configuration and user permissions

**Recommended Field Structure**:
```xml
<Field Name="UserEmail" Type="User" />
<Field Name="Role" Type="Choice">
    <CHOICES>
        <CHOICE>Staff</CHOICE>
        <CHOICE>Manager</CHOICE>
        <CHOICE>Administrator</CHOICE>
    </CHOICES>
</Field>
<Field Name="Department" Type="Choice">
    <CHOICES>
        <CHOICE>Telehealth</CHOICE>
        <CHOICE>Clinical Informatics</CHOICE>
        <CHOICE>Administration</CHOICE>
    </CHOICES>
</Field>
<Field Name="BuildingAccess" Type="MultiChoice">
    <CHOICES>
        <CHOICE>Main Hospital</CHOICE>
        <CHOICE>Building A</CHOICE>
        <CHOICE>Building B</CHOICE>
        <CHOICE>All Buildings</CHOICE>
    </CHOICES>
</Field>
<Field Name="CanApprove" Type="Boolean" Default="FALSE" />
<Field Name="CanManageDesks" Type="Boolean" Default="FALSE" />
<Field Name="NotificationPreferences" Type="Choice" Default="Email">
    <CHOICES>
        <CHOICE>Email</CHOICE>
        <CHOICE>Teams</CHOICE>
        <CHOICE>Both</CHOICE>
        <CHOICE>None</CHOICE>
    </CHOICES>
</Field>
```

## Excel Integration Tables

### Aurora120 Table
**Table ID**: `{33971B6B-6240-4C4B-8395-806991AC34EA}`
**Purpose**: Historical booking data bridge

### Aurora121 Table
**Table ID**: `{831F3501-8383-4758-A54A-C83FE145AA19}`
**Purpose**: Room/resource master data bridge

## Migration Recommendations

### Phase 1: Data Analysis
1. **Export Current Lists**: Use SharePoint export to CSV
2. **Analyze Data Patterns**: Identify field usage and relationships
3. **Clean Data**: Remove duplicates and inconsistencies

### Phase 2: Schema Enhancement
1. **Add Missing Fields**: Approval status, manager assignments
2. **Create Lookup Relationships**: Link reservations to desks
3. **Add Calculated Fields**: Duration, conflict detection

### Phase 3: Permission Setup
1. **Create Security Groups**: Staff, Managers, Admins
2. **Set List Permissions**: Read/write access by role
3. **Configure Approval Workflows**: Manager approval chains

## PowerShell Migration Scripts

### Export Current Data
```powershell
# Connect to SharePoint
Connect-PnPOnline -Url "https://dvagov.sharepoint.com/sites/vhahin/svc/ci/TelehealthTeamApp"

# Export existing lists
Get-PnPListItem -List "List_Desks" | Export-Csv "migration_desks.csv"
Get-PnPListItem -List "List_DeskReservations" | Export-Csv "migration_reservations.csv"
Get-PnPListItem -List "List_DeskAdmin" | Export-Csv "migration_admin.csv"
```

### Create Enhanced Lists
```powershell
# Create new enhanced list structure
$newListTemplate = @{
    Title = "TelehealthRooms"
    Template = "GenericList"
    Fields = @(
        @{Name="RoomName"; Type="Text"; Required=$true},
        @{Name="Building"; Type="Choice"; Choices=@("Main","BuildingA","BuildingB")},
        @{Name="Equipment"; Type="MultiChoice"; Choices=@("Video","Monitors","Whiteboard")}
    )
}

New-PnPList @newListTemplate
```

## Next Steps for Development

1. **Review Current Data**: Access VA SharePoint site to analyze existing data
2. **Document Business Rules**: Understand current booking processes
3. **Plan Data Migration**: Design migration strategy for enhanced lists
4. **Update PowerApp**: Modify app to use new list structure
5. **Add Approval Workflow**: Implement Power Automate approval process
