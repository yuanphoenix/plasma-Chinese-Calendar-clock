import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import "../js/lunar.js" as Lunar
import "../js/holidays.js" as Holidays

// 纯视觉组件（不依赖 plasmoid），可单独渲染测试
Item {
    id: view

    property bool showTodayCard: true
    property bool showFestivals: true
    property bool showTerms: true
    property bool showGanzhi: true
    property bool showHolidayMarks: true
    property int contentMargins: Kirigami.Units.largeSpacing

    readonly property var today: Lunar.todayInfo()
    property int viewYear: today.solarYear
    property int viewMonth: today.solarMonth

    property var termMap: ({})

    function rebuildTermMap() {
        var m = {}
        for (var y = viewYear - 1; y <= viewYear + 1; y++) {
            m[y] = Lunar.solarTermsOfYear(y)
        }
        termMap = m
    }

    function goMonth(delta) {
        var y = viewYear, mo = viewMonth + delta
        if (mo < 1) { mo = 12; y -= 1 }
        if (mo > 12) { mo = 1; y += 1 }
        viewYear = y
        viewMonth = mo
        rebuildTermMap()
    }

    function goToday() {
        viewYear = today.solarYear
        viewMonth = today.solarMonth
        rebuildTermMap()
    }

    Component.onCompleted: rebuildTermMap()

    readonly property var cells: Lunar.monthGrid(viewYear, viewMonth, termMap)

    readonly property int cellW: Kirigami.Units.gridUnit * 3.0
    readonly property int cellH: Kirigami.Units.gridUnit * (showTodayCard ? 2.7 : 3.1)

    implicitWidth: Kirigami.Units.gridUnit * 23
    implicitHeight: mainColumn.implicitHeight + view.contentMargins * 2

    ColumnLayout {
        id: mainColumn
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: view.contentMargins
        }
        spacing: Kirigami.Units.smallSpacing

        // ===== 今天 / 农历 / 干支 卡片 =====
        Rectangle {
            Layout.fillWidth: true
            visible: view.showTodayCard
            implicitHeight: todayCol.implicitHeight + Kirigami.Units.largeSpacing * 1.6
            radius: Kirigami.Units.largeSpacing
            color: Qt.rgba(Kirigami.Theme.highlightColor.r, Kirigami.Theme.highlightColor.g,
                           Kirigami.Theme.highlightColor.b, 0.13)

            ColumnLayout {
                id: todayCol
                anchors.centerIn: parent
                spacing: 0

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Kirigami.Units.largeSpacing

                    QQC2.Label {
                        text: view.today.solarDay
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2.4
                        font.bold: true
                        color: Kirigami.Theme.highlightColor
                    }
                    ColumnLayout {
                        spacing: 0
                        QQC2.Label {
                            text: view.today.solarYear + "年" + view.today.solarMonth
                                  + "月" + view.today.solarDay + "日 "
                                  + ["周日", "周一", "周二", "周三", "周四", "周五", "周六"][view.today.weekday]
                            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.72
                            color: Kirigami.Theme.disabledTextColor
                        }
                        QQC2.Label {
                            text: view.today.chinese
                            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.1
                            font.bold: true
                            color: Kirigami.Theme.textColor
                        }
                        QQC2.Label {
                            visible: view.showGanzhi
                            text: view.today.ganzhi + "年 · 属" + view.today.zodiac
                                 + (view.today.termToday !== "" ? " · " + view.today.termToday : "")
                            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.78
                            color: Kirigami.Theme.disabledTextColor
                        }
                    }
                }
            }
        }

        // ===== 月份导航 =====
        RowLayout {
            Layout.fillWidth: true
            spacing: 0

            QQC2.ToolButton {
                text: "‹"
                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.3
                onClicked: view.goMonth(-1)
            }
            QQC2.Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: view.viewYear + "年 " + view.viewMonth + "月"
                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.05
                font.bold: true
                color: Kirigami.Theme.textColor
            }
            QQC2.ToolButton {
                text: "今"
                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.8
                visible: !(view.viewYear === view.today.solarYear
                           && view.viewMonth === view.today.solarMonth)
                onClicked: view.goToday()
            }
            QQC2.ToolButton {
                text: "›"
                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.3
                onClicked: view.goMonth(1)
            }
        }

        // ===== 星期行 =====
        RowLayout {
            Layout.fillWidth: true
            spacing: 0
            Repeater {
                model: ["一", "二", "三", "四", "五", "六", "日"]
                QQC2.Label {
                    required property int index
                    required property string modelData
                    Layout.preferredWidth: view.cellW
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.78
                    font.bold: true
                    color: (index >= 5) ? Kirigami.Theme.negativeTextColor
                                        : Kirigami.Theme.disabledTextColor
                }
            }
        }

        // ===== 日期网格 =====
        Grid {
            Layout.fillWidth: true
            columns: 7
            spacing: 0

            Repeater {
                model: view.cells

                Item {
                    id: cellItem
                    required property var modelData

                    // 国务院放假安排
                    readonly property var hol: Holidays.lookup(modelData.y, modelData.m, modelData.d)
                    readonly property var prevHol: {
                        var p = Lunar.prevDate(modelData.y, modelData.m, modelData.d)
                        return Holidays.lookup(p.y, p.m, p.d)
                    }
                    readonly property bool isHoliday: view.showHolidayMarks && hol.status === "holiday"
                    readonly property bool isMakeupWork: view.showHolidayMarks && hol.status === "workday"
                    // 节日名只在连休第一天显示，其余日子仍显示农历日
                    readonly property bool showHolidayName: isHoliday && hol.name !== ""
                                                           && !(prevHol.status === "holiday"
                                                                && prevHol.name === hol.name)
                    readonly property string label: showHolidayName ? hol.name : modelData.main

                    width: view.cellW
                    height: view.cellH

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Kirigami.Units.smallSpacing / 2
                        radius: Kirigami.Units.smallSpacing
                        color: cellItem.modelData.isToday
                               ? Kirigami.Theme.highlightColor
                               : (mouse.containsMouse ? Qt.rgba(Kirigami.Theme.textColor.r,
                                                          Kirigami.Theme.textColor.g,
                                                          Kirigami.Theme.textColor.b, 0.08)
                                                      : "transparent")

                        // 休 / 班 角标
                        QQC2.Label {
                            anchors {
                                top: parent.top
                                right: parent.right
                                topMargin: 2
                                rightMargin: 3
                            }
                            visible: cellItem.isHoliday || cellItem.isMakeupWork
                            text: cellItem.isMakeupWork ? "班" : "休"
                            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.55
                            font.bold: true
                            color: cellItem.modelData.isToday
                                   ? Kirigami.Theme.highlightedTextColor
                                   : (cellItem.isMakeupWork ? Kirigami.Theme.negativeTextColor
                                                            : Kirigami.Theme.positiveTextColor)
                            opacity: cellItem.modelData.inMonth ? 1.0 : 0.4
                        }

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: -Kirigami.Units.smallSpacing / 2

                            QQC2.Label {
                                Layout.alignment: Qt.AlignHCenter
                                text: cellItem.modelData.d
                                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.05
                                font.bold: cellItem.modelData.isToday
                                           || cellItem.modelData.lunarDay === 1
                                color: cellItem.modelData.isToday
                                       ? Kirigami.Theme.highlightedTextColor
                                       : (cellItem.modelData.weekday >= 5
                                          ? Kirigami.Theme.negativeTextColor
                                          : Kirigami.Theme.textColor)
                                opacity: cellItem.modelData.inMonth ? 1.0 : 0.4
                            }
                            QQC2.Label {
                                Layout.alignment: Qt.AlignHCenter
                                Layout.maximumWidth: view.cellW - Kirigami.Units.smallSpacing
                                text: cellItem.label
                                elide: Text.ElideRight
                                horizontalAlignment: Text.AlignHCenter
                                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.72
                                font.bold: cellItem.showHolidayName
                                           || cellItem.modelData.festival !== ""
                                           || cellItem.modelData.term !== ""
                                           || cellItem.modelData.lunarDay === 1
                                color: cellItem.modelData.isToday
                                       ? Kirigami.Theme.highlightedTextColor
                                       : ((cellItem.showHolidayName
                                           || cellItem.modelData.festival !== ""
                                           || cellItem.modelData.term !== "")
                                          ? Kirigami.Theme.highlightColor
                                          : Qt.rgba(Kirigami.Theme.textColor.r,
                                                    Kirigami.Theme.textColor.g,
                                                    Kirigami.Theme.textColor.b, 0.62))
                                opacity: cellItem.modelData.inMonth ? 1.0 : 0.4
                            }
                        }
                    }

                    MouseArea {
                        id: mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton
                        onClicked: {
                            view.viewYear = cellItem.modelData.y
                            view.viewMonth = cellItem.modelData.m
                            view.rebuildTermMap()
                        }
                    }

                    QQC2.ToolTip.visible: mouse.containsMouse
                    QQC2.ToolTip.delay: 400
                    QQC2.ToolTip.text: {
                        var c = cellItem.modelData
                        var s = c.y + "年" + c.m + "月" + c.d + "日 · 农历" + c.chinese
                        if (cellItem.hol.status === "holiday") {
                            s += " · 放假" + (cellItem.hol.name !== "" ? "（" + cellItem.hol.name + "）" : "")
                        } else if (cellItem.hol.status === "workday") {
                            s += " · 调休上班" + (cellItem.hol.name !== "" ? "（" + cellItem.hol.name + "）" : "")
                        }
                        if (c.term !== "") s += " · " + c.term
                        if (c.festival !== "") s += " · " + c.festival
                        return s
                    }
                }
            }
        }
    }
}
