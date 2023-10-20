using System;
using System.Collections.Generic;
using System.Collections;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.IO;

public partial class lagerstyring_aktivlisten : System.Web.UI.Page
{
    SqlConnection sqlconn = null;
    string dataAreaId = "ISU";
    string globalbrand = "ISUZU";
    string globalcookie = "ISUZU";

    protected void Page_Load(object sender, EventArgs e)
    {
        Page.MaintainScrollPositionOnPostBack = true;
        if (!checklogin())
        {
            Response.Redirect("~/default.asp");
            Response.End();
        }

        if (IsPostBack == false)
        {
            string mode = Request.QueryString["m"];
            if (mode == null)
                mode = "1";

            if (mode == "1")
            {
                Headlinelbl.Text = "Egne Ordre- & Lagerbiler";
                listLiteral.Text = "Denne liste viser, hvilke egne biler der er i ordre og på lager.<br />Klik på en model for at se ordrestatus, lagerstatus samt forventet og reelle ankomstdatoer. <br /><br />";
            }
            else if (mode == "2")
            {
                Headlinelbl.Text = "Imp. & Forhandler Ordrebiler";
                listLiteral.Text = "Denne liste viser, hvilke biler det samlede forhandlernet har på lager.<br />Klik på en model for at se de enkelte bilers lager-status.<br /><br />";
            }
            else if (mode == "3")
            {
                Headlinelbl.Text = "Forhandler Lagerbiler";
                listLiteral.Text = "Denne liste viser hvilke biler det samlede forhandlernet har på lager.<br />Klik på modellen for at se lagerstatus.<br /><br />";
            }
            else if (mode == "4")
            {
                Headlinelbl.Text = "Forhandler Indfriede Lagerbiler";
                listLiteral.Text = "Denne liste viser hvilke biler det samlede forhandlernet har på lager som er indfriet.<br />Klik på modellen for at se lagerstatus.<br /><br />";
            }

            aktivListRepeater.DataSource = getListData(mode);
            aktivListRepeater.DataBind();
        }
    }

    protected void doSearchModel(object source, EventArgs e)
    {
        string mode = Request.QueryString["m"];
        ddlMotor.Items.Clear();
        ddlType.Items.Clear();
        ddlColor.Items.Clear();
        aktivListRepeater.DataSource = getListData(mode);
        aktivListRepeater.DataBind();
    }

    protected void doSearchMotor(object source, EventArgs e)
    {
        string mode = Request.QueryString["m"];
        ddlType.Items.Clear();
        ddlColor.Items.Clear();
        aktivListRepeater.DataSource = getListData(mode);
        aktivListRepeater.DataBind();
    }

    protected void doSearchType(object source, EventArgs e)
    {
        string mode = Request.QueryString["m"];
        ddlColor.Items.Clear();
        aktivListRepeater.DataSource = getListData(mode);
        aktivListRepeater.DataBind();
    }

    protected void doSearchColor(object source, EventArgs e)
    {
        string mode = Request.QueryString["m"];
        aktivListRepeater.DataSource = getListData(mode);
        aktivListRepeater.DataBind();
    }

    protected void doSearchStr(object source, EventArgs e)
    {
        string mode = Request.QueryString["m"];
        aktivListRepeater.DataSource = getListData(mode);
        aktivListRepeater.DataBind();
    }

    protected void doSearchAvailable(object source, EventArgs e)
    {
        string mode = Request.QueryString["m"];
        aktivListRepeater.DataSource = getListData(mode);
        aktivListRepeater.DataBind();
    }

    string sqlAddFilter(string s)
    {
        string retStr = "";

        retStr = s;

        if (searchStr.Text.ToString() != "")
            retStr = retStr + "and WEBTYPE like '%" + searchStr.Text.ToString() + "%' ";
        
        if (ddlModel.Text.ToString() != "")
            retStr = retStr + "and WEBTYPE like '%" + ddlModel.Text.ToString() + "%' ";
        
        if (ddlMotor.Text.ToString() != "")
            retStr = retStr + "and WEBTYPE like '%" + ddlMotor.Text.ToString() + "%' ";
        
        if (ddlType.Text.ToString() != "")
            retStr = retStr + "and WEBTYPE like '%" + ddlType.Text.ToString() + "%' ";
        
        if (ddlColor.Text.ToString() != "")
            retStr = retStr + "and ColorDescExt = '" + ddlColor.Text.ToString() + "' ";
        
        if (ddlAvailable.Text.ToString() == "1")
            retStr = retStr + "and LTrim(CAROWNERACCOUNT) = '' ";

        return retStr;
    }

    string sqlAddFilterColor(string s)
    {
        string retStr = "";

        retStr = s;

        if (ddlColor.Text.ToString() != "")
            retStr = retStr + "and ColorDescExt = '" + ddlColor.Text.ToString() + "' ";

        if (ddlAvailable.Text.ToString() == "1")
            retStr = retStr + "and LTrim(CAROWNERACCOUNT) = '' ";

        return retStr;
    }

