import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import "../contents/ui"

// 渲染有放假/调休的月份（2026年2月，春节），输出 preview/holiday.png
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
            timeText: "09:05"
            dateText: "2026年2月17日 周二"
            lunarText: "正月初一　丙午年"
            extraText: "休 · 春节"
        }

        CalendarView {
            showTodayCard: false
            contentMargins: 0
            viewYear: 2026
            viewMonth: 2
        }
    }

    Timer {
        interval: 1500
        running: true
        onTriggered: {
            win.contentItem.grabToImage(function (result) {
                result.saveToFile("/home/tifa/code/plasma-lunar-clock/preview/holiday.png")
                console.log("saved preview/holiday.png")
                Qt.quit()
            })
        }
    }
}
