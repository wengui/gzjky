function showScreenProtectDiv(type){        
	if (document.compatMode == "BackCompat") {
		   cWidth = document.body.clientWidth;
		   cHeight = document.body.clientHeight;
		   sWidth = document.body.scrollWidth;
		   sHeight = document.body.scrollHeight;
		   sLeft = document.body.scrollLeft;
		   sTop = document.body.scrollTop;
	}else { //document.compatMode == "CSS1Compat"
		   cWidth = document.documentElement.clientWidth;
		   cHeight = document.documentElement.clientHeight;
		   sWidth = document.documentElement.scrollWidth;
		   sHeight = document.documentElement.scrollHeight;
		   sLeft = document.documentElement.scrollLeft == 0 ? document.body.scrollLeft : document.documentElement.scrollLeft;
		   sTop = document.documentElement.scrollTop == 0 ? document.body.scrollTop : document.documentElement.scrollTop;
	}
	var div;
	if(type == 1) div = $("#transparentDiv");
	if(type == 2) div = $("#transparentDiv2");
	div.css("width","100%");
	div.height(document.body.scrollHeight);
	//div.css("height","100%");
	div.show();
}


function hideScreenProtectDiv(type) {
    var div;
    if(type == 1) div = $("#transparentDiv");
	if(type == 2) div = $("#transparentDiv2");
	div.hide();
}


function showLoading() {
   
   $("#divloading").show();
}
   
   
function hideLoading(){  
    
    $("#divloading").hide();
}



function overBaseButton() {
	$("#baseButton").removeClass();
	$("#baseButton").addClass("btn_org");
}
	
function outBaseButton() {
    $("#baseButton").removeClass();
	$("#baseButton").addClass("btn_blue");
}



function convertToFloat(Dight, currentRate, How) { 
        How = 2;
		if(currentRate=="1") return Dight; 
		Dight = Dight/currentRate;
	    Dight =(Dight*Math.pow(10,How)/Math.pow(10,How)).toFixed(How); 
		return Dight;
}
		
    
function setMainMenuClass(index) {
	   
	   for(var i = 1; i < 9; i++) {
	       var tempid = "m" + i;
	       $(tempid).removeClass("visited");
	       $(tempid).addClass("levelout");
	   }
	    
	    $("#m" + index).removeClass("levelout");
	    $("#m" + index).addClass("visited");
}


//not IE is required
function fncKeyStop(evt)
{
    if(!window.event)
    {
        var keycode = evt.keyCode; 
        var key = String.fromCharCode(keycode).toLowerCase();
        if(evt.ctrlKey && key == "v")
        {
          evt.preventDefault(); 
          evt.stopPropagation();
        }
    }
}





Date.prototype.pattern=function(fmt) {     
		    var o = {     
		    "M+" : this.getMonth()+1, //月份     
		    "d+" : this.getDate(), //日     
		    "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时     
		    "H+" : this.getHours(), //小时     
		    "m+" : this.getMinutes(), //分     
		    "s+" : this.getSeconds(), //秒     
		    "q+" : Math.floor((this.getMonth()+3)/3), //季度     
		    "S" : this.getMilliseconds() //毫秒     
		    };     
		    var week = {     
		    "0" : "\u65e5",     
		    "1" : "\u4e00",     
		    "2" : "\u4e8c",     
		    "3" : "\u4e09",     
		    "4" : "\u56db",     
		    "5" : "\u4e94",     
		    "6" : "\u516d"    
		    };     
		    if(/(y+)/.test(fmt)){     
		        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));     
		    }     
		    if(/(E+)/.test(fmt)){     
		        fmt=fmt.replace(RegExp.$1, ((RegExp.$1.length>1) ? (RegExp.$1.length>2 ? "\u661f\u671f" : "\u5468") : "")+week[this.getDay()+""]);     
		    }     
		    for(var k in o){     
		        if(new RegExp("("+ k +")").test(fmt)){     
		            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));     
		        }     
		    }     
		    return fmt;     
		}  

		
		
		
       function jsonToString(obj){   
	        var THIS = this;    
	        switch(typeof(obj)){   
	            case 'string':   
	                return '"' + obj.replace(/(["\\])/g, '\\$1') + '"';   
	            case 'array':   
	                return '[' + obj.map(THIS.jsonToString).join(',') + ']';   
	            case 'object':   
	                 if(obj instanceof Array){   
	                    var strArr = [];   
	                    var len = obj.length;   
	                    for(var i=0; i<len; i++){   
	                        strArr.push(THIS.jsonToString(obj[i]));   
	                    }   
	                    return '[' + strArr.join(',') + ']';   
	                }else if(obj==null){   
	                    return 'null';   
	  
	                }else{   
	                    var string = [];   
	                    for (var property in obj) string.push(THIS.jsonToString(property) + ':' + THIS.jsonToString(obj[property]));   
	                    return '{' + string.join(',') + '}';   
	                }   
	            case 'number':   
	                return obj;   
	            case false:   
	                return obj;   
	        }   
	    }		
		
		
//json转换为字符串   
function $toJsonString(obj){   
var isArray = obj instanceof Array;   
var r = [];   
for(var i in obj){   
   var value = obj[i];   
   if(typeof value == 'string'){   
    value = '"' + value + '"';   
   }else if(value != null && typeof value == 'object'){   
    value = $toJsonString(value);   
   }   
   r.push((isArray?'':i+':')+value);   
}   
if(isArray){   
   return '['+r.join(',')+']';   
}else{   
   return '{'+r.join(',')+'}';   
}   
}


function clearTable(table) {
	var tb = document.getElementById(table);
	var rowNum=tb.rows.length;
	for (i = 1; i <rowNum;i++){
		tb.deleteRow(i);
		rowNum=rowNum-1;
		i=i-1;
    }
}










//not IE is required
function fncKeyStop(evt)
{
    if(!window.event)
    {
        var keycode = evt.keyCode; 
        var key = String.fromCharCode(keycode).toLowerCase();
        if(evt.ctrlKey && key == "v")
        {
          evt.preventDefault(); 
          evt.stopPropagation();
        }
    }
}



	function clickIE4(){
		if (event.button==2){
			return true;
		}//end if
	}//end func

	function clickNS4(e){
		if (document.layers||document.getElementById&&!document.all){
			if (e.which==2||e.which==3){
				return true;
			}//end if
		}//end if
	}//end func
	
	function OnDeny(){
		if(event.ctrlKey || event.keyCode==78 && event.ctrlKey || event.altKey || event.altKey && event.keyCode==115){
			return true;
		}//end if
	}
	if (document.layers){
		document.captureEvents(Event.MOUSEDOWN);
		document.onmousedown=clickNS4;
		document.onkeydown=OnDeny();
	}else if (document.all&&!document.getElementById){
		document.onmousedown=clickIE4;
		document.onkeydown=OnDeny();
	}//end if
	document.oncontextmenu=new Function("return true");
	
	
//	document.onkeydown=function()   
//	{  
//	    if ((window.event.keyCode==116) || //屏蔽 F5    
//	        (window.event.keyCode==122) || //屏蔽 F11    
//	        (window.event.shiftKey && window.event.keyCode==121) //shift+F10 
//	           
//	       )   
//	    {   
//	        window.event.keyCode=0;    
//	        window.event.returnValue=false;    
//	    }   
//	    if ((window.event.altKey)&&(window.event.keyCode==115)) { //屏蔽Alt+F4    
//	        window.showModelessDialog("about:blank","","dialogWidth:1px;dialogheight:1px");    
//	        return false;    
//	    }   
//	}  


	
	
	
