package services.announcement.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import models.announcement.CrawTemplateQuery;
import models.announcement.CrawlTemplate;
import models.announcement.CrawlTemplatePage;
import models.announcement.SubscribeSource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import play.db.jpa.GenericModel.JPAQuery;
import services.announcement.CrawlTemplateService;

import com.google.common.collect.Maps;
import com.wisorg.scc.api.internal.announcement.TCrawlTemplate;
import com.wisorg.scc.api.internal.core.data.Pageable;
import com.wisorg.scc.api.internal.core.ex.SccException;
import com.wisorg.scc.api.internal.domain.model.Domain;
import com.wisorg.scc.api.internal.domain.model.DomainService;

@Service
public class CrawlTemplateServiceImpl implements CrawlTemplateService{
	
	@Inject
	private DomainService domainService;

	@Override
	public CrawlTemplatePage queryCrawlTemplates(CrawTemplateQuery query) throws SccException {
		CrawlTemplatePage page = new CrawlTemplatePage();
		Map<String, Object> paramList = Maps.newHashMap();
		StringBuffer jpql = new StringBuffer("from CrawlTemplate t where 1=1");
		if(null != query){
			if(StringUtils.isNoneBlank(query.getName())){
				jpql.append(" and t.name=:name");
				paramList.put("name", query.getName());
			}
			if(StringUtils.isNoneBlank(query.getDomainKey())){
				jpql.append(" and t.domain.key=:key");
				paramList.put("key", query.getDomainKey());
			}
		}

		String countjpql = "select count(t.id) " + jpql;
		page.setTotal(CrawlTemplate.count(countjpql, paramList));
		if (page.getTotal() > 0) {
			JPAQuery q = CrawlTemplate.find(jpql.toString(), paramList).from(
					Long.valueOf(query.getOffset()).intValue());
			List<CrawlTemplate> crawlTemplateList = query.getLimit() < 0 ? q.<CrawlTemplate> fetch() : q
					.<CrawlTemplate> fetch(Long.valueOf(query.getLimit()).intValue());
		
			List<TCrawlTemplate> tCrawlTemplateList = new ArrayList<TCrawlTemplate>(crawlTemplateList.size());
			for (CrawlTemplate p : crawlTemplateList) {
				TCrawlTemplate v = new TCrawlTemplate();
				v.setDirectory(StringUtils.defaultString(p.directory, ""));
				v.setDomainKey(p.domain == null ? null : p.domain.getKey());
				v.setDomainName(p.domain == null ? null : p.domain.getName());
				v.setId(p.id.longValue());
				v.setName(StringUtils.defaultString(p.name, ""));
				v.setUrlList(StringUtils.defaultString(p.urlList, ""));
				tCrawlTemplateList.add(v);
			}
			page.setItems(tCrawlTemplateList);
		}else {
			page.setItems(new ArrayList<TCrawlTemplate>(0));
		}
		return page;
	}

	
	@Override
	@Transactional
	public void saveCrawlTemplate(TCrawlTemplate tCrawlTemplate)
			throws SccException {
		if(null != tCrawlTemplate){
			CrawlTemplate crawlTemplate = null;
			if(tCrawlTemplate.getId() > 0){
				crawlTemplate = CrawlTemplate.findById(tCrawlTemplate.getId());
			}else{
				crawlTemplate = new CrawlTemplate();
			}
			crawlTemplate.directory = tCrawlTemplate.getDirectory();
			crawlTemplate.urlList = tCrawlTemplate.getUrlList();
			crawlTemplate.name = tCrawlTemplate.getName();
			
			if(tCrawlTemplate.getDomainKey() != null){
				Domain domain = domainService.getByKey(tCrawlTemplate.getDomainKey());
				crawlTemplate.domain = domain;
			}
			
			crawlTemplate.save();
		}
	}

	@Override
	@Transactional
	public boolean deleteCrawlTemplate(long id) throws SccException {
		boolean b = true;
		if(id > 0){
			JPAQuery q = SubscribeSource.find("from SubscribeSource t where t.template.id=?", id);
			if(q.fetch().size() > 0){
				b = false;
			}else{
				CrawlTemplate.delete("from CrawlTemplate t where t.id=?", id);
			}
		}
		return b;
	}	
}