    DataSet getListData(string mode)
    {
        HttpCookie KiaCookie = Request.Cookies[globalcookie];
        string user = KiaCookie["user"];
        string[] KiaLoginArr = Server.HtmlEncode(KiaCookie.Value).Split('&');
        string login = KiaLoginArr[0].Remove(0, 5).Substring(0, 4);
        ArrayList AccountArr = new ArrayList();
        SqlCommand sqlcom;
        string sql = "", sql1 = "", sql2 = "", sql3 = "", sqlColor = "", sqlMotor = "", sqlType = "";
        string[] words;
        switch (mode)
        {
            case "1":
                //Aktivlisten
                int MainFound = 0;
                string model = "";
                sqlconn = getConnection();
                sql = "SELECT INVOICEACCOUNT FROM CUSTTABLE WHERE ltrim(ACCOUNTNUM) = '" + login + "' and dataareaid = '"+dataAreaId+"'";
                sqlcom = new SqlCommand(sql, sqlconn);
                sqlconn.Open();
                string invoiceAcc = sqlcom.ExecuteScalar().ToString().Trim();
                sqlconn.Close();

                if (invoiceAcc != "" && invoiceAcc != login)
                {
                    sql = "SELECT ACCOUNTNUM FROM CUSTTABLE WHERE ltrim(invoiceaccount) = '" + invoiceAcc.Trim() + "' and dataareaid = '" + dataAreaId + "'";
                    sqlcom = new SqlCommand(sql, sqlconn);
                    sqlconn.Open();
                    SqlDataReader sqlread = sqlcom.ExecuteReader();
                    while (sqlread.Read())
                    {
                        AccountArr.Add(sqlread["ACCOUNTNUM"]).ToString().Trim();
                    }
                    sqlconn.Close();
                }
                else
                {
                    sql = "SELECT MAINACCOUNT FROM CISCustTableCarInventGroup WHERE Blocked = 0 AND ltrim(custaccount) = '" + login + "' and '" + dataAreaId + "'";
                    sqlcom = new SqlCommand(sql, sqlconn);
                    sqlconn.Open();
                    SqlDataReader sqlread = sqlcom.ExecuteReader();
                    while (sqlread.Read())
                    {
                        AccountArr.Add(sqlread["MAINACCOUNT"]).ToString().Trim();
                        MainFound = 1;
                    }
                    sqlconn.Close();

                    AccountArr.Add(login);
                }

                sql1 = "SELECT WEBTYPE ,MODEL, CARCERTTYPE, count(*) as cnt FROM CarTable ";
                sql2 = "WHERE (Brand = '" +globalbrand + "') ";
                sql2 = sql2 + "and (SalesStatus = '' or SalesStatus = 'B3' or SalesStatus = 'D1' or SalesStatus = 'DW' or SalesStatus = 'E1' or SalesStatus = 'F1' or SalesStatus = 'F2') ";
                sql2 = sql2 + "and (dataareaID = '" + dataAreaId + "') ";
                sql2 = sql2 + "and (NewOrUsed = 0 or NewOrUsed = 4) ";
                sql2 = sql2 + "and (UnitStatus = '05' or UnitStatus = '09' or UnitStatus = '10' or UnitStatus = '11' or UnitStatus = '11a' or UnitStatus = '11am' or UnitStatus = '11b' or UnitStatus = '11c' or UnitStatus = '11e' or UnitStatus = '11f' or UnitStatus = '11g' or UnitStatus = '11h' or UnitStatus = '11i' or UnitStatus = '11j' or UnitStatus = '11q' or UnitStatus = '11r' or UnitStatus = '11s') ";
                
                sql2 = sqlAddFilter(sql2);
                
                for (int i = 0; i < AccountArr.Count; i++)
                {
                    if (AccountArr.Count == 1)
                        sql2 = sql2 + "and (DEALERACCOUNT like '%" + AccountArr[i].ToString().Trim() + "%') ";
                    else
                    {
                        if (i == 0)
                            sql2 = sql2 + "and (DEALERACCOUNT like '%" + AccountArr[i].ToString().Trim() + "%' ";
                        else if (i == AccountArr.Count - 1)
                            sql2 = sql2 + "or DEALERACCOUNT like '%" + AccountArr[i].ToString().Trim() + "%') ";
                        else
                            sql2 = sql2 + "or DEALERACCOUNT like '%" + AccountArr[i].ToString().Trim() + "%' ";
                    }
                }
                sql3 = "GROUP BY CARCERTTYPE,WEBTYPE,MODEL ORDER BY WEBTYPE ASC"; 
               
                sql = sql1 + sql2 + sql3;
                break;
            case "2":
                //Ordrebiler
                sql1 = "SELECT WEBTYPE ,MODEL, CARCERTTYPE, count(*) as cnt FROM CarTable ";
                sql2 = "WHERE (Brand = '" + globalbrand + "') ";
                sql2 = sqlAddFilter(sql2);
                sql2 = sql2 + "and (SalesStatus = '' or SalesStatus = 'B1' or SalesStatus = 'B3' or SalesStatus = 'C1') ";
                sql2 = sql2 + "and (dataareaID = '" + dataAreaId + "') ";
                sql2 = sql2 + "and (NewOrUsed = 0 or NewOrUsed = 4) ";
                sql2 = sql2 + "and DEALERACCOUNT <> '' ";
                //sql2 = sql2 + "and (DEALERACCOUNT not like '%7000imp%') ";
                //sql2 = sql2 + "and (UnitStatus = '05' or UnitStatus = '09' or UnitStatus = '10' or UnitStatus = '11a' or UnitStatus = '11am' or UnitStatus = '11b' or UnitStatus = '11c' or UnitStatus = '11e' or UnitStatus = '11f' or UnitStatus = '11g' or UnitStatus = '11q' or UnitStatus = '11r' or UnitStatus = '11s' or UnitStatus = '11h' or UnitStatus = '11') ";
                sql2 = sql2 + "and (UnitStatus = '05' or UnitStatus = '09' or UnitStatus = '10' or UnitStatus = '11am' or UnitStatus = '11b' or UnitStatus = '11c' or UnitStatus = '11e' or UnitStatus = '11f' or UnitStatus = '11g' or UnitStatus = '11q' or UnitStatus = '11r' or UnitStatus = '11s' or UnitStatus = '11h' or UnitStatus = '11') ";
                sql3 = "GROUP BY CARCERTTYPE,WEBTYPE,MODEL ORDER BY WEBTYPE ASC";
                sql = sql1 + sql2 + sql3;
                break;
            case "3":
                //Lagerbiler
                sql1 = "SELECT WEBTYPE ,MODEL, CARCERTTYPE, count(*) as cnt FROM CarTable ";
                //sql1 = "SELECT WEBTYPE, CARCERTTYPE, count(*) as cnt FROM CarTable ";
                sql2 = "WHERE (Brand = '" + globalbrand+ "') ";
                sql2 = sqlAddFilter(sql2);
                sql2 = sql2 + "and NOT (SalesStatus = 'E1' or SalesStatus = 'E1' or SalesStatus = 'C1' or salesStatus = 'DB') ";
                //sql2 = sql2 + " and ((SalesStatus = 'D1') or (SalesStatus = 'B3' and RTrim(LTrim(DEALERACCOUNT))='7000')) ";
                //sql2 = sql2 + " and ((SalesStatus = 'D1') or (RTrim(LTrim(DEALERACCOUNT))='7000imp')) ";
                //sql2 = sql2 + " and NOT RTrim(LTrim(SALESACCOUNT)) ='R' AND not Len(RTrim(LTrim(SALESACCOUNT))) = 8 AND NOT RTrim(LTrim(SALESACCOUNT))='50757004' ";
                sql2 = sql2 + " and (RTrim(LTrim(SALESACCOUNT))<>'R' and RTrim(LTrim(SALESACCOUNT))<>'50757004')";
                sql2 = sql2 + "and (dataareaID = '" + dataAreaId + "') "; 
                sql2 = sql2 + "and (NewOrUsed = 0) ";
                //sql2 = sql2 + "and (ReservationVacant = 0) ";
                //sql2 = sql2 + "and (DEALERACCOUNT not like '%7000imp%') ";
                sql2 = sql2 + "and ( (UnitStatus='09' or UnitStatus='10' or UnitStatus = '11' or UnitStatus = '11a' or UnitStatus = '11am' or UnitStatus = '11b' or UnitStatus = '11c' or UnitStatus = '11d' or UnitStatus = '11e' or UnitStatus = '11f' or UnitStatus = '11g' or UnitStatus = '11h' or UnitStatus = '11i' or UnitStatus = '11j')) ";
                sql3 = "GROUP BY CARCERTTYPE,WEBTYPE,MODEL ORDER BY WEBTYPE ASC";
                //sql3 = "GROUP BY CARCERTTYPE,WEBTYPE ORDER BY WEBTYPE ASC";
                sql = sql1 + sql2 + sql3;
                break;
            case "4":
                //Indfriede lagerbiler
                sql1 = "SELECT WEBTYPE ,MODEL, CARCERTTYPE, count(*) as cnt FROM CarTable ";
                sql2 = "WHERE (Brand = '" + globalbrand + "') ";
                sql2 = sqlAddFilter(sql2);
                sql2 = sql2 + "and (SalesStatus = 'F1' or SalesStatus = 'F2') ";
                sql2 = sql2 + "and (dataareaID = '" + dataAreaId + "') ";
                sql2 = sql2 + "and (NewOrUsed = 0) ";
                //sql2 = sql2 + "and (DEALERACCOUNT not like '%7000imp%') ";
                sql2 = sql2 + "and (UnitStatus = '11j' or UnitStatus = '11h') ";
                sql2 = sql2 + "and (DEALERACCOUNT = SALESACCOUNT) ";
                sql3 = "GROUP BY CARCERTTYPE,WEBTYPE,MODEL ORDER BY WEBTYPE ASC";
                sql = sql1 + sql2 + sql3;
                break;
        }

        sqlconn = getConnection();

        sqlcom = new SqlCommand(sql, sqlconn);
        SqlDataAdapter sqladapt = new SqlDataAdapter(sql, sqlconn);
        DataSet ds = new DataSet();

        sqladapt.Fill(ds);
        
        testlbl.Text = "(" + ds.Tables[0].Rows.Count.ToString() + " linjer fundet.) ";

        writefile(login + " - " + user + " - " + DateTime.Now.ToShortDateString() + " - " + DateTime.Now.ToShortTimeString() + " : " + sql);

        if (ddlModel.Items.Count < 1)
        {
            sql = "SELECT Distinct(WEBTYPE) FROM CarTable " + sql2 + " ORDER BY WEBTYPE";
            sqlcom = new SqlCommand(sql, sqlconn);
            sqlconn.Open();
            SqlDataReader sqlread2 = sqlcom.ExecuteReader();
            string carModel = "", carModelRead = "";
            ddlModel.Items.Add("");
            while (sqlread2.Read())
            {
                words = sqlread2["WEBTYPE"].ToString().Split(' ');
                if (carModel == "")
                {
                    if (words[0].ToLower() == "ceed" && words[1].ToLower() == "pro")
                        carModel = words[0]+" "+ words[1];
                    else
                        carModel = words[0];
                }

                if (words[0].ToLower() == "ceed" && words[1].ToLower() == "pro")
                    carModelRead = words[0]+" "+words[1];
                else
                    carModelRead = words[0];

                if (carModel.ToLower() != carModelRead.ToLower())
                {
                    ddlModel.Items.Add(carModel.ToLower());
                    carModel = carModelRead.ToLower();
                }
            }
            if (carModel != "")
                ddlModel.Items.Add(carModel.ToLower());

            sqlconn.Close();
        }

        if (ddlModel.Text.ToString() != "")
        {
            if (ddlMotor.Items.Count < 1)
            {
                sqlMotor = "SELECT Distinct(WEBTYPE) FROM CarTable " + sql2 +" ORDER BY WEBTYPE ASC";

                sqlcom = new SqlCommand(sqlMotor, sqlconn);
                sqlconn.Open();
                SqlDataReader sqlread4 = sqlcom.ExecuteReader();
                string motor = "", motorRead = "";
                ddlMotor.Items.Add("");
                while (sqlread4.Read())
                {
                    words = sqlread4["WEBTYPE"].ToString().Split(' ');

                    if (motor == "")
                    {
                        if (words[0].ToUpper() == "CEED" && words[1].ToUpper() == "PRO")
                            motor = words[2];
                        else
                            motor = words[1];
                    }

                    if (words[0].ToUpper() == "CEED" && words[1].ToUpper() == "PRO")
                        motorRead = words[2];
                    else
                        motorRead = words[1];

                    if (motor != motorRead)
                    {
                        ddlMotor.Items.Add(motor);
                        motor = motorRead;
                    }
                }
                if (motor != "")
                    ddlMotor.Items.Add(motor);
                sqlconn.Close();
            }

            if (ddlMotor.Text.ToString() != "")
            {
                if (ddlType.Items.Count < 1)
                {
                    sqlType = "SELECT Distinct(WEBTYPE) FROM CarTable " + sql2 + " ORDER BY WEBTYPE ASC";
                    sqlcom = new SqlCommand(sqlType, sqlconn);
                    sqlconn.Open();
                    SqlDataReader sqlread4 = sqlcom.ExecuteReader();
                    string carType = "", carTypeRead = "";
                    ddlType.Items.Add("");
                    while (sqlread4.Read())
                    {
                        words = sqlread4["WEBTYPE"].ToString().Split(' ');

                        if (carType == "")
                        {
                            if (words[0].ToLower() == "ceed" && words[1].ToLower() == "pro")
                            {
                                for (int i = 3; i < words.Length; i++)
                                    carType += words[i] + (i<words.Length-1 ? " ": "");
                            }
                            else
                            {
                                for (int i = 2; i < words.Length; i++)
                                    carType += words[i] + (i < words.Length-1 ? " " : "");
                            }
                        }

                        if (words[0].ToLower() == "ceed" && words[1].ToLower() == "pro")
                        {
                            carTypeRead = "";
                            for (int i = 3; i < words.Length; i++)
                                carTypeRead += words[i] + (i < words.Length-1 ? " " : "");
                        }
                        else
                        {
                            carTypeRead = "";
                            for (int i = 2; i < words.Length; i++)
                                carTypeRead += words[i] + (i < words.Length-1 ? " " : "");
                        }
                        if (carType != carTypeRead)
                        {
                            ddlType.Items.Add(carType);
                            carType = carTypeRead;
                        }
                    }
                    if (carType != "" && carType != carTypeRead)
                        ddlType.Items.Add(carType);
                    
                    sqlconn.Close();
                }


            }

            if (ddlModel.Text.ToString() != "" || (ddlMotor.Text.ToString() != "" && ddlType.Text.ToString() != ""))
            {
                if (ddlColor.Items.Count < 1)
                {
                    sqlColor = "SELECT Distinct(ColorDescExt) FROM CarTable " + sql2;

                    sqlcom = new SqlCommand(sqlColor, sqlconn);
                    sqlconn.Open();
                    SqlDataReader sqlread3 = sqlcom.ExecuteReader();
                    ddlColor.Items.Add("");
                    while (sqlread3.Read())
                    {
                        ddlColor.Items.Add(sqlread3["ColorDescExt"].ToString().Trim());
                    }
                    sqlconn.Close();
                }
            }
        }
        return ds;
    }

