<% 

Function emailbodystrAX(OrId, Subject, emNote)


Set emCISCOOOrders = Server.CreateObject("ADODB.Recordset") 
strSQL = "SELECT * FROM CISCOOCarOrder WHERE OrderId=" & OrId & ";"
emCISCOOOrders.Open strSQL, strDSNAX, adOpenStatic, , adCmdText

'Response.Write(strSQL&"<br/>")
'Response.Write("Hallo51a<br/>")
'Response.Write("("&OrId&")")
'Response.Write("("&emCISCOOOrders("DealerId")&")")
'Response.End

Set emCISCOOUsers = Server.CreateObject("ADODB.Recordset")  
strSQL = "SELECT * FROM [CISCOOUsers] WHERE DealerId=" & emCISCOOOrders("DealerId") & ";" 
'Response.Write(strSQL&"<br/>")
'Response.End

emCISCOOUsers.Open strSQL, strDSNAX, adOpenStatic, , adCmdText
'Response.Write("Hallo51<br/>")
'Response.End

DealerId = emCISCOOOrders("DealerId")

Set emCISCOOOrderAccessories = Server.CreateObject("ADODB.Recordset")
strSQL = "SELECT CISCOOSelectCategoriesOptions.OptionName AS OptName, CISCOOOrderAccessories.OrderId FROM CISCOOOrderAccessories INNER JOIN CISCOOSelectCategoriesOptions ON CISCOOOrderAccessories.OptionId = CISCOOSelectCategoriesOptions.Id WHERE CISCOOOrderAccessories.OrderId=" & int(OrId) & ";"
emCISCOOOrderAccessories.Open strSQL, strDSNAX, adOpenStatic, , adCmdText

Set emCISCOOSelectCategories = Server.CreateObject("ADODB.Recordset")  
strSQL = "SELECT * FROM [CISCOOSelectCategories] WHERE CategoryType = 1 ORDER BY LayoutOrder;" 
emCISCOOSelectCategories.Open strSQL, strDSNAX, adOpenStatic, , adCmdText      
'Response.Write("Hallo51<br/>")
'Response.End

MailHtmlBody = "<html xmlns='http://www.w3.org/1999/xhtml'>" + vbcrlf
MailHtmlBody = MailHtmlBody & "<head>" + vbcrlf
MailHtmlBody = MailHtmlBody & "<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />" + vbcrlf
MailHtmlBody = MailHtmlBody & "<title>" & Subject & "</title>" + vbcrlf
MailHtmlBody = MailHtmlBody & "<style type='text/css'>" + vbcrlf
MailHtmlBody = MailHtmlBody & "<!--" + vbcrlf
MailHtmlBody = MailHtmlBody & "body,td,th {" + vbcrlf
MailHtmlBody = MailHtmlBody & "	font-family: Arial, Helvetica, sans-serif;" + vbcrlf
MailHtmlBody = MailHtmlBody & "	font-size: 12px;" + vbcrlf
MailHtmlBody = MailHtmlBody & "}" + vbcrlf
MailHtmlBody = MailHtmlBody & ".HeadText {" + vbcrlf
MailHtmlBody = MailHtmlBody & "	font-size: 14px;" + vbcrlf
MailHtmlBody = MailHtmlBody & "	font-weight: bold;" + vbcrlf
MailHtmlBody = MailHtmlBody & "}" + vbcrlf
MailHtmlBody = MailHtmlBody & ".HeadText1 {" + vbcrlf
MailHtmlBody = MailHtmlBody & "	font-size: 12px;" + vbcrlf
MailHtmlBody = MailHtmlBody & "	font-weight: bold;" + vbcrlf
MailHtmlBody = MailHtmlBody & "}" + vbcrlf
MailHtmlBody = MailHtmlBody & "-->" + vbcrlf
MailHtmlBody = MailHtmlBody & "</style></head>" + vbcrlf

MailHtmlBody = MailHtmlBody & "<body>" + vbcrlf
if emNote > "" then
MailHtmlBody = MailHtmlBody & "<table border='0' cellpadding='0' cellspacing='10' width='600'>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                      <tr><td>" + vbcrlf
MailHtmlBody = MailHtmlBody & emNote + vbcrlf
MailHtmlBody = MailHtmlBody & "                      </td></tr></table>" + vbcrlf
end if
MailHtmlBody = MailHtmlBody & "<table border='0' cellpadding='0' cellspacing='10' width='600'>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                      <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                        <td width='50%' align='center' valign='top'><table width='250' border='0' cellspacing='0' cellpadding='2'>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf

p = " -" & emCISCOOUsers("DealerNum") & "-" & emCISCOOUsers("DealerId")

MailHtmlBody = MailHtmlBody & "                              <td height='20' colspan='2' class='HeadText'>Forhandler" & p & "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td colspan='2'><hr size='1' noshade></td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td>Forhandler</td>" + vbcrlf

p = emCISCOOUsers("Company")

MailHtmlBody = MailHtmlBody & "                              <td height='20'><span class='HeadText1'>" + p + "</span>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td>Sælger</td>" + vbcrlf

