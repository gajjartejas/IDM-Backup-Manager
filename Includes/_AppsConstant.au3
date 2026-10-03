#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#Region    ;************ Includes ************
#include-once
#include <Array.au3>
#include <WinAPIShellEx.au3>
#include "_RegFunc.au3"
#EndRegion    ;************ Includes ************

#Region Common
Global Const $s_regpath_IDM = "HKEY_CURRENT_USER\Software\DownloadManager"
Global Const $s_Current_Version = "1.1.0"
Global Const $IS_PORTABLE = True

; Application URLs & Endpoints
Global Const $s_URL_Website = "https://github.com/gajjartejas/IDM-Backup-Manager"
Global Const $s_URL_Issues = "https://github.com/gajjartejas/IDM-Backup-Manager/issues"
Global Const $s_URL_Releases = "https://github.com/gajjartejas/IDM-Backup-Manager/releases"
Global Const $s_URL_Update = "https://raw.githubusercontent.com/gajjartejas/IDM-Backup-Manager/main/version.txt"
Global Const $s_URL_Facebook = "https://www.facebook.com/gajjartejas26"
Global Const $s_URL_Twitter = "https://twitter.com/gajjartejas"
Global Const $s_URL_Instagram = "https://www.instagram.com/gajjartejas/"

#EndRegion Common

#Region Global Variables IDM BM
Global Const $s_Win_Title_BM = "IDM Backup Manager " & $s_Current_Version
Global Const $i_xWidth_BM = 439
Global Const $i_yHight_BM = 276
Global $i_xWinPos = (@DesktopWidth - $i_xWidth_BM) / 2
Global $i_yWinPos = (@DesktopHeight - $i_yHight_BM) / 2

Func _sGetHistoryFile()
	Local $ScriptDir = @ScriptDir
	If StringRight($ScriptDir, 1) <> "\" Then $ScriptDir &= "\"
	If FileExists($ScriptDir & "History.txt") Then Return $ScriptDir & "History.txt"
	If FileExists($ScriptDir & "history.txt") Then Return $ScriptDir & "history.txt"
	If FileExists($ScriptDir & "..\History.txt") Then Return $ScriptDir & "..\History.txt"
	Return $ScriptDir & "History.txt"
EndFunc

Func _sGetLicenseFile()
	Local $ScriptDir = @ScriptDir
	If StringRight($ScriptDir, 1) <> "\" Then $ScriptDir &= "\"
	If FileExists($ScriptDir & "LICENSE") Then Return $ScriptDir & "LICENSE"
	If FileExists($ScriptDir & "License.txt") Then Return $ScriptDir & "License.txt"
	If FileExists($ScriptDir & "..\LICENSE") Then Return $ScriptDir & "..\LICENSE"
	If FileExists($ScriptDir & "..\License.txt") Then Return $ScriptDir & "..\License.txt"
	Return $ScriptDir & "LICENSE"
EndFunc

Global Const $s_History_File = _sGetHistoryFile()
Global Const $s_License_File = _sGetLicenseFile()

Global Const $s_ini_File = @TempDir & "\" & "idm_guest_Setting.ini"
Global Const $s_reg_File = @TempDir & "\IDMregistry.reg"

Global $s_Setting_File = ""
Global $s_Log_File = ""
Global $s_Backup_Dir = ""

If ($IS_PORTABLE) Then
	$s_Setting_File = @ScriptDir & "\SettingFile.ini"
	$s_Log_File = @ScriptDir & "\LogFile.log"
	$s_Backup_Dir = @ScriptDir & "\IDM Backup Files\"
Else
	$s_Setting_File = @AppDataDir & "\IDM Backup Manager" & "\SettingFile.ini"
	$s_Log_File = @AppDataDir & "\IDM Backup Manager\LogFile.log"
	$s_Backup_Dir = @MyDocumentsDir & "\IDM Backup Files\"
EndIf

Global $b_AppendLog_File = 1
Global $b_RestartIDM = 0
Global $b_OpenFolder = 1

Global $s_AppDataIDMFolder = _sGetAppDataIDMFolder() ;contain back "\"
Global $s_TempPath = _sGetTempPathFolder() ;contain back "\"
Global $DwnlData_Folder = $s_TempPath & "DwnlData\"
Global $GrabberData_Folder = $s_TempPath & "GrabberData\"

