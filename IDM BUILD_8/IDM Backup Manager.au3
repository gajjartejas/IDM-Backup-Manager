#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=idmbm.exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_After=Utilities\ResHacker.exe -delete "%out%", "%out%", Dialog, 1000,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker.exe -delete "%out%", "%out%", Icon, 99,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker.exe -delete "%out%", "%out%", Icon, 162,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker.exe -delete "%out%", "%out%", Icon, 164,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker.exe -delete "%out%", "%out%", Icon, 169,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker.exe -delete "%out%", "%out%", Menu, 166,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker.exe -delete "%out%", "%out%", VersionInfo, 1,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker.exe -delete "%out%", "%out%", 24, 1,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker.exe -add "%out%", "%out%", Resources\idmbm.res,,,
#AutoIt3Wrapper_Run_After=del "IDM Backup Manager_Obfuscated.au3"
#AutoIt3Wrapper_Run_After=del Utilities\ResHacker.ini
#AutoIt3Wrapper_Run_After=del Utilities\ResHacker.log
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#AutoIt3Wrapper_Versioning=v
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#region Includes
#region    ;************ Includes ************
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include "Includes\_AET_ButtonSetIcon.au3"
#include "Includes\_Resources.au3"
#include "Includes\_IsFilePathValid.au3"
#include "Includes\_RunWithReducedPrivileges.au3"
#include "Includes\_ShellFile_Install.au3"
#include "Includes\_7Zip.au3"
#include "Includes\_ProgressMarquee.au3"
#include "Includes\_IDM List Manager.au3"
#endregion    ;************ Includes ************
#endregion Includes

_StartupBM()

#region Main
Func _MainBM()
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg

			Case $GUI_EVENT_CLOSE
				_onExit()

			Case $h_Checkbox_Password_Backup
				If GUICtrlRead($h_Checkbox_Password_Backup) = $GUI_CHECKED Then
					GUICtrlSetState($h_Input_Password_Backup, $GUI_ENABLE)
					GUICtrlSetData($h_Input_Password_Backup, "")
				Else
					GUICtrlSetState($h_Input_Password_Backup, $GUI_DISABLE)
					GUICtrlSetData($h_Input_Password_Backup, "password")
				EndIf

			Case $h_Checkbox_Password_Restore
				If GUICtrlRead($h_Checkbox_Password_Restore) = $GUI_CHECKED Then
					GUICtrlSetState($h_Input_Password_Restore, $GUI_ENABLE)
					GUICtrlSetData($h_Input_Password_Restore, "")
				Else
					GUICtrlSetState($h_Input_Password_Restore, $GUI_DISABLE)
					GUICtrlSetData($h_Input_Password_Restore, "password")
				EndIf

			Case $h_Checkbox_Compression_Level_Backup
				If GUICtrlRead($h_Checkbox_Compression_Level_Backup) = $GUI_CHECKED Then
					GUICtrlSetState($h_Combo_Compression_Level_Backup, $GUI_ENABLE)
					GUICtrlSetData($h_Combo_Compression_Level_Backup, "4-Normal Compression")
				Else
					GUICtrlSetState($h_Combo_Compression_Level_Backup, $GUI_DISABLE)
					GUICtrlSetData($h_Combo_Compression_Level_Backup, "1-No Compression")
				EndIf

			Case $h_Checkbox_Convert_Registry_Restore
				If GUICtrlRead($h_Checkbox_Convert_Registry_Restore) = $GUI_CHECKED Then
					GUICtrlSetState($h_Label_Convert_Registry_Restore, $GUI_ENABLE)
					GUICtrlSetData($h_Label_Convert_Registry_Restore, "Convert Profile(Enabled)")
				Else
					GUICtrlSetState($h_Label_Convert_Registry_Restore, $GUI_DISABLE)
					GUICtrlSetData($h_Label_Convert_Registry_Restore, "Convert Profile(Disabled)")
				EndIf

			Case $h_Checkbox_Append_Registry_Restore
				If GUICtrlRead($h_Checkbox_Append_Registry_Restore) = $GUI_CHECKED Then
					GUICtrlSetState($h_Label_Append_Registry_Restore, $GUI_ENABLE)
					GUICtrlSetData($h_Label_Append_Registry_Restore, "Append/Merge(Enabled)")
				Else
					GUICtrlSetState($h_Label_Append_Registry_Restore, $GUI_DISABLE)
					GUICtrlSetData($h_Label_Append_Registry_Restore, "Append/Merge(Disabled)")
				EndIf

			Case $h_Checkbox_Full_Backup
				If GUICtrlRead($h_Checkbox_Full_Backup) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Backup Every Thing")

					GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
				Else
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
					GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
				EndIf

			Case $h_Checkbox_Listl_Backup
				If GUICtrlRead($h_Checkbox_Listl_Backup) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Backup List of Downloads Without Backing Up Data")
					GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
				Else
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
					GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
				EndIf

			Case $h_Checkbox_UnFinished_SD_Backup
				If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Backup Scheduler and Queues")
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
				Else
					If GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_CHECKED Then
						GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
						GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
					Else
						_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
						GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
						GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
					EndIf
				EndIf

			Case $h_Checkbox_UnFinished_GD_Backup
				If GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Backup Grabber Data")
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
				Else
					If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_CHECKED Then
						GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
						GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
					Else
						_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
						GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
						GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
					EndIf
				EndIf

			Case $h_Checkbox_UnFinished_DD_Backup
				If GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Backup Downloaded Data")
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
				Else
					If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_CHECKED Then
						GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
						GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
					Else
						_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
						GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
						GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
					EndIf
				EndIf

			Case $h_Checkbox_UnFinished_HL_Backup
				If GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Backup History, Logs and Sound")
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
				Else
					If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_CHECKED Or $h_Checkbox_UnFinished_DD_Backup = $GUI_CHECKED Then
						GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
						GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
					Else
						_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
						GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
						GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
					EndIf
				EndIf

			Case $h_Checkbox_Full_Restore
				If GUICtrlRead($h_Checkbox_Full_Restore) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Full Restore Selected")
					GUICtrlSetState($h_Checkbox_UnFinished_DD_Restore, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_GD_Restore, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_SD_Restore, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_HL_Restore, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_DISABLE)
				Else
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
					GUICtrlSetState($h_Checkbox_UnFinished_DD_Restore, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_GD_Restore, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_SD_Restore, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_HL_Restore, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_ENABLE)
				EndIf

			Case $h_Checkbox_Listl_Restore
				If GUICtrlRead($h_Checkbox_Listl_Restore) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: List Restore Selected. Only IDM List and Setting Restore")
					GUICtrlSetState($h_Checkbox_UnFinished_DD_Restore, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_GD_Restore, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_SD_Restore, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_HL_Restore, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_DISABLE)
				Else
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
					GUICtrlSetState($h_Checkbox_UnFinished_DD_Restore, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_GD_Restore, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_SD_Restore, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_UnFinished_HL_Restore, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_ENABLE)
				EndIf

			Case $h_Checkbox_UnFinished_SD_Restore
				If GUICtrlRead($h_Checkbox_UnFinished_SD_Restore) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Custom Restore Selected.")
					GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_DISABLE)
				Else
					If GUICtrlRead($h_Checkbox_UnFinished_GD_Restore) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_DD_Restore) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_HL_Restore) = $GUI_CHECKED Then
						GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_DISABLE)
						GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_DISABLE)
					Else
						_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
						GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_ENABLE)
						GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_ENABLE)
					EndIf
				EndIf

			Case $h_Checkbox_UnFinished_GD_Restore
				If GUICtrlRead($h_Checkbox_UnFinished_GD_Restore) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Custom Restore Selected.")
					GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_DISABLE)
				Else
					If GUICtrlRead($h_Checkbox_UnFinished_SD_Restore) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_DD_Restore) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_HL_Restore) = $GUI_CHECKED Then
						GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_DISABLE)
						GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_DISABLE)
					Else
						_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
						GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_ENABLE)
						GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_ENABLE)
					EndIf
				EndIf

			Case $h_Checkbox_UnFinished_DD_Restore
				If GUICtrlRead($h_Checkbox_UnFinished_DD_Restore) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Custom Restore Selected.")
					GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_DISABLE)
				Else
					If GUICtrlRead($h_Checkbox_UnFinished_SD_Restore) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_GD_Restore) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_HL_Restore) = $GUI_CHECKED Then
						GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_DISABLE)
						GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_DISABLE)
					Else
						_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
						GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_ENABLE)
						GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_ENABLE)
					EndIf
				EndIf

			Case $h_Checkbox_UnFinished_HL_Restore
				If GUICtrlRead($h_Checkbox_UnFinished_HL_Restore) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Custom Restore Selected.")
					GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_DISABLE)
				Else
					If GUICtrlRead($h_Checkbox_UnFinished_SD_Restore) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_GD_Restore) = $GUI_CHECKED Or $h_Checkbox_UnFinished_DD_Restore = $GUI_CHECKED Then
						GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_DISABLE)
						GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_DISABLE)
					Else
						_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
						GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_ENABLE)
						GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_ENABLE)
					EndIf
				EndIf

			Case $h_Button_BrowseLogFile_Setting
				_ChooseLogFile()

			Case $h_Button_BrowseDataBackupFolder_Setting
				_ChooseDataBackupFolder()

			Case $h_Button_BrowseAppDataFolder_Setting
				_ChooseAppDataBackupFolder()

			Case $h_Button_TempDataFolder_Setting
				_ChooseTempDataBackupFolder()

			Case $h_Label_DwnlDataFolder_Setting
				_ChangeTempDataBackupFolder()

			Case $h_Button_Open_Log_Setting
				_OpenLog()

			Case $h_Button_RestoreDefault_Setting
				_RestoreDefaultSetting()

			Case $h_Button_Browse_Backup
				_ChooseBackupFile()

			Case $h_Button_Backup
				_Backup()

			Case $h_Button_Browse_Restore
				_ChooseRestoreFile()

			Case $h_Button_Restore
				_Restore()

			Case $h_Button_Clean_Manager_Tools
				_SwCleanerGUI()

			Case $h_Button_More_Setting
				_SwMoreSettingGUI()

			Case $h_Button_Clean_Password_Tools
				_SwPwCleanerGUI()

			Case $h_Button_Cat_Tools
				_SwFileTypeGUI()

			Case $h_Button_Version_History_Help
				_SwHistory()

			Case $h_Button_Licence_Help
				_SwLicense()

			Case $h_Button_List_Manager_Tools
				_RunILM()

			Case $h_Button_Update_Help
				_UpdateCheck()

			Case $h_Button_Help_Help
				_SwHelp()

			Case $h_Button_Website_Help
				ShellExecute("http://gajjartejas26.blogspot.com")

			Case $h_Button_Forum_Help
				ShellExecute("http://forum.1067081.n5.nabble.com/IDM-Backup-Manager-f3.html")

			Case $h_Button_Associate_Setting
				_ShellInstall()

			Case $h_Picture_About
				ShellExecute("http://www.facebook.com/gajjartejas26")

		EndSwitch
	WEnd
EndFunc   ;==>_MainBM

Func _CheckIni()
	_LogSysInfo()
	FileWriteLine($s_Log_File, "")

	If FileExists($s_Setting_File) Then

		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Check Setting File: Found")

		$i_xWinPos = Number(IniRead($s_Setting_File, "Position", "x", $i_xWinPos))
		$i_yWinPos = Number(IniRead($s_Setting_File, "Position", "y", $i_yWinPos))

		$s_Backup_Dir = IniRead($s_Setting_File, "Default Paths", "Backup_Dir", $s_Backup_Dir)
		$s_Log_File = IniRead($s_Setting_File, "Default Paths", "Log_File", $s_Log_File)

;~		refresh every time on startup:
;~ 		$s_AppDataIDMFolder = IniRead($s_Setting_File, "Profile Paths", "AppDataIDMFolder", $s_AppDataIDMFolder);contain back "\"
;~ 		$s_TempPath = IniRead($s_Setting_File, "Profile Paths", "TempPath", $DwnlData_Folder);contain back "\"

		$b_RestartIDM = Number(IniRead($s_Setting_File, "More Setting", "Restart_IDM", $b_RestartIDM))

		$b_OpenFolder = Number(IniRead($s_Setting_File, "More Setting", "Open_Folder", $b_OpenFolder))
	Else
		If Not BitOR(FileExists(@AppDataDir & "\IDM Backup Manager"), DirCreate(@AppDataDir & "\IDM Backup Manager")) Then MsgBox(16, "Warning", "Log File NOT Created. Please Choose Other Location. (Setting--> LogFile)")
		_SwLicense()
		_WriteINI()
	EndIf
EndFunc   ;==>_CheckIni

Func _CheckSelfProcess()
	;Activates (gives focus to) a window.
	If WinActivate($s_Win_Title_BM) > 0 Then Exit
EndFunc   ;==>_CheckSelfProcess

Func _LogSysInfo()
	Local $a_Memory = MemGetStats()
	FileWriteLine($s_Log_File, "")
	FileWriteLine($s_Log_File, "============================= System Information =============================")
	FileWriteLine($s_Log_File, "Module Name and Version: " & $s_Win_Title_BM)
	FileWriteLine($s_Log_File, "Module Path: " & @ScriptFullPath)
	FileWriteLine($s_Log_File, "Is Module 64 bit?: " & @AutoItX64)
	FileWriteLine($s_Log_File, "Dll: " & $7zDll)
	FileWriteLine($s_Log_File, "OS Type: " & @OSType)
	FileWriteLine($s_Log_File, "OS Version: " & @OSVersion)
	FileWriteLine($s_Log_File, "Service Package: " & @OSServicePack)
	FileWriteLine($s_Log_File, "Total Memory: " & _sGetFileSizeConv($a_Memory[1] * 1024))
	FileWriteLine($s_Log_File, "Available Memory: " & _sGetFileSizeConv($a_Memory[2] * 1024))
EndFunc   ;==>_LogSysInfo

Func _CheckComponment()

	Local $sDllCheck = _7ZipCheckDll()
	If @error Then
		FileWriteLine($s_Log_File, _Current_Moment() & "Error: " & $sDllCheck & " Not found Exiting....")
		MsgBox(16, "Error", $sDllCheck & " Not Found Exiting....")
		Exit -2
	EndIf
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Check DLL: Found")
EndFunc   ;==>_CheckComponment

Func _CheckIDMProcess()

	Local $ParentWin = ""
	If IsHWnd($hGUI_BM) Then $ParentWin = $hGUI_BM

	If ProcessExists("idman.exe") Then ;**** Check the process "idman.exe" exists or not ***
		Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox(36, "IDM Need To Close", "IDM is Running in Background. Do You Want To Close IDM?", 0, $ParentWin)
		Select
			Case $iMsgBoxAnswer = 6 ;Yes
				If ProcessClose("idman.exe") Then
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Internet Download Manager Is Closed By User.")
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Internet Download Manager Could Not Closed.")
				EndIf
			Case $iMsgBoxAnswer = 7 ;No
				FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Internet Download Manager Is Running. User Selected No.")
				MsgBox(48, "Warning", "If Some File is Locked By IDM Backup/Restore Process Will Not Work Correctly.", 0, $ParentWin)
		EndSelect
	Else
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Internet Download Manager Is Not Running.")
	EndIf
EndFunc   ;==>_CheckIDMProcess

Func _LogProfilePaths()
	FileWriteLine($s_Log_File, "")
	FileWriteLine($s_Log_File, "============================= Check Profile ==================================")
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Finilized Path $AppDataIDMFolder= " & @TAB & '"' & $s_AppDataIDMFolder & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Finilized Path $s_TempPath= " & @TAB & @TAB & '"' & $s_TempPath & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Finilized Path $DwnlData_Folder= " & @TAB & @TAB & '"' & $DwnlData_Folder & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Finilized Path $GrabberData_Folder= " & @TAB & '"' & $GrabberData_Folder & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Setting File $s_Setting_File= " & @TAB & @TAB & '"' & $s_Setting_File & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Log File $s_Log_File= " & @TAB & @TAB & @TAB & '"' & $s_Log_File & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Backup Path $s_Backup_Dir= " & @TAB & @TAB & '"' & $s_Backup_Dir & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: INI File $s_ini_File= " & @TAB & @TAB & @TAB & '"' & $s_ini_File & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Reg File $s_reg_File= " & @TAB & @TAB & @TAB & '"' & $s_reg_File & '"')
	FileWriteLine($s_Log_File, "")
