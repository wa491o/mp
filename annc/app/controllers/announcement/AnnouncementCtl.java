package controllers.announcement;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.inject.Inject;

import models.announcement.CrawTemplateQuery;
import models.announcement.CrawlTemplatePage;
import models.announcement.SubscribeSource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import play.Play;
import play.data.validation.Required;
import play.db.jpa.Transactional;
import play.mvc.Controller;
import play.mvc.With;
import services.announcement.CrawlTemplateService;
import services.announcement.util.AnnouncementCrawUtil;
import types.announcement.AnnouncementErrorCode;
import utils.Sec;

import com.alibaba.fastjson.JSONObject;
import com.wisorg.scc.api.internal.announcement.TAdminTime;
import com.wisorg.scc.api.internal.announcement.TAnnouncement;
import com.wisorg.scc.api.internal.announcement.TAnnouncementBase;
import com.wisorg.scc.api.internal.announcement.TAnnouncementDataOptions;
import com.wisorg.scc.api.internal.announcement.TAnnouncementDetail;
import com.wisorg.scc.api.internal.announcement.TAnnouncementOrder;
import com.wisorg.scc.api.internal.announcement.TAnnouncementPage;
import com.wisorg.scc.api.internal.announcement.TAnnouncementQuery;
import com.wisorg.scc.api.internal.announcement.TAnnouncementService;
import com.wisorg.scc.api.internal.announcement.TAnnouncementStatus;
import com.wisorg.scc.api.internal.announcement.TCrawlTemplate;
import com.wisorg.scc.api.internal.announcement.TSubscribeSource;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceDataOptions;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceQuery;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceStatus;
import com.wisorg.scc.api.internal.core.data.P;
import com.wisorg.scc.api.internal.core.data.Page;
import com.wisorg.scc.api.internal.core.entity.Status;
import com.wisorg.scc.api.internal.core.ex.SccException;
import com.wisorg.scc.api.internal.domain.model.Domain;
import com.wisorg.scc.api.internal.domain.model.DomainQuery;
import com.wisorg.scc.api.internal.domain.model.DomainService;
import com.wisorg.scc.api.internal.fs.TFile;
import com.wisorg.scc.api.internal.identity.TAuthorizationService;
import com.wisorg.scc.api.internal.identity.TRole;
import com.wisorg.scc.api.internal.identity.TRolePage;
import com.wisorg.scc.api.internal.identity.TRoleQuery;
import com.wisorg.scc.api.internal.identity.TRoleType;
import com.wisorg.scc.api.internal.identity.TUser;
import com.wisorg.scc.api.internal.identity.TUserDataOptions;
import com.wisorg.scc.api.internal.identity.TUserService;
import com.wisorg.scc.api.internal.logger.TConsoleLog;
import com.wisorg.scc.api.internal.logger.TLoggerService;
import com.wisorg.scc.api.internal.security.Check;
import com.wisorg.scc.api.type.TypeConstants;
import com.wisorg.scc.core.play.http.HttpUtils;
import com.wisorg.scc.core.security.Constants;

import controllers.AdminSecure;

@With(AdminSecure.class)
@Check("news.admin")
public class AnnouncementCtl extends Controller {
	protected static Logger LOG = LoggerFactory.getLogger(AnnouncementCtl.class);
    private static final int SUBSCRIBESOURCE_NUM = -1;
    /**
     * 公告分页条数
     */
    private static final int NEWSPAGE_SIZE = 15;
    private static final int NEWSPAGE_NUM = 0;
    @Inject
    private static TAnnouncementService.Iface announcementService;
    @Inject
    private static TAuthorizationService.Iface roleService;
    @Inject
    private static TUserService.Iface userService;
    @Inject
    private static TLoggerService.Iface loggerService;
    @Inject
    private static AnnouncementCrawUtil util;
    @Inject
    private static CrawlTemplateService crawlTemplateService;
    @Inject
    private static DomainService domainService;

    /**
     * 通知公告首页
     */
    public static void announcementIndex() {
        TSubscribeSourceQuery sourceq = new TSubscribeSourceQuery();
        sourceq.setStatus(TSubscribeSourceStatus.ONLINE);
        sourceq.setLimit(SUBSCRIBESOURCE_NUM);
        TSubscribeSourceDataOptions sourceoption = new TSubscribeSourceDataOptions();
        sourceoption.setAll(true);
        List<TSubscribeSource> soureList = announcementService.querySubscribeSources(sourceq, sourceoption);
        render(soureList);
    }

