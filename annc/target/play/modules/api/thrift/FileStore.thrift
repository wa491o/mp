/*
 * 文件服务
 *
 * 异常号段：400~429
 */

include "Type.thrift"
include "Identity.thrift"

namespace java com.wisorg.scc.api.internal.fs
namespace js FileStore
namespace cocoa Fs

/**
 * 表示支持的图片变换类型
 *
 * @field RESIZE 等比缩放
 *
 * @field CROP 裁剪
 *
 * @field ROTATE 旋转
 *
 * @field WATERMARK 水印
 */
enum TOperate {
	RESIZE,
	CROP,
	ROTATE,
	WATERMARK
}

/**
 * 默认token有效期,10分钟
 */
const i32 TTL_DEFAULT = 600;
/**
 * 头像空间
 */
const string BIZ_AVATAR = "avatar";
/**
 * 图片
 */
const string BIZ_IMAGE = "image";
/**
 * 视频
 */
const string BIZ_VIDEO = "video";
/**
 * 应用文件
 */
const string BIZ_APP = "app";

/**
 * 文件描述信息,通过主键或者业务加所有者即可获得所关联的文件信息
 *
 * @field id 文件的id,主键
 *
 * @field bizKey 文件所属的业务key
 *
 * @field catalog 文件的分类
 *
 * @field owner 文件的所有者,建议为业务对象的主键,这样配合bizKey就可以确定和这个业务对象向关联的所有文件
 *
 * @field index 文件序号,用来排序或者根据序号获取文件
 *
 * @field userId 文件的关联用户,表示文件由哪个用户上传
 *
 * @field name 文件的名称
 *
 * @field desc 文件的描述
 *
 * @field size 文件的大小
 *
 * @field meta 文件的元数据,如图片大小,视频长度
 *
 * @field attr 文件的附加属性
 *
 * @field updateAt 文件的最后更新时间
 *
 * @field scope 文件的访问权限级别
 */
struct TFile {
	1: optional i64 id = Type.NULL_LONG,
	2: optional string bizKey,
	3: optional string catalog,
	4: optional string owner,
	5: optional i32 index = Type.NULL_INT,
	6: optional i64 userId = Type.NULL_LONG,
	7: optional string name,
	8: optional string desc,
	9: optional i32 size = Type.NULL_INT,
	10: optional i64 updateAt = Type.NULL_LONG,
	11: optional map<string, string> meta,
	12: optional map<string, string> attr,
	13: optional Type.TAccessScope scope,
	14: optional Identity.TUser user,
}

/**
 * 文件查询
 */
struct TFileQuery {
	/**
	 * 应用key
	 */
	1: optional string appKey,
	/**
	 * 业务key
	 */
	2: optional string bizKey,
	/**
	 * 所有者
	 */
	3: optional string catalog,
	/**
	 * 所有者
	 */
	4: optional string owner,
	/**
	 * 用户id
	 */
	5: optional i64 userId = Type.NULL_LONG,
	/**
	 * 文件名模糊查询
	 */
	6: optional string keyword,
	/**
	 * 起始位置
	 */
	7: optional i32 offset = Type.NULL_LONG,
	/**
	 * 获取数量
	 */
	8: optional i32 limit = Type.NULL_LONG
}

/**
 * 文件获取数据选项
 */
struct TFileFetchOption {
	/**
	 * 完整数据
	 */
	1: optional bool all = false,
	/**
	 * 创建人信息，为空表示不取
	 */
	2: optional Identity.TUserDataOptions user
}

/**
 * 文件列表分页对象
 *
 * @field items 文件列表
 *
 * @field total 文件总数
 */
struct TFilePage {
	1: optional list<TFile> items,
	2: optional i32 total = Type.NULL_INT
}

/**
 * 图片变换操作
 *
 * @field operate 操作类型
 *
 * @field params 附加参数
 */
struct TAction {
	1: optional TOperate operate,
	2: optional map<string, string> param
}

/**
 * 文件存储服务
 *
 * @tables t_scc_file
 */
