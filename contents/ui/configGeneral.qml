/*
    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: configPage

    property alias cfg_showNotifications: showNotificationsCheckbox.checked

    Kirigami.FormLayout {
        anchors.fill: parent

        // Notifications Section
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Notifications")
        }

        QQC2.CheckBox {
            id: showNotificationsCheckbox
            Kirigami.FormData.label: i18n("Show notifications:")
            text: i18n("Display notifications when toggling display")
        }

        // Info Section
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Information")
        }

        Kirigami.InlineMessage {
            Layout.fillWidth: true
            type: Kirigami.MessageType.Information
            text: i18n("This widget toggles the secondary display (eDP-2) on and off. When enabled, the display is positioned below the primary display.")
            visible: true
        }
    }
}
