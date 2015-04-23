package models.announcement;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Comment;

import play.db.jpa.Model;

import com.wisorg.scc.api.internal.announcement.TAnnouncementStatus;
import com.wisorg.scc.api.internal.core.entity.Status;

/**
 * 通知公告
 * 
 * @author Administrator
 * 
 */
@Entity
@Table(name = "T_SCC_ANNOUNCEMENT")
@Comment("通知公告数据")
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
public class Announcement extends Model {
    private static final long serialVersionUID = 140957546558026374L;

    /**
     * 通知公告基本信息
     */
    @OneToOne(fetch = FetchType.LAZY, mappedBy = "announcement", cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    public AnnouncementBase baseInfo = new AnnouncementBase(this);

    /**
     * 通知公告详细信息
     */
    @OneToOne(fetch = FetchType.LAZY, mappedBy = "announcement", cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    public AnnouncementDetail detailInfo = new AnnouncementDetail(this);

    /**
     * 通知公告时间信息
     */
    @OneToOne(fetch = FetchType.LAZY, mappedBy = "announcement", cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    public AnnouncementTime timeInfo = new AnnouncementTime(this);

    /**
     * 附件
     */
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "announcement", cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    public List<AnnouncementAttach> attach;

    /**
     * 通知公告状态
     */
    @Comment("状态")
    public TAnnouncementStatus status = TAnnouncementStatus.ONLINE;
    
    /**
     * 数据状态（2014-09-15 新增）
     */
    @Column(name = "DATA_STATUS")
    @Comment("数据状态")
    public Status dataStatus = Status.ENABLED;
}
