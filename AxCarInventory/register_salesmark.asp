<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%

Dim rsUser
Dim rsDealer
Dim rsCar
Dim rsCust2
Dim rsCust3
Dim rsCRM
Dim Axapta
Dim axParmList

set conn = Application("conn")

Function setType
    'response.Write "BORDER-LEFT-COLOR: red; BORDER-BOTTOM-COLOR: red; BORDER-TOP-STYLE: solid; BORDER-TOP-COLOR: red; BORDER-RIGHT-STYLE: solid; BORDER-LEFT-STYLE: solid; BORDER-RIGHT-COLOR: red; BORDER-BOTTOM-STYLE: solid"
End Function

Function SafeStr(str)
    If IsNull(str) Or str = "" Then
        str = "Null"
    Else
        str = Replace(str, "|", "")
        str = Replace(str, "'", "")
        str = Replace(str, "[", "")
        str = Replace(str, "]", "")
        str = Replace(str, "{", "")
        str = Replace(str, "}", "")
        str = Replace(str, "\", "")
        str = Replace(str, "/", "")
        str = Replace(str, "&", "")
        str = Replace(str, "?", "")
    End If
    SafeStr = "'" & str & "'"
End Function

Function checklogin
	user = Request.Cookies("KIA")("user")
	if user="" then 
		Response.Redirect Application("VRoot") & "/default.asp"
		Response.End
	end if

    s = "SELECT * FROM nelWPerson WHERE DATAAREAID='KIT' and BrugerKode=" & SafeStr(user)
	set rsUser = conn.Execute(s)
	if rsUser.eof then
		Response.Redirect Application("VRoot") & "/default.asp"
		Response.End
	end if
	
	s = "SELECT * FROM custTable WHERE DATAAREAID='KIT' and nelDealer=" & SafeStr(rsUser("DealerAccount"))
	set rsDealer = conn.Execute(s)
    if rsDealer.eof then
		Response.Redirect Application("VRoot") & "/default.asp"
		Response.End
    End if
End function

Checklogin()

car_Account  = request("carAccount")
car_Account2  = car_Account
return_Id    = request("Return_Id")
CarDealerCust = ""
CurDealerName = rsDealer("Name")
CurDealerCust = Ltrim(rsDealer("AccountNum"))

if car_Account = "" then
    response.End
else
    s = "SELECT * FROM carTable WHERE DATAAREAID='KIF' AND account=" & SafeStr(car_Account)
    'Response.Write s & "<br>"
	set	rsCar = conn.execute(s)
	if rsCar.eof then
		Response.Write "Vognen findes ikke." & "<BR>"
		Response.End
    end if
end if

DealerDescr = rsCar("DealerAccount")

s = "SELECT * FROM CISKiaCustCRM WHERE DATAAREAID='KIT' and CarAccount=" & SafeStr(car_Account) & " ORDER BY CreatedDate DESC, CreatedTime ASC"
set rsCRM = conn.execute(s)
if not rsCRM.eof then
    sale_Business        = rsCRM("Business")
    sale_FromBrand       = rsCRM("CarBrand")
    sale_FromModel       = rsCRM("CarModel")
    sale_Sex             = rsCRM("Gender")
    sale_CompanyPrivate  = rsCRM("CompanyPrivate")
    sale_FleetSize       = rsCRM("FleetSize")
    sale_FleetType       = rsCRM("FleetType")
    'sale_PersonName      = rsCRM("SalesPersonName")
    sale_JobDescription  = rsCRM("JobTitel")
    sale_BirthYear       = rsCRM("BirthYear")
    sale_InterestIntoKia = rsCRM("Interest")
    cert_Remarks         = rsCRM("RemarksDealer")     
else
    Response.Write("Fejl")
    Response.End()
end if

s = "SELECT * FROM CISDealerCustTable WHERE DATAAREAID='KIT' and CustomerType=0 AND CarAccount=" & SafeStr(car_Account)        
set rsCust2 = conn.Execute(s)
if not rsCust2.eof then
    cust_name        = replace(rsCust2("Name"),"&","og")
    cust_Address     = replace(rsCust2("Street"),"&","og")
    cust_Zip         = replace(rsCust2("ZipCode")," ","")
    cust_City        = rsCust2("City")
    cust_Phone       = rsCust2("Phone")
    cust_MobilePhone = rsCust2("PhoneMobile")
    cust_Email       = rsCust2("Email")
    cust_CVR         = rsCust2("VATNum")
end if

s = "SELECT * FROM CISDealerCustTable WHERE DATAAREAID='KIT' and CustomerType=1 and CarAccount=" & SafeStr(car_Account)
set rsCust3 = conn.Execute(s)
if not rsCust3.eof then
    user_name        = replace(rsCust3("Name"),"&","og")
    user_Address     = replace(rsCust3("Street"),"&","og")
    user_Zip         = replace(rsCust3("ZipCode")," ","")
    user_City        = rsCust3("City")
    user_Phone       = rsCust3("Phone")
    user_MobilePhone = rsCust3("PhoneMobile")
    user_Email       = rsCust3("Email")
end if

'set Axapta = createObject("AxaptaCOMConnector.Axapta")
'set axParmList = createObject("AxaptaCOMConnector.AxaptaParameterList")
'Axapta.logon
'Axapta.Refresh
'axParmList.Size = 2
'axParmList.Element( 1) = car_Account2
'axParmList.Element( 2) = CurDealerCust
'result = Axapta.CallStaticClassMethodEx("CISKiaDealerWeb","ValidDealerOnCar",axParmList)
'axParmList = null
'Axapta.logoff
'Axapta = null

result = ""

editOk = "readonly"
if rsUser("RettIntern") <> 0 then
    editOk = ""
else
    'if result = "" then
        if rsCar("UnitStatus") <> "15" then
            if rsCar("UnitStatus") <> "14" then
                if rsCar("UnitStatus") <> "14a" then
                    editOk = ""
                    'Response.End()
                end if
            end if
        end if
    'end if
end if

%>
<html>
<head>
<title>Salgsmarker bil</title>
<link rel="stylesheet" href="../include/stylesV2.css" type="text/css"/>
</head>

<body>
     <table class="register_sale" width="650">
        <tr>
		<th><h1>Salgsmarkering</h1></th>
        </tr>
        <tr align="left"><td style="text-indent: 0px;">Her kan du salgsmarkere en af dine egne biler. Uagtet om bilen er på lager, på vej hjem eller i bestilling på fabrikken.<br /><br />
        Informationer omhandlende kundenavn og -adresse m.m. kan kun ses af dig selv og har kun til formål, at hjælpe dig med at holde
        styr på dine biler. Du kan løbende ændre i disse informationer helt frem til at bilen skal Registreringsmeldes.<br /><br />
        En salgsmarkering afholder ikke forhandler kollegaer fra at kunne indfri bilen, hvis den er ”fri” i lagersystemet. <br />
        <br/>
        <%if result <> "" then%>
            Du er ikke den nuværende forhandler på vognen. Kontakt vognfordelingen hos Kia for yderligere hjælp.<br/>
        <%end if%>
        <!--(<%=rsUser("DealerAccount")%>/<%=CurDealerCust%>/<%=rsUser("BrugerKode")%>/<%=rsCar("SalesStatus")%>/<%=rsCar("UnitStatus")%>/<%=LTrim(rsCar("DealerAccount"))%>)<br/>-->
        </td></tr>
    </table>

<form name="register" method="post" action="register_salesmark_update.asp">
    <input type="hidden" name="car_Account" value="<%=car_Account%>">
    <input type="hidden" name="return_Id" value="<%=return_Id%>">
    <input type="hidden" name="DealerId" value="<%=rsUser("DealerAccount")%>">
    <input type="hidden" name="DealerUserId" value="<%=rsUser("BrugerKode")%>">    
    <input type="hidden" name="DealerName" value="<%=dealer_Name%>">
    <table id="Stamdata" class="register_sale" width="650">
        <tr>
		<th colspan="6">Vognens stamdata</th>
        </tr>

        <tr>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
		            <td id="nestedtable_header" class="nestedtable_header">Vognnr</td>
		            <td><div align="right"><%=rsCar("Account")%></div></td>
			</tr>
			</table>
		</td>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
		            <td id="nestedtable_header" class="nestedtable_header">Chassisnr</td>
		            <td><div align="right"><%=rsCar("SerielNo")%></div></td>
			</tr>
			</table>
		</td>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
		            <td id="nestedtable_header" class="nestedtable_header">Model</td>
		            <td><div align="right"><%=rsCar("Model")%></div></td>
			</tr>
			</table>
		</td>
        </tr>

        <tr>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
		            <td id="nestedtable_header" class="nestedtable_header">Type</td>
		            <td><div align="right"><%=rsCar("Type")%></div></td>
			</tr>
			</table>
		</td>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
		            <td id="nestedtable_header" class="nestedtable_header">Farve</td>
		            <td><div align="right"><%=rsCar("ColorDescExt")%>/<%=rsCar("ColorCodeExt")%> - <%=rsCar("ColorDescInt")%>/<%=rsCar("ColorCodeInt")%></div></td>		
			</tr>
			</table>
		</td>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
		            <td id="nestedtable_header" class="nestedtable_header">Modelår</td>
		            <td><div align="right"><%=rsCar("ModelYear")%></div></td>
			</tr>
			</table>
		</td>
        </tr>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
		            <td id="nestedtable_header" class="nestedtable_header">Forhandler</td>
		            <td><div align="right"><%=DealerDescr%></div></td>
			</tr>
			</table>
		</td>

		<td>
		</td>
		<td>
		</td>
        </tr>
    </table>
 
    <table id="CurrentOwner" class="register_sale" width="650">
        <tr>
		<th colspan="2">Kundeoplysninger (valgfrit) - udfyldte felter viser tidligere indtastede oplysninger</th>
        </tr>
        <tr>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Navn</td>
		            <td><div align="right"><input class="input" type="text" style="<%=setType%>" id="cust_Name" name="cust_Name" value="<%=cust_Name%>" <%=editOk%>></div></td>
			</tr>
			</table>
		</td>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Adresse</td>
		            <td><div align="right"><input class="input" type="text" style="<%=setType%>" name="cust_Address" value="<%=cust_Address%>" <%=editOk%>></div></td>
			</tr>
			</table>
		</td>
        </tr>
        <tr>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Postnr</td>
		            <td><div align="right"><input class="input" type="text" style="<%=setType%>" name="cust_Zip" value="<%=cust_Zip%>" <%=editOk%>></div></td>
			</tr>
			</table>
		</td>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
			            <td class="nestedtable_header">By</td>
			            <td><div align="right"><input class="input" type="text" style="<%=setType%>" name="cust_City" value="<%=cust_City%>" <%=editOk%>></div></td>
			</tr>
			</table>
		</td>
        </tr>

        <tr>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
		            <td class="nestedtable_header">1. Tlf/Mobilnr.</td>
		            <td><div align="right"><input class="input" type="text" style="<%=setType%>" name="cust_Phone" value="<%=cust_Phone%>" <%=editOk%>></div></td>
			</tr>
			</table>
		</td>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
		            <td class="nestedtable_header">2. Tlf/Mobilnr.</td>
		            <td><div align="right"><input class="input" type="text" name="cust_MobilePhone" value="<%=cust_MobilePhone%>" <%=editOk%>></div></td>
			</tr>
			</table>
		</td>
        </tr>

        <tr>
		<td>
			<table id="nestedtable" class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Email</td>
		            <td><div align="right"><input class="input" type="text" name="cust_Email" value="<%=cust_Email%>" <%=editOk%>></div></td>
			</tr>
			</table>
		</td>
		<td>
		</td>
        </tr>

    </table>

    <table id="CurrentUser" class="register_sale" width="650">
        <tr>
		<td>
			<table id="Table5" class="nestedtable">
			<tr>
		            <td valign="top" rowspan="1"><span class="nestedtable_header">Forhandlernotat<br/>(til eget brug)</td>
		            <td valign="top"><div id="Div8" name="private"><textarea rows="5" cols="60" name="cert_Remarks"><%=cert_Remarks%></textarea></div></td>
			</tr>
			</table>
		</td>
        </tr>		
    </table>

    <table width="650">
	<tr>
		<td align="right">
            <%if editOk = "" then%>
			    <input class="button" type="submit" name="sButton" value="Salgsmarker bil">
            <%end if%>
	    	<input class="button" type="button" value="Tilbage" onclick="vbscript:history.go(-1)">
		</td>
	</tr>
	</table>

</form>
</body>
</html>