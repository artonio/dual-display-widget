/*
    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami
import org.kde.notification
import "../code" as Code

PlasmoidItem {
    id: root

    // ===== Configuration Bindings =====
    readonly property string widgetIcon: Plasmoid.configuration.widgetIcon
    readonly property bool showNotifications: Plasmoid.configuration.showNotifications

    // ===== Widget Configuration =====
    Plasmoid.icon: widgetIcon
    toolTipMainText: i18n("Dual Display Toggle")
    toolTipSubText: displayController.isEnabled ? i18n("Secondary Display: On") : i18n("Secondary Display: Off")

    // Preferred representation for panel
    preferredRepresentation: compactRepresentation

    // ===== Display Controller =====
    Code.DisplayController {
        id: displayController

        onStatusChanged: function(enabled) {
            console.log("Display status changed:", enabled ? "enabled" : "disabled")
        }

        onExecutionCompleted: function(message) {
            console.log("Display: Completed -", message)
            if (showNotifications) {
                sendNotification(
                    "Dual Display",
                    displayController.isEnabled ? "Secondary display enabled" : "Secondary display disabled",
                    "dialog-positive"
                )
            }
        }

        onExecutionFailed: function(error) {
            console.error("Display: Failed -", error)
            if (showNotifications) {
                sendNotification("Dual Display", "Failed: " + error, "dialog-error")
            }
        }
    }

    // ===== Notification Component =====
    Notification {
        id: notification
        componentName: "plasma_workspace"
        eventId: "notification"
    }

    function sendNotification(title, message, iconName) {
        notification.title = title
        notification.text = message
        notification.iconName = iconName
        notification.sendEvent()
    }

    // ===== Context Menu Actions =====
    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Configure...")
            icon.name: "configure"
            onTriggered: Plasmoid.internalAction("configure").trigger()
        }
    ]

    // ===== Compact Representation (Panel Icon) =====
    compactRepresentation: Kirigami.Icon {
        source: root.widgetIcon

        // Hover effect for Plasma 6
        opacity: mouseArea.containsMouse ? 0.8 : 1.0
        Behavior on opacity {
            NumberAnimation { duration: Kirigami.Units.shortDuration }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.expanded = !root.expanded
        }
    }

    // ===== Full Representation (Popup Menu) =====
    fullRepresentation: PlasmaExtras.Representation {
        Layout.minimumWidth: Kirigami.Units.gridUnit * 12
        Layout.minimumHeight: Kirigami.Units.gridUnit * 6
        Layout.preferredWidth: Kirigami.Units.gridUnit * 14
        Layout.preferredHeight: contentLayout.implicitHeight

        collapseMarginsHint: true

        ColumnLayout {
            id: contentLayout
            anchors.fill: parent
            spacing: 0

            // Header
            PlasmaExtras.PlasmoidHeading {
                Layout.fillWidth: true

                RowLayout {
                    anchors.fill: parent

                    Kirigami.Icon {
                        Layout.preferredWidth: Kirigami.Units.iconSizes.small
                        Layout.preferredHeight: Kirigami.Units.iconSizes.small
                        source: root.widgetIcon
                    }

                    PlasmaComponents3.Label {
                        Layout.fillWidth: true
                        text: i18n("Secondary Display")
                        font.weight: Font.Bold
                    }

                    PlasmaComponents3.ToolButton {
                        icon.name: "configure"
                        text: i18n("Configure")
                        display: PlasmaComponents3.AbstractButton.IconOnly
                        onClicked: {
                            root.expanded = false
                            Plasmoid.internalAction("configure").trigger()
                        }

                        PlasmaComponents3.ToolTip {
                            text: parent.text
                        }
                    }
                }
            }

            // Content
            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.smallSpacing
                Layout.rightMargin: Kirigami.Units.smallSpacing
                Layout.topMargin: Kirigami.Units.smallSpacing
                Layout.bottomMargin: Kirigami.Units.smallSpacing
                spacing: Kirigami.Units.smallSpacing

                // Status indicator
                PlasmaComponents3.Label {
                    Layout.fillWidth: true
                    text: displayController.isEnabled ? i18n("Status: Enabled") : i18n("Status: Disabled")
                    horizontalAlignment: Text.AlignHCenter
                    color: displayController.isEnabled ? Kirigami.Theme.positiveTextColor : Kirigami.Theme.neutralTextColor
                }

                // Display name
                PlasmaComponents3.Label {
                    Layout.fillWidth: true
                    text: "eDP-2"
                    horizontalAlignment: Text.AlignHCenter
                    opacity: 0.7
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                }

                // Control buttons
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    PlasmaComponents3.Button {
                        Layout.fillWidth: true
                        text: i18n("Enable")
                        icon.name: "monitor-on"
                        enabled: !displayController.isEnabled && !displayController.isRunning

                        onClicked: {
                            displayController.enable()
                        }
                    }

                    PlasmaComponents3.Button {
                        Layout.fillWidth: true
                        text: i18n("Disable")
                        icon.name: "monitor-off"
                        enabled: displayController.isEnabled && !displayController.isRunning

                        onClicked: {
                            displayController.disable()
                        }
                    }
                }

                // Busy indicator
                PlasmaComponents3.BusyIndicator {
                    Layout.alignment: Qt.AlignHCenter
                    running: displayController.isRunning
                    visible: displayController.isRunning
                }
            }
        }
    }
}
