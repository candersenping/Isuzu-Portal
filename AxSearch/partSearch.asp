<%@ Language=VBScript %>
<!-- #include file="../include/db.asp" -->
<!-- #include file="../include/functions.asp" -->
<%Checklogin

    itemId = ""
    itemName = ""
    itemQty = 0
    itemPrice = 0
    itemPriceWithWAT = 0
    itemDiscCode = ""
    itemIdAlt = ""

%>
<html>
<head>
    <title>ISUZU Danmark: Reservedelssøgning</title>
    <link rel="stylesheet" href="../include/stylesV2.css" type="text/css" />
</head>

<body>

<form action="partSearch.asp" method="post">
    <table class="register_sale" width="600">
      <tr>
        <th><h1>Søg på ISUZU Varenummer - Pris og beholdninger (<%=rsUser("BrugerKode")%>)</h1></th></tr>        
    </table>

	<table class="register_sale" width="600">
		<tr>
		  <td class="carsearchresult_subheader">Reservedelsnummer:</td>
		  <td><input class="input" type="text" name="soeg"/></td>
		  <td><input type="submit" name="submit1" value="Søg"></td>
		</tr>
	</table>
</form>

<table class="register_sale" width="600">
<tr>
    <th colspan="2">Søgeresultat</th>
</tr>
<%
If Request.Form("soeg") <> "" then
	SQL = "select * from inventTable where DATAAREAID='ISU' AND itemId='" & Request.Form("soeg") & "'"
	'response.write SQL
	'Response.end
	Set rs = conn.Execute (SQL)	
	If not rs.eof then
        itemId   = rs("itemId")
        itemName  = rs("ItemName")
        itemIdAlt = rs("AltItemId")

		SQL = "select * from inventSum where DATAAREAID='ISU' AND itemId='" & itemId & "'"
		Set rs2 = conn.Execute (SQL)	
		if not rs2.eof then
	 		while not rs2.eof
				SQL = "select * from inventDim where DATAAREAID='ISU' AND inventDimId='" & rs2("InventDimId") & "'"
                'response.write SQL
	            'Response.end
				Set rs3 = conn.Execute (SQL)
				if not rs3.eof then
					while not rs3.eof
						//if rs3("inventLocationId") = "Fred" then
	 						itemQty = itemQty + CLng(rs2("postedQty"))-CLng(rs2("OnOrder"))
	 					//end if
	 					rs3.movenext
	 				wend
	 			end if
	 			rs2.movenext
	 		wend
	 	end if
	 	
		SQL = "select * from inventTableModule where DATAAREAID='ISU' AND ModuleType=2 AND itemId='" & itemId & "'"
		Set rs3 = conn.Execute (SQL)	
        itemPrice        = rs3("Price")
		itemPriceWithWAT = clng(itemPrice) * 1.25
        itemDiscCode     = rs3("LineDisc")
    else
    	SQL = "select * from CISItemMaster_ISU where DATAAREAID='ISU' AND itemId='" & Request.Form("soeg") & "'"
    	'response.write SQL
	    'Response.end
    	Set rsShadow = conn.Execute(SQL)
        if not rsShadow.eof then
            itemId = rsShadow("itemid")
            itemName = rsShadow("Name")
            itemPrice = rsShadow("SalesPrice")
            itemPriceWithWAT = clng(itemPrice) * 1.25
            itemQty = 0
            itemDiscCode = ""
            itemIdAlt = rsShadow("AltItemId")
        else
            Response.Write "<b>Reservedelsnummeret eksistere ikke - Prøv igen !</b>"
        end if
    end if
	%>
		<tr><td class="carsearchresult_subheader">Reservedelsnummer</td><td class="carsearch_result"><%=itemId %></td></tr>
		<tr><td class="carsearchresult_subheader">Betegnelse</td><td class="carsearch_result"><%=ItemName %></td></tr>
        <tr><td class="carsearchresult_subheader">Lagerbeholdning/Disponibel (Uden ansvar)</td><td class="carsearch_result"><%=itemQty%></td></tr>
        <tr><td class="carsearchresult_subheader">Pris eksl. Moms</td><td class="carsearch_result"><%=itemPrice %></td></tr>
        <tr><td class="carsearchresult_subheader">Pris incl. Moms</td><td class="carsearch_result"><%=itemPriceWithWAT %></td></tr>
        <tr><td class="carsearchresult_subheader">Vare Kode</td><td class="carsearch_result"><%=itemDiscCode %></td></tr>
        <tr><td class="carsearchresult_subheader">Alternativ Reservedelsnummer</td><td class="carsearch_result"><%=itemIdAlt %></td></tr>
	<%	
else
%>
		<tr><td class="carsearchresult_subheader">Reservedelsnummer</td><td class="carsearch_result"></td></tr>
		<tr><td class="carsearchresult_subheader">Betegnelse</td><td class="carsearch_result"></td></tr>
        <tr><td class="carsearchresult_subheader">Lagerbeholdning (Uden ansvar)</td><td class="carsearch_result"></td></tr>
        <tr><td class="carsearchresult_subheader">Pris eksl. Moms</td><td class="carsearch_result"></td></tr>
        <tr><td class="carsearchresult_subheader">Pris incl. Moms</td><td class="carsearch_result"></td></tr>
        <tr><td class="carsearchresult_subheader">Vare Kode</td><td class="carsearch_result"></td></tr>
        <tr><td class="carsearchresult_subheader">Alternativ Reservedelsnummer</td><td class="carsearch_result"></td></tr>
<%
end if
%>
</table>

<table class="register_sale" width="600">
  <tr><tr class="info"><td>
  På denne side kan du ved hjælp af reservedelsnummeret få oplyst priser mv.</br>
          Alle priser er vejledende udsalgspriser!</br>
          Når søgningen af et reservedels nummer er afsluttet kan du bare skrive et nyt i søge feltet og trykke søg igen!</br>
          Desværre er der enkelte reservedelsnumre der ikke er prissat !</br>
          Der tages forbehold for visnings- og databasefejl !</br>
  </td></tr>
</table>
</body>
</html>