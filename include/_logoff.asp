<%@ Language=VBScript %>
<!-- #include file="../include/db.asp" -->
<!-- #include file="../include/functions.asp" -->
<%
Session.Abandon
Response.Cookies("KIA")("user") = ""
Response.Cookies("KIA").Expires = Date() - 1
Response.Redirect(Application("Vroot") & "/default.asp")
%>