    string dateFileFormat()
    {
        string d = DateTime.Today.ToString("yyyMMdd");
        return d;
    }

    void writefile(string sql)
    {
        string mydocpath = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);

        using (StreamWriter outfile = new StreamWriter("/inetpub/wwwroot/dealerfo.isuzu.nu/log/VognLagerLog_"+ dateFileFormat() +".txt", true))
        {
            outfile.WriteLine(sql.ToString());
        }
    }

    DataSet getDetailListData(string mode, string carCertType, string model, string WebType)
    {
        HttpCookie KiaCookie = Request.Cookies[globalcookie];
        string[] KiaLoginArr = Server.HtmlEncode(KiaCookie.Value).Split('&');
        string login = KiaLoginArr[0].Remove(0, 5).Substring(0, 4);
        ArrayList AccountArr = new ArrayList();
        SqlCommand sqlcom;
        string sql = "";

        switch (mode)
        {
            case "1":
                //Aktivlisten detail
                int MainFound = 0;
                sqlconn = getConnection();
                sql = "SELECT INVOICEACCOUNT FROM CUSTTABLE WHERE ltrim(ACCOUNTNUM) = '" + login + "' and '" + dataAreaId + "'";
                sqlcom = new SqlCommand(sql, sqlconn);
                sqlconn.Open();
                string invoiceAcc = sqlcom.ExecuteScalar().ToString().Trim();
                sqlconn.Close();

                if (invoiceAcc != "" && invoiceAcc != login)
                {
                    sql = "SELECT ACCOUNTNUM FROM CUSTTABLE WHERE ltrim(invoiceaccount) = '" + invoiceAcc.Trim() + "' and '" + dataAreaId + "'";
                    sqlcom = new SqlCommand(sql, sqlconn);
                    sqlconn.Open();
                    SqlDataReader sqlread = sqlcom.ExecuteReader();

                    while (sqlread.Read())
                    {
                        AccountArr.Add(sqlread["ACCOUNTNUM"]);
                    }
                    sqlconn.Close();
                }
                else
                {
                    sql = "SELECT MAINACCOUNT FROM CISCustTableCarInventGroup WHERE Blocked = 0 AND ltrim(custaccount) = '" + login + "' and '" + dataAreaId + "'";
                    sqlcom = new SqlCommand(sql, sqlconn);
                    sqlconn.Open();
                    SqlDataReader sqlread = sqlcom.ExecuteReader();
                    while (sqlread.Read())
                    {
                        AccountArr.Add(sqlread["MAINACCOUNT"]).ToString().Trim();
                        MainFound = 1;
                    }
                    sqlconn.Close();

                    AccountArr.Add(login);

                }

                sql = "SELECT DMS_CarTransportationOrder.DEALERTRANSPORTDATE,NELCONSDATE,DEALERACCOUNT,SALESSTATUS,SALESACCOUNT,DLVDATE,EXPARRIVAL,UNITSTATUS,MODEL,ACCOUNT,ColorDescExt,ColorDescInt,CAROWNERACCOUNT,COOOrderId, CarTable.NEL_XALFILEID, CarTable.NEL_XALRECID ";
                sql = sql + "FROM CarTable LEFT JOIN DMS_CarTransportationOrder ON DMS_CarTransportationOrder.CarAccount = CarTable.ACCOUNT ";
                sql = sql + "WHERE (Brand = '" +globalbrand + "') and (SalesStatus = '' or SalesStatus = 'B3' or SalesStatus = 'D1' or SalesStatus = 'DW' or SalesStatus = 'E1' or SalesStatus = 'F1' or SalesStatus = 'F2') ";
                sql = sql + "and (CarTable.dataareaID = '"+ dataAreaId + "') ";
                sql = sql + "and (NewOrUsed = 0 or NewOrUsed = 4) ";
                sql = sql + "and (UnitStatus = '05' or UnitStatus = '09' or UnitStatus = '10' or UnitStatus = '11' or UnitStatus = '11a' or UnitStatus = '11am' or UnitStatus = '11b' or UnitStatus = '11c' or UnitStatus = '11e' or UnitStatus = '11f' or UnitStatus = '11g' or UnitStatus = '11h' or UnitStatus = '11i' or UnitStatus = '11j' or UnitStatus = '11q' or UnitStatus = '11r' or UnitStatus = '11s') ";
                sql = sql + "and CARCERTTYPE = '" + carCertType + "' ";
                sql = sql + "and MODEL = '" + model + "' ";
                sql = sql + "and WEBTYPE ='" + WebType + "' ";
                sql = sql + "and (DMS_CarTransportationOrder.DATAAREAID = '" + dataAreaId + "' or DMS_CarTransportationOrder.DATAAREAID is null) ";
                for (int c = 0; c < AccountArr.Count; c++)
                {
                    if (AccountArr.Count == 1)
                    {
                        sql = sql + "and (DEALERACCOUNT like '%" + AccountArr[c].ToString().Trim() + "%') ";
                    }
                    else
                    {
                        if (c == 0)
                            sql = sql + "and (DEALERACCOUNT like '%" + AccountArr[c].ToString().Trim() + "%' ";
                        else if (c == AccountArr.Count - 1)
                            sql = sql + "or DEALERACCOUNT like '%" + AccountArr[c].ToString().Trim() + "%') ";
                        else
                            sql = sql + "or DEALERACCOUNT like '%" + AccountArr[c].ToString().Trim() + "%' ";
                    }
                }
                sql = sqlAddFilterColor(sql);
                sql = sql + "order by ColorDescExt, NELCONSDATE";
                break;
            case "2":
                //Ordrebiler detail
                sql = "SELECT DLVDATE,EXPARRIVAL,NELCONSDATE,MODEL,ColorDescExt,ColorDescInt,UNITSTATUS,DEALERACCOUNT,ACCOUNT,NAME,PHONE,NELDEALER,CAROWNERACCOUNT,CarTable.NEL_XALFILEID, CarTable.NEL_XALRECID ";
                sql = sql + "FROM CarTable ";
                sql = sql + "LEFT JOIN CustTable ON CustTable.ACCOUNTNUM = CarTable.DEALERACCOUNT ";
                sql = sql + "WHERE (Brand = '" + globalbrand + "') ";
                sql = sql + "and (SalesStatus = '' or SalesStatus = 'B3' or SalesStatus = 'B1' or SalesStatus = 'C1') ";
                sql = sql + "and (CarTable.dataareaID = '" + dataAreaId + "') ";
                sql = sql + "and (NewOrUsed = 0 or NewOrUsed = 4) ";
                //sql = sql + "and (DEALERACCOUNT not like '%7000imp%') ";
                //sql = sql + "and (UnitStatus = '05' or UnitStatus = '09' or UnitStatus = '10' or UnitStatus = '11a' or UnitStatus = '11am' or UnitStatus = '11b' or UnitStatus = '11c' or UnitStatus = '11e' or UnitStatus = '11f' or UnitStatus = '11g' or UnitStatus = '11q' or UnitStatus = '11r' or UnitStatus = '11s' or UnitStatus = '11h' or UnitStatus = '11') ";
                sql = sql + "and (UnitStatus = '05' or UnitStatus = '09' or UnitStatus = '10' or UnitStatus = '11am' or UnitStatus = '11b' or UnitStatus = '11c' or UnitStatus = '11e' or UnitStatus = '11f' or UnitStatus = '11g' or UnitStatus = '11q' or UnitStatus = '11r' or UnitStatus = '11s' or UnitStatus = '11h' or UnitStatus = '11') ";
                sql = sql + "and CARCERTTYPE = '" + carCertType + "' ";
                sql = sql + "and MODEL = '" + model + "' ";
                sql = sql + "and WEBTYPE ='" + WebType + "' ";
                sql = sql + "and CustTable.DATAAREAID = '" + dataAreaId + "' ";
                sql = sqlAddFilterColor(sql);
                sql = sql + "order by ColorDescExt, NELCONSDATE";
                break;
            case "3":
                //Lagerbiler detail
                sql = "SELECT DMS_CarTransportationOrder.DEALERTRANSPORTDATE,ACCOUNT,SALESSTATUS,UNITSTATUS,SERIELNO,DLVDATE,EXPARRIVAL,DEALERACCOUNT,NELCONSDATE,MODEL,ColorDescExt,ColorDescInt,CAROWNERACCOUNT,ACCOUNT,NAME,PHONE,NELDEALER,INVOICEACCOUNT,CarTable.NEL_XALFILEID, CarTable.NEL_XALRECID ";
                sql = sql + "FROM CarTable ";
                sql = sql + "LEFT JOIN CustTable ON CustTable.ACCOUNTNUM = CarTable.DEALERACCOUNT ";
                sql = sql + "LEFT JOIN DMS_CarTransportationOrder ON DMS_CarTransportationOrder.CarAccount = CarTable.ACCOUNT ";
                sql = sql + "WHERE (Brand = '" +globalbrand + "') ";
                sql = sql + "and NOT (SalesStatus = 'E1' or SalesStatus = 'E1' or SalesStatus = 'C1' or SalesStatus = 'DB') ";
                //sql = sql + "and (SalesStatus = 'D1' OR SalesStatus= 'C1') "; khk 14021013
                //sql = sql + "and (SalesStatus = 'D1') ";
                //sql = sql + "and (SalesStatus = 'D1' or SalesStatus = 'B3') "; duer ikke
                //sql = sql + " and ((SalesStatus = 'D1') or (SalesStatus = 'B3' and RTrim(LTrim(DEALERACCOUNT))='7000')) ";
                //sql = sql + " and ((SalesStatus = 'D1') or (RTrim(LTrim(DEALERACCOUNT))='7000imp')) ";
                //sql = sql + " and (RTrim(LTrim(SALESACCOUNT))<>'R' and Len(RTrim(LTrim(SALESACCOUNT)))<> 4 and RTrim(LTrim(SALESACCOUNT))<>'50757004') "; 
                sql = sql + " and (RTrim(LTrim(SALESACCOUNT))<>'R' and RTrim(LTrim(SALESACCOUNT))<>'50757004') ";
                //sql = sql + " and NOT RTrim(LTrim(SALESACCOUNT)) = 'R' and NOT Len(RTrim(LTrim(SALESACCOUNT))) = 8 and NOT RTrim(LTrim(SALESACCOUNT)) = '50757004' ";
                sql = sql + "and (CarTable.dataareaID = '" + dataAreaId+ "') ";
                sql = sql + "and (NewOrUsed = 0) ";
                //sql = sql + "and (ReservationVacant = 0) ";
                //sql = sql + "and (DEALERACCOUNT not like '%7000imp%') ";
                sql = sql + "and (UnitStatus='09' or UnitStatus='10' or UnitStatus = '11' or UnitStatus = '11a' or UnitStatus = '11am' or UnitStatus = '11b' or UnitStatus = '11c' or UnitStatus = '11d' or UnitStatus = '11e' or UnitStatus = '11f' or UnitStatus = '11g' or UnitStatus = '11h' or UnitStatus = '11i' or UnitStatus = '11j') ";
                sql = sql + "and CARCERTTYPE = '" + carCertType + "' ";
                sql = sql + "and MODEL = '" + model + "' ";
                sql = sql + "and WEBTYPE ='" + WebType + "' ";
                sql = sql + "and CustTable.DATAAREAID = '"+ dataAreaId +"' ";
                sql = sqlAddFilterColor(sql);
        		sql = sql + "order by ColorDescExt, NELCONSDATE";
                break;
            case "4":
                //Indfriede lagerbiler detail
                sql = "SELECT ACCOUNT,DLVDATE,EXPARRIVAL,DEALERACCOUNT,NELCONSDATE,MODEL,ColorDescExt,ColorDescInt,NAME,PHONE,NELDEALER,CAROWNERACCOUNT,CarTable.NEL_XALFILEID, CarTable.NEL_XALRECID ";
                sql = sql + "FROM CarTable ";
                sql = sql + "LEFT JOIN CustTable ON CustTable.ACCOUNTNUM = CarTable.DEALERACCOUNT ";
                sql = sql + "WHERE (Brand = '" +globalbrand +"') ";
                sql = sql + "and (SalesStatus = 'F1' or SalesStatus = 'F2') ";
                sql = sql + "and (CarTable.dataareaID = '"+ dataAreaId+"') ";
                sql = sql + "and (NewOrUsed = 0) ";
                //sql = sql + "and (DEALERACCOUNT not like '%7000imp%') ";
                sql = sql + "and (UnitStatus = '11j' or UnitStatus = '11h') ";
                sql = sql + "and (DEALERACCOUNT = SALESACCOUNT) ";
                sql = sql + "and CARCERTTYPE = '" + carCertType + "' ";
                sql = sql + "and MODEL = '" + model + "' ";
                sql = sql + "and WEBTYPE ='" + WebType + "' ";
                sql = sql + "and CustTable.DATAAREAID = '" + dataAreaId + "' ";
                sql = sqlAddFilterColor(sql);
                sql = sql + "order by ColorDescExt, NELCONSDATE";
                break;
        }

        sqlconn = getConnection();

        sqlcom = new SqlCommand(sql, sqlconn);
        SqlDataAdapter sqladapt = new SqlDataAdapter(sql, sqlconn);
        DataSet ds = new DataSet();

        sqladapt.Fill(ds);

        //writefile(login + " - " + user + " - " + DateTime.Now.ToShortDateString() + " - " + DateTime.Now.ToShortTimeString() + " : " + sql);
        writefile(login + " - " + DateTime.Now.ToShortDateString() + " - " + DateTime.Now.ToShortTimeString() + " : " + sql);

        return ds;
    }

    SqlConnection getConnection()
    {
        SqlConnection sqlconn = new SqlConnection();
        sqlconn.ConnectionString = "UID=kiaweb;PWD=stop4bud; Initial Catalog=axdb30sp1kia-r; Data Source=172.20.16.57";
        //sqlconn.ConnectionString = "UID=kiaweb;PWD=stop4bud; Initial Catalog=axdb30sp1kia; Data Source=172.20.16.24"; //Original SQL Server = srv-sql-001

        return sqlconn;
    }

    public string formatCarcertType(string type)
    {
        switch (type)
        {
            case "0":
                return "Personbil";
            case "1":
                return "Varevogn";
            case "2":
                return "Autocamper";
            case "3":
                return "Fleet";
            case "4":
                return "IMP";
            default:
                return "";
        }
    }

    Boolean checklogin()
    {
        bool loggedin = true;
        HttpCookie KiaCookie = Request.Cookies[globalcookie];
        if (KiaCookie == null)
            loggedin = false;
        else
        {
            string user = KiaCookie["user"];
            if (user == "")
                loggedin = false;
        }
        return loggedin;
    }

    protected void webtypeBtn_OnClick(object source, RepeaterCommandEventArgs e)
    {
        HttpCookie KiaCookie = Request.Cookies[globalcookie];
        string[] KiaLoginArr = Server.HtmlEncode(KiaCookie.Value).Split('&');
        string login = KiaLoginArr[0].Remove(0, 5).Substring(0, 4);
        //string login = "4000";

        sqlconn = getConnection();
        
        string sql = "SELECT INVOICEACCOUNT FROM CUSTTABLE WHERE ltrim(ACCOUNTNUM) = '" + login + "' and dataareaid = '"+ dataAreaId +"'";
        SqlCommand sqlcom = new SqlCommand(sql, sqlconn);
        sqlconn.Open();
        string invoiceAcc = sqlcom.ExecuteScalar().ToString().Trim();
        sqlconn.Close();

        sql = "SELECT TEXT, UNITSTATUS FROM NELUNITSTATUSTABLE WHERE DATAAREAID = '" + dataAreaId + "'"; 
        sqlcom = new SqlCommand(sql, sqlconn);
        sqlconn.Open();
        SqlDataReader sqlread = sqlcom.ExecuteReader();
        Hashtable unitStatusLst = new Hashtable();
        while (sqlread.Read())
        {
            unitStatusLst.Add(sqlread["UNITSTATUS"], sqlread["TEXT"]);
        }
        sqlconn.Close();

        sql = "SELECT SALESSTATUS, DESCRIPTION FROM NELCAR_SALESSTATUSTABLE WHERE DATAAREAID = '" + dataAreaId + "'";
        sqlcom = new SqlCommand(sql, sqlconn);
        sqlconn.Open();
        sqlread = sqlcom.ExecuteReader();
        Hashtable saleStatusLst = new Hashtable();
        while (sqlread.Read())
        {
            saleStatusLst.Add(sqlread["SALESSTATUS"], sqlread["DESCRIPTION"]);
        }
        sqlconn.Close();

        Repeater src = (Repeater)source;
        string mode = Request.QueryString["m"];
        if (mode == null)
            mode = "1";

        System.Web.UI.HtmlControls.HtmlTableRow tr = (System.Web.UI.HtmlControls.HtmlTableRow)e.Item.FindControl("reprow");
        string repOpenStrCurr = ((Label)e.Item.FindControl("repOpenlbl")).Text;

        if (repOpenStrCurr == "1")
        {
            ((Label)e.Item.FindControl("repOpenlbl")).Text = "0";
            tr.BgColor = "#FFFFFF";
            tr.Style.Add("font-weight", "normal");
        }
        else
        {
            ((Label)e.Item.FindControl("repOpenlbl")).Text = "1";
            tr.BgColor = "#FF8575";
            tr.Style.Add("font-weight", "bold");
        }

        for (int i = 0; i < src.Items.Count; i++)
        {
            PlaceHolder pl = (PlaceHolder)src.Items[i].FindControl("PlaceHolder1");
            string repOpenStr = ((Label)src.Items[i].FindControl("repOpenlbl")).Text.Trim();
            if (repOpenStr == "1")
            {
                pl.Visible = true;
                string carCertType = ((Label)src.Items[i].FindControl("carCertTypelblnbr")).Text.Trim();
                string model = ((Label)src.Items[i].FindControl("modelLbl")).Text.Trim();
                string WebType = ((LinkButton)src.Items[i].FindControl("webtypeBtn")).Text.Trim();

                Repeater rep = new Repeater();

                switch (mode)
                {
                    case "1":
                        rep.HeaderTemplate = new aktivDetailListTemplate(ListItemType.Header, unitStatusLst, saleStatusLst);
                        rep.ItemTemplate = new aktivDetailListTemplate(ListItemType.Item, unitStatusLst, saleStatusLst);
                        rep.AlternatingItemTemplate = new aktivDetailListTemplate(ListItemType.AlternatingItem, unitStatusLst, saleStatusLst);
                        rep.FooterTemplate = new aktivDetailListTemplate(ListItemType.Footer, unitStatusLst, saleStatusLst);
                        break;
                    case "2":
                        rep.HeaderTemplate = new ordreBilDetailListTemplate(ListItemType.Header, unitStatusLst);
                        rep.ItemTemplate = new ordreBilDetailListTemplate(ListItemType.Item, unitStatusLst);
                        rep.AlternatingItemTemplate = new ordreBilDetailListTemplate(ListItemType.AlternatingItem, unitStatusLst);
                        rep.FooterTemplate = new ordreBilDetailListTemplate(ListItemType.Footer, unitStatusLst);
                        break;
                    case "3":
                        rep.HeaderTemplate = new lagerBilDetailListTemplate(ListItemType.Header, invoiceAcc);
                        rep.ItemTemplate = new lagerBilDetailListTemplate(ListItemType.Item, invoiceAcc);
                        rep.AlternatingItemTemplate = new lagerBilDetailListTemplate(ListItemType.AlternatingItem, invoiceAcc);
                        rep.FooterTemplate = new lagerBilDetailListTemplate(ListItemType.Footer, invoiceAcc);
                        break;
                    case "4":
                        rep.HeaderTemplate = new indfriLagerBilDetailListTemplate(ListItemType.Header);
                        rep.ItemTemplate = new indfriLagerBilDetailListTemplate(ListItemType.Item);
                        rep.AlternatingItemTemplate = new indfriLagerBilDetailListTemplate(ListItemType.AlternatingItem);
                        rep.FooterTemplate = new indfriLagerBilDetailListTemplate(ListItemType.Footer);
                        break;
                }


                rep.ID = "detailRepeater";

                rep.DataSource = getDetailListData(mode, carCertType, model, WebType);
                rep.DataBind();

                //((Label)src.Items[i].FindControl("repOpenlbl")).Text = "1";

                pl.Controls.Add(rep);
            }
            else
            {
                //Repeater rep = (Repeater)pl.FindControl("detailRepeater");
                ((Label)src.Items[i].FindControl("repOpenlbl")).Text = "0";
                pl.Visible = false;

            }
        }
    }
}

