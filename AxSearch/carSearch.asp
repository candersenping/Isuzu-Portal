<%@ Language=VBScript %>
<!-- #include file="../include/db.asp" -->
<!-- #include file="../include/functions.asp" -->
<%Checklogin%>

<html>
<head>
<title>ISUZU Danmark - Vognsøgning</title>
<link rel="stylesheet" href="../include/stylesV2.css" type="text/css" />
</head>

<body>

<form action="carSearch.asp" method="post">
    <table class="register_sale" width="600">
    <tr>
        <th><h1>Søg på ISUZU Vogn (<%=rsUser("BrugerKode")%>)</h1></th>
    </tr>
    <tr align="left" class="info"><td style="text-indent: 0px;">
    Her kan du ved hjælp af Stelnummeret (det hele eller blot de sidste 6 cifre), Vognnummeret eller Registreringsnummeret finde stamdata og reklamationshistorik på en konkret bil.<br /><br/>
    Du har også mulighed for at Salgsmarkere, Indfri eller Registreringsmelde en lagerbil.<br />
	</td>
    </tr>
    </table>
    <table class="register_sale" width="600">
    <tr>
        <td class="carsearchresult_subheader">Stelnummer</td>
        <td align="right"><input class="input" type="text" size="40" name="qVin"/></td>
    </tr>
    <tr>
        <td class="carsearchresult_subheader">Vognnummer</td>
        <td align="right"><input class="input" type="text" size="40" name="qCarAccount"/></td>
    </tr>
    <tr>
        <td class="carsearchresult_subheader">Registreringsnummer</td>
        <td align="right"><input class="input" type="text" size="40" name="qRegNo"/></td>
    </tr>
    <tr>
        <td></td>
        <td align="right"><input type="submit" value="Søg og vis" name="Search"/></td>
    </tr>
    </table>
</form>
<%

