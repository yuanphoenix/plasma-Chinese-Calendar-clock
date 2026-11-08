import QtQuick
import QtQuick.Window
import org.kde.kirigami as Kirigami
import "../contents/ui"

// 面板两行样式预览（时间 + 农历），输出 preview/store-panel2.png
Window {
    id: win
    visible: true
    color: "transparent"
    width: strip.width
    height: strip.height

    Rectangle {
        id: strip
        width: col.implicitWidth + Kirigami.Units.largeSpacing * 3
        height: Kirigami.Units.gridUnit * 2.2
        color: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g,
                       Kirigami.Theme.backgroundColor.b, 1)
        radius: Kirigami.Units.smallSpacing

        ClockCompact {
            id: col
            anchors.centerIn: parent
            timeText: "11:24"
            subLineMode: "lunar"
            subText: "廿九"
        }
    }

    Timer {
        interval: 1500
        running: true
        onTriggered: {
            win.contentItem.grabToImage(function (result) {
                result.saveToFile(Qt.resolvedUrl("../preview/store-panel2.png").toString().replace(/^file:\/\//, ""))
                Qt.quit()
            })
        }
    }
}
