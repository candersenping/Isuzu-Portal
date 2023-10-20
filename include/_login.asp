<%@ Language=VBScript %>
<!-- #include file="db.asp" -->
<!-- #include file="functions.asp" -->
<%

Session.Timeout=600

Dim Axapta, axRec1, axRec2
if DaID <> "" then
	s = "SELECT * FROM nelWPerson WHERE " & DaID & "BrugerKode='" & escape(Request.Form("login")) & "' AND AdgangsKode='" & escape(Request.Form("password")) & "'"
	set rs = conn.execute(s)
	if rs.eof then
		WriteErrorNF "Brugernavn eller brugerkode er forkert."
	else
		User = trim(rs("BrugerKode"))
		Response.Cookies("ISUZU")("cook_LastLogin") = Date2Str(rs("LastLogin"))
		Response.Cookies("ISUZU")("user") = User
		Response.Cookies("ISUZU")("user_Start") = Date()
		Response.Cookies("ISUZU").Expires = Date()+10
        Session("DealerUser") = trim(User)
        Session("DealerAccount") = trim(rs("DealerAccount"))
        Session("DealerCustAccount") = trim(rs("CustAccount"))

        if rs("COODealerId") <> "" then
            s = "SELECT * FROM CISCOOUsers WHERE DATAAREAID='KIT' AND DealerId=" & rs("COODealerId")
    	    set rsU = conn.execute(s)
            if not rsU.EOF then
                Response.Write "(" & s & ")"
                'Response.End
    	    	Session("WebLogon")        = trim(rsU("WebAccountType"))
	         	Session("WebLogonAccount") = trim(rsU("DealerId"))
            end if
        end if		  

		set Axapta = createObject("AxaptaCOMConnector.Axapta")
		Axapta.logon
		Axapta.ttsBegin
		'set axRec1 = Axapta.CreateRecord("nelWPerson")
		'axRec1.company = "ISU"
        's = "select forupdate * from where %1.BrugerKode2=='" & Request.Form("login") & "'"
		'axRec1.ExecuteStmt(s)
		'if axRec1.Found then
	    '	axRec1.Field("LastLogin") = Date()
		'	axRec1.Update
		'else
        '    Response.write("Fejl</br>")
        '   Response.Write(s)
        '    Response.End()
        'end if
        'axRec1 = null
		set axRec2 = Axapta.CreateRecord("nelWPersonLogin")
		axRec2.company = "ISU"
		axRec2.InitValue
		axRec2.Field("BrugerKode") = User
		axRec2.Insert
        axRec2 = null
		Axapta.TTSCommit
		Axapta.logoff
        set Axpta = nothing

        if rs("RettFactory") = 1 then
            Response.Redirect application("Vroot") & "/ClaimV3/factoryClaim_EnterVIN.asp"
        else
		    Response.Redirect application("Vroot") & "/frameset.asp"
        end if
	end if
end if
%>