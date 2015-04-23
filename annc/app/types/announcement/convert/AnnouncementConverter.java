package types.announcement.convert;

import java.util.ArrayList;
import java.util.List;

import models.announcement.Announcement;
import models.announcement.AnnouncementAttach;
import models.announcement.AnnouncementBase;
import models.announcement.AnnouncementDetail;
import models.announcement.AnnouncementTime;
import models.announcement.SubscribeSource;
import models.identity.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import com.wisorg.scc.api.internal.announcement.TAdminTime;
import com.wisorg.scc.api.internal.announcement.TAnnouncement;
import com.wisorg.scc.api.internal.announcement.TAnnouncementBase;
import com.wisorg.scc.api.internal.announcement.TAnnouncementDataOptions;
import com.wisorg.scc.api.internal.announcement.TAnnouncementDetail;
import com.wisorg.scc.api.internal.announcement.TSubscribeSource;
import com.wisorg.scc.api.internal.fs.TFile;
import com.wisorg.scc.api.internal.fs.TFileStoreService;
import com.wisorg.scc.api.internal.fs.service.FileStoreService;
import com.wisorg.scc.api.internal.identity.TUser;
import com.wisorg.scc.api.internal.identity.TUserDataOptions;
import com.wisorg.scc.api.internal.identity.TUserService;
import com.wisorg.scc.core.bean.ObjectConverter;

@Component
public class AnnouncementConverter extends ObjectConverter<Announcement, TAnnouncement> {

	@Autowired
	SubscribeSourceConverter subSurConverter;

	@Autowired
	private TUserService.Iface tUserService;

	@Autowired
	private FileStoreService fileService;

	@Autowired
	private TFileStoreService.Iface fileStoreService;

	@Override
	public void p2v(Announcement p, TAnnouncement v) {
		TAnnouncementDataOptions option = new TAnnouncementDataOptions();
		option.setAll(true);
		p2v4Option(p, v, option);
	}

	@Override
	public void v2p(TAnnouncement v, Announcement p) {
		TAnnouncementDataOptions option = new TAnnouncementDataOptions();
		option.setAll(true);
		v2p4Option(v, p, option);
	}

	public void p2v4Base(Announcement p, TAnnouncement v) {
		v.setId(p.getId() == null ? 0 : p.getId().longValue());
		v.setStatus(p.status);
		AnnouncementBase baseInfo = p.baseInfo;
		if (baseInfo != null) {
			AnnouncementDetail detailInfo = p.detailInfo;
			TAnnouncementBase tBaseInfo = new TAnnouncementBase();
			tBaseInfo.setId(baseInfo.id);
			tBaseInfo.setTitle(baseInfo.title);
			tBaseInfo.setSummary(baseInfo.summary);
			tBaseInfo.setViewCount(detailInfo.viewCount);
			v.setBaseInfo(tBaseInfo);
			TAnnouncementDetail tDetailInfo = new TAnnouncementDetail();
			tDetailInfo.setOnlineTime(detailInfo.onlineTime);
			v.setDetailInfo(tDetailInfo);
		}
	}

	public void p2v4Detail(Announcement p, TAnnouncement v) {
		v.setId(p.getId() == null ? 0 : p.getId().longValue());
		v.setStatus(p.status);
		AnnouncementDetail detailInfo = p.detailInfo;
		if (detailInfo != null) {
			TAnnouncementDetail tDetailInfo = new TAnnouncementDetail();
			tDetailInfo.setId(detailInfo.id);
			tDetailInfo.setOnlineTime(detailInfo.onlineTime);
			tDetailInfo.setAuthor(detailInfo.author);
			tDetailInfo.setSource(detailInfo.source);
			tDetailInfo.setViewCount(detailInfo.viewCount);
			tDetailInfo.setContent(detailInfo.content);
			tDetailInfo.setSourceUrl(detailInfo.sourceUrl);
			SubscribeSource subscribeSource = detailInfo.category;
			tDetailInfo.setSubscribeSource(subSurConverter.p2v(subscribeSource));

			v.setDetailInfo(tDetailInfo);
		}
	}

