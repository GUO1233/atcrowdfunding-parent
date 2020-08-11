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
                    <button id="saveBtn" type="button" class="btn btn-primary" style="float:right;"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <th width="30"><input type="checkbox" id="mainCheck"></th>

                                <th>名称</th>

                                <th width="100">操作</th>
                            </tr>

                            </thead>
                            <tbody>


                            </tbody>
                            <tfoot>
                            <tr >
                                <td colspan="6" align="center">
                                    <ul class="pagination">

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


<!-- 添加模态框 -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加</h4>
            </div>
            <div class="modal-body">
                <form role="form" id="addForm">
                    <div class="form-group">
                        <label>名称</label>
                        <input name="username" type="text" class="form-control" placeholder="请输入角色名称">
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveModalBtn" type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改模态框 -->
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="updateModalLabel">修改</h4>
            </div>
            <div class="modal-body">
                <form role="form" id="updateForm">
                    <div class="form-group">
                        <label>名称</label>
                        <input type="hidden" name="id">
                        <input name="name" type="text" class="form-control" placeholder="请输入角色名称">
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="updateModalBtn" type="button" class="btn btn-primary">修改</button>
            </div>
        </div>
    </div>
</div>





<%@include file="/WEB-INF/common/js.jsp"%>

<script type="text/javascript">
    $(function () {
        $(".list-group-item").click(function(){//页面加载完成时执行的事件处理。
            if ( $(this).find("ul") ) {
                $(this).toggleClass("tree-closed");
                if ( $(this).hasClass("tree-closed") ) {
                    $("ul", this).hide("fast");
                } else {
                    $("ul", this).show("fast");
                }
            }
        });

        showData(1);

    });


    var json={
        pageNum:1,
        pageSize:2,
        condition:""
    }
    function showData(pageNum) {
        json.pageNum=pageNum;
        $.ajax({
            type:"post",
            data:json,
            url:"${PATH}/role/loadData",
            dataType:"json",
            success:function(result){
                //alert(typeof (result));
                json.totalPages=result.pages;

                console.log(result);
                //显示列表数据
                showTable(result.list);
                //显示导航页码
                showNavg(result);
            },
            error:function () {
                alert("请求失败~~~");
            }

        });
    }
    //显示列表数据
    function showTable(list){
        var content = ''; //在js代码中，拼串推荐使用单引号

        $.each(list,function(i,e){ //i 索引    e 元素(Role对象)
            content+='<tr>';
            content+='  <td>'+(i+1)+'</td>';
            content+='  <td><input type="checkbox"></td>';
            content+='  <td>'+e.name+'</td>';
            content+='  <td>';
            content+='	  <button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>';
            content+='	  <button type="button" roleId="'+e.id+'" class="updateBtnClass btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>';
            content+='	  <button type="button" name="'+e.name+'" roleId="'+e.id+'" class=" deleteBtnClass btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>';
            content+='  </td>';
            content+='</tr>';
        });

        $("tbody").html(content);
    }
    //显示导航页数据
    function showNavg(pageInfo) {
        var content='';
        if(pageInfo.isFirstPage){
            content+='<li class="disabled"><a href="#">上一页</a></li>'
        }else {
            content+='<li><a onclick="showData('+(pageInfo.pageNum-1)+')">上一页</a></li>'
        }


        $.each(pageInfo.navigatepageNums,function (i,num) {
            if(num==pageInfo.pageNum){
                content+='<li class="active"><a onclick="showData('+num+')">'+num+'</a></li>'
            }else {
                content+='<li><a onclick="showData('+num+')">'+num+'</a></li>'
        }
        });

        if(pageInfo.isLastPage){
            content+='<li class="disabled"><a href="#">下一页</a></li>'
        }else {
            content+='<li><a onclick="showData('+(pageInfo.pageNum+1)+')">下一页</a></li>'
        }


        $(".pagination").html(content);
    }


    //quCondition  quConditionForm
    $("#quCondition").click(function () {
        //获取查询条件
        var condition = $("#quConditionForm input[name='condition']").val();
        json.condition=condition;
        showData(1);
    });
    //===添加功能=============================================================
    $("#saveBtn").click(function () {
        //弹出模态框
        $("#addModal").modal({
            show:true,
            backdrop:"static",
            keyboard:false
        });
    });
    //给添加模态框 添加按钮增加单击事件
    $("#saveModalBtn").click(function () {
        //1.获取表单参数
        alert(123);
        var name=$("#addModal input[name='username']").val();
        //2.发起ajax请求，保存数据
        $.ajax({
            type:"post",
            data: {name:name},
            url:"${PATH}/role/doAdd",
            success:function (result) {
                //3.判断是否保存成功，弹出消息
                //4.关闭模态框
                $("#addModal").modal("hide");
                $
                if(result=="ok"){
                    layer.msg("添加成功");
                    //5.刷新列表页面
                    showData(json.totalPages+1);
                }else {
                    layer.msg("添加失败");
                }
            }
        });
    });
    //===修改功能=============================================================
    //对于页面后来元素，增加事件处理时，不能用click()，需要使用on()函数
    /*$(".updateBtnClass").click(function(){
        alert("xxx");
    });*/

    $("tbody").on("click",".updateBtnClass",function(){
        //this.roleId; //不能通过dom对象获取自定义属性值的
        //1.获取修改的数据id
        var id = $(this).attr("roleId");//获取自定义属性只能用attr
        //alert(id);
        //2.发起ajax请求，查询数据
       $.get("${PATH}/role/getRoleById",{id:id},function(result){ // result == TRole == json {id:1,name:xxx}
            //3.回显数据
            $("#updateModal input[name='name']").val(result.name);
            $("#updateModal input[name='id']").val(result.id);
            //4.弹出模态框
            $("#updateModal").modal({
                show:true, //展示模态框
                backdrop:"static", //点背景页面，不关闭模态框
                keyboard:false  //点esc键，不关闭模态框
            });
        });
        //修改功能
        $("#updateModalBtn").click(function () {
            var name = $("#updateModal input[name='name']").val();
            var id = $("#updateModal input[name='id']").val();

            $.post("${PATH}/role/doUpdate",{id:id,name:name},function(result){
                $("#updateModal").modal("hide");
                if(result=="ok"){
                    layer.msg("修改成功");
                    showData(json.pageNum)
                }else {
                    layer.msg("修改失败");
                }
            });

        });

    });
    //========删除功能==============================================================
    $("tbody").on("click",".deleteBtnClass",function () {//$(this)就代表$(".deleteBtnClass")
        //1.获取数据
        var id = $(this).attr("roleId");
        var name = $(this).attr("name");
        alert(name);
        //2.发送请求
        layer.confirm("您确定要【"+name+"】删除吗?",{btn:['确定','取消']},function () {
            $.post("${PATH}/role/dodelete",{id:id},function (result) {
                if (result == "ok"){
                    layer.msg("删除成功");
                    showData(json.pageNum);
                }else{
                    layer.msg("删除失败");
                }
            });
        },function () {

        });




    });


</script>
</body>
</html>
