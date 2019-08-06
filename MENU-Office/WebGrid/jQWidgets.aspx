<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" 
    AutoEventWireup="true" CodeFile="jQWidgets.aspx.cs" Inherits="_jQWidgets" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" runat="server">

<link rel="stylesheet" type="text/css" href="/WebGrid/jqwidgets/styles/jqx.base.css" />
<script type="text/javascript" src="/WebGrid/jqwidgets/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxcore.js"></script>
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxdata.js"></script> 
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxbuttons.js"></script>
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxscrollbar.js"></script>
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxmenu.js"></script>
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxcheckbox.js"></script>
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxlistbox.js"></script>
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxdropdownlist.js"></script>
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxgrid.js"></script>
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxgrid.columnsresize.js"></script>
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxgrid.sort.js"></script> 
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxgrid.pager.js"></script> 
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxgrid.selection.js"></script> 
<script type="text/javascript" src="/WebGrid/jqwidgets/jqxgrid.edit.js"></script> 
<script type="text/javascript" src="/WebGrid/jqwidgets/demos.js"></script>


<script type="text/javascript">
$(document).ready(function () {
    var url = "/WebGrid/sampledata/products.xml";
    // prepare the data
    var source =
    {
        datatype: "xml",
        datafields: [
            { name: 'ProductName', type: 'string' },
            { name: 'QuantityPerUnit', type: 'int' },
            { name: 'UnitPrice', type: 'float' },
            { name: 'UnitsInStock', type: 'float' },
            { name: 'Discontinued', type: 'bool' }
        ],
        root: "Products",
        record: "Product",
        id: 'ProductID',
        url: url
    };
    var cellsrenderer = function (row, columnfield, value, defaulthtml, columnproperties, rowdata) {
        if (value < 20) {
            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #ff0000;">' + value + '</span>';
        }
        else {
            return '<span style="margin: 4px; float: ' + columnproperties.cellsalign + '; color: #008000;">' + value + '</span>';
        }
    }
    var dataAdapter = new $.jqx.dataAdapter(source, {
        downloadComplete: function (data, status, xhr) { },
        loadComplete: function (data) { },
        loadError: function (xhr, status, error) { }
    });
    // initialize jqxGrid
    $("#jqxgrid").jqxGrid(
    {
        width: 850,
        source: dataAdapter,   
        columnsresize: true,        
        pageable: true,
        autoheight: true,
        sortable: true,
        altrows: true,
        enabletooltips: true,
        editable: true,
        selectionmode: 'multiplecellsadvanced',
        columns: [
          { text: 'Product Name',       columngroup: 'ProductDetails', datafield: 'ProductName', width: 250 },
          { text: 'Quantity per Unit',  columngroup: 'ProductDetails', datafield: 'QuantityPerUnit', cellsalign: 'right', align: 'right', width: 200 },
          { text: 'Unit Price',         columngroup: 'ProductDetails', datafield: 'UnitPrice', align: 'right', cellsalign: 'right', cellsformat: 'c2', width: 200 },
          { text: 'Units In Stock',                                    datafield: 'UnitsInStock', cellsalign: 'right', cellsrenderer: cellsrenderer, width: 100 },
          { text: 'Discontinued',                                      columntype: 'checkbox', datafield: 'Discontinued' }
        ],
        columngroups: [
            { text: 'Product Details', align: 'center', name: 'ProductDetails' }
        ]
    });
    // trigger the column resized event.
    $("#jqxgrid").on('columnresized', function (event) {
        var column = event.args.columntext;
        var newwidth = event.args.newwidth
        var oldwidth = event.args.oldwidth;
        $("#eventlog").text("Column: " + column + ", " + "New Width: " + newwidth + ", Old Width: " + oldwidth);
    });
            
});
</script>

    <div id='jqxWidget' style="margin-top: 30px; font-size: 13px; font-family: Verdana; float: left;">
        <div id="jqxgrid"></div>
        <div style="margin-top: 30px;" id="eventlog"></div>
     </div>

</asp:Content>
