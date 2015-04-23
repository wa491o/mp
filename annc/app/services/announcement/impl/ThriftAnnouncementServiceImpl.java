package services.announcement.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.Query;

import models.announcement.Announcement;
import models.announcement.AnnouncementDetail;
import models.announcement.CrawlTemplate;
import models.announcement.SubscribeSource;
import models.announcement.SubscribeSourceRole;
import models.announcement.UserSubscribeInfo;
import models.identity.Role;
import models.identity.User;
import net.sf.oval.constraint.Min;
import net.sf.oval.constraint.NotNull;

import org.apache.thrift.TException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import play.db.jpa.GenericModel.JPAQuery;
import services.announcement.util.AnnouncementCrawUtil;
import types.announcement.AnnouncementErrorCode;
import types.announcement.convert.AnnouncementConverter;
import types.announcement.convert.AnnouncementCrawlTemplateConverter;
import types.announcement.convert.SubscribeSourceConverter;
import types.identity.convert.RoleConverter;

import com.google.common.collect.Maps;
import com.wisorg.scc.api.internal.announcement.TAnnouncement;
import com.wisorg.scc.api.internal.announcement.TAnnouncementDataOptions;
import com.wisorg.scc.api.internal.announcement.TAnnouncementOrder;
import com.wisorg.scc.api.internal.announcement.TAnnouncementPage;
import com.wisorg.scc.api.internal.announcement.TAnnouncementQuery;
import com.wisorg.scc.api.internal.announcement.TAnnouncementService.Iface;
import com.wisorg.scc.api.internal.announcement.TAnnouncementStatus;
import com.wisorg.scc.api.internal.announcement.TAnnouncementUnreadCount;
import com.wisorg.scc.api.internal.announcement.TCrawlTemplate;
import com.wisorg.scc.api.internal.announcement.TSubscribeSource;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceDataOptions;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceOrder;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceQuery;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceStatus;
import com.wisorg.scc.api.internal.announcement.TSubscribeStatus;
import com.wisorg.scc.api.internal.core.entity.Status;
import com.wisorg.scc.api.internal.core.ex.SccException;
import com.wisorg.scc.api.internal.domain.model.DomainService;
import com.wisorg.scc.api.internal.identity.TRole;
import com.wisorg.scc.api.internal.security.Check;
import com.wisorg.scc.api.type.TCompareType;
import com.wisorg.scc.api.type.TQueryNum;
import com.wisorg.scc.api.type.TSccException;
import com.wisorg.scc.core.rpc.Export;
import com.wisorg.scc.core.security.Sec;

@Service
@Export
@Check(value = { "scope.trusted" })
public class ThriftAnnouncementServiceImpl implements Iface {

    @Autowired
    private AnnouncementConverter announcementConverter;
    @Autowired
    private SubscribeSourceConverter subscribeConverter;
    @Autowired
    private AnnouncementCrawlTemplateConverter templateConverter;
    @Autowired
    private RoleConverter roleConverter;
    @Autowired
    private AnnouncementCrawUtil crawUtil;
    @Autowired
    private DomainService domainService;

    /**
     * 保存通知公告
     */
    @Override
    @Transactional
    public TAnnouncement saveAnnouncement(@NotNull TAnnouncement announcement, boolean push) throws TSccException, TException {
        Announcement data = null;
        if (announcement.getId() == 0) {
            data = new Announcement();
        } else {
            data = Announcement.findById(announcement.getId());
        }
        announcementConverter.v2p(announcement, data);

        data.save();
        data.baseInfo.save();
        data.detailInfo.save();
        data.timeInfo.save();

        announcementConverter.p2v(data, announcement);

        if (push) {
            // 调用推送接口
            crawUtil.sendAnnouncementPush(announcement);
        }

        return announcement;
    }

