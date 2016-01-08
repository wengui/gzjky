	var recordTotal=0; 		//记录的总个数
	var pageSizeTotal=0;	//总页数
	var currentPageNum = 0;	//当前页码
	var showPages = 3;		//显示页面个数
	//清空表格
	function clearFaceTable(){
   		var table = document.getElementById("faceTable");
		while (table.rows[1]){
			table.deleteRow(1);
		}
	}
	//清空表格(针对无标题栏的)
	function clearFaceTable1(){
   		var table = document.getElementById("faceTable");
		while (table.rows[0]){
			table.deleteRow(0);
		}
	}
	//验证页面信息
   	function valiatePageInfo() {
		pageSizeTotal = Math.floor((recordTotal/onePageSize));  
		if((currentPageNum*onePageSize) > recordTotal)  currentPageNum =  pageSizeTotal;				
		if(((pageSizeTotal+1)*onePageSize) <= recordTotal)  pageSizeTotal=Math.floor((recordTotal/onePageSize))-1;				
		if((pageSizeTotal*onePageSize) == recordTotal)pageSizeTotal = Math.floor((recordTotal/onePageSize))-1;
		if(pageSizeTotal < 0) pageSizeTotal = 0;
		if(currentPageNum > pageSizeTotal) currentPageNum = pageSizeTotal;
   	}
 	//处理页面选择器等元件
	function thingsOfAfterDraw() {
		$("#showPageArea").html("");
		if(recordTotal==0)return;
		var showMorePageNext;
		var showMorePageLast;
		
        var startShowPage = (Math.floor((currentPageNum+0.5)/showPages))*showPages+1;
        var endShowPage = startShowPage + showPages - 1;
       
        if(pageSizeTotal<endShowPage-1) {
        	endShowPage = pageSizeTotal+1;
        	showMorePageNext = " ";
        }else {
        	showMorePageNext = '<a href="#" onclick="pageShowNext('+endShowPage+')">>></a> ';
        }
        
        if(startShowPage!=1) {
        	showMorePageLast = '<a href="#" onclick="pageShowLast('+startShowPage+')"><<</a> ';
        }else {
        	showMorePageLast = " ";
        }
        $("#showPageArea").append(showMorePageLast+" ");
        for(var i=startShowPage;i<=endShowPage;i++) {
        	var curPageShow;
        	if(i==currentPageNum+1) {
        		curPageShow = i+" ";
        	}else {
        		curPageShow = '<a href="#" onclick="pageGoOn('+i+')">['+i+']</a> ';
        	}
        	$("#showPageArea").append(curPageShow);
        }
        $("#showPageArea").append(showMorePageNext+" 共"+(pageSizeTotal+1)+"页 ");
        
        $("#showPageArea").append('<input type="text" size="3" id="page_number" class="pageInput" maxlength="3" />');
        $("#showPageArea").append('<a href="#" onclick="pageGoto2()"> 跳</a>');
	}
	//选择页码
   function pageGoOn(page){
       if(recordTotal==0)return;
       if(page>=pageSizeTotal+1) page = pageSizeTotal+1;
   	   currentPageNum=page-1;
       query();
   }
	//显示后面的更多页面 
   function pageShowNext(lastPage) {
       if(recordTotal==0)return;
   	   currentPageNum=lastPage;
       query();
   }
   
   //显示前面的更多页面 
   function pageShowLast(lastPage) {
       if(recordTotal==0)return;
   	   currentPageNum=lastPage-2;
       query();
   }
   //页面跳转
	function pageGoto2() {
		var page_number = $("#page_number").val();
		var num=0;
		try{
			num=parseInt(page_number);
			if(num=='NaN'||num=='NaN'||(num+'')=='NaN'||num<1){
				$.alert("页码必须为正整数!");
				document.getElementById("page_number").focus();
				return false;
			}
			if(num>(pageSizeTotal+1)){
				$.alert("页码不能大于总页数!");
				document.getElementById("page_number").focus();
				return false;
			}
			pageGoOn(num);
		}catch(e){
			$.alert("页码必须为正整数!");
			document.getElementById("page_number").focus();
			return false;
		}
	}