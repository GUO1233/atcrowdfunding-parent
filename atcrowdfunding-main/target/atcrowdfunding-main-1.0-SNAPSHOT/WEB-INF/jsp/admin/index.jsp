<%--
  Created by IntelliJ IDEA.
  User: 28331
  Date: 2020/7/28
  Time: 20:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <%@include file="/WEB-INF/common/css.jsp"%>
    <style>
        .tree li {
            list-style-type: none;
            cursor:pointer;
        }
        table tbody tr:nth-child(odd){background:#F4F4F4;}
        table tbody td:nth-child(even){color:#C00;}
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/common/top.jsp"></jsp:include>
<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/common/menu.jsp"></jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">

                    <form class="form-inline" role="form" style="float:left;" action="${PATH}/admin/index" id="quConditionForm" method="post">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input class="form-control has-success" type="text" placeholder="请输入查询条件" name="condition" value="${param.condition}">
                            </div>
                        </div>
                        <button type="button" class="btn btn-warning" id="quCondition"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>

                    <button id="deleteBatchBtn" type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button type="button" class="btn btn-primary" style="float:right;" onclick="window.location.href='${PATH}/admin/toAdd'"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <th width="30"><input type="checkbox" id="mainCheck"></th>
                                <th>账号</th>
                                <th>名称</th>
                                <th>邮箱地址</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${page.list}" var="admin" varStatus="status">
                                <tr>
                                    <td>${status.count}</td>
                                    <td><input type="checkbox" class="childCheck" id="${admin.id}"></td>
                                    <td>${admin.loginacct}</td>
                                    <td>${admin.username}</td>
                                    <td>${admin.email}</td>
                                    <td>
                                        <button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>
                                        <button type="button" class="btn btn-primary btn-xs"  onclick="window.location.href='${PATH}/admin/toUpdate?id=${admin.id}&pageNum=${page.pageNum}'"><i class=" glyphicon glyphicon-pencil"></i></button>
                                        <button type="button" class="btn btn-danger btn-xs" onclick="deleteAdmin('${admin.loginacct}','${admin.id}')"><i class=" glyphicon glyphicon-remove"></i></button>
                                    </td>
                                </tr>
                            </c:forEach>

                            </tbody>
                            <tfoot>
                            <tr >
                                <td colspan="6" align="center">
                                    <ul class="pagination">
                                        <c:if test="${page.isFirstPage}">
                                            <li class="disabled"><a href="#">上一页</a></li>
                                        </c:if>
                                        <c:if test="${!page.isFirstPage}">
                                            <li ><a href="${PATH}/admin/index?pageNum=${page.pageNum - 1}&condition=${param.condition}">上一页</a></li>
                                        </c:if>

                                       <c:forEach items="${page.navigatepageNums}" var="num" >
                                           <c:if test="${num == page.pageNum}">
                                               <li class="active"><a href="${PATH}/admin/index?pageNum=${num}&condition=${param.condition}">${num}</a></li>
                                           </c:if>
                                           <c:if test="${num != page.pageNum}">
                                               <li><a href="${PATH}/admin/index?pageNum=${num}">${num}</a></li>
                                           </c:if>
                                       </c:forEach>

                                        <c:if test="${page.isLastPage}">
                                            <li class="disabled"><a href="#">下一页</a></li>
                                        </c:if>
                                        <c:if test="${!page.isLastPage}">
                                            <li ><a href="${PATH}/admin/index?pageNum=${page.pageNum +1}&condition=${param.condition}">下一页</a></li>
                                        </c:if>
                                    </ul>
                                </td>
                            </tr>

                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/common/js.jsp"%>

<script type="text/javascript">
    $(function () {
        $(".list-group-item").click(function(){
            if ( $(this).find("ul") ) {
                $(this).toggleClass("tree-closed");
                if ( $(this).hasClass("tree-closed") ) {
                    $("ul", this).hide("fast");
                } else {
                    $("ul", this).show("fast");
                }
            }
        });
    });
    $("tbody .btn-success").click(function(){
        window.location.href = "assignRole.html";
    });

    $("#quCondition").click(function () {
        $("#quConditionForm").submit();
    });
    //删除一条数据
    function deleteAdmin(loginacct,id) {
        //layer弹层组件
        layer.confirm("您确定要删除【"+loginacct+"】账号吗?",
            {btn:['确定','取消']},
            function () {
              window.location.href="${PATH}/admin/delete?id="+id+"&pageNum=${page.pageNum}"
            },
             function () {

             })
    }
    //复选框联动效果
    $("#mainCheck").click(function () {
        var mainCheck = $(this).prop("checked");
        $(".childCheck").prop("checked",mainCheck);
    });


    $("#deleteBatchBtn").click(function () {
        var $childCheck = $(".childCheck:checked");
        if($childCheck.length==0){
            layer.msg("请选择要删除的数据！");
            return false;
        }
        var idArray = new Array();
        $.each($childCheck,function (i,e) {//i 索引    e 元素
            var id = $(e).prop("id");
            idArray.push(id);
        });
        //[1,2,3,4] ->   "1,2,3,4"
        var str = idArray.join(",");//将数组中元素循环获取并拼成串，并使用逗号进行分割
        layer.confirm("您确定要删除这些数据吗?",{btn:['确定','取消']},function () {
            window.location.href="${PATH}/admin/deleteBatch?ids="+str+"&pageNum=${page.pageNum}";
        },function () {

        });
    });



</script>
</body>
</html>