MailHtmlBody = MailHtmlBody & "                              <td height='20'><span class='HeadText1'>" + emCISCOOOrders("DealerSalesPerson") + "</span>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td height='20'>Adresse</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td height='20'><span class='HeadText1'>" + emCISCOOUsers("Street") + "</span>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td height='20'>Postnr.</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td height='20'><span class='HeadText1'>" + emCISCOOUsers("ZipCode") + "</span>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td height='20'>By</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td height='20'><span class='HeadText1'>" + emCISCOOUsers("City") + "</span>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td height='20'>Telefonnr.</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td height='20'><span class='HeadText1'>" + emCISCOOUsers("Phone") + "</span>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td nowrap class='HeadText1'>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td colspan='2' class='HeadText'>Kunde</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td colspan='2'><hr size='1' noshade></td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top'>Kundenavn</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top' class='HeadText1'>" & emCISCOOOrders("EndUserName") & " </td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top'>Adresse</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top' class='HeadText1'>" & emCISCOOOrders("EndUserStreet") & "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top'>Postnr.</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top' class='HeadText1'>" & emCISCOOOrders("EndUserZipCode") & "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top'>By</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top' class='HeadText1'>" & emCISCOOOrders("EndUserCity") & "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top'>Telefonnr.</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top' class='HeadText1'>" & emCISCOOOrders("EndUserPhone") & "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top'>Slutseddeldato</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top' class='HeadText1'>" & emCISCOOOrders("EndUserBuyDate") & "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top'>Byttebil</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td class='HeadText1'>" & emCISCOOOrders("tradeinYear") & " " & emCISCOOOrders("tradeinBrand") & " " & emCISCOOOrders("tradeinModel") & "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top'>Køn</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td class='HeadText1'>" & emCISCOOOrders("EndUserGender") & " </td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top'>Alder</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td nowrap>Person 1: <span class='HeadText1'>" & emCISCOOOrders("EndUserAge1") & "</span> <br>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                                Person 2: <span class='HeadText1'>" & emCISCOOOrders("EndUserAge2") & "</span></td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top'>Type</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td class='HeadText1'>" + emCISCOOOrders("EndUserType") + "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top' nowrap> KIA forsikring</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td class='HeadText1'>" + vbcrlf

If emCISCOOOrders("Insurance") Then 
MailHtmlBody = MailHtmlBody & "Ja"
else 
MailHtmlBody = MailHtmlBody & "Nej"
end if

MailHtmlBody = MailHtmlBody & "                              </td>" + vbcrlf                              
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td valign='top' nowrap>Marketing</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td class='HeadText1'>" + emCISCOOOrders("Marketing") + "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td nowrap class='HeadText1'>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td nowrap class='HeadText1'>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                              <td nowrap class='HeadText1'>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                        </table>                        </td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                        <td align='center' valign='top'>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <table border='0' cellspacing='0' cellpadding='2' width='250'>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td height='20' colspan='2' valign='top' class='HeadText'>Vognbestilling</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td colspan='2' valign='top'><hr size='1' noshade></td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td>BestillingsId</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td nowrap class='HeadText1'>" & emCISCOOOrders("OrderId") & "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td>Dato</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td nowrap class='HeadText1'>" & emCISCOOOrders("OrderDate") & "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td>Forh. bestillings måned</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td nowrap class='HeadText1'>" & HMonth(emCISCOOOrders("OrderMonth")) & "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td>Forv. leverings måned</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td nowrap class='HeadText1'>" & HMonth(emCISCOOOrders("ExpArrival")) & "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td nowrap class='HeadText1'>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td height='20' valign='top'>Status:</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td class='HeadText1'>" + emCISCOOOrders("CarStatus") + "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td height='20' valign='top'>Vognnummer:</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td class='HeadText1'>" + emCISCOOOrders("CarAccount") + "</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td valign='top'>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td valign='top' class='HeadText1'>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td valign='top'>Model:</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td valign='top' class='HeadText1'>" + emCISCOOOrders("CarBrandModelGroup") + " </td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf

Do
    MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
    MailHtmlBody = MailHtmlBody & "                            <td valign='top'>" + emCISCOOSelectCategories("CategoryName") + ":</td>" + vbcrlf
    MailHtmlBody = MailHtmlBody & "                            <td valign='top' class='HeadText1'>" + emCISCOOOrders("CarOption" & emCISCOOSelectCategories("id")) + "</td>" + vbcrlf
    MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
    emCISCOOSelectCategories.MoveNext
loop until emCISCOOSelectCategories.eof

MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td valign='top'>Udstyr:</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td valign='top' class='HeadText1'>" + vbcrlf

if emCISCOOOrderAccessories.eof = False then
Do 
    MailHtmlBody = MailHtmlBody &   emCISCOOOrderAccessories("OptName") + "<br>" + vbcrlf
                                    emCISCOOOrderAccessories.MoveNext
loop until emCISCOOOrderAccessories.eof
end if

MailHtmlBody = MailHtmlBody & "                                </td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td height='20' valign='top'>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td>Bestillingstype</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td nowrap class='HeadText1'><span class='HeadText1'>" + emCISCOOOrders("OrderFrom") + "</span></td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td height='20' valign='top'>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                          <tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td height='20' valign='top'>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            <td>&nbsp;</td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                            </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                        </table></td>" + vbcrlf
MailHtmlBody = MailHtmlBody & "                      </tr>" + vbcrlf
MailHtmlBody = MailHtmlBody & "      </table>" + vbcrlf
MailHtmlBody = MailHtmlBody & "</body>" + vbcrlf
MailHtmlBody = MailHtmlBody & "</html>" + vbcrlf

emCISCOOUsers.Close
Set emCISCOOUsers = Nothing

emCISCOOOrders.Close
Set emCISCOOOrders = Nothing

emCISCOOOrderAccessories.Close
Set emCISCOOOrderAccessories = Nothing

emCISCOOSelectCategories.Close
Set emCISCOOSelectCategories = Nothing

emailbodystrAX = MailHtmlBody
end function
%>