    /**
     * 修改通知公告的状态
     */
    @Override
    @Transactional
    public void updateAnnouncementStatus(@Min(1) long id, @NotNull TAnnouncementStatus status) throws TSccException, TException {
        Announcement announcement = Announcement.findById(id);
        if (announcement == null) {
            /* 通知公告不存在 */
            throw new SccException(AnnouncementErrorCode.ANNOUNCEMENT_NOT_FOUND, id);
        }
        announcement.status = status;

        announcement.save();
    }

    /**
     * 批量屏蔽通知公告
     */
    @Override
    @Transactional
    public void updateAnnouncementStatus4Del(List<Long> ids) throws TSccException, TException {
        List<Announcement> announcementList = Announcement.find("id in (?1)", ids).fetch();
        for (Announcement announcement : announcementList) {
            announcement.status = TAnnouncementStatus.DELETE;
            announcement.save();
        }
    }

    /**
     * 获取通知公告详细信息
     */
    @Override
    @Transactional(readOnly = true)
    public TAnnouncement getAnnouncement(@Min(1) long id, @NotNull TAnnouncementDataOptions option) throws TSccException, TException {
        Announcement announcement = Announcement.findById(id);
        if (announcement == null) {
            /* 通知公告不存在 */
            throw new SccException(AnnouncementErrorCode.ANNOUNCEMENT_NOT_FOUND, id);
        }
        TAnnouncement v = new TAnnouncement();
        announcementConverter.p2v4Option(announcement, v, option);
        return v;
    }

    /**
     * 评论获取通知公告信息
     */
    @Override
    @Transactional(readOnly = true)
    public Map<Long, TAnnouncement> mgetAnnouncements(List<Long> ids, TAnnouncementDataOptions option) throws TSccException, TException {
        if (CollectionUtils.isEmpty(ids))
            return Collections.emptyMap();
        List<Announcement> announcementList = Announcement.find("id in (?1)", ids).fetch();
        if (CollectionUtils.isEmpty(announcementList))
            return Collections.emptyMap();
        Map<Long, TAnnouncement> announcementMap = new HashMap<Long, TAnnouncement>(announcementList.size());
        announcementConverter.ps2vm(announcementList, announcementMap);
        return announcementMap;
    }

