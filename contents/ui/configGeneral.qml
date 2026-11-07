import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    property alias cfg_showSeconds: secondsCheck.checked
    property alias cfg_panelSubLine: subLineCombo.currentValue
    property alias cfg_showFestivals: festivalsCheck.checked
    property alias cfg_showTerms: termsCheck.checked
    property alias cfg_showGanzhi: ganzhiCheck.checked
    property alias cfg_showHolidayMarks: holidayCheck.checked

    QQC2.CheckBox {
        id: secondsCheck
        Kirigami.FormData.label: "时间："
        text: "显示秒"
    }

    QQC2.ComboBox {
        id: subLineCombo
        Kirigami.FormData.label: "面板第二行："
        textRole: "text"
        valueRole: "value"
        model: [
            { text: "农历日（廿九）", value: "lunar" },
            { text: "公历日期（11月7日）", value: "solar" },
            { text: "不显示", value: "none" }
        ]
    }

    Item {
        Kirigami.FormData.isSection: true
    }

    QQC2.CheckBox {
        id: festivalsCheck
        Kirigami.FormData.label: "月历："
        text: "显示传统节日（春节、中秋…）"
    }
    QQC2.CheckBox {
        id: termsCheck
        text: "显示二十四节气"
    }
    QQC2.CheckBox {
        id: holidayCheck
        text: "显示放假 / 调休角标（休 · 班）"
    }
    QQC2.CheckBox {
        id: ganzhiCheck
        text: "显示干支纪年（丙午年 · 属马）"
    }
}
