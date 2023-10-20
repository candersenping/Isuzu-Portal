<%@ Language=VBScript %>
<!-- #include file="include/db.asp" -->
<!-- #include file="include/functions.asp" -->
<%Checklogin%>
<html>

<head>
<title></title>
<base target="deere_main">
<link REL="STYLESHEET" TYPE="text/css" HREF="include/web_style.css">
</head>

<body>
<div style="margin-left:15px;">
<table border="0" height="70">
<tr><td>
    <table>
      <tr><td bgcolor="#FFFFFF" ><img border="0" src="images/isuzulogo.bmp"></td></tr>
      <tr><td bgcolor="#999999" ><img border="0" src="images/space.gif" width="20" height="3"></td></tr>	  
	</table>

	<table border="0" cellpadding="0" >
		<tr><td><img border="0" src="images/space.gif" width="20" height="20"></td>
		<tr></tr>
        
		<!-- AX integrationer/links: Start her-->
		<tr><td><a href="/AxSearch/carSearch.asp" target="deere_main" class="menu">Vognsøgning</a></td></tr>
        <tr><td><a href="/AxSearch/partSearch.asp" target="deere_main" class="menu">Varenummersøgning</a></td></tr>
		<%if rsUser("RETTSALES") <> 0 then%>
            <tr><td><a href="/AxCarInventory/aktivlistenV3.aspx?m=3" target="deere_main" class="menu">Lagerbiler</a></td></tr>
        <%end if%>
		<%if rsUser("RETTBOOKING") <> 0 then%>
		    <tr><td ><a href="/AxCarBooking/CarBookingV1.aspx" target="deere_main" class="menu">Bookning af biler</a></td></tr>
		<%end if%>
		<tr><td></br></td></tr>
		
		<%if rsUser("RETTSALES") <> 0 then%>
		    <tr><td><a href="ba/balist.asp" target="deere_main" class="menu">Bestillingsark</a></td></tr>
		<%end if%>
		<%if rsUser("RETTSALES") <> 0 then%>
		    <tr><td><a href="ma/malist.asp" target="deere_main" class="menu">Merchandise</a></td></tr>
		<%end if%>
		<%if rsUser("RETTSALES") <> 0 then%>
		    <tr><td><a href="respris/rplist.asp" target="deere_main" class="menu">Reservedelspriser</a></td></tr>
		<%end if%>
		<%if rsUser("RETTSALES") <> 0 then%>
		    <tr><td><a href="iprisny/ilist.asp" target="deere_main" class="menu">Interne Prislister</a></td></tr>
		<%end if%>
		<%if rsUser("RETTSALES") <> 0 then%>
		    <tr><td><a href="speres/speres.asp" target="deere_main" class="menu">Specielle Reservedele</a></td></tr>
		<%end if%>
		<%if rsUser("RETTSALES") <> 0 then%>
		    <tr><td><a href="rekform/rekformlist.asp" target="deere_main" class="menu">Reklamationsformularer</a></td></tr>
		<%end if%>
		<%if rsUser("RETTSALES") <> 0 then%>
		    <tr><td ><a href="rb/Reservedels bestemmelser ISUZU Danmark AS 2023-06-01.pdf" target="deere_main" class="menu">Reservedelsbestemmelser</a></td></tr>
		<%end if%>
		<%if rsUser("RETTSALES") <> 0 then%>
		    <tr><td ><a href="files.aspx?m=1&folder=files&name=Foto og Film" target="deere_main" class="menu">Foto og Film</a></td></tr>
		    <!--<tr><td><a href="https://www.dropbox.com/sh/mll894jr53axngv/AAAoZ22qY6R02_G91e1h0Bx2a?dl=0" target="_new" class="menu">Foto & Film</a></td></tr>-->
		<%end if%>
		<%if rsUser("RETTSALES") <> 0 then%>
		    <tr><td><a href="annoncer/annlist.asp" target="deere_main" class="menu">Annoncer/Brochurer</a></td></tr>
		<%end if%>
		<%if rsUser("RETTSALES") <> 0 then%>
		    <tr><td><a href="tilbeh/tilbehlist.asp" target="deere_main" class="menu">Reservedele & Tilbehør Prislister</a></td></tr>
		<%end if%>   
		<%if rsUser("RETTTECHNIC") <> 0 then%>
		    <tr><td><a href="servicepris/splist.asp" target="deere_main" class="menu">Servicepriser</a></td></tr>
		<%end if%>
		<%if rsUser("RETTTECHNIC") <> 0 then%>
		    <tr><td><a href="lts/ltslist.asp" target="deere_main" class="menu">Garanti Standard Tider</a></td></tr>
		<%end if%>
                <%if rsUser("RETTTECHNIC") <> 0 then%>
		    <tr><td><a href="sikdata/sikdata.asp" target="deere_main" class="menu">Sikkerhedsdatablade</a></td></tr>
		<%end if%>
		<%if rsUser("RETTSALES") <> 0 then%>
		    <tr><td><a href="cirku/sm2015/cirku_listsorted.asp" target="deere_main" class="menu">Salgscirkulærer</a></td></tr>
		<%end if%>
		<%if rsUser("RETTTECHNIC") <> 0 then%>
		    <tr><td><a href="cirku/EF2015/cirku_listsorted.asp" target="deere_main" class="menu">Eftermarkedscirkulærer</a></td></tr>
		<%end if%>
		<%if rsUser("RETTTECHNIC") <> 0 then%>
		    <tr><td><a href="teknik/montvejl/montlist.asp" target="deere_main" class="menu">Monteringsvejledninger</a></td></tr>
		<%end if%>
		<%if rsUser("RETTTECHNIC") <> 0 then%>
		    <tr><td><a href="teknik/servicecheck/silist.asp" target="deere_main" class="menu">Service- & Check Skemaer</a></td></tr>
		<%end if%>
		<%if rsUser("RETTTECHNIC") <> 0 then%>
		    <tr><td><a href="teknik/serviceinfo/silist.asp" target="deere_main" class="menu">Serviceinformationer</a></td></tr>
		<%end if%>
		<%if rsUser("RETTTECHNIC") <> 0 then%>
		    <tr><td><a href="academy/frameset.asp" target="_top" class="menu">Isuzu Academy</a></td></tr>
		<%end if%>
		<%if rsUser("RETTSALES") <> 0 then%>
		    <tr><td><a href="rap/raplist.asp" target="deere_main" class="menu">Rapporter</a></td></tr>
		<%end if%>
		<tr><td ><a href="forhandlerliste/forhandlerliste.pdf" target="deere_main" class="menu">Forhandlerliste</a></td></tr>
		<%if rsUser("RETTSALES") <> 0 then%>
		    <tr><td><a href="training/trailist.asp" target="deere_main" class="menu">Træningsvideoer</a></td></tr>
		<%end if%>  

		<%if rsUser("RETTINTERN") <> 0 then%>
            <!--<tr><td><a href="files.aspx?m=1&folder=files&name=Foto og Film" target="deere_main" class="menu">Foto og Film</a></td></tr>-->
        <%end if%>


		<tr><td ><img border="0" src="images/space.gif" width="20" height="20"></td>
		<tr><td ><a href="intern/intern.pdf" target="deere_main" class="menu">Kontakt ISUZU</a></td></tr>
		<tr><td ><img border="0" src="images/space.gif" width="20" height="20"></td>
		<tr><td ><a href="claimhb/hblist.asp" target="deere_main" class="menu">ISUZU SPPM Reklamationshåndbog</a></td></tr>
		<tr><td><a href="../frameset.asp" target="_top" class="menu">Start</a></td></tr>
        <tr><td></br></td></tr>
        <tr><td ><a href="<%=application("Vroot")%>include/_logoff.asp" target="_top" class="menu">Afslut</a></td></tr>
    </table>
</table>
</div>
</body>
</html>