class aktivDetailListTemplate : ITemplate
{
    static int itemcount = 0;
    ListItemType templateType;
    Hashtable unitStatusHshtbl;
    Hashtable saleStatusHshtbl;

    public aktivDetailListTemplate(ListItemType type, Hashtable unitSatusLst, Hashtable salesSatusLst)
    {
        templateType = type;
        unitStatusHshtbl = unitSatusLst;
        saleStatusHshtbl = salesSatusLst;
    }

    public void InstantiateIn(System.Web.UI.Control container)
    {
        Literal lc = new Literal();
        switch (templateType)
        {
            case ListItemType.Header:
                lc.Text = "<tr><td colspan='3' style=\"padding:0px;\"><table class='detaillist' cellspacing='0'><tr><th>Model</th><th>Vognnr</th><th>Forhandler</th><th>Status</th><th>Farve</th><th>Ankomst</th><th>Slutkunde</th><th>Vognm. bestilt</th><th>Konsignation</th><th>I</th><th>R</th><th>S</th></tr>";
                break;
            case ListItemType.Item:
                lc.Text = "<tr class='detaillistrow'><td>";
                lc.DataBinding += new EventHandler(TemplateControl_DataBinding);
                break;
            case ListItemType.AlternatingItem:
                lc.Text = "<tr class='detaillistrowalt'><td>";
                lc.DataBinding += new EventHandler(TemplateControl_DataBinding);
                break;
            case ListItemType.Footer:
                lc.Text = "</table></td></tr>";
                break;

        }
        container.Controls.Add(lc);
        itemcount += 1;
    }
    private void TemplateControl_DataBinding(object sender, System.EventArgs e)
    {
        Literal lc;
        lc = (Literal)sender;
        RepeaterItem container = (RepeaterItem)lc.NamingContainer;

        string dlvDateStr = "";
        string DealerTrspDateStr = "";
        DateTime dlvDate = DateTime.Parse(DataBinder.Eval(container.DataItem, "DLVDATE").ToString());
        DateTime expDate = DateTime.Parse(DataBinder.Eval(container.DataItem, "EXPARRIVAL").ToString());

        if (dlvDate > DateTime.Parse("01-01-1901"))
            dlvDateStr = dlvDate.ToString("dd-MM-yyyy") + " A";
        else
            //dlvDateStr = expDate.ToString("MMMM yyyy") + " F";
            dlvDateStr = expDate.ToString("dd-MM-yyyy") + " F";

        if (DataBinder.Eval(container.DataItem, "DEALERTRANSPORTDATE") != null)
        {
            if (DataBinder.Eval(container.DataItem, "DEALERTRANSPORTDATE").ToString() != "")
                DealerTrspDateStr = DateTime.Parse(DataBinder.Eval(container.DataItem, "DEALERTRANSPORTDATE").ToString()).ToString("dd-MM-yyyy");
        }


        lc.Text += DataBinder.Eval(container.DataItem, "MODEL");
        lc.Text += "</td><td>";

        if (DataBinder.Eval(container.DataItem, "COOOrderId").ToString() != "")
            lc.Text += "<a href='/AxSearch/carSearch.asp?CarAccount=" + DataBinder.Eval(container.DataItem, "ACCOUNT") + "'/a>" + DataBinder.Eval(container.DataItem, "ACCOUNT") + "/" + DataBinder.Eval(container.DataItem, "COOOrderId");
        else
            lc.Text += "<a href='/AxSearch/carSearch.asp?CarAccount=" + DataBinder.Eval(container.DataItem, "ACCOUNT") + "'/a>" + DataBinder.Eval(container.DataItem, "ACCOUNT");

        lc.Text += "</td><td>";
        lc.Text += DataBinder.Eval(container.DataItem, "DEALERACCOUNT");
        lc.Text += "</td><td>";
        lc.Text += "<a href='javascript:alert(\"" + getUnitStatusHelptxt(DataBinder.Eval(container.DataItem, "UNITSTATUS").ToString()) + "\")' title='" + getUnitStatusHelptxt(DataBinder.Eval(container.DataItem, "UNITSTATUS").ToString()) + "'>" + DataBinder.Eval(container.DataItem, "UNITSTATUS") + "</a> <a href='javascript:alert(\"" + getSaleStatusHelptxt(DataBinder.Eval(container.DataItem, "SALESSTATUS").ToString()) + "\")' title='" + getSaleStatusHelptxt(DataBinder.Eval(container.DataItem, "SALESSTATUS").ToString()) + "'>" + DataBinder.Eval(container.DataItem, "SALESSTATUS") + "</a>";
        lc.Text += "</td><td>";
        //lc.Text += DataBinder.Eval(container.DataItem, "COLOUR") + "/" + DataBinder.Eval(container.DataItem, "COVERCOLOR");
        lc.Text += DataBinder.Eval(container.DataItem, "ColorDescExt") + "/" + DataBinder.Eval(container.DataItem, "ColorDescInt");


        lc.Text += "</td><td>";
        lc.Text += dlvDateStr;
        lc.Text += "</td><td>";
        lc.Text += DataBinder.Eval(container.DataItem, "CAROWNERACCOUNT");
        lc.Text += "</td><td>";
        lc.Text += DealerTrspDateStr;
        lc.Text += "</td><td>";


        string saleStatusKode = DataBinder.Eval(container.DataItem, "SALESSTATUS").ToString();
        string saleSatusStr = "";
        bool certReq = false;
        bool saleReq = false;
        string unitStatus = DataBinder.Eval(container.DataItem, "UNITSTATUS").ToString();
        string saleStatus = DataBinder.Eval(container.DataItem, "SALESSTATUS").ToString();
        string consFree   = DataBinder.Eval(container.DataItem, "NEL_XALFILEID").ToString();
        string consDaysLeft = DataBinder.Eval(container.DataItem, "NEL_XALRECID").ToString();
        //if (consFree == "1" || unitStatus == "11a" || unitStatus == "11h" || unitStatus == "11i" || unitStatus == "11j" || unitStatus == "11m" || unitStatus == "11n" || unitStatus == "11p" || unitStatus == "11q" || unitStatus == "11r" || unitStatus == "11s")
        if (consFree == "1" || unitStatus == "11j" || unitStatus == "11h" || unitStatus == "14")
        {
            certReq = true;
        }

        switch (saleStatusKode)
        {
            case "DW":
                saleSatusStr = "IRK-kode bestilt";
                break;
            case "D1":
                //saleSatusStr = getKonstxt(DateTime.Parse(DataBinder.Eval(container.DataItem, "NELCONSDATE").ToString()));
                saleSatusStr = getKonstxt2(consFree,consDaysLeft);
                break;
            case "E1":
                saleSatusStr = "Ordrebekræftet";
                saleReq = true;
                break;
            case "F1":
                saleSatusStr = "Indfriet";
                saleReq = true;
                break;
            case "F2":
                saleSatusStr = "Indfriet";
                saleReq = true;
                break;
        }

        lc.Text += saleSatusStr;
        lc.Text += "</td><td>";

        if (DataBinder.Eval(container.DataItem, "SALESSTATUS").ToString() != "DW" && certReq == true && saleReq == false)
        {
            lc.Text += "<input type=button value=\"I\" title=\"Indfri bil / Bestilling af IRK-kode.\" class=\"btn\" onclick='window.location=\"register_certificate.asp?Return_Id=2&carAccount=" + DataBinder.Eval(container.DataItem, "ACCOUNT") + "\"'>";
            lc.Text += "</td><td>";
        }
        else
        {
            lc.Text += "&nbsp";
            lc.Text += "</td><td>";
        }

        if (saleReq == true)
        {
            lc.Text += "<input type=button value=\"R\" title=\"Registreringsanmeldelse.\" class=\"btn\" onclick='window.location=\"register_carsale.asp?Return_Id=2&carAccount=" + DataBinder.Eval(container.DataItem, "ACCOUNT") + "\"'>";
            lc.Text += "</td><td>";
        }
        else
        {
            lc.Text += "&nbsp";
            lc.Text += "</td><td>";
        }

        if ((DataBinder.Eval(container.DataItem, "SALESSTATUS").ToString() == "") || 1==1)
        {
            lc.Text += "<input type=button value=\"S\" title=\"Salgsmarkering.\" class=\"btn\" onclick='window.location=\"register_salesmark.asp?Return_Id=2&carAccount=" + DataBinder.Eval(container.DataItem, "ACCOUNT") + "\"'>";
            lc.Text += "</td>";
        }
        else
        {
            lc.Text += "<input type=button value=\"S\" class=\"btn\" disabled=true>";
            lc.Text += "</td>";
        }

        lc.Text += "</tr>";
    }

