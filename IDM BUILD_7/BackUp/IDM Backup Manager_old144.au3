#NoTrayIcon

#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\IDM BUILD_2\icon.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=IDM Backup Manager 0.9.7.0
#AutoIt3Wrapper_Res_Description=IDM Backup Manager 0.9.7.0
#AutoIt3Wrapper_Res_Fileversion=0.9.7.0
#AutoIt3Wrapper_Res_LegalCopyright=©Gajjar Tejas 2012-2013
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
;																;__AET_ButtonSetIcon  |GUICtrlSetImage  |
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Backup.ico				;4					  |-5				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Open.ico 					;5					  |-6				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Forum.ico					;6					  |-7				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Help.ico					;7					  |-8				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\icon.ico					;8					  |-9				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Internet.ico				;9					  |-10				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Licence.ico				;10					  |-11				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Log.ico					;11					  |-12				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Ok.ico					;12					  |-13				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\ok32.ico					;13					  |-14				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Restore.ico				;14					  |-15				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Run.ico					;15					  |-16				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\search.ico				;16					  |-17				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Tool.ico					;17					  |-18				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Update.ico				;18					  |-19				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\FileType.ico				;19					  |-20				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Save.ico					;20					  |-21				|
#AutoIt3Wrapper_Res_Icon_Add=Resorces\Setting.ico				;21					  |-22				|
#AutoIt3Wrapper_Res_File_Add=Resorces\contactme.jpg, rt_rcdata, contactme

#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <ComboConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <ProgressConstants.au3>
#include <String.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <Memory.au3>
#include <GuiImageList.au3>

#include "_resources.au3"
#include "_FileIsPathValid.au3"
#include "_RegFunc.au3"

#region global constant
Global $a_Memory = MemGetStats()
Global Const $s_regpath_IDM = "HKEY_CURRENT_USER\Software\DownloadManager"
Global Const $s_Current_Version = "0.9.7"
Global Const $s_Win_Title = "IDM Backup Manager" & $s_Current_Version & "(Beta)"
Global $i_xWinPos = (@DesktopWidth - 439) / 2
Global $i_yWinPos = (@DesktopHeight - 276) / 2

;~ Global Const $s_Setting_File = @ScriptDir & "\SettingFile.ini" ;for portable
;~ Global $s_Log_File = @ScriptDir & "\LogFile.log" ;for portable

Global Const $s_Setting_File = @AppDataDir & "\IDM Backup Manager" & "\SettingFile.ini" ;for installer
Global $s_Log_File = @AppDataDir & "\IDM Backup Manager" & "\LogFile.log" ;for installer
Global $s_Backup_Dir = @MyDocumentsDir & "\IDM Backup Files"
Global $b_AppendLog_File = 1

Global Const $s_7zexe_Path = @ScriptDir & '\7z.exe'

Global $s_AppDataIDMFolder = _sGet_AppDataIDMFolder() ;contain back "\"
Global $DwnlData_Folder = _sGet_TempPathFolder() ;contain back "\"
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

Global $s_Backup_File = ""
Global $s_Restore_File = ""
#endregion global constant

#region ini setting
If FileExists($s_Setting_File) Then
	$i_xWinPos = IniRead($s_Setting_File, "Position", "x", $i_xWinPos)
	$i_yWinPos = IniRead($s_Setting_File, "Position", "y", $i_yWinPos)

	$s_Backup_Dir = IniRead($s_Setting_File, "Default Paths", "Backup_Dir", $s_Backup_Dir)
	$s_Log_File = IniRead($s_Setting_File, "Default Paths", "Log_File", $s_Log_File)

	$s_AppDataIDMFolder = IniRead($s_Setting_File, "Profile Paths", "AppDataIDMFolder", $s_AppDataIDMFolder);contain back "\"
	$DwnlData_Folder = IniRead($s_Setting_File, "Profile Paths", "DwnlData_Folder", $DwnlData_Folder);contain back "\"

	$b_AppendLog_File = IniRead($s_Setting_File, "More Setting", "Append_Log_File", $b_AppendLog_File)
	If $b_AppendLog_File = 0 And FileExists($s_Log_File) Then FileDelete($s_Log_File)
Else
	If Not BitOR(FileExists(@AppDataDir & "\IDM Backup Manager"), DirCreate(@AppDataDir & "\IDM Backup Manager")) Then MsgBox(16, "Warning", "Log File NOT Created.Please Choose Other Location.(Setting-->LogFile)")

	IniWrite($s_Setting_File, "Position", "x", $i_xWinPos)
	IniWrite($s_Setting_File, "Position", "y", $i_yWinPos)

	IniWrite($s_Setting_File, "Default Paths", "Backup_Dir", $s_Backup_Dir)
	IniWrite($s_Setting_File, "Default Paths", "Log_File", $s_Log_File)

	IniWrite($s_Setting_File, "Profile Paths", "AppDataIDMFolder", $s_AppDataIDMFolder)
	IniWrite($s_Setting_File, "Profile Paths", "DwnlData_Folder", $DwnlData_Folder)

	IniWrite($s_Setting_File, "More Setting", "Append_Log_File", $b_AppendLog_File)
EndIf
#endregion ini setting

_log_Sysinfo()
_Check_Componment()
_Check_IDM_Process()
_log_Profile_Paths()

#region ### START Koda GUI section ###

Global $h_IDMBM = GUICreate($s_Win_Title, 439, 276, $i_xWinPos, $i_yWinPos)

$h_Tab1 = GUICtrlCreateTab(10, 10, 420, 240)

#region backup ;==============================================================================================Backup:

$h_TabSheet1 = GUICtrlCreateTabItem("Backup Data")
GUICtrlSetImage(-1, @ScriptFullPath, -5)
$h_Group1 = GUICtrlCreateGroup("Backup Location", 24, 44, 390, 55)
GUICtrlSetFont(-1, 2, 800, 0, "MS Sans Serif")

