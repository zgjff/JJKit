import Foundation
/// google material icon
/// https://github.com/google/material-design-icons/blob/master/iconfont/MaterialIcons-Regular.ttf6
public final class Material: Fontloadable {
    public static var url: URL {
        let bundle = Bundle(for: self)
        guard let bu = bundle.url(forResource: "JJKit", withExtension: "bundle") else {
            fatalError("bundle 不存在")
        }
        let inbundle = Bundle(url: bu)
        if let u = inbundle?.url(forResource: "MaterialIcons-Regular", withExtension: "ttf") {
            return u
        } else {
            fatalError("不存在ttf文件")
        }
    }
    public static let familyName = "Material Icons"
}

/// https://material.io/tools/icons/?style=baseline
public struct MaterialIcons: IconData {
    public typealias Font = Material
    public let codePoint: UInt16
    public init(codePoint: UInt16) {
        self.codePoint = codePoint
    }
}

// MARK: - 图标列表 https://github.com/google/material-design-icons/blob/master/iconfont/codepoints

// MARK: - Action https://github.com/google/material-design-icons/tree/master/action/ios
extension MaterialIcons {
    /// 旋转3d
    public static var rotation_3d = MaterialIcons(codePoint: 0xe84d)
    /// 无障碍
    public static var accessibility = MaterialIcons(codePoint: 0xe84e)
    /// 无障碍 轮椅
    public static var accessible = MaterialIcons(codePoint: 0xe914)
    /// 账户余额
    public static var account_balance = MaterialIcons(codePoint: 0xe84f)
    /// 钱包
    public static var account_balance_wallet = MaterialIcons(codePoint: 0xe850)
    /// 账户带框
    public static var account_box = MaterialIcons(codePoint: 0xe851)
    /// 账户圆形
    public static var account_circle = MaterialIcons(codePoint: 0xe853)
    /// 购物筐
    public static var add_shopping_cart = MaterialIcons(codePoint: 0xe854)
    /// 闹钟1
    public static var access_alarm = MaterialIcons(codePoint: 0xe190)
    /// 闹钟2
    public static var access_alarms = MaterialIcons(codePoint: 0xe191)
    /// 闹钟3
    public static var access_time = MaterialIcons(codePoint: 0xe192)
    /// 闹钟4 ➕
    public static var add_alarm = MaterialIcons(codePoint: 0xe193)
    /// 闹钟5
    public static var alarm = MaterialIcons(codePoint: 0xe855)
    /// 闹钟6 ➕
    public static var alarm_add = MaterialIcons(codePoint: 0xe856)
    /// 闹钟7 关闭
    public static var alarm_off = MaterialIcons(codePoint: 0xe857)
    /// 闹钟8 on
    public static var alarm_on = MaterialIcons(codePoint: 0xe858)
    /// 四个三角加圆
    public static var all_out = MaterialIcons(codePoint: 0xe90b)
    /// 安卓
    public static var android = MaterialIcons(codePoint: 0xe859)
    /// 公告
    public static var announcement = MaterialIcons(codePoint: 0xe85a)
    /// 宽高比
    public static var aspect_ratio = MaterialIcons(codePoint: 0xe85b)
    /// 评定
    public static var assessment = MaterialIcons(codePoint: 0xe85c)
    /// 分配
    public static var assignment = MaterialIcons(codePoint: 0xe85d)
    /// 任务
    public static var assignment_ind = MaterialIcons(codePoint: 0xe85e)
    /// 任务警告
    public static var assignment_late = MaterialIcons(codePoint: 0xe85f)
    /// 左⬅️
    public static var assignment_return = MaterialIcons(codePoint: 0xe860)
    /// 下⬇️
    public static var assignment_returned = MaterialIcons(codePoint: 0xe861)
    /// 完成✅
    public static var assignment_turned_in = MaterialIcons(codePoint: 0xe862)
    /// 星
    public static var assistant = MaterialIcons(codePoint: 0xe39f)
    /// 自动更新
    public static var autorenew = MaterialIcons(codePoint: 0xe863)
    /// 云备份
    public static var backup = MaterialIcons(codePoint: 0xe864)
    /// 书
    public static var book = MaterialIcons(codePoint: 0xe865)
    /// 书签
    public static var bookmark = MaterialIcons(codePoint: 0xe866)
    /// 书签边框
    public static var bookmark_border = MaterialIcons(codePoint: 0xe867)
    /// bug
    public static var bug_report = MaterialIcons(codePoint: 0xe868)
    /// 扳手🔧
    public static var build = MaterialIcons(codePoint: 0xe869)
    /// 缓存/刷新
    public static var cached = MaterialIcons(codePoint: 0xe86a)
    /// 相机增强
    public static var camera_enhance = MaterialIcons(codePoint: 0xe8fc)
    /// 卡礼品卡
    public static var card_giftcard = MaterialIcons(codePoint: 0xe8f6)
    /// 卡会员资格
    public static var card_membership = MaterialIcons(codePoint: 0xe8f7)
    /// 卡旅行
    public static var card_travel = MaterialIcons(codePoint: 0xe8f8)
    /// 正三角
    public static var change_history = MaterialIcons(codePoint: 0xe86b)
    /// 检查圆圈
    public static var check_circle = MaterialIcons(codePoint: 0xe86c)
    /// 读卡器
    public static var chrome_reader_mode = MaterialIcons(codePoint: 0xe86d)
    /// 标签/类
    public static var `class` = MaterialIcons(codePoint: 0xe86e)
    /// < >
    public static var code = MaterialIcons(codePoint: 0xe86f)
    /// 比较箭头 一右一左箭头
    public static var compare_arrows = MaterialIcons(codePoint: 0xe915)
    /// ©️
    public static var copyright = MaterialIcons(codePoint: 0xe90c)
    /// 信用卡
    public static var credit_card = MaterialIcons(codePoint: 0xe870)
    /// 仪表盘
    public static var dashboard = MaterialIcons(codePoint: 0xe871)
    /// 日历
    public static var date_range = MaterialIcons(codePoint: 0xe916)
    /// 垃圾篓/删除
    public static var delete = MaterialIcons(codePoint: 0xe872)
    /// 垃圾篓带x/删除
    public static var delete_forever = MaterialIcons(codePoint: 0xe92b)
    /// text文件
    public static var description = MaterialIcons(codePoint: 0xe873)
    /// dns
    public static var dns = MaterialIcons(codePoint: 0xe875)
    /// 对号/完成
    public static var done = MaterialIcons(codePoint: 0xe876)
    /// 两个对号重合
    public static var done_all = MaterialIcons(codePoint: 0xe877)
    /// 甜甜圈大
    public static var donut_large = MaterialIcons(codePoint: 0xe917)
    /// 甜甜圈小
    public static var donut_small = MaterialIcons(codePoint: 0xe918)
    /// 弹出⏏️
    public static var eject = MaterialIcons(codePoint: 0xe8fb)
    /// 欧元符号
    public static var euro_symbol = MaterialIcons(codePoint: 0xe926)
    /// 事件
    public static var event = MaterialIcons(codePoint: 0xe878)
    /// 活动座位
    public static var event_seat = MaterialIcons(codePoint: 0xe903)
    /// 退出
    public static var exit_to_app = MaterialIcons(codePoint: 0xe879)
    /// 指南针/探索
    public static var explore = MaterialIcons(codePoint: 0xe87a)
    /// 七巧板
    public static var `extension` = MaterialIcons(codePoint: 0xe87b)
    /// 人脸
    public static var face = MaterialIcons(codePoint: 0xe87c)
    /// 心-实心❤️
    public static var favorite = MaterialIcons(codePoint: 0xe87d)
    /// 心-空心
    public static var favorite_border = MaterialIcons(codePoint: 0xe87e)
    /// 反馈
    public static var feedback = MaterialIcons(codePoint: 0xe87f)
    /// 页面+放大镜
    public static var find_in_page = MaterialIcons(codePoint: 0xe880)
    /// 循环+斜杠
    public static var find_replace = MaterialIcons(codePoint: 0xe881)
    /// 指纹
    public static var fingerprint = MaterialIcons(codePoint: 0xe90d)
    /// 飞机着陆
    public static var flight_land = MaterialIcons(codePoint: 0xe904)
    /// 飞机起飞
    public static var flight_takeoff = MaterialIcons(codePoint: 0xe905)
    /// 翻转/后
    public static var flip_to_back = MaterialIcons(codePoint: 0xe882)
    /// 翻转/前
    public static var flip_to_front = MaterialIcons(codePoint: 0xe883)
    /// 谷歌翻译
    public static var g_translate = MaterialIcons(codePoint: 0xe927)
    /// 木槌
    public static var gavel = MaterialIcons(codePoint: 0xe90e)
    /// 下载中
    public static var get_app = MaterialIcons(codePoint: 0xe884)
    /// gif
    public static var gif = MaterialIcons(codePoint: 0xe908)
    /// 五角星⭐️
    public static var grade = MaterialIcons(codePoint: 0xe885)
    /// 圆圈加3个空心
    public static var group_work = MaterialIcons(codePoint: 0xe886)
    /// 实心圆+问好
    public static var help = MaterialIcons(codePoint: 0xe887)
    /// 空心圆+问好
    public static var help_outline = MaterialIcons(codePoint: 0xe8fd)
    /// 空心圆+x
    public static var highlight_off = MaterialIcons(codePoint: 0xe888)
    /// 历史记录
    public static var history = MaterialIcons(codePoint: 0xe889)
    /// 家/首页
    public static var home = MaterialIcons(codePoint: 0xe88a)
    /// 沙漏空
    public static var hourglass_empty = MaterialIcons(codePoint: 0xe88b)
    /// 沙漏满
    public static var hourglass_full = MaterialIcons(codePoint: 0xe88c)
    /// HTTP
    public static var http = MaterialIcons(codePoint: 0xe902)
    /// 锁🔒
    public static var https = MaterialIcons(codePoint: 0xe88d)
    /// 重要设备
    public static var important_devices = MaterialIcons(codePoint: 0xe912)
    /// 警告/实心圆+感叹号
    public static var info = MaterialIcons(codePoint: 0xe88e)
    /// 警告/空心圆+感叹号
    public static var info_outline = MaterialIcons(codePoint: 0xe88f)
    /// 输入
    public static var input = MaterialIcons(codePoint: 0xe890)
    /// 翻转颜色/水滴一半实心一半空心
    public static var invert_colors = MaterialIcons(codePoint: 0xe891)
    /// 标签实心
    public static var label = MaterialIcons(codePoint: 0xe892)
    /// 标签空心
    public static var label_outline = MaterialIcons(codePoint: 0xe893)
    /// 全球
    public static var language = MaterialIcons(codePoint: 0xe894)
    /// 发射
    public static var launch = MaterialIcons(codePoint: 0xe895)
    /// 灯泡/💡 空心
    public static var lightbulb_outline = MaterialIcons(codePoint: 0xe90f)
    /// 线条样式
    public static var line_style = MaterialIcons(codePoint: 0xe919)
    /// 线条/粗
    public static var line_weight = MaterialIcons(codePoint: 0xe91a)
    /// 目录
    public static var list = MaterialIcons(codePoint: 0xe896)
    /// 锁🔒实心
    public static var lock = MaterialIcons(codePoint: 0xe897)
    /// 锁/打开
    public static var lock_open = MaterialIcons(codePoint: 0xe898)
    /// 锁/空心
    public static var lock_outline = MaterialIcons(codePoint: 0xe899)
    /// 倾斜标签+空心
    public static var loyalty = MaterialIcons(codePoint: 0xe89a)
    /// 未读标记邮箱
    public static var markunread_mailbox = MaterialIcons(codePoint: 0xe89b)
    /// 摩托车
    public static var motorcycle = MaterialIcons(codePoint: 0xe91b)
    /// 标签+空心➕
    public static var note_add = MaterialIcons(codePoint: 0xe89c)
    /// 实心圆+对号+横线
    public static var offline_pin = MaterialIcons(codePoint: 0xe90a)
    /// 不透明/水滴上部空心
    public static var opacity = MaterialIcons(codePoint: 0xe91c)
    /// 打开
    public static var open_in_browser = MaterialIcons(codePoint: 0xe89d)
    /// 上下左右四个粗箭头
    public static var open_with = MaterialIcons(codePoint: 0xe89f)
    /// 实心长方形+放大镜
    public static var pageview = MaterialIcons(codePoint: 0xe8a0)
    /// 手掌🖐️实心
    public static var pan_tool = MaterialIcons(codePoint: 0xe925)
    /// 付款
    public static var payment = MaterialIcons(codePoint: 0xe8a1)
    /// 相机麦克风
    public static var perm_camera_mic = MaterialIcons(codePoint: 0xe8a2)
    /// 联系人头像
    public static var perm_contact_calendar = MaterialIcons(codePoint: 0xe8a3)
    /// 日期设置
    public static var perm_data_setting = MaterialIcons(codePoint: 0xe8a4)
    /// 长方形空心+ 感叹号
    public static var perm_device_information = MaterialIcons(codePoint: 0xe8a5)
    /// 头像空心
    public static var perm_identity = MaterialIcons(codePoint: 0xe8a6)
    /// 媒体资源
    public static var perm_media = MaterialIcons(codePoint: 0xe8a7)
    /// 电话留言
    public static var perm_phone_msg = MaterialIcons(codePoint: 0xe8a8)
    /// 无信号
    public static var perm_scan_wifi = MaterialIcons(codePoint: 0xe8a9)
    /// 动物足迹/百度符号
    public static var pets = MaterialIcons(codePoint: 0xe91d)
}
// MARK: - Alert https://github.com/google/material-design-icons/tree/master/alert/ios
extension MaterialIcons {
    /// 提醒 --- 钟/➕
    public static var add_alert = MaterialIcons(codePoint: 0xe003)
    /// 错误/实心圆+感叹号
    public static var error = MaterialIcons(codePoint: 0xe000)
    /// 错误/空心圆+感叹号
    public static var error_outline = MaterialIcons(codePoint: 0xe001)
    /// 实心三角+感叹号
    public static var warning = MaterialIcons(codePoint: 0xe002)
}
// MARK: - AV https://github.com/google/material-design-icons/tree/master/av/ios
extension MaterialIcons {
    /// ➕ 带框2
    public static var add_to_queue = MaterialIcons(codePoint: 0xe05c)
    /// 单曲
    public static var airplay = MaterialIcons(codePoint: 0xe055)
    /// 专辑💽
    public static var album = MaterialIcons(codePoint: 0xe019)
    /// 艺术轨道
    public static var art_track = MaterialIcons(codePoint: 0xe060)
    /// 计时器
    public static var av_timer = MaterialIcons(codePoint: 0xe01b)
    /// 水印？
    public static var branding_watermark = MaterialIcons(codePoint: 0xe06b)
    /// 实心长方形底部有一条横线
    public static var call_to_action = MaterialIcons(codePoint: 0xe06c)
    /// 隐藏字母
    public static var closed_caption = MaterialIcons(codePoint: 0xe01c)
    /// 均衡器-3条长短不一的竖线
    public static var equalizer = MaterialIcons(codePoint: 0xe01d)
    /// 实心正方体中+E
    public static var explicit = MaterialIcons(codePoint: 0xe01e)
    /// 快进⏩
    public static var fast_forward = MaterialIcons(codePoint: 0xe01f)
    /// 播放列表
    public static var featured_play_list = MaterialIcons(codePoint: 0xe06d)
    /// 播放视频
    public static var featured_video = MaterialIcons(codePoint: 0xe06e)
    /// DVR
    public static var fiber_dvr = MaterialIcons(codePoint: 0xe05d)
    /// 圆点/录音电钮
    public static var fiber_manual_record = MaterialIcons(codePoint: 0xe061)
    /// NEW
    public static var fiber_new = MaterialIcons(codePoint: 0xe05e)
    /// PIN
    public static var fiber_pin = MaterialIcons(codePoint: 0xe06a)
    /// 圆点有圆弧
    public static var fiber_smart_record = MaterialIcons(codePoint: 0xe062)
    /// 前进10s
    public static var forward_10 = MaterialIcons(codePoint: 0xe056)
    /// 前进30s
    public static var forward_30 = MaterialIcons(codePoint: 0xe057)
    /// 前进5s
    public static var forward_5 = MaterialIcons(codePoint: 0xe058)
    /// games
    public static var games = MaterialIcons(codePoint: 0xe021)
    /// HD
    public static var hd = MaterialIcons(codePoint: 0xe052)
    /// 耳朵倾听
    public static var hearing = MaterialIcons(codePoint: 0xe023)
    /// HQ
    public static var high_quality = MaterialIcons(codePoint: 0xe024)
    /// 添加库
    public static var library_add = MaterialIcons(codePoint: 0xe02e)
    /// 书籍库
    public static var library_books = MaterialIcons(codePoint: 0xe02f)
    /// 音乐库
    public static var library_music = MaterialIcons(codePoint: 0xe030)
    /// 循环
    public static var loop = MaterialIcons(codePoint: 0xe028)
    /// 麦克风实心
    public static var mic = MaterialIcons(codePoint: 0xe029)
    /// 麦克风空心
    public static var mic_none = MaterialIcons(codePoint: 0xe02a)
    /// 麦克风无效
    public static var mic_off = MaterialIcons(codePoint: 0xe02b)
    /// 电影🎬
    public static var movie = MaterialIcons(codePoint: 0xe02c)
    /// 音乐
    public static var music_video = MaterialIcons(codePoint: 0xe063)
    /// 感叹号+四周凸起
    public static var new_releases = MaterialIcons(codePoint: 0xe031)
    /// 禁止通行
    public static var not_interested = MaterialIcons(codePoint: 0xe033)
    /// 笔记
    public static var note = MaterialIcons(codePoint: 0xe06f)
    /// 暂停
    public static var pause = MaterialIcons(codePoint: 0xe034)
    /// 暂停/实心圈
    public static var pause_circle_filled = MaterialIcons(codePoint: 0xe035)
    /// 暂停/空心圈
    public static var pause_circle_outline = MaterialIcons(codePoint: 0xe036)
    /// 播放
    public static var play_arrow = MaterialIcons(codePoint: 0xe037)
    /// 播放/实心圈
    public static var play_circle_filled = MaterialIcons(codePoint: 0xe038)
    /// 播放/空心圈
    public static var play_circle_outline = MaterialIcons(codePoint: 0xe039)
    /// 播放列表+
    public static var playlist_add = MaterialIcons(codePoint: 0xe03b)
    /// 播放列表+对号
    public static var playlist_add_check = MaterialIcons(codePoint: 0xe065)
    /// 播放列表+播放
    public static var playlist_play = MaterialIcons(codePoint: 0xe05f)
    /// 队列
    public static var queue = MaterialIcons(codePoint: 0xe03c)
    /// 队列+音乐
    public static var queue_music = MaterialIcons(codePoint: 0xe03d)
    /// 队列+下一个
    public static var queue_play_next = MaterialIcons(codePoint: 0xe066)
    /// 无线电
    public static var radio = MaterialIcons(codePoint: 0xe03e)
    /// 头像+两个竖线
    public static var recent_actors = MaterialIcons(codePoint: 0xe03f)
    /// 移除
    public static var remove_from_queue = MaterialIcons(codePoint: 0xe067)
    /// 循环
    public static var `repeat` = MaterialIcons(codePoint: 0xe040)
    /// 后退
    public static var reply = MaterialIcons(codePoint: 0xe15e)
    /// 后退10
    public static var replay_10 = MaterialIcons(codePoint: 0xe059)
    /// 后退30
    public static var replay_30 = MaterialIcons(codePoint: 0xe05a)
    /// 后退5
    public static var replay_5 = MaterialIcons(codePoint: 0xe05b)
    /// 拖曳
    public static var shuffle = MaterialIcons(codePoint: 0xe043)
    /// 播放下一个
    public static var skip_next = MaterialIcons(codePoint: 0xe044)
    /// 播放前一个
    public static var skip_previous = MaterialIcons(codePoint: 0xe045)
    /// 慢动作
    public static var slow_motion_video = MaterialIcons(codePoint: 0xe068)
    /// 打盹
    public static var snooze = MaterialIcons(codePoint: 0xe046)
    /// AZ
    public static var sort_by_alpha = MaterialIcons(codePoint: 0xe053)
    /// 停止 正方形实心
    public static var stop = MaterialIcons(codePoint: 0xe047)
    /// 订阅
    public static var subscriptions = MaterialIcons(codePoint: 0xe064)
    /// 字幕
    public static var subtitles = MaterialIcons(codePoint: 0xe048)
    /// 环绕声
    public static var surround_sound = MaterialIcons(codePoint: 0xe049)
    /// 视频电话
    public static var video_call = MaterialIcons(codePoint: 0xe070)
    /// 视频库
    public static var video_library = MaterialIcons(codePoint: 0xe04a)
    /// 摄像头实心
    public static var videocam = MaterialIcons(codePoint: 0xe04b)
    /// 摄像头无效
    public static var videocam_off = MaterialIcons(codePoint: 0xe04c)
    /// 减小音量
    public static var volume_down = MaterialIcons(codePoint: 0xe04d)
    /// 静音
    public static var volume_mute = MaterialIcons(codePoint: 0xe04e)
    /// 音量无效
    public static var volume_off = MaterialIcons(codePoint: 0xe04f)
    /// 增大音量
    public static var volume_up = MaterialIcons(codePoint: 0xe050)
    /// 网站
    public static var web = MaterialIcons(codePoint: 0xe051)
    public static var web_asset = MaterialIcons(codePoint: 0xe069)
}