	/**
	 * p2v4Detail的扩展（适用于外部接口时使用）
	 * 
	 * @param p
	 * @param v
	 */
	public void p2v4DetailOut(Announcement p, TAnnouncement v) {
		v.setId(p.getId() == null ? 0 : p.getId().longValue());
		v.setStatus(p.status);
		AnnouncementDetail detailInfo = p.detailInfo;
		if (detailInfo != null) {
			TAnnouncementDetail tDetailInfo = new TAnnouncementDetail();
			tDetailInfo.setId(detailInfo.id);
			tDetailInfo.setOnlineTime(detailInfo.onlineTime);
			tDetailInfo.setAuthor(detailInfo.author);
			tDetailInfo.setSource(detailInfo.source);
			tDetailInfo.setViewCount(detailInfo.viewCount);
			tDetailInfo.setContent(detailInfo.content.replaceAll("？？？？？？？？？？", "？？？？？？").replaceAll("？", "&nbsp;"));
			tDetailInfo.setSourceUrl(detailInfo.sourceUrl);
			SubscribeSource subscribeSource = detailInfo.category;
			TSubscribeSource tSubscribeSource = new TSubscribeSource();
			subSurConverter.p2v4Base(subscribeSource, tSubscribeSource);
			tDetailInfo.setSubscribeSource(tSubscribeSource);

			v.setDetailInfo(tDetailInfo);
		}
	}

	public void p2v4Attach(Announcement p, TAnnouncement v) {
		if (p.detailInfo != null) {
			List<AnnouncementAttach> attachList = p.attach;
			if (!CollectionUtils.isEmpty(attachList)) {
				List<TFile> attachs = new ArrayList<TFile>(attachList.size());
				for (AnnouncementAttach announceAttach : attachList) {
					TFile tfile = fileStoreService.getFile(announceAttach.attach);
					attachs.add(tfile);
				}
				v.setAttachment(attachs);
			}
		}
	}

	public void p2v4AdminTime(Announcement p, TAnnouncement v) {
		AnnouncementTime timeInfo = p.timeInfo;
		TAdminTime tAdminTime = new TAdminTime();
		tAdminTime.setId(timeInfo.id);
		tAdminTime.setCreateTime(timeInfo.createTime);
		tAdminTime.setUpdateTime(timeInfo.updateTime);
		TUserDataOptions option = new TUserDataOptions();
		if (timeInfo.creator != null) {
			TUser creator = tUserService.getUser(timeInfo.creator.id, option);
			tAdminTime.setCreator(creator);
		}
		if (timeInfo.updator != null) {
			TUser updator = tUserService.getUser(timeInfo.updator.id, option);
			tAdminTime.setUpdator(updator);
		}
		v.setAdminTime(tAdminTime);
	}

	public void p2v4Option(Announcement p, TAnnouncement v, TAnnouncementDataOptions option) {
		if (option.isAll() || option.isBase()) {
			p2v4Base(p, v);
		}
		if (option.isAll() || option.isDetail()) {
			p2v4DetailOut(p, v);
		}
		if (option.isAll() || option.isAttachment()) {
			p2v4Attach(p, v);
		}
		if (option.isAll() || option.isTime()) {
			p2v4AdminTime(p, v);
		}
	}

	public void v2p4Base(TAnnouncement v, Announcement p) {
		p.id = v.getId() == 0 ? null : v.getId();
		p.status = v.getStatus();
		TAnnouncementBase tBaseInfo = v.getBaseInfo();
		if (tBaseInfo != null) {
			AnnouncementBase baseInfo = null;
			if (p.baseInfo == null) {
				baseInfo = new AnnouncementBase(p);
			} else {
				baseInfo = p.baseInfo;
			}
			baseInfo.id = tBaseInfo.getId() == 0 ? null : tBaseInfo.getId();
			baseInfo.title = tBaseInfo.getTitle();
			baseInfo.summary = tBaseInfo.getSummary();
			p.baseInfo = baseInfo;
		}
	}

