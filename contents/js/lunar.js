.pragma library

// ===== 农历/节气 计算库（纯函数，无外部依赖）=====
// 农历数据表：1900–2099（与 lunardate/经典 lunarInfo 一致）
var lunarInfo = [
     0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950,
     0x16554, 0x056a0, 0x09ad0, 0x055d2, 0x04ae0, 0x0a5b6,
     0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2,
     0x095b0, 0x14977, 0x04970, 0x0a4b0, 0x0b4b5, 0x06a50,
     0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970,
     0x06566, 0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0, 0x02b60,
     0x186e3, 0x092e0, 0x1c8d7, 0x0c950, 0x0d4a0, 0x1d8a6,
     0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2,
     0x0a950, 0x0b557, 0x06ca0, 0x0b550, 0x15355, 0x04da0,
     0x0a5b0, 0x14573, 0x052b0, 0x0a9a8, 0x0e950, 0x06aa0,
     0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260,
     0x0f263, 0x0d950, 0x05b57, 0x056a0, 0x096d0, 0x04dd5,
     0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540,
     0x0b6a0, 0x195a6, 0x095b0, 0x049b0, 0x0a974, 0x0a4b0,
     0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570,
     0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58,
     0x05ac0, 0x0ab60, 0x096d5, 0x092e0, 0x0c960, 0x0d954,
     0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0,
     0x092d0, 0x0cab5, 0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50,
     0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930,
     0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6,
     0x0a4e0, 0x0d260, 0x0ea65, 0x0d530, 0x05aa0, 0x076a3,
     0x096d0, 0x04afb, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250,
     0x0d520, 0x0dd45, 0x0b5a0, 0x056d0, 0x055b2, 0x049b0,
     0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0,
     0x14b63, 0x09370, 0x049f8, 0x04970, 0x064b0, 0x168a6,
     0x0ea50, 0x06b20, 0x1a6c4, 0x0aae0, 0x0a2e0, 0x0d2e3,
     0x0c960, 0x0d557, 0x0d4a0, 0x0da50, 0x05d55, 0x056a0,
     0x0a6d0, 0x055d4, 0x052d0, 0x0a9b8, 0x0a950, 0x0b4a0,
     0x0b6a6, 0x0ad50, 0x055a0, 0x0aba4, 0x0a5b0, 0x052b0,
     0x0b273, 0x06930, 0x07337, 0x06aa0, 0x0ad50, 0x14b55,
     0x04b60, 0x0a570, 0x054e4, 0x0d160, 0x0e968, 0x0d520,
     0x0daa0, 0x16aa6, 0x056d0, 0x04ae0, 0x0a9d4, 0x0a2d0,
     0x0d150, 0x0f252, 0x0d520
]