Global $Grabber_Folder = $s_AppDataIDMFolder & "Grabber\"
Global $Scheduler_Folder = $s_AppDataIDMFolder & "Scheduler\"
Global $Sound_Folder = $s_AppDataIDMFolder & "Sounds\"

Global $UrlHistory_txt_File = $s_AppDataIDMFolder & "UrlHistory.txt"
Global $UrlHistory2_txt_File = $s_AppDataIDMFolder & "UrlHistory2.txt"
Global $GlobalErrors_log_File = $s_AppDataIDMFolder & "GlobalErrors.log"
Global $urlexclist_dat_File = $s_AppDataIDMFolder & "urlexclist.dat"
Global $defextmap_dat_File = $s_AppDataIDMFolder & "defextmap.dat"
Global $foldresHistory_txt_File = $s_AppDataIDMFolder & "foldresHistory.txt"
Global $sts_list_dat_File = $s_AppDataIDMFolder & "sts_list.dat"
Global $cnlurllist_dat_File = $s_AppDataIDMFolder & "cnlurllist.dat"

Global $h_Button_Browse_Backup, $h_Checkbox_Full_Backup, $h_Checkbox_Listl_Backup
Global $h_Checkbox_UnFinished_DD_Backup, $h_Checkbox_UnFinished_GD_Backup, $h_Checkbox_UnFinished_SD_Backup, $h_Button_Backup
Global $h_Input_Password_Backup, $h_Combo_Compression_Level_Backup, $h_Checkbox_UnFinished_HL_Backup, $h_Input_Backup_Path

Global $h_Button_Browse_Restore, $h_Checkbox_Convert_Registry_Restore, $h_Label_Convert_Registry_Restore
Global $h_Checkbox_UnFinished_DD_Restore, $h_Checkbox_UnFinished_GD_Restore, $h_Checkbox_UnFinished_SD_Restore, $h_Checkbox_UnFinished_HL_Restore
Global $h_Checkbox_Append_Registry_Restore, $h_Input_Password_Restore, $h_Label_Append_Registry_Restore, $h_Button_Restore, $h_Input_Restore_Path, $h_Button_Restore_Archive_Info
Global $h_Checkbox_Listl_Restore, $h_Checkbox_Full_Restore

Global $h_Button_List_Manager_Tools, $h_Button_Clean_Manager_Tools, $h_Button_Clean_Password_Tools, $h_Button_Cat_Tools,$h_Button_Make_Portable_Tools

;
Global $h_Button_BrowseLogFile_Setting, $h_Button_BrowseLogFile_Setting_Context, $h_Button_BrowseLogFile_Setting_Context0, $h_Button_BrowseLogFile_Setting_Context1

Global $h_Button_BrowseDataBackupFolder_Setting, $h_Button_BrowseDataBackupFolder_Setting_Context, $h_Button_BrowseDataBackupFolder_Setting_Context0, $h_Button_BrowseDataBackupFolder_Setting_Context1

Global $h_Button_BrowseAppDataFolder_Setting, $h_Button_BrowseAppDataFolder_Setting_Context, $h_Button_BrowseAppDataFolder_Setting_Context0, $h_Button_BrowseAppDataFolder_Setting_Context1

Global $h_Button_TempDataFolder_Setting,$h_Button_TempDataFolder_Setting_Context,$h_Button_TempDataFolder_Setting_Context0,$h_Button_TempDataFolder_Setting_Context1
;

Global $h_Button_Open_Log_Setting, $h_Button_Associate_Setting, $h_Button_More_Setting, $h_Button_RestoreDefault_Setting
Global $h_Label_LogFile_Setting, $h_Label_BrowseDataBackupFolder_Setting, $h_Label_BrowseAppDataFolder_Setting, $h_Label_DwnlDataFolder_Setting

Global $h_Button_Website_Help, $h_Button_Help_Help, $h_Button_Licence_Help, $h_Button_Version_History_Help, $h_Button_Forum_Help
Global $h_Button_Update_Help, $h_Picture_Facebook_About, $h_Picture_Twitter_About, $h_Picture_Instagram_About

