package types.announcement.convert;

import models.announcement.CrawlTemplate;

import org.springframework.stereotype.Component;

import com.wisorg.scc.api.internal.announcement.TCrawlTemplate;
import com.wisorg.scc.core.bean.ObjectConverter;

@Component
public class AnnouncementCrawlTemplateConverter extends ObjectConverter<CrawlTemplate, TCrawlTemplate> {

    @Override
    public void p2v(CrawlTemplate p, TCrawlTemplate v) {
        v.setId(p.id);
        v.setName(p.name);
    }

    @Override
    public void v2p(TCrawlTemplate v, CrawlTemplate p) {
        p.id = v.getId();
        p.name = v.getName();
    }

}
