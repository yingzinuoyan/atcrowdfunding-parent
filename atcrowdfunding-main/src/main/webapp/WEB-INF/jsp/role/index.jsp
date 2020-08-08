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
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">


                    <form id="queryForm" class="form-inline" role="form" style="float:left;" action="${PATH}/admin/index" method="post">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input class="form-control has-success" type="text" name="condition" value="${param.condition}" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="searchBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>


                    <button id="deleteBatchBtn" type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button id="saveBtn" type="button" class="btn btn-primary" style="float:right;" ><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <th width="30"><input id="theadCheckbox" type="checkbox"></th>
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


<!-- Modal添加模态框 -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加</h4>
            </div>
            <div class="modal-body">
                <form id="addForm" role="form">
                    <div class="form-group">
                        <label>名称</label>
                        <input type="text" class="form-control"  name="name" placeholder="请输入角色名称">
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

<!-- Modal修改模态框 -->
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel2">修改</h4>
            </div>
            <div class="modal-body">
                <form id="updateForm" role="form">
                    <div class="form-group">
                        <label>名称</label>
                        <input type="hidden" name="id">
                        <input type="text" class="form-control"  name="name" placeholder="请输入角色名称">
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
        showData(1);
    });

    var json = {
        pageNum:1,
        pageSize:2,
        condition:""

    };

    function showData(pageNum) {
        json.pageNum = pageNum;
        $.ajax({
            type:"post",
            data:json,
            url:"${PATH}/role/loadData",
            success:function (result) {

                json.totalPages = result.pages;
                console.log(result.list);
                // 显示列表数据
                showTable(result.list);
                // 显示导航页码
                showNavg(result);
            }
        });

    }
    // 显示列表数据
    function showTable(list) {
        var content = '';// 拼串的准备

        $.each(list,function (i,e) { // i索引 ,e 元素

            content+='<tr>';
            content+='  <td>'+(i+1)+'</td>';
            content+='  <td><input type="checkbox"></td>';
            content+='  <td>'+e.name+'</td>';
            content+='  <td>';
            content+='	  <button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>';
            content+='	  <button type="button" roleId="'+e.id+'" class="updateBtnClass btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>';
            content+='	  <button type="button" roleId="'+e.id+'" class="deleteBtnClass btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>';
            content+='  </td>';
            content+='</tr>';
        });
        $("tbody").html(content);  // 在tbody 标签中插入页面

    }
    // 显示导航页码
    function showNavg(pageInfo) {
        var content = '';// 拼串的准备

        if (pageInfo.isFirstPage){  // 判断是否是第一页
            content+='<li class="disabled"><a href="#">上一页</a></li>';
        }else{
            content+='<li><a onclick="showData('+(pageInfo.pageNum-1)+')">上一页</a></li>';
        }

        $.each(pageInfo.navigatepageNums,function (i,num) {
            if(num == pageInfo.pageNum){
                content+='<li class="active"><a onclick="showData('+num+')">'+num+'</a></li>';
            }else{
                content+='<li><a onclick="showData('+num+')">'+num+'</a></li>';
            }
        });

        if (pageInfo.isLastPage){  // 判断是否是最后一页
            content+='<li class="disabled"><a href="#">下一页</a></li>';
        }else{
            content+='<li><a onclick="showData('+(pageInfo.pageNum+1)+')">下一页</a></li>';
        }
        $(".pagination").html(content); // 在上面的url标签中添加页面
    }

    // 条件查询
    $("#searchBtn").click(function () {
       var condition =  $("#queryForm input[name='condition']").val(); // 获得查询条件文本框中的内容
       json.condition = condition;  // 把内容存放到公共的json属性中
       showData(1); // 查询
    })

    // 添加=====
    $("#saveBtn").click(function () {
        // 点击新增弹出模态框
        $("#addModal").modal({
            show:true,
            backdrop:"static",
            keyboard:false
        });
    });
    // 给模态框中的保存按钮添加点击事件
    $("#saveModalBtn").click(function(){
        // 获取表中的参数
        var name = $("#addModal input[name='name']").val();

        // 发送ajax请求,保存数据
        $.ajax({
            type:"post",
            data:{
                name:name
            },
            url:"${PATH}/role/doAdd",
            success:function(result){
                // 判断是否保存成功
                $("#addModal").modal("hide");
                $("#addModal input[name='name']").val("");
                if(result == "ok"){
                    layer.msg("添加成功");
                    showData(json.totalPages + 1);
                }else{
                    layer.msg("添加失败");
                }
            }
        });
    });
    // 修改===========
    // 页面后来元素不能使用click(),要使用on()
    $("tbody").on("click",".updateBtnClass",function () {

        // 获取要修改数据的id
       var roleId =  $(this).attr("roleId");
       // 发起ajax 查询数据
        $.get("${PATH}/role/getRoleById",{id:roleId},function (result) {

            // 在修改页回显数据
            $("#updateModal input[name='name']").val(result.name);
            $("#updateModal input[name='id']").val(result.id);
            // 弹出模态框
            $("#updateModal").modal({
                show:true,
                backdrop:"static",
                keyboard:false
            });
        });
    });
    // 模态框中修改按钮事件
    $("#updateModalBtn").click(function () {
       // 获取修改表单中的数据
        var name = $("#updateModal input[name='name']").val();
        var id = $("#updateModal input[name='id']").val();

        // 提交ajax请求
        $.post("${PATH}/role/doUpdate",{id:id,name:name},function (result) {
            $("#updateModal").modal('hide');
            if(result == "ok"){
                layer.msg("修改成功");
                showData(json.pageNum);
            }else{
                layer.msg("修改失败");
            }
        });
    });

    // 删除功能
    $("tbody").on("click",".deleteBtnClass",function () {
        var roleId = $(this).attr("roleId");
        layer.confirm("您确定要删除吗?",{btn:['确定','取消']},function () {
            $.post("${PATH}/role/doDelete",{id:roleId},function (result) {
                if(result == "ok"){
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

