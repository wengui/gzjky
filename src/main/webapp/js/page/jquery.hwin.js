/**
 * jQuery dataForJson Plugin 1.0.0
 *
 *	http://www.995120.cn
 *
 * Copyright (c) 2011 hellowin
 *
 */
jQuery.fn.dataForJson = function (options) {
	var opts = jQuery.extend({}, options);
	var id = this.attr("id");
	var date = "";
	var prefix = opts.prefix;
	if (prefix == undefined) {
		prefix = "";
	}
	if (prefix.length > 0) {
		prefix += ".";
	}
	jQuery("#" + id + " :text[jsonhide!=true]").each(function () {
		date += addValue(prefix, this.id, this.value);
	});
	jQuery("#" + id + " input[type=hidden][jsonhide!=true]").each(function () {
		date += addValue(prefix, this.id, this.value);
	});
	jQuery("#" + id + " :password[jsonhide!=true]").each(function () {
		date += addValue(prefix, this.id, this.value);
	});
	jQuery("#" + id + " :radio:checked[jsonhide!=true]").each(function () {
		date += addValue(prefix, this.id, this.value);
	});
	jQuery("#" + id + " textarea[jsonhide!=true]").each(function () {
		date += addValue(prefix, this.id, this.value);
	});
	jQuery("#" + id + " select[jsonhide!=true] option:selected").each(function () {
		date += addValue(prefix, $(this).parent().attr("id"), this.value);
	});
	jQuery("#" + id + " :checkbox:checked[jsonhide!=true]").each(function () {
		date += addValue(prefix, this.id, this.value);
	});
	/**jQuery("#" + id + " :file[jsonhide!=true]").each(function () {
		date += addValue(prefix, this.id, this.value);
	});
	jQuery("#" + id + " img[jsonhide!=true]").each(function () {
		date += addValue(prefix, this.id, this.src);
	});*/
	if (date.length > 0) {
		date = date.slice(1);
	}
	return date;
};

function addValue(prefix, name, value) {
	if (name != undefined && value != undefined && name.length>0 && value.length>0) {
		return "&" + prefix + name + "=" + value;
	}
	return "";
}

/**
 * jQuery jsonForForm Plugin 1.0.0
 *
 *	http://www.995120.cn
 *
 * Copyright (c) 2011 hellowin
 *
 */
jQuery.fn.jsonForForm = function (options) {
	var opts = jQuery.extend({}, options);
	var id = this.attr("id");
	var obj;
	if(opts.isobj){
		obj = opts.data;
	}else{
		obj = opts.data.parseObj();
	}
	jQuery.each(obj,function(i,j){
	jQuery("#"+id+" [id='" + i + "']").each(function (m, n) {
		var type = n.type;
		if (type == "text" || type == "hidden" || type == "password" || type == "select-one") {
			if(isnotnull(j))
				jQuery(this).val(j);
		} else if (type == "textarea") {
			if(isnotnull(j))
				jQuery(this).val(j);
		} else if (type == "radio") {
				if(isnotnull(j))
					jQuery("#"+id+" input[id=" + i + "][value=" + j + "]").attr("checked", "checked");
		} else if (type == "checkbox") {
			jQuery("#"+id+" :checkbox[id=" + i + "]").attr("checked", "");
			jQuery("#"+id+" :checkbox[id=" + i + "]").each(function (s, t) {
			for (var v in j) {
				if (this.value == j[v]) {
				jQuery(this).attr("checked", "checked");
				}
			}
			});
		} else if (type == "select-multiple") {
			jQuery("#"+id+" [id=" + i + "] option").attr("selected", "");
			jQuery("#"+id+" [id=" + i + "] option").each(function (s, t) {
				for (var v in j) {
					if (this.value == j[v]) {
						jQuery(this).attr("selected", "selected");
					}
				}
			});
		}
		//span赋值
		if(isnotnull(j)){
			$("#"+id+" span[id="+i+"]").html(j);
			$("#"+id+" label[id="+i+"]").html(j);
			$("#"+id+" div[id="+i+"]").html(j);
		}
		});
	});
}