    string getKonstxt(DateTime kons)
    {
        string konsstr = "";
        int d1 = 0;
        kons = kons.AddDays(16);
        TimeSpan d = kons - DateTime.Now;
        d1 = d.Days + 1;
        if (d1 <= 0 || (kons.ToShortDateString() == DateTime.Now.ToShortDateString() && (int)DateTime.Now.Hour >= 9))
            konsstr = "Bilen er fri";
        else
        {
            if ((kons.ToShortDateString() == DateTime.Now.ToShortDateString() && (int)DateTime.Now.Hour < 9))
                konsstr = "Ledig kl. 9";
            else
            {
                if (d1 == 1)
                    konsstr = d1 + " Dag tilbage";
                else
                    konsstr = d1 + " Dage tilbage";
            }
        }
        return konsstr;
    }

    string getKonstxt2(string conFree, string conDaysLeft)
    {
        string konsstr = "";
        if (conFree == "1")
            konsstr = "Bilen er fri";
        else
        {
            if (conDaysLeft == "0")
                konsstr = "Ledig kl. 9";
            else
                konsstr = conDaysLeft + " Dage tilbage";
        }
        return konsstr;
    }

    string getSaleStatusHelptxt(string status)
    {
        if (status != "")
            return saleStatusHshtbl[status].ToString();
        else
            return "";
    }

