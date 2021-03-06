<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<html>
<head>
<title>新增游戏</title>
	<style type="text/css">
		.error {
			color: Red;
			margin-left: 10px;
		}
	</style>
</head>
<body>
	<div class="page-header">
		<h4>新增运营大区</h4>
	</div>
	<c:if test="${not empty message}">
		<div id="message" class="alert alert-success">
			<button data-dismiss="alert" class="close">×</button>${message}
		</div>
	</c:if>
	<form id="inputForm" method="post" Class="form-horizontal" action="${ctx}/manage/serverZone/save" enctype="multipart/form-data">
		<div class="control-group">
			<label class="control-label" for="id">运营大区Id：</label>
			<div class="controls">
				<input type="text" name="id" class="input-large " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="serverName">运营大区名称：</label>
			<div class="controls">
				<input type="text" name="serverName" class="input-large " value="" />
			</div>
		</div>
		<div class="form-actions">
			<button type="submit" class="btn btn-primary" id="submit">保存</button>
			<a href="<%=request.getContextPath()%>/manage/serverZone/index" class="btn btn-primary">返回</a>
		</div>
	</form>
	<script type="text/javascript">
		$(function(){
			$("#inputForm").validate({
				rules:{
					id:{
						required:true,
						number:true,
						remote: '<%=request.getContextPath()%>/manage/serverZone/checkId'
					},
					serverName:{
						required:true,
						minlength:1,
						maxlength:12
					}
				},messages:{
					id:{
						required:"必须填写",
						number: "请输入合法的数字",
						remote: "ID已存在"
		
					},
					serverName:{
						required:"必须填写",
						minlength:"游戏名称长度1-12位"
					}
				}
			});
		})
	</script>
</body>