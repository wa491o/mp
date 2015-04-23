package models.announcement;

import java.io.Serializable;

/**
 * 模板源查询条件.
 * @author 
 *
 */
public class CrawTemplateQuery implements Serializable{
	private static final long serialVersionUID = -2677673239266823427L;
	
	private String name;
	private String domainKey; //
	private long offset; // optional
	private long limit; // optional

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDomainKey() {
		return domainKey;
	}

	public void setDomainKey(String domainKey) {
		this.domainKey = domainKey;
	}

	public long getOffset() {
		return offset;
	}

	public void setOffset(long offset) {
		this.offset = offset;
	}

	public long getLimit() {
		return limit;
	}

	public void setLimit(long limit) {
		this.limit = limit;
	}
}
