/**
*扩展验证函数库
*命名注意不重复
*
*/
//限制输入
function chinaornumer(field, rules, i, options) {
	if(!/^[\da-zA-Z\u4e00-\u9fa5]+$/.test(field.val())){
		return "只能输入汉字、字母、数字 .";
	}
}

//限制输入数字
function number(field, rules, i, options) {
	if(!/^[\d0-9]+$/.test(field.val())){
		return "只能输入数字 .";
	}
}

//限制输入数字,不能以0开头的
function number2(field, rules, i, options) {
	if(!/^[1-9]\d*$/.test(field.val())){
		return "只能输入数字 .";
	}
}

//国内手机
function mobilephone(field, rules, i, options) {
	if(!/^1[3458]\d{9}$/.test(field.val())){
		return "请输入一个有效的手机号码."
	}
}
//身高
function pyheight(field,rules,i,options){
	if(!/(^[1-2]\d{2}$)/.test(field.val())){
		return "请输入一个有效的身高.";
	}
}
//只能输入中文字符
function chinese(field,rules,i,options){
	if(!/^[\u0391-\uFFE5]+$/.test(field.val())){
		return "只能输入中文字符.";
	}
}
//国内电话
function telephone(field,rules,i,options){
	if(!/^((0\d{2,3})-)?(\d{7,8})(-(\d{1,4}))?$/.test(field.val())){
		return "请输入一个有效的电话号码.";
	}
}
//屏蔽特殊符号
function includespecialchar(field,rules,i,options){
	if(/[#$%^&!@*]+/.test(field.val())){
		return "包括系统禁止使用的特殊符号.";
	}
}
//体重
function pyweight(field,rules,i,options){
	if(!/(^[1-9]\d{0,2}$)/.test(field.val())){
		return "请输入一个有效的体重.";
	}
}
//身份证验证
function idcade(field,rules,i,options){
	if(!/^(\d{15}|\d{18}|\d{17}(\d|x|X))$/.test(field.val())){
		return "请输入一个有效的证件号码.";
	}
}
//
function alphanumeric(field,rules,i,options){
	if(!/^\w+$/.test(field.val())){
		return "只能输入字母，数字与下划线.";
	}
}

function password(field,rules,i,options){
	if(/^(([A-Za-z])+|(\d+)|([^%A-Za-z0-9]+))$/.test(field.val())){
		return "请以字母、数字或符号的组合";
	}else if(/%+/.test(field.val())){
		return "请不要输入字符%";
	}
}

function worldtelephone(field,rules,i,options){
	if(!/^((0{2}\d{1,3}-)?(0\d{2,3})-)?(\d{7,8})(-(\d{1,4}))?$/.test(field.val())){
		return "请输入一个有效的电话号码.";
	}
}

function worldtelephone2(field,rules,i,options){
	if(!/^((00){1}[1-9]{1}[0-9]{1,3}|86|\+86)?1[3458]\d{9}$/.test(field.val())){
		return "请输入一个有效的电话号码.";
	}
}

function filterSpecialSign(field,rules,i,options){
	if(/%+/.test(field.val())){
		return "请不要输入字符%";
	}
}

//国际手机
function Internationalmobilephone(field, rules, i, options) {
	if(!/^((00){1}[1-9]{1}[0-9]{1,3}|86|\+86)?1[3458]\d{9}$/.test(field.val())){
		return "请输入一个有效的手机号码."
	}
}

//小数及整数
function decimalAndInt(field, rules, i, options) {
	if(!/^(0|[1-9]+)\.\d{1,2}$/.test(field.val()) && !/^[1-9]\d*$/.test(field.val())){
		return "请输入正整数或保留两位小数位数的小数.";
	}
}
//小于
function lessthan(field,rules,i,options){
	var  equalsField = rules[i + 2];
	if (parseInt(field.val()) > parseInt($("#" + equalsField).val())){
		return "最高舒张压必须小于最高收缩压";
	}
}

function decimalRange(field,rules,i,options){
	var min = rules[i + 2];
	var max = rules[i+3];
	var field_value = parseFloat(field.val());
	var min_float = parseFloat(min);
	var max_float = parseFloat(max);
	if(field_value < min_float || field_value > max_float){
		return "请输入范围为"+min+"-"+max + "的值";
	}
}
	

