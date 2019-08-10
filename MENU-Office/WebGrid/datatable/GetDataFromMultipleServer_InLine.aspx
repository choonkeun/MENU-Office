<%@ Page title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" AutoEventWireup="true" %>
<%@ Import Namespace="System"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" runat="server">


<!-- https://datatables.net/extensions/colreorder/examples/initialisation/simple.html 
    https://datatables.net/extensions/colreorder/examples/integration/responsive.html
<script src="//cdn.datatables.net/responsive/2.2.3/js/dataTables.responsive.min.js"></script>
<script src="//cdn.datatables.net/colreorder/1.5.1/js/dataTables.colReorder.min.js"></script>
<script type="text/javascript" src="../Scripts/ColReorderWithResize.js"></script> 
-->

<script src="//code.jquery.com/jquery-3.3.1.js"></script>
<script src="//cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<link href="//cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" rel="stylesheet" type="text/css" />
<link href="//cdn.datatables.net/colreorder/1.5.1/css/colReorder.dataTables.min.css" rel="stylesheet" type="text/css" />



<script type="text/javascript">

    $.extend(true, $.fn.dataTable.defaults, {
        searching: true,
        paging: true,
        ordering: false,
        colReorder: false,
        responsive: false,
        processing: true,
        "scrollX": true
    });

    var columns_Adventure = [
        { "data": "BusinessEntityID",       title : "BusinessEntityID" },
        { "data": "Title",                  title : "Title" },
        { "data": "FirstName",              title : "FirstName" },
        { "data": "MiddleName",             title : "MiddleName" },
        { "data": "LastName",               title : "LastName" },
        { "data": "Suffix",                 title : "Suffix" },
        { "data": "JobTitle",               title : "JobTitle" },
        { "data": "PhoneNumber",            title : "PhoneNumber" },
        { "data": "PhoneNumberType",        title : "PhoneNumberType" },
        { "data": "EmailAddress",           title : "EmailAddress" },
        { "data": "EmailPromotion",         title : "EmailPromotion" },
        { "data": "AddressLine1",           title : "AddressLine1" },
        { "data": "AddressLine2",           title : "AddressLine2" },
        { "data": "City",                   title : "City" },
        { "data": "StateProvinceName",      title : "State"  },
        { "data": "PostalCode",             title : "PostalCode" },
        { "data": "CountryRegionName",      title : "CountryRegionName" },
        { "data": "AdditionalContactInfo",  title : "AdditionalContactInfo" }
    ];                               
                                     
    var columns_NorthWind = [         
         { "data": "CustomerID",        title :  "CustomerID" },           
         { "data": "CompanyName",       title :  'Company'  },
         { "data": "ContactName",       title :  "ContactName" },
         { "data": "ContactTitle",      title :  "ContactTitle" },
         { "data": "Address",           title :  "Address" },
         { "data": "City",              title :  "City" },
         { "data": "Region",            title :  "Region" },
         { "data": "PostalCode",        title :  "PostalCode" },
         { "data": "Country",           title :  "Country" },
         { "data": "Phone",             title :  "Phone" },
         { "data": "Fax",               title :  "Fax" }
    ];
    
    $(document).ready(function ()
    {
        $('#inputValue').on("keypress", function(e) {
            if (e.keyCode == 13) {
                $('#btnGetData').click(); 
                return false; // prevent the button click from happening
            }
        });

        $('#btnGetData').click(function (e) {          /* type="button" */
            var fd = new FormData();
            fd.append("inputValue", $("#inputValue").val());

            var serverValue = $("input[name=optradio]:checked").val();
            fd.append("serverId", serverValue);

            switch (serverValue) {
                case 'AdventureWorks':
                    fd.append("databaseId", 'Adventure2014');
                    table_Initialization(columns_Adventure);
                    Get_Database(fd);
                    break;
                    
                case 'NorthWind':
                    fd.append("databaseId", 'North2012');
                    table_Initialization(columns_NorthWind);
                    Get_Database(fd);
                    break;
            }
        });

    });

    function table_Initialization(sourceCols) {
        // https://datatables.net/forums/discussion/44956/how-to-destroy-and-reinitialize-the-datatable
        // https://jsfiddle.net/cr78t379/3/
        //$('#example').DataTable().clear().destroy();      //must destroy before create
        
        if ( $.fn.DataTable.isDataTable( '#example' ) ) {
            $('#example').DataTable().clear().destroy();    //remove rows
            $('#example').empty();                          //remove column information
        };

        var table = $('#example').DataTable(
        {
            destroy : true,
            sort    : true,
            cache   : true,
            scrollX : true,
            //order : [ 2, 'asc' ],
            dom     : 'T<"clear">lfrtip',
            lengthMenu    : [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
            displayLength : 5,
            
            data    : null,
            columns : sourceCols
        });
    }

    function Get_Database(fd) {
        $('#pnJSON').hide();

        var uri = "http://webhome/dataTable/backend_GetDatabase_ReturnJSON.aspx";
        //var uri = "http://localhost/dataTable/backend_GetDatabase_ReturnJSON.aspx";
        var xhr = new XMLHttpRequest();
        fd.append("programId", 'multiple');
        fd.append("contenttype", 'application/json');

        xhr.open("POST", uri, true);
        xhr.send(fd);

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                var outText = xhr.responseText;

                if (outText.length > 0)
                {
                    var json_data = JSON.parse(xhr.responseText);
                    $('#example').DataTable().clear().rows.add(json_data).draw();

                    $('#pnJSON').show();
                }

                $('#outText').html(outText);    //results display
                //$('#pnTEXT').show();
            }
        };
    }

</script>

<input type="hidden" name="action" id="action" value="" /> 
<input type="hidden" name="action" id="programId" value="multiple" /> 
<input type="hidden" name="action" id="databaseId" value="" /> 

<style>

    fieldset.hl7-border {
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

    legend.hl7-border {
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

    th, td { white-space: nowrap; }
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
    #pnTITLE{ display:none; }
    
</style>


<div class="row">
<div class="col-md-1"></div>
<div class="col-md-10">
<!--align center -->
  
    <div style="padding-bottom: 10px;"><h2>Get Data From Multiple Server</h2></div>

    <fieldset class="hl7-border">
    <legend class="hl7-border">Batch Informations:</legend>
        <div class="row">
            <div class="col-md-2"><button type="button" class="btn btn-primary btn-sm" id="btnGetData">Get Batch_ID Data</button></div>
            <div class="col-md-4"><b>input Value:</b> <input type="text" id="inputValue" value="a" pattern="[a-zA-Z0-9]{15}" /></div>
            <!--<div class="col-md-4"><b>input Value:</b> <input type="number" id="inputValue" value="126272" pattern="[0-9]{7}" /></div> -->

            <div class="col-md-1"><p style="font-size:24px"><span class="label label-success">server</span></p></div>
            <div class="col-md-5">
                <div class="btn-toolbar">
                <div class="btn-group" data-toggle="buttons">
                  <label class="btn"><input type="radio" name="optradio" value="Pubs" />Pubs</label>
                  <label class="btn"><input type="radio" name="optradio" value="NorthWind" />NorthWind</label>
                  <label class="btn"><input type="radio" name="optradio" value="AdventureWorks" checked="checked" />AdventureWorks</label>
                </div>
                </div>
            </div>

        </div>
    </fieldset>
   
    <div id="pnJSON"  class="container">
        <table id="example" class="display" style="width:100%"></table>
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
<div class="col-md-1"></div>
</div>

</asp:Content>

