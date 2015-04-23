package jobs.announcement;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import play.jobs.On;
import services.announcement.util.AnnouncementCrawUtil;

import com.wisorg.scc.core.play.container.Container;
import com.wisorg.scc.core.play.job.ConfigurableJob;

@On("0 */59 * * * ?")
public class AnnouncementCrawJob extends ConfigurableJob<Void> {
	private static final Logger LOGGER = LoggerFactory.getLogger(AnnouncementCrawJob.class);
    @Override
    protected void doJobInternal() {
    	LOGGER.info("===================>:begin to CrawJob AnnouncementCrawJob !");
        AnnouncementCrawUtil announcementUtil = Container.get(AnnouncementCrawUtil.class);
        announcementUtil.crawTask();
    }
}