    /**
     * 获取公告数据
     */
    public static void getAnnouncements(Long idSubSource) {
        TAnnouncementQuery queryAnns = new TAnnouncementQuery();
        String page = params.get("page");
        if (idSubSource != null && TypeConstants.NULL_LONG != idSubSource.longValue()) {
            Set<Long> list = new HashSet<Long>();
            list.add(idSubSource);
            queryAnns.setCatIds(list);
        }
        queryAnns.setLimit(NEWSPAGE_SIZE);
        if (StringUtils.isNotEmpty(page))
            queryAnns.setOffset((Integer.parseInt(page) - 1) * NEWSPAGE_SIZE);
        else
            queryAnns.setOffset(NEWSPAGE_NUM);
        List<TAnnouncementOrder> order = new ArrayList<TAnnouncementOrder>();
        order.add(TAnnouncementOrder.ONLINE_TIME_DESC);
        queryAnns.setOrders(order);
        TAnnouncementDataOptions annOptions = new TAnnouncementDataOptions();
        annOptions.setAll(true);
        TAnnouncementPage annPage = announcementService.queryAnnouncements(queryAnns, annOptions);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("total", annPage.getTotal());
        map.put("rows", annPage.getItems());
        map.put("page", page);
        renderJSON(map);
    }

    /**
     * 进入发布公告页面
     */
    public static void addAnnouncement() {
        TSubscribeSourceQuery sourceq = new TSubscribeSourceQuery();
        sourceq.setStatus(TSubscribeSourceStatus.ONLINE);
        sourceq.setLimit(SUBSCRIBESOURCE_NUM);
        TSubscribeSourceDataOptions sourceOptions = new TSubscribeSourceDataOptions();
        sourceOptions.setBase(true);
        List<TSubscribeSource> soureList = announcementService.querySubscribeSources(sourceq, sourceOptions);
        TAnnouncement announce = new TAnnouncement();
        announce.setBaseInfo(new TAnnouncementBase());
        announce.setDetailInfo(new TAnnouncementDetail());
        announce.getDetailInfo().setSubscribeSource(new TSubscribeSource());
        String preUrl = Play.configuration.getProperty("fs.domain");
        render(announce, soureList, preUrl);
    }

    /**
     * 编辑公告
     * 
     * @param id
     *            公告ID
     */
    public static void editAnnouncement(@Required Long id) {
        TAnnouncementDataOptions options = new TAnnouncementDataOptions();
        options.setAll(true);
        TAnnouncement announce = announcementService.getAnnouncement(id, options);
        TSubscribeSourceQuery sourceq = new TSubscribeSourceQuery();
        sourceq.setStatus(TSubscribeSourceStatus.ONLINE);
        sourceq.setLimit(SUBSCRIBESOURCE_NUM);
        TSubscribeSourceDataOptions sourceOptions = new TSubscribeSourceDataOptions();
        sourceOptions.setAll(true);
        List<TSubscribeSource> soureList = announcementService.querySubscribeSources(sourceq, sourceOptions);
        String preUrl = Play.configuration.getProperty("fs.domain");
        render("@addAnnouncement", announce, soureList, preUrl);
    }

