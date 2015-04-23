/*
 * 应用服务
 *
 * 异常号段：700~799
 */

include "Type.thrift"
include "Standard.thrift"
include "Identity.thrift"
include "FileStore.thrift"

namespace java com.wisorg.scc.api.internal.application
namespace js Application
namespace cocoa Application

/**
 * 应用配置-AppKey-应用
 */
const string APPKEY_APP = "app";

/**
 * 应用配置-BizKey-应用-公共
 */
const string BIZKEY_APP_COMMON = "app-common";

/**
 * 应用配置-BizKey-应用-评分
 */
const string BIZKEY_APP_RATING = BIZKEY_APP_COMMON;

/**
 * 评分-应用-类型
 */
const i32 RATING_TYPE_APP = 1;

/**
 * 应用配置-BizKey-应用-图标
 */
const string BIZKEY_APP_ICON = "app-icon";

/**
 * 应用配置-BizKey-应用-安装包
 */
const string BIZKEY_APP_PKG = "app-pkg";

/**
 * 应用来源
 */
enum TApplicationSrc {
	/**
	 * 超市
	 */
	STORE = 0,

	/**
	 * 开放平台
	 */
	OPEN = 1
}

/**
 * 应用状态
 */
enum TApplicationStatus {
	/**
	 * 草稿
	 */
	DRAFT = 0,

	/**
	 * 上架申请
	 */
	SUBMIT = 1,

	/**
	 * 上架审核退回
	 */
	REJECTED = 2,

	/**
	 * 上架
	 */
	ONLINE = 3,

	/**
	 * 下架
	 */
	OFFLINE = 4,

	/**
	 * 归档
	 */
	ARCHIVED = 5,

	/**
	 * 下架提交
	 */
	OFFLINESUBMIT = 6,

	/**
	 * 下架退回
	 */
	OFFLINEREJECTED = 7,
}

/**
 *应用开放状态
 */
enum TApplicationOpenStatus {
	/**
	 * 草稿
	 */
	DRAFT = 0,

	/**
	 * 上线申请
	 */
	ONLINESUBMIT = 1,

	/**
	 * 上线退回
	 */
	ONLINEREJECTED = 2,

	/**
	 * 上线
	 */
	ONLINE = 3,

	/**
	 * 下线申请
	 */
	OFFLINESUBMIT = 4,

	/**
	 * 下线退回
	 */
	OFFLINEREJECTED = 5,

	/**
	 * 下线
	 */
	OFFLINE = 6,

	/**
	 * 归档
	 */
	ARCHIVED = 7
}

/**
 * 应用分类
 */
struct TAppCategory {
	/**
	 * 标识
	 *
	 * @Id
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 名称
	 *
	 * @Unique
	 */
	2: optional string name,

	/**
	 * 描述
	 */
	3: optional string description,

	/**
	 * 状态
	 */
	4: optional Type.TStatus status,

	/**
	 * 顺序
	 */
	5: optional i16 index = Type.NULL_LONG
}

/**
 * 应用运行方式
 */
enum TAppRunType {
	/**
	 * 内置的（与主程序一起打包并运行）
	 */
	BUILD_IN = 0,

	/**
	 * 独立打包并运行的
	 */
	STANDALONE = 1,

	/**
	 * 第三方市场引用并运行的
	 */
	THIRDPARTY = 2
}

/**
 * 应用罗列形式
 */
enum TAppListType {
	/**
	 * 固定在主屏幕，用户不可移除
	 */
	FIXED = 0,

	/**
	 * 可自由添加、移除
	 */
	LISTABLE = 1
}

/**
 * 应用版本状态
 */
enum TAppDetailStatus {
	/**
	 * 草稿
	 */
	DRAFT = 0,

	/**
	 * 审核中
	 */
	SUBMIT = 1,

	/**
	 * 审核退回
	 */
	REJECTED = 2,

	/**
	 * 发布
	 */
	RELEASED = 3
}

/**
 * 应用信息状态
 */
enum TAppInfoStatus {
	/**
	 * 草稿
	 */
	DRAFT = 0,

	/**
	 * 审核中
	 */
	SUBMIT = 1,

	/**
	 * 审核退回
	 */
	REJECTED = 2,

	/**
	 * 审核通过
	 */
	PASSED = 3
}

/**
 * 应用级别
 */
enum TAppLevel {
	/**
	 * 弃用
	 */
	DEPRECATED = 0,

	/**
	 * 普通
	 */
	NORMAL = 1,

	/**
	 * 高级
	 */
	ADVANCED = 2,

	/**
	 * 合作
	 */
	COOPERATION = 3
}

/**
 * apk包信息
 */
struct TApkInfo {
	/**
	 * 包名
	 */
	1: optional string packageName,

	/**
	 * 版本号
	 */
	2: optional i32 versionCode,

	/**
	 * 版本名
	 */
	3: optional string versionName,

	/**
	 * 文件大小
	 */
	4: optional i64 size
}

/**
 * 应用详细信息
 */
struct TAppDetail {
	/**
	 * 应用标识
	 *
	 * @Id
	 */
	1: optional i64 appId = Type.NULL_LONG,

	/**
	 * 摘要
	 */
	2: optional string summary,

	/**
	 * 详细描述
	 */
	3: optional string description,

	/**
	 * 应用包大小（单位：字节）
	 */
	4: optional i64 size = Type.NULL_LONG,

	/**
	 * 分类（系统分类）
	 */
	5: optional TAppCategory category,

	/**
	 * 版本名称
	 */
	6: optional string version,

	/**
	 * 版本号
	 */
	7: optional i32 versionCode = Type.NULL_INT,

	/**
	 * 开发者
	 */
	8: optional i64 developer = Type.NULL_LONG,

	/**
	 * 提供者
	 */
	9: optional string provider,

	/**
	 * 标签（用户分类）
	 */
	10: optional list<string> tags,

	/**
	 * 设备类型
	 */
	11: optional Standard.TDeviceType deviceType,

	/**
	 * 安装包
	 */
	12: optional FileStore.TFile packFile,

	/**
	 * 截图
	 */
	13: optional list<i64> screenShots,
}

/**
 * 应用详细信息
 */
struct TAppDetailHistory {
	/**
	 * 标识
	 *
	 * @Id
	 */
	1: optional i64 id = Type.NULL_LONG,
	/**
	 * 应用标识
	 *
	 * @Id
	 */
	2: optional i64 appId = Type.NULL_LONG,

	/**
	 * 摘要
	 */
	3: optional string summary,

	/**
	 * 详细描述
	 */
	4: optional string description,

	/**
	 * 应用包大小（单位：字节）
	 */
	5: optional i64 size = Type.NULL_LONG,

	/**
	 * 版本名称
	 */
	6: optional string version,

	/**
	 * 版本号
	 */
	7: optional i32 versionCode = Type.NULL_INT,

