#region ;/backup registry--->
$Backup_reg_temp_path = @TempDir & "\" & "IDMregistry"
If FileExists($Backup_reg_temp_path) Then
	If Not DirRemove($Backup_reg_temp_path) Then FileWriteLine($s_Log_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $Backup_reg_temp_path & '" ' & "Error Code:" & @error)
EndIf
$k = 1
If Not FileExists($Backup_reg_temp_path) Then DirCreate($Backup_reg_temp_path)
While 1
	$var = RegEnumKey($s_regpath_IDM, $k)
	If @error <> 0 Then ExitLoop
	_regbackup($Backup_reg_temp_path & "\" & $k & ".reg", $s_regpath_IDM & "\" & $var)
	$file_join3 = FileRead($Backup_reg_temp_path & "\" & $k & ".reg") & @CRLF
	FileWrite($s_reg_File, $file_join3)
	FileDelete($Backup_reg_temp_path & "\" & $k & ".reg")
	GUICtrlSetData($h_Label_Info, "Backing up Registry Key: " & $k & "  Please Wait...")
	$k += 1
WEnd
FileWriteLine($s_Log_File, _Current_Moment() & "Registry Backup Successful Total Key = " & '"' & $k & '"')

If FileExists($Backup_reg_temp_path) Then
	If Not DirRemove($Backup_reg_temp_path, 1) Then FileWriteLine($s_Log_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $Backup_reg_temp_path & '" ' & "Error Code:1")
EndIf
#endregion ;/backup registry--->

#region ;/Check registry and cont..--->
If $k = 1 Then
	GUICtrlSetData($h_Label_Info, "Error: Registry Entry Is Empty. Nothing To Backup")
	FileWriteLine($s_Log_File, _Current_Moment() & "Error : Registry Entry Is Empty. Nothing To Backup !")
	_control_update_default()
	ContinueLoop
EndIf
#endregion ;/Check registry and cont..--->

Func _7Zip_Test($sZipFile, $sPassword)
	If FileExists($sZipFile) = 0 Then
		Return SetError(4, 0, 0)
	EndIf

	$sPassword = "-p" & '"' & $sPassword & '" '

	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Command Line: " & $s_7zexe_Path & ' t "' & $sZipFile & '" ' & $sPassword)
	Return RunWait($s_7zexe_Path & ' t "' & $sZipFile & '" ' & $sPassword, "", @SW_HIDE)
EndFunc   ;==>_7Zip_Test

Func _7Zip_Extract($sZipFile, $sDestinationFolder, $sPassword = "")
	If FileExists($sZipFile) = 0 Then
		Return SetError(4, 0, 0)
	EndIf
	If _IsDir($sDestinationFolder) = 1 And StringRight($sDestinationFolder, 1) <> "\" Then
		$sDestinationFolder &= "\"
	EndIf
	If FileExists($sDestinationFolder) = 0 Then
		DirCreate($sDestinationFolder)
	EndIf
	If $sPassword <> "" Then
		$sPassword = "-p" & '"' & $sPassword & '" '
	EndIf
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Command Line: " & $s_7zexe_Path & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"')
	Return RunWait($s_7zexe_Path & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"', "", @SW_HIDE)
EndFunc   ;==>_7Zip_Extract

; #FUNCTION# ====================================================================================================================
; Name...........:  _7Zip_Add
; Description....:  Add a folder to 7z file
; Syntax.........:  _7Zip_Add($sZipFile, $sDestinationFolder, $sCompression, $sPassword)
; Parameters.....:  $sZipFile - "c:\dir1\dir2\name.7z"
;					$sDestinationFolder - "c:\dir1\dir2\"
;					$sCompression   - "1-Store/None"
;									- "2-Fastest"
;									- "3-Fast"
;									- "4-Normal"
;									- "5-Maximum"
;									- "6-Ultra"
;					$sPassword - "any password
; Return values..: Success - 1.
;				   Failure - 0 and sets the @error flag to non-zero.
; Author.........: Gajjar Tejas
; Modified.......:
; Remarks........: This Function adds all files and subfolders from folder subdir to archive $s7z_File_Save_Name ="c:\dir1\dir2\name.7z". The filenames in archive will not contain subdir\ prefix.
; Related........:
; Link...........:
; Example........: _7Zip_Add("C:\Users\Tejas\Desktop\New folder (2)\Name.7z", "C:\Users\Tejas\Desktop\New folder (2)", "1-Store/None", "11")
Func _7Zip_Add($s7z_File_Save_Name, $sDestinationFolder, $sCompression, $sPassword)
	If FileExists($sDestinationFolder) = 0 Then
		Return SetError(3, 0, 0)
	EndIf
	If _IsDir($sDestinationFolder) = 1 And StringRight($sDestinationFolder, 1) <> "\" Then
		$sDestinationFolder &= "\"
	EndIf
	If $sPassword <> "" Then
		$sPassword = "-p" & '"' & $sPassword & '" '
	EndIf
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
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Command Line: " & $s_7zexe_Path & " " & "a" & " " & '"' & $s7z_File_Save_Name & '"' & $sCompression & " " & $sPassword & '"' & $sDestinationFolder & '"')
	Return RunWait($s_7zexe_Path & " " & "a" & " " & '"' & $s7z_File_Save_Name & '"' & $sCompression & " " & $sPassword & '"' & $sDestinationFolder & '"', "", @SW_HIDE)
EndFunc   ;==>_7Zip_Add