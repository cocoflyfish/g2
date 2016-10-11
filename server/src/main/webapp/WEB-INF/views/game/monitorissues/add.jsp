<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<html>
<head>
	<title>玩家反馈信息回复</title>
	<style type="text/css">
		.error {
			color: Red;
		}
	</style>
</head>

<body>
	<div class="page-header">
		<h4>玩家反馈信息回复</h4>
	</div>
	<c:if test="${not empty message}">
		<div id="message" class="alert alert-success">
			<button data-dismiss="alert" class="close">×</button>${message}
		</div>
	</c:if>
	<form id="inputForm" method="post" Class="form-horizontal" action="${ctx}/manage/game/monitorIssues/update" enctype="multipart/form-data">
		<input type="hidden" name="userId" value="${issues.userId}">
		<div class="control-group">
			<label class="control-label" for="server">区服：</label>
			<div class="controls">
				<input type="text" name="server" class="input-large "  value="${issues.server}" readonly="readonly"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="name">角色名：</label>
			<div class="controls">
				<input type="text" name="name" class="input-large " value="${issues.name}" readonly="readonly"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="title">邮件标题：</label>
			<div class="controls">
				<input type="text" name="title" class="input-large " />
			</div>
		</div>
		<div class="control-group ">
			<label class="control-label" for="text">公告内容（1000字）：</label>
				<div class="controls">
					<textarea path="text" id="text" name="text" cssClass="input-xlarge" value="" style="height: 100px;width: 400px" /></textarea>
				</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="attachmentID">物品ID：</label>
			<div class="controls">
				<input type="text" name="attachmentID" class="input-large " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="attachmentNum">数量：</label>
			<div class="controls">
				<input type="text" name="attachmentNum" class="input-large " />
			</div>
		</div>
		<div class="form-actions">
			<button type="submit" class="btn btn-primary" id="submit">保存</button>
			<a href="<%=request.getContextPath()%>/manage/game/monitorIssues/index" class="btn btn-primary">返回</a>
		</div>
	</form>
	<script type="text/javascript">
		$(function(){
			$("#inputForm").validate({
				rules:{
					title:{
						required:true
					},
					text:{
						required:true
					}
				},messages:{
					title:{
						required:"邮件标题必须填写"
					},
					text:{
						required:"邮件内容必须填写"
					}
				}
			});
		})
	</script>
</body>