	/**
	 * 开发者
	 */
	8: optional i64 developer = Type.NULL_LONG,

	/**
	 * 提供者
	 */
	9: optional string provider,

	/**
	 * 安装包
	 */
	10: optional FileStore.TFile packFile,

	/**
	 * 截图
	 */
	11: optional list<i64> screenShots,
	/**
	 * 安装地址
	 */
	12: optional string installUrl,
	/**
	 * 打开地址
	 */
	13: optional string openUrl,
	/**
	 * 图标
	 */
	14: optional i64 icon = Type.NULL_LONG,
	/**
	 * 版本状态
	 */
	15: optional TAppDetailStatus status
}

/**
 * 应用时间信息
 */
struct TAppTime {
	/**
	 * 应用标识
	 *
	 * @Id
	 */
	1: optional i64 appId = Type.NULL_LONG,

	/**
	 * 创建人
	 */
	2: optional i64 creator = Type.NULL_LONG,

	/**
	 * 创建时间
	 */
	3: optional i64 createTime = Type.NULL_LONG,

	/**
	 * 最后更新人
	 */
	4: optional i64 updator = Type.NULL_LONG,

	/**
	 * 最后更新时间
	 */
	5: optional i64 updateTime = Type.NULL_LONG
}

/**
 * 应用统计信息
 */
struct TAppStat {
	/**
	 * 应用标识
	 *
	 * @Id
	 */
	1: optional i64 appId = Type.NULL_LONG,

	/**
	 * 用户数
	 */
	2: optional i64 userCount = Type.NULL_LONG,

	/**
	 * 访问数
	 */
	3: optional i64 viewCount = Type.NULL_LONG,

	/**
	 * 评分：平均分
	 */
	4: optional i32 ratingAvg = Type.NULL_INT,

	/**
	 * 评分总次数
	 */
	5: optional i32 ratingCount = Type.NULL_INT,

	/**
	 * 我是否已评价，注：仅在存在当前用户上下文时有效（Open API上有效）
	 */
	6: optional bool rated = false
}

/**
 * 应用凭证
 */
struct TApplicationCredential {
	/**
	 * 凭证标识
	 *
	 * @Id
	 */
	1:optional i64 id = Type.NULL_LONG,
	/**
	 * 应用标识
	 */
	2: optional i64 appId = Type.NULL_LONG,

	/**
	 * 应用Key(授权名)
	 *
	 * @Unique
	 */
	3: optional string key,

	/**
	 * 应用密钥
	 */
	4: optional string secret,

	/**
	 * 应用状态
	 */
	5: optional Type.TStatus status
}

/**
 * 应用
 */
struct TApplication {
	/**
	 * 应用标识
	 *
	 * @Id
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 名称
	 */
	2: optional string name,

	/**
	 * 操作系统类型
	 */
	3: optional Standard.TOSType osType,

	/**
	 * 下载安装地址
	 *
	 * 注：根据目标OS区别下载方式
	 */
	4: optional string installUrl,

	/**
	 * 打开地址，外部应用需要提供此信息
	 */
	5: optional string openUrl,

	/**
	 * 图标
	 */
	6: optional i64 icon = Type.NULL_LONG,

	/**
	 * 应用运行类型
	 */
	8: optional TAppRunType runType,

	/**
	 * 应用罗列形式
	 */
	9: optional TAppListType listType;

	/**
	 * 详细信息
	 */
	10: optional TAppDetail detailInfo,

	/**
	 * 时间信息
	 */
	11: optional TAppTime timeInfo,

	/**
	 * 统计信息
	 */
	12: optional TAppStat statInfo,

	/**
	 * 扩展属性
	 */
	13: optional map<string, string> attributes,

	/**
	 * 状态
	 */
	14: optional TApplicationStatus status,

	/**
	 * 角色
	 */
	15: optional set<Identity.TRole> roles,

	/**
	 * 程序标识/代码
	 */
	16: optional string code

	/**
	 * 应用信息标识
	 */
	17: optional i64 appInfoId = Type.NULL_LONG,

	/**
	 * 测试包
	 */
	18: optional i64 testPkg = Type.NULL_LONG,

	/** 
	 * 开放状态
	 */
	19: optional TApplicationOpenStatus openStatus,

	/**
	 * 应用来源
	 */
	20: optional TApplicationSrc appSrc,
	/**
	 * 英文名称
	 */
	21: optional string nameEn

}

/**
 * 应用信息
 */
struct TAppInfo {
	/**
	 * 应用信息标识
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 应用名称
	 */
	2: optional string name,

	/**
	 * 摘要
	 */
	3: optional string summary,

	/**
	 * 详细描述
	 */
	4: optional string description,

	/**
	 * 图标
	 */
	5: optional i64 icon = Type.NULL_LONG,

	/**
	 * 分类（系统分类）
	 */
	6: optional TAppCategory category,

	/**
	 * 级别，控制权限用
	 */
	7: optional TAppLevel level,

	/**
	 * 打开地址
	 */
	8: optional string openUrl,

	/**
	 * 开发者
	 */
	9: optional i64 developer = Type.NULL_LONG,

	/**
	 * 开发者姓名
	 */
	10: optional string developerName,

	/**
	 * 创建时间
	 */
	11: optional i64 createTime = Type.NULL_LONG,

	/**
	 * 更新时间
	 */
	12: optional i64 updateTime = Type.NULL_LONG,

	/**
	 * 状态
	 */
	13: optional TAppInfoStatus status,

	/**
	 * appkey
	 */
	14: optional string key,

	/**
	 * appsecret
	 */
	15: optional string secret,

	/**
	 * 终端应用列表
	 */
	16: optional set<TApplication> apps

}

/**
 * 应用列表
 */
struct TAppList {
	/**
	 * 标识
	 *
	 * @Id
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 名称
	 *
	 * @Unique
	 */
	2: optional string name,

	/**
	 * 描述
	 */
	3: optional string description,

	/**
	 * 状态
	 */
	4: optional Type.TStatus status,

	/**
	 * 顺序
	 */
	5: optional i16 index = Type.NULL_SHORT,

	/**
	 * 应用列表
	 */
	6:optional list<i64> idApps,
	/**
	 * 应用查询关键字
	 */
	7:optional string listKey
}

/**
 * 应用信息选项
 */
struct TAppInfoDataOptions {
	/**
	 * 完整信息
	 */
	1: optional bool all = false,

	/**
	 * 信息
	 */
	2: optional bool application = false
}

/**
 * 应用数据选项
 */
struct TAppDataOptions {
	/**
	 * 完整信息
	 */
	1: optional bool all = false,

	/**
	 * 详细信息
	 */
	2: optional bool detail = false,

	/**
	 * 时间信息
	 */
	3: optional bool time = false,

	/**
	 * 统计信息
	 */
	4: optional bool stat = false,

