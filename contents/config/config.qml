import QtQuick
import org.kde.plasma.configuration

/**
 * 声明「配置农历时钟」对话框里有哪些页面。
 * source 的路径相对于 contents/ui/，所以 configGeneral.qml 直接写文件名。
 */
ConfigModel {
    ConfigCategory {
        name: "常规"
        icon: "preferences-system"
        source: "configGeneral.qml"
    }
}
