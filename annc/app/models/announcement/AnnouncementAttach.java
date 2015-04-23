package models.announcement;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Comment;

import play.db.jpa.Model;

/**
 * 通知公告附件信息
 * 
 * @author Administrator
 * 
 */
@Entity
@Table(name = "T_SCC_ANNOUNCEMENT_ATTACH")
@Comment("通知公告附件数据")
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
public class AnnouncementAttach extends Model {

    private static final long serialVersionUID = -3984269577603264539L;

    /**
     * 通知公告标识
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANNOUNCEMENT")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("通知公告标识")
    public Announcement announcement;

    /**
     * 附件ID
     */
    @Column(name = "ID_FILE")
    @Comment("附件标识")
    public Long attach;

    public AnnouncementAttach(Announcement announcement) {
        super();
        this.announcement = announcement;
    }
}