// MARK: - communication https://github.com/google/material-design-icons/tree/master/communication/ios
extension MaterialIcons {
    /// 大夏
    public static var business = MaterialIcons(codePoint: 0xe0af)
    /// 电话/呼叫
    public static var call = MaterialIcons(codePoint: 0xe0b0)
    /// 电话/挂断
    public static var call_end = MaterialIcons(codePoint: 0xe0b1)
    /// 箭头  倾斜45度
    public static var call_made = MaterialIcons(codePoint: 0xe0b2)
    /// 电话/合并/交通指示
    public static var call_merge = MaterialIcons(codePoint: 0xe0b3)
    /// 电话/未接/交通指示
    public static var call_missed = MaterialIcons(codePoint: 0xe0b4)
    /// 电话/合并/交通指示
    public static var call_missed_outgoing = MaterialIcons(codePoint: 0xe0e4)
    /// 电话/未接/交通指示
    public static var call_received = MaterialIcons(codePoint: 0xe0b5)
    /// 电话/拆分/交通指示
    public static var call_split = MaterialIcons(codePoint: 0xe0b6)
    /// 聊天消息
    public static var chat = MaterialIcons(codePoint: 0xe0b7)
    /// 聊天泡泡实心
    public static var chat_bubble = MaterialIcons(codePoint: 0xe0ca)
    /// 聊天泡泡空心
    public static var chat_bubble_outline = MaterialIcons(codePoint: 0xe0cb)
    /// 3条不对齐的横线
    public static var clear_all = MaterialIcons(codePoint: 0xe0b8)
    /// 评论
    public static var comment = MaterialIcons(codePoint: 0xe0b9)
    /// 联系人邮箱
    public static var contact_mail = MaterialIcons(codePoint: 0xe0d0)
    /// 联系人电话
    public static var contact_phone = MaterialIcons(codePoint: 0xe0cf)
    /// 联系人
    public static var contacts = MaterialIcons(codePoint: 0xe0ba)
    /// 电话 SIP
    public static var dialer_sip = MaterialIcons(codePoint: 0xe0bb)
    /// 拨号盘
    public static var dialpad = MaterialIcons(codePoint: 0xe0bc)
    /// 邮件实心
    public static var email = MaterialIcons(codePoint: 0xe0be)
    /// 邮件空心
    public static var mail_outline = MaterialIcons(codePoint: 0xe0e1)
    /// 论坛
    public static var forum = MaterialIcons(codePoint: 0xe0bf)
    /// 倒入联系人/翻开的书📖
    public static var import_contacts = MaterialIcons(codePoint: 0xe0e0)
    /// 进出口/上下两箭头
    public static var import_export = MaterialIcons(codePoint: 0xe0c3)
    /// 水滴无效
    public static var invert_colors_off = MaterialIcons(codePoint: 0xe0c4)
    /// 帮助/？
    public static var live_help = MaterialIcons(codePoint: 0xe0c6)
    /// 定位关闭
    public static var location_off = MaterialIcons(codePoint: 0xe0c7)
    /// 定位
    public static var location_on = MaterialIcons(codePoint: 0xe0c8)
    /// 消息
    public static var message = MaterialIcons(codePoint: 0xe0c9)
    /// 无sim卡
    public static var no_sim = MaterialIcons(codePoint: 0xe0cc)
    /// 电话
    public static var phone = MaterialIcons(codePoint: 0xe0cd)
    /// 手机清除
    public static var phonelink_erase = MaterialIcons(codePoint: 0xe0db)
    /// 手机锁机
    public static var phonelink_lock = MaterialIcons(codePoint: 0xe0dc)
    /// 手机铃声
    public static var phonelink_ring = MaterialIcons(codePoint: 0xe0dd)
    /// 手机设置
    public static var phonelink_setup = MaterialIcons(codePoint: 0xe0de)
    /// 便携式wifi关闭
    public static var portable_wifi_off = MaterialIcons(codePoint: 0xe0ce)
    public static var present_to_all = MaterialIcons(codePoint: 0xe0df)
    /// 来电
    public static var ring_volume = MaterialIcons(codePoint: 0xe0d1)
    /// rss
    public static var rss_feed = MaterialIcons(codePoint: 0xe0e5)
    public static var screen_share = MaterialIcons(codePoint: 0xe0e2)
    /// 扬声器
    public static var speaker_phone = MaterialIcons(codePoint: 0xe0d2)
    /// 横屏1
    public static var stay_current_landscape = MaterialIcons(codePoint: 0xe0d3)
    /// 竖屏1
    public static var stay_current_portrait = MaterialIcons(codePoint: 0xe0d4)
    /// 横屏2
    public static var stay_primary_landscape = MaterialIcons(codePoint: 0xe0d5)
    /// 竖屏2
    public static var stay_primary_portrait = MaterialIcons(codePoint: 0xe0d6)
    public static var stop_screen_share = MaterialIcons(codePoint: 0xe0e3)
    /// 交通标志
    public static var swap_calls = MaterialIcons(codePoint: 0xe0d7)
    /// 文字短信
    public static var textsms = MaterialIcons(codePoint: 0xe0d8)
    /// 语音信箱
    public static var voicemail = MaterialIcons(codePoint: 0xe0d9)
    /// 钥匙
    public static var vpn_key = MaterialIcons(codePoint: 0xe0da)
}

