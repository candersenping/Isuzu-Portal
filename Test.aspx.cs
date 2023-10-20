using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;


public partial class Test : Page
{
    public const string mail = "abp@nellemann.dk";

    protected void Page_Load(object sender, EventArgs e)
    {
        //string errCode = string.IsNullOrEmpty(Request.QueryString.ToString()) ? "500" : Request.QueryString.ToString();

        
        Response.Write(GetInfo(true));
    }

    string GetInfo(bool web = false)
    {
        StringBuilder sb = new StringBuilder(web ? "Cookies:<br/><br/>" : "Cookies\r\n\r\n");

        if (Request.Cookies.Count == 0)
        {
            sb.Append(web ? "No cookies found<br/>" : "No cookies found\r\n");
        }
        else
        {
            foreach (var n in Request.Cookies)
            {
                string name = Request.Cookies[n.ToString()].Name;
                string val = Request.Cookies[n.ToString()].Value ?? "NULL";

                if (web) sb.Append(name + ": " + val).Append("<br/>");
                else sb.Append(name + ": " + val).AppendLine();
            }
        }

        sb.Append(web ? "<br/>Session values:<br/><br/>" : "\r\nSession values:\r\n\r\n");

        if (Session.Keys.Count == 0)
        {
            sb.Append(web ? "No session values found<br/>" : "No session values found\r\n");
        }
        else
        {
            foreach (var n in Session.Keys)
            {
                string key = n.ToString();

                if (!web) sb.Append(key + ": ").Append(Session[key]).AppendLine();
                else sb.Append(key + ": ").Append(Session[key]).Append("<br/>");
            }
        }

        sb.Append(web ? "<br/>Server variables:<br/><br/>" : "\r\nServer variables:\r\n\r\n");

        if (Request.ServerVariables.Count == 0)
        {
            sb.Append(web ? "No Server variables found<br/>" : "No Server variables found\r\n");
        }
        else
        {
            foreach (var n in Request.ServerVariables)
            {
                string key = n.ToString();
                if (key != "ALL_HTTP" && key != "ALL_RAW")
                {
                    if (!web) sb.Append(key + ": ").Append(Request[key]).AppendLine();
                    else sb.Append(key + ": ").Append(Request[key]).Append("<br/>");
                }
            }
        }
        return sb.ToString();
    }
}