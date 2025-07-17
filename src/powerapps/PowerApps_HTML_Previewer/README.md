# PowerApps HTML Previewer v1.0

## Overview
A portable, standalone tool for converting PowerApps JSON screen definitions into interactive HTML previews. Perfect for design validation, stakeholder reviews, and documentation.

## 🚀 Quick Start

### Method 1: Double-Click Launch (Easiest)
1. Double-click `Launch PowerApps Previewer.bat`
2. Click "OK" on the welcome dialog
3. Browse and select your PowerApps JSON file
4. Wait for processing to complete
5. Your HTML preview will open automatically!

### Method 2: Command Line
```powershell
# Navigate to the scripts folder
cd scripts

# Run with a specific file
.\PowerApps-Converter.ps1 -InputFile "C:\path\to\your\screen.json"
```

## 📁 Directory Structure
```
PowerApps_HTML_Previewer/
├── Launch PowerApps Previewer.bat    # Main executable (double-click this!)
├── scripts/
│   ├── PowerApps-Converter.ps1       # Core conversion engine
│   └── PowerApps-GUI-Launcher.ps1    # GUI file picker interface
├── templates/
│   └── (HTML templates and examples)
├── generated_previews/
│   └── (Your generated HTML files appear here)
├── docs/
│   ├── README.md                      # This file
│   └── User-Guide.md                  # Detailed usage guide
└── PORTABLE_INSTRUCTIONS.md           # How to use in other projects
```

## ✨ Features

### What It Does
- ✅ Converts PowerApps JSON to beautiful HTML previews
- ✅ Preserves layout, colors, fonts, and positioning
- ✅ Mobile device frame simulation
- ✅ Interactive GUI file picker
- ✅ Automatic browser opening
- ✅ Detailed generation reports

### Supported PowerApps Elements
| Element Type | Support Level | Notes |
|-------------|---------------|-------|
| Labels | ✅ Full | Text, styling, positioning |
| Buttons | ✅ Full | Interactive styling |
| Rectangles | ✅ Full | Background shapes |
| Images | 🔶 Partial | Placeholder representation |
| Icons | ✅ Full | Unicode symbol mapping |
| Arrows | ✅ Full | Directional indicators |
| HTML Viewers | 🔶 Partial | Basic content rendering |
| Screens | ✅ Full | Container layouts |

### What Gets Converted
- **Position & Size**: X, Y, Width, Height
- **Colors**: Fill, Color (RGBA conversion)
- **Typography**: Font, Size, Weight, Alignment
- **Visibility**: Show/hide states
- **Z-Index**: Layer ordering
- **Basic Styling**: Borders, backgrounds

## 🎯 Use Cases

### Design Validation
- Preview layout changes before PowerApps deployment
- Validate responsive behavior
- Check visual hierarchy and spacing

### Stakeholder Reviews
- Share designs with non-PowerApps users
- Get feedback without platform access
- Document design decisions

### Development Workflow
- Generate visual specifications
- Create test cases with expected UI
- Track UI changes in version control

### Training & Documentation
- Create visual guides
- Generate screenshots for tutorials
- Document app functionality

## 🔧 Technical Details

### Requirements
- Windows 10/11
- PowerShell 5.1 or later
- .NET Framework 4.5+ (for GUI components)
- Modern web browser for preview viewing

### Input File Formats
- **PowerApps JSON**: Screen exports from unpacked .msapp files
- **Component JSON**: Individual control definitions
- **YAML**: PowerApps YAML format (experimental)

### Output Features
- **Responsive HTML5**: Clean, modern markup
- **Embedded CSS**: No external dependencies
- **Device Simulation**: Mobile frame with status bar
- **Generation Metadata**: Detailed conversion reports

## 🚨 Limitations

### What's Not Supported (Yet)
- ❌ **Data Binding**: SharePoint/API data not rendered
- ❌ **Power Fx Formulas**: Logic expressions not evaluated
- ❌ **Interactive Behavior**: Button clicks, navigation
- ❌ **Complex Controls**: Galleries, forms (show placeholders)
- ❌ **Custom Components**: Require manual handling

### Workarounds
- Use placeholder content for dynamic elements
- Generate multiple previews for different states
- Include business logic in documentation
- Create enhanced versions manually for complex screens

## 🔄 Version History

### v1.0 (Current)
- ✅ Initial release
- ✅ GUI file picker interface
- ✅ Portable, standalone operation
- ✅ Basic PowerApps element support
- ✅ HTML5 output with device simulation
- ✅ Comprehensive error handling

### Planned Features (v1.1)
- 🔮 Theme support (Dark/Light mode)
- 🔮 Batch processing multiple files
- 🔮 Enhanced gallery/form representation
- 🔮 Power Fx formula parsing
- 🔮 Custom component templates

## 🆘 Troubleshooting

### Common Issues

**"PowerShell execution policy error"**
```
Solution: Right-click the .bat file → "Run as Administrator"
Or manually set execution policy: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**"File not found" errors**
```
Solution: Ensure JSON files are valid PowerApps exports
Check file permissions and path accessibility
```

**"HTML preview is blank"**
```
Solution: Verify JSON structure has "TopParent" property
Check that the file contains PowerApps screen data
```

**GUI doesn't appear**
```
Solution: Ensure .NET Framework 4.5+ is installed
Try running PowerApps-GUI-Launcher.ps1 directly
```

### Getting Help
1. Check the generated HTML for error details
2. Review the console output during conversion
3. Validate your input JSON structure
4. Try with a simple test file first

## 📜 License & Usage
This tool is provided as-is for PowerApps development workflows. Feel free to modify and distribute for your team's needs.

## 📞 Support
For issues or feature requests, please document the problem with:
- Input file sample (if possible)
- Error messages
- Expected vs. actual output
- PowerApps version information
