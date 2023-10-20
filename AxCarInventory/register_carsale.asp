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

Function setStyle
    response.Write "BORDER-LEFT-COLOR: red; BORDER-BOTTOM-COLOR: red; BORDER-TOP-STYLE: solid; BORDER-TOP-COLOR: red; BORDER-RIGHT-STYLE: solid; BORDER-LEFT-STYLE: solid; BORDER-RIGHT-COLOR: red; BORDER-BOTTOM-STYLE: solid"
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
	
	s = "SELECT * FROM custTable WHERE DATAAREAID='KIT' and LTrim(nelDealer)=" & SafeStr(rsUser("DealerAccount"))
    'Response.Write(s & "<br>")
	set rsDealer = conn.Execute(s)
    if rsDealer.eof then
		Response.Redirect Application("VRoot") & "/default.asp"
        'Response.Write("Hallo")
		Response.End
    End if
End function

Checklogin()

car_Account   = request("carAccount")
car_Account2  = car_Account
return_Id     = request("Return_Id")
return_Id     = 4
CarDealerCust = ""
CurDealerName = rsDealer("Name")
CurDealerCust = Ltrim(rsDealer("AccountNum"))

if car_Account = "" then
    response.End
else
	s = "SELECT * FROM carTable WHERE DATAAREAID='KIF' AND account=" & SafeStr(car_Account)
	set	rsCar = conn.execute(s)
	if rsCar.eof then
		Response.Write "Vognen findes ikke." & "<BR>"
		Response.End
    else
        CarDealerCust = LTrim(rsCar("DealerAccount"))
        s = "SELECT * FROM CustTable WHERE DATAAREAID='KIT' AND LTrim(accountNum)=" & SafeStr(CarDealerCust)
        set	rsDC = conn.execute(s)
	    if rsDC.eof then
            CarDealerName = ""
        else
            CarDealerName = rsDC("Name")
        end if
    end if
end if

certOk   = "no"
demo     = "readonly"
demoSel  = "disabled=disabled"
printOut = "no"

s = "SELECT * FROM CISKiaCustCRM WHERE DATAAREAID='KIT' and CarAccount='" & rsCar("Account") & "' ORDER BY CreatedDate DESC, CreatedTime ASC"
set rsCRM = conn.execute(s)
if not rsCRM.eof then
    sale_Business         = rsCRM("Business")
    sale_Business         = rsCRM("CustomerBusiness")
    sale_FromBrand        = rsCRM("CarBrand")
    'Response.Write("(" & sale_FromBrand & ")")
    'Response.End()
    sale_FromModel        = rsCRM("CarModel")
    sale_Sex              = rsCRM("Gender")
    sale_CompanyPrivate   = rsCRM("CompanyPrivate")
    sale_FleetSize        = rsCRM("FleetSize")
    sale_JobDescription   = rsCRM("JobTitel")
    sale_JobDescription   = rsCRM("JobCategory")
    sale_BirthYear        = rsCRM("BirthYear")
    sale_InterestIntoKia  = rsCRM("Interest")
    sale_Insurance        = rsCRM("InsuranceComany")
    sale_Financing        = rsCRM("FinancingCompany")
    sale_Serviceagreement = rsCRM("ServiceAgreement")

    if (rsCar("SalesStatus") = "E1" or rsCar("SalesStatus") = "F1" or rsCar("SalesStatus") = "F2") and rsCRM("CertRequestDate") <> "" and rsCRM("CarRegistration") = 0 then
        certOk   = "yes"
        demo     = ""
        demoSel  = ""
        printOut = "no"
    end if

    if rsCRM("CarRegistration") = 1 then
        printOut = "yes"
    end if

    sale_PriceType = "Ukendt"
    if rsCRM("CertPriceType") = 1 then
        sale_PriceType = "Alm. pris"
    end if
    if rsCRM("CertPriceType") = 2 then
        sale_PriceType = "Fleet"
    end if
    if rsCRM("CertPriceType") = 3 then
        sale_PriceType = "Demo"
    end if
    if rsCRM("CertPriceType") = 4 then
        sale_PriceType = "Privat Leasing"
    end if

    sale_CarType = "Personbil"
    if rsCRM("CertType") = 1 then
        sale_CarType = "VAN"
    end if    
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
    cust_VAT         = rsCust2("VATnum")
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
'if result <> "" then
    'demo   = "readonly"
