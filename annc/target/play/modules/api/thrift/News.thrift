/*
 * 新闻服务
 *
 * 异常号段：2100~2199
 */

include "Type.thrift"
include "Identity.thrift"
include "FileStore.thrift"

namespace java com.wisorg.scc.api.internal.news
namespace js News
namespace cocoa News


/**
 * 新闻相关bizKey
 */
const string BIZ_SYS_NEWS = "news";
const string BIZ_SYS_NEWS_MESSAGE = "news-message";
const string BIZ_SYS_NEWS_ICON = "news-icon";


/**
 * 订阅源状态
 */
enum TSubscribeSrcStatus {
    /**
     * 上架
     */
    ONLINE = 0,

    /**
     * 下架
     */
    OFFLINE = 1,

    /**
     * 已删除
     */
    DELETE = 2
}

/**
 * 新闻状态
 */
enum TNewsStatus {
    /**
     * 正常状态
     */
    DEFAULT = 0,
    /**
     * 屏蔽
     */
    SHIELDED = 1
}

/**
 * 用户订阅状态
 */
enum TSubscribeStatus{
    /**
     * 未订阅
     */
    OFF = 0,
    /**
     * 已订阅
     */
    ON = 1
}

/**
 * 创建更新信息
 */
struct TAdminInfo {
    /**
     * 创建人
     */
    1:optional i64 creator = Type.NULL_LONG
    /**
     * 创建时间
     */
    2:optional i64 timeCreate = Type.NULL_LONG,
    /**
     * 修改人
     */
    3:optional i64 modifier = Type.NULL_LONG,
    /**
     * 修改时间
     */
    4:optional i64 timeModify = Type.NULL_LONG
}

/**
 * 抓取模板
 */
struct TCrawlTemplate {
    /**
     * 模板标识
     */
    1:optional i64 id = Type.NULL_LONG,
    /**
     * 模板名称
     */
    2:optional string name,
     /**
     * 模板目录
     */
    3:optional string directory,
    /**
     * 模板URL
     */
    4:optional string urlList,
    /**
     * 替换参数
     */
    5:optional string repaceParam
}

/**
 * 订阅源
 */
struct TSubscribeSource {
    /**
     * 订阅源标识
     */
    1:optional i64 id = Type.NULL_LONG,
    /**
     * 订阅源名称
     */
    2:optional string name,
    /**
     * 订阅源抓取模板
     */
    3:optional TCrawlTemplate crawlTemplate
    /**
     * 订阅源状态
     */
    4:optional TSubscribeSrcStatus status,
    /**
     * 订阅源创建更新信息
     */
    5:optional TAdminInfo adminInfo,
    /**
     * 用户订阅状态
     */
    6:optional TSubscribeStatus subscribeStatus,
    /**
     * 订阅源扩展属性
     */
    7:optional map<string, string> attributes,
    /**
     * 是否是默认订阅源
     */
    8:optional i16 defFlag = Type.NULL_SHORT
}

/**
 * 订阅源数据选项
 */
struct TSubscribeSourceDataOptions {
    1:optional bool all = false,
    2:optional bool crawlTemplate = false,
    3:optional bool adminInfo = false,
    4:optional bool attributes = false
}

/**
 * 订阅源排序
 */
enum TSubscribeSourceOrder {
    DEFAULT = 0,CREATE_TIME_ASC = 1,CREATE_TIME_DESC = 2
}
/**
 * 订阅源查询
 */
struct TSubscribeSourceQuery {
    /**
      * 如果没有此参数则返回所有数据
      */
    1:optional TSubscribeSrcStatus status,
    2:optional i64 offset = Type.NULL_LONG,
    3:optional i64 limit = Type.NULL_LONG,
    4:optional list<TSubscribeSourceOrder> subscribeSourceOrder,
    /**
      * 默认订阅源标志0非默认1默认
      */
    5:optional i16 defFlag = Type.NULL_SHORT
}

/**
 * 订阅源分页
 */
struct TSubscribeSourcePage {
    1: optional list<TSubscribeSource> items,
    2: optional i64 total = Type.NULL_LONG
}

/**
  * 基本信息
  */
struct TNewsBasic {
    /**
     * 新闻标题
     */
    1:optional string title,
    /**
     * 订阅源
     */
    2:optional TSubscribeSource subscribeSource,
    /**
     * 新闻简介
     */
    3:optional string summary,
    /**
     * 新闻缩略图
     */
    4:optional i64 smallIcon = Type.NULL_LONG,
    /**
     * 新闻来源
     */
    5:optional string source,
    /**
     * 新闻作者
     */
    6:optional string author
    /**
     * 新闻发布时间,用于新闻详情中的显示
     */
    7:optional i64 timePublish = Type.NULL_LONG,
    /**
     * 新闻创建时间
     */
    8:optional i64 timeCreate = Type.NULL_LONG
}

/**
  * 新闻统计信息
  */
