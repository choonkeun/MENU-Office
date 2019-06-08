<%@ Page Language="C#" %>
<%@ Import Namespace="System"  %>
<%@ Import Namespace="System.Collections.Generic"  %>
<%@ Import Namespace="System.Web"  %>
<%@ Import Namespace="System.IO"  %>

<script runat="server">

public partial class UploadFile: System.Web.UI.Page
{
    // http://192.168.6.49/webgrid/UploadFile.aspx
    // http://localhost/home/webgrid/UploadFile.aspx

    public string format = "yyyy-MM-dd HH.mm.ss";
    public string folderPath = @"C:\TEMP\";
    public string logFile = string.Empty;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        logFile = folderPath + "Log.txt";
        HttpPostedFile file = Request.Files["thisfile"];

        if (file != null && file.ContentLength > 0)
        {
            System.Web.HttpRequest httpRequest = System.Web.HttpContext.Current.Request;
            HttpFileCollection uploadFiles = httpRequest.Files;
            List<string> docfiles = new List<string>();
            Boolean canSave;

            if (httpRequest.Files.Count > 0)
            {
                int i;
                for (i = 0; i < uploadFiles.Count; i++)
                {
                    canSave = is_AllowedFileType(uploadFiles[i]);
                    if (canSave)
                    {
                        HttpPostedFile postedFile = uploadFiles[i];
                        string filePath = folderPath + DateTime.Now.ToString(format) + "-" + postedFile.FileName;
                        Append_log("Uploaded:" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " - Success - " + filePath);
                        postedFile.SaveAs(filePath);
                        docfiles.Add(filePath);         // not used, for multiple selection

                        Response.Write(postedFile.FileName);
                    }
                    else
                        Append_log("Verified:" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " - Skipped - " + uploadFiles[i].FileName);

                }
            }
        }
        Response.Write("--- Upload is finished...");
    }

    // file identifire: https://en.wikipedia.org/wiki/List_of_file_signatures
    // byte[] data = { 1, 2, 4, 8, 16, 32 };
    // string hex = BitConverter.ToString(data);
    // Result: 01-02-04-08-10-20

    private Boolean is_AllowedFileType(HttpPostedFile postedFile)
    {
        int idAreaLength = 20;
        int FileLen = postedFile.ContentLength;
        byte[] idArea = new byte[idAreaLength];            //Read first 20 bytes from postedFile

        if (FileLen < 20) return false;
        System.IO.Stream InStream = postedFile.InputStream;
        InStream.Read(idArea, 0, idAreaLength);
        string hex = BitConverter.ToString(idArea).Replace("-", " ");

        if (hex.Substring(0, 17) == "47 49 46 38 37 61" || hex.Substring(0, 17) == "47 49 46 38 39 61")
            return true;    // GIF87a GIF89a
        else if (hex.Substring(0, 11) == "49 49 2A 00" || hex.Substring(0, 17) == "4D 4D 00 2A")
            return true;    // 	Tagged Image File Format: II*. MM.*
        else if (hex.Substring(0, 11) == "25 50 44 46")
            return true;    // 	PDF: 25 50 44 46
        else if (hex.Substring(0, 23) == "89 50 4E 47 0D 0A 1A 0A")
            return true;    // 	PNG-Portable Network Graphics: .PNG....
        else if (hex.Substring(0, 11) == "FF D8 FF DB")
            return true;    // 	JPG: ÿØÿÛ
        else if (hex.Substring(0, 11) == "FF D8 FF E0" || hex.Substring(0, 11) == "FF D8 FF E1")
            return true;    // 	JPEG: ÿØÿà ÿØÿá

        return false;
    }

    private void Append_log(string message)
    {
        using (StreamWriter writer = new StreamWriter(logFile, true))
        {
            writer.WriteLine(message.Replace("\r\n", ""));
        }
    }    

}
    
</script>