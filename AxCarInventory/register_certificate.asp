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
	user = Request.Cookies("ISUZU")("user")
	if user="" then 
		Response.Redirect Application("VRoot") & "/default.asp"
		Response.End
	end if

    s = "SELECT * FROM nelWPerson WHERE DATAAREAID='ISU' and BrugerKode=" & SafeStr(user)
	set rsUser = conn.Execute(s)
	if rsUser.eof then
		Response.Redirect Application("VRoot") & "/default.asp"
		Response.End
	end if
	
	s = "SELECT * FROM custTable WHERE DATAAREAID='ISU' and nelDealer=" & SafeStr(rsUser("DealerAccount"))
	set rsDealer = conn.Execute(s)
    if rsDealer.eof then
		'Response.Redirect Application("VRoot") & "/default.asp"
		Response.End
    End if
End function

Checklogin()

car_Account  = request("carAccount")
car_Account2 = car_Account
return_Id    = request("Return_Id")

if car_Account = "" then
    response.End
else
	s = "SELECT * FROM carTable WHERE DATAAREAID='ISU' AND account='" & car_Account & "'"
	set	rsCar = conn.execute(s)
	if rsCar.eof then
		Response.Write "Vognen findes ikke." & "<BR>"
		Response.End
    else
        CarDealerCust = rsCar("DealerAccount")
    end if
end if

DealerDescr = rsCar("DealerAccount")
CarDealerCust = ""
CurDealerName = rsDealer("Name")
CurDealerCust = Ltrim(rsDealer("AccountNum"))

s = "SELECT * FROM CISKiaCustCRM WHERE DATAAREAID='ISU' and CarAccount=" & SafeStr(car_Account) & " ORDER BY CreatedDate DESC, CreatedTime ASC"
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
    cert_Remarks         = rsCRM("Remarks")       
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

set Axapta = createObject("AxaptaCOMConnector.Axapta")
set axParmList = createObject("AxaptaCOMConnector.AxaptaParameterList")
Axapta.logon
'Axapta.Refresh
axParmList.Size = 2
axParmList.Element( 1) = car_Account2
axParmList.Element( 2) = CurDealerCust
result = Axapta.CallStaticClassMethodEx("CISKiaDealerWeb","ValidDealerOnCar",axParmList)
'axParmList = null
Axapta.logoff
'Axapta = null

if result <> "" then
    demo   = "" 'readonly"
else
    demo = ""
end if

if rsUser("DealerAccount") <> rsCRM("DealerNo") and rsCRM("DealerNo") <> "" and cust_name <> "" and cust_Address <> "" and cust_Zip <> "" and cust_City <> "" then
    demo = "readonly"
end if

%>
<html>
<head>
<title>Indfri bil / Bestilling af certifikat og typeattest</title>
<link rel="stylesheet" href="../include/stylesV2.css" type="text/css"/>
</head>

<body>
    <table id="Table9" class="register_sale" width="650">
        <tr>
		<th><h1>Indfrielse af bil</h1></th>
        </tr>
        <tr align="left"><td style="text-indent: 0px">
        Her kan du bestille en indfrielse på af en dine egne biler eller på en af dine kollagers ”frie” lagerbiler.<br /><br />
        Når du bestiller en indfrielse, så skal du oplyse, hvilken pris og vogntype du ønsker at indfri bilen til. Du har tillige mulighed for at sende nødvendige informationer til KIDs logistikafdeling i bemærkningsfeltet.<br /><br />
        Informationer omhandlende kundenavn og -adresse m.m. kan kun ses af dig selv og har kun til formål, at hjælpe dig med at holde styr på dine biler. Du kan løbende ændre i disse informationer helt frem til at bilen skal Registreringsmeldes.<br /><br />
        Efter endt bestilling af indfrielse, kan du finde en betalingsanfordring i systemet. Når betalingen er sket og registeret hos importør, fremsendes en IRK kode til dig/jer per mail.
        <%if demo <> "" then%>
            Hvis du ikke kan rette i nuværende ejer oplysninger, skal du kontakte Vognfordelingen hos importør for yderligere hjælp.<br/>
        <%end if%>

        <!--(<%=rsUser("DealerAccount")%>/<%=CurDealerCust%>/<%=rsUser("BrugerKode")%>/<%=rsCar("SalesStatus")%>/<%=rsCar("UnitStatus")%>)<br/>-->
        </td></tr>
    </table>