	public void v2p4Detail(TAnnouncement v, Announcement p) {
		p.id = v.getId() == 0 ? null : v.getId();
		p.status = v.getStatus();
		TAnnouncementDetail tDetailInfo = v.getDetailInfo();
		if (tDetailInfo != null) {
			AnnouncementDetail detailInfo = null;
			if (p.detailInfo == null) {
				detailInfo = new AnnouncementDetail(p);
			} else {
				detailInfo = p.detailInfo;
			}
			detailInfo.id = tDetailInfo.getId() == 0 ? null : tDetailInfo.getId();
			detailInfo.onlineTime = tDetailInfo.getOnlineTime();
			detailInfo.author = tDetailInfo.getAuthor();
			detailInfo.source = tDetailInfo.getSource();
			detailInfo.viewCount = tDetailInfo.getViewCount();
			detailInfo.content = tDetailInfo.getContent();
			detailInfo.sourceUrl = tDetailInfo.getSourceUrl();

			TSubscribeSource category = tDetailInfo.getSubscribeSource();
			SubscribeSource pCategory = new SubscribeSource();
			subSurConverter.v2p(category, pCategory);
			detailInfo.category = pCategory;

			p.detailInfo = detailInfo;
		}
	}

	public void v2p4Attach(TAnnouncement v, Announcement p) {
		p.id = v.getId() == 0 ? null : v.getId();
		if (p.detailInfo != null) {
			List<AnnouncementAttach> pattachList = p.attach;
			if (pattachList != null && !pattachList.isEmpty()) {
				for (AnnouncementAttach pattach : pattachList) {
					pattach.delete();
				}
			}
		}
		List<TFile> fileList = v.getAttachment();
		List<AnnouncementAttach> attachList = null;
		if (fileList != null && !fileList.isEmpty()) {
			attachList = new ArrayList<AnnouncementAttach>(fileList.size());
			AnnouncementAttach announcementAttach = null;
			for (TFile tFile : fileList) {
				announcementAttach = new AnnouncementAttach(p);
				announcementAttach.attach = tFile.getId();
//				announcementAttach.save();这个外键Announcement都还没存呢
				attachList.add(announcementAttach);
			}
		} else {
			attachList = new ArrayList<AnnouncementAttach>(0);
		}

		p.attach = attachList;
	}

	public void v2p4AdminTime(TAnnouncement v, Announcement p) {
		p.id = v.getId() == 0 ? null : v.getId();
		TAdminTime tAdminTime = v.getAdminTime();
		if (tAdminTime != null) {
			AnnouncementTime adminTime = null;
			if (p.timeInfo == null) {
				adminTime = new AnnouncementTime(p);
			} else {
				adminTime = p.timeInfo;
			}
			adminTime.id = tAdminTime.getId() == 0 ? null : tAdminTime.getId();
			adminTime.createTime = tAdminTime.getCreateTime();
			adminTime.updateTime = tAdminTime.getUpdateTime();
			if (tAdminTime.getCreator() != null) {
				adminTime.creator = new User();
				adminTime.creator.id = tAdminTime.getCreator().getId();
			}
			if (tAdminTime.getUpdator() != null) {
				adminTime.updator = new User();
				adminTime.updator.id = tAdminTime.getUpdator().getId();
			}

			p.timeInfo = adminTime;
		}
	}

	public void v2p4Option(TAnnouncement v, Announcement p, TAnnouncementDataOptions option) {
		if (option.isAll() || option.isBase()) {
			v2p4Base(v, p);
		}
		if (option.isAll() || option.isDetail()) {
			v2p4Detail(v, p);
		}
		if (option.isAll() || option.isAttachment()) {
			v2p4Attach(v, p);
		}
		if (option.isAll() || option.isTime()) {
			v2p4AdminTime(v, p);
		}
	}
}
