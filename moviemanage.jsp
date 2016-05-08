
<%--
  Created by IntelliJ IDEA.
  User: 53804
  Date: 2015/9/22
  Time: 9:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page isELIgnored="false"%>
<%@ include file="/tagLib.jsp" %>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>
<base href="<%=basePath%>">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>管理</title>
  <link rel="stylesheet" type="text/css" href="css/themes/gray/easyui.css">
  <link rel="stylesheet" type="text/css" href="css/themes/icon.css">
  <script type="text/javascript" src="javascript/easyui/jquery.min.js"></script>
  <script type="text/javascript" src="javascript/easyui/jquery.easyui.min.js"></script>
  <script type="text/javascript" src="javascript/public/pageload.js"></script>
  <style>
    html,body {
      height: 100%;
      margin: 0px;
    }
  </style>
</head>
<body>
<div id="addMovieDialog" class="easyui-dialog" style="padding:10px 20px; width: 846px; height: 408px;"
     closed="true" buttons="#dlg-buttons">
</div>
<div id="${tv}" class="easyui-panel" data-options="border:false, fit:true, noheader:true">
  <table id="${tv}grid" class="easyui-datagrid">
  </table>
    <div id="${tv}tbar" style="padding : 2px 5px;">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addMovie()">添加影片 </a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteRow('${tv}grid')">删除影片</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editMovie('${tv}grid')">修改影片</a>
        <%--<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="saveRow('${tv}grid')">保存操作</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="cancelRow('${tv}grid')">取消操作</a>--%>
        <select id="${tv}srcType" class="easyui-combobox" data-options="prompt:'选择查询类型', value:'', panelHeight:'auto'" style="width:120px" name="method">
            <option value="cnname">影片名称</option>
        </select>
        <input id="${tv}valoneID" name="valone" class="easyui-searchbox" size="30" data-options="prompt:'输入查询内容', searcher:${tv}search">
        <form id="form_file" action="" method="post" enctype="multipart/form-data" style="display: inline">
            <input type="file" name="moviefile" style="width: 170px;" >
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-import" plain="true" onclick="javascript:$('#form_file').submit()">导入</a> 　　     　　　　　
        </form>
        <div id="cata" style="padding:7px 5px;">
            <lable style="font-size: 15px; font-family: 微软雅黑">类别</lable>：<span class="moviecata color">全部</span> <span class="moviecata">动作</span>
            <span class="moviecata">喜剧</span> <span class="moviecata">爱情</span>
            <span class="moviecata">战争</span> <span class="moviecata">恐怖</span>
            <span class="moviecata">犯罪</span> <span class="moviecata">悬疑</span>
            <span class="moviecata">惊悚</span> <span class="moviecata">科幻</span>
            <span class="moviecata">记录</span> <span class="moviecata">剧情</span>
            <span class="moviecata">伦理</span> <span class="moviecata">历史</span>
            <span class="moviecata">动画</span> <span class="moviecata">灾难</span>
        </div>
    </div>
  <script type="text/javascript">
    $(function(){
        $("#fb").filebox({
            buttonText:'选择文件'
        })
        $("#form_file").form({
            url:"importMovieExcelFile",
            onSubmit:function(){
                var isValid = $(this).form('validate');
                var filepath = $("input[name='moviefile']").val();
                var extStart = filepath.lastIndexOf(".");
                var ext = filepath.substring(extStart, filepath.length);
                if(filepath==""||filepath==undefined){
                    isValid = false;
                    $.messager.alert('导入文件错误',"请选择导入的文件",'info');
                }else if (ext != ".xls" && ext != ".xlsx")
                {
                    isValid = false;
                    $.messager.alert('文件格式错误',"请导入正确的excel文件",'info');
                }
                if (!isValid){
                    $.messager.progress('close');	// 当form不合法的时候隐藏工具条

                }
                return isValid;	// 返回false将停止form提交
            },
            success:function(data){
                var msg = eval("("+data+")").Message;
                $.messager.alert("成功",msg,'info');
                $("#${tv}grid").datagrid("reload");

            }
        })
        $("#${tv}grid").datagrid({
            onDelete : ${tv}onGridDel,
            iconCls: 'icon-search',
            singleSelect: true,
            striped: true,
            toolbar: '#${tv}tbar',
            fit: true,
            pagination: true,
            pageSize: 20,
            url: 'getMovie.do',
            columns: [[
                {
                    field: 'cnname',
                    title: '影片名称',
                    align: 'center',
                    width: 200
                },
                {
                    field: 'director',
                    align: 'center',
                    title: '导演',
                    width: 150
                },
                {
                    field: 'mainstar',
                    align: 'center',
                    title: '主演',
                    width: 300
                },
                {
                    field: 'catagory',
                    align: 'center',
                    title: '类别',
                    width: 200
                },
                {
                    field: 'duration',
                    align: 'center',
                    title: '影片时长',
                    width: 200,
                    formatter:function(value,row){
                        return value+"分钟";
                    }
                },
                {
                    field: 'remark',
                    align: 'center',
                    title: '备注',
                    width: 250
                },
                {
                    field: '',
                    title: '选择',
                    width: 150,
                    checkbox: true
                }
            ]],
            view: detailview,
            detailFormatter: function (rowIndex, rowData) {
                return '<table><tr>' +
                        '<td rowspan=2 style="border:0;padding:10px;"><img src="image/upload/movieImages/' + rowData.posters + '" style="height:170px;width:300px;"></td>' +
                        '<td style="font-family:微软雅黑;border:0;padding:40px;width:900px;"><p style="line-height: 0px;">剧情介绍：</p><p style="text-indent: 2em;">' + rowData.plot + '</p>' +
                        '</td>' +
                        '</tr></table>';

            }
        });
    });

    //设置分页控件
    var p = $("#${tv}grid").datagrid("getPager");
    $(p).pagination({
      //pageSize: 10,//每页显示的记录条数，默认为10
      //pageList: [5,10,15],//可以设置每页记录条数的列表
      beforePageText: "第",//页数文本框前显示的汉字
      afterPageText: "页    共 {pages} 页",
      displayMsg: "当前显示 {from} - {to} 条记录   共 {total} 条记录",
      /*onBeforeRefresh:function(){
       $(this).pagination('loading');
       alert('before refresh');
       $(this).pagination('loaded');
       }*/
    });

    ${tv}edr = -1;
    ${tv}edtgrd = null;
    ${tv}acturl = '';

    function ${tv}search(){
        var category;
        $("#cata>span").each(function(){
            if($(this).hasClass("color")){
                category = $(this).text();
            }
        });
        console.info(category);
      $('#${tv}grid').datagrid({
          queryParams:{valtwo : category,method : $('#${tv}srcType').combobox('getValue'), valone : $('#${tv}valoneID').textbox('getValue')}
      })
      $('#${tv}grid').datagrid('load');
    }

    function ${tv}onWndClose(){
      $("#${tv}grid").datagrid("reload");
    }

    function ${tv}boxState(value, row) {
      if (undefined != value && Status[value])
        return Status[value].statusname;
    }
    $("#cata>span").click(function(){
        $(this).addClass('color').siblings().removeClass('color');
        var category = $(this).text();
        console.info(category);
        $('#${tv}grid').datagrid({
            queryParams:{valtwo : category,method : $('#${tv}srcType').combobox('getValue'), valone : $('#${tv}valoneID').textbox('getValue')}
        })
        $('#${tv}grid').datagrid('load');
    })
      function addMovie(){
            /*$('#${tv}'+'addMovieDialog').dialog({*/
            $('#addMovieDialog').dialog({
                title:'添加影片',
                iconCls: 'icon-add',
                href:'addMovieOrEditMovie?recordid='+0,
                width:700,
                height:730,
                closed:false,
                modal:true,
                top:100
            });
      }
    function editMovie(theGrid){
        var datagd=$("#"+theGrid);
        var row = datagd.datagrid("getSelected");
        if(row){
            $('#addMovieDialog').dialog({
                title:'修改影片',
                iconCls: 'icon-edit',
                href:'addMovieOrEditMovie?recordid='+row.recordid,
                width:700,
                height:730,
                closed:false,
                modal:true,
                top:100
            });
        }else{
            $.messager.alert('警告','您还没有选择操作行！');
        }

    }
    function ${tv}onGridDel(row, idx){
        var bRes = false;
        subwindowdata("${tv}grid", "deleteMovie.do?recordid=" + row.recordid, null, function(data){
            bRes = $("input",$(data)).val() == "Success";
            if(bRes == false)
            {
                $.messager.alert("提示", $("span", $(data)).text());
            }
            else

            {
                messageHelper.info("成功", $("span", $(data)).text());
            }
        });
        return bRes;
    }
  </script>
  <script>
       $(function(){
	   });
  </script>
</div>
</body>
</html>
