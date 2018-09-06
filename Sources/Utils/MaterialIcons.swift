import Foundation
/// google material icon
/// https://github.com/google/material-design-icons/blob/master/iconfont/MaterialIcons-Regular.ttf6
public final class Material: Fontloadable {
    public static var url: URL {
        let bundle = Bundle(for: self)
        guard let bu = bundle.url(forResource: "JJLibrary", withExtension: "bundle") else {
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

public struct MaterialIcons {
    private init() {}
}

// MARK: - 图标列表
// https://github.com/google/material-design-icons/blob/master/iconfont/codepoints
extension MaterialIcons {
    /// 旋转3d
    public static var rotation_3d: IconData<Material> = IconData<Material>(codePoint: 0xe84d)
    /// 雪花
    public static var ac_unit: IconData<Material> = IconData<Material>(codePoint: 0xeb3b)
    /// 闹钟1
    public static var access_alarm: IconData<Material> = IconData<Material>(codePoint: 0xe190)
    /// 闹钟2
    public static var access_alarms: IconData<Material> = IconData<Material>(codePoint: 0xe191)
    /// 闹钟3
    public static var access_time: IconData<Material> = IconData<Material>(codePoint: 0xe192)
    /// 闹钟4 ➕
    public static var add_alarm: IconData<Material> = IconData<Material>(codePoint: 0xe193)
    /// 闹钟5
    public static var alarm: IconData<Material> = IconData<Material>(codePoint: 0xe855)
    /// 闹钟6 ➕
    public static var alarm_add: IconData<Material> = IconData<Material>(codePoint: 0xe856)
    /// 闹钟7 关闭
    public static var alarm_off: IconData<Material> = IconData<Material>(codePoint: 0xe857)
    /// 闹钟8 on
    public static var alarm_on: IconData<Material> = IconData<Material>(codePoint: 0xe858)
    /// 无障碍
    public static var accessibility: IconData<Material> = IconData<Material>(codePoint: 0xe84e)
    /// 无障碍 轮椅
    public static var accessible: IconData<Material> = IconData<Material>(codePoint: 0xe914)
    /// 账户余额
    public static var account_balance: IconData<Material> = IconData<Material>(codePoint: 0xe84f)
    /// 钱包
    public static var account_balance_wallet: IconData<Material> = IconData<Material>(codePoint: 0xe850)
    /// 账户带框
    public static var account_box: IconData<Material> = IconData<Material>(codePoint: 0xe851)
    /// 账户圆形
    public static var account_circle: IconData<Material> = IconData<Material>(codePoint: 0xe853)
    /// adb
    public static var adb: IconData<Material> = IconData<Material>(codePoint: 0xe60e)
    /// ➕
    public static var add: IconData<Material> = IconData<Material>(codePoint: 0xe145)
    /// 照相机
    public static var add_a_photo: IconData<Material> = IconData<Material>(codePoint: 0xe439)
    /// 提醒 --- 钟/➕
    public static var add_alert: IconData<Material> = IconData<Material>(codePoint: 0xe003)
    /// ➕ 带框1
    public static var add_box: IconData<Material> = IconData<Material>(codePoint: 0xe146)
    /// ➕ 圆边⭕️
    public static var add_circle: IconData<Material> = IconData<Material>(codePoint: 0xe147)
    /// ➕ 圆形
    public static var add_circle_outline: IconData<Material> = IconData<Material>(codePoint: 0xe148)
    /// ➕ 带框2
    public static var add_to_queue: IconData<Material> = IconData<Material>(codePoint: 0xe05c)
    /// 定位1
    public static var add_location: IconData<Material> = IconData<Material>(codePoint: 0xe567)
    /// 购物筐
    public static var add_shopping_cart: IconData<Material> = IconData<Material>(codePoint: 0xe854)
    /// ➕ 相册
    public static var add_to_photos: IconData<Material> = IconData<Material>(codePoint: 0xe39d)
    /// 调整
    public static var adjust: IconData<Material> = IconData<Material>(codePoint: 0xe39e)
    /// 航空公司座位 平
    public static var airline_seat_flat: IconData<Material> = IconData<Material>(codePoint: 0xe630)
    /// 航空公司座位 倾斜
    public static var airline_seat_flat_angled: IconData<Material> = IconData<Material>(codePoint: 0xe631)
    /// 航空公司座位独立套房
    public static var airline_seat_individual_suite: IconData<Material> = IconData<Material>(codePoint: 0xe632)
    /// 航空座椅腿部空间额外
    public static var airline_seat_legroom_extra: IconData<Material> = IconData<Material>(codePoint: 0xe633)
    /// 航空座椅腿部空间正常
    public static var airline_seat_legroom_normal: IconData<Material> = IconData<Material>(codePoint: 0xe634)
    /// 航空公司座位腿部空间减少
    public static var airline_seat_legroom_reduced: IconData<Material> = IconData<Material>(codePoint: 0xe635)
    /// 航空公司座椅倾斜额外
    public static var airline_seat_recline_extra: IconData<Material> = IconData<Material>(codePoint: 0xe636)
    /// 航空公司座位倾斜正常
    public static var airline_seat_recline_normal: IconData<Material> = IconData<Material>(codePoint: 0xe637)
    /// 飞机模式激活
    public static var airplanemode_active: IconData<Material> = IconData<Material>(codePoint: 0xe195)
    /// 飞机模式无效
    public static var airplanemode_inactive: IconData<Material> = IconData<Material>(codePoint: 0xe194)
    /// 单曲
    public static var airplay: IconData<Material> = IconData<Material>(codePoint: 0xe055)
    /// 班车
    public static var airport_shuttle: IconData<Material> = IconData<Material>(codePoint: 0xeb3c)
    /// 专辑💽
    public static var album: IconData<Material> = IconData<Material>(codePoint: 0xe019)
    /// 无限 符号 ∞
    public static var all_inclusive: IconData<Material> = IconData<Material>(codePoint: 0xeb3d)
    /// 四个三角加圆
    public static var all_out: IconData<Material> = IconData<Material>(codePoint: 0xe90b)
    /// 安卓
    public static var android: IconData<Material> = IconData<Material>(codePoint: 0xe859)
    /// 公告
    public static var announcement: IconData<Material> = IconData<Material>(codePoint: 0xe85a)
    /// 应用
    public static var apps: IconData<Material> = IconData<Material>(codePoint: 0xe5c3)
    /// 档案
    public static var archive: IconData<Material> = IconData<Material>(codePoint: 0xe149)
    /// 向后箭头
    public static var arrow_back: IconData<Material> = IconData<Material>(codePoint: 0xe5c4)
    /// 箭头向下
    public static var arrow_downward: IconData<Material> = IconData<Material>(codePoint: 0xe5db)
    /// 箭头下拉
    public static var arrow_drop_down: IconData<Material> = IconData<Material>(codePoint: 0xe5c5)
    /// 箭头下拉圈
    public static var arrow_drop_down_circle: IconData<Material> = IconData<Material>(codePoint: 0xe5c6)
    /// 箭头下降
    public static var arrow_drop_up: IconData<Material> = IconData<Material>(codePoint: 0xe5c7)
    /// 向前箭头
    public static var arrow_forward: IconData<Material> = IconData<Material>(codePoint: 0xe5c8)
    /// 向上箭头
    public static var arrow_upward: IconData<Material> = IconData<Material>(codePoint: 0xe5d8)
    /// 艺术轨道
    public static var art_track: IconData<Material> = IconData<Material>(codePoint: 0xe060)
    /// 纵横比
    public static var aspect_ratio: IconData<Material> = IconData<Material>(codePoint: 0xe85b)
    /// 评定
    public static var assessment: IconData<Material> = IconData<Material>(codePoint: 0xe85c)
    /// 分配
    public static var assignment: IconData<Material> = IconData<Material>(codePoint: 0xe85d)
    /// 任务
    public static var assignment_ind: IconData<Material> = IconData<Material>(codePoint: 0xe85e)
    /// 任务警告
    public static var assignment_late: IconData<Material> = IconData<Material>(codePoint: 0xe85f)
    /// 左⬅️
    public static var assignment_return: IconData<Material> = IconData<Material>(codePoint: 0xe860)
    /// 下⬇️
    public static var assignment_returned: IconData<Material> = IconData<Material>(codePoint: 0xe861)
    /// 完成✅
    public static var assignment_turned_in: IconData<Material> = IconData<Material>(codePoint: 0xe862)
    /// 星
    public static var assistant: IconData<Material> = IconData<Material>(codePoint: 0xe39f)
    /// 旗子标记
    public static var assistant_photo: IconData<Material> = IconData<Material>(codePoint: 0xe3a0)
    /// 附加文件 纵向
    public static var attach_file: IconData<Material> = IconData<Material>(codePoint: 0xe226)
    /// 旗子标记
    public static var attach_money: IconData<Material> = IconData<Material>(codePoint: 0xe227)
    /// 附加文件 横向
    public static var attachment: IconData<Material> = IconData<Material>(codePoint: 0xe2bc)
    /// 音轨
    public static var audiotrack: IconData<Material> = IconData<Material>(codePoint: 0xe3a1)
    /// 自动更新
    public static var autorenew: IconData<Material> = IconData<Material>(codePoint: 0xe863)
    /// 计时器
    public static var av_timer: IconData<Material> = IconData<Material>(codePoint: 0xe01b)
    /// 删除 退格
    public static var backspace: IconData<Material> = IconData<Material>(codePoint: 0xe14a)
    /// 云备份
    public static var backup: IconData<Material> = IconData<Material>(codePoint: 0xe864)
    /// 电池警报
    public static var battery_alert: IconData<Material> = IconData<Material>(codePoint: 0xe19c)
    /// 电池充满电
    public static var battery_charging_full: IconData<Material> = IconData<Material>(codePoint: 0xe1a3)
    /// 电池充满
    public static var battery_full: IconData<Material> = IconData<Material>(codePoint: 0xe1a4)
    /// 电池标准
    public static var battery_std: IconData<Material> = IconData<Material>(codePoint: 0xe1a5)
    /// 电池未知
    public static var battery_unknown: IconData<Material> = IconData<Material>(codePoint: 0xe1a6)
    /// 海滩伞
    public static var beach_access: IconData<Material> = IconData<Material>(codePoint: 0xeb3e)
    /// 旗帜对号
    public static var beenhere: IconData<Material> = IconData<Material>(codePoint: 0xe52d)
    /// 禁止
    public static var block: IconData<Material> = IconData<Material>(codePoint: 0xe14b)
    /// 蓝牙
    public static var bluetooth: IconData<Material> = IconData<Material>(codePoint: 0xe1a7)
    /// 蓝牙音频
    public static var bluetooth_audio: IconData<Material> = IconData<Material>(codePoint: 0xe60f)
    /// 蓝牙连接
    public static var bluetooth_connected: IconData<Material> = IconData<Material>(codePoint: 0xe1a8)
    /// 蓝牙禁用
    public static var bluetooth_disabled: IconData<Material> = IconData<Material>(codePoint: 0xe1a9)
    /// 蓝牙搜索
    public static var bluetooth_searching: IconData<Material> = IconData<Material>(codePoint: 0xe1aa)
    /// 模糊圆形
    public static var blur_circular: IconData<Material> = IconData<Material>(codePoint: 0xe3a2)
    /// 模糊线性
    public static var blur_linear: IconData<Material> = IconData<Material>(codePoint: 0xe3a3)
    /// 模糊关闭
    public static var blur_off: IconData<Material> = IconData<Material>(codePoint: 0xe3a4)
    /// 模糊
    public static var blur_on: IconData<Material> = IconData<Material>(codePoint: 0xe3a5)
    /// 书
    public static var book: IconData<Material> = IconData<Material>(codePoint: 0xe865)
    /// 书签
    public static var bookmark: IconData<Material> = IconData<Material>(codePoint: 0xe866)
    /// 书签边框
    public static var bookmark_border: IconData<Material> = IconData<Material>(codePoint: 0xe867)
    /// 田
    public static var border_all: IconData<Material> = IconData<Material>(codePoint: 0xe228)
    /// 田--底部清晰
    public static var border_bottom: IconData<Material> = IconData<Material>(codePoint: 0xe229)
    /// 田-全虚线
    public static var border_clear: IconData<Material> = IconData<Material>(codePoint: 0xe22a)
    /// 编辑
    public static var border_color: IconData<Material> = IconData<Material>(codePoint: 0xe22b)
    /// 田-中间横清晰
    public static var border_horizontal: IconData<Material> = IconData<Material>(codePoint: 0xe22c)
    
    
}




