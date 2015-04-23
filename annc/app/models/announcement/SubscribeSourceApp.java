package models.announcement;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import models.application.Application;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Comment;

import play.db.jpa.Model;

@Entity
@Table(name = "T_SCC_ANNOUNCEMENT_SUB_APP")
@Comment("订阅源与应用之间的关联关系")
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
public class SubscribeSourceApp extends Model {

    private static final long serialVersionUID = 6346989592341950510L;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_APP")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("应用标识")
    public Application app;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SSID")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("订阅源标识")
    public SubscribeSource subscribeSource;
}
