import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    id: root

    property alias from: slider.from
    property alias to: slider.to

    property alias position: slider.position

    Slider {
        id: slider
        anchors.fill: parent
        handle: Item{}
    }

    Rectangle {
        id: body
        anchors.fill: parent
        radius: height / 2

        color: "#bec2c6"

        Rectangle {
            id: playedPart
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            radius: body.radius

            width: root.position * body.width

            color: "#858789"
        }
    }
    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: body.width
            height: body.height
            radius: body.radius
            visible: false
        }
    }
}
