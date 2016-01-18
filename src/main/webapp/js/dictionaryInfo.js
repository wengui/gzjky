/**
 * 
 */
function queryDictionaryInfo(viewName){
	var requestUrl = "/gzjky/commonAction/queryDictionaryInfoList.do";
	var para = "viewName=" + viewName;

	//showScreenProtectDiv(1);
    //showLoading();
	xmlHttp = $.ajax({
		url: requestUrl,
		async:true,
		data:para,
		dataType:"json",
		type:"POST",
		complete:function(){
		    //hideScreenProtectDiv(1);
	        //hideLoading();
		},
		error:function(){
			$.alert('无权限');
		},success:function(response){
		    var dictionaryInfo = response.outBeanList;
		    if(dictionaryInfo != null){
		    	init_dictionaryInfo(dictionaryInfo);
		    }else{
		    	if(typeof memberFlag=='undefined'){
		    		//$.alert("没有查到相关数据");
		    	}	    	
		    }
		}
	});
}

function init_dictionaryInfo(dictionaryInfo){
	var parientCode = "";
	for (var i = 0; i < dictionaryInfo.length; i++){
		if(parientCode != "" && parientCode != dictionaryInfo[i].parientCode){
			parientCode = dictionaryInfo[i].parientCode;
			$("#"+parientCode).empty();
		}else if (parientCode == ""){
			parientCode = dictionaryInfo[i].parientCode;
			$("#"+parientCode).empty();
		}
		$("#"+parientCode).append("<option value='"+dictionaryInfo[i].childCode+"'"+">"+dictionaryInfo[i].childName+"</option>");
	}
}