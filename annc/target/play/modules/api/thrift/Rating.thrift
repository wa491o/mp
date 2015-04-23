/*
 * 评分服务
 *
 * 异常号段：470~479
 */

include "Type.thrift"

namespace java com.wisorg.scc.api.internal.rating
namespace js Rating
namespace cocoa Rating

/**
 * 评分对象
 *
 * @field bizKey 评分所属的业务key
 *
 * @field owner 评分的所有者
 *
 * @field type 评分的类型
 *
 * @field userId 评分的用户
 *
 * @field score 分值
 *
 * @field updateAt 更新时间
 */
struct TRating {
	2: optional string bizKey,
	3: optional string owner,
	4: optional i64 type = Type.NULL_LONG,
	5: optional i64 userId = Type.NULL_LONG,
	6: optional i32 score = Type.NULL_INT,
	7: optional i64 updateAt = Type.NULL_LONG
}

/**
 * 评分分页对象
 *
 * @field items 评分列表
 *
 * @field total 评分总数
 */
struct TRatingPage {
	/**
	 * @readonly
	 */
	1: optional list<TRating> items,
	/**
	 * @readonly
	 */
	2: optional i64 total = Type.NULL_LONG
}

/**
 * 评分服务
 *
 */
service TRatingService {
	/**
	 * 新增或更新一个评分，相同bizKey、owner、type、userId只会有一次
	 *
	 * @param rating 评分对象
	 *
	 */
	void saveRating(1: TRating rating) throws (1: Type.TSccException ex),

	/**
	 * 批量获取用户的所有评分page
	 *
	 * @param bizKey 业务key
	 *
	 * @param types  评分类型列表
	 *
	 * @param userId 用户id
	 *
	 * @param start 开始位置
	 *
	 * @param size 获取个数
	 *
	 * @return 评分分页对象
	 *
	 */
	TRatingPage getRatings(1: string bizKey, 2: set<i64> types, 3: i64 userId, 4: i32 start, 5: i32 size) throws (1: Type.TSccException ex),

	/**
	 * 批量获取用户的评分map
	 *
	 * @param bizKey 业务key
	 *
	 * @param type   评分类型
	 *
	 * @param userId 用户id
	 *
	 * @param owners 所有者列表
	 *
	 * @return 评分map
	 *
	 */
	map<string, i32> getUserScoreMap(1: string bizKey, 2: i64 type, 3: i64 userId, 4: set<string> owners) throws (1: Type.TSccException ex),

	/**
	 * 批量获取用户的评分map，根据type汇总
	 *
	 * @param bizKey 业务key
	 *
	 * @param types   评分类型
	 *
	 * @param userId 用户id
	 *
	 * @return 评分map
	 *
	 */
	map<i64, i32> getUserScoreMapByType(1: string bizKey, 2: set<i64> types, 3: i64 userId) throws (1: Type.TSccException ex),

	/**
	 * 批量获取业务对象的各个分数的评分次数map
	 *
	 * @param bizKey 业务key
	 *
	 * @param type   评分类型
	 *
	 * @param owners 所有者列表
	 *
	 * @return 各个分数的评分次数map
	 *
	 */
	map<string, map<i32,i32>> getScoreDetailMap(1: string bizKey, 2: i64 type, 3: set<string> owners) throws (1: Type.TSccException ex),

	/**
	 * 批量获取业务对象的评分次数
	 *
	 * @param bizKey 业务key
	 *
	 * @param type   评分类型
	 *
	 * @param owners 所有者列表
	 *
	 * @return 评分次数map
	 *
	 */
	map<string, i32> getScoreCountMap(1: string bizKey, 2: i64 type, 3: set<string> owners) throws (1: Type.TSccException ex),

	/**
	 * 批量获取业务对象的评分次数，根据type汇总
	 *
	 * @param bizKey 业务key
	 *
	 * @param types   评分类型
	 *
	 * @return 评分次数map
	 *
	 */
	map<i64, i32> getScoreCountMapByType(1: string bizKey, 2: set<i64> types) throws (1: Type.TSccException ex),

	/**
	 * 批量获取业务对象的平均评分
	 *
	 * @param bizKey 业务key
	 *
	 * @param type   评分类型
	 *
	 * @param owners 所有者列表
	 *
	 * @return 平均评分map
	 *
	 */
	map<string, double> getScoreAverageMap(1: string bizKey, 2: i64 type, 3: set<string> owners) throws (1: Type.TSccException ex),

	/**
	 * 批量获取业务对象的平均评分，根据type汇总
	 *
	 * @param bizKey 业务key
	 *
	 * @param types   评分类型
	 *
	 * @param owners 所有者列表
	 *
	 * @return 平均评分map
	 *
	 */
	map<i64, double> getScoreAverageMapByType(1: string bizKey, 2: set<i64> types) throws (1: Type.TSccException ex),

	/**
	 * 批量获取业务对象的每个用户的评分
	 *
	 * @param bizKey 业务key
	 *
	 * @param type   评分类型
	 *
	 * @param owners 所有者列表
	 *
	 * @return 平均评分map
	 *
	 */
	map<string, double> getScoreMapByUidAndOwner(1: string bizKey, 2: i64 type, 3: set<string> owners, 4: set<i64> userIds) throws (1: Type.TSccException ex),

	/**
	 * 获取热门评分map,key为owner,value为平均分
	 *
	 * @param bizKey 业务key
	 *
	 * @param type   评分类型
	 *
	 * @param size 个数
	 *
	 * @return 热门评分map
	 *
	 */
	map<string, double> getHotOwnerMap(1: string bizKey, 2: i64 type, 3: i32 size) throws (1: Type.TSccException ex),

	/**
	 * 批量获取大于指定分数评分的百分比
	 *
	 * @param bizKey 业务key
	 *
	 * @param type   评分类型
	 *
	 * @param score  分数
	 *
	 * @param owners 所有者列表
	 *
	 * @return 小于1的百分比map
	 *
	 */
	map<string, double> getGreaterPercentMap(1: string bizKey, 2: i64 type, 3: i32 score, 4: set<string> owners) throws (1: Type.TSccException ex)
}
