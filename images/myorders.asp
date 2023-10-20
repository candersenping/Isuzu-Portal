<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/include/security.asp" -->
<!--#include virtual="/connections/maincon.asp" -->
<% 
Set CISCOOOrders = Server.CreateObject("ADODB.Recordset")  
strSQL = "SELECT * FROM [CISCOOListOrders] WHERE DealerId=" & Session("WebLogonAccount") & ";" 
CISCOOOrders.Open strSQL, strDSN, adOpenStatic, , adCmdText 

phn_TB = "CISCOOListOrders"
dim phn_TBfield(8)
phn_TBfield(0) = "OrderDate|OrderDate"
phn_TBfield(1) = "CarModel|Model"
phn_TBfield(2) = "1|Udstyrsvariant"
phn_TBfield(3) = "2|Variant"
phn_TBfield(4) = "3|Type"
phn_TBfield(5) = "4|Motor" 
phn_TBfield(6) = "5|Gear"
phn_TBfield(7) = "6|Farve" 
phn_TBfield(8) = "Approved|Approved" 

'---- Start-Value ---
phn_order_field = "id"
phn_filter = ""
pageno = 1    
phn_PageSize = 50   

'if request("System") = "" then 
'	phn_System = 1
'	phn_filter = " System = 1" 
'else 
'	phn_System = request("System")
'end if	
	
   Set CISCOOOrders = Server.CreateObject("ADODB.Recordset")  

    	if not isEmpty(request("pageno")) then
   		pageno=request("pageno")  
	end if
    
    if request("set_order") = "DESC" then
    	phn_set_order = "DESC"
    	phn_next_order = "ASC"
    	phn_selected_order_img = "../images/desc.gif"
    else
    	phn_set_order = "ASC"
    	phn_next_order = "DESC"
    	phn_selected_order_img = "../images/asc.gif"
    end if

    phn_set_order_img = "../images/noasc.gif"

	for fil_count = 0 to ubound(phn_TBfield)
		phn_filtername = Split(phn_TBfield(fil_count), "|")
    		if request("set_orderfield") = phn_filtername(0) then phn_order_field = request("set_orderfield")
    		if request(phn_filtername(0)) > "" then
     			if phn_filter > "" then phn_filter = phn_filter & " AND"
     			phn_filter = phn_filter & " " & phn_filtername(0) & " LIKE '" & request(phn_filtername(0)) & "%'"
    		end if
	next
    
	if request("System") > "" then
		if phn_filter > "" then phn_filter = phn_filter & " AND"
		phn_filter = phn_filter & " systemer.id = " & request("System") 
	end if
    
	phn_set_order_field = phn_order_field 
    
    if phn_filter > "" then phn_filter = " WHERE" & phn_filter
    Session("SQL_filter") = phn_filter
	strSQL = "SELECT * FROM CISCOOOrders" & phn_filter & " ORDER BY [" & phn_set_order_field & "] " & phn_set_order '& " LIMIT 0 ,170"
   if request("PageSize") > "" And IsNumeric(request("PageSize")) then phn_PageSize = request("PageSize")
   if phn_PageSize < 1 then phn_PageSize = 40
       
   CISCOOOrders.Open strSQL, strDSN, adOpenStatic, , adCmdText
   
if not CISCOOOrders.EOF then
	CISCOOOrders.PageSize=phn_PageSize
    phn_recordcount = CISCOOOrders.RecordCount
    if CISCOOOrders.PageCount < CInt(pageno) then pageno=1  
    CISCOOOrders.AbsolutePage=pageno

   for page=1 to CISCOOOrders.PageCount
     if CInt(pageno) = CInt(page) then
   	  links=links & "<b>" & page & "</b>"   
     else
   	  links=links & "<a href=" & """" & "Javascript:phn_setvalue('pageno','" & page & "');" & """" & " class='maintext'>" & page & "</a>"
     end if
     if page < CISCOOOrders.PageCount then links=links & " | "
   next
end if


%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Kia Motors Vognbestilling</title>
<link href="../css/main.css" rel="stylesheet" type="text/css" />
<script src="../SpryAssets/SpryTabbedPanels.js" type="text/javascript"></script>
<link href="../SpryAssets/SpryTabbedPanels.css" rel="stylesheet" type="text/css">
</head>

