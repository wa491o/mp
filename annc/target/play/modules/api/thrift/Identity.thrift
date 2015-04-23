/*
 * 身份服务
 *
 * 异常号段：200~299
 */

include "Type.thrift"
include "Standard.thrift"

namespace java com.wisorg.scc.api.internal.identity
namespace js Identity
namespace cocoa Identity

/**
 * 用户属性：接收推送消息
 */
const string USER_ATTR_KEY_RECV_PUSH = "RECV_PUSH";

/**
 * 用户属性：接收夜间推送消息
 */
const string USER_ATTR_KEY_RECV_NIGHT_PUSH = "RECV_NIGHT_PUSH";

/**
 * 用户属性：接收公告消息
 */
const string USER_ATTR_KEY_RECV_ANNC = "RECV_ANNC";
/**
 * 用户属性：接收新闻消息
 */
const string USER_ATTR_KEY_RECV_NEWS = "RECV_NEWS";
/**
 * 用户属性：接收校历消息
 */
const string USER_ATTR_KEY_RECV_CALENDAR = "RECV_CALENDAR";

/**
 * 用户属性：接收校园互助消息
 */
const string USER_ATTR_KEY_RECV_HELP = "RECV_HELP";

/**
 * 用户属性：接收帮帮忙消息
 */
const string USER_ATTR_KEY_RECV_QA = "RECV_QA";

/**
 * 用户属性：接收课表消息
 */
const string USER_ATTR_KEY_RECV_COURSE = "RECV_COURSE";

/**
 * 用户头像BIZ
 */
const string BIZ_SYS_USER_AVATAR = "user-avatar";

/**
 * 身份模块公共BIZ
 */
const string BIZ_IDENTITY_COMMON = "identity-common";

/*
 * ====================用户管理====================
 */

/**
 * 证件类型
 */
enum TCertType {
	/**
	 * 身份证
	 */
	IDENTITY = 0,

	/**
	 * 护照
	 */
	PASSPORT = 1,

	/**
	 * 营业执照
	 */
	LICENSE = 2,

	/**
	 * 税务登记证
	 */
	TAX = 3,

	/**
	 * 官方认证
	 */
	OFFICIAL = 4,
	
	/**
	 * 小号标记
	 */
	DEPUTY = 5
}

/**
 * 用户证件
 */
struct TUserCert {
	/**
	 * 用户证件标识
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 用户标识
	 */
	2: optional i64 uid = Type.NULL_LONG,

	/**
	 * 证件类型
	 */
	3: optional TCertType type,

	/**
	 * 证件号码
	 */
	4: optional string no,

	/**
	 * 证件图片
	 */
	5: optional i64 img = Type.NULL_LONG,

	/**
	 * 业务类型
	 */
	6: optional string bizKey
}

/**
 * 实名认证状态
 */
enum TCertStatus {
	/**
	 * 默认状态(未申请状态)
	 */
	DEFAULT = 0,

	/**
	 * 提交申请
	 */
	SUBMIT = 1,

	/**
	 * 审核退回
	 */
	REJECTED = 2,

	/**
	 * 审核通过
	 */
	ACCEPTED = 3
}

/**
 * 用户性质
 */
enum TUserNature {
	/**
	 * 默认(未知)
	 */
	DEFAULT = 0,

	/**
	 * 个人
	 */
	PERSONAL = 1,

	/**
	 * 公司
	 */
	COMPANY = 2,

	/**
	 * 校园
	 */
	CAMPUS = 3
}

/**
 * 用户实名认证信息
 */
struct TUserCerts {
	/**
	 * 用户标识
	 */
	1: optional i64 uid = Type.NULL_LONG,

	/**
	 * 真实姓名(公司名称)
	 */
	2: optional string realname,

	/**
	 * 性质：个人/公司/校园
	 */
	3: optional TUserNature nature,

	/**
	 * 证件信息
	 */
	4: optional list<TUserCert> certs,

	/**
	 * 状态
	 */
	5: optional TCertStatus status = TCertStatus.DEFAULT
}

/**
 * 用户学校信息
 */
struct TUserSchool {
	/**
	 * 用户标识
	 */
	1: optional i64 uid = Type.NULL_LONG,

	/**
	 * 所在学校
	 */
	2: optional Standard.TSchool school,

	/**
	 * 入学(职)时间
	 */
	3: optional i64 enterDate = Type.NULL_LONG,

	/**
	 * 所在院系
	 */
	4: optional Standard.TDepartment department,

	/**
	 * 院系名称
	 */
	5: optional string departmentName,

	/**
	 * 专业
	 */
	6: optional Standard.TSpecialty specialty,

	/**
	 * 专业名称
	 */
	7: optional string specialtyName,

	/**
	 * 学校名称
	 */
	8: optional string schoolName
}

/**
 * 用户联系信息
 */
struct TUserContact {
	/**
	 * 用户标识
	 */
	1: optional i64 uid = Type.NULL_LONG,

	/**
	 * 所在地区
	 */
	2: optional Standard.TRegion region,

	/**
	 * 详细地址
	 */
	3: optional string address,

	/**
	 * 邮编
	 */
	4: optional string zipcode,

	/**
	 * 固话
	 */
	5: optional string telephone,

	/**
	 * QQ号
	 */
	6: optional string qq,

	/**
	 * 手机号
	 */
	7: optional string mobile,

	/**
	 * 电子邮箱
	 */
	8: optional string email
}

/**
 * 用户其他信息
 */
struct TUserExtra {
	/**
	 * 用户标识
	 */
	1: optional i64 uid = Type.NULL_LONG,

	/**
	 * 生日
	 */
	2: optional i64 birthday = Type.NULL_LONG,

	/**
	 * 出生地(家乡)
	 */
	3: optional Standard.TRegion birthRegion
}

/**
 * 用户的系统时间信息
 */
struct TUserTime {
	/**
	 * 用户标识
	 */
	1: optional i64 uid = Type.NULL_LONG,

	/**
	 * 创建(注册)时间
	 */
	2: optional i64 createTime = Type.NULL_LONG,

	/**
	 * 创建人
	 */
	3: optional i64 creator = Type.NULL_LONG,

	/**
	 * 最后更新时间
	 */
	4: optional i64 updateTime = Type.NULL_LONG,

	/**
	 * 最后更新人
	 */
	5: optional i64 updator = Type.NULL_LONG
}

/**
 * 用户类型
 *
 * 注：不同类型的用户适用于不同场景
 */
enum TUserType {
	/**
	 * 终端用户，如：学生、教师、行政人员等
	 */
	END_USER = 0,

	/**
	 * 后台管理用户，如：内容审核、内容编辑、系统管理等
	 */
	ADMIN_USER = 1,

	/**
	 * 超级管理员，拥有所有权限
	 */
	SUPER_ADMIN_USER = 2,

	/**
	 * 第三方应用
	 */
	APPLICATION = 3,