service TFileStoreService {
	/**
	 * 保存一个文件,当id为空时则为新建
	 *
	 * 1. 若id不为空,获取id对应的file对象,设置传入的新属性后更新 (可更新owner,userId,name,scope,attr属性)
	 * 2. 若id为空,则新建一个file对象
	 *
	 * @param file 待保存的文件信息
	 *
	 * @return 包含id的文件
	 */
	TFile saveFile(1: TFile file) throws (1: Type.TSccException ex),

	/**
	 * 批量删除文件
	 * 1. 批量将对应的数据库记录的status属性设置成Status.DELETED(逻辑删除)
	 * 2. 真实文件不做删除
	 *
	 * @param ids 文件id列表
	 */
	void removeFiles(1: list<i64> ids) throws (1: Type.TSccException ex),

	/**
	 * 批量删除和某个所有者相关联的所有文件
	 * 1. 批量将对应的数据库记录的status属性设置成Status.DELETED(逻辑删除)
	 * 2. 真实文件不做删除
	 *
	 * @param bizKey 业务key
	 *
	 * @param owner 所有者
	 */
	void removeFilesByOwner(1: string bizKey, 2: string owner) throws (1: Type.TSccException ex),

	/**
	 * 将二进制内容写入到目标文件的指定位置
	 *
	 * 1. 根据文件编号获取数据库中的文件记录
	 * 2. 根据文件选择存储对象(storage)
	 * 3. 获取file的key(fs-加上文件编号)
	 * 4. 把这个key进行md5加密,'加密结果前两位/加密结果第三、四位/加密结果',作为文件的子路径
	 * 5. 如果storage配置了useXsendfile为true的话,子路径前加上'/文件编号/'组成xpath
	 * 6. 检查并创建这个文件
	 *       6.1 若该路径下文件已存在,则跳过
	 *    6.2 若文件不存在,检查并创建父文件路径,创建该文件
	 * 7. 写入从起始位置开始,写入一定长度的二进制文件
	 * 8. 文件设置大小信息
	 * 9. 更新数据库中的文件信息
	 *
	 * @param id 文件id
	 *
	 * @param binary 二进制内容
	 *
	 * @param position 起始位置
	 *
	 * @param binary 二进制内容
	 *
	 * @throws FsException <ul>
	 *     <li>401 IO错误</li>
	 *     <li>402 文件未找到</li>
	 * </ul>
	 *
	 */
	void writeFile(1: i64 id, 2: binary bytes, 3: i32 position) throws (1: Type.TSccException ex),

	/**
	 * 结束写文件,写完文件调用用来更新文件元数据信息
	 */
	TFile finishWriteFile(1: i64 id) throws (1: Type.TSccException ex),
	
	/**
	 * 将url文件写入本地id指定的文件
	 * 
	 * @param id 文件id
	 * 
	 * @param url 远程文件的url地址
	 * 
	 * @throws FsException <ul>
	 *     <li>401 IO错误</li>
	 *     <li>402 文件未找到</li>
	 * </ul>
	 */
	void writeFileFromUrl(1: i64 id, 2: string url) throws (1: Type.TSccException ex),

	/**
	 * 从目标文件中读取文件二进制内容
	 *
	 * 1. 同writeFile逻辑一致,获取文件存放路径
	 * 2. 根据路径找到文件,读取文件起始位置开始,一定长度的二进制流
	 *
	 * @param id 文件id
	 *
	 * @param position 起始位置
	 *
	 * @param count 要读取的长度
	 *
	 * @return 读取的二进制内容
	 *
	 * @throws FsException <ul>
	 *     <li>401 IO错误</li>
	 *     <li>402 文件未找到</li>
	 * </ul>
	 *
	 */
	binary readFile(1: i64 id, 2: i32 position, 3: i32 count) throws (1: Type.TSccException ex),

	/**
	 * 变换一个图片
	 *
	 * 涉及到的参数
	 *
	 * 1. 同writeFile逻辑一致,获取文件存放路径
	 * 2. 如果文件是图片(后缀为"gif", "bmp", "jpg", "jpeg", "png"之一),则进行后续操作(本系统由AwtImageTransform进行图片相关操作)
	 * 3. 若操作为缩放,则调用图片缩放接口,由宽度为限制条件(若实际图片宽度>目标宽度,则缩放比例为目标宽度/实际宽度),等比缩放
	 * 4. 若操作为裁剪,则调用图片裁剪接口,截取从图片左上角为坐标轴原点,第四象限中(left,-top)这个点为起点,x轴正方向width宽度,y轴反方向height高度组成的矩形
	 * 5. 若操作为翻转,则选取从图片左上角为坐标轴原点,第四象限中(left,-top)这个点为旋转中心点,以逆时针方向旋转一定角度
	 * 6. 操作完成后,更新数据库中文件的大小
	 *
	 * @param id 文件id
	 *
	 * @param actions 变换操作列表
	 */
	void transformImage(1: i64 id, 2: list<TAction> actions) throws (1: Type.TSccException ex),

	/**
	 * 获取一个文件的访问token,通过url携带这个token实现文件的自定义权限
	 *
	 * @param ids 文件id
	 *
	 * @param writeable 是否可写
	 *
	 * @param ttl token的有效时间,单位秒
	 *
	 * @return token字符串
	 *
	 */
	string getToken(1: list<i64> ids, 2: bool writeable = false, 3: i32 ttl = TTL_DEFAULT) throws (1: Type.TSccException ex),

	/**
	 * 获取业务文件的访问token,通过url携带这个token实现文件的自定义权限
	 *
	 * @param bizKey 业务key
	 *
	 * @param owners 所有者列表
	 *
	 * @param writeable 是否可写
	 *
	 * @param ttl token的有效时间,单位秒
	 *
	 * @return 业务token字符串
	 *
	 */
	string getBizToken(1: string bizKey, 2: list<string> owners, 3: bool writeable = false, 4: i32 ttl = TTL_DEFAULT) throws (1: Type.TSccException ex),

	/**
	 * 绑定文件的读取权限到会话session
	 *
	 * @param token 会话token
	 *
	 * @param ids 文件id列表
	 */
	void bindSession(1: string token, 2: list<i64> ids) throws (1: Type.TSccException ex),
	/**
	 * 取消绑定文件的读取权限到会话session
	 *
	 * @param token 会话token
	 *
	 * @param ids 文件id列表
	 */
	void unbindSession(1: string token, 2: list<i64> ids) throws (1: Type.TSccException ex),

	/**
	 * 获取一个文件
	 *
	 * 1.仅获取数据库中的一个文件对象
	 *
	 * @param id 文件id
	 *
	 * @return 文件
	 *
	 */
	TFile getFile(1: i64 id) throws (1: Type.TSccException ex),

	/**
	 * 根据id批量获取文件
	 *
	 * @param ids 文件id列表
	 *
	 * @return 文件map
	 *
	 */
	map<i64, TFile> mgetFiles(1: list<i64> ids) throws (1: Type.TSccException ex),

	/**
	 * 获取某个业务对象关联的文件
	 * 例如用户的头像可以用getSingleFile(BIZ_AVATAR, "888")来获取888用户的头像文件信息
	 *
	 * @param bizKey 业务key
	 *
	 * @param owner 所有者
	 *
	 * @return 文件
	 *
	 */
	TFile getSingleFile(1: string bizKey, 2: string owner) throws (1: Type.TSccException ex),

	/**
	 * 根据所有者序号获取文件
	 *
	 * @param bizKey 业务key
	 *
	 * @param owner 所有者
	 *
	 * @param index 文件序号
	 *
	 * @return 文件
	 *
	 */
	TFile getFileByIndex(1: string bizKey, 2: string owner, 3: i32 index) throws (1: Type.TSccException ex),

	/**
	 * 根据文件序号列表获取文件列表,不存在的序号会被忽略
	 *
	 * @param bizKey 业务key
	 *
	 * @param owner 所有者
	 *
	 * @param indexs 序号列表
	 *
	 * @return 文件列表
	 *
	 */
	list<TFile> getFilesByIndexs(1: string bizKey, 2: string owner, 3: list<i32> indexs) throws (1: Type.TSccException ex),

	/**
	 * 批量根据文件序号列表获取文件列表,不存在的序号会被忽略
	 *
	 * @param bizKey 业务key
	 *
	 * @param indexsMap 嵌套map,map<owner, list<index>>
	 *
	 * @return 文件
	 *
	 */
	map<string, list<TFile>> mgetFilesByIndexs(1: string bizKey, 2: map<string, list<i32>> indexsMap) throws (1: Type.TSccException ex),

	/**
	 * 获取某个业务对象关联的文件,例如要获取某个帖子相关的附件,,按文件上传倒序排序
	 *
	 * @param bizKey 业务key
	 *
	 * @param owner 所有者
	 *
	 * @return 文件列表
	 *
	 */
	list<TFile> getFilesByOwner(1: string bizKey, 2: string owner) throws (1: Type.TSccException ex),

	/**
	 * 根据owner列表批量获取某个业务对象关联的文件
	 *
	 * @param bizKey 业务key
	 *
	 * @param owners 所有者列表
	 *
	 * @return 文件列表map
	 *
	 */
	map<string, list<TFile>> mgetFilesByOwners(1: string bizKey, 2: list<string> owners) throws (1: Type.TSccException ex),

	/**
	 * 根据多个bizKey,多个owner获取文件,格式map<bizKey, list<owner>>
	 *
	 * @param ownersMap 嵌套map,map<bizKey, list<owner>>
	 *
	 * @param owners 所有者列表
	 *
	 * @return 嵌套map,map<bizKey, map<owner, list<File>>>
	 *
	 */
	map<string, map<string, list<TFile>>> mgetFilesByOwnersEx(1: map<string, list<string>> ownersMap) throws (1: Type.TSccException ex),

	/**
	 * 检索文件,按文件上传倒序排序
	 *
	 * @param query 检索对象
	 *
	 * @param option 数据抓取选项
	 *
	 * @return 文件分页对象
	 *
	 */
	TFilePage queryFile(1: TFileQuery query, 2: TFileFetchOption option) throws (1: Type.TSccException ex),
	
	/**
	 * 优化文件系统，如：清理未被使用的磁盘文件，释放磁盘空间等
	 */
	void optimize() throws (1: Type.TSccException ex)
}
