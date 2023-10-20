<%
Response.Expires = 0

const adStateClosed = 0
const adStateOpen = 1
dim bConnectionOpen
dim bShoperLoaded
dim bCartLoaded 
dim rsUser
dim rsCart
dim conn
dim connax
dim user

DaID     = "DATAAREAID='ISU' AND "
cCompany = "ISU"

on error resume next
set conn   = Application("conn")
set connax = Application("connax")
on error goto 0

Function Encode(s, delim)
    Dim i, retval, ch
    If InStr(1, s, delim) <> 0 Then
        For i = 1 To Len(s)
            ch = Mid(s, i, 1)
            If ch = delim Then ch = delim & delim
            retval = retval & ch
        Next
        Encode = retval
    Else
        Encode = s
    End If
End Function

Function SafeString(s)
    Dim retval
    If IsNull(s) Or s = "" Then
        retval = "Null"
    Else
        s = Replace(s, "|", "/")
        retval = "'" & Encode(s, "'") & "'"
    End If
    SafeString = retval
End Function

function SafeLong(byval v)
	dim retval
	on error resume next
	retval = CLng(v)
	if err<>0 then retval = clng(0)
	SafeLong = retval
end function

function SafeULong(byval v)
	dim retval
	retval = SafeLong(v)
	if retval < 0 then retval = 0
	SafeULong = retval
end function

function FormatText(s)
	dim retval
	if isnull(s) then 
		retval = ""
	else
		retval = server.HTMLEncode(s)
		retval = replace(retval, chr(10) & " ", chr(10) & "&nbsp;")
		retval = replace(retval, "  ", "&nbsp;&nbsp;")
		retval = replace(retval, "&nbsp; ", "&nbsp;&nbsp;")
		retval = replace(retval, chr(13) & chr(10), "<br>")
	end if
	FormatText = retval
end function

function InitCounter(table)
	dim max
	if IsNull(Application("Next" & table)) then
		set rs = conn.Execute("SELECT max([" & table & "]) AS maxid FROM [" & table & "]")
		max = rs("maxid")
		if isnull(max) then max = 0
		application.Lock
		application("Next" & table) = max + 1
		application.UnLock
	end if
end function
%>