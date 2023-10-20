<%@ Language=VBScript %>
<!-- #include file="../../../include/db.asp" -->
<!-- #include file="../../../include/functions.asp" -->
<%Checklogin%>
	<html>
	<Body Topmargin="0" Leftmargin="0">
	<Div Align="center">
	<Center>
	<%
	WriteHeader "Isuzu Online: Serviceinformationer", "D-MAX RT56 Serviceinformationer"
	dim strPathInfo, strPhysicalPath, list_files(1000), list_size(1000), list_date(1000), list_antal
	strPathInfo = Request.ServerVariables("PATH_INFO")
	strPhysicalPath = Server.MapPath(strPathInfo)
	
	Dim objFSO, objFile, objFileItem, objFolder, objFolderContents
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	set objFile = objFSO.GetFile(strPhysicalPath)
	set objFolder = objFile.ParentFolder
	set objFolderContents = objFolder.Files

	For Each objFileItem in objFolderContents
		If UCase(Right(objFileItem.Name,3)) = "PDF" Then
			list_antal             = list_antal + 1
			list_files(list_antal) = objFileItem.Name
			list_size(list_antal)  = objFileItem.size
			list_date(list_antal)  = Mid(objFileItem.DateLastModified,1,10)
		End if
	Next
	list_max = list_antal

	%>

	<TABLE align="Center" border="0" Width="600" cellspacing="2" cellpadding="3">
	<TR>
		<TD bgcolor="#C0C0C0" align="left">  <H5>Serviceinformation</H5></TD>
		<TD bgcolor="#C0C0C0" align="right"> <H5>Størrelse</H5></TH>
		<TD bgcolor="#C0C0C0" align="center"><H5>Sidste rettet</H5></TH>
	</TR>	
	<%For i = 1 to list_antal%>
		<TR>
			<TD align="left"   class="<%WriteTD(0)%>"><A HREF="<%=list_files(list_max)%>"><%=list_files(list_max)%></TD>
			<TD align="right"  class="<%WriteTD(0)%>"><%=list_size(list_max)%></TD>
			<TD align="center" class="<%WriteTD(0)%>"><%=list_date(list_max)%></TD>
		</TR>
		<%list_max = list_max - 1%>
	<%Next%>
	</TABLE>
	<TABLE align="Center" border="0" Width="600" cellspacing="2" cellpadding="3">
		<tr></tr>
		<tr><td align="center"><a href="javascript:history.back();" target="_top" class="menu">Tilbage</a></td></tr>
	</TABLE>
	</BODY>
	</HTML>





