    /**
     * 分页查询通知公告信息 2014.09.15 过滤掉被删除的应用，不在管控台显示
     */
    @Override
    @Transactional(readOnly = true)
    public TAnnouncementPage queryAnnouncements(@NotNull TAnnouncementQuery announcementQuery, @NotNull TAnnouncementDataOptions option) throws TSccException, TException {

        // 2014.09.15 过滤掉被删除的应用，不在管控台显示
        StringBuffer jpql = new StringBuffer(
                "from Announcement t where (t.dataStatus is NULL or t.dataStatus = 0) and t.detailInfo.category.subscribeSourceStatus = :subSourceStatus");
        Map<String, Object> paramList = Maps.newHashMap();
        paramList.put("subSourceStatus", TSubscribeSourceStatus.ONLINE);
        /* 状态 */
        if (announcementQuery.isSetStatus()) {
            jpql.append(" and t.status = :status");
            paramList.put("status", TAnnouncementStatus.ONLINE);
        }
        /* 分类 */
        if (announcementQuery.isSetCatIds()) {
            jpql.append(" and t.detailInfo.category.id in (:cat)");
            paramList.put("cat", announcementQuery.getCatIds());
        }
        /* 发布时间 */
        if (announcementQuery.isSetOnlineTimes()) {
            jpql.append(" and t.detailInfo.onlineTime");
            List<TQueryNum> onlineTimeList = announcementQuery.getOnlineTimes();
            for (TQueryNum tQTimeStamp : onlineTimeList) {
                if (tQTimeStamp.getCompareType() == TCompareType.EQUAL) {
                    jpql.append(" = :time");
                } else if (tQTimeStamp.getCompareType() == TCompareType.GREATER) {
                    jpql.append(" > :time");
                } else if (tQTimeStamp.getCompareType() == TCompareType.GREATER_EQUAL) {
                    jpql.append(" >= :time");
                } else if (tQTimeStamp.getCompareType() == TCompareType.LESS) {
                    jpql.append(" < :time");
                } else if (tQTimeStamp.getCompareType() == TCompareType.LESS_EQUAL) {
                    jpql.append(" <= :time");
                }
                paramList.put("time", tQTimeStamp.getValue());
            }
        }
        /* 标题 */
        if (announcementQuery.isSetTitle()) {
            jpql.append(" and t.baseInfo.title like :title");
            paramList.put("title", "%" + announcementQuery.getTitle() + "%");
        }
        /* 分页 */
        TAnnouncementPage page = new TAnnouncementPage();
        String countjpql = "select count(t.id) " + jpql;
        page.setTotal(Announcement.count(countjpql, paramList));
        if (page.getTotal() > 0) {
            /* 排序 */
            if (announcementQuery.isSetOrders()) {
                List<TAnnouncementOrder> orderList = announcementQuery.getOrders();
                for (TAnnouncementOrder order : orderList) {
                    if (order == TAnnouncementOrder.DEFAULT || order == TAnnouncementOrder.ONLINE_TIME_DESC) {
                        jpql.append(" order by t.detailInfo.onlineTime desc");
                    } else if (order == TAnnouncementOrder.ONLINE_TIME_ASC) {
                        jpql.append(" order by t.detailInfo.onlineTime asc");
                    }
                }
            }
            /* 组装对象 */
            JPAQuery q = Announcement.find(jpql.toString(), paramList).from(Long.valueOf(announcementQuery.getOffset()).intValue());
            List<Announcement> announcementList = announcementQuery.getLimit() < 0 ? q.<Announcement> fetch() : q.<Announcement> fetch(Long.valueOf(announcementQuery.getLimit())
                    .intValue());
            List<TAnnouncement> tAnnouncementList = new ArrayList<TAnnouncement>(announcementList.size());
            for (Announcement p : announcementList) {
                TAnnouncement v = new TAnnouncement();
                announcementConverter.p2v4Option(p, v, option);
                tAnnouncementList.add(v);
            }
            page.setItems(tAnnouncementList);
        } else {
            page.setItems(new ArrayList<TAnnouncement>(0));
        }
        page.setTimestamp(System.currentTimeMillis());
        return page;
    }

    /**
     * 保存通知公告源
     */
    @Override
    @Transactional
    public TSubscribeSource saveSubscribeSource(@NotNull TSubscribeSource subscribeSource) throws TSccException, TException {
        // 检查订阅源的名称是否已经存在
        if (SubscribeSource.exist(subscribeSource.getId(), subscribeSource.getName())) {
            /* 通知公告不存在 */
            throw new SccException(AnnouncementErrorCode.SUBSCRIBESOURCE_EXSIT);
        }
        SubscribeSource data = null;
        if (subscribeSource.getId() == 0) {
            data = new SubscribeSource();
        } else {
            data = SubscribeSource.findById(subscribeSource.getId());
            // 清除订阅源原有的角色
            SubscribeSourceRole.delete("subscribeSource.id = ?1", subscribeSource.getId());
        }
        subscribeConverter.v2p(subscribeSource, data);
        CrawlTemplate crawlTemplate = CrawlTemplate.findById(data.template.id);
        data.domain = crawlTemplate.domain;
        data.save();

        /* 角色列表 */
        List<TRole> tRoles = subscribeSource.getRoles();
        if (!CollectionUtils.isEmpty(tRoles)) {
            List<Role> roles = new ArrayList<Role>(tRoles.size());
            roleConverter.vs2ps(tRoles, roles);

            SubscribeSourceRole roleData = null;
            for (Role role : roles) {
                roleData = new SubscribeSourceRole();
                roleData.role = role;
                roleData.subscribeSource = data;
                roleData.save();
            }
        }
        subscribeSource = subscribeConverter.p2v(data);
        subscribeSource.setRoles(tRoles);

        // 如果为默认订阅源
        if (subscribeSource.getDefaultFlag() == 1) {
            crawUtil.addSubscribeDefaultSource(subscribeSource);
        }

        return subscribeSource;
    }

