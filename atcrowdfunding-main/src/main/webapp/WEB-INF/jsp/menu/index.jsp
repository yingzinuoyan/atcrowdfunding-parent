<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2020/7/27
  Time: 10:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="UTF-8">
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
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 菜单维护</h3>
                </div>
                <div class="panel-body">
                    <ul id="treeDemo" class="ztree"></ul>
                </div>
            </div>
        </div>
    </div>
</div>

    <!-- Modal添加模态框 -->
    <div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="myModalLabel">添加菜单</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="name">菜单名称</label>
                            <input type="hidden" name="pid">
                            <input type="text" class="form-control"  name="name" placeholder="请输入菜单名称">
                        </div>
                        <div class="form-group">
                            <label for="icon">菜单图标</label>
                            <input type="text" class="form-control"  name="icon" placeholder="请输入菜单图标">
                        </div>
                        <div class="form-group">
                            <label for="url">菜单URL</label>
                            <input type="text" class="form-control"  name="url" placeholder="请输入菜单URL">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
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
        <h4 class="modal-title" id="myModalLabel2">修改菜单</h4>
      </div>
      <div class="modal-body">
		  <div class="form-group">
			<label for="name">菜单名称</label>
			<input type="hidden" name="id">
			<input type="text" class="form-control"  name="name" placeholder="请输入菜单名称">
		  </div>
		  <div class="form-group">
			<label for="icon">菜单图标</label>
			<input type="text" class="form-control"  name="icon" placeholder="请输入菜单图标">
		  </div>
		  <div class="form-group">
			<label for="url">菜单URL</label>
			<input type="text" class="form-control"  name="url" placeholder="请输入菜单URL">
		  </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button id="updateBtn" type="button" class="btn btn-primary">修改</button>
      </div>
    </div>
  </div>
</div>




