import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

// 面板里的样子：只显示时间 + 可选第二行
RowLayout {
    id: compact

    property string timeText: ""
    property string subText: ""
    property bool showSubLine: true
    property string subLineMode: "lunar"   // lunar | solar | none
    property real timeScale: 1.15

    spacing: Kirigami.Units.smallSpacing

    QQC2.Label {
        Layout.alignment: Qt.AlignVCenter
        text: compact.timeText
        font.pointSize: Kirigami.Theme.defaultFont.pointSize * compact.timeScale
        font.weight: Font.DemiBold
        color: Kirigami.Theme.textColor
    }

    QQC2.Label {
        Layout.alignment: Qt.AlignVCenter
        visible: compact.subLineMode !== "none" && compact.subText !== ""
        text: compact.subText
        font.pointSize: Kirigami.Theme.defaultFont.pointSize * 0.7
        color: Qt.rgba(Kirigami.Theme.textColor.r, Kirigami.Theme.textColor.g,
                       Kirigami.Theme.textColor.b, 0.62)
    }
}
