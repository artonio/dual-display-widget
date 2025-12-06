#!/bin/bash

# Dual Display Toggle Widget Installer
# Installs the widget to ~/.local/share/plasma/plasmoids/

WIDGET_ID="org.kde.plasma.dualdisplay"
INSTALL_DIR="$HOME/.local/share/plasma/plasmoids/$WIDGET_ID"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Dual Display Toggle widget..."

# Remove existing installation if present
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing existing installation..."
    rm -rf "$INSTALL_DIR"
fi

# Create installation directory
mkdir -p "$INSTALL_DIR"

# Copy widget files
cp -r "$SCRIPT_DIR/contents" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/metadata.json" "$INSTALL_DIR/"

echo ""
echo "Installation complete!"
echo ""
echo "To add the widget to your panel:"
echo "1. Right-click on your panel"
echo "2. Select 'Add Widgets...'"
echo "3. Search for 'Dual Display Toggle'"
echo "4. Click to add it to your panel"
echo ""
echo "Note: You may need to restart plasmashell for the widget to appear:"
echo "  kquitapp6 plasmashell && kstart plasmashell"
echo ""
