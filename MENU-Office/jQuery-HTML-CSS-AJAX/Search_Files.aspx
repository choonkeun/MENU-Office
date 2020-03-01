<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" 
    AutoEventWireup="true" CodeFile="Search_Files.aspx.cs" Inherits="Search_Files" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" Runat="Server">

<style type="text/css">
    .button:hover 
    {   
       background-color: White;
       color : #336699;
       font-weight: bold;
    }
    .button 
    {  
       padding-left: 10px;
       padding-right: 10px;
       background-color: #336699;   
       color: white;  
       font-weight: bold;
    }
    .error 
    {   
       background-color: lightyellow;
       color : red;
       /*font-weight: bold;*/
       font-size: 16px;
    } 
    .processing
    {   
       background-color: White;
       color : #336699;
       font-size: 24px;
    } 
</style>

<script src='https://code.jquery.com/jquery-3.3.1.js'></script> 
<script src='https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.31.2/js/jquery.tablesorter.min.js'></script> 
<script> 
    $(document).ready(function() { 
        $('#ThisTable tr').click(function() { 
            $(this).toggleClass('active'); 
        }); 
        $('#ThisTable').tablesorter(); 
    }); 
    
    function ThisFilterFunction() {
        var input, filter, table, tr, td, i, j, cnt, txtValue;
        input = document.getElementById('ThisInput');
        filter = input.value.toUpperCase();
        table = document.getElementById('ThisTable');
        tr = table.getElementsByTagName('tr');
        cnt = 0;
        
        for (i = 0; i < tr.length; i++) {
            for (j = 0; j < tr[i].cells.length; j++) {
                td = tr[i].getElementsByTagName('td')[j];
                if (td) {
                    txtValue = td.textContent || td.innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = '';
                        cnt++;
                        $('#filterMessage').html(cnt.toString() + ' row(s) are selected');
                        break;
                    } else {
                        tr[i].style.display = 'none';
                    }
                }       
            }       
        }
    }
    
    $(window).on('load', function() {
        $('#filterMessage').html('');
        //alert('All assets are all loaded')
    })
    
</script>

<script src="../Scripts/dropdowncontent.js"></script>


    <asp:Panel ID="pnPager" runat="server">
        <div><h2>Search Files<h2></div>

        <div style="padding-right: 20px;height:46px; float:left; vertical-align:top;">
            <asp:Button ID="btnSubmit" runat="server" Text="Search Files" CssClass="button" OnClick="btnSubmit_Click"  />
        </div>
        <div style="padding-right: 10px; height:46px; float:left; vertical-align:top;">
            <a href="search.htm" id="FileNameToolTip" rel="subcontent">File Name</a>: 
            <asp:TextBox ID="FileName"  Width="200px" runat="server" BorderColor="orange" BorderStyle="Solid" BorderWidth="2" placeholder="*.*" text="*.*"></asp:TextBox> 
        </div>
        <div style="padding-right: 10px; height:46px; float:left; vertical-align:top;">
            Search Folder: 
            <asp:TextBox ID="SearchFolder" Width="250px" runat="server" BorderColor="green" BorderStyle="Solid" BorderWidth="2" placeholder="C:\" text="/users/04 kaiser/MediCal/"></asp:TextBox> 
        </div>
        <div style="padding-right: 10px; height:46px;float:left; vertical-align:top;">
            Filter: 
            <asp:DropDownList ID="DDLFilter"  Width="120px" runat="server"  BorderColor="black" BorderStyle="Solid" BorderWidth="1" autopostback="true" OnSelectedIndexChanged="DDLFilter_SelectedIndexChanged">
            <asp:listitem text="" value=""></asp:listitem>
            <asp:listitem text="File Modified" value="DateTime"></asp:listitem>
            <asp:listitem text="FileSize (KB)" value="FileSize"></asp:listitem>
            </asp:DropDownList> 
        </div>
        <div style="padding-right: 10px; height:46px; float:left; vertical-align:top;">
            Filter Value: 
            <asp:TextBox ID="FilterValue"  Width="100px" runat="server" BorderColor="black" BorderStyle="Solid" BorderWidth="1" placeholder=""></asp:TextBox>
        </div>
        
        <asp:Panel ID="pnFILE" runat="server">
            <div id='divFilter' style="padding-right: 10px; float:left; vertical-align:top; " >
                <input type='text' id='ThisInput' size='50'  onkeyup='ThisFilterFunction()' placeholder='Search for any characters...' title='Type in a any characters' />
            </div>
            <div id="filterMessage" ForeColor="red" style="padding-left: 10px; float:left; color:brown; vertical-align:bottom; "></div>
            <br />
            <div style="overflow:scroll; width:100%; height:600px;">
                <asp:Literal ID="ltTable" runat="server"/>
            </div>
            <asp:Label id="message" ForeColor="red" runat="server"  style="padding-right: 10px; float:left; vertical-align:top; " />
        </asp:Panel>
            
        <asp:Panel ID="pnERROR" runat="server">
            <asp:Literal ID="ltMessage" runat="server"/>
        </asp:Panel>
    </asp:Panel>




<!--Drop Down content element -->
<DIV id="subcontent" style="position:absolute; visibility: hidden; background-color: white; width: 750px; padding: 2px; ">
<PRE>
-----------------------------------------------------------------------------------------------------
Folder Search : support Multiple filter with RegEx pattern as below examples (FTP & Network Folder)
-----------------------------------------------------------------------------------------------------
DateFormat: [YYYYMMDD] [YYYY-MM-DD] [YYMMDD] [YY-MM-DD] [MMDDYYYY] [MM-DD-YYYY] [MMDDYY] [MM-DD-YY] 

@: Alpha Only [a-zA-Z]
#: Numeric Only [0-9]
+: AlphaNumeric [0-9a-zA-Z]
.: Any character include special character
*: Any character and Any length
|: or 
(): group            (m|M|o)(c|C) same as [mMo][cC] but [] is not a group
(|): group or group  (mc|oc|xx) --> 'mc' or 'oc' or 'xx'

\/:*?"<>| is not allowed for filename
-----------------------------------------------------------------------------------------------------
Sample: 
    *B*, *.zip, *e.jpg, h*.jpg, AAAAA*.*, *v1*.docx, *con*e.do*, *c*ed.txt
    *icon*(50|24).*, *[YYYYMMDD]*.txt, *[MM/DD/YYYY]*.pptx, *@.*
    (mc|oc|xx)##(adm|ADM|loc|LOC|svc|SVC)*[YYYYMMDD]*.*(txt|csv)*
</PRE>
</DIV>



<script type="text/javascript">
//Call dropdowncontent.init("anchorID", "positionString", glideduration, "revealBehavior") at the end of the page:
dropdowncontent.init("FileNameToolTip", "right-bottom", 300, 'mouseover')
</script>

    
</asp:Content>


