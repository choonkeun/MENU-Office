using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.SqlClient;

using Newtonsoft.Json;
using System.IO;

public partial class backend_JSON_Results: System.Web.UI.Page
{
    public string folderPath = string.Empty;
    public string dbServer = string.Empty;
    public string dbDatabase = "";
    public string dbUserID = "";
    public string dbPassword = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        folderPath = HttpContext.Current.Server.MapPath("~/temp/");

        bool OK = false;
        string action = string.Empty;
        string programId = string.Empty;

        string batchId = string.Empty;
        string serverId = string.Empty;
        string contentType = string.Empty;

        string outString = string.Empty;
        string[] files = new string[] {};       //not used

        Dictionary<string, string> formData = new Dictionary<string, string>();

        if (Request.Form.Count > 0)
        {
            foreach (string key in HttpContext.Current.Request.Form.AllKeys)
            {
				if (!formData.ContainsKey(key))
					formData.Add(key.ToLower(), HttpContext.Current.Request.Form[key].ToLower());
            }
            //action = formData["action"];

            batchId = formData["batchid"];
            if (formData.TryGetValue("batchid", out batchId))
            {
                if (batchId.Length == 0)
                    batchId = string.Empty;
            }

            if (formData.TryGetValue("programid", out programId))
            {
                if (programId.Length == 0)
                    programId = string.Empty;
            }

            if (formData.TryGetValue("contenttype", out contentType))
            {
                if (contentType.Length == 0)
                    contentType = "application/json";
            }

            if (formData.TryGetValue("serverid", out serverId))
            {
                if (serverId.Trim().Length > 0)
                {
                    serverId = serverId.ToLower();

                    if (serverId == "north") dbServer = @"northsql";
                }
            }
            if (programId.Trim().Length > 0)
            {
                OK = true;
                programId = programId.ToLower();

                if (programId == "labdata")
                {
                    dbDatabase = @"labdata";
                    dbUserID = "user";
                    dbPassword = "pass";
                }

            }

            if (OK)
            {
                try
                {
                    int id = Convert.ToInt32(batchId);
                    //File.WriteAllText(folderPath + "json.txt", outString);

                    outString = Get_Lab_Data(id);
                    //outString = "{ \"data\" : " + Get_Lab_Data(id) + "}";

                }
                catch (Exception)
                {
                }
            }

            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ClearHeaders();
            HttpContext.Current.Response.ContentType = contentType;
            HttpContext.Current.Response.BufferOutput = true;
            HttpContext.Current.Response.AppendHeader("Content-Length", outString.Length.ToString());
            HttpContext.Current.Response.Write(outString);
            HttpContext.Current.Response.End();
        }

    }

    private string Get_Lab_Data(int batchID)
    {
        bool isGood = true;
        string outString = string.Empty;

        SqlConnectionStringBuilder sb = new SqlConnectionStringBuilder();
        sb.DataSource = dbServer;
        sb.UserID = dbUserID; 
        sb.Password = dbPassword;
        sb.InitialCatalog = dbDatabase;

        SqlConnection cn = new SqlConnection(sb.ConnectionString);

        try
        {
            cn.Open();

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = cn;

            cmd.CommandText = "select * from dbo.LabData Where batchID = @batchID";
            cmd.CommandType = CommandType.Text;
            cmd.Parameters.Add("@batchID", SqlDbType.Int).Value = batchID;

            DataSet ds = new DataSet();
            SqlDataAdapter sa = new SqlDataAdapter(cmd);

            sa.Fill(ds);

            isGood = (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0) ? true : false;
            if (isGood)
            {
                outString = DataTableToJSON(ds.Tables[0]);
            }

            ds.Dispose();
            cn.Close();
        }
        catch (Exception ex)
        {
            if (cn.State == ConnectionState.Open)
            {
                cn.Close();
            }
            isGood = true;
        }
        return outString;
    }

    public string DataTableToJSON(DataTable table)
    {
        string JSONString = string.Empty;
        JSONString = JsonConvert.SerializeObject(table);
        return JSONString;
    }
}

