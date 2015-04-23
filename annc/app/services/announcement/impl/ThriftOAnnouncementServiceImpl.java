package services.announcement.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.thrift.TException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import com.wisorg.scc.api.internal.announcement.TAnnouncement;
import com.wisorg.scc.api.internal.announcement.TAnnouncementDataOptions;
import com.wisorg.scc.api.internal.announcement.TAnnouncementOrder;
import com.wisorg.scc.api.internal.announcement.TAnnouncementPage;
import com.wisorg.scc.api.internal.announcement.TAnnouncementQuery;
import com.wisorg.scc.api.internal.announcement.TAnnouncementService;
import com.wisorg.scc.api.internal.announcement.TAnnouncementStatus;
import com.wisorg.scc.api.internal.announcement.TAnnouncementUnreadCount;
import com.wisorg.scc.api.internal.announcement.TSubscribeSource;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceDataOptions;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceQuery;
import com.wisorg.scc.api.internal.announcement.TSubscribeSourceStatus;
import com.wisorg.scc.api.internal.identity.TRole;
import com.wisorg.scc.api.internal.security.Check;
import com.wisorg.scc.api.internal.security.Role;
import com.wisorg.scc.api.open.announcement.AnnouncementIndex;
import com.wisorg.scc.api.open.announcement.OAnnouncementService.Iface;
import com.wisorg.scc.api.type.TSccException;
import com.wisorg.scc.core.rpc.Export;
import com.wisorg.scc.core.security.Sec;

@Service
@Export(opened = true)
@Check(value = { "scope.pro" })
public class ThriftOAnnouncementServiceImpl implements Iface {

    @Autowired
    private TAnnouncementService.Iface announcementService;

    /**
     * 获取通知公告详细信息
     */
    @Override
    @Transactional
    public TAnnouncement getAnnouncement(long id, TAnnouncementDataOptions option) throws TSccException, TException {
        TAnnouncement announcement = announcementService.getAnnouncement(id, option);
        if (option.isDetail()) {
            announcement.getDetailInfo().setViewCount(announcementService.incrViewCount(id));
        }
        return announcement;
    }

    /**
     * 分页查询通知公告信息
     */
    @Override
    @Transactional
    public TAnnouncementPage queryAnnouncements(TAnnouncementQuery announcementQuery, TAnnouncementDataOptions option) throws TSccException, TException {
        if (!announcementQuery.isSetOrders()) {
            List<TAnnouncementOrder> orders = new ArrayList<TAnnouncementOrder>(1);
            orders.add(TAnnouncementOrder.DEFAULT);
            announcementQuery.setOrders(orders);
        }

        return announcementService.queryAnnouncements(announcementQuery, option);
    }

    /**
     * 通知公告栏目首页信息初始化
     */
    @Override
    @Transactional
    public AnnouncementIndex initAnnouncementIndex() throws TSccException, TException {
        AnnouncementIndex indexData = new AnnouncementIndex();
        TSubscribeSourceQuery sourceQuery = new TSubscribeSourceQuery();
        sourceQuery.setStatus(TSubscribeSourceStatus.ONLINE);
        sourceQuery.setOffset(0L);
        sourceQuery.setLimit(Integer.MAX_VALUE);
        TSubscribeSourceDataOptions option = new TSubscribeSourceDataOptions();
        option.setBase(true);
        Set<Long> roleSet = Sec.getRoleIds();
        List<Long> roleIds = new ArrayList<Long>();
        if (!CollectionUtils.isEmpty(roleSet)) {
            roleIds = new ArrayList<Long>(roleSet.size());
            Iterator<Long> it = roleSet.iterator();
            while (it.hasNext()) {
                roleIds.add(it.next());
            }
        } else {
            roleIds = new ArrayList<Long>(0);
        }
        List<TSubscribeSource> subscribeSourceList = announcementService.queryUserSubscribeSourcesList(Sec.isGuest() ? 0L : Sec.getUserId(), roleIds, option, 0L);
        TAnnouncementPage announcementPage = null;
        if (CollectionUtils.isEmpty(subscribeSourceList)) {
            subscribeSourceList = Collections.emptyList();
            announcementPage = new TAnnouncementPage();
        } else {
            Set<Long> catIds = new HashSet<Long>(1);
            TSubscribeSource source = subscribeSourceList.get(0);
            catIds.add(source.getId());
            TAnnouncementQuery announcementQuery = new TAnnouncementQuery();
            announcementQuery.setStatus(TAnnouncementStatus.ONLINE);
            announcementQuery.setCatIds(catIds);
            announcementQuery.setOffset(0L);
            announcementQuery.setLimit(15L);
            List<TAnnouncementOrder> orders = new ArrayList<TAnnouncementOrder>(1);
            orders.add(TAnnouncementOrder.DEFAULT);
            announcementQuery.setOrders(orders);
            TAnnouncementDataOptions announcementOption = new TAnnouncementDataOptions();
            announcementOption.setBase(true);
            announcementOption.setTime(true);
            announcementPage = queryAnnouncements(announcementQuery, announcementOption);
        }
        indexData.setSubscribeSourceList(subscribeSourceList);
        indexData.setAnnouncementPage(announcementPage);
        return indexData;
    }

