package models.announcement;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import models.identity.User;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Comment;

import play.db.jpa.Model;

import com.wisorg.scc.api.internal.announcement.TSubscribeStatus;

@Entity
@Table(name = "T_SCC_ANNOUNCEMENT_USER_SUB")
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
@Comment("用户订阅数据")
public class UserSubscribeInfo extends Model {

    private static final long serialVersionUID = -7431062291430604434L;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USER_ID")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("用户标识")
    public User creator;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SSID")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("订阅源标识")
    public SubscribeSource subscribeSource;

    @Column(name = "STATUS")
    @Comment("订阅状态")
    public Short status = 1;

    /**
     * 检查用户是否订阅了某个订阅源
     * 
     * @param subscribeSourceId
     * @return
     */
    public static boolean isSubscribe(Long uid, Long subscribeSourceId, TSubscribeStatus status) {
        if (status == null) {
            return count("from UserSubscribeInfo t where t.creator.id = ?1 and t.subscribeSource.id = ?2", uid,
                    subscribeSourceId) > 0;
        } else {
            return count(
                    "from UserSubscribeInfo t where t.creator.id = ?1 and t.subscribeSource.id = ?2 and t.status = ?3",
                    uid, subscribeSourceId, status.getValue()) > 0;
        }
    }
}
