/*
 * 获取学校的消息访问和发布通道，包括站内信、邮件、短信、PUSH等类型，在应用未安装状态下也可以向用户推送应用相关消息，提高应用的唤醒率
 *
 * 异常号段：430~459
 */

include "Type.thrift"
include "Identity.thrift"
include "FileStore.thrift"
include "Standard.thrift"

namespace java com.wisorg.scc.api.internal.message
namespace js Message
namespace cocoa Message

/**
 * 消息类型
 *
 * @field PRIVATE 站内信
 *
 * @field EMAIL 邮件
 *
 * @field SMS 短信
 *
 * @field PUSH 推送
 */
enum TMessageType {
    PRIVATE,
    EMAIL,
    SMS,
    PUSH
}

/**
 * 消息状态
 *
 * @field INBOX 收件箱
 *
 * @field OUTBOX 发件箱
 *
 * @field DRAFT 草稿
 *
 * @field FAVORITE 收藏箱
 *
 * @field RECYCLE 回收站
 *
 * @field DELETED 已删除
 */
enum TMessageStatus {
    INBOX,
    OUTBOX,
    DRAFT,
    FAVORITE,
    RECYCLE,
    DELETED
}

/**
 * 短信通道.
 *
 * @field NO 非短信通道/无通道
 *
 * @field EMAY 易美软通
 * 
 * @field YXT 云信通
 */
enum TSmsChannel {
	NO,
	EMAY,
	YXT
}

/**
 * 表示发送者是系统
 */
const i64 SENDER_SYS = -1;
/**
 * 表示接收者为所有用户
 */
const i64 RECEIVER_ALL = -1;
/**
 * 系统消息bizKey
 */
const string BIZ_SYS_MSG = "sys-message";
/**
 * 消息对象
 *
 * @field id 消息的id,主键
 *
 * @field bizKey 消息所属的业务key
 *
 * @field catalog 消息的分类
 *
 * @field parentId 父消息id
 *
 * @field senderId 发送者id
 *
 * @field subject 消息的主题
 *
 * @field body 消息内容
 *
 * @field url 消息的访问或者跳转地址
 *
 * @field attr 消息的附加数据
 *
 * @field attachmentIds 附件id列表
 *
 * @field createAt 创建时间
 *
 * @field sender 发送者
 *
 * @field sender 附件列表
 *
 * @field attachments 附件列表
 */
struct TMessage {
    /**
     * @readonly
     */
    1: optional i64 id = Type.NULL_LONG,
    /**
     * @def test
     */
    2: optional string bizKey,
    3: optional string catalog,
    4: optional i64 parentId = Type.NULL_LONG,
    5: optional i64 senderId = Type.NULL_LONG,
    6: optional string subject,
    7: optional string body,
    8: optional string url,
    9: optional map<string, string> attr,
    10: optional list<i64> attachmentIds,
    /**
     * @readonly
     */
    11: optional i64 createAt = Type.NULL_LONG,
    /**
     * @readonly
     */
    12: optional Identity.TUser sender,
    /**
     * @readonly
     */
    13: optional list<FileStore.TFile> attachments
}

/**
 * 消息发送选项
 *
 * @field type 消息类型
 *
 * @field expireAt push类型消息的有效时间,过期将不进行推送
 *
 * @field priority 发送优先级,越大越优先
 *
 * @field sendAt 指定发送时间,用于延时发送
 *
 * @field push 是否同时发送push消息
 *
 * @field os 目标操作系统
 */
struct TSendOption {
    1: TMessageType type,
    2: optional i64 expireAt = Type.NULL_LONG,
    3: optional i64 sendAt = Type.NULL_LONG,
    4: optional i32 priority = 100,
    5: optional bool push = false,
    6: optional Standard.TOSType os
}

/**
 * 站内消息
 */
struct TPrivateMessage {
    1: optional i64 id = Type.NULL_LONG,
    2: optional TMessage message,
    3: optional i64 receiverId = Type.NULL_LONG,
    4: optional TMessage parent,
    5: optional TMessageStatus status = TMessageStatus.INBOX,
    6: optional i64 sendAt = Type.NULL_LONG,
    7: optional i64 readAt = Type.NULL_LONG,
    8: optional Identity.TUser receiver
}

/**
 * 发送历史
 */
struct TMessageHistory {
    1: optional i64 id = Type.NULL_LONG,
    2: optional TMessage message,
    3: optional i64 receiverId = Type.NULL_LONG,
    4: optional string receiverContact,
    5: optional bool ok = true,
    6: optional i32 retryCount = Type.NULL_INT,
    7: optional string feedback,
    8: optional i64 sendAt = Type.NULL_LONG,
    9: optional Identity.TUser receiver
}

/**
 * 消息查询
 */
