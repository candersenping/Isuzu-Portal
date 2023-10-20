<%@ Page Language="C#" AutoEventWireup="true" CodeFile="files.aspx.cs" Inherits="files" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" type="text/css" href="include/web_style.css" />
    <link rel="stylesheet" type="text/css" href="include/AbpStyles.css" />

    <title></title>

</head>
<body aria-haspopup="True">
    
        <table style="width:600px;margin-left:100px;">
            <tr><td><h2><%=PageName %></h2></td></tr>
            <tr><td style="background-color:black;height:3px"></td></tr> 
        </table>
    
    <form id="form1" runat="server">
        <div>
            <table style="width:600px;margin-left:100px;"><tr><td>
            <asp:TreeView OnTreeNodeExpanded="On_Expand" OnSelectedNodeChanged="On_Select" ID="TreeView1" runat="server" style="font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;" ImageSet="Arrows">
                <HoverNodeStyle Font-Underline="True" ForeColor="#5555DD" />

                <NodeStyle Font-Names="Tahoma" Font-Size="12pt" ForeColor="Black" HorizontalPadding="5px" NodeSpacing="1px" VerticalPadding="1px" />
                <ParentNodeStyle Font-Bold="False" />
                
                <SelectedNodeStyle Font-Underline="True" HorizontalPadding="0px" VerticalPadding="0px" ForeColor="#5555DD" />
            </asp:TreeView>
            </td></tr></table>
        </div>

    </form>
    <table style="width:600px;margin-left:100px;">
		<tr></tr>
		<tr><td><a href="/frameset.asp" target="_top" class="menu">gå til start</a></td></tr>
	</table>
</body>
</html>
