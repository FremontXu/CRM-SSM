<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName()
            + ":" + request.getServerPort() + request.getContextPath() + "/";
    Map<String, String> pMap = (Map<String, String>) application.getAttribute("pMap");
    Set<String> set = pMap.keySet();
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

    <script type="text/javascript" src="../../jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script type="text/javascript">

        /**
         * 关于阶段和可能性
         *        是一种一一对应的关系
         *        一个阶段对应一个可能性
         *        我们现在可以将阶段和可能性想象成一种键值对之间的对应关系
         *        以阶段为key,通过选中的阶段,触发可能性value
         *
         *        stage                possibility
         *        key                    value
         *    ---------------------------------------
         *        01资质审查            10
         *        02需求分析            25
         *        03价值建议            40
         *        ....
         *        ....
         *        07成功                100
         *        08...                0
         *        09...                0
         *
         *        对于以上的数据,通过观察得到结论
         *        (1) 数据量不是很大
         *        (2) 这是一种键值对的对应关系
         *
         *        如果同时满足以上两种结论,那么我们将这样的数据保存在数据库表中就没有什么意义了
         *        如果遇到这种情况,我们需要用到properties属性文件来进行保存
         *        Stage2Possibility.properties
         *        01资质审查=10
         *        02需求分析=25
         *        ....
         *
         *        Stage2Possibility.properties这个文件表示的是阶段和键值对之间的对应关系
         *        将来,我们通过stage,以及对应关系,来取得可能性这个值
         *        这种需求在交易模块中需要大量的使用到
         *
         *        所以我们就需要将该文件解析在服务器的缓存中
         *        application.setAttribute(Stage2Possibility.properties文件内容)
         */

        var json = {
            <%
                for(String key : set){
                    String value = pMap.get(key);
            %>
            "<%=key%>":<%=value%>,

            <%
                }
            %>
        };

        $(function () {

            // 条件日历组件 设置日期参数以什么格式存在
            $(".time1").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            // 条件日历组件 设置日期参数以什么格式存在
            $(".time2").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "top-left"
            });

            // 市场活动模态窗口中的搜索框绑定事件,通过触发回车键,查询并展现所需市场活动列表
            $("#aname").change(function () {
                $.ajax({
                    url: "tran/getActivity.do",
                    type: "get",
                    dataType: "json",
                    data: {
                        "aname": $.trim($("#aname").val()),
                    },
                    success: function (data) {
                        var html = "";
                        $("#activitySearchBody").html(html);
                        $.each(data, function (i, n) {
                            html += '<tr>';
                            html += '<td><input type="radio" name="activity" value="' + n.id + '" /></td>';
                            html += '<td id=' + n.id + '>' + n.name + '</td>';
                            html += '<td>' + n.startDate + '</td>';
                            html += '<td>' + n.endDate + '</td>';
                            html += '<td>' + n.owner + '</td>';
                            html += '</tr>';
                        });
                        $("#activitySearchBody").html(html);
                    }
                })
            });
            //处理选中活动
            $("#submitActivityBtn").click(function () {
                // 取得选中市场活动的id
                var id = $(":radio[name='activity']:checked").val();

                // 取得市场活动id的名字
                var name = $("#" + id).html();

                // 将以上两项信息填写到 交易表单的市场活动源中
                $("#create-activityId").val(id);
                $("#create-activity").val(name);

                // 将模态窗口关闭
                $("#findMarketActivity").modal("hide");
            });

            // 联系人活动模态窗口中的搜索框绑定事件,通过触发回车键,查询并展现所
            $("#cname").change(function () {
                $.ajax({
                    url: "tran/getContact.do",
                    type: "get",
                    dataType: "json",
                    data: {
                        "cname": $.trim($("#cname").val())
                    },
                    success: function (data) {
                        var html = "";
                        $("#contactSearchBody").html(html);
                        $.each(data, function (i, n) {
                            html += '<tr>';
                            html += '<td><input type="radio" name="contact" value="' + n.id + '" /></td>';
                            html += '<td id=' + n.id + '>' + n.fullname + '</td>';
                            html += '<td>' + n.email + '</td>';
                            html += '<td>' + n.mphone + '</td>';
                            html += '</tr>';
                        });
                        $("#contactSearchBody").html(html);
                    }
                })
            });
            //处理选中联系人
            $("#submitContactBtn").click(function () {
                // 取得选中市场活动的id
                var id = $(":radio[name='contact']:checked").val();
                console.log(id);
                // 取得市场活动id的名字
                var name = $("#" + id).html();

                // 将以上两项信息填写到 交易表单的市场活动源中
                $("#create-contactId").val(id);
                $("#create-contactName").val(name);

                // 将模态窗口关闭
                $("#findContacts").modal("hide");
            });

            // 为保存按钮绑定事件,执行交易添加操作
            $("#saveTranBtn").click(function () {
                // 发出传统请求,提交表单
                $("#tranForm").submit();
            });

            //自动补全
            $("#create-customerName").typeahead({
                source: function (query, process) {
                    $.get(
                        "tran/getCustomerName.do",
                        {"name": query},
                        function (data) {
                            process(data);
                        },
                        "json"
                    );
                },
                delay: 1500
            });

            // 为阶段的下拉框,绑定选中下拉框的事件,根据选中的阶段填写可能性
            $("#create-stage").change(function () {
                // 取得选中的阶段
                var stage = $("#create-stage").val();

                /**
                 * 目标: 填写可能性
                 *
                 *  阶段有了stage
                 *  阶段和可能性之间的对应关系pMap,但是pMap是java语言中的键值对关系(java中的map对象)
                 *  我们首先得将pMap转换为js中的键值对关系json
                 *
                 *  我们要做的是将pMap转换为json格式
                 *
                 * 我们现在以json.key的形式不能取得value
                 * 因为今天的stage是一个可变的变量
                 * 如果是这样的key,我们就不能以传统的json.key的形式取值
                 * 我们要使用的取值方式为
                 * json[key]
                 */
                var possibility = json[stage];
                // 为可能性的文本框赋值
                $("#create-possibility").val(possibility);
            });

        })


    </script>
