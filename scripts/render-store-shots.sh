#!/bin/sh
# 生成 KDE Store 投稿用的高清截图（3 倍），输出到 preview/store-*.png
set -e
cd "$(dirname "$0")/.."
QML=${QML:-/usr/lib/qt6/bin/qml}
render() { # $1=已有harness名 $2=输出名 $3=scale
    sed "s|\.\./preview/$1\.png|../preview/$2.png|" "scripts/preview-$1.qml" > "scripts/_tmp_$1.qml"
    QT_SCALE_FACTOR=$3 QT_QPA_PLATFORM=offscreen "$QML" "scripts/_tmp_$1.qml" 2>&1 \
        | grep -v -E 'QStandardPaths|GL context|QML debugging' || true
    rm -f "scripts/_tmp_$1.qml"
}
render full    store-calendar 3
render holiday store-holiday  3
render panel   store-panel    4
ls -l preview/store-*.png
