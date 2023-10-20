<% if Session("WebLogon") = "" then response.Redirect("/default.asp") 

function HMonth(Dato)


select case month(Dato)
case 1
HMonth = "Januar " & year(Dato)
case 2
HMonth = "Februar " & year(Dato)
case 3
HMonth = "Marts " & year(Dato)
case 4
HMonth = "April " & year(Dato)
case 5
HMonth = "Maj " & year(Dato)
case 6
HMonth = "Juni " & year(Dato)
case 7
HMonth = "Juli " & year(Dato)
case 8
HMonth = "August " & year(Dato)
case 9 
HMonth = "September " & year(Dato)
case 10
HMonth = "Oktober " & year(Dato)
case 11
HMonth = "November " & year(Dato)
case 12
HMonth = "December " & year(Dato)
end select
end function

%>