function isnotnull(value){
	if(value == undefined || value.length==0 || value=='null'){
		 return false
	}
	return true;
}

/**
 * jQuery clearForm Plugin 1.0.0
 *
 *	http://www.995120.cn
 *
 * Copyright (c) 2011 hellowin
 *
 */
jQuery.fn.clearForm = function (options) {
	var settings = {
		cleardiv:false//clear div context
	};
	
	var opts = jQuery.extend(settings, options);
	var id = this.attr("id");
	jQuery('#'+id+' :text').val('');
	
	jQuery('#'+id+' :password').val('');
	
	jQuery('#'+id+' input[type=hidden][type!=button]').val('');
	
	jQuery('#'+id+' :radio').attr("checked", "");
	
	jQuery('#'+id+' textarea').val('');
	
	jQuery('#'+id+' select option:nth-child(1)').attr("selected","selected");
	jQuery('#'+id+' select[multiple] option').attr("selected","");
	
	jQuery('#'+id+' :checkbox').attr("checked", "");
	
	jQuery('#'+id+' :file').attr('src','');
	
	if(opts.cleardiv){
		jQuery('#'+id+' div').html('');
	}
}


/*************公用函数******************/
/**
JS去除字符串前后空格
扩展JS函数
调用格式如 $("#id").val().trim();
*/
String.prototype.trim=function(){ 
	return this.replace(/(^\s*)|(\s*$)/g,"");
}

/**
JS去除字符串左边空格
扩展JS函数
调用格式如 $("#id").val().ltrim();
*/
String.prototype.ltrim=function(){ 
	return this.replace(/(^\s*)/g,""); 
} 

/**
JS去除字符串右边空格
扩展JS函数
调用格式如 $("#id").val().rtrim();
*/
String.prototype.rtrim=function(){ 
	return this.replace(/(\s*$)/g,""); 
}

/**
计算字符串的长度
双字符字符长度为2,ASCII字符为1
$("#id").val().len()
*/
String.prototype.len=function(){
	return this.replace(/[^\x00-\xff]/g,"zz").length; 
}

/**
*把javascript字符串转换为json对象
*/
String.prototype.parseObj=function(){ 
	return(new Function("return"+this))();
}


$(document).ready(function(){
	$(document).bind("contextmenu",function(e){  
		return true;  
	});
	
	$(document).keydown(function(event){
	if ((event.altKey)&&
	((event.keyCode==37)||//屏蔽 Alt+ 方向键 ←   
	(event.keyCode==39))) //屏蔽 Alt+ 方向键 →   
	{
	event.returnValue=false; 
		return false;
   }
    if(event.keyCode==116){
		return false; //屏蔽F5刷新键
    }
	if((event.ctrlKey) && (event.keyCode==82)){
		return false; //屏蔽alt+R
	}
	
    if (event.keyCode == 8) {//屏蔽backspace
        var d = event.srcElement || event.target;
        if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
			event.keyCode = 0;
			event.returnValue = false; 
        }
        else
           return false;
    }
	  
	});
});

function getRootPath(){
	var fullpath=window.document.location.href;
	var pathName=window.document.location.pathname;
	var pos=fullpath.indexOf(pathName);
	var localhostPaht=fullpath.substring(0,pos);
	var projectName=pathName.substring(0,pathName.substr(1).indexOf('/')+1);
	return(localhostPaht+projectName);
}

//全局的ajax访问，处理ajax清求时sesion超时
		$.ajaxSetup({
			contentType:"application/x-www-form-urlencoded;charset=utf-8",  
			complete:function(XMLHttpRequest,textStatus){
				var sessionstatus=XMLHttpRequest.getResponseHeader("sessionstatus");//通过XMLHttpRequest取得响应头，sessionstatu
				if(sessionstatus=="timeout"){
					//如果超时就处理，指定要跳转的页面
					var rootPath = getRootPath();
					window.location.replace(rootPath+'/jsp/common/reload.jsp');
				}   
			}
		});

