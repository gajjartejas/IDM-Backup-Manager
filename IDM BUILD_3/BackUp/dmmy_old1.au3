#include <GUIConstantsEx.au3>
#include "_RegFunc.au3"


$R = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager\631" , "FileSize")
ConsoleWrite($R & "====x0x===" & @CRLF)

$Rn = Number($R)
ConsoleWrite($Rn & " BYTES" & @CRLF) ; RETURN BYTES

ConsoleWrite($Rn/1024 & " KB" & @CRLF) ; RETURN KB

ConsoleWrite($Rn/(1024*1024) & " MB" & @CRLF) ; RETURN MB

ConsoleWrite($Rn/(1024*1024*1024) & " GB" & @CRLF) ; RETURN GB

ConsoleWrite(_File_Size($Rn) & "----------" & @CRLF) ; RETURN GB

Func _File_Size($Rn)
If $Rn > 0 And $Rn <= 1024 Then
	Return $Rn & " BYTES"
ElseIf $Rn > 1024 And $Rn <= 1048576 Then
	Return $Rn/(1024) & " KB"
ElseIf $Rn > 1048576 And $Rn <= 1073741824 Then
	Return $Rn/(1048576) & " MB"
ElseIf $Rn > 1073741824 Then
	Return $Rn/(1073741824) & " GB"
EndIf
EndFunc

