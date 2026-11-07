import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import "../contents/ui"

// 渲染面板里的样子，输出 preview/panel.png（不需要 Plasma 会话）
Window {
    id: win
    visible: true
    color: "transparent"
    flags: Qt.FramelessWindowHint
    width: strip.width
    height: strip.height

    Rectangle {
        id: strip
        width: row.implicitWidth + Kirigami.Units.largeSpacing * 2
        height: Kirigami.Units.gridUnit * 2.2
        color: Qt.rgba(Kirigami.Theme.backgroundColor.r,
                       Kirigami.Theme.backgroundColor.g,
                       Kirigami.Theme.backgroundColor.b, 1)
        border.width: 1
        border.color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g,
                              Kirigami.Theme.textColor.b, 0.15)
        radius: Kirigami.Units.smallSpacing

        ClockCompact {
            id: row
            anchors.centerIn: parent
            timeText: "14:32"
            subLineMode: "none"
        }
    }

    Timer {
        interval: 1500
        running: true
        onTriggered: {
            win.contentItem.grabToImage(function (result) {
                result.saveToFile("/home/tifa/code/plasma-lunar-clock/preview/panel.png")
                console.log("saved preview/panel.png")
                Qt.quit()
            })
        }
    }
}
