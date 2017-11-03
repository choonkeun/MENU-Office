using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class OCR_OCR1 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            string action = Request.Form["action"];
            switch (action)
            {
                case "clearbody":
                    lblMessage.Text = "";
                    break;

                case "loadimage":
                    //btnOpenDRV();
                    break;

                case "submit":
                    if (ParsedText.Text.Trim().Length > 0)
                    {
                        //Do_Driver_Parse();
                        //DynTable.Text = parsedText;         //html table tag
                    }
                    break;
            }
        }
        else
        {
            //pnHTML.Visible = false;
        }
    }
}