// MARK: - content https://github.com/google/material-design-icons/tree/master/content/ios
extension MaterialIcons {
    /// ➕
    public static var add = MaterialIcons(codePoint: 0xe145)
    /// ➕ 带框1
    public static var add_box = MaterialIcons(codePoint: 0xe146)
    /// ➕ 圆边⭕️
    public static var add_circle = MaterialIcons(codePoint: 0xe147)
    /// ➕ 圆形
    public static var add_circle_outline = MaterialIcons(codePoint: 0xe148)
    /// 档案
    public static var archive = MaterialIcons(codePoint: 0xe149)
    /// 删除 退格
    public static var backspace = MaterialIcons(codePoint: 0xe14a)
    /// 禁止
    public static var block = MaterialIcons(codePoint: 0xe14b)
    /// x
    public static var clear = MaterialIcons(codePoint: 0xe14c)
    /// 复制
    public static var content_copy = MaterialIcons(codePoint: 0xe14d)
    /// 剪刀
    public static var content_cut = MaterialIcons(codePoint: 0xe14e)
    /// 粘贴板
    public static var content_paste = MaterialIcons(codePoint: 0xe14f)
    /// 编辑
    public static var create = MaterialIcons(codePoint: 0xe150)
    /// 垃圾桶
    public static var delete_sweep = MaterialIcons(codePoint: 0xe16c)
    /// 草稿
    public static var drafts = MaterialIcons(codePoint: 0xe151)
    /// 3条长短不一的横线
    public static var filter_list = MaterialIcons(codePoint: 0xe152)
    /// A
    public static var font_download = MaterialIcons(codePoint: 0xe167)
    /// 箭头右实心
    public static var forward = MaterialIcons(codePoint: 0xe154)
    public static var gesture = MaterialIcons(codePoint: 0xe155)
    /// 收件箱
    public static var inbox = MaterialIcons(codePoint: 0xe156)
    /// 链接
    public static var link = MaterialIcons(codePoint: 0xe157)
    /// 优先从低
    public static var low_priority = MaterialIcons(codePoint: 0xe16d)
    /// 邮件1
    public static var mail = MaterialIcons(codePoint: 0xe158)
    /// 邮件2
    public static var markunread = MaterialIcons(codePoint: 0xe159)
    /// 投稿
    public static var move_to_inbox = MaterialIcons(codePoint: 0xe168)
    public static var next_week = MaterialIcons(codePoint: 0xe16a)
    /// 重置
    public static var redo = MaterialIcons(codePoint: 0xe15a)
    /// ➖
    public static var remove = MaterialIcons(codePoint: 0xe15b)
    /// ➖实心圆
    public static var remove_circle = MaterialIcons(codePoint: 0xe15c)
    /// ➖空心圆
    public static var remove_circle_outline = MaterialIcons(codePoint: 0xe15d)
    public static var report = MaterialIcons(codePoint: 0xe160)
    /// 内存卡
    public static var save = MaterialIcons(codePoint: 0xe161)
    public static var select_all = MaterialIcons(codePoint: 0xe162)
    /// 发送
    public static var send = MaterialIcons(codePoint: 0xe163)
    /// 3个做对齐长短不一的横线
    public static var sort = MaterialIcons(codePoint: 0xe164)
    /// A
    public static var text_format = MaterialIcons(codePoint: 0xe165)
    public static var unarchive = MaterialIcons(codePoint: 0xe169)
    /// 复原
    public static var undo = MaterialIcons(codePoint: 0xe166)
    public static var weekend = MaterialIcons(codePoint: 0xe16b)
}


