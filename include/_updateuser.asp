<%@ Language=VBScript %>
<!-- #include file="db.asp" -->
<!-- #include file="functions.asp" -->

<%
if Request.ServerVariables("Request_Method")="POST" then
	navn=Request.Form("navn")
	email=Request.Form("email")
	telefon=Request.Form("telefon")
	password1=Request.Form("password1")
	password2=Request.Form("password2")
	
	if navn = "" then
		Fejl = "Navn skal være udfyldt"
		UdskrivFejl()
		Response.End 
	end if

	if password1 <> password2 then
		Fejl = "De to password er ikke ens"
		UdskrivFejl()
		Response.End 
	end if

	if len(password1) < 6  then
		Fejl = "Kodeordet skal være mindst 6 karakter"
		UdskrivFejl()
		Response.End 
	end if

	s = "UPDATE Persons SET " &_
	" Medarbejdernavn=" & safestring(navn) & _
	", brugerkode="  & safestring(Request.Form("user")) &_
	", email=" & safestring(email)  & _
	", telefon=" & safestring(telefon) & _
	", adgangskode=" & safestring(password1)  & _
	"	WHERE brugerkode=" & safestring(Request.Form("user"))
	' Response.Write(s)
	on error resume next
	set rs = conn.execute(s)
	if err.number <> 0 then
		if err.number = -2147217900 then
			%>
			<link REL="STYLESHEET" TYPE="text/css" HREF="<% = Application("VRoot") %>/include/shop_plus.css">
			<body TOPMARGIN="0" LEFTMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0">
			<div align="center"><center>
			<h1 class="error">Fejl.</h1>
			Brugeren kunne ikke opdateres.<BR>
				Gå <a href=javascript:history.back()>tilbage </A>og prøv igen.
			</center></div>
			<%
		else
			%>
			<link REL="STYLESHEET" TYPE="text/css" HREF="<% = Application("VRoot") %>/include/shop_plus.css">
			<body TOPMARGIN="0" LEFTMARGIN="0" MARGINWIDTH="0" MARGINHEIGHT="0">
			<div align="center"><center>
				<h1 class="error">Ukendt fejl</h1>
				<%
				Response.Write "Der opstod en ukendt fejl, skriv fejlnummeret ned, og rapporter dette til VN Agro. Fejlnummer : " & err.number
				%>
			<BR>
			</center></div>
			<%
		end if
	Response.End
	end if
end if
Response.Redirect(application("Vroot") &"/start.asp")
%>


<%
function UdskrivFejl
%>
<html>
<!-- HTML BY NetFokus  -->
<!-- Script Development Team: ATP -->
<!-- www.netfokus.dk -->

<head>

<title>Velkommen til VN Agro online reklamations system.</title>
<link REL="STYLESHEET" TYPE="text/css" HREF="<%=Application("Vroot")%>/include/deere_style.css">

<base target="deere_main">

</head>

<body topmargin="0" leftmargin="0">

<div align="center">
  <center>

<table border="0" width="500" cellspacing="0" cellpadding="3">
  <tr>
    <td><img border="0" src="<%=Application("Vroot")%>/images/space.gif" WIDTH="20" HEIGHT="20"></td>
  </tr>
  <tr>
    <td bgcolor="#000000" align="center">
      <h1>Fejl i opdateringen.</h1>
    </td>
  </tr>
  <tr>
          <td width="100%"><b>&nbsp;&nbsp;</b></td>
  </tr>
  <tr>
          <td align="center">
            <h4><%=Fejl%></h4>
          </td>
  </tr>
</table>

  </center>
</div>

<p>&nbsp;</p>

</body>

</html>



<%
end function
%>