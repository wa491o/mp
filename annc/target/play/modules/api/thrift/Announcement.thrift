/*
 * 通知公告服务
 *
 * 异常号段：2000~2099
 */

include "Type.thrift"
include "Identity.thrift"
include "FileStore.thrift"

namespace java com.wisorg.scc.api.internal.announcement
namespace js Announcement
namespace cocoa Announcement

const string BIZ_SYS_ANNC = "annc";
const string BIZ_SYS_ANNC_MESSAGE = "annc-message";

/**
 * 通知公告虚拟组类型
 */
const string VGROUP_ANNOUNCEMENT = "announcement";

/**
 * 通知公告状态
 */
enum TAnnouncementStatus {
    /**
     * 上线
     */
    ONLINE = 0,

    /**
     * 已删除
     */
    DELETE = 1,

    /**
     * 下线
     */
    OFFLINE = 2
}

/**
 * 通知公告排序
 */
enum TAnnouncementOrder {
    /**
     * 默认
     */
    DEFAULT = 0,

    /**
     * 发布时间(正序)
     */
    ONLINE_TIME_ASC = 1,

    /**
     * 发布时间(倒序)
     */
    ONLINE_TIME_DESC = 2
}

/**
 * 订阅源状态
 */
enum TSubscribeSourceStatus {
    /**
     * 上架
     */
    ONLINE = 0,

    /**
     * 屏蔽
     */
    DELETE = 1,

    /**
     * 下架
     */
    OFFLINE = 2
}

/**
 * 订阅源排序
 */
enum TSubscribeSourceOrder {
    /**
     * 默认
     */
    DEFAULT = 0,

    /**
     * 发布时间(正序)
     */
    ONLINE_TIME_ASC = 1,

    /**
     * 发布时间(倒序)
     */
    ONLINE_TIME_DESC = 2
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
 * 时间信息
 */
struct TAdminTime {
    /**
     * 标识
     *
     * @Id
     */
    1: optional i64 id = Type.NULL_LONG,

    /**
     * 创建人
     */
    2: optional Identity.TUser creator,

    /**
     * 创建时间
     */
    3: optional i64 createTime = Type.NULL_LONG,

    /**
     * 最后更新人
     */
    4: optional Identity.TUser updator,

    /**
     * 最后更新时间
     */
    5: optional i64 updateTime = Type.NULL_LONG
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
     * 域key
     */
    5:optional string domainKey,
    /**
     * 域Name
     */
    6:optional string domainName
}

/**
 * 订阅源
 */
struct TSubscribeSource {
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
     * 抓取模板
     */
    3:optional TCrawlTemplate pTemplate,

    /**
     * 订阅源状态
     */
    4: optional TSubscribeSourceStatus subscribeSourceStatus,

    /**
     * 管理信息
     */
    5: optional TAdminTime adminTime,

    /**
     * 用户的订阅状态
     */
    6: optional TSubscribeStatus subscribeStatus,

    /**
     * 订阅源可见的角色列表
     */
    7: optional list<Identity.TRole> roles,

    /**
     * 默认订阅源标识
     */
    8: optional i32 defaultFlag = Type.NULL_INT
}

/**
 * 订阅源数据选项
 */
struct TSubscribeSourceDataOptions {
    /**
     * 完整信息
     */
    1: optional bool all = false,

    /**
     * 基本信息
     */
    2: optional bool base = false,

    /**
     * 时间信息
     */
    3: optional bool time = false,

    /**
     * 用户订阅状态信息
     */
    4: optional bool userSubscribeStatus = false
}

/**
 * 订阅源查询结构
 */
struct TSubscribeSourceQuery {
    /**
     * 排序，为空时默认排序
     */
    1: optional list<TSubscribeSourceOrder> orders,

    /**
     * 起始位置
     */
    2: optional i64 offset = Type.NULL_LONG,

    /**
     * 获取数量
     */
    3: optional i64 limit = Type.NULL_LONG,

    /**
     * 状态
     */
    4: optional TSubscribeSourceStatus status,

    /**
     * 用户标识
     */
    5: optional i64 uid = Type.NULL_LONG,

    /**
     * 订阅源角色
     */
    6: optional list<Identity.TRole> roles,
    
    /**
     * 应用标识
     */
    7: optional i64 appId = Type.NULL_LONG
}

/**
 * 通知公告基本信息
 */
struct TAnnouncementBase {
    /**
     * 标识
     *
     * @Id
     */
    1: optional i64 id = Type.NULL_LONG,

