#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

; Return handle of given PID
Func _ProcessGetHandle($iPID)
	Local Const $PROCESS_QUERY_INFORMATION = 0x0400
	Local $avRET = DllCall("kernel32.dll", "ptr", "OpenProcess", "int", $PROCESS_QUERY_INFORMATION, "int", 0, "int", $iPID)
	If @error Then
		Return SetError(1, 0, 0)
	Else
		Return $avRET[0]
	EndIf
EndFunc   ;==>_ProcessGetHandle

; Close process handle
Func _ProcessCloseHandle($hProc)
	Local $avRET = DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hProc)
	If @error Then
		Return SetError(1, 0, 0)
	Else
		Return 1
	EndIf
EndFunc   ;==>_ProcessCloseHandle

; Get process exit code from handle
Func _ProcessGetExitCode($hProc)
	Local $t_ExitCode = DllStructCreate("int")
	Local $avRET = DllCall("kernel32.dll", "int", "GetExitCodeProcess", "ptr", $hProc, "ptr", DllStructGetPtr($t_ExitCode))
	If @error Then
		Return SetError(1, 0, 0)
	Else
		Return DllStructGetData($t_ExitCode, 1)
	EndIf
EndFunc   ;==>_ProcessGetExitCode