<form name="register" method="post" action="register_certificate_update.asp">
    <input type="hidden" name="car_Account" value="<%=car_Account%>"/>
    <input type="hidden" name="return_Id" value="<%=return_Id%>"/>
    <input type="hidden" name="DealerId" value="<%=rsUser("DealerAccount")%>"/>
    <input type="hidden" name="DealerUserId" value="<%=rsUser("BrugerKode")%>"/>    
    <input type="hidden" name="DealerName" value="<%=dealer_Name%>"/>
    <table class="register_sale" width="650">
        <tr>
		<th colspan="6">Vognens stamdata</th>
        </tr>

        <tr>
		<td>
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Vognnr</td>
		            <td><div align="right"><%=rsCar("Account")%></div></td>
			</tr>
			</table>
		</td>
		<td>
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Chassisnr</td>
		            <td><div align="right"><%=rsCar("SerielNo")%></div></td>
			</tr>
			</table>
		</td>
		<td>
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Model</td>
		            <td><div align="right"><%=rsCar("Model")%></div></td>
			</tr>
			</table>
		</td>
        </tr>

        <tr>
		<td>
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Type</td>
		            <td><div align="right"><%=rsCar("Type")%></div></td>
			</tr>
			</table>
		</td>
		<td>
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Farve</td>		     
			    <td><div align="right"><%=rsCar("ColorDescExt")%>/<%=rsCar("ColorCodeExt")%> - <%=rsCar("ColorDescInt")%>/<%=rsCar("ColorCodeInt")%></div></td>

			</tr>
			</table>
		</td>
		<td>
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Modelår</td>
		            <td><div align="right"><%=rsCar("ModelYear")%></div></td>
			</tr>
			</table>
		</td>
        </tr>
        <tr>
		<td>
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Forhandler</td>
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
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Navn</td>
		            <td><div align="right"><input class="input" type="text" style="<%=setType%>" id="cust_Name" name="cust_Name" value="<%=cust_Name%>" <%=demo%>/></div></td>
			</tr>
			</table>
		</td>
		<td>
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Adresse</td>
		            <td><div align="right"><input class="input" type="text" style="" name="cust_Address" value="<%=cust_Address%>" <%=demo%>/></div></td>
			</tr>
			</table>
		</td>
        </tr>
        <tr>
		<td>
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Postnr</td>
		            <td><div align="right"><input class="input" type="text" style="" name="cust_Zip" value="<%=cust_Zip%>" <%=demo%>/></div></td>
			</tr>
			</table>
		</td>
		<td>
			<table class="nestedtable">
			<tr>
			            <td class="nestedtable_header">By</td>
			            <td><div align="right"><input class="input" type="text" style="" name="cust_City" value="<%=cust_City%>" <%=demo%>/></div></td>
			</tr>
			</table>
		</td>
        </tr>

        <tr>
		<td>
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">1. Tlf/Mobilnr.</td>
		            <td><div align="right"><input class="input" type="text" style="<%=setType%>" name="cust_Phone" value="<%=cust_Phone%>" <%=demo%>/></div></td>
			</tr>
			</table>
		</td>
		<td>
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">2. Tlf/Mobilnr.</td>
		            <td><div align="right"><input class="input" type="text" name="cust_MobilePhone" value="<%=cust_MobilePhone%>" <%=demo%>/></div></td>
			</tr>
			</table>
		</td>
        </tr>

        <tr>
		<td>
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Email</td>
		            <td><div align="right"><input class="input" type="text" name="cust_Email" value="<%=cust_Email%>" <%=demo%>/></div></td>
			</tr>
			</table>
		</td>
		<td>
			<table class="nestedtable">
			<tr>
			</tr>
			</table>
		</td>
        </tr>

    </table>

    <table class="register_sale" width="650">
        <tr>
		<th colspan="1">Indfrielsesoplysninger</th>
        </tr>

        <tr>
		<td colspan="1">
			<table id="Table2" class="radiobuttons">
			<tr>
		            <td valign="middle" rowspan="4"><span class="nestedtable_header"/>Forhandler netto pris: </td>
		            <td valign="middle"><div><input type="radio" name="cert_Price" value="1"/>Alm. pris</div></td>
		            <td valign="middle"><div><input type="radio" name="cert_Price" value="2"/>Fleet pris</div></td>
		            <td valign="middle"><div><input type="radio" name="cert_Price" value="3"/>Demo pris</div></td>
                    <td valign="middle"><div><input type="radio" name="cert_Price" value="4"/>Privat Leasing</div></td>
                    <td valign="middle"><div><input type="radio" name="cert_Price" value="5"/>Kampange</div></td>
                    <td valign="middle" style="color: #FF0000"><span class="nestedtable_header"/>(Skal vælges)</td>
			</tr>
			</table>
		</td>
        </tr>		

        <tr>
		<td colspan="3">
			<table id="Table3" class="radiobuttons">
			<tr>
		            <td valign="middle" rowspan="3"><span class="nestedtable_header"/>Vogntype: </td>
		            <td valign="middle"><div id="Div1"><input type="radio" name="cert_Type" value="1"/>Personbil</div></td>
		            <td valign="middle"><div id="Div2"><input type="radio" name="cert_Type" value="2"/>Van</div></td>
                    <td valign="middle" style="color: #FF0000"><span class="nestedtable_header" />(Skal vælges)</td>
			</tr>
			</table>
		</td>
        </tr>		


        <tr>
		<td>
			<table id="Table5" class="nestedtable">
			<tr>
		            <td valign="top" rowspan="1"><span class="nestedtable_header"/>Bemærkninger til KID: </td>
		            <td valign="top"><div id="Div3"><textarea rows="5" cols="58" name="cert_Remarks" <%=demo%>><%=cert_Remarks%></textarea></div></td>
			</tr>
			</table>
		</td>
        </tr>		


    </table>

	<table width="650">
	<tr>
		<td align="right">
			<%if demo = "" then%>
               <input class="button" type="submit" name="sButton" value="Indfri bil"/>
            <%end if%>
	    	<input class="button" type="button" value="Tilbage" onclick="vbscript:history.go(-1)"/>
		</td>
	</tr>
	</table>

</form>
</body>
</html>