    /**
     * 通知公告标题
     */
    2:optional string title,

    /**
     * 摘要
     */
    3:optional string summary,
    /**
    *浏览次数
    */
    4:optional i64 viewCount
}

/**
 * 通知公告详细信息
 */
struct TAnnouncementDetail {
    /**
     * 标识
     *
     * @Id
     */
    1: optional i64 id = Type.NULL_LONG,

    /**
     * 订阅源
     */
    2:optional TSubscribeSource subscribeSource,

    /**
     * 通知公告内容
     */
    3:optional string content,

    /**
     * 来源
     */
    4:optional string source,

    /**
     * 作者
     */
    5:optional string author,

    /**
     * 新闻发布时间
     */
    6:optional i64 onlineTime = Type.NULL_LONG,

    /**
     * 统计信息
     */
    7:optional i64 viewCount = Type.NULL_LONG,

    /**
     * 通知公告源的详情地址
     */
    8:optional string sourceUrl
}

/**
 * 通知公告
 */
struct TAnnouncement {
    /**
     * 应用标识
     *
     * @Id
     */
    1: optional i64 id = Type.NULL_LONG,

    /**
     * 基本信息
     */
    2: optional TAnnouncementBase baseInfo,

    /**
     * 详细信息
     */
    3: optional TAnnouncementDetail detailInfo,

    /**
     * 管理信息
     */
    4: optional TAdminTime adminTime,

    /**
     * 附件列表
     */
    5: optional list<FileStore.TFile> attachment,

    /**
     * 状态
     */
    6: optional TAnnouncementStatus status
}

/**
 * 通知公告数据选项
 */
struct TAnnouncementDataOptions {
    /**
     * 完整信息
     */
    1: optional bool all = false,

    /**
     * 基本信息
     */
    2: optional bool base = false,

    /**
     * 详细信息
     */
    3: optional bool detail = false,

    /**
     * 时间信息
     */
    4: optional bool time = false,

    /**
     * 附件
     */
    5: optional bool attachment = false
}

/**
 * 通知公告分页
 */
struct TAnnouncementPage {
    /**
     * 当前页条目
     */
    1: optional list<TAnnouncement> items,

    /**
     * 总数
     */
    2: optional i64 total = Type.NULL_LONG,
    3: optional i64 timestamp = Type.NULL_LONG
    
}

/**
 * 通知公告查询结构
 */
struct TAnnouncementQuery {
    /**
     * 分类，为空时不作为条件
     */
    1: optional set<i64> catIds,

    /**
     * 发布时间，列表为空时不作为条件，列表数为1时用>匹配，列表数为>=2时用between匹配
     */
    2: optional list<Type.TQueryNum> onlineTimes,

    /**
     * 排序，为空时默认排序
     */
    3: optional list<TAnnouncementOrder> orders,

    /**
     * 起始位置
     */
    4: optional i64 offset = Type.NULL_LONG,

    /**
     * 获取数量
     */
    5: optional i64 limit = Type.NULL_LONG,

    /**
     * 状态
     */
    6: optional TAnnouncementStatus status,

    /**
     * 通知公告标题
     */
    7: optional string title
}

struct TAnnouncementUnreadCount {
	/**
     * 订阅源标识
     *
     * @Id
     */
    1: optional i64 ssid = Type.NULL_LONG,
    
