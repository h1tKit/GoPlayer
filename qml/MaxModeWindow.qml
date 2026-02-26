import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import QtQuick.Controls
import QtMultimedia
import MyCustomModule 1.0

Window {
    id: window
    width: 1200
    height: 750
    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint
    color: "transparent"

    property int duration: 215
    property int position: 87

    AudioOutput {
        id: audioOutput
        volume: volumeSlider.position
    }

    MediaPlayer {
        id: player
        audioOutput: audioOutput
        source: DebugExeDir + "/../../resource/musics/Sasha Sloan - Dancing With Your Ghost.mp3"

        onPlaybackStateChanged: {
            console.log(playbackState)
        }
        Component.onCompleted: {
            console.log(DebugExeDir)
        }
    }

    SongTagParser {
        id: songTagParser
        Component.onCompleted: {
            songTagParser.getInfoOf("../../resource/musics/Sasha Sloan - Dancing With Your Ghost.mp3")
        }
    }

    Item {
        id: dragArea
        anchors.top: body.top
        anchors.left: body.left
        anchors.right: body.right
        anchors.bottom: coverImg.top
        DragHandler {
            onActiveChanged: {
                if(active){
                    window.startSystemMove()
                }
            }
        }
    }

    Rectangle {
        id: body
        z: 0
        anchors.fill: parent
        anchors.leftMargin: 20
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
            samples: 20
            color: "#303131"
            opacity: 0.5
        }
    }

    Image {
        id: menuButton

        anchors.top: body.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: coverImg.top
        width: height

        source: "qrc:/icons/menu.svg"
        fillMode: Image.PreserveAspectCrop

        SwitchButton {
            id: menuBtn
            anchors.fill: parent
        }
    }


    Item {
        id: coverImg
        z: 1
        x: 50
        y: 50
        width: 400
        height: 400

        Image {
            id: coverImage
            anchors.fill: parent

            source: "image://audioCovers/" + "../../resource/musics/Sasha Sloan - Dancing With Your Ghost.mp3"
            fillMode: Image.PreserveAspectCrop

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: 400
                    height: 400
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
        anchors.left: coverImg.left
        anchors.leftMargin: 3
        anchors.top: coverShadow.bottom
        anchors.topMargin: 5

        Component.onCompleted: {
            text = Qt.binding(function(){return songTagParser.title})
        }

        font.family: "Segoe UI Semibold"
        font.pointSize: 20
        color: "#777a7c"
        wrapMode: Text.Wrap
    }

    Text {
        id: artist
        anchors.left: coverImg.left
        anchors.leftMargin: 3
        anchors.top: title.bottom
        anchors.topMargin: 6

        Component.onCompleted: {
            text = Qt.binding(function(){return songTagParser.artist})
        }

        font.family: "Segoe UI Semilight"
        font.pointSize: 18
        color: "#8f9294"
        wrapMode: Text.Wrap
    }

    Text {
        id: album
        anchors.left: artist.right
        anchors.top: title.bottom
        anchors.topMargin: 6

        Component.onCompleted: {
            text = Qt.binding(function(){return " - "+songTagParser.album})
        }

        font.family: "Segoe UI Semilight"
        font.pointSize: 18
        color: "#8f9294"
        wrapMode: Text.Wrap
    }

    PlayingSlider {
        id: playingSlider
        anchors.top: artist.bottom
        anchors.topMargin: 12

        anchors.left: coverImg.left
        anchors.leftMargin: 4
        anchors.right: coverImg.right
        anchors.rightMargin: 4

        height: 6

        from: 0
        to: player.duration

        value: player.position

        onIsDraggingChanged: {
            if(isDragging){
            }else{// 结束拖动进度条，执行进度跳转
                player.position = playingSlider.value
            }
        }

        Connections {
            target: player
            function onPositionChanged() {
                if (!(playingSlider.isDragging)) {
                    playingSlider.value = player.position
                    //console.log("非拖动时同步")
                }else {
                    //console.log("拖动时不做处理")
                }
            }
        }
    }

    // 毫秒转分秒字符串(mm:ss)
    function formatMsToMinSec(ms) {
        // 1. 输入校验：如果不是数字/负数/NaN，默认返回00:00
        if (typeof ms !== 'number' || isNaN(ms) || ms < 0) {
            return "00:00";
        }
        // 2. 毫秒转总秒数（向下取整，避免小数）
        const totalSeconds = Math.floor(ms / 1000);
        // 3. 计算分钟和秒（均取整数）
        const minutes = Math.floor(totalSeconds / 60);
        const seconds = totalSeconds % 60;
        // 4. 补零处理：确保分钟/秒都是两位数（不足则前面补0）
        const twoDigitMinutes = minutes.toString().padStart(2, '0');
        const twoDigitSeconds = seconds.toString().padStart(2, '0');
        // 5. 返回最终格式的字符串
        return `${twoDigitMinutes}:${twoDigitSeconds}`;
    }

    Text {
        id: duration
        anchors.right: playingSlider.right
        anchors.top: playingSlider.bottom
        anchors.topMargin: 8

        text: formatMsToMinSec(player.duration)

        font.family: "Segoe UI Semibold"
        font.pointSize: 10
        color: "#8f9294"
        wrapMode: Text.Wrap
    }

    Text {
        id: position
        anchors.left: playingSlider.left
        anchors.top: playingSlider.bottom
        anchors.topMargin: 8

        text: formatMsToMinSec(playingSlider.value)

        font.family: "Segoe UI Semibold"
        font.pointSize: 10
        color: "#8f9294"
        wrapMode: Text.Wrap
    }

    Image {
        id: likeButton
        anchors.right: coverImg.right
        anchors.rightMargin: 5
        anchors.top: coverShadow.bottom
        anchors.topMargin: 10
        width: 30
        height: 30

        fillMode: Image.PreserveAspectCrop

        source: "qrc:/icons/like_n.svg"

        SwitchButton {
            id: likeButtonSwitch
            anchors.fill: parent

            property int stateNum: 0

            onIsTapped: {
                stateNum = stateNum === 0 ? 1 : 0
            }
            onStateNumChanged: {
                if(stateNum === 0){
                    likeButton.source = "qrc:/icons/like_n.svg"
                }else {
                    likeButton.source = "qrc:/icons/like_y.svg"
                }
            }
        }
    }

    Image {
        id: lastButton
        anchors.right: playButton.left
        anchors.rightMargin: 30
        anchors.verticalCenter: playButton.verticalCenter
        width: 32
        height: 32

        fillMode: Image.PreserveAspectCrop

        source: "qrc:/icons/last.svg"

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 10
            radius: 15.0
            samples: 17
            color: "#bec2c6"
        }
    }

    Image {
        id: nextButton
        anchors.left: playButton.right
        anchors.leftMargin: 30
        anchors.verticalCenter: playButton.verticalCenter
        width: 32
        height: 32

        fillMode: Image.PreserveAspectCrop

        source: "qrc:/icons/last.svg"

        rotation: 180

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 10
            radius: 15.0
            samples: 17
            color: "#bec2c6"
        }
    }

    Image {
        id: playButton
        anchors.horizontalCenter: coverImg.horizontalCenter
        anchors.top: playingSlider.bottom
        anchors.topMargin: 20
        width: 50
        height: 50

        fillMode: Image.PreserveAspectCrop

        source: "qrc:/icons/play_max.svg"

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

            onIsTapped: {
                if(player.playbackState === MediaPlayer.PlayingState){
                    player.pause()
                    playButton.source = "qrc:/icons/play_max.svg"
                }else if(player.playbackState === MediaPlayer.PausedState){
                    player.play()
                    playButton.source = "qrc:/icons/pause_max.svg"
                }else { // 播放完毕一首歌
                    player.play()
                    playButton.source = "qrc:/icons/pause_max.svg"
                }
            }

            Connections {
                target: player
                function onPlaybackStateChanged(){
                    if(player.playbackState === MediaPlayer.StoppedState){  // 播放完毕一首歌
                        playButton.source = "qrc:/icons/play_max.svg"
                    }
                }
            }
        }
    }

    Image {
        id: volumeImg
        anchors.verticalCenter: volumeSlider.verticalCenter
        anchors.left: coverImg.left
        anchors.leftMargin: 4
        width: 16
        height: 16

        fillMode: Image.PreserveAspectCrop

        source:  "qrc:/icons/volume_low.svg"
    }

    PlayingSlider {
        id: volumeSlider
        anchors.top: playButton.bottom
        anchors.topMargin: 12

        anchors.left: volumeImg.right
        anchors.leftMargin: 4
        anchors.right: coverImg.right
        anchors.rightMargin: 4

        height: 6

        from: 0
        to: 100
    }

    Item {
        id: rightArea
        anchors.top: coverImg.top
        anchors.left: coverImg.right
        anchors.leftMargin: 20
        anchors.bottom: body.bottom
        anchors.bottomMargin: 20
        anchors.right: body.right
        anchors.rightMargin: 20

        Rectangle {
            anchors.fill: parent
            radius: 15
            color: "white"
        }

        SongListView {
            id: songlistView
            anchors.fill: parent
            anchors.margins: 20

            onCurrentSongFilePathChanged: {
                console.log("window received : " + currentSongFilePath)
            }
        }
    }

}
