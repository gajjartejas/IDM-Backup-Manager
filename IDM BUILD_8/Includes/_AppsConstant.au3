#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#region    ;************ Includes ************
#include-once
#include <Array.au3>
#include "_RegFunc.au3"
#endregion    ;************ Includes ************

#region Common
Global Const $s_regpath_IDM = "HKEY_CURRENT_USER\Software\DownloadManager"
Global Const $s_Current_Version = "0.9.8"
#endregion Common

#region Global Variables IDM BM
Global $hGUI_BM
Global $aData[14]

Global Const $s_Win_Title_BM = "IDM Backup Manager" & $s_Current_Version & "(Beta)"
Global Const $i_xWidth_BM = 439
Global Const $i_yHight_BM = 276
Global $i_xWinPos = (@DesktopWidth - $i_xWidth_BM) / 2
Global $i_yWinPos = (@DesktopHeight - $i_yHight_BM) / 2

Global Const $s_History_File = @ScriptDir & "\history.txt"
Global Const $s_License_File = @ScriptDir & "\License.txt"

Global Const $s_ini_File = @TempDir & "\" & "idm_guest_Setting.ini"
Global Const $s_reg_File = @TempDir & "\IDMregistry.reg"

;~ Global Const $s_Setting_File = @ScriptDir & "\SettingFile.ini" ;for portable
;~ Global $s_Log_File = @ScriptDir & "\LogFile.log" ;for portable
Global Const $s_Setting_File = @AppDataDir & "\IDM Backup Manager" & "\SettingFile.ini" ;for installer
Global $s_Log_File = @AppDataDir & "\IDM Backup Manager" & "\LogFile.log" ;for installer
Global $s_Backup_Dir = @MyDocumentsDir & "\IDM Backup Files\"

Global $b_AppendLog_File = 1
Global $b_RestartIDM = 0
Global $b_OpenFolder = 1

Global $s_AppDataIDMFolder = _sGetAppDataIDMFolder() ;contain back "\"
Global $s_DwnlData_Folder = _sGetTempPathFolder() ;contain back "\"
Global $s_DwnlData_Folder_ = _sPath_Last_Remove($s_DwnlData_Folder) ;contain back "\"
Global $Grabber_Folder = $s_AppDataIDMFolder & "Grabber\"
Global $GrabberData_Folder = $s_AppDataIDMFolder & "GrabberData\"
Global $Scheduler_Folder = $s_AppDataIDMFolder & "Scheduler\"

Global $UrlHistory_txt_File = $s_AppDataIDMFolder & "UrlHistory.txt"
Global $UrlHistory2_txt_File = $s_AppDataIDMFolder & "UrlHistory2.txt"
Global $GlobalErrors_log_File = $s_AppDataIDMFolder & "GlobalErrors.log"
Global $urlexclist_dat_File = $s_AppDataIDMFolder & "urlexclist.dat"
Global $defextmap_dat_File = $s_AppDataIDMFolder & "defextmap.dat"
Global $foldresHistory_txt_File = $s_AppDataIDMFolder & "foldresHistory.txt"
Global $sts_list_dat_File = $s_AppDataIDMFolder & "sts_list.dat"
Global $cnlurllist_dat_File = $s_AppDataIDMFolder & "cnlurllist.dat"

Global $h_Button_Browse_Backup, $h_Checkbox_Password_Backup, $h_Checkbox_Compression_Level_Backup, $h_Checkbox_Full_Backup, $h_Checkbox_Listl_Backup
Global $h_Checkbox_UnFinished_DD_Backup, $h_Checkbox_UnFinished_GD_Backup, $h_Checkbox_UnFinished_SD_Backup, $h_Button_Backup
Global $h_Input_Password_Backup, $h_Combo_Compression_Level_Backup, $h_Checkbox_UnFinished_HL_Backup, $h_Input_Backup_Path

Global $h_Button_Browse_Restore, $h_Checkbox_Password_Restore, $h_Checkbox_Convert_Registry_Restore, $h_Label_Convert_Registry_Restore
Global $h_Checkbox_UnFinished_DD_Restore, $h_Checkbox_UnFinished_GD_Restore, $h_Checkbox_UnFinished_SD_Restore, $h_Checkbox_UnFinished_HL_Restore
Global $h_Checkbox_Append_Registry_Restore, $h_Input_Password_Restore, $h_Label_Append_Registry_Restore, $h_Button_Restore, $h_Input_Restore_Path
Global $h_Checkbox_Listl_Restore, $h_Checkbox_Full_Restore

Global $h_Button_List_Manager_Tools, $h_Button_Clean_Manager_Tools, $h_Button_Clean_Password_Tools, $h_Button_Cat_Tools

Global $h_Button_BrowseLogFile_Setting, $h_Button_BrowseDataBackupFolder_Setting, $h_Button_BrowseAppDataFolder_Setting, $h_Button_DwnlDataFolder_Setting
Global $h_Button_Open_Log_Setting, $h_Button_Associate_Setting, $h_Button_More_Setting, $h_Button_RestoreDefault_Setting
Global $h_Label_LogFile_Setting, $h_Label_BrowseDataBackupFolder_Setting, $h_Label_BrowseAppDataFolder_Setting, $h_Label_DwnlDataFolder_Setting