// MARK: - device https://github.com/google/material-design-icons/tree/master/device/ios
extension MaterialIcons {
    /// 飞机模式激活
    public static var airplanemode_active = MaterialIcons(codePoint: 0xe195)
    /// 飞机模式无效
    public static var airplanemode_inactive = MaterialIcons(codePoint: 0xe194)
    /// 电池警报
    public static var battery_alert = MaterialIcons(codePoint: 0xe19c)
    /// 电池充满电
    public static var battery_charging_full = MaterialIcons(codePoint: 0xe1a3)
    /// 电池充满
    public static var battery_full = MaterialIcons(codePoint: 0xe1a4)
    /// 电池标准
    public static var battery_std = MaterialIcons(codePoint: 0xe1a5)
    /// 电池未知
    public static var battery_unknown = MaterialIcons(codePoint: 0xe1a6)
    /// 蓝牙
    public static var bluetooth = MaterialIcons(codePoint: 0xe1a7)
    /// 蓝牙连接
    public static var bluetooth_connected = MaterialIcons(codePoint: 0xe1a8)
    /// 蓝牙禁用
    public static var bluetooth_disabled = MaterialIcons(codePoint: 0xe1a9)
    /// 蓝牙搜索
    public static var bluetooth_searching = MaterialIcons(codePoint: 0xe1aa)
    /// 中间A四周三角
    public static var brightness_auto = MaterialIcons(codePoint: 0xe1ab)
    /// 中间圆点四周三角
    public static var brightness_high = MaterialIcons(codePoint: 0xe1ac)
    /// 中间空白四周三角
    public static var brightness_low = MaterialIcons(codePoint: 0xe1ad)
    /// 中间半圆四周三角
    public static var brightness_medium = MaterialIcons(codePoint: 0xe1ae)
    public static var data_usage = MaterialIcons(codePoint: 0xe1af)
    public static var developer_mode = MaterialIcons(codePoint: 0xe1b0)
    public static var devices = MaterialIcons(codePoint: 0xe1b1)
    public static var dvr = MaterialIcons(codePoint: 0xe1b2)
    /// 定位中
    public static var gps_fixed = MaterialIcons(codePoint: 0xe1b3)
    /// 未定位
    public static var gps_not_fixed = MaterialIcons(codePoint: 0xe1b4)
    /// 定位失败
    public static var gps_off = MaterialIcons(codePoint: 0xe1b5)
    public static var graphic_eq = MaterialIcons(codePoint: 0xe1b8)
    /// 未失败
    public static var location_disabled = MaterialIcons(codePoint: 0xe1b6)
    /// 未定位
    public static var location_searching = MaterialIcons(codePoint: 0xe1b7)
    public static var nfc = MaterialIcons(codePoint: 0xe1bb)
    /// 横屏锁屏
    public static var screen_lock_landscape = MaterialIcons(codePoint: 0xe1be)
    /// 竖屏锁屏
    public static var screen_lock_portrait = MaterialIcons(codePoint: 0xe1bf)
    /// 屏幕翻转锁屏
    public static var screen_lock_rotation = MaterialIcons(codePoint: 0xe1c0)
    /// 屏幕翻转
    public static var screen_rotation = MaterialIcons(codePoint: 0xe1c1)
    /// 内存卡
    public static var sd_storage = MaterialIcons(codePoint: 0xe1c2)
    public static var settings_system_daydream = MaterialIcons(codePoint: 0xe1c3)
    /// 网络信号1
    public static var network_cell = MaterialIcons(codePoint: 0xe1b9)
    /// 网络信号2
    public static var signal_cellular_4_bar = MaterialIcons(codePoint: 0xe1c8)
    /// 网络信号无
    public static var signal_cellular_connected_no_internet_4_bar = MaterialIcons(codePoint: 0xe1cd)
    /// 无sim卡
    public static var signal_cellular_no_sim = MaterialIcons(codePoint: 0xe1ce)
    public static var signal_cellular_null = MaterialIcons(codePoint: 0xe1cf)
    public static var signal_cellular_off = MaterialIcons(codePoint: 0xe1d0)
    /// wifi信号
    public static var network_wifi = MaterialIcons(codePoint: 0xe1ba)
    /// wifi满
    public static var signal_wifi_4_bar = MaterialIcons(codePoint: 0xe1d8)
    /// wifi满 锁
    public static var signal_wifi_4_bar_lock = MaterialIcons(codePoint: 0xe1d9)
    /// wifi满 锁
    public static var wifi_lock = MaterialIcons(codePoint: 0xe1e1)
    /// wifi无
    public static var signal_wifi_off = MaterialIcons(codePoint: 0xe1da)
    /// 存储
    public static var storage = MaterialIcons(codePoint: 0xe1db)
    /// usb
    public static var usb = MaterialIcons(codePoint: 0xe1e0)
    /// 墙纸
    public static var wallpaper = MaterialIcons(codePoint: 0xe1bc)
    public static var widgets = MaterialIcons(codePoint: 0xe1bd)
    /// wifi共享
    public static var wifi_tethering = MaterialIcons(codePoint: 0xe1e2)
}