struct TMessageQuery {
    /**
     * 应用key
     */
    1: optional string appKey,
    /**
     * 业务key
     */
    2: optional string bizKey,
    /**
     * 分类
     */
    3: optional string catalog,
    /**
     * 发送者
     */
    4: optional i64 senderId = Type.NULL_LONG,
    /**
     * 内容模糊查询
     */
    8: optional string keyword,
    /**
     * 开始时间
     */
    9: optional i64 startDate = Type.NULL_LONG,
    /**
     * 结束时间
     */
    10: optional i64 endDate = Type.NULL_LONG,
    /**
     * 排序,默认按创建时间递减
     */
    14: optional list<Type.TOrder> orders,
    /**
     * 查询游标,第一次查询会返回,以后带上
     */
    15: optional i64 cursor = Type.NULL_LONG,
    /**
     * 起始位置
     */
    16: optional i32 offset = Type.NULL_INT,
    /**
     * 获取数量
     */
    17: optional i32 limit = Type.NULL_INT,
    /**
     * os 目标操作系统
     */
    18: optional Standard.TOSType os
}

/**
 * 私信查询
 */
struct TPrivateMessageQuery {
    1: TMessageQuery messageQuery,
    /**
     * 接受者
     */
    2: optional i64 receiverId = Type.NULL_LONG,
    /**
     * 消息状态
     */
    3: optional TMessageStatus status,
    /**
     * 是否已读
     */
    4: optional bool readed = false
}

/**
 * 发送历史查询
 */
struct TMessageHistoryQuery {
    1: TMessageQuery messageQuery,
    /**
     * 消息id
     */
    2: optional i64 messageId = Type.NULL_LONG,
    /**
     * 是否发送成功
     */
    3: optional bool ok = true,
    /**
     * 接受者联系方式
     */
    4: optional string receiverContact,
}

/**
 * 消息获取数据选项
 */
struct TMessageFetchOption {
    /**
     * 完整数据
     */
    1: optional bool all = false,
    /**
     * 附加数据
     */
    2: optional bool attr = false,
    /**
     * 父消息
     */
    3: optional bool parent = false,
    /**
     * 附件列表
     */
    4: optional bool attachment = false,
    /**
     * 发送者
     */
    5: optional Identity.TUserDataOptions sender,
    /**
     * 接受者
     */
    6: optional Identity.TUserDataOptions receiver
}

/**
 * 消息分页对象
 *
 * @field items 列表
 *
 * @field total 总数
 */
struct TMessagePage {
    1: optional list<TMessage> items,
    2: optional i32 total = Type.NULL_INT
}

/**
 * 站内消息分页对象
 *
 * @field items 列表
 *
 * @field total 总数
 *
 * @field cursor 游标
 */
struct TPrivateMessagePage {
    1: optional list<TPrivateMessage> items,
    2: optional i32 total = Type.NULL_INT,
    3: optional i64 cursor = Type.NULL_LONG,
}

/**
 * 消息历史分页对象
 *
 * @field items 列表
 *
 * @field total 总数
 */
struct TMessageHistoryPage {
    1: optional list<TMessageHistory> items,
    2: optional i32 total = Type.NULL_INT
}

/**
 * 消息服务
 *
 * @tables t_scc_message
 *            t_scc_message_history
 *            t_scc_message_inbox
 *            t_scc_message_timeline
 */
