<%@ Page title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" AutoEventWireup="true" %>
<%@ Import Namespace="System"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" runat="server">

<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<link href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" rel="stylesheet" type="text/css" />
<script src="https://cdn.datatables.net/fixedcolumns/3.2.6/js/dataTables.fixedColumns.min.js"></script>

<script src="https://cdn.datatables.net/plug-ins/1.10.19/dataRender/ellipsis.js"></script>


<script type="text/javascript">

//https://jsfiddle.net/jf2jx3mr/1/

    $.extend(true, $.fn.dataTable.defaults, {
        searching: true,
        paging: true,
        processing: true,
        "scrollX": true
    });

    var columns_Adventure = [
        { "data": "BusinessEntityID",       title : "EntityID" },
        { "data": "Title",                  title : "Title" },
        { "data": "FirstName",              title : "FirstName" },
        { "data": "MiddleName",             title : "MiddleName" },
        { "data": "LastName",               title : "LastName" },
        { "data": "Suffix",                 title : "Suffix" },
        { "data": "JobTitle",               title : "JobTitle" },
        { "data": "PhoneNumber",            title : "PhoneNumber"},             //column rendering
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
    
    //https://datatables.net/blog/2016-02-26
    //columnDefs:
    var columns_Definition = [
        //{ targets: [0, 1], "width": "20%", render: $.fn.dataTable.render.ellipsis(20, false, true) },
        //{ targets: 2, "width": "33%", render: $.fn.dataTable.render.ellipsis(40, false, true) },
        //{ targets: 3, "width": "16%", render: $.fn.dataTable.render.moment( 'Do MMM YYYYY' ) },
        //{ targets: 4, "width": "11%", render: $.fn.dataTable.render.number(',', '.', 0) },
        
        //1. Ellipsis with tooltip
        { targets:6, render: function (data, type, row) { 
                                  return type === 'display' && data.length > 10 ? '<span data-toggle="tooltip" title="' + data + '">' + data.substr( 0, 20 )+ '</span>' : data;
                             }
        },
        //2. Display Format: input: 123-456-1234 --> (123) 456-1234
        { targets:7, render: function (data, type, row) { 
                                var cleaned = data.replace(/[^\d]/g, "");   //remain only digits
                                //way 1: return cleaned.replace(/(\d{3})(\d{3})(\d{4})/, "($1) $2-$3");
                                //way 2:
                                var match = cleaned.match(/^(1|)?(\d{3})(\d{3})(\d{4})$/)
                                if (match) {
                                  var intlCode = (match[1] ? '+1 ' : '')
                                  return [intlCode, '(', match[2], ') ', match[3], '-', match[4]].join('')
                                }
                                return null;
                             }
        },
        //{ targets: 9, "width": "33%", render: $.fn.dataTable.render.ellipsis(20, false, true) },    //working
        { targets:9, render: function (data, type, row) { 
                                //return type === 'display' && data.length > 10 ? data.substr( 0, 20 ) +'…' : data;     //ellipsis only without tooltip
                                  return type === 'display' && data.length > 10 ? '<span data-toggle="tooltip" title="' + data + '">' + data.substr( 0, 20 )+ '</span>' : data;
                             }
        }
      
      
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
                    var table = table_Initialization(columns_Adventure);
                    Get_Database(fd, table);
                    break;
                    
                case 'NorthWind':
                    fd.append("databaseId", 'North2012');
                    var table = table_Initialization(columns_NorthWind);
                    Get_Database(fd, table);
                    break;
            }
        });

    });

    function table_Initialization(sourceCols) {
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
            //scrollCollapse: true,
            //dom: 'T<"clear">lfrtip',
            //order: [ 0, 'asc' ],
            
            lengthMenu    : [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
            displayLength : 5,
            
            data    : null,
            columns : sourceCols,
            fixedColumns: {
                leftColumns: 1
            },
            
            aoColumnDefs: columns_Definition    //column rendering
        });
        //$('.dataTables_filter').remove();  --> remove "$search: ....... above title of the table"
        
        setTimeout(function() {
            $.fn.dataTable.tables( { visible: true, api: true } )
            .columns.adjust().fixedColumns().relayout();
        }, 200);

        return table;
    }

    function Get_Database(fd, table) {
        $('#pnJSON').hide();

        //var uri = "http://webhome/dataTable/backend_GetDatabase_ReturnJSON.aspx";
        var uri = "http://localhost/dataTable/backend_GetDatabase_ReturnJSON.aspx";
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
                    
                    //tooltip display for ellipsis()
                    $( '#example' ).on('draw.dt', function () {
                        $('[data-toggle="tooltip"]').tooltip();
                    });

                    
                    $( '#example' ).off("click", "td").on("click", "tbody td", function () {
                        var col = this.cellIndex;               //$(this).parent().children().index($(this));
                        var row = $(this).parent().parent().children().index($(this).parent());
                        var textvalue = this.innerText;         //innerHTML: <span data-toggle="tooltip" title="Production Technician - WC60">Production Technicia</span>
                        //alert('Row: ' + row + ', Column: ' + col + ', value: ' + textvalue);
                        
                        $('#example').DataTable().search(this.innerText).draw();
                    });
      
                    //table.initComplete = Build_Filter(table);
                    
                    $('#pnJSON').show();
                }
                                
                $('#outText').html(outText);    //results display
                //$('#pnTEXT').show();
            }
        };
    }

    
    // https://jsfiddle.net/cr78t379/3/
    // data should exist before 'build filter'
    
    function Build_Filter (table) {
        var rows = 1;
        
        table.columns().every( function () {
            var column = this;
            $('#' + rows).remove();
            var select = $("<br /><select id=" + rows + "><option value=''></option></select>")
                .appendTo( $(column.header()))
                .on( 'change', function () {
                    var val = $.fn.dataTable.util.escapeRegex(
                        $(this).val()
                    );
                    column.search( val ? '^'+val+'$' : '', true, false ).draw();
                });

            column.data().unique().sort().each( function ( d, j ) {
                select.append( '<option value="'+d+'">'+d+'</option>' )
            });

            rows = rows + 1;
        });
        table.columns().draw();
    }
    
</script>

<input type="hidden" name="action" id="action" value="" /> 
<input type="hidden" name="action" id="programId" value="filterTitle" /> 
<input type="hidden" name="action" id="databaseId" value="" /> 

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
        height: 200px;      //500px;
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
    
    /* Font Size */
    //th { font-size: 14px; }
    //td { font-size: 12px; }
    //tr td {height:12px; border:1px solid red;}
   
    
    
    
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
  
    <div style="padding-bottom: 10px;"><h2>Data Field Rendering - display format & ellipsis with tooltip</h2></div>

    <fieldset class="dt-border">
    <legend class="dt-border">Batch Informations:</legend>
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
   
    <div id="pnJSON"  class="gridview">
        <table id="example" class="display" style="width:100%" cellspacing="0"></table>
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

