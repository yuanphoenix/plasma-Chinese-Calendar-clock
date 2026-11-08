import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

// 面板里的样子：时间在上，可选的第二行小字在下（农历日 / 公历日期）
ColumnLayout {
    id: compact

    property string timeText: ""
    property string subText: ""
    property string subLineMode: "none"   // lunar | solar | none
    property real timeScale: 1.15

    readonly property bool hasSubLine: subLineMode !== "none" && subText !== ""

    spacing: 0

    QQC2.Label {
        Layout.alignment: Qt.AlignHCenter
        text: compact.timeText
        font.pointSize: Kirigami.Theme.defaultFont.pointSize * compact.timeScale
        font.weight: Font.DemiBold
        color: Kirigami.Theme.textColor
    }

    QQC2.Label {
        Layout.alignment: Qt.AlignHCenter
        visible: compact.hasSubLine
        text: compact.subText
        font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.66
        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g,
                       Kirigami.Theme.textColor.b, 0.66)
    }
}