	/**
	 * 扩展属性
	 */
	5: optional bool attribute = false,

	/**
	 * 角色信息
	 */
	6: optional bool role = false
}

/**
 * 用户应用数据选项
 */
struct TUserAppDataOptions {
	/**
	 * 完整信息
	 */
	1: optional bool all = false,

	/**
	 * 应用数据选项
	 */
	2: optional TAppDataOptions appDataOptions
}

/**
 * 用户应用
 */
struct TUserApplication {
	/**
	 * 用户标识
	 */
	1: optional i64 uid = Type.NULL_LONG,

	/**
	 * 应用标识
	 */
	2: optional TApplication app,

	/**
	 * 桌面号
	 */
	3: optional i16 desktop = Type.NULL_SHORT,

	/**
	 * 桌面内顺序
	 */
	4: optional i16 index = Type.NULL_SHORT,

	/**
	 * 状态
	 */
	5: optional Type.TStatus status
}

/**
 * 用户应用分页
 */
struct TUserApplicationPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TUserApplication> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 应用分页
 */
struct TApplicationPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TApplication> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 应用历史记录分页
 */
struct TAppDetailHistoryPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TAppDetailHistory> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 应用排序
 */
enum TApplicationOrder {
	/**
	 * 默认
	 */
	DEFAULT = 0,

	/**
	 * 创建时间
	 */
	CREATE_TIME = 1,

	/**
	 * 更新时间
	 */
	UPDATE_TIME = 2,

	/**
	 * 用户量
	 */
	USER_COUNT = 3,

	/**
	 * 访问量
	 */
	VIEW_COUNT = 4
}
struct TAppListPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TAppList> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 用户应用查询结构
 */
struct TUserApplicationQuery {
	/**
	 * 关键词，模糊匹配，为空时不作为条件
	 */
	1: optional string keyword,

	/**
	 * 桌面号，为空时不作为条件
	 */
	2: optional set<i16> desktopIds,

	/**
	 * 用户应用的状态集合，为空时不作为条件
	 */
	3: optional set<Type.TStatus> userStatus,

	/**
	 * 系统类型，为空时不作为条件
	 */
	4: optional set<Standard.TOSType> osTypes,

	/**
	 * 应用本身的状态集合，为空时不作为条件
	 */
	5: optional set<Type.TStatus> appStatus,

	/**
	 * 根据用户身份角色进行过滤
	 */
	6: optional bool userRole = false,

	/**
	 * 设备类型，为空时不作为条件，OPEN接口默认为PHONE类型
	 */
	7: optional set<Standard.TDeviceType> deviceTypes,

	/**
	 * 起始位置
	 */
	20: optional i64 offset = Type.NULL_LONG,

	/**
	 * 获取数量
	 */
	21: optional i64 limit = Type.NULL_LONG
}
/**
 * 应用列表查询结构
 */
struct TAppListQuery {
	/**
	 * 关键词，为空时不作为条件
	 */
	1: optional set<string> keyword,

	/**
	 * 列表id集合
	 */
	2: optional set<i64> ids,

	/**
	 * 状态过滤，为空时不作为条件
	 */
	3: set<Type.TStatus> status

	/**
	 * 起始位置
	 */
	4: optional i64 offset = Type.NULL_LONG,

	/**
	 * 获取数量
	 */
	5: optional i64 limit = Type.NULL_LONG
}

/**
 * 应用查询结构
 */
struct TApplicationQuery {
	/**
	 * 关键词，模糊匹配，为空时不作为条件
	 */
	1: optional string keyword,

	/**
	 * 分类，为空时不作为条件
	 */
	2: optional set<i64> catIds,

	/**
	 * 系统类型，为空时不作为条件
	 */
	3: optional set<Standard.TOSType> osTypes,

	/**
	 * 视图运行类型，为空时不作为条件
	 */
	4: optional set<TAppRunType> runTypes,

	/**
	 * 罗列类型，为空不作为条件
	 */
	5: optional set<TAppListType> listTypes,

	/**
	 * 开发者，为空时不作为条件
	 */
	6: optional set<i64> developers,

	/**
	 * 安装包大小，为空时不作为条件，列表数为1时用>匹配，列表数>=2用between匹配
	 */
	7: optional list<i64> sizes,

	/**
	 * 标签，为空时不作为条件
	 */
	8: optional set<string> tags,

	/**
	 * 设备类型，为空时不作为条件
	 */
	9: optional set<Standard.TDeviceType> deviceTypes,

	/**
	 * 创建时间，列表为空时不作为条件，列表数为1时用>匹配，列表数为>=2时用between匹配
	 */
	10: optional list<i64> createTimes,

	/**
	 * 更新时间，列表为空时不作为条件，列表数为1时用>匹配，列表数为>=2时用between匹配
	 */
	11: optional list<i64> updateTimes,

	/**
	 * 用户数，列表为空时不作为条件，列表数为1时用>匹配，列表数为>=2时用between匹配
	 */
	12: optional list<i64> userCount,

	/**
	 * 访问数，列表为空时不作为条件，列表数为1时用>匹配，列表数为>=2时用between匹配
	 */
	13: optional list<i64> viewCount,

	/**
	 * 状态
	 */
	14: optional set<TApplicationStatus> status,

	/**
	 * 角色标识，为空时不作为过滤条件
	 */
	15: optional set<i64> roleIds,

	/**
	 * 排序，为空时默认排序
	 */
	19: optional list<TApplicationOrder> orders,

	/**
	 * 起始位置
	 */
	20: optional i64 offset = Type.NULL_LONG,

	/**
	 * 获取数量
	 */
	21: optional i64 limit = Type.NULL_LONG,
	/**
	 * 应用所属列表
	 */
	22: optional set<i64> listIds,
	/**
	 * 所属列表关键字
	 */
	23: optional set<string> keyLists,
	/**
	 * 需要排除的应用
	 */
	24: optional set<i64> excludeIds,

	/**
	 * 应用信息标识
	 */
	25: optional set<i64> appInfoIds,

	/**
	 * 开放状态
	 */
	26: optional set<TApplicationOpenStatus> openStatus,

	/**
	 * 应用来源
	 */
	27: optional set<TApplicationSrc> appSrcs

}
/**
 * 应用详情查询结构
 */
struct TAppDetailHistoryQuery {
	/**
	 * 应用id，为空时不作为条件
	 */
	1: optional set<i64> idApp,

	/**
	 * 关键词，模糊匹配，为空时不作为条件
	 */
	2: optional string keyword,

	/**
	 * 开发者，为空时不作为条件
	 */
	3: optional set<i64> developers,

	/**
	 * 安装包大小，为空时不作为条件，列表数为1时用>匹配，列表数>=2用between匹配
	 */
	4: optional list<i64> sizes,

	/**
	 * 标签，为空时不作为条件
	 */
	5: optional set<string> tags,

