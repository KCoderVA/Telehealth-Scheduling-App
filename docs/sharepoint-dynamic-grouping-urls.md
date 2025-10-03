# SharePoint Dynamic Grouping URLs

## 📋 Original View URL
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables/xDataSheet.aspx?viewid=07735088%2Dabc1%2D4263%2Da4d4%2Daef2e8a92ff1
```

## 🎯 Grouped View URL (Primary: CBOC_Name_text, Secondary: Room_Name_text)

### Method 1: URL Parameters (Recommended)
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables/xDataSheet.aspx?viewid=07735088%2Dabc1%2D4263%2Da4d4%2Daef2e8a92ff1&GroupBy=CBOC_Name_text&GroupBy2=Room_Name_text&Grouped=TRUE
```

### Method 2: Alternative Parameter Format
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables/xDataSheet.aspx?viewid=07735088%2Dabc1%2D4263%2Da4d4%2Daef2e8a92ff1&GroupByField=CBOC_Name_text&GroupByField2=Room_Name_text&Group=TRUE
```

### Method 3: Modern SharePoint Approach
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables/AllItems.aspx?viewid=07735088%2Dabc1%2D4263%2Da4d4%2Daef2e8a92ff1&GroupBy=CBOC_Name_text,Room_Name_text
```

## 🔧 Power Apps Implementation

### Canvas App Button OnSelect Property
```powerfx
Launch("https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables/xDataSheet.aspx?viewid=07735088%2Dabc1%2D4263%2Da4d4%2Daef2e8a92ff1&GroupBy=CBOC_Name_text&GroupBy2=Room_Name_text&Grouped=TRUE")
```

### Dynamic Grouping with Variables
```powerfx
Set(varGroupedViewURL,
    "https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables/xDataSheet.aspx?viewid=07735088%2Dabc1%2D4263%2Da4d4%2Daef2e8a92ff1&GroupBy=" &
    varPrimaryGroupColumn &
    "&GroupBy2=" &
    varSecondaryGroupColumn &
    "&Grouped=TRUE"
)
```

## 📊 Additional Grouping Options

### Expand/Collapse All Groups
```
&GroupExpanded=TRUE    // Expand all groups by default
&GroupExpanded=FALSE   // Collapse all groups by default
```

### Sort Direction for Groups
```
&GroupAscending=TRUE   // Ascending order (A-Z)
&GroupAscending=FALSE  // Descending order (Z-A)
```

### Complete URL with All Options
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables/xDataSheet.aspx?viewid=07735088%2Dabc1%2D4263%2Da4d4%2Daef2e8a92ff1&GroupBy=CBOC_Name_text&GroupBy2=Room_Name_text&Grouped=TRUE&GroupExpanded=TRUE&GroupAscending=TRUE
```

## 🎯 Quick Test URLs

### Test 1: Basic Grouping
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables/xDataSheet.aspx?viewid=07735088%2Dabc1%2D4263%2Da4d4%2Daef2e8a92ff1&GroupBy=CBOC_Name_text&Grouped=TRUE
```

### Test 2: Two-Level Grouping
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables/xDataSheet.aspx?viewid=07735088%2Dabc1%2D4263%2Da4d4%2Daef2e8a92ff1&GroupBy=CBOC_Name_text&GroupBy2=Room_Name_text&Grouped=TRUE
```

### Test 3: Expanded Groups
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/Lists/20250902%20TelehealthMasterSched_Tables/xDataSheet.aspx?viewid=07735088%2Dabc1%2D4263%2Da4d4%2Daef2e8a92ff1&GroupBy=CBOC_Name_text&GroupBy2=Room_Name_text&Grouped=TRUE&GroupExpanded=TRUE
```

## ⚠️ Troubleshooting

### If Grouping Doesn't Work:
1. **Column Names**: Ensure exact column internal names (CBOC_Name_text, Room_Name_text)
2. **View Permissions**: User must have read access to the list
3. **Modern vs Classic**: Try switching between xDataSheet.aspx and AllItems.aspx
4. **Browser Cache**: Clear cache or try in incognito mode

### Alternative Column Name Formats:
If the above doesn't work, try these variations:
- `CBOC%5FName%5Ftext` (URL-encoded underscores)
- `CBOCNametext` (no underscores)
- Check the actual internal column names in SharePoint

## 🔍 Finding Internal Column Names

### Method 1: SharePoint REST API
```
https://dvagov.sharepoint.com/sites/578TelehealthResourceApp/_api/web/lists/getbytitle('20250902 TelehealthMasterSched_Tables')/fields?$filter=Hidden eq false
```

### Method 2: Power Apps Formula
```powerfx
// In your Power Apps, check column names
ShowColumns(YourSharePointList, "DisplayName", "InternalName")
```

### Method 3: Browser Developer Tools
1. Open the list in browser
2. Right-click column header → Inspect Element
3. Look for `data-automation-id` or field references