	/**
	 * 开发者
	 */
	DEVELOPER = 4,

	/**
	 * 商户
	 */
	SHOP_OWNER = 5,

	/**
	 * 店铺客服
	 */
	SHOP_WAITER = 6
}

/**
 * 用户状态
 */
enum TUserStatus {
	/**
	 * 初始建立（需要用户完善）
	 */
	INITIAL = 0,

	/**
	 * 正常
	 */
	NORMAL = 1
}

/**
 * 账户状态
 */
enum TAccountStatus {
	/**
	 * 初始
	 */
	INITIAL = 0,

	/**
	 * 正常
	 */
	NORMAL = 1,

	/**
	 * 锁定
	 */
	LOCKED = 2,

	/**
	 * 禁用
	 */
	DISABLED = 3,

	/**
	 * 归档
	 */
	ARCHIVED = 4
}
/**
 * 权限
 */
struct TPrivilege {

	/**
	 * 标识
	 *
	 * @Id
	 *
	 * @readonly
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 定义源
	 */
	2: optional string source,

	/**
	 * 所属
	 */
	3: optional string owner,

	/**
	 * 资源
	 */
	4: optional string resource,

	/**
	 * 操作
	 */
	5: optional set<string> operations,

	/**
	 * 扩展属性
	 */
	6: optional map<string,string> attributes
}

/**
 * 角色类型
 *
 * 注：不同类型的角色适用于不同场景
 */
enum TRoleType {
	/**
	 * 系统内置的如：游客、所有人、已登陆用户、管理员等
	 */
	BUILD_IN = 0,
	/**
	 * 终端用户身份，如：学生、教师、行政人员等
	 */
	END_USER_ROLE = 1,

	/**
	 * 后台管理用户身份，如：内容审核、内容编辑、系统管理等
	 */
	ADMIN_USER_ROLE = 2,

	/**
	 * 第三方应用，如：普通应用、特权应用、信任应用等
	 */
	APPLICATION_ROLE = 3
}

/**
 * 角色
 */
struct TRole {
	/**
	 * 标识
	 *
	 * @Id
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 父标识
	 */
	2: optional i64 pid = Type.NULL_LONG,

	/**
	 * 代码
	 *
	 * @Unique
	 */
	3: optional string code,

	/**
	 * 名称
	 */
	4: optional string name,

	/**
	 * 描述
	 */
	5: optional string description,

	/**
	 * 角色类型
	 */
	6: optional TRoleType type,

	/**
	 * 权限
	 *
	 * @readonly
	 */
	7: optional list<TPrivilege> privileges,

	/**
	 * 状态
	 */
	8: optional Type.TStatus status,

	/**
	 * 显示顺序
	 */
	9: optional i16 index = Type.NULL_SHORT
}
/**
 * 用户
 */
struct TUser {
	/**
	 * 标识
	 *
	 * @Id
	 *
	 * @readonly
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 昵称
	 *
	 * @Unique
	 */
	2: optional string nickname,

	/**
	 * 个人签名
	 */
	3: optional string signature,

	/**
	 * 等级
	 *
	 * @readonly
	 */
	4: optional i16 rank = Type.NULL_SHORT,

	/**
	 * 头像标识
	 */
	5: optional i64 avatar = Type.NULL_LONG,

	/**
	 * 性别
	 */
	6: optional Standard.TGender gender

	/**
	 * 学校信息
	 */
	7: optional TUserSchool schoolInfo,

	/**
	 * 实名认证信息
	 */
	8: optional TUserCerts certInfo,

	/**
	 * 联系信息
	 */
	9: optional TUserContact contactInfo,

	/**
	 * 其他信息
	 */
	10: optional TUserExtra extraInfo,

	/**
	 * 系统日志信息
	 *
	 * @readonly
	 */
	11: optional TUserTime timeInfo,

	/**
	 * 扩展属性
	 */
	12: optional map<string, string> attributes,

	/**
	 * 用户类型
	 */
	13: optional TUserType type,

	/**
	 * IDS号
	 */
	14: optional string idsNo,

	/**
	 * 所属域
	 */
	15: optional string domain,

	/**
	 * 积分
	 */
	16: optional i64 points = Type.NULL_LONG,

	/**
	 * 所属账户标识
	 */
	17: optional i64 accountId = Type.NULL_LONG,

	/**
	 * 用户状态
	 * 
	 * @readonly
	 */
	18: optional TUserStatus status,

	/**
	 * 经验值
	 * 
	 * @readonly
	 */
	19: optional i64 exp = Type.NULL_LONG,

	/**
	 * 金币（来自于账户）
	 * 
	 * @readonly
	 */
	20: optional i64 coin = Type.NULL_LONG,
	
	/**
	 * IDS别名，英文逗号间隔
	 */
	21: optional string idsNames,

	/**
	 * 所属账户状态
	 */
	22: optional TAccountStatus accountStatus = TAccountStatus.NORMAL,
	/**
	 * 角色
	 */
	23: optional set<TRole> roles
}

/**
 * 凭证类型/帐户绑定
 */
enum TCredentialType {
	/**
	 * 普通用户名/学号/工号
	 */
	USERNAME = 0,

	/**
	 * 电子邮箱
	 */
	EMAIL = 1,

	/**
	 * 手机号
	 */
	MOBILE = 2,

	/**
	 * 新浪微博
	 */
	SINA = 3,

	/**
	 * 腾讯微博
	 */
	TENCENT = 4,

	/**
	 * 人人网
	 */
	RENREN = 5,

	/**
	 * 学校统一身份认证
	 */
	IDS = 6,

	/**
	 * 其他
	 */
	OTHER = 7,

	/**
	 * 移动社区平台（客户端认证）
	 */
	SNC = 8,

	/**
	 * IDS5登录
	 */
	IDS5 = 9,

	/**
	 * OAUTH登录
	 */
	OAUTH = 10,

	/**
	 * CAS登录
	 */
	CAS = 11,

	/**
	 * 移动社区平台（服务端认证）
	 */
	SNC_SERVER = 12,

	/**
	 * QQ空间
	 */
	QQ = 13,

	/**
	 * WEB版IDS
	 */
	IDSWEB = 14,

	/**
	 * 仅用于老社区自动登录验证
	 */
	SNC_AUTO = 15,

	/**
	 * 教务系统
	 */
	SYS_JW = 16
}

/**
 * 凭证
 */
struct TCredential {
	/**
	 * 标识
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 账户标识
	 */
	2: optional i64 accountId = Type.NULL_LONG,

	/**
	 * 凭证类型
	 */
	3: optional TCredentialType type = TCredentialType.USERNAME,

	/**
	 * 凭证名：如邮件地址、手机号等
	 */
	4: optional string name,

	/**
	 * 凭证值：登录时为帐户密码，绑定认证时为认证码
	 */
	5: optional string value,

	/**
	 * 扩展属性
	 */
	6: optional map<string, string> attributes
}

