# ViBBS – Visualization Building Blocks and Scenarios

The ViBBS tool helps you explore and organize different visualization techniques and design patterns. Each card represents a specific approach or method that can be applied to data visualization projects.

Cards courtesy of [Thorsten May](https://www.igd.fraunhofer.de/de/institut/mitarbeitende/thorsten-may.html) from Fraunhofer IGD, [Lena Cibulski](https://lcibulski.github.io/) from the University of Rostock, [Peter Musaeus](https://www.au.dk/en/petermus@au.dk) and [Hans-Jörg Schulz](https://cs.au.dk/~hjschulz/) from Aarhus University. Developed by [Arvind Srinivasan](https://arvindchee.nu/) as a personal project to make these digital.

## Getting Started

### Initial Setup

1. **Add your card and scenario images** to the respective folders:
   - Cards: `cards/deck-name_card-name.png` (example: `cards/visualization_bar-chart.png`)
   - Scenarios: `scenarios/image-name.png` (or `.jpg`, `.jpeg`) (example: `scenarios/dashboard-layout.png`)

2. **Generate index files** using the cross-platform scripts by `cd`-ing into the `scripts/` folder running:

   **Unix/Linux/Mac:**
   ```bash
   chmod +x generate.sh
   ./generate.sh
   ```

   **Windows:**
   ```cmd
   generate.bat
   ```

3. **Open `index.html`** in your browser or host it on a web server

### File Naming Convention

- **Cards**: `deck-name_card-name.png`
  - Examples: `visualization_bar-chart.png`, `interaction_tooltip.png`
  - Use lowercase letters and hyphens (no spaces)
  - Must match a deck `id` in `deck.js`

- **Scenarios**: Any image filename (`.png`, `.jpg`, `.jpeg`)
  - Examples: `dashboard-overview.png`, `mobile-design.jpg`
  - Lowercase and hyphens recommended for consistency

## Adding Content

### Method 1: Using Generation Scripts (Recommended)

The generation scripts automatically discover all image files and create the required index files.

**Unix/Linux/Mac:**
```bash
./generate.sh
```

**Windows:**
```cmd
generate.bat
```

**Output example:**
```
✓ Generated cards/index.js with 65 files
✓ Generated scenarios/index.js with 10 files
Index files have been generated. You can now use the ViBBS application.
```

### Method 2: Manual Addition

If you prefer to manage files manually or the scripts don't work in your environment:

#### Adding Cards Manually

1. Add your image to the `cards/` folder. Let's say: `cards/visualization_pie-chart.png`

2. Edit `cards/index.js` and add the filename to the array:
   ```javascript
   export const files = [
     "visualization_bar-chart.png",  // <- Existing example files
     "visualization_pie-chart.png",  // <- Add this line
     "interaction_tooltip.png",
     // ... other files
   ];
   
   // Note: No need to update lastGenerated when editing manually
   export const lastGenerated = "2025-01-16T10:30:00Z";
   ```

#### Adding Scenarios Manually

1. Add your image to the `scenarios/` folder. For example: `scenarios/new-dashboard.png`

2. Edit `scenarios/index.js` and add the filename:
   ```javascript
   export const files = [
     "dashboard-overview.png",      // <- Existing example files
     "new-dashboard.png",           // <- Add this line
     "mobile-layout.jpg",
     // ... other files
   ];
   
   // Note: No need to update lastGenerated when editing manually
   export const lastGenerated = "2025-01-16T10:30:00Z";
   ```

## Configuration

### Adding a New Deck

To add a new deck category, edit `deck.js` and add a new object to the `decks` array. For example:

```javascript
export const decks = [
  {
    "id": "deck-id",           // Must match your card filename prefix
    "title": "Deck Title",     // Display name
    "color": "sky",            // Theme color (see available colors below)
    "description": "Description to show in info modal",
    "order": 1                 // Display order (integer)
  },
  // ... other decks
];
```

**Available Colors:**
`red`, `orange`, `amber`, `yellow`, `lime`, `green`, `emerald`, `teal`, `cyan`, `sky`, `blue`, `indigo`, `violet`, `purple`, `fuchsia`, `pink`, `rose`, `slate`, `gray`, `zinc`, `neutral`, `stone`

## Features

- **📌 Pin Cards**: Click cards or use the pin button to save them to your collection
- **👁️ Hide/Show Pinned**: Toggle visibility of pinned cards in each category
- **🏷️ Filter by Category**: Use filter pills in the drawer to view specific deck types
- **📱 Responsive Design**: Works on desktop, tablet, and mobile devices
- **🖼️ Scenario Gallery**: View larger scenario images with PhotoSwipe lightbox
- **💾 Persistent Storage**: Your pinned cards are saved locally in the browser

## Development

### Project Structure

```
├── index.html              # Main application
├── deck.js                 # Deck configuration
├── generate.sh            # Unix generation script
├── generate.bat           # Windows generation script
├── cards/
│   ├── index.js           # Auto-generated card index
│   └── *.png              # Card images (e.g., visualization_bar-chart.png)
└── scenarios/
    ├── index.js           # Auto-generated scenario index
    └── *.{png,jpg,jpeg}   # Scenario images (e.g., dashboard-overview.png)
```

### Troubleshooting

**Cards not showing up?**
- Check that card filenames follow the `deck-name_card-name.png` pattern (e.g., `visualization_pie-chart.png`)
- Ensure the deck name matches an `id` in `deck.js`
- Run the generation script to update `cards/index.js`

**Scripts not working?**
- **Unix/Linux/Mac**: Make sure the script is executable: `chmod +x scripts/generate.sh`
- **Windows**: Run `scripts/generate.bat` from Command Prompt or PowerShell
- **Alternative**: Add files manually to the index.js files

**Images not loading?**
- Verify image files are in the correct directories
- Check browser console for 404 errors
- Ensure proper file naming conventions are followed

## Browser Compatibility

- Modern browsers supporting ES6 modules
- Chrome 61+, Firefox 60+, Safari 10.1+, Edge 16+
- No build step required - runs directly in the browser
