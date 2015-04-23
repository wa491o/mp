/*
 * 定义公用对象
 */

namespace java com.wisorg.scc.api.type
namespace js Type
namespace cocoa Type

/**
 * 对于这种自定义数据的方式,7: optional map<string, string> data
 * 如果放入一个已JSON常量作为key的值,则表示已这个值反序列后作为data
 */
const string JSON="_json";

const string TRUE_STR = "true";
const string FALSE_STR = "false";

const i16 TRUE_BOOLEAN = 1;
const i16 FALSE_BOOLEAN = -1;

/**
 * 表示空的bool
 * 因为Thrift的基本类型不支持null,在做插入操作的时候用来表示主键为空
 */
const i16 NULL_BOOLEAN = 0;

/**
 * 同上
 */
const i16 NULL_SHORT = 0;

/**
 * 同上
 */
const i32 NULL_INT = 0;

/**
 * 同上
 */
const i64 NULL_LONG = 0;

/**
 * 同上
 */
const double NULL_DOUBLE = 0;

/**
 * 同上
 */
const i64 NULL_DATE = 0;

/**
 * 一分钟的秒数
 */
const i32 SECONDS_PER_MINUTE = 60;

/**
 * 一小时的秒数
 */
const i32 SECONDS_PER_HOUR = 3600;

/**
 * 一天的秒数
 */
const i32 SECONDS_PER_DAY = 86400;

/**
 * 一周的秒数
 */
const i32 SECONDS_PER_WEEK = 604800;

/**
 * 一个月的秒数
 */
const i32 SECONDS_PER_MONTH = 18144000;

/**
 * 表示实体对象的状态
 *
 * @field ENABLED 表示对象处于正常启用状态
 *
 * @field DISABLED 表示对象被禁用
 *
 * @field DELETED 表示对象已被删除
 */
enum TStatus {
    ENABLED,
    DISABLED,
    DELETED
}

/**
 * 表示实体对象的访问权限级别
 *
 * @field ALL  所有人都可以访问
 *
 * @field USER 登陆用户即可访问
 *
 * @field ROLE 拥有指定角色才能访问
 *
 * @field TOKEN需要通过token认证才能访问
 *
 * @field SELF 只有自己才能访问
 *
 * @field SESSION 需要会话授权才能访问
 */
enum TAccessScope {
    ALL,
    USER,
    ROLE,
    TOKEN,
    SELF,
    SESSION,
    VGROUP,
}

/**
 * 异常堆栈对象
 *
 * @field className 发生异常的类
 *
 * @field methodName 发生异常的方法
 *
 * @field fileName 发生异常的文件
 *
 * @field lineNumber 发生异常的行号
 */
struct TStackTrace {
    1: string className,
    2: string methodName,
    3: string fileName,
    4: i32 lineNumber = NULL_INT
}

/**
 * 通用错误对象
 *
 * @field code 错误代码
 *
 * @field msg 错误消息
 *
 * @field stackTraces 错误堆栈，供调试用
 */
exception TSccException {
    1: optional i32 code = 1,
    2: optional string msg,
    3: optional list<TStackTrace> stackTraces
}

/**
 * 数据获取策略
 */
enum TFetchType {
    /**
     * 延迟加载（不获取关联数据）
     */
    LAZY = 0,

    /**
     * 完全加载（获取关联数据）
     */
    EAGER = 1
}

/**
 * 逻辑关系
 */
enum TLogic {
    AND = 0,
    OR = 1,
    XOR = 2
}

/**
  * 查询比较
  */
enum TCompareType {
    /**
      * =
      */
    EQUAL = 0,
    /**
      * >
      */
    GREATER = 1,
    /**
      * <
      */
    LESS = 2,
    /**
      * >=
      */
    GREATER_EQUAL = 3,
    /**
      * <=
      */
    LESS_EQUAL = 4
}

/**
  * 查询时间戳条件
  */
struct TQueryNum {
    1: optional TCompareType compareType,
    2: optional i64 value = NULL_LONG
}

struct TOrder {
    1: string name,
    2: optional bool asc = false
}

struct TDomain {
	1:optional i64 id = NULL_LONG,
	2:optional string key,
	3:optional string name
}

/**
 * 边界类型（区间：开、闭）
 */
enum TBoundType {
	/**
	 * 开区间
	 */
	OPEN = 0,

	/**
	 * 闭区间
	 */
	CLOSED = 1
}

/**
 * 区间
 */
struct TRange {
	/**
	 * 下界（若无下界，可使用实际最小值代替）
	 */
	1: optional i64 lower = NULL_LONG,

	/**
	 * 下界类型
	 */
	2: optional TBoundType lowerType,

	/**
	 * 上界（若无上界，可使用实际最大值代替）
	 */
	3: optional i64 upper = NULL_LONG,

	/**
	 * 上界类型
	 */
	4: optional TBoundType upperType
}
