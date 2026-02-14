import QtQuick

Item {
    anchors.fill: parent

    ListView {
        anchors.fill: parent
        model: Qt.fontFamilies()
        delegate: Item {
            height: 60
            width: parent.width
            Rectangle {
                height: 45
                width: parent.width
                Text {
                    id: txtShow
                    anchors.centerIn: parent
                    color: "black"
                    text: index + " : " + modelData
                    font.family: modelData
                    //MiSans
                    //Segoe UI Semibold
                    //Segoe UI Semilight
                }
            }
        }
    }
}
