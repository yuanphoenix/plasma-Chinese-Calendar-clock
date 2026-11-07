import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import "../js/lunar.js" as Lunar
import "../js/holidays.js" as Holidays

/*
 * 农历时钟 —— 放在面板上显示时间，悬停看农历，点击展开月历。
 *
 * 数据来源：
 *   农历换算 / 二十四节气：contents/js/lunar.js（内置 1900–2099 表 + 天文算法）
 *   法定节假日与调休：contents/js/holidays.js（由 scripts/gen-holidays.py 生成）
 */
PlasmoidItem {
    id: root

    // 每秒刷新，保证走时准
    property var now: new Date()

    readonly property var today: Lunar.todayInfo()
    readonly property var todayHoliday: Holidays.lookup(now.getFullYear(),
                                                       now.getMonth() + 1,
                                                       now.getDate())

    readonly property bool withSeconds: Plasmoid.configuration.showSeconds

    function pad2(n) {
        return n < 10 ? "0" + n : "" + n
    }

    function timeText(d, secs) {
        var s = pad2(d.getHours()) + ":" + pad2(d.getMinutes())
        if (secs) {
            s += ":" + pad2(d.getSeconds())
        }
        return s
    }

    function weekdayName(d) {
        return ["周日", "周一", "周二", "周三", "周四", "周五", "周六"][d.getDay()]
    }

    // 休 / 班
    readonly property string holidayBadge: {
        if (todayHoliday.status === "holiday") {
            return todayHoliday.name !== "" ? "休 · " + todayHoliday.name : "休"
        }
        if (todayHoliday.status === "workday") {
            return todayHoliday.name !== "" ? "班 · " + todayHoliday.name : "班"
        }
        return ""
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    // ===== 悬停提示：农历 =====
    toolTipMainText: "农历 " + today.chinese
    toolTipSubText: now.getFullYear() + "年" + (now.getMonth() + 1) + "月" + now.getDate() + "日 "
                    + weekdayName(now)
                    + (Plasmoid.configuration.showGanzhi ? "　" + today.ganzhi + "年 · 属" + today.zodiac : "")
                    + (today.termToday !== "" ? "　" + today.termToday : "")
                    + (holidayBadge !== "" ? "　" + holidayBadge : "")

    // ===== 面板：只显示时间（第二行可配置） =====
    compactRepresentation: Item {
        implicitWidth: compactClock.implicitWidth + Kirigami.Units.smallSpacing
        implicitHeight: Math.max(compactClock.implicitHeight, Kirigami.Units.gridUnit * 1.6)

        ClockCompact {
            id: compactClock
            anchors.centerIn: parent
            timeText: root.timeText(root.now, root.withSeconds)
            subLineMode: Plasmoid.configuration.panelSubLine
            subText: {
                if (Plasmoid.configuration.panelSubLine === "lunar") {
                    return root.today.main
                }
                if (Plasmoid.configuration.panelSubLine === "solar") {
                    return (root.now.getMonth() + 1) + "月" + root.now.getDate() + "日"
                }
                return ""
            }
        }
    }

    // ===== 点击展开：时间 + 月历 =====
    fullRepresentation: Item {
        id: fullRoot
        implicitWidth: calendar.implicitWidth
        implicitHeight: fullColumn.implicitHeight + Kirigami.Units.largeSpacing

        ColumnLayout {
            id: fullColumn
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                leftMargin: calendar.contentMargins
                rightMargin: calendar.contentMargins
                topMargin: Kirigami.Units.largeSpacing
            }
            spacing: Kirigami.Units.smallSpacing

            ClockHeader {
                Layout.fillWidth: true
                timeText: root.timeText(root.now, root.withSeconds)
                dateText: root.now.getFullYear() + "年" + (root.now.getMonth() + 1)
                          + "月" + root.now.getDate() + "日 " + root.weekdayName(root.now)
                lunarText: root.today.chinese
                           + (Plasmoid.configuration.showGanzhi
                              ? "　" + root.today.ganzhi + "年" : "")
                extraText: {
                    var parts = []
                    if (root.today.termToday !== "") {
                        parts.push(root.today.termToday)
                    }
                    if (root.holidayBadge !== "") {
                        parts.push(root.holidayBadge)
                    }
                    return parts.join("　")
                }
                extraIsWarning: root.todayHoliday.status === "workday"
            }

            CalendarView {
                id: calendar
                Layout.fillWidth: true
                showTodayCard: false
                contentMargins: 0
                showFestivals: Plasmoid.configuration.showFestivals
                showTerms: Plasmoid.configuration.showTerms
                showGanzhi: Plasmoid.configuration.showGanzhi
                showHolidayMarks: Plasmoid.configuration.showHolidayMarks
            }
        }
    }
}
