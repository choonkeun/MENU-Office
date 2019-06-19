using System;
using System.Collections.Generic;
using System.Web;
using System.IO;
using System.Web.Script.Serialization;
public partial class backend_HL7Validate_AltaMed: System.Web.UI.Page
{
    public string format = "yyyy-MM-dd HH.mm.ss";
    public string outText = string.Empty;
    public string folderPath = @"C:\TEMP\";
    public string logFile = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        logFile = folderPath + "Log.txt";
        Dictionary<string, string> formData = new Dictionary<string, string>();
        Dictionary<string, string> QStrData = new Dictionary<string, string>();

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

        //HttpPostedFile file = Request.Files[0];

        if (Request.Files.Count > 0)
        {
            List<string> returnString = new List<string>();

            int i;
            for (i = 0; i < Request.Files.Count; i++)
            {
                HttpPostedFile postedFile = Request.Files[i];

                COHL7Validator.HL7Validator p = new COHL7Validator.HL7Validator();
                p.FileName = postedFile.FileName;
                p.FileStream = postedFile.InputStream;

                Boolean status = p.Validate();
                returnString.Add(postedFile.FileName);
                returnString.Add(p.Results + Environment.NewLine);
            }
            outText = string.Join(System.Environment.NewLine, returnString);
            Response.Write(outText);
        }
        else
            Response.Write("--- No file is Uploaded ---");
    }

    private void Append_log(string message)
    {
        using (StreamWriter writer = new StreamWriter(logFile, true))
        {
            writer.WriteLine(message.Replace("\r\n", ""));
        }
    }

}
