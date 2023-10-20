using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using NelAspxLib;

public static class Abpx
{
    public static string DealerCustAccount(this string userId, string dataAreaId)
    {
        string sql = "SELECT DEALERACCOUNT FROM NELWPERSON WHERE RTrim(LTrim(BRUGERKODE)) = '" + userId + "' and dataareaid = '" + dataAreaId + "'";

        SqlConnection sqlconn = new SqlConnection
        {
            ConnectionString = Connections.CNKIAWEB
        };
        SqlCommand sqlcmd = new SqlCommand(sql, sqlconn);

        sqlconn.Open();
        string CustAcc = "";
        try
        {
            CustAcc = sqlcmd.ExecuteScalar().ToString().Trim();
        }
        catch
        { }

        sqlconn.Close();
        return CustAcc;
    }


    public static void SetDealerSession(this Page page, ref string UserId, ref string dataareaid, ref string DealerNum)
    {
        HttpCookie Cookie = page.Request.Cookies["ISUZU"];
        UserId = Cookie["user"];
        dataareaid = "isu";
        DealerNum = UserId.DealerCustAccount(dataareaid);

        if (!string.IsNullOrEmpty(DealerNum))
        {
            page.SetSession("axDealerNum", DealerNum);
        }
    }

    public static string GetPageCookies(this Page page, bool web = true)
    {
        StringBuilder sb = new StringBuilder();

        foreach (var n in page.Request.Cookies)
        {
            if (!web) sb.Append(n.ToString()).AppendLine();
            else sb.Append(n.ToString()).Append("<br/>");
        }

        return sb.ToString();
    }
}


public struct Connections
{
    public const string CNKIAWEB = "UID=kiaweb;PWD=stop4bud; Initial Catalog=axdb30sp1kia; Data Source=172.20.16.24";
    public const string CNAX = "Data Source=srv-sql-001;Initial Catalog=axdb30sp1Kia;User ID=sa;Password=swsupport";
}