$h_Input_Backup_Path = GUICtrlCreateInput("", 33, 64, 336, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
GUICtrlCreateGroup("", -99, -99, 1, 1)

$h_Button_Browse_Backup = GUICtrlCreateButton("", 376, 63, 30, 23)
__AET_ButtonSetIcon(-1, 20, 16, 16, 4)
GUICtrlSetTip(-1, "Browse For Backup File")

$h_Group2 = GUICtrlCreateGroup("Options", 24, 104, 390, 100)
GUICtrlSetFont(-1, 1, 800, 0, "MS Sans Serif")

$h_Checkbox_Password_Backup = GUICtrlCreateCheckbox("", 38, 130, 12, 17)
GUICtrlSetTip(-1, "Choose Yes If You Want Encryption of Your Backup Files Which Is Required Strong Password", "Backup Password", 1, 1)

$h_Input_Password_Backup = GUICtrlCreateInput("Password", 54, 128, 130, 21, $ES_PASSWORD)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSendMsg(-1, $EM_SETCUEBANNER, True, "Password")
GUICtrlSetTip(-1, "Choose Yes If You Want Encryption of Your Backup Files Which Is Required Strong Password", "Backup Password", 1, 1)

$h_Checkbox_Compression_Level_Backup = GUICtrlCreateCheckbox("", 39, 159, 12, 17)
GUICtrlSetTip(-1, "Here You Can Set The Compression Level of The Backup Files" & @CRLF & "", "Compression Level", 1, 1)

$h_Combo_Compression_Level_Backup = GUICtrlCreateCombo("1-No Compression", 54, 157, 130, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetData(-1, "2-Fastest Compression|3-Fast Compression|4-Normal Compression|5-Maximum Compression|6-Ultra Compression", "1-No Compression")
GUICtrlSetTip(-1, "Here You Can Set The Compression Level of The Backup Files" & @CRLF & "", "Compression Level", 1, 1)

$h_Checkbox_Full_Backup = GUICtrlCreateCheckbox("Full Backup", 200, 128, 107, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$h_Checkbox_Listl_Backup = GUICtrlCreateCheckbox("Only List Backup", 310, 128, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$h_Checkbox_UnFinished_DD_Backup = GUICtrlCreateCheckbox("Downloaded Data", 200, 149, 107, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$h_Checkbox_UnFinished_GD_Backup = GUICtrlCreateCheckbox("Grabber Data", 310, 149, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$h_Checkbox_UnFinished_SD_Backup = GUICtrlCreateCheckbox("Scheduler Data", 200, 170, 107, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$h_Checkbox_UnFinished_HL_Backup = GUICtrlCreateCheckbox("History and Logs", 310, 170, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$h_Button_Backup = GUICtrlCreateButton("Backup Now", 319, 217, 95, 25)
__AET_ButtonSetIcon(-1, 12, 16, 16, 0)
GUICtrlSetTip(-1, "Backup Now")
GUICtrlSetState(-1, $GUI_DISABLE)

#endregion backup ;==============================================================================================Backup:

#region Restore ;==============================================================================================Restore:

$h_TabSheet2 = GUICtrlCreateTabItem("Restore Data")
GUICtrlSetImage(-1, @ScriptFullPath, -15)
$h_Group3 = GUICtrlCreateGroup("Restore Location", 24, 44, 390, 55)
GUICtrlSetFont(-1, 2, 800, 0, "MS Sans Serif")

$h_Input_Restore_Path = GUICtrlCreateInput("", 33, 64, 336, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))

$h_Button_Browse_Restore = GUICtrlCreateButton("", 376, 63, 30, 23)
__AET_ButtonSetIcon(-1, 5, 16, 16, 4)
GUICtrlSetTip(-1, "Browse For Restore File")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group7 = GUICtrlCreateGroup("Options", 24, 104, 390, 100)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

$h_Checkbox_Password_Restore = GUICtrlCreateCheckbox("", 38, 130, 12, 17)
GUICtrlSetTip(-1, "Choose Yes If Your backup is Encrypted", "Restore Encryption", 1, 1)

$h_Input_Password_Restore = GUICtrlCreateInput("Password", 54, 128, 130, 21, $ES_PASSWORD)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSendMsg(-1, $EM_SETCUEBANNER, True, "Password")
GUICtrlSetTip(-1, "Choose Yes If Your backup is Encrypted", "Restore Encryption", 1, 1)

$h_Checkbox_Convert_Registry_Restore = GUICtrlCreateCheckbox("", 39, 159, 12, 17)
GUICtrlSetTip(-1, "Choose Yes If Destination Backup is another System" & @CRLF & @CRLF & _
		"EXAMPLE:" & @CRLF & _
		"Incase of If You Want To Restore Backup of Cybercafe to Your Home PC", "Convert Profile", 1, 1)

$h_Label_Convert_Registry_Restore = GUICtrlCreateLabel("Convert Profile", 60, 160, 73, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Choose Yes If Destination Backup is another System" & @CRLF & @CRLF & _
		"EXAMPLE:" & @CRLF & _
		"Incase of If You Want To Restore Backup of Cybercafe to Your Home PC", "Convert Profile", 1, 1)

$h_Checkbox_NoRestore_Registry = GUICtrlCreateCheckbox("Do Not Restore Registry", 200, 128, 209, 17)
$h_Checkbox_NoRestore_Data = GUICtrlCreateCheckbox("Do Not Restore Data", 200, 149, 209, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$h_Button_Restore = GUICtrlCreateButton("Restore Now", 319, 217, 95, 25)
__AET_ButtonSetIcon(-1, 12, 16, 16, 0)
GUICtrlSetTip(-1, "Restore Now")
GUICtrlSetState(-1, $GUI_DISABLE)
#endregion Restore ;==============================================================================================Restore:

#region Tools ;============================================================================================== Tools:

$TabSheet3 = GUICtrlCreateTabItem("Tools")
GUICtrlSetImage(-1, @ScriptFullPath, -18)

$Group4 = GUICtrlCreateGroup("Tools", 24, 44, 390, 160)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

$h_Button_List_Manager_Tools = GUICtrlCreateButton("Downloads List Manager", 39, 64, 97, 73, $BS_MULTILINE)
If Not FileExists(@ScriptDir & "\IDM List Manager.exe") Then GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Download List Manager is allow to use Join Unfinished Downloaded Files, Remove Download From Lisr and much more")

$h_Button_Clean_Manager_Tools = GUICtrlCreateButton("Run Cleaner", 144, 64, 97, 73)
GUICtrlSetTip(-1, "Clean History, Logs and Unfinished Download Data.")
GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion Tools ;============================================================================================== Tools:

#region Setting ;============================================================================================== Setting:
$TabSheet5 = GUICtrlCreateTabItem("Setting")
GUICtrlSetImage(-1, @ScriptFullPath, -22)

$Group4 = GUICtrlCreateGroup("Default Path", 24, 44, 390, 80)
$h_Label_LogFile_Setting = GUICtrlCreateInput($s_Log_File, 144, 64, 265, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$h_Button_BrowseLogFile_Setting = GUICtrlCreateButton("Log File Path:", 32, 60, 107, 25)

$h_Label_BrowseDataBackupFolder_Setting = GUICtrlCreateInput($s_Backup_Dir, 144, 96, 265, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$h_Button_BrowseDataBackupFolder_Setting = GUICtrlCreateButton("Backup Folder:", 32, 92, 107, 25)

GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group5 = GUICtrlCreateGroup("Default Profile", 24, 128, 393, 81)
$h_Label_BrowseAppDataFolder_Setting = GUICtrlCreateInput($s_AppDataIDMFolder, 144, 150, 265, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$h_Button_BrowseAppDataFolder_Setting = GUICtrlCreateButton("AppData Folder", 32, 146, 107, 25)
$h_Label_DwnlDataFolder_Setting = GUICtrlCreateInput($DwnlData_Folder, 144, 182, 265, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$h_Button_DwnlDataFolder_Setting = GUICtrlCreateButton("DwnlData Folder:", 32, 178, 107, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Button_RestoreDefault_Setting = GUICtrlCreateButton("Restore Default", 320, 216, 99, 25)

$h_Button_Associate_Setting = GUICtrlCreateButton("Associate .IBF files", 172, 216, 146, 25)
__AET_ButtonSetIcon(-1, 19, 24, 24, 0)

$h_Button_More_Setting = GUICtrlCreateButton("More Setting...", 24, 216, 147, 25)
__AET_ButtonSetIcon(-1, 21, 24, 24, 0)
GUICtrlCreateTabItem("")
#endregion Setting ;============================================================================================== Setting:

#region Help ;============================================================================================== Help:

$TabSheet4 = GUICtrlCreateTabItem("Help")
GUICtrlSetImage(-1, @ScriptFullPath, -8)

$Group6 = GUICtrlCreateGroup("Help and Update", 24, 44, 390, 160)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

$h_Button_Website_Help = GUICtrlCreateButton("  Website", 37, 126, 100, 30, $BS_left)
__AET_ButtonSetIcon(-1, 9, 24, 24, 0)

$h_Button_Help_Help = GUICtrlCreateButton("  Help", 37, 66, 100, 30, $BS_left)
__AET_ButtonSetIcon(-1, 7, 24, 24, 0)

$h_Button_Licence_Help = GUICtrlCreateButton("  Licence", 37, 96, 100, 30, $BS_left)
__AET_ButtonSetIcon(-1, 10, 24, 24, 0)

$h_Button_View_Log_Help = GUICtrlCreateButton("  View Log", 146, 66, 100, 30, $BS_left)
__AET_ButtonSetIcon(-1, 11, 24, 24, 0)

$h_Button_Forum_Help = GUICtrlCreateButton("  Forum", 146, 96, 100, 30, $BS_left)
__AET_ButtonSetIcon(-1, 6, 24, 24, 0)

$h_Button_Update_Help = GUICtrlCreateButton("  Update", 146, 126, 100, 30, $BS_left);1111
__AET_ButtonSetIcon(-1, 18, 24, 24, 0)

$h_Pic_Help = GUICtrlCreatePic("", 260, 55, 150, 145)
_ResourceSetImageToCtrl($h_Pic_Help, "contactme")

GUICtrlCreateGroup("", -99, -99, 1, 1)
#endregion Help ;============================================================================================== Help:

GUICtrlCreateTabItem("")
#region Info Label
$h_Label_Info = GUICtrlCreateLabel("INFO: Full Backup Selected", 12, 253, 413, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
#endregion Info Label

#endregion ### END Koda GUI section ###

GUISetState(@SW_SHOW)
FileWriteLine($s_Log_File, _Current_Moment() & "Info: Window Created: " & $s_Win_Title & " With Error Code: " & @error)
_check_cmd()

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
			Else
				GUICtrlSetState($h_Label_Convert_Registry_Restore, $GUI_DISABLE)
			EndIf

		Case $h_Checkbox_Full_Backup
			If GUICtrlRead($h_Checkbox_Full_Backup) = $GUI_CHECKED Then
				GUICtrlSetData($h_Label_Info, "INFO: Full Backup Selected")
				GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
			Else
				GUICtrlSetData($h_Label_Info, "INFO: Ready")
				GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_ENABLE)
				GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_ENABLE)
				GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_ENABLE)
				GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_ENABLE)
				GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
			EndIf

		Case $h_Checkbox_Listl_Backup
			If GUICtrlRead($h_Checkbox_Listl_Backup) = $GUI_CHECKED Then
				GUICtrlSetData($h_Label_Info, "INFO: List Backup Selected. Only IDM List and Setting Backup")
				GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
			Else
				GUICtrlSetData($h_Label_Info, "INFO: Ready")
				GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_ENABLE)
				GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_ENABLE)
				GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_ENABLE)
				GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_ENABLE)
				GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
			EndIf

		Case $h_Checkbox_UnFinished_SD_Backup
			If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Then
				GUICtrlSetData($h_Label_Info, "INFO: Custom Backup Selected.")
				GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
			Else
				If GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_CHECKED Then
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
				Else
					GUICtrlSetData($h_Label_Info, "INFO: Ready")
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
				EndIf
			EndIf

		Case $h_Checkbox_UnFinished_GD_Backup
			If GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_CHECKED Then
				GUICtrlSetData($h_Label_Info, "INFO: Custom Backup Selected.")
				GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
			Else
				If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_CHECKED Then
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
				Else
					GUICtrlSetData($h_Label_Info, "INFO: Ready")
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
				EndIf
			EndIf

		Case $h_Checkbox_UnFinished_DD_Backup
			If GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_CHECKED Then
				GUICtrlSetData($h_Label_Info, "INFO: Custom Backup Selected.")
				GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
			Else
				If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_CHECKED Then
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
				Else
					GUICtrlSetData($h_Label_Info, "INFO: Ready")
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
				EndIf
			EndIf

		Case $h_Checkbox_UnFinished_HL_Backup
			If GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_CHECKED Then
				GUICtrlSetData($h_Label_Info, "INFO: Custom Backup Selected.")
				GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
				GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
			Else
				If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Or GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_CHECKED Or $h_Checkbox_UnFinished_DD_Backup = $GUI_CHECKED Then
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_DISABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_DISABLE)
				Else
					GUICtrlSetData($h_Label_Info, "INFO: Ready")
					GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
					GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
				EndIf
			EndIf

		Case $h_Checkbox_NoRestore_Registry
			If GUICtrlRead($h_Checkbox_NoRestore_Registry) = $GUI_CHECKED Then
				GUICtrlSetState($h_Checkbox_NoRestore_Data, $GUI_DISABLE)
			Else
				GUICtrlSetState($h_Checkbox_NoRestore_Data, $GUI_ENABLE)
			EndIf

		Case $h_Checkbox_NoRestore_Data
			If GUICtrlRead($h_Checkbox_NoRestore_Data) = $GUI_CHECKED Then
				GUICtrlSetState($h_Checkbox_NoRestore_Registry, $GUI_DISABLE)
			Else
				GUICtrlSetState($h_Checkbox_NoRestore_Registry, $GUI_ENABLE)
			EndIf

		Case $h_Button_BrowseLogFile_Setting
			$s_Log_File = FileSaveDialog("Save Log File", @ScriptDir, "Log File (*.Log)", 2, "LogFile.log", $h_IDMBM)
			If $s_Log_File <> "" And StringRight($s_Log_File, 4) <> ".log" Then $s_Log_File &= ".log"
			If Not @error Then
				GUICtrlSetData($h_Label_LogFile_Setting, $s_Log_File)
				IniWrite($s_Setting_File, "Default Paths", "Log_File", $s_Log_File)
			EndIf

		Case $h_Button_BrowseDataBackupFolder_Setting
			$s_Backup_Dir = FileSelectFolder("Choose a folder to save file...", "", 7, $s_Backup_Dir, $h_IDMBM)

			If _FileIsPathValid($s_Backup_Dir) = "True" Then ;User Selected valid path
				GUICtrlSetData($h_Label_BrowseDataBackupFolder_Setting, $s_Backup_Dir)
				IniWrite($s_Setting_File, "Default Paths", "Backup_Dir", $s_Backup_Dir)
			Else
				$s_Backup_Dir = GUICtrlRead($h_Label_BrowseDataBackupFolder_Setting)
			EndIf

		Case $h_Button_BrowseAppDataFolder_Setting
			$s_AppDataIDMFolder = FileSelectFolder("Choose a folder to save file...", "", 7, $s_AppDataIDMFolder, $h_IDMBM)
			If StringRight($s_AppDataIDMFolder, 1) <> "\" Then $s_AppDataIDMFolder &= "\"

			If _FileIsPathValid($s_AppDataIDMFolder) = "True" Then ;User Selected valid path
				GUICtrlSetData($h_Label_BrowseAppDataFolder_Setting, $s_AppDataIDMFolder)
				IniWrite($s_Setting_File, "Profile Paths", "AppDataIDMFolder", $s_AppDataIDMFolder)
			Else
				$s_AppDataIDMFolder = GUICtrlRead($h_Label_BrowseAppDataFolder_Setting)
			EndIf

		Case $h_Button_DwnlDataFolder_Setting
			$DwnlData_Folder = FileSelectFolder("Choose a folder to save file...", "", 7, $DwnlData_Folder, $h_IDMBM)
			If StringRight($DwnlData_Folder, 1) <> "\" Then $DwnlData_Folder &= "\"

			If _FileIsPathValid($DwnlData_Folder) = "True" Then ;User Selected valid path
				GUICtrlSetData($h_Label_DwnlDataFolder_Setting, $DwnlData_Folder)
				IniWrite($s_Setting_File, "Profile Paths", "DwnlData_Folder", $DwnlData_Folder)
			Else
				$DwnlData_Folder = GUICtrlRead($h_Label_DwnlDataFolder_Setting)
			EndIf

		Case $Button_RestoreDefault_Setting
			$i_xWinPos = (@DesktopWidth - 439) / 2
			$i_yWinPos = (@DesktopHeight - 276) / 2

			$s_Backup_Dir = @MyDocumentsDir & "\IDM Backup Files"
			$s_Log_File = @AppDataDir & "\IDM Backup Manager" & "\LogFile.log" ;for installer

			$s_AppDataIDMFolder = _sGet_AppDataIDMFolder()
			$DwnlData_Folder = _sGet_TempPathFolder()

			$b_AppendLog_File = 1

			GUICtrlSetData($h_Label_BrowseDataBackupFolder_Setting, $s_Backup_Dir)
			GUICtrlSetData($h_Label_LogFile_Setting, $s_Log_File)
			GUICtrlSetData($h_Label_BrowseAppDataFolder_Setting, $s_AppDataIDMFolder)
			GUICtrlSetData($h_Label_DwnlDataFolder_Setting, $DwnlData_Folder)

			IniWrite($s_Setting_File, "Position", "x", $i_xWinPos)
			IniWrite($s_Setting_File, "Position", "y", $i_yWinPos)

			IniWrite($s_Setting_File, "Default Paths", "Backup_Dir", $s_Backup_Dir)
			IniWrite($s_Setting_File, "Default Paths", "Log_File", $s_Log_File)

			IniWrite($s_Setting_File, "Profile Paths", "AppDataIDMFolder", $s_AppDataIDMFolder);contain back "\"
			IniWrite($s_Setting_File, "Profile Paths", "DwnlData_Folder", $DwnlData_Folder);contain back "\"

			IniWrite($s_Setting_File, "More Setting", "Append_Log_File", $b_AppendLog_File) ;Boolean

		Case $h_Button_Browse_Backup
			GUICtrlSetData($h_Label_Info, "INFO: Ready")
			$s_Backup_File = FileSaveDialog("Save Backup File", $s_Backup_Dir, "IDM Backup File (*.ibf)", 18, "IDMbackup" & @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC & ".ibf", $h_IDMBM)
			If $s_Backup_File <> "" And StringRight($s_Backup_File, 4) <> ".ibf" Then $s_Backup_File &= ".ibf"

			If @error Then
				GUICtrlSetData($h_Label_Info, "INFO: Ready")
			Else
				If FileExists($s_Backup_File) Then
					If FileDelete($s_Backup_File) = 0 Then
						GUICtrlSetState($h_Button_Backup, $GUI_DISABLE)
						GUICtrlSetData($h_Input_Backup_Path, "")
						GUICtrlSetData($h_Label_Info, "Error: Files Could Not Deleted")
					Else
						GUICtrlSetState($h_Button_Backup, $GUI_ENABLE)
						GUICtrlSetData($h_Label_Info, "INFO: Ready")
						GUICtrlSetData($h_Input_Backup_Path, $s_Backup_File)
					EndIf
				Else
					GUICtrlSetData($h_Input_Backup_Path, $s_Backup_File)
					GUICtrlSetState($h_Button_Backup, $GUI_ENABLE)
				EndIf
			EndIf

		Case $h_Button_Backup
			FileWriteLine($s_Log_File, "")
			FileWriteLine($s_Log_File, "============================= Backup Session Started =============================")
			_control_update_busy()

			#region ;/Define Some variable: $s_Backup_File, $s_Compression_Level, $s_ini_File, $s_reg_File and remove temp(ini and reg) file--->
			$s_Backup_File = GUICtrlRead($h_Input_Backup_Path)
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: User Selected Backup to  " & "=" & ' "' & $s_Backup_File & '"')

			If GUICtrlRead($h_Checkbox_Compression_Level_Backup) = $GUI_CHECKED Then
				$s_Compression_Level = GUICtrlRead($h_Combo_Compression_Level_Backup)
			Else
				$s_Compression_Level = "1-No Compression"
			EndIf

			$s_ini_File = @TempDir & "\" & "idm_guest_Setting.ini"
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: $s_ini_File= " & '"' & $s_ini_File & '"')

			$s_reg_File = @TempDir & "\" & "IDMregistry.reg"
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: $s_reg_File= " & '"' & $s_reg_File & '"')

			If FileExists($s_reg_File) Then
				If Not FileDelete($s_reg_File) Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & $s_reg_File & '" ' & "Error Code:1")
			EndIf

			If FileExists($s_ini_File) Then
				If Not FileDelete($s_ini_File) Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & $s_ini_File & '" ' & "Error Code:1")
			EndIf
			#endregion ;/Define Some variable: $s_Backup_File, $s_Compression_Level, $s_ini_File, $s_reg_File and remove temp(ini and reg) file--->

			#region ;/Check Password, Drive Space, Condition and PreRequestes--->
			If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_UNCHECKED _
					And GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_UNCHECKED _
					And GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_UNCHECKED _
					And GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_UNCHECKED _
					And GUICtrlRead($h_Checkbox_Listl_Backup) = $GUI_UNCHECKED _
					And GUICtrlRead($h_Checkbox_Full_Backup) = $GUI_UNCHECKED Then
				GUICtrlSetData($h_Label_Info, "Error: Select Backup Type")
				_control_update_default()
				ContinueLoop
			EndIf

			If GUICtrlRead($h_Checkbox_Password_Backup) = $GUI_CHECKED Then
				$s_Password = GUICtrlRead($h_Input_Password_Backup)
				If $s_Password = "" Then
					GUICtrlSetData($h_Label_Info, "Error: Password is Empty")
					FileWriteLine($s_Log_File, "Error: Password is Empty")
					_control_update_default()
					ContinueLoop
				EndIf
				$b_Password = True
			Else
				$b_Password = False
				$s_Password = ""
			EndIf
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Password= " & '"' & $b_Password & '"')

			GUICtrlSetData($h_Label_Info, "Checking : Drive Space Please Wait...")
			If DriveSpaceFree(_Drive_Get_From_Path($s_Backup_File)) < DirGetSize($s_AppDataIDMFolder) / 1024 / 1024 Then
				GUICtrlSetData($h_Label_Info, "Error: Not Enought Free Space on Drive. +" & _File_Size(DirGetSize($s_AppDataIDMFolder) - DriveSpaceFree(_Drive_Get_From_Path($s_Backup_File)) * 1024 * 1024) & " Required")

				FileWriteLine($s_Log_File, _Current_Moment() & _
						"Error: Not Enought Free Space on Drive " & _Drive_Get_From_Path($s_Backup_File) & _
						" Free Space:" & _File_Size((DriveSpaceFree(_Drive_Get_From_Path($s_Backup_File)) * 1024 * 1024)) & _
						". At Least " & _File_Size(DirGetSize($s_AppDataIDMFolder) - DriveSpaceFree(_Drive_Get_From_Path($s_Backup_File)) * 1024 * 1024) & "Required")
				_control_update_default()
				ContinueLoop
			EndIf
			#endregion ;/Check Password, Drive Space, Condition and PreRequestes--->

			#region ;/Count registry--->
			GUICtrlSetData($h_Label_Info, "Counting Registry Key Please Wait...")
			$k = 1
			While 1
				$var = RegEnumKey($s_regpath_IDM, $k)
				If @error <> 0 Then ExitLoop
				$k += 1
			WEnd
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Registry Backup Successful Total Key = " & '"' & $k & '"')
			#endregion ;/Count registry--->

			#region ;/Check registry and cont..--->
			If Not _RegKeyExists($s_regpath_IDM) Then
				GUICtrlSetData($h_Label_Info, "Error: Registry Entry Is Empty. Nothing To Backup")
				FileWriteLine($s_Log_File, _Current_Moment() & "Error: Registry Entry Is Empty. Nothing To Backup !")
				_control_update_default()
				ContinueLoop
			EndIf
			#endregion ;/Check registry and cont..--->

			#region ;/Expert registry --->
			GUICtrlSetData($h_Label_Info, "Backingup: Registry Registry Please Wait...")
			_regbackup($s_reg_File, $s_regpath_IDM)
			#endregion ;/Expert registry --->

			#region ;/define backup type--->
			$b_DwnlData_Folder = False
			$b_Grabber_Folder = False
			$b_Scheduler_Folder = False
			$b_History_Files = False

			If GUICtrlRead($h_Checkbox_Full_Backup) = $GUI_CHECKED Then ;Full Backup
				$b_DwnlData_Folder = True
				$b_Grabber_Folder = True
				$b_Scheduler_Folder = True
				$b_History_Files = True

				FileWriteLine($s_Log_File, _Current_Moment() & "Info: User Selected Full Backup")

				IniWrite($s_ini_File, "Default", "AppDataIDMFolder", $s_AppDataIDMFolder)
				IniWrite($s_ini_File, "Default", "TempPath", $DwnlData_Folder)
				IniWrite($s_ini_File, "Default", "idmvers", RegRead($s_regpath_IDM, "idmvers"))
				IniWrite($s_ini_File, "Default", "Keys", $k)
				IniWrite($s_ini_File, "Default", "Password", $b_Password)
				IniWrite($s_ini_File, "Default", "Mode", "Full")
				IniWrite($s_ini_File, "Default", "Username", @UserName)

			ElseIf GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Or _
					GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_CHECKED Or _
					GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_CHECKED Or _
					GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_CHECKED Then ;Custom backup
				FileWriteLine($s_Log_File, _Current_Moment() & "Info: User Selected Custom Backup")

				If GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_CHECKED Then $b_DwnlData_Folder = True
				If GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_CHECKED Then $b_Grabber_Folder = True
				If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Then $b_Scheduler_Folder = True
				If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Then $b_History_Files = True

				GUICtrlRead($h_Checkbox_UnFinished_GD_Backup)

				IniWrite($s_ini_File, "Default", "AppDataIDMFolder", $s_AppDataIDMFolder)
				IniWrite($s_ini_File, "Default", "TempPath", $DwnlData_Folder)
				IniWrite($s_ini_File, "Default", "idmvers", RegRead($s_regpath_IDM, "idmvers"))
				IniWrite($s_ini_File, "Default", "Keys", $k)
				IniWrite($s_ini_File, "Default", "Password", $b_Password)
				IniWrite($s_ini_File, "Default", "Mode", "Custom")
				IniWrite($s_ini_File, "Default", "Username", @UserName)

			ElseIf GUICtrlRead($h_Checkbox_Listl_Backup) = $GUI_CHECKED Then ;Only List backup
				FileWriteLine($s_Log_File, _Current_Moment() & "Info: User Selected List Backup")

				IniWrite($s_ini_File, "Default", "AppDataIDMFolder", $s_AppDataIDMFolder)
				IniWrite($s_ini_File, "Default", "TempPath", $DwnlData_Folder)
				IniWrite($s_ini_File, "Default", "idmvers", RegRead($s_regpath_IDM, "idmvers"))
				IniWrite($s_ini_File, "Default", "Keys", $k)
				IniWrite($s_ini_File, "Default", "Password", $b_Password)
				IniWrite($s_ini_File, "Default", "Mode", "List")
				IniWrite($s_ini_File, "Default", "Username", @UserName)

			EndIf
			#endregion ;/define backup type--->

			#region ;/add Data and Write INI--->
			If $b_DwnlData_Folder = True Then
				If FileExists($DwnlData_Folder) Then
					GUICtrlSetData($h_Label_Info, "Adding: Download Data Folder Please Wait...")
					$foo_2 = _7Zip_Add($s_Backup_File, $DwnlData_Folder, $s_Compression_Level, $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $DwnlData_Folder " & "=" & ' "' & $DwnlData_Folder & '" ' & "Error Code:" & _7z_Errors($foo_2))
					IniWrite($s_ini_File, "Default", "DwnlData_Folder", True)
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: Folder Does Not Exit= " & '"' & $DwnlData_Folder & '"')
				EndIf
			Else
				IniWrite($s_ini_File, "Default", "DwnlData_Folder", False)
			EndIf

			If $b_Grabber_Folder = True Then
				If FileExists($Grabber_Folder) Then
					GUICtrlSetData($h_Label_Info, "Adding: Grabber Folder Please Wait...")
					$foo_3 = _7Zip_Add($s_Backup_File, $Grabber_Folder, $s_Compression_Level, $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $Grabber_Folder " & "=" & ' "' & $Grabber_Folder & '" ' & "Error Code:" & _7z_Errors($foo_3))
					IniWrite($s_ini_File, "Default", "Grabber_Folder", True)
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: Folder Does Not Exit= " & '"' & $Grabber_Folder & '"')
				EndIf

				If FileExists($GrabberData_Folder) Then
					GUICtrlSetData($h_Label_Info, "Adding: Grabber Data Folder Please Wait...")
					$foo_4 = _7Zip_Add($s_Backup_File, $GrabberData_Folder, $s_Compression_Level, $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $GrabberData_Folder " & "=" & ' "' & $GrabberData_Folder & '" ' & "Error Code:" & _7z_Errors($foo_4))
					IniWrite($s_ini_File, "Default", "GrabberData_Folder", True)
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: Folder Does Not Exit= " & '"' & $GrabberData_Folder & '"')
				EndIf
			Else
				IniWrite($s_ini_File, "Default", "Grabber_Folder", False)
				IniWrite($s_ini_File, "Default", "GrabberData_Folder", False)
			EndIf


			If $b_Scheduler_Folder = True Then
				If FileExists($Scheduler_Folder) Then
					GUICtrlSetData($h_Label_Info, "Adding: Scheduler Folder Please Wait...")
					$foo_5 = _7Zip_Add($s_Backup_File, $Scheduler_Folder, $s_Compression_Level, $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $Scheduler_Folder " & "=" & ' "' & $GrabberData_Folder & '" ' & "Error Code:" & _7z_Errors($foo_5))
					IniWrite($s_ini_File, "Default", "Scheduler_Folder", True)
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: Folder Does Not Exit= " & '"' & $Scheduler_Folder & '"')
				EndIf
			Else
				IniWrite($s_ini_File, "Default", "Scheduler_Folder", False)
			EndIf

			If $b_History_Files = True Then

				GUICtrlSetData($h_Label_Info, "Adding: History and Logs  Folder Please Wait...")

				If FileExists($UrlHistory_txt_File) Then
					$foo_6 = _7Zip_Add($s_Backup_File, $UrlHistory_txt_File, $s_Compression_Level, $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $UrlHistory_txt_File " & "=" & ' "' & $UrlHistory_txt_File & '" ' & "Error Code:" & _7z_Errors($foo_6))
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: File Does Not Exit= " & '"' & $UrlHistory_txt_File & '"')
				EndIf

				If FileExists($UrlHistory2_txt_File) Then
					$foo_7 = _7Zip_Add($s_Backup_File, $UrlHistory2_txt_File, $s_Compression_Level, $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $UrlHistory2_txt_File " & "=" & ' "' & $UrlHistory2_txt_File & '" ' & "Error Code:" & _7z_Errors($foo_7))
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: File Does Not Exit= " & '"' & $UrlHistory2_txt_File & '"')
				EndIf

				If FileExists($GlobalErrors_log_File) Then
					$foo_8 = _7Zip_Add($s_Backup_File, $GlobalErrors_log_File, $s_Compression_Level, $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $GlobalErrors_log_File " & "=" & ' "' & $GlobalErrors_log_File & '" ' & "Error Code:" & _7z_Errors($foo_8))
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: File Does Not Exit= " & '"' & $GlobalErrors_log_File & '"')
				EndIf

				If FileExists($urlexclist_dat_File) Then
					$foo_9 = _7Zip_Add($s_Backup_File, $urlexclist_dat_File, $s_Compression_Level, $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $urlexclist_dat_File " & "=" & ' "' & $urlexclist_dat_File & '" ' & "Error Code:" & _7z_Errors($foo_9))
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: File Does Not Exit= " & '"' & $urlexclist_dat_File & '"')
				EndIf

				If FileExists($defextmap_dat_File) Then
					$foo_10 = _7Zip_Add($s_Backup_File, $defextmap_dat_File, $s_Compression_Level, $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $defextmap_dat_File " & "=" & ' "' & $defextmap_dat_File & '" ' & "Error Code:" & _7z_Errors($foo_10))
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: File Does Not Exit= " & '"' & $defextmap_dat_File & '"')
				EndIf

				If FileExists($foldresHistory_txt_File) Then
					$foo_11 = _7Zip_Add($s_Backup_File, $foldresHistory_txt_File, $s_Compression_Level, $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $foldresHistory_txt_File " & "=" & ' "' & $foldresHistory_txt_File & '" ' & "Error Code:" & _7z_Errors($foo_11))
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: File Does Not Exit= " & '"' & $foldresHistory_txt_File & '"')
				EndIf

				If FileExists($sts_list_dat_File) Then
					$foo_12 = _7Zip_Add($s_Backup_File, $sts_list_dat_File, $s_Compression_Level, $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $sts_list_dat_File " & "=" & ' "' & $sts_list_dat_File & '" ' & "Error Code:" & _7z_Errors($foo_12))
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: File Does Not Exit= " & '"' & $sts_list_dat_File & '"')
				EndIf

				If FileExists($cnlurllist_dat_File) Then
					$foo_13 = _7Zip_Add($s_Backup_File, $cnlurllist_dat_File, $s_Compression_Level, $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $cnlurllist_dat_File " & "=" & ' "' & $cnlurllist_dat_File & '" ' & "Error Code:" & _7z_Errors($foo_13))
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: File Does Not Exit= " & '"' & $cnlurllist_dat_File & '"')
				EndIf

				IniWrite($s_ini_File, "Default", "History_Files", True)
			Else
				IniWrite($s_ini_File, "Default", "History_Files", False)
			EndIf

			#endregion ;/add Data and Write INI--->

			#region ;/add registry--->
			If FileExists($s_reg_File) Then
				GUICtrlSetData($h_Label_Info, "Adding: Registry File Please Wait...")
				$foo_15 = _7Zip_Add($s_Backup_File, $s_reg_File, $s_Compression_Level, $s_Password)
				FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $s_reg_File " & "=" & ' "' & $s_reg_File & '" ' & "Error Code:" & _7z_Errors($foo_15))
			Else
				FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: File Does Not Exit= " & '"' & $s_reg_File & '"')
			EndIf
			If FileExists($s_reg_File) Then
				If Not FileDelete($s_reg_File) Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & $s_reg_File & '" ' & "Error Code:" & @error)
			EndIf
			#endregion ;/add registry--->

			#region ;/add INI--->
			If FileExists($s_ini_File) Then
				GUICtrlSetData($h_Label_Info, "Adding: ini File Please Wait...")
				$foo_16 = _7Zip_Add($s_Backup_File, $s_ini_File, $s_Compression_Level, "")
				FileWriteLine($s_Log_File, _Current_Moment() & "Info: Added $s_ini_File " & "=" & ' "' & $s_ini_File & '" ' & "Error Code:" & _7z_Errors($foo_16))
			Else
				FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Not Added Reason: File Does Not Exit= " & '"' & $s_ini_File & '"')
			EndIf
			If FileExists($s_ini_File) Then
				If Not FileDelete($s_ini_File) Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & $s_ini_File & '" ' & "Error Code:" & @error)
			EndIf
			#endregion ;/add INI--->

			GUICtrlSetData($h_Label_Info, "INFO: Done")
			If Not ProcessExists("idman.exe") Then _sRun_IDMexe()
			_control_update_default()

			FileWriteLine($s_Log_File, "============================= Backup Session Ended =============================")

		Case $h_Button_Browse_Restore
			GUICtrlSetData($h_Label_Info, "INFO: Ready")
			$s_Restore_File = FileOpenDialog("Open Backup File", $s_Backup_Dir, "IDM Backup File (*.ibf)", 3, "*.ibf", $h_IDMBM)
			If @error Then
				GUICtrlSetData($h_Label_Info, "INFO: Ready")
			Else
				GUICtrlSetData($h_Label_Info, "INFO: Ready")
				GUICtrlSetState($h_Button_Restore, $GUI_ENABLE)
				GUICtrlSetData($h_Input_Restore_Path, $s_Restore_File)
			EndIf

		Case $h_Button_Restore
			FileWriteLine($s_Log_File, "")
			FileWriteLine($s_Log_File, "============================= Restore Session Started =============================")
			GUICtrlSetData($h_Label_Info, "INFO: Restoring...")
			_control_update_busy()

			#region ;/Define Some variable: $s_Restore_File, $s_ini_File, $s_reg_File
			$s_Restore_File = GUICtrlRead($h_Input_Restore_Path)
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: $s_Restore_File= " & '"' & $s_Restore_File & '"')

			$s_ini_File = @TempDir & "\" & "idm_guest_Setting.ini"
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: $s_ini_File= " & '"' & $s_ini_File & '"')

			$s_ini_File1 = @TempDir & "\" & "idm_host_Setting.ini"

			$s_reg_File = @TempDir & "\IDMregistry.reg"
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: $s_reg_File= " & '"' & $s_reg_File & '"')

			If FileExists($s_ini_File) Then
				If FileDelete($s_ini_File) = 0 Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & $s_ini_File & '" ' & "Error Code:1")
			EndIf

			If FileExists($s_reg_File) Then
				If FileDelete($s_reg_File) = 0 Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & $s_reg_File & '" ' & "Error Code:1")
			EndIf
			#endregion ;/Define Some variable: $s_Restore_File, $s_ini_File, $s_reg_File

			#region ;/Check Backup File, Read Guest ini setting and Check For Password
			GUICtrlSetData($h_Label_Info, "INFO: Extracting ini File Please Wait...")
			$foo_16 = _7Zip_Extract_File($s_Restore_File, @TempDir, "idm_guest_Setting.ini", "");Extract ini File -> Check For Password
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extract Staus idm_guest_Setting.ini " & "=" & ' "' & $s_Restore_File & "-->" & "idm_guest_Setting.ini" & '" ' & "Error Code:" & _7z_Errors($foo_16))

			If $foo_16 = 0 And FileExists($s_ini_File) Then ;Check if INI available and Succeful Extract

				$Guest_AppDataIDMFolder = IniRead($s_ini_File, "Default", "AppDataIDMFolder", "") ;True C:\Users\Tejas\AppData\Roaming\IDM\
				$Guest_TempPath = IniRead($s_ini_File, "Default", "TempPath", "");C:\Users\Tejas\AppData\Roaming\IDM\DwnlData\
				$Guest_idmvers = IniRead($s_ini_File, "Default", "idmvers", "");v6.07b10 Full
				$Guest_Keys = IniRead($s_ini_File, "Default", "Keys", "");1191
				$Guest_Password = IniRead($s_ini_File, "Default", "Password", "");True
				$Guest_Mode = IniRead($s_ini_File, "Default", "Mode", "");Custom
				$Guest_Username = IniRead($s_ini_File, "Default", "Username", "");Tejas

				$Guest_DwnlData_Folder = IniRead($s_ini_File, "Default", "DwnlData_Folder", "");True
				$Guest_Grabber_Folder = IniRead($s_ini_File, "Default", "Grabber_Folder", "");True
				$Guest_GrabberData_Folder = IniRead($s_ini_File, "Default", "GrabberData_Folder", "");True
				$Guest_Scheduler_Folder = IniRead($s_ini_File, "Default", "Scheduler_Folder", "");True
				$Guest_History_Files = IniRead($s_ini_File, "Default", "History_Files", "");True

				If $Guest_Password = "True" Then
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Password Protected Backup File Detected")
					If GUICtrlRead($h_Checkbox_Password_Restore) = $GUI_CHECKED Then
						If GUICtrlRead($h_Input_Password_Restore) <> "" Then
							$s_Password = GUICtrlRead($h_Input_Password_Restore)
							$foo_17 = _7Zip_Test($s_Restore_File, $s_Password)
							If $foo_17 <> 0 Then
								GUICtrlSetData($h_Label_Info, "Error: CRC Failed May Be Wrong Password")
								FileWriteLine($s_Log_File, _Current_Moment() & "Error: CRC Failed May Be Wrong Password !")
								_control_update_default()
								ContinueLoop
							EndIf
						Else
							GUICtrlSetData($h_Label_Info, "Error: Enter Password")
							FileWriteLine($s_Log_File, _Current_Moment() & "Error: Password Protected Backup Please Enter The Password")
							_control_update_default()
							ContinueLoop
						EndIf
					Else
						GUICtrlSetData($h_Label_Info, "Error: Check Checkbox --> Enter Password")
						FileWriteLine($s_Log_File, _Current_Moment() & "Error: Password Protected Backup Please Check Checkbox and Enter The Password")
						_control_update_default()
						ContinueLoop
					EndIf
				Else
					$s_Password = ""
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Backup Files is Not Password Protected")
				EndIf
			Else
				GUICtrlSetData($h_Label_Info, "Error: Backup File May Be Damaged.")
				FileWriteLine($s_Log_File, _Current_Moment() & "Error: INI File Not Found. INI File Not Found Inside Backup File or Backup File May Be Damaged !")
				_control_update_default()
				ContinueLoop
			EndIf
			#endregion ;/Check Backup File, Read Guest ini setting and Check For Password

			#region ;/Cleanup--->
			GUICtrlSetData($h_Label_Info, "Deleting: TempPath Please Wait...")
			If Not DirRemove($s_AppDataIDMFolder, 1) Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & $s_AppDataIDMFolder & '" ' & "Error Code:1")
			#endregion ;/Cleanup--->

			#region ;/Restore Data--->
			If GUICtrlRead($h_Checkbox_NoRestore_Data) <> $GUI_CHECKED Then

				FileWriteLine($s_Log_File, _Current_Moment() & "Info: Restoring Files And Folders...")

				If $Guest_DwnlData_Folder = "True" Then
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_DwnlData_Folder= " & '"' & $Guest_DwnlData_Folder & '"')
					GUICtrlSetData($h_Label_Info, "Restoring: DwnlData Folder Please Wait...")
					$foo_20 = _7Zip_Extract_File($s_Restore_File, $s_AppDataIDMFolder, "DwnlData" & "\", $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extract DwnlData " & "=" & ' "' & $s_Restore_File & "-->" & "DwnlData\" & '" ' & "Error Code:" & _7z_Errors($foo_20))
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_DwnlData_Folder= " & '"' & $Guest_DwnlData_Folder & '"')
				EndIf

				If $Guest_Grabber_Folder = "True" Then
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_Grabber_Folder= " & '"' & $Guest_Grabber_Folder & '"')
					GUICtrlSetData($h_Label_Info, "Restoring: Grabber Folder Please Wait...")

					$foo_22 = _7Zip_Extract_File($s_Restore_File, $s_AppDataIDMFolder, "Grabber" & "\", $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extract Grabber " & "=" & ' "' & $s_Restore_File & "-->" & "Grabber\" & '" ' & "Error Code:" & _7z_Errors($foo_22))
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_Grabber_Folder= " & '"' & $Guest_Grabber_Folder & '"')
				EndIf

				If $Guest_GrabberData_Folder = "True" Then
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_GrabberData_Folder= " & '"' & $Guest_GrabberData_Folder & '"')
					GUICtrlSetData($h_Label_Info, "Restoring: Grabber Data Folder Please Wait...")
					$foo_21 = _7Zip_Extract_File($s_Restore_File, $s_AppDataIDMFolder, "GrabberData" & "\", $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extract GrabberData Folder " & "=" & ' "' & $s_Restore_File & "-->" & "GrabberData\" & '" ' & "Error Code:" & _7z_Errors($foo_21))
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_GrabberData_Folder= " & '"' & $Guest_GrabberData_Folder & '"')
				EndIf

				If $Guest_Scheduler_Folder = "True" Then
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_Scheduler_Folder= " & '"' & $Guest_Scheduler_Folder & '"')
					GUICtrlSetData($h_Label_Info, "Restoring: Scheduler Data Folder Please Wait...")
					$foo_23 = _7Zip_Extract_File($s_Restore_File, $s_AppDataIDMFolder, "Scheduler", $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extract Scheduler " & "=" & ' "' & $s_Restore_File & "-->" & "Scheduler\" & '" ' & "Error Code:" & _7z_Errors($foo_23))
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_Scheduler_Folder= " & '"' & $Guest_Scheduler_Folder & '"')
				EndIf

				If $Guest_History_Files = "True" Then
					GUICtrlSetData($h_Label_Info, "Restoring: History and Logs Data Folder Please Wait...")
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_History_Files= " & '"' & $Guest_History_Files & '"')

					$foo_24 = _7Zip_Extract_File($s_Restore_File, $s_AppDataIDMFolder, "UrlHistory.txt", $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extract UrlHistory.txt " & "=" & ' "' & $s_Restore_File & "-->" & "UrlHistory.txt" & '" ' & "Error Code:" & _7z_Errors($foo_24))

					$foo_25 = _7Zip_Extract_File($s_Restore_File, $s_AppDataIDMFolder, "UrlHistory2.txt", $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extract UrlHistory2.txt " & "=" & ' "' & $s_Restore_File & "-->" & "UrlHistory2.txt" & '" ' & "Error Code:" & _7z_Errors($foo_25))

					$foo_26 = _7Zip_Extract_File($s_Restore_File, $s_AppDataIDMFolder, "GlobalErrors.log", $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extract GlobalErrors.log " & "=" & ' "' & $s_Restore_File & "-->" & "GlobalErrors.log" & '" ' & "Error Code:" & _7z_Errors($foo_26))

					$foo_27 = _7Zip_Extract_File($s_Restore_File, $s_AppDataIDMFolder, "urlexclist.dat", $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extract urlexclist.dat " & "=" & ' "' & $s_Restore_File & "-->" & "urlexclist.dat" & '" ' & "Error Code:" & _7z_Errors($foo_27))

					$foo_28 = _7Zip_Extract_File($s_Restore_File, $s_AppDataIDMFolder, "defextmap.dat", $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extract defextmap.dat " & "=" & ' "' & $s_Restore_File & "-->" & "defextmap.dat" & '" ' & "Error Code:" & _7z_Errors($foo_28))

					$foo_29 = _7Zip_Extract_File($s_Restore_File, $s_AppDataIDMFolder, "foldresHistory.txt", $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extract foldresHistory.txt " & "=" & ' "' & $s_Restore_File & "-->" & "foldresHistory.txt" & '" ' & "Error Code:" & _7z_Errors($foo_29))

					$foo_30 = _7Zip_Extract_File($s_Restore_File, $s_AppDataIDMFolder, "sts_list.dat", $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extract sts_list.dat " & "=" & ' "' & $s_Restore_File & "-->" & "sts_list.dat" & '" ' & "Error Code:" & _7z_Errors($foo_30))

					$foo_31 = _7Zip_Extract_File($s_Restore_File, $s_AppDataIDMFolder, "cnlurllist.dat", $s_Password)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extract cnlurllist.dat " & "=" & ' "' & $s_Restore_File & "-->" & "cnlurllist.dat" & '" ' & "Error Code:" & _7z_Errors($foo_31))
				Else
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: $Guest_History_Files= " & '"' & $Guest_History_Files & '"')
				EndIf
			EndIf
			#endregion ;/Restore Data--->

			#region ;/Extract Registry--->
			GUICtrlSetData($h_Label_Info, "Extarcting: Registry Please Wait...")
			$foo_32 = _7Zip_Extract_File($s_Restore_File, @TempDir, "IDMregistry.reg", $s_Password)
			FileWriteLine($s_Log_File, _Current_Moment() & "Info: Extracting IDMregistry.reg " & "=" & ' "' & $s_Restore_File & "-->" & "IDMregistry.reg" & '" ' & "Error Code:" & _7z_Errors($foo_32))
			#endregion ;/Extract Registry--->

			#region ;/Convert Profile--->
			If GUICtrlRead($h_Checkbox_Convert_Registry_Restore) = $GUI_CHECKED Then
				If GUICtrlRead($h_Checkbox_NoRestore_Registry) <> $GUI_CHECKED Then
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Converting Registry Profile")

					GUICtrlSetData($h_Label_Info, "Converting: Profile Please Wait...")
					_ReplaceStringInFile($s_reg_File, StringReplace(($Guest_AppDataIDMFolder & "DwnlData" & "\" & $Guest_Username), "\", "\\"), StringReplace($s_AppDataIDMFolder & "DwnlData" & "\" & @UserName, "\", "\\"))
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Searching-->" & StringReplace(($Guest_AppDataIDMFolder & "DwnlData" & "\" & $Guest_Username), "\", "\\"))
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Replacing-->" & StringReplace($s_AppDataIDMFolder & "DwnlData" & "\" & @UserName, "\", "\\") & " Error Code" & @error)

					_ReplaceStringInFile($s_reg_File, StringReplace(($Guest_AppDataIDMFolder & "GrabberData" & "\" & $Guest_Username), "\", "\\"), StringReplace($s_AppDataIDMFolder & "GrabberData" & "\" & @UserName, "\", "\\"))
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Searching-->" & StringReplace(($Guest_AppDataIDMFolder & "GrabberData" & "\" & $Guest_Username), "\", "\\"))
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Replacing-->" & StringReplace($s_AppDataIDMFolder & "GrabberData" & "\" & @UserName, "\", "\\") & " Error Code" & @error)

					_ReplaceStringInFile($s_reg_File, StringReplace(($Guest_AppDataIDMFolder), "\", "\\"), StringReplace($s_AppDataIDMFolder, "\", "\\"))
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Searching-->" & StringReplace(($Guest_AppDataIDMFolder), "\", "\\"))
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Replacing-->" & StringReplace($s_AppDataIDMFolder, "\", "\\") & " Error Code" & @error)
				EndIf

				If GUICtrlRead($h_Checkbox_NoRestore_Data) <> $GUI_CHECKED Then
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Converting Folder Profile")

					DirMove($s_AppDataIDMFolder & "DwnlData\" & $Guest_Username, $s_AppDataIDMFolder & "DwnlData\" & @UserName)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Renaming-->" & $s_AppDataIDMFolder & "DwnlData\" & $Guest_Username)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: To-->" & $s_AppDataIDMFolder & "DwnlData\" & @UserName & " Error Code" & @error)

					DirMove($s_AppDataIDMFolder & "GrabberData\" & $Guest_Username, $s_AppDataIDMFolder & "GrabberData\" & @UserName)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Renaming-->" & $s_AppDataIDMFolder & "GrabberData\" & $Guest_Username)
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: To-->" & $s_AppDataIDMFolder & "GrabberData\" & @UserName & " Error Code" & @error)
				EndIf
			EndIf
			#endregion ;/Convert Profile--->

			#region ;/Read Host Registry and store in File--->
			If FileExists(@TempDir & "\" & "ConfigTime.ini") Then
				If Not FileDelete(@TempDir & "\" & "ConfigTime.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "ConfigTime.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "DwnlPanel.ini") Then
				If Not FileDelete(@TempDir & "\" & "DwnlPanel.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "DwnlPanel.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "DwnlSelPanel.ini") Then
				If Not FileDelete(@TempDir & "\" & "DwnlSelPanel.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "DwnlSelPanel.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "FoldersTree.ini") Then
				If Not FileDelete(@TempDir & "\" & "FoldersTree.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "FoldersTree.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "GetAllDlgLS.ini") Then
				If Not FileDelete(@TempDir & "\" & "GetAllDlgLS.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "GetAllDlgLS.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "GrabberDlgLS.ini") Then
				If Not FileDelete(@TempDir & "\" & "GrabberDlgLS.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "GrabberDlgLS.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "GrabberSts.ini") Then
				If Not FileDelete(@TempDir & "\" & "GrabberSts.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "GrabberSts.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "IDMBI.ini") Then
				If Not FileDelete(@TempDir & "\" & "IDMBI.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "IDMBI.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "ListSettings.ini") Then
				If Not FileDelete(@TempDir & "\" & "ListSettings.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "ListSettings.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "maxID.ini") Then
				If Not FileDelete(@TempDir & "\" & "maxID.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "maxID.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "MCN.ini") Then
				If Not FileDelete(@TempDir & "\" & "MCN.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "MCN.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "menuExt.ini") Then
				If Not FileDelete(@TempDir & "\" & "menuExt.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "menuExt.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "netApps.ini") Then
				If Not FileDelete(@TempDir & "\" & "netApps.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "netApps.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "Passwords.ini") Then
				If Not FileDelete(@TempDir & "\" & "Passwords.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "Passwords.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "Queue.ini") Then
				If Not FileDelete(@TempDir & "\" & "Queue.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "Queue.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "Scheduler.ini") Then
				If Not FileDelete(@TempDir & "\" & "Scheduler.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "Scheduler.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "SpecialKeys.ini") Then
				If Not FileDelete(@TempDir & "\" & "SpecialKeys.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "SpecialKeys.ini" & '" ' & "Error Code:1")
			EndIf
			If FileExists(@TempDir & "\" & "idm_host_Setting.ini") Then
				If FileDelete(@TempDir & "\" & "idm_host_Setting.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "idm_host_Setting.ini" & '" ' & "Error Code:1")
			EndIf

			$i = 1
			While 1
				$key = RegEnumVal($s_regpath_IDM, $i)
				If @error <> 0 Then ExitLoop
				IniWrite($s_ini_File1, "Reg", $key, _RegRead($s_regpath_IDM, $key))
				$i += 1
			WEnd

			_regbackup(@TempDir & "\" & "ConfigTime.ini", $s_regpath_IDM & "\" & "ConfigTime")
			_regbackup(@TempDir & "\" & "DwnlPanel.ini", $s_regpath_IDM & "\" & "DwnlPanel")
			_regbackup(@TempDir & "\" & "DwnlSelPanel.ini", $s_regpath_IDM & "\" & "DwnlSelPanel")
			_regbackup(@TempDir & "\" & "FoldersTree.ini", $s_regpath_IDM & "\" & "FoldersTree")
			_regbackup(@TempDir & "\" & "GetAllDlgLS.ini", $s_regpath_IDM & "\" & "GetAllDlgLS")
			_regbackup(@TempDir & "\" & "GrabberDlgLS.ini", $s_regpath_IDM & "\" & "GrabberDlgLS")
			_regbackup(@TempDir & "\" & "GrabberSts.ini", $s_regpath_IDM & "\" & "GrabberSts")
			_regbackup(@TempDir & "\" & "IDMBI.ini", $s_regpath_IDM & "\" & "IDMBI")
			_regbackup(@TempDir & "\" & "ListSettings.ini", $s_regpath_IDM & "\" & "ListSettings")
			_regbackup(@TempDir & "\" & "maxID.ini", $s_regpath_IDM & "\" & "maxID")
			_regbackup(@TempDir & "\" & "MCN.ini", $s_regpath_IDM & "\" & "MCN")
			_regbackup(@TempDir & "\" & "menuExt.ini", $s_regpath_IDM & "\" & "menuExt")
			_regbackup(@TempDir & "\" & "netApps.ini", $s_regpath_IDM & "\" & "netApps")
			_regbackup(@TempDir & "\" & "Passwords.ini", $s_regpath_IDM & "\" & "Passwords")
			_regbackup(@TempDir & "\" & "Queue.ini", $s_regpath_IDM & "\" & "Queue")
			_regbackup(@TempDir & "\" & "Scheduler.ini", $s_regpath_IDM & "\" & "Scheduler")
			_regbackup(@TempDir & "\" & "SpecialKeys.ini", $s_regpath_IDM & "\" & "SpecialKeys")
			#endregion ;/Read Host Registry and store in File--->

			#region ;/Restore Registry-->
			GUICtrlSetData($h_Label_Info, "Restoring: Registry Please Wait...")
			If GUICtrlRead($h_Checkbox_NoRestore_Registry) <> $GUI_CHECKED Then _reg_import($s_reg_File)

			If FileExists($s_reg_File) Then
				If Not FileDelete($s_reg_File) Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & $s_reg_File & '" ' & "Error Code:" & @error)
			EndIf
			#endregion ;/Restore Registry-->

			#region ;/Write Host Registry from stored in File--->
			If GUICtrlRead($h_Checkbox_Convert_Registry_Restore) = $GUI_CHECKED Then

				_RegWrite($s_regpath_IDM, "AppDataIDMFolder", $REG_SZ, IniRead($s_ini_File1, "reg", "AppDataIDMFolder", "0"))
				_RegWrite($s_regpath_IDM, "bShBTtFQCI", $REG_DWORD, IniRead($s_ini_File1, "reg", "bShBTtFQCI", "0"))
				_RegWrite($s_regpath_IDM, "bShTipDD", $REG_DWORD, IniRead($s_ini_File1, "reg", "bShTipDD", "0"))
				_RegWrite($s_regpath_IDM, "ConnectionSpeed", $REG_DWORD, IniRead($s_ini_File1, "reg", "ConnectionSpeed", "0"))
				_RegWrite($s_regpath_IDM, "ConnectionType", $REG_DWORD, IniRead($s_ini_File1, "reg", "ConnectionType", "0"))
				_RegWrite($s_regpath_IDM, "DialUpEntry", $REG_SZ, IniRead($s_ini_File1, "reg", "DialUpEntry", "0"))
				_RegWrite($s_regpath_IDM, "EnableDriver", $REG_DWORD, IniRead($s_ini_File1, "reg", "EnableDriver", "0"))
				_RegWrite($s_regpath_IDM, "ExceptionServers", $REG_SZ, IniRead($s_ini_File1, "reg", "ExceptionServers", "0"))
				_RegWrite($s_regpath_IDM, "ExePath", $REG_SZ, IniRead($s_ini_File1, "reg", "ExePath", "0"))
				_RegWrite($s_regpath_IDM, "Extensions", $REG_SZ, IniRead($s_ini_File1, "reg", "Extensions", "0"))
				_RegWrite($s_regpath_IDM, "FindApps", $REG_DWORD, IniRead($s_ini_File1, "reg", "FindApps", "0"))
				_RegWrite($s_regpath_IDM, "FtpPasive", $REG_DWORD, IniRead($s_ini_File1, "reg", "FtpPasive", "0"))
				_RegWrite($s_regpath_IDM, "idmvers", $REG_SZ, IniRead($s_ini_File1, "reg", "idmvers", "0"))
				_RegWrite($s_regpath_IDM, "IntegrateNN", $REG_DWORD, IniRead($s_ini_File1, "reg", "IntegrateNN", "0"))
				_RegWrite($s_regpath_IDM, "isSSW_OK", $REG_DWORD, IniRead($s_ini_File1, "reg", "isSSW_OK", "0"))
				_RegWrite($s_regpath_IDM, "LargeButtons", $REG_DWORD, IniRead($s_ini_File1, "reg", "LargeButtons", "0"))
				_RegWrite($s_regpath_IDM, "LastCheck", $REG_SZ, IniRead($s_ini_File1, "reg", "LastCheck", "0"))
				_RegWrite($s_regpath_IDM, "LastCheckQU", $REG_NONE, IniRead($s_ini_File1, "reg", "LastCheckQU", "0"))
				_RegWrite($s_regpath_IDM, "lastintres", $REG_DWORD, IniRead($s_ini_File1, "reg", "lastintres", "0"))
				_RegWrite($s_regpath_IDM, "LaunchOnStart", $REG_DWORD, IniRead($s_ini_File1, "reg", "LaunchOnStart", "0"))
				_RegWrite($s_regpath_IDM, "LocalPathW", $REG_NONE, IniRead($s_ini_File1, "reg", "LocalPathW", "0"))
				_RegWrite($s_regpath_IDM, "lstbhotime", $REG_NONE, IniRead($s_ini_File1, "reg", "lstbhotime", "0"))
				_RegWrite($s_regpath_IDM, "lstbhotime2", $REG_NONE, IniRead($s_ini_File1, "reg", "lstbhotime2", "0"))
				_RegWrite($s_regpath_IDM, "MonitorUrlClipboard", $REG_DWORD, IniRead($s_ini_File1, "reg", "MonitorUrlClipboard", "0"))
				_RegWrite($s_regpath_IDM, "mzcc_vers", $REG_DWORD, IniRead($s_ini_File1, "reg", "mzcc_vers", "0"))
				_RegWrite($s_regpath_IDM, "nDESC7", $REG_DWORD, IniRead($s_ini_File1, "reg", "nDESC7", "0"))
				_RegWrite($s_regpath_IDM, "nDESC8", $REG_DWORD, IniRead($s_ini_File1, "reg", "nDESC8", "0"))
				_RegWrite($s_regpath_IDM, "ptrk_scdt", $REG_NONE, IniRead($s_ini_File1, "reg", "ptrk_scdt", "0"))
				_RegWrite($s_regpath_IDM, "radxcnt", $REG_DWORD, IniRead($s_ini_File1, "reg", "radxcnt", "0"))
				_RegWrite($s_regpath_IDM, "RememberLastSave", $REG_DWORD, IniRead($s_ini_File1, "reg", "RememberLastSave", "0"))
				_RegWrite($s_regpath_IDM, "ShowTipOnFirstCatch", $REG_DWORD, IniRead($s_ini_File1, "reg", "ShowTipOnFirstCatch", "0"))
				_RegWrite($s_regpath_IDM, "sortOrder", $REG_DWORD, IniRead($s_ini_File1, "reg", "sortOrder", "0"))
				_RegWrite($s_regpath_IDM, "TempPath", $REG_SZ, IniRead($s_ini_File1, "reg", "TempPath", "0"))
				_RegWrite($s_regpath_IDM, "TipFilePos", $REG_DWORD, IniRead($s_ini_File1, "reg", "TipFilePos", "0"))
				_RegWrite($s_regpath_IDM, "TipStartUp", $REG_DWORD, IniRead($s_ini_File1, "reg", "TipStartUp", "0"))
				_RegWrite($s_regpath_IDM, "TipTimeStamp", $REG_SZ, IniRead($s_ini_File1, "reg", "TipTimeStamp", "0"))
				_RegWrite($s_regpath_IDM, "ToolbarStyle", $REG_SZ, IniRead($s_ini_File1, "reg", "ToolbarStyle", "0"))
				_RegWrite($s_regpath_IDM, "TrayIcon", $REG_DWORD, IniRead($s_ini_File1, "reg", "TrayIcon", "0"))
				_RegWrite($s_regpath_IDM, "tvfrdt", $REG_NONE, IniRead($s_ini_File1, "reg", "tvfrdt", "0"))
				_RegWrite($s_regpath_IDM, "UseFtpProxy", $REG_DWORD, IniRead($s_ini_File1, "reg", "UseFtpProxy", "0"))
				_RegWrite($s_regpath_IDM, "UseHttpProxy", $REG_DWORD, IniRead($s_ini_File1, "reg", "UseHttpProxy", "0"))
				_RegWrite($s_regpath_IDM, "windowPlacementV5", $REG_NONE, IniRead($s_ini_File1, "reg", "windowPlacementV5", "0"))

				_reg_import(@TempDir & "\" & "ConfigTime.ini")
				_reg_import(@TempDir & "\" & "DwnlPanel.ini")
				_reg_import(@TempDir & "\" & "DwnlSelPanel.ini")
				_reg_import(@TempDir & "\" & "FoldersTree.ini")
				_reg_import(@TempDir & "\" & "GetAllDlgLS.ini")
				_reg_import(@TempDir & "\" & "GrabberDlgLS.ini")
				_reg_import(@TempDir & "\" & "GrabberSts.ini")
				_reg_import(@TempDir & "\" & "IDMBI.ini")
				_reg_import(@TempDir & "\" & "ListSettings.ini")
				_reg_import(@TempDir & "\" & "maxID.ini")
				_reg_import(@TempDir & "\" & "MCN.ini")
				_reg_import(@TempDir & "\" & "menuExt.ini")
				_reg_import(@TempDir & "\" & "netApps.ini")
				_reg_import(@TempDir & "\" & "Passwords.ini")
				_reg_import(@TempDir & "\" & "Queue.ini")
				_reg_import(@TempDir & "\" & "Scheduler.ini")
				_reg_import(@TempDir & "\" & "SpecialKeys.ini")

				If FileExists(@TempDir & "\" & "ConfigTime.ini") Then
					If Not FileDelete(@TempDir & "\" & "ConfigTime.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "ConfigTime.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "DwnlPanel.ini") Then
					If Not FileDelete(@TempDir & "\" & "DwnlPanel.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "DwnlPanel.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "DwnlSelPanel.ini") Then
					If Not FileDelete(@TempDir & "\" & "DwnlSelPanel.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "DwnlSelPanel.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "FoldersTree.ini") Then
					If Not FileDelete(@TempDir & "\" & "FoldersTree.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "FoldersTree.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "GetAllDlgLS.ini") Then
					If Not FileDelete(@TempDir & "\" & "GetAllDlgLS.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "GetAllDlgLS.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "GrabberDlgLS.ini") Then
					If Not FileDelete(@TempDir & "\" & "GrabberDlgLS.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "GrabberDlgLS.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "GrabberSts.ini") Then
					If Not FileDelete(@TempDir & "\" & "GrabberSts.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "GrabberSts.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "IDMBI.ini") Then
					If Not FileDelete(@TempDir & "\" & "IDMBI.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "IDMBI.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "ListSettings.ini") Then
					If Not FileDelete(@TempDir & "\" & "ListSettings.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "ListSettings.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "maxID.ini") Then
					If Not FileDelete(@TempDir & "\" & "maxID.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "maxID.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "MCN.ini") Then
					If Not FileDelete(@TempDir & "\" & "MCN.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "MCN.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "menuExt.ini") Then
					If Not FileDelete(@TempDir & "\" & "menuExt.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "menuExt.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "netApps.ini") Then
					If Not FileDelete(@TempDir & "\" & "netApps.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "netApps.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "Passwords.ini") Then
					If Not FileDelete(@TempDir & "\" & "Passwords.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "Passwords.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "Queue.ini") Then
					If Not FileDelete(@TempDir & "\" & "Queue.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "Queue.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "Scheduler.ini") Then
					If Not FileDelete(@TempDir & "\" & "Scheduler.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "Scheduler.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "SpecialKeys.ini") Then
					If Not FileDelete(@TempDir & "\" & "SpecialKeys.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "SpecialKeys.ini" & '" ' & "Error Code:1")
				EndIf
				If FileExists(@TempDir & "\" & "idm_host_Setting.ini") Then
					If FileDelete(@TempDir & "\" & "idm_host_Setting.ini") Then FileWriteLine($s_Log_File, _Current_Moment() & "Warning: Could Not Delete  " & "=" & ' "' & @TempDir & "\" & "idm_host_Setting.ini" & '" ' & "Error Code:1")
				EndIf
			EndIf
			#endregion ;/Write Host Registry from stored in File--->

			GUICtrlSetData($h_Label_Info, "INFO: Done")
			If Not ProcessExists("idman.exe") Then _sRun_IDMexe()
			_control_update_default()
			FileWriteLine($s_Log_File, "============================= Backup Session Ended =============================")

		Case $h_Button_Clean_Manager_Tools
			clean()

		Case $h_Button_More_Setting
			_More_Setting_GUI()

		Case $h_Button_List_Manager_Tools
			Run(@ScriptDir & "\IDM List Manager.exe")

		Case $h_Button_Update_Help
			GUICtrlSetData($h_Label_Info, "INFO: Checking Update Please Wait...")
			If _IsInternetConnected() = "True" Then
				Local $Update_VER = InetRead("http://www.geocities.ws/gajjartejas/IDM_Backup_Manager/v0.9.1/update.txt", 1)
				Switch BinaryToString($Update_VER)
					Case ""
						GUICtrlSetData($h_Label_Info, "INFO: Time Out! or server May be Unavaible.")
					Case $s_Current_Version
						GUICtrlSetData($h_Label_Info, "INFO: You Have Most Recent Version.")
					Case Else
						GUICtrlSetData($h_Label_Info, "INFO: Download Following Version: " & BinaryToString($Update_VER))
						ShellExecute("http://gajjartejas26.blogspot.com/p/idm-backup-manager.html")
				EndSwitch
			Else
				GUICtrlSetData($h_Label_Info, "Error: Internet Connection Could Not Found")
			EndIf

		Case $h_Button_Help_Help
			If FileExists(@ScriptDir & "\Help.chm") Then
				ShellExecute(@ScriptDir & "\Help.chm")
			Else
				ShellExecute("http://gajjartejas26.blogspot.com/p/idm-backup-manager.html")
			EndIf

		Case $h_Button_Licence_Help
			If FileExists(@ScriptDir & "\Licence.txt") Then
				ShellExecute(@ScriptDir & "\Licence.txt")
			Else
				MsgBox(64, "Licence", "IDM Backup Manager v" & $s_Current_Version & "(Beta) Copyright (c) 2012-2013, Gajjar Tejas" & @CRLF & "7-Zip Copyright (C) 1999-2013 Igor Pavlov (GPL)" & @CRLF & @CRLF & "THE SOFTWARE IS PROVIDED" & '"' & "AS IS" & '"' & "AND THE AUTHOR DISCLAIMS ALL WARRANTIESWITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OFMERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FORANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGESWHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN ANACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OFOR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.", 0, $h_IDMBM)
			EndIf

		Case $h_Button_Website_Help
			ShellExecute("http://gajjartejas26.blogspot.com")

		Case $h_Button_View_Log_Help
			If FileExists($s_Log_File) Then
				ShellExecute($s_Log_File)
			Else
				GUICtrlSetData($h_Label_Info, "Error: Log File Could Not Found or Not Created Yet!")
			EndIf

		Case $h_Button_Forum_Help
			ShellExecute("http://forum.1067081.n5.nabble.com/IDM-Backup-Manager-f3.html")

		Case $h_Button_Associate_Setting
			_ShellFile_Install("Restore IDM Backup", "ibf", @ScriptName, @ScriptFullPath, @ScriptFullPath, 19, False, False)
			If @error Then
				MsgBox(16, 'Association NOT Created.', '".IBF" was not associated due to an error occurring.', 0, $h_IDMBM)
			Else
				GUICtrlSetState($h_Button_Associate_Setting, $GUI_DISABLE)
				MsgBox(64, 'Association Created.', "Please Log on Again to see Icon on IBF File", 0, $h_IDMBM)
			EndIf
	EndSwitch
WEnd
#region 7z Functions
Func _7Zip_Test($sZipFile, $sPassword)
	If FileExists($sZipFile) = 0 Then
		Return SetError(4, 0, 0)
	EndIf
	If $sPassword <> "" Then
		$sPassword = "-p" & '"' & $sPassword & '" '
	EndIf
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

Func _7Zip_Extract_File($sZipFile, $sDestinationFolder, $sFile_To_Extracr, $sPassword)

	If FileExists($sZipFile) = 0 Then
		Return SetError(4, 0, 0)
	EndIf
	If _IsDir($sDestinationFolder) = 1 And StringRight($sDestinationFolder, 1) <> "\" Then
		$sDestinationFolder &= "\"
	EndIf
	If _IsDir($sFile_To_Extracr) = 1 And StringRight($sFile_To_Extracr, 1) <> "\" Then
		$sFile_To_Extracr &= "\"
	EndIf
	If FileExists($sDestinationFolder) = 0 Then
		DirCreate($sDestinationFolder)
	EndIf
	If $sPassword <> "" Then
		$sPassword = "-p" & '"' & $sPassword & '" '
	EndIf
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Command Line: " & $s_7zexe_Path & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"' & " " & $sFile_To_Extracr & " -r")
	Return RunWait($s_7zexe_Path & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"' & " " & $sFile_To_Extracr & " -r", "", @SW_HIDE)

EndFunc   ;==>_7Zip_Extract_File

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
Func _7Zip_Add_($s7z_File_Save_Name, $sDestinationFolder, $sCompression, $sPassword)
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
	FileWriteLine($s_Log_File, _Current_Moment() & "Info: Command Line: " & $s_7zexe_Path & " " & "a" & " " & '"' & $s7z_File_Save_Name & '"' & $sCompression & " " & $sPassword & '"' & $sDestinationFolder & "*" & '"')
	Return RunWait($s_7zexe_Path & " " & "a" & " " & '"' & $s7z_File_Save_Name & '"' & $sCompression & " " & $sPassword & '"' & $sDestinationFolder & "*" & '"', "", @SW_HIDE)
EndFunc   ;==>_7Zip_Add_

Func _7z_Errors($foo)
	If $foo = 1 Then
		Return "1 Warning (Non fatal error(s)) For example, one or more files were locked by some other application, so they were not compressed."
	ElseIf $foo = 2 Then
		Return "2 Fatal Error"
	ElseIf $foo = 3 Then
		Return "3 Destination File/Folder Not Exist To Add To Archive"
	ElseIf $foo = 4 Then
		Return "4 Backup File Not Found"
	ElseIf $foo = 7 Then
		Return "7 Command line error"
	ElseIf $foo = 8 Then
		Return "8 Not enough memory for operation"
	ElseIf $foo = 255 Then
		Return "255 Operation Canclled"
	ElseIf $foo = 0 Then
		Return "0 Done"
	Else
		Return "Unknown Error"
	EndIf
EndFunc   ;==>_7z_Errors
#endregion 7z Functions

#region Registry Functions
;_regbackup(c:\path\name1.reg",     hku\folder1\folder2)
;_regbackup(@TempDir & "\" & "Scheduler.reg", $s_regpath_IDM & "\Scheduler")
Func _regbackup($s7z_File_Save_Name, $regkey)
	ShellExecuteWait('regedit.exe', '/e "' & $s7z_File_Save_Name & '"' & " " & $regkey)
EndFunc   ;==>_regbackup

;_regbackup(c:\path\name1.reg")
;_regbackup(@TempDir & "\" & "Scheduler.reg")
Func _reg_import($s7z_File_Save_Name)
	If ProcessExists('regedit.exe') Then ProcessClose('regedit.exe')
	ShellExecuteWait('regedit.exe', "/s /c " & $s7z_File_Save_Name)
EndFunc   ;==>_reg_import
#endregion Registry Functions

Func _control_update_busy()
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
	GUICtrlSetState($h_Checkbox_NoRestore_Registry, $GUI_DISABLE)
	GUICtrlSetState($h_Checkbox_NoRestore_Data, $GUI_DISABLE)

	GUICtrlSetState($h_Button_Restore, $GUI_DISABLE)
	#endregion  ;for Restore
EndFunc   ;==>_control_update_busy

Func _control_update_default()
	GUICtrlSetState($h_Tab1, $GUI_ENABLE)

	#region ;for backup
	GUICtrlSetState($h_Input_Backup_Path, $GUI_ENABLE)
	GUICtrlSetState($h_Button_Browse_Backup, $GUI_ENABLE)

	GUICtrlSetState($h_Checkbox_Password_Backup, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_Password_Backup) = $GUI_CHECKED Then GUICtrlSetState($h_Input_Password_Backup, $GUI_ENABLE)
	GUICtrlSetState($h_Checkbox_Compression_Level_Backup, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_Compression_Level_Backup) = $GUI_CHECKED Then GUICtrlSetState($h_Combo_Compression_Level_Backup, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_Full_Backup) = $GUI_CHECKED Then GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_Listl_Backup) = $GUI_CHECKED Then GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_CHECKED Or _
			GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_CHECKED Or _
			GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_CHECKED Or _
			GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_CHECKED Then
		GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_ENABLE)
	EndIf

	If GUICtrlRead($h_Checkbox_UnFinished_SD_Backup) = $GUI_UNCHECKED And _
			GUICtrlRead($h_Checkbox_UnFinished_GD_Backup) = $GUI_UNCHECKED And _
			GUICtrlRead($h_Checkbox_UnFinished_HL_Backup) = $GUI_UNCHECKED And _
			GUICtrlRead($h_Checkbox_UnFinished_DD_Backup) = $GUI_UNCHECKED And _
			GUICtrlRead($h_Checkbox_Full_Backup) = $GUI_UNCHECKED And _
			GUICtrlRead($h_Checkbox_Listl_Backup) = $GUI_UNCHECKED Then
		GUICtrlSetState($h_Checkbox_Full_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_Listl_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_DD_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_GD_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_SD_Backup, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_UnFinished_HL_Backup, $GUI_ENABLE)

	EndIf
	If Not FileExists($s_Backup_File) Then GUICtrlSetState($h_Button_Backup, $GUI_ENABLE)
	#endregion ;for backup

	#region ;for restore
	GUICtrlSetState($h_Input_Restore_Path, $GUI_ENABLE)
	GUICtrlSetState($h_Button_Browse_Restore, $GUI_ENABLE)

	GUICtrlSetState($h_Checkbox_Password_Restore, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_Password_Restore) = $GUI_CHECKED Then GUICtrlSetState($h_Input_Password_Restore, $GUI_ENABLE)
	If GUICtrlSetState($h_Checkbox_Convert_Registry_Restore, $GUI_ENABLE) Then GUICtrlSetState($h_Label_Convert_Registry_Restore, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_NoRestore_Registry) = $GUI_CHECKED Then GUICtrlSetState($h_Checkbox_NoRestore_Registry, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_NoRestore_Data) = $GUI_CHECKED Then GUICtrlSetState($h_Checkbox_NoRestore_Data, $GUI_ENABLE)
	If GUICtrlRead($h_Checkbox_NoRestore_Registry) = $GUI_UNCHECKED And GUICtrlRead($h_Checkbox_NoRestore_Data) = $GUI_UNCHECKED Then
		GUICtrlSetState($h_Checkbox_NoRestore_Registry, $GUI_ENABLE)
		GUICtrlSetState($h_Checkbox_NoRestore_Data, $GUI_ENABLE)
	EndIf

	If FileExists($s_Restore_File) Then GUICtrlSetState($h_Button_Restore, $GUI_ENABLE)
	#endregion ;for restore
EndFunc   ;==>_control_update_default

Func _Drive_Get_From_Path($path)
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[1]
EndFunc   ;==>_Drive_Get_From_Path

Func _File_Size($iBytes)
	If $iBytes >= 0 And $iBytes <= 1024 Then
		Return $iBytes & " BYTES"
	ElseIf $iBytes > 1024 And $iBytes <= 1048576 Then
		Return Round($iBytes / (1024), 2) & " KB"
	ElseIf $iBytes > 1048576 And $iBytes <= 1073741824 Then
		Return Round($iBytes / (1048576), 2) & " MB"
	ElseIf $iBytes > 1073741824 Then
		Return Round($iBytes / (1073741824), 2) & " GB"
	EndIf
EndFunc   ;==>_File_Size

Func _IsDir($sFilePath)
	Return Number(FileExists($sFilePath) And StringInStr(FileGetAttrib($sFilePath), "D", 2, 1) > 0)
EndFunc   ;==>_IsDir

Func _Current_Moment()
	Return @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & " --> "
EndFunc   ;==>_Current_Moment

Func _IsInternetConnected()
	Local $aReturn = DllCall('connect.dll', 'long', 'IsInternetConnected')
	If @error Then
		Return SetError(1, 0, False)
	EndIf
	Return $aReturn[0] = 0
EndFunc   ;==>_IsInternetConnected

Func _More_Setting_GUI()
	#region ### START Koda GUI section ###
	GUISetState(@SW_DISABLE, $h_IDMBM)
	Local $size = WinGetPos($s_Win_Title)
	Local $More_Setting_GUI = GUICreate("More Setting", 351, 121, $size[0], $size[1], BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), -1, $h_IDMBM)
	GUISetBkColor(0xFFFFFF)
	GUISetIcon(@ScriptFullPath, 0, $More_Setting_GUI)

	$h_group_Setting = GUICtrlCreateGroup("Setting", 10, 10, 330, 100)
	$h_AppendLog_Setting = GUICtrlCreateCheckbox("Append Log", 20, 30, 313, 17)
	If $b_AppendLog_File = 1 Then GUICtrlSetState($h_AppendLog_Setting, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop

			Case $h_AppendLog_Setting
				If GUICtrlRead($h_AppendLog_Setting) = $GUI_CHECKED Then
					IniWrite($s_Setting_File, "More Setting", "Append_Log_File", 1)
					$b_AppendLog_File = 1
				Else
					IniWrite($s_Setting_File, "More Setting", "Append_Log_File", 0)
					$b_AppendLog_File = 0
				EndIf
		EndSwitch
	WEnd
	GUISetState(@SW_ENABLE, $h_IDMBM)
	GUIDelete($More_Setting_GUI)
EndFunc   ;==>_More_Setting_GUI


Func clean()
	GUISetState(@SW_DISABLE, $h_IDMBM)
	Local $size = WinGetPos($s_Win_Title)
	Local $clean = GUICreate("IDM Cleaner", 202, 259, $size[0], $size[1], BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), -1, $h_IDMBM)
	GUISetBkColor(0xFFFFFF)
	GUISetIcon(@ScriptFullPath, 0, $clean)

	$Group1 = GUICtrlCreateGroup("Options", 5, 60, 190, 150)
	Local $Clena_DD = GUICtrlCreateCheckbox("Download Data", 20, 80, 97, 17)
	Local $Clean_GD = GUICtrlCreateCheckbox("Grabber Data", 20, 105, 97, 17)
	Local $Clean_SD = GUICtrlCreateCheckbox("Scheduler Data", 20, 130, 97, 17)
	Local $Clean_HL = GUICtrlCreateCheckbox("Clean History and Logs", 20, 155, 137, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $Group2 = GUICtrlCreateGroup("Clean Mode", 5, 5, 190, 55)
	Local $Custom_Clean = GUICtrlCreateRadio("Custom Clean", 17, 29, 88, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	Local $Full_Clean = GUICtrlCreateRadio("Full Clean", 117, 29, 68, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $Progress1 = GUICtrlCreateProgress(10, 225, 96, 21)

	Local $Button_Clean = GUICtrlCreateButton("", 155, 215, 40, 40)
	__AET_ButtonSetIcon(-1, 13, 32, 32, 0)
	GUICtrlSetTip(-1, "Clean The Files/Folders", "Clean", 1, 1)

	Local $Button_Analyze = GUICtrlCreateButton("", 110, 215, 40, 40)
	__AET_ButtonSetIcon(-1, 16, 32, 32, 0)
	GUICtrlSetTip(-1, "Analyze Size of Files/Folders To Clean", "Analyze", 1, 1)
	GUISetState(@SW_SHOW)

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
				Local $size = 0
				If GUICtrlRead($Full_Clean) = $GUI_CHECKED Then
					$size += DirGetSize($DwnlData_Folder)
					$size += DirGetSize($GrabberData_Folder)
					$size += DirGetSize($Scheduler_Folder)
				Else
					If GUICtrlRead($Clena_DD) = $GUI_CHECKED Then $size += DirGetSize($DwnlData_Folder)
					If GUICtrlRead($Clean_GD) = $GUI_CHECKED Then $size += DirGetSize($GrabberData_Folder)
					If GUICtrlRead($Clean_SD) = $GUI_CHECKED Then $size += DirGetSize($Scheduler_Folder)
				EndIf ;==>clean
				MsgBox(64, "Info", _File_Size($size) & " Will Removed.", 0, $clean)

			Case $Button_Clean
				Local $size = 0
				If GUICtrlRead($Full_Clean) = $GUI_CHECKED Then
					$size += DirGetSize($DwnlData_Folder)
					$size += DirGetSize($GrabberData_Folder)
					$size += DirGetSize($Scheduler_Folder)

					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox(36, "Conform", _File_Size($size) & " Will Removed. Continue?", 0, $clean)
					Select
						Case $iMsgBoxAnswer = 6 ;Yes
							If GUICtrlRead($Clena_DD) = $GUI_CHECKED And FileExists($DwnlData_Folder) Then
								If Not DirRemove($DwnlData_Folder, 1) Then MsgBox(16, "Error", " Could Not Delete. " & $DwnlData_Folder & " It May be Locked.", 0, $clean)
							EndIf

							If GUICtrlRead($Clean_GD) = $GUI_CHECKED And BitOR(FileExists($Grabber_Folder), FileExists($GrabberData_Folder)) Then
								If Not DirRemove($Grabber_Folder, 1) Then MsgBox(16, "Error", " Could Not Delete: " & $Grabber_Folder & " It May be Locked.")
								If Not DirRemove($GrabberData_Folder, 1) Then MsgBox(16, "Error", " Could Not Delete: " & $GrabberData_Folder & " It May be Locked.", 0, $clean)
							EndIf

							If GUICtrlRead($Clean_SD) = $GUI_CHECKED And FileExists($Scheduler_Folder) Then
								If Not DirRemove($Scheduler_Folder, 1) Then MsgBox(16, "Error", " Could Not Delete: " & $Scheduler_Folder & " It May be Locked.", 0, $clean)
							EndIf

							If GUICtrlRead($Clean_HL) = $GUI_CHECKED Then
								FileDelete($UrlHistory_txt_File)
								FileDelete($UrlHistory2_txt_File)
								FileDelete($GlobalErrors_log_File)
								FileDelete($urlexclist_dat_File)
								FileDelete($defextmap_dat_File)
								FileDelete($foldresHistory_txt_File)
								FileDelete($sts_list_dat_File)
								FileDelete($cnlurllist_dat_File)
							EndIf
							MsgBox(64, "Done", "Done.", 0, $clean)
						Case $iMsgBoxAnswer = 7 ;No
					EndSelect

				ElseIf GUICtrlRead($Custom_Clean) = $GUI_CHECKED Then
					If GUICtrlRead($Clena_DD) = $GUI_CHECKED Then $size += DirGetSize($DwnlData_Folder)
					If GUICtrlRead($Clean_GD) = $GUI_CHECKED Then $size += DirGetSize($GrabberData_Folder)
					If GUICtrlRead($Clean_SD) = $GUI_CHECKED Then $size += DirGetSize($Scheduler_Folder)

					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox(36, "Conform", _File_Size($size) & " Will Removed. Continue?", 0, $clean)
					If $iMsgBoxAnswer = 6 Then

						_ProgressMarquee_Start($Progress1)

						If GUICtrlRead($Clena_DD) = $GUI_CHECKED And FileExists($DwnlData_Folder) Then
							If Not DirRemove($DwnlData_Folder, 1) Then MsgBox(16, "Error", " Could Not Delete. " & $DwnlData_Folder & " It May be Locked.", 0, $clean)
						EndIf

						If GUICtrlRead($Clean_GD) = $GUI_CHECKED And BitOR(FileExists($Grabber_Folder), FileExists($GrabberData_Folder)) Then
							If Not DirRemove($Grabber_Folder, 1) Then MsgBox(16, "Error", " Could Not Delete: " & $Grabber_Folder & " It May be Locked.")
							If Not DirRemove($GrabberData_Folder, 1) Then MsgBox(16, "Error", " Could Not Delete: " & $GrabberData_Folder & " It May be Locked.", 0, $clean)
						EndIf

						If GUICtrlRead($Clean_SD) = $GUI_CHECKED And FileExists($Scheduler_Folder) Then
							If Not DirRemove($Scheduler_Folder, 1) Then MsgBox(16, "Error", " Could Not Delete: " & $Scheduler_Folder & " It May be Locked.", 0, $clean)
						EndIf

						If GUICtrlRead($Clean_HL) = $GUI_CHECKED Then
							FileDelete($UrlHistory_txt_File)
							FileDelete($UrlHistory2_txt_File)
							FileDelete($GlobalErrors_log_File)
							FileDelete($urlexclist_dat_File)
							FileDelete($defextmap_dat_File)
							FileDelete($foldresHistory_txt_File)
							FileDelete($sts_list_dat_File)
							FileDelete($cnlurllist_dat_File)
						EndIf
						MsgBox(64, "Done", "Done.", 0, $clean)
					EndIf
					_ProgressMarquee_Stop($Progress1, 1)
				EndIf
		EndSwitch
	WEnd
	GUISetState(@SW_ENABLE, $h_IDMBM)
	GUIDelete($clean)
EndFunc   ;==>clean

Func _ProgressMarquee_Start($iControlID)
	GUICtrlSetStyle($iControlID, BitOR($PBS_SMOOTH, $PBS_MARQUEE, $WS_TABSTOP))
	Return GUICtrlSendMsg($iControlID, $PBM_SETMARQUEE, 1, 10)
EndFunc   ;==>_ProgressMarquee_Start

Func _ProgressMarquee_Stop($iControlID, $iReset = 0)
	GUICtrlSendMsg($iControlID, $PBM_SETMARQUEE, 1, 10)
	Local $iReturn = GUICtrlSendMsg($iControlID, $PBM_SETMARQUEE, 0, 50)
	If $iReset Then
		GUICtrlSetStyle($iControlID, BitOR($PBS_SMOOTH, $WS_TABSTOP))
	EndIf
	Return $iReturn
EndFunc   ;==>_ProgressMarquee_Stop

Func _sGet_AppDataIDMFolder()
	Local $AppDataIDMFolder

	$AppDataIDMFolder = RegRead($s_regpath_IDM, "AppDataIDMFolder")

	If Not FileExists($AppDataIDMFolder) Then $AppDataIDMFolder = @AppDataDir & "\" & "IDM" & "\"

	If StringRight($AppDataIDMFolder, 1) <> "\" Then $AppDataIDMFolder &= "\"

	Return $AppDataIDMFolder
EndFunc   ;==>_sGet_AppDataIDMFolder

Func _sGet_TempPathFolder()
	Local $TempPath

	$TempPath = RegRead($s_regpath_IDM, "TempPath")

	If FileExists($TempPath) Then
		If StringRight($TempPath, 1) <> "\" Then $TempPath &= "\"
		$TempPath &= "DwnlData\"
	Else
		$TempPath = @AppDataDir & "\" & "IDM" & "\" & "DwnlData\"
	EndIf

	Return $TempPath
EndFunc   ;==>_sGet_TempPathFolder

Func _log_Sysinfo()
	FileWriteLine($s_Log_File, "")
	FileWriteLine($s_Log_File, "============================= New Session Started at " & _Current_Moment() & "=============================")
	FileWriteLine($s_Log_File, "")
	FileWriteLine($s_Log_File, "============================= System Information =============================")
	FileWriteLine($s_Log_File, "Module Name and Version: " & $s_Win_Title)
	FileWriteLine($s_Log_File, "Module Path: " & @ScriptFullPath)
	FileWriteLine($s_Log_File, "OS Type: " & @OSType)
	FileWriteLine($s_Log_File, "OS Version: " & @OSVersion)
	FileWriteLine($s_Log_File, "Service Package: " & @OSServicePack)
	FileWriteLine($s_Log_File, "Total Memory: " & $a_Memory[1])
	FileWriteLine($s_Log_File, "Available Memory: " & $a_Memory[2])
	FileWriteLine($s_Log_File, "")
EndFunc   ;==>_log_Sysinfo

Func _Check_Componment()
	If Not FileExists($s_7zexe_Path) Then
		FileWriteLine($s_Log_File, "Error: 7z.exe not found. Exiting....")
		MsgBox(16, "Error", "7z.exe not found. Exiting....")
		Exit -2
	EndIf
	If Not FileExists(@ScriptDir & "\7z.dll") Then
		FileWriteLine($s_Log_File, "Error: 7z.dll not found. Exiting....")
		MsgBox(16, "Error", "7z.dll not found. Exiting....")
		Exit -3
	EndIf
EndFunc   ;==>_Check_Componment

Func _Check_IDM_Process()
	If ProcessExists("idman.exe") Then ;**** Check the process "idman.exe" exists or not ***
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox(36, "IDM Need To Close", "IDM is Running in Background.Do You Want To Close IDM?")
		Select
			Case $iMsgBoxAnswer = 6 ;Yes

				If ProcessClose("idman.exe") <> 1 Then
					FileWriteLine($s_Log_File, _Current_Moment() & "Info: Internet Download Manager Is Closed. Now Cont...")
					Else
				FileWriteLine($s_Log_File, _Current_Moment() & "Info: Internet Download Manager Is Closed. Now Cont...")
				EndIf
			Case $iMsgBoxAnswer = 7 ;No
				FileWriteLine($s_Log_File, _Current_Moment() & "Internet Download Manager Is Running Now...User Selected No")
				MsgBox(48, "Warning", "If Some File is Locked By IDM Backup Process Will Not Work Correctly.")
		EndSelect
	EndIf
	FileWriteLine($s_Log_File, "")
EndFunc   ;==>_Check_IDM_Process

Func _log_Profile_Paths()
	FileWriteLine($s_Log_File, "============================= Profile and Paths Assignment =============================")
	FileWriteLine($s_Log_File, _Current_Moment() & "Finilized Path $AppDataIDMFolder= " & '"' & $s_AppDataIDMFolder & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Finilized Path $DwnlData_Folder= " & '"' & $DwnlData_Folder & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Setting File $s_Setting_File= " & '"' & $s_Setting_File & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Log File $s_Log_File= " & '"' & $s_Log_File & '"')
	FileWriteLine($s_Log_File, _Current_Moment() & "Backup Path $s_Backup_Dir= " & '"' & $s_Backup_Dir & '"')
	FileWriteLine($s_Log_File, "")
EndFunc   ;==>_log_Profile_Paths

Func __AET_ButtonSetIcon($hWnd, $iIndex, $iWidth, $iHeight, $iAlign)
	Local $hImageList
	$hImageList = _GUIImageList_Create($iWidth, $iHeight, 5, 3)
	_GUIImageList_AddIcon($hImageList, @ScriptFullPath, $iIndex, True)
	_GUICtrlButton_SetImageList($hWnd, $hImageList, $iAlign)
EndFunc   ;==>__AET_ButtonSetIcon

Func _check_cmd()
	If $CmdLine[0] > 0 Then
		If $CmdLine[0] = 1 Then
			If FileExists($CmdLine[1]) Then
				GUICtrlSetData($h_Label_Info, "INFO: Ready")
				GUICtrlSetState($h_Button_Restore, $GUI_ENABLE)
				GUICtrlSetData($h_Input_Restore_Path, $CmdLine[1])
				GUICtrlSetState($h_TabSheet2, $GUI_SHOW)
			Else
				MsgBox(16, "Error", "File Not Exists:" & @CRLF & $CmdLine[1])
				FileWriteLine($s_Log_File, "File Not Exists: " & $CmdLine[1])
			EndIf
		Else
			MsgBox(16, "Error", "Wrong Command Line.Please Use ""(Double quation on Full path)""")
			FileWriteLine($s_Log_File, "Wrong Command Line: " & $CmdLine[1])
		EndIf
	EndIf
EndFunc   ;==>_check_cmd

Func _ShellFile_Install($sText, $sFileType, $sName = @ScriptName, $sFilePath = @ScriptFullPath, $sIconPath = @ScriptFullPath, $iIcon = 0, $fAllUsers = False, $fExtended = False)
	Local $i64Bit = '', $sRegistryKey = ''

	If $iIcon = Default Then
		$iIcon = 0
	EndIf
	If $sFilePath = Default Then
		$sFilePath = @ScriptFullPath
	EndIf
	If $sIconPath = Default Then
		$sIconPath = @ScriptFullPath
	EndIf
	If $sName = Default Then
		$sName = @ScriptName
	EndIf
	If @OSArch = 'X64' Then
		$i64Bit = '64'
	EndIf
	If $fAllUsers Then
		$sRegistryKey = 'HKEY_LOCAL_MACHINE' & $i64Bit & '\SOFTWARE\Classes\'
	Else
		$sRegistryKey = 'HKEY_CURRENT_USER' & $i64Bit & '\SOFTWARE\Classes\'
	EndIf

	$sFileType = StringRegExpReplace($sFileType, '^\.+', '')
	$sName = StringLower(StringRegExpReplace($sName, '\.[^\.\\/]*$', ''))
	If StringStripWS($sName, 8) = '' Or FileExists($sFilePath) = 0 Or StringStripWS($sFileType, 8) = '' Then
		Return SetError(1, 0, False)
	EndIf

	_ShellFile_Uninstall($sFileType, $fAllUsers)

	Local $iReturn = 0
	$iReturn += RegWrite($sRegistryKey & '.' & $sFileType, '', 'REG_SZ', $sName)
	$iReturn += RegWrite($sRegistryKey & $sName & '\DefaultIcon\', '', 'REG_SZ', $sIconPath & ',' & $iIcon)
	$iReturn += RegWrite($sRegistryKey & $sName & '\shell\open', '', 'REG_SZ', $sText)
	$iReturn += RegWrite($sRegistryKey & $sName & '\shell\open', 'Icon', 'REG_EXPAND_SZ', $sIconPath & ',' & $iIcon)
	$iReturn += RegWrite($sRegistryKey & $sName & '\shell\open\command\', '', 'REG_SZ', '"' & $sFilePath & '" "%1"')
	$iReturn += RegWrite($sRegistryKey & $sName, '', 'REG_SZ', $sText)
	$iReturn += RegWrite($sRegistryKey & $sName, 'Icon', 'REG_EXPAND_SZ', $sIconPath & ',' & $iIcon)
	$iReturn += RegWrite($sRegistryKey & $sName & '\command', '', 'REG_SZ', '"' & $sFilePath & '" "%1"')
	If $fExtended Then
		$iReturn += RegWrite($sRegistryKey & $sName, 'Extended', 'REG_SZ', '')
	EndIf
	Return $iReturn > 0
EndFunc   ;==>_ShellFile_Install

Func _ShellFile_Uninstall($sFileType, $fAllUsers = False)
	Local $i64Bit = '', $sRegistryKey = ''

	If @OSArch = 'X64' Then
		$i64Bit = '64'
	EndIf
	If $fAllUsers Then
		$sRegistryKey = 'HKEY_LOCAL_MACHINE' & $i64Bit & '\SOFTWARE\Classes\'
	Else
		$sRegistryKey = 'HKEY_CURRENT_USER' & $i64Bit & '\SOFTWARE\Classes\'
	EndIf

	$sFileType = StringRegExpReplace($sFileType, '^\.+', '')
	If StringStripWS($sFileType, 8) = '' Then
		Return SetError(1, 0, False)
	EndIf

	Local $iReturn = 0, $sName = RegRead($sRegistryKey & '.' & $sFileType, '')
	If @error Then
		Return SetError(2, 0, False)
	EndIf
	$iReturn += RegDelete($sRegistryKey & '.' & $sFileType)
	$iReturn += RegDelete($sRegistryKey & $sName)
	Return $iReturn > 0
EndFunc   ;==>_ShellFile_Uninstall

Func _sRun_IDMexe()
	Local $s_IDMexe_Path = RegRead($s_regpath_IDM, "ExePath")
	If Not FileExists($s_IDMexe_Path) Then $s_IDMexe_Path = @ProgramFilesDir & "\" & "Internet Download Manager\IDMan.exe"
	If Not FileExists($s_IDMexe_Path) Then Return 0
	$s_IDMexe_Path &= " /onboot"
	If Not ProcessExists("idman.exe") Then Run($s_IDMexe_Path)
EndFunc   ;==>_sRun_IDMexe

Func _onExit()
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $h_IDMBM, "int", 200, "long", 0x00050010);implode
	Local $WinPos = WinGetPos($h_IDMBM)
	IniWrite($s_Setting_File, "Position", "x", $WinPos[0])
	IniWrite($s_Setting_File, "Position", "y", $WinPos[1])
	Exit
EndFunc   ;==>_onExit