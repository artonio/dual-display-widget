# Dual Display Toggle Widget

A KDE Plasma 6 widget for the **ASUS Zenbook Duo (2024)** to toggle the secondary ScreenPad display (eDP-2) on and off with a single click.

## Features

- Toggle secondary display with Enable/Disable buttons
- Real-time status indicator showing current display state
- Optional desktop notifications
- Automatic status detection on startup
- Configurable panel icon

## Requirements

- KDE Plasma 6.0+
- Wayland session
- kscreen-doctor (part of libkscreen, usually pre-installed)

## Installation

### Quick Install

```bash
cd /home/artonio/DEV/kde/dual-display-widget
./install-widget.sh
```

### Manual Install

```bash
# Create the widget directory
mkdir -p ~/.local/share/plasma/plasmoids/org.kde.plasma.dualdisplay

# Copy widget files
cp -r contents ~/.local/share/plasma/plasmoids/org.kde.plasma.dualdisplay/
cp metadata.json ~/.local/share/plasma/plasmoids/org.kde.plasma.dualdisplay/
```

### After Installation

1. Right-click on your panel
2. Select "Add Widgets..."
3. Search for "Dual Display Toggle"
4. Click to add it to your panel

**Note:** You may need to restart plasmashell for the widget to appear:
```bash
kquitapp6 plasmashell && kstart plasmashell
```

## Usage

1. **Click the widget icon** in your panel to open the popup
2. The popup shows:
   - Current status (Enabled/Disabled)
   - Display name (eDP-2)
   - Enable and Disable buttons
3. **Click Enable** to turn on the secondary display
4. **Click Disable** to turn it off

### Configuration

Right-click the widget icon → Configure:
- **Show notifications**: Enable/disable desktop notifications when toggling display

## Display Configuration

This widget is configured for:
- **Secondary Display**: eDP-2
- **Position**: Below primary display (0,1125)
- **Scale**: 1.6x (matches primary display)

To modify these settings, edit `contents/code/DisplayController.qml`.

## Troubleshooting

### Widget doesn't appear after installation
```bash
kquitapp6 plasmashell && kstart plasmashell
```

### Check if kscreen-doctor works
```bash
kscreen-doctor -o
```

### Test display commands manually
```bash
# Enable secondary display
kscreen-doctor output.eDP-2.enable output.eDP-2.position.0,1125

# Disable secondary display
kscreen-doctor output.eDP-2.disable
```

## License

GPL-2.0-or-later
