<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" 
    AutoEventWireup="true" CodeFile="DragDrop1.aspx.cs" Inherits="_DragDrop1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" runat="server">


<script type="text/javascript">

    $(document).ready(function () {
        $('input:file').change( function(e) {
            var f = e.target.files, len = f.length;
            for (var i=0;i<len;i++) {
                var n = f[i].name,
                s = f[i].size,
                t = f[i].type;
                sendFile(f[i]);
            }
        });
    });    

    var fnames = [];

    function sendFile(file) {
        var uri = "http://localhost/DragDrop/UploadImageFile.aspx";
        var xhr = new XMLHttpRequest();
        var fd = new FormData();

        xhr.open("POST", uri, true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                // Handle response.
                alert(xhr.responseText); // handle response.
                var fname = xhr.responseText + '<br />';
                fnames.push(fname);
                $('#fileList').html(fnames);
            }
        };
        fd.append('thisfile', file);
        // Initiate a multipart/form-data upload
        xhr.send(fd);
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

            var filesArray = event.dataTransfer.files;
            for (var i = 0; i < filesArray.length; i++) {
                //alert(filesArray[i].name);
                sendFile(filesArray[i]);
            }
            $('#fileList').text("aaa");
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
        width:500px; 
        height:300px; 
        line-height: 300px; /* <-- this is what you must define */
    }
    #dropzone.hover { background-color: lightgreen; border: 2px dotted gray; width:500px; height:300px; margin:30px; }
    ul
    {
        list-style-type: none;
    }
</style>

    <!-- html input file -->
    <input type="file"   id="file" name="file" multiple="" style="display:none" />
    <button type="button" class="btn btn-primary btn-sm" id="btnOpenFile" style="width:100px;" onclick="clickMe();">Choose File</button>
    <input type="hidden" name="action" id="action" value="" />
    <!-- html input file -->

    <br />
    <div style="float: left;">
        <div id="dropzone">
            <strong>Drag & drop your file here...</strong>
        </div>
    </div>
    <div style="float: left; margin-left: 10px;">
      <div id="fileList">
      </div>
    </div>

    <asp:Literal ID="DynTable" runat="server"></asp:Literal>
   
</asp:Content>
