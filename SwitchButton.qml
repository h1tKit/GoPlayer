import QtQuick

Item {
    id: root

    property bool isHovered: false
    signal isTapped()

    TapHandler {
        onTapped: {
            root.isTapped()
            console.log("tapped")
        }
    }
    HoverHandler {
        onHoveredChanged: {
            if(hovered) {
                root.isHovered = true
                console.log("hovering")
            }else {
                root.isHovered = false
                console.log("removed")
            }
        }
    }
}
