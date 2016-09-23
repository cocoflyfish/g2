<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<%@ taglib prefix="huake" uri="/huake"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<html>
<head>
	<title>留存率</title>
    <!-- 引入 G2 文件 -->
    <script src="${ctx}/static/g2/index.js"></script>
    <link rel="stylesheet" type="text/css" media="screen" href="${ctx}/static/datetimepicker/bootstrap-datetimepicker.min.css">
</head>
<body>
	<div>
		<div class="page-header">
			<h4>
				留存率
			</h4>
		</div>
		<div class="container-fluid">
			<form id="inputForm"  Class="form-horizontal" >
				<div class="control-group">
					<label class="control-label" for="serverId">区服：</label>
					<div class="controls">
						<select id="serverId" name="search_EQ_serverId">	
							<option value="">请选择项目</option>
							<c:forEach items="${servers}" var="item" >
								<option value="${item.serverName}">
									${item.serverName}
								</option>
							</c:forEach>
						</select>
						<span id="error_storeId" class="error" hidden="hidden">项目必须填写</span>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="datetimepickerStart">起始时间：</label>
					<div class="controls">
						<div id="datetimepickerStart" class="input-append date">
							<input type="text" name="search_EQ_dateFrom" value="${param.search_EQ_dateFrom == null ? dateFrom : param.search_EQ_dateFrom }" id="dateFrom"></input> 
							<span class="add-on"> 
								<i data-time-icon="icon-time" data-date-icon="icon-calendar"></i>
							</span>
						</div>
						<span id="error_dateFrom" class="error" hidden="hidden">起始查询时间必须填写</span>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="datetimepickerEnd">结束时间：</label>
					<div class="controls">
						<div id="datetimepickerEnd" class="input-append date">
							<input type="text" name="search_EQ_dateTo" value="${param.search_EQ_dateTo == null ? dateTo : param.search_EQ_dateTo}" id="dateTo"></input>
							<span class="add-on"> 
								<i data-time-icon="icon-time" data-date-icon="icon-calendar"></i>
							</span>
						</div>
						<span id="error_dateTo" class="error" hidden="hidden">结束查询时间必须填写</span>
						<span id="error_dateTo_vs_dateFrom" class="error" hidden="hidden">结束时间不能小于开始时间</span>
					</div>

				</div>
				<div class="control-group">
					<label class="control-label"></label> 
					<div class="controls">
						<a href="#" class="btn btn-success" id="yesterday">昨日</a> 
						<a href="#" class="btn btn-success" id="sevenDayAgo">近7日</a> 
						<a href="#" class="btn btn-success" id="thirtyDayAgo">近30日</a>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label"></label>
					<div class="controls">
						<button class="btn btn-primary" type="submit">
							<i class="fa fa-check"></i>&nbsp;&nbsp;<span class="bold">确定</span>
						</button>
						<a href="<%=request.getContextPath()%>/manage/store/index" class="btn btn-primary">返回</a>
					</div>
				</div>
			</form>
			<div class="row-fluid">
				<div class="row-fluid">
						<div class="tabbable span12">
							<p><code>基本指标</code></p>
							<table class="table table-striped table-bordered table-condensed" id="table">
								<thead>
									<tr>
										<th title="编号" width="120px">编号</th>
										<th title="首次使用时间">首次使用时间</th>
										<th title="新增用户">新增用户</th>
										<th title="1天后">1天后</th>
										<th title="2天后">2天后</th>
										<th title="3天后">3天后</th>
										<th title="4天后">4天后</th>
										<th title="5天后">5天后</th>
										<th title="6天后">6天后</th>
										<th title="7天后">7天后</th>
										<th title="14天后">14天后</th>
										<th title="30天后">30天后</th>
									</tr>
								</thead>
								<tbody id="tbody">
									<tr id="">
										<td id="iDictionary">
											<div class="btn-group">
												<a class="btn" href="#">#1</a> 
												<a class="btn dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
												<ul class="dropdown-menu">
													<li class="divider"></li>
													<li><a href="#">sample</a></li>
												</ul>
											</div>
										</td>
										<td>2016-09-17</td>
										<td>6666</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
									</tr>
																		<tr id="">
										<td id="iDictionary">
											<div class="btn-group">
												<a class="btn" href="#">#2</a> 
												<a class="btn dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
												<ul class="dropdown-menu">
													<li class="divider"></li>
													<li><a href="#">sample</a></li>
												</ul>
											</div>
										</td>
										<td>2016-09-17</td>
										<td>6666</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td></td>
									</tr>
																		<tr id="">
										<td id="iDictionary">
											<div class="btn-group">
												<a class="btn" href="#">#3</a> 
												<a class="btn dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
												<ul class="dropdown-menu">
													<li class="divider"></li>
													<li><a href="#">sample</a></li>
												</ul>
											</div>
										</td>
										<td>2016-09-17</td>
										<td>6666</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td></td>
										<td></td>
									</tr>
																		<tr id="">
										<td id="iDictionary">
											<div class="btn-group">
												<a class="btn" href="#">#4</a> 
												<a class="btn dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
												<ul class="dropdown-menu">
													<li class="divider"></li>
													<li><a href="#">sample</a></li>
												</ul>
											</div>
										</td>
										<td>2016-09-17</td>
										<td>6666</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
																		<tr id="">
										<td id="iDictionary">
											<div class="btn-group">
												<a class="btn" href="#">#5</a> 
												<a class="btn dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
												<ul class="dropdown-menu">
													<li class="divider"></li>
													<li><a href="#">sample</a></li>
												</ul>
											</div>
										</td>
										<td>2016-09-17</td>
										<td>6666</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td>7.4%</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>	
			</div>
		</div>
	</div>
	<script type="text/javascript" src="${ctx}/static/datetimepicker/bootstrap-datetimepicker.min.js"></script>
	<%@ include file="chart.jsp"%>
	<script type="text/javascript">
		$("#storeId").change(function(){
			var storeName = $("#storeId").val();
			$("#storeName").empty();
			if(storeName!=""){
				$("#storeName").text("（"+$("#storeId").val()+"）");
			}else{
				$("#storeName").text("");
			}
		})
	    $("#condition").click(function(){
	    	if($("#condition").text() == "开启筛选条件"){
	    		$("#condition").text("关闭筛选条件");
	    		$("#conditionX").show();
	    	}else{
	    		$("#condition").text("开启筛选条件");
	    		$("#conditionX").hide();
	    		$("input[type='checkbox']").attr("checked", false);
	    	}
	    });
		$('#datetimepickerStart').datetimepicker({
			format : 'yyyy-MM-dd',
			language : 'en',
			pickDate : true,
			pickTime : true,
			hourStep : 1,
			minuteStep : 15,
			secondStep : 30,
			inputMask : true
		});
		$('#datetimepickerEnd').datetimepicker({
			format : 'yyyy-MM-dd',
			language : 'en',
			pickDate : true,
			pickTime : true,
			hourStep : 1,
			minuteStep : 15,
			secondStep : 30,
			inputMask : true
		});

		$(function() {
			$("#inputForm").validate({
				rules:{
					search_EQ_serverId:{
						required:true
					},
					search_EQ_dateFrom:{
						required:true
					},
					search_EQ_dateTo:{
						required:true
					}
				},messages:{
					search_EQ_serverId:{
						required:"查询区服必须填写"
					},
					search_EQ_dateFrom:{
						required:"起始时间必须填写"
					},
					search_EQ_dateTo:{
						required:"结束时间必须填写"
					}
				}
			});
			
			$("#yesterday").click(function() {
				$.ajax({
					url : '<%=request.getContextPath()%>/manage/game/summary/getDate',
					type: 'GET',
					contentType: "application/json;charset=UTF-8",		
					dataType: 'text',
					success: function(data){
						var parsedJson = $.parseJSON(data);
						$("#dateFrom").val(parsedJson.yesterday);
						$("#dateTo").val(parsedJson.nowDate);
					},error:function(xhr){
						window.location.href = window.location.href;
					}//回调看看是否有出错
				});
			});
			$("#sevenDayAgo").click(function(){
				$.ajax({                                               
					url: '<%=request.getContextPath()%>/manage/game/summary/getDate',
					type: 'GET',
					contentType: "application/json;charset=UTF-8",		
					dataType: 'text',
					success: function(data){
						var parsedJson = $.parseJSON(data);
						$("#dateFrom").val(parsedJson.sevenDayAgo);
						$("#dateTo").val(parsedJson.nowDate);
					},error:function(xhr){
						window.location.href = window.location.href;
					}//回调看看是否有出错
				});
			});
			$("#thirtyDayAgo").click(function(){
				$.ajax({                                               
					url: '<%=request.getContextPath()%>/manage/game/summary/getDate',
					type: 'GET',
					contentType: "application/json;charset=UTF-8",		
					dataType: 'text',
					success: function(data){
						var parsedJson = $.parseJSON(data);
						$("#dateFrom").val(parsedJson.thirtyDayAgo);
						$("#dateTo").val(parsedJson.nowDate);
					},error:function(xhr){
						window.location.href = window.location.href;
					}//回调看看是否有出错
				});
			});		
		});
	</script>
</body> 	