// MARK: - navigation: https://github.com/google/material-design-icons/tree/master/navigation/ios
extension MaterialIcons {
    /// 应用
    public static var apps = MaterialIcons(codePoint: 0xe5c3)
    /// 向后箭头
    public static var arrow_back = MaterialIcons(codePoint: 0xe5c4)
    /// 箭头向下
    public static var arrow_downward = MaterialIcons(codePoint: 0xe5db)
    /// 箭头下拉
    public static var arrow_drop_down = MaterialIcons(codePoint: 0xe5c5)
    /// 箭头下拉圈
    public static var arrow_drop_down_circle = MaterialIcons(codePoint: 0xe5c6)
    /// 箭头下降
    public static var arrow_drop_up = MaterialIcons(codePoint: 0xe5c7)
    /// 向前箭头
    public static var arrow_forward = MaterialIcons(codePoint: 0xe5c8)
    /// 向上箭头
    public static var arrow_upward = MaterialIcons(codePoint: 0xe5d8)
    /// x 圆圈实心
    public static var cancel = MaterialIcons(codePoint: 0xe5c9)
    /// 对号
    public static var check = MaterialIcons(codePoint: 0xe5ca)
    /// <
    public static var chevron_left = MaterialIcons(codePoint: 0xe5cb)
    /// >
    public static var chevron_right = MaterialIcons(codePoint: 0xe5cc)
    /// x
    public static var close = MaterialIcons(codePoint: 0xe5cd)
    /// ^
    public static var expand_less = MaterialIcons(codePoint: 0xe5ce)
    /// v
    public static var expand_more = MaterialIcons(codePoint: 0xe5cf)
    public static var first_page = MaterialIcons(codePoint: 0xe5dc)
    public static var fullscreen = MaterialIcons(codePoint: 0xe5d0)
    public static var fullscreen_exit = MaterialIcons(codePoint: 0xe5d1)
    public static var last_page = MaterialIcons(codePoint: 0xe5dd)
    /// 菜单
    public static var menu = MaterialIcons(codePoint: 0xe5d2)
    /// ...
    public static var more_horiz = MaterialIcons(codePoint: 0xe5d3)
    public static var more_vert = MaterialIcons(codePoint: 0xe5d4)
    public static var refresh = MaterialIcons(codePoint: 0xe5d5)
    public static var subdirectory_arrow_left = MaterialIcons(codePoint: 0xe5d9)
    public static var subdirectory_arrow_right = MaterialIcons(codePoint: 0xe5da)
    public static var unfold_less = MaterialIcons(codePoint: 0xe5d6)
    public static var unfold_more = MaterialIcons(codePoint: 0xe5d7)
}


