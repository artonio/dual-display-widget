# Claude Code Development Notes

## Project Context

This is a KDE Plasma 6 plasmoid widget created with Claude Code assistance. The widget provides a panel icon that opens a popup to enable/disable a secondary display using kscreen-doctor.

## Technical Architecture

### Technology Stack
- **KDE Plasma**: 6.0+
- **Qt/QML**: Plasma 6 APIs
- **Display Control**: kscreen-doctor (Wayland-compatible)
- **Architecture**: Popup-based with controller component

### Key Design Decisions

1. **Popup-Based Interaction**
   - Compact representation (icon) opens popup on click
   - Full representation (popup) contains control buttons
   - This pattern matches working KDE widgets and ensures reliable click handling

2. **Component Separation**
   - `DisplayController.qml`: Isolated display control logic
   - `main.qml`: UI integration and signal handling
   - Rationale: Single responsibility, testability

3. **Plasma 6 Compatibility**
   - Uses `PlasmoidItem` as root element (required for Plasma 6)
   - Uses `Plasma5Support.DataSource` for shell execution
   - Modern imports: `org.kde.kirigami`, `org.kde.plasma.extras`

4. **kscreen-doctor for Display Control**
   - Native KDE tool for Wayland display management
   - Commands: `output.eDP-2.enable`, `output.eDP-2.disable`
   - Parses `kscreen-doctor -o` output to detect current state

## File Structure

```
dual-display-widget/
├── metadata.json                      # Widget identity, Plasma 6 compatibility
├── install-widget.sh                  # Installation script
├── README.md                          # User documentation
├── CLAUDE.md                          # Development notes (this file)
├── contents/
│   ├── config/
│   │   ├── main.xml                  # Configuration schema (type-safe)
│   │   └── config.qml                # Config page registration
│   ├── code/
│   │   └── DisplayController.qml     # Display control logic (reusable)
│   └── ui/
│       ├── main.qml                  # Main widget (integration)
│       └── configGeneral.qml         # Configuration UI
```

## Display Control Commands

```bash
# List displays and status
kscreen-doctor -o

# Enable secondary display at position below primary
kscreen-doctor output.eDP-2.enable output.eDP-2.position.0,1125

# Disable secondary display
kscreen-doctor output.eDP-2.disable
```

## Customization

### Changing Target Display
Edit `contents/code/DisplayController.qml`:
```qml
property string displayName: "eDP-2"    // Change display ID
property string position: "0,1125"       // Change position (x,y)
```

### Adding More Displays
1. Add configuration entries to `main.xml`
2. Create additional DisplayController instances in `main.qml`
3. Add UI controls in fullRepresentation

## Development Workflow

### Testing During Development
```bash
cd /home/artonio/DEV/kde/dual-display-widget
plasmoidviewer -a . -l topedge -f horizontal
```

### Installing Locally
```bash
./install-widget.sh
# Or manually:
cp -r . ~/.local/share/plasma/plasmoids/org.kde.plasma.dualdisplay
kquitapp6 plasmashell && kstart plasmashell
```

### Debugging
- Console output: `journalctl -f | grep plasma`
- QML errors appear in plasmoidviewer stderr
- Add `console.log()` statements in QML files

## Known Limitations

1. **Hardcoded Display**
   - Currently hardcoded to eDP-2
   - Position hardcoded to 0,1125 (below primary)

2. **Status Polling**
   - Status checked on startup and after commands
   - No real-time monitoring (would require polling)

3. **Single Display Only**
   - Designed for dual-display setup
   - Would need UI changes for more displays

## Future Enhancement Ideas

- **Display Selection**: Dropdown to choose which display to control
- **Position Options**: Configure display position (left/right/above/below)
- **Multiple Displays**: Support for 3+ display setups
- **Quick Toggle**: Single-click toggle without popup
- **Presets**: Save and restore display configurations

## References

- [KDE Plasma Widget Development](https://develop.kde.org/docs/plasma/widget/)
- [Porting to Plasma 6](https://develop.kde.org/docs/plasma/widget/porting_kf6/)
- [kscreen-doctor Documentation](https://invent.kde.org/plasma/libkscreen)
- System examples: `/usr/share/plasma/plasmoids/`
- User examples: `~/.local/share/plasma/plasmoids/`

## Modification History

- **2025-12-05**: Initial creation with popup-based UI
  - 7 files: metadata, config schema, config UI, controller, main widget, install script
  - Full GUI configuration support
  - Notification system
  - Based on custom-actions-plasmoid template
