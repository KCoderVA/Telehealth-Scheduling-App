# PowerApps Screen to HTML Preview Guide

## Overview
This guide explains how to convert PowerApps screen JSON files into HTML previews for design validation, change preview, and UI mockups.

## 🎯 What This Solves
- **Design Validation**: Preview screen layouts without opening PowerApps Studio
- **Change Testing**: See how UI modifications will look before implementation
- **Documentation**: Generate visual documentation of app screens
- **Collaboration**: Share screen designs with non-PowerApps users
- **Version Control**: Track visual changes alongside code changes

## 📁 Generated Files Structure
```
src/powerapps/
├── screens/                     # Extracted screen JSON files
│   └── DeskSelect.json         # Individual screen definitions
├── previews/                    # Generated HTML previews
│   ├── DeskSelect.html         # Basic automated preview
│   └── DeskSelect-Enhanced.html # Manual enhanced preview
├── screen-to-html-converter.js  # JavaScript converter class
├── Generate-ScreenPreview.ps1   # PowerShell automation script
└── Generate-ScreenPreview-Fixed.ps1 # Working version
```

## 🔧 How the Conversion Works

### 1. PowerApps JSON Structure Analysis
PowerApps screens are stored as JSON with this hierarchy:
```json
{
  "TopParent": {
    "Name": "ScreenName",
    "Template": { "Name": "screen" },
    "Rules": [
      {
        "Property": "Width",
        "InvariantScript": "640"
      }
    ],
    "Children": [
      {
        "Name": "ControlName",
        "Template": { "Name": "label" },
        "Rules": [...]
      }
    ]
  }
}
```

### 2. Key Properties Extracted
From each control's `Rules` array, we extract:
- **Position**: X, Y coordinates
- **Size**: Width, Height
- **Styling**: Fill, Color, Font, Size
- **Content**: Text, Image sources
- **Behavior**: OnSelect, Visible conditions
- **Z-Index**: Layer ordering

### 3. CSS Generation
Each control becomes a CSS class with absolute positioning:
```css
.control-lblselectdesk {
    position: absolute;
    left: 0px;
    top: 0px;
    width: 640px;
    height: 110px;
    color: rgba(255, 255, 255, 1);
    font-size: 32px;
    z-index: 3;
}
```

## 🚀 Usage Methods

### Method 1: Automated PowerShell Script
```powershell
# Basic usage
.\Generate-ScreenPreview-Fixed.ps1 -ScreenName "DeskSelect"

# Custom output directory
.\Generate-ScreenPreview-Fixed.ps1 -ScreenName "DeskSelect" -OutputDir "my-previews"
```

**Pros**:
- ✅ Automated extraction from JSON
- ✅ Handles multiple screens easily
- ✅ Programmatic conversion of RGBA colors

**Cons**:
- ❌ Limited styling accuracy
- ❌ No complex layout handling
- ❌ Missing visual context

### Method 2: Manual Enhanced HTML
Create detailed, accurate previews by manually analyzing the JSON structure.

**Pros**:
- ✅ Pixel-perfect layout accuracy
- ✅ Enhanced visual styling
- ✅ Business context included
- ✅ Mobile device frame simulation

**Cons**:
- ❌ Manual work required
- ❌ Time-intensive for complex screens

## 📊 Control Type Mapping

| PowerApps Control | HTML Element | CSS Approach |
|------------------|--------------|--------------|
| `label` | `<div>` | Text content with positioning |
| `button` | `<button>` | Interactive styling |
| `rectangle` | `<div>` | Background color/border |
| `image` | `<div>` with background | Image placeholder or actual source |
| `icon` | `<div>` with Unicode | Font-based icon representation |
| `arrow` | `<div>` with arrow symbol | CSS arrow or Unicode character |
| `htmlViewer` | `<div>` with innerHTML | Direct HTML content rendering |
| `gallery` | `<div>` container | Placeholder for data-driven content |
| `screen` | `<div>` container | Root container element |

## 🎨 Advanced Styling Techniques

### RGBA Color Conversion
```javascript
// PowerApps: RGBA(135, 78, 181, 0.65)
// CSS: rgba(135, 78, 181, 0.65)

function convertRgbaColor(rgbaString) {
    const match = rgbaString.match(/RGBA\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)/);
    if (match) {
        const [, r, g, b, a] = match;
        return `rgba(${r}, ${g}, ${b}, ${a})`;
    }
    return 'transparent';
}
```

### Font Mapping
```javascript
const fontMap = {
    "Font.'Open Sans'": "'Open Sans', sans-serif",
    "Font.'Segoe UI'": "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif",
    "Font.'Arial'": "Arial, sans-serif"
};
```