    /**
     * 更新通知公告源的状态
     */
    @Override
    @Transactional
    public void updateSubscribeSourceStatus(@Min(1) long id, @NotNull TSubscribeSourceStatus status) throws TSccException, TException {
        SubscribeSource subscribeSource = SubscribeSource.findById(id);
        if (subscribeSource == null) {
            /* 通知公告订阅源不存在 */
            throw new SccException(AnnouncementErrorCode.SUBSCRIBESOURCE_NOT_FOUND, id);
        }
        subscribeSource.subscribeSourceStatus = status;

        subscribeSource.save();
    }

    /**
     * 获取通知公告源详情
     */
    @Override
    @Transactional(readOnly = true)
    public TSubscribeSource getSubscribeSource(@Min(1) long id, @NotNull TSubscribeSourceDataOptions option) throws TSccException, TException {
        SubscribeSource subscribeSource = null;
        List<TRole> troleList = null;
        subscribeSource = SubscribeSource.findById(id);
        List<Role> roleList = SubscribeSourceRole.find("select t.role from SubscribeSourceRole t where t.subscribeSource.id = ?1", id).fetch();
        troleList = new ArrayList<TRole>(roleList.size());
        roleConverter.ps2vs(roleList, troleList);
        if (subscribeSource == null) {
            /* 通知公告不存在 */
            throw new SccException(AnnouncementErrorCode.SUBSCRIBESOURCE_NOT_FOUND, id);
        }
        TSubscribeSource v = new TSubscribeSource();
        subscribeConverter.p2v4Option(subscribeSource, v, option);
        v.setRoles(troleList);
        return v;
    }

    /**
     * 查询通知公告源列表
     */
    @Override
    @Transactional(readOnly = true)
    public List<TSubscribeSource> querySubscribeSources(@NotNull TSubscribeSourceQuery subscribeSourceQuery, @NotNull TSubscribeSourceDataOptions option) throws TSccException,
            TException {
        StringBuffer jpql = new StringBuffer("from SubscribeSource t where 1=1");
        Map<String, Object> paramList = Maps.newHashMap();
        /* 状态 */
        if (subscribeSourceQuery.isSetStatus()) {
            jpql.append(" and t.subscribeSourceStatus = :status");
            paramList.put("status", subscribeSourceQuery.getStatus());
        } else {
            jpql.append(" and t.subscribeSourceStatus != :status");
            paramList.put("status", TSubscribeSourceStatus.DELETE);
        }
        /* 角色 */
        if (subscribeSourceQuery.isSetRoles()) {
            jpql.append(" and exists(select t.id from SubscribeSourceRole r where r.role in (:roles) and r.subscribeSource = t.id)");
            List<Role> roles = new ArrayList<Role>(subscribeSourceQuery.getRolesSize());
            roleConverter.vs2ps(subscribeSourceQuery.getRoles(), roles);
            paramList.put("roles", roles);
        }
        /* 应用 */
        if (subscribeSourceQuery.isSetAppId() && subscribeSourceQuery.getAppId() != 0L) {
            jpql.append(" and exists(select t.id from SubscribeSourceApp a where a.app.id=:appId and a.subscribeSource = t.id)");
            paramList.put("appId", subscribeSourceQuery.getAppId());
        }
        /* 排序 */
        jpql.append(" order by t.createTime asc");
//        if (subscribeSourceQuery.isSetOrders()) {
//            List<TSubscribeSourceOrder> orderList = subscribeSourceQuery.getOrders();
//            for (TSubscribeSourceOrder order : orderList) {
//                if (order == TSubscribeSourceOrder.DEFAULT || order == TSubscribeSourceOrder.ONLINE_TIME_DESC) {
//                    jpql.append(" order by t.createTime desc");
//                } else if (order == TSubscribeSourceOrder.ONLINE_TIME_ASC) {
//                    jpql.append(" order by t.createTime asc");
//                }
//            }
//        }
        /* 组装对象 */
        JPAQuery q = SubscribeSource.find(jpql.toString(), paramList).from(Long.valueOf(subscribeSourceQuery.getOffset()).intValue());
        List<SubscribeSource> subscribeSourceList = subscribeSourceQuery.getLimit() < 0 ? q.<SubscribeSource> fetch() : q.<SubscribeSource> fetch(Long.valueOf(
                subscribeSourceQuery.getLimit()).intValue());
        List<TSubscribeSource> tSubscribeSource = new ArrayList<TSubscribeSource>(subscribeSourceList.size());
        for (SubscribeSource p : subscribeSourceList) {
            TSubscribeSource v = new TSubscribeSource();
            subscribeConverter.p2v4Option(p, v, option);
            tSubscribeSource.add(v);
        }
        /* 是否需要返回用户的订阅状态 */
        if (option.isUserSubscribeStatus() && subscribeSourceQuery.isSetUid()) {
            List<Long> sourceIdList = UserSubscribeInfo
                    .find("select subscribeSource.id from UserSubscribeInfo where creator.id = ?1 and status = 1", subscribeSourceQuery.getUid()).fetch();
            for (TSubscribeSource v : tSubscribeSource) {
                boolean isSubscribeFlag = false;
                for (Long sourceId : sourceIdList) {
                    if (v.getId() == sourceId) {
                        isSubscribeFlag = true;
                        break;
                    }
                }
                if (isSubscribeFlag) {
                    v.setSubscribeStatus(TSubscribeStatus.ON);
                } else {
                    v.setSubscribeStatus(TSubscribeStatus.OFF);
                }
            }
        }
        return tSubscribeSource;
    }

