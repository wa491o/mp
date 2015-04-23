/*
 * 标准数据服务
 *
 * 异常号段：100~199
 */

include "Type.thrift"

namespace java com.wisorg.scc.api.internal.standard
namespace js Standard
namespace cocoa Standard

/**
 * 地区
 */
struct TRegion {
	/**
	 * 标识
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 父标识
	 */
	2: optional i64 pid = Type.NULL_LONG,

	/**
	 * 地区码
	 */
	3: optional string code,

	/**
	 * 名称
	 */
	4: optional string name,

	/**
	 * 描述
	 */
	5: optional string description
}

/**
 * 性别
 */
enum TGender {
	/**
	 * 未知
	 */
	UNKNOWN = 0,

	/**
	 * 男
	 */
	BOY = 1,

	/**
	 * 女
	 */
	GIRL = 2
}

/**
 * 学校
 */
struct TSchool {
	/**
	 * 学校标识
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 学校代码
	 */
	2: optional string code,

	/**
	 * 学校名称
	 */
	3: optional string name,

	/**
	 * 所在地区
	 */
	4: optional TRegion region,

	/**
	 * 学校主页
	 */
	5: optional string homeUrl
}

/**
 * 校区.
 */
struct TCampus {
	/**
	 * 校区ID
	 */
	1:optional i64 campusId = Type.NULL_LONG,
   	
	/**
	 * 所属学校ID
	 */
   	2:optional i64 schoolId = Type.NULL_LONG,
   	
   	/**
   	 * 校区名称
   	 */
   	3:optional string name,
   	
   	/**
   	 * 地区ID
   	 */
   	4:optional i64 regionId = Type.NULL_LONG,
   	
   	/**
   	 * 学校名字
   	 */
   	5:optional string schoolName,
   	
   	/**
   	 * 学校CODE
   	 */
   	6:optional string schoolCode
}

/**
 * 学校分页
 */
struct TSchoolPage {
    /**
     * 当前页条目
     */
    1: optional list<TSchool> items,
    
    /**
     * 总数
     */
    2: optional i64 total = Type.NULL_LONG,
}

/**
 * 校区分页
 */
struct TCampusPage {
    /**
     * 当前页条目
     */
    1: optional list<TCampus> items,
    
    /**
     * 总数
     */
    2: optional i64 total = Type.NULL_LONG,
}

/**
 * 学校查询结构
 */
struct TSchoolQuery {
	/**
	 * 学校代码
	 */
	1: optional string code,

	/**
	 * 学校名称
	 */
	2: optional string name,

    /**
     * 起始位置
     */
    3: optional i64 offset = Type.NULL_LONG,

    /**
     * 获取数量
     */
    4: optional i64 limit = Type.NULL_LONG
}

/**
 * 校区查询结构
 */
struct TCampusQuery {
    /**
     * 起始位置
     */
    1: optional i64 offset = Type.NULL_LONG,

    /**
     * 获取数量
     */
    2: optional i64 limit = Type.NULL_LONG
}

/**
 * 院系
 */
struct TDepartment {
	/**
	 * 标识
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 父标识
	 */
	2: optional i64 pid = Type.NULL_LONG,

	/**
	 * 所属学校
	 */
	3: optional TSchool school,

	/**
	 * 院系代码
	 */
	4: optional string code,

	/**
	 * 院系名称
	 */
	5: optional string name,

	/**
	 * 院系首页
	 */
	6: optional string homeUrl,

	/**
	 * 描述
	 */
	7: optional string description
}

/**
 * 专业
 */
struct TSpecialty {
	/**
	 * 标识
	 */
	1: optional i64 id = Type.NULL_LONG,

	/**
	 * 标准
	 */
	2: optional string std,

	/**
	 * 代码
	 */
	3: optional string code,

	/**
	 * 名称
	 */
	4: optional string name,

	/**
	 * 所属院系
	 */
	5: optional TDepartment department,

	/**
	 * 描述
	 */
	6: optional string description
}

/**
 * 设备操作系统
 */
enum TOSType {
	/**
	 * 未知
	 */
	UNKNOWN = 0,

	/**
	 * Android
	 */
	Android = 1,

	/**
	 * iOS
	 */
	iOS = 2,

	/**
	 * WP
	 */
	WindowsPhone = 3,

	/**
	 * Windows
	 */
	Windows = 4,

	/**
	 * Linux系列
	 */
	Linux = 5,

	/**
	 * Mac OS
	 */
	Mac = 6,

	/**
	 * 其他
	 */
	Other = 7,

	/**
	 * 混合
	 **/
	Hybird = 8
}