struct TNewsStat {
    /**
     * 新闻标识
     */
    1:optional i64 idNews = Type.NULL_LONG,
    /**
     * 新闻查看次数
     */
    2:optional i64 viewCount = Type.NULL_LONG,
}

/**
 * 新闻
 */
struct TNews {
    /**
     * 新闻标识
     */
    1:optional i64 id = Type.NULL_LONG,
    /**
     * 新闻基本信息
     */
    2:optional TNewsBasic basicInfo,
    /**
     * 新闻详情内容
     */
    3:optional string content,
    /**
     * 新闻附件
     */
    4:optional list<FileStore.TFile> attachments,
    /**
     * 新闻管理更新信息
     */
    5:optional TAdminInfo adminInfo,
    /**
     * 新闻状态
     */
    6:optional TNewsStatus status,
    /**
     * 相关统计信息
     */
    7:optional TNewsStat stat,
    /**
     * 抓取新闻详情地址
     */
    8:optional string detailUrl,
    /**
     * 新闻扩展属性
     */
    9:optional map<string, string> attributes
}

/**
 * 新闻数据选项
 */
struct TNewsDataOptions {
    1:optional bool all = false,
    2:optional bool basicInfo = false,
    3:optional bool content = false,
    /**
     * 新闻统计信息
     */
    4:optional bool stat = false,
    5:optional bool attachments = false,
    6:optional bool adminInfo = false,
    7:optional bool attributes = false,
    8:optional TSubscribeSourceDataOptions srcDataOptions

}

/**
 * 新闻排序
 */
enum TNewsOrder {
    /**
      * 默认
      */
    DEFAULT = 0,
    /**
      * 创建时间升序
      */
    CREATE_TIME_ASC = 1,
    /**
      * 创建时间倒序
      */
    CREATE_TIME_DESC = 2
}

/**
 * 新闻源查询
 */
struct TNewsQuery {
    /**
      * 新闻标题
      */
    1:optional string title,
    /**
      * 订阅源标识,为空时不作为条件取所有源的新闻
      */
    2:optional list<i64> sourceIds,
    /**
      * 新闻发布时间
      */
    3:optional list<Type.TQueryNum> timeCreates,
    /**
     * 排序，为空时默认排序
     */
    4:optional list<TNewsOrder> newsOrder,
    /**
     * 新闻状态,为空时不作为条件
     */
    5:optional TNewsStatus status,
    /**
     * 起始位置
     */
    6:optional i64 offset = Type.NULL_LONG,
    /**
     * 获取数量
     */
    7:optional i64 limit = Type.NULL_LONG
    
}

/**
 * 新闻分页
 */
struct TNewsPage {
    1: optional list<TNews> items,
    2: optional i64 total = Type.NULL_LONG,
    3: optional i64 timestamp = Type.NULL_LONG
}

/**
 * 获取未读新闻数目参数
 */
struct TNewsUnreadCount{
	/**
     * 新闻订阅源标识
     */
	1: optional i64 id = Type.NULL_LONG,
	/**
     * 对应订阅源本地最新一条新闻的时间戳
     */
    2: optional i64 timestamp = Type.NULL_LONG
}

/**
 * 新闻服务
 */
