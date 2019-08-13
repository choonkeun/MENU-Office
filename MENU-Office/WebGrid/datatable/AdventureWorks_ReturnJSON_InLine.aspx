<%@ Page title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" AutoEventWireup="true" %>
<%@ Import Namespace="System"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" runat="server">

<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<link href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" rel="stylesheet" type="text/css" />
<script src="https://cdn.datatables.net/fixedcolumns/3.2.6/js/dataTables.fixedColumns.min.js"></script>


<script type="text/javascript">

    $.extend(true, $.fn.dataTable.defaults, {
        searching: true,
        paging: true,
        ordering: true,
        colReorder: false,
        responsive: false,
        processing: true,
        "scrollX": true
    });

    var columns_Adventure = [
        { "data": "BusinessEntityID" },
        { "data": "Title" },
        { "data": "FirstName" },
        { "data": "MiddleName" },
        { "data": "LastName" },
        { "data": "Suffix" },
        { "data": "JobTitle" },
        { "data": "PhoneNumber" },
        { "data": "PhoneNumberType" },
        { "data": "EmailAddress" },
        { "data": "EmailPromotion" },
        { "data": "AddressLine1" },
        { "data": "AddressLine2" },
        { "data": "City" },
        { "data": "StateProvinceName" },
        { "data": "PostalCode" },
        { "data": "CountryRegionName" },
        { "data": "AdditionalContactInfo" }
    ];

    var dataSet = [];   
    var table = {};

    $(document).ready(function ()
    {
        //html이 최초에 load되었을때 한번만 setup을 한 다음 계속 사용한다
        table = $('#example').DataTable(
        {
            data: dataSet,
            lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
            columns: columns_Adventure,
            fixedColumns: {
                leftColumns: 2
            }
        });

        $('#inputValue').on("keypress", function(e) {
            if (e.keyCode == 13) {
                $('#btnGetData').click(); 
                return false; // prevent the button click from happening
            }
        });

        //input text에 값이 들어올때마다 table.row를 clear하고 다시 draw()한다
        $('#btnGetData').click(function (e) {          /* type="button" */

            setTimeout(function() {
                $.fn.dataTable.tables( { visible: true, api: true } )
                .columns.adjust().fixedColumns().relayout();
            }, 200);

            var fd = new FormData();
            fd.append("inputValue", $("#inputValue").val());
            var serverValue = $("input[name=optradio]:checked").val();
            fd.append("serverId", serverValue);

            Get_Database(fd);
        });
    });

    function Get_Database(fd) {
        $('#pnJSON').hide();

        //var uri = "http://webhome/dataTable/backend_GetDatabase_ReturnJSON.aspx";
        var uri = "http://localhost/dataTable/backend_GetDatabase_ReturnJSON.aspx";
        var xhr = new XMLHttpRequest();
        fd.append("contenttype", 'application/json');
        fd.append("programId", 'Adventure');
        fd.append("databaseId", 'Adventure2014');

        xhr.open("POST", uri, true);
        xhr.send(fd);

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                //alert(xhr.responseText);      //results display
                var outText = xhr.responseText;

                table.clear();
                if (outText.length > 0)
                {
                    var json_data = JSON.parse(xhr.responseText);
                    table.rows.add(json_data).draw();

                    $('#pnJSON').show();
                }

                $('#outText').html(outText);    //results display
                //$('#pnTEXT').show();
            }
        };
    }

</script>

<input type="hidden" name="action" id="action" value="" /> 

<style>

    fieldset.dt-border {
        border: 1px solid #ddd !important;
        /*padding: 0 10px 10px 10px;*/
        padding-top: 0px;
        padding-left: 20px;
        padding-bottom: 10px;
        margin: 0 0 1.5em 0 !important;
        border-radius: 8px;
        -webkit-box-shadow:  0px 0px 0px 0px #000;
                box-shadow:  0px 0px 0px 0px #000;
    }

    legend.dt-border {
        font-size: 1.2em !important;
        font-weight: bold !important;
        text-align: left !important;
        width:auto;
        padding:0 10px;
        border-bottom:none;
    }

    .panel textarea {
        display: block;
        width: 950px;
        height: 200px;      /*500px;*/
        box-sizing: border-box;
        border: 2px solid #ddd;
        padding: 10px;
        font-family: 'consolas', 'Courier New';  
        font-size: 12px;   
    }

    th, td { white-space: nowrap; }
    div.gridview {
        width: 100%;
    }
    
    div.dataTables_wrapper {
        width: 100%;
        margin: 0 auto;
    }
    
    div.DTCR_pointer {
        margin-left: -10px;
        width: 0;
        height: 0 !important;
        border-style: solid;
        border-width: 10px 10px 0 10px;
        border-color: #0259c4 transparent transparent transparent;
        background: transparent;
    }

    #pnJSON{ display:none; }
    #pnTEXT{ display:none; }
    
</style>


<div class="row">
<!--align center -->
  
    <div style="padding-bottom: 10px;"><h2>AdventureWorks</h2></div>

    <fieldset class="dt-border">
    <legend class="dt-border">Batch Informations:</legend>
        <div class="row">
            <div class="col-md-2"><button type="button" class="btn btn-primary btn-sm" id="btnGetData">Get Batch_ID Data</button></div>
            <div class="col-md-4"><b>input Value:</b> <input type="text" id="inputValue" value="a" pattern="[a-zA-Z0-9]{15}" /></div>

            <div class="col-md-1"><p style="font-size:24px"><span class="label label-success">server</span></p></div>
            <div class="col-md-5">
                <div class="btn-toolbar">
                <div class="btn-group" data-toggle="buttons">
                  <label class="btn"><input type="radio" name="optradio" value="Develop" />Develop</label>
                  <label class="btn"><input type="radio" name="optradio" value="Quality" />Quality</label>
                  <label class="btn"><input type="radio" name="optradio" value="Production" checked="checked" />Production</label>
                </div>
                </div>
            </div>

        </div>
    </fieldset>
   
    <div id="pnJSON"  class="gridview">
        <table id="example" class="display" style="width:100%">
            <thead>
            <tr>
               <th>EntityID</th>
               <th>Title</th>
               <th>FirstName</th>
               <th>MiddleName</th>
               <th>LastName</th>
               <th>Suffix</th>
               <th>JobTitle</th>
               <th>PhoneNumber</th>
               <th>PhoneNumberType</th>
               <th>EmailAddress</th>
               <th>EmailPromotion</th>
               <th>AddressLine1</th>
               <th>AddressLine2</th>
               <th>City</th>
               <th>StateProvinceName</th>
               <th>PostalCode</th>
               <th>CountryRegionName</th>
               <th>AdditionalContactInfo</th>
            </tr>
            </thead>   
        </table>
    </div>

    <div id="pnTEXT" >
        <br />
        <div style="float: left;">
            <strong><div id="dataList"></div></strong>
            <div class="panel">
                <textarea id="outText"></textarea>
            </div>
        </div>
    </div>
    
<!--align center -->
</div>

</asp:Content>