/**
 * 用户排序
 */
enum TUserOrder {
	DEFAULT = 0
}

/**
 * 用户查询
 */
struct TUserQuery {
	/**
	 * 昵称，模糊匹配，若为空则不作为条件
	 */
	1: optional string nickName,

	/**
	 * 性别，可多选，多选时为或关系，集合为空时不作为条件
	 */
	2: optional set<Standard.TGender> genders,

	/**
	 * 实名认证状态，可多选，多选时为或关系，集合为空时不作为条件
	 */
	3: optional set<TCertStatus> certStatus,

	/**
	 * 等级，列表为空不作为条件，列表数为1时用=匹配，列表数为2时用between匹配，列表数大于2时，用in匹配
	 */
	6: optional list<i16> ranks,

	/**
	 * 创建时间，列表为空时不作为条件，列表数为1时用>匹配，列表数为>=2时用between匹配
	 */
	7: optional list<i64> createTimes,

	/**
	 * 扩展属性，列表为空时不作为条件
	 */
	8: optional map<string, string> attributes,

	/**
	 * 用户类型，为空不作为条件
	 */
	9: optional set<TUserType> types,

	/**
	 * 正式姓名
	 */
	10: optional string realName,

	/**
	 * IDS号
	 */
	11: optional string idsNo,

	/**
	 * 院系名称
	 */
	12: optional string department,

	/**
	 * 专业名称
	 */
	13: optional string specialty,

	/**
	 * 用户组标识
	 */
	14: optional set<i64> groupIds,

	/**
	 * 联系邮箱
	 */
	4: optional string contactEmail,

	/**
	 * 联系电话
	 */
	5: optional string contactTel,

	/**
	 * 联系手机
	 */
	15: optional string contactMobile,

	/**
	 * 排序，为空时默认排序
	 */
	19: optional list<TUserOrder> orders,

	/**
	 * 起始位置
	 */
	20: optional i64 offset = Type.NULL_LONG,

	/**
	 * 获取数量
	 */
	21: optional i64 limit = Type.NULL_LONG,

	/**
	 * domain
	 */
	22: optional set<string> domainKey
}

/**
 * 小号查询
 */
struct TDeputyUserQuery {
	/**
	 * 昵称，模糊匹配，若为空则不作为条件
	 */
	1: optional string nickName,

	/**
	 * domain
	 */
	2: optional set<string> domainKey
	
	/*
	 * 排序，为空时默认排序
	 */
	3: optional list<TUserOrder> orders,
	
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
 * 用户分页
 */
struct TUserPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TUser> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 用户数据选项
 */
struct TUserDataOptions {
	/**
	 * 完整数据
	 */
	1: optional bool all = false,

	/**
	 * 学校信息
	 */
	2: optional bool school = false,

	/**
	 * 实名认证信息
	 */
	3: optional bool cert = false,

	/**
	 * 联系信息
	 */
	4: optional bool contact = false,

	/**
	 * 其他信息
	 */
	5: optional bool extra = false,

	/**
	 * 时间信息
	 */
	6: optional bool time = false,

	/**
	 * 扩展属性
	 */
	7: optional bool attribute = false
}

/**
 * 账户的系统时间信息
 */
struct TAccountTime {
	/**
	 * 账户标识
	 */
	1: optional i64 accountId = Type.NULL_LONG,

	/**
	 * 创建(注册)时间
	 */
	2: optional i64 createTime = Type.NULL_LONG,

	/**
	 * 创建人
	 */
	3: optional i64 creator = Type.NULL_LONG,

	/**
	 * 最后更新时间
	 */
	4: optional i64 updateTime = Type.NULL_LONG,

	/**
	 * 最后更新人
	 */
	5: optional i64 updator = Type.NULL_LONG
}



/**
 * 账户（用户+凭证）
 *
 * 仅作为初始化时的结构，其他数据还是以用户为中心
 */
struct TAccount {
	/**
	 * 标识
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 用户信息
	 * 
	 * 1) 创建时，指定需要关联的用户（带id）或需要同时创建的用户（不带id）；
	 * 2) 获取时与Session的ActiveUser对应
	 */
	2: optional TUser user,

	/**
	 * 凭证信息
	 */
	3: optional list<TCredential> credentials,

	/**
	 * 状态
	 */
	4: optional TAccountStatus status = TAccountStatus.INITIAL,

	/**
	 * 时间信息
	 */
	5: optional TAccountTime timeInfo,

	/**
	 * 角色信息
	 * 
	 * 对应user的角色信息
	 *
	 * @readonly
	 */
	6: optional set<TRole> roles,

	/**
	 * 是否已设置账户密码
	 * 
	 * @readonly
	 */
	7: optional bool hasPwd,

	/**
	 * 金币
	 * 
	 * @readonly
	 */
	8: optional i64 coin = Type.NULL_LONG
}

/**
 * 账户数据选项
 */
struct TAccountDataOptions {
	/**
	 * 完整信息
	 */
	1: optional bool all = false,

	/**
	 * 用户数据选项
	 */
	2: optional TUserDataOptions userDataOptions,

	/**
	 * 凭证信息
	 */
	3: optional bool credential = false,

	/**
	 * 时间信息
	 */
	4: optional bool time = false,

	/**
	 * 角色信息
	 */
	5: optional bool role = false
}

/**
 * 账户查询
 */
struct TAccountQuery {
	/**
	 * 用户查询结构
	 */
	1: optional TUserQuery userQuery,

	/**
	 * 角色，为空时不作为条件
	 */
	2: optional set<i64> roleIds,

	/**
	 * 状态，为空时不作为条件
	 */
	3: optional set<TAccountStatus> status,

	/**
	 * 凭证类型，可多选，多选时为或关系，集合为空时不作为条件
	 */
	4: optional set<TCredentialType> credentialTypes,