    /**
     * 获取某个用户已订阅的订阅源列表
     */
    @Override
    @Transactional
    public List<TSubscribeSource> queryUserSubscribeSourcesList(@Min(1) long uid, @NotNull List<Long> roleIds, @NotNull TSubscribeSourceDataOptions option, @Min(1) long appId)
            throws TSccException, TException {
        if (roleIds.isEmpty()) {
            throw new SccException(AnnouncementErrorCode.SUBSCRIBESOURCE_SUB_FAILED, uid);
        }
        List<TSubscribeSource> tSubscribeSource = null;
        // 游客
        if (uid == 0) {
            /* 状态 */
            StringBuffer jpql = new StringBuffer("from SubscribeSource t where t.subscribeSourceStatus = :status and t.defaultFlag = 1")
                    .append(" and exists(select t.id from SubscribeSourceRole r where r.role.id in (:roleIds) and r.subscribeSource = t.id)");
            Map<String, Object> paramList = Maps.newHashMap();
            paramList.put("status", TSubscribeSourceStatus.ONLINE);
            paramList.put("roleIds", roleIds);
            /* 应用 */
            if (appId != 0L) {
                jpql.append(" and exists(select t.id from SubscribeSourceApp a where a.app.id=:appId and a.subscribeSource = t.id)");
                paramList.put("appId", appId);
            }
            /* 排序 */
            jpql.append(" order by t.createTime asc");
            /* 组装对象 */
            List<SubscribeSource> subscribeSourceList = SubscribeSource.find(jpql.toString(), paramList).fetch();
            tSubscribeSource = new ArrayList<TSubscribeSource>(subscribeSourceList.size());
            for (SubscribeSource p : subscribeSourceList) {
                TSubscribeSource v = new TSubscribeSource();
                subscribeConverter.p2v4Option(p, v, option);
                tSubscribeSource.add(v);
            }
        }
        // 登录用户
        else {
            List<UserSubscribeInfo> list = UserSubscribeInfo.find("creator.id = ?1", uid).fetch();
            // 用户没有订阅过 系统会给用户订阅所有默认的订阅源
            if (CollectionUtils.isEmpty(list)) {
                subscribeDefaultSource(uid, roleIds);
            }

            List<Long> sourceIds = UserSubscribeInfo.find("select t.subscribeSource.id from UserSubscribeInfo t where t.creator.id = ?1 and t.status = 1", uid).fetch();
            if (!sourceIds.isEmpty()) {
                /* 状态 */
                StringBuffer jpql = new StringBuffer("from SubscribeSource t where t.subscribeSourceStatus = :status and t.id in (:sourceIds)")
                        .append(" and exists(select t.id from SubscribeSourceRole r where r.role.id in (:roleIds) and r.subscribeSource = t.id)");
                Map<String, Object> paramList = Maps.newHashMap();
                paramList.put("status", TSubscribeSourceStatus.ONLINE);
                paramList.put("sourceIds", sourceIds);
                paramList.put("roleIds", roleIds);
                /* 应用 */
                if (appId != 0L) {
                    jpql.append(" and exists(select t.id from SubscribeSourceApp a where a.app.id=:appId and a.subscribeSource = t.id)");
                    paramList.put("appId", appId);
                }
                /* 排序 */
                jpql.append(" order by t.createTime asc");
                /* 组装对象 */
                List<SubscribeSource> subscribeSourceList = SubscribeSource.find(jpql.toString(), paramList).fetch();
                tSubscribeSource = new ArrayList<TSubscribeSource>(subscribeSourceList.size());
                for (SubscribeSource p : subscribeSourceList) {
                    TSubscribeSource v = new TSubscribeSource();
                    subscribeConverter.p2v4Option(p, v, option);
                    tSubscribeSource.add(v);
                }
            } else {
                tSubscribeSource = new ArrayList<TSubscribeSource>(0);
            }
        }

        return tSubscribeSource;
    }