	/**
	 * 起始位置
	 */
	6: optional i64 offset = Type.NULL_LONG,

	/**
	 * 获取数量
	 */
	7: optional i64 limit = Type.NULL_LONG,
	/**
	 * 状态
	 */
	8: optional set<TAppDetailStatus> detailStatus
}

/**
 * 应用审核结果
 */
enum TAppApproveResult {
	/**
	 * 待审核
	 */
	TODO = 0,

	/**
	 * 审核通过
	 */
	PASSED = 1,

	/**
	 * 审核不通过
	 */
	REJECTED = 2
}

/**
 * 应用申请类型
 */
enum TAppApplyType {
	/**
	 * 开放平台申请
	 */
	NORMAL = 1,

	/**
	 * 上架申请
	 */
	ONSALE = 2,

	/**
	 * 下架申请
	 */
	OFFSALE = 3,

}

/**
 * 应用申请排序
 */
enum TAppApplyOrder {
	/**
	 * 默认
	 */
	DEFAULT = 0,
	/**
	 * 申请时间升序
	 */
	APPLY_TIME_ASC = 1,
	/**
	 * 申请时间降序
	 */
	APPLY_TIME_DESC = 2,
	/**
	 * 审核时间升序
	 */
	APPROVE_TIME_ASC = 3,
	/**
	 * 审核时间降序
	 */
	APPROVE_TIME_DESC = 4
}

/**
 * 应用升级申请排序
 */
enum TAppUpgradeApplyOrder {
	/**
	 * 默认
	 */
	DEFAULT = 0,
	/**
	 * 申请时间升序
	 */
	APPLY_TIME_ASC = 1,
	/**
	 * 申请时间降序
	 */
	APPLY_TIME_DESC = 2,
	/**
	 * 审核时间升序
	 */
	APPROVE_TIME_ASC = 3,
	/**
	 * 审核时间降序
	 */
	APPROVE_TIME_DESC = 4
}

/**
 * 应用申请
 */
struct TAppApply {
	/**
	 * 标识（只读）
	 *
	 *@id
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 应用标识
	 */
	2: optional i64 appId = Type.NULL_LONG,

	/**
	 * 应用名称（只读）
	 */
	3: optional string appName,

	/**
	 * 简介（只读）
	 */
	4: optional string appDesc,

	/**
	 * 图标 （只读）
	 */
	5: optional i64 appIcon = Type.NULL_LONG,

	/**
	 * 操作系统
	 */
	6: optional Standard.TOSType osType,

	/**
	 * 当前版本
	 */
	7: optional string currentVersion,

	/**
	 * 测试包
	 */
	8: optional i64 testPkg = Type.NULL_LONG,

	/**
	 * 申请类型
	 */
	9: optional TAppApplyType applyType,

	/**
	 * 申请内容
	 */
	10: optional string applyContent,

	/**
	 * 申请人（只读）
	 */
	11: optional i64 proposer = Type.NULL_LONG,

	/**
	 * 申请人姓名
	 */
	12: optional string proposerName,

	/**
	 * 申请时间（只读）
	 */
	13: optional i64 applyTime = Type.NULL_LONG,

	/**
	 * 审核结果
	 */
	14: optional TAppApproveResult approveResult,

	/**
	 * 审核意见
	 */
	15: optional string approveOpinion,

	/**
	 * 审核人（只读）
	 */
	16: optional i64 approver = Type.NULL_LONG,

	/**
	 * 审核人名称（只读）
	 */
	17: optional string approverName,

	/**
	 * 审核时间（只读）
	 */
	18: optional i64 approveTime = Type.NULL_LONG
}

/**
 * 应用升级申请
 */
struct TAppUpgradeApply {
	/**
	 * 标识（只读）
	 *
	 *@id
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 应用标识
	 */
	2: optional i64 appId = Type.NULL_LONG,

	/**
	 * 应用名称（只读）
	 */
	3: optional string appName,

	/**
	 * 简介（只读）
	 */
	4: optional string appDesc,

	/**
	 * 图标 （只读）
	 */
	5: optional i64 appIcon = Type.NULL_LONG,

	/**
	 * 应用版本（只读）
	 */
	6: optional string version,

	/**
	 * 安装地址
	 */
	7: optional string installUrl,

	/**
	 * 操作系统类型
	 */
	8: optional Standard.TOSType ostype,

	/**
	 * 申请内容
	 */
	9: optional string applyContent,

	/**
	 * 申请人（只读）
	 */
	10: optional i64 proposer = Type.NULL_LONG,

	/**
	 * 申请人姓名
	 */
	11: optional string proposerName,

	/**
	 * 申请时间（只读）
	 */
	12: optional i64 applyTime = Type.NULL_LONG,

	/**
	 * 审核结果
	 */
	13: optional TAppApproveResult approveResult,

	/**
	 * 审核意见
	 */
	14: optional string approveOpinion,

	/**
	 * 审核人（只读）
	 */
	15: optional i64 approver = Type.NULL_LONG,

	/**
	 * 审核人名称（只读）
	 */
	16: optional string approverName,

	/**
	 * 审核时间（只读）
	 */
	17: optional i64 approveTime = Type.NULL_LONG
}

/**
 * 应用级别申请
 */
struct TAppLevelApply {
	/**
	 * 标识（只读）
	 *
	 *@id
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 应用标识
	 */
	2: optional i64 appInfoId = Type.NULL_LONG,

	/**
	 * 应用名称（只读）
	 */
	3: optional string appName,

	/**
	 * 简介（只读）
	 */
	4: optional string appDesc,

	/**
	 * 图标 （只读）
	 */
	5: optional i64 appIcon = Type.NULL_LONG,

	/**
	 * 原级别
	 */
	6: optional TAppLevel orgLevel,

	/**
	 * 申请级别
	 */
	7: optional TAppLevel applyLevel,

	/**
	 * 申请内容
	 */
	8: optional string applyContent,

	/**
	 * 申请人（只读）
	 */
	9: optional i64 proposer = Type.NULL_LONG,

	/**
	 * 申请人姓名
	 */
	10: optional string proposerName,

	/**
	 * 申请时间（只读）
	 */
	11: optional i64 applyTime = Type.NULL_LONG,

	/**
	 * 审核结果
	 */
	12: optional TAppApproveResult approveResult,

	/**
	 * 审核意见
	 */
	13: optional string approveOpinion,

	/**
	 * 审核人（只读）
	 */
	14: optional i64 approver = Type.NULL_LONG,

	/**
	 * 审核人名称（只读）
	 */
	15: optional string approverName,

	/**
	 * 审核时间（只读）
	 */
	16: optional i64 approveTime = Type.NULL_LONG
}

/**
 * 应用信息申请
 */
