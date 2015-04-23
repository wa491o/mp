package models.announcement;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Comment;

import play.db.jpa.Model;

@Entity
@Table(name = "T_SCC_ANNOUNCEMENT_DETAIL")
@Comment("通知公告详情数据")
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
public class AnnouncementDetail extends Model {
    private static final long serialVersionUID = 5555298373579248739L;

    /**
     * 通知公告标识
     */
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANNOUNCEMENT")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("通知公告标识")
    public Announcement announcement;

    /**
     * 订阅源类别
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CATEGORY")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("订阅源标识")
    public SubscribeSource category;

    /**
     * 发布时间
     */
    @Column(name = "TIME_ONLINE")
    @Comment("发布时间")
    public Long onlineTime;

    /**
     * 作者
     */
    @Comment("作者")
    public String author;

    /**
     * 来源
     */
    @Comment("来源")
    public String source;

    /**
     * 统计信息
     */
    @Column(name = "VIEW_COUNT")
    @Comment("浏览数")
    public Long viewCount = 0L;

    /**
     * 正文
     */
    @Column()
    @Lob
    @Comment("正文内容")
    public String content;

    /**
     * 通知公告详情页面地址
     */
    @Column(name = "URL_SOURCE", length = 2000)
    @Comment("通知公告详情页面地址")
    public String sourceUrl;

    public static boolean exist(Long subscribeSourceId, String sourceURL) {
        return (Long) find("select count(id) from AnnouncementDetail t where t.sourceUrl = ?1 and t.category.id = ?2",
                sourceURL, subscribeSourceId).fetch().get(0) != 0;
    }
    
    public static AnnouncementDetail findByUrl(Long subscribeSourceId, String sourceURL) {
    	AnnouncementDetail details = AnnouncementDetail.find("sourceUrl = ?1 and category.id = ?2",sourceURL, subscribeSourceId).first();
 		return details;
    }

    public static long incrViewCount(Long announcementId) {
        AnnouncementDetail announcementDetail = AnnouncementDetail.find("announcement.id = ?1", announcementId).first();
        announcementDetail.viewCount = announcementDetail.viewCount + 1;
        announcementDetail.save();
        return announcementDetail.viewCount;
    }

    public AnnouncementDetail(Announcement announcement) {
        super();
        this.announcement = announcement;
    }
}