    /**
     * 用户上次查看某个订阅源下最新一条通知公告的时间戳
     */
    2: optional i64 lastTime = Type.NULL_LONG
}

/**
 * 通知公告服务
 */
service TAnnouncementService {
    /**
     * 保存一个通知公告,当id为空时则为新建
     *
     * @param announcement 待保存的通知公告
     *
     * @param push 是否默认推送
     *
     * @return 包含id的通知公告
     *
     * @tables t_scc_announcement
     */
    TAnnouncement saveAnnouncement(1: TAnnouncement announcement, 2: bool push) throws (
        /**
         * @error 54 必须参数不存在
         * @error 4 数据库访问异常
         */
        1: Type.TSccException ex),

    /**
     * 修改一个通知公告的当前状态
     *
     * @param id 通知公告id
     *
     * @param status 通知公告的状态
     *
     * @tables t_scc_announcement
     */
    void updateAnnouncementStatus(1: i64 id , 2: TAnnouncementStatus status) throws (
        /**
         * @error 54 必须参数不存在
         * @error 4 数据库访问异常
         * @error 2001 通知公告不存在
         */
        1: Type.TSccException ex),

    /**
     * 批量屏蔽通知公告
     *
     * @param id 通知公告id
     *
     * @param status 通知公告的状态
     *
     * @tables t_scc_announcement
     */
    void updateAnnouncementStatus4Del(1: list<i64> ids) throws (
        /**
         * @error 4 数据库访问异常
         */
        1: Type.TSccException ex),

    /**
     * 获取一个通知公告
     *
     * @param id 通知公告id
     * 
     * @param TAnnouncementDataOptions option 通知公告数据选项
     *
     * @return 通知公告
     *
     * @tables t_scc_announcement
     */
    TAnnouncement getAnnouncement(1: i64 id , 2: TAnnouncementDataOptions option) throws (
        /**
         * @error 54 必须参数不存在
         * @error 4 数据库访问异常
         * @error 2001 通知公告不存在
         */
        1: Type.TSccException ex),

    /**
     * 根据id列表批量获取通知公告
     *
     * @param ids 通知公告id列表
     * 
     * @param TAnnouncementDataOptions option 通知公告数据选项
     *
     * @return 通知公告列表map
     *
     * @tables t_scc_announcement
     */
    map<i64, TAnnouncement> mgetAnnouncements(1: list<i64> ids , 2: TAnnouncementDataOptions option) throws (1: Type.TSccException ex),

    /**
     * 获取通知公告列表
     *
     * @param TAnnouncementQuery announcementQuery 通知公告查询
     * 
     * @param TAnnouncementDataOptions option 通知公告数据选项
     *
     * @return 通知公告分类列表
     *
     * @tables t_scc_announcement
     */
    TAnnouncementPage queryAnnouncements(1: TAnnouncementQuery announcementQuery , 2: TAnnouncementDataOptions option) throws (
        /**
         * @error 54 必须参数不存在
         */
        1: Type.TSccException ex),
    
    /**
     * 保存一个订阅源,当id为空时则为新建
     *
     * @param category 待保存的订阅源
     *
     * @return 包含id的订阅源
     *
     * @tables t_scc_announcement_sub
     */
    TSubscribeSource saveSubscribeSource(1: TSubscribeSource subscribeSource) throws (
        /**
         * @error 4 数据库访问异常
         */
        1: Type.TSccException ex),


    /**
     * 修改一个订阅源的当前状态
     *
     * @param id 订阅源id
     *
     * @param TSubscribeSourceStatus status 订阅源的状态
     *
     * @tables t_scc_announcement_sub
     */
    void updateSubscribeSourceStatus(1: i64 id , 2: TSubscribeSourceStatus status) throws (
        /**
         * @error 54 必须参数不存在
         * @error 4 数据库访问异常
         * @error 2001 通知公告不存在
         */
        1: Type.TSccException ex),

    /**
     * 获取一个订阅源
     * 
     * @param id 订阅源id
     * 
     * @param TSubscribeSourceDataOptions option 订阅源数据选项
     *
     * @return 订阅源
     *
     * @tables t_scc_announcement_sub
     */
    TSubscribeSource getSubscribeSource(1: i64 id , 2: TSubscribeSourceDataOptions option) throws (
        /**
         * @error 54 必须参数不存在
         * @error 4 数据库访问异常
         * @error 2001 通知公告不存在
         */
        1: Type.TSccException ex),

    /**
     * 获取订阅源列表
     * 
     * @param TSubscribeSourceQuery subscribeSourceQuery 订阅源查询
     * 
     * @param TSubscribeSourceDataOptions option 订阅源数据选项
     *
     * @return 订阅源列表
     *
     * @tables t_scc_announcement_sub
     */
    list<TSubscribeSource> querySubscribeSources(1: TSubscribeSourceQuery subscribeSourceQuery , 2: TSubscribeSourceDataOptions option) throws (
        /**
         * @error 54 必须参数不存在
         */
        1: Type.TSccException ex),
    
    /**
     * 获取某个用户已订阅的订阅源列表
     * 
     * @param i64 uid 用户标识
     * 
     * @param roleIds 用户角色id
     *
     * @param TSubscribeSourceDataOptions option 订阅源数据选项
     *
     * @param appId 应用标识
     *
     * @return 用户已订阅的订阅源列表
     *
     * @tables t_scc_announcement_sub
     */
    list<TSubscribeSource> queryUserSubscribeSourcesList(1: i64 uid, 2: list<i64> roleIds, 3: TSubscribeSourceDataOptions option, 4: i64 appId) throws (
        /**
         * @error 54 必须参数不存在
         */
        1: Type.TSccException ex),
    
    /**
     * 用户订阅一个订阅源(新增订阅关系)
     *
     * @param uid 用户id
     *
     * @param ssid 订阅源id
     *
     * @tables t_scc_announcement_sub
     */
    void subscribe(1: i64 uid , 2: i64 ssid) throws (
        /**
         * @error 56  用户不存在
         * @error 2003  不能重复订阅同一个订阅源
         * @error 2002 通知公告的订阅源不存在
         */
        1: Type.TSccException ex),
    
    /**
     * 用户取消订阅（删除订阅关系）
     *
     * @param uid 用户id
     *
     * @param ssid 订阅源id
     *
     * @tables t_scc_announcement_sub
     */
    void unsubscribe(1: i64 uid , 2: i64 ssid) throws (
        /**
         * @error 4 数据库访问异常
         */
        1: Type.TSccException ex),
    
    /**
     * 用户订阅所有订阅源(新增用户和所有订阅源之间的订阅关系)
     *
     * @param uid 用户id
     *
     * @param roleIds 用户角色id
     *
     * @tables t_scc_announcement_sub
     */
    void subscribe4All(1: i64 uid , 2: list<i64> roleIds) throws (
        /**
         * @error 4 数据库访问异常
         */
        1: Type.TSccException ex),
    
    /**
     * 用户订阅所有订阅源(新增用户和所有订阅源之间的订阅关系)
     *
     * @param uid 用户id
     *
     * @param roleIds 用户角色id
     *
     * @param appId 应用ID
     *
     * @tables t_scc_announcement_sub
     */
    void subscribe4AllByAppId(1: i64 uid , 2: list<i64> roleIds,3:i64 appId) throws (
        /**
         * @error 4 数据库访问异常
         */
        1: Type.TSccException ex),
        
    
    /**
     * 用户取消所有订阅（删除用户和所有订阅源之间的订阅关系）
     *
     * @param uid 用户id
     *
     * @tables t_scc_announcement_sub
     */
    void unsubscribe4All(1: i64 uid) throws (
        /**
         * @error 4 数据库访问异常
         */
        1: Type.TSccException ex),
	
	/**
     * 用户取消所有订阅（删除用户和所有订阅源之间的订阅关系）
     *
     * @param uid 用户id
     *
     * @param appId 应用ID
     *
     * @tables t_scc_announcement_sub
     */
    void unsubscribe4AllByAppId(1: i64 uid,2:i64 appId) throws (
        /**
         * @error 4 数据库访问异常
         */
        1: Type.TSccException ex),
        
    /**
     * 用户订阅默认订阅源(用户注册时使用)
     *
     * @param uid 用户id
     *
     * @param roleIds 用户角色id
     *
     * @tables t_scc_announcement_sub
     */
    void subscribeDefaultSource(1: i64 uid , 2: list<i64> roleIds) throws (
        /**
         * @error 4 数据库访问异常
         */
        1: Type.TSccException ex),
    
    /**
     * 获取所有抓取模板列表
     *
     * @return 抓取模板列表
     */
    list<TCrawlTemplate> queryTemplates() throws (
        /**
         * @error 4 数据库访问异常
         */
        1: Type.TSccException ex),

    /**
     * 增加通知公告的浏览数
     *
     * @param id 通知公告id
     *
     * @return 浏览数
     */
    i64 incrViewCount(1: i64 id) throws (
        /**
         * @error 4 数据库访问异常
         */
        1: Type.TSccException ex),
    
    /**
     * 获取通知公告未读信息的数目
     *
     * @param params 订阅源和(用户上次查看某个订阅源下最新一条通知公告的)时间戳对应关系列表
     *
     * @return 用户订阅的订阅源未读公告信息的总数目
     */
    i32 getUnreadCount(1: list<TAnnouncementUnreadCount> params) throws (
    	/**
         * @error 4 数据库访问异常
         */
        1: Type.TSccException ex)
    
    /**
     * 获取通知公告未读数目
     *
     * @return 通知公告未读数目
     */
    i64 getUnreadNum(
    	/**
          * 订阅源标识
          */
    	1:list<i64> sids,
    	/**
          * 时间戳
          */
    	2:i64 timestamp
    )throws (
            1:Type.TSccException ex
    )
    
    /**
     * 删除公告.
     */
    void deleteAnnouncements(
        /**
         * 公告ID集合.
         */
        1:list<i64> ids
    )throws (
        1:Type.TSccException ex
    )
}

