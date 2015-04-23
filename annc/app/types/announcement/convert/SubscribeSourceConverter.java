package types.announcement.convert;

import models.announcement.SubscribeSource;
import models.identity.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.wisorg.scc.api.internal.announcement.TAdminTime;
import com.wisorg.scc.api.internal.announcement.TSubscribeSource;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceDataOptions;
import com.wisorg.scc.api.internal.identity.TUser;
import com.wisorg.scc.api.internal.identity.TUserDataOptions;
import com.wisorg.scc.api.internal.identity.TUserService;
import com.wisorg.scc.core.bean.ObjectConverter;

@Component
public class SubscribeSourceConverter extends ObjectConverter<SubscribeSource, TSubscribeSource> {

    @Autowired
    private TUserService.Iface tUserService;

    @Autowired
    private AnnouncementCrawlTemplateConverter templateConverter;

    @Override
    public void p2v(SubscribeSource p, TSubscribeSource v) {
        v.setId(p.getId() == null ? 0 : p.getId().longValue());
        v.setName(p.name);
        v.setSubscribeSourceStatus(p.subscribeSourceStatus);
        v.setPTemplate(templateConverter.p2v(p.template));

        TAdminTime adminTime = new TAdminTime();
        adminTime.setCreateTime(p.createTime);
        adminTime.setUpdateTime(p.updateTime);

        TUserDataOptions option = new TUserDataOptions();
        if (p.creator != null) {
            TUser creator = tUserService.getUser(p.creator.id, option);
            adminTime.setCreator(creator);
        }
        if (p.updator != null) {
            TUser updator = tUserService.getUser(p.updator.id, option);
            adminTime.setUpdator(updator);
        }

        v.setAdminTime(adminTime);
        v.setDefaultFlag(p.defaultFlag == null ? 0 : p.defaultFlag);
    }

    public void p2v4Base(SubscribeSource p, TSubscribeSource v) {
        v.setId(p.getId() == null ? 0 : p.getId().longValue());
        v.setName(p.name);
        v.setSubscribeSourceStatus(p.subscribeSourceStatus);
        v.setDefaultFlag(p.defaultFlag == null ? 0 : p.defaultFlag);
    }

    public void p2v4AdminTime(SubscribeSource p, TSubscribeSource v) {
        v.setId(p.getId() == null ? 0 : p.getId().longValue());
        TAdminTime adminTime = new TAdminTime();
        adminTime.setCreateTime(p.createTime);
        adminTime.setUpdateTime(p.updateTime);

        TUserDataOptions option = new TUserDataOptions();
        if (p.creator != null) {
            TUser creator = tUserService.getUser(p.creator.id, option);
            adminTime.setCreator(creator);
        }
        if (p.updator != null) {
            TUser updator = tUserService.getUser(p.updator.id, option);
            adminTime.setUpdator(updator);
        }

        v.setAdminTime(adminTime);
    }

    public void p2v4Option(SubscribeSource p, TSubscribeSource v, TSubscribeSourceDataOptions option) {
        if (option.isAll() || option.isBase()) {
            p2v4Base(p, v);
        }
        if (option.isAll() || option.isTime()) {
            p2v4AdminTime(p, v);
        }
        if (option.isAll()) {
            v.setPTemplate(templateConverter.p2v(p.template));
        }
    }

    @Override
    public void v2p(TSubscribeSource v, SubscribeSource p) {
        p.id = v.getId() == 0 ? null : v.getId();
        p.name = v.getName();
        if (v.isSetPTemplate()) {
            p.template = templateConverter.v2p(v.getPTemplate());
        }
        p.subscribeSourceStatus = v.getSubscribeSourceStatus();
        if (v.isSetAdminTime()) {
            p.createTime = v.getAdminTime().getCreateTime();
            p.updateTime = v.getAdminTime().getUpdateTime();
            p.creator = new User();
            p.creator.id = v.getAdminTime().getCreator().getId();
            p.updator = new User();
            p.updator.id = v.getAdminTime().getUpdator().getId();
        }
        if (v.isSetDefaultFlag() && v.getDefaultFlag() == 1) {
            p.defaultFlag = v.getDefaultFlag();
        } else {
            p.defaultFlag = 0;
        }
    }

    public void v2p4Base(TSubscribeSource v, SubscribeSource p) {
        p.id = v.getId() == 0 ? null : v.getId();
        p.name = v.getName();
        p.subscribeSourceStatus = v.getSubscribeSourceStatus();
        if (v.isSetDefaultFlag() && v.getDefaultFlag() == 1) {
            p.defaultFlag = v.getDefaultFlag();
        } else {
            p.defaultFlag = 0;
        }
    }

    public void v2p4AdminTime(TSubscribeSource v, SubscribeSource p) {
        p.id = v.getId() == 0 ? null : v.getId();
        if (v.isSetAdminTime()) {
            p.createTime = v.getAdminTime().getCreateTime();
            p.updateTime = v.getAdminTime().getUpdateTime();
            p.creator = new User();
            p.creator.id = v.getAdminTime().getCreator().getId();
            p.updator = new User();
            p.updator.id = v.getAdminTime().getUpdator().getId();
        }
    }

    public void v2p4Option(TSubscribeSource v, SubscribeSource p, TSubscribeSourceDataOptions option) {
        if (option.isAll() || option.isBase()) {
            v2p4Base(v, p);
        }
        if (option.isAll() || option.isTime()) {
            v2p4AdminTime(v, p);
        }
        if (option.isAll()) {
            p.template = templateConverter.v2p(v.getPTemplate());
        }
    }
}
