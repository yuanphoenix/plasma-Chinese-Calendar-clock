#!/bin/sh
# 把部件安装（或更新）到当前用户的 Plasma 目录。不需要 root。
set -e
here=$(cd "$(dirname "$0")/.." && pwd)
pkg_id=$(sed -n 's/.*"Id": *"\([^"]*\)".*/\1/p' "$here/metadata.json")
[ -n "$pkg_id" ] || { echo "metadata.json 里读不到 Id"; exit 1; }
dest="${XDG_DATA_HOME:-$HOME/.local/share}/plasma/plasmoids/$pkg_id"

# 只同步部件本体（metadata.json + contents/），不把 scripts/docs/.github 带进 plasmoid 目录。
# 注意：不要对 $dest 再执行 kpackagetool6 --upgrade <同一路径>，
# kpackagetool6 会把源目录当作临时包搬走并删掉它（踩过一次）。
mkdir -p "$dest"
find "$dest" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
cp -a "$here/metadata.json" "$dest/"
cp -a "$here/contents" "$dest/"

echo "已安装到：$dest（Id: $pkg_id）"
echo "如果面板上已经放着这个部件，执行以下命令让它重新加载："
echo "  systemctl --user restart plasma-plasmashell"
echo "或者：右键面板 → 添加部件 → 搜索「农历时钟」。"
