#!/bin/sh
# 生成 README 用的预览图，不需要 Plasma 会话（offscreen 渲染）
set -e
cd "$(dirname "$0")/.."
mkdir -p preview
QML=${QML:-/usr/lib/qt6/bin/qml}
for f in scripts/preview-full.qml scripts/preview-holiday.qml scripts/preview-panel.qml; do
    QT_SCALE_FACTOR=2 QT_QPA_PLATFORM=offscreen "$QML" "$f" 2>&1 | grep -v -E 'QStandardPaths|GL context|QML debugging' || true
done
ls -l preview/
