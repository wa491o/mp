/*
 * 会话服务
 *
 * 异常号段：300~399
 */

include "Type.thrift"
include "Standard.thrift"
include "Identity.thrift"

namespace java com.wisorg.scc.api.internal.session
namespace js Session
namespace cocoa Session

/*
 * ====================会话管理====================
 */

/**
 * 运营商
 */
enum TOperatorsType {
	/**
	 * 中国电信
	 */
	CHINATELECOM = 0,
	/**
	 * 中国联通
	 */
	CHINAUNICOM = 1,
	/**
	 * 中国移动
	 */
	CHINAMOBILE = 2,

	/**
	 * 未知
	 */
	UNKNOWN = 3
}

/**
 * 终端设备
 */
struct TTerminal {
	/**
	 * 标识
	 *
	 * @Id
	 *
	 * @readonly
	 */
	1: optional i64 id = Type.NULL_LONG,
	/**
	 * 设备类型
	 */
	2: optional Standard.TDeviceType deviceType,

	/**
	 * 设备型号
	 */
	3: optional string deviceModel,

	/**
	 * 分辨率：x
	 */
	5: optional i32 screenX = Type.NULL_INT,
	/**
	 * 分辨率：y
	 */
	6: optional i32 screenY = Type.NULL_INT,

	/**
	 * 操作系统类型
	 */
	7: optional Standard.TOSType osType

}

/**
 * 网络类型
 */
enum TTerminalNetwork {
	/**
	 * 运营商网络
	 */
	OPERATORS = 0,

	/**
	 * 无线局域网
	 */
	WIFI = 1,

	/**
	 * 其他
	 */
	OTHER = 2
}

/**
 * 终端环境
 */
struct TTerminalEnvironment {
	/**
	 * 会话标识
	 *
	 * @Id
	 *
	 * @readonly
	 */
	1: optional i64 sid = Type.NULL_LONG,
	/**
	 * 终端设备标识
	 */
	2: optional TTerminal terminal,
	/**
	 * User-Agent
	 */
	3: optional string userAgent,

	/**
	 * 操作系统版本
	 */
	5: optional string osVersion,

	/**
	 * 客户端版本
	 */
	6: optional string clientVersion,

	/**
	 * 网络
	 */
	7: optional TTerminalNetwork network,

	/**
	 * 运营商
	 */
	8: optional TOperatorsType operators,

	/**
	 * IP地址
	 */
	9: optional string ip,

	/**
	 * 设备码
	 */
	10: optional string imei,
	/**
	 * 设备token,用来做推送
	 */
	11: optional string deviceToken,

	/**
	 * 经度
	 */
	12: optional double longtitude = Type.NULL_DOUBLE,

	/**
	 * 纬度
	 */
	13: optional double latitude = Type.NULL_DOUBLE
}

/**
 * 会话状态
 */
enum TSessionStatus {
	/**
	 * 活动的
	 */
	ACTIVE = 0,

	/**
	 * 过期的
	 */
	TIMEOUT = 1,

	/**
	 * 主动退出的
	 */
	LOGOUT = 2,

	/**
	 * 被踢出的
	 */
	KILLED = 3,

	/**
	 * 无效的（其他）
	 */
	INVALID = 4,

	/**
	 * 归档
	 */
	ARCHIVED = 5
}

/**
 * 会话时间
 */
struct TSessionTime {
	/**
	 * 会话标识
	 *
	 * @Id
	 *
	 * @readonly
	 */
	1: optional i64 sid = Type.NULL_LONG,

	/**
	 * 创建时间
	 *
	 * @readonly
	 */
	2: optional i64 createTime = Type.NULL_LONG,

	/**
	 * 存活时间(Time to live)
	 */
	3: optional i64 ttl = Type.NULL_LONG,

	/**
	 * 允许发呆时间(Time to idle)
	 */
	4: optional i64 tti = Type.NULL_LONG,

	/**
	 * 最后一次活动时间
	 */
	5: optional i64 updateTime = Type.NULL_LONG,

	/**
	 * 结束时间
	 */
	6: optional i64 endTime = Type.NULL_LONG
}

/**
 * 会话
 */
struct TSession {
	/**
	 * 标识
	 *
	 * @Id
	 *
	 * @readonly
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 令牌
	 *
	 * @Unique
	 *
	 * @readonly
	 */
	2: optional string token,

	/**
	 * 账户信息
	 *
	 * @readonly
	 */
	3: optional Identity.TAccount account,

	/**
	 * 登录所使用凭证
	 */
	4: optional Identity.TCredential loginCredential,

	/**
	 * 终端环境信息
	 */
	5: optional TTerminalEnvironment terminalEnv,

