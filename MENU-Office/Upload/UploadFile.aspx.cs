using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

public partial class UploadFile: System.Web.UI.Page
{

    //   http://192.168.6.49/webgrid/UploadFile.aspx
    // http://localhost/home/webgrid/UploadFile.aspx
    // http://localhost:1082/webgrid/UploadFile.aspx
    protected void Page_Load(object sender, EventArgs e)
    {
        HttpPostedFile file = Request.Files["thisfile"];
        //check file was submitted
        if (file != null && file.ContentLength > 0)
        {
            var httpRequest = System.Web.HttpContext.Current.Request;
            HttpFileCollection uploadFiles = httpRequest.Files;
            var docfiles = new List<string>();      // not used, for multiple selection

            if (httpRequest.Files.Count > 0)
            {
                int i;
                for (i = 0; i < uploadFiles.Count; i++)
                {
                    HttpPostedFile postedFile = uploadFiles[i];         //postedFile.FileName: 'C:\Program Files (x86)\IIS Express\BGC.xml'
                    var filePath = @"C:\TEMP\" + postedFile.FileName;   //Make server file path & location
                    postedFile.SaveAs(filePath);                        //upload file from client pc to server location
                    docfiles.Add(filePath);         // not used, for multiple selection
                    Response.Write(postedFile.FileName);
                }
            }
        }
        Response.Write("--- Upload is finished...");
    }

}