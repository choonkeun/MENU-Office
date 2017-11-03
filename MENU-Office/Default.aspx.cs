using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Browser.Cookies)
        {

            if (Request.Cookies["HOME"] == null)
                Response.Cookies["HOME"]["XMLParsePath"] = @"C:\";
            else
            {
                if (Request.Cookies["HOME"]["XMLParsePath"] != null)
                    Session["XMLParsePath"] = Request.Cookies["HOME"]["XMLParsePath"];
                else
                    Response.Cookies["HOME"]["XMLParsePath"] = @"C:\";
            }
        }
        else
        {
            //not supports the cookies
            //redirect user on specific page
            //for this or show messages
        } 
        
        if (IsPostBack)
        {
            string reqXml = txtXMLData.Text;
            Label1.Text = "This was a post back." + "\r\n" + reqXml;
            //Response.Write(Label1.Text);
        }
        else
        {
            Label1.Text = "This was NOT a post back.";
        }
    }
}