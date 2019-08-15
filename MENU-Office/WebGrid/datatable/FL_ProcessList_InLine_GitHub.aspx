<%@ Page title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" AutoEventWireup="true" %>
<%@ Import Namespace="System"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" runat="server">

<script src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<link href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" rel="stylesheet" type="text/css" />
<script src="https://cdn.datatables.net/fixedcolumns/3.2.6/js/dataTables.fixedColumns.min.js"></script>

<script src="https://cdn.datatables.net/plug-ins/1.10.19/dataRender/ellipsis.js"></script>
<script src="../Scripts/moment.min.js"></script>

<script type="text/javascript">

//https://datatables.net/examples/api/row_details.html - Parent/Child Grid
//https://jsfiddle.net/jf2jx3mr/1/

    $.extend(true, $.fn.dataTable.defaults, {
        searching: true,
        paging: true,
        language: { search: '', searchPlaceholder: "Search..." },
        processing: true,
        "scrollX": true
    });

    var columns_Scheduler = [
        { "data": "procID",                   title : "procID" },
        { "data": "procName",                 title : "procName" },
        { "data": "procDescription",          title : "procDescription" },
        { "data": "procCreatedOn",            title : "procCreatedOn" },
        { "data": "procCreatedBy",            title : "procCreatedBy" },
        { "data": "procActive",               title : "procActive" },
        { "data": "procPriority",             title : "procPriority" },
        { "data": "taskID",                   title : "taskID" },
        { "data": "taskName",                 title : "taskName" },
        { "data": "taskDescription",          title : "taskDescription" },
        { "data": "taskActive",               title : "taskActive" },
        { "data": "taskDateAdded",            title : "taskDateAdded" },
        { "data": "taskIndex",                title : "taskIndex" },
        { "data": "ID",                       title : "ID" },
        { "data": "PropertyName",             title : "PropertyName" },
        { "data": "PropertyType",             title : "PropertyType" },
        { "data": "PropertyValue",            title : "PropertyValue" }
    ];                               
    
    //https://datatables.net/blog/2016-02-26
    //columnDefs:
    var columns_Definition = [
        //1. Ellipsis with tooltip
        { targets:1, render: function (data, type, row) { 
                                  return type === 'display' && data != null && data.length > 30 ? '<span data-toggle="tooltip" title="' + data + '">' + data.substr( 0, 30 )+ '</span>' : data;
                             }
        },
        { targets:2, render: function (data, type, row) { 
                                  return type === 'display' && data != null && data.length > 30 ? '<span data-toggle="tooltip" title="' + data + '">' + data.substr( 0, 30 )+ '</span>' : data;
                             }
        },
        //2. Date Format: input: 2011-09-27T15:38:50.69 --> 2011-09-27 15:38:50
        { targets:3, render: function (data, type, row) { 
                                var date = new Date(data);
                                return moment(date).format('YYYY-MM-DD HH:mm:ss');
                             }
        }
        //3. Display Format: input: 123-456-1234 --> (123) 456-1234
        //{ targets:7, render: function (data, type, row) { 
        //                        var cleaned = data.replace(/[^\d]/g, "");   //remain only digits
        //                        //way 1: return cleaned.replace(/(\d{3})(\d{3})(\d{4})/, "($1) $2-$3");
        //                        //way 2:
        //                        var match = cleaned.match(/^(1|)?(\d{3})(\d{3})(\d{4})$/)
        //                        if (match) {
        //                          var intlCode = (match[1] ? '+1 ' : '')
        //                          return [intlCode, '(', match[2], ') ', match[3], '-', match[4]].join('')
        //                        }
        //                        return null;
        //                     }
        //},
        //{ targets:9, render: function (data, type, row) { 
        //                        //return type === 'display' && data.length > 10 ? data.substr( 0, 20 ) +'…' : data;     //ellipsis only without tooltip
        //                          return type === 'display' && data.length > 10 ? '<span data-toggle="tooltip" title="' + data + '">' + data.substr( 0, 20 )+ '</span>' : data;
        //                     }
        //}
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
                case 'SERVERPROD':
                    fd.append("databaseId", 'AdvrntureWorks');
                    break;
                    
                case 'SERVERQA':
                    fd.append("databaseId", 'NorthWind');
                    break;
                    
                case 'SERVERDEV':
                    fd.append("databaseId", 'Pubs');
                    break;
            }
            
            var table = table_Initialization(columns_Scheduler);
            Get_Database(fd, table);
    
        });

    });

    function table_Initialization(sourceCols) {
        
        if ( $.fn.DataTable.isDataTable( '#example' ) ) {
            $('#example').DataTable().clear().destroy();    //remove rows
            $('#example').empty();                          //remove column information
        };

        var oldValue = 0;
        var evenColor = true;
            
        var table = $('#example').DataTable(
        {
            destroy : true,
            sort    : true,
            cache   : true,
            scrollX : true,
            
            aoColumnDefs: columns_Definition,    //column rendering
            
            //scrollCollapse: true,
            //dom: 'T<"clear">lfrtip',
            
            lengthMenu    : [[5, 10, 15, 25, 50, -1], [5, 10, 15, 25, 50, "All"]],
            displayLength : 15,         //compact display
            
            //--no paging
            //paging  : false,        //more loading time because load all data to the browser - very slow and large memory usage
            //scrollY : "400px",
            //--no paging

            data    : null,
            columns : sourceCols,
            fixedColumns: {
                leftColumns: 2
            },
            
            rowCallback: function(row, data, index) {
                if(data.prcActive.toString().toLowerCase() == 'true'){
                    $(row).find('td:eq(5)').css('color', 'blue').css('font-weight', 'bold');
                }
                if(data.prcPriority < 3){
                    $(row).find('td:eq(11)').css('color', 'red').css('font-weight', 'bold');    //$('td', row).eq(5).addClass('highlight');
                }

                //---row group backColor
                if (oldValue != data.prcID) {
                    evenColor = !evenColor;
                    oldValue = data.prcID;
                }
                if (evenColor) {
                    //$('td', row).eq(0).addClass('WhiteSmoke');       //td.highlight WhiteSmoke oldlace
                    $(row).css('background-color', '#fff' );
                } else {
                    //$('td', row).eq(0).addClass('oldlace');           //td.highlight WhiteSmoke oldlace
                    $(row).css('background-color', 'WhiteSmoke' );
                }
                //---row group backColor
            },


        });
        //$('.dataTables_filter').remove();  --> remove "$search: ....... above title of the table"
        
        //reflesh/redraw() head and title after finished loading
        setTimeout(function() {
            $.fn.dataTable.tables( { visible: true, api: true } )
            .columns.adjust().fixedColumns().relayout();
        }, 500);

        return table;
    }

    function Get_Database(fd, table) {
        $('#pnJSON').hide();

        var uri = "http://webhome/dataTable/backend_GetDatabase_ReturnJSON.aspx";
        var xhr = new XMLHttpRequest();
        fd.append("programId", 'processlist');
        fd.append("contenttype", 'application/json');

        xhr.open("POST", uri, true);
        xhr.send(fd);

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                var outText = xhr.responseText;

                if (outText.length > 0)
                {
                    var table = $('#example').DataTable();
                    
                    var json_data = JSON.parse(xhr.responseText);
                    table.clear().rows.add(json_data).draw();
                    
                    $( '#example' ).off("dblclick", "td").on("dblclick", "tbody td", function () {
                        var col = this.cellIndex;               //$(this).parent().children().index($(this));
                        var row = $(this).parent().parent().children().index($(this).parent());
                        var textvalue = this.innerText;         //innerHTML: <span data-toggle="tooltip" title="Production Technician">Production Technicia</span>
                        //alert('Row: ' + row + ', Column: ' + col + ', value: ' + textvalue);
                        
                        table.search(this.innerText).draw();
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
<input type="hidden" name="action" id="programId" value="processlist" /> 
<input type="hidden" name="action" id="databaseId" value="NorthWind" /> 

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

    div.gridview {
        width: 100%;
    }
    th, td { white-space: nowrap; }

    td.highlight {
        font-weight: bold;
        color: blue;
    }
    .highlight { background-color: lightblue; }     //not working if you use display at '#example'
    
    //#example .selecting { background: #FECA40; }
    //#example .selected  { background: #F39814; color: white; }

    /* Font Size */
    //th { font-size: 14px; }
    //td { font-size: 8px; }
    //tr td {height:8px; border:1px solid red;}

    /* http://jsfiddle.net/dq2bmgd9/ */
    /* Change the filter input Style of Datatable */
    #example_filter input {
        width: 250px;
        font-size: 14px;
        padding: 2px;
        border-radius: 2px;
        
        border-top-style: groove;
        border-right-style: hidden;
        border-left-style: hidden;
        border-bottom-style: groove;
        background-color: WhiteSmoke;    //#eee;
    }
    /* add clear text 'x' mark*/
    input[type=search]::-webkit-search-cancel-button {
        -webkit-appearance: searchfield-cancel-button;
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
  
    <div style="padding-bottom: 10px;"><h2>Process List</h2></div>

    <fieldset class="dt-border">
    <legend class="dt-border">Process Informations:</legend>
        <div class="row">
            <div class="col-md-2"><button type="button" class="btn btn-primary btn-sm" id="btnGetData">Get Process List</button></div>
            <div class="col-md-4"><b>input Value:</b> <input type="text" id="inputValue" value="lexis" pattern="[a-zA-Z0-9]{15}" /></div>
            <!--<div class="col-md-4"><b>input Value:</b> <input type="number" id="inputValue" value="126272" pattern="[0-9]{7}" /></div> -->

            <div class="col-md-1"><p style="font-size:24px"><span class="label label-success">server</span></p></div>
            <div class="col-md-5">
                <div class="btn-toolbar">
                <div class="btn-group" data-toggle="buttons">
                  <label class="btn"><input type="radio" name="optradio" value="SERVERDEV" />SERVERDEV</label>
                  <label class="btn"><input type="radio" name="optradio" value="SERVERQA" />SERVERQA</label>
                  <label class="btn active""><input type="radio" name="optradio" value="SERVERPROD" checked="checked" />SERVERPROD</label>
                </div>
                </div>
            </div>

        </div>
    </fieldset>
   
    <div id="pnJSON"  class="gridview">
        <table id="example" class="cell-border compact" style="width:100%" cellspacing="0"></table>         <!--"display compact cell-border"-->
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

