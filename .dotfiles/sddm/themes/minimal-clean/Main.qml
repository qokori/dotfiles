import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    anchors.fill: parent
    color: "#0d0d0d"

    // ── Background ───────────────────────────────────────────────────────────
    Image {
        id: background
        anchors.fill: parent
        source: config.background !== "" ? config.background : ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }


    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.45
    }

    // ── Clock ────────────────────────────────────────────────────────────────
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.12
        spacing: 6

        Text {
            id: timeText
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 72
            font.weight: Font.Light
            color: "#ffffff"
            text: Qt.formatTime(new Date(), "HH:mm")
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: timeText.text = Qt.formatTime(new Date(), "HH:mm")
            }
        }

        Text {
            id: dateText
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 16
            font.weight: Font.Light
            color: "#cccccc"
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            Timer {
                interval: 60000
                running: true
                repeat: true
                onTriggered: dateText.text = Qt.formatDate(new Date(), "dddd, MMMM d")
            }
        }
    }

    // ── Login Card ───────────────────────────────────────────────────────────
    Column {
        anchors.centerIn: parent
        spacing: 16

        // Avatar
        Rectangle {
            id: avatarContainer
            anchors.horizontalCenter: parent.horizontalCenter
            width: 90
            height: 90
            radius: 45
            color: "#333333"
            clip: true

            Image {
                id: avatarImage
                anchors.fill: parent
		source: userList.currentIndex >= 0 ? (userModel.data(userModel.index(userList.currentIndex, 0), 0x107) || "") : ""
                fillMode: Image.PreserveAspectCrop
                visible: status === Image.Ready
            }

            Text {
                anchors.centerIn: parent
                visible: avatarImage.status !== Image.Ready
                text: ""
                font.pixelSize: 40
                color: "#ffffff"
            }
        }

        // Username
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: userList.currentIndex >= 0 ? userModel.data(userModel.index(userList.currentIndex, 0), Qt.DisplayRole) : ""
            color: "#ffffff"
            font.pixelSize: 18
            font.weight: Font.Medium
        }

        // Password field
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 260
            height: 42
            radius: 21
            color: "#33ffffff"
            border.color: passwordField.activeFocus ? "#ffffff" : "transparent"
            border.width: 1

            TextInput {
                id: passwordField
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                verticalAlignment: TextInput.AlignVCenter
                echoMode: TextInput.Password
                color: "#ffffff"
                font.pixelSize: 14
                selectionColor: "#44ffffff"
                focus: true

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    text: "Password"
                    color: "#88ffffff"
                    font.pixelSize: 14
                    visible: passwordField.text === ""
                }

                Keys.onReturnPressed: doLogin()
            }
        }

        // Login button
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 260
            height: 42
            radius: 21
            color: loginMouse.containsMouse ? "#ffffffff" : "#ccffffff"

            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: "Login"
                color: "#111111"
                font.pixelSize: 14
                font.weight: Font.Medium
            }

            MouseArea {
                id: loginMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: doLogin()
            }
        }

        // Session selector
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 260
            height: 32
            radius: 16
            color: "#22ffffff"

            Text {
                anchors.centerIn: parent
                text: sessionModel.data(sessionModel.index(sessionList.currentIndex, 0), Qt.DisplayRole) || "Session"
                color: "#cccccc"
                font.pixelSize: 12
            }

            MouseArea {
                anchors.fill: parent
                onClicked: sessionList.currentIndex = (sessionList.currentIndex + 1) % sessionModel.rowCount()
            }
        }
    }

    // ── Hidden lists ─────────────────────────────────────────────────────────
    ListView {
        id: userList
        model: userModel
        visible: false
        currentIndex: 0
    }

    ListView {
        id: sessionList
        model: sessionModel
        visible: false
        currentIndex: 0
    }

    // ── Error message ────────────────────────────────────────────────────────
    Text {
        id: errorMessage
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        color: "#ff6b6b"
        font.pixelSize: 13
        text: ""
        visible: text !== ""
    }

    // ── Login function ───────────────────────────────────────────────────────
    function doLogin() {
   	 var username = userModel.data(userModel.index(userList.currentIndex, 0), 257)
   	 sddm.login(username, passwordField.text, sessionList.currentIndex)
    }
	
    Connections {
        target: sddm
        function onLoginFailed() {
            errorMessage.text = "Incorrect password"
            passwordField.text = ""
            passwordField.focus = true
        }
    }
}