<div class="modal fade" id="permissionModal" tabindex="-1" role="dialog" aria-labelledby="Modal">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel3">给菜单分配权限</h4>
      </div>
      <div class="modal-body">
 			<ul id="assignPermissionTree" class="ztree"></ul>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button id="assignPermission" type="button" class="btn btn-primary">分配</button>
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
        showTree();
    });
    function showTree(){
        var setting = {
            data: {
                simpleData: {
                    enable: true,
                    pIdKey: 'pid'
                }
            },
            view:{
                addDiyDom: customeIcon, //增加自定义图标
                addHoverDom: customeAddBtn, //鼠标移动到节点上显示按钮组
                removeHoverDom: customeRemoveBtn //鼠标离开节点去掉按钮组
            }
        };

        var zNodes = {};
        $.get("${PATH}/menu/loadTree",{},function(result){
            zNodes = result ;

            //增加根节点
            zNodes.push({"id":0,"name":"系统权限菜单","icon":"glyphicon glyphicon-th-list","children":[]});

            //初始化树
            var treeObj =  $.fn.zTree.init($("#treeDemo"), setting, zNodes);

            //获取树并展开所有节点
            //var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            treeObj.expandAll(true);
        });

    }

    //给树节点增加自定义 字体图标
    //treeId  表示生成树的位置，即容器id
    //treeNode 节点对象
    function customeIcon(treeId,treeNode) {
        //tId 由treeId + "_" + 序号
        //  tId + "_ico"  获取显示字体图标的元素
        //  tId + "_span"  获取显示节点名称的元素
        $("#"+treeNode.tId+"_ico").removeClass();//.addClass();
        $("#"+treeNode.tId+"_span").before("<span class='"+treeNode.icon+"'></span>")
    }

    // 鼠标移动到节点上显示按钮组
    function customeAddBtn(treeId, treeNode){
        var aObj = $("#" + treeNode.tId + "_a");
        aObj.attr("href", "javascript:;"); //禁用链接
        aObj.attr("onclick", "return false;"); //禁用单击事件

        if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) {
            return;
        }

        var s = '<span id="btnGroup'+treeNode.tId+'">';
        if ( treeNode.level == 0 ) { //根节点
            s += '<a id="saveBtn" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px; padding-top:0px;" title="添加权限信息" onclick="add('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
        } else if ( treeNode.level == 1 ) { //分支节点
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" title="修改权限信息" onclick="update('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
        if (treeNode.children.length == 0) {
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  title="删除权限信息" onclick="remove('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
        }
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  title="添加权限信息" onclick="add('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
        } else if ( treeNode.level == 2 ) { //叶子节点
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  title="修改权限信息" onclick="update('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  title="删除权限信息" onclick="remove('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
        }
        s += '</span>';
        aObj.after(s);
    }

    //鼠标离开节点去掉按钮组
    function customeRemoveBtn(treeId, treeNode){
        $("#btnGroup"+treeNode.tId).remove();
    }

    // 添加=====
   function add(id) {

        $("#addModal input[name='pid']").val(id);
            $('#addModal').modal({ //弹出模态框
            show:true,
            backdrop:'static',
            keyboard:false
        });

   }
   // 添加保存
    $("#saveBtn").click(function(){
        var pid = $("#addModal input[name='pid']").val();
        var name = $("#addModal input[name='name']").val();
        var icon = $("#addModal input[name='icon']").val();
        var url = $("#addModal input[name='url']").val();
        $.ajax({
            type:'post',
            url:"${PATH}/menu/save",
            data:{
                pid:pid,
                name:name,
                icon:icon,
                url:url
            },
            success:function(result){ //  result='ok'   result='fail'
                if(result=='ok'){
                    layer.msg("添加成功",{time:1000,icon:6},function(){
                        $('#addModal').modal('hide');
                        $("#addModal input[name='pid']").val("");
                        $("#addModal input[name='name']").val("");
                        $("#addModal input[name='icon']").val("");
                        $("#addModal input[name='url']").val("");
                        showTree();
                    });
                }else{
                    layer.msg("添加失败",{time:1000,icon:5});
                }
            }
        });
    });
    // 修改==
    function update(id) {
        // 获取数据
        $.get("${PATH}/menu/get",{id:id},function(result) {
            console.log(result);

            // 回显数据
            $("#updateModal input[name='id']").val(result.id);
            $("#updateModal input[name='name']").val(result.name);
            $("#updateModal input[name='icon']").val(result.icon);
            $("#updateModal input[name='url']").val(result.url);
            // 弹出模态框
            $("#updateModal").modal({
                show:true,
                backdrop:'static',
                keyboard:false
            });
        });
    }
    // 修改成功保存
    $("#updateBtn").click(function(){
        var id = $("#updateModal input[name='id']").val();
        var name = $("#updateModal input[name='name']").val();
        var icon = $("#updateModal input[name='icon']").val();
        var url = $("#updateModal input[name='url']").val();
        $.ajax({
            type:'post',
            url:"${PATH}/menu/update",
            data:{
                id:id,
                name:name,
                icon:icon,
                url:url
            },
            success:function(result){ //  result='ok'   result='fail'
                if(result=='ok'){
                    $('#updateModal').modal('hide');
                    layer.msg("修改成功",{time:1000,icon:6},function(){
                    loadTree();
                    });
                }else{
                    layer.msg("修改失败",{time:1000,icon:5});
                }
            }
        });
    });
    // 删除
    function remove(id){
        layer.confirm('您确定要删除这条数据吗?', {btn:['确定','取消']}, function(index){

            $.post("${PATH}/menu/delete",{id:id},function(result){
                if(result=='ok'){
                    layer.msg("删除成功",{time:1000,icon:6},function(){
                        loadTree();
                    });
                }else{
                    layer.msg("删除失败",{time:1000,icon:5});
                }
            });

            layer.close(index);
        }, function(index){
            layer.close(index);
        });
    }

</script>
</body>
</html>

