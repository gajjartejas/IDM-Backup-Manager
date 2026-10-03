#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#Region    ;************ Includes ************
#include-once
#include <String.au3>
#EndRegion    ;************ Includes ************

; #VARIABLES# ===================================================================================================================

Global $7zDll = _7ZipGetDll()

#Au3Stripper_Off
Global Const $FNAME_MAX32 = 512
Global $hArchiveProc
Global $hDLL_7ZIP = 0

Global Const $tagEXTRACTINGINFO = "int dwFileSize;int dwWriteSize;char szSourceFileName[" & $FNAME_MAX32 + 1 & "];" & _
		"char dummy1[3];char szDestFileName[" & $FNAME_MAX32 + 1 & "];char dummy[3]"

Global Const $tagEXTRACTINGINFOEX = $tagEXTRACTINGINFO & ";dword dwCompressedSize;dword dwCRC;uint uOSType;short wRatio;" & _
		"short wDate;short wTime;char szAttribute[8];char szMode[8]"
#Au3Stripper_On

; #STRUCTURES# ==================================================================================================================
;~ Global $tagINDIVIDUALINFO = "int dwOriginalSize;int dwCompressedSize;int dwCRC;uint uFlag;uint uOSType;short wRatio;" & _
;~ 		"short wDate;short wTime;char szFileName[" & $FNAME_MAX32 + 1 & "];char dummy1[3];" & _
;~ 		"char szAttribute[8];char szMode[8]"

Func _7ZipStartup()
	$hDLL_7ZIP = DllOpen($7zDll) ; Open x32 dll from no compiled path

	If $hDLL_7ZIP = -1 Then Return SetError(1, 0, 0) ; If no dll handle, return error
	Return 1
EndFunc   ;==>_7ZipStartup

Func _7ZipShutdown()
	DllClose($hDLL_7ZIP)
	If $hArchiveProc Then DllCallbackFree($hArchiveProc)
	$hDLL_7ZIP = 0 ; Release var
	$hArchiveProc = "" ; Release var
	Return 1
EndFunc   ;==>_7ZipShutdown

Func _7ZipAdd($hWnd, $s7z_File_Save_Name, $aDestinationFolders, $sCompression, $sPassword)

	Local $iFlagDll = _7ZipControlStartup()
	If $iFlagDll = 0 Then Return SetError(2, 0, 0)

	If $sPassword <> "" Then
		$sPassword = " -p" & '"' & $sPassword & '" '
	EndIf

	Local $tDATA = ""

	For $i = 0 To UBound($aDestinationFolders) - 1
		If $aDestinationFolders[$i] = "" Then ContinueLoop

		If _IsDir($aDestinationFolders[$i]) Then
			$aDestinationFolders[$i] = _StringInsert($aDestinationFolders[$i], " -i!" & '"', -StringLen($aDestinationFolders[$i])) & '"'
		Else
			$aDestinationFolders[$i] = _StringInsert($aDestinationFolders[$i], " " & '"', -StringLen($aDestinationFolders[$i])) & '"'
		EndIf

		$tDATA &= $aDestinationFolders[$i]
	Next

	If $tDATA = "" Then Return 0

	If $sCompression <> "" Then
		Switch $sCompression
			Case "1-No Compression"
				$sCompression = " -mx0"
			Case "2-Fastest Compression"
				$sCompression = " -mx1"
			Case "3-Fast Compression"
				$sCompression = " -mx3"
			Case "4-Normal Compression"
				$sCompression = " -mx5"
			Case "5-Maximum Compression"
				$sCompression = " -mx7"
			Case "6-Ultra Compression"
				$sCompression = " -mx9"
		EndSwitch
	EndIf

	Local $sCMD = " a" & " " & '"' & $s7z_File_Save_Name & '"' & $sCompression & $sPassword & $tDATA & " -hide"

	Local $tOutBuffer = DllStructCreate("char[32768]")

	Local $aRet = DllCall($hDLL_7ZIP, "int", "SevenZip", _
			"hwnd", $hWnd, _
			"str", $sCMD, _
			"ptr", DllStructGetPtr($tOutBuffer), _
			"int", DllStructGetSize($tOutBuffer))

	If $iFlagDll = 2 Then _7ZipShutdown()
	If Not $aRet[0] Then Return SetError(0, 0, DllStructGetData($tOutBuffer, 1))
	Return SetError(0, 0, DllStructGetData($tOutBuffer, 1))
