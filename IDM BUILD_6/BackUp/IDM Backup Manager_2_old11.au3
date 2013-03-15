#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\IDM BUILD_2\icon.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=IDM Backup Manager
#AutoIt3Wrapper_Res_Description=IDM Backup Manager is a free software that can backup files from Internet Download Manager
#AutoIt3Wrapper_Res_Fileversion=0.9.5.0
#AutoIt3Wrapper_Res_LegalCopyright=©Gajjar Tejas 2012
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
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
#include "_RegFunc.au3"

Global $LOG_File = @ScriptDir & "\LogFile.log"
Global $MEMORY = MemGetStats()
Global $regkey_x86_IDM = "HKEY_CURRENT_USER\Software\DownloadManager"
Global $current_version = "0.9.5"
Global $Win_Title = "IDM Backup Manager" & $current_version & "(Beta)"
Global $Backup_Dir = "::{450D8FBA-AD25-11D0-98A8-0800361B1103}\IDM Backup"

_log_Sysinfo()
_Check_Componment()
_Check_IDM_Process()
Global $TempPath = _Check_Reg()

#region ### START Koda GUI section ###

Global $IDMBM = GUICreate($Win_Title, 439, 276, (@DesktopWidth - 439) / 2, (@DesktopHeight - 276) / 2)

$Tab1 = GUICtrlCreateTab(10, 10, 420, 240)

$TabSheet1 = GUICtrlCreateTabItem("Backup Data")
GUICtrlSetImage(-1, @ScriptDir & "\Resorces\Backup.ico", 0)
$Group1 = GUICtrlCreateGroup("Backup Location", 24, 44, 390, 55)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

