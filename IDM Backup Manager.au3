#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\icon.ico
#AutoIt3Wrapper_Outfile=bin\IDM Backup Manager.exe
#AutoIt3Wrapper_Outfile_x64=bin\IDM Backup Manager_x64.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Description=IDM Backup Manager
#AutoIt3Wrapper_Res_Fileversion=1.1.0.0
#AutoIt3Wrapper_Res_ProductVersion=1.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright (c) 2012-2016, Gajjar Tejas
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Res_Icon_Add=Resources\Backup.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\open.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\Forum.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\Help.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\Internet.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\License.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\History.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\Ok.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\ok32.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\Restore.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\search.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\Tool.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\Update.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\FileType.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\Save.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\Setting.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\refresh.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\Log.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\StatusInfo.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\StatusWarning.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\StatusCompled.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\StatusError.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\StatusWorking.ico
#AutoIt3Wrapper_Res_File_Add=Resources\facebook.jpg, rt_rcdata, facebooklogo
#AutoIt3Wrapper_Res_File_Add=Resources\twitter.jpg, rt_rcdata, twitterlogo
#AutoIt3Wrapper_Res_File_Add=Resources\instagram.jpg, rt_rcdata, instagramlogo
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region Includes
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Date.au3>

#include "Includes\_AET_ButtonSetIcon.au3"
#include "Includes\_Resources.au3"
#include "Includes\_IsFilePathValid.au3"
#include "Includes\_RunWithReducedPrivileges.au3"
#include "Includes\_ShellFile_Install.au3"
#include "Includes\_7Zip.au3"
#include "Includes\_ProgressMarquee.au3"
#include "Includes\_IDM List Manager.au3"
#include "Includes\_MoveDirEx.au3"
#EndRegion Includes

_StartupBM()

#Region Main
Func _MainBM()
	If $b_CheckUpdate_Background Then _UpdateCheck(True)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg

			Case $GUI_EVENT_CLOSE
				_onExit()



			Case $h_Checkbox_Convert_Registry_Restore
				If GUICtrlRead($h_Checkbox_Convert_Registry_Restore) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Convert profile paths enabled for cross-system restore")
				Else
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Convert profile paths disabled")
				EndIf

			Case $h_Checkbox_Append_Registry_Restore
				If GUICtrlRead($h_Checkbox_Append_Registry_Restore) = $GUI_CHECKED Then
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Append/Merge enabled (preserve existing profile)")
				Else
					_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Append/Merge disabled (overwrite existing entries)")
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

				#Region BrowseLogFile
			Case $h_Button_BrowseLogFile_Setting
				_ShowMenu($hGUI_BM, $nMsg, $h_Button_BrowseLogFile_Setting_Context)

			Case $h_Button_BrowseLogFile_Setting_Context0
				_ChooseLogFile()

			Case $h_Button_BrowseLogFile_Setting_Context1
				_SelectFile(GUICtrlRead($h_Label_LogFile_Setting))
				#EndRegion BrowseLogFile

				#Region BrowseDataBackupFolder
			Case $h_Button_BrowseDataBackupFolder_Setting
				_ShowMenu($hGUI_BM, $nMsg, $h_Button_BrowseDataBackupFolder_Setting_Context)

			Case $h_Button_BrowseDataBackupFolder_Setting_Context0
				_ChooseDataBackupFolder()

			Case $h_Button_BrowseDataBackupFolder_Setting_Context1
				_SelectFile(GUICtrlRead($h_Label_BrowseDataBackupFolder_Setting))

				#EndRegion BrowseDataBackupFolder

				#Region BrowseAppDataFolder
			Case $h_Button_BrowseAppDataFolder_Setting
				_ShowMenu($hGUI_BM, $nMsg, $h_Button_BrowseAppDataFolder_Setting_Context)

			Case $h_Button_BrowseAppDataFolder_Setting_Context0
				_ChooseAppDataBackupFolder()

			Case $h_Button_BrowseAppDataFolder_Setting_Context1
				_SelectFile(GUICtrlRead($h_Label_BrowseAppDataFolder_Setting))
				#EndRegion BrowseAppDataFolder

				#Region TempDataFolder
			Case $h_Button_TempDataFolder_Setting
				_ShowMenu($hGUI_BM, $nMsg, $h_Button_TempDataFolder_Setting_Context)

			Case $h_Button_TempDataFolder_Setting_Context0
				_ChooseTempDataBackupFolder()

			Case $h_Button_TempDataFolder_Setting_Context1
				_SelectFile(GUICtrlRead($h_Label_DwnlDataFolder_Setting))
				#EndRegion TempDataFolder

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

			Case $h_Button_Restore_Archive_Info
				_SwFileInformation()

			Case $h_Button_Restore
				_Restore()

			Case $h_Tab1
				Local $iCurrentTab = GUICtrlRead($h_Tab1)
				Switch $iCurrentTab
					Case 2 ; Downloads
						If Not $b_LM_Loaded Then
							$b_LM_Loaded = True
							_Analyze()
						EndIf
					Case 3 ; Cleaner
						_UpdatePwCleanerCount()
					Case 4 ; Categories
						_LoadFileCategories()
				EndSwitch

			; Tab 3: Downloads Manager
			Case $h_Button_LM_Refresh
				_Analyze()

			Case $h_Button_LM_OpenFolder
				_Open_Folder()

			Case $h_Button_LM_ForceJoin
				If _Join_Fragments() = -2 Then MsgBox(48, "Error", "At Least 2 Fragment Required To Join It.", 0, $hGUI_BM)

			Case $h_Button_LM_Remove
				_Remove()

			Case $h_Button_LM_Export
				_ShowMenu($hGUI_BM, $h_Button_LM_Export, $h_Button_LM_Export_Context)

			Case $h_MenuItem_LM_Export_CSV
				_Expert_CSV()

			Case $h_MenuItem_LM_Export_HTML
				_Expert_HTML()

			Case $h_MenuItem_LM_Export_TXT
				_Expert_IDM_TXT()

			Case $h_MenuItem_LM_Export_IDM
				_Expert_IDM_LIST()

			Case $h_Input_LM_Search
				_SearchDownloadsList(GUICtrlRead($h_Input_LM_Search))

			Case $h_Button_LM_SearchClear
				GUICtrlSetData($h_Input_LM_Search, "")
				_Analyze()

			; Tab 4: Cleaner (Data & Passwords)
			Case $h_Radio_Clean_Custom
				GUICtrlSetState($h_Checkbox_Clean_DD, $GUI_ENABLE)
				GUICtrlSetState($h_Checkbox_Clean_GD, $GUI_ENABLE)
				GUICtrlSetState($h_Checkbox_Clean_SD, $GUI_ENABLE)
				GUICtrlSetState($h_Checkbox_Clean_HL, $GUI_ENABLE)

			Case $h_Radio_Clean_Full
				GUICtrlSetState($h_Checkbox_Clean_DD, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_Clean_GD, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_Clean_SD, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_Clean_HL, $GUI_DISABLE)

			Case $h_Button_Clean_Analyze
				_CleanAnalyze()

			Case $h_Button_Clean_Now
				_CleanExecute()

			Case $h_Button_PwCleaner_Refresh
				_UpdatePwCleanerCount()

			Case $h_Button_PwCleaner_Clear
				_ClearAllPasswords()

			; Tab 5: Categories
			Case $h_Checkbox_Cat_Compressed
				If GUICtrlRead($h_Checkbox_Cat_Compressed) = $GUI_CHECKED Then
					GUICtrlSetState($h_Input_Cat_Compressed, $GUI_ENABLE)
				Else
					GUICtrlSetState($h_Input_Cat_Compressed, $GUI_DISABLE)
				EndIf

			Case $h_Checkbox_Cat_Documents
				If GUICtrlRead($h_Checkbox_Cat_Documents) = $GUI_CHECKED Then
					GUICtrlSetState($h_Input_Cat_Documents, $GUI_ENABLE)
				Else
					GUICtrlSetState($h_Input_Cat_Documents, $GUI_DISABLE)
				EndIf

			Case $h_Checkbox_Cat_Music
				If GUICtrlRead($h_Checkbox_Cat_Music) = $GUI_CHECKED Then
					GUICtrlSetState($h_Input_Cat_Music, $GUI_ENABLE)
				Else
					GUICtrlSetState($h_Input_Cat_Music, $GUI_DISABLE)
				EndIf

			Case $h_Checkbox_Cat_Programs
				If GUICtrlRead($h_Checkbox_Cat_Programs) = $GUI_CHECKED Then
					GUICtrlSetState($h_Input_Cat_Programs, $GUI_ENABLE)
				Else
					GUICtrlSetState($h_Input_Cat_Programs, $GUI_DISABLE)
				EndIf

			Case $h_Checkbox_Cat_Video
				If GUICtrlRead($h_Checkbox_Cat_Video) = $GUI_CHECKED Then
					GUICtrlSetState($h_Input_Cat_Video, $GUI_ENABLE)
				Else
					GUICtrlSetState($h_Input_Cat_Video, $GUI_DISABLE)
				EndIf

			Case $h_Button_Cat_Save
				_SaveCategories()

			Case $h_Button_Cat_Enhance
				_EnhanceCategories()

			Case $h_Button_Cat_Default
				_RestoreDefaultCategories()

			Case $h_Button_More_Setting
				_SwMoreSettingGUI()

			Case $h_Button_Version_History_Help
				_SwHistory()

			Case $h_Button_Licence_Help
				_SwLicense()

			Case $h_Button_Update_Help
				_UpdateCheck()

			Case $h_Button_Help_Help
				_SwHelp()

			Case $h_Button_Website_Help
				ShellExecute($s_URL_Website)

			Case $h_Button_Forum_Help
				ShellExecute($s_URL_Issues)

			Case $h_Button_Associate_Setting
				_ShellInstall()

			Case $h_Picture_Facebook_About
				ShellExecute($s_URL_Facebook)

			Case $h_Picture_Twitter_About
				ShellExecute($s_URL_Twitter)

			Case $h_Picture_Instagram_About
				ShellExecute($s_URL_Instagram)

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
		$b_CheckUpdate_Background = Number(IniRead($s_Setting_File, "More Setting", "CheckUpdate_Background", $b_CheckUpdate_Background))
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

Func _WarnAndCloseIDM()

	Local $ParentWin = ""
	If IsHWnd($hGUI_BM) Then $ParentWin = $hGUI_BM

	If ProcessExists("idman.exe") Then ;**** Check the process "idman.exe" exists or not ***
		Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox(36, "IDM Need To Close", "IDM is Running in Background. If Some File is Locked By IDM Backup/Restore Process Will Not Work Correctly. Do You Want To Close IDM?", 0, $ParentWin)
		Select
			Case $iMsgBoxAnswer = 6 ;Yes
				If ProcessClose("idman.exe") Then
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Internet Download Manager Is Closed By User.")
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Internet Download Manager Could Not Closed.")
				EndIf
			Case $iMsgBoxAnswer = 7 ;No
				FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Internet Download Manager Is Running. User Selected No.")
		EndSelect
	Else
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Internet Download Manager Is Not Running.")
	EndIf
EndFunc   ;==>_WarnAndCloseIDM

Func _LogProfilePaths()
	FileWriteLine($s_Log_File, "")
	FileWriteLine($s_Log_File, "============================= Check Profile ==================================")
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Finalized Path $AppDataIDMFolder= " & @TAB & '"' & $s_AppDataIDMFolder & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Finalized Path $s_TempPath= " & @TAB & @TAB & '"' & $s_TempPath & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Finalized Path $DwnlData_Folder= " & @TAB & @TAB & '"' & $DwnlData_Folder & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Finalized Path $GrabberData_Folder= " & @TAB & '"' & $GrabberData_Folder & '"')
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

Func _LogCmdLine()
	FileWriteLine($s_Log_File, "")
	FileWriteLine($s_Log_File, "============================= Command Line Check =============================")
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: No of Command Line Parameters Passed: " & $CmdLine[0])
EndFunc   ;==>_LogCmdLine

Func _StartupBM()
	_LogRemove()
	_LogCmdLine()
	Switch $CmdLine[0]
		Case 0
			_CheckSelfProcess()
			_CheckIni()
			_CheckComponment()
			_LogProfilePaths()
			_SwBMGUI()
			_MainBM()
		Case 1
			Switch $CmdLine[1]
				Case "swlm"
					_CheckSelfProcess()
					_CheckIni()
					_CheckComponment()
					_LogProfilePaths()
					_SwBMGUI()
					GUICtrlSetState($h_TabSheet3, $GUI_SHOW)
					_Analyze()
					_MainBM()
				Case "swdc"
					_CheckSelfProcess()
					_CheckIni()
					_CheckComponment()
					_LogProfilePaths()
					_SwBMGUI()
					GUICtrlSetState($h_TabSheet4, $GUI_SHOW)
					_MainBM()
				Case "swpwc"
					_CheckSelfProcess()
					_CheckIni()
					_CheckComponment()
					_LogProfilePaths()
					_SwBMGUI()
					GUICtrlSetState($h_TabSheet4, $GUI_SHOW)
					_MainBM()
				Case "swft"
					_CheckSelfProcess()
					_CheckIni()
					_CheckComponment()
					_LogProfilePaths()
					_SwBMGUI()
					GUICtrlSetState($h_TabSheet5, $GUI_SHOW)
					_MainBM()
				Case Else
					If FileExists($CmdLine[1]) Then
						_CheckSelfProcess()
						_CheckIni()
						_CheckComponment()
						_LogProfilePaths()
						_SwBMGUI()
						_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
						GUICtrlSetState($h_Button_Restore, $GUI_ENABLE)
						GUICtrlSetState($h_Button_Restore_Archive_Info, $GUI_ENABLE)
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
						_LogProfilePaths()
						_SwBMGUI()
						_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
						GUICtrlSetState($h_Button_Restore, $GUI_ENABLE)
						GUICtrlSetState($h_Button_Restore_Archive_Info, $GUI_ENABLE)

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
#EndRegion Main