EndFunc   ;==>_LogProfilePaths

Func _LogRemove()
	$b_AppendLog_File = Number(IniRead($s_Setting_File, "More Setting", "Append_Log_File", $b_AppendLog_File))
	If Not $b_AppendLog_File And FileExists($s_Log_File) Then FileDelete($s_Log_File)
EndFunc   ;==>_LogRemove

Func _CheckCmdLine()
	FileWriteLine($s_Log_File, "")
	FileWriteLine($s_Log_File, "============================= Command Line Check =============================")
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: No of Command Line Parameters Passed: " & $CmdLine[0])
EndFunc   ;==>_CheckCmdLine

Func _StartupBM()
	_LogRemove()
	_CheckCmdLine()
	Switch $CmdLine[0]
		Case 0
			_CheckSelfProcess()
			_CheckIni()
			_CheckComponment()
			_CheckIDMProcess()
			_LogProfilePaths()
			_SwBMGUI()
			_MainBM()
		Case 1
			Switch $CmdLine[1]
				Case "swlm"
					_CheckSelfProcess()
					_CheckIni()
					_CheckComponment()
					_CheckIDMProcess()
					_LogProfilePaths()
					_RunILM()
				Case "swdc"
					_CheckSelfProcess()
					_CheckIni()
					_CheckComponment()
					_CheckIDMProcess()
					_LogProfilePaths()
					_SwCleanerGUI()
				Case "swpwc"
					_CheckSelfProcess()
					_CheckIni()
					_CheckComponment()
					_CheckIDMProcess()
					_LogProfilePaths()
					_SwPwCleanerGUI()
				Case "swft"
					_CheckSelfProcess()
					_CheckIni()
					_CheckComponment()
					_CheckIDMProcess()
					_LogProfilePaths()
					_SwFileTypeGUI()
				Case Else
					If FileExists($CmdLine[1]) Then
						_CheckSelfProcess()
						_CheckIni()
						_CheckComponment()
						_CheckIDMProcess()
						_LogProfilePaths()
						_SwBMGUI()
						_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
						GUICtrlSetState($h_Button_Restore, $GUI_ENABLE)
						GUICtrlSetData($h_Input_Restore_Path, $CmdLine[1])
						GUICtrlSetState($h_TabSheet2, $GUI_SHOW)
						_MainBM()
					Else
						_SwCMDLineMSGBOX()
					EndIf
			EndSwitch
		Case 2
			Switch $CmdLine[1]
				Case "backup"
					If FileExists($CmdLine[1]) Then
						If Not FileDelete($CmdLine[2]) Then
							_CheckSelfProcess()
							_CheckIni()
							_CheckComponment()
							_CheckIDMProcess()
							_LogProfilePaths()
							_SwBMGUI()
							GUICtrlSetState($h_Button_Backup, $GUI_DISABLE)
							GUICtrlSetData($h_Input_Backup_Path, "")
							_GUICtrlStatusBar_SetText($h_Status_Info, "Error: File Could Not Deleted")
							FileWriteLine($s_Log_File, _Current_Moment() & "Error: File Could Not Deleted: " & $CmdLine[2])
						EndIf
					Else
						_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
						GUICtrlSetState($h_Button_Backup, $GUI_ENABLE)
						GUICtrlSetData($h_Input_Backup_Path, $CmdLine[1])
						GUICtrlSetState($h_TabSheet1, $GUI_SHOW)
					EndIf
				Case "restore"
					If FileExists($CmdLine[1]) Then
						_CheckSelfProcess()
						_CheckIni()
						_CheckComponment()
						_CheckIDMProcess()
						_LogProfilePaths()
						_SwBMGUI()
						_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
						GUICtrlSetState($h_Button_Restore, $GUI_ENABLE)
						GUICtrlSetData($h_Input_Restore_Path, $CmdLine[1])
						GUICtrlSetState($h_TabSheet2, $GUI_SHOW)
						_MainBM()
					Else
						MsgBox(16, "Error", "File Not Exists:" & @CRLF & $CmdLine[1], 0, $hGUI_BM)
						FileWriteLine($s_Log_File, _Current_Moment() & "Error: File Not Exists: " & $CmdLine[2])
					EndIf
				Case Else
					_SwCMDLineMSGBOX()
			EndSwitch
	EndSwitch
EndFunc   ;==>_StartupBM
#endregion Main

#region control Functions
Func _ControlUpdateBusy()
	GUICtrlSetState($h_Tab1, $GUI_DISABLE)

	#region ;for backup
	GUICtrlSetState($h_Input_Backup_Path, $GUI_DISABLE)
	GUICtrlSetState($h_Button_Browse_Backup, $GUI_DISABLE)

	GUICtrlSetState($h_Checkbox_Password_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Input_Password_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_Compression_Level_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Combo_Compression_Level_Backup, $GUI_DISABLE)

	GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_DISABLE)

	GUICtrlSetState($h_Button_Backup, $GUI_DISABLE)
	#endregion ;for backup

	#region  ;for Restore
	GUICtrlSetState($h_Input_Restore_Path, $GUI_DISABLE)
	GUICtrlSetState($h_Button_Browse_Restore, $GUI_DISABLE)

	GUICtrlSetState($h_Checkbox_Password_Restore, $GUI_DISABLE)
	GUICtrlSetState($h_Input_Password_Restore, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_Convert_Registry_Restore, $GUI_DISABLE)
	GUICtrlSetState($h_Label_Convert_Registry_Restore, $GUI_DISABLE)

	GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_UnFinished_DD_Restore, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_UnFinished_GD_Restore, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_UnFinished_SD_Restore, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_UnFinished_HL_Restore, $GUI_DISABLE)

	GUICtrlSetState($h_Checkbox_Append_Registry_Restore, $GUI_DISABLE)
	GUICtrlSetState($h_Label_Append_Registry_Restore, $GUI_DISABLE)

	GUICtrlSetState($h_Button_Restore, $GUI_DISABLE)
	#endregion  ;for Restore
EndFunc   ;==>_ControlUpdateBusy

Func _ControlUpdateDefault()
	GUICtrlSetState($h_Tab1, $GUI_ENABLE)
	WinActivate($s_Win_Title_BM)

	#region ;for backup
	GUICtrlSetState($h_Input_Backup_Path, $GUI_ENABLE)
	GUICtrlSetState($h_Button_Browse_Backup, $GUI_ENABLE)

	GUICtrlSetState($h_Checkbox_Password_Backup, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_Password_Backup) = $GUI_CHECKED Then GUICtrlSetState($h_Input_Password_Backup, $GUI_ENABLE)
	GUICtrlSetState($h_Checkbox_Compression_Level_Backup, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_Compression_Level_Backup) = $GUI_CHECKED Then GUICtrlSetState($h_Combo_Compression_Level_Backup, $GUI_ENABLE)

	If GUICtrlRead($h_Checkbox_Full_Backup) = $GUI_CHECKED Then
		GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
	ElseIf GUICtrlRead($h_Checkbox_Listl_Backup) = $GUI_CHECKED Then
		GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
	ElseIf GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_CHECKED Or _
			GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_CHECKED Then
		GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_ENABLE)
	Else
		GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_ENABLE)
	EndIf

	If GUICtrlRead($h_Input_Backup_Path) <> "" And Not FileExists(GUICtrlRead($h_Input_Backup_Path)) Then GUICtrlSetState($h_Button_Backup, $GUI_ENABLE)
	#endregion ;for backup

	#region ;for restore
	GUICtrlSetState($h_Input_Restore_Path, $GUI_ENABLE)
	GUICtrlSetState($h_Button_Browse_Restore, $GUI_ENABLE)

	GUICtrlSetState($h_Checkbox_Password_Restore, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_Password_Restore) = $GUI_CHECKED Then GUICtrlSetState($h_Input_Password_Restore, $GUI_ENABLE)
	GUICtrlSetState($h_Checkbox_Convert_Registry_Restore, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_Convert_Registry_Restore) = $GUI_CHECKED Then GUICtrlSetState($h_Label_Convert_Registry_Restore, $GUI_ENABLE)

	If GUICtrlRead($h_Checkbox_Full_Restore) = $GUI_CHECKED Then
		GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_ENABLE)
	ElseIf GUICtrlRead($h_Checkbox_Listl_Restore) = $GUI_CHECKED Then
		GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_ENABLE)
	ElseIf GUICtrlRead($h_Checkbox_UnFinished_DD_Restore) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_GD_Restore) = $GUI_CHECKED Or _
			GUICtrlRead($h_Checkbox_UnFinished_SD_Restore) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_HL_Restore) = $GUI_CHECKED Then
		GUICtrlSetState($h_Checkbox_UnFinished_DD_Restore, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_GD_Restore, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_SD_Restore, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_HL_Restore, $GUI_ENABLE)
	Else
		GUICtrlSetState($h_Checkbox_Full_Restore, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_Listl_Restore, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_DD_Restore, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_GD_Restore, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_SD_Restore, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_HL_Restore, $GUI_ENABLE)
	EndIf

	GUICtrlSetState($h_Checkbox_Append_Registry_Restore, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_Append_Registry_Restore) = $GUI_CHECKED Then GUICtrlSetState($h_Label_Append_Registry_Restore, $GUI_ENABLE)

	If FileExists(GUICtrlRead($h_Input_Restore_Path)) Then GUICtrlSetState($h_Button_Restore, $GUI_ENABLE)

	_GUICtrlStatusBar_SetText($h_Status_Info, "", 1)
	#endregion ;for restore
EndFunc   ;==>_ControlUpdateDefault
#endregion control Functions

