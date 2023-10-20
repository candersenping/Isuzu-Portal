<%
dim TDCounter
TDCounter = 1
dim Errors (255)
dim Errno
Errno = 0

Function Time2Sql(Tid)
	If Tid <> 0 Then
		Time2Sql = "'" & Right("00" & Cstr(Hour(Time())),2) + ":" + Right("00" & CStr(Minute(Time())),2) & "'"
	Else
		Time2Sql = ""
	End If
	
End Function

Function Date2Sql(Dato)
    If Dato <> 0 Then
		Date2Sql = "Convert(smalldatetime,'" & _
					Right("00"   & CStr(Day(Dato))  ,2) & "-" & _
					Right("00"   & CStr(Month(Dato)),2) & "-" & _
					Right("0000" & CStr(Year(Dato)) ,4) & _
					"',105)"
    else
		Date2Sql = ""
    end if
end function

Function Date2SqlStr(Dato)
    If Dato <> "" Then
		Date2SqlStr = "Convert(smalldatetime,'" & _
					Right("00"   & Mid(Dato,1,2),2) & "-" & _
					Right("00"   & Mid(Dato,4,2),2) & "-" & _
					Right("0000" & Mid(Dato,7,4),4) & _
					"',105)"
    else
		Date2SqlStr = "Null"
    end if
end function

function Time2Str(Tid)
	If Tid <> "" Then
		Time2Str = Tid
	Else
		Time2Str = ""
	End if
end function

function Time2StrNew(Tid)
	If Tid <> 0 Then
	    a = int(Tid/3600)
		Time2StrNew = Right("00" & a,2) & ":" & Right("00" & int((Tid-(a*3600))/60),2)
	Else
		Time2StrNew = ""
	End if
end function

function Time2StrOld(Tid)
	If Tid <> 0 Then
		Time2Str = Right("00" & Cstr(Hour(Tid)),2) + ":" + Right("00" & CStr(Minute(Tid)),2)
	Else
		Time2Str = ""
	End if
end function

function Date2Str(Dato)
    If Dato <> 0 Then
		Date2Str = Right("00" & CStr(Day(Dato)),2)+ "-" + Right("00" & CStr(Month(Dato)),2) + "-" + Right("0000" & CStr(Year(Dato)),4)
    else
		Date2Str = ""
    end if
end function

function Date2CDate(Dato)
    If Dato <> "" Then
		Date2CDate = Right("00" & Mid(Dato,1,2),2)+ "-" + Right("00" & Mid(Dato,4,2),2) + "-" + Right("0000" & Mid(Dato,7,4),4)
    else
		Date2CDate = ""
    end if
end function

function CheckForError(field,Fejl)
	if field = "" then
		Errno = Errno+1
		Errors(Errno) = "Der skal indtastes " & Fejl
	end if
end function

function WriteTekst(feltnavn)
	set rsTekster= conn.execute("SELECT * FROM tekst WHERE feltnavn = "& safestring(feltnavn))
	desc = rsTekster("indhold")
	WriteTekst = FormatText(desc)
end function

if Application("VRoot") = "" then
	application("VRoot") = GetVirtualRoot()
end if

function GetVirtualRoot()
	Dim f
	dim vroot, p, c
	vroot = Request.ServerVariables("PATH_INFO")
	approot = ucase(approot)
	do
		if ucase(server.MapPath(vroot)) = approot then exit do
		while (right(vroot,1) <> "/") and (len(vroot)>1)
			vroot = mid(vroot,1, len(vroot)-1)
		wend
		vroot = mid(vroot,1, len(vroot)-1)
	loop while len(vroot)>1
	if vroot = "/" then vroot = ""
	GetVirtualRoot = vroot
end function

Function checklogin
	user = Request.Cookies("ISUZU")("user")
	if user="" then 
		Response.Redirect Application("VRoot") & "/default.asp"
		Response.End
	end if
	set rsUser = conn.Execute("SELECT * FROM nelWPerson WHERE " & DaID & "BrugerKode=" & safestring(user))
	if rsUser.eof then 
		Response.Redirect Application("VRoot") & "/default.asp"
		Response.End
	end if
	Response.Cookies("ISUZU")("user") = user
	Response.Cookies("ISUZU").Expires = Date() + 10
