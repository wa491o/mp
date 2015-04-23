/*
 * ��ҳ���
 * ����jquery��Ͱ汾Ϊ1.4.2
 * @���� Gabriel Birke (birke *at* d-scribe *dot* de)
 * @ ���룺����Ե  qq:80213876   http://blog.csdn.net/luoyeyu1989         .net��վ����ɾ���ӣ�seo�Ż��� http://www.89nian.com
 * @2011-11-22
 * @�汾 2.2
 * @��ϸ�����readme.txt
 */
 (function($){
	/**
	 * @�����ҳֵ��class��
	 */
	$.PaginationCalculator = function(maxentries, opts) {
		this.maxentries = maxentries;
		this.opts = opts;
	}
	
	$.extend($.PaginationCalculator.prototype, {
		/**
		 * ������ҳ��
		 * @���� {Number}
		 */
		numPages:function() {
			return Math.ceil(this.maxentries/this.opts.items_per_page);
		},
		/**
		 * ���㿪ʼ�ͽ����ķ�ҳ
		 * ��ǰҳ�����Ҫ��ʾ��ҳ��
		 * @�������� {Array}
		 */
		getInterval:function(current_page)  {
			var ne_half = Math.floor(this.opts.num_display_entries/2);
			var np = this.numPages();
			var upper_limit = np - this.opts.num_display_entries;
			var start = current_page > ne_half ? Math.max( Math.min(current_page - ne_half, upper_limit), 0 ) : 0;
			var end = current_page > ne_half?Math.min(current_page+ne_half + (this.opts.num_display_entries % 2), np):Math.min(this.opts.num_display_entries, np);
			return {start:start, end:end};
		}
	});
	
	// ��ʼ����ҳ��jquery�������
	$.PaginationRenderers = {}
	
	/**
	 * @��Ⱦ��ҳt�ӵ���
	 */
	$.PaginationRenderers.defaultRenderer = function(maxentries, opts) {
		this.maxentries = maxentries;
		this.opts = opts;
		this.pc = new $.PaginationCalculator(maxentries, opts);
	}
	$.extend($.PaginationRenderers.defaultRenderer.prototype, {
		/**
		 * ���һ��5�t�ӵĺ�������ǵ�ǰҳ�������span��ǩ��
		 * @���� {Number} page_id ����ҳ��ҳ��
		 * @���� {Number}current_page ����ǰҳҳ��
		 * @���� {Object} appendopts ����ҳ��options���ı�����
		 * @���� {jQuery} ����t�ӵ�jquery����
		 */
		createLink:function(page_id, current_page, appendopts){
			var lnk, np = this.pc.numPages();
			page_id = page_id<0?0:(page_id<np?page_id:np-1); 
			appendopts = $.extend({text:page_id+1, classes:""}, appendopts||{});
			if(page_id == current_page){
				lnk = $("<span class='current'>" + appendopts.text + "</span>");
			}
			else
			{
				lnk = $("<a>" + appendopts.text + "</a>")
					.attr('href', this.opts.link_to.replace(/__id__/,page_id));
			}
			if(appendopts.classes){ lnk.addClass(appendopts.classes); }
			lnk.data('page_id', page_id);
			return lnk;
		},
		// ������ַ�Χ�ڵ�ҳ��t��
		appendRange:function(container, current_page, start, end, opts) {
			var i;
			for(i=start; i<end; i++) {
				this.createLink(i, current_page, opts).appendTo(container);
			}
		},
		getLinks:function(opts, current_page, eventHandler) {
			var begin, end,
				interval = this.pc.getInterval(current_page),
				np = this.pc.numPages(),
				fragment = $("<div class='paginationStyle' style='float:"+opts.position+"'></div>");
			
			// ��ɡ���һҳ����t��
			if(this.opts.prev_text && (current_page > 0 || this.opts.prev_show_always)){
				fragment.append(this.createLink(current_page-1, current_page, {text:this.opts.prev_text, classes:"prev"}));
			}
			// ��ʼ��
			if (interval.start > 0 && this.opts.num_edge_entries > 0)
			{
				end = Math.min(this.opts.num_edge_entries, interval.start);
				this.appendRange(fragment, current_page, 0, end, {classes:'sp'});
				if(this.opts.num_edge_entries < interval.start && this.opts.ellipse_text)
				{
					jQuery("<span>"+this.opts.ellipse_text+"</span>").appendTo(fragment);
				}
			}
			// t��֮��ļ��
			this.appendRange(fragment, current_page, interval.start, interval.end);
			// �����
			if (interval.end < np && this.opts.num_edge_entries > 0)
			{
				if(np-this.opts.num_edge_entries > interval.end && this.opts.ellipse_text)
				{
					jQuery("<span>"+this.opts.ellipse_text+"</span>").appendTo(fragment);
				}
				begin = Math.max(np-this.opts.num_edge_entries, interval.end);
				this.appendRange(fragment, current_page, begin, np, {classes:'ep'});
				
			}
			// ����һҳ��t��
			if(this.opts.next_text && (current_page < np-1 || this.opts.next_show_always)){
				fragment.append(this.createLink(current_page+1, current_page, {text:this.opts.next_text, classes:"next"}));
			}
			$('a', fragment).click(eventHandler);
			return fragment;
		}
	});
	
	// jquery)չ
	$.fn.pagination = function(maxentries, opts){
		
		//��ʼ��Options��Ĭ��ֵ
		opts = jQuery.extend({
			position:"right",
			items_per_page:10,
			num_display_entries:11,
			current_page:0,
			num_edge_entries:0,
			link_to:"#",
			prev_text:"上一页",
			next_text:"下一页",
			ellipse_text:"...",
			prev_show_always:true,
			next_show_always:true,
			renderer:"defaultRenderer",
			load_first_page:false,
			callback:function(){return false;}
		},opts||{});
		
		var containers = this,
			renderer, links, current_page;
		
		/**
		 * ��ҳt���¼����?��
		 * @���� {int} page_id ���µ�ҳ��
		 */
		function paginationClickHandler(evt){
			var links, 
				new_current_page = $(evt.target).data('page_id'),
				continuePropagation = selectPage(new_current_page);
			if (!continuePropagation) {
				evt.stopPropagation();
			}
			return continuePropagation;
		}
		
		/**
		 * �ڲ��¼����?��
		 * �ڷ�ҳ��������������µķ�ҳ
		 * ��ݷ�ҳt�Ӻͻص�����µ�html
		 * �ص���
		 */
		function selectPage(new_current_page) {
			// ���������е�����t����ʾ
			containers.data('current_page', new_current_page);
			links = renderer.getLinks(opts, new_current_page, paginationClickHandler);
			containers.empty();
			links.appendTo(containers);
			// ����true������ûص����Լ�һЩ�¼���
			var continuePropagation = opts.callback(new_current_page, containers);
			return continuePropagation;
		}
		
		// -----------------------------------
		// ��ҳ�����ʼ��
		// -----------------------------------
		current_page = opts.current_page;
		containers.data('current_page', current_page);
		// Ϊ maxentries �� items_per_page��ֵ
		maxentries = (!maxentries || maxentries < 0)?1:maxentries;
		opts.items_per_page = (!opts.items_per_page || opts.items_per_page < 0)?1:opts.items_per_page;
		
		if(!$.PaginationRenderers[opts.renderer])
		{
			throw new ReferenceError("Pagination renderer '" + opts.renderer + "' was not found in jQuery.PaginationRenderers object.");
		}
		renderer = new $.PaginationRenderers[opts.renderer](maxentries, opts);
		
		// ����Ӧ��domԪ�ذ��¼�
		var pc = new $.PaginationCalculator(maxentries, opts);
		var np = pc.numPages();
		containers.bind('setPage', {numPages:np}, function(evt, page_id) { 
				if(page_id >= 0 && page_id < evt.data.numPages) {
					selectPage(page_id); return false;
				}
		});
		containers.bind('prevPage', function(evt){
				var current_page = $(this).data('current_page');
				if (current_page > 0) {
					selectPage(current_page - 1);
				}
				return false;
		});
		containers.bind('nextPage', {numPages:np}, function(evt){
				var current_page = $(this).data('current_page');
				if(current_page < evt.data.numPages - 1) {
					selectPage(current_page + 1);
				}
				return false;
		});
		
		// �����еĳ�ʼ����ɺ�����t��
		links = renderer.getLinks(opts, current_page, paginationClickHandler);
		containers.empty();
		links.appendTo(containers);
		// �ص���
		if(opts.load_first_page) {
			opts.callback(current_page, containers);
		}
	} // ��ҳ�������
	
})(jQuery);
