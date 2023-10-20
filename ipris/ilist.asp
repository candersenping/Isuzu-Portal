<%@ Language=VBScript %>
<!-- #include file="../include/db.asp" -->
<!-- #include file="../include/functions.asp" -->
<%Checklogin%>
	<html>
	<Body Topmargin="0" Leftmargin="0">
	<Div Align="center">
	<Center>
	<%
	WriteHeader "Isuzu Online: Interne Prislister", "Interne Prislister"
	dim strPathInfo, strPhysicalPath
	strPathInfo = Request.ServerVariables("PATH_INFO")
	strPhysicalPath = Server.MapPath(strPathInfo)
	
	Dim objFSO, objFile, objFileItem, objFolder, objFolderContents
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	set objFile = objFSO.GetFile(strPhysicalPath)
	set objFolder = objFile.ParentFolder
	set objFolderContents = objFolder.Files
	%>

	<TABLE align="Center" border="0" Width="600" cellspacing="2" cellpadding="3">
	<TR>
		<TD bgcolor="#C0C0C0" align="left">  <H5>Dokumentnavn</H5></TD>
		<TD bgcolor="#C0C0C0" align="right"> <H5>Størrelse</H5></TH>
		<TD bgcolor="#C0C0C0" align="center"><H5>Sidste rettet</H5></TH>
	</TR>	
	<%
	For Each objFileItem in objFolderContents
		If UCase(Right(objFileItem.Name,3)) = "PDF" or UCase(Right(objFileItem.Name,3)) = "DOC" or UCase(Right(objFileItem.Name,4)) = "XLSX" then
	%>
		<TR>
			<TD align="left"   class="<%WriteTD(0)%>"><A HREF="<%=objFileItem.Name%>"><%=objFileItem.Name%></TD>
			<TD align="right"  class="<%WriteTD(0)%>"><%=objFileItem.size%></TD>
			<TD align="center" class="<%WriteTD(0)%>"><%=objFileItem.DateLastModified%></TD>
		</TR>
		<%End If
	Next%>
	</TABLE>
	<TABLE align="Center" border="0" Width="600" cellspacing="2" cellpadding="3">
		<tr></tr>
		<tr><td align="center"><a href="<%=Application("Vroot")%>../frameset.asp" target="_top" class="menu">Gå til Start</a><p>&nbsp;</p></td></tr>
	</TABLE>
	</BODY>
	</HTML>




























