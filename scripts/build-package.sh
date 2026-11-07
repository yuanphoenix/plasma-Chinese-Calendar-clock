#!/bin/sh
# 打包成 KDE Store / 手动安装用的 .plasmoid 文件（其实是 zip）
set -e
cd "$(dirname "$0")/.."
id=$(sed -n 's/.*"Id": *"\([^"]*\)".*/\1/p' metadata.json)
ver=$(sed -n 's/.*"Version": *"\([^"]*\)".*/\1/p' metadata.json)
out="dist/${id}-${ver}.plasmoid"
mkdir -p dist
rm -f "$out"
zip -qr "$out" metadata.json contents -x '*.qmlc' '*.jsc' '*/__pycache__/*'
echo "已生成 $out（$(du -h "$out" | cut -f1)）"