    /**
     * 保存公告
     */
    @Transactional
    public static void saveAnnouncement(Long idAnnouncement, String title, Long idSubSource, String summary,
            String content, String from, String author, List<Long> attachList, Integer defaultPush) {
        String msg = "";
        Map<String, String> map = new HashMap<String, String>(1);
        try {
            TAnnouncement announcement = null;
            TUserDataOptions option = new TUserDataOptions();
            option.setAll(true);
            TUser user = userService.getUser(Sec.getUserId(), option);
            TAdminTime adminTime = null;
            TAnnouncementBase newsBasic = null;
            TAnnouncementDetail annDetail = null;

            // 记录操作日志
            TConsoleLog tconsoleLog = new TConsoleLog();
            tconsoleLog.setIP(HttpUtils.getClientIP(request));
            tconsoleLog.setUserAgent(HttpUtils.getHeader(request, "User-Agent"));

            if (idAnnouncement != null && TypeConstants.NULL_LONG != idAnnouncement.longValue()) {
                TAnnouncementDataOptions options = new TAnnouncementDataOptions();
                options.setAll(true);
                announcement = announcementService.getAnnouncement(idAnnouncement, options);
                adminTime = announcement.getAdminTime();
                newsBasic = announcement.getBaseInfo();
                annDetail = announcement.getDetailInfo();
                TSubscribeSourceDataOptions option1 = new TSubscribeSourceDataOptions();
                option1.setAll(true);
                annDetail.setSubscribeSource(announcementService.getSubscribeSource(idSubSource, option1));
                adminTime.setUpdator(user);
                adminTime.setUpdateTime(System.currentTimeMillis());
                tconsoleLog.setDescription("编辑公告");
            } else {
                announcement = new TAnnouncement();
                adminTime = new TAdminTime();
                newsBasic = new TAnnouncementBase();
                annDetail = new TAnnouncementDetail();
                adminTime.setCreator(user);
                adminTime.setCreateTime(System.currentTimeMillis());
                adminTime.setUpdator(user);
                adminTime.setUpdateTime(System.currentTimeMillis());
                TSubscribeSourceDataOptions option1 = new TSubscribeSourceDataOptions();
                option1.setAll(true);
                annDetail.setSubscribeSource(announcementService.getSubscribeSource(idSubSource, option1));
                tconsoleLog.setDescription("创建公告");
            }
            announcement.setAdminTime(adminTime);
            List<TFile> attachment = new ArrayList<TFile>();
            if (attachList != null && attachList.size() > 0) {
                for (Long idFile : attachList) {
                    TFile tFile = new TFile();
                    tFile.setId(idFile);
                    attachment.add(tFile);
                }
            }
            announcement.setAttachment(attachment);
            newsBasic.setTitle(title);
            newsBasic.setSummary(summary);
            annDetail.setOnlineTime(System.currentTimeMillis());
            annDetail.setAuthor(author);
            annDetail.setSource(from);
            annDetail.setContent("<style>img{max-width:100%;height:auto;}</style>" + content);
            announcement.setBaseInfo(newsBasic);
            announcement.setDetailInfo(annDetail);
            announcement.setStatus(TAnnouncementStatus.ONLINE);
            if (defaultPush == 1) {
                announcementService.saveAnnouncement(announcement, true);
            } else {
                announcementService.saveAnnouncement(announcement, false);
            }

            loggerService.createConsoleLog(tconsoleLog, Sec.getUserId());
        } catch (Exception e) {
            msg = "保存公告错误";
            LOG.error(msg,e);
        }
        map.put("msg", msg);
        renderJSON(map);
    }

    /**
     * 屏蔽公告
     * 
     * @param id
     *            公告ID
     */
    @Transactional
    public static void shieldingAnnouncement(Long id, Integer status, List<Long> ids) {
        if (id != null && TypeConstants.NULL_LONG != id.longValue()) {
            announcementService.updateAnnouncementStatus(id, TAnnouncementStatus.findByValue(status));
        }
        if (ids != null && ids.size() > 0) {
            announcementService.updateAnnouncementStatus4Del(ids);
        }
        // 记录操作日志
        TConsoleLog tconsoleLog = new TConsoleLog();
        tconsoleLog.setIP(HttpUtils.getClientIP(request));
        tconsoleLog.setUserAgent(HttpUtils.getHeader(request, "User-Agent"));
        tconsoleLog.setDescription("屏蔽公告");
        loggerService.createConsoleLog(tconsoleLog, Sec.getUserId());
    }

    /**
     * 编辑订阅源,根据ID获取订阅源信息
     * 
     * @param id
     *            订阅源ID
     */
    public static void editSubscribeSource(@Required Long id) {
        TSubscribeSourceDataOptions options = new TSubscribeSourceDataOptions();
        // options.ssetTemplate(true);
        options.setAll(true);
        TSubscribeSource source = announcementService.getSubscribeSource(id, options);
        renderJSON(source);
    }

    /**
     * 删除订阅源
     * 
     * @param id
     *            订阅源ID
     */
    @Transactional
    public static void deleteSubscribeSource(Long id) {
        if (id == null || TypeConstants.NULL_LONG == id.longValue())
            return;
        announcementService.updateSubscribeSourceStatus(id, TSubscribeSourceStatus.DELETE);
        // 记录操作日志
        TConsoleLog tconsoleLog = new TConsoleLog();
        tconsoleLog.setIP(HttpUtils.getClientIP(request));
        tconsoleLog.setUserAgent(HttpUtils.getHeader(request, "User-Agent"));
        tconsoleLog.setDescription("删除订阅源");
        loggerService.createConsoleLog(tconsoleLog, Sec.getUserId());
    }

