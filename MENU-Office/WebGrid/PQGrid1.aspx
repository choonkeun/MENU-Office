<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" 
    AutoEventWireup="true" CodeFile="PQGrid1.aspx.cs" Inherits="_PQGrid1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" runat="server">

<!--jQuery dependencies-->
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/themes/base/jquery-ui.css" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>    
    <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.2/jquery-ui.min.js"></script>
<!--PQ Grid files-->
    <link rel="stylesheet" href="pqgrid/pqgrid.min.css" />
    <script src="pqgrid/pqgrid.min.js"></script>
<!--PQ Grid Office theme-->
    <link rel="stylesheet" href="pqgrid/pqgrid.css" />
    
<style>
    .pq-select-text{
        max-height:20px;
    }
    
</style>

<script>
    $(function () {

        var colM = [
            { title: "RepId",           width:  50, dataType: "integer",  dataIndx: "UsrRepId" },
            { title: "Report Type",     width:  80, dataType: "string",   dataIndx: "UsrRepType"  },
            { title: "Company",         width: 200, dataType: "string",   dataIndx: "Company" },
            { title: "Creation Date",   width: 120, dataType: "string",   dataIndx: "RepCreated", align: "center" },
            //{ title: "Creation Date",   width: 100, dataType: "date",     dataIndx: "RepCreated", align: "center", 
            //    render: function (ui) {
            //        var cellData = ui.rowData[ui.dataIndx];
            //            cellData = ui.rowData.RepCreated;
            //        var dateValue = parseInt(cellData.replace(/\/Date\((\d+)\)\//g, "$1"));
            //        var newDate = JSON.parse(JSON.stringify(new Date(dateValue)));
            //        var dateStr = newDate.replace(/T/g, " ");
            //        var newTime = dateStr.substring(11, 19);
            //            newTime = dateStr.substring(0, 16);
            //        return dateStr;
            //        //$.datepicker.formatDate('yymmdd', new Date());
            //        if (dateValue) {
            //            // Convert JSON DateTime e.g. /Date(2176326711)/ to yyyy-mm-dd format
            //            // The datepicker's formatDate() method does not have any option to format time
            //            return $.datepicker.formatDate('dd/mm/yy', new Date(dateValue)) + " " + newTime;
            //            //return $datetimepicker({ dateFormat: "yy-mm-dd", timeFormat: "hh:mm:ss" }, new Date(dateValue));
            //        }
            //    }
            //},
//JSON.parse(JSON.stringify(new Date(1400009760000)));
//-->"2014-05-13T19:36:00.000Z"
//new Date(1400009760000)
//-->Fri Dec 14 2012 06:42:32 GMT-0800 (Pacific Standard Time)

            { title: "SSN",             width: 100, dataType: "string",   dataIndx: "SSN", align: "center",
                render: function (ui) {
                    var cellData = ui.rowData[ui.dataIndx];
                    var s1 = cellData.substring(0, 3);
                    var s2 = cellData.substring(3, 5);
                    var s3 = cellData.substring(5, 9);
                    var s4 = s1 + '-' + s2 + '-' + s3;
                    return s4;
                }
            },
            { title: "Driver Name",     width: 150, dataType: "string",   dataIndx: "DriverName"  },
            { title: "UserId",          width:  60, dataType: "integer",  dataIndx: "UserId", align: "center" },
            { title: "User Name",       width: 150, dataType: "string",   dataIndx: "UserName"  },
            { title: "User EMail",      width: 150, dataType: "string",   dataIndx: "UserEMail" },
            { title: "TPA_MsgCode",     width: 100, dataType: "integer",  dataIndx: "TPA_ResMsgCode", align: "center" },
            { title: "RepStatus",       width:  80, dataType: "integer",  dataIndx: "RepStatus" , align: "center" },
            { title: "Notes",           width: 160, dataType: "string",   dataIndx: "Notes", hidden: true }
        ];
        
        var dataModel = {
            recIndx: "RepCreated",
            location: "remote",
            sorting: "local",            
            dataType: "JSON",
            method: "GET",
            sortIndx: "RepCreated",
            sortDir: "up",
            url: "/webgrid/UsrReportStatus.aspx",
                getData: function (dataJSON) {                
                    return { data: dataJSON.data };
                }
        };
        
        var obj = {
            title: "Shipping Orders",
            width: 900, height: 460,
            dataModel: dataModel,
            colModel: colM,
            freezeCols: 2,
            pageModel: { type: "local", rPP: 15, rPPOptions: [10, 15, 20, 50, 100] },
            flexHeight: true,
            //flexWidth: true,
            wrap: false,
            hwrap: false,
            showBottom: false,
            editable: false,
            selectionModel: { mode: 'single' },
            //selectionModel: { type: 'cell' },
            scrollModel: { horizontal: true },
            resizable: true,
            draggable: true,
            columnBorders: true
        };
        obj.width = 840;
        obj.height = 460;
        obj.title = "UsrReport Table";
        obj.showBottom = true;
        //obj.collapsible = false;
        
        var $grid = $("#grid_array").pqGrid(obj);   // Create dataModel
        
        $( "#grid_array" ).on( "pqgridcellclick", function( event, ui ) {
            //alert("rowData: " + ui.rowData["UsrRepId"]);        //220
            //alert("dataIndx: " + ui.dataIndx);                  //"RepCreated"
            //alert("rowData: " + ui.rowData[ui.dataIndx]);       //220
            //alert("rowIndx: " + ui.rowIndx);                    //
            var repid = ui.rowData["UsrRepId"].toString();
            if (ui.rowData["Notes"].length > 0)
            {
                $("#noteTable").html(ui.rowData["Notes"]);
                //document.getElementById("noteTable").innerHTML = ui.rowData["Notes"];
                
                $("#popup-dialog").dialog({ width:'600px', title: "Notes (" + (ui.rowIndx + 1) + ")"
                }).dialog("open");
            }
        });
        
    });
    
</script>    

<div id="grid_array" style="margin:20px auto;"></div>

<style>
    .tdformat{
        text-align: center;
        width: 100px;
        border: 1px solid #993300;
        background-color:#D7E4F2;
        font-size:12px;
        padding:5px;
    }
    .number{
        text-align: center;
        border: 1px solid #993300;
        background-color:#D7E4F2;
        font-size:12px;
        padding:10px;
    }
    .notes{
        text-align: left;
        border: 1px solid #993300;
        background-color:#D7E4F2;
        font-size:12px;
        padding:5px;
    }
</style>

<div id="popup-dialog" style="display:none;">

    <div id="noteTable"></div>
    
</asp:Content>
