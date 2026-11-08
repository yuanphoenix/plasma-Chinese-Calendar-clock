# KDE Store 投稿资料

投稿入口：<https://store.kde.org/product/add>
分类：**KDE Plasma Extensions → Plasma 6 Applets**（或 “Plasma 6 Applets / Date and Time” 子类，按现有同类产品选）
上传文件：`dist/io.github.yuanphoenix.lunarclock-1.0.2.plasmoid`（先跑 `./scripts/build-package.sh`）
许可证：GPL-2.0-or-later
源码：https://github.com/yuanphoenix/plasma-Chinese-Calendar-clock
主页：https://github.com/yuanphoenix/plasma-Chinese-Calendar-clock

## 标题

```
农历时钟 · Lunar Clock
```

## 一句话简介（Pling 的 “Summary”）

```
Plasma 6 面板时钟：农历、节气、国务院节假日与调休
```

## 详细描述（中文）

```
一个 KDE Plasma 6 面板时钟：面板上只显示时间，悬停看农历，点开是带节假日与调休的中式月历。

补的是 Plasma 6 的空缺——KDE 5 的时钟日历有“备用日历 / 中国农历”，Plasma 6 把它删掉了。

功能
• 面板只显示时间（可选秒、可选第二行显示农历日或公历日期）
• 点击展开月历，再点收起；悬停显示农历、干支、生肖、节气、放假日状态
• 月历每格显示公历日 + 农历日，初一显示月名，闰月标“闰”
• 二十四节气按天文算法实时计算，不是查表
• 传统节日：春节、元宵、龙抬头、端午、七夕、中元、中秋、重阳、腊八、除夕
• 国务院法定节假日与调休：放假标“休”、调休上班标“班”，连休首日显示节日名
• 今天高亮、周末红色、前后月淡显、可点前后月日期跳转
• 配色全部取自 Plasma 主题，跟随深浅色与主色调

安装
系统设置 → 面板 → 添加部件 → 获取新部件，搜索“农历时钟”；
或下载 .plasmoid 后 kpackagetool6 --type Plasma/Applet --install <文件>

数据说明
农历换算覆盖 1900–2099 年，已与 lunardate / Debian lunar 逐日对拍；
节假日与调休数据来自开源项目 chinese-calendar（MIT），随国务院公告更新，每年 11 月前后发布次年安排。
```

## 详细描述（English）

```
A KDE Plasma 6 panel clock with the Chinese lunisolar calendar.

Plasma 6 removed the alternate-calendar (Chinese lunar) option that Plasma 5's clock had; this widget brings it back and adds what mainland users actually need: State Council statutory holidays and make-up workdays (调休).

Features
• Panel shows the time only (optional seconds, optional second line with lunar day or date)
• Click to expand a month grid, click again to collapse
• Hover tooltip: lunar date, sexagenary year, zodiac, solar term, holiday status
• Month grid: solar day + lunar day, month name on the 1st, leap months marked
• 24 solar terms computed astronomically (Meeus apparent solar longitude), not a lookup table
• Traditional festivals: Spring Festival, Lantern, Longtaitou, Dragon Boat, Qixi, Zhongyuan, Mid-Autumn, Double Ninth, Laba, New Year's Eve
• Statutory holidays and make-up workdays from the State Council schedule, marked 休 / 班
• Today highlighted, weekends in red, adjacent-month days dimmed and clickable
• Colors follow the Plasma theme (light/dark, accent color)

Data
Lunar conversion covers 1900–2099 and was cross-checked day by day against lunardate and the Debian `lunar` tool.
Holiday data is generated from the open-source chinese-calendar project (MIT) and refreshed each November when the State Council publishes the next year's schedule.
```

## 标签 / Tags

```
lunar calendar, chinese calendar, 农历, 节气, solar terms, holidays, 调休, clock, plasmoid, plasma 6
```
