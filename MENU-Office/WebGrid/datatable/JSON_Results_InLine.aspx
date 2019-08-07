<%@ Page title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" AutoEventWireup="true" %>
<%@ Import Namespace="System"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" runat="server">


<!-- https://datatables.net/extensions/colreorder/examples/initialisation/simple.html 
    https://datatables.net/extensions/colreorder/examples/integration/responsive.html
-->
<script src="//code.jquery.com/jquery-3.3.1.js"></script>
<script src="//cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<script src="//cdn.datatables.net/responsive/2.2.3/js/dataTables.responsive.min.js"></script>
<script src="//cdn.datatables.net/colreorder/1.5.1/js/dataTables.colReorder.min.js"></script>
<script type="text/javascript" src="../Scripts/ColReorderWithResize.js"></script>

<link href="//cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" rel="stylesheet" type="text/css" />
<link href="//cdn.datatables.net/colreorder/1.5.1/css/colReorder.dataTables.min.css" rel="stylesheet" type="text/css" />



<script type="text/javascript">

    $.extend(true, $.fn.dataTable.defaults, {
        searching: true,
        paging: true,
        ordering: true,
        colReorder: true,
        responsive: true,
        processing: true,
        "scrollX": true
    });

    var columns = [
        { "data": "customerid" },
        { "data": "customer_last_name" },
        { "data": "customer_first_name" },
        { "data": "customer_birth_date" },
        { "data": "customer_gender" },
        { "data": "customer_address" },
        { "data": "customer_city" },
        { "data": "customer_state" },
        { "data": "customer_zip_code" },
        { "data": "customer_phone_number" },
        { "data": "batchID" }
    ];

    var dataSet = [];
    var table = {};
    $(document).ready(function ()
    {
        table = $('#example').DataTable(
        {
            data: dataSet,
            columns: columns,
            lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
        });

        $('#btnGetData').click(function (e) {          /* type="button" */
            var fd = new FormData();
            var serverValue = $("input[name=optradio]:checked").val();
            fd.append("serverId", serverValue);
            fd.append("batchId", $("#batchId").val());

            Get_LabData(fd);
        });

    });

    function Get_LabData(fd) {
        var uri = "http://localhost/backend_JSON_Results.aspx";
        var xhr = new XMLHttpRequest();
        fd.append("contenttype", 'application/json');
        fd.append("programId", $("#programId").val());

        xhr.open("POST", uri, true);
        xhr.send(fd);

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                //alert(xhr.responseText);      //results display
                var outText = xhr.responseText;                 //JSON format

                table.clear();
                var json_data = JSON.parse(xhr.responseText);   //json_data = array()
                table.rows.add(json_data).draw();

                $('#outText').html(outText);    //results display
                $('#pnJSON').show();
            }
        };
    }

</script>

<input type="hidden" name="action" id="action" value="" /> 
<input type="hidden" name="action" id="programId" value="labdata" /> 

<style>

    fieldset.lab-border {
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

    legend.lab-border {
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
        height: 200px;      //500px;
        box-sizing: border-box;
        border: 2px solid #ddd;
        padding: 10px;
        font-family: 'consolas', 'Courier New';  
        font-size: 12px;   
    }

    
    div.container {
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
<div class="col-md-1"></div>
<div class="col-md-10">
<!--align center -->
  
    <div style="padding-bottom: 10px;"><h2>Lab Results by batchID</h2></div>

    <fieldset class="lab-border">
    <legend class="lab-border">Batch Informations:</legend>
        <div class="row">
            <div class="col-md-2"><button type="button" class="btn btn-primary btn-sm" id="btnGetData">Get Batch_ID Data</button></div>
            <div class="col-md-4"><b>Batch ID:</b> <input type="text" id="batchId" value="126272" /></div>

            <div class="col-md-1"><p style="font-size:24px"><span class="label label-success">server</span></p></div>
            <div class="col-md-5">
                <div class="btn-toolbar">
                <div class="btn-group" data-toggle="buttons">
                  <label class="btn"><input type="radio" name="optradio" value="northtst" />bt2010tst</label>
                  <label class="btn"><input type="radio" name="optradio" value="northqa1" />bt2010qa1</label>
                  <label class="btn"><input type="radio" name="optradio" value="northpr1"  checked="checked" />northpr1</label>
                </div>
                </div>
            </div>

        </div>
    </fieldset>
   
    <div id="pnJSON"  class="container">
        <table id="example" class="display" style="width:100%">
            <thead>
            <tr>
                <th>customerid</th>
                <th>last_name</th>
                <th>first_name</th>
                <th>birth_date</th>
                <th>gender</th>
                <th>address</th>
                <th>city</th>
                <th>state</th>
                <th>zip_code</th>
                <th>phone_number</th>
                <th>batchID</th>
            </tr>
            </thead>
        </table>
    </div>

    <div id="pnTEXT" >
        <div style="float: left;">
            <strong><div id="dataList"></div></strong>
            <div class="panel">
                <textarea id="outText"></textarea>
            </div>
        </div>
    </div>
    
<!--align center -->
</div>
<div class="col-md-1"></div>
</div>

</asp:Content>

<!-- Sample JSON format object
[ 
   { 
      "MONTH":"1",
      "TIME":"15:00",
      "TEXT":"Blah"
   },
   { 
      "MONTH":"1",
      "TIME":"14:21",
      "TEXT":"Blah2"
   },
...
]
-->
