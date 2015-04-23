/*
 * 日志服务
 *
 * 异常号段：800~899
 */

include "Type.thrift"
include "Standard.thrift"
include "Identity.thrift"

namespace java com.wisorg.scc.api.internal.logger
namespace js application
namespace cocoa application

/**
 * 管控台日志排序
 */
enum TConsoleLogOrder {
	/**
	 * 默认
	 */
	DEFAULT = 0,
	/**
	 * 创建时间升序
	 */
	OPER_TIME_ASC = 1,
	/**
	 * 创建时间倒序
	 */
	OPER_TIME_DESC = 2
}

/**
 *管控台日志查询
 */
struct TConsoleLogQuery {
	/**
	 *用户昵称
	 */
	1: optional string nickname,
	/**
	 *操作时间
	 */
	2: optional list<i64> operTimes,

	3:optional i64 offset = Type.NULL_LONG,
	4:optional i64 limit = Type.NULL_LONG,
	5:list<TConsoleLogOrder> consoleLogOrder
}

/**
 *管控台日志
 */
struct TConsoleLog {
	/**
	 *日志标识（可不填）
	 */
	1: optional i64 id = Type.NULL_LONG,
	/**
	 *用户昵称（可不填）
	 */
	2: optional string nickname,
	/**
	 *操作说明
	 */
	3: optional string description,
	/**
	 *操作时间（可不填）
	 */
	4: optional i64 operTime = Type.NULL_LONG,
	/**
	 *额外信息，例如对象标识
	 */
	5: optional string extra,
	/**
	 *useragent
	 */
	6: optional string userAgent,
	/**
	 *IP
	 */
	7: optional string IP
}

/**
 *管控台日志分页
 */
struct TConsoleLogPage {
	1: optional list<TConsoleLog> items,
	2: optional i64 total = Type.NULL_LONG
}

/**
 *日志服务
 */
service TLoggerService {

	/**
	 *查询管控台日志
	 *@return 管控台日志分页数据
	 */
	TConsoleLogPage queryConsoleLogs (
			/**
			 *管控台日志查询参数
			 */
			1: TConsoleLogQuery tconsoleLogQuery
	) throws (
			/**
			 * @error 无
			 */
			1:Type.TSccException ex
	)

	/**
	 *创建管控台日志
	 */
	void createConsoleLog (
			/**
			 *管控台日志
			 */
			1: TConsoleLog tconsoleLog,
			/**
			 *用户标识
			 */
			2: i64 uid
	) throws (
			/**
			 * @error 801    用户不存在
			 */
			1:Type.TSccException ex
	)
}