#Region control Functions
Func _ControlUpdateBusy()
	GUICtrlSetState($h_Tab1, $GUI_DISABLE)

	#Region ;for backup
	GUICtrlSetState($h_Input_Backup_Path, $GUI_DISABLE)
	GUICtrlSetState($h_Button_Browse_Backup, $GUI_DISABLE)

	GUICtrlSetState($h_Input_Password_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Combo_Compression_Level_Backup, $GUI_DISABLE)

	GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_DISABLE)

	GUICtrlSetState($h_Button_Backup, $GUI_DISABLE)
	#EndRegion ;for backup

	#Region  ;for Restore
	GUICtrlSetState($h_Input_Restore_Path, $GUI_DISABLE)
	GUICtrlSetState($h_Button_Browse_Restore, $GUI_DISABLE)

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


	GUICtrlSetState($h_Button_Restore_Archive_Info, $GUI_DISABLE)
	GUICtrlSetState($h_Button_Restore, $GUI_DISABLE)
	#EndRegion  ;for Restore
EndFunc   ;==>_ControlUpdateBusy

Func _ControlUpdateDefault()
	GUICtrlSetState($h_Tab1, $GUI_ENABLE)
	WinActivate($s_Win_Title_BM)

	#Region ;for backup
	GUICtrlSetState($h_Input_Backup_Path, $GUI_ENABLE)
	GUICtrlSetState($h_Button_Browse_Backup, $GUI_ENABLE)

	GUICtrlSetState($h_Input_Password_Backup, $GUI_ENABLE)
	GUICtrlSetState($h_Combo_Compression_Level_Backup, $GUI_ENABLE)

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
	#EndRegion ;for backup

	#Region ;for restore
	GUICtrlSetState($h_Input_Restore_Path, $GUI_ENABLE)
	GUICtrlSetState($h_Button_Browse_Restore, $GUI_ENABLE)

	GUICtrlSetState($h_Input_Password_Restore, $GUI_ENABLE)
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

	If FileExists(GUICtrlRead($h_Input_Restore_Path)) Then
		GUICtrlSetState($h_Button_Restore, $GUI_ENABLE)
		GUICtrlSetState($h_Button_Restore_Archive_Info, $GUI_ENABLE)
	EndIf


	_GUICtrlStatusBar_SetText($h_Status_Info, "", 1)
	#EndRegion ;for restore
EndFunc   ;==>_ControlUpdateDefault
#EndRegion control Functions

