using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.Services;

 
namespace Adventure
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    [System.Web.Script.Services.ScriptService]
    public class AdventureService : System.Web.Services.WebService
    {

        [WebMethod]
        //[ScriptMethod(UseHttpGet = true, ResponseFormat = ResponseFormat.Json)]
        public void GetEmployees(int iDisplayLength, int iDisplayStart, int iSortCol_0, string sSortDir_0, string sSearch)
        {
            int displayLength = iDisplayLength;
            int displayStart = iDisplayStart;
            int sortCol = iSortCol_0;
            string sortDir = sSortDir_0;
            string search = sSearch;

            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            List<Employee> listEmployees = new List<Employee>();
            int filteredCount = 0;
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("spGetEmployees", con);

                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter paramDisplayLength = new SqlParameter()
                {
                    ParameterName = "@DisplayLength",
                    Value = displayLength
                };
                cmd.Parameters.Add(paramDisplayLength);

                SqlParameter paramDisplayStart = new SqlParameter()
                {
                    ParameterName = "@DisplayStart",
                    Value = displayStart
                };
                cmd.Parameters.Add(paramDisplayStart);

                SqlParameter paramSortCol = new SqlParameter()
                {
                    ParameterName = "@SortCol",
                    Value = sortCol
                };
                cmd.Parameters.Add(paramSortCol);

                SqlParameter paramSortDir = new SqlParameter()
                {
                    ParameterName = "@SortDir",
                    Value = sortDir
                };
                cmd.Parameters.Add(paramSortDir);

                SqlParameter paramSearchString = new SqlParameter()
                {
                    ParameterName = "@Search",
                    Value = string.IsNullOrEmpty(search) ? null : search
                };
                cmd.Parameters.Add(paramSearchString);

                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    Employee employee = new Employee();
                    employee.BusinessEntityID = Convert.ToInt32(rdr["BusinessEntityID"]);
                    employee.Title = rdr["Title"].ToString();
                    employee.FirstName = rdr["FirstName"].ToString();
                    employee.MiddleName = rdr["MiddleName"].ToString();
                    employee.LastName = rdr["LastName"].ToString();
                    employee.Suffix = rdr["Suffix"].ToString();
                    employee.JobTitle = rdr["JobTitle"].ToString();
                    employee.PhoneNumber = rdr["PhoneNumber"].ToString();
                    employee.PhoneNumberType = rdr["PhoneNumberType"].ToString();
                    employee.EmailAddress = rdr["EmailAddress"].ToString();
                    employee.EmailPromotion = rdr["EmailPromotion"].ToString();
                    employee.AddressLine1 = rdr["AddressLine1"].ToString();
                    employee.AddressLine2 = rdr["AddressLine2"].ToString();
                    employee.City = rdr["City"].ToString();
                    employee.StateProvinceName = rdr["StateProvinceName"].ToString();
                    employee.PostalCode = rdr["PostalCode"].ToString();
                    employee.CountryRegionName = rdr["CountryRegionName"].ToString();
                    employee.AdditionalContactInfo = rdr["AdditionalContactInfo"].ToString();
                    listEmployees.Add(employee);
                }
            }

            var result = new
            {
                iTotalRecords = GetEmployeeTotalCount(),
                iTotalDisplayRecords = filteredCount,
                aaData = listEmployees
            };

            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            
            //CORS Policy
            Context.Response.AppendHeader("Access-Control-Allow-Origin", "*");
            Context.Response.AppendHeader("Access-Control-Allow-Methods", "POST,GET,OPTIONS");
            Context.Response.AppendHeader("Access-Control-Allow-Headers", "Origin, Methods, Content-Type");

            Context.Response.Write(js.Serialize(result));
            Context.Response.End();
        }

        private int GetEmployeeTotalCount()
        {
            int totalEmployeeCount = 0;
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new
                    SqlCommand("select count(*) from HumanResources.vEmployee", con);
                con.Open();
                totalEmployeeCount = (int)cmd.ExecuteScalar();
            }
            return totalEmployeeCount;
        }
    }
}