/**
 * 设备类型
 */
enum TDeviceType {
	/**
	 * 未知
	 */
	UNKNOWN = 0,

	/**
	 * 个人电脑
	 */
	PC = 1,

	/**
	 * PAD
	 */
	PAD = 2,

	/**
	 * 手机
	 */
	PHONE = 3,

	/**
	 * 电视
	 */
	TV = 4,

	/**
	 * 手表
	 */
	WATCH = 5,

	/**
	 * 眼镜
	 */
	GLASSES = 6
}

/**
 * 标准数据服务
 */
service TStandardService {
	/**
	 * 获取地区
	 *
	 * @return 地区
	 */
	TRegion getRegion(
			/**
			 * 地区标识
			 */
			1: i64 id
	) throws (
			/**
			 * @error 101 地区不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取地区，根据代码
	 *
	 * @return 地区
	 */
	TRegion getRegionByCode(
			/**
			 * 地区代码
			 */
			1: string code
	) throws (
			/**
			 * @error 101 地区不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取地区
	 *
	 * @return 标识-地区 映射表
	 */
	map<i64, TRegion> mgetRegions(
			/**
			 * 地区标识集合
			 */
			1: set<i64> ids
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取下级地区列表
	 *
	 * @return 下级地区列表
	 */
	list<TRegion> getChildRegions(
			/**
			 * 上级地区标识
			 *
			 * 注：<=0时表示获取第一级
			 */
			1: i64 pid
	) throws (
			/**
			 * @error 101 地区不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取学校信息
	 *
	 * @return 学校
	 */
	TSchool getSchool(
			/**
			 * 学校标识
			 */
			1: i64 id
	) throws (
			/**
			 * @error 102 学校不存在
			 */
			1: Type.TSccException ex
	),
	
	/**
	 * 根据CODE获取学校信息
	 *
	 * @return 学校
	 */
	TSchool getSchoolByCode(
			/**
			 * 学校标识
			 */
			1: string code
	) throws (
			/**
			 * @error 102 学校不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取学校信息
	 *
	 * @return 标识-学校 映射表
	 */
	map<i64, TSchool> mgetSchools(
			/**
			 * 学校标识集合
			 */
			1: set<i64> ids
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取院系
	 *
	 * @return 院系
	 */
	TDepartment getDepartment(
			/**
			 * 院系标识
			 */
			1: i64 id
	) throws (
			/**
			 * @error 103 院系不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取院系
	 *
	 * @return 标识-院系 映射表
	 */
	map<i64, TDepartment> mgetDepartments(
			/**
			 * 院系标识集合
			 */
			1: set<i64> ids
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取下级院系列表
	 *
	 * @return 下级院系列表
	 */
	list<TDepartment> getChildDepartments(
			/**
			 * 上级院系标识
			 *
			 * 注：<=0时表示获取第一级
			 */
			1: i64 pid
	) throws (
			/**
			 * @error 103 院系不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 获取专业信息
	 *
	 * @return 专业
	 */
	TSpecialty getSpecialty(
			/**
			 * 专业标识
			 */
			1: i64 id
	) throws (
			/**
			 * @error 104 专业不存在
			 */
			1: Type.TSccException ex
	),

	/**
	 * 批量获取专业信息
	 *
	 * @return 标识-专业 映射表
	 */
	map<i64, TSpecialty> mgetSpecialties(
			/**
			 * 专业标识集合
			 */
			1: set<i64> ids
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),
	
	/**
	 * 获取学校校区列表
	 *
	 * @return 校区列表
	 */
	list<TCampus> getSchoolCampus(
			/**
			 * 学校标识
			 */
			1: i64 schoolId
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),
	
	/**
	 * 查询学校信息
	 *
	 * @return 学校分页
	 */
	TSchoolPage querySchool(
			/**
			 * 查询条件
			 */
			1: TSchoolQuery query
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),
	
	/**
	 * 查询校区信息
	 *
	 * @return 学校分页
	 */
	TCampusPage queryCampus(
			/**
			 * 查询条件
			 */
			1: TCampusQuery query
	) throws (
			/**
			 */
			1: Type.TSccException ex
	),
	
	/**
	 * 获得校区
	 */
	TCampus getCampus(
		1: i64 campusId
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),
	
	/**
	 * 保存学校
	 */
	void saveSchool(
		1: TSchool school
	)throws (
			/**
			 */
			1: Type.TSccException ex
	),
	
	/**
	 * 保存校区
	 */
	void saveCampus(
		1: TCampus campus
	)throws (
			/**
			 */
			1: Type.TSccException ex
	)
}