    /**
     * 用户订阅一个订阅源
     */
    @Override
    @Transactional
    public void subscribe(@Min(1) long uid, @Min(1) long ssid) throws TSccException, TException {
        SubscribeSource subscribeSource = (SubscribeSource) SubscribeSource.findById(ssid);
        if (subscribeSource == null) {
            /* 通知公告的订阅源不存在 */
            throw new SccException(AnnouncementErrorCode.SUBSCRIBESOURCE_NOT_FOUND, ssid);
        }
        User user = (User) User.findById(uid);
        if (user == null) {
            /* 用户不存在 */
            throw new SccException(AnnouncementErrorCode.ENTITY_NOT_FOUND, uid);
        }

        List<UserSubscribeInfo> list = UserSubscribeInfo.find("creator.id = ?1 and subscribeSource.id = ?2", uid, ssid).fetch();
        UserSubscribeInfo userSubscribeInfo = null;
        if (list.size() > 0) {
            userSubscribeInfo = list.get(0);
            if (userSubscribeInfo.status == 1) {
                /* 不能重复订阅 */
                throw new SccException(AnnouncementErrorCode.SUBSCRIBESOURCE_NOT_REPEATED, ssid);
            } else {
                userSubscribeInfo.status = 1;
                userSubscribeInfo.save();
            }
        } else {
            userSubscribeInfo = new UserSubscribeInfo();
            userSubscribeInfo.subscribeSource = subscribeSource;
            userSubscribeInfo.creator = user;
            userSubscribeInfo.save();
        }
    }

    /**
     * 用户取消一个订阅
     */
    @Override
    @Transactional
    public void unsubscribe(@Min(1) long uid, @Min(1) long ssid) throws TSccException, TException {
        List<UserSubscribeInfo> list = UserSubscribeInfo.find("creator.id = ?1 and subscribeSource.id = ?2", uid, ssid).fetch();
        if (!CollectionUtils.isEmpty(list)) {
            if (list.size() > 0) {
                UserSubscribeInfo.delete("creator.id = ?1 and subscribeSource.id = ?2", uid, ssid);
                UserSubscribeInfo userSubscribeInfo = new UserSubscribeInfo();
                userSubscribeInfo.creator = new User();
                userSubscribeInfo.creator.id = uid;
                userSubscribeInfo.subscribeSource = new SubscribeSource();
                userSubscribeInfo.subscribeSource.id = ssid;
                userSubscribeInfo.status = 0;
                userSubscribeInfo.save();
            } else {
                UserSubscribeInfo userSubscribeInfo = list.get(0);
                userSubscribeInfo.status = 0;
                userSubscribeInfo.save();
            }
        }
    }

