# VA Government Cloud Environment Configuration

## Environment Overview
This Telehealth Room Booking application operates within the **U.S. Department of Veterans Affairs (VA) Government Cloud** infrastructure, utilizing **Azure Government (Fairfax)** services and **GCC High** SharePoint.

---

## SharePoint Data Sources

### Primary Application Site (New Schema)
- **URL**: `https://dvagov.sharepoint.com/sites/578TelehealthResourceApp`
- **Purpose**: Primary data storage for v0.3.x application
- **Lists**:
  - `App_ReservationLog` (ID: `82836f65-caa8-4c03-bc26-7a38e444c6bd`)
  - `App_User_list` (ID: `9e296a65-09d0-4ea1-a0a6-bd0a2477821e`)
  - `AppLoadAudit` (ID: `fd436609-adae-497b-99d2-dfbcd0386f48`)
  - `TelehealthMasterSched_CombiTable` (ID: `ad789c18-d515-44a3-826e-e64337c1b84e`)

### Legacy Team Application Site (Old Schema)
- **URL**: `https://dvagov.sharepoint.com/sites/vhahin/svc/ci/TelehealthTeamApp`
- **Purpose**: Legacy data source for backward compatibility
- **Lists**:
  - `List_DeskReservations` (ID: `b3c3f13a-091b-4c06-a04e-658ea71f297c`)
  - `List_Desks` (ID: `09770055-3583-4d23-92fd-65cc81f2cc18`)

---

## Power Platform Environment

### Cloud Infrastructure
- **Environment Type**: Azure Government (GCC High / Fairfax)
- **Region**: US Government
- **Domain**: `dvagov.sharepoint.com` (VA Government tenant)
- **Icon CDN**: `https://connectorsiconsfairfax.z5.web.core.usgovcloudapi.net`

### Connections
1. **SharePoint Online**
   - Connection ID: `366ef963-df5e-475a-805f-b326dde4b0cc`
   - API: `/providers/microsoft.powerapps/apis/shared_sharepointonline`
   - Tier: Standard
   - Permissions: Read, Write, Delete

2. **Office 365 Users**
   - Connection ID: `64852b16-4509-4d34-be4c-adfa1f496b3a`
   - API: `/providers/microsoft.powerapps/apis/shared_office365users`
   - Tier: Standard
   - Operations: MyProfile, UserPhotoV2, MyProfileV2, SearchUser
   - Icon URL: `https://connectorsiconsfairfax.z5.web.core.usgovcloudapi.net/v1.0.1767/1.0.1767.4341/office365users/icon.png`

---

## MyAppts Screen Data Source Details

### Current Data Source (v0.3.x)
The MyAppts screen uses **`App_ReservationLog`** from the primary application site:
- **SharePoint List**: `App_ReservationLog`
- **Site URL**: `https://dvagov.sharepoint.com/sites/578TelehealthResourceApp`
- **List ID**: `82836f65-caa8-4c03-bc26-7a38e444c6bd`
- **Purpose**: Stores all reservation requests, approvals, and statuses

### Key Fields in App_ReservationLog
- `ID` - Unique identifier
- `Title` - Reservation title
- `field_1` - CBOC_Name_text (building/location)
- `field_2` - Room_number
- `field_3` - Room_Name_text
- `Modified` - Last modified timestamp
- `Modified_DayOfWeek` - Day of week for reservation
- `Modified_SubmitterEmail_text` - Email of person who submitted
- `selectedClinicalStaff_email` - Email of clinical staff member
- `reservationStatus_Choice` - Current status (Pending, Approved, Rejected)

### Gallery Filter Logic
```powerfx
FirstN(
    SortByColumns(
        Filter(
            App_ReservationLog,
            currentUser.Email = selectedClinicalStaff_email
        ),
        "Modified",
        SortOrder.Descending
    ),
    6
)
```

---

## Cancellation Fix Implementation

### Correct Data Source Reference
When implementing the cancellation fix in the MyAppts screen, use:

```powerfx
Remove(App_ReservationLog, varReservationToCancel);
UpdateContext({varConfirmCancel:false})
```

**NOT** the legacy data source:
```powerfx
// ❌ WRONG - This is the old schema
Remove(List_DeskReservations, varSelectedReservation)
```

### Why This Matters
1. **Different SharePoint Sites**: 
   - `App_ReservationLog` is in `/sites/578TelehealthResourceApp`
   - `List_DeskReservations` is in `/sites/vhahin/svc/ci/TelehealthTeamApp`

2. **Different Schemas**: The field names and structure differ between the two lists

3. **Data Consistency**: MyAppts screen displays from `App_ReservationLog`, so deletions must target the same list

---

## Government Cloud Compliance Considerations

### Security
- All connections use **Azure Government** infrastructure
- Data never leaves the GCC High boundary
- Authentication via VA Active Directory (Office 365 Users GCC High)

### Network Restrictions
- Connections must use `.gov` or government-approved domains
- API endpoints use `usgovcloudapi.net` domain
- Icon/resource CDNs use Fairfax region: `connectorsiconsfairfax.z5.web.core.usgovcloudapi.net`

### Data Residency
- All SharePoint data stored in US Government datacenters
- Backup and disaster recovery within government cloud boundary
- Audit logs maintained per VA compliance requirements

---

## Power Apps Web Editor URLs

### Development Environment
When making changes, ensure you're accessing the **Government Cloud** Power Apps portal:

- **GCC High Power Apps**: `https://make.gov.powerapps.us`
  - OR: `https://make.powerapps.us` (redirects to government instance)
- **Standard Commercial** (WRONG): `https://make.powerapps.com` ❌

### Verifying Correct Environment
1. Check URL bar - should contain `.gov` or `.us` TLD
2. Verify SharePoint site URLs contain `dvagov.sharepoint.com`
3. Connection icons should load from `usgovcloudapi.net`

---

## Implementation Checklist for Web Editor

When implementing the MyAppts cancellation fix:

- [ ] Access Power Apps via GCC High portal (`make.gov.powerapps.us`)
- [ ] Verify environment shows "GCC High" or government badge
- [ ] Confirm SharePoint connection points to `dvagov.sharepoint.com`
- [ ] Use `App_ReservationLog` data source (not `List_DeskReservations`)
- [ ] Use variable `varReservationToCancel` (not `varSelectedReservation`)
- [ ] Test in preview mode to verify record deletion
- [ ] Publish to government environment (not commercial)

---

## Troubleshooting Government Cloud Issues

### Issue: "Data source not found"
**Cause**: Wrong environment or incorrect site permissions  
**Solution**: 
1. Verify you're in the GCC High environment
2. Check VA network/VPN connection
3. Confirm SharePoint site permissions for your account

### Issue: "Connection failed"
**Cause**: Commercial cloud endpoint being used  
**Solution**: 
1. Remove and re-add connection in GCC High environment
2. Verify connection uses `dvagov.sharepoint.com` domain
3. Check that icon URLs contain `usgovcloudapi.net`

### Issue: "Cannot remove record"
**Cause**: Wrong data source or insufficient permissions  
**Solution**:
1. Confirm using `App_ReservationLog` not `List_DeskReservations`
2. Verify SharePoint list permissions (Contribute or higher)
3. Check record exists and user has access

---

## Related Documentation
- Microsoft GCC High Documentation: https://learn.microsoft.com/power-platform/admin/microsoft-cloud-government
- VA Power Platform Guidelines: Internal VA documentation
- SharePoint GCC High Overview: Internal VA documentation

---

**Last Updated**: 2025-11-19  
**Environment**: VA Government Cloud (GCC High / Azure Fairfax)  
**Application Version**: v0.3.2