Global $h_Tab1, $h_TabSheet1, $h_TabSheet2, $h_TabSheet3, $h_TabSheet4, $h_TabSheet5

Func _sGetStatusIcon($sIconName, $iFallbackIndex)
	Local $ScriptDir = @ScriptDir
	If StringRight($ScriptDir, 1) <> "\" Then $ScriptDir &= "\"
	Local $sPath = $ScriptDir & "Resources\" & $sIconName
	If Not FileExists($sPath) Then $sPath = $ScriptDir & "..\Resources\" & $sIconName
	If FileExists($sPath) Then
		Return _WinAPI_ShellExtractIcon($sPath, 0, 16, 16)
	ElseIf @Compiled Then
		Return _WinAPI_ShellExtractIcon(@ScriptFullPath, $iFallbackIndex, 16, 16)
	EndIf
	Return 0
EndFunc

Global $h_Status_Info
Global $hIcons_StatusInfo = _sGetStatusIcon("StatusInfo.ico", 19)
Global $hIcons_StatusWarning = _sGetStatusIcon("StatusWarning.ico", 20)
Global $hIcons_StatusCompled = _sGetStatusIcon("StatusCompled.ico", 21)
Global $hIcons_StatusError = _sGetStatusIcon("StatusError.ico", 22)
Global $hIcons_StatusWorking = _sGetStatusIcon("StatusWorking.ico", 23)

Global $nMsg
Global $hGUI_BM
Global $aData[15]
#EndRegion Global Variables IDM BM

#Region global Variables
Global $s_Win_Title_LM = "IDM List Manager " & $s_Current_Version & " (Beta)"
Global Enum $idExplore = 1000, $idJoin, $idDetails, $idRemove, $idGoto
Global $i_xWidth_LM = 570, $i_yHight_LM = 150
Global $hGUI_LM, $MenuItem_list_Catagories_[1], $fChange = False

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

Global $h_Status_Info_LM, $progress, $h_Progress

#EndRegion global Variables

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
	Else
		$TempPath = @AppDataDir & "\IDM\"
	EndIf

	Return $TempPath
EndFunc   ;==>_sGetTempPathFolder

Func _SwHelp()
	If FileExists(@ScriptDir & "\Help.chm") Then
		ShellExecute(@ScriptDir & "\Help.chm")
	ElseIf FileExists(@ScriptDir & "\..\Help\Help.docx") Then
		ShellExecute(@ScriptDir & "\..\Help\Help.docx")
	ElseIf FileExists(@ScriptDir & "\Help\Help.docx") Then
		ShellExecute(@ScriptDir & "\Help\Help.docx")
	Else
		ShellExecute($s_URL_Website & "#readme")
	EndIf
EndFunc   ;==>_SwHelp

;Return array containging extra past Dwnload Data(Root) Path if Exists
Func _aGetTempPathFolderEx()
	If Not _RegKeyExists($s_regpath_IDM) Then Return SetError(1, 0, 0)

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
;~ 			$tPath &= StringLeft($val, $sub + 7) & "|"
			$tPath &= StringLeft($val, $sub - 1) & "|"
		EndIf
	WEnd

	$tPath = StringTrimRight($tPath, 1)
	$aPath = StringSplit($tPath, "|", 3)
	If @error Then Return SetError(1, 0, 0)
	_ArraySort($aPath)

	For $i = 0 To UBound($aPath) - 2
		$sCheck = $aPath[$i]
		If FileExists($aPath[$i]) Then
			If StringRight($aPath[$i], 1) <> "\" Then $aPath[$i] &= "\"
			$tPath1 &= $aPath[$i] & "|"
		EndIf
;~ 		ConsoleWrite($aPath[$i] &"   <--"& @LF)

		If $sCheck = $aPath[$i + 1] Then
			While $sCheck = $aPath[$i + 1]
				If $i >= UBound($aPath) - 2 Then ExitLoop
				$i += 1
			WEnd
		EndIf
	Next
	$tPath1 = StringTrimRight($tPath1, 1)
	$aPath1 = StringSplit($tPath1, "|", 3)
	Return $aPath1
EndFunc   ;==>_aGetTempPathFolderEx