    /**
     * 根据指定的应用标识初始化栏目首页信息
     */
    @Override
    @Transactional
    public AnnouncementIndex initAnnouncementIndexByAppId(long appId) throws TSccException, TException {
        AnnouncementIndex indexData = new AnnouncementIndex();
        TSubscribeSourceQuery sourceQuery = new TSubscribeSourceQuery();
        sourceQuery.setStatus(TSubscribeSourceStatus.ONLINE);
        sourceQuery.setOffset(0L);
        sourceQuery.setLimit(Integer.MAX_VALUE);
        TSubscribeSourceDataOptions option = new TSubscribeSourceDataOptions();
        option.setBase(true);
        Set<Long> roleSet = Sec.getRoleIds();
        List<Long> roleIds = new ArrayList<Long>();
        if (!CollectionUtils.isEmpty(roleSet)) {
            roleIds = new ArrayList<Long>(roleSet.size());
            Iterator<Long> it = roleSet.iterator();
            while (it.hasNext()) {
                roleIds.add(it.next());
            }
        } else {
            roleIds = new ArrayList<Long>(0);
        }
        List<TSubscribeSource> subscribeSourceList = announcementService.queryUserSubscribeSourcesList(Sec.isGuest() ? 0L : Sec.getUserId(), roleIds, option, appId);
        TAnnouncementPage announcementPage = null;
        if (CollectionUtils.isEmpty(subscribeSourceList)) {
            subscribeSourceList = Collections.emptyList();
            announcementPage = new TAnnouncementPage();
        } else {
            Set<Long> catIds = new HashSet<Long>(1);
            TSubscribeSource source = subscribeSourceList.get(0);
            catIds.add(source.getId());
            TAnnouncementQuery announcementQuery = new TAnnouncementQuery();
            announcementQuery.setStatus(TAnnouncementStatus.ONLINE);
            announcementQuery.setCatIds(catIds);
            announcementQuery.setOffset(0L);
            announcementQuery.setLimit(15L);
            List<TAnnouncementOrder> orders = new ArrayList<TAnnouncementOrder>(1);
            orders.add(TAnnouncementOrder.DEFAULT);
            announcementQuery.setOrders(orders);
            TAnnouncementDataOptions announcementOption = new TAnnouncementDataOptions();
            announcementOption.setBase(true);
            announcementOption.setTime(true);
            announcementPage = queryAnnouncements(announcementQuery, announcementOption);
        }
        indexData.setSubscribeSourceList(subscribeSourceList);
        indexData.setAnnouncementPage(announcementPage);
        return indexData;
    }

    /**
     * 查询通知公告源列表
     */
    @Override
    @Transactional
    public List<TSubscribeSource> querySubscribeSources(TSubscribeSourceQuery subscribeSourceQuery, TSubscribeSourceDataOptions option) throws TSccException, TException {
        subscribeSourceQuery.setUid(Sec.getUserId());
        Set<Role> roleSet = Sec.getRoles();
        if (!CollectionUtils.isEmpty(roleSet)) {
            List<TRole> roles = new ArrayList<TRole>(roleSet.size());
            Iterator<Role> it = roleSet.iterator();
            while (it.hasNext()) {
                Role role = it.next();
                TRole trole = new TRole();
                trole.setId(role.getId());
                roles.add(trole);
            }
            subscribeSourceQuery.setRoles(roles);
        }
        return announcementService.querySubscribeSources(subscribeSourceQuery, option);
    }

    /**
     * 用户订阅一个订阅源
     */
    @Override
    @Transactional
    public void subscribe(long ssid) throws TException {
        announcementService.subscribe(Sec.getUserId(), ssid);
    }

    /**
     * 用户取消一个订阅
     */
    @Override
    @Transactional
    public void unsubscribe(long ssid) throws TException {
        announcementService.unsubscribe(Sec.getUserId(), ssid);
    }

