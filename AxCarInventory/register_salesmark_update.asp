<%@ Language=VBScript %>
<!-- #include file="../include/db.asp" -->
<!-- #include file="../include/functions.asp" -->
<%

Function showAxError(a)
    if err.number <> 0 then
        e1 = "Fejl opstået - men prøv venligst igen (dog max 3 gange)."
        e2 = Request.Form("DealerId") & ", " & Request.Form("DealerUserId") & " på vogn " & Request.Form("car_Account")
        e3 = " (" & a & ") (" & err.Description & ") (" & err.number & ")"
        Set objNewMail_NH     = CreateObject("CDO.Message")
	    objNewMail_NH.From    = "web01@kiamotors.dk"
	    objNewMail_NH.To      = "itdisk@nellemann.dk"
	    objNewMail_NH.Subject = e2 & e3
	    objNewMail_NH.Send
	    Axapta.Stop
	    Set objNewMail_NH = Nothing
        writeError(e1 & "<br>" & e2 & "<br>")
        Response.End()
    end if
End Function

Function addPling(str)
    addPling = "" & str & ""
End Function

Dim Axapta
Dim axParmList

CheckLogin

on error resume next

set Axapta = createObject("AxaptaCOMConnector.Axapta")
showAxError("sale1")

set axParmList = createObject("AxaptaCOMConnector.AxaptaParameterList")
showAxError("sale2")

Axapta.logon
showAxError("sale3")

'Axapta.Refresh
'showAxError("sale4")

axParmList.Size = 37
axParmList.Element( 1) = addPling(Request.Form("car_Account"))
axParmList.Element( 2) = addPling(Request.Form("car_FirstRegDate"))
axParmList.Element( 3) = addPling(Request.Form("car_RegNo"))
axParmList.Element( 4) = addPling(Request.Form("cust_Name"))
axParmList.Element( 5) = addPling(Request.Form("cust_Address"))
axParmList.Element( 6) = addPling(Request.Form("cust_Zip"))
axParmList.Element( 7) = addPling(Request.Form("cust_City"))
axParmList.Element( 8) = addPling(Request.Form("cust_Phone"))
axParmList.Element( 9) = addPling(Request.Form("cust_MobilePhone"))
axParmList.Element(10) = addPling(Request.Form("cust_Email"))
axParmList.Element(11) = addPling(Request.Form("user_Name"))
axParmList.Element(12) = addPling(Request.Form("user_Address"))
axParmList.Element(13) = addPling(Request.Form("user_Zip"))
axParmList.Element(14) = addPling(Request.Form("user_City"))
axParmList.Element(15) = addPling(Request.Form("user_Phone"))
axParmList.Element(16) = addPling(Request.Form("user_MobilePhone"))
axParmList.Element(17) = addPling(Request.Form("user_Email"))
axParmList.Element(18) = addPling(Request.Form("sale_CompanyPrivate"))
axParmList.Element(19) = addPling(Request.Form("sale_Sex"))
axParmList.Element(20) = addPling(Request.Form("sale_BirthYear"))
axParmList.Element(21) = addPling(Request.Form("sale_Business"))
axParmList.Element(22) = addPling(Request.Form("sale_FromBrand"))
axParmList.Element(23) = addPling(Request.Form("sale_InterestIntoKia"))
axParmList.Element(24) = "KIT"
axParmList.Element(25) = addPling(Request.Form("sale_FromModel"))
axParmList.Element(26) = addPling(Request.Form("DealerId"))
axParmList.Element(27) = addPling(Request.Form("DealerUserId"))
axParmList.Element(28) = addPling(Request.Form("sale_FleetSize"))
axParmList.Element(29) = addPling(Request.Form("sale_Decisionmaker"))
axParmList.Element(30) = addPling(Request.Form("sale_Jobdescription"))
axParmList.Element(31) = addPling(Request.Form("cert_Price"))
axParmList.Element(32) = addPling(Request.Form("cert_Type"))
axParmList.Element(33) = addPling(Request.Form("cert_Special"))
axParmList.Element(34) = addPling(Request.Form("cert_Remarks"))
axParmList.Element(35) = addPling(Request.Form("cust_CVR"))
axParmList.Element(36) = addPling(Request.Form("sale_FleetType"))
axParmList.Element(37) = addPling(Request.Form("sale_PersonName"))

'response.Write "(" & Request.Form("cert_Remarks") & ")"
'response.End()

result = Axapta.CallStaticClassMethodEx("CISKiaDealerWeb","UpdateCarSalesAsSoldV2",axParmList)

showAxError("sale5")

Axapta.logoff
showAxError("sale6")

if result <> "" then
    writeError(result)
    Response.End()
else

  'Set objNewMail_NH     = CreateObject("CDO.Message")
	'objNewMail_NH.From    = "onlinecertifikat@kiamotors.dk"
	'objNewMail_NH.To      = "casi@nellemann.dk"
	'objNewMail_NH.Subject = "Certifikat og Typeattest bestilt af " & Request.Form("DealerId") & ", " & Request.Form("DealerUserId") & " på vogn " & Request.Form("car_Account")
	'objNewMail_NH.Send
	'Set objNewMail_NH = Nothing

    if request.Form("return_Id") = 3 then
        Response.Redirect("/lagerstyringV2/aktivlistenV3.aspx?m=3")
    end if
    if request.Form("return_Id") = 2 then
        Response.Redirect("/lagerstyringV2/aktivlistenV3.aspx?m=1")
    end if
    if request.Form("return_Id") = 1 then
        Response.Redirect("/vognsoeg/carSearchV2.asp")
    end if
    Response.End() 
end if
%>