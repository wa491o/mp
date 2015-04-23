package services.announcement.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URLEncoder;
import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import models.announcement.AnnouncementDetail;
import models.announcement.CrawlTemplate;
import models.announcement.SubscribeSource;
import models.announcement.UserSubscribeInfo;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import play.Logger;
import play.Play;
import services.announcement.CrawlTemplateService;
import services.announcement.impl.CrawlTemplateServiceImpl;

import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.wisorg.scc.api.internal.announcement.AnnouncementConstants;
import com.wisorg.scc.api.internal.announcement.TAdminTime;
import com.wisorg.scc.api.internal.announcement.TAnnouncement;
import com.wisorg.scc.api.internal.announcement.TAnnouncementBase;
import com.wisorg.scc.api.internal.announcement.TAnnouncementDetail;
import com.wisorg.scc.api.internal.announcement.TAnnouncementService;
import com.wisorg.scc.api.internal.announcement.TAnnouncementStatus;
import com.wisorg.scc.api.internal.announcement.TCrawlTemplate;
import com.wisorg.scc.api.internal.announcement.TSubscribeSource;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceDataOptions;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceQuery;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceStatus;
import com.wisorg.scc.api.internal.identity.IdentityConstants;
import com.wisorg.scc.api.internal.identity.TIdentityService;
import com.wisorg.scc.api.internal.identity.TRole;
import com.wisorg.scc.api.internal.identity.TUser;
import com.wisorg.scc.api.internal.identity.TUserDataOptions;
import com.wisorg.scc.api.internal.identity.TUserPage;
import com.wisorg.scc.api.internal.identity.TUserQuery;
import com.wisorg.scc.api.internal.identity.TUserService;
import com.wisorg.scc.api.internal.identity.TUserType;
import com.wisorg.scc.api.internal.identity.TVGroup;
import com.wisorg.scc.api.internal.message.TMessage;
import com.wisorg.scc.api.internal.message.TMessageService;
import com.wisorg.scc.api.internal.message.TMessageType;
import com.wisorg.scc.api.internal.message.TSendOption;
import com.wisorg.scc.core.play.Executor;
import com.wisorg.scc.core.security.Constants;
import com.wisorg.scc.core.support.http.HttpClientFactoryBean;
import com.wisorg.scc.core.util.StringUtils;

/**
 * 通知公告抓取工具类 .
 * 
 * @author <a href="mailto:jfli@wisorg.com">jfli</a>
 */
@Component
public class AnnouncementCrawUtil {

	@Autowired
	private HttpClientFactoryBean httpClientFactory;

	@Autowired
	private TAnnouncementService.Iface announcementService;

	@Autowired
	private TMessageService.Iface messageService;

	@Autowired
	private TIdentityService.Iface identityService;
	@Autowired
    private CrawlTemplateService crawlTemplateService;
	
	@Autowired
	private TUserService.Iface userService;

	public void crawTask() {
		TSubscribeSourceQuery subscribeSourceQuery = new TSubscribeSourceQuery();
		subscribeSourceQuery.setLimit(Integer.MAX_VALUE);
		subscribeSourceQuery.setOffset(0);
		subscribeSourceQuery.setStatus(TSubscribeSourceStatus.ONLINE);
		TSubscribeSourceDataOptions option = new TSubscribeSourceDataOptions();
		option.setAll(true);
		List<TSubscribeSource> subscribeSourceList = announcementService.querySubscribeSources(subscribeSourceQuery, option);
		if (!CollectionUtils.isEmpty(subscribeSourceList)) {
			TAdminTime adminTime = new TAdminTime();
			for (TSubscribeSource tSubscribeSource : subscribeSourceList) {
				TCrawlTemplate tTemplate = tSubscribeSource.getPTemplate();
				if (tTemplate != null) {
					CrawlTemplate pTemplate = CrawlTemplate.findById(tTemplate.getId());
					List<String> urlList = crawAnnouncementList(pTemplate.directory, URLEncoder.encode(pTemplate.urlList));
					List<TAnnouncement> anncList = new ArrayList<TAnnouncement>();
					for (String reqUrl : urlList) {
						TAnnouncement announcement = crawAnnouncementDetails(pTemplate.directory, URLEncoder.encode(reqUrl));
						if (announcement != null) {
							if(StringUtils.isEmpty(announcement.getBaseInfo().getTitle()) || StringUtils.isEmpty(announcement.getDetailInfo().getContent())){
								if(null!=announcement.getDetailInfo()){
									Logger.error(announcement.getDetailInfo().getSourceUrl()+" title is null");
								}
								continue;
							}
							if(announcement.getBaseInfo().getTitle().startsWith("[讲座]") || announcement.getBaseInfo().getTitle().startsWith("[报告会]")){
								continue;
							}
							
							announcement.setStatus(TAnnouncementStatus.ONLINE);
							announcement.getDetailInfo().setSubscribeSource(tSubscribeSource);
							announcement.getDetailInfo().setSourceUrl(reqUrl);
							anncList.add(announcement);
						}
					}
					AnnouncementDetail detail = null;
					if (!anncList.isEmpty()) {
						boolean pushFlag = true;
						for (int index = anncList.size() - 1; index >= 0; index--) {
							long currTime = System.currentTimeMillis();
							TAnnouncement announcement = anncList.get(index);
							detail = AnnouncementDetail.findByUrl(tSubscribeSource.getId(), announcement.getDetailInfo().getSourceUrl());
							if(null!=detail){
								announcement.setId(detail.announcement.id);
								announcement.getBaseInfo().setId(detail.announcement.baseInfo.getId());
								announcement.getDetailInfo().setId(detail.getId());
								adminTime.setId(detail.announcement.timeInfo.getId());
							}
														//Logger.error("OnlineTime:" + announcement.getDetailInfo().getOnlineTime(), new Object[0]);

			                if ((announcement.getDetailInfo() != null) && (announcement.getDetailInfo().getOnlineTime() > 0L)) {
			                    adminTime.setCreateTime(announcement.getDetailInfo().getOnlineTime());
			                    adminTime.setUpdateTime(announcement.getDetailInfo().getOnlineTime());
			                } else {
			                	announcement.getDetailInfo().setOnlineTime(currTime);
			                    adminTime.setCreateTime(currTime);
			                    adminTime.setUpdateTime(currTime);
			                }
							
							announcement.setAdminTime(adminTime);
							announcementService.saveAnnouncement(announcement, false);
							pushFlag = false;
							adminTime.setId(0L);
						}
					}
					if(null==crawlTemplateService){
						crawlTemplateService = new CrawlTemplateServiceImpl();
					}
					//晓庄只保留50条
					//crawlTemplateService.dealOldAnnc(tSubscribeSource);
				}
			}
			
		}
	}