service TMessageService {
    /**
     * 发送消息,注意消息是异步发送的,可以通过发送历史id来获取发送状态
     * 如果是站内消息,接收者为空表示存为草稿箱,否则存到发件箱
     *
     * 1. 先判断message类型,若为站内消息且设置了编号,若编号对应的message存在则更新该message,否则在数据库新建一条message记录
     * 2. 若为站内消息,
     *    3.1 接收者不为空
     *        3.1.1 若发送者和接收者不是同一个人,保存站内信到接收者的收件箱(message中parentId对应的parent若存在,也保存该parentId)
     *        3.1.2 保存站内信到发件人的发件箱
     *       3.2   接收者为空,则保存该记录到发件人的草稿箱
     *    3.3 站内信在获取时才进行渲染
     * 3. 若为email
     *       4.1 首先从身份服务获取接收者的邮箱(user对象的email属性),若没有则不发
     *    4.2 发送前,先往消息历史表中插入一条数据,状态为发送失败
     *    4.3 再获取bizKey获取消息模板配置,通过模板引擎渲染消息内容
     *    4.4 发送email,若发送成功则将消息历史的状态设置成成功,否则将错误信息更新到这条发送历史中
     * 4. 若为手机短信
     *    5.1 首先从身份服务获取接收者的手机(user对象的mobile属性),若没有则不发
     *    5.2 发送前,先往消息历史表中插入一条数据,状态为发送失败
     *    5.3 再获取bizKey获取消息模板配置,通过模板引擎渲染消息内容
     *    5.4 发送手机短信,若发送成功则将消息历史的状态设置成成功,否则将错误信息更新到这条发送历史中
     *
     * @param userIds 接收者列表
     *
     * @param option 发送参数
     *
     * @param message 消息
     *
     * @return 消息id
     */
    i64 send(1: list<i64> userIds, 2: TSendOption option, 3: TMessage message) throws (1: Type.TSccException ex),

    /**
     * 直接向目标发送消息
     *
     * 同send接口,只是message的类型必须为email,push,或手机短信(去掉站内信那部分逻辑)
     * 手机或email,imei地址直接在targets中设置(不同于send要从receiver的身份去取)
     *
     * @param userIds 接收者列表
     *
     * @param option 发送参数
     *
     * @param message 消息
     *
     * @return 消息id
     */
    i64 directSend(1: list<string> targets, 2: TSendOption option, 3: TMessage message) throws (1: Type.TSccException ex),

	/**
     * 发送消息(idsNos)
     *
     * @param idsNos 接收者列表
     *
     * @param option 发送参数
     *
     * @param message 消息
     *
     * @return 消息id
     */
    i64 sendByIdsNos(1: list<string> idsNos, 2: TSendOption option, 3: TMessage message) throws (1: Type.TSccException ex),
    
    /**
     * 发送到虚拟组
     *
     * @param group 接受的虚拟组
     *
     * @param option 发送参数
     *
     * @param message 消息
     *
     * @return 消息id
     */
    i64 sendToGroup(1: Identity.TVGroup group, 2: TSendOption option, 3: TMessage message) throws (1: Type.TSccException ex),

    /**
     * 批量更新站内消息的状态
     *
     * @param ids 用户id
     *
     * @param readAt 消息阅读时间
     *
     * @param ids    消息id列表
     */
    void updatePrivateMessageReadAt(1: list<i64> ids, 2: i64 readAt) throws (1: Type.TSccException ex),

    /**
     * 批量更新站内消息的状态
     *
     * @param ids 用户id
     *
     * @param status 消息状态
     */
    void updatePrivateMessageStatus(1: list<i64> ids, 2: TMessageStatus status) throws (1: Type.TSccException ex),

    /**
     * 获取一条站内消息
     *
     * @param id 消息id
     *
     * @param option 数据抓取选项
     *
     * @return 站内消息
     */
    TPrivateMessage getPrivateMessage(1: i64 id, 2: TMessageFetchOption option) throws (1: Type.TSccException ex),

    /**
     * 根据id批量获取站内消息
     *
     * @param ids id列表
     *
     * @param option 数据抓取选项
     *
     * @return 站内消息map
     */
    map<i64, TPrivateMessage> mgetPrivateMessages(1: list<i64> ids, 2: TMessageFetchOption option) throws (1: Type.TSccException ex),

    /**
     * 根据消息分类获取未读站内消息数量
     *
     * @param userId 用户id
     *
     * @param bizKey 业务key,空表示所有业务
     *
     * @param cursor 查询游标
     *
     * @param os 目标操作系统
     *
     * @return 未读站内消息数量map
     */
    i32 getUnreadPrivateMessageCount(1: i64 userId, 2: string bizKey, 3: i64 cursor, 4: Standard.TOSType os) throws (1: Type.TSccException ex),

    /**
     * 根据消息分类列表批量获取未读站内消息数量map
     *
     * @param userId 用户id
     *
     * @param catalogs 业务key列表,空表示所有
     *
     * @param cursor 查询游标
     *
     * @param os 目标操作系统
     *
     * @return 未读站内消息数量map
     */
    map<string, i32> mgetUnreadPrivateMessageCounts(1: i64 userId, 2: list<string> bizKeys, 3: i64 cursor, 4: Standard.TOSType os) throws (1: Type.TSccException ex),

    /**
     * 检索站内消息
     *
     * @param query 检索对象
     *
     * @param option 数据抓取选项
     *
     * @return 站内消息分页对象
     */
    TPrivateMessagePage queryPrivateMessage(1: TPrivateMessageQuery query, 2: TMessageFetchOption option) throws (1: Type.TSccException ex),

    /**
     * 获取一条发送历史
     *
     * @param messageHistoryId 消息历史id
     *
     * @return 发送历史
     */
    TMessageHistory getMessageHistory(1: i64 messageHistoryId) throws (1: Type.TSccException ex),

    /**
     * 检索发送历史
     *
     * 1. 从数据库中查询满足条件的站内消息
     * 2. 按照getMessage相同的逻辑渲染消息内容
     *
     *
     * @param query 检索对象
     *
     * @return 发送历史分页对象
     */
    TMessageHistoryPage queryMessageHistory(1: TMessageHistoryQuery query) throws (1: Type.TSccException ex),
    /**
     * 检索消息
     *
     * @param query 检索对象
     *
     * @param option 数据抓取选项
     *
     * @return 消息分页对象
     */
    TMessagePage queryMessage(1: TMessageQuery query, 2: TMessageFetchOption option) throws (1: Type.TSccException ex),

	/**
	 * 获得当前短信通道
	 * @return 短信通道
	 */
	TSmsChannel getChannel() throws (1: Type.TSccException ex),
	
	/**
	 * 设置当前短信通道
	 *
	 * @param channel 短信通道
	 */
	void setChannel(1: TSmsChannel channel) throws (1: Type.TSccException ex)
}
