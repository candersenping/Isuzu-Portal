<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CarBookingV1.aspx.cs" Inherits="AxCarBooking_CarBookingV1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>ISUZU Import Danmark</title>
    <link rel="STYLESHEET" type="text/css" href="/include/web_style.css"/>
    <script type = "text/javascript">
        function Confirm() {
            var confirm_value2 = document.createElement("INPUT");
            confirm_value2.type = "hidden";
            confirm_value2.name = "confirm_value";
            if (confirm("Do you want to save data?"))
            {
                confirm_value2.value = "Yes";
            }
            else
            {
                confirm_value2.value = "No";
            }
            document.forms[0].appendChild(confirm_value2);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <h1><table>
        <asp:Label ID="PageTxt" runat="server" Text=""></asp:Label>
        <h4><asp:Label ID="MessageInfo" runat="server" Text=""></asp:Label></h4>
    </table></h1>
    <div>
        <asp:GridView ID="BookingView" runat="server" 
            OnRowDataBound="BookingView_OnRowBound" 
            AutoGenerateColumns="False"             
            CellPadding="4" 
            BackColor="White"            
            GridLines="None">            
        <Columns>
            <asp:BoundField DataField="CARACCOUNT" HeaderText="Vogn" SortExpression="CARACCOUNT" ItemStyle-VerticalAlign="Top" />
            <asp:BoundField DataField="DESCRIPTION" HeaderText="Navn" ItemStyle-Width="400" SortExpression="DESCRIPTION" ItemStyle-VerticalAlign="Top" />
            <asp:BoundField DataField="REGNUM" HeaderText="Reg.nr." SortExpression="CARREGNUM" ItemStyle-VerticalAlign="Top" />
            <asp:TemplateField HeaderText="Kalender">
                <ItemTemplate>
                    <asp:Calendar ID="Calendar1" runat="server" OnDayRender="RenderDay" OnSelectionChanged="C1_selectionChanged" ShowTitle="True"></asp:Calendar>
                </ItemTemplate>
                <HeaderStyle ForeColor="White" />
            </asp:TemplateField>
        </Columns>
            <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
            <RowStyle BackColor="White" ForeColor="#333333" />
            <SelectedRowStyle BackColor="White" Font-Bold="True" ForeColor="Navy" />
            <SortedAscendingCellStyle BackColor="#FDF5AC" />
            <SortedAscendingHeaderStyle BackColor="#4D0000" />
            <SortedDescendingCellStyle BackColor="#FCF6C0" />
            <SortedDescendingHeaderStyle BackColor="#820000" />
        </asp:GridView>
    </div>
        
        <table><tr><td><asp:Button ID="Start" runat="server" Text="Gå til start" OnClick="Start_Click" /></td></tr></table>
        <asp:Table ID="DealerTabel" runat="server"></asp:Table>
    </form>
</body>
</html>
