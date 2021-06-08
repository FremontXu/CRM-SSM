<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName()
            + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <base href="<%=basePath%>">
    <link href="../jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="../jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="../jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
</head>
<body>

<%@include file="/common/head.jsp" %>

<!-- 中间 -->
<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">
    <div style="position: relative; top: 30px; width: 60%; height: 100px; left: 20%;">
        <div class="page-header">
            <h3>系统设置</h3>
        </div>
    </div>
    <div style="position: relative; width: 55%; height: 70%; left: 22%;">
        <div style="position: relative; width: 33%; height: 50%;">
            常规
            <br><br>
            <a href="javascript:void(0);">个人设置</a>
        </div>
        <div style="position: relative; width: 33%; height: 50%;">
            安全控制
            <br><br>
            <!--
            <a href="org/index.jsp" style="text-decoration: none; color: red;">组织机构</a>
             -->
            <a href="settings/dept/index.jsp">部门管理</a>
            <br>
            <a href="settings/qx/index.jsp">权限管理</a>
        </div>

        <div style="position: relative; width: 33%; height: 50%; left: 33%; top: -100%">
            定制
            <br><br>
            <a href="javascript:void(0);">模块</a>
            <br>
            <a href="javascript:void(0);">模板</a>
            <br>
            <a href="javascript:void(0);">定制内容复制</a>
        </div>
        <div style="position: relative; width: 33%; height: 50%; left: 33%; top: -100%">
            自动化
            <br><br>
            <a href="javascript:void(0);">工作流自动化</a>
            <br>
            <a href="javascript:void(0);">计划</a>
            <br>
            <a href="javascript:void(0);">Web表单</a>
            <br>
            <a href="javascript:void(0);">分配规则</a>
            <br>
            <a href="javascript:void(0);">服务支持升级规则</a>
        </div>

        <div style="position: relative; width: 34%; height: 50%;  left: 66%; top: -200%">
            扩展及API
            <br><br>
            <a href="javascript:void(0);">API</a>
            <br>
            <a href="javascript:void(0);">其它的</a>
        </div>
        <div style="position: relative; width: 34%; height: 50%; left: 66%; top: -200%">
            数据管理
            <br><br>
            <a href="settings/dictionary/index.jsp">数据字典表</a>
            <br>
            <a href="javascript:void(0);">导入</a>
            <br>
            <a href="javascript:void(0);">导出</a>
            <br>
            <a href="javascript:void(0);">存储</a>
            <br>
            <a href="javascript:void(0);">回收站</a>
            <br>
            <a href="javascript:void(0);">审计日志</a>
        </div>
    </div>
</div>
</body>
</html>