#Region GUIS
Func _SwBMGUI()
	#Region ### START Koda GUI section ###

	$hGUI_BM = GUICreate($s_Win_Title_BM, $i_xWidth_BM, $i_yHight_BM, $i_xWinPos, $i_yWinPos)
	GUISetFont(9, 400, 0, "Segoe UI", $hGUI_BM)

	$h_Tab1 = GUICtrlCreateTab(10, 10, 620, 375)

	#Region backup ;==============================================================================================Backup:

	$h_TabSheet1 = GUICtrlCreateTabItem("Backup Data")
	_AET_TabSetIcon(-1, 1, -2)
	GUICtrlCreateGroup("Backup Destination", 24, 44, 592, 58)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")

	$h_Input_Backup_Path = GUICtrlCreateInput("", 36, 65, 528, 24, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$h_Button_Browse_Backup = GUICtrlCreateButton("", 572, 64, 32, 26)
	_AET_ButtonSetIcon(-1, 15, 16, 16, 4)
	GUICtrlSetTip(-1, "Choose destination backup file location (.ibf)", "Select Backup Location", 1, 1)

	GUICtrlCreateGroup("Backup Options", 24, 110, 592, 185)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")

	GUICtrlCreateLabel("Password (Optional):", 38, 132, 230, 16)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	$h_Input_Password_Backup = GUICtrlCreateInput("", 38, 150, 230, 24, $ES_PASSWORD)
	GUICtrlSendMsg(-1, $EM_SETCUEBANNER, True, "Password (Optional)")
	GUICtrlSetTip(-1, "Enter a password to encrypt this backup. Leave empty for no encryption (default).", "Backup Password", 1, 1)

	GUICtrlCreateLabel("Compression Level:", 38, 192, 230, 16)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	$h_Combo_Compression_Level_Backup = GUICtrlCreateCombo("1-No Compression", 38, 210, 230, 24, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "2-Fastest Compression|3-Fast Compression|4-Normal Compression|5-Maximum Compression|6-Ultra Compression", "1-No Compression")
	GUICtrlSetTip(-1, "Select backup compression level (default: 1-No Compression).", "Compression Level", 1, 1)

	$h_Checkbox_Full_Backup = GUICtrlCreateCheckbox("Full Backup", 310, 136, 130, 20)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetTip(-1, "Backup everything including downloads, lists, and settings", "Full Backup", 1, 1)

	$h_Checkbox_Listl_Backup = GUICtrlCreateCheckbox("Only List", 460, 136, 130, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Backup list of downloads without actual data files", "Only List Backup", 1, 1)

	$h_Checkbox_UnFinished_DD_Backup = GUICtrlCreateCheckbox("Downloaded Data", 310, 170, 140, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Backup downloaded files data", "Downloaded Data", 1, 1)

	$h_Checkbox_UnFinished_GD_Backup = GUICtrlCreateCheckbox("Grabber Data", 460, 170, 130, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Backup grabber project data", "Grabber Data", 1, 1)

	$h_Checkbox_UnFinished_SD_Backup = GUICtrlCreateCheckbox("Scheduler/Queues", 310, 204, 140, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Backup scheduler tasks and queue definitions", "Scheduler & Queues", 1, 1)

	$h_Checkbox_UnFinished_HL_Backup = GUICtrlCreateCheckbox("Other Data", 460, 204, 130, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Backup history, logs, and other IDM data", "Other Data", 1, 1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $h_Label_Backup_Tip = GUICtrlCreateLabel("💡 Choose destination and optional encryption before creating backup.", 36, 320, 410, 22)
	GUICtrlSetFont($h_Label_Backup_Tip, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_Backup_Tip, 0x666666)

	$h_Button_Backup = GUICtrlCreateButton("  Backup Now", 466, 312, 150, 38)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 8, 20, 20, 0)
	GUICtrlSetTip(-1, "Start IDM backup process now", "Backup Now", 1, 1)
	GUICtrlSetState(-1, $GUI_DISABLE)

	#EndRegion backup ;==============================================================================================Backup:

	#Region Restore ;==============================================================================================Restore:
	$h_TabSheet2 = GUICtrlCreateTabItem("Restore Data")
	_AET_TabSetIcon(-1, 10, -11)
	GUICtrlCreateGroup("Restore Source", 24, 44, 592, 58)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")

	$h_Input_Restore_Path = GUICtrlCreateInput("", 36, 65, 492, 24, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))

	$h_Button_Restore_Archive_Info = GUICtrlCreateButton("", 536, 64, 32, 26)
	_AET_ButtonSetIcon(-1, 19, 16, 16, 4)
	GUICtrlSetTip(-1, "Show information about the selected backup file", "Archive Info", 1, 1)
	GUICtrlSetState(-1, $GUI_DISABLE)

	$h_Button_Browse_Restore = GUICtrlCreateButton("", 572, 64, 32, 26)
	_AET_ButtonSetIcon(-1, 2, 16, 16, 4)
	GUICtrlSetTip(-1, "Browse for backup archive file (.ibf)", "Select Backup File", 1, 1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("Restore Options", 24, 110, 592, 185)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")

	GUICtrlCreateLabel("Password (if encrypted):", 38, 132, 230, 16)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	$h_Input_Password_Restore = GUICtrlCreateInput("", 38, 150, 230, 24, $ES_PASSWORD)
	GUICtrlSendMsg(-1, $EM_SETCUEBANNER, True, "Password (if encrypted)")
	GUICtrlSetTip(-1, "Enter password if your backup archive is encrypted (leave empty if not).", "Restore Password", 1, 1)

	$h_Checkbox_Convert_Registry_Restore = GUICtrlCreateCheckbox("Convert Profile Paths", 38, 192, 230, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetTip(-1, "Adapt profile and download paths when restoring onto a different computer or Windows account.", "Convert Profile", 1, 1)
	$h_Label_Convert_Registry_Restore = GUICtrlCreateDummy()

	$h_Checkbox_Append_Registry_Restore = GUICtrlCreateCheckbox("Append / Merge Data", 38, 222, 230, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetTip(-1, "Merge backup records with existing IDM data instead of replacing existing entries.", "Append/Merge Data", 1, 1)
	$h_Label_Append_Registry_Restore = GUICtrlCreateDummy()

	$h_Checkbox_Full_Restore = GUICtrlCreateCheckbox("Full Restore", 310, 136, 130, 20)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetTip(-1, "Restore everything from backup archive", "Full Restore", 1, 1)

	$h_Checkbox_Listl_Restore = GUICtrlCreateCheckbox("Only List", 460, 136, 130, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Restore list of downloads without actual data files", "Only List Restore", 1, 1)

	$h_Checkbox_UnFinished_DD_Restore = GUICtrlCreateCheckbox("Downloaded Data", 310, 170, 140, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Restore downloaded files data", "Downloaded Data", 1, 1)

	$h_Checkbox_UnFinished_GD_Restore = GUICtrlCreateCheckbox("Grabber Data", 460, 170, 130, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Restore grabber project data", "Grabber Data", 1, 1)

	$h_Checkbox_UnFinished_SD_Restore = GUICtrlCreateCheckbox("Scheduler/Queues", 310, 204, 140, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Restore scheduler tasks and queue definitions", "Scheduler & Queues", 1, 1)

	$h_Checkbox_UnFinished_HL_Restore = GUICtrlCreateCheckbox("Other Data", 460, 204, 130, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Restore history, logs, and other IDM data", "Other Data", 1, 1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $h_Label_Restore_Tip = GUICtrlCreateLabel("💡 Select an .ibf backup archive to restore IDM settings and download data.", 36, 320, 410, 22)
	GUICtrlSetFont($h_Label_Restore_Tip, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_Restore_Tip, 0x666666)

	$h_Button_Restore = GUICtrlCreateButton("  Restore Now", 466, 312, 150, 38)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 8, 20, 20, 0)
	GUICtrlSetTip(-1, "Start IDM restore process now", "Restore Now", 1, 1)
	GUICtrlSetState(-1, $GUI_DISABLE)

	#EndRegion Restore ;==============================================================================================Restore:

	#Region Downloads ;============================================================================================== Downloads:
	$h_TabSheet3 = GUICtrlCreateTabItem("Downloads")
	_AET_TabSetIcon(-1, 11, -12)

	$h_Button_LM_Refresh = GUICtrlCreateButton("  Refresh", 24, 42, 86, 28)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 17, 16, 16, 0)
	GUICtrlSetTip(-1, "Refresh and reload downloads list from IDM", "Refresh List", 1, 1)

	$h_Button_LM_OpenFolder = GUICtrlCreateButton("  Open Folder", 116, 42, 110, 28)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 2, 16, 16, 0)
	GUICtrlSetTip(-1, "Open folder containing selected downloaded file", "Open Folder", 1, 1)

	$h_Button_LM_ForceJoin = GUICtrlCreateButton("  Force Join", 232, 42, 100, 28)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 12, 16, 16, 0)
	GUICtrlSetTip(-1, "Join incomplete download file fragments together", "Force Join", 1, 1)

	$h_Button_LM_Remove = GUICtrlCreateButton("  Remove", 338, 42, 86, 28)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 22, 16, 16, 0)
	GUICtrlSetTip(-1, "Delete selected download entry and files", "Remove Download", 1, 1)

	$h_Button_LM_Export = GUICtrlCreateButton("  Export ▼", 430, 42, 94, 28)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 15, 16, 16, 0)
	GUICtrlSetTip(-1, "Export downloads list to HTML, CSV, TXT, or IDM format", "Export List", 1, 1)
	$h_Button_LM_Export_Context = GUICtrlCreateContextMenu($h_Button_LM_Export)
	$h_MenuItem_LM_Export_CSV = GUICtrlCreateMenuItem("Export to CSV Spreadsheet (.csv)", $h_Button_LM_Export_Context)
	$h_MenuItem_LM_Export_HTML = GUICtrlCreateMenuItem("Export to HTML Report (.htm)", $h_Button_LM_Export_Context)
	$h_MenuItem_LM_Export_TXT = GUICtrlCreateMenuItem("Export to IDM Text File (.txt)", $h_Button_LM_Export_Context)
	$h_MenuItem_LM_Export_IDM = GUICtrlCreateMenuItem("Export to IDM Export List (.ef2)", $h_Button_LM_Export_Context)

	$h_Input_LM_Search = GUICtrlCreateInput("", 24, 76, 554, 24)
	GUICtrlSendMsg(-1, $EM_SETCUEBANNER, True, "Search downloads by name, link, or ID (press Enter or type to filter)...")
	GUICtrlSetTip(-1, "Type search query and press Enter to filter list", "Filter Downloads", 1, 1)

	$h_Button_LM_SearchClear = GUICtrlCreateButton("✕", 584, 75, 32, 26)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")
	GUICtrlSetTip(-1, "Clear search and restore full downloads list", "Clear Filter", 1, 1)

	$idListView = GUICtrlCreateListView("No.|File Name|Size|MIME Type|ID|Download Link", 24, 108, 592, 260)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	$hListView = GUICtrlGetHandle($idListView)
	_GUICtrlListView_SetExtendedListViewStyle($idListView, BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT, $LVS_EX_INFOTIP, $LVS_EX_GRIDLINES, $LVS_EX_HEADERDRAGDROP))
	_WinAPI_SetWindowTheme($hListView, "Explorer")
	_GUICtrlListView_SetColumnWidth($idListView, 0, 38)
	_GUICtrlListView_SetColumnWidth($idListView, 1, 190)
	_GUICtrlListView_SetColumnWidth($idListView, 2, 75)
	_GUICtrlListView_SetColumnWidth($idListView, 3, 80)
	_GUICtrlListView_SetColumnWidth($idListView, 4, 45)
	_GUICtrlListView_SetColumnWidth($idListView, 5, 155)
	#EndRegion Downloads ;============================================================================================== Downloads:

	#Region Cleaner ;============================================================================================== Cleaner:
	$h_TabSheet4 = GUICtrlCreateTabItem("Cleaner")
	_AET_TabSetIcon(-1, 17, -18)

	GUICtrlCreateGroup("IDM Data && Cache Cleaner", 24, 44, 592, 156)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")

	$h_Radio_Clean_Custom = GUICtrlCreateRadio("Custom Clean", 38, 66, 110, 20)
	GUICtrlSetFont(-1, 8.5, 600, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_CHECKED)

	$h_Radio_Clean_Full = GUICtrlCreateRadio("Full Clean", 158, 66, 100, 20)
	GUICtrlSetFont(-1, 8.5, 600, 0, "Segoe UI")

	$h_Checkbox_Clean_DD = GUICtrlCreateCheckbox("Downloaded Data (temporary files)", 38, 92, 260, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_CHECKED)

	$h_Checkbox_Clean_GD = GUICtrlCreateCheckbox("Grabber Project Cache", 320, 92, 260, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")

	$h_Checkbox_Clean_SD = GUICtrlCreateCheckbox("Scheduler && Queue Data", 38, 116, 260, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")

	$h_Checkbox_Clean_HL = GUICtrlCreateCheckbox("History && Error Logs", 320, 116, 260, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")

	$h_Progress_Clean = GUICtrlCreateProgress(38, 154, 240, 22)

	$h_Button_Clean_Analyze = GUICtrlCreateButton("  Analyze Size", 295, 148, 140, 34)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 11, 16, 16, 0)
	GUICtrlSetTip(-1, "Calculate total disk space that can be freed", "Analyze Cleanup Size", 1, 1)

	$h_Button_Clean_Now = GUICtrlCreateButton("  Clean Now", 445, 148, 155, 34)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 17, 16, 16, 0)
	GUICtrlSetTip(-1, "Permanently delete selected temporary data and cache", "Clean Data Now", 1, 1)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("IDM Stored Passwords Sanitizer", 24, 210, 592, 146)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")

	$h_Label_PwCleaner_Info = GUICtrlCreateLabel("Checking stored passwords in IDM registry...", 38, 234, 560, 22)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")

	Local $h_Label_PwTip = GUICtrlCreateLabel("💡 Safely remove saved website and server credentials stored in IDM registry for security.", 38, 260, 560, 20)
	GUICtrlSetFont($h_Label_PwTip, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_PwTip, 0x666666)

	$h_Button_PwCleaner_Refresh = GUICtrlCreateButton("  Scan Passwords", 280, 298, 145, 36)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 11, 16, 16, 0)
	GUICtrlSetTip(-1, "Rescan IDM registry for stored authentication passwords", "Scan Passwords", 1, 1)

	$h_Button_PwCleaner_Clear = GUICtrlCreateButton("  Clear All Passwords", 435, 298, 165, 36)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 6, 16, 16, 0)
	GUICtrlSetTip(-1, "Remove all stored authentication passwords from IDM", "Clear Passwords", 1, 1)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	#EndRegion Cleaner ;============================================================================================== Cleaner:

	#Region Categories ;============================================================================================== Categories:
	$h_TabSheet5 = GUICtrlCreateTabItem("Categories")
	_AET_TabSetIcon(-1, 14, -15)

	GUICtrlCreateGroup("File Extension Categories in IDM", 24, 44, 592, 255)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")

	Local $h_Label_Cat_Desc = GUICtrlCreateLabel("Configure file extension patterns that IDM automatically organizes into download categories:", 38, 66, 560, 18)
	GUICtrlSetFont($h_Label_Cat_Desc, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_Cat_Desc, 0x444444)

	$h_Checkbox_Cat_Compressed = GUICtrlCreateCheckbox("Compressed", 38, 92, 110, 22)
	GUICtrlSetFont(-1, 8.5, 600, 0, "Segoe UI")
	$h_Input_Cat_Compressed = GUICtrlCreateInput("", 152, 92, 450, 23)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)

	$h_Checkbox_Cat_Documents = GUICtrlCreateCheckbox("Documents", 38, 122, 110, 22)
	GUICtrlSetFont(-1, 8.5, 600, 0, "Segoe UI")
	$h_Input_Cat_Documents = GUICtrlCreateInput("", 152, 122, 450, 23)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)

	$h_Checkbox_Cat_Music = GUICtrlCreateCheckbox("Music", 38, 152, 110, 22)
	GUICtrlSetFont(-1, 8.5, 600, 0, "Segoe UI")
	$h_Input_Cat_Music = GUICtrlCreateInput("", 152, 152, 450, 23)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)

	$h_Checkbox_Cat_Programs = GUICtrlCreateCheckbox("Programs", 38, 182, 110, 22)
	GUICtrlSetFont(-1, 8.5, 600, 0, "Segoe UI")
	$h_Input_Cat_Programs = GUICtrlCreateInput("", 152, 182, 450, 23)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)

	$h_Checkbox_Cat_Video = GUICtrlCreateCheckbox("Video", 38, 212, 110, 22)
	GUICtrlSetFont(-1, 8.5, 600, 0, "Segoe UI")
	$h_Input_Cat_Video = GUICtrlCreateInput("", 152, 212, 450, 23)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetState(-1, $GUI_DISABLE)

	Local $h_Label_Cat_Hint = GUICtrlCreateLabel("💡 Separate extensions with spaces (e.g. zip rar 7z doc pdf mp3 mp4). Check box to edit.", 38, 248, 560, 20)
	GUICtrlSetFont($h_Label_Cat_Hint, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_Cat_Hint, 0x666666)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$h_Button_Cat_Save = GUICtrlCreateButton("  Save Changes", 34, 315, 150, 38)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 15, 16, 16, 0)
	GUICtrlSetTip(-1, "Save checked category extension lists into IDM", "Save Categories", 1, 1)

	$h_Button_Cat_Enhance = GUICtrlCreateButton("  Add Extra File Types", 198, 315, 195, 38)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 13, 16, 16, 0)
	GUICtrlSetTip(-1, "Populate checked categories with comprehensive file extension presets", "Enhance Extensions", 1, 1)

	$h_Button_Cat_Default = GUICtrlCreateButton("  Restore IDM Defaults", 406, 315, 200, 38)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 17, 16, 16, 0)
	GUICtrlSetTip(-1, "Restore checked categories to default IDM file extensions", "Reset Categories", 1, 1)
	#EndRegion Categories ;============================================================================================== Categories:

	#Region Setting ;============================================================================================== Setting:
	$h_TabSheet6 = GUICtrlCreateTabItem("Options")
	_AET_TabSetIcon(-1, 16, -17)

	GUICtrlCreateGroup("Default Application Paths", 24, 44, 592, 96)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")

	$h_Button_BrowseLogFile_Setting = GUICtrlCreateButton(" Log File Folder:", 36, 64, 130, 26, $BS_left)
	_AET_ButtonSetIcon(-1, 2, 16, 16, 0)
	$h_Button_BrowseLogFile_Setting_Context = GUICtrlCreateContextMenu($h_Button_BrowseLogFile_Setting)
	$h_Button_BrowseLogFile_Setting_Context0 = GUICtrlCreateMenuItem("Select Folder...", $h_Button_BrowseLogFile_Setting_Context)
	$h_Button_BrowseLogFile_Setting_Context1 = GUICtrlCreateMenuItem("Open Folder Location", $h_Button_BrowseLogFile_Setting_Context)

	$h_Label_LogFile_Setting = GUICtrlCreateInput($s_Log_File, 172, 65, 430, 24, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetTip(-1, GUICtrlRead($h_Label_LogFile_Setting))

	$h_Button_BrowseDataBackupFolder_Setting = GUICtrlCreateButton(" Backup Folder:", 36, 98, 130, 26, $BS_left)
	_AET_ButtonSetIcon(-1, 2, 16, 16, 0)
	$h_Button_BrowseDataBackupFolder_Setting_Context = GUICtrlCreateContextMenu($h_Button_BrowseDataBackupFolder_Setting)
	$h_Button_BrowseDataBackupFolder_Setting_Context0 = GUICtrlCreateMenuItem("Select Folder...", $h_Button_BrowseDataBackupFolder_Setting_Context)
	$h_Button_BrowseDataBackupFolder_Setting_Context1 = GUICtrlCreateMenuItem("Open Folder Location", $h_Button_BrowseDataBackupFolder_Setting_Context)

	$h_Label_BrowseDataBackupFolder_Setting = GUICtrlCreateInput($s_Backup_Dir, 172, 99, 430, 24, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetTip(-1, GUICtrlRead($h_Label_BrowseDataBackupFolder_Setting))

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("Default IDM Profile Paths", 24, 148, 592, 100)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")

	$h_Button_BrowseAppDataFolder_Setting = GUICtrlCreateButton(" AppData Folder:", 36, 170, 130, 26, $BS_left)
	_AET_ButtonSetIcon(-1, 2, 16, 16, 0)
	$h_Button_BrowseAppDataFolder_Setting_Context = GUICtrlCreateContextMenu($h_Button_BrowseAppDataFolder_Setting)
	$h_Button_BrowseAppDataFolder_Setting_Context0 = GUICtrlCreateMenuItem("Select Folder...", $h_Button_BrowseAppDataFolder_Setting_Context)
	$h_Button_BrowseAppDataFolder_Setting_Context1 = GUICtrlCreateMenuItem("Open Folder Location", $h_Button_BrowseAppDataFolder_Setting_Context)

	$h_Label_BrowseAppDataFolder_Setting = GUICtrlCreateInput($s_AppDataIDMFolder, 172, 171, 430, 24, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetTip(-1, GUICtrlRead($h_Label_BrowseAppDataFolder_Setting))

	$h_Button_TempDataFolder_Setting = GUICtrlCreateButton(" Temp Folder:", 36, 204, 130, 26, $BS_left)
	GUICtrlSetTip(-1, _
			"Temporary directory is required for storing file parts during download." & @CRLF & _
			"If you have several physical drives on your computer, you should select" & @CRLF & _
			"different physical drives for temporary directory and ""Save To"" folders" & @CRLF & _
			"for faster assembling of downloaded files.")
	_AET_ButtonSetIcon(-1, 2, 16, 16, 0)
	$h_Button_TempDataFolder_Setting_Context = GUICtrlCreateContextMenu($h_Button_TempDataFolder_Setting)
	$h_Button_TempDataFolder_Setting_Context0 = GUICtrlCreateMenuItem("Select Folder...", $h_Button_TempDataFolder_Setting_Context)
	$h_Button_TempDataFolder_Setting_Context1 = GUICtrlCreateMenuItem("Open Folder Location", $h_Button_TempDataFolder_Setting_Context)

	$h_Label_DwnlDataFolder_Setting = GUICtrlCreateCombo("", 172, 205, 430, 120, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWN))
	Local $s_all_DwnlData_Folder = _aGetTempPathFolderEx()
	Local $i = 0
	If Not @error Then
		For $i = 0 To UBound($s_all_DwnlData_Folder) - 1
			GUICtrlSetData($h_Label_DwnlDataFolder_Setting, $s_all_DwnlData_Folder[$i])
		Next
	EndIf
	GUICtrlSetData($h_Label_DwnlDataFolder_Setting, $s_TempPath, $s_TempPath)

	GUICtrlSetTip($h_Label_DwnlDataFolder_Setting, _
			"DwnlData Folder: " & @CRLF & _
			$DwnlData_Folder & @CRLF & _
			@CRLF & _
			"GrabberData Folder: " & @CRLF & _
			$GrabberData_Folder)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $h_Label_Options_Tip = GUICtrlCreateLabel("💡 Tip: Right-click path buttons for quick options (Browse or Open in Explorer)", 36, 264, 560, 20)
	GUICtrlSetFont($h_Label_Options_Tip, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_Options_Tip, 0x666666)

	$h_Button_Open_Log_Setting = GUICtrlCreateButton("  View Log", 34, 308, 130, 36)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 18, 16, 16, 0)
	GUICtrlSetTip(-1, "Open the application log file in text editor", "Open Log", 1, 1)

	$h_Button_Associate_Setting = GUICtrlCreateButton("  Associate .ibf", 176, 308, 140, 36)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 14, 16, 16, 0)
	GUICtrlSetTip(-1, "Associate .ibf file extension with IDM Backup Manager", "File Association", 1, 1)

	$h_Button_More_Setting = GUICtrlCreateButton("  Preferences", 328, 308, 130, 36)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 16, 16, 16, 0)
	GUICtrlSetTip(-1, "Configure additional application preferences", "More Settings", 1, 1)

	$h_Button_RestoreDefault_Setting = GUICtrlCreateButton("  Reset Defaults", 470, 308, 146, 36)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 17, 16, 16, 0)
	GUICtrlSetTip(-1, "Reset all settings back to default values", "Reset Defaults", 1, 1)

	#EndRegion Setting ;============================================================================================== Setting:

	#Region Help ;============================================================================================== Help:

	$h_TabSheet7 = GUICtrlCreateTabItem("Help")
	_AET_TabSetIcon(-1, 4, -5)

	; Top Hero Card: Application Identity & Updates
	GUICtrlCreateGroup("About IDM Backup Manager", 24, 44, 592, 96)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")

	Local $s_Help_AppIcon = _AET_GetResourcePath("icon.ico")
	If Not FileExists($s_Help_AppIcon) And @Compiled Then $s_Help_AppIcon = @ScriptFullPath
	Local $h_Icon_About_App = GUICtrlCreateIcon($s_Help_AppIcon, -1, 40, 68, 48, 48)

	Local $h_Label_Help_Title = GUICtrlCreateLabel("IDM Backup Manager", 102, 65, 290, 24)
	GUICtrlSetFont($h_Label_Help_Title, 12, 700, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_Help_Title, 0x1A1A1A)

	Local $h_Label_Help_Ver = GUICtrlCreateLabel("Version " & $s_Current_Version & "  •  Open Source  •  MIT License", 102, 91, 310, 18)
	GUICtrlSetFont($h_Label_Help_Ver, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_Help_Ver, 0x555555)

	Local $h_Label_Help_Author = GUICtrlCreateLabel("Created by Tejas Gajjar  •  © 2012–2026", 102, 111, 310, 18)
	GUICtrlSetFont($h_Label_Help_Author, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_Help_Author, 0x777777)

	$h_Button_Update_Help = GUICtrlCreateButton("  Check for Updates", 426, 68, 176, 36)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 13, 20, 20, 0)
	GUICtrlSetTip(-1, "Check online for newer versions of IDM Backup Manager", "Check for Updates", 1, 1)

	Local $h_Label_Update_Status = GUICtrlCreateLabel("Stay up to date with new releases", 426, 110, 176, 16, $SS_CENTER)
	GUICtrlSetFont($h_Label_Update_Status, 8, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_Update_Status, 0x777777)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Left Card: Documentation & Guides
	GUICtrlCreateGroup("Documentation && Guides", 24, 148, 290, 208)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")

	Local $h_Label_DocsIntro = GUICtrlCreateLabel("User documentation and release history:", 36, 168, 266, 18)
	GUICtrlSetFont($h_Label_DocsIntro, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_DocsIntro, 0x666666)

	$h_Button_Help_Help = GUICtrlCreateButton("  User Guide && FAQ", 36, 192, 266, 34, $BS_left)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 4, 18, 18, 0)
	GUICtrlSetTip(-1, "Open User Guide and FAQ documentation", "Documentation", 1, 1)

	$h_Button_Version_History_Help = GUICtrlCreateButton("  Version History && Notes", 36, 232, 266, 34, $BS_left)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 7, 18, 18, 0)
	GUICtrlSetTip(-1, "View full changelog and release history", "Version History", 1, 1)

	$h_Button_Licence_Help = GUICtrlCreateButton("  License Agreement (MIT)", 36, 272, 266, 34, $BS_left)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 6, 18, 18, 0)
	GUICtrlSetTip(-1, "View open source license terms", "License Agreement", 1, 1)

	Local $h_Label_Docs_Tip = GUICtrlCreateLabel("Tip: All documentation is stored locally in Help folder", 36, 322, 266, 18)
	GUICtrlSetFont($h_Label_Docs_Tip, 8, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_Docs_Tip, 0x777777)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Right Card: Community & Support
	GUICtrlCreateGroup("Community && Support", 326, 148, 290, 208)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")

	Local $h_Label_OnlineIntro = GUICtrlCreateLabel("Official repository, issues && social channels:", 338, 168, 266, 18)
	GUICtrlSetFont($h_Label_OnlineIntro, 8.5, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_OnlineIntro, 0x666666)

	$h_Button_Website_Help = GUICtrlCreateButton("  GitHub Repository", 338, 192, 266, 34, $BS_left)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 5, 18, 18, 0)
	GUICtrlSetTip(-1, "Visit official GitHub repository", "Project Website", 1, 1)

	$h_Button_Forum_Help = GUICtrlCreateButton("  Feedback && Bug Reports", 338, 232, 266, 34, $BS_left)
	GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI")
	_AET_ButtonSetIcon(-1, 3, 18, 18, 0)
	GUICtrlSetTip(-1, "Report bugs or request new features on GitHub", "Feedback & Issues", 1, 1)

	Local $h_Label_Help_Connect = GUICtrlCreateLabel("Follow Developer:", 338, 274, 136, 16)
	GUICtrlSetFont($h_Label_Help_Connect, 8.5, 600, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_Help_Connect, 0x444444)

	Local $h_Label_Help_Follow = GUICtrlCreateLabel("News, updates && tools", 338, 292, 136, 16)
	GUICtrlSetFont($h_Label_Help_Follow, 8, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_Help_Follow, 0x777777)

	$h_Picture_Facebook_About = GUICtrlCreatePic("", 484, 274, 32, 32, BitOR($GUI_SS_DEFAULT_PIC, $SS_NOTIFY))
	GUICtrlSetTip(-1, "Connect on Facebook", "Facebook", 1, 1)
	GUICtrlSetCursor(-1, 0)
	_ResourceSetImageToCtrl(-1, "facebooklogo")

	$h_Picture_Twitter_About = GUICtrlCreatePic("", 524, 274, 32, 32, BitOR($GUI_SS_DEFAULT_PIC, $SS_NOTIFY))
	GUICtrlSetTip(-1, "Follow on Twitter / X", "Twitter / X", 1, 1)
	GUICtrlSetCursor(-1, 0)
	_ResourceSetImageToCtrl(-1, "twitterlogo")

	$h_Picture_Instagram_About = GUICtrlCreatePic("", 564, 274, 32, 32, BitOR($GUI_SS_DEFAULT_PIC, $SS_NOTIFY))
	GUICtrlSetTip(-1, "Follow on Instagram", "Instagram", 1, 1)
	GUICtrlSetCursor(-1, 0)
	_ResourceSetImageToCtrl(-1, "instagramlogo")

	Local $h_Label_Social_Tip = GUICtrlCreateLabel("Open source project licensed under the MIT License", 338, 322, 266, 18)
	GUICtrlSetFont($h_Label_Social_Tip, 8, 400, 0, "Segoe UI")
	GUICtrlSetColor($h_Label_Social_Tip, 0x777777)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	#EndRegion Help ;============================================================================================== Help:

	GUICtrlCreateTabItem("")

	#Region Info Label
	Local $aParts[2] = [500, -1]
	Local $aText[2] = ["INFO: Ready", ""]
	$h_Status_Info = _GUICtrlStatusBar_Create($hGUI_BM, $aParts, $aText)
	_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo)
	$h_Status_Info_LM = $h_Status_Info
	#EndRegion Info Label

	#EndRegion ### END Koda GUI section ###
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	_LoadFileCategories()
	_UpdatePwCleanerCount()
	GUISetState(@SW_SHOW)
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Window Created: " & $s_Win_Title_BM & " With Error Code: " & @error)
EndFunc   ;==>_SwBMGUI

