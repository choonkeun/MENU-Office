<%@ Page Language="C#" %>
<%@ Import Namespace="System"  %>
<%@ Import Namespace="System.IO"  %>
<%@ Import Namespace="System.Collections.Generic"  %>
<%@ Import Namespace="System.Linq"  %>
<%@ Import Namespace="System.Web"  %>
<%@ Import Namespace="System.Web.UI"  %>
<%@ Import Namespace="System.Web.UI.WebControls"  %>
<%@ Import Namespace="System.Drawing"  %>

<%@ Import Namespace="System.Xml"  %>
<%@ Import Namespace="System.Xml.Xsl"  %>
<%@ Import Namespace="System.Xml.XPath"  %>
<%@ Import Namespace="System.Threading"  %>

<script runat="server">

public partial class HL7Validate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            string action = Request.Form["action"];
            if (action == "clearbody") txtXMLData.Text = "";
            if (action == "loadfile") 
                btnOpenHL7();
            else
                if (action == "submit" && txtXMLData.Text.Trim().Length > 0) Do_XMLParse();
        }
        else
        {
            pnHTML.Visible = false;
        }
    }

    protected void btnOpenHL7()
    {
        HttpPostedFile file = Request.Files["file"];
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

                    //way 1
                    //var filePath = @"C:\TEMP\" + postedFile.FileName;   //Make server file path & location
                    //postedFile.SaveAs(filePath);                        //upload file from client pc to server location
                    //txtXMLData.Text = File.ReadAllText(filePath);       //read from file from server  
                    //txtOpenFile.Text = postedFile.FileName;
                    //docfiles.Add(filePath);         // not used, for multiple selection
                    //File.Delete(filePath);

                    //way 2
                    using (StreamReader sr = new StreamReader(postedFile.InputStream))
                    {
                        String line = sr.ReadToEnd();
                        txtXMLData.Text = line;
                    }
                }
            }
        }
    }

    private void Do_XMLParse()
    {
        string xmloutput = String.Empty;
        xmloutput = txtXMLData.Text;

        System.Xml.XmlDocument oDoc = new System.Xml.XmlDocument();
        try
        {
            oDoc.LoadXml(xmloutput);
            txtXMLData.Text = "";
            display_node(oDoc.ChildNodes, -4);
        }
        catch (Exception ex)
        {
            txtOpenFile.Text = ex.Message;
        }

        pnPager.Visible = false;
        pnHTML.Visible = true;
        using (StreamWriter writer = new StreamWriter(Server.MapPath("~/") + @"\XML\XMLParse.txt"))
        {
            writer.Write(txtXMLData.Text);
        }

    }

    private void display_node(System.Xml.XmlNodeList Nodes, int Indent)
    {
        Indent += 4;    //Insert space left to make indent

        foreach (System.Xml.XmlNode xNode in Nodes)
        {
            if (xNode.NodeType == XmlNodeType.Element || xNode.NodeType == XmlNodeType.Text)
            {
                if (xNode.NodeType == XmlNodeType.Element)
                {
                    txtXMLData.Text += System.Environment.NewLine;
                    txtXMLData.Text += new String(' ', Indent);
                    txtXMLData.Text += xNode.Name + ": ";
                    if (xNode.Attributes.Count > 0)
                    {
                        for (int i = 0; i < xNode.Attributes.Count; i++)
                        {
                            txtXMLData.Text += xNode.Attributes[i].Name + "=" + xNode.Attributes[i].Value + " ";
                            if (i != xNode.Attributes.Count - 1)
                                txtXMLData.Text += ", ";
                        }
                    }
                }
                txtXMLData.Text += string.IsNullOrEmpty(xNode.Value) ? "" : xNode.Value;
            }
            if (xNode.HasChildNodes)
            {
                display_node(xNode.ChildNodes, Indent);
            }
        }
        
    }

}
    
</script>