    /**
     * 用户订阅所有的订阅源
     */
    @Override
    @Transactional
    public void subscribe4All(@Min(1) long uid, @NotNull List<Long> roleIds) throws TSccException, TException {
        if (roleIds.isEmpty()) {
            throw new SccException(AnnouncementErrorCode.SUBSCRIBESOURCE_SUB_FAILED, uid);
        }
        // 删除用户所有订阅信息
        UserSubscribeInfo.delete("creator.id = ?1", uid);

        StringBuffer jpql = new StringBuffer("from SubscribeSource t where t.subscribeSourceStatus = ?1")
                .append(" and exists(select t.id from SubscribeSourceRole r where r.role.id in (?2) and r.subscribeSource = t.id)");
        List<SubscribeSource> allSourceList = SubscribeSource.find(jpql.toString(), TSubscribeSourceStatus.ONLINE, roleIds).fetch();
        if (allSourceList != null && !allSourceList.isEmpty()) {
            UserSubscribeInfo userSubscribeInfo = null;
            for (SubscribeSource subscribeSource : allSourceList) {
                userSubscribeInfo = new UserSubscribeInfo();
                userSubscribeInfo.creator = new User();
                userSubscribeInfo.creator.id = uid;
                userSubscribeInfo.subscribeSource = subscribeSource;
                userSubscribeInfo.save();
            }
        }
    }

    @Override
    @Transactional
    public void subscribe4AllByAppId(long uid, List<Long> roleIds, long appId) throws TSccException, TException {
        if (roleIds.isEmpty() || appId == 0) {
            throw new SccException(AnnouncementErrorCode.SUBSCRIBESOURCE_SUB_FAILED, uid);
        }
        unsubscribe4AllByAppId(uid, appId);

        StringBuffer jpql = new StringBuffer("from SubscribeSource t where t.subscribeSourceStatus = ?1").append(
                " and exists(select t.id from SubscribeSourceRole r where r.role.id in (?2) and r.subscribeSource = t.id)").append(
                " and t.id in (select subscribeSource.id from SubscribeSourceApp where app.id = ?3)");
        List<SubscribeSource> allSourceList = SubscribeSource.find(jpql.toString(), TSubscribeSourceStatus.ONLINE, roleIds, appId).fetch();
        if (allSourceList != null && !allSourceList.isEmpty()) {
            UserSubscribeInfo userSubscribeInfo = null;
            for (SubscribeSource subscribeSource : allSourceList) {
                userSubscribeInfo = new UserSubscribeInfo();
                userSubscribeInfo.creator = new User();
                userSubscribeInfo.creator.id = uid;
                userSubscribeInfo.subscribeSource = subscribeSource;
                userSubscribeInfo.save();
            }
        }
    }

    /**
     * 用户取消全部的订阅
     */
    @Override
    @Transactional
    public void unsubscribe4All(@Min(1) long uid) throws TSccException, TException {
        String jpql = "update UserSubscribeInfo set status = 0 where creator.id = :uid";
        Query query = UserSubscribeInfo.em().createQuery(jpql);
        query.setParameter("uid", uid);
        query.executeUpdate();
    }

    @Override
    @Transactional
    public void unsubscribe4AllByAppId(long uid, long appId) throws TSccException, TException {
        String jpql = "update UserSubscribeInfo set status = 0 where creator.id = :uid and subscribeSource.id in (select subscribeSource.id from SubscribeSourceApp where app.id = :appId)";
        Query query = UserSubscribeInfo.em().createQuery(jpql);
        query.setParameter("uid", uid);
        query.setParameter("appId", appId);
        query.executeUpdate();
    }