'else
'    demo = ""
'end if    

if rsUser("RettIntern") = 1 then
    certOk   = "yes"
    demo     = "" '"readonly"
    demoSel  = "" '"disabled=disabled"
    printOut = "yes"
    'Response.End()
end if

%>
<html>
<head>
    <meta content="text/html; charset=iso-8859-1" http-equiv="content-type" />
    <title>Registreringsmelding</title>
<link rel="stylesheet" href="../include/stylesV2.css" type="text/css"/>

<script type="text/vbscript">
Function urlPDF(theURL)     
    theURL = theURL & "&cust_Name="        + document.getElementById("cust_Name").value
    theURL = theURL & "&cust_Address="     + document.getElementById("cust_Address").value
    theURL = theURL & "&cust_Zip="         + document.getElementById("cust_Zip").value
    theURL = theURL & "&cust_City="        + document.getElementById("cust_City").value
    theURL = theURL & "&cust_Phone="       + document.getElementById("cust_Phone").value
    theURL = theURL & "&cust_Phone="       + document.getElementById("cust_MobilePhone").value
    theURL = theURL & "&user_Name="        + document.getElementById("user_Name").value
    theURL = theURL & "&user_Address="     + document.getElementById("user_Address").value
    theURL = theURL & "&user_Zip="         + document.getElementById("user_Zip").value
    theURL = theURL & "&user_City="        + document.getElementById("user_City").value
    theURL = theURL & "&user_Phone="       + document.getElementById("user_Phone").value
    theURL = theURL & "&user_Phone="       + document.getElementById("user_MobilePhone").value
    theURL = theURL & "&car_RegNo="        + document.getElementById("car_RegNo").value
    theURL = theURL & "&car_FirstRegDate=" + document.getElementById("car_FirstRegDate").value
    theURL = theURL & "&dealer_Id="        + document.getElementById("dealerId").value
    theURL = theURL & "&dealer_UserId="    + document.getElementById("dealerUserId").value
    open.window.location = theURL
End Function
</script>

<script type="text/vbscript">
Function urlPDF2(theURL)     
    open.window.location = theURL
End Function
</script>

</head>

<body onload="document.register.CarDealerCust.focus()">

    <table id="Table1" class="register_sale" width="650">
        <tr>
		<th><h1>Registreringsmelding</h1></th>
        </tr>

        <tr align="left">
        <td style="text-indent: 0px; color: #FF0000; font-weight: bold;">
        Opmærksom ! Du er nu i færd med at registreringsmelde en ny bil.<br />
        (Indtastede oplysninger kan ikke rettes efter fremsendelse.)</td>
        </tr>
        
        <tr align="left"><td style="text-indent: 0px;">
        Registreringsmeldingen bruges til at videregive registreringsnummer, -dato, kunde og forhandler oplysninger til KMC (KIA Motors Corporation). Oplysningerne bruges bla. til at aktivere den pågældende bil i KMCs Garantisystem. Fejl og/eller urigtige oplysninger kan få alvorlige konsekvenser.<br /><br />
        Vær særligt opmærksom på, at du skal vælge, hvilken KIA forhandler og afdeling, der har solgt bilen.<br />
        <%if demo <> "" then%>
            Hvis du ikke kan rette i nuværende ejer oplysninger, skal du kontakte Vognfordelingen hos Kia for yderligere hjælp.<br/>
        <%end if%>

        <%if certOk = "no" then%>
            Vognen er ikke indfriet. Kontakt venligst Vognfordelingen hos Kia for yderligere hjælp.<br/>
        <%end if%>
        <!--(<%=rsUser("DealerAccount")%>/<%=CurDealerCust%>/<%=rsUser("BrugerKode")%>/<%=rsCar("SalesStatus")%>/<%=rsCar("UnitStatus")%>)<br/>-->
        </td></tr>
    </table>

