using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Collections.Generic;

using ExtensionMethods;

public partial class Search_Files : System.Web.UI.Page
{
    private Boolean hasException = false;
    private string errorMessage = string.Empty;
    
    private string FILE_ROOT = "C:\\";
    private string[] FILE_FILTERS = new string[] { };
    private DateTime FILE_DATE = DateTime.MinValue;
    private int FILE_SIZE = -1;

    private string ddlFilter = string.Empty;
    private string filterValue = string.Empty;

    private List<NewFileInfo> listFiles = new List<NewFileInfo>();
    public struct NewFileInfo
    {
        public string FullName;
        public string Name;
        public DateTime LastWriteTime;
        public long Length;
    };

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            pnFILE.Visible = false;
            pnERROR.Visible = false;
            FilterValue.Text = DateTime.Now.ToString("yyyy-MM-dd");
        }
    }

    protected void DDLFilter_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlFilter = DDLFilter.SelectedItem.Value.ToLower();
        filterValue = FilterValue.Text.Trim();
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        //btnSubmit.BackColor = System.Drawing.Color.LightCyan;
        message.Text = String.Empty;

        ddlFilter = DDLFilter.SelectedItem.Value.ToLower();
        filterValue = FilterValue.Text.Trim();
        FileName.Text = FileName.Text.Trim().Length > 0 ? FileName.Text.Trim() : "*.*";
        SearchFolder.Text = SearchFolder.Text.Trim().Length > 0 ? SearchFolder.Text.Trim() : @"C:\";
        SearchFolder.Text = SearchFolder.Text.Replace(@"G:", @"\\optima\group");

        if (ddlFilter == "datetime" && ddlFilter.Length > 0 && filterValue.Length > 0)
        {
            FILE_DATE = DateTime.Parse(filterValue);
        }
        else if (ddlFilter == "filesize" && ddlFilter.Length > 0 && filterValue.Length > 0)
        {
            int.TryParse(filterValue, out FILE_SIZE);
            FILE_SIZE *= 1000;
        }

        FILE_ROOT = SearchFolder.Text;

        if (SearchFolder.Text.Substring(0,6).ToLower() == "/users")
        {
            FILE_FILTERS = FileNameFilter.Build_FilterPattern(FileName.Text);

            FtpFilter.SearchFolderBegin(FILE_ROOT, FILE_FILTERS, FILE_DATE, FILE_SIZE);

            if (!FtpFilter.hasException && FtpFilter.SessionStatus)
            {
                foreach (var row in FtpFilter.listFiles)
                {
                    NewFileInfo nf = new NewFileInfo();
                    nf.FullName = row.FullName;
                    nf.Name = row.Name;
                    nf.LastWriteTime = row.LastWriteTime;
                    nf.Length = row.Length;
                    listFiles.Add(nf);
                }
            }
            else
            {
                hasException = true;
                errorMessage = FtpFilter.ExceptionMessage;
            }
        }
        else
        {
            message.Text = FILE_ROOT;
            
            if (!Directory.Exists(FILE_ROOT))
            {
                message.Text = "Folder does not exist";
            }

            FILE_FILTERS = FileNameFilter.Build_FilterPattern(FileName.Text);

            FileFilter.SearchFolderBegin(FILE_ROOT, FILE_FILTERS, FILE_DATE, FILE_SIZE);

            if (!FileFilter.hasException)
            {
                foreach (var row in FileFilter.listFiles)
                {
                    NewFileInfo nf = new NewFileInfo();
                    nf.FullName = row.FullName;
                    nf.Name = row.Name;
                    nf.LastWriteTime = row.LastWriteTime;
                    nf.Length = row.Length;
                    listFiles.Add(nf);
                }
            }
            else
            {
                hasException = true;
                errorMessage = FileFilter.ExceptionMessage;
            }

        }


        if (!hasException && FILE_ROOT.Length > 0 && FILE_FILTERS.Length > 0)
        {
            pnFILE.Visible = true;
            pnERROR.Visible = false;

            if (listFiles.Count > 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("<style>");
                //sb.Append("th { font-size: 12px; }");
                //sb.Append("td { font-size: 12px; }");
                //sb.Append("tr td { height:12px; }");
                //sb.Append("th, tr, td { white-space: nowrap; }");
                sb.Append("tr.active td { background-color: #8fc3f7;}");
                sb.Append("#ThisTable { font-family: 'Trebuchet MS', Arial, Helvetica, sans-serif; border-collapse: collapse; width: 100%; }");
                sb.Append("#ThisTable td, #ThisTable th { border: 1px solid #ddd; padding: 2px; font-size: 12px; height:12px; white-space: nowrap; }");
                sb.Append("#ThisTable tr:nth-child(even){ background-color: #f2f2f2; }");
                sb.Append("#ThisTable tr:hover{ background-color: #ddd; }");
                sb.Append("#ThisTable th { padding-top: 2px; padding-bottom: 2px; text-align: left; background-color: #228B22; color: white; }"); //#228B22:ForestGreen
                sb.Append("</style>");
                
                sb.Append("<table id='ThisTable'><thead><th>#</th><th>Full Path</th><th>DateTime</th><th>File Size</th></thead><tbody>");

                string txt = string.Empty;
                int i = 0;
                foreach (var row in listFiles)
                {
                    txt = string.Empty;
                    txt += "<tr><td>" + (++i).ToString() + "</td>";
                    txt += "<td>" + row.FullName + "</td>";
                    txt += "<td>" + row.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss") + "</td>";
                    txt += "<td style='text-align:right;'>" + row.Length.ToString("N0") + "</td></tr>";
                    sb.Append(txt);
                }
                sb.Append("</tbody></table>");

                ltTable.Text = sb.ToString();
                
                message.Text = listFiles.Count.ToString() + " files(s) found";
            }
            else
            {
                pnFILE.Visible = false;
                pnERROR.Visible = true;
                ltMessage.Text = "No File(s) Found...";
            }

        }
        else
        {
            pnFILE.Visible = false;
            pnERROR.Visible = true;
            ltMessage.Text = "<br /><br /><div class='error'>";
            ltMessage.Text += errorMessage.Replace(Environment.NewLine, "<br />");
            ltMessage.Text += "</div>";
        }

    }


}