<body><form name="form1" method="POST" action="<%=Request.ServerVariables("URL")%>" onSubmit="return Form1_Validator(this)">
<input type="hidden" name="set_orderfield" value="<%=request("set_orderfield")%>">
<input type="hidden" name="set_order" value="<%=request("set_order")%>">
<input type="hidden" name="pageno" value="<%=pageno%>">
  <table width="800" border="0" align="center" cellpadding="0" cellspacing="0">
<!--#include virtual="/include/top.asp" -->
  <tr>
    <td align="center"><div id="TabbedPanels1" class="TabbedPanels">
      <ul class="TabbedPanelsTabGroup">
        <li class="TabbedPanelsTab" tabindex="0"><a href="default.asp">Vognbestilling</a></li>
        <li class="TabbedPanelsTab" tabindex="0">Mine bestillinger</li>
      </ul>
      <div class="TabbedPanelsContentGroup">
        <div class="TabbedPanelsContent" style="display: none">
        </div>
        <div class="TabbedPanelsContent" style="display: block"><br>
          Mine bestillinger<br>
          <br>
          <%if not CISCOOOrders.EOF  then%>
  <table border="0" cellspacing="2" cellpadding="0" bordercolor="#111111">
      <tr>
	<%for fil_count = 0 to ubound(phn_TBfield)
		phn_filtername = Split(phn_TBfield(fil_count), "|")%>
        <td nowrap valign="top" class="sbutton1">
        <%=phn_filtername(1)%>
        <a href="Javascript:phn_setorder('<%=phn_filtername(0)%>','<%if phn_filtername(0) = phn_order_field then Response.write(phn_next_order) else Response.write("ASC")%>');"><img border="0" src="<%if phn_filtername(0) = phn_order_field then Response.write(phn_selected_order_img) else Response.write(phn_set_order_img)%>" alt="Click to activate column sorting. Click again to invert sequence. Black down arrow indicates ascending column sorting. Up arrow - descending."></a></b>        </td>
	<%next%>
      </tr>
<% 
    for intRecord=1 to CISCOOOrders.PageSize 
	if intRecord and 1 then sclass = "odd" else sclass = "even"%>
<tr onClick="Javascript:document.location='produkt.asp?id=<%=CISCOOOrders("id")%>'" class="<%=sclass%>">
		<td nowrap class="maintext"><%=CISCOOOrders("OrderDate")%></td>
        <td nowrap class="maintext"><%=CISCOOOrders("CarModel")%></td>
		<td nowrap class="maintext"><%=CISCOOOrders("1")%></td>
        <td nowrap class="maintext"><%=CISCOOOrders("2")%></td>
		<td nowrap class="maintext"><%=CISCOOOrders("3")%></td>
		<td nowrap class="maintext"><%=CISCOOOrders("4")%></td>
		<td nowrap class="maintext"><%=CISCOOOrders("5")%></td>
        <td nowrap class="maintext"><%=CISCOOOrders("6")%></td>
		<td align="center" nowrap class="maintext"><%if CISCOOOrders("Approved") then%>
        <img src="../../images/ball_green.gif" width="10" height="10">
        <%else%>
        <img src="../../images/ball_red.gif" width="10" height="10">
        <%end if%></td>
      </tr>
   <% 
   CISCOOOrders.MoveNext
   if CISCOOOrders.EOF then exit for
   next
 %>
  </table>

  <table border="0" cellspacing="0" cellpadding="2" bordercolor="#111111">
  <tr>
  <td height="15" nowrap class="maintext">
  Antal Poster&nbsp; </td>
  <td class="maintext"><%=phn_recordcount%></td>
  </tr>
  <tr>
    <td height="15" colspan="3" class="maintext"><%if CISCOOOrders.recordcount > phn_PageSize  then response.Write("Side: " & links)%></td>
    </tr>
</table>

<%else%>
Ingen poster fundet.
<%end if
%>


        </div>
      </div>
    </div>
      </td>
  </tr>
</table>
</form>
<script type="text/javascript">
<!--
var TabbedPanels1 = new Spry.Widget.TabbedPanels("TabbedPanels1", {defaultTab:1});
//-->
</script>
</body>
</html>
<%
CISCOOOrders.Close
Set CISCOOOrders = Nothing
%>