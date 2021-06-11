<%@ page contentType="text/html; charset=UTF-8" autoFlush="false" buffer="300kb" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName()
            + ":" + request.getServerPort() + request.getContextPath() + "/";

%>
<html>
<head>
    <meta charset="UTF-8">
    <base href="<%=basePath%>">

    <link href="../../jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="../../jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="../../jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {

            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $(".remarkDiv").mouseover(function () {
                $(this).children("div").children("div").show();
            });

            $(".remarkDiv").mouseout(function () {
                $(this).children("div").children("div").hide();
            });

            $(".myHref").mouseover(function () {
                $(this).children("span").css("color", "red");
            });

            $(".myHref").mouseout(function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            // 为全选按钮绑定事件
            $("#qx").click(function () {
                $(":checkbox[name='xz']").prop("checked", this.checked);
            });
            $("#activitySearchBody").on("click", $(":checkbox[name='xz']"), function () {
                $("#qx").prop("checked", $(":checkbox[name='xz']").length == $(":checkbox[name='xz']:checked").length);
            });

            // 为关联市场活动模态窗口中的搜索框绑定事件,通过触发回车键,查询并展现所需市场活动列表
            $("#aname").click(function () {
                $.ajax({
                    url: "clue/getActivityNotBund.do",
                    type: "get",
                    dataType: "json",
                    data: {
                        "aname": $.trim($("#aname1").val()),
                        "clueId": "${requestScope.clue.id}"
                    },
                    success: function (data) {
                        var html = "";
                        $.each(data, function (i, n) {
                            html += '<tr>';
                            html += '<td><input type="checkbox" name="xz" value="' + n.id + '" /></td>';
                            html += '<td>' + n.name + '</td>';
                            html += '<td>' + n.startDate + '</td>';
                            html += '<td>' + n.endDate + '</td>';
                            html += '<td>' + n.owner + '</td>';
                            html += '</tr>';
                        });
                        $("#activitySearchBody").html(html);
                    }
                })

            });

            // 为关联按钮绑定事件,执行关联表的添加操作
            $("#bundBtn").click(function () {

                var $xz = $(":checkbox[name='xz']:checked");
                if ($xz.length > 0) {
                    //1条或多条
                    if (confirm("确认关联吗?")) {

                        var param = "cid=${requestScope.clue.id}&";
                        for (var i = 0; i < $xz.length; i++) {
                            param += "aid=" + $($xz[i]).val();
                            if (i < $xz.length - 1) {
                                param += "&";
                            }
                        }
                        $.ajax({
                            url: "clue/bund.do",
                            data: param,
                            dataType: "json",
                            type: "post",
                            success: function (data) {
                                if (data) {
                                    showActivityList();
                                    // 清除搜索框中的信息,复选框中的对勾干掉,清空activitySearchBody中的内容
                                    $("#aname1").val("");
                                    $("#activitySearchBody").html("");
                                    // 关闭模态窗口
                                    $("#bundModal").modal("hide");
                                } else {
                                    alert("关联失败");
                                }
                            }
                        })
                    }
                } else {
                    alert("请选择需要关联的线索");
                }
            });

            // 为保存按钮绑定事件,执行备注添加操作
            $("#saveRemark").click(function () {
                $.ajax({
                    url: "clue/saveRemark.do",
                    data: {
                        "noteContent": $.trim($("#remark").val()),
                        "clueId": "${requestScope.clue.id}"
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data) {
                            showRemarkList();
                        } else {
                            alert("添加备注失败");
                        }
                    }
                })
            });

            showRemarkList();
            showActivityList()
        });

        //显示活动
        function showActivityList() {
            $.ajax({
                url: "clue/getActivityListByClueId.do",
                data: {
                    "clueId": "${requestScope.clue.id}"
                },
                dataType: "json",
                type: "get",
                success: function (data) {

                    var html = "";
                    $.each(data, function (i, n) {

                        html += '<tr id="' + n.id + '">';
                        html += '<td>' + n.name + '</td>';
                        html += '<td>' + n.startDate + '</td>';
                        html += '<td>' + n.endDate + '</td>';
                        html += '<td>' + n.owner + '</td>';
                        html += '<td><a href="javascript:void(0);"  style="text-decoration: none;" onclick="unbund(\'' + n.id + '\')"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
                        html += '</tr>';
                    });
                    $("#activityBody").html(html);
                }
            })
        }

        //显示备注
        function showRemarkList() {
            $.ajax({
                url: "clue/getClueRemark.do",
                type: "get",
                data: {
                    "clueId": "${requestScope.clue.id}"
                },
                dataType: "json",
                success: function (data) {
                    var html = "";
                    $("#remarkDiv").html(html);
                    $.each(data, function (i, n) {
                        html += '<div class="remarkDiv" style="height: 60px;">';
                        html += '<img title="xxx" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;" >';
                        html += '<h5>' + n.noteContent + '</h5>';
                        html += '<font color="gray">线索</font> <font color="gray">-</font> <b>"${requestScope.clue.fullname}${clue.appellation}"-"${clue.company}"</b> <small style="color: gray;"> "${clue.editTime == null?clue.createTime:clue.editTime}" 由"${clue.owner}"</small>';
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
                        html += '</div>';
                        html += '</div>';
                        html += '</div>';
                    });
                    $("#remarkDiv").before(html);
                }
            })
        }

        //绑定解除关联事件
        function unbund(id) {
            $.ajax({
                url: "clue/unbund.do",
                data: {
                    "id": id
                },
                dataType: "json",
                type: "post",
                success: function (data) {
                    if (data) {
                        // 刷新关联的市场活动列表
                        showActivityList();
                    } else {
                        alert("解除关联失败");
                    }
                }
            })
        }

    </script>

</head>
<body>

<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询"
                                   id="aname1"/>
                            <input type="button" value="查询" id="aname"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox" id="qx"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="activitySearchBody">

                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="bundBtn">关联</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${requestScope.clue.fullname}${requestScope.clue.appellation}
            <small>${requestScope.clue.company}</small>
        </h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" class="glyphicon glyphicon-retweet"
                onclick="window.location.href='workbench/clue/convert.jsp?id=${clue.id}&fullname=${clue.fullname}&appellation=${clue.appellation}&company=${clue.company}&owner=${clue.owner}\'';">
            <span></span> 转换
        </button>
    </div>

</div>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;">
            <b>${requestScope.clue.fullname}${requestScope.clue.appellation}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.company}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.job}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">线索状态</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.state}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.createBy}&nbsp;&nbsp;</b>
            <small style="font-size: 10px; color: gray;">${requestScope.clue.createTime}</small>
        </div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.editBy}&nbsp;&nbsp;</b>
            <small style="font-size: 10px; color: gray;">${requestScope.clue.editTime}</small>
        </div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${requestScope.clue.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${requestScope.clue.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;">
            <b>${requestScope.clue.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${requestScope.clue.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 40px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->
    <div class="remarkDiv" style="height: 60px;">

    </div>


    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="saveRemark">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>

                <tbody id="activityBody">

                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" data-toggle="modal" data-target="#bundModal"
               style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>