    /**
     * 改变订阅源的上下架状态
     */
    @Transactional
    public static void changeSourceStatus() {
        String idStr = params.get("id");
        String statusStr = params.get("status");
        if (StringUtils.isEmpty(idStr) || StringUtils.isEmpty(statusStr))
            return;
        Long id = Long.parseLong(idStr);
        Integer status = Integer.parseInt(statusStr);
        if (id == null || TypeConstants.NULL_LONG == id.longValue())
            return;
        announcementService.updateSubscribeSourceStatus(id, TSubscribeSourceStatus.findByValue(status));

        // 记录操作日志
        TConsoleLog tconsoleLog = new TConsoleLog();
        tconsoleLog.setIP(HttpUtils.getClientIP(request));
        tconsoleLog.setUserAgent(HttpUtils.getHeader(request, "User-Agent"));
        if (TSubscribeSourceStatus.findByValue(status) == TSubscribeSourceStatus.OFFLINE) {
            tconsoleLog.setDescription("下架订阅源");
        } else {
            tconsoleLog.setDescription("上架订阅源");
        }
        loggerService.createConsoleLog(tconsoleLog, Sec.getUserId());
    }

    /**
     * 根据type获取订阅源(不包括已删除的).
     */
    public static void getAllSoure(Integer type) {
        // 获取订阅源
        TSubscribeSourceQuery sourceq = new TSubscribeSourceQuery();
        if (type != null)
            sourceq.setStatus(TSubscribeSourceStatus.findByValue(type));
        sourceq.setLimit(SUBSCRIBESOURCE_NUM);
        TSubscribeSourceDataOptions sourceoption = new TSubscribeSourceDataOptions();
        sourceoption.setAll(true);
        List<TSubscribeSource> soureList = announcementService.querySubscribeSources(sourceq, sourceoption);

        renderJSON(soureList);
    }

    /**
     * 获取所有模版
     */
    public static void getTemplates() {
        List<TCrawlTemplate> temList = announcementService.queryTemplates();
        renderJSON(temList);
    }

    public static void getAllRoles() {
        // 获取角色
        TRoleQuery roleQuery = new TRoleQuery();
        roleQuery.setLimit(-1);
        Set<TRoleType> types = new HashSet<TRoleType>();
        types.add(TRoleType.END_USER_ROLE);
        types.add(TRoleType.BUILD_IN);
        roleQuery.setTypes(types);
        TRolePage rolePage = roleService.queryRole(roleQuery);
        List<TRole> roles = rolePage.getItems();
        List<TRole> roleList = new ArrayList<TRole>();
        for (TRole trole : roles) {
            if (!trole.getCode().equals(Constants.ADMIN) && !trole.getCode().equals(Constants.SUPER_ADMIN)) {
                roleList.add(trole);
            }
        }
        renderJSON(roleList);
    }

    /**
     * 保存订阅源
     */
    @Transactional
    public static void saveSubSource(String name, Long idTemplate, Long id, List<Long> ids, Integer defaultFlag) {
        String errMsg = "";
        try {
            TUserDataOptions userOption = new TUserDataOptions();
            userOption.setAll(true);
            TUser user = userService.getUser(Sec.getUserId(), userOption);
            TAdminTime adminTime = null;
            TSubscribeSource source = null;

            // 记录操作日志
            TConsoleLog tconsoleLog = new TConsoleLog();
            tconsoleLog.setIP(HttpUtils.getClientIP(request));
            tconsoleLog.setUserAgent(HttpUtils.getHeader(request, "User-Agent"));

            if (id != null && TypeConstants.NULL_LONG != id.longValue()) {
                TSubscribeSourceDataOptions subOption = new TSubscribeSourceDataOptions();
                subOption.setAll(true);
                source = announcementService.getSubscribeSource(Long.valueOf(id), subOption);
                adminTime = source.getAdminTime();
                adminTime.setUpdator(user);
                adminTime.setUpdateTime(System.currentTimeMillis());
                tconsoleLog.setDescription("编辑订阅源");
            } else {
                source = new TSubscribeSource();
                adminTime = new TAdminTime();
                adminTime.setCreator(user);
                adminTime.setCreateTime(System.currentTimeMillis());
                adminTime.setUpdator(user);
                adminTime.setUpdateTime(System.currentTimeMillis());
                tconsoleLog.setDescription("创建订阅源");
            }
            source.setAdminTime(adminTime);
            if (StringUtils.isEmpty(name) || idTemplate == null || TypeConstants.NULL_LONG == idTemplate.longValue()) {
                return;
            }
            List<TRole> roleList = new ArrayList<TRole>();
            if (ids != null && ids.size() != 0) {
                for (Long i : ids) {
                    if (i != null && TypeConstants.NULL_LONG != i.longValue()) {
                        TRole role = new TRole();
                        role.setId(i);
                        roleList.add(role);
                    }
                }
            }
            source.setDefaultFlag(defaultFlag);
            source.setSubscribeSourceStatus(TSubscribeSourceStatus.ONLINE);
            source.setRoles(roleList);
            source.setName(name);
            source.setPTemplate(new TCrawlTemplate());
            source.getPTemplate().setId(idTemplate);
            announcementService.saveSubscribeSource(source);

            loggerService.createConsoleLog(tconsoleLog, Sec.getUserId());
        } catch (SccException ex) {
            // SccException ex = (SccException) e;
            if (ex.getCode() == AnnouncementErrorCode.SUBSCRIBESOURCE_EXSIT) {
                errMsg = "订阅源名称已经存在";
            }
        }
        Map<String, String> map = new HashMap<String, String>(1);
        map.put("errMsg", errMsg);
        renderJSON(map);
    }

