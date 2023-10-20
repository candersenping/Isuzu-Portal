<%@ Language=VBScript %>
<!-- #include file="include/db.asp" -->
<!-- #include file="include/functions.asp" -->
<html>

<head>
<title>Velkommen til Isuzu Denmark Forhandlersystem.</title>
<link REL="STYLESHEET" TYPE="text/css" HREF="include/web_style.css">

<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-24074632-2']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>

</head>

<body onLoad="document.form1.login.focus()"></body>

<body topmargin="0" leftmargin="0" bgcolor="#FFFFFF">

<table border="0" width="100%" cellspacing="0" cellpadding="0">
  <tr><td bgcolor="#FFFFFF"><img border="0" src="images/space.gif" width="20" height="10"></td></tr>
  <tr><td bgcolor="#FFFFFF" align="center"><img border="0" src="images/isuzulogo.bmp"></td></tr>
  <tr><td bgcolor="#FFFFFF" align="center"><h2><b>Velkommen til Isuzu Danmark Forhandlernet</h2></b></tr>
  <tr><td bgcolor="#FFFFFF" align="center"><h4><b>(Welcome to Isuzu Denmark Dealernet)</h4></b></tr>  
  <tr><td bgcolor="#999999" align="center"><img border="0" src="images/space.gif" width="20" height="3"></td></tr>
  <tr><td><img border="0" src="images/space.gif" width="20" height="20"></td></tr>
  <tr><td align="center">
    <p>Indtast dit brugernavn og kodeord, klik derefter på Log ind.
    <p><h6>(Please enter your Userid and Password and click at "Log ind".)
    <form name="form1" action="<%=application("Vroot")%>/include/_login.asp" method="POST">
    <table border="0" cellspacing="5" cellpadding="0">
 
      <tr>
        <td><img border="0" src="images/space.gif" width="100" height="10"></td>
        <td></td>
        <td><img border="0" src="images/space.gif" width="100" height="10"></td>
      </tr>
      <tr>
        <td align="right"><b>Brugernavn (Userid):</b></td>
        <td><input type="text" name="login" size="15"></td>
        <td></td>
      </tr>
      <tr>
        <td align="right"><b>Kodeord (Password):</b></td>
        <td><input type="password" name="password" size="15"></td>
        <td></td>
      </tr>
      <tr>
        <td></td>
  	<td align="center"><input type="submit" value="Log ind" name="LoginKnap" style="font-weight: bold; font-family: Verdana"></td>
        <td></td>
      </tr>
    </table><img border="0" src="images/space.gif" width="20" height="10">
    </FORM>
    <table border="0" cellspacing="0" cellpadding="0">
      <tr><td>Isuzu Danmark A/S, Baronessens Kvarter 5, 7000 Fredericia, Denmark, Telefon (phone): +45 3698 2556, mail <a href="mailto:info@isuzu.nu"><font color="#000000">info@isuzu.nu</font></a></td></tr>
	</table>
    </br></br>
	<tr><td align="center"><img border="0" src="images/isuzucar.png"></td></tr></td></tr>
</table>
</body>
</html>
