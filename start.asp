<%@ Language=VBScript %>
<!-- #include file="include/db.asp" -->
<!-- #include file="include/functions.asp" -->
<%
Checklogin
dim rsDealer
s = "SELECT Name FROM custTable WHERE DATAAREAID='ISU' AND AccountNum=" & safestring(rsUser("CustAccount"))
set rsDealer = conn.execute(s)
if rsDealer.Eof then
	Response.Write s & "<br>"
	'Name = rsDealer("Name")
	Response.End
Else
	Name = rsDealer("Name")
End if

If Request.Cookies("ISUZU")("cook_LastLogin") <> "" Then
	ld = "Du har sidst anvendt forhandlernettet den " & Request.Cookies("ISUZU")("cook_LastLogin")
Else
	ld = ""
End If
%>
<head>
    <title></title>
    <link href="include/web_style.css" rel=stylesheet type=text/css>
    <base target="deere_main">
</head>

<html>
<center>
<body>
<div>
<table>  
    <tr><td><img alt="" src="images/space.gif" width="20" height="10"></td></tr>	
    <tr><td><h1>Velkommen til ISUZU forhandlernet</h1></td></tr>
    <tr><td><img alt="" src="images/space.gif" width="20" height="1"/></td></tr>	
    <tr><td><h4><%=rsuser("medarbejdernavn")%>, <%=name%></h4></td></tr>
    <tr><td bgcolor="#999999" align="center"><img border="0" src="images/space.gif" width="20" height="1"></td></tr>
    <tr><td>
        <br/>
        <br/>
        <strong>Informationer:</strong><br/>
        Velkommen til 2023<br/>
        <br/>
        <strong>Driftstatus:</strong><br/>
        Normal<br/>
        <br/>
        <br/>
	</td></tr>
    <tr><td bgcolor="#999999" align="center"><img border="0" src="images/space.gif" width="20" height="1"></td></tr>
    <tr><td><img alt"" src="images/isuzucar.png" height="180" width="300"></td></tr>
    <tr><td bgcolor="#999999" align="center"><img border="0" src="images/space.gif" width="20" height="1"></td></tr>
    <tr><td><h6><hr style="left: 3px; top: 8px">
      Forhandlernettet har været aktivt siden <%=Date2Str(application("appl_Start"))%>, <%=Time2Str(application("appl_Start"))%><br>
			Der har været <%=application("appl_Visits")%> besøg på systemet.<br>
			Der er <%=application("appl_Active")%> bruger(e) på system.<br>
			Du har logget på <%=Date2Str(Session("sess_Start"))%>, <%=Time2Str(Session("sess_Start"))%><br>
			<%If ld<>"" Then%>
				<%=ld%><br>
			<%End If%></h6>
	</td></tr>
</table>
</div>
</body>
</center>
</html>



























































































































































