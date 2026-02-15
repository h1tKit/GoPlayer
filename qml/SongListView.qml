import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

ListView {
    id: playlistView

    property string currentSongFilePath: playlistView.currentItem.songFilePath

    width: parent.width
    height: parent.height
    spacing: 8

    ListModel {
        id: testModel

        ListElement {
            title: "Apple"
            artist: "pingguo"
            filePath: "apple.mp3"
        }
        ListElement {
            title: "Orange"
            artist: "chengzi"
            filePath: "orange.flac"
        }
        ListElement {
            title: "Banana"
            artist: "xiangjiao"
            filePath: "banana.wav"
        }
        ListElement {
            title: "Strawberry"
            artist: "caomei"
            filePath: "strawberry.mp3"
        }
        ListElement {
            title: "Grape"
            artist: "putao"
            filePath: "grape.flac"
        }
        ListElement {
            title: "Mango"
            artist: "mangguo"
            filePath: "mango.wav"
        }
        ListElement {
            title: "Peach"
            artist: "taozi"
            filePath: "peach.mp3"
        }
        ListElement {
            title: "Pear"
            artist: "lizi"
            filePath: "pear.flac"
        }
        ListElement {
            title: "Watermelon123456789"
            artist: "xigua"
            filePath: "watermelon.wav"
        }
        ListElement {
            title: "Pineapple"
            artist: "boluo"
            filePath: "pineapple.mp3"
        }
        ListElement {
            title: "Kiwi"
            artist: "migua"
            filePath: "kiwi.flac"
        }
        ListElement {
            title: "Cherry"
            artist: "yingtao"
            filePath: "cherry.wav"
        }
        ListElement {
            title: "Lychee"
            artist: "lizhi"
            filePath: "lychee.mp3"
        }
        ListElement {
            title: "Longan"
            artist: "longyan"
            filePath: "longan.flac"
        }
        ListElement {
            title: "Durian"
            artist: "liulian"
            filePath: "durian.wav"
        }
        ListElement {
            title: "Papaya"
            artist: "mugua"
            filePath: "papaya.mp3"
        }
        ListElement {
            title: "Apricot"
            artist: "xingzi"
            filePath: "apricot.flac"
        }
        ListElement {
            title: "Plum"
            artist: "meizi"
            filePath: "plum.wav"
        }
        ListElement {
            title: "Pomegranate"
            artist: "shiliu"
            filePath: "pomegranate.mp3"
        }
        ListElement {
            title: "Fig"
            artist: "wuhuaguo"
            filePath: "fig.flac"
        }
        ListElement {
            title: "Coconut"
            artist: "yeke"
            filePath: "coconut.wav"
        }
        ListElement {
            title: "Blueberry"
            artist: "lanmei"
            filePath: "blueberry.mp3"
        }
        ListElement {
            title: "Raspberry"
            artist: "shanmei"
            filePath: "raspberry.flac"
        }
        ListElement {
            title: "Blackberry"
            artist: "heimei"
            filePath: "blackberry.wav"
        }
        ListElement {
            title: "Cranberry"
            artist: "manyingtao"
            filePath: "cranberry.mp3"
        }
        ListElement {
            title: "Lemon"
            artist: "ningmeng"
            filePath: "lemon.flac"
        }
        ListElement {
            title: "Lime"
            artist: "qingningmeng"
            filePath: "lime.wav"
        }
        ListElement {
            title: "Avocado"
            artist: "houtaoguo"
            filePath: "avocado.mp3"
        }
        ListElement {
            title: "Dragonfruit"
            artist: "huolongguo"
            filePath: "dragonfruit.flac"
        }
        ListElement {
            title: "Passionfruit"
            artist: "baixiangguo"
            filePath: "passionfruit.wav"
        }
        ListElement {
            title: "Guava"
            artist: "fanshiliu"
            filePath: "guava.mp3"
        }
        ListElement {
            title: "Persimmon"
            artist: "shizi"
            filePath: "persimmon.flac"
        }
    }

    model: testModel

    clip: true // 裁剪超出视图的内容，避免无效渲染（比如列表项越界绘制）
    cacheBuffer: 200 // 缓存可视区域外的少量列表项，滚动时无卡顿
    reuseItems: true // 复用列表项，避免频繁创建/销毁Delegate
    keyNavigationEnabled: false // 无需键盘导航，关闭以减少事件监听
    focus: false // 列表无需焦点，关闭以减少资源占用
    boundsBehavior: ListView.StopAtBounds // 滚动到边界时停止，避免弹性滚动的额外计算

    // 判断列表项是否可视
    function isItemVisible(index) {
        if (index < 0 || index >= model.count) return false; // 索引越界直接返回false
        // 计算列表项的y坐标（包含cacheBuffer的偏移）
        const itemY = index * delegateHeight - contentY + cacheBuffer;
        // 可视区域范围：[-cacheBuffer, height + cacheBuffer]（包含缓存区）
        return itemY >= -cacheBuffer && itemY <= height + cacheBuffer;
    }

    property int delegateHeight: 60

    delegate: Rectangle {
        id: delegateItem
        property string songTitle: model.title // 缓存model属性，避免多次读取model，避免「重复绑定」
        property string songArtist: model.artist
        property string coverFilePath: "qrc:/img/cover2.jpg"
        property string songFilePath: model.filePath

        width: playlistView.width -12
        height: delegateHeight
        radius: 5
        //color: ListView.isCurrentItem ? "#BBBBBB" : (hoverHandler.hovered ? "#DDDDDD" : "white")
        Connections {
            target: playlistView
            function onCurrentIndexChanged() {
                // 用"无效赋值"触发绑定重计算（不覆盖绑定）
                delegateItem.color = Qt.binding(() => {
                    const isSelected = playlistView.currentIndex === index;
                    const isHovered = hoverHandler.hovered;
                    if (isSelected) return "#BBBBBB";
                    if (isHovered) return "#DDDDDD";
                    return "white";
                });
            }
        }

        Behavior on color {
            ColorAnimation { duration: 120; easing.type: Easing.Linear }
        }

        TapHandler {
            onTapped: {
                console.log("选中歌曲：", model.title, "路径：", model.filePath);
                playlistView.currentIndex = index // 选中当前项
                // 选中时立即更新颜色（不受防抖影响）
                updateItemColor();
            }
            onLongPressed: {
                console.log("长按歌曲：", model.title);
            }
        }

        HoverHandler {
            id: hoverHandler
            onHoveredChanged: hoverTimer.restart() // 触发防抖Timer
        }

        // 防抖Timer：仅hover稳定后才更新颜色（减少动画触发）
        Timer {
            id: hoverTimer
            interval: 40          // 防抖时长：鼠标停留40ms后才触发
            repeat: false
            // 防抖触发后，执行颜色更新逻辑
            onTriggered: {
                //console.log("Hover防抖生效 | index:", index, "hovered:", hoverHandler.hovered);
                updateItemColor();
            }
        }

        function updateItemColor() {
            // 优先级：选中态 > hover态 > 默认态
            if (delegateItem.ListView.isCurrentItem) {
                delegateItem.color = "#BBBBBB";
            } else if (hoverHandler.hovered) {
                delegateItem.color = "#DDDDDD";
            } else {
                delegateItem.color = "white";
            }
        }

        Loader {
            id: coverLoader
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 48
            height: 48
            // 仅当列表项在可视区域时加载图片
            active: playlistView.isItemVisible(index)

            sourceComponent: Image {
                anchors.fill: parent
                source: coverFilePath
                fillMode: Image.PreserveAspectFit
                cache: true // 开启图片缓存，避免重复加载同一图片
                asynchronous: true // 异步加载图片，不阻塞UI线程

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: 48
                        height: 48
                        radius: 5
                        visible: false
                    }
                }
                // 监听图片加载状态，输出index（测试Loader核心逻辑）
                onStatusChanged: {
                    // 加载成功
                    if (status === Image.Ready) {
                        //console.log("[Loader测试] Image加载完成 | index:", index, "| 路径:", source);
                    }
                    // 加载失败（便于排查路径问题）
                    else if (status === Image.Error) {
                        //console.log("[Loader测试] Image加载失败 | index:", index, "| 路径:", source, "| 错误:", errorString);
                    }
                }
            }
        }


        Text {
            anchors.left: coverLoader.right
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10
            width: parent.width - 80
            text: songTitle // 歌曲名
            font.pixelSize: 16
            font.bold: true
            color: "#333333"
            elide: Text.ElideRight // 文字过长时省略
            Layout.fillWidth: true
        }

        Text {
            anchors.left: coverLoader.right
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            width: parent.width - 80
            text: songArtist // 歌手
            font.pixelSize: 14
            color: "#666666"
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        // 分割线
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width - 20
            height: 1
            color: "#eeeeee"
            anchors.horizontalCenter: parent.horizontalCenter
            visible: delegateItem.ListView.isCurrentItem ? false : true
        }
    }

    // ListView空占位（叠加一个文本项，仅当model.count为0时显示）
    Text {
        text: "歌单为空，添加歌曲吧～"
        font.pixelSize: 16
        color: "#999999"
        anchors.centerIn: parent
        // 仅当列表无数据时显示
        visible: playlistView.model.count === 0
        // 层级高于列表项，确保能显示
        z: 10
    }

    // 滚动条
    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
        //background: Rectangle { color: "#f5f5f5";radius: 5}
    }
}
