    //格式化时间
    Date.prototype.format = function(format){
        var o = {
        "M+" : this.getMonth()+1, //month
        "d+" : this.getDate(),    //day
        "h+" : this.getHours(),   //hour
        "m+" : this.getMinutes(), //minute
        "s+" : this.getSeconds(), //second
        "q+" : Math.floor((this.getMonth()+3)/3),  //quarter
        "S" : this.getMilliseconds() //millisecond
        }
        if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
        (this.getFullYear()+"").substr(4 - RegExp.$1.length));
        for(var k in o)if(new RegExp("("+ k +")").test(format))
        format = format.replace(RegExp.$1,
        RegExp.$1.length==1 ? o[k] :
        ("00"+ o[k]).substr((""+ o[k]).length));
        return format;
    }

    /**
     * 点击后自动查询
     */
    function changeDate(days){
       var today = new Date(); // 获取今天时间
       var begin;
       var endTime;
       
       today.setTime(today.getTime()- days *24*3600*1000);
       begin = today.format('yyyy-MM-dd');
       end =new Date().format('yyyy-MM-dd');
       
       var status =$("#status").val();
       $("#startDate").val(begin + " 00:00:00");
       $("#endDate").val(end + " 23:59:59");
      
       queryStart();
      
    }
    
    