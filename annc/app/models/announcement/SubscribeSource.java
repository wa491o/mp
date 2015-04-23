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

import models.identity.User;
import play.db.jpa.Model;

import com.wisorg.scc.api.internal.announcement.TSubscribeSourceStatus;
import com.wisorg.scc.api.internal.domain.model.Domain;

@Entity
@Table(name = "T_SCC_ANNOUNCEMENT_SUB")
@Comment("通知公告订阅源数据")
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
public class SubscribeSource extends Model {

    private static final long serialVersionUID = 6369970806595989231L;

    /**
     * 通知公告分类名称
     */
    @Column(name = "NAME", length = 40)
    @Comment("订阅源所属分类名称")
    public String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_TEMPLATE")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("模板标识")
    public CrawlTemplate template;

    /**
     * 订阅源状态
     */
    @Column(name = "STATUS")
    @Comment("订阅源状态")
    public TSubscribeSourceStatus subscribeSourceStatus = TSubscribeSourceStatus.ONLINE;

    /**
     * 默认订阅源标识位(1:默认 0:非默认)
     */
    @Column(name = "FLAG_DEFAULT")
    @Comment("是否为默认订阅源")
    public Integer defaultFlag = 0;

    /**
     * 创建人
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CREATOR")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("创建人标识")
    public User creator;

    /**
     * 创建时间
     */
    @Column(name = "TIME_CREATE")
    @Comment("创建时间")
    public Long createTime;

    /**
     * 修改人
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_UPDATOR")
    @Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
    @Comment("修改人标识")
    public User updator;

    /**
     * 域
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DOMAIN_ID")
    @Comment("所属域标识")
    public Domain domain;

    /**
     * 更新时间
     */
    @Column(name = "TIME_UPDATE")
    @Comment("修改时间")
    public Long updateTime;

    public static boolean exist(Long id, String name) {
        if (id == 0L) {
            return (Long) find(
                    "select count(id) from SubscribeSource t where t.name = ?1 and t.subscribeSourceStatus = ?2", name,
                    TSubscribeSourceStatus.ONLINE).fetch().get(0) != 0;
        } else {
            return (Long) find(
                    "select count(id) from SubscribeSource t where t.name = ?1 and t.subscribeSourceStatus = ?2 and t.id <> ?3",
                    name, TSubscribeSourceStatus.ONLINE, id).fetch().get(0) != 0;
        }

    }
    
    public static void goChange(String type, Long id){
    	SubscribeSource ss = findById(id);
    	long time = ss.createTime;
    	String sql = "";
    	if("up".toUpperCase().equals(type.toUpperCase())){
    		sql = " from SubscribeSource where createTime<(?1) order by createTime desc";
    	}else{
    		sql = "from SubscribeSource where createTime>(?1) order by createTime asc";
    	}
    	SubscribeSource ss2 = find(sql, ss.createTime).first();
    	if(null!=ss2){
    		ss.createTime=ss2.createTime;
        	ss.save();
        	ss2.createTime= time;
        	ss2.save();
    	}
    }
}
