import QtQuick
import QtQuick.Window
import org.kde.kirigami as Kirigami
import "../contents/ui"

// 复刻面板真实的 28px 高度，检查两行文字是否被裁
Window {
    id: win
    visible: true
    width: 220; height: 90
    color: "#dfe6ea"

    Rectangle {
        x: 10; y: 10
        width: 96; height: 28          // 面板给部件的高度
        color: Kirigami.Theme.backgroundColor
        clip: true
        ClockCompact {
            id: c1
            anchors.centerIn: parent
            timeText: "11:24:37"
            subLineMode: "lunar"
            subText: "廿九"
            Component.onCompleted: console.log("两行内容高度:", Math.ceil(c1.implicitHeight), "宽度:", Math.ceil(c1.implicitWidth))
        }
    }
    Rectangle {
        x: 120; y: 10
        width: 96; height: 28
        color: Kirigami.Theme.backgroundColor
        clip: true
        ClockCompact {
            anchors.centerIn: parent
            timeText: "11:24"
            subLineMode: "solar"
            subText: "11月8日"
        }
    }
    Text {
        x: 10; y: 50
        text: "左：时间带秒+农历　右：时间+公历日期（都限制在 28px 高）"
        font.pointSize: 7
        color: "#333"
    }

    Timer {
        interval: 1200; running: true
        onTriggered: {
            win.contentItem.grabToImage(function (r) {
                r.saveToFile(Qt.resolvedUrl("../preview/_clip.png").toString().replace(/^file:\/\//, ""))
                Qt.quit()
            })
        }
    }
}
