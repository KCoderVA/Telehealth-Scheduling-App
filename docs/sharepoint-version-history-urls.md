# SharePoint Version History Direct Links

## 📋 URL Pattern for Telehealth Master Schedule List

### Base URL Structure
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/_layouts/15/versions.aspx?list={ListID}&ID={ItemID}
```

### Your Specific Implementation (CORRECTED with List GUID)
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/_layouts/15/versions.aspx?list=AD789C18-D515-44A3-826E-E64337C1B84E&ID={ItemID}
```

## 🔧 Power Apps Formula Implementation

### Canvas App Button OnSelect Property (CORRECTED)
```powerfx
Launch("https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/_layouts/15/versions.aspx?list=AD789C18-D515-44A3-826E-E64337C1B84E&ID=" & ThisItem.ID)
```

### Gallery Item Version History Button (CORRECTED)
```powerfx
// For items in a gallery control
Launch("https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/_layouts/15/versions.aspx?list=AD789C18-D515-44A3-826E-E64337C1B84E&ID=" & galTelehealthSchedule.Selected.ID)
```

### Form Context Implementation (CORRECTED)
```powerfx
// When viewing/editing a specific form record
Launch("https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/_layouts/15/versions.aspx?list=AD789C18-D515-44A3-826E-E64337C1B84E&ID=" & formTelehealthBooking.LastSubmit.ID)
```

## 🔗 Alternative URL Patterns

### Using List GUID (More Reliable)
If you need the actual List GUID instead of the encoded list name:

1. **Get List GUID**: Navigate to List Settings → In the URL, find the List parameter
2. **URL Pattern**: `https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/_layouts/15/versions.aspx?list={GUID}&ID={ItemID}`

### Power Automate Dynamic URL Construction
```json
{
  "VersionHistoryURL": "https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/_layouts/15/versions.aspx?list=20250902%20TelehealthMasterSched_Tables&ID=@{items('Apply_to_each')?['ID']}"
}
```

## 🎯 Usage Examples

### Static Example (Item ID 123) - CORRECTED
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/_layouts/15/versions.aspx?list=AD789C18-D515-44A3-826E-E64337C1B84E&ID=123
```

### Dynamic Power Apps Variable - CORRECTED
```powerfx
Set(varVersionHistoryURL,
    "https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/_layouts/15/versions.aspx?list=AD789C18-D515-44A3-826E-E64337C1B84E&ID=" &
    varSelectedBookingID
)
```

## ⚠️ Important Notes

1. **URL Encoding**: The list name `20250902%20TelehealthMasterSched_Tables` is already URL-encoded
2. **Permissions**: Users must have read access to the list and version history permissions
3. **Modern vs Classic**: This opens in SharePoint Classic experience (versions.aspx)
4. **Browser Behavior**: Use `Launch()` in Power Apps to open in new browser window/tab

## 🔍 Troubleshooting - URL DIDN'T WORK

### ❌ Issue: List Name vs List GUID
The URL failed because SharePoint version history requires the **List GUID**, not the list name.

### ✅ Solution: Get the Correct List GUID

**Method 1: From List Settings**
1. Navigate to your list: `https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables`
2. Click the **Settings** gear → **List Settings**
3. In the URL, look for: `List=%7B[GUID-HERE]%7D`
4. Copy that GUID (without the %7B and %7D)

**Method 2: From Current Datasheet View**
Your current URL: `https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables/xDataSheet.aspx?viewid=75541be1%2D3bb4%2D41f0%2D8917%2D0eb4b8453086`

1. Right-click on any list item → **View Properties** or **Edit**
2. In the popup URL, look for `List=` parameter
3. That's your List GUID

**Method 3: PowerShell Command**
```powershell
# Connect to SharePoint Online
Connect-PnPOnline -Url "https://dvagov.sharepoint.com/sites/578TelehealthResourceApp" -Interactive

# Get the List GUID
$list = Get-PnPList -Identity "20250902 TelehealthMasterSched_Tables"
Write-Host "List GUID: $($list.Id)"
```

### ✅ CORRECTED URL Pattern (WITH ACTUAL GUID)
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/_layouts/15/versions.aspx?list=AD789C18-D515-44A3-826E-E64337C1B84E&ID=123
```

**List GUID Extracted From Your Settings URL:**
- **GUID**: `AD789C18-D515-44A3-826E-E64337C1B84E`
- **Source**: `https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/_layouts/15/listedit.aspx?List=%7BAD789C18%2DD515%2D44A3%2D826E%2DE64337C1B84E%7D`

### Alternative: Modern SharePoint Version History
Try this modern approach instead:
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables/DispForm.aspx?ID=123&Source=https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables/AllItems.aspx
```
Then users can click "Version History" from the item display form.

## 📱 Mobile Considerations

For mobile users, consider adding a confirmation:
```powerfx
If(
    Confirm("Open version history in browser?"),
    Launch("https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/_layouts/15/versions.aspx?list=20250902%20TelehealthMasterSched_Tables&ID=" & ThisItem.ID)
)
```
