using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.SqlClient;

using Newtonsoft.Json;
using ExtensionMethods;

public partial class backend_GetDatabase_ReturnJSON: System.Web.UI.Page
{
    public string folderPath = string.Empty;
    public string dbServer = string.Empty;
    public string dbDatabase = string.Empty;
    public string dbUserID = string.Empty;
    public string dbPassword = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        folderPath = HttpContext.Current.Server.MapPath("~/temp/");

        bool OK = false;
        string action = string.Empty;
        string contentType = string.Empty;

        string inputValue = string.Empty;
        string serverId = string.Empty;
        string databaseId = string.Empty;
        string programId = string.Empty;

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

            inputValue = formData["inputvalue"];
            if (formData.TryGetValue("inputvalue", out inputValue))
            {
                if (inputValue.Length == 0)
                    inputValue = string.Empty;
            }

            if (formData.TryGetValue("contenttype", out contentType))
            {
                if (contentType.Length == 0)
                    contentType = "application/json";
            }

            //only support registered program
            if (formData.TryGetValue("programid", out programId))
            {   
                OK = false;
                if (programId == "multiple") OK = true;
                if (programId == "adventure") OK = true;
            }

            if (OK && formData.TryGetValue("serverid", out serverId))
            {
                if (serverId == "adventureworks") serverId = "HOST";
                if (serverId == "northwind") serverId = "HOST";
                //if (serverId == "adventureworks") serverId = "5490L8";
                //if (serverId == "northwind") serverId = "192.168.104.10";

                //if (serverId == "production") serverId = "HOST";
                //if (serverId == "quality") serverId = "HOST";
                //if (serverId == "develop") serverId = "HOST";
            }

            if (OK && formData.TryGetValue("databaseid", out databaseId))
            {
                if (databaseId == "adventure2014") databaseId = "AdventureWorks";
                if (databaseId == "north2012") databaseId = "NorthWind";
            }

            if (OK && databaseId.Trim().Length > 0)
            {
                OK = true;
                databaseId = databaseId.ToLower();

                if (databaseId == "adventureworks")
                {
                    dbServer = serverId;
                    dbDatabase = databaseId;
                    dbUserID = "sa";
                    //dbPassword = "!!11qqAA";
                    dbPassword = "1";
                }
                if (databaseId == "northwind")
                {
                    dbServer = serverId;
                    dbDatabase = databaseId;
                    dbUserID = "sa";
                    dbPassword = "1";
                }

            }

            if (OK)
            {
                SqlConnectionStringBuilder sb = new SqlConnectionStringBuilder();
                sb.DataSource = dbServer;
                sb.UserID = dbUserID;
                sb.Password = dbPassword;
                sb.InitialCatalog = dbDatabase;
                SqlConnection cn = new SqlConnection(sb.ConnectionString);


                outString = Get_SQL_Data(sb.ConnectionString, databaseId, inputValue);
            }

            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ClearHeaders();
            HttpContext.Current.Response.ContentType = contentType;
            HttpContext.Current.Response.BufferOutput = true;
            //HttpContext.Current.Response.AppendHeader("Content-Length", outString.Length.ToString());
            HttpContext.Current.Response.Write(outString);                  //Response.WriteFile(fileName);
            HttpContext.Current.Response.End();
        }

    }

    private string Get_SQL_Data(string connStr, string databaseId, string inputValue)
    {
        string outString = string.Empty;
        string query = string.Empty;
        string sqlString = string.Empty;


        SqlCommand cmd = new SqlCommand();
        cmd.CommandType = CommandType.Text;

        if (databaseId == "adventureworks")
        {
            query = "select * from HumanResources.vEmployee ";

            int intValue = 0;
            bool isValue = int.TryParse(inputValue, out intValue);
            if (isValue)
            {
                sqlString = " Where BusinessEntityID >= @keyString";
                sqlString += " Order by BusinessEntityID";
                cmd.Parameters.Add("@keyString", SqlDbType.Int);
                cmd.Parameters["@keyString"].Value = Convert.ToUInt32(inputValue);
            }
            else
            {
                sqlString = " Where LastName like @keyString";
                sqlString += " Order by LastName";
                cmd.Parameters.AddWithValue("@keyString", inputValue + "%");
                //cmd.Parameters.Add("@keyString", SqlDbType.Text).Value = inputValue + "%";
            }
            query += sqlString;
            cmd.CommandText = query;
        }

        if (databaseId == "northwind")
        {
            query = "select * from dbo.Customers ";

            int intValue = 0;
            bool isValue = int.TryParse(inputValue, out intValue);
            if (isValue)
            {
                sqlString = " Where CustomerID >= @keyString";
                sqlString += " Order by CustomerID";
                cmd.Parameters.Add("@keyString", SqlDbType.Int);
                cmd.Parameters["@keyString"].Value = Convert.ToUInt32(inputValue);
            }
            else
            {
                sqlString = " Where ContactName like @keyString";
                sqlString += " Order by ContactName";
                cmd.Parameters.AddWithValue("@keyString", inputValue + "%");
                //cmd.Parameters.Add("@keyString", SqlDbType.Text).Value = inputValue + "%";
            }
            query += sqlString;
            cmd.CommandText = query;
        }

        try
        {
            DataSet ds = Utility.GetDataSet(connStr, cmd);

            bool isGood = (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0) ? true : false;
            if (isGood)
            {
                outString = DataTableToJSON(ds.Tables[0]);
            }

            ds.Dispose();
        }
        catch (Exception ex)
        {
            //throw;
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

