	(function (d) {
		d['okValue'] = '确定';
	    d['cancelValue'] = '取消';
	    d['title'] = '消息';
	    // [more..]
	})($.dialog.defaults);
	
	$.fn.page.settings.pagesize=10;
	function page(num){
		$(this).page({
		drawTable:showData,
		currentnum:num,
		buttonClickCallback:pageClick
		});
	}
	function pageClick(num){
		$.fn.page.settings.currentnum = num;
		query();
	}