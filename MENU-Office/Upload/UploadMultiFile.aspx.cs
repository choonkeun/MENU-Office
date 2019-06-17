using System;
using System.Collections.Generic;
using System.Web;
using System.IO;
using System.Web.Script.Serialization;

public partial class UploadMultiFile: System.Web.UI.Page
{
    // http://192.168.6.49/DragDrop/UploadMultiFile.aspx
    // http://localhost/home/DragDrop/UploadMultiFile.aspx

    public string format = "yyyy-MM-dd HH.mm.ss";
    public string folderPath = @"C:\TEMP\";
    public string logFile = string.Empty;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        logFile = folderPath + "Log.txt";
        Dictionary<string, string> formData = new Dictionary<string, string>();
        Dictionary<string, string> QStrData = new Dictionary<string, string>();

        //httpRequest.InputStream - read InputStream into Byte[]
        System.IO.Stream str = Request.InputStream;
        int strLen = Convert.ToInt32(str.Length);
        byte[] strArr = new byte[strLen];
        int strRead = str.Read(strArr, 0, strLen);      //read into byteArray
        var inStream = System.Text.Encoding.Default.GetString(strArr);
        //var inStream = System.Text.Encoding.UTF8.GetString(strArr);

        //System.IO.StreamReader reader = new System.IO.StreamReader(HttpContext.Current.Request.InputStream);
        //string requestFromPost = reader.ReadToEnd();

        //httpRequest.Form
        if (Request.Form.Count > 0)
        {
            foreach (string key in HttpContext.Current.Request.Form.AllKeys)
            {
                formData.Add(key, HttpContext.Current.Request.Form[key]);
                if (formData.ContainsKey(key))
                {
                    string value = formData[key];
                    Console.WriteLine(value);
                }
            }
            string filePath = folderPath + DateTime.Now.ToString(format) + "-FormData.txt";
            using (StreamWriter writer = new StreamWriter(filePath, true))
            {
                foreach (var pair in formData)
                {
                    writer.WriteLine("{0}={1}", pair.Key, pair.Value);
                }
            }
            Append_log("Uploaded:" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " - Success - " + filePath);
        }

        //httpRequest.QueryString
        if (Request.QueryString.Count > 0)
        {
            foreach (string key in HttpContext.Current.Request.QueryString.AllKeys)
            {
                QStrData.Add(key, HttpContext.Current.Request.QueryString[key]);
            }
        }

        //httpRequest.Files - multiple files
        if (Request.Files.Count > 0)
        {
            //System.Web.HttpRequest httpRequest = System.Web.HttpContext.Current.Request;
            //HttpFileCollection uploadFiles = httpRequest.Files;
            List<postFileResults> docfiles = new List<postFileResults>();

            int i;
            for (i = 0; i < Request.Files.Count; i++)
            {
                HttpPostedFile postedFile = Request.Files[i];
                //HttpPostedFile postedFile = uploadFiles[i];
                string filePath = folderPath + DateTime.Now.ToString(format) + "-" + postedFile.FileName;
                var obj = new postFileResults();
                obj.fileName = postedFile.FileName;

                var fileLen = postedFile.ContentLength;
                byte[] postBytes = new byte[fileLen];
                postedFile.InputStream.Read(postBytes, 0, fileLen);

                try
                {
                    postedFile.SaveAs(filePath);
                    Append_log("Uploaded:" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " - Success - " + filePath);
                    obj.status = "1";
                    docfiles.Add(obj);
                }
                catch (Exception)
                {
                    Append_log("Uploaded:" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " - failed  - " + filePath);
                    obj.status = "0";
                    docfiles.Add(obj);
                }
            }
            var json = new JavaScriptSerializer().Serialize(docfiles);
            Response.Write(json);
        }
        else
            Response.Write("--- No file is Uploaded ---");
    }

    public struct postFileResults
    {
        public String status;
        public String fileName;
    }

    private void Append_log(string message)
    {
        using (StreamWriter writer = new StreamWriter(logFile, true))
        {
            writer.WriteLine(message.Replace("\r\n", ""));
        }
    }    

}