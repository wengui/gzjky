/**
*扩展验证函数库
*命名注意不重复
*
*/
//身份证验证
jQuery.validator.addMethod("idcade",function(value,element){
	return this.optional(element)||/^(\d{15}|\d{18}|\d{17}(\d|x|X))$/.test(value);
},"请输入一个有效的证件号码.");

//身高
jQuery.validator.addMethod("pyheight",function(value,element){
	//return this.optional(element)||/(^[1-2]?[0-9]{2}(\.\d{1,2})?(cm)?$)/.test(value);
	return this.optional(element)||/(^[1-2]\d{2}$)/.test(value);
},"请输入一个有效的身高.");

//身高
jQuery.validator.addMethod("pyweight",function(value,element){
	//return this.optional(element)||/(^[1-2]?[0-9]{2}(\.\d{1,2})?(cm)?$)/.test(value);
	return this.optional(element)||/(^[1-9]\d{0,2}$)/.test(value);
},"请输入一个有效的体重.");

//民族
jQuery.validator.addMethod("folk",function(value,element){
	return this.optional(element)||/^[\u4E00-\u9FA5]{1,}$/.test(value);
},"请输入一个有效的民族.");

//登陆帐号合法性验证
jQuery.validator.addMethod("account",function(value,element){
	return this.optional(element)||/^\w{3,16}$/.test(value);
},"登陆名不合法.");

//ipv4
jQuery.validator.addMethod("ipv4",function(value,element){
	return this.optional(element)||/^((25[0-5]|2[0-4]\d|[0-1]?\d{1,2})\.){3}(25[0-5]|2[0-4]\d|[0-1]?\d{1,2})$/.test(value);
},"请输入一个有效的IP地址.");

//ipv6
jQuery.validator.addMethod("ipv6",function(value,element){
	return this.optional(element)||/^([\da-fA-F]{1,4}:){6}((25[0-5]|2[0-4]\d|[0-1]?\d{1,2})\.){3}(25[0-5]|2[0-4]\d|[0-1]?\d{1,2})$|^::([\da-fA-F]{1,4}:){0,4}((25[0-5]|2[0-4]\d|[0-1]?\d{1,2})\.){3}(25[0-5]|2[0-4]\d|[0-1]?\d{1,2})$|^([\da-fA-F]{1,4}:):([\da-fA-F]{0,3}:){0,3}((25[0-5]|2[0-4]\d|[0-1]?\d{1,2})\.){3}(25[0-5]|2[0-4]\d|[0-1]?\d{1,2})$|^([\da-fA-F]{1,4}:){2}:([\da-fA-F]{0,3}:){0,2}((25[0-5]|2[0-4]\d|[0-1]?\d{1,2})\.){3}(25[0-5]|2[0-4]\d|[0-1]?\d{1,2})$|^([\da-fA-F]{1,4}:){3}:([\da-fA-F]{1,4}:){0,1}((25[0-5]|2[0-4]\d|[0-1]?\d{1,2})\.){3}(25[0-5]|2[0-4]\d|[0-1]?\d{1,2})$|^([\da-fA-F]{1,4}:){4}:((25[0-5]|2[0-4]\d|[0-1]?\d{1,2})\.){3}(25[0-5]|2[0-4]\d|[0-1]?\d{1,2})$|^([\da-fA-F]{1,4}:){7}([\da-fA-F]{1,4})$|^::([\da-fA-F]{1,4}:){3}[\da-fA-F]{1,4}$|^:((:[\da-fA-F]{1,4}){1,6}|:)$|^[\da-fA-F]{1,4}:((:[\da-fA-F]{1,4}){1,5}|:)$|^([\da-fA-F]{1,4}:){2}(([\da-fA-F]{1,4}){1,4}|:)$|^([\da-fA-F]{1,4}:){3}((:[\da-fA-F]{1,4}){1,3}|:)$|^([\da-fA-F]{1,4}:){4}((:[\da-fA-F]{1,4}){1,2}|:)$|^([\da-fA-F]{1,4}:){5}:([\da-fA-F]{1,4})?$|^([\da-fA-F]{1,4}:){6}:$/.test(value);
},"请输入一个有效的IP地址.");

//金额
jQuery.validator.addMethod("money",function(value,element){
	return this.optional(element)||/^\d+(\.\d{1,2})?$/.test(value);
},"请输入一个有效的金额.");

//国内电话,手机
jQuery.validator.addMethod("phone",function(value,element){
	return this.optional(element)||/^1[3458]\d{9}$|^((0\d{2,3})-)?(\d{7,8})(-(\d{1,4}))?$/.test(value);
},"请输入一个有效的电话/手机号码.");

//国内手机
jQuery.validator.addMethod("mobilephone",function(value,element){
	return this.optional(element)||/^1[3458]\d{9}$/.test(value);
},"请输入一个有效的手机号码.");

//国内电话
jQuery.validator.addMethod("telephone",function(value,element){
	return this.optional(element)||/^((0\d{2,3})-)?(\d{7,8})(-(\d{1,4}))?$/.test(value);
},"请输入一个有效的电话号码.");