Func _SwEditGUI($sTXTFile, $s_Title)
	GUISetState(@SW_DISABLE, $hGUI_BM)

	Local $ChildixWidth = 520
	Local $ChildiyHight = 360
	Local $sizea = WinGetPos($s_Win_Title_BM)
	If @error Then
		;If windows not Found Place it to centre
		Local $size[2] = [(@DesktopWidth - $ChildixWidth) / 2, (@DesktopHeight - $ChildiyHight) / 2]
	Else
		Local $size[2] = [$sizea[0] + $i_xWidth_BM / 2 - $ChildixWidth / 2, $sizea[1] + $i_yHight_BM / 2 - $ChildiyHight / 2]
	EndIf

	Local $Help_GUI = GUICreate($s_Title, $ChildixWidth, $ChildiyHight, $size[0], $size[1], BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE), $hGUI_BM)
	GUISetFont(9, 400, 0, "Segoe UI", $Help_GUI)

	Local $sContent = FileRead($sTXTFile)
	$sContent = StringRegExpReplace($sContent, "(\r\n|\r|\n)", @CRLF)

	Local $hEdit = GUICtrlCreateEdit($sContent, 12, 12, $ChildixWidth - 24, $ChildiyHight - 60, BitOR($WS_VSCROLL, $ES_AUTOVSCROLL, $ES_READONLY, $ES_MULTILINE))
	GUICtrlSetFont($hEdit, 9.5, 400, 0, "Segoe UI")
	GUICtrlSendMsg($hEdit, $EM_SETSEL, -1, 0)

	Local $Close = GUICtrlCreateButton("Close", $ChildixWidth - 96, $ChildiyHight - 38, 84, 28)
	GUICtrlSetFont($Close, 9, 400, 0, "Segoe UI")
	GUICtrlSetState($Close, $GUI_FOCUS)

	GUISetIcon(@ScriptFullPath, 0, $Help_GUI)
	GUISetState(@SW_SHOW, $Help_GUI)
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
	#Region ### START Koda GUI section ###
	GUISetState(@SW_DISABLE, $hGUI_BM)

	Local $ChildixWidth = 360
	Local $ChildiyHight = 180
	Local $sizea = WinGetPos($s_Win_Title_BM)
	If @error Then
		;If windows not Found Place it to centre
		Local $size[2] = [(@DesktopWidth - $ChildixWidth) / 2, (@DesktopHeight - $ChildiyHight) / 2]
	Else
		Local $size[2] = [$sizea[0] + $i_xWidth_BM / 2 - $ChildixWidth / 2, $sizea[1] + $i_yHight_BM / 2 - $ChildiyHight / 2]
	EndIf

	Local $More_Setting_GUI = GUICreate("Preferences", $ChildixWidth, $ChildiyHight, $size[0], $size[1], BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE), $hGUI_BM)
	GUISetFont(9, 400, 0, "Segoe UI", $More_Setting_GUI)

	GUICtrlCreateGroup("Application Preferences", 10, 8, 340, 160)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")
	Local $h_AppendLog_Setting = GUICtrlCreateCheckbox("Append Log File", 20, 28, 315, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	If $b_AppendLog_File Then GUICtrlSetState($h_AppendLog_Setting, $GUI_CHECKED)

	Local $h_RestortIDM_Setting = GUICtrlCreateCheckbox("Auto Restart IDM after Restore / Tools", 20, 52, 315, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	If $b_RestartIDM Then GUICtrlSetState($h_RestortIDM_Setting, $GUI_CHECKED)

	Local $h_OpenFolder_Setting = GUICtrlCreateCheckbox("Open Destination Folder after Backup", 20, 76, 315, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	If $b_OpenFolder Then GUICtrlSetState($h_OpenFolder_Setting, $GUI_CHECKED)

	Local $h_CheckUpdate_Setting = GUICtrlCreateCheckbox("Check for updates in background (non-blocking)", 20, 100, 315, 20)
	GUICtrlSetFont(-1, 8.5, 400, 0, "Segoe UI")
	If $b_CheckUpdate_Background Then GUICtrlSetState($h_CheckUpdate_Setting, $GUI_CHECKED)

	Local $h_Close = GUICtrlCreateButton("Close", 255, 128, 85, 28)
	GUICtrlSetFont(-1, 9, 600, 0, "Segoe UI")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
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

			Case $h_CheckUpdate_Setting
				If GUICtrlRead($h_CheckUpdate_Setting) = $GUI_CHECKED Then
					IniWrite($s_Setting_File, "More Setting", "CheckUpdate_Background", 1)
					$b_CheckUpdate_Background = 1
				Else
					IniWrite($s_Setting_File, "More Setting", "CheckUpdate_Background", 0)
					$b_CheckUpdate_Background = 0
				EndIf

		EndSwitch
	WEnd
	GUISetState(@SW_ENABLE, $hGUI_BM)
	GUIDelete($More_Setting_GUI)
EndFunc   ;==>_SwMoreSettingGUI

#Region Integrated Tools Helper Functions

Func _SearchDownloadsList($sText)
	If $sText = "" Then
		_Analyze()
		Return
	EndIf
	_GUICtrlListView_BeginUpdate($idListView)
	Local $i = 0
	While 1
		If $i >= _GUICtrlListView_GetItemCount($hListView) Then ExitLoop
		If Not StringInStr(_GUICtrlListView_GetItemTextString($hListView, $i), $sText) Then
			_GUICtrlListView_DeleteItem($hListView, $i)
		Else
			$i += 1
		EndIf
	WEnd
	_GUICtrlListView_EndUpdate($idListView)
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: " & _GUICtrlListView_GetItemCount($hListView) & " item(s) matching """ & $sText & """")
EndFunc   ;==>_SearchDownloadsList

Func _UpdatePwCleanerCount()
	Local $k = 1, $j = 0, $var
	While 1
		$var = RegEnumKey($s_regpath_IDM & "\Passwords", $k)
		If @error <> 0 Then ExitLoop
		If _RegValueExists($s_regpath_IDM & "\Passwords\" & $var, "EncPassword") Then $j += 1
		$k += 1
	WEnd
	GUICtrlSetData($h_Label_PwCleaner_Info, "Total " & $j & " saved authentication password(s) found in IDM registry.")
	If $j = 0 Then
		GUICtrlSetState($h_Button_PwCleaner_Clear, $GUI_DISABLE)
	Else
		GUICtrlSetState($h_Button_PwCleaner_Clear, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_UpdatePwCleanerCount

Func _ClearAllPasswords()
	Local $iAns = MsgBox(36, "Confirm Password Cleanup", "Are you sure you want to remove all saved server and website authentication passwords from IDM?", 0, $hGUI_BM)
	If $iAns <> 6 Then Return
	Local $k = 1, $j = 0, $var
	While 1
		$var = RegEnumKey($s_regpath_IDM & "\Passwords", $k)
		If @error <> 0 Then ExitLoop
		If _RegValueExists($s_regpath_IDM & "\Passwords\" & $var, "EncPassword") Then
			_RegDelete($s_regpath_IDM & "\Passwords\" & $var, "EncPassword")
			$j += 1
		EndIf
		$k += 1
	WEnd
	GUICtrlSetData($h_Label_PwCleaner_Info, "Total " & $j & " password(s) successfully removed.")
	GUICtrlSetState($h_Button_PwCleaner_Clear, $GUI_DISABLE)
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: " & $j & " password(s) removed.")
	If $b_RestartIDM Then _RunIDMexe()
EndFunc   ;==>_ClearAllPasswords

Func _CleanAnalyze()
	_ProgressMarquee_Start($h_Progress_Clean)
	Local $aCleanData[12]
	If GUICtrlRead($h_Radio_Clean_Full) = $GUI_CHECKED Then
		$aCleanData[0] = $DwnlData_Folder & @UserName & "\"
		$aCleanData[1] = $Grabber_Folder
		$aCleanData[2] = $GrabberData_Folder & @UserName & "\"
		$aCleanData[3] = $Scheduler_Folder
		$aCleanData[4] = $UrlHistory_txt_File
		$aCleanData[5] = $UrlHistory2_txt_File
		$aCleanData[6] = $GlobalErrors_log_File
		$aCleanData[7] = $urlexclist_dat_File
		$aCleanData[8] = $defextmap_dat_File
		$aCleanData[9] = $foldresHistory_txt_File
		$aCleanData[10] = $sts_list_dat_File
		$aCleanData[11] = $cnlurllist_dat_File
	Else
		_ResetDataAray($aCleanData)
		If GUICtrlRead($h_Checkbox_Clean_DD) = $GUI_CHECKED Then $aCleanData[0] = $DwnlData_Folder & @UserName & "\"
		If GUICtrlRead($h_Checkbox_Clean_GD) = $GUI_CHECKED Then
			$aCleanData[1] = $Grabber_Folder
			$aCleanData[2] = $GrabberData_Folder & @UserName & "\"
		EndIf
		If GUICtrlRead($h_Checkbox_Clean_SD) = $GUI_CHECKED Then $aCleanData[3] = $Scheduler_Folder
		If GUICtrlRead($h_Checkbox_Clean_HL) = $GUI_CHECKED Then
			$aCleanData[4] = $UrlHistory_txt_File
			$aCleanData[5] = $UrlHistory2_txt_File
			$aCleanData[6] = $GlobalErrors_log_File
			$aCleanData[7] = $urlexclist_dat_File
			$aCleanData[8] = $defextmap_dat_File
			$aCleanData[9] = $foldresHistory_txt_File
			$aCleanData[10] = $sts_list_dat_File
			$aCleanData[11] = $cnlurllist_dat_File
		EndIf
	EndIf

	_ProgressMarquee_Stop($h_Progress_Clean, 1)
	Local $sSize = _sGetFileSizeConv(_iGetFileSize($aCleanData))
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Analysis complete. " & $sSize & " of temporary data found.")
	MsgBox(64, "Analysis Result", $sSize & " can be cleaned.", 0, $hGUI_BM)
EndFunc   ;==>_CleanAnalyze

Func _CleanExecute()
	Local $aCleanData[12]
	If GUICtrlRead($h_Radio_Clean_Full) = $GUI_CHECKED Then
		$aCleanData[0] = $DwnlData_Folder & @UserName & "\"
		$aCleanData[1] = $Grabber_Folder
		$aCleanData[2] = $GrabberData_Folder & @UserName & "\"
		$aCleanData[3] = $Scheduler_Folder
		$aCleanData[4] = $UrlHistory_txt_File
		$aCleanData[5] = $UrlHistory2_txt_File
		$aCleanData[6] = $GlobalErrors_log_File
		$aCleanData[7] = $urlexclist_dat_File
		$aCleanData[8] = $defextmap_dat_File
		$aCleanData[9] = $foldresHistory_txt_File
		$aCleanData[10] = $sts_list_dat_File
		$aCleanData[11] = $cnlurllist_dat_File
	Else
		_ResetDataAray($aCleanData)
		If GUICtrlRead($h_Checkbox_Clean_DD) = $GUI_CHECKED Then $aCleanData[0] = $DwnlData_Folder & @UserName & "\"
		If GUICtrlRead($h_Checkbox_Clean_GD) = $GUI_CHECKED Then
			$aCleanData[1] = $Grabber_Folder
			$aCleanData[2] = $GrabberData_Folder & @UserName & "\"
		EndIf
		If GUICtrlRead($h_Checkbox_Clean_SD) = $GUI_CHECKED Then $aCleanData[3] = $Scheduler_Folder
		If GUICtrlRead($h_Checkbox_Clean_HL) = $GUI_CHECKED Then
			$aCleanData[4] = $UrlHistory_txt_File
			$aCleanData[5] = $UrlHistory2_txt_File
			$aCleanData[6] = $GlobalErrors_log_File
			$aCleanData[7] = $urlexclist_dat_File
			$aCleanData[8] = $defextmap_dat_File
			$aCleanData[9] = $foldresHistory_txt_File
			$aCleanData[10] = $sts_list_dat_File
			$aCleanData[11] = $cnlurllist_dat_File
		EndIf
	EndIf

	Local $sSize = _sGetFileSizeConv(_iGetFileSize($aCleanData))
	Local $iAns = MsgBox(36, "Confirm Clean", $sSize & " will be removed. Continue?", 0, $hGUI_BM)
	If $iAns <> 6 Then Return

	FileWriteLine($s_Log_File, "")
	FileWriteLine($s_Log_File, "============================= Cleaning Started =============================")
	_ProgressMarquee_Start($h_Progress_Clean)
	Local $sLockedFiles = _iFileOrFolderRemove($aCleanData)
	_ProgressMarquee_Stop($h_Progress_Clean, 1)

	If $sLockedFiles <> "" Then
		MsgBox(16, "Warning", "Some file(s) could not be removed. View Log for more information.", 0, $hGUI_BM)
		Local $sLockedFile = StringSplit($sLockedFiles, @CRLF, 1)
		For $i = 1 To $sLockedFile[0] - 1
			FileWriteLine($s_Log_File, _Current_Moment() & "Warning: File Could Not Deleted= " & '"' & $sLockedFile[$i] & '"')
		Next
	EndIf

	For $i = 0 To 3
		If Not FileExists($aCleanData[$i]) Then DirCreate($aCleanData[$i])
	Next

	FileWriteLine($s_Log_File, "============================= Cleaning Ended =============================")
	FileWriteLine($s_Log_File, "")
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Cleaning completed.")
	MsgBox(64, "Cleaning Done", "Selected files and cache have been cleaned.", 0, $hGUI_BM)
	If $b_RestartIDM Then _RunIDMexe()
EndFunc   ;==>_CleanExecute

Func _LoadFileCategories()
	Local $sComp = _RegRead($s_regpath_IDM & "\FoldersTree\Compressed", "mask")
	If @error Or $sComp = "0" Or $sComp = 0 Or StringStripWS($sComp, 8) = "" Then $sComp = "zip rar r0* r1* arj gz sit sitx sea ace bz2 7z"
	Local $sDocs = _RegRead($s_regpath_IDM & "\FoldersTree\Documents", "mask")
	If @error Or $sDocs = "0" Or $sDocs = 0 Or StringStripWS($sDocs, 8) = "" Then $sDocs = "doc pdf ppt pps docx pptx"
	Local $sMusic = _RegRead($s_regpath_IDM & "\FoldersTree\Music", "mask")
	If @error Or $sMusic = "0" Or $sMusic = 0 Or StringStripWS($sMusic, 8) = "" Then $sMusic = "mp3 wav wma mpa ram ra aac aif m4a"
	Local $sProgs = _RegRead($s_regpath_IDM & "\FoldersTree\Programs", "mask")
	If @error Or $sProgs = "0" Or $sProgs = 0 Or StringStripWS($sProgs, 8) = "" Then $sProgs = "exe msi"
	Local $sVideo = _RegRead($s_regpath_IDM & "\FoldersTree\Video", "mask")
	If @error Or $sVideo = "0" Or $sVideo = 0 Or StringStripWS($sVideo, 8) = "" Then $sVideo = "avi mpg mpe mpeg asf wmv mov qt rm mp4 flv m4v webm ogv ogg"

	GUICtrlSetData($h_Input_Cat_Compressed, $sComp)
	GUICtrlSetData($h_Input_Cat_Documents, $sDocs)
	GUICtrlSetData($h_Input_Cat_Music, $sMusic)
	GUICtrlSetData($h_Input_Cat_Programs, $sProgs)
	GUICtrlSetData($h_Input_Cat_Video, $sVideo)
EndFunc   ;==>_LoadFileCategories

Func _SaveCategories()
	Local $iSaved = 0
	If GUICtrlRead($h_Checkbox_Cat_Compressed) = $GUI_CHECKED Then
		_RegWrite($s_regpath_IDM & "\FoldersTree\Compressed\", "mask", $REG_SZ, GUICtrlRead($h_Input_Cat_Compressed))
		$iSaved += 1
	EndIf
	If GUICtrlRead($h_Checkbox_Cat_Documents) = $GUI_CHECKED Then
		_RegWrite($s_regpath_IDM & "\FoldersTree\Documents\", "mask", $REG_SZ, GUICtrlRead($h_Input_Cat_Documents))
		$iSaved += 1
	EndIf
	If GUICtrlRead($h_Checkbox_Cat_Music) = $GUI_CHECKED Then
		_RegWrite($s_regpath_IDM & "\FoldersTree\Music\", "mask", $REG_SZ, GUICtrlRead($h_Input_Cat_Music))
		$iSaved += 1
	EndIf
	If GUICtrlRead($h_Checkbox_Cat_Programs) = $GUI_CHECKED Then
		_RegWrite($s_regpath_IDM & "\FoldersTree\Programs\", "mask", $REG_SZ, GUICtrlRead($h_Input_Cat_Programs))
		$iSaved += 1
	EndIf
	If GUICtrlRead($h_Checkbox_Cat_Video) = $GUI_CHECKED Then
		_RegWrite($s_regpath_IDM & "\FoldersTree\Video\", "mask", $REG_SZ, GUICtrlRead($h_Input_Cat_Video))
		$iSaved += 1
	EndIf

	GUICtrlSetData($h_Button_Cat_Save, "Saved!")
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: " & $iSaved & " category rule(s) saved to IDM.")
	Sleep(600)
	GUICtrlSetData($h_Button_Cat_Save, "  Save Changes")
	If $b_RestartIDM Then _RunIDMexe()
EndFunc   ;==>_SaveCategories

Func _EnhanceCategories()
	Local $s_Enhance_Compressed = "zip rar r0* r1* arj gz sit sitx sea ace bz2 7z 001 cab xz txz lzma tar cpio bzip2 tbz2 tbz gzip tgz tpz z taz lzh lha rpm deb vhd wim swm fat ntfs xar squashfs ifu ifc dgca yz1 rk miniso iso isz bin cue mds mdf nrg ashdisc b6t b6i b5t b5i bwt bwi lcd ccd img dvd 000 daa cdi cif xmf xmd pdi dmg timg hfs ncd pxi p2i rif rdf gi uif vc4 fcd vcd ima bif flp c2d dao tao p01 md1 xa VaporCD gcd ixa vdi"
	Local $s_Enhance_Documents = "doc pdf ppt pps docx pptx docm dotx dotm rtf odt wri wpd wps xps djvu ps chm accdb mdb adp mda accda mde accde ade xl* xlsx xlsm xlsb xlam xltx xltm xls xlt xla xlw xsn xsf infopathxml onetoc2 one onepkg pptm ppsx ppsm potx pot potm odp thmx pub"
	Local $s_Enhance_Music = "mp3 wav wma mpa ram ra aac aif m4a 3ga 669 a52 ac3 adt adts aifc aiff amr aob ape awb caf cda dts flac it m4p mid mka mlp mod mp1 mp2 mpc oga oma qcp rmi s3m spx thd tta voc vqf w64 wv xm"
	Local $s_Enhance_Programs = "exe msi jar jad dll bpl cpl scr ocx msstyles mui"
	Local $s_Enhance_Video = "avi mpg mpe mpeg asf wmv mov qt rm mp4 flv m4v webm ogv ogg 3g2 3gp 3gp2 3gpp amv divx drc dv f4v gxf m1v m2v m2t m2ts mkv mp2v mp4v mpeg1 mpeg2 mpeg4 mpv2 mts mtv mxf mxg nsv nuv ogg ogm ogx rec rmvb tod ts tts vob vro"

	If GUICtrlRead($h_Checkbox_Cat_Compressed) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Cat_Compressed, $s_Enhance_Compressed)
	If GUICtrlRead($h_Checkbox_Cat_Documents) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Cat_Documents, $s_Enhance_Documents)
	If GUICtrlRead($h_Checkbox_Cat_Music) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Cat_Music, $s_Enhance_Music)
	If GUICtrlRead($h_Checkbox_Cat_Programs) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Cat_Programs, $s_Enhance_Programs)
	If GUICtrlRead($h_Checkbox_Cat_Video) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Cat_Video, $s_Enhance_Video)
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Enhanced file type definitions loaded. Click 'Save Changes' to apply.")
EndFunc   ;==>_EnhanceCategories

Func _RestoreDefaultCategories()
	Local $s_Default_Compressed = "zip rar r0* r1* arj gz sit sitx sea ace bz2 7z"
	Local $s_Default_Documents = "doc pdf ppt pps docx pptx"
	Local $s_Default_Music = "mp3 wav wma mpa ram ra aac aif m4a"
	Local $s_Default_Programs = "exe msi"
	Local $s_Default_Video = "avi mpg mpe mpeg asf wmv mov qt rm mp4 flv m4v webm ogv ogg"

	If GUICtrlRead($h_Checkbox_Cat_Compressed) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Cat_Compressed, $s_Default_Compressed)
	If GUICtrlRead($h_Checkbox_Cat_Documents) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Cat_Documents, $s_Default_Documents)
	If GUICtrlRead($h_Checkbox_Cat_Music) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Cat_Music, $s_Default_Music)
	If GUICtrlRead($h_Checkbox_Cat_Programs) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Cat_Programs, $s_Default_Programs)
	If GUICtrlRead($h_Checkbox_Cat_Video) = $GUI_CHECKED Then GUICtrlSetData($h_Input_Cat_Video, $s_Default_Video)
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Default IDM categories loaded. Click 'Save Changes' to apply.")
EndFunc   ;==>_RestoreDefaultCategories

; Compatibility wrappers
Func _SwCleanerGUI()
	GUICtrlSetState($h_TabSheet4, $GUI_SHOW)
EndFunc   ;==>_SwCleanerGUI

Func _SwPwCleanerGUI()
	GUICtrlSetState($h_TabSheet4, $GUI_SHOW)
EndFunc   ;==>_SwPwCleanerGUI

Func _SwFileTypeGUI()
	GUICtrlSetState($h_TabSheet5, $GUI_SHOW)
EndFunc   ;==>_SwFileTypeGUI

#EndRegion Integrated Tools Helper Functions

Func _SwFileInformation()

	FileWriteLine($s_Log_File, "")
	FileWriteLine($s_Log_File, "============================= File Info Started =============================")

	Local $ChildixWidth = 433
	Local $ChildiyHight = 401

	Local $sizea = WinGetPos($s_Win_Title_BM)
	If @error Then
		;If windows not Found Place it to centre
		Local $size[2] = [(@DesktopWidth - $ChildixWidth) / 2, (@DesktopHeight - $ChildiyHight) / 2]
	Else
		Local $size[2] = [$sizea[0] + $i_xWidth_BM / 2 - $ChildixWidth / 2, $sizea[1] + $i_yHight_BM / 2 - $ChildiyHight / 2]
	EndIf

	Local $FileInformationGUI = GUICreate("Backup File Information", $ChildixWidth, $ChildiyHight, $size[0], $size[1], BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE), $hGUI_BM)

	Local $lblTitle = GUICtrlCreateLabel("Backup From ", 8, 8, 417, 48, BitOR($SS_CENTER, $WS_CLIPSIBLINGS))
	GUICtrlSetFont(-1, 16, 400, 0, "Microsoft Sans Serif")
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKVCENTER + $GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("Backup File Property", 8, 56, 417, 113)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("File Name:", 16, 80, 54, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("File Size:", 16, 101, 46, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("File Date(UTC):", 16, 122, 87, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("Total Downloads:", 16, 143, 87, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $lblFileName = GUICtrlCreateLabel("", 112, 80, 306, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	Local $lblFileSize = GUICtrlCreateLabel("", 112, 101, 306, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	Local $lblFileDate = GUICtrlCreateLabel("", 112, 122, 306, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	Local $lblTotalDownloads = GUICtrlCreateLabel("", 112, 143, 306, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("Backup Modes and Folders", 8, 176, 417, 137)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("Backup Mode:", 16, 200, 74, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH)
	GUICtrlCreateLabel("Download Data Folder:", 16, 221, 113, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH)
	GUICtrlCreateLabel("Grabber Folder:", 217, 221, 77, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("Scheduler Folder:", 16, 242, 87, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH)
	GUICtrlCreateLabel("History Files:", 217, 242, 63, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("AppDataIDM Folder:", 16, 263, 101, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("Temp Folder:", 16, 284, 66, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $lblBackupMode = GUICtrlCreateLabel("", 128, 200, 290, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	Local $lblDownloadDataFolder = GUICtrlCreateLabel("", 128, 221, 79, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $lblGrabberFolder = GUICtrlCreateLabel("", 290, 221, 127, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	Local $lblSchedulerFolder = GUICtrlCreateLabel("", 128, 242, 79, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $lblHistoryFolder = GUICtrlCreateLabel("", 290, 242, 127, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	Local $lblAppDataIDMFolder = GUICtrlCreateLabel("", 128, 263, 290, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	Local $lblTempFolder = GUICtrlCreateLabel("", 128, 287, 290, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("System Properties", 8, 320, 417, 73)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("OSVersion:", 16, 344, 57, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("OSServicePack:", 217, 344, 83, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("OSArch:", 16, 365, 44, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateLabel("Computer Name:", 217, 365, 83, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $lblOSVersion = GUICtrlCreateLabel("", 128, 344, 79, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	Local $lblOSServicePack = GUICtrlCreateLabel("", 304, 344, 111, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	Local $lblComputerName = GUICtrlCreateLabel("", 304, 365, 111, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	Local $lblOSArch = GUICtrlCreateLabel("", 128, 365, 79, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	#Region Backup File
	Local $s_Restore_File = GUICtrlRead($h_Input_Restore_Path)

	FileWriteLine($s_Log_File, _Current_Moment() & "Info: $s_Restore_File= " & '"' & $s_Restore_File & '"')
	;Check backup File
	If Not FileExists($s_Restore_File) Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Backup File Not Found")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
		_ControlUpdateDefault()
		Return SetError(1)
	EndIf

	;Check Password
	Local $s_Password = GUICtrlRead($h_Input_Password_Restore)
	If $s_Password <> "" Then
		If StringInStr($s_Password, """") Or StringInStr($s_Password, '''') Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Password Doesn't Contain Double Quote or Single Quote")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusWarning);StatusWarning
			FileWriteLine($s_Log_File, _Current_Moment() & "Password Doesn't Contain Double Quote or Single Quote")
			_ControlUpdateDefault()
			Return SetError(1)
		EndIf
	EndIf

	;Startup 7z
	_7ZipStartup()
	_7ZipSetOwnerWindowEx($hGUI_BM, "_ARCHIVERPROC_EXT")

	_ResetDataAray($aData)
	$aData[13] = "idm_guest_Setting.ini"

	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Getting File Info...")
	_ControlUpdateBusy()
	_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusWorking);StatusWorking

	;remove extracted ini
	_FileOrFolderDeleteWithLog($s_ini_File)

	Local $foo = _7ZipExtractEx($hGUI_BM, $s_Restore_File, @TempDir, $aData, $s_Password);Extract ini,reg File -> Check For Password
	_7ZipShutdown()
	If $foo <> 0 And FileExists($s_ini_File) Then ;Check if INI available and Succeful Extract

		_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
		_ControlUpdateDefault()
		FileWriteLine($s_Log_File, _Current_Moment() & "Success!")

		;Show GUI
		GUISetState(@SW_SHOW)
		GUISetState(@SW_DISABLE, $hGUI_BM)

		GUICtrlSetData($lblTitle, "Backup From " & IniRead($s_ini_File, "Default", "Username", "Not Available") & " PC")
		GUICtrlSetData($lblFileName, _Name_Get_From_Path($s_Restore_File))
		GUICtrlSetData($lblFileSize, _sGetFileSizeConv(FileGetSize($s_Restore_File)))
		GUICtrlSetData($lblFileDate, IniRead($s_ini_File, "Default", "FileDate", "Not Available"))
		GUICtrlSetData($lblTotalDownloads, IniRead($s_ini_File, "Default", "Keys", "Not Available"))
		GUICtrlSetData($lblBackupMode, IniRead($s_ini_File, "Default", "Mode", "Not Available"))
		GUICtrlSetData($lblDownloadDataFolder, IniRead($s_ini_File, "Default", "DwnlData_Folder", "Not Available"))
		GUICtrlSetData($lblGrabberFolder, IniRead($s_ini_File, "Default", "Grabber_Folder", "Not Available"))
		GUICtrlSetData($lblSchedulerFolder, IniRead($s_ini_File, "Default", "Scheduler_Folder", "Not Available"))
		GUICtrlSetData($lblHistoryFolder, IniRead($s_ini_File, "Default", "History_Files", "Not Available"))
		GUICtrlSetData($lblAppDataIDMFolder, IniRead($s_ini_File, "Default", "AppDataIDMFolder", "Not Available"))
		GUICtrlSetData($lblTempFolder, IniRead($s_ini_File, "Default", "TempPath", "Not Available"))

		GUICtrlSetData($lblOSVersion, IniRead($s_ini_File, "GuestSystemInfo", "OSVersion", ""))
		GUICtrlSetData($lblOSServicePack, IniRead($s_ini_File, "GuestSystemInfo", "OSServicePack", ""))
		GUICtrlSetData($lblOSArch, IniRead($s_ini_File, "GuestSystemInfo", "OSArch", ""))
		GUICtrlSetData($lblComputerName, IniRead($s_ini_File, "GuestSystemInfo", "ComputerName", ""))
	Else
		GUISetState(@SW_ENABLE, $hGUI_BM)
		GUIDelete($FileInformationGUI)

		If $s_Password = "" Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Backup may be password-protected or file damaged.")
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
	EndIf
	#EndRegion Backup File

	Local $nMsg
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				;remove extracted ini
				_FileOrFolderDeleteWithLog($s_ini_File)
				ExitLoop
		EndSwitch
	WEnd

	GUISetState(@SW_ENABLE, $hGUI_BM)
	GUIDelete($FileInformationGUI)
EndFunc   ;==>_SwFileInformation
#EndRegion GUIS

#Region system & process Functions(idm related)
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
	Local $h_reg_File_Tmp = FileOpen($s_reg_File_Tmp, 32 + 1)

	; Check if file opened for reading OK
	If $h_reg_File = -1 Or $h_reg_File_Tmp = -1 Then Return SetError(1, 0, 0)

	Local $Pathex = StringReplace('"' & $DwnlData_Folder & @UserName & "\", "\", "\\")

	Local $sLine, $final, $str, $strLen, $asp, $iN, $asp2

	While 1
		$sLine = FileReadLine($h_reg_File)


		If @error = -1 Or @error = 1 Then ExitLoop
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
		Next

		$final = StringTrimRight($final, 2);

		$final = $str & $Pathex & $final & @CRLF

		FileWrite($h_reg_File_Tmp, $final)

		ConsoleWrite("$sLine = " & $sLine & @CRLF)
		ConsoleWrite("$sLine1 = " & $final & @CRLF & @CRLF)

		$final = ""

		;===========================================
	WEnd
	FileClose($h_reg_File)
	FileClose($h_reg_File_Tmp)
	ConsoleWrite("FileClose " & @CRLF & @CRLF)

	If Not FileDelete($s_reg_File) Then Return SetError(1, 0, 0)
	If Not FileMove($s_reg_File_Tmp, $s_reg_File, 8 + 1) Then Return SetError(1, 0, 0)

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
	If Not FileMove($s_reg_File_Tmp, $s_reg_File, 8 + 1) Then Return SetError(1, 0, 0)

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
	If $h_Update_Download <> -1 Then
		InetClose($h_Update_Download)
		$h_Update_Download = -1
		If FileExists($s_Update_FilePath) Then FileDelete($s_Update_FilePath)
	EndIf
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

#Au3Stripper_Off
Func _ARCHIVERPROC_ADD($hWnd, $Msg, $nState, $ExInfo)
	Local $sFileName
	#forceref $hWnd,$Msg

	If $nState = 0 Then
		Local $EXTRACTINGINFO = DllStructCreate($tagEXTRACTINGINFO, $ExInfo)

		;$iFileSize = DllStructGetData($EXTRACTINGINFO, "dwFileSize")
		;$iWriteSize = DllStructGetData($EXTRACTINGINFO, "dwWriteSize")
		$sFileName = DllStructGetData($EXTRACTINGINFO, "szSourceFileName")
		;$iPercent = Int($iWriteSize / $iFileSize * 100)

		;_GUICtrlStatusBar_SetText($h_Status_Info, $iPercent & " %", 1)

		_GUICtrlStatusBar_SetText($h_Status_Info, "Adding: ..." & StringRight($sFileName, 40))

		Return 1
	EndIf

	Return 1
EndFunc   ;==>_ARCHIVERPROC_ADD

Func _ARCHIVERPROC_EXT($hWnd, $Msg, $nState, $ExInfo)
	Local $sFileName
	#forceref $hWnd,$Msg

	If $nState = 0 Then
		Local $EXTRACTINGINFO = DllStructCreate($tagEXTRACTINGINFO, $ExInfo)

		;$iFileSize = DllStructGetData($EXTRACTINGINFO, "dwFileSize")
		;$iWriteSize = DllStructGetData($EXTRACTINGINFO, "dwWriteSize")
		$sFileName = DllStructGetData($EXTRACTINGINFO, "szSourceFileName")
		;$iPercent = Int($iWriteSize / $iFileSize * 100)

		;_GUICtrlStatusBar_SetText($h_Status_Info, $iPercent & " %", 1)

		_GUICtrlStatusBar_SetText($h_Status_Info, "Extracting: ..." & StringRight($sFileName, 40))

		Return 1
	EndIf

	Return 1
EndFunc   ;==>_ARCHIVERPROC_EXT

#Au3Stripper_On

Func _ResetDataAray(ByRef $aData)
	For $i = 0 To UBound($aData) - 1
		$aData[$i] = ""
	Next
EndFunc   ;==>_ResetDataAray
#EndRegion system & process Functions(idm related)

#Region Help
Func _SwHistory()
	If FileExists($s_History_File) Then
		_SwEditGUI($s_History_File, "Version History")
	Else
		_GUICtrlStatusBar_SetText($h_Status_Info, "Error: history.txt Not Found.")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
	EndIf
EndFunc   ;==>_SwHistory

Func _CompareVersions($sV1, $sV2)
	Local $a1 = StringSplit($sV1, ".", 2)
	Local $a2 = StringSplit($sV2, ".", 2)
	Local $m = UBound($a1)
	If UBound($a2) > $m Then $m = UBound($a2)
	For $i = 0 To $m - 1
		Local $n1 = 0
		If $i < UBound($a1) Then $n1 = Number($a1[$i])
		Local $n2 = 0
		If $i < UBound($a2) Then $n2 = Number($a2[$i])
		If $n1 > $n2 Then Return 1
		If $n1 < $n2 Then Return -1
	Next
	Return 0
EndFunc   ;==>_CompareVersions

Func _UpdateCheck($bSilent = False)
	If $h_Update_Download <> -1 Then
		If Not $bSilent Then _GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Update check already in progress...")
		Return
	EndIf

	If Not _IsInternetConnectedEx() Then
		If Not $bSilent Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Internet Connection Could Not Be Found")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError)
		EndIf
		Return
	EndIf

	If FileExists($s_Update_FilePath) Then FileDelete($s_Update_FilePath)

	$b_Update_Silent = $bSilent
	$i_Update_StartTime = TimerInit()

	If Not $b_Update_Silent Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Checking for updates in background...")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo)
		If $h_Button_Update_Help <> 0 Then
			GUICtrlSetData($h_Button_Update_Help, "  Checking...")
			GUICtrlSetState($h_Button_Update_Help, $GUI_DISABLE)
		EndIf
	EndIf

	; Launch asynchronous background download on OS background worker thread (non-blocking)
	$h_Update_Download = InetGet($s_URL_Update, $s_Update_FilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
	AdlibRegister("_UpdateCheck_Monitor", 250)
EndFunc   ;==>_UpdateCheck

Func _UpdateCheck_Monitor()
	If $h_Update_Download = -1 Then
		AdlibUnRegister("_UpdateCheck_Monitor")
		Return
	EndIf

	Local $bComplete = InetGetInfo($h_Update_Download, $INET_DOWNLOADCOMPLETE)
	Local $bTimeout = (TimerDiff($i_Update_StartTime) > 10000)

	If Not $bComplete And Not $bTimeout Then Return

	; Download finished or timed out
	AdlibUnRegister("_UpdateCheck_Monitor")
	InetClose($h_Update_Download)
	$h_Update_Download = -1

	; Re-enable Help button if it was disabled
	If $h_Button_Update_Help <> 0 Then
		GUICtrlSetData($h_Button_Update_Help, "  Check for Updates")
		GUICtrlSetState($h_Button_Update_Help, $GUI_ENABLE)
	EndIf

	If $bTimeout Or Not FileExists($s_Update_FilePath) Then
		If FileExists($s_Update_FilePath) Then FileDelete($s_Update_FilePath)
		If Not $b_Update_Silent Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Update check timed out or server unavailable.")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError)
		EndIf
		Return
	EndIf

	Local $hFileOpen = FileOpen($s_Update_FilePath, $FO_READ)
	If $hFileOpen = -1 Then
		If FileExists($s_Update_FilePath) Then FileDelete($s_Update_FilePath)
		If Not $b_Update_Silent Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Could not read update information.")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError)
		EndIf
		Return
	EndIf

	Local $sFileRead = FileRead($hFileOpen)
	FileClose($hFileOpen)
	If FileExists($s_Update_FilePath) Then FileDelete($s_Update_FilePath)

	Local $sDownloadedVersion = StringStripWS(BinaryToString($sFileRead), 3)
	If $sDownloadedVersion = "" Then $sDownloadedVersion = StringStripWS($sFileRead, 3)

	If $sDownloadedVersion = "" Then
		If Not $b_Update_Silent Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Invalid version response from server.")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError)
		EndIf
		Return
	EndIf

	Local $iComp = _CompareVersions($sDownloadedVersion, $s_Current_Version)
	If $iComp > 0 Then
		; New update available!
		_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: New version v" & $sDownloadedVersion & " available! Click to update.")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo)
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: New version found online: v" & $sDownloadedVersion)
		If Not $b_Update_Silent Then
			Local $iAns = MsgBox(BitOR($MB_YESNO, $MB_ICONINFORMATION), "Update Available", _
					"A new version of IDM Backup Manager is available:" & @CRLF & @CRLF & _
					"• Current Version: v" & $s_Current_Version & @CRLF & _
					"• Latest Version : v" & $sDownloadedVersion & @CRLF & @CRLF & _
					"Would you like to open the GitHub Releases page now to download it?", 0, $hGUI_BM)
			If $iAns = $IDYES Then ShellExecute($s_URL_Releases)
		EndIf
	Else
		; Up to date!
		_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: You have the most recent version (v" & $s_Current_Version & ").")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusCompled)
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Version check completed. Up to date (v" & $s_Current_Version & ").")
		If Not $b_Update_Silent Then
			MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION), "Up to Date", _
					"You are using the latest version of IDM Backup Manager (v" & $s_Current_Version & ").", 0, $hGUI_BM)
		EndIf
	EndIf
EndFunc   ;==>_UpdateCheck_Monitor

Func _ShellInstall()
	Local $iMsgBoxAnswer = MsgBox(36, "Associate IBF File?", "Would you like to associate ibf(IDM Backup File)?", 0, $hGUI_BM)
	If $iMsgBoxAnswer = 6 Then;Yes
		_AssociateIBFFile()
	EndIf
EndFunc   ;==>_ShellInstall

Func _AssociateIBFFile()
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
EndFunc   ;==>_AssociateIBFFile

Func _SwLicense()
	If FileExists($s_License_File) Then
		_SwEditGUI($s_License_File, "License")
	Else
		MsgBox(64, "License", "IDM Backup Manager v" & $s_Current_Version & "(Beta) Copyright (c) 2012-2016, Gajjar Tejas" & @CRLF & "7-Zip Copyright (C) 1999-2013 Igor Pavlov (GPL)" & @CRLF & @CRLF & "THE SOFTWARE IS PROVIDED" & '"' & "AS IS" & '"' & "AND THE AUTHOR DISCLAIMS ALL WARRANTIESWITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OFMERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FORANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGESWHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN ANACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OFOR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.", 0, $hGUI_BM)
	EndIf
EndFunc   ;==>_SwLicense
#EndRegion Help

#Region Setting
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

	$s_Backup_Dir = FileSelectFolder("Choose a folder to save file...", $s_Backup_Dir, 7, $s_Backup_Dir, $hGUI_BM)
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

	$s_AppDataIDMFolder = FileSelectFolder("Choose a folder to save file...", $s_AppDataIDMFolder, 7, $s_AppDataIDMFolder, $hGUI_BM)
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

	$s_TempPath = FileSelectFolder("Choose a folder...", $s_TempPath, 7, $s_TempPath, $hGUI_BM)
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
	IniWrite($s_Setting_File, "More Setting", "CheckUpdate_Background", $b_CheckUpdate_Background)
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
#EndRegion Setting

#Region Backup
Func _ChooseBackupFile()
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Ready")
	_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo

	If Not FileExists($s_Backup_Dir) Then DirCreate($s_Backup_Dir)

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

	;close IDM If running
	_WarnAndCloseIDM();

	#Region ;/Define Some variable: $s_Backup_File, $s_Compression_Level--->
	Local $s_Backup_File = GUICtrlRead($h_Input_Backup_Path)
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: User Selected Backup to  " & "=" & ' "' & $s_Backup_File & '"')

	Local $s_Compression_Level = GUICtrlRead($h_Combo_Compression_Level_Backup)
	If $s_Compression_Level = "" Then $s_Compression_Level = "1-No Compression"
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Compression Level " & "=" & ' "' & $s_Compression_Level & '"')
	#EndRegion ;/Define Some variable: $s_Backup_File, $s_Compression_Level--->

	#Region ;/Check Password, Drive Space, Condition and PreRequestes--->
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

	Local $b_Password = False, $s_Password = GUICtrlRead($h_Input_Password_Backup)
	If $s_Password <> "" Then
		If StringInStr($s_Password, """") Or StringInStr($s_Password, '''') Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Password Doesn't Contain Double Quote or Single Quote")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusWarning);StatusWarning
			FileWriteLine($s_Log_File, _Current_Moment() & "Password Doesn't Contain Double Quote or Single Quote")
			_ControlUpdateDefault()
			Return SetError(1)
		Else
			$b_Password = True
		EndIf
	Else
		$b_Password = False
		$s_Password = ""
	EndIf
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Password= " & '"' & _HexToString($b_Password) & '"')

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
	#EndRegion ;/Check Password, Drive Space, Condition and PreRequestes--->

	#Region ;/Check registry and count--->
	If Not _RegKeyExists($s_regpath_IDM) Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Registry Entry Is Empty. Nothing To Backup")
		_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusError);StatusError
		FileWriteLine($s_Log_File, _Current_Moment() & "Error: Registry Entry Is Empty. Nothing To Backup!")
		_ControlUpdateDefault()
		Return SetError(1)
	Else
		_GUICtrlStatusBar_SetText($h_Status_Info, "Counting Registry Key Please Wait...")
		Local $iTotalKey = _iCountKey($s_regpath_IDM)
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Total Registry Need to Backup = " & '"' & $iTotalKey & '"')
	EndIf
	#EndRegion ;/Check registry and count--->

	#Region ;/Expert registry --->
	_GUICtrlStatusBar_SetText($h_Status_Info, "Backingup: Registry Registry Please Wait...")
	_RegBackup($s_reg_File, $s_regpath_IDM)
	#EndRegion ;/Expert registry --->

	#Region ;/define backup type--->
	Local $b_DwnlData_Folder = False
	Local $b_Grabber_Folder = False
	Local $b_Scheduler_Folder = False
	Local $b_History_Files = False

	;write ini
	IniWrite($s_ini_File, "Default", "AppDataIDMFolder", $s_AppDataIDMFolder)
	IniWrite($s_ini_File, "Default", "TempPath", $DwnlData_Folder)
	IniWrite($s_ini_File, "Default", "idmvers", RegRead($s_regpath_IDM, "idmvers"))
	IniWrite($s_ini_File, "Default", "Keys", $iTotalKey)
	IniWrite($s_ini_File, "Default", "Password", $b_Password)
	IniWrite($s_ini_File, "Default", "Username", @UserName)

	; Show local date/time as UTC
	Local $tTime = _Date_Time_EncodeFileTime(@MON, @MDAY, @YEAR, @HOUR, @MIN, @SEC)
	Local $tLocal = _Date_Time_LocalFileTimeToFileTime($tTime)

	IniWrite($s_ini_File, "Default", "FileDate", _Date_Time_FileTimeToStr($tLocal, 1))

	IniWrite($s_ini_File, "GuestSystemInfo", "ComputerName", @ComputerName)
	IniWrite($s_ini_File, "GuestSystemInfo", "LogonDNSDomain", @LogonDNSDomain)
	IniWrite($s_ini_File, "GuestSystemInfo", "LogonDomain", @LogonDomain)
	IniWrite($s_ini_File, "GuestSystemInfo", "LogonServer", @LogonServer)
	IniWrite($s_ini_File, "GuestSystemInfo", "OSArch", @OSArch)
	IniWrite($s_ini_File, "GuestSystemInfo", "OSBuild", @OSBuild)
	IniWrite($s_ini_File, "GuestSystemInfo", "OSLang", @OSLang)
	IniWrite($s_ini_File, "GuestSystemInfo", "OSServicePack", @OSServicePack)
	IniWrite($s_ini_File, "GuestSystemInfo", "OSType", @OSType)
	IniWrite($s_ini_File, "GuestSystemInfo", "OSVersion", @OSVersion)


	IniWrite($s_ini_File, "AppInfo", "AppVersion", FileGetVersion(@AutoItExe))
	IniWrite($s_ini_File, "AppInfo", "AutoItVersion", @AutoItVersion)
	IniWrite($s_ini_File, "AppInfo", "AutoItX64", @AutoItX64)
	IniWrite($s_ini_File, "AppInfo", "ScriptFullPath", @AutoItExe)



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
	#EndRegion ;/define backup type--->

	#Region ;/Build Data array and Write INI--->

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

	#Region ;/add INI--->
	If FileExists($s_ini_File) Then
		$aData[13] = $s_ini_File
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $s_ini_File " & "=" & ' "' & $s_ini_File & '"')
	Else
		$aData[13] = ""
		FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $s_ini_File Reason: File Does Not Exits= " & '"' & $s_ini_File & '"')
	EndIf
	#EndRegion ;/add INI--->

	#Region ;/add registry--->
	If FileExists($s_reg_File) Then
		$aData[14] = $s_reg_File
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Found $s_ini_File " & "=" & ' "' & $s_reg_File & '"')
	Else
		$aData[14] = ""
		FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added $s_ini_File Reason: File Does Not Exits= " & '"' & $s_reg_File & '"')
	EndIf
	#EndRegion ;/add registry--->
	#EndRegion ;/Build Data array and Write INI--->

	#Region ;/add Data Files-#Au3Stripper_Off-->
	_GUICtrlStatusBar_SetText($h_Status_Info, "Adding: Data Files Please Wait...")

	_7ZipStartup()
	_7ZipSetOwnerWindowEx($hGUI_BM, "_ARCHIVERPROC_ADD")
	Local $foo = _7ZipAdd($hGUI_BM, $s_Backup_File, $aData, $s_Compression_Level, $s_Password)

	Local $sFile = StringSplit($foo, @CRLF, 1)
	For $i = 1 To $sFile[0]
		If $sFile[$i] <> "" Then FileWriteLine($s_Log_File, _Current_Moment() & "7z Log: = " & $sFile[$i])
	Next

	_7ZipShutdown()
	#EndRegion ;/add Data Files-#Au3Stripper_Off-->

	_CleanINInReg()
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Done")
	_ControlUpdateDefault()
	_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
	If $b_OpenFolder Then _SelectFile($s_Backup_File)
	FileWriteLine($s_Log_File, "============================= Backup Session Ended =============================")
EndFunc   ;==>_Backup
#EndRegion Backup

#Region Restore
Func _ChooseRestoreFile()

	If Not FileExists($s_Backup_Dir) Then DirCreate($s_Backup_Dir)

	Local $s_Restore_File = FileOpenDialog("Open Backup File", $s_Backup_Dir, "IDM Backup File (*.ibf)|All Files(*.*)", 3, "*.ibf", $hGUI_BM)
	If @error Then
	Else
		GUICtrlSetState($h_Button_Restore_Archive_Info, $GUI_ENABLE)
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

	;close IDM If running
	_WarnAndCloseIDM();

	#Region ;/Define Some variable: $s_Restore_File
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

	Local $s_Password = GUICtrlRead($h_Input_Password_Restore)
	If $s_Password <> "" Then
		If StringInStr($s_Password, """") Or StringInStr($s_Password, '''') Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Password Doesn't Contain Double Quote or Single Quote")
			_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusWarning);StatusWarning
			FileWriteLine($s_Log_File, _Current_Moment() & "Password Doesn't Contain Double Quote or Single Quote")
			_ControlUpdateDefault()
			Return SetError(1)
		EndIf
	EndIf
	#EndRegion ;/Define Some variable: $s_Restore_File

	#Region ;/Check Backup File, Read Guest ini setting and Check For Password
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Reading Backup File Please Wait...")

	_ResetDataAray($aData)
	$aData[13] = "idm_guest_Setting.ini"
	$aData[14] = "IDMregistry.reg"

	_7ZipStartup()
	_7ZipSetOwnerWindowEx($hGUI_BM, "_ARCHIVERPROC_EXT")
	Local $foo = _7ZipExtractEx($hGUI_BM, $s_Restore_File, @TempDir, $aData, $s_Password);Extract ini,reg File -> Check For Password

	If $foo <> 0 And FileExists($s_ini_File) Then ;Check if INI available and Succeful Extract

		Local $Guest_Username = IniRead($s_ini_File, "Default", "Username", "");Tejas
		Local $Guest_DwnlData_Folder = IniRead($s_ini_File, "Default", "DwnlData_Folder", "True");True
		Local $Guest_Grabber_Folder = IniRead($s_ini_File, "Default", "Grabber_Folder", "True");True
		Local $Guest_GrabberData_Folder = IniRead($s_ini_File, "Default", "GrabberData_Folder", "True");True
		Local $Guest_Scheduler_Folder = IniRead($s_ini_File, "Default", "Scheduler_Folder", "True");True
		Local $Guest_History_Files = IniRead($s_ini_File, "Default", "History_Files", "True");True

		If $s_Password = "" Then FileWriteLine($s_Log_File, _Current_Moment() & "Info: Backup Files is Not Password Protected")
	Else
		If $s_Password = "" Then
			_GUICtrlStatusBar_SetText($h_Status_Info, "Error: Backup may be password-protected or file damaged.")
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
	EndIf
	#EndRegion ;/Check Backup File, Read Guest ini setting and Check For Password

	#Region ;/Remove TempPath--->

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
	#EndRegion ;/Remove TempPath--->

	#Region ;/define Restore type--->
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
	#EndRegion ;/define Restore type--->

	#Region ;/Restore Data--->

	_ResetDataAray($aData)

	#Region Restore part-1

	#Region Restore DwnlData\
	;If Unfinished Download Data Selectde Then
	If $b_DwnlData_Folder Then
		If $Guest_DwnlData_Folder = "True" Then
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_DwnlData_Folder= " & '"' & $Guest_DwnlData_Folder & '"')
			$aData[0] = "DwnlData" & "\"
		Else
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_DwnlData_Folder= " & '"' & $Guest_DwnlData_Folder & '"')
		EndIf
	EndIf
	#EndRegion Restore DwnlData\

	#Region Restore GrabberData\
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
	#EndRegion Restore GrabberData\

	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Restoring DwnlData & GrabberData Folder Please Wait...")
	_GUICtrlStatusBar_SetText($h_Status_Info, "Restoring: DwnlData & GrabberData Folder Please Wait...")
	$foo = _7ZipExtractEx($hGUI_BM, $s_Restore_File, $s_TempPath, $aData, $s_Password)

	Local $sFile = StringSplit($foo, @CRLF, 1)
	For $i = 1 To $sFile[0]
		If $sFile[$i] <> "" Then FileWriteLine($s_Log_File, _Current_Moment() & "7z Log: = " & $sFile[$i])
	Next
	#EndRegion Restore part-1

	_ResetDataAray($aData)
	_GUICtrlStatusBar_SetText($h_Status_Info, "Removing: Files and Folder Please Wait...")

	#Region Restore part-2
	#Region Restore Scheduler\
	;If Scheduler Data Selectde Then
	If $b_Scheduler_Folder Then
		If $Guest_Scheduler_Folder = "True" Then
			$aData[3] = "Scheduler" & "\"
		EndIf
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_Scheduler_Folder= " & '"' & $Guest_Scheduler_Folder & '"')
	EndIf
	#EndRegion Restore Scheduler\

	#Region Restore History_Files
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
	#EndRegion Restore History_Files

	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Restoring AppDataIDMFolder Folder Please Wait...")
	_GUICtrlStatusBar_SetText($h_Status_Info, "Restoring: AppDataIDMFolder Folder Please Wait...")

	$foo = _7ZipExtractEx($hGUI_BM, $s_Restore_File, $s_AppDataIDMFolder, $aData, $s_Password)

	$sFile = StringSplit($foo, @CRLF, 1)
	For $i = 1 To $sFile[0]
		If $sFile[$i] <> "" Then FileWriteLine($s_Log_File, _Current_Moment() & "7z Log: = " & $sFile[$i])
	Next
	#EndRegion Restore part-2

	_7ZipShutdown()
	#EndRegion ;/Restore Data--->

	#Region ;/Remove Temp Registry File--->
	If _RegKeyExists($s_regpath_IDM & "_tmp") Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "Removing: Temp Registry Please Wait...")
		If Not RegDelete($s_regpath_IDM & "_tmp") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete Registry " & "=" & ' "' & $s_regpath_IDM & "_tmp" & '" ' & "Error Code:" & @error)
	EndIf
	#EndRegion ;/Remove Temp Registry File--->

	#Region ;/CAppend/Merge--->
	;Append/Merge Registry Checkbox Is Checked Then
	If GUICtrlRead($h_Checkbox_Append_Registry_Restore) = $GUI_CHECKED Then
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Appending/Merging Profile")

		_GUICtrlStatusBar_SetText($h_Status_Info, "Appending/Merging: Profile Please Wait...")
		_AppendRegKeys()
		If @error Then FileWriteLine($s_Log_File, _Current_Moment() & "Error: Error Occured during Appending/Merging Profile Error Code:" & @error)
	Else
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Append/Merge Profile Not Selected.")
	EndIf
	#EndRegion ;/CAppend/Merge--->

	#Region ;/Convert Profile--->
	;Convert Registry Checkbox Is Checked Then
	If GUICtrlRead($h_Checkbox_Convert_Registry_Restore) = $GUI_CHECKED Then

		;Registry Renames
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Converting Registry Profile")

		_GUICtrlStatusBar_SetText($h_Status_Info, "Converting: Profile Please Wait...")

		_ConvertRegProfile()
		If @error Then FileWriteLine($s_Log_File, _Current_Moment() & "Error: Error Occured during Converting Profile Error Code:" & @error)

		;Folder Renames
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Converting Folder Profile")

		Local $status
		If FileExists($DwnlData_Folder & $Guest_Username) Then
			;DirMove($DwnlData_Folder & $Guest_Username, $DwnlData_Folder & @UserName, 1)
			$status = _MoveDirEx($DwnlData_Folder & $Guest_Username, $DwnlData_Folder & @UserName)
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Renaming-->" & $DwnlData_Folder & $Guest_Username)
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: To-->" & $DwnlData_Folder & @UserName & " Error Code" & $status)
		EndIf
		If FileExists($DwnlData_Folder & "GrabberData\" & $Guest_Username) Then
			;DirMove($DwnlData_Folder & "GrabberData\" & $Guest_Username, $DwnlData_Folder & "GrabberData\" & @UserName, 1)
			$status = _MoveDirEx($DwnlData_Folder & "GrabberData\" & $Guest_Username, $DwnlData_Folder & "GrabberData\" & @UserName)
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Renaming-->" & $DwnlData_Folder & "GrabberData\" & $Guest_Username)
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: To-->" & $DwnlData_Folder & "GrabberData\" & @UserName & " Error Code" & $status)
		EndIf

		_FileOrFolderDeleteWithLog($DwnlData_Folder & $Guest_Username)

	Else
		FileWriteLine($s_Log_File, _Current_Moment() & "Info: Profile Conversion Not Selected.")
	EndIf
	#EndRegion ;/Convert Profile--->

	#Region ;/Read Host Registry and store in tmp Registory(Free From Registry Conversion)--->
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
	#EndRegion ;/Read Host Registry and store in tmp Registory(Free From Registry Conversion)--->

	#Region ;/Remove Host Registry--->
	;if Append/Merge Not Selected then
	If GUICtrlRead($h_Checkbox_Append_Registry_Restore) = $GUI_UNCHECKED Then
		_GUICtrlStatusBar_SetText($h_Status_Info, "Removing: Registry Please Wait...")
		If _RegKeyExists($s_regpath_IDM) Then
			If Not RegDelete($s_regpath_IDM) Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete Host Registry " & "=" & ' "' & $s_regpath_IDM & '" ' & "Error Code:" & @error)
		EndIf
	EndIf
	#EndRegion ;/Remove Host Registry--->

	#Region ;/Restore Guest Registry-->
	_GUICtrlStatusBar_SetText($h_Status_Info, "Restoring: Registry Please Wait...")
	;If Registry Restore allowed via Checkbox
	_RegImport($s_reg_File)
	#EndRegion ;/Restore Guest Registry-->

	#Region ;/Restore Host Registry from stored in tmp Registry--->
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
	#EndRegion ;/Restore Host Registry from stored in tmp Registry--->

	#Region ;/Remove tmp Registry--->
	_GUICtrlStatusBar_SetText($h_Status_Info, "Removing: Temp Registry Please Wait...")
	If _RegKeyExists($s_regpath_IDM & "_tmp") Then
		If Not RegDelete($s_regpath_IDM & "_tmp") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete Registry " & "=" & ' "' & $s_regpath_IDM & "_tmp" & '" ' & "Error Code:" & @error)
	EndIf
	#EndRegion ;/Remove tmp Registry--->

	_CleanINInReg()

	If $b_RestartIDM Then _RunIDMexe()

	_ControlUpdateDefault()
	_GUICtrlStatusBar_SetText($h_Status_Info, "INFO: Done")
	_GUICtrlStatusBar_SetIcon($h_Status_Info, 0, $hIcons_StatusInfo);StatusInfo
	FileWriteLine($s_Log_File, "============================= Restore Session Ended =============================")
EndFunc   ;==>_Restore
#EndRegion Restore

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