var lunarMonthNames = ["正", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二"]
var lunarDayNames = ["初一","初二","初三","初四","初五","初六","初七","初八","初九","初十",
                     "十一","十二","十三","十四","十五","十六","十七","十八","十九","二十",
                     "廿一","廿二","廿三","廿四","廿五","廿六","廿七","廿八","廿九","三十"]
var ganNames = ["甲","乙","丙","丁","戊","己","庚","辛","壬","癸"]
var zhiNames = ["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"]
var zodiacNames = ["鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪"]

// 某农历年闰哪个月，0 表示无闰月
function leapMonth(y) {
    return lunarInfo[y - 1900] & 0xf
}

// 闰月天数
function leapDays(y) {
    if (leapMonth(y)) {
        return (lunarInfo[y - 1900] & 0x10000) ? 30 : 29
    }
    return 0
}

// 某农历年 y 年 m 月（1-12）的天数
function monthDays(y, m) {
    return (lunarInfo[y - 1900] & (0x10000 >> m)) ? 30 : 29
}

// 农历某年的总天数
function lYearDays(y) {
    var i, sum = 348
    for (i = 0x8000; i > 0x8; i >>= 1) {
        sum += (lunarInfo[y - 1900] & i) ? 1 : 0
    }
    return sum + leapDays(y)
}

function utcDays(y, m, d) {
    return Math.floor(Date.UTC(y, m - 1, d) / 86400000)
}

// 前一天（用于判断是否为连休首日）
function prevDate(y, m, d) {
    var dt = new Date(Date.UTC(y, m - 1, d) - 86400000)
    return { y: dt.getUTCFullYear(), m: dt.getUTCMonth() + 1, d: dt.getUTCDate() }
}

// 公历 -> 农历。返回 {year, month, day, isLeap, monthDays, leapMonth}
function lunarMonthsOf(y) {
    var list = []
    var leap = leapMonth(y)
    for (var m = 1; m <= 12; m++) {
        list.push({ month: m, isLeap: false, days: monthDays(y, m) })
        if (leap === m) {
            list.push({ month: m, isLeap: true, days: leapDays(y) })
        }
    }
    return list
}

function solarToLunar(y, m, d) {
    if (y < 1900 || y > 2099) {
        return null
    }
    var offset = utcDays(y, m, d) - utcDays(1900, 1, 31)
    var lYear = 1900
    var yearDays = lYearDays(lYear)
    while (offset >= yearDays && lYear < 2099) {
        offset -= yearDays
        lYear += 1
        yearDays = lYearDays(lYear)
    }
    var months = lunarMonthsOf(lYear)
    for (var i = 0; i < months.length; i++) {
        if (offset < months[i].days) {
            return {
                year: lYear,
                month: months[i].month,
                day: offset + 1,
                isLeap: months[i].isLeap,
                monthDays: months[i].days,
                leapMonth: leapMonth(lYear)
            }
        }
        offset -= months[i].days
    }
    return null
}

function lunarMonthName(l) {
    return "闰" + lunarMonthNames[l.month - 1] + "月"
}

function lunarDayName(day) {
    return lunarDayNames[day - 1]
}

// 农历日 -> 日历里显示的短名：初一显示月名，其余显示日名
function lunarDayLabel(l) {
    if (l.day === 1) {
        return (l.isLeap ? "闰" : "") + lunarMonthNames[l.month - 1] + "月"
    }
    return lunarDayNames[l.day - 1]
}

function ganzhiYear(lunarYear) {
    var idx = (lunarYear - 4) % 60
    if (idx < 0) idx += 60
    return ganNames[idx % 10] + zhiNames[idx % 12]
}

function zodiac(lunarYear) {
    var idx = (lunarYear - 4) % 12
    if (idx < 0) idx += 12
    return zodiacNames[idx]
}

// ===== 二十四节气 =====
var termNames = ["小寒","大寒","立春","雨水","惊蛰","春分","清明","谷雨",
                 "立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑",
                 "白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至"]

// 太阳视黄经（度），Meeus 低精度公式，误差 <0.01°
function solarLongitude(jd) {
    var T = (jd - 2451545.0) / 36525.0
    var L0 = 280.46646 + 36000.76983 * T + 0.0003032 * T * T
    var M = 357.52911 + 35999.05029 * T - 0.0001537 * T * T
    var rad = Math.PI / 180.0
    var Mr = M * rad
    var C = (1.914602 - 0.004817 * T - 0.000014 * T * T) * Math.sin(Mr)
          + (0.019993 - 0.000101 * T) * Math.sin(2 * Mr)
          + 0.000289 * Math.sin(3 * Mr)
    var trueLong = L0 + C
    var omega = (125.04 - 1934.136 * T) * rad
    var lambda = trueLong - 0.00569 - 0.00478 * Math.sin(omega)
    lambda = lambda % 360
    if (lambda < 0) lambda += 360
    return lambda
}

// 求某年第 i 个节气（0=小寒 ... 23=冬至）的北京日期，返回 {y,m,d}
function solarTermDate(year, i) {
    var target = (285 + i * 15) % 360
    // 初值：小寒约 1 月 5 日，之后每 15.22 天一个节气
    var jd = Date.UTC(year, 0, 1) / 86400000 + 2440587.5 + 4 + i * 15.2184
    for (var k = 0; k < 12; k++) {
        var lon = solarLongitude(jd)
        var diff = target - lon
        while (diff > 180) diff -= 360
        while (diff < -180) diff += 360
        if (Math.abs(diff) < 1e-7) break
        jd += diff / 0.9856473
    }
    // JD -> 北京时间（UTC+8）日期
    var ms = (jd - 2440587.5) * 86400000 + 8 * 3600000
    var dt = new Date(ms)
    return { y: dt.getUTCFullYear(), m: dt.getUTCMonth() + 1, d: dt.getUTCDate() }
}

// 某公历年内所有节气：返回对象 {"M-D": "立冬"}
function solarTermsOfYear(year) {
    var out = {}
    for (var i = 0; i < 24; i++) {
        var t = solarTermDate(year, i)
        if (t.y !== year) {
            continue
        }
        out[t.m + "-" + t.d] = termNames[i]
    }
    return out
}

// ===== 传统节日（农历）=====
var lunarFestivals = {
    "1-1": "春节", "1-15": "元宵", "2-2": "龙抬头",
    "5-5": "端午", "7-7": "七夕", "7-15": "中元",
    "8-15": "中秋", "9-9": "重阳", "12-8": "腊八"
}
// 除夕：腊月最后一天
function lunarFestivalOf(l) {
    var key = l.month + "-" + l.day
    if (lunarFestivals[key]) {
        return lunarFestivals[key]
    }
    if (l.month === 12 && !l.isLeap && l.day === l.monthDays) {
        return "除夕"
    }
    return ""
}

// 公历节日
var solarFestivals = {
    "1-1": "元旦", "3-8": "妇女节", "5-1": "劳动节", "5-4": "青年节",
    "6-1": "儿童节", "7-1": "建党节", "8-1": "建军节", "9-10": "教师节",
    "10-1": "国庆节"
}

// 汇总某天要显示的标签（优先：节气 > 农历节日 > 公历节日 > 农历日）
function dayLabels(y, m, d, terms, opts) {
    opts = opts || {}
    var l = solarToLunar(y, m, d)
    if (!l) {
        return { main: "", lunar: "", term: "", festival: "" }
    }
    var term = terms[(m + "-" + d)] || ""
    var fest = lunarFestivalOf(l)
    var showFest = opts.showFestivals !== false
    var showTerm = opts.showTerms !== false
    var main = ""
    if (showFest && fest) {
        main = fest
    } else if (showTerm && term) {
        main = term
    } else {
        main = lunarDayLabel(l)
    }
    return {
        main: main,
        lunar: lunarDayLabel(l),
        lunarMonth: l.month,
        lunarDay: l.day,
        isLeap: l.isLeap,
        term: term,
        festival: fest,
        chinese: (l.isLeap ? "闰" : "") + lunarMonthNames[l.month - 1] + "月" + lunarDayNames[l.day - 1]
    }
}

// 今天（本地时区）的完整信息
function todayInfo() {
    var now = new Date()
    var y = now.getFullYear(), m = now.getMonth() + 1, d = now.getDate()
    var terms = solarTermsOfYear(y)
    var l = solarToLunar(y, m, d)
    var info = dayLabels(y, m, d, terms)
    info.solarYear = y
    info.solarMonth = m
    info.solarDay = d
    info.weekday = now.getDay()
    info.ganzhi = l ? ganzhiYear(l.year) : ""
    info.zodiac = l ? zodiac(l.year) : ""
    info.termToday = terms[(m + "-" + d)] || ""
    return info
}

// 某月的日期网格（周一起始），返回 6*7 个 {y,m,d,inMonth,isToday,...}
function monthGrid(year, month, termMap) {
    var first = new Date(Date.UTC(year, month - 1, 1))
    var startDow = (first.getUTCDay() + 6) % 7  // 周一=0
    var daysInMonth = new Date(Date.UTC(year, month, 0)).getUTCDate()
    var today = new Date()
    var ty = today.getFullYear(), tm = today.getMonth() + 1, td = today.getDate()
    var cells = []
    var startMs = Date.UTC(year, month - 1, 1) - startDow * 86400000
    for (var i = 0; i < 42; i++) {
        var dt = new Date(startMs + i * 86400000)
        var cy = dt.getUTCFullYear(), cm = dt.getUTCMonth() + 1, cd = dt.getUTCDate()
        var terms = termMap[cy] || {}
        var lab = dayLabels(cy, cm, cd, terms)
        cells.push({
            y: cy, m: cm, d: cd,
            inMonth: (cy === year && cm === month),
            isToday: (cy === ty && cm === tm && cd === td),
            weekday: (dt.getUTCDay() + 6) % 7,
            main: lab.main,
            lunar: lab.lunar,
            chinese: lab.chinese,
            term: lab.term,
            festival: lab.festival,
            lunarDay: lab.lunarDay
        })
    }
    return cells
}

if (typeof module !== "undefined" && module.exports) {
    module.exports = {
        solarToLunar: solarToLunar, solarTermDate: solarTermDate,
        solarTermsOfYear: solarTermsOfYear, termNames: termNames,
        dayLabels: dayLabels, lunarDayLabel: lunarDayLabel,
        ganzhiYear: ganzhiYear, zodiac: zodiac, monthGrid: monthGrid,
        prevDate: prevDate, todayInfo: todayInfo
    }
}