If Request.Form("qVin") <> "" or Request.Form("qCarAccount") <> "" or Request.Form("qRegNo") <> "" or Request("CarAccount") <> "" then
	
    SQL = " select * from CarTable where DATAAREAID='ISU' AND left(Account,4) <> 'BRUG' AND Account <> RegNo AND ("
	      if Request.Form("qVin") <> "" then
	        SQL = Sql & " SerielNo = '" & Request.Form("qVin") & "' or right(SerielNo,6) = '" & Request.Form("qVin") & "' "
	      end if
	      if Request.Form("qCarAccount") <> "" then
	        SQL = SQL & " Account = '" & Request.Form("qCarAccount") & "' "
	      end if  
	      if Request("CarAccount") <> "" then
	        SQL = SQL & " Account = '" & Request("CarAccount") & "' "
	      end if  
	      if Request.Form("qRegNo") <> "" then
	        SQL = SQL & " regNo = '" & Request.Form("qRegNo") & "' "
	      end if
	SQL = SQL & " ) "
	
	'response.write SQL
	'Response.end
	Set rs = conn.Execute (SQL)	
	If not rs.eof then
	
	theAccount = rs("Account")
	regNo      = rs("RegNo")
    VIN        = rs("SerielNo")
    uStatus    = rs("UnitStatus")
    sStatus    = rs("SalesStatus")
    'response.Write "(" & sStatus & ")"
    'response.End

    if rs("DealerTransportDate") = "01-01-1900" then
        TransportDate = ""
    else
        TransportDate = rs("DealerTransportDate")
    end if    

 	If rs("KMCWarranty") = "0" Then
     	garanti = "Nej"
    else
     	garanti = "Ja"
 	End if
 	
	Vogntype = ""
 	If rs("CarCertType") = 2 Then
 	    Vogntype = "Camper"
 	End if
 	
 	If rs("CarCertType") = 1 Then
     	Vogntype = "Varevogn"
 	End if
 	
 	If rs("CarCertType") = 0 Then
     	Vogntype = "Personvogn"
 	End if	

	Startsp = ""
 	If rs("NelStartBlockKia") <> "" Then
     	Startsp =rs("NelStartBlockKia") 
 	End if
 	
 	Regi = ""
 	If rs("RegDate") <= 1901 Then
     	Regi = ""
 	else
 	    Regi=rs("RegDate")
 	End if 

 	Fartpilot = "Bilen ikke udstyret med eftermonteret fartpilot"
 	If rs("NelFartPilotKia") >= "1" Then
     	Fartpilot=rs("NelFartPilotKia")
 	End if
 	
 	Noegle = "Kontakt Serviceafdelingen"
 	If rs("KeyNo") >= "1" Then
     	Noegle=rs("KeyNo")
 	End if
 	
 	Regist = ""
    If rs("RegNo") <> "" Then
 	    Regist=rs("RegNo")
 	End if
 	
    TirePCS = ""
    If rs("TirePCS") = 1 Then
 	    TirePCS = "Ja"
 	End if
    If rs("TirePCS") = 2 Then
 	    TirePCS = "Nej"
 	End if

	unitSql = "select * from nelUnitStatusTable where DATAAREAID='ISU' AND unitStatus ='" & uStatus & "'"
	Set rsUnit = conn.Execute(unitSql)	
	If not rsUnit.eof then
 	    UnitStatus = rsUnit("Text")
        'Response.Write(uStatus)
        'Response.End()
 	else
        UnitStatus = ""
 	End if

	sSql = "select * from nelCar_SalesStatusTable where DATAAREAID='ISU' AND SalesStatus ='" & sStatus & "'"
	Set rsSalesStatus = conn.Execute(sSql)	
	If not rsSalesStatus.eof then
 	    sStatus       = rsSalesStatus("SalesStatus")
        sSalesMark    = rsSalesStatus("Salesmark")
        sCertRequest  = rsSalesStatus("CertRequest")
        sRegistration = rsSalesStatus("Registration")
 	else
        sStatus = ""
        sSalesMark    = 1
 	End if

	modelSql = "select * from CarModelTable where DATAAREAID='ISU' AND Model ='" & rs("Model") & "'"
	Set rsModel = conn.Execute(modelSql)	
	ParticleFilter = "Nej"
	If not rsModel.eof then
        if rsModel("CertParticleFilter") = "1" then
 	        ParticleFilter = "Ja"
     	End if

        TypeAppr = rsModel("CertTypeApproval")
        LTS      = rsModel("LTS")

 	End if

	aSql = "select * from nDMSCarAccessoryModel where DATAAREAID='ISU' AND Model='" & rs("Model") & "' AND ModelGroup='" & rs("CarBrandModelGroup") & "'"
	Set rsAcc = conn.Execute(aSql)	
	aList = ""
    If not rsAcc.eof then
        Do While Not (rsAcc.eof)
            aList = aList & rsAcc("Accessory") & ","
        rsAcc.MoveNext
        loop
 	End if

	dealerSql = "select * from custTable where DATAAREAID='ISU' AND AccountNum ='" & rs("DealerAccount") & "'"
	Set rsDealer = conn.Execute(dealerSql)	
	If not rsDealer.eof then
 	    DealerName = rsDealer("Name")
        DealerNum  = rsDealer("NelDealer")
 	else
        DealerName = ""
        DealerNum  = ""
 	End if

	if rs("CarOwnerAccount") <> "" then
        OwnerUserSql = "select Phone, Name from CISDealerCustTable where DATAAREAID='ISU' AND CustomerType=0 AND CarAccount ='" & rs("Account") & "'"
	    Set rsDealerCust = conn.Execute(OwnerUserSql)	
	    if not rsDealerCust.eof then
            DealerCust = rsDealerCust("Phone") & "/" & rsDealerCust("Name")
        else
            DealerCust = ""
        end if
 	End if

	if rs("CarUserAccount") <> "" then
        OwnerUserSql = "select Phone, Name from CISDealerCustTable where DATAAREAID='ISU' AND CustomerType=1 AND CarAccount ='" & rs("Account") & "'"
	    Set rsDealerCust2 = conn.Execute(OwnerUserSql)	
	    if not rsDealerCust2.eof then
 	        DealerCust = DealerCust & "/" & rsDealerCust2("Phone") & "/" & rsDealerCust2("Name")
        end if
 	End if

    s = "select * from CISKiaCustCRM where DATAAREAID='ISU' AND CarAccount ='" & rs("Account") & "'"
	Set rsCrmSql = conn.Execute(s)	
    if not rsCrmSql.eof then
 	    if (rs("UnitStatus") <> "15" or rs("UnitStatus") <> "14d")  then
            registrated = rsCrmSql("CarRegistration")
        end if
    end if

    if rsUser("RettIntern") = 1 then
        salesMark         = "ok"
        certMark          = "ok"
        registrationMark  = "ok"
        registrationPrint = "ok"
    else
        salesMark         = ""
        certMark          = ""
        registrationMark  = ""
        registrationPrint = ""

        if DealerNum = rsUser("DealerAccount") then
            if rsUser("RettSales") = 1 then

                if regNo = "" and rsCrmSql("CarRegistration") = 0 and sSalesMark = 1 and rsUnit("SalesMark") = 1 then
                    salesMark = "ok"
                end if

                if regNo = "" and rsCrmSql("CertRequest") = 0 and sCertRequest = 1 and rsUnit("CertRequest") = 1 then
                    certMark = "ok"
                end if

                if rsCrmSql("CarRegistration") = 0 and sRegistration = 1 and rsUnit("Registration") = 1 then
                    registrationMark = "ok"
                end if

                if (now - rs("RegDate")) < 8 or rs("CRMPrintNumber") = "" then
                    registrationPrint = "ok"
                end if

        
            end if
        end if
    end if
