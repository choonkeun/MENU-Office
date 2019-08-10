<script type="text/javascript">
    function clickMe() {
        $("#file").click();
    };
    $(document).ready(function () {
        $('input:file').change(function (e) {
            var files = e.target.files, len = files.length;
            var fd = new FormData();
            for (var i = 0; i < len; i++) {
                var f = files[i];
                fd.append("files", f);
            }
            sendFile(fd);
        });
    });    
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
    
    function sendFile(fd) {
        var uri = "http://localhost/backend_Validator.aspx";
        var xhr = new XMLHttpRequest();
        fd.append("savedFolder", $('#savedFolder').val());
        xhr.open("POST", uri, true);
        xhr.send(fd);
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                //alert(xhr.responseText);      //results display
                var outText = xhr.responseText;
                
                //download to download folder
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
