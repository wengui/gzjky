	var map;						//定义要载入的地图对象
	var point;						//定义一个中心点坐标
	
	var safe_island_p_lng;			//查询地点返回经度
	var safe_island_p_lat;			//查询地点返回纬度
	var infowindow = new BMap.InfoWindow(); //叠加层外观与提示框
	
	var pointArray=[];				//经纬度数组
	var poly;						//折线
	var markersArray = [];			//标注数组
	var maxTime;					//最大时间

	var locationMarkerArray = [];		//用户们的当前位置标记数组
	
	var bounds_position_safeISland ;
	var myCity = new BMap.LocalCity();
	
	function myFun(result){
	    var cityName = result.name;
	    map.setCenter(cityName);
	    //alert(cityName);
	}
	/**
	*初始化方法
	*/
	function load() {
		var sLat = '30.291000';					//纬度
		var sLng = '120.117500';				//经度
		loadMap(sLat,sLng,14);						//调用装载地图方法
		polyOption();
	}
	/**
	*载入地图
	*lat为地理纬度，lng为地理经度，zoom为地图放大级别,divObj为放地图的div对象,mapType为地图类型
	*/
	function loadMap(lat,lng,zoom) {
		map = new BMap.Map("map_canvas");          	 		// 创建地图实例 
		point = new BMap.Point(lng, lat);  					// 创建点坐标   
		map.centerAndZoom(point, zoom);                 	// 初始化地图，设置中心点坐标和地图级别 
		myCity.get(myFun);
		setMapEvent();
		addMapControl();
	}
	
	//地图事件设置函数：
    function setMapEvent(){
        map.enableDragging();//启用地图拖拽事件，默认启用(可不写)
        map.enableScrollWheelZoom();//启用地图滚轮放大缩小
        map.enableDoubleClickZoom();//启用鼠标双击放大，默认启用(可不写)
        map.enableKeyboard();//启用键盘上下左右键移动地图
    }
    //地图控件添加函数：
    function addMapControl(){
        //向地图中添加缩放控件
		var ctrl_nav = new BMap.NavigationControl({anchor:BMAP_ANCHOR_TOP_LEFT,type:BMAP_NAVIGATION_CONTROL_LARGE});
		map.addControl(ctrl_nav);
	    //向地图中添加缩略图控件
		var ctrl_ove = new BMap.OverviewMapControl({anchor:BMAP_ANCHOR_BOTTOM_RIGHT,isOpen:1});
		map.addControl(ctrl_ove);
	    //向地图中添加比例尺控件
		var ctrl_sca = new BMap.ScaleControl({anchor:BMAP_ANCHOR_BOTTOM_LEFT});
		map.addControl(ctrl_sca);
    }

	//描述折线选项
	function polyOption(){
		//折线选项
		poly = new BMap.Polyline({   
			strokeColor: "#FF0000",      	 //笔触颜色
			strokeOpacity: 1.0,      		//笔触不透明度
			strokeWeight: 3    				//笔触宽度（以像素为单位）
		}); 
	}
	/**
	 * 显示信息窗口
	 */
	function showWindow(marker,cont){
		var opts = {
			width : 300,     // 信息窗口宽度
		    height: 40,     // 信息窗口高度
		    offset:new BMap.Size(0,0),//偏移量
		    enableMessage:false//设置允许信息窗发送短息
		};
		var infoWindow = new BMap.InfoWindow(cont, opts);  // 创建信息窗口对象
		marker.openInfoWindow(infoWindow);  
		marker.addEventListener("click", function(){          
		     this.openInfoWindow(infoWindow);  
//			 this.closeInfoWindow();
		});
	}
	/**
	 * 在地图上添加标注和信息
	 */
	function addMarker_Info(mapCenter,cont){
		//map.clearOverlays();
		BMap.Convertor.translate(mapCenter,0,function(po){
			map.setCenter(po);
			var marker = new BMap.Marker(po);        		// 创建标注   
			map.addOverlay(marker);                     		// 将标注添加到地图中 
			showWindow(marker, cont);//显示信息
		});
		
	}
	 
	 /**
	*以已知地点为圆心，radius为半径画圆形附加层
	*lat为地理纬度，lng为地理经度，radius为圆的半径(单位为米),map为传入的地图
	*/
	function drawCircle(mapCenter,radius) {
		var circleOption = {
			center:point,		//中心地理坐标
			fillColor:"#FF0000",								//圆内填充颜色
			fillOpacity:0.3,			//填充不透明度
			strokeColor:"#FFAA00",		//笔触颜色
			strokeOpacity: 0.8,			//介于 0.0 和 1.0 之间的笔触不透明度
			strokeWeight: 2				//笔触宽度（以像素为单位)
		};
		var circle = new BMap.Circle(mapCenter,radius,circleOption);		
		map.addOverlay(circle); 
		
	}
	/**
	 * 地图上的地址解析标注与安全岛范围的显示
	 * @param address
	 * @param safeIslandRadius
	 */
	function gecoder(address,safeIslandRadius) {
		map.clearOverlays();
		// 创建地址解析器实例   
//		var myGeo = new BMap.Geocoder();
//		myGeo.getPoint(address, function(po){
//			  if (po) {
//			  	map.clearOverlays();
//			    map.centerAndZoom(po, 14);
//			    var safe_island_p_lng =po.lng;
//			    var safe_island_p_lat =po.lat;
//			    var param = para+"&longitude="+safe_island_p_lng+"&latitude="+safe_island_p_lat+
//				"&address="+address+"&radius="+safeIslandRadius;
//				//修改后台数据
//			    addCenter(param); 
//			    //在地图上显示
//				addSafeIslandMarker(po,safeIslandRadius,address);
//	    		point = po;
//			  }
//		});
		var local = new BMap.LocalSearch(map, {
			renderOptions:{map: map},
			pageCapacity:1,
			onInfoHtmlSet:function(poi){
				var safe_island_p_lng = poi.point.lng;
				var safe_island_p_lat = poi.point.lat;
				var re="";
				var addr = poi.address;
				var title=poi.title;
				re=addr;
				if(re.indexOf(title)<0){
					re=re+title;
				}
				if(poi.city!=undefined&&re.indexOf(poi.city)<0){
					re=poi.city+re;
				}
				if(poi.province!=undefined&&re.indexOf(poi.province)<0){
					re=poi.province+re;
				}
				 var param = para+"&longitude="+safe_island_p_lng+"&latitude="+safe_island_p_lat+
					"&address="+address+"&radius="+safeIslandRadius;
				addCenter(param);
				//map.centerAndZoom(poi.point, 14);   
				drawCircle(poi.point,safeIslandRadius);
			},
			onSearchComplete: function(results){  
				if(results.getNumPois()==0) {
					alert("安全岛中心位置无法找到！");
				}	
			}
		});
		local.search(address);	
	}
	/**
	*在地图上画圆
	*lat为地理纬度，lng为地理经度，radius为地图上圆的半径,address为地图的地址位置
	*/
	function safeCircle(lng,lat,radius,address) {
		var mapCenter = new BMap.Point(lng, lat);  
		addSafeIslandMarker(mapCenter,radius,address);
	}
	
	/**
	*增加安全岛事件
	*location为地理坐标点
	*/
	function addSafeIslandMarker(mapCenter,radius,address) {
		map.clearOverlays();
		var marker = new BMap.Marker(mapCenter);        		// 创建标注   
		map.addOverlay(marker);                     		// 将标注添加到地图中 
		map.setCenter(mapCenter);   
		drawCircle(mapCenter,radius);//画圆
		var cont='<div style="margin:0;padding:10px;">安全岛中心地址：'+address+'</div>';//窗口内容
		showWindow(marker, cont);//显示信息
		
	 }
	
	 /**
	 *历史定位位置标记
	 */
	 function mindUsersLocationHistoryMarker(lng,lat,address,datetime) {
	 	var mapCenter = new BMap.Point(lng,lat);
	 	 addPoly(mapCenter,datetime,address);
	 }
	  
	/**
	*定位
	*/
	function addMarker(lng,lat,address) {
		var mapCenter = new BMap.Point(lng, lat);
		var cont='<div style="margin:0;padding:10px;">当前位置:'+address+'</div>';//窗口内容
		addMarker_Info(mapCenter,cont);
	}
	function fitSafeBounds(){
		if(bounds_position_safeISland==undefined || bounds_position_safeISland==null) 
			return;
	 	map.fitBounds(bounds_position_safeISland);
	 
	 }
	 //增加两点之间的折线事件
	function addPoly(mapCenter,datetime,address) {
		BMap.Convertor.translate(mapCenter,0,function(location){
		    var marker = new BMap.Marker(location);
		   	var len=pointArray.length;
		   	if(len==0){
		   		pointArray.push(location);
		   	}
		   	var f=true;
		   	for(var j=0;j<len;j++){
		   		var poi=pointArray[j];
		   		if(poi.lng==location.lng&&poi.lat==location.lat){
		   			f=false;
		   			break;
		   		}
		   	}
		   	if(f){
		   		pointArray.push(location);
		   	}
		   	poly.setStrokeColor("#ff0000");
		   	poly.setPath(pointArray);
		   	map.addOverlay(poly);
		    markersArray.push(marker);  
		    map.addOverlay(marker);
		    var cont='<div style="margin:0;padding:5px;">时间：'+datetime+'<br/>定位地址：'+address+'</div>';//窗口内容
		    showWindow(marker, cont);
		});
	 }
	 
	  /**
	*删除所有用户的当前位置标记
	*/
	function delUsersLocationMarker() {
		
		map.clearOverlays();
		locationMarkerArray = [];
	 }
	/**
	*删除用户的折线数组
	*/
	function delLocationPoly() {
		map.clearOverlays();
		pointArray= [];
		markersArray=[];
	 }
	
	/**
	*删除安全岛事件
	*/
	function delSafeIslandMarker() {
		map.clearOverlays();
	 }
	 
	 /**
	*删除当前标记事件
	*/
	function delMarker() {
		map.clearOverlays();
	 }
	 
	 /**
	*通过经纬度读取实际地址
	*/
	 function gecoderAddressLA(type,i,id,member_cluster_id,member_unit_id,member_unit_type,lng,lat,cellular_id,datetime) 
	 {
	 	var geocoder = new BMap.Geocoder();     //用于在地址和 LatLng 之间进行转换的服务 
	 	var latlng = new BMap.Point(lng, lat);
	 	BMap.Convertor.translate(latlng,0,function(poi){
	 		geocoder.getLocation(poi, function(results){
		 		var address = results.address;
				map.setCenter(results.point);
				address = myReplace(address);
				datetime = myReplace(datetime);
				findAddress(type,i, id, lng,lat,cellular_id,address,datetime,member_unit_id,member_cluster_id,member_unit_type);
				
				Pause(this,100);
		 		this.NextStep=function(){  
		 			i++;
		 			hostory_for_method(i);
		 		}; 
		 	});
	 	});
	 }
	 
	 /*
	  *所有用户的当前位置标记
	 */
	 function mindUsersLocationMarker(lng,lat,address,name) {
	 
	 	var mapCenter = new BMap.Point(lng,lat);
	 	var cont='<div style="margin:0;padding:10px;">姓名：'+name+' <br/>当前位置：'+address+'</div>';//窗口内容
	 	addMarker_Info(mapCenter,cont);
	 }
	 
 	/**
	*历史定位
	*/
	function addHistoryMarker(lng,lat,address,datetime) {
		var mapCenter = new BMap.Point(lng,lat);
		var locationMarker = new BMap.Marker(mapCenter);
//	    locationMarker.addEventListener("click", function(){          
//		   this.openInfoWindow(infoWindow);  
//		});
	 	locationMarkerArray.push(locationMarker);
	 }
	 
	 /**
	*删除历史定位位置标记
	*/
	function delUsersLocationHistoryMarker() {
		locationMarkerArray = [];
		map.clearOverlays();
	}
	/**
	 * 标记第i的对象的地图位置信息
	 * @param i
	 * @param address
	 */
	function findPlace(i,address) {
		var datetime = memberLocationList[i].datetime;
		var lng = memberLocationList[i].longitude;
		var lat = memberLocationList[i].latitude;
/**
		var gps_offset_id = memberLocationList[i].gps_offset_id;
		var offsetlng = memberLocationList[i].offsetlng;
		var offsetlat = memberLocationList[i].offsetlat;
	    	
    	if(gps_offset_id!=null &&  gps_offset_id!=0) {
    		lng = lng*1 + offsetlng*1;
    	 	lat = lat*1 + offsetlat*1;
    	}*/
    	map.clearOverlays();
    	var mapCenter = new BMap.Point(lng,lat);
    	var cont="<div style='height:50px;overflow:hidden;text-align:left;'>时间："+datetime.substring(0,19)+"<br/>地址："+address+"</div>";
    	addMarker_Info(mapCenter, cont);
	 }
	 
	 /**
	*历史定位标记
	*/
	function addLocationHistoryMarker(lng,lat,address,name,datetime) {
		var mapCenter = new BMap.Point(lng,lat);
		var marker = new BMap.Marker(mapCenter);
		var cont='<div style="margin:0;padding:10px;">时间：'+datetime.substring(0,19)+' <br/>地点：'+address+'</div>';//窗口内容
	 	showWindow(marker, cont);
	 }
	 
	  /**
	*删除历史报警位置标记
	*/
	function delUsersSOSHistoryMarker() {
		locationMarkerArray = [];
		map.clearOverlays();
	 }
	 
	 /**
	*删除当前报警标记
	*/
	function delSOSMarker() {
	    map.clearOverlays();
	 }
	 
	  /**
	*通过经纬度读取实际地址
	*/
	 function gecoderAddress(type,i,sms_content,SOSAlertID,MemberClusterID,MemberUnitID,MemberUnitType,CustomerName,lng,lat,CellularID,DateTimeAlert) {
	 	var geocoder = new BMap.Geocoder();    //用于在地址和 LatLng 之间进行转换的服务 
	 	var latlng = new BMap.Point(lng, lat);
	 	geocoder.getLocation(latlng, function(results){
			var address = results.address;
			map.setCenter(results.point);
			address = myReplace(address);
			DateTimeAlert = myReplace(DateTimeAlert);
			acceptSOSList(type,i,sms_content,SOSAlertID,MemberClusterID,MemberUnitID,MemberUnitType,CustomerName,lng,lat,CellularID,DateTimeAlert,address);
			
			Pause(this,100);
	 		this.NextStep=function(){  
	 			i++;
	 			hostory_for_method(i);
	 		};       
	 	});
	 }
	 
	  /**
	 *历史报警位置标记
	 */
	 function mindUsersSOSHistoryMarker(lng,lat,address,name,datetime) {
	 	var mapCenter = new BMap.Point(lng, lat);
	 	var cont='<div style="margin:0;padding:10px;">时间：'+datetime.substring(0,19)+' <br/>报警位置：'+address+'</div>';//窗口内容
	 	addMarker_Info(mapCenter, cont);
	 	var locationMarker = new BMap.Marker(mapCenter);
	 	locationMarkerArray.push(locationMarker);
	 }
	 
	  /**
	 *当前报警用户位置标记
	 */
	 function mindUsersSOSMarker(lng,lat,address,name) {
	 
	 	var mapCenter = new BMap.Point(lng, lat);
	    var locationMarker = new BMap.Marker(mapCenter);
	    var cont='<div style="margin:0;padding:10px;">姓名：'+name+' <br/>报警位置：'+address+'</div>';//窗口内容
	 	addMarker_Info(mapCenter, cont);
	 	locationMarkerArray.push(locationMarker);
	 }
	 
	  /**
	*当前报警定位标记
	*/
	function addSOSMarker(lng,lat,address,name) {
		var mapCenter = new BMap.Point(lng, lat);
		var cont='<div style="margin:0;padding:10px;">姓名：'+name+' <br/>报警位置：'+address+'</div>';//窗口内容
	 	addMarker_Info(mapCenter, cont);
	 }
	 
	 /**
	*历史报警定位标记
	*/
	function addSOSHistoryMarker(lng,lat,address,name,datetime) {
		var mapCenter = new BMap.Point(lng, lat);
		var cont='<div style="margin:0;padding:10px;">报警时间：'+datetime+' <br/>报警位置：'+address+'</div>';//窗口内容
	 	addMarker_Info(mapCenter, cont);
	 }