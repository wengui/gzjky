<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<link href="<c:url value='/css/index_tab.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/health_records.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/index_common.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/css/popup.css'/>" rel="stylesheet" type="text/css" />
<link href="<c:url value='/js/validationEngine/skins/validationEngine.jquery.css'/>" rel="stylesheet" type="text/css"/>
<link href="<c:url value='/js/artDialog/skins/default.css'/>" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="<c:url value='//js/ztree/css/zTreeStyle.css'/>" type="text/css"></link>
<script src="<c:url value='/js/jquery/jquery-1.8.2.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/validationEngine/languages/jquery.validationEngine-zh_CN.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/validationEngine/jquery.validationEngine.js'/>" type="text/javascript" charset="utf-8"></script>
<script src="<c:url value='/js/page/validationEngine-additional-methods.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.artDialog.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/artDialog.plugins.min.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/artDialog/jquery.ui.draggable.js'/>" type="text/javascript"></script><!-- 拖动函数，不需要可以去掉 -->
<script src="<c:url value='/js/base.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/My97DatePicker/WdatePicker.js'/>" type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.page.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/common.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/page/jquery.hwin.js'/>"  type="text/javascript"></script>
<script src="<c:url value='/js/ztree/jquery.ztree.all-3.1.min.js'/>" type="text/javascript"></script>
<style type="text/css">
	ul.ztree {margin-top: 10px;border: 1px solid #617775;background: #f0f6e4;width:220px;height:360px;overflow-y:scroll;overflow-x:auto;}
</style>
<script type="text/javascript">

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
</script>

<script type="text/javascript">
	var doctor_unit_id = window.parent.doctor_unit_id;
	var doctor_cluster_id = window.parent.doctor_cluster_id;
	var doctor_unit_type = window.parent.doctor_unit_type;

	


	var memberIllnessHistoryList;
	$.fn.page.settings.pagesize=10;
	
	$(function(){
			queryStart();
	    	jQuery('#addMemberIllnessHistory').validationEngine("attach",
	    			{
	    				promptPosition:"topRight",
	    				maxErrorsPerField:1,
	    				scroll:false,
	    				focusFirstField:false
	    				//binded:false,
	    				//showArrow:false,
	    			}
	    	);
		});

	function queryStart(){
			$("#show_history").attr("style","display");
			$("#add_history").attr("style","display:none");
    		$.fn.page.settings.currentnum=1;
    		query();
    }

	function query(){
		var pointerStart = ($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize;
		if(pointerStart<0) pointerStart = 0;
		
		var requestUrl = "/healthRecordAction/queryMemberIllnessHistoryList.action";
    	var para = "member_unit_id="+window.parent.member_unit_id+"&member_cluster_id="+window.parent.member_cluster_id+"&member_unit_type="+window.parent.member_unit_type
    					+"&pointerStart="+pointerStart+"&pageSize="+$.fn.page.settings.pagesize;
	
  	    showScreenProtectDiv(1);
	    showLoading();
    	xmlHttp = $.ajax({
			url: requestUrl,
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			complete:function(){
			    hideScreenProtectDiv(1);
		        hideLoading();
			},
			error:function(){
				$.alert('无权限');
			},success:function(response){
			    var modelMap = response.modelMap;
			    memberIllnessHistoryList = modelMap.memberIllnessHistoryList;
			    $.fn.page.settings.count=modelMap.recordTotal;
				page($.fn.page.settings.currentnum);
			}
		});
	}
	
	function showData(){
	    clearFaceTable(); 
		for (var i = 0; i < $.fn.page.settings.currentsize; i++){	 
			 addrowtotable(i);
		}
    }
    var diseaseTypeDic = {};
    
    	diseaseTypeDic[1] = "感冒";
    
    	diseaseTypeDic[2] = "慢性支气管炎";
    
    	diseaseTypeDic[3] = "哮喘";
    
    	diseaseTypeDic[4] = "肺气肿";
    
    	diseaseTypeDic[5] = "支气管扩张";
    
    	diseaseTypeDic[6] = "肺炎";
    
    	diseaseTypeDic[7] = "百日咳";
    
    	diseaseTypeDic[8] = "支原体肺炎";
    
    	diseaseTypeDic[9] = "气胸";
    
    	diseaseTypeDic[10] = "疱疹性咽峡炎";
    
    	diseaseTypeDic[11] = "成人呼吸窘迫综合征";
    
    	diseaseTypeDic[12] = "鼾症";
    
    	diseaseTypeDic[13] = "胃病";
    
    	diseaseTypeDic[14] = "慢性胃炎";
    
    	diseaseTypeDic[15] = "胃癌";
    
    	diseaseTypeDic[16] = "便秘";
    
    	diseaseTypeDic[17] = "慢性腹泻";
    
    	diseaseTypeDic[18] = "急性胃炎";
    
    	diseaseTypeDic[19] = "急性腐蚀性胃炎";
    
    	diseaseTypeDic[20] = "胃肠道功能紊乱";
    
    	diseaseTypeDic[21] = "食物中毒";
    
    	diseaseTypeDic[22] = "腹痛";
    
    	diseaseTypeDic[23] = "大肠癌";
    
    	diseaseTypeDic[24] = "消化性溃疡";
    
    	diseaseTypeDic[25] = "癫痫";
    
    	diseaseTypeDic[26] = "头痛";
    
    	diseaseTypeDic[27] = "坐骨神经痛";
    
    	diseaseTypeDic[28] = "神经衰弱";
    
    	diseaseTypeDic[29] = "偏头痛";
    
    	diseaseTypeDic[30] = "糖尿病";
    
    	diseaseTypeDic[31] = "甲亢";
    
    	diseaseTypeDic[32] = "白血病";
    
    	diseaseTypeDic[33] = "地中海贫血";
    
    	diseaseTypeDic[34] = "淋巴瘤";
    
    	diseaseTypeDic[35] = "再生障碍性贫血";
    
    	diseaseTypeDic[36] = "过敏性紫癜";
    
    	diseaseTypeDic[37] = "维生素B12缺乏所致贫";
    
    	diseaseTypeDic[38] = "缺铁性贫血";
    
    	diseaseTypeDic[39] = "贫血";
    
    	diseaseTypeDic[40] = "尿路感染";
    
    	diseaseTypeDic[41] = "慢性肾炎";
    
    	diseaseTypeDic[42] = "肾积水";
    
    	diseaseTypeDic[43] = "尿道炎";
    
    	diseaseTypeDic[44] = "尿毒症";
    
    	diseaseTypeDic[45] = "肾囊肿";
    
    	diseaseTypeDic[46] = "肾结石";
    
    	diseaseTypeDic[47] = "急性肾炎";
    
    	diseaseTypeDic[48] = "肾病综合征";
    
    	diseaseTypeDic[49] = "高血压";
    
    	diseaseTypeDic[50] = "冠心病";
    
    	diseaseTypeDic[51] = "心肌炎";
    
    	diseaseTypeDic[52] = "心肌梗死";
    
    	diseaseTypeDic[53] = "先天性心脏病";
    
    	diseaseTypeDic[54] = "心律失常";
    
    	diseaseTypeDic[55] = "窦性心动过速";
    
    	diseaseTypeDic[56] = "心绞痛";
    
    	diseaseTypeDic[57] = "骨肉瘤";
    
    	diseaseTypeDic[58] = "皮肤癌";
    
    	diseaseTypeDic[59] = "阴茎癌";
    
    	diseaseTypeDic[60] = "膀胱癌";
    
    	diseaseTypeDic[61] = "卵巢癌";
    
    	diseaseTypeDic[62] = "胆管癌";
    
    	diseaseTypeDic[63] = "胰腺癌";
    
    	diseaseTypeDic[64] = "鼻咽癌";
    
    	diseaseTypeDic[65] = "食管癌";
    
    	diseaseTypeDic[66] = "肺癌";
    
    	diseaseTypeDic[67] = "原发性肝癌";
    
    	diseaseTypeDic[68] = "宫外孕";
    
    	diseaseTypeDic[69] = "闭经";
    
    	diseaseTypeDic[70] = "淋球菌感染";
    
    	diseaseTypeDic[71] = "念珠菌性阴道炎";
    
    	diseaseTypeDic[72] = "坐骨疝";
    
    	diseaseTypeDic[73] = "先天性无阴道";
    
    	diseaseTypeDic[74] = "出血性输卵管炎";
    
    	diseaseTypeDic[75] = "卵巢癌";
    
    	diseaseTypeDic[76] = "蛲虫性阴道炎";
    
    	diseaseTypeDic[77] = "子宫下垂";
    
    	diseaseTypeDic[78] = "细菌性阴道炎";
    
    	diseaseTypeDic[79] = "滴虫性阴道炎";
    
    	diseaseTypeDic[80] = "乳腺癌";
    
    	diseaseTypeDic[81] = "乳房结核";
    
    	diseaseTypeDic[82] = "子宫肌瘤";
    
    	diseaseTypeDic[83] = "宫颈癌";
    
    	diseaseTypeDic[84] = "附件炎";
    
    	diseaseTypeDic[85] = "卵泡囊肿";
    
    	diseaseTypeDic[86] = "乳房纤维瘤";
    
    	diseaseTypeDic[87] = "子宫内膜增生";
    
    	diseaseTypeDic[88] = "痛经";
    
    	diseaseTypeDic[89] = "非淋菌性尿道炎";
    
    	diseaseTypeDic[90] = "卵巢囊肿";
    
    	diseaseTypeDic[91] = "输卵管炎";
    
    	diseaseTypeDic[92] = "子宫破裂";
    
    	diseaseTypeDic[93] = "不孕症";
    
    	diseaseTypeDic[94] = "复发性卵巢恶性肿瘤";
    
    	diseaseTypeDic[95] = "卵巢肿瘤";
    
    	diseaseTypeDic[96] = "失血性休克";
    
    	diseaseTypeDic[97] = "过期妊娠";
    
    	diseaseTypeDic[98] = "盆腔炎";
    
    	diseaseTypeDic[99] = "宫颈癌";
    
    	diseaseTypeDic[100] = "卵巢巧克力囊肿破";
    
    	diseaseTypeDic[101] = "输卵管阻塞性不孕";
    
    	diseaseTypeDic[102] = "乳腺增生";
    
    	diseaseTypeDic[103] = "宫颈糜烂";
    
    	diseaseTypeDic[104] = "乳腺囊性增生病";
    
    	diseaseTypeDic[105] = "外阴痛";
    
    	diseaseTypeDic[106] = "产褥感染";
    
    	diseaseTypeDic[107] = "外阴瘙痒";
    
    	diseaseTypeDic[108] = "宫颈息肉";
    
    	diseaseTypeDic[109] = "卵巢破裂";
    
    	diseaseTypeDic[110] = "外阴瘙痒";
    
    	diseaseTypeDic[111] = "性交疼痛";
    
    	diseaseTypeDic[112] = "乳腺炎";
    
    	diseaseTypeDic[113] = "宫外孕";
    
    	diseaseTypeDic[114] = "毛滴虫病";
    
    	diseaseTypeDic[115] = "外阴湿疹";
    
    	diseaseTypeDic[116] = "子宫肌瘤";
    
    	diseaseTypeDic[117] = "宫颈腺癌";
    
    	diseaseTypeDic[118] = "子宫内膜炎";
    
    	diseaseTypeDic[119] = "细菌性阴道炎";
    
    	diseaseTypeDic[120] = "月经不调";
    
    	diseaseTypeDic[121] = "过敏性阴道炎";
    
    	diseaseTypeDic[122] = "霉菌性阴道炎";
    
    	diseaseTypeDic[123] = "月经不调";
    
    	diseaseTypeDic[124] = "崩漏";
    
    	diseaseTypeDic[125] = "宫颈炎";
    
    	diseaseTypeDic[126] = "麦格综合征";
    
    	diseaseTypeDic[127] = "子宫颈平滑肌瘤";
    
    	diseaseTypeDic[128] = "小儿中暑和暑热症";
    
    	diseaseTypeDic[129] = "百日咳";
    
    	diseaseTypeDic[130] = "母乳性黄疸";
    
    	diseaseTypeDic[131] = "小儿发烧";
    
    	diseaseTypeDic[132] = "败血症";
    
    	diseaseTypeDic[133] = "奶癣";
    
    	diseaseTypeDic[134] = "小儿肺炎";
    
    	diseaseTypeDic[135] = "地中海贫血";
    
    	diseaseTypeDic[136] = "尿布疹";
    
    	diseaseTypeDic[137] = "小儿脑瘫";
    
    	diseaseTypeDic[138] = "手足口病";
    
    	diseaseTypeDic[139] = "儿童遗尿症";
    
    	diseaseTypeDic[140] = "婴幼儿腹泻";
    
    	diseaseTypeDic[141] = "疝气";
    
    	diseaseTypeDic[142] = "小儿营养不良";
    
    	diseaseTypeDic[143] = "自闭症";
    
    	diseaseTypeDic[144] = "小儿多动症";
    
    	diseaseTypeDic[145] = "新生儿败血症";
    
    	diseaseTypeDic[146] = "小儿厌食症";
    
    	diseaseTypeDic[147] = "小儿肺炎";
    
    	diseaseTypeDic[148] = "早产儿";
    
    	diseaseTypeDic[149] = "风疹";
    
    	diseaseTypeDic[150] = "小儿肥胖症";
    
    	diseaseTypeDic[151] = "鹅口疮";
    
    	diseaseTypeDic[152] = "麻疹";
    
    	diseaseTypeDic[153] = "小儿发烧";
    
    	diseaseTypeDic[154] = "新生儿缺氧缺血性";
    
    	diseaseTypeDic[155] = "新生儿黄疸";
    
    	diseaseTypeDic[156] = "小儿感冒";
    
    	diseaseTypeDic[157] = "小儿急性支气管炎";
    
    	diseaseTypeDic[158] = "流行性腮腺炎";
    
    	diseaseTypeDic[159] = "小儿哮喘";
    
    	diseaseTypeDic[160] = "白血病";
    
    	diseaseTypeDic[161] = "性早熟";
    
    	diseaseTypeDic[162] = "产后出血";
    
    	diseaseTypeDic[163] = "羊水栓塞";
    
    	diseaseTypeDic[164] = "产后虚脱";
    
    	diseaseTypeDic[165] = "早产";
    
    	diseaseTypeDic[166] = "弓形虫病";
    
    	diseaseTypeDic[167] = "子宫破裂";
    
    	diseaseTypeDic[168] = "流产";
    
    	diseaseTypeDic[169] = "产褥期乳腺炎";
    
    	diseaseTypeDic[170] = "失血性休克";
    
    	diseaseTypeDic[171] = "难产";
    
    	diseaseTypeDic[172] = "胎儿先天畸形";
    
    	diseaseTypeDic[173] = "妊高征";
    
    	diseaseTypeDic[174] = "胎位异常";
    
    	diseaseTypeDic[175] = "破水";
    
    	diseaseTypeDic[176] = "新生儿窒息";
    
    	diseaseTypeDic[177] = "急性化脓性乳腺炎";
    
    	diseaseTypeDic[178] = "羊膜带综合征";
    
    	diseaseTypeDic[179] = "胎盘早剥";
    
    	diseaseTypeDic[180] = "湿疹";
    
    	diseaseTypeDic[181] = "斑秃";
    
    	diseaseTypeDic[182] = "酒渣鼻";
    
    	diseaseTypeDic[183] = "脚气";
    
    	diseaseTypeDic[184] = "白屑风";
    
    	diseaseTypeDic[185] = "麻风病";
    
    	diseaseTypeDic[186] = "荨麻疹";
    
    	diseaseTypeDic[187] = "冻疮";
    
    	diseaseTypeDic[188] = "麻疹";
    
    	diseaseTypeDic[189] = "皮肤过敏";
    
    	diseaseTypeDic[190] = "耳湿疹";
    
    	diseaseTypeDic[191] = "毛囊炎";
    
    	diseaseTypeDic[192] = "阴囊湿疹";
    
    	diseaseTypeDic[193] = "银屑病";
    
    	diseaseTypeDic[194] = "牛痘";
    
    	diseaseTypeDic[195] = "白癜风";
    
    	diseaseTypeDic[196] = "红斑狼疮";
    
    	diseaseTypeDic[197] = "手足癣";
    
    	diseaseTypeDic[198] = "痤疮";
    
    	diseaseTypeDic[199] = "红癣";
    
    	diseaseTypeDic[200] = "狐臭";
    
    	diseaseTypeDic[201] = "带状疱疹";
    
    	diseaseTypeDic[202] = "坏疽性脓皮症";
    
    	diseaseTypeDic[203] = "牛皮癣";
    
    	diseaseTypeDic[204] = "汗疱症";
    
    	diseaseTypeDic[205] = "雀斑";
    
    	diseaseTypeDic[206] = "花柳病";
    
    	diseaseTypeDic[207] = "鸡眼";
    
    	diseaseTypeDic[208] = "脚癣";
    
    	diseaseTypeDic[209] = "白化病";
    
    	diseaseTypeDic[210] = "疥疮";
    
    	diseaseTypeDic[211] = "尖锐湿疣";
    
    	diseaseTypeDic[212] = "艾滋病";
    
    	diseaseTypeDic[213] = "梅毒";
    
    	diseaseTypeDic[214] = "生殖器疱疹";
    
    	diseaseTypeDic[215] = "淋病";
    
    	diseaseTypeDic[216] = "生殖器念珠菌病";
    
    	diseaseTypeDic[217] = "生殖器疱疹";
    
    	diseaseTypeDic[218] = "生殖器念珠菌病";
    
    	diseaseTypeDic[219] = "二期梅毒";
    
    	diseaseTypeDic[220] = "一期梅毒";
    
    	diseaseTypeDic[221] = "潜伏梅毒";
    
    	diseaseTypeDic[222] = "腹股沟肉芽肿";
    
    	diseaseTypeDic[223] = "三期梅毒";
    
    	diseaseTypeDic[224] = "病毒性肝炎";
    
    	diseaseTypeDic[225] = "丙型肝炎病毒感染";
    
    	diseaseTypeDic[226] = "肝结核";
    
    	diseaseTypeDic[227] = "肝瘟";
    
    	diseaseTypeDic[228] = "甲型病毒性肝炎";
    
    	diseaseTypeDic[229] = "肝炎";
    
    	diseaseTypeDic[230] = "网瘾";
    
    	diseaseTypeDic[231] = "癔症";
    
    	diseaseTypeDic[232] = "焦虑症";
    
    	diseaseTypeDic[233] = "抑郁性神经症";
    
    	diseaseTypeDic[234] = "躁狂症";
    
    	diseaseTypeDic[235] = "性冷淡";
    
    	diseaseTypeDic[236] = "性心理障碍";
    
    	diseaseTypeDic[237] = "性障碍";
    
    	diseaseTypeDic[238] = "失眠";
    
    	diseaseTypeDic[239] = "情感障碍";
    
    	diseaseTypeDic[240] = "强迫症";
    
    	diseaseTypeDic[241] = "性变态";
    
    	diseaseTypeDic[242] = "恐怖症";
    
    	diseaseTypeDic[243] = "精神分裂症";
    
    	diseaseTypeDic[244] = "磨牙";
    
    	diseaseTypeDic[245] = "人格障碍";
    
    	diseaseTypeDic[246] = "抑郁症";
    
    	diseaseTypeDic[247] = "疑病症";
    
    	diseaseTypeDic[248] = "自闭症";
    
    	diseaseTypeDic[249] = "偏执性精神障碍";
    
    	diseaseTypeDic[250] = "白内障";
    
    	diseaseTypeDic[251] = "结膜炎";
    
    	diseaseTypeDic[252] = "散光";
    
    	diseaseTypeDic[253] = "并发症白内障";
    
    	diseaseTypeDic[254] = "近视眼";
    
    	diseaseTypeDic[255] = "沙眼";
    
    	diseaseTypeDic[256] = "玻璃体出血";
    
    	diseaseTypeDic[257] = "角膜炎";
    
    	diseaseTypeDic[258] = "色盲";
    
    	diseaseTypeDic[259] = "青光眼";
    
    	diseaseTypeDic[260] = "眶底骨折";
    
    	diseaseTypeDic[261] = "视网膜病变";
    
    	diseaseTypeDic[262] = "反向斜视";
    
    	diseaseTypeDic[263] = "泪腺炎";
    
    	diseaseTypeDic[264] = "视网膜脱落";
    
    	diseaseTypeDic[265] = "干眼";
    
    	diseaseTypeDic[266] = "麦粒肿";
    
    	diseaseTypeDic[267] = "斜视";
    
    	diseaseTypeDic[268] = "巩膜炎";
    
    	diseaseTypeDic[269] = "缺血性视神经病变";
    
    	diseaseTypeDic[270] = "雪盲";
    
    	diseaseTypeDic[271] = "红眼病";
    
    	diseaseTypeDic[272] = "弱视";
    
    	diseaseTypeDic[273] = "眼弓蛔虫病";
    
    	diseaseTypeDic[274] = "干眼症";
    
    	diseaseTypeDic[275] = "球后视神经炎";
    
    	diseaseTypeDic[276] = "角膜炎";
    
    	diseaseTypeDic[277] = "眼眶脓肿";
    
    	diseaseTypeDic[278] = "鼻疖";
    
    	diseaseTypeDic[279] = "过敏性鼻炎";
    
    	diseaseTypeDic[280] = "面肌痉挛";
    
    	diseaseTypeDic[281] = "鼻息肉";
    
    	diseaseTypeDic[282] = "鼓膜外伤";
    
    	diseaseTypeDic[283] = "乳突炎";
    
    	diseaseTypeDic[284] = "鼻前庭炎";
    
    	diseaseTypeDic[285] = "喉癌";
    
    	diseaseTypeDic[286] = "听力障碍";
    
    	diseaseTypeDic[287] = "鼻咽癌";
    
    	diseaseTypeDic[288] = "喉痹";
    
    	diseaseTypeDic[289] = "突发性耳聋";
    
    	diseaseTypeDic[290] = "鼻炎";
    
    	diseaseTypeDic[291] = "喉炎";
    
    	diseaseTypeDic[292] = "嗅觉障碍";
    
    	diseaseTypeDic[293] = "鼻咽炎";
    
    	diseaseTypeDic[294] = "喉阻塞";
    
    	diseaseTypeDic[295] = "咽部异物";
    
    	diseaseTypeDic[296] = "鼻出血";
    
    	diseaseTypeDic[297] = "酒渣鼻";
    
    	diseaseTypeDic[298] = "中耳炎";
    
    	diseaseTypeDic[299] = "鼻骨骨折";
    
    	diseaseTypeDic[300] = "急性鼻咽炎";
    
    	diseaseTypeDic[301] = "扁桃体炎";
    
    	diseaseTypeDic[302] = "枯草热";
    
    	diseaseTypeDic[303] = "耳聋";
    
    	diseaseTypeDic[304] = "慢性鼻炎";
    
    	diseaseTypeDic[305] = "耳疖";
    
    	diseaseTypeDic[306] = "慢性鼻咽炎";
    
    	diseaseTypeDic[307] = "扁平苔癣";
    
    	diseaseTypeDic[308] = "口臭";
    
    	diseaseTypeDic[309] = "唇裂";
    
    	diseaseTypeDic[310] = "口角炎";
    
    	diseaseTypeDic[311] = "垂痈";
    
    	diseaseTypeDic[312] = "口糜";
    
    	diseaseTypeDic[313] = "唇疱疹";
    
    	diseaseTypeDic[314] = "口腔溃疡";
    
    	diseaseTypeDic[315] = "单纯性牙周炎";
    
    	diseaseTypeDic[316] = "流行性腮腺炎";
    
    	diseaseTypeDic[317] = "鹅口疮";
    
    	diseaseTypeDic[318] = "龋齿";
    
    	diseaseTypeDic[319] = "腭裂";
    
    	diseaseTypeDic[320] = "牙痈";
    
    	diseaseTypeDic[321] = "二氧化硫中毒";
    
    	diseaseTypeDic[322] = "牙周炎";
    
    	diseaseTypeDic[323] = "氟牙症";
    
    	diseaseTypeDic[324] = "牙髓病";
    
    	diseaseTypeDic[325] = "根尖周病";
    
    	diseaseTypeDic[326] = "颌骨骨折";
    
    	diseaseTypeDic[327] = "闭合性气胸";
    
    	diseaseTypeDic[328] = "鸡胸";
    
    	diseaseTypeDic[329] = "早搏";
    
    	diseaseTypeDic[330] = "病毒性心肌炎";
    
    	diseaseTypeDic[331] = "急性心包炎";
    
    	diseaseTypeDic[332] = "怔忡";
    
    	diseaseTypeDic[333] = "穿透性心脏外伤";
    
    	diseaseTypeDic[334] = "咳嗽晕厥综合征";
    
    	diseaseTypeDic[335] = "主动脉瘤";
    
    	diseaseTypeDic[336] = "创伤窒息综合征";
    
    	diseaseTypeDic[337] = "淋巴管肌瘤";
    
    	diseaseTypeDic[338] = "原发性心脏肿瘤";
    
    	diseaseTypeDic[339] = "单心房";
    
    	diseaseTypeDic[340] = "慢性肺炎";
    
    	diseaseTypeDic[341] = "胸膜炎";
    
    	diseaseTypeDic[342] = "动脉瘤";
    
    	diseaseTypeDic[343] = "慢性心包炎";
    
    	diseaseTypeDic[344] = "心律失常";
    
    	diseaseTypeDic[345] = "动脉硬化";
    
    	diseaseTypeDic[346] = "慢性心力衰竭";
    
    	diseaseTypeDic[347] = "胸腺癌";
    
    	diseaseTypeDic[348] = "恶性胸腔积液";
    
    	diseaseTypeDic[349] = "脓胸";
    
    	diseaseTypeDic[350] = "心肌炎";
    
    	diseaseTypeDic[351] = "肺癌";
    
    	diseaseTypeDic[352] = "气管梗阻";
    
    	diseaseTypeDic[353] = "心厥";
    
    	diseaseTypeDic[354] = "肺水肿";
    
    	diseaseTypeDic[355] = "失血性休克";
    
    	diseaseTypeDic[356] = "心肌梗塞";
    
    	diseaseTypeDic[357] = "高血压";
    
    	diseaseTypeDic[358] = "支气管发育不全";
    
    	diseaseTypeDic[359] = "膈肌膨出";
    
    	diseaseTypeDic[360] = "胸腔积液";
    
    	diseaseTypeDic[361] = "闭合性脑外伤";
    
    	diseaseTypeDic[362] = "颅内黑色素瘤";
    
    	diseaseTypeDic[363] = "脑血吸虫病";
    
    	diseaseTypeDic[364] = "表皮囊肿";
    
    	diseaseTypeDic[365] = "颅骨结核";
    
    	diseaseTypeDic[366] = "脑膜瘤";
    
    	diseaseTypeDic[367] = "痴呆";
    
    	diseaseTypeDic[368] = "脑出血";
    
    	diseaseTypeDic[369] = "脑蛛网膜炎";
    
    	diseaseTypeDic[370] = "垂体瘤";
    
    	diseaseTypeDic[371] = "脑积水";
    
    	diseaseTypeDic[372] = "丘脑下部损伤";
    
    	diseaseTypeDic[373] = "高颅压性脑积水";
    
    	diseaseTypeDic[374] = "脑痨";
    
    	diseaseTypeDic[375] = "头风病";
    
    	diseaseTypeDic[376] = "高血压脑出血";
    
    	diseaseTypeDic[377] = "脑梗塞";
    
    	diseaseTypeDic[378] = "偏头痛";
    
    	diseaseTypeDic[379] = "弓形体脑病";
    
    	diseaseTypeDic[380] = "脑瘤";
    
    	diseaseTypeDic[381] = "中风";
    
    	diseaseTypeDic[382] = "脊椎结核";
    
    	diseaseTypeDic[383] = "脑膜炎";
    
    	diseaseTypeDic[384] = "颅骨缺损";
    
    	diseaseTypeDic[385] = "脑栓塞";
    
    	diseaseTypeDic[386] = "颅内肿瘤";
    
    	diseaseTypeDic[387] = "脑萎";
    
    	diseaseTypeDic[388] = "颅骨骨髓炎";
    
    	diseaseTypeDic[389] = "脑血栓";
    
    	diseaseTypeDic[390] = "颅咽管瘤";
    
    	diseaseTypeDic[391] = "脑震荡";
    
    	diseaseTypeDic[392] = "包皮龟头炎";
    
    	diseaseTypeDic[393] = "尿瘘";
    
    	diseaseTypeDic[394] = "输尿管炎";
    
    	diseaseTypeDic[395] = "产褥感染";
    
    	diseaseTypeDic[396] = "尿道炎";
    
    	diseaseTypeDic[397] = "肾下垂";
    
    	diseaseTypeDic[398] = "胆石症";
    
    	diseaseTypeDic[399] = "膀胱炎";
    
    	diseaseTypeDic[400] = "输尿管结石";
    
    	diseaseTypeDic[401] = "非肾上腺素增生性";
    
    	diseaseTypeDic[402] = "膀胱瘘";
    
    	diseaseTypeDic[403] = "阴囊癌";
    
    	diseaseTypeDic[404] = "腹股沟疝";
    
    	diseaseTypeDic[405] = "膀胱结石";
    
    	diseaseTypeDic[406] = "遗精";
    
    	diseaseTypeDic[407] = "附睾炎";
    
    	diseaseTypeDic[408] = "前列腺炎";
    
    	diseaseTypeDic[409] = "阴茎结核";
    
    	diseaseTypeDic[410] = "梗阻性肾病";
    
    	diseaseTypeDic[411] = "前列腺增生";
    
    	diseaseTypeDic[412] = "鞘膜积液";
    
    	diseaseTypeDic[413] = "急性膀胱炎";
    
    	diseaseTypeDic[414] = "肾积水";
    
    	diseaseTypeDic[415] = "支原体尿路感染";
    
    	diseaseTypeDic[416] = "精囊结石";
    
    	diseaseTypeDic[417] = "肾结石";
    
    	diseaseTypeDic[418] = "真菌性尿路感染";
    
    	diseaseTypeDic[419] = "急性肾小球肾炎";
    
    	diseaseTypeDic[420] = "肾功能衰减";
    
    	diseaseTypeDic[421] = "肾小球肾炎";
    
    	diseaseTypeDic[422] = "肩周炎";
    
    	diseaseTypeDic[423] = "骨质增生";
    
    	diseaseTypeDic[424] = "关节脱位";
    
    	diseaseTypeDic[425] = "脊椎结核";
    
    	diseaseTypeDic[426] = "坐骨神经痛";
    
    	diseaseTypeDic[427] = "鼻骨骨折";
    
    	diseaseTypeDic[428] = "风湿性关节炎";
    
    	diseaseTypeDic[429] = "踝扭伤";
    
    	diseaseTypeDic[430] = "颈椎病";
    
    	diseaseTypeDic[431] = "坐骨疝";
    
    	diseaseTypeDic[432] = "半椎体畸形";
    
    	diseaseTypeDic[433] = "高弓足";
    
    	diseaseTypeDic[434] = "踝部骨折";
    
    	diseaseTypeDic[435] = "肋骨骨折";
    
    	diseaseTypeDic[436] = "肘关节脱位";
    
    	diseaseTypeDic[437] = "扁平足";
    
    	diseaseTypeDic[438] = "跟骨骨折";
    
    	diseaseTypeDic[439] = "滑囊炎";
    
    	diseaseTypeDic[440] = "类风湿性关节炎";
    
    	diseaseTypeDic[441] = "椎间盘突出症";
    
    	diseaseTypeDic[442] = "髌骨骨折";
    
    	diseaseTypeDic[443] = "复发性风湿病";
    
    	diseaseTypeDic[444] = "褐黄病";
    
    	diseaseTypeDic[445] = "孟氏骨折";
    
    	diseaseTypeDic[446] = "髌腱断裂";
    
    	diseaseTypeDic[447] = "股骨头坏死";
    
    	diseaseTypeDic[448] = "踝关节脱位";
    
    	diseaseTypeDic[449] = "平底足";
    
    	diseaseTypeDic[450] = "布氏杆菌性关节炎";
    
    	diseaseTypeDic[451] = "骨折";
    
    	diseaseTypeDic[452] = "脊柱炎";
    
    	diseaseTypeDic[453] = "软骨发育不全";
    
    	diseaseTypeDic[454] = "变形性骨炎";
    
    	diseaseTypeDic[455] = "网球肘";
    
    	diseaseTypeDic[456] = "腱鞘炎";
    
    	diseaseTypeDic[457] = "鼠标手";
    
    	diseaseTypeDic[458] = "成人骨坏死";
    
    	diseaseTypeDic[459] = "骨髓炎";
    
    	diseaseTypeDic[460] = "筋膜炎";
    
    	diseaseTypeDic[461] = "膝关节脱位";
    
    	diseaseTypeDic[462] = "耻骨炎";
    
    	diseaseTypeDic[463] = "骨膜炎";
    
    	diseaseTypeDic[464] = "腱鞘囊肿";
    
    	diseaseTypeDic[465] = "腰椎间盘突出";
    
    	diseaseTypeDic[466] = "脆弱性骨硬化";
    
    	diseaseTypeDic[467] = "骨关节炎";
    
    	diseaseTypeDic[468] = "筋痹";
    
    	diseaseTypeDic[469] = "腰肌劳损";
    
    	diseaseTypeDic[470] = "败血症";
    
    	diseaseTypeDic[471] = "鼻疖";
    
    	diseaseTypeDic[472] = "创伤性鼻出血";
    
    	diseaseTypeDic[473] = "断指再植";
    
    	diseaseTypeDic[474] = "电击伤";
    
    	diseaseTypeDic[475] = "喉部创伤";
    
    	diseaseTypeDic[476] = "创伤性休克";
    
    	diseaseTypeDic[477] = "创伤性气胸";
    
    	diseaseTypeDic[478] = "不动杆菌感染";
    
    	diseaseTypeDic[479] = "创伤窒息综合征";
    
    	diseaseTypeDic[480] = "电烧伤";
    
    	diseaseTypeDic[481] = "冻僵";
    
    	diseaseTypeDic[482] = "化学烧伤";
    
    	diseaseTypeDic[483] = "浸渍足";
    
    	diseaseTypeDic[484] = "钠过多";
    
    	diseaseTypeDic[485] = "热烧伤";
    
    	diseaseTypeDic[486] = "烧伤感染";
    
    	diseaseTypeDic[487] = "小儿烧伤";
    
    	diseaseTypeDic[488] = "咽部灼伤";
    
    	diseaseTypeDic[489] = "烧伤休克";
    
    	diseaseTypeDic[490] = "鼻血管瘤";
    
    	diseaseTypeDic[491] = "肺血管炎";
    
    	diseaseTypeDic[492] = "管炎肠系膜动脉瘤";
    
    	diseaseTypeDic[493] = "肺动静脉瘤";
    
    	diseaseTypeDic[494] = "腹主动脉瘤";
    
    	diseaseTypeDic[495] = "腹壁血栓性静脉炎";
    
    	diseaseTypeDic[496] = "肠系膜动脉瘤";
    
    function addrowtotable(i){
    	try{
    		var begin_date=memberIllnessHistoryList[i].begin_date;
    		var end_date=memberIllnessHistoryList[i].end_date;
	
		    var table = document.getElementById("faceTable");
		    var rowcount=table.rows.length;
			var tr=table.insertRow(rowcount);
				    
		    td=tr.insertCell(0);
		    td.innerHTML = "&nbsp;&nbsp;&nbsp;" + (($.fn.page.settings.currentnum-1) * $.fn.page.settings.pagesize + (i+1));
		    td.height=25;
		    
		    
		    td=tr.insertCell(1);
		    td.innerHTML =  diseaseTypeDic[memberIllnessHistoryList[i].disease_id];
		  
		    
	        td=tr.insertCell(2);
		    td.innerHTML =  begin_date;

		    if(end_date=="0000-00-00"||end_date=="3000-01-01"){
				end_date="";
			}
		    td=tr.insertCell(3);
		    td.innerHTML =  end_date;
		  
		    
		    td=tr.insertCell(4);
		    td.innerHTML =  "<a href='javascript:void(0)' onclick='showMemberIllness("+i+")'>查看</a>|&nbsp;&nbsp;<a href='javascript:void(0)' onclick='deleteMemberIllnessHistory("+i+")'>删除</a>";
		   
		    
	   } catch(e){	   
	     	alert(e.toString());
	   }
    }
	
	function deleteMemberIllnessHistory(i){
		var id=memberIllnessHistoryList[i].id;
		var requestUrl = "/healthRecordAction/deleteMemberIllnessHistory.action";
    	var para = "id="+id;
		$.confirm('你确定要删除吗？', function () {
  	    showScreenProtectDiv(2);
	    showLoading();
    	xmlHttp = $.ajax({
			url: requestUrl,
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			complete:function(){

			},
			error:function(){
				$.alert('无权限');
			},success:function(response){
			    hideScreenProtectDiv(2);
		        hideLoading();
			    var modelMap = response.modelMap;
			    var status = modelMap.status;
			    if(status==0){
			    	$.alert("删除发生异常！");
			    }
			    if(status==1){
			    	$.fn.page.settings.realcount-=1;
			    	pagemodify("del");
			    	$.alert("删除成功！");
			    	query();
			    }
			}
		});
		},function(){});
	}
	
	function showMemberIllness(i){
			$("#addMemberIllnessHistory").clearForm();
			$("#show_history").attr("style","display:none");
			$("#add_history").attr("style","");
			$("#addMemberIllnessHistory input,textarea").attr("disabled",true);
			$("#search_diseaseBtn").attr("style","display:none");
			$("#save_button").attr("style","display:none");
			
			$("#disease_name").val(diseaseTypeDic[memberIllnessHistoryList[i].disease_id]);
			$("#begin_date").val(memberIllnessHistoryList[i].begin_date);
			var end_date=memberIllnessHistoryList[i].end_date;
			if(end_date=="0000-00-00"||end_date=="3000-01-01"){
				end_date="";
			}
			$("#end_date").val(end_date);
			$("#hospital_record").val(memberIllnessHistoryList[i].hospital_record);
			$("#recover_record").val(memberIllnessHistoryList[i].recover_record);
			$("#comment").val(memberIllnessHistoryList[i].comment);
	}
	
	function addMemberIllnessHistory(i){
		if(!jQuery('#addMemberIllnessHistory').validationEngine('validate')) return false;
	
		var disease_id=$("#disease_id").val();
		var begin_date=$("#begin_date").val();
		var end_date=$("#end_date").val();
		var hospital_record=$("#hospital_record").val();
		var recover_record=$("#recover_record").val();
		var comment=$("#comment").val();
		
		var requestUrl = "/healthRecordAction/addMemberIllnessHistory.action";
    	var para = "member_unit_id="+window.parent.member_unit_id+"&member_cluster_id="+window.parent.member_cluster_id+"&member_unit_type="+window.parent.member_unit_type
    					+ "&operator_unit_id="+doctor_unit_id+"&operator_cluster_id="+doctor_cluster_id+"&operator_unit_type="+doctor_unit_type
    					+ "&disease_id="+disease_id+"&begin_date="+begin_date+"&end_date="+end_date+"&hospital_record="+hospital_record
    					+ "&recover_record="+recover_record+"&comment="+comment ;
    					
  	    showScreenProtectDiv(2);
	    showLoading();
    	xmlHttp = $.ajax({
			url: requestUrl,
			async:true,
			data:para,
			dataType:"json",
			type:"POST",
			complete:function(){

			},
			error:function(){
				$.alert('无权限');
			},success:function(response){
			    hideScreenProtectDiv(2);
		        hideLoading();				
			    var modelMap = response.modelMap;
			    var status = modelMap.status;
			    if(status==0){
			    	$.alert("增加发生异常！");
			    }
			    if(status==1){
			    	$.alert("增加成功！");
			    	$.fn.page.settings.realcount++;
			    	$.fn.page.settings.currentnum = 1;
					//pagemodify("add");
			    	$("#show_history").attr("style","");
					$("#add_history").attr("style","display:none");
			    	query();
			    }
			}
		});
	}
	
	function toAddMemberIllnessHistory(){
		$("#addMemberIllnessHistory").clearForm();
	
		$("#show_history").attr("style","display:none");
		$("#add_history").attr("style","");
		$("#addMemberIllnessHistory input,textarea").attr("disabled",false);
		$("#search_diseaseBtn").attr("style","display");
		$("#save_button").attr("style","display");
	}
	
	function showMemberIllnessHistory(){
		jQuery("#addMemberIllnessHistory").validationEngine("hide");
		$("#show_history").attr("style","");
		$("#add_history").attr("style","display:none");
	}
		
</script>

<SCRIPT type="text/javascript">
		var menu_zTree;
  		var menu_Nodes;
  		var search_menu_zTree;
		var menu_setting = {
			view: {
				dblClickExpand: false
			},
			data: {
				simpleData: {
					enable: true
				}
			},
			callback: {
				beforeClick: menu_beforeClick,
				onClick: menu_onClick
			}
		};
		var search_menu_setting = {
				view: {
					dblClickExpand: false
				},
				data: {
					simpleData: {
						enable: true
					}
				},
				callback: {
					beforeClick: search_menu_beforeClick,
					onClick: search_menu_onClick
				}
			};

		function menu_beforeClick(treeId, treeNode) {
			check = treeNode;
			return check;
		}
		
		function menu_onClick(e, treeId, treeNode) {
			menu_zTree = $.fn.zTree.getZTreeObj("menu_tree");
			nodes = menu_zTree.getSelectedNodes();
			v = "";
			vv = "";
			for (var i=0, l=nodes.length; i<l; i++) {
				v += nodes[i].name + ",";
				vv += nodes[i].id + ",";
			}
			if (v.length > 0 ) v = v.substring(0, v.length-1);
			if (vv.length > 0 ) vv = vv.substring(0, vv.length-1);
			//alert(v);
			//alert(vv);
			$("#areaName").val(v);
			$("#areaId").val(vv);
			hideMenu();
		}

		function showMenu() {
			var cityObj = $("#areaName");
			menu_zTree.cancelSelectedNode();
			
			var cityPosition = $("#areaName").position();
			$("#menuContent").css({left:cityPosition.left + "px", top:cityPosition.top + cityObj.outerHeight() + "px"}).slideDown("fast");
			$("body").bind("mousedown", onBodyDown);
		}
		function hideMenu() {
			$("#menuContent").fadeOut("fast");
			$("body").unbind("mousedown", onBodyDown);
		}
		function onBodyDown(event) {
			if (!(event.target.id == "areaBtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length>0)) {
				hideMenu();
			}
		}
		
		function search_menu_beforeClick(treeId, treeNode) {
			check = treeNode;
			return check;
		}
		
		function search_menu_onClick(e, treeId, treeNode) {
			search_menu_zTree = $.fn.zTree.getZTreeObj("search_menu_tree");
			nodes = search_menu_zTree.getSelectedNodes();
			v = "";
			vv = "";
			for (var i=0, l=nodes.length; i<l; i++) {
				v += nodes[i].name + ",";
				vv += nodes[i].id + ",";
			}
			if (v.length > 0 ) v = v.substring(0, v.length-1);
			if (vv.length > 0 ) vv = vv.substring(0, vv.length-1);
			//alert(v);
			//alert(vv);
			if(vv>0){
				$("#disease_name").val(v);
				$("#disease_id").val(vv);
				search_hideMenu();
			}
		}

		function search_showMenu() {
			var cityObj = $("#disease_name");
			search_menu_zTree.cancelSelectedNode();
			
			var cityPosition = $("#disease_name").position();
			$("#search_menuContent").css({left:cityPosition.left + "px", top:cityPosition.top + cityObj.outerHeight() + "px"}).slideDown("fast");
			$("body").bind("mousedown", search_onBodyDown);
		}
		function search_hideMenu() {
			$("#search_menuContent").fadeOut("fast");
			$("body").unbind("mousedown", search_onBodyDown);
		}
		function search_onBodyDown(event) {
			if (!(event.target.id == "search_diseaseBtn" || event.target.id == "search_menuContent" || $(event.target).parents("#search_menuContent").length>0)) {
				search_hideMenu();
			}
		}
		
		function reloadTree() {
			para='';
  			xmlHttp = $.ajax({
			url:'/healthRecordAction/searchAllOfficeDiseaseByTree.action',
			async:false,
			data:para,
			dataType:"json",
			type:"POST",
			error:function(){
				$.alert('无权限或操作异常');
			},success:function(response){
				var modelMap = response.modelMap;
				var state = modelMap.state;
				if(state=='0'){
					menu_Nodes = modelMap.treeNodes.parseObj();
					$.fn.zTree.init($("#search_menu_tree"), search_menu_setting, menu_Nodes);
					search_menu_zTree = $.fn.zTree.getZTreeObj("search_menu_tree");
					search_menu_zTree.expandAll(true);
				}else if(state=='2'){
					$.alert('未知的错误');
				}
			}
		}); 
		}

		$(function(){
			reloadTree() ;
		});
</SCRIPT>

<body>
<div style="font-size:13px;font-family:微软雅黑;color:#5a5a5a;">
<!--bp_history start-->
<div class="bp_history" id="show_history">
  <div class="search">
    <ul>
      <li class="criteria_search" style="height: 40px;">疾病史</li>
      <li class="btn_search" style="height: 40px;"><a href="javascript:void(0)" onclick="toAddMemberIllnessHistory()">新建疾病史</a></li>           
    </ul>
  </div>
  <div class="index_table">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="bPhistory_table"  id="faceTable">
      <colgroup>
        <col width="10%" />
        <col width="20%" />
        <col width="20%" />
        <col width="20%" />
        <col width="20%" />
      </colgroup>
      <tr>
        <th>序号</th>
        <th>疾病名称</th>
        <th>发生日期</th>
        <th>结束日期</th>
        <th>操作</th>
      </tr>
    </table>
  </div>
  

<script type="text/javascript">
		var reg = /^[1-9]{6,16}/; 
		
		function gotoPage(){
			var num = $.trim($("#gopage").val());
			if(num==''){
				$.alert('请输入页码');
				$("#gopage").focus();
				return false;
			}
			if(!/^\d+$/.test(num)){
				$.alert('页码中包括非数字字符');
				$("#gopage").focus();
				return false;
			}
			if(num == '0') {
			    $.alert('页码不正确');
			    return false;
			}
			if(parseInt(num)>$.fn.page.settings.pagecount)
			{
				$.alert('无效的页码');
				$("#gopage").focus();
				return false;
			}
			pageClick(num);
		}
	</script>

<!-- 
<div id="sjxx">共 <span style="font-weight:bold; color:#000;" id="showcount"></span> 条信息，当前：第 <span style="font-weight:bold;color:#000;" id="showcurrentnum"></span> 页 ，共 <span style="font-weight:bold;color:#000;" id="showpagecount"></span> 页</div>
<div id="fanye" >
<input type="button" value="首页" class="button_fy page-first" />
<input type="button" value="上一页" class="button_fy page-perv" />
<input type="button" value="下一页" class="button_fy page-next" />
<input type="button" value="末页" class="button_fy page-last" style="margin-right:15px;" /> 
 转到<input id="gopage" type="text" style="border:1px solid #bababa; width:30px; height:18px; margin:0 3px;text-align: center;" />
<input type="button" value="跳" class="button_fy" onclick="gotoPage()"/>
</div>
 -->
 
<div class="index_page">
  <ul>
    <li class="page_information">共<span  id="showcount"></span>条信息，当前：第<span  id="showcurrentnum"></span>页，共<span  id="showpagecount"></span>页</li>
    <li class="page_button">
	    <a href="###" class="page-first">首页</a>
	    <a href="###" class="page-perv">上一页</a>
	    <a href="###" class="page-next">下一页</a>
	    <a href="###" class="page-last">末页</a>
    </li>
    <li class="page_select">
    转<select id="gopage" onchange="gotoPage()">
    	</select>页
    </li>
  </ul>
</div>
</div>
<div class="bp_history" id="add_history" style="display:none">
	<div class="index_table">
	<form id="addMemberIllnessHistory"  method="post" style="height: 300px">
		<input type="text"  id="disease_id"  name="disease_id" maxlength=32  style="display:none"/>
	 	
	 	<div class="informationModify_main2" >
          <ul>
          
           <li class="tLeft_informationModify">            
             <ul>
               <li class="tgrey_informationModify">*疾病名称：</li>
               <li class="tblack_informationModify">
               		<div class="family_disease_relation">
               		<input class="inputMin_informationModify text-input validate[required] " type="text"  id="disease_name"  name="disease_name" maxlength=32  readonly="readonly"/>
               		<a id="search_diseaseBtn" href="javascript:void(0)" onclick="search_showMenu(); return false;">选择疾病</a>              		
               		</div>
               </li>
             </ul>
             </li>
             
             <li>
             <ul>
               <li class="tgrey_informationModify">*开始日期：</li>
               <li class="tblack_informationModify">
               		<input type="text"   id="begin_date" name="begin_date" value='' onfocus="var end_date=$dp.$('end_date');WdatePicker({dateFmt:'yyyy-MM-dd',onpicked:function(){end_date.focus();},maxDate:'#F{$dp.$D(\'end_date\') || \'%y-%M-%d\'}' })" class="inputMin_informationModify text-input validate[required,date] "/>
               </li>
             </ul>
             </li>
             
             <li>
             <ul>
               <li class="tgrey_informationModify">结束日期：</li>
               <li class="tblack_informationModify">
               		<input type="text"   id="end_date" name="end_date" value='' onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'begin_date\')}',maxDate:'%y-%M-%d'})" class="inputMin_informationModify text-input validate[date]"/>
               </li>
             </ul>

             </li>
             
             <li>
             <ul>
               <li class="tgrey_informationModify">住院情况：</li>
               <li class="tblack_informationModify">
               		<textarea rows="5" cols="40" name="hospital_record"  id="hospital_record"  class="validate[funcCall[includespecialchar]]" style="border: solid 1px gray"></textarea>
               </li>
             </ul>

             </li>
             
             <li>
             <ul>

               <li class="tgrey_informationModify">转归情况：</li>
               <li class="tblack_informationModify">
               		<textarea rows="5" cols="40" name="recover_record"  id="recover_record" class="validate[funcCall[includespecialchar]]" style="border: solid 1px gray"></textarea>
               </li>
             </ul>

             </li>
             
             <li>
             <ul>

               <li class="tgrey_informationModify">备注：</li>
               <li class="tblack_informationModify">
               		<textarea rows="5" cols="40" name="comment"  id="comment"  class="validate[funcCall[includespecialchar]]" style="border: solid 1px gray"></textarea>
               </li>
             </ul>

             </li>
             
             <li>

             <ul>

             	<!-- <li class="tgrey_informationModify"></li> -->
	 			<li class="btn_search" style="height: 40px;margin-left:50px;"><a href="javascript:void(0)" onclick="addMemberIllnessHistory()" id="save_button">保存</a></li>
	 			<li class="btn_search" style="height: 40px;"><a href="javascript:void(0)" onclick="showMemberIllnessHistory()">返回列表</a></li>
	 		 </ul>
	 		 </li>
            </li>
          </ul>
        </div>
        
        <div id="search_menuContent" class="menuContent" style="display:none; position: absolute;">
			<ul id="search_menu_tree" class="ztree" style="margin-top:1px; width:220px;"></ul>
 		</div>  	
	</form> 
	</div>
	
</div>
	

<div id="divloading">
	<img src="/images/public/blue-loading.gif" />
</div>

<div id="transparentDiv" ></div>

<div id="transparentDiv2"></div> 
</div>
</body>
</html>