%>

<table class="register_sale" width="600">

<tr>
    <th colspan="2">Søgeresultat</th>
</tr>

<tr>
	<td class="carsearchresult_subheader">Stelnummer</td>
	<td class="carsearch_result"><%= rs("SerielNo") %></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Vognnummer</td>
	<td class="carsearch_result"><%= rs("Account") %></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Biltype</td>
	<td class="carsearch_result"><%= rs("Type") %></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Webtype</td>
	<td class="carsearch_result"><%= rs("WebType") %></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Udstyr</td>
	<td class="carsearch_result"><%= aList%></td>
</tr>


<tr>
	<td class="carsearchresult_subheader">Farve</td>
	<td class="carsearch_result"><%= rs("ColorDescExt") %></td>

</tr>

<tr>
	<td class="carsearchresult_subheader">Farvekode</td>
	<td class="carsearch_result"><%= rs("ColorCodeExt") %></td>

</tr>

<tr>
	<td class="carsearchresult_subheader">Indtræk</td>
	<td class="carsearch_result"><%= rs("ColorDescInt") %></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Indtrækskode</td>
	<td class="carsearch_result"><%= rs("ColorCodeInt") %></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Partikelfilter</td>
	<td class="carsearch_result"><%= ParticleFilter %></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Dæktrykskontrolsystem (TPMS)</td>
	<td class="carsearch_result"><%= TirePCS %></td>
</tr>


<tr>
	<td class="carsearchresult_subheader">Registreringsnummer</td>
	<td class="carsearch_result"><%=Regist%></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Registreringsdato / Ibrugtagningsdato</td>
	<td class="carsearch_result"><%=Regi%></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Årgang</td>
	<td class="carsearch_result"><%= rs("ModelYear") %></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Modelkode</td>
	<td class="carsearch_result"><%= rs("Model") %></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Typegodkendelse</td>
	<td class="carsearch_result"><%= TypeAppr %></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">LTS</td>
	<td class="carsearch_result"><%=LTS %></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Motornummer</td>
	<td class="carsearch_result"><%= rs("EngineNo") %></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Startspærrekode</td>
	<td class="carsearch_result"><%=Startsp%></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Nøglenummer</td>
	<td class="carsearch_result"><%=Noegle%></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Vogntype</td>
	<td class="carsearch_result"><%=Vogntype%></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Vognstatus</td>
	<td class="carsearch_result"><%=UnitStatus%> (<%=uStatus %>) (<%=sStatus%>) (<%=rsCrmSql("CarRegistration")%>)</td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Forhandler</td>
	<td class="carsearch_result"><%=rs("DealerAccount")%> - <%=dealerName%></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Omfattet af Garantiordning ?</td>
	<td class="carsearch_result"><%=garanti%></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Vognmand Bestilt</td>
	<td class="carsearch_result"><%=TransportDate %></td>
</tr>

<tr>
	<td class="carsearchresult_subheader">Kunde</td>
	<td class="carsearch_result"><%=DealerCust%></td>
</tr>

