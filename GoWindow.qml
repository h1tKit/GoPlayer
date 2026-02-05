import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

import Qt5Compat.GraphicalEffects


Window {
    id: window
    minimumWidth: 600
    minimumHeight: 400
    flags: Qt.Window | Qt.FramelessWindowHint
    color: "transparent"
    visible: true

    signal miniSize()
    signal midSize()
    signal maxSize()

    onWidthChanged: {
        window.width > 1000 ? maxSize() : window.width > 650 ? midSize() : miniSize()
    }

    Rectangle {
        id: titleBar
        anchors.left: parent.left
        anchors.right: parent.right
        height: 40
        color: Qt.rgba(0.106, 0.553, 0.788,1)

        topLeftRadius: 12
        topRightRadius: 12

        Rectangle {               //fix bottom radius
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 20
            color: parent.color
        }

        Text {
            id: titleText
            text: "SHX Music"
            color: "white"
            font.pixelSize: 16

            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
        }

        Row {
            id: windowControlButtons
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            RoundButton {
                id: minButton
                width: 30
                height: 30
                radius: 10
                Text {
                    text: "—"
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }
                onClicked: window.showMinimized()
            }

            RoundButton {
                id: maxButton
                width: 30
                height: 30
                radius: 10
                Text {
                    text: window.visibility === Window.Maximized ? "❐" : "□"
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }
                onClicked: window.toggleMaximize()
            }

            RoundButton {
                id: closeButton
                width: 30
                height: 30
                radius: 10
                Text {
                    color: closeButton.isHoverd ? "white" : "black"
                    text: "×"
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }
                onClicked: window.close()
            }
        }

        Item {
            id: dragArea
            anchors.left: parent.left
            anchors.right: windowControlButtons.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            TapHandler {
                onDoubleTapped: {
                    window.toggleMaximize()
                }
            }
            DragHandler {
                onActiveChanged: {
                    if(active){
                        window.startSystemMove()
                    }
                }
            }
        }
    }//title ends here

    Rectangle {
        id: mainArea
        y: titleBar.height
        width: window.width
        height: window.height - titleBar.height
        bottomLeftRadius: 12
        bottomRightRadius: 12

        color: Qt.rgba(1,1,1,1)
    }

    Rectangle {
        id: contentRect
        anchors.fill: mainArea
        anchors.margins: 15
        color: "white"
        radius: 12

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 15.0
            samples: 17
            color: "#80000000"
        }
    }

    Item {
        id: resizeWindow
        anchors.fill: parent

        property real edgeSize: 6
        property real cornerSize: 7

        Item {
            id: leftTopArea
            anchors.left: parent.left
            anchors.top: parent.top
            width: resizeWindow.cornerSize
            height: resizeWindow.cornerSize

            HoverHandler {
                cursorShape: Qt.SizeFDiagCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.LeftEdge | Qt.TopEdge)
                }
            }
        }
        Item {
            id: leftBottomArea
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: resizeWindow.cornerSize
            height: resizeWindow.cornerSize

            HoverHandler {
                cursorShape: Qt.SizeBDiagCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.LeftEdge | Qt.BottomEdge)
                }
            }
        }
        Item {
            id: rightTopArea
            anchors.right: parent.right
            anchors.top: parent.top
            width: resizeWindow.cornerSize
            height: resizeWindow.cornerSize

            HoverHandler {
                cursorShape: Qt.SizeBDiagCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.RightEdge | Qt.TopEdge)
                }
            }
        }
        Item {
            id: rightBottomArea
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: resizeWindow.cornerSize
            height: resizeWindow.cornerSize

            HoverHandler {
                cursorShape: Qt.SizeFDiagCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
                }
            }
        }
        Item {
            id: leftArea
            anchors.left: parent.left
            anchors.top: leftTopArea.bottom
            anchors.bottom: leftBottomArea.top
            width: resizeWindow.edgeSize

            HoverHandler {
                cursorShape: Qt.SizeHorCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.LeftEdge)
                }
            }
        }
        Item {
            id: rightArea
            anchors.right: parent.right
            anchors.top: rightTopArea.bottom
            anchors.bottom: rightBottomArea.top
            width: resizeWindow.edgeSize

            HoverHandler {
                cursorShape: Qt.SizeHorCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.RightEdge)
                }
            }
        }
        Item {
            id: topArea
            anchors.left: leftTopArea.right
            anchors.top: parent.top
            anchors.right: rightTopArea.left
            height: resizeWindow.edgeSize

            HoverHandler {
                cursorShape: Qt.SizeVerCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.TopEdge)
                }
            }
        }
        Item {
            id: bottomArea
            anchors.left: leftBottomArea.right
            anchors.bottom: parent.bottom
            anchors.right: rightBottomArea.left
            height: resizeWindow.edgeSize

            HoverHandler {
                cursorShape: Qt.SizeVerCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.BottomEdge)
                }
            }
        }
    }

    function toggleMaximize() {
        if (window.visibility === Window.Maximized) {
            titleBar.topLeftRadius = 12
            titleBar.topRightRadius = 12
            mainArea.bottomLeftRadius = 12
            mainArea.bottomRightRadius = 12
            window.showNormal()
        } else {
            window.showMaximized()
            titleBar.topLeftRadius = 0
            titleBar.topRightRadius = 0
            mainArea.bottomLeftRadius = 0
            mainArea.bottomRightRadius = 0
        }
    }
}