</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" id="aname"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
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
                <button type="button" class="btn btn-default" data-dismiss="modal" onclick="window.location.href=''">取消</button>
                <button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" id="cname"
                                   placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="contactTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="contactSearchBody"></tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="submitContactBtn">提交</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<div style="position:  relative; left: 30px;">
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveTranBtn">保存</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>

<form action="tran/saveTran.do" method="post" id="tranForm" class="form-horizontal" role="form"
      style="position: relative; top: -30px;">

    <div class="form-group">
        <label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionOwner" name="owner">
                <option></option>
                <c:forEach items="${requestScope.uList}" var="u">
                    <option value="${u.id}" ${sessionScope.user.id eq u.id?"selected":""}>${u.name}</option>
                </c:forEach>
            </select>
        </div>

        <label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-amountOfMoney" name="money">
        </div>

    </div>

    <div class="form-group">
        <label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-transactionName" name="name">
        </div>

        <label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time1" id="create-expectedClosingDate" name="expectedDate">
        </div>

    </div>

    <div class="form-group">

        <label for="create-customerName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-customerName" name="customerId"
                   placeholder="支持自动补全，输入客户不存在则新建">
        </div>

        <label for="create-stage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-stage" name="stage">
                <option></option>
                <c:forEach items="${applicationScope.stageList}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
            </select>
        </div>

    </div>

    <div class="form-group">

        <label for="create-transactionType" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-transactionType" name="type">
                <option></option>
                <c:forEach items="${applicationScope.transactionTypeList}" var="t">
                    <option value="${t.value}">${t.text}</option>
                </c:forEach>
            </select>
        </div>

        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility">
        </div>

    </div>

    <!--活动原-->
    <div class="form-group">
        <label for="create-clueSource" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-clueSource" name="source">
                <option></option>
                <c:forEach items="${applicationScope.sourceList}" var="s">
                    <option value="${s.value}">${s.text}</option>
                </c:forEach>
            </select>
        </div>

        <label for="create-activity" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;
            <a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity">
                <span class="glyphicon glyphicon-search"></span>
            </a>
        </label>

        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-activity">
            <input type="hidden" class="form-control" id="create-activityId" name="activityId">
        </div>

    </div>

    <!--联系人-->
    <div class="form-group">
        <label for="create-contactName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;
            <a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts">
                <span class="glyphicon glyphicon-search"></span>
            </a>
        </label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-contactName">
            <input type="hidden" name="contactsId" id="create-contactId"/>
        </div>
    </div>

    <div class="form-group">
        <label for="create-describe" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time2" id="create-nextContactTime" name="nextContactTime">
        </div>
    </div>

</form>
</body>
</html>