<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" 
    AutoEventWireup="true" CodeFile="PQGrid2.aspx.cs" Inherits="_PQGrid2" %>

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

        function pqDatePicker(ui) {
            var $this = $(this);
            $this
                .css({ zIndex: 3, position: "relative" })
                .datepicker({
                    yearRange: "-5:+0", //5 years prior to present.
                    changeYear: true,
                    changeMonth: true,
                    dateFormat : 'yy-mm-dd',    //2016-01-01
                    defaultDate: new Date(),
                    //showButtonPanel: true,
                    onClose: function (evt, ui) {
                        $(this).focus();        // press tab key after keyboard type or click date on calenda
                    }
                });
            //default date
            $this.filter(".pq-from").datepicker("option", "defaultDate", new Date("2010-01-01"));
        };

        var colM = [
            { title: "RepId",    width:  50, dataType: "integer",  dataIndx: "UsrRepId" },
            { title: "Type",     width:  80, dataType: "string",   dataIndx: "UsrRepType",
                filter: { type: "select",
                                condition: 'equal',
                                prepend: { '': '--Select--' },
                                valueIndx: "UsrRepType", labelIndx: "UsrRepType",
                                listeners: ['change']
                        }
            },
            { title: "MsgCode",  width:  60, dataType: "integer",  dataIndx: "TPA_ResMsgCode", align: "center" },
            { title: "Status",   width:  60, dataType: "integer",  dataIndx: "RepStatus" , align: "center" },
            { title: "Company",  width: 200, dataType: "string",   dataIndx: "Company",
                filter: { type: "select",
                                condition: 'equal',
                                prepend: { '': '--Select--' },
                                valueIndx: "Company", labelIndx: "Company",
                                listeners: ['change']
                        }
            },
            { title: "Creation Date",   width: 110, dataType: "string",   dataIndx: "RepCreated", align: "center",
                //filter: { type: 'textbox', condition: 'begin', listeners: ['keyup'] }
                filter: { type: 'textbox', condition: "begin", init: pqDatePicker, listeners: ['change'] }
            },
            { title: "SSN",             width: 90, dataType: "string",   dataIndx: "SSN", align: "center",
                render: function (ui) {
                    var cellData = ui.rowData[ui.dataIndx];
                    var s1 = cellData.substring(0, 3);
                    var s2 = cellData.substring(3, 5);
                    var s3 = cellData.substring(5, 9);
                    var s4 = s1 + '-' + s2 + '-' + s3;
                    return s4;
                }
            },
            { title: "Driver Name",     width: 120, dataType: "string",   dataIndx: "DriverName"  },
            { title: "UserId",          width:  60, dataType: "integer",  dataIndx: "UserId", align: "center" },
            { title: "User Name",       width: 100, dataType: "string",   dataIndx: "UserName"  },
            { title: "User EMail",      width: 150, dataType: "string",   dataIndx: "UserEMail" },
            { title: "Notes",           width:  10, dataType: "string",   dataIndx: "Notes",   hidden: true },
            { title: "MsgCode",         width:  10, dataType: "string",   dataIndx: "MsgCode", hidden: true }
        ];
        
        var dataModel = {
            location: "local",
            sorting: "local",            
            sortIndx: "RepCreated",
            sortDir: "down"
        };
        
        var obj = {
            title: "Shipping Orders",
            width: 1200, height: 460,
            dataModel: dataModel,
            colModel: colM,
            freezeCols: 4,
            pageModel: { type: "local", rPP: 15, rPPOptions: [10, 15, 20, 50, 100] },
            flexHeight: true,
            wrap: false,
            hwrap: false,
            showBottom: false,
            editable: false,
            selectionModel: { mode: 'single' },
            //selectionModel: { type: 'cell' },
            filterModel: { on: true, mode: "AND", header: true },
            scrollModel: { horizontal: true },
            resizable: true,
            draggable: true,
            columnBorders: true
        };
        obj.width = 1100;
        obj.height = 460;
        obj.title = "UsrReport Table";
        obj.showBottom = true;
        //obj.collapsible = false;
        
        var $grid = $("#grid_array").pqGrid(obj);   // Create dataModel
        
        //load all data at once
        $grid.pqGrid("showLoading");
        $.ajax({
            url: "/webgrid/UsrReportStatus.aspx",
            headers: { 'driverfact': 'PQGrid' },
            cache: false,
            async: true,
            dataType: "JSON",
            success: function (response) {
                $grid.pqGrid("option", "dataModel.data", response.data);
                
                //UsrRepType
                var column = $grid.pqGrid("getColumn", { dataIndx: "UsrRepType" });
                var filter = column.filter;
                filter.cache = null;
                filter.options = $grid.pqGrid("getData", { dataIndx: ["UsrRepType"] });
                
                //Company
                var column = $grid.pqGrid("getColumn", { dataIndx: "Company" });
                var filter = column.filter;
                filter.cache = null;
                filter.options = $grid.pqGrid("getData", { dataIndx: ["Company"] });

                $grid.pqGrid("refreshDataAndView");
                $grid.pqGrid("hideLoading");
            }
        });
       
        //Popup Display: notes
        $( "#grid_array" ).on( "pqgridcellclick", function( event, ui ) {
            var repid = ui.rowData["UsrRepId"].toString();
            var username = ui.rowData["UserName"];
            if (ui.rowData["Notes"].length > 0 && ui.colIndx == 0)
            {
                $("#noteTable").html(ui.rowData["Notes"]);
                $("#popup-dialog1").dialog({ width:'600px', title: "Notes (" + repid + ": " + username + ")"
                }).dialog("open");
            }
        });
        
        //Popup Display: TPA_MsgCode
        $( "#grid_array" ).on( "pqgridcellclick", function( event, ui ) {
            var repid = ui.rowData["UsrRepId"].toString();
            var username = ui.rowData["UserName"];
            if (ui.rowData["MsgCode"].length > 0 && ui.colIndx > 0)
            {
                $("#msgTable").html(ui.rowData["MsgCode"]);
                $("#popup-dialog2").dialog({ width:'600px', title: "MsgCode (" + repid + ": " + username + ")"
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

<div id="popup-dialog1" style="display:none;">
    <div id="noteTable">
</div>

<div id="popup-dialog2" style="display:none; background-color:#F6DFDD">
    <div id="msgTable">
</div>

</asp:Content>
