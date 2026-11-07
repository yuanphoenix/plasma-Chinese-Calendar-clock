import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

// 展开面板顶部：大号时间 + 右侧日期/农历/节气/休班
RowLayout {
    id: header

    property string timeText: ""
    property string dateText: ""
    property string lunarText: ""
    property string extraText: ""
    property bool extraIsWarning: false
    property real timeScale: 2.2

    spacing: Kirigami.Units.smallSpacing

    QQC2.Label {
        Layout.alignment: Qt.AlignVCenter
        text: header.timeText
        font.pointSize: Kirigami.Theme.defaultFont.pointSize * header.timeScale
        font.bold: true
        color: Kirigami.Theme.textColor
    }

    Item {
        Layout.fillWidth: true
    }

    ColumnLayout {
        Layout.alignment: Qt.AlignVCenter
        spacing: 0

        QQC2.Label {
            Layout.alignment: Qt.AlignRight
            text: header.dateText
            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.8
            color: Kirigami.Theme.disabledTextColor
        }
        QQC2.Label {
            Layout.alignment: Qt.AlignRight
            text: header.lunarText
            visible: text !== ""
            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.95
            font.bold: true
            color: Kirigami.Theme.highlightColor
        }
        QQC2.Label {
            Layout.alignment: Qt.AlignRight
            text: header.extraText
            visible: text !== ""
            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.78
            color: header.extraIsWarning ? Kirigami.Theme.negativeTextColor
                                         : Kirigami.Theme.positiveTextColor
        }
    }
}
