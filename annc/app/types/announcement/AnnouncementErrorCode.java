package types.announcement;

import com.wisorg.scc.api.internal.core.ex.ErrorCode;

/**
 * 通知公告异常定义.
 * <p>
 * 异常号段：2000~2099
 * </p>
 * 
 * @author jfli 2013-10-25
 */
public interface AnnouncementErrorCode extends ErrorCode {
    /**
     * 起始号段
     */
    static final int ANNOUNCEMENT_ERROR = CUSTOM * 20;

    /**
     * 通知公告不存在
     */
    static final int ANNOUNCEMENT_NOT_FOUND = ANNOUNCEMENT_ERROR + 1;

    /**
     * 通知公告的订阅源不存在
     */
    static final int SUBSCRIBESOURCE_NOT_FOUND = ANNOUNCEMENT_ERROR + 2;

    /**
     * 不能重复订阅同一个订阅源
     */
    static final int SUBSCRIBESOURCE_NOT_REPEATED = ANNOUNCEMENT_ERROR + 3;

    /**
     * 订阅失败
     */
    static final int SUBSCRIBESOURCE_SUB_FAILED = ANNOUNCEMENT_ERROR + 4;

    /**
     * 订阅源名称已经存在
     */
    static final int SUBSCRIBESOURCE_EXSIT = ANNOUNCEMENT_ERROR + 5;
}
