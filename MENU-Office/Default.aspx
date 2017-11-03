<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" 
    AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" runat="server">

<style type="text/css">
	#hint{
		cursor:pointer;
	}
	div.ajaxtooltip{
        color:#000; 
        position: absolute; 
        background-color:#E1E5F1; 
        border:1px solid #667295; padding:4px;
        font: 16px Verdana, sans-serif; 
        width:300px; 
        border-radius: 5px 5px; -moz-border-radius: 5px; -webkit-border-radius: 5px; 
        box-shadow: 5px 5px 5px rgba(0, 0, 0, 0.1); -webkit-box-shadow: 5px 5px rgba(0, 0, 0, 0.1); -moz-box-shadow: 5px 5px rgba(0, 0, 0, 0.1);
	}
    div.ajaxtooltip em {
        font-family: Candara; font-size: 1.4em; font-weight: bold; display: block; 
        /* padding: 0.2em 0 0.6em 0; */
    }
    div.ajaxtooltip small {
        font-family: sans-serif; font-size: 0.7em; font-weight: normal; display: block; 
        padding: 0 0 0.4em 0.5em; /*top,right,bottom,left*/
    }
    .table1 td:hover {
        color:white;
        background-color: black;
    }
</style>

<script type="text/javascript">

        function OMI(fld) {
            $('div.ajaxtooltip').remove();
            //alert(code);
            //alert(col);
            //alert(line);
            var tooltipX = event.pageX - 8;
            var tooltipY = event.pageY + 8;

            var tooltipX = 0;
            var tooltipY = 0;
            if (!e) var e = window.event;
            if (e.pageX || e.pageY) {
              tooltipX = e.pageX;
              tooltipY = e.pageY;
            }
            else if (e.clientX || e.clientY) {
              tooltipX = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
              tooltipY = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
            }
            
            //find current td index number
            var col = $(fld).index();       //or var col = $(fld).parent().children().index($(fld));   
            //alert('Column: ' + col);

            //1st td contents
            var code = $(fld).parent('tr').find("td:first").html();
            //alert(code);
            
            //find current td contents
            //var col01 = $(fld).html()
            //alert(col01);

            var row = $(fld).parent('tr').attr('rownumber');
            var info = "";
            var formData = {tagid:code, col:col, line:row}; 
            // http://localhost/home/driver/tooltipAjax.aspx?tagid=CDRA&col=6&line=1234
            // http://192.168.6.49/Driver/tooltipAjax.aspx - Working
            // http://localhost/home/ggg.html - Working
            $.ajax({
                url: 'http://192.168.6.49/Driver/tooltipAjax.aspx',
                type: 'GET',
                data: formData,
                success: function(data, textStatus, jqXHR) {
                    info = data;
                    $('#AAA').html(data);
                    //alert(info);
                    $(fld).css('background-color', 'black');
                    $(fld).css('color', 'white');
                    $('<div class="ajaxtooltip">'+info+'</div>').appendTo('body');
                    
                    $('div.ajaxtooltip').css({top: tooltipY, left: tooltipX});
                },
                error: function(e) {
                    alert(e);
                //called when there is an error
                //console.log(e.message);
                }
            });

        }
        function OMO(elem) {
            $('div.ajaxtooltip').remove();
            $(elem).css('background-color', 'white');
            $(elem).css('color', 'black');
        }
</script>

    <br />
    <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
    <br />
    <br />
    <p class="lead">Content for Twitter Bootstrap framework with ASP.NET without using NuGet package.</p>

        <asp:Label ID="Label2" runat="server" Text="Label"></asp:Label>
        <asp:TextBox ID="txtXMLData" runat="server"></asp:TextBox>
        <asp:Button ID="Button1" runat="server" Text="Button" AutoPostback="true" />
    <br />
<br />        
<br />
<br />


<table class="table1">
<tr rownumber=5 id=10>
    <td style="width:50px" onmouseover="OMI(this)" onmouseout="OMO(this)">CDRA</td>
    <td style="width:50px" onmouseover="OMI(this)" onmouseout="OMO(this)">000011</td>
    <td style="width:50px" onmouseover="OMI(this)" onmouseout="OMO(this)">02314-</td>
    <td style="width:50px" onmouseover="OMI(this)" onmouseout="OMO(this)">A</td>
    <td style="width:50px" onmouseover="OMI(this)" onmouseout="OMO(this)">ABDI</td>
    <td style="width:50px" onmouseover="OMI(this)" onmouseout="OMO(this)">111111111</td>
</tr></table>                                                                          
<br />        
<br />
<br />
<br />        
<br />
<br />
<br />        
<br />
<br />
<div id="AAA"></DIv>
<br />
<br />

</asp:Content>
