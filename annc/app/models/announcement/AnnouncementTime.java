package models.announcement;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Comment;

import models.identity.User;
import play.db.jpa.Model;

@Entity
@Table(name = "T_SCC_ANNOUNCEMENT_TIME")
@Comment("通知公告时间数据")
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
public class AnnouncementTime extends Model {

    private static final long serialVersionUID = -1821170219746916177L;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANNOUNCEMENT")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("通知公告标识")
    public Announcement announcement;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CREATOR")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("创建者标识")
    public User creator;

    @Column(name = "TIME_CREATE")
    @Comment("创建时间")
    public Long createTime;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_UPDATOR")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("修改者标识")
    public User updator;

    @Column(name = "TIME_UPDATE")
    @Comment("修改时间")
    public Long updateTime;

    public AnnouncementTime(Announcement announcement) {
        super();
        this.announcement = announcement;
    }

}