	/**
	 * 时间信息
	 */
	6: optional TSessionTime time,

	/**
	 * 扩展属性
	 *
	 * @readonly
	 */
	7: optional map<string,string> attributes,

	/**
	 * 状态
	 */
	8: optional TSessionStatus status,
	
	/**
	 * 会话用户
	 */
	9: optional Identity.TUser activeUser
}

/**
 * 会话数据加载选项
 */
struct TSessionDataOptions {
	/**
	 * 完整信息
	 */
	1: optional bool all = false,

	/**
	 * 账户数据选项
	 */
	2: optional Identity.TAccountDataOptions accountDataOptions,

	/**
	 * 凭证信息
	 */
	3: optional bool credential = false,

	/**
	 * 终端信息
	 */
	4: optional bool terminal = false,

	/**
	 * 时间信息
	 */
	5: optional bool time = false,

	/**
	 * 扩展属性信息
	 */
	6: optional bool attributes = false,
	
	/**
	 * 用户数据选项
	 */
	7: optional Identity.TUserDataOptions userDataOptions
}

/**
 * 会话分页
 */
struct TSessionPage {
	/**
	 * 当前页条目
	 */
	1: optional list<TSession> items,

	/**
	 * 总数
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 会话列表排序
 */
enum TSessionOrder {
	/**
	 * 默认，根据最近活动时间倒序
	 */
	DEFAULT = 0
}

/**
 * 会话查询结构
 */
struct TSessionQuery {
	/**
	 * 最近活动时间范围，单位：毫秒
	 *
	 * 注：当<=NULL_LONG时，不作为过滤条件
	 */
	1: optional i64 lastActive = Type.NULL_LONG,

	/**
	 * 状态，为空时不作为条件
	 */
	2: optional set<TSessionStatus> status,

	/**
	 * 关联账户过滤
	 *
	 * 注：为空时不作为条件
	 */
	3: optional Identity.TAccountQuery accountQuery,