    string getUnitStatusHelptxt(string status)
    {
        if (status != "")
            return unitStatusHshtbl[status].ToString();
        else
            return "";
    }
}

class ordreBilDetailListTemplate : ITemplate
{
    static int itemcount = 0;
    ListItemType templateType;
    Hashtable unitStatusHshtbl;
    public ordreBilDetailListTemplate(ListItemType type, Hashtable unitSatusLst)
    {
        templateType = type;
        unitStatusHshtbl = unitSatusLst;
    }

    public void InstantiateIn(System.Web.UI.Control container)
    {
        Literal lc = new Literal();
        switch (templateType)
        {
            case ListItemType.Header:
                lc.Text = "<tr><td colspan='3' style=\"padding:0px;\"><table class='detaillist' cellspacing='0'><tr><th>Model</th><th>Vognnr</th><th>Status</th><th>Farve</th><th>Forhandler</th><th>Telefon</th><th>Forv. ankomst</th><th>Ankomstdato</th></tr>";
                break;
            case ListItemType.Item:
                lc.Text = "<tr class='detaillistrow'><td>";
                lc.DataBinding += new EventHandler(TemplateControl_DataBinding);
                break;
            case ListItemType.AlternatingItem:
                lc.Text = "<tr class='detaillistrowalt'><td>";
                lc.DataBinding += new EventHandler(TemplateControl_DataBinding);
                break;
            case ListItemType.Footer:
                lc.Text = "</table></td></tr>";
                break;

        }
        container.Controls.Add(lc);
        itemcount += 1;
    }
    private void TemplateControl_DataBinding(object sender, System.EventArgs e)
    {
        Literal lc;
        lc = (Literal)sender;
        RepeaterItem container = (RepeaterItem)lc.NamingContainer;

        string dlvDateStr = "";
        string expectedDateStr = "";
        string ownerCust = "";

        DateTime dlvDate = DateTime.Parse(DataBinder.Eval(container.DataItem, "DLVDATE").ToString());
        DateTime expDate = DateTime.Parse(DataBinder.Eval(container.DataItem, "EXPARRIVAL").ToString());

        if (dlvDate > DateTime.Parse("01-01-1901"))
            dlvDateStr = dlvDate.ToString("dd-MM-yyyy");
        else
        {
            //expectedDateStr = expDate.ToString("MMMM yyyy");
            expectedDateStr = expDate.ToString("dd-MM-yyyy");
            if (expDate < DateTime.Parse("01-01-2000"))
                expectedDateStr = "(Ukendt)";
        }

        ownerCust = DataBinder.Eval(container.DataItem, "CAROWNERACCOUNT").ToString();
        if (ownerCust != "")
            //ownerCust = " (Solgt)";
            ownerCust = "";
        else
            ownerCust = "";

        lc.Text += DataBinder.Eval(container.DataItem, "MODEL");
        lc.Text += "</td><td>";
        lc.Text += "<a href='/AxSearch/carSearch.asp?CarAccount=" + DataBinder.Eval(container.DataItem, "ACCOUNT") + "'/a>" + DataBinder.Eval(container.DataItem, "ACCOUNT");
        lc.Text += "</td><td>";
        lc.Text += "<a href='javascript:alert(\"" + getUnitStatusHelptxt(DataBinder.Eval(container.DataItem, "UNITSTATUS").ToString()) + "\")' title='" + getUnitStatusHelptxt(DataBinder.Eval(container.DataItem, "UNITSTATUS").ToString()) + "'>" + DataBinder.Eval(container.DataItem, "UNITSTATUS") + "</a>";
        lc.Text += "</td><td>";
        lc.Text += DataBinder.Eval(container.DataItem, "ColorDescExt") + "/" + DataBinder.Eval(container.DataItem, "ColorDescInt");
        lc.Text += "</td><td>";
        if (DataBinder.Eval(container.DataItem, "DEALERACCOUNT").ToString() != "")
            lc.Text += DataBinder.Eval(container.DataItem, "DEALERACCOUNT") + " " + DataBinder.Eval(container.DataItem, "NAME");
        lc.Text += "</td><td>";
        lc.Text += DataBinder.Eval(container.DataItem, "PHONE");
        lc.Text += "</td><td>";
        lc.Text += expectedDateStr+ownerCust;
        lc.Text += "</td><td>";
        lc.Text += dlvDateStr;
        lc.Text += "</td></tr>";
    }

