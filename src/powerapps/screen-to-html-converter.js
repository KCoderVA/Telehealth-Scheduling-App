/**
 * PowerApps Screen to HTML Converter
 * Converts PowerApps JSON screen definitions to HTML previews
 */

class PowerAppsToHtmlConverter {
  constructor() {
    this.cssRules = [];
    this.htmlElements = [];
  }

  /**
   * Convert PowerApps RGBA to CSS color
   */
  convertRgbaColor(rgbaString) {
    if (!rgbaString || !rgbaString.includes('RGBA')) return 'transparent';

    const match = rgbaString.match(/RGBA\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)/);
    if (match) {
      const [, r, g, b, a] = match;
      return `rgba(${r}, ${g}, ${b}, ${a})`;
    }
    return 'transparent';
  }

  /**
   * Convert PowerApps font to CSS font-family
   */
  convertFont(fontString) {
    if (!fontString) return 'Arial, sans-serif';

    const fontMap = {
      "Font.'Open Sans'": "'Open Sans', sans-serif",
      "Font.'Segoe UI'": "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif",
      "Font.'Arial'": "Arial, sans-serif"
    };

    return fontMap[fontString] || "'Open Sans', sans-serif";
  }

  /**
   * Convert PowerApps alignment to CSS text-align
   */
  convertAlignment(alignString) {
    const alignMap = {
      "Align.Center": "center",
      "Align.Left": "left",
      "Align.Right": "right",
      "VerticalAlign.Middle": "middle",
      "VerticalAlign.Top": "top",
      "VerticalAlign.Bottom": "bottom"
    };

    return alignMap[alignString] || "left";
  }

  /**
   * Extract control properties from Rules array
   */
  extractControlProperties(control) {
    const props = {
      x: 0, y: 0, width: 100, height: 50,
      fill: 'transparent', color: '#000000',
      text: '', font: 'Arial', fontSize: 14,
      align: 'left', verticalAlign: 'top',
      borderColor: 'transparent', borderThickness: 0,
      zIndex: 1, visible: true
    };

    if (control.Rules) {
      control.Rules.forEach(rule => {
        if (!rule.Property || !rule.InvariantScript) return;

        const value = rule.InvariantScript.replace(/"/g, '');

        switch (rule.Property) {
          case 'X': props.x = parseInt(value) || 0; break;
          case 'Y': props.y = parseInt(value) || 0; break;
          case 'Width': props.width = parseInt(value) || 100; break;
          case 'Height': props.height = parseInt(value) || 50; break;
          case 'Fill': props.fill = this.convertRgbaColor(value); break;
          case 'Color': props.color = this.convertRgbaColor(value); break;
          case 'Text': props.text = value; break;
          case 'Font': props.font = this.convertFont(value); break;
          case 'Size': props.fontSize = parseInt(value) || 14; break;
          case 'Align': props.align = this.convertAlignment(value); break;
          case 'VerticalAlign': props.verticalAlign = this.convertAlignment(value); break;
          case 'BorderColor': props.borderColor = this.convertRgbaColor(value); break;
          case 'BorderThickness': props.borderThickness = parseInt(value) || 0; break;
          case 'ZIndex': props.zIndex = parseInt(value) || 1; break;
          case 'Visible': props.visible = !value.includes('false'); break;
        }
      });
    }

    return props;
  }

  /**
   * Generate CSS class for a control
   */
  generateCssClass(control, props) {
    const className = `powerapps-${control.Name.toLowerCase()}`;

    const css = `
.${className} {
    position: absolute;
    left: ${props.x}px;
    top: ${props.y}px;
    width: ${props.width}px;
    height: ${props.height}px;
    background-color: ${props.fill};
    color: ${props.color};
    font-family: ${props.font};
    font-size: ${props.fontSize}px;
    text-align: ${props.align};
    vertical-align: ${props.verticalAlign};
    border: ${props.borderThickness}px solid ${props.borderColor};
    z-index: ${props.zIndex};
    display: ${props.visible ? 'block' : 'none'};
    box-sizing: border-box;
}`;

    this.cssRules.push(css);
    return className;
  }

  /**
   * Generate HTML element for a control
   */
  generateHtmlElement(control, props, className) {
    const templateName = control.Template?.Name || 'unknown';

    switch (templateName) {
      case 'label':
        return `<div class="${className}" title="${control.Name}">${props.text}</div>`;

      case 'button':
        return `<button class="${className}" title="${control.Name}">${props.text}</button>`;

      case 'rectangle':
        return `<div class="${className}" title="${control.Name}"></div>`;

      case 'image':
        return `<div class="${className}" title="${control.Name}">
                    <span style="color: #999; font-size: 12px;">[Image: ${control.Name}]</span>
                </div>`;

      case 'icon':
        const iconVariant = control.VariantName || 'Icon';
        return `<div class="${className}" title="${control.Name}">
                    <span style="color: #666; font-size: ${props.fontSize}px;">⚫</span>
                    <small>${iconVariant}</small>
                </div>`;

      case 'arrow':
        const arrowSymbol = control.VariantName === 'backArrow' ? '←' : '→';
        return `<div class="${className}" title="${control.Name}" style="display: flex; align-items: center; justify-content: center;">
                    <span style="font-size: ${props.fontSize + 10}px;">${arrowSymbol}</span>
                </div>`;

      case 'htmlViewer':
        // Extract HTML content if available
        const htmlContent = props.text || `<div style="background: #f0f0f0; padding: 10px;">HTML Viewer: ${control.Name}</div>`;
        return `<div class="${className}" title="${control.Name}">${htmlContent}</div>`;

      case 'screen':
        return `<div class="${className}" title="${control.Name}"></div>`;

      default:
        return `<div class="${className}" title="${control.Name}">
                    <span style="color: #999; font-size: 10px;">[${templateName}: ${control.Name}]</span>
                </div>`;
    }
  }

  /**
   * Process a control and its children recursively
   */
  processControl(control) {
    const props = this.extractControlProperties(control);
    const className = this.generateCssClass(control, props);
    const htmlElement = this.generateHtmlElement(control, props, className);

    this.htmlElements.push({
      html: htmlElement,
      zIndex: props.zIndex,
      name: control.Name,
      type: control.Template?.Name || 'unknown'
    });

    // Process children recursively
    if (control.Children && Array.isArray(control.Children)) {
      control.Children.forEach(child => this.processControl(child));
    }
  }

  /**
   * Convert PowerApps screen JSON to HTML
   */
  convertScreenToHtml(screenJson) {
    this.cssRules = [];
    this.htmlElements = [];

    // Process the main screen and all its children
    this.processControl(screenJson.TopParent);

    // Sort elements by z-index for proper layering
    this.htmlElements.sort((a, b) => a.zIndex - b.zIndex);

    const css = this.cssRules.join('\n');
    const htmlBody = this.htmlElements.map(el => el.html).join('\n    ');

    const fullHtml = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PowerApps Screen Preview: ${screenJson.TopParent.Name}</title>
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: 'Open Sans', Arial, sans-serif;
            background-color: #f5f5f5;
            position: relative;
        }

        .screen-container {
            position: relative;
            margin: 0 auto;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            background-color: white;
        }

        .screen-info {
            background: #2c3e50;
            color: white;
            padding: 10px;
            font-size: 14px;
            margin-bottom: 10px;
        }

        ${css}
    </style>
</head>
<body>
    <div class="screen-info">
        <strong>Screen:</strong> ${screenJson.TopParent.Name} |
        <strong>Controls:</strong> ${this.htmlElements.length} |
        <strong>Template:</strong> ${screenJson.TopParent.Template?.Name || 'Unknown'}
    </div>

    <div class="screen-container">
        ${htmlBody}
    </div>

    <div style="margin-top: 20px; font-size: 12px; color: #666;">
        <strong>Generated from PowerApps JSON</strong><br>
        Control types: ${[...new Set(this.htmlElements.map(el => el.type))].join(', ')}
    </div>
</body>
</html>`;

    return fullHtml;
  }
}

// Export for Node.js usage
if (typeof module !== 'undefined' && module.exports) {
  module.exports = PowerAppsToHtmlConverter;
}

// Usage example:
// const converter = new PowerAppsToHtmlConverter();
// const html = converter.convertScreenToHtml(screenJsonData);
