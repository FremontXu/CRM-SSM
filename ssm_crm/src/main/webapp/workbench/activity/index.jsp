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

            // 条件日历组件
            $(".time").datetimepicker({
                minView: "month",		// 设置只显示到月份
                language: 'zh-CN',
                format: 'yyyy-mm-dd', 	// 显示格式
                autoclose: true,		// 选中自动关闭
                todayBtn: true,			// 显示今日按钮
                pickerPosition: "bottom-left"
            });

            //创建活动
            $("#addBtn").click(function () {
                //操作模态窗口 传递参数
                $.ajax({
                    url: "act/userList.do",
                    data: {},
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        //处理数据
                        var html = "<option></option>";
                        $.each(data, function (i, n) {
                            html += "<option value='" + n.id + "'>" + n.name + "</option>";
                        });

                        $("#create-marketActivityOwner").html(html);

                        var id = "${sessionScope.user.id}";
                        $("#create-marketActivityOwner").val(id);   // 默认select标签选中当前用户

                        $("#createActivityModal").modal("show");//显示模态窗

                    }
                });

            });

            //修改
            $("#upBtn").click(function () {
                var $xz = $(":checkbox[name='xz']:checked");
                if($xz.length == 0){
                    alert("请选择要修改的记录");
                } else if($xz.length>1){
                    alert("只能选择一条记录进行修改");
                } else if($xz.length == 1){
                    var id = $xz.val();
                    $.ajax({
                        url:"act/getUserListAndActivity.do",
                        type:"get",
                        data:{
                            "id":id
                        },
                        dataType:"json",
                        success:function(data){
                            /**
                             * data
                             * 	用户列表
                             * 	市场活动对象
                             * 	{"uList":[{用户1},{2},{3}...],"a":{市场活动}}
                             */

                                // 处理所有者下拉框
                            var html = "<option></option>";

                            $.each(data.uList,function(i,n){
                                html += "<option value='"+n.id+"'>"+n.name+"</option>";
                            })
                            $("#edit-owner").html(html);

                            // 处理单条activity
                            $("#edit-id").val(data.a.id);
                            $("#edit-name").val(data.a.name);
                            $("#edit-owner").val(data.a.owner);
                            $("#edit-endDate").val(data.a.endDate);
                            $("#edit-cost").val(data.a.cost);
                            $("#edit-startDate").val(data.a.startDate);
                            $("#edit-description").val(data.a.description);

                            // 所有的值都填写好之后,打开修改操作的模态窗口
                            $("#editActivityModal").modal("show");
                        }
                    })
                }
            });

            //保存活动
            $("#saveBtn").click(function () {
                $.ajax({
                    url: "act/saveAct.do",
                    data: {
                        owner: $.trim($("#create-marketActivityOwner").val()),
                        name: $.trim($("#create-marketActivityName").val()),
                        startDate: $.trim($("#create-startTime").val()),
                        endDate: $.trim($("#create-endTime").val()),
                        cost: $.trim($("#create-cost").val()),
                        description: $.trim($("#create-describe").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.result) {
                            //添加成功
                            pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            //清空内容
                            $("#create-form")[0].reset();
                            //关闭模态窗
                            $("#createActivityModal").modal("hide");
                        } else {
                            alert("添加失败");
                        }

                    }
                });
            });

            //全选
            $("#qx").click(function () {
                $(":checkbox[name='xz']").prop("checked", this.checked);
            });

            /**
             * 动态生成的元素,我们要以on方法的形式来触发事件
             * 语法:
             *        $(需要绑定元素的有效的外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
             */
            $("#activityBody").on("click", $(":checkbox[name='xz']"), function () {
                $("#qx").prop("checked", $(":checkbox[name='xz']").length == $(":checkbox[name='xz']:checked").length);
            });

            //查询
            $("#searchBtn").click(function () {
                /**
                 * 点击查询按钮的时候,我们应该将搜索框中的信息保存起来,保存到隐藏域中
                 */

                $("#hidden-name").val($.trim($("#search-name").val()))
                $("#hidden-owner").val($.trim($("#search-owner").val()))
                $("#hidden-startDate").val($.trim($("#search-startDate").val()))
                $("#hidden-endDate").val($.trim($("#search-endDate").val()))

                pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
            });

            //绑定删除
            $("#delBtn").click(function () {
                delAct();
            });

            //进入时显示
            pageList(1, 2);
        });

        //分页显示
        function pageList(pageNo, pageSize) {

            // 查询前,将隐藏域中保存的信息取出来,重新赋予到搜索框中
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-startDate").val($.trim($("#hidden-startDate").val()));
            $("#search-endDate").val($.trim($("#hidden-endDate").val()));

            // 将全选的复选框的对勾干掉
            $("#qx").prop("checked", false);

            $.ajax({
                url: "act/pageList.do",
                data: {
                    //分页
                    pageNo: pageNo,
                    pageSize: pageSize,
                    //查询条件
                    name: $.trim($("#search-name").val()),
                    owner: $.trim($("#search-owner").val()),
                    startDate: $.trim($("#search-startTime").val()),
                    endDate: $.trim($("#search-endTime").val())
                },
                type: "post",
                dataType: "json",
                success: function (data) {

                    var html = "";
                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value=' + n.id + ' /></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'act/detail.do?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td>' + n.startDate + '</td>';
                        html += '<td>' + n.endDate + '</td>';
                        html += '</tr>';
                    })

                    $("#activityBody").html(html);

                    // 计算总页数
                    var totalPages = data.total % pageSize === 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;
                    // 数据处理完毕后,结合分页查询,对前端展现分页信息
                    $("#activityPage").bs_pagination({
                        currentPage: pageNo, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数
                        visiblePageLinks: 5, // 显示几个卡片

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,
                        homePageText: "首页",
                        endPageText: "尾页",
                        prevPageText: "上一页",
                        nextPageText: "下一页",

                        // 该回调函数是在点击分页组件的时候触发的
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });

                }
            });

        }

        //多选删除
        function delAct() {

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
                        url: "act/delAct.do",
                        type: "post",
                        data: param,
                        dataType: "json",
                        success: function (data) {
                            if (data) {
                                // 删除成功
                                pageList(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                alert("删除失败");
                            }
                        }
                    })
                }
            }
        }

    </script>
</head>
<body>

<input type="hidden" id="hidden-name"/>
<input type="hidden" id="hidden-owner"/>
<input type="hidden" id="hidden-startDate"/>
<input type="hidden" id="hidden-endDate"/>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="create-form">

                    <input type="reset" hidden/>

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">

                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startTime" readonly>
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endTime" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <input type="hidden" id="edit-id" />

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner" id="edit-owner">

                            </select>
                        </div>
                        <label for="edit-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-startTime" readonly>
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="edit-endTime" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="updateBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control" type="text" id="search-startTime"/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control" type="text" id="search-endTime">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="addBtn" data-toggle="modal"
                        data-target="#createActivityModal">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="upBtn" data-toggle="modal"
                        data-target="#editActivityModal"><span
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
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityBody">

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">

            <div id="activityPage"></div>

        </div>

    </div>

</div>

</body>
</html>