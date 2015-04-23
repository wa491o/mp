package models.announcement;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Comment;

import models.identity.Role;
import play.db.jpa.Model;

@Entity
@Table(name = "T_SCC_ANNOUNCEMENT_SUB_ROLE")
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
@Comment("订阅源与角色的关联关系")
public class SubscribeSourceRole extends Model {

    private static final long serialVersionUID = 6346989592341950510L;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ROLE")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("角色标识")
    public Role role;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SSID")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("订阅源标识")
    public SubscribeSource subscribeSource;
}
