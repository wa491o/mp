package services.announcement.vgroup.impl;

import java.util.List;

import models.announcement.UserSubscribeInfo;
import models.identity.Account;
import models.identity.UserDevice;

import org.apache.thrift.TException;
import org.springframework.stereotype.Service;

import play.db.jpa.JPA;
import services.identity.vgroup.AbstractVGroupProvider;

import com.wisorg.scc.api.internal.announcement.AnnouncementConstants;
import com.wisorg.scc.api.internal.announcement.TSubscribeStatus;
import com.wisorg.scc.api.internal.identity.TAccountStatus;
import com.wisorg.scc.api.internal.identity.TUserDevice;
import com.wisorg.scc.api.internal.identity.TVGroup;
import com.wisorg.scc.api.internal.standard.TOSType;

/**
 * .
 * <p/>
 * 
 * @author <a href="mailto:oznyang@163.com">oznyang</a>
 * @version V1.0, 11/14/13
 */
@Service
public class AnnouncementVGroupProvider extends AbstractVGroupProvider {

    @Override
    public String getType() throws TException {
        return AnnouncementConstants.VGROUP_ANNOUNCEMENT;
    }

    @Override
    public List<Long> getUserIds(TVGroup group, int offset, int limit) throws TException {
        return UserSubscribeInfo
                .find("select t.creator.id from UserSubscribeInfo t where t.subscribeSource.id = ?1 and t.status = 1 order by t.id",
                        Long.valueOf(group.getKey())).from(offset).fetch(limit);
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<TUserDevice> getUserDevices(TVGroup group, TOSType os, int offset, int limit) throws TException {
        List<UserDevice> list;
        String sql = null;
        if (os == null || os == TOSType.UNKNOWN) {
            sql = "SELECT DISTINCT t1.* FROM t_scc_user_device t1 LEFT JOIN t_scc_announcement_user_sub t2 ON t1.USER_ID = t2.USER_ID WHERE t2.SSID = :sid AND t2.STATUS = 1 ORDER BY t1.token";
            list = JPA.em().createNativeQuery(sql, UserDevice.class).setFirstResult(offset)
                    .setParameter("sid", Long.valueOf(group.getKey())).setMaxResults(limit).getResultList();
        } else {
            sql = "SELECT DISTINCT t1.* FROM t_scc_user_device t1 LEFT JOIN t_scc_announcement_user_sub t2 ON t1.USER_ID = t2.USER_ID WHERE t2.SSID = :sid AND TYPE_OS = :os AND t2.STATUS = 1 ORDER BY t1.token";
            list = JPA.em().createNativeQuery(sql, UserDevice.class).setParameter("sid", Long.valueOf(group.getKey()))
                    .setParameter("os", os).setFirstResult(offset).setMaxResults(limit).getResultList();
        }
        return userDeviceConverter.ps2vs(list);
    }

    @Override
    public boolean isInGroup(TVGroup group, long userId) throws TException {
        Account account = Account.findById(userId);
        return account.status == TAccountStatus.NORMAL
                && UserSubscribeInfo.isSubscribe(userId, Long.valueOf(group.getKey()), TSubscribeStatus.ON);
    }

}