struct TAppInfoApply {
	/**
	 * 标识（只读）
	 *
	 *@id
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 应用信息标识
	 */
	2: optional i64 appInfoId = Type.NULL_LONG,

	/**
	 * 应用名称（只读）
	 */
	3: optional string appName,

	/**
	 * 简介（只读）
	 */
	4: optional string appDesc,

	/**
	 * 图标（只读）
	 */
	5: optional i64 appIcon = Type.NULL_LONG,

	/**
	 * 申请内容
	 */
	6: optional string applyContent,

	/**
	 * 申请人（只读）
	 */
	7: optional i64 proposer = Type.NULL_LONG,

	/**
	 * 申请人姓名
	 */
	8: optional string proposerName,

	/**
	 * 申请时间（只读）
	 */
	9: optional i64 applyTime = Type.NULL_LONG,

	/**
	 * 审核结果
	 */
	10: optional TAppApproveResult approveResult,

	/**
	 * 审核意见
	 */
	11: optional string approveOpinion,

	/**
	 * 审核人（只读）
	 */
	12: optional i64 approver = Type.NULL_LONG,

	/**
	 * 审核人名称（只读）
	 */
	13: optional string approverName,

	/**
	 * 审核时间（只读）
	 */
	14: optional i64 approveTime = Type.NULL_LONG
}

/**
 * 应用申请分页
 */
struct TAppApplyPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TAppApply> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 应用升级申请分页
 */
struct TAppUpgradeApplyPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TAppUpgradeApply> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 应用级别申请分页
 */
struct TAppLevelApplyPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TAppLevelApply> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 应用申请查询结构
 */
struct TAppApplyQuery {
	/**
	 * 申请类型
	 */
	1: optional set<TAppApplyType> types,

	/**
	 * 申请结果
	 */
	2: optional set<TAppApproveResult> results,

	/**
	 * 应用名称（模糊）
	 */
	3: optional string appName,

	/**
	 * 操作系统类型
	 */
	4: optional set<Standard.TOSType> osTypes,

	/**
	 * 申请者姓名（模糊）
	 */
	5: optional string proposerName,

	/**
	 * 申请时间段
	 */
	6: optional list<i64> applyTimes,

	/**
	 * 审核人姓名（模糊）
	 */
	7: optional string approverName,

	/**
	 * 审核时间段
	 */
	8: optional list<i64> approveTimes,

	/**
	 * 应用标识
	 */
	9: optional set<i64> appIds,

	/**
	 * 起始位置
	 */
	10: optional i64 offset = Type.NULL_LONG,

	/**
	 * 获取数量
	 */
	11: optional i64 limit = Type.NULL_LONG,

	/**
	 * 排序
	 */
	12: list<TAppApplyOrder> order
}

/**
 * 应用升级申请查询结构
 */
struct TAppUpgradeApplyQuery {
	/**
	 * 审批结果
	 */
	1: optional set<TAppApproveResult> results,

	/**
	 * 应用名称（模糊）
	 */
	2: optional string appName,

	/**
	 * 应用版本
	 */
	3: optional string version,

	/**
	 * 操作系统
	 */
	4: optional set<Standard.TOSType> osTypes,

	/**
	 * 申请者姓名（模糊）
	 */
	5: optional string proposerName,

	/**
	 * 申请时间段
	 */
	6: optional list<i64> applyTimes,

	/**
	 * 审核人姓名（模糊）
	 */
	7: optional string approverName,

	/**
	 * 审核时间段
	 */
	8: optional list<i64> approveTimes,

	/**
	 * 起始位置
	 */
	9: optional i64 offset = Type.NULL_LONG,

	/**
	 * 获取数量
	 */
	10: optional i64 limit = Type.NULL_LONG,

	/**
	 * 排序
	 */
	11: list<TAppApplyOrder> order
}

/**
 * 应用级别申请查询结构
 */
struct TAppLevelApplyQuery {
	/**
	 * 应用信息标识
	 */
	1: optional i64 appInfoId,

	/**
	 * 申请结果
	 */
	2: optional set<TAppApproveResult> results,

	/**
	 * 应用名称（模糊）
	 */
	3: optional string appName,

	/**
	 * 申请级别
	 */
	4: optional set<TAppLevel> applyLevels,

	/**
	 * 申请者姓名（模糊）
	 */

	5: optional string proposerName,

	/**
	 * 申请时间段
	 */
	6: optional list<i64> applyTimes,

	/**
	 * 审核人姓名（模糊）
	 */
	7: optional string approverName,

	/**
	 * 审核时间段
	 */
	8: optional list<i64> approveTimes,

	/**
	 * 起始位置
	 */
	9: optional i64 offset = Type.NULL_LONG,

	/**
	 * 获取数量
	 */
	10: optional i64 limit = Type.NULL_LONG,

	/**
	 * 排序
	 */
	11: list<TAppApplyOrder> order
}

enum TAppInfoOrder {
	/**
	 * 默认
	 */
	DEFAULT = 0,

	/**
	 * 创建时间
	 */
	CREATE_TIME_ASC = 1,

	/**
	 * 创建时间
	 */
	CREATE_TIME_DESC = 2,

	/**
	 * 更新时间
	 */
	UPDATE_TIME_ASC = 3,

	/**
	 * 更新时间
	 */
	UPDATE_TIME_DESC = 4

}

/**
 * 应用信息查询结构
 */
struct TAppInfoQuery {
	/**
	 * 名称
	 */
	1: optional string name,

	/**
	 * 应用类别
	 */
	2: optional set<TAppCategory> categorys,

	/**
	 * 应用级别
	 */
	3: optional set<TAppLevel> levels,

	/**
	 * 开发者标识
	 */
	4: optional i64 developerId = Type.NULL_LONG,

	/**
	 * 开发者姓名（模糊）
	 */
	5: optional string developerName,

	/**
	 * 创建时间段
	 */
	6: optional list<i64> createTimes,

	/**
	 * 更新时间段
	 */
	7: optional list<i64> updateTimes,

	/**
	 * 起始位置
	 */
	8: optional i64 offset = Type.NULL_LONG,

	/**
	 * 获取数量
	 */
	9: optional i64 limit = Type.NULL_LONG,

	/**
	 * 排序
	 */
	10: list<TAppInfoOrder> order
}

/**
 * 应用信息分页
 */
struct TAppInfoPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TAppInfo> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 应用信息申请查询结构
 */
struct TAppInfoApplyQuery {
	/**
	 * 申请结果
	 */
	1: optional set<TAppApproveResult> results,

	/**
	 * 应用名称（模糊）
	 */
	2: optional string appName,

	/**
	 * 申请者姓名（模糊）
	 */

	3: optional string proposerName,

	/**
	 * 申请时间段
	 */
	4: optional list<i64> applyTimes,

	/**
	 * 审核人姓名（模糊）
	 */
	5: optional string approverName,