    /**
     * 获取所有抓取模板列表
     */
    @Override
    @Transactional(readOnly = true)
    public List<TCrawlTemplate> queryTemplates() throws TSccException, TException {
        List<CrawlTemplate> crawlTemplates = CrawlTemplate.findAll();
        if (CollectionUtils.isEmpty(crawlTemplates)) {
            return Collections.emptyList();
        }
        List<TCrawlTemplate> vs = new ArrayList<TCrawlTemplate>(crawlTemplates.size());
        templateConverter.ps2vs(crawlTemplates, vs);
        return vs;
    }

    /**
     * 增加通知公告的浏览数
     */
    @Override
    @Transactional
    public long incrViewCount(@Min(1) long announcementId) throws TSccException, TException {
        return AnnouncementDetail.incrViewCount(announcementId);
    }

    /**
     * 用户订阅默认订阅源(用户注册时使用)
     */
    @Override
    @Transactional
    public void subscribeDefaultSource(@Min(1) long uid, @NotNull List<Long> roleIds) throws TSccException, TException {
        if (roleIds.isEmpty()) {
            throw new SccException(AnnouncementErrorCode.SUBSCRIBESOURCE_SUB_FAILED, uid);
        }
        User user = (User) User.findById(uid);
        if (user == null) {
            /* 用户不存在 */
            throw new SccException(AnnouncementErrorCode.ENTITY_NOT_FOUND, uid);
        }
        StringBuffer jpql = new StringBuffer("from SubscribeSource t where defaultFlag = 1 and t.subscribeSourceStatus = ?1").append(" and domain.key = ?2").append(
                " and exists(select t.id from SubscribeSourceRole r where r.role.id in (?3) and r.subscribeSource = t.id)");
        List<SubscribeSource> subscribeSources = SubscribeSource.find(jpql.toString(), TSubscribeSourceStatus.ONLINE, Sec.getDomainKey(), roleIds).fetch();
        if (!CollectionUtils.isEmpty(subscribeSources)) {
            for (SubscribeSource subscribeSource : subscribeSources) {
                UserSubscribeInfo userSubscribeInfo = new UserSubscribeInfo();
                userSubscribeInfo.subscribeSource = subscribeSource;
                userSubscribeInfo.creator = user;
                userSubscribeInfo.save();
            }
        }
    }

    /**
     * 获取通知公告未读信息的数目
     */
    @Override
    @Transactional(readOnly = true)
    public int getUnreadCount(List<TAnnouncementUnreadCount> params) throws TSccException, TException {
        if (CollectionUtils.isEmpty(params)) {
            return 0;
        } else {
            StringBuffer jpql = new StringBuffer("select count(t.id) from AnnouncementDetail t where");
            int size = params.size();
            int index = 1;
            for (TAnnouncementUnreadCount param : params) {
                jpql.append(" (t.category.id = ").append(param.getSsid()).append(" and t.onlineTime > ").append(param.getLastTime()).append(")");
                if (index < size) {
                    jpql.append(" or ");
                }
                index++;
            }
            return (int) AnnouncementDetail.count(jpql.toString());
        }
    }

    @Override
    @Transactional(readOnly = true)
    public long getUnreadNum(List<Long> sids, long timestamp) throws TSccException, TException {
        String jpql = "SELECT COUNT(*) FROM t_scc_announcement_detail WHERE ID_CATEGORY IN(SELECT id FROM t_scc_announcement_sub WHERE id in (:sids) AND STATUS = 0) AND TIME_ONLINE > :timestamp";
        Query query = Announcement.em().createNativeQuery(jpql);
        query.setParameter("sids", sids);
        query.setParameter("timestamp", timestamp);
        return Long.parseLong(query.getSingleResult().toString());

    }

    /**
     * 删除通知公告.
     */
    @Override
    @Transactional
    public void deleteAnnouncements(List<Long> ids) throws TSccException, TException {
        if (ids != null && ids.size() > 0) {
            for (Long id : ids) {
                Announcement announcement = Announcement.findById(id);
                if (null != announcement) {
                    announcement.dataStatus = Status.DELETED;
                    announcement.save();
                }
            }
        }
    }
}