End function

Function getClaimRec(Dealer, ClaimNo)
	Dim rsClaim, s
	s = "SELECT * FROM nelClaimsTable WHERE " & DaID & " ClaimID='" & ClaimNo & "' AND Dealer='" & Dealer & "'"
	set rsClaim = conn.execute(s)
End Function

function AmountAft(vIn)
	Dim n
	If vIn = "" Then
		vIn = "0"
	End If
	n = Replace(vIn,".",",")
	n = Replace(n,"o","0")
	n = Replace(n,"O","0")
	n = Replace(n,"l","1")
	
	AmountAft = CDbl(n)
end function

function AmountFormat(talIn,Dec)
	AmountFormat = talIn
end function

function AmountFormat2(talIn,Dec)
	dim v,t,d,s,i
	v = Round(talIn,Dec)
	t = Fix(v)
	d = Round((v - t)*100,Dec)
	s = ""
	for i = 1 to Len(t)
		s = Mid(t,len(t)-i+1,1) & s
		if i=3 or i=6 or i=9 or i=12 then
			if i <> Len(t)Then
				s = "." & s
			End if
		End if
	next
	If Dec <> 0 Then
		s = s & "," & Right("00"+CStr(d),Dec)
	End if
	AmountFormat2 = s
end function


function AmountOld(vIn)
	decimalpoint = ","
	thousandsep = "."
	decimals = 2
	dim s,p,v
	v = vIn
	os = mid(v,2,1)
	v = round(v, 2)
	p = instr(1,v,os)
	if p=0 then 
		v = v & decimalpoint & string(decimals, "0")
	else
		v = v & string(decimals, "0")
		v = mid(v, 1, instr(1, v, os) + decimals)
	end if 
	v = replace(v, os, decimalpoint)
	s = right(v, decimals + 1)
	v = mid(v,1,len(v)-decimals-1)
	for i = 1 to fix((len(v)-1)/3)
		s = thousandsep & right(v,3) & s  
		v = mid(v, 1, len(v) - 3)
	next
	s = v & s
	Amount = s
end function

function WriteTD(adder)
	if cInt(TDCounter) mod 2=0 then
		WriteTD = "TD0"
	else
		WriteTD = "TD1"
	end if
	TDCounter = TDCounter + adder
end function

function WriteHeader(Title,Name)
%>
<head>
<title><%=Title%></title>
<link REL="STYLESHEET" TYPE="text/css" HREF="<%=Application("Vroot")%>/include/web_style.css">
<base target="deere_main">
</head>
<table border="0" width="500" cellspacing="0" cellpadding="2">
  <tr><td><img border="0" src="<%=Application("Vroot")%>/images/space.gif" WIDTH="20" HEIGHT="20"></td></tr>
  <tr><td align="center"><h1><%=Name%></h1></td></tr>
  <tr><td width="100%"><b>&nbsp;&nbsp;</b></td></tr>
</table>
<%
end function

Function WriteErrorNF(Error)
%>
<html>
<head>
<title>ISUZU Online: Fejlmeddelelse</title>
<link REL="STYLESHEET" TYPE="text/css" HREF="<%=Application("Vroot")%>/include/web_style.css">
</head>
<body topmargin="0" leftmargin="0">
<div align="center">
<center>
<table border="0" width="500" cellspacing="0" cellpadding="3">
  <tr><td><img border="0" src="<%=Application("Vroot")%>/images/space.gif" WIDTH="20" HEIGHT="20"></td></tr>
  <tr><td align="center"><h1>Der er opstået en fejl.</h1></td></tr>
  <tr><td width="100%"><b>&nbsp;&nbsp;</b></td></tr>
  <tr><td align="center"><h4><%=Error%></h4></td></tr>
  <tr><td align="center">Gå <a href=javascript:history.back()>tilbage </A>og prøv igen.</td></tr>
</table>
</center>
</div>
</body>
</html>
<%
Response.End 
end function

