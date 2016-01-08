	var map;						//定义要载入的地图对象
	var point;						//定义一个中心点坐标
	
	var safe_island_p_lng;			//查询地点返回经度
	var safe_island_p_lat;			//查询地点返回纬度
	var infowindow = new BMap.InfoWindow(); //叠加层外观与提示框
	
	var pointArray=[];				//经纬度数组
	var poly;						//折线
	var markersArray = [];			//标注数组

	var locationMarkerArray = [];		//用户们的当前位置标记数组
	
	var bounds_position_safeISland ;
	var name1View_Array=[];
	var islandMarker;
	var circle;
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
			width : 350,     // 信息窗口宽度
		    height: 50,     // 信息窗口高度
		    offset:new BMap.Size(0,0),//偏移量
		    enableMessage:false//设置允许信息窗发送短息
		};
		var infoWindow = new BMap.InfoWindow(cont, opts);  // 创建信息窗口对象
		marker.openInfoWindow(infoWindow);  
		marker.addEventListener("click", function(){          
		   this.openInfoWindow(infoWindow);  
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
		circle = new BMap.Circle(mapCenter,radius,circleOption);		
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
		var myGeo = new BMap.Geocoder();
		try{
			myGeo.getPoint(address, function(po){
				  if (po) {
				    map.centerAndZoom(po, 14);
				    var safe_island_p_lng =po.lng;
				    var safe_island_p_lat =po.lat;
				    var param = para+"&longitude="+safe_island_p_lng+"&latitude="+safe_island_p_lat+
					"&address="+address+"&radius="+safeIslandRadius;
					//修改后台数据
				    doSetCenter(param); 
		    		point = po;
				  }else{
					  $.alert("定位不到该地址，请重新确认输入的地址！");
					  return;
				  }
			});
		}catch(e){
			$.alert("定位不到该地址，请确认输入的地址！");
			return;
		}
		
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
		removeSafeIslandMarker();
		islandMarker = new BMap.Marker(mapCenter);        		// 创建标注   
		map.addOverlay(islandMarker);                     		// 将标注添加到地图中 
		map.setCenter(mapCenter);   
		drawCircle(mapCenter,radius);//画圆
		/*var cont='<div style="margin:0;padding:10px;">安全岛中心地址：'+address+'</div>';//窗口内容
		showWindow(marker, cont);//显示信息*/
		
	 }
	/**
	 * 移除之前的安全岛信息
	 */
	function removeSafeIslandMarker() {
		map.removeOverlay(circle);
		map.removeOverlay(islandMarker);
	}
	 /**
	  *所有用户的当前位置标记
	  */
	 function mindUsersLocationMarker(lng,lat,address,name,serial_id) {
		var mapCenter = new BMap.Point(lng,lat);
//	 	map.setCenter(mapCenter);
	 	BMap.Convertor.translate(mapCenter,0,function(po){
	 		map.setCenter(po);
//	 		alert(po.lng+","+po.lat);
			var marker = new BMap.Marker(po);        		// 创建标注   
			map.addOverlay(marker);                     		// 将标注添加到地图中 
			var text=serial_id;
			var name1View = new NameOverlay(po, name,text);    // 定义一个NameOverlay，显示在指定位置
			map.addOverlay(name1View);
			name1View_Array.push(name1View);
		});
	 }
	 /**
	 *某一用户的历史定位位置标记
	 */
	 function mindUsersLocationHistoryMarker(lng,lat,address,datetime) {
		 //alert(lng+","+lat);
	 	var mapCenter = new BMap.Point(lng,lat);
	 	BMap.Convertor.translate(mapCenter,0,function(po){
	 		addPoly(po,datetime,address);
	 		var name1View = new NameOverlay(po,datetime,address);    // 定义一个NameOverlay，显示在指定位置
			map.addOverlay(name1View);
			name1View_Array.push(name1View);
			hideOverLayOview();
	 	});
	 }
	  
	/**
	*定位
	*/
	function addMarker(lng,lat,address,name,pos_time) {
		var mapCenter = new BMap.Point(lng, lat);
		var cont='<div style="margin:0;padding:10px;">当前位置:'+address+'</div>';//窗口内容
		if(name!=null&&name!=""){
			cont='<div style="margin:0;padding:10px;">姓名：'+name
				+'<br/>当前位置:'+address+'</div>';//窗口内容
		}
		if(pos_time!=null&&pos_time!=""){
			cont='<div style="margin:0;padding:10px;">时间：'+pos_time
			+'<br/>位置:'+address+'</div>';//窗口内容
		}
		addMarker_Info(mapCenter,cont);
	}
	function fitSafeBounds(){
		if(bounds_position_safeISland==undefined || bounds_position_safeISland==null) 
			return;
	 	map.fitBounds(bounds_position_safeISland);
	 
	 }
	 //增加两点之间的折线事件
	function addPoly(location,datetime,address) {

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
	    
	    /*var cont='<div style="margin:0;padding:10px;">时间：'+datetime+',地址:'+address+'</div>';//窗口内容
	    showWindow(marker, cont);*/
	    
	 }
	 
	  /**
	*删除所有用户的当前位置标记
	*/
	function delUsersLocationMarker() {
		map.clearOverlays();
		pointArray= [];
		locationMarkerArray = [];
		name1View_Array=[];
		markersArray=[];
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
	*通过经纬度读取实际地址
	*/
	 function gecoderAddressLA(type,i,id,member_cluster_id,member_unit_id,member_unit_type,lng,lat,cellular_id,datetime,device_sid) 
	 {
	 	var geocoder = new BMap.Geocoder();     //用于在地址和 LatLng 之间进行转换的服务 
	 	var latlng = new BMap.Point(lng, lat);
	 	BMap.Convertor.translate(latlng,0,function(poi){
	 		geocoder.getLocation(poi, function(results){
		 		var address = results.address;
				map.setCenter(results.point);
				address = myReplace(address);
				datetime = myReplace(datetime);
				showaddress(type,i,id,datetime,lng,lat,address,member_cluster_id,member_unit_id,member_unit_type,device_sid);
				
				Pause(this,100);
		 		this.NextStep=function(){  
		 			i++;
		 			hostory_for_method(i);
		 		}; 
		 	});
	 	});
	 }
	 
 	/**
	*历史定位
	*/
	function addHistoryMarker(lng,lat,address,datetime) {
		var mapCenter = new BMap.Point(lng,lat);
		var locationMarker = new BMap.Marker(mapCenter);
	 	locationMarkerArray.push(locationMarker);
	 }
	 
	 /**
	*删除历史定位位置标记
	*/
	function delUsersLocationHistoryMarker() {
		pointArray= [];
		locationMarkerArray = [];
		name1View_Array=[];
		markersArray=[];
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
    	map.clearOverlays();
    	var mapCenter = new BMap.Point(lng,lat);
    	var cont="<div style='height:50px;overflow:hidden;text-align:left;'>时间："+datetime.substring(0,19)+"<br/>地址："+address+"</div>";
    	addMarker_Info(mapCenter, cont);
	 }
	 
	 /**
	*历史定位标记
	*/
	function addLocationHistoryMarker(lng,lat,address,name,datetime) {
//		alert(lng+","+lat);
		var mapCenter = new BMap.Point(lng,lat);
//		var marker = new BMap.Marker(mapCenter);
		var cont='<div style="margin:0;padding:10px;">时间：'+datetime.substring(0,19)+' <br/>地点：'+address+'</div>';//窗口内容
		addMarker_Info(mapCenter, cont);
	 }
	 
	 
	  /**
	*通过经纬度读取实际地址
	*/
	 function gecoderAddress(type,i,sms_content,SOSAlertID,MemberClusterID,MemberUnitID,MemberUnitType,cli_his_device_sid ,cli_his_device_version,CustomerName,lng,lat,CellularID,DateTimeAlert) {
	 	var geocoder = new BMap.Geocoder();    //用于在地址和 LatLng 之间进行转换的服务 
	 	var latlng = new BMap.Point(lng, lat);
	 	geocoder.getLocation(latlng, function(results){
			var address = results.address;
			map.setCenter(results.point);
			address = myReplace(address);
			DateTimeAlert = myReplace(DateTimeAlert);
			acceptSOSList(type,i,sms_content,SOSAlertID,MemberClusterID,MemberUnitID,MemberUnitType,cli_his_device_sid ,cli_his_device_version,CustomerName,lng,lat,CellularID,DateTimeAlert,address);
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
	/**************************给定位图标元素添加旁白********************************/
	NameOverlay.prototype = new BMap.Overlay(); // 扩展OverlayView
	 // NameOverlay定义
	function NameOverlay(point, text, time){
	      this._point = point;
	      this._text = text;
	      this._time= time;
	}
	NameOverlay.prototype.initialize = function(map) {
		this._map = map;
		// 创建一个div，其中包含了当前文字
	    var div = this._div = document.createElement('DIV');
	    div.style.position = "absolute";
	    div.style.zIndex = BMap.Overlay.getZIndex(this._point.lat);
	    div.style.color="blue";
	    div.style.padding = "2px";
	    div.style.lineHeight = "18px";
	    div.style.whiteSpace = "nowrap";
	    div.style.MozUserSelect = "none";
	    div.style.fontSize = "12px";
	    div.style.height="40px";
	    div.style.fontWeight ="bold";
	    
	    var span = this._span = document.createElement("span");
	    var br = this._br = document.createElement("br");
	    var datetime=document.createTextNode(this._time);
	    var text= document.createTextNode(this._text);
	    span.appendChild(text);
	    span.appendChild(br);
	    span.appendChild(datetime);
		div.appendChild(span);
	    map.getPanes().labelPane.appendChild(div);
	    return div;
	};
	NameOverlay.prototype.draw = function() {
		var map = this._map;
	    var pixel = map.pointToOverlayPixel(this._point);
	    this._div.style.left = pixel.x + 10 + "px";
	    this._div.style.top  = pixel.y - 20 + "px";
  	};
  	NameOverlay.prototype.show = function(){
		if(this._div){
			this._div.style.display="";
		}
    };
  	NameOverlay.prototype.hide = function(){
		if(this._div){
			this._div.style.display="none";
		}
    };
/******************轨迹线的隐藏与显示*********************/
	//显示轨迹线
	function showline() {
		map.addOverlay(poly);
	}
	//隐藏轨迹线
	function hideline() {
		map.removeOverlay(poly);
	}
 /******************地址和时间覆盖层的隐藏与显示****************************/
	//显示叠加层
	 function showOverLayOview() {
	 	var l = name1View_Array.length;
		for(var i=0;i<l;i++) {
			var name1View = name1View_Array[i];
			name1View.show();
		}
	 }
	//隐藏叠加层
	 function hideOverLayOview() {
	 	var l = name1View_Array.length;
		for(var i=0;i<l;i++) {
			var name1View = name1View_Array[i];
			name1View.hide();
		}
	 }
	//清除叠加层
	 function clearOverLayOview() {
	 	var l = name1View_Array.length;
		for(var i=0;i<l;i++) {
			var name1View = name1View_Array[i];
			map.removeOverlay(name1View);
		}
		name1View_Array.length = 0;
		name1View_Array = [];
	 }