<form name="register" method="post" action="register_carsale_update.asp">
    <input type="hidden" name="car_Account"  value="<%=car_Account%>"/>
    <input type="hidden" name="return_Id"    value="<%=return_Id%>"/>
    <input type="hidden" name="DealerId"     value="<%=rsUser("DealerAccount")%>"/>
    <input type="hidden" name="DealerUserId" value="<%=rsUser("BrugerKode")%>"/>    
    <input type="hidden" name="DealerName"   value="<%=CurDealerName%>"/>
    
    <table id="Stamdata" class="register_sale" width="650">
        <tr>
		<th colspan="2">Vognens stamdata</th>
        </tr>
        <tr>
             <td class="nestedtable_header">Vognnr</td>
	         <td><%=rsCar("Account")%></td>
	    </tr>
        <tr>
	        <td class="nestedtable_header">Chassisnr</td>
		    <td><%=rsCar("SerielNo")%></td>
         </tr>
         <tr>
             <td class="nestedtable_header">Model</td>
	         <td><%=rsCar("Model")%></td>
        </tr>
	    <tr>
             <td class="nestedtable_header">Type</td>
             <td><%=rsCar("WebType")%></td>
        </tr>
		<tr>
            <td class="nestedtable_header">Farve</td>
	    <td><%=rsCar("ColorDescExt")%>/<%=rsCar("ColorCodeExt")%> - <%=rsCar("ColorDescInt")%>/<%=rsCar("ColorCodeInt")%></td>
        </tr>
        <tr>
		    <td class="nestedtable_header">Modelår</td>
		    <td><%=rsCar("ModelYear")%></td>
        </tr>
        <tr>
		    <td class="nestedtable_header">Pristype</td>
		    <td><%=sale_PriceType%></td>
        </tr>
	    <tr>
		    <td class="nestedtable_header">Vogntype</td>
		    <td style="text-indent: 0px"><%=sale_CarType%></td>
	    </tr>
        <tr>
		    <td class="nestedtable_header">Forhandler</td>
            <td>
            <select name="CarDealerCust" <%=demoSel%>>
		    <option value="Vælg">Vælg</option>
            <%
		    dim rsDS
		    s = "SELECT * FROM custTable WHERE DATAAREAID='KIT' and ConsCustYesNo=1"
		    set rsDS = conn.execute(s)
	        while not rsDS.eof
            a = LTrim(rsDS("AccountNum"))
		    %>		                
            <option 
		    <%if a = CarDealerCust then
		            Response.Write " selected "
		    end if%> 
            value="<%=a%>"><%=a%> - <%=rsDS("Name")%>
		    </option>
		    <%
	        rsDS.movenext
		    wend
		    %>
		    </select></td>
        </tr>
        <tr>
		    <td class="nestedtable_header">Reg.nr.</td>
		    <%if len(rsCar("RegNo")) > 0 then%>
		        <td><input type="hidden" name="car_RegNo" value="<%=rsCar("RegNo")%>"/><%=rsCar("RegNo")%></td>
    		<%else%>
       		    <td><input class="input" style="text-transform: uppercase" name="car_RegNo" value="<%=rsCar("RegNo")%>" <%=demo%>/></td>
    		<%end if%>
		</tr>
	    <tr>
		    <td class="nestedtable_header">1. reg.dato</td>
            <%
            r = rsCar("RegDate")
            if r = "01-01-1900" then
                r = ""
            end if
            if len(rsCar("RegNo")) > 0 then%>                        
                <td><input type="hidden" name="car_FirstRegDate" value="<%=r%>"/><%=r%></td>
            <%else%>
    		    <td><input class="input" type="text" name="car_FirstRegDate" value="<%=r%>" <%=demo%>/> dd-mm-åååå</td>
            <%end if%>
		</tr>
    </table>
 
    <table id="CurrentOwner" class="register_sale" width="650">
        <tr>
		<th colspan="2">Indehaver af registreringsattest (ejer) jf. registreringsattest</th>
        </tr>
        <tr>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Navn</td>
		            <td align="right"><input class="input" type="text" style="<%=setStyle%>" id="cust_Name" name="cust_Name" value="<%=cust_Name%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Adresse</td>
		            <td align="right"><input class="input" type="text" style="<%=setStyle%>" name="cust_Address" value="<%=cust_Address%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
        </tr>
        <tr>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Postnr</td>
		            <td align="right"><input class="input" type="text" style="<%=setStyle%>" name="cust_Zip" value="<%=cust_Zip%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
		<td>
			<table  class="nestedtable">
			<tr>
			            <td class="nestedtable_header">By</td>
			            <td align="right"><input class="input" type="text" style="<%=setStyle%>" name="cust_City" value="<%=cust_City%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
        </tr>

        <tr>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">1. Tlf/Mobilnr.</td>
		            <td align="right"><input class="input" type="text" style="<%=setStyle%>" name="cust_Phone" value="<%=cust_Phone%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">2. Tlf/Mobilnr.</td>
		            <td align="right"><input class="input" type="text" name="cust_MobilePhone" value="<%=cust_MobilePhone%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
        </tr>

        <tr>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Email</td>
		            <td align="right"><input class="input" type="text" name="cust_Email" value="<%=cust_Email%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
        </tr>

    </table>
 
    <table class="register_sale" width="650">
        <tr>
		<th colspan="2">Bruger (hvis en anden end ejer) jf. registreringsattest</th>
        </tr>
        <tr>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Navn</td>
		            <td align="right"><input class="input" type="text" name="user_Name" value="<%=user_Name%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Adresse</td>
		            <td align="right"><input class="input" type="text" name="user_Address" value="<%=user_Address%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
        </tr>
        <tr>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Postnr</td>
		            <td align="right"><input class="input" type="text" name="user_Zip" value="<%=user_Zip%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">By</td>
		            <td align="right"><input class="input" type="text" name="user_City" value="<%=user_City%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
        </tr>
        <tr>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">1. Tlf/Mobilnr.</td>
		            <td align="right"><input class="input" type="text" name="user_Phone" value="<%=user_Phone%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
		<td>
			<table  class="nestedtable">
			<tr>
			<td class="nestedtable_header">2. Tlf/Mobilnr.</td>
			<td align="right"><input class="input" type="text" name="user_MobilePhone" value="<%=user_MobilePhone%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
        </tr>
        <tr>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Email</td>
		            <td align="right"><input class="input" type="text" name="user_Email" value="<%=user_Email%>" <%=demo%>/></td>
			</tr>
			</table>
		</td>
        </tr>
    </table>