    string getUnitStatusHelptxt(string status)
    {
        if (status != "")
            return unitStatusHshtbl[status].ToString();
        else
            return "";
    }
}


// Lagerliste
class lagerBilDetailListTemplate : ITemplate
{
    static int itemcount = 0;
    ListItemType templateType;
    static string modelOld;
    static string colorOld;
    static string dlvDateStrOld = "";
    static string dlvDateStrFirst = "";
    string invoiceAcc;

    public lagerBilDetailListTemplate(ListItemType type, string invoiceAccount)
    {
        templateType = type;
        invoiceAcc = invoiceAccount;
    }

    public void InstantiateIn(System.Web.UI.Control container)
    {
        Literal lc = new Literal();
        switch (templateType)
        {
            case ListItemType.Header:
                //lc.Text = "<tr><td colspan='3' style=\"padding:0px;\"><table class='detaillist' cellspacing='0'><tr><th>Model</th><th>Vognnr</th><th>Farve</th><th>Ankomst</th><th>Forhandler</th><th>Telefon</th><th>Konsignation</th><th>I</th></tr>";
                lc.Text = "<tr><td colspan='3' style=\"padding:0px;\"><table class='detaillist' cellspacing='0'><tr><th>VIN</th><th>Status</th><th>Vognnr</th><th>Farve</th><th>Ankomst</th><th>Forhandler</th><th></tr>";
                break;
            case ListItemType.Item:
                lc.Text = "<tr class='detaillistrow'><td>";
                lc.DataBinding += new EventHandler(TemplateControl_DataBinding);
                break;
            case ListItemType.AlternatingItem:
                lc.Text = "<tr class='detaillistrowalt'><td>";
                lc.DataBinding += new EventHandler(TemplateControl_DataBinding);
                break;
            case ListItemType.Footer:
                lc.Text = "</table></td></tr>";
                break;

        }
        container.Controls.Add(lc);
        itemcount += 1;
    }
    private void TemplateControl_DataBinding(object sender, System.EventArgs e)
    {
        Literal lc;
        lc = (Literal)sender;
        RepeaterItem container = (RepeaterItem)lc.NamingContainer;

        string dlvDateStr = "";

        DateTime dlvDate = DateTime.Parse(DataBinder.Eval(container.DataItem, "DLVDATE").ToString());
        DateTime expDate = DateTime.Parse(DataBinder.Eval(container.DataItem, "EXPARRIVAL").ToString());
        Boolean indfridisable = false;

        string vin = DataBinder.Eval(container.DataItem, "SERIELNO").ToString();
        string salesStatus = DataBinder.Eval(container.DataItem, "SALESSTATUS").ToString();
        string unitStatus = DataBinder.Eval(container.DataItem, "UNITSTATUS").ToString();
        string usStatus = unitStatus +" "+ salesStatus;
        string model = DataBinder.Eval(container.DataItem, "MODEL").ToString();
        string color = DataBinder.Eval(container.DataItem, "ColorDescExt").ToString() + "/" + DataBinder.Eval(container.DataItem, "ColorDescInt").ToString();
        string ownerCust;
        string consTxt = getKonstxt((DateTime)DataBinder.Eval(container.DataItem, "NELCONSDATE"));

        string consFree = DataBinder.Eval(container.DataItem, "NEL_XALFILEID").ToString();
        string consDaysLeft = DataBinder.Eval(container.DataItem, "NEL_XALRECID").ToString();
        string consTxt2 = getKonstxt2(consFree, consDaysLeft);


        if (DataBinder.Eval(container.DataItem, "DEALERACCOUNT").ToString().Trim() == "7000imp")
            consTxt2 = "Bilen er fri";        

        if (consTxt != "Bilen er fri")
            indfridisable = true;

        if (consFree == "1")
            indfridisable = false;
        
        if (dlvDate > DateTime.Parse("01-01-1901"))
            dlvDateStr = dlvDate.ToString("dd-MM-yyyy");
        else
            dlvDateStr = expDate.ToString("dd-MM-yyyy");

        //dlvDateStrFirst = dlvDateStr;

        if (model != modelOld || color != colorOld)
            dlvDateStrFirst = dlvDateStr;
        
        if (model == modelOld && color == colorOld)
            indfridisable = true;

        if (model == modelOld && color == colorOld && dlvDateStr == dlvDateStrOld && dlvDateStr == dlvDateStrFirst)
            indfridisable = false;
        
        //if (invoiceAcc != "")
        //{
        //    if (DataBinder.Eval(container.DataItem, "INVOICEACCOUNT").ToString().Trim() == invoiceAcc)
        //        indfridisable = false;
        //}

        ownerCust = DataBinder.Eval(container.DataItem, "CAROWNERACCOUNT").ToString();
        if (ownerCust != "")
            //ownerCust = " (Solgt)";
            ownerCust = "";
        else
            ownerCust = "";


        //lc.Text += model;
        lc.Text += vin;
        lc.Text += "</td><td>";
        lc.Text += usStatus;
        lc.Text += "</td><td>";
        lc.Text += "<a href='/AxSearch/carSearch.asp?CarAccount=" + DataBinder.Eval(container.DataItem, "ACCOUNT") + "'/a>" + DataBinder.Eval(container.DataItem, "ACCOUNT");
        lc.Text += "</td><td>";
        lc.Text += color;
        lc.Text += "</td><td>";
        lc.Text += dlvDateStr;
        lc.Text += "</td><td>";
        lc.Text += DataBinder.Eval(container.DataItem, "DEALERACCOUNT") + " " + DataBinder.Eval(container.DataItem, "NAME");
        lc.Text += "</td><td>";
        //lc.Text += DataBinder.Eval(container.DataItem, "PHONE");
        //lc.Text += "</td><td>";
        //lc.Text += consTxt2+ownerCust;
        //lc.Text += "</td><td>";
        //if (!indfridisable)
        //    lc.Text += "<input type=button value=\"I\" title=\"Indfri bil.\" class=\"btn\" onclick='window.location=\"register_certificate.asp?Return_Id=3&carAccount=" + DataBinder.Eval(container.DataItem, "ACCOUNT") + "\"'>";
        //else
        //    lc.Text += "<input type=button value=\"I\" title=\"Indfri bil.\" class=\"btn\" disabled onclick='window.location=\"register_certificate.asp?Return_Id=3&carAccount=" + DataBinder.Eval(container.DataItem, "ACCOUNT") + "\"'>";
        //lc.Text += "</td></tr>";
        modelOld = model;
        colorOld = color;
        dlvDateStrOld = dlvDateStr;
    }

