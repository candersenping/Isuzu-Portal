<%
strDSN = "Provider=SqlOledb;UID=kiaweb;PWD=stop4bud; Initial Catalog=KiaCOO; Data Source=172.20.16.24"
strDSNAX = "Provider=SqlOledb;UID=kiaweb;PWD=stop4bud; Initial Catalog=axdb30sp1kia; Data Source=172.20.16.24"

dataset = "KIT"

Session.Timeout=600

Function GetDbValue(DbTable, sField, SFieldVal, rField)
   Set sRecord = Server.CreateObject("ADODB.Recordset")  
   strSQL = "SELECT * FROM [" & DbTable & "] WHERE " & SFieldVal & " = " & SFieldVal  
   sRecord.Open strSQL, strDSN, adOpenStatic, adLockReadOnly, adCmdText
   GetDbValue = sRecord(rField)
   sRecord.Close
   Set sRecord = Nothing
End Function

function cleansqlstr(iString)
	cleansqlstr = replace(iString,"'","")
	cleansqlstr = replace(iString,Chr(34),"")
	cleansqlstr = replace(iString,";","")
	cleansqlstr = replace(iString,"'","")
	cleansqlstr = replace(iString,"\","")
	cleansqlstr = replace(iString,"/","")
	cleansqlstr = replace(iString,vbnull,"")
	cleansqlstr = replace(iString,vbcrlf,"")
end function

function formatValuta(CurVal)
	on error resume next
	formatValuta = replace(FormatCurrency(CurVal,2,-2,0,0),"kr", "")
	formatValuta = replace(formatValuta,"$", "")
	formatValuta = "Kr. " & formatValuta
end function 

Function FP_SaveFieldToDB(strField, strDBField)
	on error resume next
	Select Case webRegRecord(strDBField).Type
		Case adInteger Or adBigInt Or adUnsignedTinyInt Or adUnsignedSmallInt Or  adUnsignedInt Or adUnsignedBigInt
			webRegRecord(strDBField) = CInt(strField)
		Case adSingle Or adDecimal Or adNumeric 
			webRegRecord(strDBField) = CSng(strField)
		Case adDouble
			webRegRecord(strDBField) = CDbl(strField)
		Case adCurrency
			webRegRecord(strDBField) = CCur(strField)
		Case adBoolean
			webRegRecord(strDBField) = CBool(strField)
		Case adDate, adDBDate, adDBTime, adDBTimeStamp
			webRegRecord(strDBField) = CDate(strField)
		Case Else
			webRegRecord(strDBField) = CStr(Left(strField, webRegRecord(strDBField).DefinedSize))  
	End Select
End Function  
  
Const adOpenForwardOnly = 0
Const adOpenKeyset = 1
Const adOpenDynamic = 2
Const adOpenStatic = 3

'---- LockTypeEnum Values ----
Const adLockReadOnly = 1
Const adLockPessimistic = 2
Const adLockOptimistic = 3
Const adLockBatchOptimistic = 4

'---- CommandTypeEnum Values ----
Const adCmdUnknown = &H0008
Const adCmdText = &H0001
Const adCmdTable = &H0002
Const adCmdStoredProc = &H0004
Const adCmdFile = &H0100
Const adCmdTableDirect = &H0200

'---- DataTypeEnum Values ----
Const adEmpty = 0
Const adTinyInt = 16
Const adSmallInt = 2
Const adInteger = 3
Const adBigInt = 20
Const adUnsignedTinyInt = 17
Const adUnsignedSmallInt = 18
Const adUnsignedInt = 19
Const adUnsignedBigInt = 21
Const adSingle = 4
Const adDouble = 5
Const adCurrency = 6
Const adDecimal = 14
Const adNumeric = 131
Const adBoolean = 11
Const adError = 10
Const adUserDefined = 132
Const adVariant = 12
Const adIDispatch = 9
Const adIUnknown = 13
Const adGUID = 72
Const adDate = 7
Const adDBDate = 133
Const adDBTime = 134
Const adDBTimeStamp = 135
Const adBSTR = 8
Const adChar = 129
Const adVarChar = 200
Const adLongVarChar = 201
Const adWChar = 130
Const adVarWChar = 202
Const adLongVarWChar = 203
Const adBinary = 128
Const adVarBinary = 204
Const adLongVarBinary = 205
Const adChapter = 136
Const adFileTime = 64
Const adDBFileTime = 137
Const adPropVariant = 138
Const adVarNumeric = 139 
%>