	public List<String> crawAnnouncementList(String appid, String reqURL) {
		String url = MessageFormat.format(Play.configuration.getProperty("content.crawURL"), appid, reqURL);
		List<String> urlList = new ArrayList<String>();
		HttpGet httpget = new HttpGet(url.toString());
		BufferedReader reader = null;
		try {
			HttpResponse response = httpClientFactory.getObject().execute(httpget);
			HttpEntity entity = response.getEntity();
			if (entity != null) {
				reader = new BufferedReader(new InputStreamReader(entity.getContent(), "UTF-8"));
				String line = null;
				while ((line = reader.readLine()) != null) {
					if (StringUtils.isNotBlank(line.trim()) && line.startsWith("http://")) {
						urlList.add(line);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (reader != null) {
					reader.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			httpget.abort();
		}
		return urlList;
	}

	public TAnnouncement crawAnnouncementDetails(String appid, String reqURL) {
		String url = MessageFormat.format(Play.configuration.getProperty("content.crawURL"), appid, reqURL);
		TAnnouncement tAnnouncement = null;
		try {
			HttpGet httpget = new HttpGet(url);
			HttpClient httpClient = httpClientFactory.getObject();
			HttpResponse response = httpClient.execute(httpget);
			HttpEntity entity = response.getEntity();
			if (entity != null) {
				BufferedReader reader = new BufferedReader(new InputStreamReader(entity.getContent()));
				String line = null;
				String title = "", source = "", author = "",summary = "",timePublish = ""; String timeFormat = "";
				StringBuffer content = new StringBuffer();
				StringBuffer summaryStr = new StringBuffer();
				boolean contentStartFlag = false;
				boolean summaryStartFlag = false;
				while ((line = reader.readLine()) != null) {
					line = line.trim();
					if (line.startsWith("content:")) {
						contentStartFlag = true;
						summaryStartFlag = false;
					} else if (line.startsWith("summary:")) {
						summaryStartFlag = true;
					}
					if (contentStartFlag) {
						content.append(line);
					} else if (summaryStartFlag) {
						summaryStr.append(line);
					} else {
						if (line.startsWith("title:")) {
							title = line.replaceAll("title:", "");
						} else if (line.startsWith("source:")) {
							source = line.replaceAll("source:", "");
						} else if (line.startsWith("autor:")) {
							author = line.replaceAll("autor:", "");
						} else if (line.startsWith("timePublish:")){
				            timePublish = line.replaceAll("timePublish:", "");
						} else if (line.startsWith("timeFormat:")) {
				            timeFormat = line.replaceAll("timeFormat:", "");
				        }
					}
				}
				TAnnouncementBase baseInfo = new TAnnouncementBase();
				baseInfo.setTitle(title);
				summary = summaryStr.toString().replaceAll("\\s|org.dom4j.tree.[\\w]*@[\\w\\d\\s\\[:&;@]*\\]", "");
				summary = summary.replaceAll(" ", "");

				if (summary.length() > 60) {
					summary = summary.substring(0, 60);
				}
				if(!summary.startsWith("org.dom4j.tree")){
					baseInfo.setSummary(summary.toString().replaceAll("summary:", ""));
				}
				
				TAnnouncementDetail detailInfo = new TAnnouncementDetail();
				detailInfo.setAuthor(author);
				
				//Logger.error("timePublish:" + timePublish + " timeFormat:" + timeFormat, new Object[0]);
		        if ((StringUtils.isNotEmpty(timePublish)) && (StringUtils.isNotEmpty(timeFormat))) {
		          try {
		            SimpleDateFormat smp = new SimpleDateFormat(timeFormat);
		            detailInfo.setOnlineTime(smp.parse(timePublish).getTime());
		          } catch (Exception e) {
		            detailInfo.setOnlineTime(0L);
		          }
		        }
				
				detailInfo.setSource(source);
				if (content.length() > 0) {
					detailInfo.setContent(content.toString().replaceAll("content:", ""));
				}
				tAnnouncement = new TAnnouncement();
				tAnnouncement.setBaseInfo(baseInfo);
				tAnnouncement.setDetailInfo(detailInfo);
			}
			httpget.abort();
		} catch (Exception e) {
			Logger.warn(e.getMessage());
		}
		return tAnnouncement;
	}

	/**
	 * 发通知公告push消息
	 * 
	 * @param announcement
	 */
	public void sendAnnouncementPush(final TAnnouncement announcement) {
		Executor.delay(new Runnable() {
			@Override
			public void run() {
				// 消息实体
				TMessage message = new TMessage();
				message.setBizKey(AnnouncementConstants.BIZ_SYS_ANNC_MESSAGE);
				message.setSubject(announcement.getBaseInfo().getTitle());
				message.setBody(announcement.getBaseInfo().getTitle());
				StringBuffer url = new StringBuffer("scc://wisorg.com/").append(AnnouncementConstants.BIZ_SYS_ANNC).append("/").append(announcement.getId());
				message.setUrl(url.toString());

				// 发送选项
				TSendOption option = new TSendOption();
				option.setType(TMessageType.PUSH);

				// 订阅源
				TSubscribeSource subscribeSource = announcement.getDetailInfo().getSubscribeSource();
				TVGroup group = new TVGroup();
				group.setType(AnnouncementConstants.VGROUP_ANNOUNCEMENT);
				group.setName(subscribeSource.getName());
				group.setKey(subscribeSource.getId() + "");

				Map<String, String> attr = Maps.newHashMap();
				attr.put(IdentityConstants.USER_ATTR_KEY_RECV_ANNC, "1");
				message.setAttr(attr);

				messageService.sendToGroup(group, option, message);

				if (announcement.getDetailInfo().getSubscribeSource().getDefaultFlag() == 1) {
					boolean push = false;
					List<TRole> roles = announcement.getDetailInfo().getSubscribeSource().getRoles();
					if(null!=roles){
						for (TRole r : roles) {
							if (r.getCode().equals(Constants.GUEST) || r.getCode().equals(Constants.EVERYONE)) {
								push = true;
								break;
							}
						}
					}
					if (push) {
						TVGroup guestGroup = new TVGroup();
						guestGroup.setType(IdentityConstants.VGROUP_GUEST);
						guestGroup.setName("游客");
						messageService.sendToGroup(guestGroup, option, message);
					}
				}

			}
		}, "3s");
	}

	/**
	 * 新增默认订阅源时,给所有的用户添加订阅关系
	 * 
	 * @param subscribeSource
	 */
	public void addSubscribeDefaultSource(final TSubscribeSource subscribeSource) {

		// 每页查询的数据条数
		final long limit = 100L;
		
		Executor.delay(new Runnable() {
			@Override
			public void run() {
				long offset = 0;
				SubscribeSource source = SubscribeSource.findById(subscribeSource.getId());
				Set<String> domainKeys = Sets.newHashSet(source.domain.getKey());
				while (true) {
					TUserQuery userQuery = new TUserQuery();
					// 用户类型
					Set<TUserType> userTypeSet = new HashSet<TUserType>(1);
					userTypeSet.add(TUserType.END_USER);
					userQuery.setTypes(userTypeSet);
					userQuery.setDomainKey(domainKeys);
					// 分页
					userQuery.setOffset(offset);
					userQuery.setLimit(limit);

					TUserPage userPage = userService.queryUser(userQuery, new TUserDataOptions());
					List<TUser> userLists = userPage.getItems();
					for (TUser user : userLists) {
						long uid = user.getId();
						long ssid = subscribeSource.getId();
						if (!UserSubscribeInfo.isSubscribe(uid, ssid, null)) {
							announcementService.subscribe(uid, ssid);
						}
					}

					// 没有查满
					if (userLists.size() < limit) {
						break;
					} else {
						offset = offset + limit;
					}
				}
			}
		}, "3s");
	}
}
