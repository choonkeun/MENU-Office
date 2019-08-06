<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" 
    AutoEventWireup="true" CodeFile="Datatable.aspx.cs" Inherits="_Datatable" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" runat="server">

<link href="//cdn.datatables.net/colreorder/1.1.0/css/dataTables.colReorder.css" rel="stylesheet" type="text/css" />
<script src="//cdn.datatables.net/colreorder/1.1.0/js/dataTables.colReorder.js"></script>
<link href="//datatables.net/download/build/nightly/jquery.dataTables.css" rel="stylesheet" type="text/css" />
<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
<script src="//datatables.net/download/build/nightly/jquery.dataTables.js"></script>

<script type="text/javascript" src="jqwidgets/colResizable-1.5.min.js"></script>
<script>
    $.extend(true, $.fn.dataTable.defaults, {
        "searching": true,
        "ordering": true
    });

    $(document).ready(function () {
        var table = $('#example').DataTable({
            "ajax": "/WEBGRID/array.txt",
            "initComplete": function () {
                var api = this.api();
                api.$('td').click(function () {
                    api.search(this.innerHTML).draw();
                });
            },
            "lengthMenu": [[5, 10, 25, -1], [5, 10, 25, "All"]],
            "columns": [
                null,
                { "orderSequence": [ "asc" ] },
                { "orderSequence": [ "desc", "asc"] },
                { "orderSequence": [ "desc" ] },
                { "orderSequence": [ "asc" ] },
                null
            ]
        });

        $("#example").colResizable({
            liveDrag:true,
            gripInnerHtml:"<div class='grip'></div>", 
            draggingClass:"dragging",
        });

        $("#set_pos").click(function(){
            var scrol_pos = $("#set_pos").scrollTop();
            $("#set_pos").scrollTop(scrol_pos + 150);
        });

        $('#example tbody').on('click', 'button', function () {
            var data = table.row($(this).parents('tr')).data();
            alert(data[0] + "'s salary is: " + data[5]);
            return false;   // do not postback
        });
    });
</script>
	<div class="container">
		<table id="example" class="display compact"  cellspacing="0" width="100%">
			<thead>
				<tr>
					<th>Name</th>
					<th>Position</th>
					<th>Office</th>
					<th>Age</th>
					<th>Start date</th>
					<th>Salary</th>
				</tr>
			</thead>

		</table>
	</div>

</asp:Content>
