# Power Apps Building Filter Formula

## 🏢 Building to Abbreviation Mapping

| Building Name | Abbreviation | Example Team |
|---------------|--------------|--------------|
| Aurora | AUR | AUR CVT MHC PHYSN 29 PAT |
| Hoffman Estates | HE | HE CVT MH INTAKE PAT |
| Joliet | JOL | JOL CVT GI TELEPREP PAT |
| Kankakee | KAN | KAN CVT CHAPLAIN PAT |
| Lasalle | LAS | LAS CVT AUDIO EVAL & FIT PAT |
| Oak Lawn | OL | OL CVT MHC PHYSN 37 PAT |

## 📱 Power Apps OnSelect Formula

### Building Filter Dropdown OnSelect Property
```powerfx
// Clear and collect filtered teams based on selected building
ClearCollect(
    colFilteredTeams,
    Filter(
        colTelehealthTeams,
        StartsWith(
            Team_Name,
            Switch(
                ddBuildingFilter.Selected.Value,
                "Aurora", "AUR",
                "Hoffman Estates", "HE",
                "Joliet", "JOL",
                "Kankakee", "KAN",
                "Lasalle", "LAS",
                "Oak Lawn", "OL",
                ""  // Default case - no filter
            )
        )
    )
)
```

### Alternative with Case-Insensitive Matching
```powerfx
// More robust version with case-insensitive building name matching
ClearCollect(
    colFilteredTeams,
    Filter(
        colTelehealthTeams,
        StartsWith(
            Upper(Team_Name),
            Switch(
                Upper(ddBuildingFilter.Selected.Value),
                "AURORA", "AUR",
                "HOFFMAN ESTATES", "HE",
                "JOLIET", "JOL",
                "KANKAKEE", "KAN",
                "LASALLE", "LAS",
                "OAK LAWN", "OL",
                ""  // Default case
            )
        )
    )
)
```

### With Error Handling and "All Buildings" Option
```powerfx
// Complete formula with error handling and "All Buildings" option
If(
    IsBlank(ddBuildingFilter.Selected) ||
    ddBuildingFilter.Selected.Value = "All Buildings",
    // Show all teams if no building selected or "All Buildings" selected
    ClearCollect(colFilteredTeams, colTelehealthTeams),
    // Filter by selected building
    ClearCollect(
        colFilteredTeams,
        Filter(
            colTelehealthTeams,
            StartsWith(
                Team_Name,
                Switch(
                    ddBuildingFilter.Selected.Value,
                    "Aurora", "AUR",
                    "Hoffman Estates", "HE",
                    "Joliet", "JOL",
                    "Kankakee", "KAN",
                    "Lasalle", "LAS",
                    "Oak Lawn", "OL",
                    ""  // Default - no match
                )
            )
        )
    )
)
```

## 🎯 Gallery Items Property (Alternative Approach)

Instead of using OnSelect, you can also filter directly in the Gallery's Items property:

```powerfx
Filter(
    colTelehealthTeams,
    If(
        IsBlank(ddBuildingFilter.Selected) ||
        ddBuildingFilter.Selected.Value = "All Buildings",
        true,  // Show all teams
        StartsWith(
            Team_Name,
            Switch(
                ddBuildingFilter.Selected.Value,
                "Aurora", "AUR",
                "Hoffman Estates", "HE",
                "Joliet", "JOL",
                "Kankakee", "KAN",
                "Lasalle", "LAS",
                "Oak Lawn", "OL",
                ""
            )
        )
    )
)
```

## 🔧 Setup Instructions

### 1. Load Teams Data (OnVisible of Screen)
```powerfx
// Load teams from CSV data source or SharePoint list
ClearCollect(
    colTelehealthTeams,
    'telehealth-teams'  // Your CSV data source name
)
```

### 2. Building Filter Dropdown Items
```powerfx
["All Buildings", "Aurora", "Hoffman Estates", "Joliet", "Kankakee", "Lasalle", "Oak Lawn"]
```

### 3. Team Display Gallery Items
```powerfx
// Use the filtered collection
colFilteredTeams
```

## 📊 Expected Results by Building

- **Aurora**: 21 teams (AUR prefix)
- **Hoffman Estates**: 22 teams (HE prefix)
- **Joliet**: 29 teams (JOL prefix)
- **Kankakee**: 24 teams (KAN prefix)
- **Lasalle**: 27 teams (LAS prefix)
- **Oak Lawn**: 27 teams (OL prefix)
- **All Buildings**: 140 total teams

## 🎨 Enhanced User Experience

### Add Loading Indicator
```powerfx
// Set loading state
Set(varLoadingTeams, true);

// Clear and collect with completion handler
ClearCollect(
    colFilteredTeams,
    Filter(/* your filter logic here */)
);

// Clear loading state
Set(varLoadingTeams, false)
```

### Team Count Display
```powerfx
// Show count of filtered teams
CountRows(colFilteredTeams) & " teams in " & ddBuildingFilter.Selected.Value
```
