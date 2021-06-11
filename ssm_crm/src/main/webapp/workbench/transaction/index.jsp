<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName()
            + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <meta charset="UTF-8">
    <base href="<%=basePath%>">

    <link href="../../jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="../../jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="../../jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="../../jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="../../jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <link rel="stylesheet" type="text/css" href="../../jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="../../jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="../../jquery/bs_pagination/en.js"></script>

    <script type="text/javascript">

        $(function () {
            // 为全选按钮绑定事件
            $("#qx").click(function () {
                $(":checkbox[name='xz']").prop("checked", this.checked);
            });
            $("#clueBody").on("click", $(":checkbox[name='xz']"), function () {
                $("#qx").prop("checked", $(":checkbox[name='xz']").length == $(":checkbox[name='xz']:checked").length);
            });
            //删除 多选
            $("#delBtn").click(function () {
                // 找到复选框中所有选中的复选框的jquery对象
                var $xz = $(":checkbox[name='xz']:checked");
                if ($xz.length === 0) {
                    alert("请选择需要删除的记录");
                } else {
                    if (confirm("确定删除所选中的记录吗?")) {
                        // 拼接参数
                        var param = "";
                        // 将$xz中的每一个dom对象遍历出来,取其value值
                        for (var i = 0; i < $xz.length; i++) {
                            param += "id=" + $($xz[i]).val();
                            // 如果不是最后一个元素,需要在后面追加一个&符
                            if (i < $xz.length - 1) {
                                param += "&";
                            }
                        }
                        $.ajax({
                            url: "tran/delTran.do",
                            type: "post",
                            data: param,
                            dataType: "json",
                            success: function (data) {
                                if (data) {
                                    // 刷新页面
                                    pageList(1, $("#tranPage").bs_pagination('getOption', 'rowsPerPage'));
                                } else {
                                    alert("删除失败");
                                }
                            }
                        })
                    }
                }

            });
            //搜索
            $("#search-button").click(function () {
                $("hidden-owner").val($.trim($("#search-owner").val()));
                $("hidden-name").val($.trim($("#search-name").val()));
                $("hidden-state").val($.trim($("#search-state").val()));
                $("hidden-customer").val($.trim($("#search-customer").val()));
                $("hidden-stage").val($.trim($("#search-stage").val()));
                $("hidden-type").val($.trim($("#search-type").val()));
                $("hidden-source").val($.trim($("#search-source").val()));
                $("hidden-contact").val($.trim($("#search-contact").val()));

                pageList(1, $("#tranPage").bs_pagination('getOption', 'rowsPerPage'));
            });

            //选中 修改
            $("#editBtn").click(function () {
                var $xz = $(":checkbox[name='xz']:checked");
                if ($xz.length === 0) {
                    alert("请选择要修改的记录");
                } else if ($xz.length > 1) {
                    alert("只能选择一条记录进行修改");
                } else if ($xz.length == 1) {
                    var id = $(":checkbox[name='xz']:checked").val();
                    window.location.href = "tran/edit.do?id=" + id;
                }
            });

            pageList(1, 2);

        });

        function pageList(pageNo, pageSize) {

            // 将全选框的对勾取消
            $("#qx").prop("checked", false);

            // 将隐藏域中的值赋值给查询框,防止更换页数时,查询条件为空
            $("search-owner").val($.trim($("#hidden-owner").val()));
            $("search-name").val($.trim($("#hidden-name").val()));
            $("search-state").val($.trim($("#hidden-state").val()));
            $("search-customer").val($.trim($("#hidden-customer").val()));
            $("search-stage").val($.trim($("#hidden-stage").val()));
            $("search-type").val($.trim($("#hidden-type").val()));
            $("search-source").val($.trim($("#hidden-source").val()));
            $("search-contact").val($.trim($("#hidden-contact").val()));

            $.ajax({
                url: "tran/pageList.do",
                data: {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "owner": $.trim($("#search-owner").val()),
                    "name": $.trim($("#search-name").val()),
                    "state": $.trim($("#search-state").val()),
                    "customerId": $.trim($("#search-customer").val()),
                    "stage": $.trim($("#search-stage").val()),
                    "type": $.trim($("#search-type").val()),
                    "source": $.trim($("#search-source").val()),
                    "contactsId": $.trim($("#search-contact").val())
                },
                dataType: "json",
                type: "get",
                success: function (data) {

                    console.log(data);

                    var html = "";
                    $.each(data.tList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '" /></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'tran/detailTran.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>' + n.customerId + '</td>';
                        html += '<td>' + n.stage + '</td>';
                        html += '<td>' + n.type + '</td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.source + '</td>';
                        html += '<td>' + n.contactsId + '</td>';
                        html += '</tr>';
                    })

                    $("#tranBody").html(html);

                    // 计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

                    // 数据处理完毕后,结合分页查询,对前端展现分页信息
                    $("#tranPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数

                        visiblePageLinks: 3, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        // 该回调函数是在点击分页组件的时候触发的
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });
                }
            })

        }

    </script>
</head>
<body>

<%--隐藏域,存放临时数据的--%>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-state"/>
<input type="hidden" id="hidden-customer"/>
<input type="hidden" id="hidden-stage"/>
<input type="hidden" id="hidden-type"/>
<input type="hidden" id="hidden-source"/>
<input type="hidden" id="hidden-contact"/>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>交易列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text" id="search-customer">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">阶段</div>
                        <select class="form-control" id="search-stage">
                            <option></option>
                            <c:forEach items="${applicationScope.stageList}" var="c">
                                <option value="${c.value}">${c.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">类型</div>
                        <select class="form-control" id="search-type">
                            <option></option>
                            <c:forEach items="${applicationScope.transactionTypeList}" var="c">
                                <option value="${c.value}">${c.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="search-source">
                            <option></option>
                            <c:forEach items="${applicationScope.sourceList}" var="c">
                                <option value="${c.value}">${c.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">联系人名称</div>
                        <input class="form-control" type="text" id="search-contact">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>

        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary"
                        onclick="window.location.href='tran/add.do';"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="delBtn"><span class="glyphicon glyphicon-minus"></span>
                    删除
                </button>
            </div>


        </div>

        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>客户名称</td>
                    <td>阶段</td>
                    <td>类型</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>联系人名称</td>
                </tr>
                </thead>

                <tbody id="tranBody"></tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 60px;">
            <div id="tranPage"></div>
        </div>

    </div>

</div>
</body>
</html>