service TNewsService {
    /**
     * 新增/编辑订阅源
     *
     * @return 订阅源
     */
    TSubscribeSource saveSubscribeSource(
        /**
          * 订阅源
          */
        1:TSubscribeSource subscribeSource
    ) throws (
            /**
              * @error 2101 订阅源名称为空
              * @error 2108 订阅源名称已经存在
              */
            1:Type.TSccException ex
    )

    /**
     * 更新订阅源状态
     */
    void updateSourceStatus(
        /**
          * 订阅源标识
          */
        1:i64 id,
        2:TSubscribeSrcStatus status
    ) throws (
            /**
              * @error 2102 订阅源不存在
              * @error 2103 新闻服务参数有误
              */
            1:Type.TSccException ex
    )

    /**
     * 获取一个订阅源
     *
     * @return 订阅源
     */
    TSubscribeSource getSubscribeSource(
        /**
          * 订阅源标识
          */
        1:i64 id,
        /**
          * 订阅源数据选项
          */
        2:TSubscribeSourceDataOptions subscribeSourceDataOptions
    ) throws (
            /**
              * @error 2102 订阅源不存在
              */
            1:Type.TSccException ex
    )

    /**
     * 获取多个订阅源
     *
     * @return 订阅源
     */
    map<i64,TSubscribeSource> mgetSubscribeSource(
        /**
          * 订阅源标识
          */
        1:list<i64> ids,
        /**
          * 订阅源数据选项
          */
        2:TSubscribeSourceDataOptions subscribeSourceDataOptions
    ) throws (
            /**
              * @error 2103 新闻服务参数有误
              */
            1:Type.TSccException ex
    )

    /**
     * 查询订阅源
     *
     * @return 订阅源分页数据
     */
    TSubscribeSourcePage querySubscribeSources(
        /**
          * 订阅源查询
          */
        1:TSubscribeSourceQuery subscribeSourceQuery,
        /**
          * 订阅源数据选项
          */
        2:TSubscribeSourceDataOptions subscribeSourceDataOptions
    ) throws (
            1:Type.TSccException ex
    )




    /**
     * 新增/编辑一条新闻
     *
     * @return 新闻
     */
    TNews saveNews(
        /**
          * 新闻
          */
        1:TNews news,
        /**
          * 是否推送消息
          */
        2:bool push
    ) throws (
            /**
              * @error 2103 新闻服务参数有误
              * @error 2105 新闻标题为空
              * @error 2106 新闻内容为空
              * @error 2107 订阅源为空
              */
            1:Type.TSccException ex
    )

    /**
     * 更新删除状态
     */
    void updateNewsStatus(
        /**
          * 新闻标识集合
          */
        1:list<i64> ids,
        2:TNewsStatus status
    ) throws (
            /**
              * @error 2103 新闻服务参数有误
              * @error 2104 新闻不存在
              */
            1:Type.TSccException ex
    )

    /**
     * 获取一个新闻
     *
     * @return 新闻
     */
    TNews getNews(
        /**
          * 新闻标识
          */
        1:i64 id,
        /**
          * 新闻数据选项
          */
        2:TNewsDataOptions newsDataOptions
    ) throws (
            /**
              * @error 2104 新闻不存在
              */
            1:Type.TSccException ex
    )

    /**
     * 增加新闻的查看数
     *
     * @return 新闻
     */
    void incrViewCount(
        /**
          * 新闻标识
          */
        1:i64 id
    ) throws (
            /**
              * @error 2104 新闻不存在
              */
            1:Type.TSccException ex
    )

    /**
     * 获取多个新闻
     *
     * @return 新闻
     */
    map<i64,TNews> mgetNews(
        /**
          * 新闻标识集合
          */
        1:list<i64> ids,
        /**
          * 新闻数据选项
          */
        2:TNewsDataOptions newsDataOptions
    ) throws (
            /**
              * @error 2103 新闻服务参数有误
              */
            1:Type.TSccException ex
    )

    /**
     * 查询新闻
     *
     * @return 订阅源分页数据
     */
    TNewsPage queryNewss(
        /**
          * 新闻查询
          */
        1:TNewsQuery newsQuery,
        /**
          * 新闻数据选项
          */
        2:TNewsDataOptions newsDataOptions
    ) throws (
            1:Type.TSccException ex
    )





    /**
     * 用户订阅/取消订阅一个订阅源
     */
    void subscribeOneSource(
        /**
          * 用户标识
          */
        1: i64 uid,
        /**
          * 订阅源标识
          */
        2: i64 ssid,
        /**
          * 订阅标志
          */
        3: TSubscribeStatus subscribeStatus
    ) throws (
            /**
              * @error 2103 新闻服务参数有误
              */
            1:Type.TSccException ex
    )

    /**
     * 用户订阅/取消订阅所有订阅源
     */
    void subscribeAllSource(
        /**
          * 用户标识
          */
        1: i64 uid,
        /**
          * 订阅标志
          */
        2: TSubscribeStatus subscribeStatus
    ) throws (
            /**
              * @error 2103 新闻服务参数有误
              */
            1:Type.TSccException ex
    )


    /**
     * 获取所有订阅源，包含用户是否订阅信息
     *
     * @return 订阅源数据
     */
    list<TSubscribeSource> getAllSourceByUid(
        /**
          * 用户标识
          */
        1: i64 uid,
        /**
          * 订阅源数据选项
          */
        2:TSubscribeSourceDataOptions subscribeSourceDataOptions
    ) throws (
            1:Type.TSccException ex
    )

    /**
     * 订阅/取消订阅默认订阅源
     */
    void subscribeDefSource(
        /**
          * 用户标识
          */
        1: i64 uid,
        /**
          * 订阅标志
          */
        2: TSubscribeStatus subscribeStatus
    ) throws (
            1:Type.TSccException ex
    )

    /**
     * 获取所有抓取模板
     *
     * @return 抓取模板列表
     */
    list<TCrawlTemplate> getAllTemplate()throws (
            1:Type.TSccException ex
    )
    
    /**
     * 获取新闻未读数目
     *
     * @return 新闻未读数目
     */
    i64 getUnreadCount(
    	1:list<TNewsUnreadCount> unreadCount
    )throws (
            1:Type.TSccException ex
    )
    
    /**
     * 获取新闻未读数目
     *
     * @return 新闻未读数目
     */
    i64 getUnreadNum(
    	/**
          * 用户标识
          */
    	1:i64 uid,
    	/**
          * 时间戳
          */
    	2:i64 timestamp
    )throws (
            1:Type.TSccException ex
    )
    
    /**
     * 删除新闻.
     */
    void deleteNews(
        /**
         * 新闻ID集合.
         */
        1:list<i64> ids
    )throws (
        1:Type.TSccException ex
    )
}
