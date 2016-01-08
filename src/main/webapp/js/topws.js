
        var ws = null;

        function setConnected(connected) {
            //document.getElementById('connect').disabled = connected;
            //document.getElementById('disconnect').disabled = !connected;
            //document.getElementById('echo').disabled = !connected;
        }

        var sessionAlias = null;
        var memberLoginId = null;
        function connect(target, alias) {
            
        	$("#pushMsgList").html("<li class='information_push_title'>消息窗口</li>");
        	
            if (target == '') {
                $("#pushMsgList").html("<li class='information_push_title'>Please select server side connection implementation</li>");
                return;
            }
            if ('WebSocket' in window) {
                ws = new WebSocket(target);
            } else if ('MozWebSocket' in window) {
                ws = new MozWebSocket(target);
            } else {
            	$("#pushMsgList").append("<li class='information_push_left'>浏览器版本不兼容</li>");
    			$("#pushMsgList").append("<li class='information_push_right'>浏览器版本过低，建议使用Chrome、Firefox、IE10及以上等浏览器</li>");
                return;
            }
            
            ws.onopen = function () {
                setConnected(true);
                //log('open');
                ws.send(alias);
                
                memberPushMsgArrayId = alias + "_MemberPushMsgArray";
                displayLastMsg();
            };
            ws.onmessage = function (event) {
            	var message = event.data;
            	if(message.indexOf("sessionAlias:") != -1) {
            		sessionAlias = message.replace("sessionAlias:", "");
            		return;
            	}
                log(event.data ,true);
            };
            ws.onclose = function () {
                setConnected(false);
                //log('closed');
            };
        }
        
        function disconnect() {
            if (ws != null) {
                ws.close();
                ws = null;
            }
            setConnected(false);
        }
        
        var pushMsgCount = 0;
        function log(message , flag) {
        	
            var start = message.indexOf("\"");
            var messageJson = null;
            if(start != -1) {
            	var end = message.indexOf("\"", 4);
        		var msgType = message.substring(start + 1, end);
                var messageJson = eval("(" + message + ")");
            } else {
            	$("#pushMsgList").append("<li class='information_push_right'>" + message + "</li>");
            	return;
            }
            
            if(msgType == "BloodPressure") {//血压通知
    			
            	var obj = messageJson.BloodPressure;
    			var shrinkPressure = obj.shrinkPressure;
    			var diastolePressure = obj.diastolePressure; //舒张压
    			var takeTime = obj.takeTime;
    			var heartRate = obj.heartRate;
    			var memberName = obj.memberName;
    			if(heartRate != null && heartRate == "0") heartRate = "--";
    			
    			var description = "收缩压/舒张压：" + shrinkPressure + "/" + diastolePressure + "，";
    			description += "心率：" + heartRate + "，";
    			description += "测压时间：" + takeTime;
    			
    			updatePushMsgWindow("血压通知", description, message);
    			
    		} else if(msgType == "BloodPressureAlert") { //血压告警
    			
    			var obj = messageJson.BloodPressureAlert;
    			var shrinkPressure = obj.shrinkPressure;
    			var diastolePressure = obj.diastolePressure; //舒张压
    			var takeTime = obj.takeTime;
    			var heartRate = obj.heartRate;
    			var memberName = obj.memberName;
    			if(heartRate != null && heartRate == "0") heartRate = "--";
    			
    			var description = "收缩压/舒张压：" + shrinkPressure + "/" + diastolePressure + "，";
    			description += "心率：" + heartRate + "，";
    			description += "测压时间：" + takeTime;
    			
    			updatePushMsgWindow("血压告警", description, message);
    			
    		} else if(msgType == "HeartAlert") { //心率告警
    			
    			var obj = messageJson.HeartAlert;
    			var takeTime = obj.takeTime;
    			var heartRate = obj.heartRate;
    			var memberName = obj.memberName;
    			if(heartRate != null && heartRate == "0") heartRate = "--";
    			
    			var description = "心率：" + heartRate + "，";
    			description += "时间：" + takeTime;
    			
    			updatePushMsgWindow("心率告警", description, message);
    			
    		} else if(msgType == "SosAlert") { //SOS告警
    			
    			var obj = messageJson.SosAlert;
    			
    			var positionType = obj.positionType;
    			var longitude = obj.longitude;
    			var latitude = obj.latitude;
    			var address = obj.address;
    			var takeTime = obj.takeTime;
    			var memberName = obj.memberName;
    			
    			var description = "地址：" + address + "，";
    			description += "时间：" + takeTime;
    			
    			updatePushMsgWindow("SOS告警", description, message);
    			
    		} else if(msgType == "Positioning") { //定位
    			
    			var obj = messageJson.Positioning;
    			
    			var positionType = obj.positionType;
    			var longitude = obj.longitude;
    			var latitude = obj.latitude;
    			var address = obj.address;
    			var takeTime = obj.takeTime;
    			var memberName = obj.memberName;
    			
    			var description = "地址：" + address + "，";
    			description += "时间：" + takeTime;
    			
    			if(positionType == 0) {
    				updatePushMsgWindow("精确定位",  description, message);
    			} else {
    				updatePushMsgWindow("糊糊定位",  description, message);
    			}
    			
    		} else if(msgType == "WEB_BUY_PACKAGE_SUCCESS") { //购买套餐成功
    			
                var obj = messageJson.WEB_BUY_PACKAGE_SUCCESS;
    			
    			var packageName = obj.packageName;
    			var packageType = obj.packageType;
    			var packagePrice = obj.packagePrice;
    			var takeTime = obj.takeTime;
    			var balance = obj.balance;
    			
    			
    			if(packageType == 0) packageType = "次";
    			if(packageType == 1) packageType = "月";
    			if(packageType == 3) packageType = "季";
    			if(packageType == 12) packageType = "年";
    			
    			var description = "套餐名称：" + packageName + "，";
    			description += "套餐价格：" + packagePrice + "元，";
    			description += "套餐类型：" + packageType + "，";
    			description += "购买时间：" + takeTime;
    			
    			updatePushMsgWindow("购买套餐成功", description, message);
    			packageBaseinfo();
    			$("#memberBalanceArea").html(balance);
    			
    		} else if(msgType == "WEB_RECHARGE_SUCCESS") { //充值成功
    			
                var obj = messageJson.WEB_RECHARGE_SUCCESS;
    			var platform_order_id = obj.platform_order_id;
    			var balance = obj.balance;
    			var takeTime = obj.takeTime;
    			
    			var description = "平台订单号：" + platform_order_id + "，";
    			description += "充值金额：" + balance + "元，";
    			description += "充值时间：" + takeTime;
    			
    			updatePushMsgWindow("充值成功", description, message);
    			queryMemberBalance();
    			
    		} else if(msgType == "DoctorAdvice") {
    			
                var obj = messageJson.DoctorAdvice;
    			var takeTime = obj.takeTime;
    			
    			var description = "医生给您发了一份医嘱，";
    			description += "生成时间：" + takeTime;
    			
    			updatePushMsgWindow("医嘱", description, message);
    			
    			parent.mainFrame.queryDoctorAdvice();
    			
    		}  else if(msgType == "WEB_BROADCAST_MSG") { 
    			
                var obj = messageJson.WEB_BROADCAST_MSG;
    			var pushMsg = obj.pushMsg;
    			var takeTime = obj.takeTime;
    			
    			var description = pushMsg + "，";
    			description += "时间：" + takeTime;
    			
    			updatePushMsgWindow("平台广播", description, message);
    			
    		} 
        }
        
        
        var memberPushMsgArrayId = null;
        
        function displayLastMsg() {
        	//localStorage.removeItem(memberPushMsgArrayId);
        	
        	var str = localStorage.getItem(memberPushMsgArrayId);
        	//if(str == null || str == "") return;
            var result = JSON.parse(str);
            $("#pushMsgList").html("<li class='information_push_title'>消息窗口</li>");
            
            var msgSize = 0;
            if(result != null && result.length > 0) {
            	msgSize = result.length;
            	$("#pushMsgList").append("<li class='information_push_left'><a style='color:#0ca7a1; text-decoration: none;' onclick='clearHistoryRecord()' href='javascript:void(0)' title='点击清除所有历史数据'>清除历史数据</a></li>");
    			$("#pushMsgList").append("<li class='information_push_right'>&nbsp;</li>");
    			
    			for(var i = 0; i < result.length; i++) {
                    var msgType = result[i].msgType;
                    var description = result[i].description;
                    
                    $("#pushMsgList").append("<li class='information_push_left'>" + msgType + "</li>");
        			$("#pushMsgList").append("<li class='information_push_right'>" + description + "</li>");
                }
            }
            
            if(msgSize == 0) 
            	$("#pushMsgCount").html("<font>" + msgSize + "</font>");
            else
            	$("#pushMsgCount").html("<font color='#f3711b'>" + msgSize + "</font>");
        }
        
        
        function updatePushMsgWindow(msgType, description, message) {
        	
        	var pushMsgArray = new Array();
        	var str = localStorage.getItem(memberPushMsgArrayId);
        	if(str != null && str != "") {
        		
        		var result = JSON.parse(str);
                
        		for(var i = 0; i < result.length; i++) {
                    
                    var mt = result[i].msgType;
                    var de = result[i].description;
                    
                    var data = new Object;  
        		    data.msgType = mt;  
        		    data.description = de;
        		    
        		    pushMsgArray.push(data);
               }
        	}
        	
    		var data = new Object;  
		    data.msgType = msgType;  
		    data.description = description;
		    
		    if(pushMsgArray.length >= 10) pushMsgArray.shift();
		    pushMsgArray.push(data);
		    
		    
		    var str = JSON.stringify(pushMsgArray);  
		    localStorage.setItem(memberPushMsgArrayId, str);  
        	
		    displayLastMsg();
        }
        
        
        
        function clearHistoryRecord() {
        	
        	localStorage.removeItem(memberPushMsgArrayId);
        	displayLastMsg();
        }
        
        
        
        
        

        