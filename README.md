# 农历时钟（Lunar Clock）

一个 KDE Plasma 6 桌面部件：**面板上就是个数字时钟，悬停显示农历，点开是带节假日与调休的中式月历。**

它本来是为了补上 Plasma 6 的一个空缺——KDE 5 的时钟日历有「备用日历 / 中国农历」，Plasma 6 把这个功能去掉了（见 `../plasma-workspace/applets/digital-clock/configCalendar.qml`，配置页里只剩周数、首日、事件插件三项）。

| 面板（紧凑） | 点击展开 |
| --- | --- |
| ![panel](preview/panel.png) | ![full](preview/full.png) |

春节假期（休 / 班角标）：

![holiday](preview/holiday.png)

## 功能

- **面板显示时间**：`HH:mm`，可选显示秒
- **面板第二行**：农历日（廿九）/ 公历日期（11月7日）/ 不显示，三选一
- **悬停提示**：农历几月几日 + 干支 + 生肖 + 节气 + 今日放假/调休状态
- **点击展开月历**：
  - 每格公历日 + 农历日；初一显示月名（十月），闰月标「闰」
  - 二十四节气（天文算法实时计算，非查表）
  - 传统节日：春节、元宵、龙抬头、端午、七夕、中元、中秋、重阳、腊八、除夕
  - **国务院法定节假日与调休**：放假标「休」、调休上班标「班」，连休首日显示节日名（来源 chinese-calendar）
  - 今天高亮、周末红色、前后月淡显、悬停显示当日完整信息、点其他月份日期可跳月
- 配色全部取自 Plasma 主题（跟随深浅色与主色调），不硬编码颜色

## 安装

```sh
git clone <this repo> plasma-lunar-clock
cd plasma-lunar-clock
./scripts/install.sh
```

然后：右键面板 → **添加部件** → 搜索「农历时钟」→ 拖到面板上。

已经放着旧版本时，装完执行 `systemctl --user restart plasma-plasmashell` 重新加载。

手动安装也可以，把仓库里的 `metadata.json` 和 `contents/` 复制到：

```
~/.local/share/plasma/plasmoids/org.hermes.lunarcalendar/
```

## 配置

右键部件 → 配置农历时钟：

| 选项 | 说明 |
| --- | --- |
| 显示秒 | 面板时间是否带秒 |
| 面板第二行 | 农历日 / 公历日期 / 不显示 |
| 显示传统节日 | 月历里是否标春节、中秋等 |
| 显示二十四节气 | 月历里是否标立春、冬至等 |
| 显示放假/调休角标 | 是否显示「休」「班」 |
| 显示干支纪年 | 悬停与展开视图里的「丙午年 · 属马」 |

## 数据来源与精度

| 内容 | 实现 | 精度 |
| --- | --- | --- |
| 农历换算 | `contents/js/lunar.js`，内置 1900–2099 年农历表 + 逐月推算 | 1950–2099 逐日对拍 54,787 天，仅 1954 / 1978 / 2057 / 2060 四个有争议年与部分库不一致；1979–2049 随机 400 天与 Debian `lunar` 程序 0 差异 |
| 二十四节气 | Meeus 太阳视黄经算法（含光行差与章动修正）实时求解，不依赖查表 | 2000–2049 共 1200 个节气对拍权威程序，596/600 个「节」完全一致，4 个交节时刻距午夜不足 10 分钟的年份差一天 |
| 节假日与调休 | `contents/js/holidays.js`，由 `scripts/gen-holidays.py` 从 [liriansu-opus/chinese-calendar](https://github.com/liriansu-opus/chinese-calendar) 生成 | 覆盖 2004–2027（数据随上游更新） |

### 更新节假日数据

每年国务院公布次年安排后，上游一般 11 月发版。然后在本仓库执行：

```sh
python3 scripts/gen-holidays.py
```

脚本会拉取上游 `constants.py`，生成 `contents/js/holidays.js`，并打印覆盖年份与抽查结果。重新安装部件即可生效。

## 目录结构

```
metadata.json                 部件清单
contents/
  config/main.xml             配置项定义
  js/lunar.js                 农历 / 节气 / 干支 / 节日（纯函数，可单独测试）
  js/holidays.js              节假日与调休（脚本生成，勿手改）
  ui/main.qml                 部件入口：紧凑 = 时钟，展开 = 时钟 + 月历
  ui/ClockCompact.qml         面板里的时钟
  ui/ClockHeader.qml          展开视图顶部（时间 + 日期 + 农历）
  ui/CalendarView.qml         月历网格（可独立渲染）
  ui/configGeneral.qml        配置界面
scripts/
  gen-holidays.py             生成 holidays.js
  install.sh                  安装 / 更新到 ~/.local/share
  render-preview.sh           生成 preview/ 下的截图（offscreen 渲染，无需 Plasma 会话）
  preview-*.qml               渲染用的临时窗口
preview/                      README 截图
```

## 开发

`lunar.js` 是纯函数，可以直接用 node 测（去掉首行 `.pragma library` 后 `require`）：

```sh
sed '1d' contents/js/lunar.js > /tmp/lunar.js
node -e 'const L=require("/tmp/lunar.js"); console.log(L.solarToLunar(2026,11,7))'
```

改界面后生成预览图：

```sh
./scripts/render-preview.sh      # 需要 qml-qt6（apt install qml-qt6）
```

## 许可

本仓库代码以 **GPL-2.0-or-later** 发布，见 `LICENSE`。

`contents/js/holidays.js` 由 [chinese-calendar](https://github.com/liriansu-opus/chinese-calendar)（MIT）的数据生成，该数据的著作权归其作者所有；本仓库仅做格式转换并保留此声明。