<tr><th colspan="2">Teknisk Service Bulletin</th></tr>
<tr>
    <td colspan="2">
        <%
            sql = "SELECT NELCAMPAIGNLINES.CAMPAIGNID, CAMPAIGNTYPE, CAMPAIGNTEXT, FINISHED, FINISHEDDATE, PDFNAME FROM NELCAMPAIGNLINES, NELCAMPAIGNTABLE WHERE NELCAMPAIGNLINES.DATAAREAID='ISU' AND NELCAMPAIGNLINES.CAMPAIGNID = NELCAMPAIGNTABLE.CAMPAIGNID AND NELCAMPAIGNTABLE.CAMPAIGNACTIVE = 1 AND CARSERIELNO = '" & rs("SerielNo") & "'"
            Set nelcamprs = conn.Execute(sql)	
	        
        %>
        <table border="0" width="100%" class="carsearch_result">
            <tr>
                <td class="carsearchresult_subheader">
                    Kampagne ID
                </td>
                <td class="carsearchresult_subheader">
                    Type
                </td>
                <td class="carsearchresult_subheader">
                    Udført
                </td>
                <td class="carsearchresult_subheader">
                    Udført dato
                </td>
                <td class="carsearchresult_subheader">
                    Tekst
                </td>
                <td class="carsearchresult_subheader">
                    Pdf
                </td>
            </tr>
                <%  If not nelcamprs.eof then
                        Do While Not (nelcamprs.eof)
                        CampaignID = nelcamprs("CAMPAIGNID")
                        CampaignTxt = nelcamprs("CAMPAIGNTEXT")
                        CampaignType = nelcamprs("CAMPAIGNTYPE")
                        Finished = nelcamprs("FINISHED")
                        FinishedDate = nelcamprs("FINISHEDDATE")
                        pdfname = nelcamprs("PDFNAME")
                    %>
                    <tr>
                        <td>
                            <%=CampaignID %>
                        </td>
                        <td>
                            <%=CampaignType %>
                        </td>
                        <td>
                            <% If (Finished = "0") Then response.write("Nej") Else response.write("Ja") End if %>
                        </td>
                        <td>
                            <%
                                If (FinishedDate = "01-01-1900") Then

                                else
                                    response.write(FinishedDate)
                                end if
                            %>
                        </td>
                        <td>
                            <%=CampaignTxt %>
                        </td>
                        <td>
                            <%if pdfname <> "" Then %>
                                <a style="text-decoration:none; color:Black;" href="../teknik/serviceinfo/num/<%=pdfname %>">hent</a>
                            <%end if %>
                        </td>
                    </tr>
                
                    <%
                        nelcamprs.MoveNext
                    
                        Loop
                        nelcamprs.CLose
                    Else %>
                    <tr>
                        <td colspan="6">
                            Ingen kampagner fundet
                        </td>
                    </tr>
                    <%end if %>
        </table>
    </td>
</tr>
</table>

<!--
<table id="Buttons" class="buttons">
<tr>
    <%if salesMark = "ok" then %>
	    <td><input type="button" value="Salgsmarkering" onclick="window.location='../lagerstyringV2/register_salesmark.asp?Return_Id=1&carAccount=<% = theAccount %>'"/></td>
	<%end if%>
    <%if certMark = "ok" then %>
	    <td><input type="button" value="Indfrielse" onclick="window.location='../lagerstyringV2/register_certificate.asp?Return_Id=1&carAccount=<% = theAccount %>'"/></td>
	<%end if%>
    <%if registrationMark = "ok" then %>
	    <td><input type="button" value="Registreringsmelding" onclick="window.location='../lagerstyringV2/register_carsale.asp?Return_Id=1&carAccount=<% = theAccount %>'"/></td>
	<%end if%>
    <%if registrated = 1 and registrationPrint = "ok" then %>
        <!--<td><input type="button" value="Udskriv registreringskort" onclick="window.location='../lagerstyringV2/register_carsale.asp?Return_Id=1&carAccount=<% = theAccount %>'"/></td> -->
        <td><input type="button" value="Udskriv registreringskort" onclick="window.location='http://pdfprint.nellemann.dk/carRegCard.asp?carAccount=<% = theAccount %>'"/></td>
    <%end if%>
    <td><input type="button" value="Reklamationshistorik" onclick="window.location='/claimV3/claim_searchAndList.asp?ClaimVis=99&Search_String=<%=VIN%>'"/></td>
</tr>
</table>
//-->


<%
		Do until rs.eof
		rs.movenext
		Loop
		Response.Write "</table><p>"
%>


<%
	Else
		Response.Write "<span class='error'>Stelnummeret ukendt eller mangelfuldt - prøv igen!</span>"
		Response.Write "</table><p>"
End if
End if
%>
</body>
</html>