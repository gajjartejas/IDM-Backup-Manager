#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#Region    ;************ Includes ************
#include-once
#include <File.au3>
#EndRegion    ;************ Includes ************

#Region Misc Functions(App Indepedent For IDMBM)
Func _iGetFileSize($aFiles)
	Local $i, $iSize = 0

	For $i = 0 To UBound($aFiles) - 1
		If Not FileExists($aFiles[$i]) Then ContinueLoop
		If _IsDir($aFiles[$i]) Then
			$iSize += DirGetSize($aFiles[$i])
		Else
			$iSize += FileGetSize($aFiles[$i])
		EndIf
	Next
	Return $iSize
EndFunc   ;==>_iGetFileSize

Func _sDriveGetFromPath($path)
	Local $szDrive, $szDir, $szFName, $szExt
	Local $TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[1]
EndFunc   ;==>_sDriveGetFromPath

;Get Filesize Conversion
Func _sGetFileSizeConv($iBytes)
	Local $iIndex = 0, $aArray = [' bytes', ' KB', ' MB', ' GB', ' TB', ' PB', ' EB', ' ZB', ' YB']
	While $iBytes > 1023
		$iIndex += 1
		$iBytes /= 1024
	WEnd
	Return Round($iBytes) & $aArray[$iIndex]
EndFunc   ;==>_sGetFileSizeConv


Func _IsDir($sFilePath)
	Return Number(FileExists($sFilePath) And StringInStr(FileGetAttrib($sFilePath), "D", 2, 1) > 0)
EndFunc   ;==>_IsDir

Func _Current_Moment()
	Return @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & " --> "
EndFunc   ;==>_Current_Moment

Func _iFileOrFolderRemove($aFiles)
	Local $i, $sFileLocked

	For $i = 0 To UBound($aFiles) - 1
		If ($aFiles[$i] = "") Or (Not FileExists($aFiles[$i])) Then ContinueLoop

		If _IsDir($aFiles[$i]) Then
			If Not DirRemove($aFiles[$i], 1) Then $sFileLocked &= $aFiles[$i] & @CRLF
		Else
			FileSetAttrib($aFiles[$i], "-R+A")
			If Not FileDelete($aFiles[$i]) Then $sFileLocked &= $aFiles[$i] & @CRLF
		EndIf
	Next
	Return $sFileLocked
EndFunc   ;==>_iFileOrFolderRemove

Func _IsInternetConnectedEx() ; Returns 1 = ON or 0 = OFF
	Local $is_Return = DllCall("wininet.dll", "int", "InternetGetConnectedState", "int", 0, "int", 0)
	If (@error) Or ($is_Return[0] = 0) Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_IsInternetConnectedEx

Func _SelectFile($filename) ;Select file in Explorer
	If FileExists($filename) Then Run("explorer /select, " & '"' & $filename & '"')
EndFunc   ;==>_SelectFile

Func _sPath_Last_Remove($sPath)
	Local $s_Saved_Path = ""

	If StringRight($sPath, 1) <> "\" Then $sPath &= "\"

	Local $split_path = StringSplit($sPath, "\")

	If @error = 1 Then
		Return $sPath
	ElseIf $split_path[0] = 2 Then
		Return $sPath
	Else
		For $i = 1 To $split_path[0] - 2 Step 1
			$s_Saved_Path &= $split_path[$i] & "\"
		Next
		Return $s_Saved_Path
	EndIf
EndFunc   ;==>_sPath_Last_Remove
#EndRegion Misc Functions(App Indepedent For IDMBM)

#Region Misc Functions(App Indepedent For IDMLM)
Func _CountKey($sRegpath)
	Local $k = 1
	While 1
		RegEnumKey($sRegpath, $k)
		If @error <> 0 Then ExitLoop
		$k += 1
	WEnd
	Return $k - 1
EndFunc   ;==>_CountKey

Func _Resize_Text($text)
	Return "Goto " & StringLeft($text, 20) & "...."
EndFunc   ;==>_Resize_Text

Func _Drive_Get_From_Path($path)
	Local $szDrive, $szDir, $szFName, $szExt
	Local $TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[1]
EndFunc   ;==>_Drive_Get_From_Path

Func _Ext_Get_From_Path($path)
	Local $szDrive, $szDir, $szFName, $szExt
	Local $TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[4]
EndFunc   ;==>_Ext_Get_From_Path

Func _Name_Get_From_Path($path)
	Local $szDrive, $szDir, $szFName, $szExt
	Local $TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[3]
EndFunc   ;==>_Name_Get_From_Path

#EndRegion Misc Functions(App Indepedent For IDMLM)