//国际通用电话
jQuery.validator.addMethod("worldtelephone",function(value,element){
	return this.optional(element)||/^((0{2}\d{1,3}-)?(0\d{2,3})-)?(\d{7,8})(-(\d{1,4}))?$/.test(value);
},"请输入一个有效的电话号码.");



//中国邮编
jQuery.validator.addMethod("postcode",function(value,element){
	return this.optional(element)||/^\d{6}$/.test(value);
},"请输入一个有效的邮政编码.");

//限制输入
jQuery.validator.addMethod("chinaornumer",function(value,element){
	return this.optional(element)||/^[\da-zA-Z\u4e00-\u9fa5]+$/.test(value);
},"只输入汉字、字母、数字 .");

//限制输入
jQuery.validator.addMethod("chinaorchar",function(value,element){
	return this.optional(element)||/^[a-zA-Z\u4e00-\u9fa5]+$/.test(value);
},"只能输入汉字、字母.");

//只能输入中文字符
jQuery.validator.addMethod("chinese",function(value,element){
	return this.optional(element)||/^[\u0391-\uFFE5]+$/.test(value);
},"只能输入中文字符.");

jQuery.validator.addMethod("alphanumeric", function(value, element) {
	return this.optional(element) || /^\w+$/.test(value);
}, "只能输入字母，数字与下划线.");

jQuery.validator.addMethod("alphanumeric2", function(value, element) {
	return this.optional(element) || /^[A-Za-z0-9]+$/.test(value);
}, "只能输入字母，数字.");

jQuery.validator.addMethod("nowhitespace", function(value, element) {
	return this.optional(element) || /^\S+$/.test(value);
}, "输入包括非空白字符."); 

//测试方法
jQuery.validator.addMethod("test",function(value,element,v){
	var reg = new RegExp("^\\d{"+v+",}$");
	return this.optional(element)||reg.test(value);
},"最少{0}位数字.");

//判断用户名是否符合规范
jQuery.validator.addMethod("loginid",function(value,element){
	return this.optional(element)|| /^[a-zA-Z]{1}\w{4,29}$/.test(value);
},"输入用户名格式不正确.");

jQuery.validator.addMethod("password",function(value,element){
	return this.optional(element)|| /^[0-9a-zA-Z_]{6,16}$/.test(value);
},"输入密码格式不正确.");

//无符号整数
jQuery.validator.addMethod("unsignedint",function(value,element){
	return this.optional(element)||/^\d+$/.test(value);
},"只能输入数字.");

//输入数字长度范围
jQuery.validator.addMethod("numberrangelength",function(value,element,v){
	var reg = new RegExp("^\\d{"+v[0]+","+v[1]+"}$");
	return this.optional(element)|| (value.replace(/[^\x00-\xff]/g,"zz").length>=v[0] && value.replace(/[^\x00-\xff]/g,"zz").length<=v[1]);
},"请输入{0}到{1}位的数字.");

//QQ账号验证，包括邮箱账号
jQuery.validator.addMethod("qq",function(value,element){
	return this.optional(element)||/^((\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)|([1-9]\d{4,10}))$/.test(value);
},"输入格式不正确.");

//sid
jQuery.validator.addMethod("sid",function(value,element){
	return this.optional(element)||/^[\s\-a-zA-Z_0-9]{1,}$/.test(value);
},"请检查您输入的SID终端号.");


//最少输入字符长度(双字节占2位字段)
jQuery.validator.addMethod("cnminlength",function(value,element,v){
	return this.optional(element)|| value.replace(/[^\x00-\xff]/g,"zz").length>=v;
},"最少输入{0}位长度字符.");

//最多输入字符长度(双字节占2位字段)
jQuery.validator.addMethod("cnmaxlength",function(value,element,v){
	return this.optional(element)|| value.replace(/[^\x00-\xff]/g,"zz").length<=v;
},"最多输入{0}位长度字符.");

//输入字符串范围(双字节占2位字段)
jQuery.validator.addMethod("cnrangelength",function(value,element,v){
	return this.optional(element)|| (value.replace(/[^\x00-\xff]/g,"zz").length>=v[0] && value.replace(/[^\x00-\xff]/g,"zz").length<=v[1]);
},"请输入{0}到{1}个字符.");

//屏蔽特殊符号
jQuery.validator.addMethod("includespecialchar",function(value,element){
	return this.optional(element)||!/[#$%^&!@*]+/.test(value);
},"包括系统禁止使用的特殊符号.");

//菜单编号
jQuery.validator.addMethod("menucode",function(value,element){
	return this.optional(element)||/^(\d{4})*$/.test(value);
},"请输入4位或4的整数倍数字编号.");

//按钮编号
jQuery.validator.addMethod("buttoncode",function(value,element){
	return this.optional(element)||/^\d{4}$/.test(value);
},"请输入4位数字.");

//按钮编号
jQuery.validator.addMethod("domain",function(value,element){
	return this.optional(element)||/^((https?|ftp):\/\/)?(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/.test(value);
},"请输入有效的网址.");