// MARK: - toggle  https://github.com/google/material-design-icons/tree/master/toggle/ios
extension MaterialIcons {
    /// check  实心正方形
    public static var check_box = MaterialIcons(codePoint: 0xe834)
    public static var indeterminate_check_box = MaterialIcons(codePoint: 0xe909)
    public static var radio_button_checked = MaterialIcons(codePoint: 0xe837)
    /// 圆圈⭕️
    public static var radio_button_unchecked = MaterialIcons(codePoint: 0xe836)
    /// star ★
    public static var star = MaterialIcons(codePoint: 0xe838)
    /// star 半实半空
    public static var star_half = MaterialIcons(codePoint: 0xe839)
    /// star ☆
    public static var star_border = MaterialIcons(codePoint: 0xe83a)
}

// MARK: - social: https://github.com/google/material-design-icons/tree/master/social/ios
extension MaterialIcons {
    /// 蛋糕
    public static var cake = MaterialIcons(codePoint: 0xe7e9)
    public static var domain = MaterialIcons(codePoint: 0xe7ee)
    /// 联系人组
    public static var group = MaterialIcons(codePoint: 0xe7ef)
    /// 联系人 +
    public static var group_add = MaterialIcons(codePoint: 0xe7f0)
    public static var location_city = MaterialIcons(codePoint: 0xe7f1)
    public static var notifications = MaterialIcons(codePoint: 0xe7f4)
    public static var notifications_active = MaterialIcons(codePoint: 0xe7f7)
    public static var notifications_none = MaterialIcons(codePoint: 0xe7f5)
    public static var notifications_off = MaterialIcons(codePoint: 0xe7f6)
    public static var notifications_paused = MaterialIcons(codePoint: 0xe7f8)
    public static var pages = MaterialIcons(codePoint: 0xe7f9)
    public static var party_mode = MaterialIcons(codePoint: 0xe7fa)
    public static var people = MaterialIcons(codePoint: 0xe7fb)
    public static var people_outline = MaterialIcons(codePoint: 0xe7fc)
    /// 联系人
    public static var person = MaterialIcons(codePoint: 0xe7fd)
    /// 添加联系人
    public static var person_add = MaterialIcons(codePoint: 0xe7fe)
    public static var person_outline = MaterialIcons(codePoint: 0xe7ff)
    public static var person_pin = MaterialIcons(codePoint: 0xe55a)
    /// +1
    public static var plus_one = MaterialIcons(codePoint: 0xe800)
    public static var poll = MaterialIcons(codePoint: 0xe801)
    /// 全球
    public static var `public` = MaterialIcons(codePoint: 0xe80b)
    public static var school = MaterialIcons(codePoint: 0xe80c)
    /// 笑脸
    public static var mood = MaterialIcons(codePoint: 0xe7f2)
    /// 失望的脸色
    public static var mood_bad = MaterialIcons(codePoint: 0xe7f3)
    /// 哭脸
    public static var sentiment_dissatisfied = MaterialIcons(codePoint: 0xe811)
    public static var sentiment_neutral = MaterialIcons(codePoint: 0xe812)
    /// 笑脸
    public static var sentiment_satisfied = MaterialIcons(codePoint: 0xe813)
    public static var sentiment_very_dissatisfied = MaterialIcons(codePoint: 0xe814)
    /// 大笑
    public static var sentiment_very_satisfied = MaterialIcons(codePoint: 0xe815)
    /// 设置
    public static var settings = MaterialIcons(codePoint: 0xe8b8)
    /// 分享
    public static var share = MaterialIcons(codePoint: 0xe80d)
    public static var whatshot = MaterialIcons(codePoint: 0xe80e)
    /// 点赞
    public static var thumb_up = MaterialIcons(codePoint: 0xe8dc)
    public static var thumb_down = MaterialIcons(codePoint: 0xe8db)
    public static var thumbs_up_down = MaterialIcons(codePoint: 0xe8dd)
}