    /**
     * 用户订阅所以的订阅源
     */
    @Override
    @Transactional
    public void subscribe4All() throws TException {
        Set<Long> roleSet = Sec.getRoleIds();
        List<Long> roleIds = new ArrayList<Long>();
        if (!CollectionUtils.isEmpty(roleSet)) {
            roleIds = new ArrayList<Long>(roleSet.size());
            Iterator<Long> it = roleSet.iterator();
            while (it.hasNext()) {
                roleIds.add(it.next());
            }
        } else {
            roleIds = new ArrayList<Long>(0);
        }
        announcementService.subscribe4All(Sec.getUserId(), roleIds);
    }

    @Override
    @Transactional
    public void subscribe4AllByAppId(long appId) throws TSccException, TException {
        Set<Long> roleSet = Sec.getRoleIds();
        List<Long> roleIds = new ArrayList<Long>();
        if (!CollectionUtils.isEmpty(roleSet)) {
            roleIds = new ArrayList<Long>(roleSet.size());
            Iterator<Long> it = roleSet.iterator();
            while (it.hasNext()) {
                roleIds.add(it.next());
            }
        } else {
            roleIds = new ArrayList<Long>(0);
        }
        announcementService.subscribe4AllByAppId(Sec.getUserId(), roleIds, appId);
    }

    /**
     * 用户取消全部的订阅
     */
    @Override
    @Transactional
    public void unsubscribe4All() throws TException {
        announcementService.unsubscribe4All(Sec.getUserId());
    }

    @Override
    public void unsubscribe4AllByAppId(long appId) throws TSccException, TException {
        announcementService.unsubscribe4AllByAppId(Sec.getUserId(), appId);
    }

    /**
     * 获取通知公告未读信息的数目
     */
    @Override
    @Transactional(readOnly = true)
    public int getUnreadCount(List<TAnnouncementUnreadCount> params) throws TSccException, TException {
        return announcementService.getUnreadCount(params);
    }

    @Override
    @Transactional(readOnly = true)
    public long getUnreadNum(long timestamp) throws TSccException, TException {
        TSubscribeSourceQuery sourceQuery = new TSubscribeSourceQuery();
        sourceQuery.setStatus(TSubscribeSourceStatus.ONLINE);
        sourceQuery.setOffset(0L);
        sourceQuery.setLimit(Integer.MAX_VALUE);
        TSubscribeSourceDataOptions option = new TSubscribeSourceDataOptions();
        option.setBase(true);
        Set<Long> roleSet = Sec.getRoleIds();
        List<Long> roleIds = new ArrayList<Long>();
        if (!CollectionUtils.isEmpty(roleSet)) {
            roleIds = new ArrayList<Long>(roleSet.size());
            Iterator<Long> it = roleSet.iterator();
            while (it.hasNext()) {
                roleIds.add(it.next());
            }
        } else {
            roleIds = new ArrayList<Long>(0);
        }
        List<TSubscribeSource> subscribeSourceList = announcementService.queryUserSubscribeSourcesList(Sec.isGuest() ? 0L : Sec.getUserId(), roleIds, option, 0L);
        if (CollectionUtils.isEmpty(subscribeSourceList)) {
            return 0;
        } else {
            List<Long> sids = new ArrayList<Long>();
            for (TSubscribeSource s : subscribeSourceList) {
                sids.add(s.getId());
            }
            return announcementService.getUnreadNum(sids, timestamp);
        }
    }

    @Override
    @Transactional
    public long getUnreadNumByAppId(long timestamp, long appId) throws TSccException, TException {
        TSubscribeSourceQuery sourceQuery = new TSubscribeSourceQuery();
        sourceQuery.setStatus(TSubscribeSourceStatus.ONLINE);
        sourceQuery.setOffset(0L);
        sourceQuery.setLimit(Integer.MAX_VALUE);
        TSubscribeSourceDataOptions option = new TSubscribeSourceDataOptions();
        option.setBase(true);
        Set<Long> roleSet = Sec.getRoleIds();
        List<Long> roleIds = new ArrayList<Long>();
        if (!CollectionUtils.isEmpty(roleSet)) {
            roleIds = new ArrayList<Long>(roleSet.size());
            Iterator<Long> it = roleSet.iterator();
            while (it.hasNext()) {
                roleIds.add(it.next());
            }
        } else {
            roleIds = new ArrayList<Long>(0);
        }
        List<TSubscribeSource> subscribeSourceList = announcementService.queryUserSubscribeSourcesList(Sec.isGuest() ? 0L : Sec.getUserId(), roleIds, option, appId);
        if (CollectionUtils.isEmpty(subscribeSourceList)) {
            return 0;
        } else {
            List<Long> sids = new ArrayList<Long>();
            for (TSubscribeSource s : subscribeSourceList) {
                sids.add(s.getId());
            }
            return announcementService.getUnreadNum(sids, timestamp);
        }

    }
}