EndFunc   ;==>_7ZipAdd

Func _7ZipExtractEx($hWnd, $sZipFile, $sDestinationFolder, $aFile_To_Extracr, $sPassword)

	Local $iFlagDll = _7ZipControlStartup()
	If $iFlagDll = 0 Then Return SetError(2, 0, 0)

	If FileExists($sZipFile) = 0 Then
		Return SetError(4, 0, 0)
	EndIf

	If FileExists($sDestinationFolder) = 0 Then
		DirCreate($sDestinationFolder)
	EndIf

	Local $tDATA = ""

	For $i = 0 To UBound($aFile_To_Extracr) - 1
		If $aFile_To_Extracr[$i] = "" Then ContinueLoop

		$aFile_To_Extracr[$i] = _StringInsert($aFile_To_Extracr[$i], " -ir!" & '"', -StringLen($aFile_To_Extracr[$i])) & '"'
		$tDATA &= $aFile_To_Extracr[$i]
	Next

	If $tDATA = "" Then Return 0

	$sPassword = "-p" & '"' & $sPassword & '" '

	Local $sCMD = ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"' & " " & $tDATA & " -hide"

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sCMD = ' & $sCMD & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	Local $tOutBuffer = DllStructCreate("char[32768]")


	Local $aRet = DllCall($hDLL_7ZIP, "int", "SevenZip", _
			"hwnd", $hWnd, _
			"str", $sCMD, _
			"ptr", DllStructGetPtr($tOutBuffer), _
			"int", DllStructGetSize($tOutBuffer))

	If $iFlagDll = 2 Then _7ZipShutdown()
	If Not $aRet[0] Then Return SetError(0, 0, DllStructGetData($tOutBuffer, 1))
	Return SetError(0, 0, DllStructGetData($tOutBuffer, 1))
EndFunc   ;==>_7ZipExtractEx

Func _7ZipSetOwnerWindowEx($hWnd, $sProcFunc)
	If $hDLL_7ZIP <= 0 Then Return SetError(2, 0, 0)
	If $hArchiveProc Then DllCallbackFree($hArchiveProc)
	$hArchiveProc = DllCallbackRegister($sProcFunc, "int", "hwnd;uint;uint;ptr")
	If $hArchiveProc = 0 Then Return SetError(1, 0, 0)

	Local $aRet = DllCall($hDLL_7ZIP, "int", "SevenZipSetOwnerWindowEx", _
			"hwnd", $hWnd, _
			"ptr", DllCallbackGetPtr($hArchiveProc))
	Return $aRet[0]
EndFunc   ;==>_7ZipSetOwnerWindowEx

; #FUNCTIONS FOR INTERNAL USE# ==================================================================================================
; This function control if dll is opened and return a flag for autoclosing.
Func _7ZipControlStartup()
	If $hDLL_7ZIP <= 0 Then ; The dll not opened by _7ZipStartup()
		If _7ZipStartup() Then
			Return 2 ; dll opened by this fuction
		Else
			Return 0 ; Error on opening dll
		EndIf
	EndIf
	Return 1 ; The dll was already opened
EndFunc   ;==>_7ZipControlStartup

Func _7ZipCheckDll()
	If Not FileExists($7zDll) Then Return SetError(1, 0, $7zDll)
EndFunc   ;==>_7ZipCheckDll

Func _7ZipGetDll()
	Local $ScriptDir = @ScriptDir
	If StringRight($ScriptDir, 1) <> "\" Then $ScriptDir &= "\"

	Local $sDllName = "7-zip32.dll"
	If @OSArch = "X64" And @AutoItX64 Then
		$sDllName = "7-zip64.dll"
	EndIf

	If FileExists($ScriptDir & $sDllName) Then
		$7zDll = $ScriptDir & $sDllName
	ElseIf FileExists($ScriptDir & "bin\" & $sDllName) Then
		$7zDll = $ScriptDir & "bin\" & $sDllName
	Else
		$7zDll = $ScriptDir & $sDllName
	EndIf
	Return $7zDll
EndFunc   ;==>_7ZipGetDll
