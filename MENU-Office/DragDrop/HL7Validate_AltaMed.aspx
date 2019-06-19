<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" 
    AutoEventWireup="true" CodeFile="HL7Validate_AltaMed.aspx.cs" Inherits="HL7Validate_AltaMed" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" runat="server">


<script type="text/javascript">

    $(document).ready(function () {
        $('input:file').change(function (e) {
            var f = e.target.files, len = f.length;
            var fd = new FormData();
            fd.append("files", f);
            sendFile(fd);
            //for (var i=0;i<len;i++) {
            //    var n = f[i].name,
            //    s = f[i].size,
            //    t = f[i].type;
            //    sendFile(f[i]);
            //}
        });
    });    

    function sendFile(fd) {
        var uri = "http://localhost/EDI/backend_HL7Validate_AltaMed.aspx";
        var xhr = new XMLHttpRequest();

        fd.append("targetFolder", "ANY PERSON");

        xhr.open("POST", uri, true);
        xhr.send(fd);

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                //alert(xhr.responseText);      //results display
                var outText = xhr.responseText;

                var blob = new Blob([xhr.responseText]);
                var link = document.createElement('a');
                link.href = window.URL.createObjectURL(blob);

                link.download = file.name + ".out";
                link.style.display = 'none';
                document.body.appendChild(link);
                link.click();

                $('#outText').html(outText);    //results display
                $('#dragdrop').hide();
                $('#pnTEXT').show();
            }
        };
    }

    function clickMe() {
        $("#file").click();
    };

    window.onload = function () {
        var dropzone = document.getElementById("dropzone");
        dropzone.ondragover = dropzone.ondragenter = function (event) {
            event.stopPropagation();
            event.preventDefault();
        }

        dropzone.ondrop = function (event) {
            event.stopPropagation();
            event.preventDefault();

            var fd = new FormData();
            var files = event.dataTransfer.files;
            for (var i = 0, f; f = files[i]; i++) {
                fd.append("files", f);
            }
            sendFile(fd);
        }
    }
</script>

<style>
    #dropzone       
    { 
        margin-top: 5px;
        text-align: center;
        vertical-align: middle;
        background-color: white;      
        border: 2px dotted gray; 
        border-radius: 10px;
        width:900px; 
        height:300px; 
        line-height: 300px; /* <-- this is what you must define */
    }
    #dropzone.hover { background-color: lightgreen; border: 2px dotted gray; width:900px; height:300px; margin:30px; }
    ul
    {
        list-style-type: none;
    }
</style>

<input type="hidden" name="action" id="action" value="" /> 


<asp:Panel ID="pnPager" runat="server">
    <div><h2>HL7 Validate - AltaMed</h2></div>
    
    <div class="container" style="padding-left: 40px;">
      <h4>- HL7 Folder locations </h4>
      <ul class="list-group">
        <li class="list-group-item col-sm-10">/users/69 altamed/incoming/ <span class="badge">incoming FTP folder</span></li>
        <li class="list-group-item col-sm-10">CO_AltaMed_HL7_05232019_01_batID=122177,_ftpID=2;.txt  <span class="badge">sample file name</span></li>
        <li class="list-group-item col-sm-10">\\bt2010pr1\Integration\Inbox\Data\ <span class="badge">drop folder</span></li>
        <li class="list-group-item col-sm-10">\\bt2010pr1\Integration\Inbox\Archive\2019\06\CO_AltaMed_HL7_05232019_01_batID=122177,_ftpID=2;.txt <span class="badge">archive folder</span></li>
      </ul>
    </div>

    <div id="dragdrop">
        <div style="padding-top: 20px; padding-left: 40px;">
            <table>
            <tr>
                <td style="height:20px; width:110px;text-align:left;">
                    <!-- html input file -->
                    <input type="file" multiple="multiple" id="file" name="file" title="Load File" style="display:none" />
                    <button type="button" class="btn btn-primary btn-sm" id="btnOpenFile" style="width:100px;" onclick="clickMe();">Open HL7 File</button>
                    <!-- html input file -->
                </td>
            </tr>
            </table>
        </div>

        <div style="float: left; padding-left: 40px;">
            <div id="dropzone">
                <strong>Drag & drop your file here...</strong>
            </div>
        </div>
    </div>
</asp:Panel>

<style>
    #pnTEXT{ display:none; }
<!––
    .panel {
        width: 920px;
        height: 200px;
        border: 1px solid #000;
        box-sizing: border-box;
        padding: 10px;
    }
-->
    .panel textarea {
        display: block;
        width: 920px;
        height: 200px;
        box-sizing: border-box;
        padding: 10px;
        font-family: 'consolas', 'Courier New';  
        font-size: 12px;   
    }
</style>

<div id="pnTEXT" >
    <br />
    <br />
    <div style="float: left; margin-left: 40px;">
        <strong><div id="fileList"></div></strong>
        <div class="panel">
            <textarea id="outText"></textarea>
        </div>
    </div>
</div>

</asp:Content>
