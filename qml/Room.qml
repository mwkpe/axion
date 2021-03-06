import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11


Page {
  ColumnLayout {
    anchors.fill: parent
    spacing: 0

    ListView {
      id: chatView
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.leftMargin: 12
      Layout.rightMargin: 12
      displayMarginBeginning: 48
      displayMarginEnd: 48
      verticalLayoutDirection: ListView.BottomToTop
      spacing: 12
      model: roomModel

      delegate: Row {
        readonly property bool sentByMe: user_id === roomModel.user
        readonly property bool dummyRoom: roomModel.room_name === "music" ||
            roomModel.room_name === "physics"

        id: messageRow
        anchors.right: sentByMe ? parent.right : undefined
        height: sentByMe ? speechBubble.height : Math.max(userImage.height, speechBubble.height)
        spacing: 12

        Image {
          id: userImage
          width: config.avatarSize
          height: config.avatarSize
          smooth: true
          asynchronous: true
          source: !sentByMe ? dummyRoom ? "qrc:/img/res/img/" + account_name + ".png" :
              "image://matrix_media/" + avatar_id : ""
          visible: !sentByMe
        }

        Rectangle {
          id: speechBubble
          width: message_type == 3 ? messageImage.implicitWidth + 16 : Math.min(messageText.implicitWidth + 16,
                 chatView.width - (!sentByMe ? userImage.width + 12 : 0))
          height: message_type == 3 ? messageImage.implicitHeight + 16 : messageText.implicitHeight + 16
          radius: 8
          function deduceStateColor()
          {
            var stateColor = "grey"
            if (sentByMe) {
              if (message_type == 1) {
                if (transmit_confirmed) {
                  stateColor = "darkorchid"
                }
                else if (transmit_failed) {
                  stateColor = "indianred"
                }
              }
              else {
                if (transmit_confirmed) {
                  stateColor = "teal"
                }
                else if (transmit_failed) {
                  stateColor = "indianred"
                }
              }
            }
            else {
              if (message_type == 1) {
                stateColor = "slateblue"
              }
              else {
                stateColor = "steelblue"
              }
            }

            return stateColor
          }
          color: deduceStateColor()

          Label {
            id: messageText
            renderType: Text.NativeRendering
            anchors.fill: parent
            anchors.margins: 8
            text: sentByMe ? message_type == 1 ? "<i>" + display_name + " " + message_text + "</i>"
                                               : message_text
                           : message_type == 1 ? "<i>" + display_name + " " + message_text + "</i>"
                                               : "<b><font color=\"lightgrey\">" + display_name +
                                                 "</font></b><br>" + message_text
            font.family: "Segoe UI"
            font.bold: false
            font.italic: false
            font.pixelSize: config.textSize
            wrapMode: Label.Wrap
            color: "white"
            visible: message_type != 3
          }

          Image {
            id: messageImage
            anchors.fill: parent
            anchors.margins: 8
            smooth: true
            asynchronous: true
            source: "image://matrix_media/" + image_id
            visible: message_type == 3
          }
        }
      }
    }

    InputPane {
    }
  }
}
