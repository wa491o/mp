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

import com.wisorg.scc.api.internal.domain.model.Domain;

import play.data.validation.Unique;
import play.db.jpa.Model;

/**
 * 抓取模板
 */
@Entity
@Table(name = "T_SCC_ANNC_CRAWLTEMPLATE")
@Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE)
@Comment("通知公告的抓取模板数据")
public class CrawlTemplate extends Model {

    private static final long serialVersionUID = -474911953886273702L;

    @Unique
    @Column(name = "NAME", unique = true, length = 100)
    @Comment("模板名称")
    public String name;

    @Column(name = "DIRECTORY", length = 100)
    @Comment("模板路径")
    public String directory;

    @Column(name = "URL_LIST", length = 1000)
    @Comment("抓取的网址")
    public String urlList;

    @Column(name = "URL_DETAIL", length = 1000)
    @Comment("预留字段")
    public String urlDetail;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DOMAIN_ID")
    public Domain domain;

}