<script type="text/javascript">
function able(theForm, theObject, theValue)
{
    if (theValue == 0)
    {
		theObject[0].checked = true;
		// Disable private info
        document.register.sale_Sex.disabled            = true;
        document.register.sale_BirthYear.disabled      = true;
        document.register.sale_Jobdescription.disabled = true;
	    // Enable company info
		document.register.sale_FleetSize.disabled      = false;
    	document.register.sale_Business.disabled       = false;
    }
    if (theValue == 1)
    {
    	theObject[1].checked = true;
        // Enable private info
        document.register.sale_Sex.disabled            = false;
        document.register.sale_BirthYear.disabled      = false;
        document.register.sale_Jobdescription.disabled = false;
        // Disable company info
        document.register.sale_FleetSize.disabled      = true;
        document.register.sale_Business.disabled       = true;
    }
} 	
</script>
	
    <table id="CurrentUser" class="register_sale" width="650">
        <tr>
		<th colspan="2">Marketingoplysninger 1 (obligatorisk)</th>
        </tr>
        <tr>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td><span class="nestedtable_header"/>Firmasalg <input id="sale_Company" value="0" type="radio" onclick="javascript:able(document.register, document.register.sale_CompanyPrivate, this.value);" name="sale_CompanyPrivate"/></td>
			</tr>
			</table>
		</td>
		<td><span class="nestedtable_header"/>Privatsalg <input id="sale_Private" value="1" type="radio" onclick="javascript:able(document.register, document.register.sale_CompanyPrivate, this.value);" name="sale_CompanyPrivate"/></td>
		</tr>
	<tr>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Antal biler i flåden</td>
		            <td align="right"><input class="input" type="text" name="sale_FleetSize"/></td>
			</tr>
			</table>
		</td>
		<td>
			<table  class="nestedtable">
			<tr>
	            <td class="nestedtable_header">Beslutningstager (køn)</td>
		            <td align="right">
                    <select class="input" name="sale_Sex" <%=demoSel%>>
                    <%
		            dim rsCR7
		            s = "SELECT * FROM CISCRMMaleFemale WHERE DATAAREAID='KIT' ORDER BY Id"
		            set rsCR7 = conn.execute(s)
	                while not rsCR7.eof
                    a = LTrim(rsCR7("Id"))
		            %>		                
                    <option 
		            <%if int(a) = int(sale_Sex) then
		                    Response.Write " selected "
		            end if%> 
                    value="<%=a%>"><%=rsCR7("Description")%>
		            </option>
		            <%
	                rsCR7.movenext
		            wend
		            %>
		            </select>
		            </td>
			</tr>
			</table>
		</td>
        </tr>

        <tr>
		<td>
			<table class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Branche</td>
		            <td align="right">
                    <select class="input" name="sale_Business" <%=demoSel%>>
                    <%
		            dim rsCR1
		            s = "SELECT * FROM CISCRMCustomerBusiness WHERE DATAAREAID='KIT' ORDER BY Id"
		            set rsCR1 = conn.execute(s)
	                while not rsCR1.eof
                    a = LTrim(rsCR1("Id"))
		            %>		                
                    <option 
		            <%if int(a) = int(sale_Business) then
		                    Response.Write " selected "
		            end if%> 
                    value="<%=a%>"><%=rsCR1("Description")%>
		            </option>
		            <%
	                rsCR1.movenext
		            wend
		            %>
		            </select>
                    </td>
			</tr>
			</table>
		</td>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Fødselsår</td>
		            <td align="right">
		                <select id="Select1" class="input" name="sale_BirthYear" <%=demoSel%>>
		            	<option value="0">Vælg fødselsår</option>
		            	<%for i = Year(Now())-14 to Year(Now())-100 step -1
		            	    response.Write "<option "
		            	     if CStr(sale_BirthYear) = CStr(i) then
		            	        response.Write " selected "
		            	     end if
		            	     response.Write " value=" & CStr(i) & ">" & i & "</option>"
		            	  next
		            	 %>
			            </select>
			            
		            </td>
			</tr>
			</table>
		</td>
        </tr>

        <tr>
		<td>

		</td>
		<td>
			<table  class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Stillingsbetegnelse </td>
                    <td align="right">
                    <select class="input" name="sale_Jobdescription" <%=demoSel%>>
                    <%
		            dim rsCR2
		            s = "SELECT * FROM CISCRMJobCategory WHERE DATAAREAID='KIT' ORDER BY Id"
		            set rsCR2 = conn.execute(s)
	                while not rsCR2.eof
                    a = LTrim(rsCR2("Id"))
		            %>		                
                    <option 
		            <%if int(a) = int(sale_Jobdescription) then
		                    Response.Write " selected "
		            end if%> 
                    value="<%=a%>"><%=rsCR2("Description")%>
		            </option>
		            <%
	                rsCR2.movenext
		            wend
		            %>
		            </select>
                    </td>
			</tr>
			</table>
		</td>
        </tr>
        <tr>
		<th colspan="2">Marketingoplysninger 2 (obligatorisk)</th>
        </tr>

        
        <tr>
            <td class="nestedtable_header">Byttebil </td>
        <td>
			<table  class="nestedtable">
			    <tr>
		        <td>Mærke</td>
                <td align="right">
		        <select class="input" name="sale_FromBrand" <%=demoSel%>>
                <%
                Br = array ("(ingen)","ALFA-ROMEO","AUDI","BMW","CADILLAC","CHEVROLET","CHRYSLER","CITROEN","DODGE","FIAT","FORD","HONDA","HYUNDAI", _
                            "JAGUAR","JEEP","KIA","LAND ROVER","LEXUS","MAZDA","MERCEDES-BENZ","MINI","MITSUBISHI","NISSAN","OPEL","PEUGEOT", _
                            "RENAULT","ROVER","SEAT","SKODA","SMART","SSANGYONG","SUBARU","SUZUKI","SAAB","TOYOTA","VOLKSWAGEN","VOLVO","ØVRIGE")
                    
                for i = 0 to 37
                    response.Write "<option "
                    if Br(i) = sale_FromBrand then
                        response.Write " selected "
                    end if
                    response.Write "value=" & Br(i) & ">" & Br(i) & "</option>"
                next
                %>
		        </select>
		        
                </td>
                </tr>
                <tr>
                    <td>Model</td>
		            <td align="right"><input class="input" type="text" name="sale_FromModel" value="<%=sale_FromModel%>" /></td>
                </tr>

			</table>
        </td>
        </tr>

        <tr>
            <td>
				<table id="radiobuttons" class="nestedtable">
		            <tr>
			            <td class="nestedtable_header">Hvor blev kunden opmærksom på Kia </td>
                        <td align="right"><select class="input" name="sale_InterestIntoKia" <%=demoSel%>>
                        <%
		                dim rsCR3
		                s = "SELECT * FROM CISCRMInterested WHERE DATAAREAID='KIT' ORDER BY Id"
		                set rsCR3 = conn.execute(s)
	                    while not rsCR3.eof
                        a = LTrim(rsCR3("Id"))
		                %>		                
                        <option 
		                <%if int(a) = int(sale_InterestIntoKia) then
		                        Response.Write " selected "
		                end if%> 
                        value="<%=a%>"><%=rsCR3("Description")%>
		                </option>
		                <%
	                    rsCR3.movenext
		                wend
		                %>
		                </select>
                        </td>
		            </tr>
				</table>
            </td>
		    <td>
			    <table id="Table5" class="nestedtable">
			    <tr>
		                <td class="nestedtable_header">Forsikring </td>
                        <td align="right">
                        <select class="input" name="sale_Insurance" <%=demoSel%>>
                        <%
		                dim rsCR4
		                s = "SELECT * FROM CISCRMInsuranceCompany WHERE DATAAREAID='KIT' ORDER BY Id"
		                set rsCR4 = conn.execute(s)
	                    while not rsCR4.eof
                        a = LTrim(rsCR4("Id"))
		                %>		                
                        <option 
		                <%if int(a) = int(sale_Insurance) then
		                        Response.Write " selected "
		                end if%> 
                        value="<%=a%>"><%=rsCR4("Description")%>
		                </option>
		                <%
	                    rsCR4.movenext
		                wend
		                %>
		                </select>
                        </td>
			    </tr>
			    </table>
            </td>
        </tr>
		<tr>
        <td>
			<table id="Table6" class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Forhandler formidlet finansiering </td>
		            <td align="right">
                    <select class="input" name="sale_Financing" <%=demoSel%>>
                    <%
		            dim rsCR5
		            s = "SELECT * FROM CISCRMFinancingCompany WHERE DATAAREAID='KIT' ORDER BY Id"
		            set rsCR5 = conn.execute(s)
	                while not rsCR5.eof
                    a = LTrim(rsCR5("Id"))
		            %>		                
                    <option 
		            <%if int(a) = int(sale_Financing) then
		                    Response.Write " selected "
		            end if%> 
                    value="<%=a%>"><%=rsCR5("Description")%>
		            </option>
		            <%
	                rsCR5.movenext
		            wend
		            %>
		            </select>                    
                    </td>
			</tr>
			</table>
		</td>
      		<td>
			<table id="Table7" class="nestedtable">
			<tr>
		            <td class="nestedtable_header">Serviceaftale </td>
                    <td align="right">
                    <select class="input" name="sale_Serviceagreement" <%=demoSel%>>
                    <%
		            dim rsCR6
		            s = "SELECT * FROM CISCRMServiceAgreement WHERE DATAAREAID='KIT' ORDER BY Id"
		            set rsCR6 = conn.execute(s)
	                while not rsCR6.eof
                    a = LTrim(rsCR6("Id"))
		            %>		                
                    <option 
		            <%if int(a) = int(sale_Serviceagreement) then
		                    Response.Write " selected "
		            end if%> 
                    value="<%=a%>"><%=rsCR6("Description")%>
		            </option>
		            <%
	                rsCR6.movenext
		            wend
		            %>
		            </select>
                    </td>
			</tr>
			</table>
		</td>
        </tr>
    </table>

<table>
<tr>
    <%if certOk = "yes"then %>
        <td><input class="button" type="submit" name="sButton" value="Registrer"/></td>
    <%end if%>
    <%if printOut = "yes" then %>
        <!--<td><input type="button" value="Udskriv registreringskort" onclick="vbscript:urlPDF('http://pdfprint.nellemann.dk/car_registration.asp?carAccount=<%=car_Account%>')"/></td>-->
	<%end if%>
    <%if rsUser("BrugerKode") = "7000CASI" then %>
        <!--<td><input type="button" value="Udskriv registreringskort2" onclick="vbscript:urlPDF2('http://pdfprint.nellemann.dk/carRegCard.asp?carAccount=<%=car_Account%>')"/></td>-->
	<%end if%>

    <td><input type="button" value="Tilbage" onclick="vbscript:history.go(-1)"/></td>
</tr>
</table>

</form>
</body>
</html>