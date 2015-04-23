package services.announcement;

import models.announcement.CrawTemplateQuery;
import models.announcement.CrawlTemplatePage;

import com.wisorg.scc.api.internal.announcement.TCrawlTemplate;
import com.wisorg.scc.api.internal.core.ex.SccException;

/**
 * 抓取模板接口.
 * @author 
 *
 */
public interface CrawlTemplateService {
	
	/**
	 * 查询.
	 * @param query
	 * @return
	 * @throws SccException
	 */
	CrawlTemplatePage queryCrawlTemplates(CrawTemplateQuery query) throws SccException;

	/**
	 * 保存.
	 * @param crawlTemplate
	 * @throws SccException
	 */
	void saveCrawlTemplate(TCrawlTemplate tCrawlTemplate) throws SccException;
	
	/**
	 * 删除.
	 * @param id
	 * @throws SccException
	 */
	boolean deleteCrawlTemplate(long id) throws SccException;
}