// MARK: - 其它:  若有漏写,请结合 https://material.io/tools/icons/?style=baseline 以及
// https://github.com/google/material-design-icons/blob/master/iconfont/codepoints
// MaterialIcons(codePoint: xxxxx)
extension MaterialIcons {
    /// 雪花
    public static var ac_unit = MaterialIcons(codePoint: 0xeb3b)
    /// adb
    public static var adb = MaterialIcons(codePoint: 0xe60e)
    /// 照相机
    public static var add_a_photo = MaterialIcons(codePoint: 0xe439)
    /// 定位1
    public static var add_location = MaterialIcons(codePoint: 0xe567)
    /// ➕ 相册
    public static var add_to_photos = MaterialIcons(codePoint: 0xe39d)
    /// 调整
    public static var adjust = MaterialIcons(codePoint: 0xe39e)
    /// 航空公司座位 平
    public static var airline_seat_flat = MaterialIcons(codePoint: 0xe630)
    /// 航空公司座位 倾斜
    public static var airline_seat_flat_angled = MaterialIcons(codePoint: 0xe631)
    /// 航空公司座位独立套房
    public static var airline_seat_individual_suite = MaterialIcons(codePoint: 0xe632)
    /// 航空座椅腿部空间额外
    public static var airline_seat_legroom_extra = MaterialIcons(codePoint: 0xe633)
    /// 航空座椅腿部空间正常
    public static var airline_seat_legroom_normal = MaterialIcons(codePoint: 0xe634)
    /// 航空公司座位腿部空间减少
    public static var airline_seat_legroom_reduced = MaterialIcons(codePoint: 0xe635)
    /// 航空公司座椅倾斜额外
    public static var airline_seat_recline_extra = MaterialIcons(codePoint: 0xe636)
    /// 航空公司座位倾斜正常
    public static var airline_seat_recline_normal = MaterialIcons(codePoint: 0xe637)
    /// 班车
    public static var airport_shuttle = MaterialIcons(codePoint: 0xeb3c)
    /// 无限 符号 ∞
    public static var all_inclusive = MaterialIcons(codePoint: 0xeb3d)
    /// 旗子标记
    public static var assistant_photo = MaterialIcons(codePoint: 0xe3a0)
    /// 附加文件 纵向
    public static var attach_file = MaterialIcons(codePoint: 0xe226)
    /// 旗子标记
    public static var attach_money = MaterialIcons(codePoint: 0xe227)
    /// 附加文件 横向
    public static var attachment = MaterialIcons(codePoint: 0xe2bc)
    /// 音轨
    public static var audiotrack = MaterialIcons(codePoint: 0xe3a1)
    /// 海滩伞
    public static var beach_access = MaterialIcons(codePoint: 0xeb3e)
    /// 旗帜对号
    public static var beenhere = MaterialIcons(codePoint: 0xe52d)
    /// 蓝牙音频
    public static var bluetooth_audio = MaterialIcons(codePoint: 0xe60f)
    /// 模糊圆形
    public static var blur_circular = MaterialIcons(codePoint: 0xe3a2)
    /// 模糊线性
    public static var blur_linear = MaterialIcons(codePoint: 0xe3a3)
    /// 模糊关闭
    public static var blur_off = MaterialIcons(codePoint: 0xe3a4)
    /// 模糊
    public static var blur_on = MaterialIcons(codePoint: 0xe3a5)
    /// 田
    public static var border_all = MaterialIcons(codePoint: 0xe228)
    /// 田--底部清晰
    public static var border_bottom = MaterialIcons(codePoint: 0xe229)
    /// 田-全虚线
    public static var border_clear = MaterialIcons(codePoint: 0xe22a)
    /// 编辑
    public static var border_color = MaterialIcons(codePoint: 0xe22b)
    /// 田-中间横清晰
    public static var border_horizontal = MaterialIcons(codePoint: 0xe22c)
    /// 田-中间横竖清晰
    public static var border_inner = MaterialIcons(codePoint: 0xe22d)
    /// 田-中间左清晰
    public static var border_left = MaterialIcons(codePoint: 0xe22e)
    /// 田-四周清晰
    public static var border_outer = MaterialIcons(codePoint: 0xe22f)
    /// 田-中间右清晰
    public static var border_right = MaterialIcons(codePoint: 0xe230)
    /// 口-上左清晰
    public static var border_style = MaterialIcons(codePoint: 0xe231)
    /// 田-中间上清晰
    public static var border_top = MaterialIcons(codePoint: 0xe232)
    /// 田-中间竖清晰
    public static var border_vertical = MaterialIcons(codePoint: 0xe233)
    /// 黑色圆点
    public static var brightness_1 = MaterialIcons(codePoint: 0xe3a6)
    /// 月牙1
    public static var brightness_2 = MaterialIcons(codePoint: 0xe3a7)
    /// 月牙2
    public static var brightness_3 = MaterialIcons(codePoint: 0xe3a8)
    /// 月牙3
    public static var brightness_4 = MaterialIcons(codePoint: 0xe3a9)
    /// 中间圆四周三角
    public static var brightness_5 = MaterialIcons(codePoint: 0xe3aa)
    /// 月牙4
    public static var brightness_6 = MaterialIcons(codePoint: 0xe3ab)
    /// 中间圆点四周三角
    public static var brightness_7 = MaterialIcons(codePoint: 0xe3ac)
    /// 破碎的图像
    public static var broken_image = MaterialIcons(codePoint: 0xe3ad)
    /// 毛刷
    public static var brush = MaterialIcons(codePoint: 0xe3ae)
    /// 3个大小不一的气泡
    public static var bubble_chart = MaterialIcons(codePoint: 0xe6dd)
    /// 突发模式
    public static var burst_mode = MaterialIcons(codePoint: 0xe43c)
    /// 医药箱
    public static var business_center = MaterialIcons(codePoint: 0xeb3f)
}