#region GUIS
Func _SwBMGUI()
	#region ### START Koda GUI section ###

	$hGUI_BM = GUICreate($s_Win_Title_BM, $i_xWidth_BM, $i_yHight_BM, $i_xWinPos, $i_yWinPos)

	$h_Tab1 = GUICtrlCreateTab(10, 10, 420, 240)

	#region backup ;==============================================================================================Backup:

	$h_TabSheet1 = GUICtrlCreateTabItem("Backup Data")
	GUICtrlSetImage(-1, @ScriptFullPath, -2)
	GUICtrlCreateGroup("Backup Location", 24, 44, 390, 55)
	GUICtrlSetFont(-1, 2, 800, 0, "MS Sans Serif")

	$h_Input_Backup_Path = GUICtrlCreateInput("", 33, 64, 336, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$h_Button_Browse_Backup = GUICtrlCreateButton("", 376, 63, 30, 23)
	_AET_ButtonSetIcon(-1, 15, 16, 16, 4)
	GUICtrlSetTip(-1, "Browse For Backup File")

	GUICtrlCreateGroup("Options", 24, 104, 390, 100)
	GUICtrlSetFont(-1, 1, 800, 0, "MS Sans Serif")

	$h_Checkbox_Password_Backup = GUICtrlCreateCheckbox("", 38, 130, 13, 17)

	$h_Input_Password_Backup = GUICtrlCreateInput("Password", 54, 128, 130, 21, $ES_PASSWORD)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSendMsg(-1, $EM_SETCUEBANNER, True, "Password")
	GUICtrlSetTip(-1, "Choose Yes If You Want Encryption of Your Backup Files Which Is Required Strong Password", "Backup Password", 1, 1)

	$h_Checkbox_Compression_Level_Backup = GUICtrlCreateCheckbox("", 38, 159, 13, 17)

	$h_Combo_Compression_Level_Backup = GUICtrlCreateCombo("1-No Compression", 54, 157, 130, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetData(-1, "2-Fastest Compression|3-Fast Compression|4-Normal Compression|5-Maximum Compression|6-Ultra Compression", "1-No Compression")
	GUICtrlSetTip(-1, "Here You Can Set The Compression Level of The Backup Files" & @CRLF & "", "Compression Level", 1, 1)

	$h_Checkbox_Full_Backup = GUICtrlCreateCheckbox("Full Backup", 200, 128, 107, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetTip(-1, "Backup Every Thing")
	$h_Checkbox_Listl_Backup = GUICtrlCreateCheckbox("Only List Backup", 310, 128, 97, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Backup List of Downloads Without Backing Up Data")
	$h_Checkbox_UnFinished_DD_Backup = GUICtrlCreateCheckbox("Downloaded Data", 200, 149, 107, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Backup Downloaded Data")
	$h_Checkbox_UnFinished_GD_Backup = GUICtrlCreateCheckbox("Grabber Data", 310, 149, 97, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Backup Grabber Data")
	$h_Checkbox_UnFinished_SD_Backup = GUICtrlCreateCheckbox("Scheduler/Queues", 200, 170, 107, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Backup Scheduler and Queues")
	$h_Checkbox_UnFinished_HL_Backup = GUICtrlCreateCheckbox("Other Data", 310, 170, 97, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Backup History, Logs and Sound")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$h_Button_Backup = GUICtrlCreateButton("Backup Now", 319, 217, 95, 25)
	_AET_ButtonSetIcon(-1, 8, 16, 16, 0)
	GUICtrlSetTip(-1, "Backup Now")
	GUICtrlSetState(-1, $GUI_DISABLE)

	#endregion backup ;==============================================================================================Backup:

	#region Restore ;==============================================================================================Restore:

	$h_TabSheet2 = GUICtrlCreateTabItem("Restore Data")
	GUICtrlSetImage(-1, @ScriptFullPath, -11)
	GUICtrlCreateGroup("Restore Location", 24, 44, 390, 55)
	GUICtrlSetFont(-1, 2, 800, 0, "MS Sans Serif")

	$h_Input_Restore_Path = GUICtrlCreateInput("", 33, 64, 336, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))

	$h_Button_Browse_Restore = GUICtrlCreateButton("", 376, 63, 30, 23)
	_AET_ButtonSetIcon(-1, 2, 16, 16, 4)
	GUICtrlSetTip(-1, "Browse For Restore File")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("Options", 24, 104, 390, 100)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

	$h_Checkbox_Password_Restore = GUICtrlCreateCheckbox("", 38, 130, 13, 17)

	$h_Input_Password_Restore = GUICtrlCreateInput("Password", 54, 128, 130, 21, $ES_PASSWORD)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSendMsg(-1, $EM_SETCUEBANNER, True, "Password")
	GUICtrlSetTip(-1, "Choose Yes If Your backup is Encrypted", "Restore Encryption", 1, 1)

	$h_Checkbox_Convert_Registry_Restore = GUICtrlCreateCheckbox("", 38, 159, 13, 17)

	$h_Label_Convert_Registry_Restore = GUICtrlCreateLabel("Convert Profile(Disabled)", 54, 161, 130, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Choose Yes If Destination Backup is another System" & @CRLF & @CRLF & _
			"EXAMPLE:" & @CRLF & _
			"In case of If You Want To Restore Backup of Cybercafé to Your Home PC", "Convert Profile", 1, 1)

	$h_Checkbox_Append_Registry_Restore = GUICtrlCreateCheckbox("", 38, 180, 13, 17)
	$h_Label_Append_Registry_Restore = GUICtrlCreateLabel("Append/Merge(Disabled)", 54, 182, 130, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "This will not remove existing profile. It will append data if possible and then merge.", "Append/Merge Data", 1, 1)

	$h_Checkbox_Full_Restore = GUICtrlCreateCheckbox("Full Restore", 200, 128, 107, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$h_Checkbox_Listl_Restore = GUICtrlCreateCheckbox("Only List Restore", 310, 128, 97, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$h_Checkbox_UnFinished_DD_Restore = GUICtrlCreateCheckbox("Downloaded Data", 200, 149, 107, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$h_Checkbox_UnFinished_GD_Restore = GUICtrlCreateCheckbox("Grabber Data", 310, 149, 97, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$h_Checkbox_UnFinished_SD_Restore = GUICtrlCreateCheckbox("Scheduler/Queues", 200, 170, 107, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$h_Checkbox_UnFinished_HL_Restore = GUICtrlCreateCheckbox("Other Data", 310, 170, 97, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$h_Button_Restore = GUICtrlCreateButton("Restore Now", 319, 217, 95, 25)
	_AET_ButtonSetIcon(-1, 8, 16, 16, 0)
	GUICtrlSetTip(-1, "Restore Now")
	GUICtrlSetState(-1, $GUI_DISABLE)
	#endregion Restore ;==============================================================================================Restore:

	#region Tools ;============================================================================================== Tools:

	$h_TabSheet3 = GUICtrlCreateTabItem("Tools")
	GUICtrlSetImage(-1, @ScriptFullPath, -13)

	GUICtrlCreateGroup("Tools", 24, 44, 390, 160)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

	$h_Button_List_Manager_Tools = GUICtrlCreateButton("Downloads List Manager", 45, 64, 80, 60, $BS_MULTILINE)
;~ 	If Not FileExists(@ScriptDir & "\IDM List Manager.exe") Then GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Download List Manager is allow to use Join Unfinished Downloaded Files, Remove Download From List and much more.")

	$h_Button_Clean_Manager_Tools = GUICtrlCreateButton("Data Cleaner", 135, 64, 80, 60, $BS_MULTILINE)
	GUICtrlSetTip(-1, "Clean History, Logs and Unfinished Download Data.")

	$h_Button_Clean_Password_Tools = GUICtrlCreateButton("Sites Logins Password Cleaner", 225, 64, 80, 60, $BS_MULTILINE)
	GUICtrlSetTip(-1, "Clean Password For Server/Sites.")

	$h_Button_Cat_Tools = GUICtrlCreateButton("Add Extra File Types in Categories", 315, 64, 80, 60, $BS_MULTILINE)
	GUICtrlSetTip(-1, "Add Extra File Types in Categories")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	#endregion Tools ;============================================================================================== Tools:

	#region Setting ;============================================================================================== Setting:
	$h_TabSheet4 = GUICtrlCreateTabItem("Setting")
	GUICtrlSetImage(-1, @ScriptFullPath, -17)

	GUICtrlCreateGroup("Default Application Path", 24, 44, 390, 80)

	$h_Button_BrowseLogFile_Setting = GUICtrlCreateButton(" Log File Folder:", 32, 60, 107, 25, $BS_left)
	_AET_ButtonSetIcon(-1, 2, 16, 16, 0)

	$h_Label_LogFile_Setting = GUICtrlCreateInput($s_Log_File, 144, 64, 265, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetTip(-1, GUICtrlRead($h_Label_LogFile_Setting))

	$h_Button_BrowseDataBackupFolder_Setting = GUICtrlCreateButton(" Backup Folder:", 32, 92, 107, 25, $BS_left)
	_AET_ButtonSetIcon(-1, 2, 16, 16, 0)

	$h_Label_BrowseDataBackupFolder_Setting = GUICtrlCreateInput($s_Backup_Dir, 144, 96, 265, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetTip(-1, GUICtrlRead($h_Label_BrowseDataBackupFolder_Setting))

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("Default IDM Profile", 24, 128, 393, 81)

	$h_Button_BrowseAppDataFolder_Setting = GUICtrlCreateButton(" AppData Folder:", 32, 146, 107, 25, $BS_left)
	_AET_ButtonSetIcon(-1, 2, 16, 16, 0)

	$h_Label_BrowseAppDataFolder_Setting = GUICtrlCreateInput($s_AppDataIDMFolder, 144, 150, 265, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetTip(-1, GUICtrlRead($h_Label_BrowseAppDataFolder_Setting))

	$h_Button_TempDataFolder_Setting = GUICtrlCreateButton(" Temp Folder:", 32, 178, 107, 25, $BS_left)
	GUICtrlSetTip(-1, _
			"Temporary directory is required for storing file parts during download." & @CRLF & _
			"If you have several physical drives on your computer, you should select" & @CRLF & _
			"different physical drives for temporary directory and ""Save To"" folders" & @CRLF & _
			"for faster assembling of downloaded files.")
	_AET_ButtonSetIcon(-1, 2, 16, 16, 0)

	$h_Label_DwnlDataFolder_Setting = GUICtrlCreateCombo("", 144, 182, 265, 17, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	#region Set Data
	Local $s_all_DwnlData_Folder = _aGetTempPathFolderEx()
	Local $i = 0
	If Not @error Then
		For $i = 0 To UBound($s_all_DwnlData_Folder) - 1
			GUICtrlSetData($h_Label_DwnlDataFolder_Setting, $s_all_DwnlData_Folder[$i])
		Next
	EndIf
	GUICtrlSetData($h_Label_DwnlDataFolder_Setting, $s_TempPath, $s_TempPath)
	#endregion Set Data
	GUICtrlSetTip($h_Label_DwnlDataFolder_Setting, _
			"DwnlData Folder: " & @CRLF & _
			$DwnlData_Folder & @CRLF & _
			@CRLF & _
			"GrabberData Folder: " & @CRLF & _
			$GrabberData_Folder)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$h_Button_Open_Log_Setting = GUICtrlCreateButton("", 274, 216, 30, 23)
	_AET_ButtonSetIcon(-1, 18, 16, 16, 4)
	GUICtrlSetTip(-1, "Open Log File")

	$h_Button_Associate_Setting = GUICtrlCreateButton("", 310, 216, 30, 23)
	_AET_ButtonSetIcon(-1, 14, 16, 16, 4)
	GUICtrlSetTip(-1, "Association .IBF File")

	$h_Button_More_Setting = GUICtrlCreateButton("", 346, 216, 30, 23)
	_AET_ButtonSetIcon(-1, 16, 16, 16, 4)
	GUICtrlSetTip(-1, "More Setting")

	$h_Button_RestoreDefault_Setting = GUICtrlCreateButton("", 382, 216, 30, 23)
	_AET_ButtonSetIcon(-1, 17, 16, 16, 4)
	GUICtrlSetTip(-1, "Restore Default Setting")

	GUICtrlCreateTabItem("")
	#endregion Setting ;============================================================================================== Setting:

	#region Help ;============================================================================================== Help:

	$h_TabSheet5 = GUICtrlCreateTabItem("Help")
	GUICtrlSetImage(-1, @ScriptFullPath, -5)

	GUICtrlCreateGroup("Help and Update", 24, 44, 390, 160)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

	$h_Button_Website_Help = GUICtrlCreateButton("  Website", 37, 126, 100, 30, $BS_left)
	_AET_ButtonSetIcon(-1, 5, 24, 24, 0)

	$h_Button_Help_Help = GUICtrlCreateButton("  Help", 37, 66, 100, 30, $BS_left)
	_AET_ButtonSetIcon(-1, 4, 24, 24, 0)

	$h_Button_Licence_Help = GUICtrlCreateButton("  License", 37, 96, 100, 30, $BS_left)
	_AET_ButtonSetIcon(-1, 6, 24, 24, 0)

	$h_Button_Version_History_Help = GUICtrlCreateButton("  Ver History", 146, 66, 100, 30, $BS_left)
	_AET_ButtonSetIcon(-1, 7, 24, 24, 0)

	$h_Button_Forum_Help = GUICtrlCreateButton("  Forum", 146, 96, 100, 30, $BS_left)
	_AET_ButtonSetIcon(-1, 3, 24, 24, 0)

	$h_Button_Update_Help = GUICtrlCreateButton("  Update", 146, 126, 100, 30, $BS_left);1111
	_AET_ButtonSetIcon(-1, 13, 24, 24, 0)

	$h_Picture_About = GUICtrlCreatePic("", 260, 55, 150, 145)
	GUICtrlSetTip(-1, "Dedicated to my lovely classmates!", "Love You!", 1, 1)
	_ResourceSetImageToCtrl(-1, "contactme")

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	#endregion Help ;============================================================================================== Help:

	GUICtrlCreateTabItem("")

	#region Info Label
	Local $aParts[3] = [400, 650]
	Local $aText[3] = ["INFO: Ready", @TAB & ""]
	$h_Status_Info = _GUICtrlStatusBar_Create($hGUI_BM, $aParts, $aText)
	_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo)
	#endregion Info Label

	#endregion ### END Koda GUI section ###
	GUISetState(@SW_SHOW)
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Window Created: " & $s_Win_Title_BM & " With Error Code: " & @error)
EndFunc   ;==>_SwBMGUI

Func _SwEditGUI($sTXTFile, $s_Title)
	GUISetState(@SW_DISABLE, $hGUI_BM)

	Local $ChildixWidth = 491
	Local $ChildiyHight = 310
	Local $sizea = WinGetPos($s_Win_Title_BM)
	If @error Then
		;If windows not Found Place it to centre
		Local $size[2] = [(@DesktopWidth - $ChildixWidth) / 2, (@DesktopHeight - $ChildiyHight) / 2]
	Else
		Local $size[2] = [$sizea[0] + $i_xWidth_BM / 2 - $ChildixWidth / 2, $sizea[1] + $i_yHight_BM / 2 - $ChildiyHight / 2]
	EndIf
;~ IsHWnd
	Local $Help_GUI = GUICreate($s_Title, $ChildixWidth, $ChildiyHight, $size[0], $size[1], BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE), $hGUI_BM)

	GUICtrlCreateEdit("", 10, 10, 470, 250, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY))
	GUICtrlSetData(-1, FileRead($sTXTFile))
	Local $Close = GUICtrlCreateButton("Close", 408, 265, 75, 25)
	GUISetIcon(@ScriptFullPath, 0, $Help_GUI)
	GUISetState(@SW_SHOW)
	Local $nMsg
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $Close
				ExitLoop
		EndSwitch
	WEnd

	GUISetState(@SW_ENABLE, $hGUI_BM)
	GUIDelete($Help_GUI)
EndFunc   ;==>_SwEditGUI

Func _SwMoreSettingGUI()
	#region ### START Koda GUI section ###
	GUISetState(@SW_DISABLE, $hGUI_BM)

	Local $ChildixWidth = 351
	Local $ChildiyHight = 141
	Local $sizea = WinGetPos($s_Win_Title_BM)
	If @error Then
		;If windows not Found Place it to centre
		Local $size[2] = [(@DesktopWidth - $ChildixWidth) / 2, (@DesktopHeight - $ChildiyHight) / 2]
	Else
		Local $size[2] = [$sizea[0] + $i_xWidth_BM / 2 - $ChildixWidth / 2, $sizea[1] + $i_yHight_BM / 2 - $ChildiyHight / 2]
	EndIf

	Local $More_Setting_GUI = GUICreate("More Setting", $ChildixWidth, $ChildiyHight, $size[0], $size[1], BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE), $hGUI_BM)

	GUICtrlCreateGroup("Setting", 10, 10, 330, 116)
	Local $h_AppendLog_Setting = GUICtrlCreateCheckbox("Append Log", 20, 30, 313, 17)
	If $b_AppendLog_File Then GUICtrlSetState($h_AppendLog_Setting, $GUI_CHECKED)
	Local $h_RestortIDM_Setting = GUICtrlCreateCheckbox("Auto Restart IDM after Restore/(Tool Section)", 20, 50, 313, 17)
	If $b_RestartIDM Then GUICtrlSetState($h_RestortIDM_Setting, $GUI_CHECKED)
	Local $h_OpenFolder_Setting = GUICtrlCreateCheckbox("Open Folder after Backup", 20, 70, 313, 17)
	If $b_OpenFolder Then GUICtrlSetState($h_OpenFolder_Setting, $GUI_CHECKED)
	Local $h_Close = GUICtrlCreateButton("Close", 256, 96, 75, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###
	Local $nMsg
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $h_Close
				ExitLoop

			Case $h_AppendLog_Setting
				If GUICtrlRead($h_AppendLog_Setting) = $GUI_CHECKED Then
					IniWrite($s_Setting_File, "More Setting", "Append_Log_File", 1)
					$b_AppendLog_File = 1
				Else
					IniWrite($s_Setting_File, "More Setting", "Append_Log_File", 0)
					$b_AppendLog_File = 0
				EndIf

			Case $h_RestortIDM_Setting
				If GUICtrlRead($h_RestortIDM_Setting) = $GUI_CHECKED Then
					IniWrite($s_Setting_File, "More Setting", "Restart_IDM", 1)
					$b_RestartIDM = 1
				Else
					IniWrite($s_Setting_File, "More Setting", "Restart_IDM", 0)
					$b_RestartIDM = 0
				EndIf

			Case $h_OpenFolder_Setting
				If GUICtrlRead($h_OpenFolder_Setting) = $GUI_CHECKED Then
					IniWrite($s_Setting_File, "More Setting", "Open_Folder", 1)
					$b_OpenFolder = 1
				Else
					IniWrite($s_Setting_File, "More Setting", "Open_Folder", 0)
					$b_OpenFolder = 0
				EndIf

		EndSwitch
	WEnd
	GUISetState(@SW_ENABLE, $hGUI_BM)
	GUIDelete($More_Setting_GUI)
EndFunc   ;==>_SwMoreSettingGUI

Func _SwCleanerGUI()
	GUISetState(@SW_DISABLE, $hGUI_BM)

	Local $ChildixWidth = 202
	Local $ChildiyHight = 259
	Local $sizea = WinGetPos($s_Win_Title_BM)
	If @error Then
		;If windows not Found Place it to centre
		Local $size[2] = [(@DesktopWidth - $ChildixWidth) / 2, (@DesktopHeight - $ChildiyHight) / 2]
	Else
		Local $size[2] = [$sizea[0] + $i_xWidth_BM / 2 - $ChildixWidth / 2, $sizea[1] + $i_yHight_BM / 2 - $ChildiyHight / 2]
	EndIf

	Local $Clean_GUI = GUICreate("IDM Cleaner", $ChildixWidth, $ChildiyHight, $size[0], $size[1], BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE), $hGUI_BM)

	GUICtrlCreateGroup("Options", 5, 60, 190, 150)
	Local $Clena_DD = GUICtrlCreateCheckbox("Download Data", 20, 80, 97, 17)
	Local $Clean_GD = GUICtrlCreateCheckbox("Grabber Data", 20, 105, 97, 17)
	Local $Clean_SD = GUICtrlCreateCheckbox("Scheduler Data", 20, 130, 97, 17)
	Local $Clean_HL = GUICtrlCreateCheckbox("Clean History and Logs", 20, 155, 137, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("Clean Mode", 5, 5, 190, 55)
	Local $Custom_Clean = GUICtrlCreateRadio("Custom Clean", 17, 29, 88, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	Local $Full_Clean = GUICtrlCreateRadio("Full Clean", 117, 29, 68, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $Progress1 = GUICtrlCreateProgress(10, 225, 96, 21)

	Local $Button_Clean = GUICtrlCreateButton("", 155, 215, 40, 40)
	_AET_ButtonSetIcon(-1, 9, 32, 32, 0)
	GUICtrlSetTip(-1, "Clean The Files/Folders", "Clean", 1, 1)

	Local $Button_Analyze = GUICtrlCreateButton("", 110, 215, 40, 40)
	_AET_ButtonSetIcon(-1, 11, 32, 32, 0)
	GUICtrlSetTip(-1, "Analyze Size of Files/Folders To Clean", "Analyze", 1, 1)
	GUISetState(@SW_SHOW)
	FileWriteLine($s_Log_File, "")
	FileWriteLine($s_Log_File, "============================= IDM Cleaner Started =============================")
	Local $nMsg
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop

			Case $Custom_Clean
				GUICtrlSetState($Clena_DD, $GUI_ENABLE)
				GUICtrlSetState($Clean_GD, $GUI_ENABLE)
				GUICtrlSetState($Clean_SD, $GUI_ENABLE)
				GUICtrlSetState($Clean_HL, $GUI_ENABLE)

			Case $Full_Clean
				GUICtrlSetState($Clena_DD, $GUI_DISABLE)
				GUICtrlSetState($Clean_GD, $GUI_DISABLE)
				GUICtrlSetState($Clean_SD, $GUI_DISABLE)
				GUICtrlSetState($Clean_HL, $GUI_DISABLE)

			Case $Button_Analyze
				_ProgressMarquee_Start($Progress1)
				If GUICtrlRead($Full_Clean) = $GUI_CHECKED Then
					$aData[0] = $DwnlData_Folder & @UserName & "\"
					$aData[1] = $Grabber_Folder
					$aData[2] = $GrabberData_Folder & @UserName & "\"
					$aData[3] = $Scheduler_Folder

					$aData[4] = $UrlHistory_txt_File
					$aData[5] = $UrlHistory2_txt_File
					$aData[6] = $GlobalErrors_log_File
					$aData[7] = $urlexclist_dat_File
					$aData[8] = $defextmap_dat_File
					$aData[9] = $foldresHistory_txt_File
					$aData[10] = $sts_list_dat_File
					$aData[11] = $cnlurllist_dat_File
				Else
					_ResetDataAray($aData)
					If GUICtrlRead($Clena_DD) = $GUI_CHECKED Then $aData[0] = $DwnlData_Folder & @UserName & "\"
					If GUICtrlRead($Clean_GD) = $GUI_CHECKED Then
						$aData[1] = $Grabber_Folder
						$aData[2] = $GrabberData_Folder & @UserName & "\"
					EndIf
					If GUICtrlRead($Clean_SD) = $GUI_CHECKED Then $aData[3] = $Scheduler_Folder
					If GUICtrlRead($Clean_HL) = $GUI_CHECKED Then
						$aData[4] = $UrlHistory_txt_File
						$aData[5] = $UrlHistory2_txt_File
						$aData[6] = $GlobalErrors_log_File
						$aData[7] = $urlexclist_dat_File
						$aData[8] = $defextmap_dat_File
						$aData[9] = $foldresHistory_txt_File
						$aData[10] = $sts_list_dat_File
						$aData[11] = $cnlurllist_dat_File
					EndIf
				EndIf ;==>clean

				_ProgressMarquee_Stop($Progress1, 1)
				Local $sSize = _sGetFileSizeConv(_iGetFileSize($aData))

				MsgBox(64, "Info", $sSize & " Will Removed.", 0, $Clean_GUI)

			Case $Button_Clean
				FileWriteLine($s_Log_File, "")
				FileWriteLine($s_Log_File, "============================= Cleaning Started =============================")
				If GUICtrlRead($Full_Clean) = $GUI_CHECKED Then
					$aData[0] = $DwnlData_Folder & @UserName & "\"
					$aData[1] = $Grabber_Folder
					$aData[2] = $GrabberData_Folder & @UserName & "\"
					$aData[3] = $Scheduler_Folder

					$aData[4] = $UrlHistory_txt_File
					$aData[5] = $UrlHistory2_txt_File
					$aData[6] = $GlobalErrors_log_File
					$aData[7] = $urlexclist_dat_File
					$aData[8] = $defextmap_dat_File
					$aData[9] = $foldresHistory_txt_File
					$aData[10] = $sts_list_dat_File
					$aData[11] = $cnlurllist_dat_File
				Else
					_ResetDataAray($aData)
					If GUICtrlRead($Clena_DD) = $GUI_CHECKED Then $aData[0] = $DwnlData_Folder & @UserName & "\"
					If GUICtrlRead($Clean_GD) = $GUI_CHECKED Then
						$aData[1] = $Grabber_Folder
						$aData[2] = $GrabberData_Folder & @UserName & "\"
					EndIf
					If GUICtrlRead($Clean_SD) = $GUI_CHECKED Then $aData[3] = $Scheduler_Folder
					If GUICtrlRead($Clean_HL) = $GUI_CHECKED Then
						$aData[4] = $UrlHistory_txt_File
						$aData[5] = $UrlHistory2_txt_File
						$aData[6] = $GlobalErrors_log_File
						$aData[7] = $urlexclist_dat_File
						$aData[8] = $defextmap_dat_File
						$aData[9] = $foldresHistory_txt_File
						$aData[10] = $sts_list_dat_File
						$aData[11] = $cnlurllist_dat_File
					EndIf
				EndIf

				_ProgressMarquee_Start($Progress1)
				$sSize = _sGetFileSizeConv(_iGetFileSize($aData))

				Local $iMsgBoxAnswer = MsgBox(36, "Conform", $sSize & " Will Removed. Continue?", 0, $Clean_GUI)
				_ProgressMarquee_Stop($Progress1, 1)

				If $iMsgBoxAnswer = 6 Then
					_ProgressMarquee_Start($Progress1)
					Local $sLockedFiles = _iFileOrFolderRemove($aData)
					_ProgressMarquee_Stop($Progress1, 1)

					If $sLockedFiles <> "" Then
						MsgBox(16, "Warning", "Some File(s) Could Not Removed. View Log For More Information.", 0, $Clean_GUI)

						Local $sLockedFile = StringSplit($sLockedFiles, @CRLF, 1)
						For $i = 1 To $sLockedFile[0] - 1
							FileWriteLine($s_Log_File, _Current_Moment() & "Warning: File Could Not Deleted= " & '"' & $sLockedFile[$i] & '"')
						Next

					EndIf

					For $i = 0 To 3
						If Not FileExists($aData[$i]) Then DirCreate($aData[$i])
					Next

					MsgBox(64, "Done", "Done.", 0, $Clean_GUI)
					If $b_RestartIDM Then _RunIDMexe()
				EndIf
				FileWriteLine($s_Log_File, "============================= Cleaning Ended =============================")
				FileWriteLine($s_Log_File, "")
		EndSwitch
	WEnd
	GUISetState(@SW_ENABLE, $hGUI_BM)
	GUIDelete($Clean_GUI)
EndFunc   ;==>_SwCleanerGUI

Func _SwPwCleanerGUI()
	GUISetState(@SW_DISABLE, $hGUI_BM)

	Local $ChildixWidth = 178
	Local $ChildiyHight = 60
	Local $sizea = WinGetPos($s_Win_Title_BM)
	If @error Then
		;If windows not Found Place it to centre
		Local $size[2] = [(@DesktopWidth - $ChildixWidth) / 2, (@DesktopHeight - $ChildiyHight) / 2]
	Else
		Local $size[2] = [$sizea[0] + $i_xWidth_BM / 2 - $ChildixWidth / 2, $sizea[1] + $i_yHight_BM / 2 - $ChildiyHight / 2]
	EndIf

	Local $pwCleaner_GUI = GUICreate("Password Cleaner", $ChildixWidth, $ChildiyHight, $size[0], $size[1], BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE), $hGUI_BM)
	Local $k = 1
	Local $j = 0
	Local $sInfoLabelText = "Total " & $j & " Password Found."
	Local $var
	While 1
		$var = RegEnumKey($s_regpath_IDM & "\Passwords", $k)
		If @error <> 0 Then ExitLoop
		If _RegValueExists($s_regpath_IDM & "\Passwords\" & $var, "EncPassword") Then $j += 1
		$sInfoLabelText = "Total " & $j & " Password Found."
		$k += 1
	WEnd
	Local $h_Lable_Info_pwCleaner = GUICtrlCreateLabel($sInfoLabelText, 10, 6, 155, 17)
	Local $h_Button_ClearAll_pwCleaner = GUICtrlCreateButton("Clear All", 10, 24, 75, 25)
	If $j = 0 Then GUICtrlSetState(-1, $GUI_DISABLE)
	Local $h_Button_Close_pwCleaner = GUICtrlCreateButton("Close", 90, 24, 75, 25)
	GUISetState(@SW_SHOW)

	Local $nMsg
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg

			Case $GUI_EVENT_CLOSE, $h_Button_Close_pwCleaner
				ExitLoop

			Case $h_Button_ClearAll_pwCleaner
				$k = 1
				$j = 0
				While 1
					$var = RegEnumKey($s_regpath_IDM & "\Passwords", $k)
					If @error <> 0 Then ExitLoop
					If _RegValueExists($s_regpath_IDM & "\Passwords\" & $var, "EncPassword") Then
						_RegDelete($s_regpath_IDM & "\Passwords\" & $var, "EncPassword")
						$j += 1
					EndIf
					$sInfoLabelText = "Removing " & $k - 1 & " Password(s)."
					GUICtrlSetData($h_Lable_Info_pwCleaner, $sInfoLabelText)
					$k += 1
				WEnd
				$sInfoLabelText = "Total " & $j & " Password(s) Removed."
				GUICtrlSetData($h_Lable_Info_pwCleaner, $sInfoLabelText)
				GUICtrlSetState($h_Button_ClearAll_pwCleaner, $GUI_DISABLE)
				If $b_RestartIDM Then _RunIDMexe()
		EndSwitch
	WEnd

	GUISetState(@SW_ENABLE, $hGUI_BM)
	GUIDelete($pwCleaner_GUI)
EndFunc   ;==>_SwPwCleanerGUI

Func _SwFileTypeGUI()
	GUISetState(@SW_DISABLE, $hGUI_BM)

	Local $ChildixWidth = 477
	Local $ChildiyHight = 218
	Local $sizea = WinGetPos($s_Win_Title_BM)
	If @error Then
		;If windows not Found Place it to centre
		Local $size[2] = [(@DesktopWidth - $ChildixWidth) / 2, (@DesktopHeight - $ChildiyHight) / 2]
	Else
		Local $size[2] = [$sizea[0] + $i_xWidth_BM / 2 - $ChildixWidth / 2, $sizea[1] + $i_yHight_BM / 2 - $ChildiyHight / 2]
	EndIf

	Local $FileTypeGUI = GUICreate("Add Extra Filetype By Categories", $ChildixWidth, $ChildiyHight, $size[0], $size[1], BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE), $hGUI_BM)

	Local $s_Default_Compressed_FileTypeGUI = "zip rar r0* r1* arj gz sit sitx sea ace bz2 7z"
	Local $s_Default_Documents_FileTypeGUI = "doc pdf ppt pps docx pptx"
	Local $s_Default_Music_FileTypeGUI = "mp3 wav wma mpa ram ra aac aif m4a"
	Local $s_Default_Programs_FileTypeGUI = "exe msi"
	Local $s_Default_Video_FileTypeGUI = "avi mpg mpe mpeg asf wmv mov qt rm mp4 flv m4v webm ogv ogg"

	Local $s_Enhance_Compressed_FileTypeGUI = $s_Default_Compressed_FileTypeGUI & " 001 cab xz txz lzma tar cpio bzip2 tbz2 tbz gzip tgz tpz z taz lzh lha rpm deb vhd wim swm fat ntfs xar squashfs ifu ifc dgca yz1 rk miniso iso isz bin cue mds mdf nrg ashdisc b6t b6i b5t b5i bwt bwi lcd ccd img dvd 000 daa cdi cif xmf xmd pdi dmg timg hfs ncd pxi p2i rif rdf gi uif vc4 fcd vcd ima bif flp c2d dao tao p01 md1 xa VaporCD gcd ixa vdi"
	Local $s_Enhance_Documents_FileTypeGUI = $s_Default_Documents_FileTypeGUI & " docm dotx dotm rtf odt wri wpd wps xps djvu ps chm accdb mdb adp mda accda mde accde ade xl* xlsx xlsm xlsb xlam xltx xltm xls xlt xla xlw xsn xsf infopathxml onetoc2 one onepkg pptm ppsx ppsm potx pot potm odp thmx pub"
	Local $s_Enhance_Music_FileTypeGUI = $s_Default_Music_FileTypeGUI & " 3ga 669 a52 ac3 adt adts aifc aiff amr aob ape awb caf cda dts flac it m4p mid mka mlp mod mp1 mp2 mpc oga oma qcp rmi s3m spx thd tta voc vqf w64 wv xm"
	Local $s_Enhance_Programs_FileTypeGUI = $s_Default_Programs_FileTypeGUI & " jar jad dll bpl cpl scr ocx msstyles mui"
	Local $s_Enhance_Video_FileTypeGUI = $s_Default_Video_FileTypeGUI & " 3g2 3gp 3gp2 3gpp amv divx drc dv f4v gxf m1v m2v m2t m2ts mkv mp2v mp4v mpeg1 mpeg2 mpeg4 mpv2 mts mtv mxf mxg nsv nuv ogg ogm ogx rec rmvb tod ts tts vob vro"

	Local $s_Current_Compressed_FileTypeGUI = _RegRead($s_regpath_IDM & "\FoldersTree\Compressed", "mask")
	If @error Then $s_Current_Compressed_FileTypeGUI = ""
	Local $s_Current_Documents_FileTypeGUI = _RegRead($s_regpath_IDM & "\FoldersTree\Documents", "mask")
	If @error Then $s_Current_Documents_FileTypeGUI = ""
	Local $s_Current_Music_FileTypeGUI = _RegRead($s_regpath_IDM & "\FoldersTree\Music", "mask")
	If @error Then $s_Current_Music_FileTypeGUI = ""
	Local $s_Current_Programs_FileTypeGUI = _RegRead($s_regpath_IDM & "\FoldersTree\Programs", "mask")
	If @error Then $s_Current_Programs_FileTypeGUI = ""
	Local $s_Current_Video_FileTypeGUI = _RegRead($s_regpath_IDM & "\FoldersTree\Video", "mask")
	If @error Then $s_Current_Video_FileTypeGUI = ""

	Local $h_Checkbox_Compressed_FileTypeGUI = GUICtrlCreateCheckbox("Compressed", 15, 12, 97, 17)
	Local $h_Checkbox_Documents_FileTypeGUI = GUICtrlCreateCheckbox("Documents", 15, 42, 97, 17)
	Local $h_Checkbox_Music_FileTypeGUI = GUICtrlCreateCheckbox("Music", 15, 72, 97, 17)
	Local $h_Checkbox_Programs_FileTypeGUI = GUICtrlCreateCheckbox("Programs", 15, 102, 97, 17)
	Local $h_Checkbox_Video_FileTypeGUI = GUICtrlCreateCheckbox("Video", 15, 132, 97, 17)

	Local $h_Input_Compressed_FileTypeGUI = GUICtrlCreateInput($s_Current_Compressed_FileTypeGUI, 115, 12, 351, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Local $h_Input_Documents_FileTypeGUI = GUICtrlCreateInput($s_Current_Documents_FileTypeGUI, 115, 42, 351, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Local $h_Input_Music_FileTypeGUI = GUICtrlCreateInput($s_Current_Music_FileTypeGUI, 115, 72, 351, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Local $h_Input_Programs_FileTypeGUI = GUICtrlCreateInput($s_Current_Programs_FileTypeGUI, 115, 102, 351, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Local $h_Input_Video_FileTypeGUI = GUICtrlCreateInput($s_Current_Video_FileTypeGUI, 115, 132, 351, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)

	Local $h_Button_Save_FileTypeGUI = GUICtrlCreateButton("Save Checked", 15, 162, 110, 43)
	Local $h_Button_Enhance_FileTypeGUI = GUICtrlCreateButton("Add/Enhance Extra File Types", 130, 162, 110, 43, $BS_MULTILINE)
	Local $h_Button_Default_FileTypeGUI = GUICtrlCreateButton("Restore Default File Types", 245, 162, 110, 43, $BS_MULTILINE)
	Local $h_Button_Close_FileTypeGUI = GUICtrlCreateButton("Close", 358, 162, 110, 43, $BS_MULTILINE)
	GUISetState(@SW_SHOW)

	Local $nMsg
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $h_Button_Close_FileTypeGUI
				ExitLoop

			Case $h_Checkbox_Compressed_FileTypeGUI
				If GUICtrlRead($h_Checkbox_Compressed_FileTypeGUI) = $GUI_CHECKED Then
					GUICtrlSetState($h_Input_Compressed_FileTypeGUI, $GUI_ENABLE)
				Else
					GUICtrlSetState($h_Input_Compressed_FileTypeGUI, $GUI_DISABLE)
				EndIf
			Case $h_Checkbox_Documents_FileTypeGUI
				If GUICtrlRead($h_Checkbox_Documents_FileTypeGUI) = $GUI_CHECKED Then
					GUICtrlSetState($h_Input_Documents_FileTypeGUI, $GUI_ENABLE)
				Else
					GUICtrlSetState($h_Input_Documents_FileTypeGUI, $GUI_DISABLE)
				EndIf
			Case $h_Checkbox_Music_FileTypeGUI
				If GUICtrlRead($h_Checkbox_Music_FileTypeGUI) = $GUI_CHECKED Then
					GUICtrlSetState($h_Input_Music_FileTypeGUI, $GUI_ENABLE)
				Else
					GUICtrlSetState($h_Input_Music_FileTypeGUI, $GUI_DISABLE)
				EndIf
			Case $h_Checkbox_Programs_FileTypeGUI
				If GUICtrlRead($h_Checkbox_Programs_FileTypeGUI) = $GUI_CHECKED Then
					GUICtrlSetState($h_Input_Programs_FileTypeGUI, $GUI_ENABLE)
				Else
					GUICtrlSetState($h_Input_Programs_FileTypeGUI, $GUI_DISABLE)
				EndIf
			Case $h_Checkbox_Video_FileTypeGUI
				If GUICtrlRead($h_Checkbox_Video_FileTypeGUI) = $GUI_CHECKED Then
					GUICtrlSetState($h_Input_Video_FileTypeGUI, $GUI_ENABLE)
				Else
					GUICtrlSetState($h_Input_Video_FileTypeGUI, $GUI_DISABLE)
				EndIf

			Case $h_Button_Save_FileTypeGUI
				If GUICtrlRead($h_Checkbox_Compressed_FileTypeGUI) = $GUI_CHECKED Then _RegWrite($s_regpath_IDM & "\FoldersTree\Compressed\", "mask", $REG_SZ, GUICtrlRead($h_Input_Compressed_FileTypeGUI))
				If GUICtrlRead($h_Checkbox_Documents_FileTypeGUI) = $GUI_CHECKED Then _RegWrite($s_regpath_IDM & "\FoldersTree\Documents\", "mask", $REG_SZ, GUICtrlRead($h_Input_Documents_FileTypeGUI))
				If GUICtrlRead($h_Checkbox_Music_FileTypeGUI) = $GUI_CHECKED Then _RegWrite($s_regpath_IDM & "\FoldersTree\Music\", "mask", $REG_SZ, GUICtrlRead($h_Input_Music_FileTypeGUI))
				If GUICtrlRead($h_Checkbox_Programs_FileTypeGUI) = $GUI_CHECKED Then _RegWrite($s_regpath_IDM & "\FoldersTree\Programs\", "mask", $REG_SZ, GUICtrlRead($h_Input_Programs_FileTypeGUI))
				If GUICtrlRead($h_Checkbox_Video_FileTypeGUI) = $GUI_CHECKED Then _RegWrite($s_regpath_IDM & "\FoldersTree\Video\", "mask", $REG_SZ, GUICtrlRead($h_Input_Video_FileTypeGUI))
				GUICtrlSetState($h_Button_Save_FileTypeGUI, $GUI_DISABLE)
				GUICtrlSetData($h_Button_Save_FileTypeGUI, "Done!")
				Sleep(500)
				GUICtrlSetState($h_Button_Save_FileTypeGUI, $GUI_ENABLE)
				GUICtrlSetData($h_Button_Save_FileTypeGUI, "Save")
				If $b_RestartIDM Then _RunIDMexe()

			Case $h_Button_Enhance_FileTypeGUI
				If GUICtrlRead($h_Checkbox_Compressed_FileTypeGUI) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Compressed_FileTypeGUI, $s_Enhance_Compressed_FileTypeGUI)
				If GUICtrlRead($h_Checkbox_Documents_FileTypeGUI) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Documents_FileTypeGUI, $s_Enhance_Documents_FileTypeGUI)
				If GUICtrlRead($h_Checkbox_Music_FileTypeGUI) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Music_FileTypeGUI, $s_Enhance_Music_FileTypeGUI)
				If GUICtrlRead($h_Checkbox_Programs_FileTypeGUI) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Programs_FileTypeGUI, $s_Enhance_Programs_FileTypeGUI)
				If GUICtrlRead($h_Checkbox_Video_FileTypeGUI) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Video_FileTypeGUI, $s_Enhance_Video_FileTypeGUI)

			Case $h_Button_Default_FileTypeGUI
				If GUICtrlRead($h_Checkbox_Compressed_FileTypeGUI) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Compressed_FileTypeGUI, $s_Default_Compressed_FileTypeGUI)
				If GUICtrlRead($h_Checkbox_Documents_FileTypeGUI) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Documents_FileTypeGUI, $s_Default_Documents_FileTypeGUI)
				If GUICtrlRead($h_Checkbox_Music_FileTypeGUI) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Music_FileTypeGUI, $s_Default_Music_FileTypeGUI)
				If GUICtrlRead($h_Checkbox_Programs_FileTypeGUI) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Programs_FileTypeGUI, $s_Default_Programs_FileTypeGUI)
				If GUICtrlRead($h_Checkbox_Video_FileTypeGUI) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Video_FileTypeGUI, $s_Default_Video_FileTypeGUI)
		EndSwitch
	WEnd

	GUISetState(@SW_ENABLE, $hGUI_BM)
	GUIDelete($FileTypeGUI)
EndFunc   ;==>_SwFileTypeGUI
#endregion GUIS

#region system & process Functions(idm related)
Func _FileOrFolderDeleteWithLog($sFile)
	If FileExists($sFile) Then
		If _IsDir($sFile) Then
			If Not DirRemove($sFile, 1) Then
				FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Remove  " & "=" & ' "' & $sFile & '" ' & "Error Code:1")
				Return SetError(1, 0, 0)
			EndIf
		Else
			FileSetAttrib($sFile, "-R+A")
			If Not FileDelete($sFile) Then
				FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & $sFile & '" ' & "Error Code:1")
				Return SetError(1, 0, 0)
			EndIf
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_FileOrFolderDeleteWithLog

Func _iGetMaxKey($s_regpath_IDM)
	Local $k = 1, $j = 0, $var, $iMaxKey

	While 1
		$var = RegEnumKey($s_regpath_IDM, $k)
		If @error <> 0 Then ExitLoop
		If Number($var) <> 0 Then $j += 1
		$k += 1
	WEnd

	If $j = 0 Then Return SetError(1, 0, 0)

	Local $MaxKey[$j]
	$k = 1
	$j = 0
	While 1
		$var = RegEnumKey($s_regpath_IDM, $k)
		If @error <> 0 Then ExitLoop
		If Number($var) <> 0 Then
			$MaxKey[$j] = $var
			$j += 1
		EndIf
		$k += 1
	WEnd
	$iMaxKey = _ArrayMax($MaxKey, 1)
	If @error Then Return SetError(1, 0, 0)
	Return $iMaxKey + 1
EndFunc   ;==>_iGetMaxKey

Func _ConvertRegProfile()
	Local $s_reg_File_Tmp = @TempDir & "\IDMregistryTmp.reg"

	_FileOrFolderDeleteWithLog($s_reg_File_Tmp)

	Local $h_reg_File = FileOpen($s_reg_File, 0)

	;append mode Use Unicode UTF16 Little Endian reading and writing mode.
	Local $h_reg_File_Tmp = FileOpen($s_reg_File_Tmp, 32 + 1)

	; Check if file opened for reading OK
	If $h_reg_File = -1 Or $h_reg_File_Tmp = -1 Then Return SetError(1, 0, 0)

	Local $Pathex = StringReplace('"' & $DwnlData_Folder & @UserName & "\", "\", "\\")
	Local $sLine, $final, $str, $strLen, $asp, $iN, $asp2

	While 1
		$sLine = FileReadLine($h_reg_File)
		If @error = -1 Then ExitLoop
		;===========================================
		If StringLeft($sLine, 16) = '"LocalFileName"=' Then
			$str = '"LocalFileName"='
			$strLen = 17
		ElseIf StringLeft($sLine, 12) = '"LocalPath"=' Then
			$str = '"LocalPath"='
			$strLen = 13
		ElseIf StringLeft($sLine, 14) = '"LogFileName"=' Then
			$str = '"LogFileName"='
			$strLen = 15
		Else
			FileWrite($h_reg_File_Tmp, $sLine & @CRLF)
			ContinueLoop
		EndIf

		$asp = StringSplit(StringTrimLeft($sLine, $strLen), "DwnlData\\", 3)
		If @error Then ContinueLoop

		$iN = UBound($asp) - 1
		$asp2 = StringSplit($asp[$iN], "\\", 3)
		If @error Then ContinueLoop

		For $i = 1 To UBound($asp2) - 1
			$final &= $asp2[$i] & "\\"
		Next;

		$final = StringTrimRight($final, 2);
		FileWrite($h_reg_File_Tmp, $str & $Pathex & $final & @CRLF)
		;===========================================
	WEnd
	FileClose($h_reg_File)
	FileClose($h_reg_File_Tmp)

	If Not FileDelete($s_reg_File) Then Return SetError(1, 0, 0)
	If Not FileMove($s_reg_File_Tmp, $s_reg_File) Then Return SetError(1, 0, 0)

	;Cleaneup
	If FileExists($s_reg_File_Tmp) Then FileDelete($s_reg_File_Tmp)

	Return 1
EndFunc   ;==>_ConvertRegProfile

Func _AppendRegKeys()
	Local $s_reg_File_Tmp = @TempDir & "\IDMregistryTmp.reg"

	_FileOrFolderDeleteWithLog($s_reg_File_Tmp)

	Local $iCounter = 0

	;Try to Get Max Key From Reg if Exists
	If _RegValueExists($s_regpath_IDM & "\maxID", "maxID") Then
		$iCounter = RegRead("HKEY_CURRENT_USER\Software\DownloadManager\", "maxID")
		If @error Then
			$iCounter = _iGetMaxKey($s_regpath_IDM);Otherwise Use Function
			If @error Then Return SetError(1, 0, 0)
		EndIf
	EndIf

	Local $h_reg_File = FileOpen($s_reg_File, 0);Read
	Local $h_reg_File_Tmp = FileOpen($s_reg_File_Tmp, 32 + 1);append mode Use Unicode UTF16 Little Endian reading and writing mode.
	Local $sLine, $asplit

	; Check if file opened for reading OK
	If $h_reg_File = -1 Or $h_reg_File_Tmp = -1 Then Return SetError(1, 0, 0)

	; Read in lines of text until the EOF is reached
	While 1
		$sLine = FileReadLine($h_reg_File)
		If @error = -1 Then ExitLoop

		If StringInStr($sLine, $s_regpath_IDM & "\") Then

			$asplit = StringSplit(StringTrimRight($sLine, 1), "\")

			;Decrease Counter to set same value
			If StringInStr($sLine, "ChList") Then $iCounter -= 1

			If StringIsDigit($asplit[4]) Then $sLine = StringReplace($sLine, $asplit[4], $iCounter)

			FileWrite($h_reg_File_Tmp, $sLine & @CRLF)
			$iCounter += 1
		Else
			FileWrite($h_reg_File_Tmp, $sLine & @CRLF)
		EndIf
	WEnd

	FileClose($h_reg_File)
	FileClose($h_reg_File_Tmp)

	If Not FileDelete($s_reg_File) Then Return SetError(1, 0, 0)
	If Not FileMove($s_reg_File_Tmp, $s_reg_File) Then Return SetError(1, 0, 0)

	;Cleaneup
	If FileExists($s_reg_File_Tmp) Then FileDelete($s_reg_File_Tmp)

	Return SetError(0, 0, 1)
EndFunc   ;==>_AppendRegKeys

Func _RunIDMexe()
	Local $s_IDMexe_Path = RegRead($s_regpath_IDM, "ExePath")
	If Not FileExists($s_IDMexe_Path) Then $s_IDMexe_Path = @ProgramFilesDir & "\" & "Internet Download Manager\IDMan.exe"
	If Not FileExists($s_IDMexe_Path) Then Return SetError(1, 0, 0)
	If ProcessExists("idman.exe") Then
		ProcessClose("idman.exe")
		_RunWithReducedPrivileges($s_IDMexe_Path, "/onboot")
	EndIf
EndFunc   ;==>_RunIDMexe

Func _onExit()
	Local $WinPos = WinGetPos($hGUI_BM)
	IniWrite($s_Setting_File, "Position", "x", $WinPos[0])
	IniWrite($s_Setting_File, "Position", "y", $WinPos[1])
	If $b_RestartIDM Then _RunIDMexe()
	FileWriteLine($s_Log_File, "")
	FileWriteLine($s_Log_File, "================================= Exit =======================================")
	Exit 0
EndFunc   ;==>_onExit

Func _CleanINInReg()
	_FileOrFolderDeleteWithLog($s_reg_File)
	_FileOrFolderDeleteWithLog($s_ini_File)
EndFunc   ;==>_CleanINInReg

Func _CopyRegTempKeyWithLog($sSrcKey, $sDestKey)
	If _RegKeyExists($sSrcKey) Then
		If _RegCopyKey($sSrcKey, $sDestKey) Then
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: tmp Sub Registry Copied" & "=" & ' "' & $sSrcKey & '" ' & "Error Code:" & @error)
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: tmp Sub Registry Could Not Copied" & "=" & ' "' & $sSrcKey & '" ' & "Error Code:" & @error)
		EndIf
	Else
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: tmp Registry Key Not Exists= " & '"' & $sSrcKey & '"')
	EndIf
EndFunc   ;==>_CopyRegTempKeyWithLog

#obfuscator_off
Func _ARCHIVERPROC($hWnd, $Msg, $nState, $ExInfo)
	Local $iFileSize, $iWriteSize, $iPercent = 0
	#forceref $hWnd,$Msg

	If $nState = 0 Then
		Local $EXTRACTINGINFO = DllStructCreate($tagEXTRACTINGINFO, $ExInfo)

		$iFileSize = DllStructGetData($EXTRACTINGINFO, "dwFileSize")
		$iWriteSize = DllStructGetData($EXTRACTINGINFO, "dwWriteSize")

		$iPercent = Int($iWriteSize / $iFileSize * 100)

		_GUICtrlStatusBar_SetText($h_Status_Info, $iPercent & " %", 1)
		Return 1
	EndIf

	Return 1
EndFunc   ;==>_ARCHIVERPROC
#Obfuscator_On

Func _ResetDataAray(ByRef $aData)
	For $i = 0 To UBound($aData) - 1
		$aData[$i] = ""
	Next
EndFunc   ;==>_ResetDataAray
#endregion system & process Functions(idm related)

#region Help
Func _SwHistory()
	If FileExists($s_History_File) Then
		_SwEditGUI($s_History_File, "Version History")
	Else
		_GUICtrlStatusBar_SetText($h_Status_Info, "Error: history.txt Not Found.")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
	EndIf
EndFunc   ;==>_SwHistory

Func _UpdateCheck()
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Checking Update Please Wait...")
	_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
	If _IsInternetConnectedEx() Then
		Local $Update_VER = InetRead("http://www.geocities.ws/gajjartejas/IDM_Backup_Manager/v0.9.1/update.txt", 1)
		Switch BinaryToString($Update_VER)
			Case ""
				_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Time Out! Or server May be Unviable")
				_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
			Case "0.9.1", "0.9.2", "0.9.3", "0.9.4", "0.9.5", "0.9.6", "0.9.7", $s_Current_Version
				_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: You Have Most Recent Version.")
				_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusCompled);StatusCompled
			Case Else
				_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Download Following Version: " & BinaryToString($Update_VER))
				_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
				ShellExecute("http://gajjartejas26.blogspot.com/p/idm-backup-manager.html")
		EndSwitch
	Else
		_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Internet Connection Could Not Found")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
	EndIf
EndFunc   ;==>_UpdateCheck

Func _ShellInstall()
	_ShellFile_Install("Restore IDM Backup", "ibf", @ScriptName, @ScriptFullPath, @ScriptFullPath, 14, False, False)
	If @error Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Association NOT Created.")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
	Else
		GUICtrlSetState($h_Button_Associate_Setting, $GUI_DISABLE)
		_GUICtrlStatusBar_SetText($h_Status_Info, "Info: Association Created.")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusCompled);StatusCompled
		DllCall("shell32.dll", "none", "SHChangeNotify", "long", 0x8000000, "uint", BitOR(0x0, 0x1000), "ptr", 0, "ptr", 0)
	EndIf
EndFunc   ;==>_ShellInstall

Func _SwLicense()
	If FileExists($s_License_File) Then
		_SwEditGUI($s_License_File, "License")
	Else
		MsgBox(64, "License", "IDM Backup Manager v" & $s_Current_Version & "(Beta) Copyright (c) 2012-2013, Gajjar Tejas" & @CRLF & "7-Zip Copyright (C) 1999-2013 Igor Pavlov (GPL)" & @CRLF & @CRLF & "THE SOFTWARE IS PROVIDED" & '"' & "AS IS" & '"' & "AND THE AUTHOR DISCLAIMS ALL WARRANTIESWITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OFMERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FORANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGESWHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN ANACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OFOR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.", 0, $hGUI_BM)
	EndIf
EndFunc   ;==>_SwLicense
#endregion Help

#region Setting
Func _ChooseLogFile()
	$s_Log_File = FileSaveDialog("Save Log File", _sPath_Last_Remove($s_Log_File), "Log File (*.Log)", 2, "LogFile.log", $hGUI_BM)
	If $s_Log_File <> "" And StringRight($s_Log_File, 4) <> ".log" Then $s_Log_File &= ".log"
	If Not @error Then
		; Check if file opened for writing OK
		Local $file = FileOpen($s_Log_File, 1)
		If $file <> -1 Then
			GUICtrlSetData($h_Label_LogFile_Setting, $s_Log_File)
			IniWrite($s_Setting_File, "Default Paths", "Log_File", $s_Log_File)
			GUICtrlSetTip($h_Label_LogFile_Setting, $s_Log_File)
		Else
			;Error
			$s_Log_File = GUICtrlRead($h_Label_LogFile_Setting)
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Unable To Save File. Please Choose Different Location.")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusInfo
		EndIf
		FileClose($file)
	Else
		$s_Log_File = GUICtrlRead($h_Label_LogFile_Setting)
	EndIf
EndFunc   ;==>_ChooseLogFile

Func _ChooseDataBackupFolder()
	If Not FileExists($s_Backup_Dir) Then DirCreate($s_Backup_Dir)

	$s_Backup_Dir = FileSelectFolder("Choose a folder to save file...", "", 7, $s_Backup_Dir, $hGUI_BM)
	If StringRight($s_Backup_Dir, 1) <> "\" Then $s_Backup_Dir &= "\"

	If _IsFilePathValid($s_Backup_Dir) Then ;User Selected valid path
		GUICtrlSetData($h_Label_BrowseDataBackupFolder_Setting, $s_Backup_Dir)
		IniWrite($s_Setting_File, "Default Paths", "Backup_Dir", $s_Backup_Dir)
		GUICtrlSetTip($h_Label_BrowseDataBackupFolder_Setting, $s_Backup_Dir)
	Else
		$s_Backup_Dir = GUICtrlRead($h_Label_BrowseDataBackupFolder_Setting)
	EndIf
EndFunc   ;==>_ChooseDataBackupFolder

Func _ChooseAppDataBackupFolder()
	If Not FileExists($s_AppDataIDMFolder) Then DirCreate($s_AppDataIDMFolder)

	$s_AppDataIDMFolder = FileSelectFolder("Choose a folder to save file...", "", 7, $s_AppDataIDMFolder, $hGUI_BM)
	If StringRight($s_AppDataIDMFolder, 1) <> "\" Then $s_AppDataIDMFolder &= "\"

	If _IsFilePathValid($s_AppDataIDMFolder) Then ;User Selected valid path
		If StringRight($s_AppDataIDMFolder, 5) = "\IDM\" Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
			GUICtrlSetData($h_Label_BrowseAppDataFolder_Setting, $s_AppDataIDMFolder)
			IniWrite($s_Setting_File, "Profile Paths", "AppDataIDMFolder", $s_AppDataIDMFolder)
			GUICtrlSetTip($h_Label_BrowseAppDataFolder_Setting, $s_AppDataIDMFolder)
		Else
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Please Choose Correct Folder Named & 'IDM\'")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
			$s_AppDataIDMFolder = GUICtrlRead($h_Label_BrowseAppDataFolder_Setting)
		EndIf
	Else
		$s_AppDataIDMFolder = GUICtrlRead($h_Label_BrowseAppDataFolder_Setting)
		_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
	EndIf
EndFunc   ;==>_ChooseAppDataBackupFolder

Func _ChooseTempDataBackupFolder()
	If Not FileExists($s_TempPath) Then DirCreate($s_TempPath)

	$s_TempPath = FileSelectFolder("Choose a folder...", "", 7, $s_TempPath, $hGUI_BM)
	If StringRight($s_TempPath, 1) <> "\" Then $s_TempPath &= "\"

	If _IsFilePathValid($s_TempPath) Then ;User Selected valid path
		_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
		GUICtrlSetData($h_Label_DwnlDataFolder_Setting, $s_TempPath, $s_TempPath)
		IniWrite($s_Setting_File, "Profile Paths", "TempPath", $s_TempPath)
		$DwnlData_Folder = $s_TempPath & "DwnlData\" ;contain back "\"
		$GrabberData_Folder = $s_TempPath & "GrabberData\" ;contain back "\"
		GUICtrlSetTip($h_Label_DwnlDataFolder_Setting, _
				"DwnlData Folder: " & @CRLF & _
				$DwnlData_Folder & @CRLF & _
				@CRLF & _
				"GrabberData Folder: " & @CRLF & _
				$GrabberData_Folder)
	Else
		_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
		$s_TempPath = GUICtrlRead($h_Label_DwnlDataFolder_Setting) ;contain back "\"
		$DwnlData_Folder = $s_TempPath & "DwnlData\" ;contain back "\"
		$GrabberData_Folder = $s_TempPath & "GrabberData\" ;contain back "\"
	EndIf
EndFunc   ;==>_ChooseTempDataBackupFolder

Func _ChangeTempDataBackupFolder()
	$s_TempPath = GUICtrlRead($h_Label_DwnlDataFolder_Setting)
	IniWrite($s_Setting_File, "Profile Paths", "TempPath", $s_TempPath)
	$DwnlData_Folder = $s_TempPath & "DwnlData\" ;contain back "\"
	$GrabberData_Folder = $s_TempPath & "GrabberData\"
	GUICtrlSetTip($h_Label_DwnlDataFolder_Setting, _
			"DwnlData Folder: " & @CRLF & _
			$DwnlData_Folder & @CRLF & _
			@CRLF & _
			"GrabberData Folder: " & @CRLF & _
			$GrabberData_Folder)
EndFunc   ;==>_ChangeTempDataBackupFolder

Func _WriteINI()
	IniWrite($s_Setting_File, "Position", "x", $i_xWinPos)
	IniWrite($s_Setting_File, "Position", "y", $i_yWinPos)

	IniWrite($s_Setting_File, "Default Paths", "Backup_Dir", $s_Backup_Dir)
	IniWrite($s_Setting_File, "Default Paths", "Log_File", $s_Log_File)

	IniWrite($s_Setting_File, "Profile Paths", "AppDataIDMFolder", $s_AppDataIDMFolder);contain back "\"
	IniWrite($s_Setting_File, "Profile Paths", "TempPath", $s_TempPath);contain back "\"

	IniWrite($s_Setting_File, "More Setting", "Append_Log_File", $b_AppendLog_File) ;Boolean
	IniWrite($s_Setting_File, "More Setting", "Restart_IDM", $b_RestartIDM)
	IniWrite($s_Setting_File, "More Setting", "Open_Folder", $b_OpenFolder)
EndFunc   ;==>_WriteINI

Func _OpenLog()
	If FileExists($s_Log_File) Then
		ShellExecute($s_Log_File)
	Else
		_GUICtrlStatusBar_SetText($h_Status_Info, "Error: File Could Not Found. Please Choose Correct Location in Setting Tab.")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
	EndIf
EndFunc   ;==>_OpenLog

Func _RestoreDefaultSetting()
	Local $iMsgBoxAnswer = MsgBox(52, "Warning", "This Operation Will Reset IDM Backup Manager Setting And Restart IDM Backup Manager. Do You Want To Continue?", 0, $hGUI_BM)

	If $iMsgBoxAnswer = 6 Then;Yes
		If _FileOrFolderDeleteWithLog($s_Setting_File) Then
			Run(@ScriptFullPath)
			Exit
		Else
			MsgBox(48, "Error", "Error Occurred During Resetting Setting.")
		EndIf
	EndIf
EndFunc   ;==>_RestoreDefaultSetting
#endregion Setting

#region Backup
Func _ChooseBackupFile()
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
	_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo

	Local $s_Backup_File = FileSaveDialog("Save Backup File", $s_Backup_Dir, "IDM Backup File (*.ibf)|All Files(*.*)", 18, "IDMbackup" & @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC & ".ibf", $hGUI_BM)
	If $s_Backup_File <> "" And StringRight($s_Backup_File, 4) <> ".ibf" Then $s_Backup_File &= ".ibf"

	If @error Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
	Else
		If FileExists($s_Backup_File) Then
			If FileDelete($s_Backup_File) = 0 Then
				GUICtrlSetState($h_Button_Backup, $GUI_DISABLE)
				GUICtrlSetData($h_Input_Backup_Path, "")
				_GUICtrlStatusBar_SetText($h_Status_Info, "Error: File Could Not Deleted")
				_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
			Else
				GUICtrlSetState($h_Button_Backup, $GUI_ENABLE)
				_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
				_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
				GUICtrlSetData($h_Input_Backup_Path, $s_Backup_File)
			EndIf
		Else
			GUICtrlSetData($h_Input_Backup_Path, $s_Backup_File)
			GUICtrlSetState($h_Button_Backup, $GUI_ENABLE)
		EndIf
	EndIf
EndFunc   ;==>_ChooseBackupFile

Func _Backup()
	FileWriteLine($s_Log_File, "")
	FileWriteLine($s_Log_File, "============================= Backup Session Started =============================")
	_ControlUpdateBusy()
	_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusWorking);StatusWorking
	_CleanINInReg()

	#region ;/Define Some variable: $s_Backup_File, $s_Compression_Level--->
	Local $s_Backup_File = GUICtrlRead($h_Input_Backup_Path)
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: User Selected Backup to  " & "=" & ' "' & $s_Backup_File & '"')

	Local $s_Compression_Level
	If GUICtrlRead($h_Checkbox_Compression_Level_Backup) = $GUI_CHECKED Then
		$s_Compression_Level = GUICtrlRead($h_Combo_Compression_Level_Backup)
	Else
		$s_Compression_Level = "1-No Compression"
	EndIf
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Compression Level " & "=" & ' "' & $s_Compression_Level & '"')
	#endregion ;/Define Some variable: $s_Backup_File, $s_Compression_Level--->

	#region ;/Check Password, Drive Space, Condition and PreRequestes--->
	If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_UNCHECKED _
			And GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_UNCHECKED _
			And GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_UNCHECKED _
			And GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_UNCHECKED _
			And GUICtrlRead($h_Checkbox_Listl_Backup) = $GUI_UNCHECKED _
			And GUICtrlRead($h_Checkbox_Full_Backup) = $GUI_UNCHECKED Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Select Backup Type")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusWarning);StatusWarning
		_ControlUpdateDefault()
		Return SetError(1)
	EndIf

	Local $b_Password, $s_Password
	If GUICtrlRead($h_Checkbox_Password_Backup) = $GUI_CHECKED Then
		$s_Password = GUICtrlRead($h_Input_Password_Backup)
		If $s_Password = "" Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Password is Empty")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusWarning);StatusWarning
			FileWriteLine($s_Log_File, _Current_Moment() & "Error: Password is Empty")
			_ControlUpdateDefault()
			Return SetError(1)
		ElseIf StringInStr($s_Password, """") Or StringInStr($s_Password, '''') Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Password Dosen't Contain Double Quote or Single Quote")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusWarning);StatusWarning
			FileWriteLine($s_Log_File, _Current_Moment() & "Password Dosen't Contain Double Quote or Single Quote")
			_ControlUpdateDefault()
			Return SetError(1)
		Else
			$b_Password = True
		EndIf

	Else
		$b_Password = False
		$s_Password = ""
	EndIf
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Password= " & '"' & $b_Password & '"')

	_GUICtrlStatusBar_SetText($h_Status_Info, "Checking : Drive Space Please Wait...")
	If DriveSpaceFree(_sDriveGetFromPath($s_Backup_File)) < DirGetSize($s_AppDataIDMFolder) / 1024 / 1024 Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Not Enough  Free Space on Drive. +" & _sGetFileSizeConv(DirGetSize($s_AppDataIDMFolder) - DriveSpaceFree(_sDriveGetFromPath($s_Backup_File)) * 1024 * 1024) & " Required")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
		FileWriteLine($s_Log_File, _Current_Moment() & _
				"Error: Not Enough  Free Space on Drive " & _sDriveGetFromPath($s_Backup_File) & _
				" Free Space:" & _sGetFileSizeConv((DriveSpaceFree(_sDriveGetFromPath($s_Backup_File)) * 1024 * 1024)) & _
				". At Least " & _sGetFileSizeConv(DirGetSize($s_AppDataIDMFolder) - DriveSpaceFree(_sDriveGetFromPath($s_Backup_File)) * 1024 * 1024) & "Required")
		_ControlUpdateDefault()
		Return SetError(1)
	EndIf
	#endregion ;/Check Password, Drive Space, Condition and PreRequestes--->

	#region ;/Check registry and count--->
	If Not _RegKeyExists($s_regpath_IDM) Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Registry Entry Is Empty. Nothing To Backup")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
		FileWriteLine($s_Log_File, _Current_Moment() & "Error: Registry Entry Is Empty. Nothing To Backup !")
		_ControlUpdateDefault()
		Return SetError(1)
	Else
		_GUICtrlStatusBar_SetText($h_Status_Info, "Counting Registry Key Please Wait...")
		Local $iTotalKey = _iCountKey($s_regpath_IDM)
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Total Registry Need to Backup = " & '"' & $iTotalKey & '"')
	EndIf
	#endregion ;/Check registry and count--->

	#region ;/Expert registry --->
	_GUICtrlStatusBar_SetText($h_Status_Info, "Backingup: Registry Registry Please Wait...")
	_RegBackup($s_reg_File, $s_regpath_IDM)
	#endregion ;/Expert registry --->

	#region ;/define backup type--->
	Local $b_DwnlData_Folder = False
	Local $b_Grabber_Folder = False
	Local $b_Scheduler_Folder = False
	Local $b_History_Files = False

	IniWrite($s_ini_File, "Default", "AppDataIDMFolder", $s_AppDataIDMFolder)
	IniWrite($s_ini_File, "Default", "TempPath", $DwnlData_Folder)
	IniWrite($s_ini_File, "Default", "idmvers", RegRead($s_regpath_IDM, "idmvers"))
	IniWrite($s_ini_File, "Default", "Keys", $iTotalKey)
	IniWrite($s_ini_File, "Default", "Password", $b_Password)
	IniWrite($s_ini_File, "Default", "Username", @UserName)

	;Full Backup
	If GUICtrlRead($h_Checkbox_Full_Backup) = $GUI_CHECKED Then
		$b_DwnlData_Folder = True
		$b_Grabber_Folder = True
		$b_Scheduler_Folder = True
		$b_History_Files = True

		FileWriteLine($s_Log_File, _Current_Moment() & "Info: User Selected Full Backup")
		IniWrite($s_ini_File, "Default", "Mode", "Full")

		;Only List backup
	ElseIf GUICtrlRead($h_Checkbox_Listl_Backup) = $GUI_CHECKED Then
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: User Selected List Backup")

		IniWrite($s_ini_File, "Default", "Mode", "List")

		;Custom Backup
	Else
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: User Selected Custom Backup")

		If GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_CHECKED Then $b_DwnlData_Folder = True
		If GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_CHECKED Then $b_Grabber_Folder = True
		If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Then $b_Scheduler_Folder = True
		If GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_CHECKED Then $b_History_Files = True

		IniWrite($s_ini_File, "Default", "Mode", "Custom")
	EndIf
	#endregion ;/define backup type--->

	#region ;/Build Data array and Write INI--->

	_ResetDataAray($aData)

	If $b_DwnlData_Folder = True Then
		If FileExists($DwnlData_Folder) Then
			$aData[0] = $DwnlData_Folder
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $DwnlData_Folder " & "=" & ' "' & $DwnlData_Folder & '" ')
			IniWrite($s_ini_File, "Default", "DwnlData_Folder", True)
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $DwnlData_Folder Reason: Folder Does Not Exists= " & '"' & $DwnlData_Folder & '"')
		EndIf
	Else
		IniWrite($s_ini_File, "Default", "DwnlData_Folder", False)
	EndIf

	If $b_Grabber_Folder = True Then
		If FileExists($Grabber_Folder) Then
			$aData[1] = $Grabber_Folder
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $Grabber_Folder " & "=" & ' "' & $Grabber_Folder & '" ')
			IniWrite($s_ini_File, "Default", "Grabber_Folder", True)
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $Grabber_Folder Reason: Folder Does Not Exists= " & '"' & $Grabber_Folder & '"')
		EndIf

		If FileExists($GrabberData_Folder) Then
			$aData[2] = $GrabberData_Folder
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $GrabberData_Folder " & "=" & ' "' & $GrabberData_Folder & '" ')
			IniWrite($s_ini_File, "Default", "GrabberData_Folder", True)
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $GrabberData_Folder Reason: Folder Does Not Exists= " & '"' & $GrabberData_Folder & '"')
		EndIf
	Else
		IniWrite($s_ini_File, "Default", "Grabber_Folder", False)
		IniWrite($s_ini_File, "Default", "GrabberData_Folder", False)
	EndIf

	If $b_Scheduler_Folder = True Then
		If FileExists($Scheduler_Folder) Then
			$aData[3] = $Scheduler_Folder
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $Scheduler_Folder " & "=" & ' "' & $Scheduler_Folder & '" ')
			IniWrite($s_ini_File, "Default", "Scheduler_Folder", True)
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $Scheduler_Folder Reason: Folder Does Not Exists= " & '"' & $Scheduler_Folder & '"')
		EndIf
	Else
		IniWrite($s_ini_File, "Default", "Scheduler_Folder", False)
	EndIf

	If $b_History_Files = True Then

		If FileExists($UrlHistory_txt_File) Then
			$aData[4] = $UrlHistory_txt_File
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $UrlHistory_txt_File " & "=" & ' "' & $UrlHistory_txt_File & '"')
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $UrlHistory_txt_File Reason: File Does Not Exists= " & '"' & $UrlHistory_txt_File & '"')
		EndIf

		If FileExists($UrlHistory2_txt_File) Then
			$aData[5] = $UrlHistory2_txt_File
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $UrlHistory2_txt_File " & "=" & ' "' & $UrlHistory2_txt_File & '"')
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $UrlHistory2_txt_File Reason: File Does Not Exists= " & '"' & $UrlHistory2_txt_File & '"')
		EndIf

		If FileExists($GlobalErrors_log_File) Then
			$aData[6] = $GlobalErrors_log_File
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $GlobalErrors_log_File " & "=" & ' "' & $GlobalErrors_log_File & '"')
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $GlobalErrors_log_File Reason: File Does Not Exists= " & '"' & $GlobalErrors_log_File & '"')
		EndIf

		If FileExists($urlexclist_dat_File) Then
			$aData[7] = $urlexclist_dat_File
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $urlexclist_dat_File " & "=" & ' "' & $urlexclist_dat_File & '"')
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $urlexclist_dat_File Reason: File Does Not Exists= " & '"' & $urlexclist_dat_File & '"')
		EndIf

		If FileExists($defextmap_dat_File) Then
			$aData[8] = $defextmap_dat_File
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $defextmap_dat_File " & "=" & ' "' & $defextmap_dat_File & '"')
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $defextmap_dat_File Reason: File Does Not Exists= " & '"' & $defextmap_dat_File & '"')
		EndIf

		If FileExists($foldresHistory_txt_File) Then
			$aData[9] = $foldresHistory_txt_File
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $foldresHistory_txt_File " & "=" & ' "' & $foldresHistory_txt_File & '"')
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $foldresHistory_txt_File Reason: File Does Not Exists= " & '"' & $foldresHistory_txt_File & '"')
		EndIf

		If FileExists($sts_list_dat_File) Then
			$aData[10] = $sts_list_dat_File
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $sts_list_dat_File " & "=" & ' "' & $sts_list_dat_File & '" ')
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $sts_list_dat_File Reason: File Does Not Exists= " & '"' & $sts_list_dat_File & '"')
		EndIf

		If FileExists($cnlurllist_dat_File) Then
			$aData[11] = $cnlurllist_dat_File
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $cnlurllist_dat_File " & "=" & ' "' & $cnlurllist_dat_File & '" ')
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $cnlurllist_dat_File Reason: File Does Not Exists= " & '"' & $cnlurllist_dat_File & '"')
		EndIf

		If FileExists($Sound_Folder) Then
			$aData[12] = $Sound_Folder
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $Sound_Folder " & "=" & ' "' & $Sound_Folder & '" ')
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $Sound_Folder Reason: File Does Not Exists= " & '"' & $Sound_Folder & '"')
		EndIf

		IniWrite($s_ini_File, "Default", "History_Files", True)
	Else
		IniWrite($s_ini_File, "Default", "History_Files", False)
	EndIf

	#region ;/add INI--->
	If FileExists($s_ini_File) Then
		$aData[13] = $s_ini_File
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $s_ini_File " & "=" & ' "' & $s_ini_File & '"')
	Else
		$aData[13] = ""
		FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $s_ini_File Reason: File Does Not Exits= " & '"' & $s_ini_File & '"')
	EndIf
	#endregion ;/add INI--->

	#region ;/add registry--->
	If FileExists($s_reg_File) Then
		$aData[14] = $s_reg_File
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $s_ini_File " & "=" & ' "' & $s_reg_File & '"')
	Else
		$aData[14] = ""
		FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $s_ini_File Reason: File Does Not Exits= " & '"' & $s_reg_File & '"')
	EndIf
	#endregion ;/add registry--->
	#endregion ;/Build Data array and Write INI--->

	#region ;/add Data Files--->
	_GUICtrlStatusBar_SetText($h_Status_Info, "Adding: Data Files Please Wait...")

	_7ZipStartup()
	_7ZipSetOwnerWindowEx($hGUI_BM, "_ARCHIVERPROC")
	Local $foo = _7ZipAdd($hGUI_BM, $s_Backup_File, $aData, $s_Compression_Level, $s_Password)

	Local $sFile = StringSplit($foo, @CRLF, 1)
	For $i = 1 To $sFile[0]
		If $sFile[$i] <> "" Then FileWriteLine($s_Log_File, _Current_Moment() & "7z Log: = " & $sFile[$i])
	Next

	_7ZipShutdown()
	#endregion ;/add Data Files--->

	_CleanINInReg()
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Done")
	_ControlUpdateDefault()
	_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
	If $b_OpenFolder Then _SelectFile($s_Backup_File)
	FileWriteLine($s_Log_File, "============================= Backup Session Ended =============================")
EndFunc   ;==>_Backup
#endregion Backup

#region Restore
Func _ChooseRestoreFile()
	Local $s_Restore_File = FileOpenDialog("Open Backup File", $s_Backup_Dir, "IDM Backup File (*.ibf)|All Files(*.*)", 3, "*.ibf", $hGUI_BM)
	If @error Then
	Else
		GUICtrlSetState($h_Button_Restore, $GUI_ENABLE)
		GUICtrlSetData($h_Input_Restore_Path, $s_Restore_File)
	EndIf
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
	_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
EndFunc   ;==>_ChooseRestoreFile

Func _Restore()
	FileWriteLine($s_Log_File, "")
	FileWriteLine($s_Log_File, "============================= Restore Session Started =============================")
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Restoring...")
	_ControlUpdateBusy()
	_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusWorking);StatusWorking
	_CleanINInReg()

	#region ;/Define Some variable: $s_Restore_File
	Local $s_Restore_File = GUICtrlRead($h_Input_Restore_Path)
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: $s_Restore_File= " & '"' & $s_Restore_File & '"')

	If Not FileExists($s_Restore_File) Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Backup File Not Found")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
		_ControlUpdateDefault()
		Return SetError(1)
	EndIf

	If GUICtrlRead($h_Checkbox_UnFinished_SD_Restore) = $GUI_UNCHECKED _
			And GUICtrlRead($h_Checkbox_UnFinished_GD_Restore) = $GUI_UNCHECKED _
			And GUICtrlRead($h_Checkbox_UnFinished_HL_Restore) = $GUI_UNCHECKED _
			And GUICtrlRead($h_Checkbox_UnFinished_DD_Restore) = $GUI_UNCHECKED _
			And GUICtrlRead($h_Checkbox_Listl_Restore) = $GUI_UNCHECKED _
			And GUICtrlRead($h_Checkbox_Full_Restore) = $GUI_UNCHECKED Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Select Restore Type")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
		_ControlUpdateDefault()
		Return SetError(1)
	EndIf

	Local $s_Password
	If GUICtrlRead($h_Checkbox_Password_Restore) = $GUI_CHECKED Then
		$s_Password = GUICtrlRead($h_Input_Password_Restore)
		If StringInStr($s_Password, """") Or StringInStr($s_Password, '''') Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Password Dosen't Contain Double Quote or Single Quote")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusWarning);StatusWarning
			FileWriteLine($s_Log_File, _Current_Moment() & "Password Dosen't Contain Double Quote or Single Quote")
			_ControlUpdateDefault()
			Return SetError(1)
		EndIf
	Else
		$s_Password = ""
	EndIf
	#endregion ;/Define Some variable: $s_Restore_File

	#region ;/Check Backup File, Read Guest ini setting and Check For Password
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Reading Backup File Please Wait...")

	_ResetDataAray($aData)
	$aData[13] = "idm_guest_Setting.ini"
	$aData[14] = "IDMregistry.reg"

	_7ZipStartup()
	_7ZipSetOwnerWindowEx($hGUI_BM, "_ARCHIVERPROC")
	Local $foo = _7ZipExtractEx($hGUI_BM, $s_Restore_File, @TempDir, $aData, $s_Password);Extract ini,reg File -> Check For Password

	If $foo <> 0 And FileExists($s_ini_File) Then ;Check if INI available and Succeful Extract

;~ 		Local $Guest_AppDataIDMFolder = IniRead($s_ini_File, "Default", "AppDataIDMFolder", "") ;True C:\Users\Tejas\AppData\Roaming\IDM\
;~ 		Local $Guest_TempPath = IniRead($s_ini_File, "Default", "TempPath", "");C:\Users\Tejas\AppData\Roaming\IDM\DwnlData\
;~ 		Local $Guest_IDMver = IniRead($s_ini_File, "Default", "idmvers", "");v6.07b10 Full
;~ 		Local $Guest_Keys = IniRead($s_ini_File, "Default", "Keys", "");1191
;~ 		Local $Guest_Password = IniRead($s_ini_File, "Default", "Password", "");True
;~ 		Local $Guest_Mode = IniRead($s_ini_File, "Default", "Mode", "");Custom
		Local $Guest_Username = IniRead($s_ini_File, "Default", "Username", "");Tejas

		Local $Guest_DwnlData_Folder = IniRead($s_ini_File, "Default", "DwnlData_Folder", "True");True
		Local $Guest_Grabber_Folder = IniRead($s_ini_File, "Default", "Grabber_Folder", "True");True
		Local $Guest_GrabberData_Folder = IniRead($s_ini_File, "Default", "GrabberData_Folder", "True");True
		Local $Guest_Scheduler_Folder = IniRead($s_ini_File, "Default", "Scheduler_Folder", "True");True
		Local $Guest_History_Files = IniRead($s_ini_File, "Default", "History_Files", "True");True

		If $s_Password = "" Then FileWriteLine($s_Log_File, _Current_Moment() & "Info: Backup Files is Not Password Protected")
	Else
		If GUICtrlRead($h_Checkbox_Password_Restore) = $GUI_CHECKED Then
			If GUICtrlRead($h_Input_Password_Restore) = "" Then
				_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Enter Password")
				_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
				FileWriteLine($s_Log_File, _Current_Moment() & "Error: Password Protected Backup Please Enter The Password")
				_ControlUpdateDefault()
				Return SetError(1)
			Else
				_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Incorrect Password or File May Be Damaged.")
				_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
				FileWriteLine($s_Log_File, _Current_Moment() & "Error: INI File Not Found. INI File Not Found Inside Backup File or Backup File May Be Damaged!")
				_ControlUpdateDefault()
				Return SetError(1)
			EndIf
		Else
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Check Checkbox --> Enter Password")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
			FileWriteLine($s_Log_File, _Current_Moment() & "Error: Password Protected Backup Please Check Checkbox and Enter The Password")
			_ControlUpdateDefault()
			Return SetError(1)
		EndIf
	EndIf
	#endregion ;/Check Backup File, Read Guest ini setting and Check For Password

	#region ;/Remove TempPath--->

	;if Append/Merge Not Selected then Pre Delete as per Componments
	If GUICtrlRead($h_Checkbox_Append_Registry_Restore) = $GUI_UNCHECKED Then

		If GUICtrlRead($h_Checkbox_UnFinished_DD_Restore) = $GUI_CHECKED Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Removing: TempPath Please Wait...")
			If $Guest_DwnlData_Folder = "True" Then _FileOrFolderDeleteWithLog($DwnlData_Folder)
		EndIf

		If GUICtrlRead($h_Checkbox_UnFinished_GD_Restore) = $GUI_CHECKED Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Removing: Grabber Folder Please Wait...")
			If $Guest_Grabber_Folder = "True" Then _FileOrFolderDeleteWithLog($Grabber_Folder)

			_GUICtrlStatusBar_SetText($h_Status_Info, "Removing: GrabberData Folder Please Wait...")
			If $Guest_GrabberData_Folder = "True" Then _FileOrFolderDeleteWithLog($GrabberData_Folder)
		EndIf

		If GUICtrlRead($h_Checkbox_UnFinished_SD_Restore) = $GUI_CHECKED Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Removing: Scheduler Folder Please Wait...")
			If $Guest_Scheduler_Folder = "True" Then _FileOrFolderDeleteWithLog($Scheduler_Folder)
		EndIf

		If GUICtrlRead($h_Checkbox_UnFinished_HL_Restore) = $GUI_CHECKED Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Removing: History And Logs Please Wait...")
			If $Guest_History_Files = "True" Then
				_FileOrFolderDeleteWithLog($UrlHistory_txt_File)
				_FileOrFolderDeleteWithLog($UrlHistory2_txt_File)
				_FileOrFolderDeleteWithLog($GlobalErrors_log_File)
				_FileOrFolderDeleteWithLog($urlexclist_dat_File)
				_FileOrFolderDeleteWithLog($defextmap_dat_File)
				_FileOrFolderDeleteWithLog($foldresHistory_txt_File)
				_FileOrFolderDeleteWithLog($sts_list_dat_File)
				_FileOrFolderDeleteWithLog($cnlurllist_dat_File)
				_FileOrFolderDeleteWithLog($Sound_Folder)
			EndIf
		EndIf
	EndIf
	#endregion ;/Remove TempPath--->

	#region ;/define Restore type--->
	Local $b_DwnlData_Folder = False
	Local $b_Grabber_Folder = False
	Local $b_Scheduler_Folder = False
	Local $b_History_Files = False

	If GUICtrlRead($h_Checkbox_Full_Restore) = $GUI_CHECKED Then ;Full Restore
		$b_DwnlData_Folder = True
		$b_Grabber_Folder = True
		$b_Scheduler_Folder = True
		$b_History_Files = True
	Else
		If GUICtrlRead($h_Checkbox_UnFinished_DD_Restore) = $GUI_CHECKED Then $b_DwnlData_Folder = True
		If GUICtrlRead($h_Checkbox_UnFinished_GD_Restore) = $GUI_CHECKED Then $b_Grabber_Folder = True
		If GUICtrlRead($h_Checkbox_UnFinished_SD_Restore) = $GUI_CHECKED Then $b_Scheduler_Folder = True
		If GUICtrlRead($h_Checkbox_UnFinished_HL_Restore) = $GUI_CHECKED Then $b_History_Files = True
	EndIf
	#endregion ;/define Restore type--->

	#region ;/Restore Data--->

	_ResetDataAray($aData)

	#region Restore part-1

	#region Restore DwnlData\
	;If Unfinished Download Data Selectde Then
	If $b_DwnlData_Folder Then
		If $Guest_DwnlData_Folder = "True" Then
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_DwnlData_Folder= " & '"' & $Guest_DwnlData_Folder & '"')
			$aData[0] = "DwnlData" & "\"
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_DwnlData_Folder= " & '"' & $Guest_DwnlData_Folder & '"')
		EndIf
	EndIf
	#endregion Restore DwnlData\

	#region Restore GrabberData\
	;If Grabber Data Selectde Then
	If $b_Grabber_Folder Then
		If $Guest_Grabber_Folder = "True" Then
			$aData[1] = "Grabber" & "\"
		EndIf
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_Grabber_Folder= " & '"' & $Guest_Grabber_Folder & '"')

		If $Guest_GrabberData_Folder = "True" Then
			$aData[2] = "GrabberData" & "\"
		EndIf
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_GrabberData_Folder= " & '"' & $Guest_GrabberData_Folder & '"')
	EndIf
	#endregion Restore GrabberData\

	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Restoring DwnlData & GrabberData Folder Please Wait...")
	_GUICtrlStatusBar_SetText($h_Status_Info, "Restoring: DwnlData & GrabberData Folder Please Wait...")
	$foo = _7ZipExtractEx($hGUI_BM, $s_Restore_File, $s_TempPath, $aData, $s_Password)

	Local $sFile = StringSplit($foo, @CRLF, 1)
	For $i = 1 To $sFile[0]
		If $sFile[$i] <> "" Then FileWriteLine($s_Log_File, _Current_Moment() & "7z Log: = " & $sFile[$i])
	Next
	#endregion Restore part-1

	_ResetDataAray($aData)
	_GUICtrlStatusBar_SetText($h_Status_Info, "Removing: Files and Folder Please Wait...")

	#region Restore part-2
	#region Restore Scheduler\
	;If Scheduler Data Selectde Then
	If $b_Scheduler_Folder Then
		If $Guest_Scheduler_Folder = "True" Then
			$aData[3] = "Scheduler" & "\"
		EndIf
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_Scheduler_Folder= " & '"' & $Guest_Scheduler_Folder & '"')
	EndIf
	#endregion Restore Scheduler\

	#region Restore History_Files
	;If History_Files Selectde Then
	If $b_History_Files Then
		If $Guest_History_Files = "True" Then
			$aData[4] = "UrlHistory.txt"
			$aData[5] = "UrlHistory2.txt"
			$aData[6] = "GlobalErrors.log"
			$aData[7] = "urlexclist.dat"
			$aData[8] = "defextmap.dat"
			$aData[9] = "foldresHistory.txt"
			$aData[10] = "sts_list.dat"
			$aData[11] = "cnlurllist.dat"
			$aData[12] = "Sounds" & "\"
		EndIf
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_History_Files= " & '"' & $Guest_History_Files & '"')
	EndIf
	#endregion Restore History_Files

	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Restoring AppDataIDMFolder Folder Please Wait...")
	_GUICtrlStatusBar_SetText($h_Status_Info, "Restoring: AppDataIDMFolder Folder Please Wait...")

	$foo = _7ZipExtractEx($hGUI_BM, $s_Restore_File, $s_AppDataIDMFolder, $aData, $s_Password)

	$sFile = StringSplit($foo, @CRLF, 1)
	For $i = 1 To $sFile[0]
		If $sFile[$i] <> "" Then FileWriteLine($s_Log_File, _Current_Moment() & "7z Log: = " & $sFile[$i])
	Next
	#endregion Restore part-2

	_7ZipShutdown()
	#endregion ;/Restore Data--->

	#region ;/Remove Temp Registry File--->
	If _RegKeyExists($s_regpath_IDM & "_tmp") Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "Removing: Temp Registry Please Wait...")
		If Not RegDelete($s_regpath_IDM & "_tmp") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete Registry " & "=" & ' "' & $s_regpath_IDM & "_tmp" & '" ' & "Error Code:" & @error)
	EndIf
	#endregion ;/Remove Temp Registry File--->

	#region ;/CAppend/Merge--->
	;Append/Merge Registry Checkbox Is Checked Then
	If GUICtrlRead($h_Checkbox_Append_Registry_Restore) = $GUI_CHECKED Then
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Appending/Merging Profile")

		_GUICtrlStatusBar_SetText($h_Status_Info, "Appending/Merging: Profile Please Wait...")
		_AppendRegKeys()
		If @error Then FileWriteLine($s_Log_File, _Current_Moment() & "Error: Error Occured during Appending/Merging Profile Error Code:" & @error)
	Else
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Append/Merge Profile Not Selected.")
	EndIf
	#endregion ;/CAppend/Merge--->

	#region ;/Convert Profile--->
	;Convert Registry Checkbox Is Checked Then
	If GUICtrlRead($h_Checkbox_Convert_Registry_Restore) = $GUI_CHECKED Then

		;Registry Renames
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Converting Registry Profile")

		_GUICtrlStatusBar_SetText($h_Status_Info, "Converting: Profile Please Wait...")

		_ConvertRegProfile()
		If @error Then FileWriteLine($s_Log_File, _Current_Moment() & "Error: Error Occured during Converting Profile Error Code:" & @error)

		;Folder Renames
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Converting Folder Profile")

		If FileExists($DwnlData_Folder & $Guest_Username) Then
			DirMove($DwnlData_Folder & $Guest_Username, $DwnlData_Folder & @UserName)
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Renaming-->" & $DwnlData_Folder & $Guest_Username)
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: To-->" & $DwnlData_Folder & @UserName & " Error Code" & @error)
		EndIf
		If FileExists($DwnlData_Folder & "GrabberData\" & $Guest_Username) Then
			DirMove($DwnlData_Folder & "GrabberData\" & $Guest_Username, $DwnlData_Folder & "GrabberData\" & @UserName)
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Renaming-->" & $DwnlData_Folder & "GrabberData\" & $Guest_Username)
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: To-->" & $DwnlData_Folder & "GrabberData\" & @UserName & " Error Code" & @error)
		EndIf
	Else
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Profile Conversion Not Selected.")
	EndIf
	#endregion ;/Convert Profile--->

	#region ;/Read Host Registry and store in tmp Registory(Free From Registry Conversion)--->
	If GUICtrlRead($h_Checkbox_Convert_Registry_Restore) = $GUI_CHECKED Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "Creating: Temp Registry Please Wait...")
		If _RegKeyExists($s_regpath_IDM) Then _RegCopyKeyNoTree($s_regpath_IDM, $s_regpath_IDM & "_tmp")

		If _RegKeyExists($s_regpath_IDM & "\" & "ConfigTime") Then _RegCopyKey($s_regpath_IDM & "\" & "ConfigTime", $s_regpath_IDM & "_tmp" & "\" & "ConfigTime")
		If _RegKeyExists($s_regpath_IDM & "\" & "DwnlPanel") Then _RegCopyKey($s_regpath_IDM & "\" & "DwnlPanel", $s_regpath_IDM & "_tmp" & "\" & "DwnlPanel")
		If _RegKeyExists($s_regpath_IDM & "\" & "DwnlSelPanel") Then _RegCopyKey($s_regpath_IDM & "\" & "DwnlSelPanel", $s_regpath_IDM & "_tmp" & "\" & "DwnlSelPanel")
		If _RegKeyExists($s_regpath_IDM & "\" & "FoldersTree") Then _RegCopyKey($s_regpath_IDM & "\" & "FoldersTree", $s_regpath_IDM & "_tmp" & "\" & "FoldersTree")
		If _RegKeyExists($s_regpath_IDM & "\" & "GetAllDlgLS") Then _RegCopyKey($s_regpath_IDM & "\" & "GetAllDlgLS", $s_regpath_IDM & "_tmp" & "\" & "GetAllDlgLS")
		If $Guest_GrabberData_Folder = "False" Then
			If _RegKeyExists($s_regpath_IDM & "\" & "GrabberDlgLS") Then _RegCopyKey($s_regpath_IDM & "\" & "GrabberDlgLS", $s_regpath_IDM & "_tmp" & "\" & "GrabberDlgLS")
			If _RegKeyExists($s_regpath_IDM & "\" & "GrabberSts") Then _RegCopyKey($s_regpath_IDM & "\" & "GrabberSts", $s_regpath_IDM & "_tmp" & "\" & "GrabberSts")
		EndIf
		If _RegKeyExists($s_regpath_IDM & "\" & "IDMBI") Then _RegCopyKey($s_regpath_IDM & "\" & "IDMBI", $s_regpath_IDM & "_tmp" & "\" & "IDMBI")
		If _RegKeyExists($s_regpath_IDM & "\" & "ListSettings") Then _RegCopyKey($s_regpath_IDM & "\" & "ListSettings", $s_regpath_IDM & "_tmp" & "\" & "ListSettings")
		If _RegKeyExists($s_regpath_IDM & "\" & "maxID") Then _RegCopyKey($s_regpath_IDM & "\" & "maxID", $s_regpath_IDM & "_tmp" & "\" & "maxID")
		If _RegKeyExists($s_regpath_IDM & "\" & "MCN") Then _RegCopyKey($s_regpath_IDM & "\" & "MCN", $s_regpath_IDM & "_tmp" & "\" & "MCN")
		If _RegKeyExists($s_regpath_IDM & "\" & "menuExt") Then _RegCopyKey($s_regpath_IDM & "\" & "menuExt", $s_regpath_IDM & "_tmp" & "\" & "menuExt")
		If _RegKeyExists($s_regpath_IDM & "\" & "netApps") Then _RegCopyKey($s_regpath_IDM & "\" & "netApps", $s_regpath_IDM & "_tmp" & "\" & "netApps")
		If _RegKeyExists($s_regpath_IDM & "\" & "Passwords") Then _RegCopyKey($s_regpath_IDM & "\" & "Passwords", $s_regpath_IDM & "_tmp" & "\" & "Passwords")
		If _RegKeyExists($s_regpath_IDM & "\" & "Queue") Then _RegCopyKey($s_regpath_IDM & "\" & "Queue", $s_regpath_IDM & "_tmp" & "\" & "Queue")
		If $Guest_Scheduler_Folder = "False" Then
			If _RegKeyExists($s_regpath_IDM & "\" & "Scheduler") Then _RegCopyKey($s_regpath_IDM & "\" & "Scheduler", $s_regpath_IDM & "_tmp" & "\" & "Scheduler")
		EndIf
		If _RegKeyExists($s_regpath_IDM & "\" & "SpecialKeys") Then _RegCopyKey($s_regpath_IDM & "\" & "SpecialKeys", $s_regpath_IDM & "_tmp" & "\" & "SpecialKeys")
	EndIf
	#endregion ;/Read Host Registry and store in tmp Registory(Free From Registry Conversion)--->

	#region ;/Remove Host Registry--->
	;if Append/Merge Not Selected then
	If GUICtrlRead($h_Checkbox_Append_Registry_Restore) = $GUI_UNCHECKED Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "Removing: Registry Please Wait...")
		If _RegKeyExists($s_regpath_IDM) Then
			If Not RegDelete($s_regpath_IDM) Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete Host Registry " & "=" & ' "' & $s_regpath_IDM & '" ' & "Error Code:" & @error)
		EndIf
	EndIf
	#endregion ;/Remove Host Registry--->

	#region ;/Restore Guest Registry-->
	_GUICtrlStatusBar_SetText($h_Status_Info, "Restoring: Registry Please Wait...")
	;If Registry Restore allowed via Checkbox
	_RegImport($s_reg_File)
	#endregion ;/Restore Guest Registry-->

	#region ;/Restore Host Registry from stored in tmp Registry--->
	If GUICtrlRead($h_Checkbox_Convert_Registry_Restore) = $GUI_CHECKED Then

		_GUICtrlStatusBar_SetText($h_Status_Info, "Restoring: Host Registry To tmp Registry  Please Wait...")

		If _RegKeyExists($s_regpath_IDM & "_tmp") Then
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Restoring Host Registry From Stored in tmp Registry")
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: tmp Registry " & "=" & ' "' & $s_regpath_IDM & "_tmp" & '" ')

			_RegCopyKeyNoTree($s_regpath_IDM & "_tmp", $s_regpath_IDM)
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Copied Registry Key " & "=" & ' "' & $s_regpath_IDM & "_tmp" & " to " & $s_regpath_IDM & '" ' & "Error Code:" & @error)

			_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "ConfigTime", $s_regpath_IDM & "\" & "ConfigTime")
			_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "DwnlPanel", $s_regpath_IDM & "\" & "DwnlPanel")
			_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "DwnlSelPanel", $s_regpath_IDM & "\" & "DwnlSelPanel")

			If _RegKeyExists($s_regpath_IDM & "_tmp" & "\" & "FoldersTree") Then
				_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "FoldersTree", $s_regpath_IDM & "\" & "FoldersTree")
			Else
				FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Found" & "=" & ' "' & $s_regpath_IDM & "_tmp" & "\" & "FoldersTree" & '" ')
				Local $key
				$i = 1
				While 1
					$key = RegEnumKey($s_regpath_IDM & "\FoldersTree\", $i)
					If @error <> 0 Then ExitLoop

					If _RegValueExists($s_regpath_IDM & "\FoldersTree\" & $key, "pathW") Then
						If Not _RegDeleteValue($s_regpath_IDM & "\FoldersTree\" & $key, "pathW") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete Registry " & "=" & ' "' & $s_regpath_IDM & "\FoldersTree\" & $key & "-->" & "pathW" & '" ' & "Error Code:" & @error)
					EndIf

					$i += 1
				WEnd
			EndIf

			_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "GetAllDlgLS", $s_regpath_IDM & "\" & "GetAllDlgLS")

			If $Guest_GrabberData_Folder = "False" Then
				_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "GrabberDlgLS", $s_regpath_IDM & "\" & "GrabberDlgLS")
				_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "GrabberSts", $s_regpath_IDM & "\" & "GrabberSts")
			EndIf

			_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "IDMBI", $s_regpath_IDM & "\" & "IDMBI")
			_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "ListSettings", $s_regpath_IDM & "\" & "ListSettings")
			_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "maxID", $s_regpath_IDM & "\" & "maxID")
			_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "MCN", $s_regpath_IDM & "\" & "MCN")
			_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "menuExt", $s_regpath_IDM & "\" & "menuExt")
			_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "netApps", $s_regpath_IDM & "\" & "netApps")
			_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "Passwords", $s_regpath_IDM & "\" & "Passwords")
			_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "Queue", $s_regpath_IDM & "\" & "Queue")

			If $Guest_Scheduler_Folder = "False" Then
				_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "Scheduler", $s_regpath_IDM & "\" & "Scheduler")
			EndIf

			_CopyRegTempKeyWithLog($s_regpath_IDM & "_tmp" & "\" & "SpecialKeys", $s_regpath_IDM & "\" & "SpecialKeys")
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: tmp Registry Not Exists " & "=" & ' "' & $s_regpath_IDM & "_tmp" & '" ')
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Removing Some Un Used Registry Key...")

			If _RegValueExists($s_regpath_IDM, "LocalPathW") Then
				If Not _RegDeleteValue($s_regpath_IDM, "LocalPathW") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete Registry " & "=" & ' "' & $s_regpath_IDM & "-->" & "LocalPathW" & '" ' & "Error Code:" & @error)
			EndIf

			$i = 1
			While 1
				$key = RegEnumKey($s_regpath_IDM & "\FoldersTree\", $i)
				If @error <> 0 Then ExitLoop

				If _RegValueExists($s_regpath_IDM & "\FoldersTree\" & $key, "pathW") Then
					If Not _RegDeleteValue($s_regpath_IDM & "\FoldersTree\" & $key, "pathW") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete Registry " & "=" & ' "' & $s_regpath_IDM & "\FoldersTree\" & $key & "-->" & "pathW" & '" ' & "Error Code:" & @error)
				EndIf

				$i += 1
			WEnd
		EndIf
	EndIf

	_RegWrite($s_regpath_IDM, "AppDataIDMFolder", $REG_SZ, $s_AppDataIDMFolder)
	_RegWrite($s_regpath_IDM, "TempPath", $REG_SZ, $s_TempPath)
	_RegWrite($s_regpath_IDM & "\maxID", "maxID", $REG_DWORD, _iGetMaxKey($s_regpath_IDM))
	#endregion ;/Restore Host Registry from stored in tmp Registry--->

	#region ;/Remove tmp Registry--->
	_GUICtrlStatusBar_SetText($h_Status_Info, "Removing: Temp Registry Please Wait...")
	If _RegKeyExists($s_regpath_IDM & "_tmp") Then
		If Not RegDelete($s_regpath_IDM & "_tmp") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete Registry " & "=" & ' "' & $s_regpath_IDM & "_tmp" & '" ' & "Error Code:" & @error)
	EndIf
	#endregion ;/Remove tmp Registry--->

	_CleanINInReg()

	If $b_RestartIDM Then _RunIDMexe()

	_ControlUpdateDefault()
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Done")
	_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
	FileWriteLine($s_Log_File, "============================= Restore Session Ended =============================")
EndFunc   ;==>_Restore
#endregion Restore

Func _SwCMDLineMSGBOX()
	Local $ParentWin = ""
	If IsHWnd($hGUI_BM) Then $ParentWin = $hGUI_BM
	MsgBox(64, "Info", "Command Line Parameters:" & @CRLF & _
			"" & @CRLF & _
			"USAGE:" & @CRLF & _
			"IDM Backup Manager.exe 	[swlm] [swdc] [swpwc] [swft]" & @CRLF & _
			"			[backup <file path>]" & @CRLF & _
			"			[restore <file path>]" & @CRLF & _
			"" & @CRLF & _
			"Where:" & @CRLF & _
			"	swlm 		Run IDM List Manager" & @CRLF & _
			"	swdc 		Run Data Cleaner" & @CRLF & _
			"	swpwc		Run Password Cleaner" & @CRLF & _
			"	swft		Run FileType" & @CRLF & "" & @CRLF & _
			"	backup		Run Backup" & @CRLF & _
			"	restore		Run Restore", 0, $ParentWin)
EndFunc   ;==>_SwCMDLineMSGBOX