$Backup_Input = GUICtrlCreateInput("", 33, 64, 336, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Browse_Button_Backup = GUICtrlCreateButton("", 376, 63, 30, 23)
__AET_ButtonSetIcon(-1, 0, 16, 16, 0, "Browse.ico")
GUICtrlSetTip(-1, "Browse For Backup Folder")

$Backup_Button = GUICtrlCreateButton("Backup Now", 319, 217, 95, 25)
__AET_ButtonSetIcon(-1, 0, 16, 16, 0, "Ok.ico")
GUICtrlSetTip(-1, "Backup Now")
GUICtrlSetState(-1, $GUI_DISABLE)

$Group6 = GUICtrlCreateGroup("Options", 24, 104, 390, 100)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

$Checkbox_backup_Password = GUICtrlCreateCheckbox("", 38, 130, 12, 17)
GUICtrlSetTip(-1, "Choose Yes If You Want Encryption of Your Backup Files Which Is Required Strong Password", "Backup Password", 1, 1)

$Input_backup_Password = GUICtrlCreateInput("Password", 54, 128, 130, 21, $ES_PASSWORD)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Choose Yes If You Want Encryption of Your Backup Files Which Is Required Strong Password", "Backup Password", 1, 1)

$Checkbox_restore_Setting_Compression = GUICtrlCreateCheckbox("", 39, 159, 12, 17)
GUICtrlSetTip(-1, "Here You Can Set The Compression Level of The Backup Files" & @CRLF & "", "Compression Level", 1, 1)

$Setting_Compression_Level = GUICtrlCreateCombo("1-No Compression", 54, 157, 130, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetData(-1, "2-Fastest Compression|3-Fast Compression|4-Normal Compression|5-Maximum Compression|6-Ultra Compression", "1-No Compression")
GUICtrlSetTip(-1, "Here You Can Set The Compression Level of The Backup Files" & @CRLF & "", "Compression Level", 1, 1)

$Full_Backup = GUICtrlCreateCheckbox("Full Backup", 200, 128, 107, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$List_Backup = GUICtrlCreateCheckbox("Only List Backup", 310, 128, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Unfinished_DD = GUICtrlCreateCheckbox("Downloaded Data", 200, 149, 107, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Unfinished_GD = GUICtrlCreateCheckbox("Grabber Data", 310, 149, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Unfinished_SD = GUICtrlCreateCheckbox("Scheduler Data", 200, 170, 107, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Unfinished_HL = GUICtrlCreateCheckbox("History and Logs", 310, 170, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;==============================================================================================
$TabSheet2 = GUICtrlCreateTabItem("Restore Data")
GUICtrlSetImage(-1, @ScriptDir & "\Resorces\Restore.ico", 0)
$Group2 = GUICtrlCreateGroup("Restore Location", 24, 44, 390, 55)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

$Restore_Input = GUICtrlCreateInput("", 33, 64, 336, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))

$Browse_Button_Restore = GUICtrlCreateButton("", 376, 63, 30, 23)
__AET_ButtonSetIcon(-1, 0, 16, 16, 0, "Browse.ico")
GUICtrlSetTip(-1, "Browse For Restore Folder")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Restore_Button = GUICtrlCreateButton("Restore Now", 319, 217, 95, 25)
__AET_ButtonSetIcon(-1, 0, 16, 16, 0, "Ok.ico")
GUICtrlSetTip(-1, "Restore Now")
GUICtrlSetState(-1, $GUI_DISABLE)

$Group7 = GUICtrlCreateGroup("Options", 24, 104, 390, 100)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

$Checkbox_restore_Password = GUICtrlCreateCheckbox("", 38, 130, 12, 17)
GUICtrlSetTip(-1, "Choose Yes If Your backup is Encrypted", "Restore Encryption", 1, 1)

$Input_restore_Password = GUICtrlCreateInput("Password", 54, 128, 130, 21, $ES_PASSWORD)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Choose Yes If Your backup is Encrypted", "Restore Encryption", 1, 1)

$Checkbox_restore_Convert_Registry = GUICtrlCreateCheckbox("", 39, 159, 12, 17)
GUICtrlSetTip(-1, "Choose Yes If Destination Backup is another System" & @CRLF & @CRLF & "EXAMPLE:" & @CRLF & "Incase of If You Want To Restore Backup of Cybercafe to Your Home PC", "Convert Profile", 1, 1)

$Label_Convert_Registry = GUICtrlCreateLabel("Convert Profile", 60, 160, 73, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Choose Yes If Destination Backup is another System" & @CRLF & @CRLF & "EXAMPLE:" & @CRLF & "Incase of If You Want To Restore Backup of Cybercafe to Your Home PC", "Convert Profile", 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;==============================================================================================
$TabSheet3 = GUICtrlCreateTabItem("Tools")
GUICtrlSetImage(-1, @ScriptDir & "\Resorces\Tool.ico", 0)
$Group3 = GUICtrlCreateGroup("IDM List Manager", 24, 44, 390, 90)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Tools_List_Man = GUICtrlCreateButton("Run IDM List Manager", 254, 104, 155, 25)
__AET_ButtonSetIcon(-1, 0, 24, 24, 0, "Run.ico")
If Not FileExists(@ScriptDir & "\IDM List Manager.exe") Then GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateLabel("IDM List Manager is allow to use Force to Join Unfinished Downloaded Files, Remove Download From List and much more", 34, 64, 375, 32)
GUICtrlSetCursor(-1, 2)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group4 = GUICtrlCreateGroup("Cleaner", 25, 140, 390, 90)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Tools_Cleaner_Man = GUICtrlCreateButton("Run Cleaner", 255, 200, 155, 25)
__AET_ButtonSetIcon(-1, 0, 24, 24, 0, "Run.ico")
GUICtrlCreateLabel("Clean History, Logs and Unfinished Download Data.", 35, 160, 374, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;==============================================================================================
$TabSheet4 = GUICtrlCreateTabItem("Help")
GUICtrlSetImage(-1, @ScriptDir & "\Resorces\Help.ico", 0)
$Help_Tab = GUICtrlCreateGroup("Help and Update", 24, 44, 390, 160)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Website = GUICtrlCreateButton("Website", 37, 126, 100, 30)
__AET_ButtonSetIcon(-1, 0, 24, 24, 0, "Internet.ico")
$Help = GUICtrlCreateButton("Help", 37, 66, 100, 30)
__AET_ButtonSetIcon(-1, 0, 24, 24, 0, "Help.ico")
$Licence = GUICtrlCreateButton("Licence", 37, 96, 100, 30)
__AET_ButtonSetIcon(-1, 0, 24, 24, 0, "Licence.ico")
$View_Log = GUICtrlCreateButton("View Log", 146, 66, 100, 30)
__AET_ButtonSetIcon(-1, 0, 24, 24, 0, "Log.ico")
$Forum = GUICtrlCreateButton("Forum", 146, 96, 100, 30)
__AET_ButtonSetIcon(-1, 0, 24, 24, 0, "Forum.ico")
$Update = GUICtrlCreateButton("Update", 146, 126, 100, 30);1111
__AET_ButtonSetIcon(-1, 0, 24, 24, 0, "Update.ico")
$Pic1 = GUICtrlCreatePic(@ScriptDir & "\Resorces\contactme.jpg", 260, 55, 150, 145)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")

$INFO = GUICtrlCreateLabel("INFO: Full Backup Selected", 12, 253, 413, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
FileWriteLine($LOG_File, _Current_Moment() & "Window Created: " & $Win_Title & " With Error Code: " & @error)
#endregion ### END Koda GUI section ###

_check_cmd()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg

		Case $GUI_EVENT_CLOSE
			Exit

		Case $Checkbox_backup_Password
			If GUICtrlRead($Checkbox_backup_Password) = $GUI_CHECKED Then
				GUICtrlSetState($Input_backup_Password, $GUI_ENABLE)
			Else
				GUICtrlSetState($Input_backup_Password, $GUI_DISABLE)
			EndIf

		Case $Checkbox_restore_Password
			If GUICtrlRead($Checkbox_restore_Password) = $GUI_CHECKED Then
				GUICtrlSetState($Input_restore_Password, $GUI_ENABLE)
			Else
				GUICtrlSetState($Input_restore_Password, $GUI_DISABLE)
			EndIf

		Case $Checkbox_restore_Setting_Compression
			If GUICtrlRead($Checkbox_restore_Setting_Compression) = $GUI_CHECKED Then
				GUICtrlSetState($Setting_Compression_Level, $GUI_ENABLE)
			Else
				GUICtrlSetState($Setting_Compression_Level, $GUI_DISABLE)
			EndIf

		Case $Checkbox_restore_Convert_Registry
			If GUICtrlRead($Checkbox_restore_Convert_Registry) = $GUI_CHECKED Then
				GUICtrlSetState($Label_Convert_Registry, $GUI_ENABLE)
			Else
				GUICtrlSetState($Label_Convert_Registry, $GUI_DISABLE)
			EndIf

		Case $Full_Backup
			If GUICtrlRead($Full_Backup) = $GUI_CHECKED Then
				GUICtrlSetData($INFO, "INFO: Full Backup Selected")
				GUICtrlSetState($Unfinished_DD, $GUI_DISABLE)
				GUICtrlSetState($Unfinished_GD, $GUI_DISABLE)
				GUICtrlSetState($Unfinished_SD, $GUI_DISABLE)
				GUICtrlSetState($Unfinished_HL, $GUI_DISABLE)
				GUICtrlSetState($List_Backup, $GUI_DISABLE)
			Else
				GUICtrlSetData($INFO, "INFO: Ready")
				GUICtrlSetState($Unfinished_DD, $GUI_ENABLE)
				GUICtrlSetState($Unfinished_GD, $GUI_ENABLE)
				GUICtrlSetState($Unfinished_SD, $GUI_ENABLE)
				GUICtrlSetState($Unfinished_HL, $GUI_ENABLE)
				GUICtrlSetState($List_Backup, $GUI_ENABLE)
			EndIf

		Case $List_Backup
			If GUICtrlRead($List_Backup) = $GUI_CHECKED Then
				GUICtrlSetData($INFO, "INFO: List Backup Selected. Only IDM List and Setting Backup")
				GUICtrlSetState($Unfinished_DD, $GUI_DISABLE)
				GUICtrlSetState($Unfinished_GD, $GUI_DISABLE)
				GUICtrlSetState($Unfinished_SD, $GUI_DISABLE)
				GUICtrlSetState($Unfinished_HL, $GUI_DISABLE)
				GUICtrlSetState($Full_Backup, $GUI_DISABLE)
			Else
				GUICtrlSetData($INFO, "INFO: Ready")
				GUICtrlSetState($Unfinished_DD, $GUI_ENABLE)
				GUICtrlSetState($Unfinished_GD, $GUI_ENABLE)
				GUICtrlSetState($Unfinished_SD, $GUI_ENABLE)
				GUICtrlSetState($Unfinished_HL, $GUI_ENABLE)
				GUICtrlSetState($Full_Backup, $GUI_ENABLE)
			EndIf

		Case $Unfinished_SD
			If GUICtrlRead($Unfinished_SD) = $GUI_CHECKED Then
				GUICtrlSetData($INFO, "INFO: Custom Backup Selected.")
				GUICtrlSetState($Full_Backup, $GUI_DISABLE)
				GUICtrlSetState($List_Backup, $GUI_DISABLE)
			Else
				If GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_HL) = $GUI_CHECKED Then
					GUICtrlSetState($Full_Backup, $GUI_DISABLE)
					GUICtrlSetState($List_Backup, $GUI_DISABLE)
				Else
					GUICtrlSetData($INFO, "INFO: Ready")
					GUICtrlSetState($Full_Backup, $GUI_ENABLE)
					GUICtrlSetState($List_Backup, $GUI_ENABLE)
				EndIf
			EndIf

		Case $Unfinished_GD
			If GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Then
				GUICtrlSetData($INFO, "INFO: Custom Backup Selected.")
				GUICtrlSetState($Full_Backup, $GUI_DISABLE)
				GUICtrlSetState($List_Backup, $GUI_DISABLE)
			Else
				If GUICtrlRead($Unfinished_SD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_HL) = $GUI_CHECKED Then
					GUICtrlSetState($Full_Backup, $GUI_DISABLE)
					GUICtrlSetState($List_Backup, $GUI_DISABLE)
				Else
					GUICtrlSetData($INFO, "INFO: Ready")
					GUICtrlSetState($Full_Backup, $GUI_ENABLE)
					GUICtrlSetState($List_Backup, $GUI_ENABLE)
				EndIf
			EndIf

		Case $Unfinished_DD
			If GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Then
				GUICtrlSetData($INFO, "INFO: Custom Backup Selected.")
				GUICtrlSetState($Full_Backup, $GUI_DISABLE)
				GUICtrlSetState($List_Backup, $GUI_DISABLE)
			Else
				If GUICtrlRead($Unfinished_SD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_HL) = $GUI_CHECKED Then
					GUICtrlSetState($Full_Backup, $GUI_DISABLE)
					GUICtrlSetState($List_Backup, $GUI_DISABLE)
				Else
					GUICtrlSetData($INFO, "INFO: Ready")
					GUICtrlSetState($Full_Backup, $GUI_ENABLE)
					GUICtrlSetState($List_Backup, $GUI_ENABLE)
				EndIf
			EndIf

		Case $Unfinished_HL
			If GUICtrlRead($Unfinished_HL) = $GUI_CHECKED Then
				GUICtrlSetData($INFO, "INFO: Custom Backup Selected.")
				GUICtrlSetState($Full_Backup, $GUI_DISABLE)
				GUICtrlSetState($List_Backup, $GUI_DISABLE)
			Else
				If GUICtrlRead($Unfinished_SD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Or $Unfinished_DD = $GUI_CHECKED Then
					GUICtrlSetState($Full_Backup, $GUI_DISABLE)
					GUICtrlSetState($List_Backup, $GUI_DISABLE)
				Else
					GUICtrlSetData($INFO, "INFO: Ready")
					GUICtrlSetState($Full_Backup, $GUI_ENABLE)
					GUICtrlSetState($List_Backup, $GUI_ENABLE)
				EndIf
			EndIf

		Case $Browse_Button_Backup
			GUICtrlSetData($INFO, "INFO: Ready")
			$Backup_7z_path = FileSaveDialog("Save Backup File", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}\IDM Backup", "IDM Backup File (*.ibf)", 18, "IDMbackup.ibf", $IDMBM)
			If @error Then
				GUICtrlSetData($INFO, "INFO: Ready")
			Else
				If FileExists($Backup_7z_path) Then
					If FileDelete($Backup_7z_path) = 0 Then
						GUICtrlSetState($Backup_Button, $GUI_DISABLE)
						GUICtrlSetData($Backup_Input, "")
						GUICtrlSetData($INFO, "Error : Files Could Not Deleted")
						MsgBox(48, "Warning", "Files Could Not Deleted." & @CRLF & @CRLF & $Backup_7z_path, 0, $IDMBM)
					Else
						GUICtrlSetState($Backup_Button, $GUI_ENABLE)
						GUICtrlSetData($INFO, "INFO: Ready")
						GUICtrlSetData($Backup_Input, $Backup_7z_path)
					EndIf
				Else
					GUICtrlSetData($Backup_Input, $Backup_7z_path)
					GUICtrlSetState($Backup_Button, $GUI_ENABLE)
				EndIf
			EndIf

		Case $Backup_Button
			FileWriteLine($LOG_File, "")
			FileWriteLine($LOG_File, "============================= Backup Session Started =============================")

			$Backup_7z_path = GUICtrlRead($Backup_Input)

			If GUICtrlRead($Checkbox_backup_Password) = $GUI_CHECKED Then
				$passwd = GUICtrlRead($Input_backup_Password)
				If $passwd = "" Then
					GUICtrlSetData($INFO, "Error : Password is Empty")
					MsgBox(48, "Alert", "Password is Empty", 0, $IDMBM)
					FileWriteLine($LOG_File, "Password is Empty")
					ContinueLoop
				EndIf
				$password_exists = True
			Else
				$password_exists = False
				$passwd = ""
			EndIf

			GUICtrlSetData($INFO, "Checking : Drive Space Please Wait...")
			If DriveSpaceFree(_Drive_Get_From_Path($Backup_7z_path)) < DirGetSize($TempPath) / 1024 / 1024 Then
				GUICtrlSetData($INFO, "Error : Not Enought Free Space on Drive")
				MsgBox(16, "Error", "Not Enought Free Space on Drive " & _Drive_Get_From_Path($Backup_7z_path) & " Free Space:" & DriveSpaceFree(_Drive_Get_From_Path($Backup_7z_path)) & "MB" & ". At Least " & DirGetSize($TempPath) / 1024 / 1024 & "MB Required.", 0, $IDMBM)
				FileWriteLine($LOG_File, _Current_Moment() & "Not Enought Free Space on Drive " & _Drive_Get_From_Path($Backup_7z_path) & " Free Space:" & DriveSpaceFree(_Drive_Get_From_Path($Backup_7z_path)) & "MB" & ". At Least " & DirGetSize($TempPath) / 1024 / 1024 & "MB Required.")
				ContinueLoop
			EndIf

			_control_update_busy()

			If GUICtrlRead($Checkbox_restore_Setting_Compression) = $GUI_CHECKED Then
				$Compression_Level = GUICtrlRead($Setting_Compression_Level)
			Else
				$Compression_Level = "1-No Compression"
			EndIf

			FileWriteLine($LOG_File, _Current_Moment() & "Password= " & '"' & $password_exists & '"')

			$ini_File = @TempDir & "\" & "idm_guest_Setting.ini"
			FileWriteLine($LOG_File, _Current_Moment() & "$ini_File= " & '"' & $ini_File & '"')
			$reg_File = @TempDir & "\" & "IDMregistry.reg"
			FileWriteLine($LOG_File, _Current_Moment() & "$reg_File= " & '"' & $reg_File & '"')

			$Temp_File_1 = FileDelete($reg_File)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $reg_File & '" ' & "Error Code:" & @error)
			$Temp_File_2 = FileDelete($ini_File)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $ini_File & '" ' & "Error Code:" & @error)

			;/backup registry--->
			$Backup_reg_temp_path = @TempDir & "\" & "IDMregistry"
			$Temp_File_3 = FileDelete($Backup_reg_temp_path)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $Backup_reg_temp_path & '" ' & "Error Code:" & @error)
			$k = 1
			If Not FileExists($Backup_reg_temp_path) Then DirCreate($Backup_reg_temp_path)
			While 1
				$var = RegEnumKey($regkey_x86_IDM, $k)
				If @error <> 0 Then ExitLoop
				_regbackup($Backup_reg_temp_path & "\" & $k & ".reg", $regkey_x86_IDM & "\" & $var)
				$file_join3 = FileRead($Backup_reg_temp_path & "\" & $k & ".reg") & @CRLF
				FileWrite($reg_File, $file_join3)
				FileDelete($Backup_reg_temp_path & "\" & $k & ".reg")
				GUICtrlSetData($INFO, "Backing up Registry Key: " & $k & "  Please Wait...")
				$k += 1
			WEnd
			FileWriteLine($LOG_File, _Current_Moment() & "Registry Backup Successful Total Key = " & '"' & $k & '"')
			$Temp_File_3 = FileDelete($Backup_reg_temp_path)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $Backup_reg_temp_path & '" ' & "Error Code:" & @error)
			;/<---backup registry

			If $k = 1 Then
				GUICtrlSetData($INFO, "Error : Registry Entry Is Empty. Nothing To Backup")
				MsgBox(48, "Error", "Nothing To Backup !", 0, $IDMBM)
				FileWriteLine($LOG_File, _Current_Moment() & "Registry Entry Is Empty. Nothing To Backup !")
			Else
				If GUICtrlRead($Full_Backup) = $GUI_CHECKED Then
					FileWriteLine($LOG_File, _Current_Moment() & "User Selected Full Backup to  " & "=" & ' "' & $Backup_7z_path & '"')
					IniWrite($ini_File, "Default", "AppDataIDMFolder", RegRead($regkey_x86_IDM, "AppDataIDMFolder"))
					IniWrite($ini_File, "Default", "TempPath", RegRead($regkey_x86_IDM, "TempPath"))
					IniWrite($ini_File, "Default", "idmvers", RegRead($regkey_x86_IDM, "idmvers"))
					IniWrite($ini_File, "Default", "Password", $password_exists)
					IniWrite($ini_File, "Default", "Mode", "Full")
					IniWrite($ini_File, "Default", "Username", @UserName)
					IniWrite($ini_File, "Default", "Keys", $k)

					GUICtrlSetData($INFO, "Backing up Registry: " & $k & "  Please Wait...")
					_regbackup($reg_File, $regkey_x86_IDM)

					GUICtrlSetData($INFO, "Adding: Data Folder Please Wait...")
					$foo_2 = _7Zip_Add_($Backup_7z_path, $TempPath, $Compression_Level, $passwd)
					FileWriteLine($LOG_File, _Current_Moment() & "Added $TempPath " & "=" & ' "' & $TempPath & '" ' & "Error Code:" & _7z_Errors($foo_2))
					GUICtrlSetData($INFO, "Adding: Registry File Please Wait...")
					$foo_3 = _7Zip_Add($Backup_7z_path, $reg_File, $Compression_Level, $passwd)
					FileWriteLine($LOG_File, _Current_Moment() & "Added $reg_File " & "=" & ' "' & $reg_File & '" ' & "Error Code:" & _7z_Errors($foo_3))
					GUICtrlSetData($INFO, "Adding: ini File Please Wait...")
					$foo_16 = _7Zip_Add($Backup_7z_path, $ini_File, $Compression_Level, "")
					FileWriteLine($LOG_File, _Current_Moment() & "Added $ini_File " & "=" & ' "' & $ini_File & '" ' & "Error Code:" & _7z_Errors($foo_16))
				ElseIf GUICtrlRead($Unfinished_SD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_HL) = $GUI_CHECKED Or GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Then
					FileWriteLine($LOG_File, _Current_Moment() & "User Selected Custom Backup to  " & "=" & ' "' & $Backup_7z_path & '"')
					$DwnlData_Folder = $TempPath & "DwnlData"
					$Grabber_Folder = $TempPath & "Grabber"
					$GrabberData_Folder = $TempPath & "GrabberData"
					$Scheduler_Folder = $TempPath & "Scheduler"

					$UrlHistory_txt_File = $TempPath & "UrlHistory.txt"
					$UrlHistory2_txt_File = $TempPath & "UrlHistory2.txt"
					$GlobalErrors_log_File = $TempPath & "GlobalErrors.log"
					$urlexclist_dat_File = $TempPath & "urlexclist.dat"
					$defextmap_dat_File = $TempPath & "defextmap.dat"
					$foldresHistory_txt_File = $TempPath & "foldresHistory.txt"
					$sts_list_dat_File = $TempPath & "sts_list.dat"
					$cnlurllist_dat_File = $TempPath & "cnlurllist.dat"

					If FileExists($reg_File) Then
						GUICtrlSetData($INFO, "Adding: Registry File Please Wait...")
						$foo_15 = _7Zip_Add($Backup_7z_path, $reg_File, $Compression_Level, $passwd)
						FileWriteLine($LOG_File, _Current_Moment() & "Added $reg_File " & "=" & ' "' & $reg_File & '" ' & "Error Code:" & _7z_Errors($foo_15))
					Else
						FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: Folder Does Not Exit= " & '"' & $reg_File & '"')
					EndIf

					IniWrite($ini_File, "Default", "AppDataIDMFolder", RegRead($regkey_x86_IDM, "AppDataIDMFolder"))
					IniWrite($ini_File, "Default", "TempPath", RegRead($regkey_x86_IDM, "TempPath"))
					IniWrite($ini_File, "Default", "idmvers", RegRead($regkey_x86_IDM, "idmvers"))
					IniWrite($ini_File, "Default", "Keys", $k)
					IniWrite($ini_File, "Default", "Password", $password_exists)
					IniWrite($ini_File, "Default", "Mode", "Custom")
					IniWrite($ini_File, "Default", "Username", @UserName)

					If GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Then
						If FileExists($DwnlData_Folder) Then
							GUICtrlSetData($INFO, "Adding: Download Data Folder Please Wait...")
							$foo_2 = _7Zip_Add($Backup_7z_path, $DwnlData_Folder, $Compression_Level, $passwd)
							FileWriteLine($LOG_File, _Current_Moment() & "Added $DwnlData_Folder " & "=" & ' "' & $DwnlData_Folder & '" ' & "Error Code:" & _7z_Errors($foo_2))
							IniWrite($ini_File, "Default", "DwnlData_Folder", True)
						Else
							If GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Then FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: Folder Does Not Exit= " & '"' & $DwnlData_Folder & '"')
						EndIf
					EndIf

					If GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Then
						If FileExists($Grabber_Folder) Then
							GUICtrlSetData($INFO, "Adding: Grabber Folder Please Wait...")
							$foo_3 = _7Zip_Add($Backup_7z_path, $Grabber_Folder, $Compression_Level, $passwd)
							FileWriteLine($LOG_File, _Current_Moment() & "Added $Grabber_Folder " & "=" & ' "' & $Grabber_Folder & '" ' & "Error Code:" & _7z_Errors($foo_3))
							IniWrite($ini_File, "Default", "Grabber_Folder", True)
						Else
							If GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Then FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: Folder Does Not Exit= " & '"' & $Grabber_Folder & '"')
						EndIf
					EndIf

					If GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Then
						If FileExists($GrabberData_Folder) Then
							GUICtrlSetData($INFO, "Adding: Grabber Data Folder Please Wait...")
							$foo_4 = _7Zip_Add($Backup_7z_path, $GrabberData_Folder, $Compression_Level, $passwd)
							FileWriteLine($LOG_File, _Current_Moment() & "Added $GrabberData_Folder " & "=" & ' "' & $GrabberData_Folder & '" ' & "Error Code:" & _7z_Errors($foo_4))
							IniWrite($ini_File, "Default", "GrabberData_Folder", True)
						Else
							If GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Then FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: Folder Does Not Exit= " & '"' & $GrabberData_Folder & '"')
						EndIf
					EndIf

					If GUICtrlRead($Unfinished_SD) = $GUI_CHECKED Then
						If FileExists($Scheduler_Folder) Then
							GUICtrlSetData($INFO, "Adding: Scheduler Folder Please Wait...")
							$foo_5 = _7Zip_Add($Backup_7z_path, $Scheduler_Folder, $Compression_Level, $passwd)
							FileWriteLine($LOG_File, _Current_Moment() & "Added $Scheduler_Folder " & "=" & ' "' & $GrabberData_Folder & '" ' & "Error Code:" & _7z_Errors($foo_5))
							IniWrite($ini_File, "Default", "Scheduler_Folder", True)
						Else
							If GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Then FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: Folder Does Not Exit= " & '"' & $Scheduler_Folder & '"')
						EndIf
					EndIf

					If GUICtrlRead($Unfinished_HL) = $GUI_CHECKED Then
						GUICtrlSetData($INFO, "Adding: History and Logs  Folder Please Wait...")
						If FileExists($UrlHistory_txt_File) Then
							$foo_6 = _7Zip_Add($Backup_7z_path, $UrlHistory_txt_File, $Compression_Level, $passwd)
							FileWriteLine($LOG_File, _Current_Moment() & "Added $UrlHistory_txt_File " & "=" & ' "' & $UrlHistory_txt_File & '" ' & "Error Code:" & _7z_Errors($foo_6))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $UrlHistory_txt_File & '"')
						EndIf

						If FileExists($UrlHistory2_txt_File) Then
							$foo_7 = _7Zip_Add($Backup_7z_path, $UrlHistory2_txt_File, $Compression_Level, $passwd)
							FileWriteLine($LOG_File, _Current_Moment() & "Added $UrlHistory2_txt_File " & "=" & ' "' & $UrlHistory2_txt_File & '" ' & "Error Code:" & _7z_Errors($foo_7))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $UrlHistory2_txt_File & '"')
						EndIf

						If FileExists($GlobalErrors_log_File) Then
							$foo_8 = _7Zip_Add($Backup_7z_path, $GlobalErrors_log_File, $Compression_Level, $passwd)
							FileWriteLine($LOG_File, _Current_Moment() & "Added $GlobalErrors_log_File " & "=" & ' "' & $GlobalErrors_log_File & '" ' & "Error Code:" & _7z_Errors($foo_8))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $GlobalErrors_log_File & '"')
						EndIf

						If FileExists($urlexclist_dat_File) Then
							$foo_9 = _7Zip_Add($Backup_7z_path, $urlexclist_dat_File, $Compression_Level, $passwd)
							FileWriteLine($LOG_File, _Current_Moment() & "Added $urlexclist_dat_File " & "=" & ' "' & $urlexclist_dat_File & '" ' & "Error Code:" & _7z_Errors($foo_9))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $urlexclist_dat_File & '"')
						EndIf

						If FileExists($defextmap_dat_File) Then
							$foo_10 = _7Zip_Add($Backup_7z_path, $defextmap_dat_File, $Compression_Level, $passwd)
							FileWriteLine($LOG_File, _Current_Moment() & "Added $defextmap_dat_File " & "=" & ' "' & $defextmap_dat_File & '" ' & "Error Code:" & _7z_Errors($foo_10))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $defextmap_dat_File & '"')
						EndIf

						If FileExists($foldresHistory_txt_File) Then
							$foo_11 = _7Zip_Add($Backup_7z_path, $foldresHistory_txt_File, $Compression_Level, $passwd)
							FileWriteLine($LOG_File, _Current_Moment() & "Added $foldresHistory_txt_File " & "=" & ' "' & $foldresHistory_txt_File & '" ' & "Error Code:" & _7z_Errors($foo_11))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $foldresHistory_txt_File & '"')
						EndIf

						If FileExists($sts_list_dat_File) Then
							$foo_12 = _7Zip_Add($Backup_7z_path, $sts_list_dat_File, $Compression_Level, $passwd)
							FileWriteLine($LOG_File, _Current_Moment() & "Added $sts_list_dat_File " & "=" & ' "' & $sts_list_dat_File & '" ' & "Error Code:" & _7z_Errors($foo_12))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $sts_list_dat_File & '"')
						EndIf

						If FileExists($cnlurllist_dat_File) Then
							$foo_13 = _7Zip_Add($Backup_7z_path, $cnlurllist_dat_File, $Compression_Level, $passwd)
							FileWriteLine($LOG_File, _Current_Moment() & "Added $cnlurllist_dat_File " & "=" & ' "' & $cnlurllist_dat_File & '" ' & "Error Code:" & _7z_Errors($foo_13))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $cnlurllist_dat_File & '"')
						EndIf

						IniWrite($ini_File, "Default", "History_Files", True)
					EndIf

					GUICtrlSetData($INFO, "Adding: ini File Please Wait...")
					$foo_16 = _7Zip_Add($Backup_7z_path, $ini_File, $Compression_Level, "")
					FileWriteLine($LOG_File, _Current_Moment() & "Added $ini_File " & "=" & ' "' & $ini_File & '" ' & "Error Code:" & _7z_Errors($foo_16))
				Else
					FileWriteLine($LOG_File, _Current_Moment() & "User Selected List Backup to  " & "=" & ' "' & $Backup_7z_path & '"')

					$Backup_reg_temp_path = @TempDir & "\" & "IDMregistry"
					$Temp_File_3 = FileDelete($Backup_reg_temp_path)
					If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $Backup_reg_temp_path & '" ' & "Error Code:" & @error)

					$k = 1
					If Not FileExists($Backup_reg_temp_path) Then DirCreate($Backup_reg_temp_path)
					While 1
						$var = RegEnumKey($regkey_x86_IDM, $k)
						If @error <> 0 Then ExitLoop
						_regbackup($Backup_reg_temp_path & "\" & $k & ".reg", $regkey_x86_IDM & "\" & $var)
						$file_join3 = FileRead($Backup_reg_temp_path & "\" & $k & ".reg") & @CRLF
						FileWrite($reg_File, $file_join3)
						FileDelete($Backup_reg_temp_path & "\" & $k & ".reg")
						GUICtrlSetData($INFO, "Backing up Registry Key: " & $k & "  Please Wait...")
						$k += 1
					WEnd
					FileWriteLine($LOG_File, _Current_Moment() & "Registry Backup Successful Total Key = " & '"' & $k & '"')

					$Temp_File_3 = FileDelete($Backup_reg_temp_path)
					If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $Backup_reg_temp_path & '" ' & "Error Code:" & @error)

					If $k = 1 Then
						GUICtrlSetData($INFO, "Error: Registry Entry Is Empty. Nothing To Backup")
						MsgBox(48, "Error", "Nothing To Backup !", 0, $IDMBM)
						FileWriteLine($LOG_File, _Current_Moment() & "Registry Entry Is Empty.Nothing To Backup !")
					Else
						If FileExists($reg_File) Then
							GUICtrlSetData($INFO, "Adding: Registry File Please Wait...")
							$foo_15 = _7Zip_Add($Backup_7z_path, $reg_File, $Compression_Level, $passwd)
							FileWriteLine($LOG_File, _Current_Moment() & "Added $reg_File " & "=" & ' "' & $reg_File & '" ' & "Error Code:" & _7z_Errors($foo_15))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: Folder Does Not Exit= " & '"' & $reg_File & '"')
						EndIf

						IniWrite($ini_File, "Default", "AppDataIDMFolder", RegRead($regkey_x86_IDM, "AppDataIDMFolder"))
						IniWrite($ini_File, "Default", "TempPath", RegRead($regkey_x86_IDM, "TempPath"))
						IniWrite($ini_File, "Default", "idmvers", RegRead($regkey_x86_IDM, "idmvers"))
						IniWrite($ini_File, "Default", "Keys", $k)
						IniWrite($ini_File, "Default", "Password", $password_exists)
						IniWrite($ini_File, "Default", "Mode", "List")
						IniWrite($ini_File, "Default", "Username", @UserName)

						IniWrite($ini_File, "Default", "DwnlData_Folder", False)
						IniWrite($ini_File, "Default", "Grabber_Folder", False)
						IniWrite($ini_File, "Default", "GrabberData_Folder", False)
						IniWrite($ini_File, "Default", "Scheduler_Folder", False)
						IniWrite($ini_File, "Default", "History_Files", False)
					EndIf

					GUICtrlSetData($INFO, "Adding: ini File Please Wait...")
					$foo_16 = _7Zip_Add($Backup_7z_path, $ini_File, $Compression_Level, "")
					FileWriteLine($LOG_File, _Current_Moment() & "Added $ini_File " & "=" & ' "' & $ini_File & '" ' & "Error Code:" & _7z_Errors($foo_16))

				EndIf
				GUICtrlSetData($INFO, "INFO: Ready")
			MsgBox(64, "Info", "Done!", 0, $IDMBM)
		EndIf

			$Temp_File_4 = FileDelete($ini_File)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $ini_File & '" ' & "Error Code:" & @error)
			$Temp_File_5 = FileDelete($reg_File)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $reg_File & '" ' & "Error Code:" & @error)
			FileWriteLine($LOG_File, "============================= Backup Session Ended =============================")


			_control_update_default()
			GUICtrlSetState($Browse_Button_Backup, $GUI_ENABLE)
			GUICtrlSetState($Backup_Button, $GUI_DISABLE)

		Case $Browse_Button_Restore
			GUICtrlSetData($INFO, "INFO: Ready")
			$Restore_7z_path = FileOpenDialog("Open Backup File", $Backup_Dir, "IDM Backup File (*.ibf)", 3, "*.ibf", $IDMBM)
			If @error Then
				GUICtrlSetData($INFO, "INFO: Ready")
			Else
				GUICtrlSetData($INFO, "INFO: Ready")
				GUICtrlSetState($Restore_Button, $GUI_ENABLE)
				GUICtrlSetData($Restore_Input, $Restore_7z_path)
			EndIf

		Case $Restore_Button
			GUICtrlSetData($INFO, "INFO: Restoring...")
			FileWriteLine($LOG_File, "")
			FileWriteLine($LOG_File, "============================= Restore Session Started =============================")

			$Restore_7z_path = GUICtrlRead($Restore_Input)

			FileWriteLine($LOG_File, _Current_Moment() & "$Restore_7z_path= " & '"' & $Restore_7z_path & '"')
			$ini_File = @TempDir & "\" & "idm_guest_Setting.ini"
			FileWriteLine($LOG_File, _Current_Moment() & "$ini_File= " & '"' & $ini_File & '"')
			$reg_File = @TempDir & "\IDMregistry.reg"
			FileWriteLine($LOG_File, _Current_Moment() & "$reg_File= " & '"' & $reg_File & '"')
			FileDelete($ini_File)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $ini_File & '" ' & "Error Code:" & @error)
			FileDelete($reg_File)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $reg_File & '" ' & "Error Code:" & @error)

			GUICtrlSetData($INFO, "INFO: Extracting ini File Please Wait...")
			$foo_16 = _7Zip_Extract_File($Restore_7z_path, @TempDir, "idm_guest_Setting.ini", "");Check For Password
			FileWriteLine($LOG_File, _Current_Moment() & "Extracting idm_guest_Setting.ini " & "=" & ' "' & $Restore_7z_path & "-->" & "idm_guest_Setting.ini" & '" ' & "Error Code:" & _7z_Errors($foo_16))
			If $foo_16 = 0 And FileExists($ini_File) Then ;Check if INI available and Succeful Extract
				$Guest_AppDataIDMFolder = IniRead($ini_File, "Default", "AppDataIDMFolder", "") ;True C:\Users\Tejas\AppData\Roaming\IDM\
				$Guest_TempPath = IniRead($ini_File, "Default", "TempPath", "");C:\Users\Tejas\AppData\Roaming\IDM\
				$Guest_idmvers = IniRead($ini_File, "Default", "idmvers", "");v6.07b10 Full
				$Guest_Keys = IniRead($ini_File, "Default", "Keys", "");1191

				$Guest_Password = IniRead($ini_File, "Default", "Password", "");True

				$Guest_Username = IniRead($ini_File, "Default", "Username", "");Tejas

				$Guest_Mode = IniRead($ini_File, "Default", "Mode", "");Custom
				$Guest_DwnlData_Folder = IniRead($ini_File, "Default", "DwnlData_Folder", "");True
				$Guest_Grabber_Folder = IniRead($ini_File, "Default", "Grabber_Folder", "");True
				$Guest_GrabberData_Folder = IniRead($ini_File, "Default", "GrabberData_Folder", "");True
				$Guest_Scheduler_Folder = IniRead($ini_File, "Default", "Scheduler_Folder", "");True
				$Guest_History_Files = IniRead($ini_File, "Default", "History_Files", "");True

				If $Guest_Password = "True" Then
					FileWriteLine($LOG_File, _Current_Moment() & "Password Protected Backup File Detected")
					If GUICtrlRead($Checkbox_restore_Password) = $GUI_CHECKED Then
						If GUICtrlRead($Input_restore_Password) <> "" Then
							$passwd2 = GUICtrlRead($Input_restore_Password)
							$foo_17 = _7Zip_Test($Restore_7z_path, $passwd2)
							If $foo_17 <> 0 Then
								GUICtrlSetData($INFO, "Error: Wrong Password!")
								MsgBox(48, "Wrong Password", "CRC Failed May Be Wrong Password !", 0, $IDMBM)
								FileWriteLine($LOG_File, _Current_Moment() & "CRC Failed May Be Wrong Password !")
								ContinueLoop
							EndIf
						Else
							GUICtrlSetData($INFO, "Error: Empty Password!")
							MsgBox(48, "Empty Password", "Password Protected Backup Please Enter The Password")
							FileWriteLine($LOG_File, _Current_Moment() & "Empty Password !")
							ContinueLoop
						EndIf
					Else
						GUICtrlSetData($INFO, "Error: Check Checkbox --> Enter Password!")
						MsgBox(48, "Check Checkbox", "Password Protected Backup Please Check Checkbox and Enter The Password", 0, $IDMBM)
						FileWriteLine($LOG_File, _Current_Moment() & "Checkbox Not Yet Checked !")
						ContinueLoop
					EndIf
				Else
					$passwd2 = ""
					FileWriteLine($LOG_File, _Current_Moment() & "Backup Files is Not Password Protected")
				EndIf
			Else
				GUICtrlSetData($INFO, "Error: INI File Not Found!")
				MsgBox(0, "INI File Not Found", "INI File Not Found Inside Backup File or Backup File May Be Damaged.", 0, $IDMBM)
				FileWriteLine($LOG_File, _Current_Moment() & "INI File Not Found INI File Not Found Inside Backup File or Backup File May Be Damaged !")
				ContinueLoop
			EndIf

			_control_update_busy()

			GUICtrlSetData($INFO, "Deleting: TempPath Please Wait...")
			DirRemove($TempPath)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $TempPath & '" ' & "Error Code:" & @error)
			DirCreate($TempPath)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Create  " & "=" & ' "' & $TempPath & '" ' & "Error Code:" & @error)

			If $Guest_Mode = "Full" Then
				FileWriteLine($LOG_File, _Current_Moment() & "Full Backup Mode.")
				GUICtrlSetData($INFO, "Restoring: TempPath Please Wait...")
				$foo_18 = _7Zip_Extract($Restore_7z_path, $TempPath, $passwd2)
				FileWriteLine($LOG_File, _Current_Moment() & "Extracting $TempPath " & "=" & ' "' & $TempPath & '" ' & "Error Code:" & _7z_Errors($foo_18))
			Else
				FileWriteLine($LOG_File, _Current_Moment() & "Custom Backup Mode.")

				If $Guest_DwnlData_Folder = "True" Then
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_DwnlData_Folder= " & '"' & $Guest_DwnlData_Folder & '"')
					GUICtrlSetData($INFO, "Restoring: DwnlData Folder Please Wait...")
					$foo_20 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "DwnlData" & "\", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting DwnlData " & "=" & ' "' & $Restore_7z_path & "-->" & "DwnlData\" & '" ' & "Error Code:" & _7z_Errors($foo_20))
				Else
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_DwnlData_Folder= " & '"' & $Guest_DwnlData_Folder & '"')
				EndIf

				If $Guest_Grabber_Folder = "True" Or $Guest_GrabberData_Folder = "True" Then
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_GrabberData_Folder= " & '"' & $Guest_GrabberData_Folder & '"')
					GUICtrlSetData($INFO, "Restoring: Grabber Folder Please Wait...")
					$foo_21 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "GrabberData" & "\", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting GrabberData " & "=" & ' "' & $Restore_7z_path & "-->" & "GrabberData\" & '" ' & "Error Code:" & _7z_Errors($foo_21))
					GUICtrlSetData($INFO, "Restoring: Grabber Data Folder Please Wait...")
					$foo_22 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "Grabber" & "\", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting Grabber " & "=" & ' "' & $Restore_7z_path & "-->" & "Grabber\" & '" ' & "Error Code:" & _7z_Errors($foo_22))
				Else
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_GrabberData_Folder= " & '"' & $Guest_GrabberData_Folder & '"')
				EndIf

				If $Guest_Scheduler_Folder = "True" Then
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_Scheduler_Folder= " & '"' & $Guest_Scheduler_Folder & '"')
					GUICtrlSetData($INFO, "Restoring: Scheduler Data Folder Please Wait...")
					$foo_23 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "Scheduler", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting Scheduler " & "=" & ' "' & $Restore_7z_path & "-->" & "Scheduler\" & '" ' & "Error Code:" & _7z_Errors($foo_23))
				Else
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_Scheduler_Folder= " & '"' & $Guest_Scheduler_Folder & '"')
				EndIf

				If $Guest_History_Files = "True" Then
					GUICtrlSetData($INFO, "Restoring: History and Logs Data Folder Please Wait...")
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_History_Files= " & '"' & $Guest_History_Files & '"')

					$foo_24 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "UrlHistory.txt", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting UrlHistory.txt " & "=" & ' "' & $Restore_7z_path & "-->" & "UrlHistory.txt" & '" ' & "Error Code:" & _7z_Errors($foo_24))

					$foo_25 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "UrlHistory2.txt", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting UrlHistory2.txt " & "=" & ' "' & $Restore_7z_path & "-->" & "UrlHistory2.txt" & '" ' & "Error Code:" & _7z_Errors($foo_25))

					$foo_26 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "GlobalErrors.log", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting GlobalErrors.log " & "=" & ' "' & $Restore_7z_path & "-->" & "GlobalErrors.log" & '" ' & "Error Code:" & _7z_Errors($foo_26))

					$foo_27 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "urlexclist.dat", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting urlexclist.dat " & "=" & ' "' & $Restore_7z_path & "-->" & "urlexclist.dat" & '" ' & "Error Code:" & _7z_Errors($foo_27))

					$foo_28 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "defextmap.dat", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting defextmap.dat " & "=" & ' "' & $Restore_7z_path & "-->" & "defextmap.dat" & '" ' & "Error Code:" & _7z_Errors($foo_28))

					$foo_29 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "foldresHistory.txt", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting foldresHistory.txt " & "=" & ' "' & $Restore_7z_path & "-->" & "foldresHistory.txt" & '" ' & "Error Code:" & _7z_Errors($foo_29))

					$foo_30 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "sts_list.dat", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting sts_list.dat " & "=" & ' "' & $Restore_7z_path & "-->" & "sts_list.dat" & '" ' & "Error Code:" & _7z_Errors($foo_30))

					$foo_31 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "cnlurllist.dat", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting cnlurllist.dat " & "=" & ' "' & $Restore_7z_path & "-->" & "cnlurllist.dat" & '" ' & "Error Code:" & _7z_Errors($foo_31))
				Else
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_History_Files= " & '"' & $Guest_History_Files & '"')
				EndIf
			EndIf

			GUICtrlSetData($INFO, "Extarcting: Registry Please Wait...")
			$foo_32 = _7Zip_Extract_File($Restore_7z_path, @TempDir, "IDMregistry.reg", $passwd2)
			FileWriteLine($LOG_File, _Current_Moment() & "Extracting IDMregistry.reg " & "=" & ' "' & $Restore_7z_path & "-->" & "IDMregistry.reg" & '" ' & "Error Code:" & _7z_Errors($foo_32))

			If GUICtrlRead($Checkbox_restore_Convert_Registry) = $GUI_CHECKED Then
				FileWriteLine($LOG_File, _Current_Moment() & "Converting Profile")

				GUICtrlSetData($INFO, "Converting: Profile Please Wait...")
				_ReplaceStringInFile($reg_File, StringReplace(($Guest_AppDataIDMFolder & "DwnlData" & "\" & $Guest_Username), "\", "\\"), StringReplace($TempPath & "DwnlData" & "\" & @UserName, "\", "\\"))
				FileWriteLine($LOG_File, _Current_Moment() & "Searching-->" & StringReplace(($Guest_AppDataIDMFolder & "DwnlData" & "\" & $Guest_Username), "\", "\\"))
				FileWriteLine($LOG_File, _Current_Moment() & "Replacing-->" & StringReplace($TempPath & "DwnlData" & "\" & @UserName, "\", "\\") & " Error Code" & @error)

				_ReplaceStringInFile($reg_File, StringReplace(($Guest_AppDataIDMFolder & "GrabberData" & "\" & $Guest_Username), "\", "\\"), StringReplace($TempPath & "GrabberData" & "\" & @UserName, "\", "\\"))
				FileWriteLine($LOG_File, _Current_Moment() & "Searching-->" & StringReplace(($Guest_AppDataIDMFolder & "GrabberData" & "\" & $Guest_Username), "\", "\\"))
				FileWriteLine($LOG_File, _Current_Moment() & "Replacing-->" & StringReplace($TempPath & "GrabberData" & "\" & @UserName, "\", "\\") & " Error Code" & @error)

				_ReplaceStringInFile($reg_File, StringReplace(($Guest_AppDataIDMFolder), "\", "\\"), StringReplace($TempPath, "\", "\\"))
				FileWriteLine($LOG_File, _Current_Moment() & "Searching-->" & StringReplace(($Guest_AppDataIDMFolder), "\", "\\"))
				FileWriteLine($LOG_File, _Current_Moment() & "Replacing-->" & StringReplace($TempPath, "\", "\\") & " Error Code" & @error)

				DirMove($TempPath & "DwnlData\" & $Guest_Username, $TempPath & "DwnlData\" & @UserName)
				FileWriteLine($LOG_File, _Current_Moment() & "Renaming-->" & $TempPath & "DwnlData\" & $Guest_Username)
				FileWriteLine($LOG_File, _Current_Moment() & "To-->" & $TempPath & "DwnlData\" & @UserName & " Error Code" & @error)

				DirMove($TempPath & "GrabberData\" & $Guest_Username, $TempPath & "GrabberData\" & @UserName)
				FileWriteLine($LOG_File, _Current_Moment() & "Renaming-->" & $TempPath & "GrabberData\" & $Guest_Username)
				FileWriteLine($LOG_File, _Current_Moment() & "To-->" & $TempPath & "GrabberData\" & @UserName & " Error Code" & @error)
			EndIf

			GUICtrlSetData($INFO, "Restoring: Registry Please Wait...")
			$foo_19 = _reg_import($reg_File)

			GUICtrlSetData($INFO, "INFO: Ready")
			MsgBox(64, "Info", "Done!", 0, $IDMBM)
			_control_update_default()
			FileWriteLine($LOG_File, "============================= Backup Session Ended =============================")

		Case $Tools_Cleaner_Man
			clean()

		Case $Tools_List_Man
			Run(@ScriptDir & "\IDM List Manager.exe")

		Case $Update
			If _IsInternetConnected() = "True" Then
				Local $Update_VER = InetRead("http://www.geocities.ws/gajjartejas/IDM_Backup_Manager/v0.9.1/update.txt", 1)
				Switch BinaryToString($Update_VER)
					Case ""
						MsgBox(48, "Error", "Time Out!", 0, $IDMBM)
					Case "0.9.1"
						MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $IDMBM)
					Case "0.9.2"
						MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $IDMBM)
					Case "0.9.3"
						MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $IDMBM)
					Case "0.9.4"
						MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $IDMBM)
					Case "0.9.5"
						MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $IDMBM)
					Case Else
						GUICtrlSetData($INFO, "INFO: Download Following Version" & BinaryToString($Update_VER))
						MsgBox(64, "Availabe", "You Should Download Following Version" & BinaryToString($Update_VER), 0, $IDMBM)
						ShellExecute("http://gajjartejas26.blogspot.com/p/idm-backup-manager.html")
				EndSwitch
			Else
				GUICtrlSetData($INFO, "Error: Internet Connection Could Not Found")
				MsgBox(48, "Error", "Internet connection could not found.", 0, $IDMBM)
			EndIf

		Case $Help
			If FileExists(@ScriptDir & "\Help.chm") Then
				ShellExecute(@ScriptDir & "\Help.chm")
			Else
				ShellExecute("http://gajjartejas26.blogspot.com/p/idm-backup-manager.html")
			EndIf

		Case $Licence
			If FileExists("Licence.TXT") Then
				ShellExecute(@ScriptDir & "\Licence.txt")
			Else
				MsgBox(64, "Licence", "IDM Backup Manager v0.9.5(Beta) Copyright (c) 2012, Gajjar Tejas" & @CRLF & "7-Zip Copyright (C) 1999-2012 Igor Pavlov (GPL)" & @CRLF & @CRLF & "Permission to use, copy and distribute this software for anypurpose with or without fee is hereby granted, provided that the abovecopyright notice and this permission notice appear in all copies." & @CRLF & @CRLF & "THE SOFTWARE IS PROVIDED" & '"' & "AS IS" & '"' & "AND THE AUTHOR DISCLAIMS ALL WARRANTIESWITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OFMERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FORANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGESWHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN ANACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OFOR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.", 0, $IDMBM)
			EndIf

		Case $Website
			ShellExecute("http://gajjartejas26.blogspot.com")

		Case $View_Log
			If FileExists($LOG_File) Then
				ShellExecute($LOG_File)
			Else
				GUICtrlSetData($INFO, "Error: Log File Could Not Found or Not Created Yet!")
			EndIf

		Case $Forum
			ShellExecute("http://forum.1067081.n5.nabble.com/IDM-Backup-Manager-f3.html")

	EndSwitch
WEnd

Func _7Zip_Test($sZipFile, $sPassword)
	If FileExists($sZipFile) = 0 Then
		Return SetError(4, 0, 0)
	EndIf
	If $sPassword <> "" Then
		$sPassword = "-p" & '"' & $sPassword & '" '
	EndIf
	FileWriteLine($LOG_File, _Current_Moment() & "Command Line: " & @ScriptDir & '\7z.exe' & ' t "' & $sZipFile & '" ' & $sPassword)
	Return RunWait(@ScriptDir & '\7z.exe' & ' t "' & $sZipFile & '" ' & $sPassword, "", @SW_HIDE)
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
	FileWriteLine($LOG_File, _Current_Moment() & "Command Line: " & @ScriptDir & '\7z.exe' & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"')
	Return RunWait(@ScriptDir & '\7z.exe' & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"', "", @SW_HIDE)
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
	FileWriteLine($LOG_File, _Current_Moment() & "Command Line: " & @ScriptDir & '\7z.exe' & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"' & " " & $sFile_To_Extracr & " -r")
	Return RunWait(@ScriptDir & '\7z.exe' & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"' & " " & $sFile_To_Extracr & " -r", "", @SW_HIDE)

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
	FileWriteLine($LOG_File, _Current_Moment() & "Command Line: " & @ScriptDir & "\7z.exe" & " " & "a" & " " & '"' & $s7z_File_Save_Name & '"' & $sCompression & " " & $sPassword & '"' & $sDestinationFolder & '"')
	Return RunWait(@ScriptDir & "\7z.exe" & " " & "a" & " " & '"' & $s7z_File_Save_Name & '"' & $sCompression & " " & $sPassword & '"' & $sDestinationFolder & '"', "", @SW_HIDE)
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
	FileWriteLine($LOG_File, _Current_Moment() & "Command Line: " & @ScriptDir & "\7z.exe" & " " & "a" & " " & '"' & $s7z_File_Save_Name & '"' & $sCompression & " " & $sPassword & '"' & $sDestinationFolder & "*" & '"')
	Return RunWait(@ScriptDir & "\7z.exe" & " " & "a" & " " & '"' & $s7z_File_Save_Name & '"' & $sCompression & " " & $sPassword & '"' & $sDestinationFolder & "*" & '"', "", @SW_HIDE)
EndFunc   ;==>_7Zip_Add_

;_regbackup(c:\path\name1.reg",     hku\folder1\folder2)
;_regbackup(@TempDir & "\" & "Scheduler.reg", $regkey_x86_IDM & "\Scheduler")
Func _regbackup($s7z_File_Save_Name, $regkey)
	ShellExecuteWait('regedit.exe', '/e "' & $s7z_File_Save_Name & '"' & " " & $regkey)
EndFunc   ;==>_regbackup

;_regbackup(c:\path\name1.reg")
;_regbackup(@TempDir & "\" & "Scheduler.reg")
Func _reg_import($s7z_File_Save_Name)
	ShellExecuteWait('regedit.exe', "/s /c " & $s7z_File_Save_Name)
EndFunc   ;==>_reg_import

Func _control_update_busy()
	GUICtrlSetState($Browse_Button_Backup, $GUI_DISABLE)
	GUICtrlSetState($Backup_Button, $GUI_DISABLE)
	GUICtrlSetState($Browse_Button_Restore, $GUI_DISABLE)
	GUICtrlSetState($Restore_Button, $GUI_DISABLE)
	GUISetCursor(15, 1, $IDMBM)
EndFunc   ;==>_control_update_busy

Func _control_update_default()
	GUICtrlSetState($Browse_Button_Backup, $GUI_ENABLE)
	GUICtrlSetState($Backup_Button, $GUI_ENABLE)
	GUICtrlSetState($Browse_Button_Restore, $GUI_ENABLE)
	GUICtrlSetState($Restore_Button, $GUI_ENABLE)
	GUISetCursor(-1, 0, $IDMBM)
EndFunc   ;==>_control_update_default

Func _Drive_Get_From_Path($path)
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[1]
EndFunc   ;==>_Drive_Get_From_Path

Func _IsInternetConnected()
	Local $aReturn = DllCall('connect.dll', 'long', 'IsInternetConnected')
	If @error Then
		Return SetError(1, 0, False)
	EndIf
	Return $aReturn[0] = 0
EndFunc   ;==>_IsInternetConnected

Func _IsDir($sFilePath)
	Return Number(FileExists($sFilePath) And StringInStr(FileGetAttrib($sFilePath), "D", 2, 1) > 0)
EndFunc   ;==>_IsDir

Func _7z_Errors($foo)
	If $foo = 1 Then
		Return "Warning (Non fatal error(s)) For example, one or more files were locked by some other application, so they were not compressed."
	ElseIf $foo = 2 Then
		Return "Fatal Error"
	ElseIf $foo = 3 Then
		Return "Destination File/Folder Not Exist To Add To Archive"
	ElseIf $foo = 4 Then
		Return "Backup File Not Found"
	ElseIf $foo = 7 Then
		Return "Command line error"
	ElseIf $foo = 8 Then
		Return "Not enough memory for operation"
	ElseIf $foo = 255 Then
		Return "Operation Canclled"
	ElseIf $foo = 0 Then
		Return "Done"
	Else
		Return "Unknown Error"
	EndIf
EndFunc   ;==>_7z_Errors

Func _Current_Moment()
	Return @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & " --> "
EndFunc   ;==>_Current_Moment

Func clean()
	GUISetState(@SW_DISABLE, $IDMBM)
	Local $size = WinGetPos($Win_Title)
	Local $clean = GUICreate("IDM Cleaner", 202, 259, $size[0], $size[1], BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), -1, $IDMBM)
	GUISetBkColor(0xFFFFFF)
	GUISetIcon(@ScriptDir & "\Resorces\icon.ico", -1, $clean)

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
	__AET_ButtonSetIcon(-1, 0, 32, 32, 0, "Ok32.ico")
	GUICtrlSetTip(-1, "Clean The Files/Folders", "Clean", 1, 1)

	Local $Button_Analyze = GUICtrlCreateButton("", 110, 215, 40, 40)
	__AET_ButtonSetIcon(-1, 0, 32, 32, 0, "search.ico")
	GUICtrlSetTip(-1, "Analyze Size of Files/Folders To Clean", "Analyze", 1, 1)
	GUISetState(@SW_SHOW)

	Local $DwnlData_Folder = $TempPath & "DwnlData"
	Local $Grabber_Folder = $TempPath & "Grabber"
	Local $GrabberData_Folder = $TempPath & "GrabberData"
	Local $Scheduler_Folder = $TempPath & "Scheduler"

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
					MsgBox(64, "Info", Round(DirGetSize($TempPath) / 1048576) & "MB" & " Will Deleted.", 0, $clean)
				Else
					If GUICtrlRead($Clena_DD) = $GUI_CHECKED Then $size += Round(DirGetSize($DwnlData_Folder) / 1048576)
					If GUICtrlRead($Clean_GD) = $GUI_CHECKED Then $size += Round(DirGetSize($GrabberData_Folder) / 1048576)
					If GUICtrlRead($Clean_SD) = $GUI_CHECKED Then $size += Round(DirGetSize($Scheduler_Folder) / 1048576)
					$size_ = $size & "MB"
					MsgBox(64, "Info", $size_ & " Will Deleted.", 0, $clean)
				EndIf ;==>clean

			Case $Button_Clean
				If GUICtrlRead($Full_Clean) = $GUI_CHECKED Then

					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox(36, "Conform", Round(DirGetSize($TempPath) / 1048576) & "MB" & " Will Deleted. Continue?", 0, $clean)
					Select
						Case $iMsgBoxAnswer = 6 ;Yes
							$Full_Delete = DirRemove($TempPath, 1)
							If @error Then MsgBox(16, "Error", " Could Not Delete. " & $TempPath & " It May be Locked.", 0, $clean)
						Case $iMsgBoxAnswer = 7 ;No
					EndSelect

				ElseIf GUICtrlRead($Custom_Clean) = $GUI_CHECKED Then
					Local $size = 0
					If GUICtrlRead($Clena_DD) = $GUI_CHECKED Then $size += Round(DirGetSize($DwnlData_Folder) / 1048576)
					If GUICtrlRead($Clean_GD) = $GUI_CHECKED Then $size += Round(DirGetSize($GrabberData_Folder) / 1048576)
					If GUICtrlRead($Clean_SD) = $GUI_CHECKED Then $size += Round(DirGetSize($Scheduler_Folder) / 1048576)
					$size_ = $size & "MB"

					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox(36, "Conform", $size_ & " Will Deleted. Continue?", 0, $clean)
					If $iMsgBoxAnswer = 6 Then
						_ProgressMarquee_Start($Progress1)
						If GUICtrlRead($Clena_DD) = $GUI_CHECKED Then
							$Full_Delete1 = DirRemove($DwnlData_Folder, 1)
							If @error Then MsgBox(16, "Error", " Could Not Delete. " & $DwnlData_Folder & " It May be Locked.", 0, $clean)
						EndIf

						If GUICtrlRead($Clean_GD) = $GUI_CHECKED Then
							$Full_Delete2 = DirRemove($Grabber_Folder, 1)
							If @error Then MsgBox(16, "Error", " Could Not Delete. " & $Grabber_Folder & " It May be Locked.")
							$Full_Delete3 = DirRemove($GrabberData_Folder, 1)
							If @error Then MsgBox(16, "Error", " Could Not Delete. " & $GrabberData_Folder & " It May be Locked.", 0, $clean)
						EndIf

						If GUICtrlRead($Clean_SD) = $GUI_CHECKED Then
							$Full_Delete4 = DirRemove($Scheduler_Folder, 1)
							If @error Then MsgBox(16, "Error", " Could Not Delete. " & $Scheduler_Folder & " It May be Locked.", 0, $clean)
						EndIf

						If GUICtrlRead($Clean_SD) = $GUI_CHECKED Then
							FileDelete($TempPath & "defextmap.dat")
							FileDelete($TempPath & "foldresHistory.txt")
							FileDelete($TempPath & "GlobalErrors.log")
							FileDelete($TempPath & "sts_list.dat")
							FileDelete($TempPath & "urlexclist.dat")
							FileDelete($TempPath & "UrlHistory*.txt")
						EndIf
					EndIf
					_ProgressMarquee_Stop($Progress1, 0)
					MsgBox(64, "Done", "Done.", 0, $clean)
				EndIf
		EndSwitch
	WEnd
	GUISetState(@SW_ENABLE, $IDMBM)
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

Func _Check_IDM_Process()
	If ProcessExists("idman.exe") Then ;**** Check the process "idman.exe" exists or not ***
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox(36, "IDM Need To Close", "IDM is Running in Background.Do You Want To Close IDM?")
		Select
			Case $iMsgBoxAnswer = 6 ;Yes
				ProcessClose("idman.exe")
				FileWriteLine($LOG_File, _Current_Moment() & "Internet Download Manager Is Closed. Now Cont...")
			Case $iMsgBoxAnswer = 7 ;No
				FileWriteLine($LOG_File, _Current_Moment() & "Internet Download Manager Is Running Now...User Selected No")
				MsgBox(48, "Warning", "If Some File is Locked By IDM Backup Process Will Not Work Correctly.")
		EndSelect
	EndIf
EndFunc   ;==>_Check_IDM_Process

Func _Check_Reg()
	Local $AppDataIDMFolder, $TempPath

	$AppDataIDMFolder = RegRead($regkey_x86_IDM, "AppDataIDMFolder")
	FileWriteLine($LOG_File, _Current_Moment() & "$AppDataIDMFolder " & "= " & '"' & $AppDataIDMFolder & '" ' & " Error Code:" & @error)

	$TempPath = RegRead($regkey_x86_IDM, "TempPath")
	FileWriteLine($LOG_File, _Current_Moment() & "$TempPath " & "=" & ' "' & $TempPath & '" ' & " Error Code:" & @error)

	If FileExists($AppDataIDMFolder) Then
		If FileExists($TempPath) Then
			FileWriteLine($LOG_File, _Current_Moment() & "Finilized Path $AppDataIDMFolder= " & '"' & $AppDataIDMFolder & '"')
			FileWriteLine($LOG_File, _Current_Moment() & "Finilized Path $TempPath= " & '"' & $TempPath & '"')
		Else
			FileWriteLine($LOG_File, _Current_Moment() & "Not Found $TempPath: " & '"' & $TempPath & '"')
			$TempPath = $AppDataIDMFolder
			FileWriteLine($LOG_File, _Current_Moment() & "Auto assign $TempPath = $AppDataIDMFolder: " & '"' & $TempPath & '"')
		EndIf
	Else
		If FileExists($TempPath) Then
			FileWriteLine($LOG_File, _Current_Moment() & "Not Found $AppDataIDMFolder: " & '"' & $AppDataIDMFolder & '"')
			$AppDataIDMFolder = $TempPath
			FileWriteLine($LOG_File, _Current_Moment() & "Auto assign $AppDataIDMFolder = $TempPath: " & '"' & $AppDataIDMFolder & '"')
		Else
			FileWriteLine($LOG_File, _Current_Moment() & "Not Found $TempPath: " & '"' & $TempPath & '"')
			$TempPath = @AppDataDir & "\" & "IDM" & "\"
			FileWriteLine($LOG_File, _Current_Moment() & "Auto assign $TempPath: " & '"' & $TempPath & '"')

			FileWriteLine($LOG_File, _Current_Moment() & "Not Found $AppDataIDMFolder: " & '"' & $AppDataIDMFolder & '"')
			$AppDataIDMFolder = @AppDataDir & "\" & "IDM" & "\"
			FileWriteLine($LOG_File, _Current_Moment() & "Auto assign $TempPath: " & '"' & $AppDataIDMFolder & '"')
		EndIf
	EndIf
	Return $TempPath
EndFunc   ;==>_Check_Reg

Func _log_Sysinfo()
	FileWriteLine($LOG_File, "")
	FileWriteLine($LOG_File, "============================= New Session Started at " & _Current_Moment() & "=============================")
	FileWriteLine($LOG_File, "")
	FileWriteLine($LOG_File, "============================= System Information =============================")
	FileWriteLine($LOG_File, "Module Name and Version: " & $Win_Title)
	FileWriteLine($LOG_File, "Module Path: " & @ScriptFullPath)
	FileWriteLine($LOG_File, "OS Type: " & @OSType)
	FileWriteLine($LOG_File, "OS Version: " & @OSVersion)
	FileWriteLine($LOG_File, "Service Package: " & @OSServicePack)
	FileWriteLine($LOG_File, "Total Memory: " & $MEMORY[1])
	FileWriteLine($LOG_File, "Available Memory: " & $MEMORY[2])
	FileWriteLine($LOG_File, "")
	FileWriteLine($LOG_File, "============================= Variable Assignment =============================")
EndFunc   ;==>_log_Sysinfo

Func _Check_Componment()
	If Not FileExists(@ScriptDir & "\7z.exe") Then
		FileWriteLine($LOG_File, "7z.exe not found. Exiting....")
		MsgBox(16, "Error", "7z.exe not found. Exiting....")
		Exit -2
	EndIf
EndFunc   ;==>_Check_Componment

Func __AET_ButtonSetIcon($hWnd, $iIndex, $iWidth, $iHeight, $iAlign, $sIcon)
	Local $hImageList
	$hImageList = _GUIImageList_Create($iWidth, $iHeight, 5, 3)
	_GUIImageList_AddIcon($hImageList, @ScriptDir & "\Resorces\" & $sIcon, $iIndex, True)
	_GUICtrlButton_SetImageList($hWnd, $hImageList, $iAlign)
EndFunc   ;==>__AET_ButtonSetIcon

Func _check_cmd()
	If $CmdLine[0] > 0 Then
		If $CmdLine[0] = 1 Then
			GUICtrlSetData($INFO, "INFO: Ready")
			GUICtrlSetState($Restore_Button, $GUI_ENABLE)
			GUICtrlSetData($Restore_Input, $CmdLine[1])
			GUICtrlSetState($TabSheet2, $GUI_SHOW)
		Else
			MsgBox(16, "Error", "Wrong Command Line.")
			FileWriteLine($LOG_File, "Wrong Command Line.")
		EndIf
	EndIf
EndFunc   ;==>_check_cmd