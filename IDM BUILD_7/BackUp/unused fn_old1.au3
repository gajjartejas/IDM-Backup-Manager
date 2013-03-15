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

			;~ Func _7Zip_Test($sZipFile, $sPassword)
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