### Responsive Design Simulation
```css
.screen-container {
    position: relative;
    width: 640px;  /* PowerApps mobile width */
    height: 1136px; /* PowerApps mobile height */
    margin: 0 auto;
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    overflow: hidden;
}
```

## 🔍 Analysis Example: DeskSelect Screen

### Extracted Control Hierarchy
1. **Screen Container** (`DeskSelect`)
   - Background fill and responsive sizing

2. **Header Section**
   - `Image2_2`: Abstract background (linear gradient)
   - `Rectangle2_1`: Purple overlay (rgba(135, 78, 181, 0.65))
   - `lblSelectDesk`: "Select a Desk" title (white, bold, 32px)

3. **Navigation**
   - `Arrow1_1`: Back arrow (top-left, white circle)

4. **Content Area**
   - `bgRounded_2`: Rounded background container
   - `lblDateDesk`: Date/time display area

5. **Interactive Elements**
   - `Icon1`: Cancel icon
   - `DeskSearchIcon`: Search functionality

### Business Logic Integration
```powerfx
// OnVisible behavior
OnVisible: UpdateContext({showMap:false})

// Back button behavior
OnSelect: Reset(galleryAvailDesk); Back();

// Dynamic date display
Text: startTime & " - " & endTime
```

## 💡 Best Practices

### 1. Maintain Aspect Ratios
Keep PowerApps mobile dimensions (640×1136) for accurate representation.

### 2. Include Z-Index Layering
```css
/* Ensure proper layering */
.background-image { z-index: 1; }
.header-overlay { z-index: 2; }
.main-title { z-index: 3; }
.content-background { z-index: 4; }
```

### 3. Add Visual Context
Include device frames, status bars, and business context for stakeholder reviews.

### 4. Document Dynamic Content
```html
<!-- Placeholder for dynamic content -->
<div class="content-area">
    <div>
        <strong>📋 Desk Selection Gallery</strong><br>
        <small>This area would contain:</small><br>
        • Available desk cards<br>
        • Room capacity information<br>
        • Equipment details<br>
    </div>
</div>
```

### 5. Theme Support
```css
/* Support for PowerApps theme variables */
.content-background {
    background-color: var(--theme-light, #FCFCFC);
}

/* Dark mode alternative */
@media (prefers-color-scheme: dark) {
    .content-background {
        background-color: #1D1F23;
    }
}
```

## 🔧 Automation Workflow

### 1. Extract All Screens
```powershell
# Batch process multiple screens
$screens = @("DeskSelect", "BookingForm", "Success", "Dashboard")
foreach ($screen in $screens) {
    .\Generate-ScreenPreview-Fixed.ps1 -ScreenName $screen
}
```

### 2. Version Control Integration
```bash
# Add to git workflow
git add src/powerapps/previews/*.html
git commit -m "Update screen previews for UI changes"
```

### 3. Documentation Generation
```powershell
# Generate index page for all previews
$indexHtml = Generate-PreviewIndex -ScreenDirectory "previews"
$indexHtml | Out-File "previews/index.html"
```

## 🎯 Use Cases

### 1. Design Review Meetings
Share HTML previews with stakeholders who don't have PowerApps access.

### 2. Change Impact Assessment
Generate before/after previews when modifying screen layouts.

### 3. Developer Handoffs
Provide visual specifications alongside functional requirements.

### 4. Testing Documentation
Create visual test cases showing expected UI behavior.

### 5. Training Materials
Generate screenshots and visual guides from actual screen definitions.

## 🚨 Limitations & Considerations

### What Works Well ✅
- Static layout and positioning
- Basic styling (colors, fonts, sizes)
- Control hierarchy and z-indexing
- Mobile device simulation
- Theme-aware styling

### Current Limitations ❌
- **Data Binding**: Can't show actual SharePoint data
- **Dynamic Formulas**: Power Fx expressions not evaluated
- **Interactive Behavior**: No actual button functionality
- **Complex Controls**: Galleries, forms need manual representation
- **Custom Components**: Require individual analysis

### Workarounds 💡
- Use placeholder content for data-driven controls
- Document expected behavior in comments
- Create multiple preview states for different data scenarios
- Include business logic explanations in documentation

## 🔄 Future Enhancements

### Planned Improvements
1. **Enhanced JavaScript Converter**: Better Power Fx formula parsing
2. **Component Library Support**: Handle custom components
3. **Interactive Previews**: Basic click simulation
4. **Batch Processing**: Generate all screen previews automatically
5. **Theme Integration**: Dynamic theme switching
6. **Data Simulation**: Mock data for galleries and forms

This HTML preview system provides a powerful way to visualize PowerApps screens outside the platform, enabling better collaboration, documentation, and design validation workflows.