	/**
	 * 凭证名称，模糊匹配，若为空则不作为条件
	 */
	5: optional string credentialName,

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
 * 账户分页
 */
struct TAccountPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TAccount> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 虚拟组
 */
struct TVGroup {
	/**
	 * 虚拟组类型
	 */
	1: string type,
	/**
	 * 虚拟组的key
	 */
	2: optional string key,
	/**
	 * 虚拟组名称
	 */
	3: optional string name
}

/**
 * 用户关联的设备
 */
struct TUserDevice {
	/**
	 * 设备token
	 */
	1: string token,
	/**
	 * 用户id
	 */
	2: i64 userId = Type.NULL_LONG,
	/**
	 * 设备系统类型
	 */
	3: Standard.TOSType os,
	/**
	 * 设备名
	 */
	4: optional string name,
	/**
	 * 设备串号
	 */
	5: optional string imei,
	/**
	 * 创建时间
	 */
	6: optional i64 createAt = Type.NULL_LONG,
}

/**
 * 所有用户虚拟组类型
 */
const string VGROUP_ALL = "all";
/**
 * 身份服务提供的组
 */
const string VGROUP_IDENTITY_GROUP = "group";
/**
 * 身份服务角色提供的虚拟组
 */
const string VGROUP_IDENTITY_ROLE = "role";
/**
 * 性别虚拟组类型
 */
const string VGROUP_GENDER = "gender";
/**
 * 在线用户虚拟组类型
 */
const string VGROUP_ONLINE = "online";
/**
 * 新闻虚拟组类型
 */
const string VGROUP_NEWS = "news";
/**
 * guest用户虚拟组
 */
const string VGROUP_GUEST = "guest";
/**
 * 指定学校虚拟组类型
 */
const string VGROUP_SCHOOL = "school";
/**
 * 指定院系虚拟组类型
 */
const string VGROUP_DEPARTMENT = "department";
/**
 * 指定设备类型虚拟组类型,要求id设置为TOSType的value
 */
const string VGROUP_DEVICE = "os";

/**
 * 虚拟组提供者接口
 */
service TVGroupProvider {
	/**
	 * 虚拟组提供者类型
	 */
	string getType();
	/**
	 * 获取组内成员列表
	 *
	 * @param group 虚拟组
	 *
	 * @param offset 偏移
	 *
	 * @param limit 数量
	 */
	list<i64> getUserIds(1: TVGroup group, 2: i32 offset, 3: i32 limit),
	/**
	 * 获取组内成员关联的设备列表,用来做推送
	 *
	 * @param group 虚拟组
	 *
	 * @param os 系统类型
	 *
	 * @param offset 偏移
	 *
	 * @param limit 数量
	 */
	list<TUserDevice> getUserDevices(1: TVGroup group, 2: Standard.TOSType os, 3: i32 offset, 4: i32 limit),
	/**
	 * 判断用户是否在组内
	 *
	 * @param groups 需要检测的虚拟组
	 *
	 * @param userId 用户id
	 */
	bool isInGroup(1: TVGroup group, 2:i64 userId),
	/**
	 * 返回包含用户的组
	 *
	 * @param groups 需要检测的虚拟组列表
	 *
	 * @param userId 用户id
	 */
	list<TVGroup> getInGroups(1: list<TVGroup> groups, 2:i64 userId)
}

/**
 * 身份服务
 */
service TIdentityService {
	/**
	 * 账户查询
	 *
	 * @return 账户分页
	 */
	TAccountPage queryAccount(
			/**
			 * 账户查询结构
			 */
			1: TAccountQuery query,

			/**
			 * 账户数据选项
			 */
			2: TAccountDataOptions options
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 创建账户，初始密码从凭证列表第一个value中获取
	 *
	 * @return 用户标识
	 */
	i64 createAccount(
			/**
			 * 账户信息
			 *
			 * 注：如果关联数据中存在标识，则将根据标识直接关联，否则将用结构中的数据直接创建目标关联对象，并进行关联
			 */
			1: TAccount account,

			/**
			 * 账户数据选项
			 */
			2: TAccountDataOptions options,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 207 缺少用户信息
			 * @error 210 缺少昵称或IDS号
			 * @error 209 昵称已存在
			 * @error 212 IDS号已存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量创建账户，，初始密码从凭证列表第一个value中获取
	 *
	 * @return 用户标识列表，顺序与参数列表对应
	 */
	list<i64> mcreateAccounts(
			/**
			 * 账户列表
			 */
			1: list<TAccount> accounts,

			/**
			 * 账户数据选项
			 */
			2: TAccountDataOptions options,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 207 缺少用户信息
			 * @error 210 缺少昵称或IDS号
			 * @error 209 昵称已存在
			 * @error 212 IDS号已存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取账户信息
	 *
	 * @return 账户信息
	 */
	TAccount getAccount(
			/**
			 * 账户标识
			 */
			1: i64 accountId,

			/**
			 * 账户数据选项
			 */
			2: TAccountDataOptions options
	) throws (
			/**
			 * @error 213 账户不存在
			 * @error 205 无效账户
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取账户信息，根据用户标识
	 *
	 * @return 账户信息
	 */
	TAccount getAccountByUid(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 账户数据选项
			 */
			2: TAccountDataOptions options
	) throws (
			/**
			 * @error 213 账户不存在
			 * @error 205 无效账户
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取账户信息，根据用户标识
	 *
	 * @return 用户表示-账户 映射表
	 */
	map<i64, TAccount> mgetAccountsByUids(
			/**
			 * 用户标识集合
			 */
			1: set<i64> uids,

			/**
			 * 账户数据选项
			 */
			2: TAccountDataOptions options
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取账户信息，根据用户IDS号
	 *
	 * @return 账户信息
	 */
	TAccount getAccountByIdsNo(
			/**
			 * 用户IDS号
			 */
			1: string idsNo,

			/**
			 * 账户数据选项
			 */
			2: TAccountDataOptions options
	) throws (
			/**
			 * @error 213 账户不存在
			 * @error 205 无效账户
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取账户信息，根据用户IDS号
	 *
	 * @return IDS号-账户 映射表
	 */
	map<string, TAccount> getAccountsByIdsNos(
			/**
			 * 用户IDS号集合
			 */
			1: set<string> idsNos,

			/**
			 * 账户数据选项
			 */
			2: TAccountDataOptions options
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取账户信息
	 *
	 * @return 标识-账户信息 映射表
	 */
	map<i64, TAccount> mgetAccounts(
			/**
			 * 账户标识集合
			 */
			1: set<i64> accountIds,

			/**
			 * 账户数据选项
			 */
			2: TAccountDataOptions options
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 认证
	 *
	 * 适用于：1)本地帐户体系认证，如：管理控制台；2)集成认证源登录，如：IDS(学校统一身份认证)
	 *
	 * @return 认证通过，返回账户标识，否则异常
	 */
	i64 authenticate(
			/**
			 * 凭证
			 */
			1: TCredential credential
	) throws (
			/**
			 * @error 203 无效凭证
			 */
			1: Type.TSccException ex
	),

	/**
	 * 修改账户密码
	 */
	void updateAccountPassword(
			/**
			 * 账户标识
			 */
			1: i64 accountId,

			/**
			 * 旧密码
			 */
			2: string oldPassword,

			/**
			 * 新密码
			 */
			3: string newPassword
	)throws (
			/**
			 * @error 213 账户不存在
			 * @error 205 无效账户
			 * @error 206 密码错误
			 */
			1: Type.TSccException ex
	),

	/**
	 * 重置账户密码
	 *
	 * @return 重置后的密码
	 */
	string resetAccountPassword(
			/**
			 * 账户标识
			 */
			1: i64 accountId,

			/**
			 * 新密码
			 *
			 * 注：若为""，则产生随机密码
			 */
			2: string newPassword,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	)throws (
			/**
			 * @error 213 账户不存在
			 * @error 205 无效账户
			 */
			1: Type.TSccException ex
	),

	/**
	 * 重置账户密码
	 *
	 * @return 重置后的密码
	 */
	string resetAccountPasswordEx(
			/**
			 * 账户标识
			 */
			1: i64 accountId,

			/**
			 * 新密码
			 *
			 * 注：若为""，则产生随机密码
			 */
			2: string newPassword,

			/**
			 * 操作人标识
			 */
			3: i64 submitter,

			/**
			 * 为true时表示不作加密处理直接存储
			 */
			4: bool direct
	)throws (
			/**
			 * @error 213 账户不存在
			 * @error 205 无效账户
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新设置账户状态
	 */
	void updateAccountStatus(
			/**
			 * 账户标识
			 */
			1: i64 accountId,

			/**
			 * 需要设置的状态
			 */
			2: TAccountStatus status,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 213 账户不存在
			 * @error 205 无效账户
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新设置账户状态
	 */
	void mupdateAccountStatus(
			/**
			 * 账户标识-状态 映射表
			 */
			1: map<i64, TAccountStatus> status,

			/**
			 * 操作人标识
			 */
			2: i64 submitter
	) throws (
			/**
			 * @error 213 账户不存在
			 * @error 205 无效账户
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取指定账户的凭证列表
	 * 
	 * @return 类型-凭证 映射表
	 */
	map<TCredentialType, TCredential> listCredentials(
			/**
			 * 账户标识
			 */
			1: i64 accountId
	) throws (
			/**
			 * @error 213 账户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 创建账户凭证绑定
	 *
	 * 注：会根据凭证的type和name检查唯一性
	 *
	 * @return 凭证标识
	 */
	i64 createCredential(
			/**
			 * 凭证
			 */
			1: TCredential credential
	) throws (
			/**
			 * @error 204 凭证已存在
			 * @error 225 凭证类型重复
			 */
			1: Type.TSccException ex
	),

	/**
	 * 取消账户凭证绑定
	 *
	 * 注：如果凭证不存在则忽略
	 */
	void removeCredential(
			/**
			 * 凭证
			 *
			 * 注：其中，当id<=0时，会根据type和name去唯一匹配，否则直接根据id匹配
			 */
			1: TCredential credential
	) throws (
			/**
			 * @error 203 无效凭证
			 */
			1: Type.TSccException ex
	),

	/**
	 * 重命名凭证
	 * 
	 * 注：此接口仅更新凭证的name
	 */
	void renameCredential(
			/**
			 * 凭证
			 */
			1: TCredential credential,

			/**
			 * 新的凭证名
			 */
			2: string newName
	) throws (
			/**
			 * @error 203 无效凭证
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新凭证扩展属性
	 * 
	 * 注：仅更新属性，合并方式
	 */
	void updateCredentialAttributes(
			/**
			 * 凭证
			 */
			1: TCredential credential,
	) throws (
			/**
			 * @error 203 无效凭证
			 */
			1: Type.TSccException ex
	),

	/**
	 * 重置凭证扩展属性
	 * 
	 * 注：仅更新属性，替换/覆盖方式
	 */
	void resetCredentialAttributes(
			/**
			 * 凭证
			 */
			1: TCredential credential,
	) throws (
			/**
			 * @error 203 无效凭证
			 */
			1: Type.TSccException ex
	),

	/**
	 * 根据部分凭证内容获取完整内容，如：根据type和name匹配完整凭证信息，根据id获取完整凭证信息
	 *
	 * @return 如果能匹配上则返回完整的凭证内容，否则异常
	 */
	TCredential matchCredential(
			/**
			 * 凭证
			 *
			 * 注：其中，如果id>0，则会根据id获取完整凭证信息；如果id<=0，则会根据type和name匹配
			 */
			1: TCredential credential
	) throws (
			/**
			 * @error 203 无效凭证
			 */
			1: Type.TSccException ex
	),

	/**
	 * 检测凭证是否已经存在
	 *
	 * 注：根据凭证参数的type和name检测
	 *
	 * @return 凭证是否存在
	 */
	bool isCredentialExists(
			/**
			 * 凭证
			 */
			1: TCredential credential
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),
}

/**
 * 用户服务
 */
service TUserService {

	/**
	 * 创建用户
	 *
	 * @return 返回用户标识，或异常
	 */
	i64 createUser(
			/**
			 * 用户信息
			 */
			1: TUser user,
			/**
			 * 用户数据选项
			 */
			2: TUserDataOptions options,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 210 缺少昵称或IDS号
			 * @error 209 昵称已存在
			 * @error 212 IDS号已存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量创建用户
	 *
	 * @return 返回用户标识列表，顺序与user参数保持一致，或异常
	 */
	list<i64> mcreateUsers(
			/**
			 * 用户信息列表
			 */
			1: list<TUser> users,
			/**
			 * 用户数据选项
			 */
			2: TUserDataOptions options,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 210 缺少昵称或IDS号
			 * @error 209 昵称已存在
			 * @error 212 IDS号已存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取用户信息
	 *
	 * @return 用户信息，若不存在则异常
	 */
	TUser getUser(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 用户数据选项
			 */
			2: TUserDataOptions options
	) throws (
			/**
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取用户信息，根据IDS号
	 *
	 * @return 用户信息，若不存在则异常
	 */
	TUser getUserByIdsNo(
			/**
			 * IDS号
			 */
			1: string idsNo,

			/**
			 * 用户数据选项
			 */
			2: TUserDataOptions options
	) throws (
			/**
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),
	
	/**
     * 获取用户信息，根据IDS别名
     *
     * @return 用户信息，若不存在则异常
     */
    TUser getUserByIdsName(
            /**
             * IDS别名
             */
            1: string idsName,

            /**
             * 用户数据选项
             */
            2: TUserDataOptions options
    ) throws (
            /**
             * @error 201 用户不存在
             */
            1: Type.TSccException ex
    ),
	

	/**
	 * 批量获取用户信息
	 *
	 * 注：1)若参数中uid在实际数据中不存在，则返回数据中将忽略
	 *
	 * @return 标识-用户 映射表
	 */
	map<i64, TUser> mgetUsers(
			/**
			 * 用户标识
			 */
			1: set<i64> uids,

			/**
			 * 用户数据选项
			 */
			2: TUserDataOptions options
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 根据昵称获取用户基本信息
	 *
	 * @return 用户信息，若不存在则异常
	 */
	TUser getUserByNick(
			/**
			 * 昵称
			 */
			1: string nick,

			/**
			 * 用户数据选项
			 */
			2: TUserDataOptions options
	) throws (
			/**
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 根据昵称获取用户基本信息
	 *
	 * @return 昵称-用户信息 映射表，若不存在则忽略
	 */
	map<string, TUser> mgetUsersByNick(
			/**
			 * 昵称集合
			 */
			1: set<string> nick,

			/**
			 * 用户数据选项
			 */
			2: TUserDataOptions options
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新用户信息，根据数据选项
	 */
	void updateUser(
			/**
			 * 用户信息
			 */
			1: TUser user,

			/**
			 * 用户数据选项
			 */
			2: TUserDataOptions options,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 210 缺少昵称或IDS号
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新用户状态
	 */
	void updateUserStatus(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 状态
			 */
			2: TUserStatus status
	)throws (
			/**
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新数据选项，根据数据选项
	 */
	void mupdateUsers(
			/**
			 * 用户信息列表
			 */
			1: list<TUser> users,

			/**
			 * 用户数据选项
			 */
			2: TUserDataOptions options,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 210 缺少昵称或IDS号
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 删除用户，如果已经有账户关联，则不允许删除
	 */
	void removeUser(
			/**
			 * 用户标识
			 */
			1: i64 uid
	)throws (
			/**
			 * @error 214 无法删除此用户
			 */
			1: Type.TSccException ex
	),

	/**
	 * 用户查询
	 *
	 * @return 分页用户
	 */
	TUserPage queryUser(
			/**
			 * 用户查询结构
			 */
			1: TUserQuery query,

			/**
			 * 用户数据选项
			 */
			2: TUserDataOptions options
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),
	
	/**
	 * 查询小号用户.
	 *
	 * @return 分页用户
	 */
	TUserPage queryDeputyUser(
			/**
			 * 用户查询结构
			 */
			1: TDeputyUserQuery query,

			/**
			 * 用户数据选项
			 */
			2: TUserDataOptions options
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取用户所有扩展属性
	 *
	 * @return 用户扩展属性映射表
	 */
	map<string, string> getUserAllAttributes(
			/**
			 * 用户标识
			 */
			1: i64 uid
	) throws (
			/**
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取用户所有扩展属性
	 *
	 * @return 用户-用户扩展属性映射表
	 */
	map<i64, map<string, string>> mgetUserAllAttributes(
			/**
			 * 用户标识集合
			 */
			1: set<i64> uids
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取用户局部扩展属性
	 *
	 * @return 用户扩展属性映射表
	 */
	map<string, string> getUserAttributes(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 属性key集合
			 */
			2: set<string> keys
	) throws (
			/**
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取用户局部扩展属性
	 *
	 * @return 用户-用户扩展属性映射表
	 */
	map<i64, map<string, string>> mgetUserAttributes(
			/**
			 * 用户标识-属性key集合 映射表
			 */
			1: map<i64, set<string>> uidKeys
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 设置用户扩展属性
	 */
	void setUserAttributes(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 属性映射表
			 */
			2: map<string, string> attributes,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	) throws (
			/**
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 设置用户扩展属性
	 */
	void msetUserAttributes(
			/**
			 * 用户标识
			 */
			1: map<i64, map<string, string>> userAttributes,

			/**
			 * 操作人标识
			 */
			2: i64 submitter
	) throws (
			/**
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 移除用户扩展属性
	 */
	void removeUserAttributes(
			/**
			 * 用户标识
			 */
			1: i64 uid,

			/**
			 * 属性Key集合
			 */
			2: set<string> keys,

			/**
			 * 操作人标识
			 */
			3: i64 submitter
	)throws (
			/**
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量移除用户扩展属性
	 */
	void mremoveUserAttributes(
			/**
			 * 用户标识
			 */
			1: map<i64, set<string>> uidKeys,

			/**
			 * 操作人标识
			 */
			2: i64 submitter
	)throws (
			/**
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 检测昵称是否已存在
	 *
	 * @return 存在返回true，否则返回false
	 */
	bool isNickNameExists(
			/**
			 * 用户ID
			 *
			 * 注：仅当>0时作为查询条件
			 */
			1: i64 uid,

			/**
			 * 昵称
			 */
			2: string nickName
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 检测IDS号是否已存在
	 *
	 * @return 存在返回true，否则返回false
	 */
	bool isIdsNoExists(
			/**
			 * 用户ID
			 *
			 * 注：仅当>0时作为查询条件
			 */
			1: i64 uid,

			/**
			 * IDS号
			 */
			2: string idsNo
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 保存认证信息
	 * 
	 * @return 认证标识
	 */
	i64 saveUserCert(
			/**
			 * 认证信息
			 */
			1: TUserCert userCert
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 删除认证信息
	 */
	void removeUserCert(
			/**
			 * 认证标识
			 */
			1: i64 certId
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 列出用户的认证信息列表
	 * 
	 * @return 用户认证信息列表
	 */
	map<i64, list<TUserCert>> listUserCert(
			/**
			 * 用户标识集合
			 */
			1: set<i64> uids,

			/**
			 * 认证类型
			 */
			2: set<TCertType> types,

			/**
			 * 业务类型
			 */
			3: set<string> bizKeys
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 同步用户积分
	 */
	void syncUserPoints(
			/**
			 * 用户标识集合
			 */
			1: set<i64> uids
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 签名云服务用户信息
	 *
	 * @param uid 用户标识
	 *
	 * @return 格式用户信息(json)
	 */
	string signCloudUser(1: i64 uid) throws (1: Type.TSccException ex)
}

/*
 * ====================用户组管理====================
 */

/**
 * 组类型
 *
 * 注：不同类型的组适用于不同场景
 */
enum TGroupType {
	/**
	 * 终端用户，如：学生、教师、行政人员等
	 */
	END_USER_GROUP = 0,

	/**
	 * 后台管理用户，如：内容审核、内容编辑、系统管理等
	 */
	ADMIN_USER_GROUP = 1,

	/**
	 * 第三方应用，如：普通应用、特权应用、信任应用等
	 */
	APPLICATION_GROUP = 2
}

/**
 * 组
 */
struct TGroup {
	/**
	 * 标识
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 父标识
	 */
	2: optional i64 pid = Type.NULL_LONG,

	/**
	 * 名称
	 */
	3: optional string name,

	/**
	 * 描述
	 */
	4: optional string description,

	/**
	 * 组类型
	 */
	5: optional TGroupType type,

	/**
	 * 状态
	 */
	6: optional Type.TStatus status
}

/**
 * 组查询
 */
struct TGroupQuery {
	/**
	 * 关键词，模糊匹配，为空时不作为过滤条件
	 */
	1: string keywords,

	/**
	 * 类型，为空时不作为条件
	 */
	2: set<TGroupType> types,

	/**
	 * 状态，为空时不作为条件
	 */
	3: set<Type.TStatus> status,

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
 * 组分页
 */
struct TGroupPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TGroup> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 组服务
 */
service TGroupService {
	/**
	 * 创建组
	 *
	 * @return 新创建组的标识
	 */
	i64 createGroup(
			/**
			 * 角色
			 */
			1: TGroup group
	) throws (
			/**
			 * @error xxxx xxxx
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取组
	 *
	 * @return 组
	 */
	TGroup getGroup(
			/**
			 * 标识
			 */
			1: i64 id
	)throws (
			/**
			 * @error 208 组不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取组
	 *
	 * @return 标识-组 映射表
	 */
	map<i64, TGroup> mgetGroups(
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
	 * 更新组
	 */
	void updateGroup(
			/**
			 * 组
			 */
			1: TGroup group
	)throws (
			/**
			 * @error xxxx xxxx
			 */
			1: Type.TSccException ex
	),

	/**
	 * 修改组状态
	 */
	void updateGroupStatus(
			/**
			 * 组标识
			 */
			1: i64 id,

			/**
			 * 状态
			 */
			2: Type.TStatus status
	)throws (
			/**
			 * @error 208 组不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 角色查询
	 *
	 * @return 角色分页
	 */
	TGroupPage queryGroup(
			/**
			 * 组查询结构
			 */
			1: TGroupQuery query
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量将一批用户加入一批组
	 */
	void addUsersToGroups(
			/**
			 * 用户标识集合
			 */
			1: set<i64> uids,

			/**
			 * 组标识集合
			 */
			2: set<i64> gids
	)throws (
			/**
			 * @error 208 组不存在
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 重置一批用于的组所属
	 */
	void resetUsersToGroups(
			/**
			 * 用户标识集合
			 */
			1: set<i64> uids,

			/**
			 * 组标识集合
			 */
			2: set<i64> gids
	)throws (
			/**
			 * @error 208 组不存在
			 * @error 201 用户不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量将一批用户从一批组中移除
	 */
	void removeUsersFromGroups(
			/**
			 * 用户标识集合
			 */
			1: set<i64> uids,

			/**
			 * 组标识集合
			 */
			2: set<i64> gids
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取用户的组信息
	 *
	 * @return 结构：map<用户标识, set<组>>
	 */
	map<i64, set<TGroup>> listUserGroups(
			/**
			 * 用户标识集合
			 */
			1: set<i64> uids,

			/**
			 * 用户组状态，为空时不作为过滤条件
			 */
			2: set<Type.TStatus> status
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取用户的组标识
	 *
	 * @return 结构：map<用户标识, set<组标识>>
	 */
	map<i64, set<i64>> listUserGroupIds(
			/**
			 * 用户标识集合
			 */
			1: set<i64> uids,

			/**
			 * 用户组状态，为空时不作为过滤条件
			 */
			2: set<Type.TStatus> status
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),
}

/**
 * 授权主体类型
 */
enum TPrincipalType {
	/**
	 * 用户
	 */
	USER = 0,

	/**
	 * 用户组
	 */
	GROUP = 1,

	/**
	 * 第三方应用
	 */
	APPLICATION = 2
}

/**
 * 权限计量类型,按使用优先级排列
 */
enum TMeterType {

	/**
	 * 无限制
	 */
	UNLIMITED = 0,

	/**
	 * 时间段限制
	 */
	TIME_PERIOD = 1,

	/**
	 * 时长限制
	 */
	TIME_OUT = 2,

	/**
	 * 次数限制
	 */
	NUMBER_OF_TIMES = 3
}

/**
 * 权限类型
 */
enum TPrivilegeType {
	/**
	 * 权限条目
	 */
	PRIVILEGE = 0,

	/**
	 * 角色(权限集合)
	 */
	ROLE = 1
}

/**
 * 授权计量
 */
struct TAuthMeter {
	/**
	 * 计量类型
	 */
	1: optional TMeterType type,

	/**
	 * 若MeterType为MeterType.UNLIMITED，不用设置此项
	 * 若MeterType为MeterType.NUMBER_OF_TIMES，表示使用次数
	 * 若MeterType为MeterType.TIME_OUT，时长
	 * 若MeterType为MeterType.TIME_PERIOD，表示时间段开始时间，为0则不作限制，此时不能与m2同时设置为0
	 */
	2: optional i64 m1 = Type.NULL_LONG,

	/**
	 * 若MeterType为MeterType.UNLIMITED，不用设置此项
	 * 若MeterType为MeterType.NUMBER_OF_TIMES，不用设置此项
	 * 若MeterType为MeterType.TIME_OUT，不用设置此项
	 * 若MeterType为MeterType.TIME_PERIOD，表示时间段结束时间，为0则不作限制，此时不能与m1同时设置为0
	 */
	3: optional i64 m2 = Type.NULL_LONG,

	/**
	 * 与其他计量的逻辑运算关系
	 */
	4: optional Type.TLogic logic
}

/**
 * 授权条目
 */
struct TAuthEntry {

	/**
	 * 授权批次，用来标识一次授权操作，以便后续撤销和获取对应的权限，
	 * 如：订单号(orderNo:xxxxxxxxxxx)
	 *
	 * @readonly
	 */
	1: optional string batch,

	/**
	 * 用户、组的标识
	 */
	2: optional i64 principal = Type.NULL_LONG,

	/**
	 * 授权用户类型
	 */
	3: optional TPrincipalType principalType,

	/**
	 * 权限标识
	 */
	4: optional i64 privilege = Type.NULL_LONG,

	/**
	 * 权限类型
	 */
	5: optional TPrivilegeType privilegeType,

	/**
	 * 计量(多个meter之间，先检查所有AND，只要有一个AND无效则此条目，后检查余下OR，只要有一个OR有效则有效)
	 */
	6: optional list<TAuthMeter> meters
}

/**
 * 角色查询
 */
struct TRoleQuery {
	/**
	 * 关键词，模糊匹配，为空时不作为过滤条件
	 */
	1: string keywords,

	/**
	 * 类型，为空时不作为条件
	 */
	2: set<TRoleType> types,

	/**
	 * 状态，为空时不作为条件
	 */
	3: set<Type.TStatus> status,

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
 * 角色分页
 */
struct TRolePage {
	/**
	 * 当前页条目
	 */
	1: optional list<TRole> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 授权条目分页
 */
struct TAuthEntryPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TAuthEntry> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 授权服务
 */
service TAuthorizationService {
	/*
	 * ====================角色管理====================
	 */

	/**
	 * 创建角色
	 *
	 * @return 新创建角色的标识
	 */
	i64 createRole(
			/**
			 * 角色
			 */
			1: TRole role
	) throws (
			/**
			 * @error 217 角色已存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量创建角色
	 */
	list<i64> mcreateRoles(
			/**
			 * 角色列表
			 */
			1: list<TRole> roles
	) throws (
			/**
			 * @error 217 角色已存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取角色
	 *
	 * @return 角色
	 */
	TRole getRole(
			/**
			 * 标识
			 */
			1: i64 id
	)throws (
			/**
			 * @error 215 角色不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 根据code获取角色
	 *
	 * @return 角色
	 */
	TRole getRoleByCode(
			/**
			 * 角色code
			 */
			1: string code
	)throws (
			/**
			 * @error 215 角色不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取角色
	 *
	 * @return 标识-角色 映射表
	 */
	map<i64, TRole> mgetRoles(
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
	 * 批量根据code获取角色
	 *
	 * @return code-角色 映射表
	 */
	map<string, TRole> mgetRolesByCode(
			/**
			 * 角色code
			 */
			1: set<string> codes,

			/**
			 * 为空时不过滤
			 */
			2: set<Type.TStatus> status
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取角色
	 *
	 * @return 标识-角色 映射表
	 */
	map<i64, TRole> mgetRolesWithStatus(
			/**
			 * 标识集合
			 */
			1: set<i64> ids,

			/**
			 * 为空时不过滤
			 */
			2: set<Type.TStatus> status
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新角色
	 */
	void updateRole(
			/**
			 * 角色
			 */
			1: TRole role
	)throws (
			/**
			 * @error 217 角色代码已存在
			 * @error 215 角色不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 修改角色状态
	 */
	void updateRoleStatus(
			/**
			 * 角色标识
			 */
			1: i64 id,

			/**
			 * 状态
			 */
			2: Type.TStatus status
	)throws (
			/**
			 * @error 215 角色不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新角色显示顺序
	 */
	void updateRoleIndex(
			/**
			 * 角色标识-顺序 映射表
			 *
			 * 注：结构，map<角色标识, 顺序>
			 */
			1: map<i64, i16> indexes
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 角色查询
	 *
	 * @return 角色分页
	 */
	TRolePage queryRole(
			/**
			 * 角色查询结构
			 */
			1: TRoleQuery query
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),
	
	/**
	 * 删除角色
	 */
	void deleteRole(
	       /**
             * 角色标识
             */
            1: i64 id,
	)throws (
            /**
             */
            1: Type.TSccException ex
    ),

	/*
	 * ====================权限管理====================
	 */

	/**
	 * 创建权限
	 *
	 * @return 权限标识
	 */
	i64 createPrivilege(
			/**
			 * 权限
			 */
			1: TPrivilege privilege
	)throws (
			/**
			 * @error 10 功能尚未实现
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取权限
	 *
	 * @return 权限
	 */
	TPrivilege getPrivilege(
			/**
			 * 标识
			 */
			1: i64 id
	)throws (
			/**
			 * @error 10 功能尚未实现
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取权限
	 *
	 * @return 标识-权限 映射表
	 */
	map<i64, TPrivilege> mgetPrivileges(
			/**
			 * 标识集合
			 */
			1: set<i64> ids
	)throws (
			/**
			 * @error 10 功能尚未实现
			 */
			1: Type.TSccException ex
	),


	/*
	 * ====================授权管理====================
	 */

	/**
	 * 添加授权
	 *
	 * @return 批次号，如果entry.batch为空则自动产生新批次号
	 */
	string addAuthEntry(
			/**
			 * 授权条目
			 */
			1: TAuthEntry entry
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量添加授权
	 *
	 * @return 批次号，如果第一个entry.batch为空则自动产生新批次号
	 */
	string addAuthEntries(
			/**
			 * 授权条目列表
			 */
			1: list<TAuthEntry> entries
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 重置用户主体相关的授权条目，即先取消（根据principal），后添加
	 *
	 * @return 批次号，如果第一个entry.batch为空则自动产生新批次号
	 */
	string resetAuthEntriesByPrincipals(
			/**
			 * 新的授权条目列表
			 */
			1: list<TAuthEntry> entries
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 取消授权，根据批次号
	 */
	void removeAuthEntriesByBatch(
			/**
			 * 批次号
			 */
			1: string batch
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 取消授权，根据用户主体
	 */
	void removeAuthEntriesByPrincipals(
			/**
			 * 用户主体类型
			 */
			1: TPrincipalType principalType,

			/**
			 * 用户主体标识
			 */
			2: set<i64> principalIds
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 取消授权，根据权限主体
	 */
	void removeAuthEntriesByPrivileges(
			/**
			 * 权限主体类型
			 */
			1: TPrivilegeType privilegeType,

			/**
			 * 权限标识
			 */
			2: set<i64> privilegeIds
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取授权列表，根据批次号
	 */
	TAuthEntryPage listAuthEntriesByBatch(
			/**
			 * 批次号
			 */
			1: string batch,

			/**
			 * 分页起始
			 */
			10: i64 offset,

			/**
			 * 分页大小
			 */
			11: i64 limit
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取授权列表，根据用户主体
	 */
	TAuthEntryPage listAuthEntriesByPrincipals(
			/**
			 * 用户主体类型
			 */
			1: TPrincipalType principalType,

			/**
			 * 用户主体标识
			 */
			2: set<i64> principalIds,

			/**
			 * 分页起始
			 */
			10: i64 offset,

			/**
			 * 分页大小
			 */
			11: i64 limit
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取用户角色，可获取状态过滤后的角色集合
	 *
	 * @return 角色集合
	 */
	set<TRole> listUserRoles(
			/**
			 * 用户标识
			 */
			1: i64 uid,
			/**
			 * 角色状态过滤
			 */
			2: set<Type.TStatus> status
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取用户角色标识，可获取状态过滤后的角色集合
	 *
	 * @return 角色标识集合
	 */
	set<i64> listUserRoleIds(
			/**
			 * 用户标识
			 */
			1: i64 uid,
			/**
			 * 角色状态过滤
			 */
			2: set<Type.TStatus> status
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取用户角色，可获取状态过滤后的角色集合
	 *
	 * @return 用户标识-角色集合 映射表
	 */
	map<i64, set<TRole>> mlistUserRoles(
			/**
			 * 用户标识集合
			 */
			1: set<i64> uids,

			/**
			 * 角色状态过滤
			 */
			2: set<Type.TStatus> status
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取授权列表，根据权限主体
	 */
	TAuthEntryPage listAuthEntriesByPrivileges(
			/**
			 * 权限主体类型
			 */
			1: TPrivilegeType privilegeType,

			/**
			 * 权限标识
			 */
			2: set<i64> privilegeIds,

			/**
			 * 分页起始
			 */
			10: i64 offset,

			/**
			 * 分页大小
			 */
			11: i64 limit
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取用户主体
	 *
	 * @return 用户主体标识列表
	 */
	list<i64> listPrincipalsByPrivileges(
			/**
			 * 权限主体类型
			 */
			1: TPrivilegeType privilegeType,

			/**
			 * 权限标识
			 */
			2: set<i64> privilegeIds,

			/**
			 * 用户主体类型
			 */
			3: TPrincipalType principalType,

			/**
			 * 分页起始
			 */
			10: i64 offset,

			/**
			 * 分页大小
			 */
			11: i64 limit
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 判断是否具有授权
	 */
	bool hasAuth(
			/**
			 * 用户、组的标识
			 */
			1: i64 principal,

			/**
			 * 授权用户类型
			 */
			2: TPrincipalType principalType,

			/**
			 * 权限标识
			 */
			3: i64 privilege,

			/**
			 * 权限类型
			 */
			4: TPrivilegeType privilegeType,
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),
}
