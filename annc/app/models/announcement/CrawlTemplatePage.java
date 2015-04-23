package models.announcement;

import java.util.List;

import com.wisorg.scc.api.internal.announcement.TCrawlTemplate;

public class CrawlTemplatePage {

	private List<TCrawlTemplate> items; // optional
	private long total; // optional
	private long timestamp; // optional
	
	public List<TCrawlTemplate> getItems() {
		return items;
	}
	public void setItems(List<TCrawlTemplate> items) {
		this.items = items;
	}
	public long getTotal() {
		return total;
	}
	public void setTotal(long total) {
		this.total = total;
	}
	public long getTimestamp() {
		return timestamp;
	}
	public void setTimestamp(long timestamp) {
		this.timestamp = timestamp;
	}
}
