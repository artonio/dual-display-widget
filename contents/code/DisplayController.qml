/*
    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import org.kde.plasma.plasma5support as Plasma5Support

Item {
    id: displayController

    signal statusChanged(bool enabled)
    signal executionCompleted(string message)
    signal executionFailed(string error)

    property bool isRunning: false
    property bool isEnabled: false
    property string displayName: "eDP-2"
    property string position: "0,1125"

    // DataSource for executing shell commands
    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        onNewData: function(sourceName, data) {
            disconnectSource(sourceName)
            isRunning = false

            // Check if this was a status check command
            if (sourceName.indexOf("kscreen-doctor -o") !== -1) {
                parseStatusOutput(data.stdout || "")
                return
            }

            // Handle enable/disable commands
            if (data["exit code"] === 0) {
                executionCompleted(data.stdout || "Display updated successfully")
                // Check status after change
                checkStatus()
            } else {
                executionFailed(data.stderr || "Failed to update display")
            }
        }
    }

    function parseStatusOutput(output) {
        // Look for eDP-2 section and check if enabled or disabled
        var lines = output.split("\n")
        var inEDP2Section = false

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i]

            // Check if we're entering the eDP-2 section
            if (line.indexOf(displayName) !== -1) {
                inEDP2Section = true
                continue
            }

            // If we're in the eDP-2 section, check for enabled/disabled
            if (inEDP2Section) {
                if (line.indexOf("enabled") !== -1) {
                    isEnabled = true
                    statusChanged(true)
                    return
                } else if (line.indexOf("disabled") !== -1) {
                    isEnabled = false
                    statusChanged(false)
                    return
                }
                // If we hit another Output line, we've left the eDP-2 section
                if (line.indexOf("Output:") !== -1) {
                    break
                }
            }
        }

        // Default to disabled if not found
        isEnabled = false
        statusChanged(false)
    }

    function checkStatus() {
        if (isRunning) {
            return false
        }

        var command = "kscreen-doctor -o"
        isRunning = true
        executable.connectSource(command)
        return true
    }

    function enable() {
        if (isRunning) {
            console.warn("Display command already running, ignoring request")
            return false
        }

        var command = "kscreen-doctor output." + displayName + ".enable output." + displayName + ".position." + position
        console.log("Enabling display:", command)

        isRunning = true
        executable.connectSource(command)
        return true
    }

    function disable() {
        if (isRunning) {
            console.warn("Display command already running, ignoring request")
            return false
        }

        var command = "kscreen-doctor output." + displayName + ".disable"
        console.log("Disabling display:", command)

        isRunning = true
        executable.connectSource(command)
        return true
    }

    function toggle() {
        if (isEnabled) {
            return disable()
        } else {
            return enable()
        }
    }

    Component.onCompleted: {
        // Check status on startup
        checkStatus()
    }
}