function WriteError(Error)
%>
<html>
<head>
<title>ISUZU Online: Fejlmeddelelse</title>
<link REL="STYLESHEET" TYPE="text/css" HREF="<%=Application("Vroot")%>/include/web_style.css">
<base target="deere_main">
</head>
<body topmargin="0" leftmargin="0">
<div align="center">
<center>
<table border="0" width="500" cellspacing="0" cellpadding="2">
  <tr><td><img border="0" src="<%=Application("Vroot")%>/images/space.gif" WIDTH="20" HEIGHT="20"></td></tr>
  <tr><td align="center"><h1>Der er opstået en fejl.</h1></td></tr>
  <tr><td width="100%"><b>&nbsp;&nbsp;</b></td></tr>
  <tr><td align="center"><h4><%=Error%></h4></td></tr>
  <tr><td align="center">Gå <a href=javascript:history.back()>tilbage </A>og prøv igen.</td></tr>
</table>
</center>
</div>
</body>
</html>
<%
Response.End 
end function

function showDateAndTime()
    Response.Write "</tr><tr><td height=" & 12 & " align=center>Date: " & Now() & "</td></tr>"
end function

function WriteErrorUK(Error)
%>
<html>
<head>
<title>ISUZU Denmark - Dealerweb: Errormessage</title>
<link REL="STYLESHEET" TYPE="text/css" HREF="<%=Application("Vroot")%>/include/web_style.css">
<base target="_self">
</head>
<body topmargin="0" leftmargin="0">
<div align="center">
<center>
<table border="0" width="500" cellspacing="0" cellpadding="2">
  <tr><td><img border="0" src="<%=Application("Vroot")%>/images/space.gif" WIDTH="20" HEIGHT="20"></td></tr>
  <tr><td align="center"><h1>There is an error.</h1></td></tr>
  <tr><td width="100%"><b>&nbsp;&nbsp;</b></td></tr>
  <tr><td align="center"><h4><%=Error%></h4></td></tr>
  <tr><td align="center">Go <a href=javascript:history.back()>back </A>and try again.</td></tr>
</table>
</center>
</div>
</body>
</html>
<%
Response.End 
end function

function WriteErrorFatalClaim(Error)
%>
<html>
<head>
<title>ISUZU Online: Fejlmeddelelse</title>
<link REL="STYLESHEET" TYPE="text/css" HREF="<%=Application("Vroot")%>/include/web_style.css">
<base target="deere_main">
</head>
<body topmargin="0" leftmargin="0">
<div align="center">
<center>
<table border="0" width="500" cellspacing="0" cellpadding="3">
  <tr><td><img border="0" src="<%=Application("Vroot")%>/images/space.gif" WIDTH="20" HEIGHT="20"></td></tr>
  <tr><td align="center"><h1>Der er opstået en fejl.</h1></td></tr>
  <tr><td width="100%"><b>&nbsp;&nbsp;</b></td></tr>
  <tr><td align="center"><h4><%=Error%></h4></td></tr>
  <tr><td align="center"><a href=claim_list.asp>Claimoversigt</td></tr>
</table>
</center>
</div>
</body>
</html>
<%
Response.End 
end function

function WriteErrors(ErrorList,Errno)
%>
<html>
<head>
<title>ISUZU Online: Fejlmeddelelse</title>
<link REL="STYLESHEET" TYPE="text/css" HREF="<%=Application("Vroot")%>/include/web_style.css">
<base target="deere_main">
</head>
<body topmargin="0" leftmargin="0">
<div align="center">
<center>
<table border="0" width="500" cellspacing="0" cellpadding="3">
  <tr><td><img border="0" src="<%=Application("Vroot")%>/images/space.gif" WIDTH="20" HEIGHT="20"></td></tr>
  <tr><td align="center"><h1>Der er opstået en fejl.</h1></td></tr>
  <tr><td width="100%"><b>&nbsp;&nbsp;</b></td></tr>
  <%for c = 1 to Errno%>
	<tr><td align="left"><h4 class="error"><%=ErrorList(c)%></h4></td></tr>
  <%next%>
  <tr><td align="left">Gå <a href=javascript:history.back()>tilbage </A>og prøv igen.</td></tr>
</table>
</center>
</div>
<p>&nbsp;</p>
</body>
</html>
<%
Response.End 
end function
%>