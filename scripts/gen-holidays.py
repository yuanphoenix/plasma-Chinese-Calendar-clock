#!/usr/bin/env python3
"""
从 chinese-calendar（https://github.com/liriansu-opus/chinese-calendar）生成
contents/js/holidays.js —— 国务院放假安排（含调休上班日）。

用法：
    python3 scripts/gen-holidays.py              # 拉取上游最新 constants.py
    python3 scripts/gen-holidays.py --local FILE # 用本地 constants.py 离线生成

数据来源：chinese-calendar/constants.py（MIT），由国务院年度放假通知整理而来。
上游一般在每年 11 月前后随国务院公告发版，所以本脚本适合每年跑一次。
"""
import argparse
import datetime
import json
import sys
import urllib.request
from pathlib import Path

UPSTREAM = "https://raw.githubusercontent.com/liriansu-opus/chinese-calendar/master/chinese_calendar/constants.py"
ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "contents" / "js" / "holidays.js"


def load_constants(source: Path) -> dict:
    """执行 constants.py，拿到 holidays / workdays / in_lieu_days 三个字典。"""
    ns: dict = {}
    code = source.read_text(encoding="utf-8")
    exec(compile(code, str(source), "exec"), ns)
    return ns


def build(ns: dict):
    Holiday = ns["Holiday"]
    en2zh = {h.value: h.chinese for h in Holiday}

    holidays = {}
    for day, name in ns["holidays"].items():
        holidays[day] = en2zh.get(name, name)

    workdays = {}
    for day, name in ns["workdays"].items():
        workdays[day] = en2zh.get(name, name)

    in_lieu = {day: en2zh.get(name, name) for day, name in ns.get("in_lieu_days", {}).items()}
    return holidays, workdays, in_lieu


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--local", help="本地 constants.py 路径（离线生成）")
    args = ap.parse_args()

    if args.local:
        src = Path(args.local)
    else:
        src = Path("/tmp/chinese_calendar_constants.py")
        print(f"拉取上游 constants.py …")
        urllib.request.urlretrieve(UPSTREAM, src)

    ns = load_constants(src)
    holidays, workdays, in_lieu = build(ns)

    years = sorted({d.year for d in holidays} | {d.year for d in workdays})
    print(f"覆盖年份：{years[0]}–{years[-1]}（{len(years)} 年）")
    print(f"放假日 {len(holidays)} 天，调休上班日 {len(workdays)} 天，调休 {len(in_lieu)} 天")

    def key(d: datetime.date) -> str:
        return f"{d.year:04d}-{d.month:02d}-{d.day:02d}"

    lines = [
        ".pragma library",
        "",
        "// ===== 中国法定节假日与调休（国务院放假安排）=====",
        "// 本文件由 scripts/gen-holidays.py 自动生成，请勿手工修改。",
        "// 数据来源：chinese-calendar (https://github.com/liriansu-opus/chinese-calendar)，MIT License",
        f"// 覆盖年份：{years[0]}–{years[-1]}",
        "",
        "// 日期 -> 节日名（该日放假）",
        "var holidays = {",
    ]
    items = sorted(holidays.items())
    for i in range(0, len(items), 6):
        chunk = ", ".join(f'"{key(d)}": "{n}"' for d, n in items[i:i + 6])
        lines.append("    " + chunk + ("," if i + 6 < len(items) else ""))
    lines += ["}", "", "// 日期 -> 节日名（该日调休上班，原本是周末）", "var workdays = {"]
    items = sorted(workdays.items())
    for i in range(0, len(items), 6):
        chunk = ", ".join(f'"{key(d)}": "{n}"' for d, n in items[i:i + 6])
        lines.append("    " + chunk + ("," if i + 6 < len(items) else ""))
    lines += ["}", "", "// 查询：返回 {status: \"holiday\"|\"workday\"|\"\", name: \"\"}",
              "function lookup(y, m, d) {",
              "    var k = (y < 1000 ? \"0\" + y : y) + \"-\" + (m < 10 ? \"0\" + m : m) + \"-\" + (d < 10 ? \"0\" + d : d)",
              "    if (holidays.hasOwnProperty(k)) {",
              "        return { status: \"holiday\", name: holidays[k] }",
              "    }",
              "    if (workdays.hasOwnProperty(k)) {",
              "        return { status: \"workday\", name: workdays[k] }",
              "    }",
              "    return { status: \"\", name: \"\" }",
              "}", "",
              "if (typeof module !== \"undefined\" && module.exports) {",
              "    module.exports = { holidays: holidays, workdays: workdays, lookup: lookup }",
              "}", ""]

    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"已写入 {OUT.relative_to(ROOT)}（{OUT.stat().st_size / 1024:.1f} KB）")

    # 抽查：2026 / 2027 春节与调休
    for probe in [datetime.date(2026, 2, 17), datetime.date(2026, 10, 1),
                  datetime.date(2027, 2, 6), datetime.date(2027, 2, 7)]:
        h = holidays.get(probe, "")
        w = workdays.get(probe, "")
        print(f"  抽查 {probe}: {'放假 ' + h if h else ('调休上班 ' + w if w else '普通日')}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
