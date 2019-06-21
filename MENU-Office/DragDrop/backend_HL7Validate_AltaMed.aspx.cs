using System;
using System.Collections.Generic;
using System.Web;
using System.IO;

public partial class backend_HL7Validate_AltaMed: System.Web.UI.Page
{
    public string format = "yyyy-MM-dd HH.mm.ss";
    public string outText = string.Empty;

    public string savedFolder = @"C:\TEMP\";
    public string folderPath = string.Empty;
    public string logFile = string.Empty;
	
    protected void Page_Load(object sender, EventArgs e)
    {
        folderPath = HttpContext.Current.Server.MapPath("~/Log/");
        logFile = folderPath + "Log.txt";
        Dictionary<string, string> formData = new Dictionary<string, string>();
        Dictionary<string, string> qStrData = new Dictionary<string, string>();
        Dictionary<string, string> fileData = new Dictionary<string, string>();

        //httpRequest.Form
        if (Request.Form.Count > 0)
        {
            foreach (string key in HttpContext.Current.Request.Form.AllKeys)
            {
				if (!formData.ContainsKey(key))
					formData.Add(key, HttpContext.Current.Request.Form[key]);
            }

            foreach (var pair in formData)
            {
                Append_log(string.Format("{0}: {1}={2}", DateTime.Now.ToString(format), pair.Key, pair.Value));
            }

            if (formData.TryGetValue("savedFolder", out savedFolder))
            {
                if (!savedFolder.Trim().EndsWith(@"\"))
                {
                    savedFolder += @"\";
                }
                outText = "savedFolder: " + savedFolder + Environment.NewLine;
            }
        }

        //httpRequest.File
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

                fileData.Add("file " + i.ToString(), postedFile.FileName);

                Boolean status = p.Validate();
                returnString.Add(postedFile.FileName);
                returnString.Add(p.Results + Environment.NewLine);
            }
            outText += Environment.NewLine + string.Join(System.Environment.NewLine, returnString);

            foreach (var pair in fileData)
            {
                Append_log(string.Format("{0}: {1}={2}", DateTime.Now.ToString(format), pair.Key, pair.Value));
            }

            try
            {
                string savedFullFile = savedFolder + DateTime.Now.ToString("yyyy-MM-dd HHmmss") + "_HL7_Validation.txt";
                using (StreamWriter writer = new StreamWriter(savedFullFile, true))
                {
                    writer.WriteLine(outText);
                }
            }
            catch (Exception ex)
            {
                outText = "*** Network Folder file creation has failed ***" + Environment.NewLine + outText;
            }

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
