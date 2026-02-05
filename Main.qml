import QtQuick
import Qt5Compat.GraphicalEffects

Window {
    id: window
    width: 480
    height: 560
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    color: "transparent"

    property int duration: 215
    property int position: 87

    Rectangle {
        id: body
        z: 0
        anchors.fill: parent
        anchors.leftMargin: 70
        anchors.topMargin: 20
        anchors.rightMargin: 20
        anchors.bottomMargin: 20

        radius: 15

        color: "#eef3f7"

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 20.0
            samples: 17
            color: "#777a7c"
        }
    }

    Item {
        id: coverImg
        z: 1
        x: 20
        y: 50
        width: 300
        height: 300

        Image {
            id: coverImage
            anchors.fill: parent

            source: "UIdesign/cover2.jpg"
            fillMode: Image.PreserveAspectCrop

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: 300
                    height: 300
                    radius: 15
                    visible: false
                }
            }
        }
    }

    Item {
        id: coverShadow
        z: 0
        visible: true
        anchors.horizontalCenter: coverImg.horizontalCenter
        width: coverImg.width * 0.9
        height: coverImg.height * 0.9
        anchors.bottom: coverImg.bottom
        anchors.bottomMargin: -18

        FastBlur {
            transparentBorder: true
            anchors.fill: parent
            anchors.margins: 0
            source: coverImg
            radius: 30
            opacity: 0.8
        }
    }

    Text {
        id: title
        anchors.left: body.left
        anchors.leftMargin: 30
        anchors.top: coverShadow.bottom
        anchors.topMargin: 3
        width: 200

        text: "title"

        font.family: "Segoe UI Semibold"
        font.pointSize: 20
        color: "#777a7c"
        wrapMode: Text.Wrap
    }

    Text {
        id: artist
        anchors.left: body.left
        anchors.leftMargin: 30
        anchors.top: title.bottom
        anchors.topMargin: 8
        width: 200

        text: "artist"

        font.family: "Segoe UI Semilight"
        font.pointSize: 18
        color: "#8f9294"
        wrapMode: Text.Wrap
    }

    PlayingSlider {
        id: playingSlider
        anchors.bottom: body.bottom
        anchors.bottomMargin: 50

        anchors.left: body.left
        anchors.leftMargin: 30
        anchors.right: body.right
        anchors.rightMargin: 30

        height: 6

        from: 0
        to: 215
    }

    Text {
        id: playingSliderTest
        text: playingSlider.position
        anchors.top: playingSlider.bottom
        anchors.horizontalCenter: playingSlider.horizontalCenter
    }

    Text {
        id: duration
        anchors.right: playingSlider.right
        anchors.bottom: playingSlider.top
        anchors.bottomMargin: 10

        text: "03:35"

        font.family: "Segoe UI Semibold"
        font.pointSize: 16
        color: "#8f9294"
        wrapMode: Text.Wrap
    }

    Text {
        id: position
        anchors.left: playingSlider.left
        anchors.top: playingSlider.bottom
        anchors.topMargin: 8

        text: "01:27"

        font.family: "Segoe UI Semibold"
        font.pointSize: 14
        color: "#8f9294"
        wrapMode: Text.Wrap
    }

    Item {
        id: buttonArea
        anchors.left: coverImg.right
        anchors.right: body.right
        anchors.top: coverImg.top
        anchors.bottom: duration.top
    }

    Image {
        id: likeButton
        anchors.horizontalCenter: buttonArea.horizontalCenter
        anchors.top: buttonArea.top
        anchors.topMargin: 20
        width: 36
        height: 36

        fillMode: Image.PreserveAspectCrop

        source: "icons/like_n.svg"

        SwitchButton {
            id: likeButtonSwitch
            anchors.fill: parent

            property int stateNum: 0

            onIsTapped: {
                stateNum = stateNum === 0 ? 1 : 0
            }
            onStateNumChanged: {
                if(stateNum === 0){
                    likeButton.source = "icons/like_n.svg"
                }else {
                    likeButton.source = "icons/like_y.svg"
                }
            }
        }
    }

    Image {
        id: shareButton
        anchors.horizontalCenter: buttonArea.horizontalCenter
        anchors.top: likeButton.bottom
        anchors.topMargin: 24
        width: 32
        height: 32

        fillMode: Image.PreserveAspectCrop

        source: "icons/share.svg"
    }

    Image {
        id: lastButton
        anchors.horizontalCenter: buttonArea.horizontalCenter
        anchors.top: shareButton.bottom
        anchors.topMargin: 24
        width: 32
        height: 32

        fillMode: Image.PreserveAspectCrop

        source: "icons/last.svg"
    }


    Image {
        id: nextButton
        anchors.horizontalCenter: buttonArea.horizontalCenter
        anchors.top: lastButton.bottom
        anchors.topMargin: 24
        width: 32
        height: 32

        fillMode: Image.PreserveAspectCrop

        source: "icons/last.svg"

        rotation: 180
    }

    Image {
        id: playButton
        anchors.horizontalCenter: buttonArea.horizontalCenter
        anchors.top: nextButton.bottom
        anchors.topMargin: 28
        width: 100
        height: 100

        fillMode: Image.PreserveAspectCrop

        source: "icons/play.svg"

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 10
            radius: 15.0
            samples: 17
            color: "#bec2c6"
        }

        SwitchButton {
            id: playButtonSwitch
            anchors.fill: parent

            property int stateNum: 0

            onIsTapped: {
                stateNum = stateNum === 0 ? 1 : 0
            }
            onStateNumChanged: {
                if(stateNum === 0){
                    playButton.source = "icons/play.svg"
                }else {
                    playButton.source = "icons/pause.svg"
                }
            }
        }
    }


}
