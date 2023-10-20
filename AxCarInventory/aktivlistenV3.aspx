<%@ Page Language="C#" AutoEventWireup="true" CodeFile="aktivlistenV3.aspx.cs" Inherits="lagerstyring_aktivlisten" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Egne Ordre- & Lagerbiler</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <style type="text/css">
        a {
	        color: black;
	        text-decoration:none;
        }
        body {
	        font-family:microsoft sans serif;
	        font-size: 12px;
        }
        h1 {
	        font-family:Lucida Sans Unicode;
	        font-size:20px;
	        color:#cc3333;
        }
        .detaillist 
        {
            font-size:10px;
            width:798px;
            border-style:none;
            text-align:left;
            
        }
        .detaillist td
        {
        	padding:0px 3px 0px 3px;
        }
        .detaillist th
        {
        	background-color:#DDDDDD;
        	padding:0px 3px 0px 3px;
        }
        .detaillistrow
        {
        	background-color:#fff;
        }
        .detaillistrowalt
        {
        	background-color:#F5FAFA;
        }
        
        .btn
        {
        	width: 20px;
        	height: 15px;
        	font-size: 8px;

        }
    </style>
    <script type="text/javascript">
        function trMouseOver(obj) {
            //obj.bgColor = '#8BB381';
        }
        function trMouseOut(obj) {
            if (obj.bgColor == '#8BB381') {
            }
            else {
                //obj.bgColor = '#FFFFFF';
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width:100%";>
        <div style="width:800px; display:block;">
            <div style="text-align:center;">
                <h1><asp:Label runat="server" ID="Headlinelbl" /></h1>
                <asp:Literal runat="server" ID="listLiteral" />
                <asp:Label runat="server" ID="Filter" Text="Søgefilter til afgrænsning af nedenstående:" />
                <asp:Label runat="server" ID="testlbl" />
                <table style="border: medium solid #cccccc; text-align:left;">
                <tr>
                    <td><asp:Label runat="server" ID="modellbl" Text="Model" Width="60" Font-Bold="True"></asp:Label></td>
                    <td><asp:DropDownList runat="server" ID="ddlModel" OnTextChanged="doSearchModel" AutoPostBack="True" Width="100"></asp:DropDownList></td>
                    <td><asp:Label runat="server" ID="motorlbl" Text="Motor" Width="60" Font-Bold="True"></asp:Label></td>
                    <td><asp:DropDownList runat="server" ID="ddlMotor" OnTextChanged="doSearchMotor" AutoPostBack="True" Width="100"></asp:DropDownList></td>
                    <td><asp:Label runat="server" ID="typelbl" Text="Type" Width="60" Font-Bold="True"></asp:Label></td>
                    <td><asp:DropDownList runat="server" ID="ddlType"  OnTextChanged="doSearchType"  AutoPostBack="True" Width="375"></asp:DropDownList></td>
                </tr>
                <tr>
                    <td><asp:Label runat="server" ID="colorlbl" Text="Farve" Width="60" Font-Bold="True"></asp:Label></td>
                    <td><asp:DropDownList runat="server" ID="ddlColor" OnTextChanged="doSearchColor" AutoPostBack="True" Width="100"></asp:DropDownList></td>
                    <td><asp:Label runat="server" ID="Availablelbl" Text="Vis" Width="60" Font-Bold="True"></asp:Label></td>
                    <td><asp:RadioButtonList ID="ddlAvailable" OnTextChanged="doSearchAvailable" AutoPostback="true"
                            runat="server" RepeatDirection="Horizontal" >
                        <asp:ListItem Value="0">Alle</asp:ListItem>
                        <asp:ListItem Value="1">Ledige</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td><asp:Label runat="server" ID="searchlbl" Text="Afgrænsning" Width="70" Font-Bold="True"></asp:Label></td>
                    <td><asp:TextBox runat="server" ID="searchStr" AutoPostBack="True" OnTextChanged="doSearchStr" Width="375"></asp:TextBox></td>
                </tr>
                </table>
            </div>
            <div>
                <table cellpadding="4" cellspacing="0" style="width:800px; border-style:none;">
                    <tr style="background-color:#DDDDDD;">
                        <th style="text-align:left;">
                            Model
                        </th>
                        <th style="text-align:left; width:100px;">
                            Type
                        </th>
                        <th style="text-align:left; width:50px;">
                            Lager
                        </th>
                    </tr>
                </table>
                <table border="0" cellpadding="4" cellspacing="0" style="border:1px solid #cccccc;border-top:0; width:800px;">
                    <asp:Repeater ID="aktivListRepeater" runat="server" OnItemCommand="webtypeBtn_OnClick">
                    <ItemTemplate>
                    <tr runat="server" id="reprow" onmouseover="trMouseOver(this);" onmouseout="trMouseOut(this);">
                        <td style="border-bottom:1px solid #cccccc; border-top:1px solid #cccccc;">
                                <asp:LinkButton ID="webtypeBtn" OnClientClick="trMouseOver('1');" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "WEBTYPE")%>' />
                        </td>
                        <td style="border-bottom:1px solid #cccccc; border-top:1px solid #cccccc; width:100px;">
                            <asp:Label runat="server" ID="carCertTypelbltxt" Text='<%# formatCarcertType(DataBinder.Eval(Container.DataItem, "CARCERTTYPE").ToString())%>' />
                            <asp:Label runat="server" ID="carCertTypelblnbr" Visible="false" Text='<%# DataBinder.Eval(Container.DataItem, "CARCERTTYPE")%>' />
                            <asp:Label runat="server" ID="repOpenlbl" Visible="false" Text='0' />
                        </td>
                        <td style="border-bottom:1px solid #cccccc; border-top:1px solid #cccccc; width:50px;">
                            <asp:Label runat="server" ID="cntLbl" Text='<%# DataBinder.Eval(Container.DataItem, "cnt") + " stk."%>' />
                            <asp:Label runat="server" ID="modelLbl" Visible="false" Text='<%# DataBinder.Eval(Container.DataItem, "MODEL")%>' />
                            <asp:label runat="server" ID="testlbl" />
                        </td>
                    </tr>
                    <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
                    </ItemTemplate>
                    </asp:Repeater>
                </table>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