Global $h_Button_Website_Help, $h_Button_Help_Help, $h_Button_Licence_Help, $h_Button_Version_History_Help, $h_Button_Forum_Help
Global $h_Button_Update_Help

Global $h_Tab1, $h_TabSheet1, $h_TabSheet2, $h_TabSheet3, $h_TabSheet4, $h_TabSheet5, $h_Status_Info

Global $nMsg
#endregion Global Variables IDM BM

#region global Variables
Global $s_Win_Title_LM = "IDM List Manager" & $s_Current_Version & "(Beta)"
Global Enum $idExplore = 1000, $idJoin, $idDetails, $idRemove, $idGoto
Global $i_xWidth_LM = 570, $i_yHight_LM = 153
Global $hGUI_LM, $MenuItem_list_Catagories_[_iCountKey($s_regpath_IDM) + 1], $fChange = False

Global $MenuItem_File, $MenuItem_File_Analyze, $MenuItem_File_Selected, $MenuItem_File_Selected_ExploreFolder, $MenuItem_File_Selected_ForceJoin
Global $MenuItem_File_Selected_Remove, $MenuItem_File_Selected_Goto, $MenuItem_File_Selected_Properties, $MenuItem_File_Split, $MenuItem_File_Exit

Global $MenuItem_Edit, $MenuItem_Edit_Remove, $MenuItem_Edit_Remove_All, $MenuItem_Edit_Find

Global $MenuItem_Tools, $MenuItem_Tools_Expert, $MenuItem__Tools_Expert_asIDM, $MenuItem_Tools_Expert_asText, $MenuItem__Tools_Expert_asHTML
Global $MenuItem__Tools_Expert_asCSV

Global $MenuItem_View, $MenuItem_list, $MenuItem_View_List_AllDownloads, $MenuItem_View_List_FinishedDownloads, $MenuItem_View_List_UnFinished
Global $MenuItem_View_List_UnFinished_Data, $MenuItem_View_Categories_list_all, $MenuItem_View_Categories_list_CatArray, $i_Cat_Item
Global $MenuItem_View_SwGrid, $MenuItem_View_AutoArrange

Global $MenuItem_Help, $MenuItem_Help_h

Global $idListView, $hListView

Global $h_Status_Info_LM

#endregion global Variables

Func _sGetAppDataIDMFolder()

	Local $AppDataIDMFolder = RegRead($s_regpath_IDM, "AppDataIDMFolder")

	If Not FileExists($AppDataIDMFolder) Then $AppDataIDMFolder = @AppDataDir & "\" & "IDM" & "\"

	If StringRight($AppDataIDMFolder, 1) <> "\" Then $AppDataIDMFolder &= "\"

	Return $AppDataIDMFolder
EndFunc   ;==>_sGetAppDataIDMFolder

Func _sGetTempPathFolder()

	Local $TempPath = RegRead($s_regpath_IDM, "TempPath")

	If FileExists($TempPath) Then
		If StringRight($TempPath, 1) <> "\" Then $TempPath &= "\"
		$TempPath &= "DwnlData\"
	Else
		$TempPath = @AppDataDir & "\" & "IDM" & "\" & "DwnlData\"
	EndIf

	Return $TempPath
EndFunc   ;==>_sGetTempPathFolder

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

Func _SwHelp()
	If FileExists(@ScriptDir & "\Help.chm") Then
		ShellExecute(@ScriptDir & "\Help.chm")
	Else
		ShellExecute("http://gajjartejas26.blogspot.com/p/idm-backup-manager.html")
	EndIf
EndFunc   ;==>_SwHelp

;Return array containging extra past Dwnload Data Path if Exists
Func _aGetTempPathFolderEx()
	Local $i = 1
	Local $tPath, $val, $tPath1, $aPath1, $var, $sub, $aPath, $sCheck
	While 1
		$var = RegEnumKey($s_regpath_IDM, $i)
		If @error Then ExitLoop
		$i += 1

		$val = RegRead($s_regpath_IDM & "\" & $var, "LocalPath")
		If @error Then ContinueLoop

		$sub = StringInStr($val, "DwnlData", 0, -1)
		If $sub Then
			$tPath &= StringLeft($val, $sub + 7) & "|"
		EndIf
	WEnd

	$tPath = StringTrimRight($tPath, 1)
	$aPath = StringSplit($tPath, "|", 2)
	_ArraySort($aPath)

	For $i = 0 To UBound($aPath) - 2
		$sCheck = $aPath[$i]
		If FileExists($aPath[$i]) Then $tPath1 &= $aPath[$i] & "|"

		If $sCheck = $aPath[$i + 1] Then
			While $sCheck = $aPath[$i + 1]
				If $i >= UBound($aPath) - 2 Then ExitLoop
				$i += 1
			WEnd
		EndIf
	Next
	$aPath1 = StringSplit($tPath1, "|", 3)
	Return $aPath1
EndFunc   ;==>_aGetTempPathFolderEx
