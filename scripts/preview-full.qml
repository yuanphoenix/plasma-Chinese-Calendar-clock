import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import "../contents/ui"

// 渲染「点击展开」的样子，输出 preview/full.png（不需要 Plasma 会话）
Window {
    id: win
    visible: true
    color: Kirigami.Theme.backgroundColor
    width: column.implicitWidth + Kirigami.Units.largeSpacing * 2
    height: column.implicitHeight + Kirigami.Units.largeSpacing * 2

    ColumnLayout {
        id: column
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: Kirigami.Units.largeSpacing
        }
        spacing: Kirigami.Units.smallSpacing

        ClockHeader {
            Layout.fillWidth: true
            timeText: "14:32"
            dateText: "2026年11月7日 周六"
            lunarText: "九月廿九　丙午年"
            extraText: "立冬"
        }

        CalendarView {
            showTodayCard: false
            contentMargins: 0
        }
    }

    Timer {
        interval: 1500
        running: true
        onTriggered: {
            win.contentItem.grabToImage(function (result) {
                result.saveToFile("/home/tifa/code/plasma-lunar-clock/preview/full.png")
                console.log("saved preview/full.png")
                Qt.quit()
            })
        }
    }
}
