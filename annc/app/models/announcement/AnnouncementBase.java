package models.announcement;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Comment;

import play.data.validation.MinSize;
import play.data.validation.Required;
import play.db.jpa.Model;

@Entity
@Table(name = "T_SCC_ANNOUNCEMENT_BASE")
@Comment("通知公告基础数据")
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
public class AnnouncementBase extends Model {

    private static final long serialVersionUID = 356081227674374277L;

    /**
     * 通知公告标识
     */
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANNOUNCEMENT")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("通知公告标识")
    public Announcement announcement;

    /**
     * 通知公告标题
     */
    @Required
    @MinSize(value = 2)
    @Comment("标题")
    public String title;

    /**
     * 摘要
     */
    @Comment("摘要")
    public String summary;

    /**
     * 通知公告来源图标
     */
    @Column(name = "ID_ICON")
    @Comment("来源图标")
    public Long smallIcon;

    public AnnouncementBase(Announcement announcement) {
        super();
        this.announcement = announcement;
    }
}