	/**
	 * 审核时间段
	 */
	6: optional list<i64> approveTimes,

	/**
	 * 起始位置
	 */
	7: optional i64 offset = Type.NULL_LONG,

	/**
	 * 获取数量
	 */
	8: optional i64 limit = Type.NULL_LONG,

	/**
	 * 排序
	 */
	9: list<TAppApplyOrder> order
}

/**
 * 应用信息申请分页
 */
struct TAppInfoApplyPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TAppInfoApply> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 应用管理
 */
service TApplicationService {
	/*
	 * ====================应用====================
	 */

	/**
	 * 创建应用
	 *
	 * @return 应用标识
	 */
	i64 createApp(
			/**
			 * 应用
			 */
			1: TApplication app,

			/**
			 * 应用数据选项
			 */
			2: TAppDataOptions options,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 703 缺少应用代码和系统类型
			 * @error 704 应用代码和系统类型重复
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量创建应用
	 *
	 * @return 应用标识列表，顺序与参数apps对应
	 */
	list<i64> mcreateApps(
			/**
			 * 应用列表
			 */
			1: list<TApplication> apps,

			/**
			 * 应用数据选项
			 */
			2: TAppDataOptions options,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 703 缺少应用代码和系统类型
			 * @error 704 应用代码和系统类型重复
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取应用
	 *
	 * @return 应用
	 */
	TApplication getApp(
			/**
			 * 应用标识
			 */
			1: i64 id,
			/**
			 * 应用数据选项
			 */
			2: TAppDataOptions options
	) throws (
			/**
			 * @error 701 应用不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取应用，根据code
	 *
	 * @return 应用
	 */
	set<TApplication> getAppsByCode(
			/**
			 * 应用code
			 */
			1: string code,
			/**
			 * 应用数据选项
			 */
			2: TAppDataOptions options
	) throws (
			/**
			 * @error 701 应用不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取应用
	 *
	 * @return 标识-应用 映射表
	 */
	map<i64, TApplication> mgetApps(
			/**
			 * 应用标识集合
			 */
			1: set<i64> ids,
			/**
			 * 应用数据选项
			 */
			2: TAppDataOptions options
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取应用，根据code
	 *
	 * @return code-应用 映射表
	 */
	map<string, set<TApplication>> mgetAppsByCode(
			/**
			 * 应用code集合
			 */
			1: set<string> codes,
			/**
			 * 应用数据选项
			 */
			2: TAppDataOptions options
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新应用
	 *
	 */
	void updateApp(
			/**
			 * 应用
			 */
			1: TApplication app,

			/**
			 * 应用数据选项
			 */
			2: TAppDataOptions options,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 701 应用不存在
			 */
			1: Type.TSccException ex
	),
	/**
	 * 升级应用
	 *
	 */
	void upgradeApp(
			/**
			 * 应用升级信息
			 */
			1: TAppDetailHistory detailHistory,

			/**
			 * 操作人标识
			 */
			2: i64 submitter
	) throws (
			/**
			 * @error 701 应用不存在
			 */
			1: Type.TSccException ex
	),
	/**
	 * 保存升级记录
	 *
	 */
	void saveAppHis(
			/**
			 * 应用升级信息
			 */
			1: TAppDetailHistory detailHistory,

			/**
			 * 操作人标识
			 */
			2: i64 submitter
	) throws (
			/**
			 * @error 701 应用不存在
			 */
			1: Type.TSccException ex
	),
	/**
	 * 查询升级记录
	 *
	 */
	TAppDetailHistory queryAppHistory(
			/**
			 * 应用标志
			 */
			1: i64 idApp,

			/**
			 * 版本
			 */
			2: string version,
			/**
			 * 版本名称
			 */
			3: i32 versionCode,
			/**
			 * 版本编号
			 */
			4:i32 idHidtory
	) throws (
			/**
			 * @error 701 应用不存在
			 */
			1: Type.TSccException ex
	),
	/**
	 * 回退应用
	 *
	 */
	void backVersionApp(
			/**
			 * 应用
			 */
			1: i64 idApp,
			/**
			 * 应用历史版本号
			 */
			2: i64 idHistory,
			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 701 应用不存在
			 */
			1: Type.TSccException ex
	),
	/**
	 * 版本历史记录
	 *
	 */
	TAppDetailHistoryPage appHistoryList(
			/**
			 * 应用
			 */
			1: TAppDetailHistoryQuery historyQuery
	) throws (
			/**
			 * @error 701 应用不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量更新应用
	 *
	 */
	void mupdateApps(
			/**
			 * 应用列表
			 */
			1: list<TApplication> apps,

			/**
			 * 应用数据选项
			 */
			2: TAppDataOptions options,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 701 应用不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新应用状态
	 */
	void updateAppStatus(
			/**
			 * 应用标识
			 */
			1: i64 id,

			/**
			 * 状态
			 */
			2: TApplicationStatus status,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 701 应用不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新应用状态
	 */
	void mupdateAppStatus(
			/**
			 * 应用标识
			 */
			1: map<i64, TApplicationStatus> status,

			/**
			 * 操作人标识
			 */
			2: i64 submitter
	) throws (
			/**
			 * @error 701 应用不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 应用查询
	 *
	 * @return 应用分页数据
	 */
	TApplicationPage queryApplications(
			/**
			 * 应用查询参数
			 */
			1: TApplicationQuery query,

			/**
			 * 应用数据选项
			 */
			2: TAppDataOptions options,
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 提交应用申请
	 * @param		apply	申请对象
	 * @param		appId	应用标识
	 * @Param		Proposer	申请人标识
	 * @return 无
	 */
	void submitAppApply(
			/**
			 * 应用申请
			 */
			1: TAppApply apply,

			/**
			 * 应用标识
			 */
			2: i64 appId

			/**
			 * 申请人标识
			 */
			3: i64 proposer
	) throws (
			/**
			 * @error	713	申请人不存在
			 * @error	701	应用不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 应用审核
	 */
	void appApprove(
			/**
			 * 应用申请标识
			 */
			1: i64 id,

			/**
			 * 审核结果
			 */
			2: TAppApproveResult result,

			/**
			 * 审核意见
			 */
			3: string opinion,

			/**
			 * 审核人员
			 */
			4: i64 approver
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取应用申请
	 */
	TAppApply getAppApply(
			/**
			 * 应用申请标识
			 */
			1: i64 id
	) throws (
			/**
			 * @error 705 应用申请不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 提交应用升级申请
	 */
	void submitAppUpgradeApply(
			/**
			 * 应用升级申请
			 */
			1: TAppUpgradeApply apply,

			/**
			 * 应用版本标识
			 */
			2: i64 detailId

			/**
			 * 申请人
			 */
			3: i64 proposer
	) throws (
			/**
			 *
			 */
			1: Type.TSccException ex
	),

	/**
	 * 应用升级审核
	 */
	void appUpgradeApprove(
			/**
			 * 应用升级申请标识
			 */
			1: i64 id,

			/**
			 * 审核结果
			 */
			2: TAppApproveResult result,

			/**
			 * 审核意见
			 */
			3: string opinion,

			/**
			 * 审核人员
			 */
			4: i64 approver
	) throws (
			/**
			 * @error 716 应用升级申请不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取应用升级申请
	 */
	TAppUpgradeApply getAppUpgradeApply (
			/**
			 * 应用升级申请标识
			 */
			1: i64 id
	) throws (
			/**
			 * @error 716 应用升级申请不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 提交应用级别申请
	 */
	void submitAppLevelApply(
			/**
			 * 应用级别申请
			 */
			1: TAppLevelApply apply,

			/**
			 * 应用信息标识
			 */
			2: i64 appInfoId

			/**
			 * 申请人标识
			 */
			3: i64 proposer
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 应用级别审核
	 */
	void appLevelApprove(
			/**
			 * 应用申请标识
			 */
			1: i64 id,

			/**
			 * 审核结果
			 */
			2: TAppApproveResult result,

			/**
			 * 审核意见
			 */
			3: string opinion,

			/**
			 * 审核人员
			 */
			4: i64 approver
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取应用级别申请
	 */
	TAppLevelApply getAppLevelApply(
			/**
			 * 应用级别申请标识
			 */
			1: i64 id
	) throws (
			/**
			 * @error  应用级别申请不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 查询应用申请
	 */
	TAppApplyPage queryAppApply (
			/**
			 * 应用申请查询，为空时不作为条件
			 */
			1: TAppApplyQuery query
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 查询应用升级申请
	 */
	TAppUpgradeApplyPage queryAppUpgradeApply (
			/**
			 * 应用升级申请查询，为空时不作为条件
			 */
			1: TAppUpgradeApplyQuery query
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 查询应用级别申请
	 */
	TAppLevelApplyPage queryAppLevelApply (
			/**
			 * 应用级别申请查询，为空时不作为条件
			 */
			1: TAppLevelApplyQuery query
	)throws (
			/**
			 *
			 */
			1: Type.TSccException ex
	),

	/**
	 * 创建应用信息
	 */
	void createAppInfo (
			/**
			 * 应用信息
			 */
			1: TAppInfo appInfo,

			/**
			 * 开发者
			 */
			2: i64 developer
	) throws (
			/**
			 *
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新应用信息
	 */
	void updateAppInfo (
			/**
			 * 应用信息
			 */
			1: TAppInfo appInfo,

			/**
			 * 开发者
			 */
			2: i64 developer
	) throws (
			/**
			 *
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取应用信息
	 */
	TAppInfo getAppInfo (
			/**
			 * 应用信息标识
			 */
			1: i64 id
	) throws (
			/**
			 *
			 */
			1: Type.TSccException ex
	),

	/**
	 * 查询应用信息
	 */
	TAppInfoPage queryAppInfo (
			/**
			 * 应用信息查询结构
			 */
			1: TAppInfoQuery query,

			/**
			 *应用信息数据选项
			 */
			2: TAppInfoDataOptions options
	) throws (
			/**
			 *
			 */
			1: Type.TSccException ex
	),

	/**
	 * 提交应用信息申请
	 */
	void submitAppInfoApply(
			/**
			 * 应用级别申请
			 */
			1: TAppInfoApply apply,

			/**
			 * 应用信息标识
			 */
			2: i64 appInfoId

			/**
			 * 申请人标识
			 */
			3: i64 proposer
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 应用信息审核
	 */
	void appInfoApprove(
			/**
			 * 应用申请标识
			 */
			1: i64 id,

			/**
			 * 审核结果
			 */
			2: TAppApproveResult result,

			/**
			 * 审核意见
			 */
			3: string opinion,

			/**
			 * 审核人员
			 */
			4: i64 approver
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 查询应用信息申请
	 */
	TAppInfoApplyPage queryAppInfoApply (
			/**
			 * 应用信息查询结构
			 */
			1: TAppInfoApplyQuery query
	) throws (
			/**
			 *
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取应用信息申请
	 */
	TAppInfoApply getAppInfoApply(
			/**
			 * 应用信息申请标识
			 */
			1: i64 id
	) throws (
			/**
			 * @error  应用信息申请不存在
			 */
			1: Type.TSccException ex
	),

	/*
	 * ====================用户应用====================
	 */

	/**
	 * 添加用户应用
	 *
	 * 注：如果用户列表中已存在，则更新状态为TStatus.ENABLED，否则添加用户应用（状态默认为TStatus.ENABLED）
	 */
	void addUserApplications(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 应用标识集合
			 */
			2: set<i64> appIds
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 移除用户应用
	 *
	 * 注：标识用户应用状态为TStatus.DELETED
	 */
	void removeUserApplications(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 应用标识集合
			 */
			2: set<i64> appIds
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 用户应用位置排序
	 */
	void orderUserApplications(
			/**
			 * 用户表示
			 */
			1: i64 uid,

			/**
			 * 用户桌面应用位置信息
			 *
			 * 注：结构为，map<用户桌面号, map<应用标识, 顺序号>>
			 */
			2: map<i16, map<i64, i16>> orders
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 将应用直接推送到用户桌面（用户范围取决于应用的角色定义）
	 */
	oneway void pushAppsToUserDesktop(
			/**
			 * 需要推送的应用标识集合
			 */
			1: set<i64> appIds
	),

	/**
	 * 用户应用查询
	 *
	 * 注：仅返回该用户角色范围内，并且为已上线状态的应用
	 *
	 * @return 用户应用分页
	 */
	TUserApplicationPage queryUserApplications(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 用户应用查询结构
			 */
			2: TUserApplicationQuery query,

			/**
			 * 应用数据选项
			 */
			3: TUserAppDataOptions options,
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 点击应用，可以累积一定数量后一次性提交
	 */
	oneway void hitApp(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 应用标识-时间戳 映射表
			 *
			 * 注：结构，map<应用标识, 时间戳(毫秒)>
			 */
			2: map<i64, i64> idTimes
	),

	/**
	 * 点击应用URL，可以累积一定数量后一次性提交
	 */
	oneway void hitAppByUrl(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 应用URL-时间戳 映射表
			 *
			 * 注：结构，map<应用标识, 时间戳(毫秒)>
			 */
			2: map<string, i64> idTimes,
			/**
			 * 操作系统类型
			 */
			3: optional Standard.TOSType osType
	),
	/**
	 * 根据应用URL查找应用
	 */
	TApplication getAppByUrl(
			/**
			 * 应用URL
			 */
			1: string openUrl,
			/**
			 *操作系统类型
			 */
			2: Standard.TOSType osType
	),
	/**
	 * 下载应用，可以累积一定数量后一次性提交
	 */
	oneway void downApp(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 应用标识-时间戳 映射表
			 *
			 * 注：结构，map<应用标识, 时间戳(毫秒)>
			 */
			2: map<i64, i64> idTimes,
	),

	/**
	 * 应用评分
	 */
	void ratingApp(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 应用标识-评分分值 映射表
			 *
			 * 注：结构，map<应用标识, 评分分值>
			 */
			2: map<i64, i32> idScores,
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/*
	 * ====================分类====================
	 */

	/**
	 * 创建分类
	 *
	 * @return 分类标识
	 */
	i64 createAppCategory(
			/**
			 * 分类
			 */
			1: TAppCategory cat
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取分类
	 *
	 * @return 分类
	 */
	TAppCategory getAppCategory(
			/**
			 * 标识
			 */
			1: i64 id
	)throws (
			/**
			 * @error 702 应用分类不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取分类
	 *
	 * @return 标识-分类 映射表
	 */
	map<i64, TAppCategory> mgetAppCategory(
			/**
			 * 标识集合
			 */
			1: set<i64> ids
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新分类
	 */
	void updateAppCategory(
			/**
			 * 分类
			 */
			1: TAppCategory cat
	)throws (
			/**
			 * @error 702 应用分类不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新状态
	 */
	void updateAppCategoryStatus(
			/**
			 * 分类标识-状态 映射表
			 */
			1: map<i64, Type.TStatus> status
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新分类
	 */
	void updateAppCategoryIndex(
			/**
			 * 分类标识-状态 映射表
			 */
			1: map<i64, i16> index
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),
	
	/**
	 * 检测分类名称是否存在
	 */
	bool isAppCategoryNameExist(
			/**
			 * 分类
			 */
			1: TAppCategory cat
	),

	/**
	 * 获取分类列表
	 *
	 * @return 分类列表
	 */
	list<TAppCategory> listAppCategory(
			/**
			 * 关键词过滤，为空时不作为条件
			 */
			1: string keywords,

			/**
			 * 状态过滤，为空时不作为条件
			 */
			2: set<Type.TStatus> status
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),
	list<TAppList> listAppList(
			/**
			 * 关键词过滤，为空时不作为条件
			 */
			1: set<string> keywords
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 根据应用的key和secret，创建动态token，token默认有效期为一个月
	 * 建议应用存储此token,在token失效时(或定期)再次调用此方法获取新token.
	 */
	string refreshAccessToken(
			/**
			 * 应用key
			 */
			1:string key,

			/**
			 * 应用secret
			 */
			2:string secret
	) throws (
			/**
			 * @error 705  被禁用的凭证
			 * @error 706  无效app凭证
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取应用凭证
	 *
	 * @return 应用凭证
	 */
	TApplicationCredential getAppCredentialByToken(
			/**
			 * app token
			 */
			1: string appToken,
	)throws (
			/**
			 * @error 705 被禁用的凭证
			 * @error 706 无效app凭证
			 */
			1: Type.TSccException ex
	),

	/**
	 * 创建应用凭证
	 *
	 * @return 应用凭证
	 */
	TApplicationCredential createAppCredential(
			/**
			 * idApp 应用标识
			 */
			1:i64 idApp
	)throws(
			/**
			 * @error 701  应用不存在
			 * @error 708 生成appKey失败
			 * @error 709  应用的凭证已经存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 重置secret
	 *
	 * @return 应用凭证
	 */
	TApplicationCredential resetAppSecret(
			/**
			 * idApp 应用标识
			 */
			1:i64 idApp
	)throws(
			/**
			 * @error 710  应用的凭证不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 修改应用凭证状态
	 *
	 * @return 应用凭证
	 */
	TApplicationCredential updateAppCredStatus(
			/**
			 * idApp 应用标识
			 */
			1:i64 idApp,
			/**
			 * 应用凭证状态
			 */
			2:Type.TStatus status
	)throws(
			/**
			 * @error 710  应用的凭证不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取应用凭证，根据应用标识
	 *
	 * @return 应用标识-应用凭证 映射表
	 */
	map<i64, TApplicationCredential> mgetAppCredentials(
			/**
			 * 应用标识集合
			 */
			1: set<i64> appIds
	)throws(
			1: Type.TSccException ex
	),
	/*
	 * ====================应用列表====================
	 */

	/**
	 * 创建应用列表
	 *
	 * @return 应用列表标识
	 */
	i64 createAppList(
			/**
			 * 列表
			 */
			1: TAppList appList
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取应用列表详情
	 *
	 * @return 应用列表
	 */
	TAppList getAppList(
			/**
			 * 应用列表标识
			 */
			1: i64 id
	)throws (
			/**
			 * @error 702 应用分类不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新应用列表
	 */
	void updateAppList(
			/**
			 * 应用列表
			 */
			1: TAppList appList
	)throws (
			/**
			 * @error 702 应用分类不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新应用列表状态
	 */
	void updateAppListStatus(
			/**
			 * 分类标识-状态 映射表
			 */
			1: map<i64, Type.TStatus> status
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取应用列表分页数据
	 *
	 * @return 列表数据
	 */
	TAppListPage queryAppList(
			/**
			 * 应用列表查询，为空时不作为条件
			 */
			1: TAppListQuery query
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),
	/**
	 * 删除应用列表
	 *
	 */
	void removeAppList(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 应用标识集合
			 */
			2: set<i64> appListIds
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),
	/**
	 * 保存应用详情截图
	 *
	 */
	void saveAppScreenShot(
			1: i64 idApp,
			2: set<i64> idFiles
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),
	/**
	 * 查询应用详情截图
	 *
	 */
	list<i64> queryAppScreenShot(
			1: i64 idApp
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),
	/**
	 * 同步应用点击统计结果
	 *
	 */
	void syncAppStat(
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取apk包信息
	 */
	TApkInfo getApkInfo (
			/**
			 * 文件标识
			 */
			1: i64 fileId
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 重置应用secret
	 */
	void resetAppInfoSecret(
			1: i64 appInfoId
	)throws(
			1: Type.TSccException ex
	),

	/**
	 * 名称和系统类型是否存在
	 * 
	 */
	bool isAppNameExist(
			/**
			 * 应用信息
			 */
			1: TApplication app
	)throws (
			/**
			 * 
			 */
			1: Type.TSccException ex
	),

	/**
	 * CODE和系统类型是否存在
	 */
	bool isAppCodeExist(
			/**
			 * 应用信息
			 */
			1: TApplication app
	)throws (
			/**
			 * 
			 */
			1: Type.TSccException ex
	),
	
	/**
	 * 删除应用（标记删除）.
	 */
	bool deleteApp(
	       /**
	        * 应用ID.
	        */
	       1: i64 idApp
	)throws (
            /**
             * 
             */
           1: Type.TSccException ex
    )
}