    /**
     * 立即抓取数据
     */
    public static void syncAnnouncement() {
        util.crawTask();
        renderJSON("OK");
    }
    
    /**
     * 模板源管理页.
     */
    public static void crawlTemplateIndex() {
    	DomainQuery domainQuery = new DomainQuery();
    	List<Status> status = new ArrayList<Status>(1);
    	status.add(Status.ENABLED);
    	domainQuery.setStatus(status);
    	Page<Domain> domains = domainService.queryDomain(domainQuery, P.offset(0, Integer.MAX_VALUE));
    	
    	CrawTemplateQuery query = new CrawTemplateQuery();
//    	query.setDomainKey(Sec.getDomainKey());
    	query.setOffset(0);
    	query.setLimit(Integer.MAX_VALUE);
    	CrawlTemplatePage page = crawlTemplateService.queryCrawlTemplates(query);
    	Map<String, Object> dataMap = new HashMap<String, Object>(1);
    	dataMap.put("crawlTemplateList", page.getItems());
    	dataMap.put("domains", domains);
    	render(dataMap);
    }
    
    /**
     * 保存模板源.
     */
    public static void saveTemplate(){
    	JSONObject jo = new JSONObject();
    	String id = params.get("id");
    	String directory = params.get("directory");
    	String name = params.get("name");
    	String urlList = params.get("urlList");
    	String domainKey = params.get("domainKey");

    	TCrawlTemplate tCrawlTemplate = new TCrawlTemplate();
    	tCrawlTemplate.setDirectory(directory);
    	tCrawlTemplate.setId(StringUtils.isNotBlank(id) ? Long.parseLong(id) : 0);
    	tCrawlTemplate.setDomainKey(domainKey);
    	tCrawlTemplate.setName(name);
    	tCrawlTemplate.setUrlList(urlList);
    	
    	try {
			crawlTemplateService.saveCrawlTemplate(tCrawlTemplate);
			jo.put("state", "1");
		} catch (SccException e) {
			LOG.error("保存模板源失败", e);
			jo.put("state", "0");
            jo.put("msg", "保存模板源失败");
		}
    	renderJSON(jo);
    }
    
    /**
     * 删除模板源.
     */
    public static void deleteTemplate(){
    	JSONObject jo = new JSONObject();
    	String id = params.get("id");
    	try {
			boolean b = crawlTemplateService.deleteCrawlTemplate(StringUtils.isNotBlank(id) ? Long.parseLong(id) : 0);
			if(b){
				jo.put("state", "1");
			}else{
				jo.put("state", "0");
	            jo.put("msg", "该模板源已被引用，无法删除");
			}
		} catch (SccException e) {
			LOG.error("删除模板源失败", e);
			jo.put("state", "0");
            jo.put("msg", "删除模板源失败");
		}
    	renderJSON(jo);
    }
    
    /**
     * 删除通知公告.
     */
    public static void deleteAnnouncements(List<Long> ids){
        JSONObject jo = new JSONObject();
        try {
            announcementService.deleteAnnouncements(ids);
            jo.put("state", "1");
            jo.put("msg", "");
        } catch (SccException e) {
            LOG.error("删除通知公告失败", e);
            jo.put("state", "0");
            jo.put("msg", "删除通知公告失败");
        }
        renderJSON(jo);
    }
    
    public static void changerOrder(String chType,Long id){
    	SubscribeSource.goChange(chType,id);
    }
}
