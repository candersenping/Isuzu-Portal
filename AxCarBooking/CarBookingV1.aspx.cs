using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Axapta = AxaptaCOMConnector;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Net.Mail;



public partial class AxCarBooking_CarBookingV1 : System.Web.UI.Page
{
    string connStr = "UID=kiaweb;PWD=stop4bud; Initial Catalog=axdb30sp1kia; Data Source=172.20.16.24";
    string DealerUserId = "";
    string CustAccount = "";
    string DealerUserName = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!checklogin())
        {
            Response.Redirect("~/default.asp");
            Response.End();
        }

        string DealerUser = (string)Session["DealerUser"];

        SqlConnection conn = new SqlConnection(connStr);
        conn.Open();
        string sql = "SELECT * FROM NelWPerson WHERE DATAAREAID='ISU' AND BRUGERKODE='" + DealerUser + "'";
        SqlCommand cmd = new SqlCommand(sql, conn);
        SqlDataReader reader = cmd.ExecuteReader();
        if (reader.HasRows)
        {
            while (reader.Read())
            {
                CustAccount = reader["CUSTACCOUNT"].ToString().Trim();
                DealerUserName = reader["MEDARBEJDERNAVN"].ToString().Trim();
                break;
            }
        }

        loadDealers();

        if (!IsPostBack)
        {
            selectData2GridView();
            PageTxt.Text = "Bookning af Demo/Showbiler - (" + DealerUser + ")</br></br>";
        }
    }

    public Int32 colourGet(string dealerCustAccount = "")
    {
        int colour = 0;

        if (dealerCustAccount.Trim() != "")
        {
            //Response.Write("("+dealerCustAccount+")");
            //Response.End();
            DataClassesDataContext data = new DataClassesDataContext();

            var result = from person in data.NELWPERSONs where person.DATAAREAID == "ISU" && person.DEALERACCOUNT == dealerCustAccount select person;
            foreach (var c in result)
            {
                colour = c.COLOURCARBOOKING;
                break;
            }
            result = null;
            data.Dispose();
        }
        return colour;
    }

    public void loadDealers()
    {
        DataClassesDataContext data = new DataClassesDataContext();

        var result = from cust in data.CUSTTABLEs where cust.DATAAREAID == "ISU" && cust.CUSTGROUP == "dk forh" &&  cust.CONSCUSTYESNO == 1 select cust;
        foreach(var c in result)
        {
            TableRow tRow = new TableRow();
            DealerTabel.Rows.Add(tRow);
            TableCell tCell = new TableCell();
            tCell.Text = c.ACCOUNTNUM + " "+ c.NAME.ToString();
            tCell.BackColor = System.Drawing.Color.FromArgb(colourGet(c.ACCOUNTNUM.ToString().Trim()));
            tCell.Font.Size = 8;
            tRow.Cells.Add(tCell);
        }
        result = null;
        data.Dispose();
    }

    protected void Start_Click(object sender, EventArgs e)
    {
        Response.Redirect("/start.asp");
    }

    Boolean checklogin()
    {
        bool loggedin = true;
        HttpCookie KiaCookie = Request.Cookies["ISUZU"];
        if (KiaCookie == null)
            loggedin = false;
        else
        {
            string user = KiaCookie["user"];
            DealerUserId = user;
            Session["Dealeruser"] = DealerUserId;
            if (user == "")
                loggedin = false;
        }
        return loggedin;
    }

    public void selectData2GridView()
    {

        SqlConnection conn = new SqlConnection(connStr);
        conn.Open();
        string sql = @"SELECT [CARACCOUNT], [DESCRIPTION], CARTABLE.[TYPE], CARTABLE.[REGNO] REGNUM FROM [CISCARBOOKINGTABLE] JOIN CARTABLE ON CARTABLE.ACCOUNT = [CISCARBOOKINGTABLE].CARACCOUNT WHERE [CISCARBOOKINGTABLE].DATAAREAID='ISU' ORDER BY CARACCOUNT";
        SqlCommand cmd = new SqlCommand(sql, conn);
        SqlDataReader reader = cmd.ExecuteReader();
        BookingView.DataSource = reader;
        BookingView.DataBind();
        reader.Close();
        reader.Dispose();
        cmd.Dispose();
        conn.Close();
        conn.Dispose();
    }

    public void C1_selectionChanged(object sender, EventArgs e)
    {
        Calendar c = (Calendar)sender;
        GridViewRow g = (GridViewRow)c.Parent.Parent;

        string sql = "";
        string car = g.Cells[0].Text.ToString();
        string calDate = c.SelectedDate.ToString("yyyy-MM-dd");

        SqlConnection conn = new SqlConnection(connStr);
        conn.Open();
        sql = "SELECT CISCARBOOKINGTRANS.[CARACCOUNT] CAR, CISCARBOOKINGTRANS.[RECID] RECID, CISCARBOOKINGTRANS.[CONFIRMED] CONFIRMED ,CISCARBOOKINGTRANS.[CUSTACCOUNT] DEALER, CUSTTABLE.NAME [NAME], CISCARBOOKINGTRANS.[BOOKINGDATE] FROM CISCarBookingTrans JOIN CUSTTABLE ON CUSTTABLE.DATAAREAID = CISCARBOOKINGTRANS.DATAAREAID AND CUSTTABLE.ACCOUNTNUM = CISCARBOOKINGTRANS.CUSTACCOUNT WHERE CISCARBOOKINGTRANS.DATAAREAID='ISU' AND CISCARBOOKINGTRANS.CARACCOUNT='" + car + "' AND BOOKINGDATE='" + calDate + "'";
        SqlCommand cmd = new SqlCommand(sql, conn);
        SqlDataReader reader = cmd.ExecuteReader();
        if (reader.HasRows)
        {
            while (reader.Read())
            {
                if (reader["DEALER"].ToString().Trim() != CustAccount || reader["CONFIRMED"].ToString().Trim() == "1" || c.SelectedDate < System.DateTime.Today)
                {
                    Response.Write(SetAlertBox("Vogn booket den " + reader["BOOKINGDATE"].ToString().Substring(0, 10) + " af " + reader["DEALER"].ToString().Trim() + " " + reader["NAME"].ToString()));
                }
                else
                {

                    string RecId = reader["RECID"].ToString().Trim();
                    Axapta.Axapta axapta = new AxaptaCOMConnector.Axapta();
                    axapta.Logon("", "", "", "");
                    try
                    {
                        axapta.TTSBegin();
                        Axapta.IAxaptaRecord record = axapta.CreateRecord("CISCarBookingTrans");
                        record.Company = "ISU";
                        sql = "delete_from %1 where %1.RecId==" + RecId;
                        record.ExecuteStmt(sql);
                        axapta.TTSCommit();
                        axapta.Logoff();
                        axapta = null;
                    }
                    catch (Exception ee)
                    {
                        axapta.TTSAbort();
                        axapta.Logoff();
                        axapta = null;
                        Response.Write("Fejl: " + ee.Message.ToString());
                        Response.End();
                    }
                }
                break;
            }
        }
        else
        {
            if (c.SelectedDate >= System.DateTime.Today)
            {

                //String scriptText = "return confirm('Er du helt sikker?')";
                //ClientScript.RegisterOnSubmitStatement(this.GetType(), "ConfirmSubmit", scriptText);
                {
                    Axapta.Axapta axapta = new AxaptaCOMConnector.Axapta();
                    axapta.Logon("", "", "", "");
                    try
                    {
                        axapta.TTSBegin();
                        Axapta.IAxaptaRecord record = axapta.CreateRecord("CISCarBookingTrans");
                        record.Company = "ISU";
                        record.set_field("CustAccount", CustAccount);
                        record.set_field("BookingDate", calDate);
                        record.set_field("CarAccount", car);
                        record.set_field("DealerUserId", DealerUserId);
                        record.set_field("Web", 1);
                        record.Insert();
                        axapta.TTSCommit();
                        axapta.Logoff();
                        axapta = null;

                        MailMessage msg = new MailMessage();
                        MailAddress from = new MailAddress("itdisk@nellemann.dk");
                        msg.From = from;
                        msg.To.Add("itdisk@nellemann.dk");
                        msg.To.Add("rea@nellemann.dk");
                        msg.Subject = "Vogn " + car + " booked den " + c.SelectedDate.ToString("dd-MM-yyyy") + " af forhandler " + CustAccount + "/" + DealerUserName;
                        SmtpClient smtpClient = new SmtpClient("127.0.0.1");
                        smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
                        smtpClient.Send(msg);
                    }
                    catch (Exception ee)
                    {
                        axapta.TTSAbort();
                        axapta.Logoff();
                        axapta = null;
                        Response.Write("Fejl: " + ee.Message.ToString());
                        Response.End();
                    }
                }
            }
            else
            {
                Response.Write(SetAlertBox("Vogn kan ikke bookes tidligere end dagsdato."));
            }
        }
        reader.Close();
        reader.Dispose();
        cmd.Dispose();
        conn.Close();
        conn.Dispose();

        Calendar c2 = (Calendar)g.FindControl("Calendar1");
        SelectedDatesCollection s = c2.SelectedDates;
        s.Clear();
        try
        {
            SqlConnection conn2 = new SqlConnection(connStr);
            conn2.Open();
            sql = "SELECT * FROM  CISCarBookingTrans WHERE DATAAREAID='ISU' AND CARACCOUNT='" + car + "' ORDER BY CARACCOUNT";
            SqlCommand cmd2 = new SqlCommand(sql, conn2);
            SqlDataReader reader2 = cmd2.ExecuteReader();
            if (reader2.HasRows)
            {
                while (reader2.Read())
                {
                    s.Add(Convert.ToDateTime(reader2["BOOKINGDATE"].ToString()));
                }
            }
            reader2.Close();
            reader2.Dispose();
            cmd2.Dispose();
            conn2.Close();
            conn2.Dispose();
        }
        catch (Exception t)
        {
            Response.Write(t.Message);
            Response.End();
        }
    }

    public Boolean Confirm()
    {
        String scriptText = "return confirm('Er du helt sikker (test) ?')";
        ClientScript.RegisterOnSubmitStatement(this.GetType(), "ConfirmSubmit", scriptText);
        return false;
    }

    protected string SetAlertBox(string t)
    {
        string s = "", n = "";

        n = t.Replace("&#230;", "æ");
        n = n.Replace("&#198;", "Æ");
        n = n.Replace("&#248;", "ø");
        n = n.Replace("&#216;", "Ø");
        n = n.Replace("&#229;", "å");
        n = n.Replace("&#197;", "Å");

        s = "<script>alert('" + n + "')</script>";
        return s;
    }

    protected string SetConfirmBox()
    {
        string s = "";
        s = "<script>var confirm_value = document.createElement(" + "\"" + "INPUT" + "\"" + "); confirm_value.name=" + "\"" + "confirm_value" + "\"" + "; if (confirm(" + "\"" + "Er du sikker ? " + "\"" + ")) { confirm_value.value=" + "\"" + "Yes" + "\"" + "; } else { confirm_value.value = " + "\"" + "No" + "\"" + "; }</script>";
        return s;
    }

    public Boolean ConfirmBoxResult()
    {
        string confirmValue = Request.Form["confirm_value2"];
        if (confirmValue == "Yes")
        {
            //this.Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('You clicked YES!')", true);
            return true;
        }
        else
        {
            //this.Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('You clicked NO!')", true);
            return false;
        }
    }

    protected void RenderDay(object sender, DayRenderEventArgs e)
    {
        Calendar c = (Calendar)sender;
        GridViewRow g = (GridViewRow)c.Parent.Parent;

        string sql = "";
        string car = g.Cells[0].Text.ToString();
        string calDate = e.Day.Date.ToString("yyyy-MM-dd");
        
        SqlConnection conn = new SqlConnection(connStr);
        conn.Open();
        sql = "SELECT  * FROM CISCarBookingTrans WHERE DATAAREAID='ISU' AND CARACCOUNT='" + car + "' AND BOOKINGDATE='" + calDate + "'";
        SqlCommand cmd = new SqlCommand(sql, conn);
        SqlDataReader reader = cmd.ExecuteReader();
        if (reader.HasRows)
        {
            while (reader.Read())
            {
                e.Cell.BackColor = System.Drawing.Color.FromArgb(colourGet(reader["CUSTACCOUNT"].ToString().Trim()));
            }
        }
        reader.Close();
        reader.Dispose();
        cmd.Dispose();
        conn.Close();
        conn.Dispose();
    }

    public void BookingView_OnRowBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            GridViewRow g = e.Row;
            Calendar c = (Calendar)g.FindControl("Calendar1");
            SelectedDatesCollection s = c.SelectedDates;
            s.Clear();
            try
            {
                SqlConnection conn = new SqlConnection(connStr);
                conn.Open();
                string car = e.Row.Cells[0].Text.ToString();
                string sql = "SELECT [CARACCOUNT], [CUSTACCOUNT], [BOOKINGDATE] FROM  CISCarBookingTrans WHERE DATAAREAID='ISU' AND CARACCOUNT='" + car +"' ORDER BY CARACCOUNT";
                //Response.Write(car);
                //Response.End();
                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        s.Add(Convert.ToDateTime(reader["BOOKINGDATE"].ToString()));
                    }
                }
                //DateTime aDate = DateTime.Today;
                //c.SelectedDate = Convert.ToDateTime(DateTime.Now.Date.AddDays(g.RowIndex));
                reader.Close();
                reader.Dispose();
                cmd.Dispose();
                conn.Close();
                conn.Dispose();
            }
            catch (Exception t)
            {
                Response.Write(t.Message);
                Response.End();
            }
        }
        //c.SelectedDate = 
        /*
        SelectedDatesCollection theDates = new SelectedDatesCollection(new System.Collections.ArrayList());
        
        theDates.Clear();
        for (int i = 0; i <= 6; i++)
        {
            theDates.Add(aDate.AddDays(i));
        }
        c.SelectedDates = theDates;
         * */
    }

}