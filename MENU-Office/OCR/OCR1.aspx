<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MasterPage.master" 
    AutoEventWireup="true" CodeFile="OCR1.aspx.cs" Inherits="OCR_OCR1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CPH1" Runat="Server">
    <style> body { height: 100%; } </style>

    <script type="text/javascript">

        var filestable = [];       //filelist to be upload

        $(function () {
            var filesSelected = document.getElementById("inputfiles");

            function validfile(file) {
                var thisfile = file.name;
                var extn = thisfile.substring(thisfile.lastIndexOf('.') + 1).toLowerCase();
                if (extn == "pdf" || extn == "tif" || extn == "png" || extn == "gif" || extn == "jpg" || extn == "jpeg")
                    return true;
                else
                    return false;
            }

            function filterfiles(files) {
                var fileok, idx = 0;
                for (var i = 0, file; file = files[i]; i++) {
                    fileok = validfile(file);
                    if (fileok == true) {
                        $('#filelist').show();
                        idx = filestable.length;
                        filestable.push([true, file]);   // add to array(1 cell has 2 items)
                        displaythumb(file, idx);
                        $('#txtOpenFile').val(file.name);
                    } else {
                        alert("Please select only images");
                    }
                }
            }

            function displaythumb(file, i) {
                //var idx = filestable.length;
                $('#previewPane').empty();
                var span = document.createElement('span');
                var reader = new FileReader();
                reader.onload = (function () {
                    return function (e) {
                        span.innerHTML = ['<img class="thumb" src="', e.target.result, '" title="', file.name, '"/></span>'].join('');
                        $('#previewPane').append(span);
                    };
                })();
                reader.readAsDataURL(file);
            }

            filesSelected.addEventListener("change", function () {
                var files = this.files;
                filterfiles(files);
            }, false);

            //Using drag and drop for selecting
            function dnd_handleFileSelect(evt) {
                evt.stopPropagation();
                evt.preventDefault();

                var files = evt.dataTransfer.files; // FileList object.
                filterfiles(files);
            }

            function handleDragOver(evt) {
                evt.stopPropagation();
                evt.preventDefault();
                evt.dataTransfer.dropEffect = 'copy'; // Explicitly show this is a copy.
            }

            $("#startupload").click(function () {
                var upfilecnt = 0;
                var len = filestable.length;
                for (var i = 0; i < len; i++) {
                    if (filestable[i][0] == true) {
                        uploadFile(filestable[i][1], i);
                        upfilecnt++;
                    }
                }
                $('#fileCnt').html(upfilecnt + " Files are uploaded");
            });

            //var uri = "http://192.168.6.49/WebGrid/UploadFile.aspx";  //remote server
            var uri = "UploadFile.aspx";                                //local server

            function uploadFile(file, i) {
                var xhr = new XMLHttpRequest();
                var formData = new FormData();
                formData.append('thisfile', file);
                xhr.open("POST", uri, true);
                xhr.send(formData);
            }

            var dropZone = document.getElementById('dropzone');
            dropZone.addEventListener('dragover', handleDragOver, false);
            dropZone.addEventListener('drop', dnd_handleFileSelect, false);
        });

        function clickMe() {
            $("#inputfiles").click();
        };

    </script>


    <style type="text/css">
        div.scroll 
        {
            width: 450px;
            height: 500px;
            overflow: auto;
            border: solid 1px lightBlue;
            background-color: white;
            padding: 0px;
            font-family: Consolas, 'Courier New';
            font-size: 16px;
        }
       .thumb {
            margin: 10px;
            width: 410px;
            border: 1px solid #000;
            vertical-align: top;
        }
    </style>

    <asp:Panel ID="pnPager" runat="server">
        <div><h2>OCR - 1 image file</h2></div>

        <div style="padding-top: 20px;">
            <table>
            <tr>
                <td style="height:40px; width:110px;text-align:left;">
                    <!-- html input file -->
                    <input type="file"   id="inputfiles" name="inputfiles" title="Load File" style="display:none" />
                    <button type="button" class="btn btn-primary btn-sm" id="btnOpenFile" style="width:100px;" onclick="clickMe();">Image File</button>
                    <!-- html input file -->
                </td>
                <td>
                    <input id="txtOpenFile" style="width:300px;text-align:left;border: 1px solid lightblue;" />
                </td>
                <td style="height:40px; width:10px;" >
                </td>
                <td>
                    <button type="submit" class="btn btn-success btn-block btn-sm" style="width:100px;">Parse Data</button>
                    <!-- 
                        Bootstrap submit은 항상 Page_Load()를 거치게 되는데 ASP.NET의 Event가 없기 때문에
                        이것을 인식할 방법이 필요하다. 따라서 hidden field를 만들고 거기에 jQuery로 값을 넣어서
                        code로 전달하여 사용하는 방식을 사용한다. $(document).ready(function()을 반드시 사용해야 한다
                     -->
                    <input type="hidden" name="action" id="Hidden1" value="" />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div class="scroll">
                        <div id="previewPane"></div>
                    </div>
                </td>
                <td style="height:40px; width:10px;" >
                </td>
                <td>
                    <div class="scroll">
                        <asp:Literal ID="ParsedText" runat="server"></asp:Literal>
                    </div>
                </td>
            </tr>
            </table>
        </div>
    </asp:Panel>
    <asp:Label ID="lblMessage" runat="server" Text="" AutoSize="true" ></asp:Label>
</asp:Content>
