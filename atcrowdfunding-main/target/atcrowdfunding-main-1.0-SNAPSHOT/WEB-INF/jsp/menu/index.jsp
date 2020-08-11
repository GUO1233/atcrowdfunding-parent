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
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 权限菜单列表</h3>
                </div>
                <div class="panel-body">
                    <ul id="treeDemo" class="ztree"></ul>

                </div>
            </div>
        </div>
    </div>
</div>

<%--添加模态框--%>
<div class="modal fade" id="AddModal" tabindex="-1" role="dialog" aria-labelledby="AddModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                <h4 class="modal-title" id="myModalLabel">添加菜单</h4>
            </div>
            <form id="addMenuForm">
                <div class="modal-body">
                    <div class="form-group">
                        <label >菜单名称</label>
                        <input type="hidden" id="addFormPid" name="pid">
                        <input type="text" class="form-control" id="addFormName" name="name"  placeholder="请输入菜单名称">
                    </div>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label >菜单图标</label>
                        <input type="text" class="form-control" id="addFormIcon" name="icon"  placeholder="请输入菜单图标">
                    </div>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label >菜单URL</label>
                        <input type="text" class="form-control" id="addFormUrl" name="url"  placeholder="请输入菜单URL">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" onclick="saveMenu()">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%--修改模态框--%>
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="AddModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                <h4 class="modal-title" id="myModalLabel">修改菜单</h4>
            </div>
            <form id="addMenuForm">
                <div class="modal-body">
                    <div class="form-group">
                        <label >菜单名称</label>
                        <input type="hidden" id="addFormPid" name="id">
                        <input type="text" class="form-control" id="addFormName" name="name"  placeholder="请输入菜单名称">
                    </div>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label >菜单图标</label>
                        <input type="text" class="form-control" id="addFormIcon" name="icon"  placeholder="请输入菜单图标">
                    </div>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label >菜单URL</label>
                        <input type="text" class="form-control" id="addFormUrl" name="url"  placeholder="请输入菜单URL">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" onclick="update()">修改</button>
                </div>
            </form>
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

        showTree();

    });

    function showTree() {
        var setting = {
            data: {
                simpleData: {
                    enable: true,
                    pIdKey: 'pid'
                }
            },
            view:{
                addDiyDom:customeIcon,  //增加自定义图标
                addHoverDom:customeAddBtn, //鼠标移动到节点上显示按钮组
                removeHoverDom:customeRemoveBtn //鼠标离开节点去掉按钮组

            }
            
        };

        var zNodes ={};

        $.get("${PATH}/menu/loadTree",{},function (result) {
            zNodes=result;
            //增加根节点
            zNodes.push({"id":0,"name":"系统权限菜单","icon":"glyphicon glyphicon-th-list","children":[]});
            //初始化树
            var treeObj=$.fn.zTree.init($("#treeDemo"), setting, zNodes);

            //获取树并展开所有节点
            //var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            treeObj.expandAll(true);
        });
    }

    //给树节点增加自定义  字体图标
    //treeId  表示生成树的位置，即容器id   <ul id="treeDemo" class="ztree"></ul>
    //treeNode 节点对象  一个节点对象  就相当与一个TMenu对象
    //{"id":1,"pid":0,"name":"控制面板","icon":"glyphicon glyphicon-dashboard","url":"main","children":[]}
    function customeIcon(treeId,treeNode) {
        //tId 由treeId + "_" + 序号
        //  tId + "_ico"  获取显示字体图标的元素
        //  tId + "_span"  获取显示节点名称的元素
        $("#"+treeNode.tId+"_ico").removeClass();//.addClass();
        $("#"+treeNode.tId+"_span").before("<span class='"+treeNode.icon+"'></span>")

    }

    function customeAddBtn(treeId, treeNode) {
        var aObj = $("#" + treeNode.tId + "_a");
        aObj.attr("href", "javascript:;"); //禁用链接
        aObj.attr("onclick", "return false;"); //禁用单击事件
        if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) {
            return;
        }

        var s = '<span id="btnGroup'+treeNode.tId+'">';
        if ( treeNode.level == 0 ) { //根节点
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  href="#">&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg " onclick="add('+treeNode.id+')" ></i></a>';
        } else if ( treeNode.level == 1 ) { //分支节点
            s += '<a class="addLevel1 btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  href="#" title="修改权限信息">&nbsp;&nbsp;' +
                '<i class="fa fa-fw fa-edit rbg " onclick="doUpdate('+treeNode.id+')"></i></a>';
            if (treeNode.children.length == 0) {
                s += '<a  class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg " onclick="remove('+treeNode.id+')"></i></a>';
            }
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;  href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg " onclick="add('+treeNode.id+')"></i></a>';
        } else if ( treeNode.level == 2 ) { //叶子节点
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  href="#" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg " onclick="doUpdate('+treeNode.id+')"></i></a>';
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg " onclick="remove('+treeNode.id+')"></i></a>';
        }
        s += '</span>';
        aObj.after(s);
    }

    //鼠标离开节点去掉按钮组
    function customeRemoveBtn(treeId, treeNode){
        $("#btnGroup"+treeNode.tId).remove();
    }

    //===添加功能=============================================================

    function add(id) {
        $("#addFormPid").val(id);
        $("#AddModal").modal({show:true,backdrop:'static',keyboard:false})
    }

    function saveMenu() {
        var pid = $("#addFormPid").val();
        var name = $("#addFormName").val();
        var icon = $("#addFormIcon").val();
        var url = $("#addFormUrl").val();
        $.post("${PATH}/menu/add",{pid:pid,name:name,icon:icon,url:url},function(result){
            if(result=="ok"){

                layer.msg("添加成功",{time:1000,icon:6},function () {
                    $("#AddModal").modal("hide");
                    $("#AddModal input[name='pid']").val("");
                    $("#AddModal input[name='name']").val("");
                    $("#AddModal input[name='icon']").val("");
                    $("#AddModal input[name='url']").val("");
                    showTree();
                });

            }else {
                layer.msg("添加失败",{time:1000,icon:5});
            }
        });

    }

    //===删除功能=============================================================
    function remove(id) {
        layer.confirm("您确定要删除这条数据吗?",{btn:['确定','取消']},function () {
            $.get("${PATH}/menu/delete",{id:id},function (result) {
                if(result=="ok"){
                    layer.msg("删除成功",{time:100,icon:6},function () {
                        showTree();
                    });
                }else {
                    layer.msg("删除失败");
                }
            });
        },function () {

        });
    }
    //===修改功能=============================================================
    function doUpdate(id) {
        $.get("${PATH}/menu/doUpdate",{id:id},function (result) {
            $("#updateModal input[name='id']").val(result.id);
            $("#updateModal input[name='name']").val(result.name);
            $("#updateModal input[name='icon']").val(result.icon);
            $("#updateModal input[name='url']").val(result.url);
            $("#updateModal").modal({show:true,backdrop:'static',keyboard:false});
        });
    }
    function update() {
        var id = $("#updateModal input[name='id']").val();
        var name = $("#updateModal input[name='name']").val();
        var icon = $("#updateModal input[name='icon']").val();
        var url = $("#updateModal input[name='url']").val();
        $.get("${PATH}/menu/update",{id:id,name:name,icon:icon,url:url},function (result) {
            $("#updateModal").modal("hide");
            layer.msg("修改成功",{time:1000,icon:6},function () {
                $("#updateModal input[name='pid']").val("");
                $("#updateModal input[name='name']").val("");
                $("#updateModal input[name='icon']").val("");
                $("#updateModal input[name='url']").val("");
                showTree();
            });
        });
    }




   /* var setting = {
        data: {
            simpleData: {
                enable: true
            }
        }
    };

    var zNodes ={};

    $(document).ready(function(){
        $.fn.zTree.init($("#treeDemo"), setting, zNodes);
    });*/

</script>
</body>
</html>