    string getKonstxt(DateTime kons)
    {
        string konsstr = "";
        int d1 = 0;
        kons = kons.AddDays(16);
        TimeSpan d = kons - DateTime.Now;
        d1 = d.Days + 1;
        if (d1 <= 0 || (kons.ToShortDateString() == DateTime.Now.ToShortDateString() && (int)DateTime.Now.Hour >= 9))
            konsstr = "Bilen er fri";
        else
        {
            if ((kons.ToShortDateString() == DateTime.Now.ToShortDateString() && (int)DateTime.Now.Hour < 9))
                konsstr = "Ledig kl. 9";
            else
            {
                if (d1 == 1)
                    konsstr = d1 + " Dag tilbage";
                else
                    konsstr = d1 + " Dage tilbage";
            }
        }
        return konsstr;
    }

    string getKonstxt2(string conFree, string conDaysLeft)
    {
        string konsstr = "";
        if (conFree == "1")
            konsstr = "Bilen er fri";
        else
        {
            if (conDaysLeft == "0")
                konsstr = "Ledig kl. 9";
            else
                konsstr = conDaysLeft + " Dage tilbage";
        }
        return konsstr;
    }
}


class indfriLagerBilDetailListTemplate : ITemplate
{
    static int itemcount = 0;
    ListItemType templateType;
    public indfriLagerBilDetailListTemplate(ListItemType type)
    {
        templateType = type;
    }

    public void InstantiateIn(System.Web.UI.Control container)
    {
        Literal lc = new Literal();
        switch (templateType)
        {
            case ListItemType.Header:
                lc.Text = "<tr><td colspan='3' style=\"padding:0px;\"><table class='detaillist' cellspacing='0'><tr><th>Model</th><th>Vognnr</th><th>Farve</th><th>Ankomst</th><th>Forhandler</th><th>Telefon</th></tr>";
                break;
            case ListItemType.Item:
                lc.Text = "<tr class='detaillistrow'><td>";
                lc.DataBinding += new EventHandler(TemplateControl_DataBinding);
                break;
            case ListItemType.AlternatingItem:
                lc.Text = "<tr class='detaillistrowalt'><td>";
                lc.DataBinding += new EventHandler(TemplateControl_DataBinding);
                break;
            case ListItemType.Footer:
                lc.Text = "</table></td></tr>";
                break;

        }
        container.Controls.Add(lc);
        itemcount += 1;
    }
    private void TemplateControl_DataBinding(object sender, System.EventArgs e)
    {
        Literal lc;
        lc = (Literal)sender;
        RepeaterItem container = (RepeaterItem)lc.NamingContainer;

        string dlvDateStr = "";
        string ownerCust = "";

        DateTime dlvDate = DateTime.Parse(DataBinder.Eval(container.DataItem, "DLVDATE").ToString());
        DateTime expDate = DateTime.Parse(DataBinder.Eval(container.DataItem, "EXPARRIVAL").ToString());

        if (dlvDate > DateTime.Parse("01-01-1901"))
            dlvDateStr = dlvDate.ToString("dd-MM-yyyy");
        else
            //dlvDateStr = expDate.ToString("MMMM yyyy");
            dlvDateStr = expDate.ToString("dd-MM-yyyy");

        ownerCust = DataBinder.Eval(container.DataItem, "CAROWNERACCOUNT").ToString();
        if (ownerCust != "")
            //ownerCust = " (Solgt)";
            ownerCust = "";
        else
            ownerCust = "";

        lc.Text += DataBinder.Eval(container.DataItem, "MODEL");
        lc.Text += "</td><td>";
        lc.Text += "<a href='/AxSearch/carSearch.asp?CarAccount=" + DataBinder.Eval(container.DataItem, "ACCOUNT") + "'/a>" + DataBinder.Eval(container.DataItem, "ACCOUNT");
        lc.Text += "</td><td>";
        lc.Text += DataBinder.Eval(container.DataItem, "ColorDescExt") + "/" + DataBinder.Eval(container.DataItem, "ColorDescInt");
        lc.Text += "</td><td>";
        lc.Text += dlvDateStr;
        lc.Text += "</td><td>";
        lc.Text += DataBinder.Eval(container.DataItem, "DEALERACCOUNT") + " " + DataBinder.Eval(container.DataItem, "NAME");
        lc.Text += "</td><td>";
        lc.Text += DataBinder.Eval(container.DataItem, "PHONE")+ownerCust;
        lc.Text += "</td></tr>";
    }
}