	/**
	 * 排序，为空时默认排序
	 */
	19: optional list<TSessionOrder> orders,

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
 * 会话服务
 */
service TSessionService {
	/**
	 * 用户登录
	 *
	 * 注：适用于本地帐号体系或本地集成（如：校内IDS）登录方式，登录成功后会自动创建本地会话
	 *
	 * @return 会话令牌
	 */
	string login(
			/**
			 * 当前登录凭证
			 */
			1: Identity.TCredential credential,

			/**
			 * 会话存活时间（单位：毫秒）
			 *
			 * 其中，-1标识永久存活（不会自动失效）；0表示会话失效时间由tti决定
			 */
			2: i64 ttl,

			/**
			 * 已经存在的会话，若为""，则会创建新会话，否则会将该登录用户绑定到该会话
			 */
			3: string existToken
	) throws (
			/**
			 * @error 203 无效凭证
			 */
			1: Type.TSccException ex
	),

	/**
	 * 注销
	 */
	void logout(
			/**
			 * 会话令牌
			 */
			1: string token
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 验证会话令牌
	 *
	 * @return 若会话存在，则返回会话状态，否则异常
	 */
	TSessionStatus validateToken(
			/**
			 * 会话令牌
			 */
			1: string token
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 创建用户会话
	 *
	 * 注：适用于用户已经通过第三方登录，然后通过本方法创建本地会话
	 *
	 * @return 会话令牌
	 */
	string createUserSession(
			/**
			 * 当前登录凭证
			 */
			1: Identity.TCredential credential,

			/**
			 * 会话存活时间（单位：毫秒）
			 *
			 * 其中，-1标识永久存活（不会自动失效）；0表示会话失效时间由tti决定
			 */
			2: i64 ttl
	) throws (
			/**
			 * @error 203 无效凭证
			 */
			1: Type.TSccException ex
	),
	
	/**
     * 创建用户会话
     *
     * 注：适用于绑定外部会话
     *
     */
    void createUserSessionEx(
            /**
             * 当前登录凭证
             */
            1: Identity.TCredential credential,
            
            /**
             * 外部会话token
             */
            2: string token,
            
            /**
             * 产品域Key
             */
            3: string domainKey,

            /**
             * 会话存活时间（单位：毫秒）
             *
             * 其中，-1表示永久存活（不会自动失效）；0表示会话失效时间由tti决定
             */
            4: i64 ttl
    ) throws (
            /**
             * @error 203 无效凭证
             */
            1: Type.TSccException ex
    ),

	/**
	 * 创建访客会话
	 *
	 * @return 会话令牌
	 */
	string createGuestSession(
			/**
			 * 会话存活时间（单位：毫秒）
			 *
			 * 其中，-1表示永久存活（不会自动失效）；0表示会话失效时间由tti决定
			 */
			1: i64 ttl
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),
	
	/**
     * 创建访客会话
     *
     * 注：适用于绑定外部会话
     */
    void createGuestSessionEx(
            /**
             * 外部会话token
             */
            1: string token,
            
            /**
             * 产品域Key
             */
            2: string domainKey,
            
            /**
             * 会话存活时间（单位：毫秒）
             *
             * 其中，-1表示永久存活（不会自动失效）；0表示会话失效时间由tti决定
             */
            3: i64 ttl
    ) throws (
            /**
             */
            1: Type.TSccException ex
    ),

	/**
	 * 获取会话信息
	 *
	 * @return 会话信息
	 */
	TSession getSession(
			/**
			 * 会话令牌
			 */
			1: string token,

			/**
			 * 会话数据选项
			 */
			2: TSessionDataOptions options
	) throws (
			/**
			 * @error 202 无效会话
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取会话信息
	 *
	 * @return 令牌-会话信息 映射表
	 */
	map<string, TSession> mgetSessions(
			/**
			 * 会话令牌
			 */
			1: set<string> tokens,

			/**
			 * 会话数据选项
			 */
			2: TSessionDataOptions options
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 更新会话终端环境信息
	 */
	void logSessionTerminal(
			/**
			 * 会话令牌
			 */
			1: string token,

			/**
			 * 会话终端环境
			 */
			2: TTerminalEnvironment terminalEnv
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量失效会话
	 */
	void invalidateSessions(
			/**
			 * 会话令牌集合
			 */
			1: set<string> tokens,

			/**
			 * 状态
			 */
			2: TSessionStatus status
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取会话所有扩展属性
	 *
	 * @return 会话扩展属性映射表
	 */
	map<string, string> getSessionAllAttributes(
			/**
			 * 会话令牌
			 */
			1: string token
	) throws (
			/**
			 * @error 202 无效会话
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取会话所有扩展属性
	 *
	 * @return 令牌-会话扩展属性映射表
	 */
	map<string, map<string, string>> mgetSessionAllAttributes(
			/**
			 * 令牌集合
			 */
			1: set<string> tokens
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取会话局部扩展属性
	 *
	 * @return 会话扩展属性映射表
	 */
	map<string, string> getSessionAttributes(
			/**
			 * 令牌
			 */
			1: string token,

			/**
			 * 属性key集合
			 */
			2: set<string> keys
	) throws (
			/**
			 * @error 202 无效会话
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取会话局部扩展属性
	 *
	 * @return 令牌-会话扩展属性映射表
	 */
	map<string, map<string, string>> mgetSessionAttributes(
			/**
			 * 令牌-属性key集合 映射表
			 */
			1: map<string, set<string>> tokenKeys
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 设置会话扩展属性
	 */
	void setSessionAttributes(
			/**
			 * 令牌
			 */
			1: string token,

			/**
			 * 属性映射表
			 */
			2: map<string, string> attributes
	) throws (
			/**
			 * @error 202 无效会话
			 */
			1: Type.TSccException ex
	),

	/**
	 * 设置会话扩展属性
	 */
	void msetSessionAttributes(
			/**
			 * 令牌-属性 映射表
			 */
			1: map<string, map<string, string>> tokenAttributes
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 移除会话扩展属性
	 */
	void removeSessionAttributes(
			/**
			 * 令牌
			 */
			1: string token,

			/**
			 * 属性Key集合
			 */
			2: set<string> keys
	)throws (
			/**
			 * @error 202 无效会话
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量移除会话扩展属性
	 */
	void mremoveSessionAttributes(
			/**
			 * 令牌-属性key 映射表
			 */
			1: map<string, set<string>> tokenKeys
	)throws (
			/**
			 * @error 202 无效会话
			 */
			1: Type.TSccException ex
	),

	/**
	 * 会话心跳，更新会话最后活动时间
	 */
	oneway void hitSession(
			/**
			 * 会话令牌
			 */
			1: string token
	),

	/**
	 * 会话查询
	 *
	 * @return 会话分页
	 */
	TSessionPage querySession(
			/**
			 * 会话查询
			 */
			1: TSessionQuery query,

			/**
			 * 会话数据选项
			 */
			2: TSessionDataOptions options
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),
	
	/**
	 * 是否存在会话（仅有效会话）
	 */
	bool hasSession(
			/**
			 * 会话token
			 */
			1: string token
	),

	/**
	 * 触发一次会话状态同步检查
	 */
	oneway void triggerSessionStatus(),

	/**
	 * 触发一次已结束会话的归档
	 */
	oneway void triggerSessionArchive()
}
