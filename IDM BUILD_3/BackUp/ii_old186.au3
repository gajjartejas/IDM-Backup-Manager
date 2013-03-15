#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\IDM BUILD_2\icon.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=IDM Backup Manager is a free software that can backup files from Internet Download Manager
#AutoIt3Wrapper_Res_Description=IDM Backup Manager is a free software that can backup files from Internet Download Manager
#AutoIt3Wrapper_Res_Fileversion=0.9.3.0
#AutoIt3Wrapper_Res_LegalCopyright=©Gajjar Tejas 2012
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

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
#include "_FileIsPathValid.au3"
#include "_RegFunc.au3"

;==============================================================================================

$LOG_File = @ScriptDir & "\file.log"
$MEMORY = MemGetStats()
;==============================================================================================
If @OSArch <> "X86" Then
	MsgBox(16, "Advisory!", "This application is not compatable with the architecture of this operating system." & @CR & "The application will now exit.")
	FileWriteLine($LOG_File, "@OSArch " & "=" & '"' & @OSArch & '"' & "	Exit Code:" & "-1")
	Exit -1
EndIf

;==============================================================================================
#region ;**** Create title and read registry of IDM Backup Manager and Read IDM registry****
Global $regkey_x86_IDM = "HKEY_CURRENT_USER\Software\DownloadManager"
Global $regkey_x86_IDMBM = "HKEY_CURRENT_USER\Software\IDM Backup Manager"
Global $current_version = "0.9.3"
Global $Win_Title = "IDM Backup Manager" & $current_version & "(Beta)"


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
;==============================================================================================
$AppDataIDMFolder = RegRead($regkey_x86_IDM, "AppDataIDMFolder")
FileWriteLine(@ScriptDir & '\file.log', _Current_Moment() & "$AppDataIDMFolder " & "= " & '"' & $AppDataIDMFolder & '" ' & " Error Code:" & @error)
$TempPath = RegRead($regkey_x86_IDM, "TempPath")
FileWriteLine(@ScriptDir & '\file.log', _Current_Moment() & "$TempPath " & "=" & ' "' & $TempPath & '" ' & " Error Code:" & @error)
;==============================================================================================
#region

If ProcessExists("idman1.exe") Then ;**** Check the process "idman.exe" exists or not ***
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(4, "IDM Need To Close", "Close IDM Before You Can Continue.Do You Want To Close IDM?")
	Select
		Case $iMsgBoxAnswer = 6 ;Yes
			ProcessClose("idman.exe")
			FileWriteLine($LOG_File, _Current_Moment() & "Internet Download Manager Is Closed. Now Cont...")
		Case $iMsgBoxAnswer = 7 ;No
			FileWriteLine($LOG_File, _Current_Moment() & "Internet Download Manager Is Running Now...User Selected No Exit Code -2")
			Exit -2
	EndSelect
EndIf

$Intial_Backup_Path = RegRead($regkey_x86_IDMBM, "Backup Folder")
FileWriteLine($LOG_File, _Current_Moment() & "$Intial_Backup_Path " & "=" & ' "' & $Intial_Backup_Path & '" ' & "Error Code:" & @error)
If @error <> 0 Then
	$Intial_Backup_Path = ""
EndIf

$Intial_Restore_Path = RegRead($regkey_x86_IDMBM, "Restore Folder")
FileWriteLine($LOG_File, _Current_Moment() & "$Intial_Restore_Path " & "=" & ' "' & $Intial_Restore_Path & '" ' & "Error Code:" & @error)
If @error <> 0 Then
	$Intial_Restore_Path = ""
EndIf

$version = RegRead($regkey_x86_IDMBM, "Software Version")
FileWriteLine($LOG_File, _Current_Moment() & "$version " & "=" & ' "' & $version & '" ' & "Error Code:" & @error)
If $version <> $current_version Then RegWrite($regkey_x86_IDMBM, "Software Version", "REG_SZ", $current_version)

#endregion

;**** Create main GUI of the IDM Backup Manager ****
;==============================================================================================
#region ### START Koda GUI section ### Form=C:\Users\Tejas\Desktop\project\IDM\IDM BUILD_3\Form4.kxf

$IDMBM = GUICreate($Win_Title, 439, 276, 401, 252)

$Tab1 = GUICtrlCreateTab(10, 10, 420, 240)

$TabSheet1 = GUICtrlCreateTabItem("Backup Data")

$Group1 = GUICtrlCreateGroup("Backup Location", 24, 44, 390, 55)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

$Backup_Input = GUICtrlCreateInput("", 33, 64, 336, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Browse_Button_Backup = GUICtrlCreateButton("...", 376, 63, 30, 23)
GUICtrlSetTip(-1, "Browse For Backup Path")

$Backup_Button = GUICtrlCreateButton("Backup Now...", 319, 217, 95, 25)
GUICtrlSetTip(-1, "Backup Now")

$Group6 = GUICtrlCreateGroup("Options", 24, 104, 390, 100)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

$Checkbox_backup_Password = GUICtrlCreateCheckbox("", 38, 130, 12, 17)
GUICtrlSetTip(-1, "Choose Yes If You Want Encryption of Your Backup Files Which Is Required Strong Password", "Backup Password", 1, 1)

$Input_backup_Password = GUICtrlCreateInput("Password", 54, 128, 130, 21, $ES_PASSWORD)
GUICtrlSetTip(-1, "Choose Yes If You Want Encryption of Your Backup Files Which Is Required Strong Password", "Backup Password", 1, 1)

$Checkbox_restore_Setting_Compression = GUICtrlCreateCheckbox("", 39, 159, 12, 17)
GUICtrlSetTip(-1, "Here You Can Set The Compression Level of The Backup Files" & @CRLF & "", "Compression Level", 1, 1)

$Setting_Compression_Level = GUICtrlCreateCombo("1-No Compression", 54, 157, 130, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "2-Fastest Compression|3-Fast Compression|4-Normal Compression|5-Maximum Compression|6-Ultra Compression", "1-No Compression")
GUICtrlSetTip(-1, "Here You Can Set The Compression Level of The Backup Files" & @CRLF & "", "Compression Level", 1, 1)

$Unfinished_DD = GUICtrlCreateCheckbox("Downloaded Data", 200, 149, 107, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Unfinished_GD = GUICtrlCreateCheckbox("Grabber Data", 310, 149, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Unfinished_SD = GUICtrlCreateCheckbox("Scheduler Data", 200, 170, 107, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Full_Backup = GUICtrlCreateCheckbox("Full Backup", 200, 128, 107, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Unfinished_HL = GUICtrlCreateCheckbox("History and Logs", 310, 170, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$INFO1 = GUICtrlCreateLabel("INFO", 26, 221, 293, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

;==============================================================================================
$TabSheet2 = GUICtrlCreateTabItem("Restore Data")

$Group2 = GUICtrlCreateGroup("Restore Location", 24, 44, 390, 55)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

$Restore_Input = GUICtrlCreateInput("", 33, 64, 336, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))

$Browse_Button_Restore = GUICtrlCreateButton("...", 376, 63, 30, 23)
GUICtrlSetTip(-1, "Browse For Restore Path")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Restore_Button = GUICtrlCreateButton("Restore Now...", 319, 217, 95, 25)
GUICtrlSetTip(-1, "Restore Now")

$Group7 = GUICtrlCreateGroup("Options", 24, 104, 390, 100)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

$Checkbox_restore_Password = GUICtrlCreateCheckbox("", 38, 130, 12, 17)
GUICtrlSetTip(-1, "Choose Yes If Your backup is Encrypted", "Restore Encryption", 1, 1)

$Input_restore_Password = GUICtrlCreateInput("Password", 54, 128, 130, 21, $ES_PASSWORD)
GUICtrlSetTip(-1, "Choose Yes If Your backup is Encrypted", "Restore Encryption", 1, 1)

$Checkbox_restore_Convert_Registry = GUICtrlCreateCheckbox("", 39, 159, 12, 17)
GUICtrlSetTip(-1, "Choose Yes If Destination Backup is another System" & @CRLF & @CRLF & "EXAMPLE:" & @CRLF & "Incase of If You Want To Restore Backup of Cybercafe to Your Home PC", "Convert Profile", 1, 1)

$Label_Convert_Registry = GUICtrlCreateLabel("Convert Profile", 60, 160, 73, 17)
GUICtrlSetTip(-1, "Choose Yes If Destination Backup is another System" & @CRLF & @CRLF & "EXAMPLE:" & @CRLF & "Incase of If You Want To Restore Backup of Cybercafe to Your Home PC", "Convert Profile", 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$INFO2 = GUICtrlCreateLabel("INFO", 26, 221, 293, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
;==============================================================================================


$TabSheet3 = GUICtrlCreateTabItem("Tools")
$Group3 = GUICtrlCreateGroup("Tools", 24, 44, 390, 90)
$Tools_List_Man = GUICtrlCreateButton("Downloads List Manager", 254, 104, 155, 25)
$Edit1 = GUICtrlCreateEdit("", 30, 60, 375, 39, BitOR($ES_READONLY,$ES_WANTRETURN), 0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetData(-1, StringFormat("Download List Manager is allow to use Join Unfinished \r\nDownloaded Files, Remove Download From List and much more"))
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetCursor (-1, 2)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group4 = GUICtrlCreateGroup("Cleaner", 25, 140, 390, 90)
$Tools_Cleaner_Man = GUICtrlCreateButton("Cleaner", 255, 200, 155, 25)
$Edit2 = GUICtrlCreateEdit("", 31, 156, 375, 39, BitOR($ES_READONLY,$ES_WANTRETURN), 0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetData(-1, "Clean History, Logs and Unfinished Download Data.")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetCursor (-1, 2)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;==============================================================================================
$TabSheet4 = GUICtrlCreateTabItem("Help")
$Help_Tab = GUICtrlCreateGroup("Help and Update", 24, 44, 390, 160)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Website = GUICtrlCreateButton("Website", 37, 126, 100, 30)
$Help = GUICtrlCreateButton("Help", 37, 66, 100, 30)
GUICtrlSetCursor(-1, 4)
$Licence = GUICtrlCreateButton("Licence", 37, 96, 100, 30)
GUICtrlSetCursor(-1, 4)
$View_Log = GUICtrlCreateButton("View Log", 146, 66, 100, 30)
$Bug_Report = GUICtrlCreateButton("Bug Report", 146, 96, 100, 30)
$Update = GUICtrlCreateButton("Update", 146, 126, 100, 30)
$Pic1 = GUICtrlCreatePic(@ScriptDir & "\Resorces\contactme.jpg", 260, 55, 150, 145)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")

GUICtrlSetState($Backup_Button, $GUI_DISABLE)
GUICtrlSetState($Restore_Button, $GUI_DISABLE)
GUICtrlSetState($Input_backup_Password, $GUI_DISABLE)
GUICtrlSetState($Input_restore_Password, $GUI_DISABLE)
GUICtrlSetState($Setting_Compression_Level, $GUI_DISABLE)
GUICtrlSetState($Label_Convert_Registry, $GUI_DISABLE)

GUISetState(@SW_SHOW)
FileWriteLine($LOG_File, _Current_Moment() & "Window Created: " & $Win_Title & " With Error Code: " & @error)
#endregion ### END Koda GUI section ###

;==============================================================================================

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

;==============================================================================================
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg

		Case $GUI_EVENT_CLOSE
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $IDMBM, "int", 1000, "long", 0x00050010);implode
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
				GUICtrlSetState($Unfinished_DD, $GUI_DISABLE)
				GUICtrlSetState($Unfinished_GD, $GUI_DISABLE)
				GUICtrlSetState($Unfinished_SD, $GUI_DISABLE)
				GUICtrlSetState($Unfinished_HL, $GUI_DISABLE)
			Else
				GUICtrlSetState($Unfinished_DD, $GUI_ENABLE)
				GUICtrlSetState($Unfinished_GD, $GUI_ENABLE)
				GUICtrlSetState($Unfinished_SD, $GUI_ENABLE)
				GUICtrlSetState($Unfinished_HL, $GUI_ENABLE)
			EndIf

		Case $Unfinished_SD
			If GUICtrlRead($Unfinished_SD) = $GUI_CHECKED Then
				GUICtrlSetState($Full_Backup, $GUI_DISABLE)
			Else
				If GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_HL) = $GUI_CHECKED Then
					GUICtrlSetState($Full_Backup, $GUI_DISABLE)
				Else
					GUICtrlSetState($Full_Backup, $GUI_ENABLE)
				EndIf

			EndIf

		Case $Unfinished_GD
			If GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Then
				GUICtrlSetState($Full_Backup, $GUI_DISABLE)
			Else
				If GUICtrlRead($Unfinished_SD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_HL) = $GUI_CHECKED Then
					GUICtrlSetState($Full_Backup, $GUI_DISABLE)
				Else
					GUICtrlSetState($Full_Backup, $GUI_ENABLE)
				EndIf
			EndIf

		Case $Unfinished_DD
			If GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Then
				GUICtrlSetState($Full_Backup, $GUI_DISABLE)
			Else
				If GUICtrlRead($Unfinished_SD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_HL) = $GUI_CHECKED Then
					GUICtrlSetState($Full_Backup, $GUI_DISABLE)
				Else
					GUICtrlSetState($Full_Backup, $GUI_ENABLE)
				EndIf
			EndIf

		Case $Unfinished_HL
			If GUICtrlRead($Unfinished_HL) = $GUI_CHECKED Then
				GUICtrlSetState($Full_Backup, $GUI_DISABLE)
			Else
				If GUICtrlRead($Unfinished_SD) = $GUI_CHECKED Or GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Or $Unfinished_DD = $GUI_CHECKED Then
					GUICtrlSetState($Full_Backup, $GUI_DISABLE)
				Else
					GUICtrlSetState($Full_Backup, $GUI_ENABLE)
				EndIf
			EndIf

		Case $Browse_Button_Backup
			$Backup_path = FileSelectFolder("Choose a folder to save backup...", "", 7, $Intial_Backup_Path, $IDMBM)
			If StringRight($Backup_path, 1) <> "\" Then $Backup_path &= "\"
			$Backup_7z_path = $Backup_path & "IDMbackup.7z"


			If _FileIsPathValid($Backup_path) = True Then
				If FileExists($Backup_7z_path) Then
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox(36, "Confirm Save", "Previous Backup File :-" & @CRLF & $Backup_7z_path & @CRLF & "Already Exists Do You Want To Replace It?", 0, $IDMBM)
					Select
						Case $iMsgBoxAnswer = 6 ;Yes
							If FileDelete($Backup_7z_path) = 0 Then
								GUICtrlSetState($Backup_Button, $GUI_DISABLE)
								GUICtrlSetData($Backup_Input, "")
								MsgBox(48, "Warning", "Files Could Not Deleted." & @CRLF & @CRLF & $Backup_7z_path, 0, $IDMBM)
							Else
								GUICtrlSetState($Backup_Button, $GUI_ENABLE)
								GUICtrlSetData($Backup_Input, $Backup_path)
							EndIf
						Case $iMsgBoxAnswer = 7 ;No
							GUICtrlSetData($Backup_Input, "")
							GUICtrlSetState($Backup_Button, $GUI_DISABLE)
					EndSelect
				Else
					GUICtrlSetState($Backup_Button, $GUI_ENABLE)
					GUICtrlSetData($Backup_Input, $Backup_path)
				EndIf
			Else
				If $Backup_path <> "\" Then
					If _FileIsPathValid(GUICtrlRead($Backup_Input)) = True Then
						GUICtrlSetState($Backup_Button, $GUI_ENABLE)
					Else
						GUICtrlSetState($Backup_Button, $GUI_DISABLE)
					EndIf
					MsgBox(48, "Error", '"' & $Backup_path & '"' & " is not Valid Folder", 0, $IDMBM)
				Else
					If _FileIsPathValid(GUICtrlRead($Backup_Input)) = True Then
						GUICtrlSetState($Backup_Button, $GUI_ENABLE)
					Else
						GUICtrlSetState($Backup_Button, $GUI_DISABLE)
					EndIf
				EndIf
			EndIf

		Case $Backup_Button
			FileWriteLine($LOG_File, "")
			FileWriteLine($LOG_File, "============================= Backup Session Started =============================")
			If GUICtrlRead($Checkbox_backup_Password) = $GUI_CHECKED Then
				$passwd = GUICtrlRead($Input_backup_Password)
				If $passwd = "" Then
					MsgBox(48, "Alert", "Password is Empty", 0, $IDMBM)
					ContinueLoop
				EndIf
				$password_exists = True
			Else
				$password_exists = False
				$passwd = ""
			EndIf
			_control_update_busy()
			FileWriteLine($LOG_File, _Current_Moment() & "Password= " & '"' & $password_exists & '"')

			$ini_File = @TempDir & "\" & "idm_guest_Setting.ini"
			FileWriteLine($LOG_File, _Current_Moment() & "$ini_File= " & '"' & $ini_File & '"')
			$reg_File = @TempDir & "\" & "IDMregistry.reg"
			FileWriteLine($LOG_File, _Current_Moment() & "$reg_File= " & '"' & $reg_File & '"')

			$Temp_File_1 = FileDelete($reg_File)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $reg_File & '" ' & "Error Code:" & @error)
			$Temp_File_2 = FileDelete($ini_File)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $ini_File & '" ' & "Error Code:" & @error)

			If GUICtrlRead($Full_Backup) = $GUI_CHECKED Then
				FileWriteLine($LOG_File, _Current_Moment() & "User Selected Full Backup to  " & "=" & ' "' & $Backup_path & '"')
				$k = 1
				While 1
					$var = RegEnumKey($regkey_x86_IDM, $k)
					If @error <> 0 Then ExitLoop
					$k += 1
				WEnd
				If $k = 1 Then
					MsgBox(48, "Error", "Nothing To Backup !", 0, $IDMBM)
					FileWriteLine($LOG_File, _Current_Moment() & "Registry Entry Is Empty. Nothing To Backup !")
				Else
					IniWrite($ini_File, "Default", "AppDataIDMFolder", RegRead($regkey_x86_IDM, "AppDataIDMFolder"))
					IniWrite($ini_File, "Default", "TempPath", RegRead($regkey_x86_IDM, "TempPath"))
					IniWrite($ini_File, "Default", "idmvers", RegRead($regkey_x86_IDM, "idmvers"))
					IniWrite($ini_File, "Default", "Password", $password_exists)
					IniWrite($ini_File, "Default", "Mode", "Full")
					IniWrite($ini_File, "Default", "Username", @UserName)
					IniWrite($ini_File, "Default", "Keys", $k)

					_regbackup($reg_File, "HKEY_CURRENT_USER\Software\DownloadManager\")

					$foo_2 = _7Zip_Add_($Backup_7z_path, $TempPath, GUICtrlRead($Setting_Compression_Level), $passwd) ;add idm app
					FileWriteLine($LOG_File, _Current_Moment() & "Adding $TempPath " & "=" & ' "' & $TempPath & '" ' & "Error Code:" & _7z_Errors($foo_2))
					$foo_3 = _7Zip_Add($Backup_7z_path, $reg_File, GUICtrlRead($Setting_Compression_Level), $passwd) ;add Reg
					FileWriteLine($LOG_File, _Current_Moment() & "Adding $reg_File " & "=" & ' "' & $reg_File & '" ' & "Error Code:" & _7z_Errors($foo_3))
					$foo_16 = _7Zip_Add($Backup_7z_path, $ini_File, GUICtrlRead($Setting_Compression_Level), "") ; update  add ini
					FileWriteLine($LOG_File, _Current_Moment() & "Adding $ini_File " & "=" & ' "' & $ini_File & '" ' & "Error Code:" & _7z_Errors($foo_16))
				EndIf
			Else
				FileWriteLine($LOG_File, _Current_Moment() & "User Selected Custom Backup to  " & "=" & ' "' & $Backup_path & '"')
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

				$Backup_reg_temp_path = @TempDir & "\" & "IDMregistry"
				$Temp_File_3 = FileDelete($Backup_reg_temp_path)
				If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $Backup_reg_temp_path & '" ' & "Error Code:" & @error)

				$k = 1
				If Not FileExists($Backup_reg_temp_path) Then DirCreate($Backup_reg_temp_path)
				While 1
					$var = RegEnumKey($regkey_x86_IDM, $k)
					If @error <> 0 Then ExitLoop
					_regbackup($Backup_reg_temp_path & "\" & $k & ".reg", "HKEY_CURRENT_USER\Software\DownloadManager\" & $var)
					$file_join = FileOpen($Backup_reg_temp_path & "\" & $k & ".reg")
					$file_join3 = FileRead($file_join) & @CRLF
					FileWrite($reg_File, $file_join3)
					FileClose($file_join)
					FileDelete($Backup_reg_temp_path & "\" & $k & ".reg")
					GUICtrlSetData($INFO1, "Enumming Registry Key: " & $k & "  Please Wait...")
					$k += 1
				WEnd
				FileWriteLine($LOG_File, _Current_Moment() & "Registry Backup Successful Total Key = " & '"' & $k & '"')

				$Temp_File_3 = FileDelete($Backup_reg_temp_path)
				If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $Backup_reg_temp_path & '" ' & "Error Code:" & @error)

				If $k = 1 Then
					MsgBox(48, "Error", "Nothing To Backup !", 0, $IDMBM)
					FileWriteLine($LOG_File, _Current_Moment() & "Registry Entry Is Empty.Nothing To Backup !")
				Else
					$foo_15 = _7Zip_Add($Backup_7z_path, $reg_File, GUICtrlRead($Setting_Compression_Level), $passwd)

					If FileExists($reg_File) Then
						$foo_15 = _7Zip_Add($Backup_7z_path, $reg_File, GUICtrlRead($Setting_Compression_Level), $passwd)
						FileWriteLine($LOG_File, _Current_Moment() & "Adding $reg_File " & "=" & ' "' & $reg_File & '" ' & "Error Code:" & _7z_Errors($foo_15))
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
						$foo_2 = _7Zip_Add($Backup_7z_path, $DwnlData_Folder, GUICtrlRead($Setting_Compression_Level), $passwd) ;add DwnlData_Folder
						FileWriteLine($LOG_File, _Current_Moment() & "Adding $DwnlData_Folder " & "=" & ' "' & $DwnlData_Folder & '" ' & "Error Code:" & _7z_Errors($foo_2))
						IniWrite($ini_File, "Default", "DwnlData_Folder", True)
					Else
						If GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Then FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: Folder Does Not Exit= " & '"' & $DwnlData_Folder & '"')
					EndIf
					EndIf

					If FileExists($Grabber_Folder) And GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Then
						$foo_3 = _7Zip_Add($Backup_7z_path, $Grabber_Folder, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						FileWriteLine($LOG_File, _Current_Moment() & "Adding $Grabber_Folder " & "=" & ' "' & $Grabber_Folder & '" ' & "Error Code:" & _7z_Errors($foo_3))
						IniWrite($ini_File, "Default", "Grabber_Folder", True)
					Else
						If GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Then FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: Folder Does Not Exit= " & '"' & $Grabber_Folder & '"')
					EndIf

					If FileExists($GrabberData_Folder) And GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Then
						$foo_4 = _7Zip_Add($Backup_7z_path, $GrabberData_Folder, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						FileWriteLine($LOG_File, _Current_Moment() & "Adding $GrabberData_Folder " & "=" & ' "' & $GrabberData_Folder & '" ' & "Error Code:" & _7z_Errors($foo_4))
						IniWrite($ini_File, "Default", "GrabberData_Folder", True)
					Else
						If GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Then FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: Folder Does Not Exit= " & '"' & $GrabberData_Folder & '"')
					EndIf

					If FileExists($Scheduler_Folder) And GUICtrlRead($Unfinished_SD) = $GUI_CHECKED Then
						$foo_5 = _7Zip_Add($Backup_7z_path, $Scheduler_Folder, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						FileWriteLine($LOG_File, _Current_Moment() & "Adding $Scheduler_Folder " & "=" & ' "' & $GrabberData_Folder & '" ' & "Error Code:" & _7z_Errors($foo_5))
						IniWrite($ini_File, "Default", "Scheduler_Folder", True)
					Else
						If GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Then FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: Folder Does Not Exit= " & '"' & $Scheduler_Folder & '"')
					EndIf

					If GUICtrlRead($Unfinished_HL) = $GUI_CHECKED Then

						If FileExists($UrlHistory_txt_File) Then
							$foo_6 = _7Zip_Add($Backup_7z_path, $UrlHistory_txt_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
							FileWriteLine($LOG_File, _Current_Moment() & "Adding $UrlHistory_txt_File " & "=" & ' "' & $UrlHistory_txt_File & '" ' & "Error Code:" & _7z_Errors($foo_6))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $UrlHistory_txt_File & '"')
						EndIf

						If FileExists($UrlHistory2_txt_File) Then
							$foo_7 = _7Zip_Add($Backup_7z_path, $UrlHistory2_txt_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
							FileWriteLine($LOG_File, _Current_Moment() & "Adding $UrlHistory2_txt_File " & "=" & ' "' & $UrlHistory2_txt_File & '" ' & "Error Code:" & _7z_Errors($foo_7))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $UrlHistory2_txt_File & '"')
						EndIf

						If FileExists($GlobalErrors_log_File) Then
							$foo_8 = _7Zip_Add($Backup_7z_path, $GlobalErrors_log_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
							FileWriteLine($LOG_File, _Current_Moment() & "Adding $GlobalErrors_log_File " & "=" & ' "' & $GlobalErrors_log_File & '" ' & "Error Code:" & _7z_Errors($foo_8))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $GlobalErrors_log_File & '"')
						EndIf

						If FileExists($urlexclist_dat_File) Then
							$foo_9 = _7Zip_Add($Backup_7z_path, $urlexclist_dat_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
							FileWriteLine($LOG_File, _Current_Moment() & "Adding $urlexclist_dat_File " & "=" & ' "' & $urlexclist_dat_File & '" ' & "Error Code:" & _7z_Errors($foo_9))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $urlexclist_dat_File & '"')
						EndIf

						If FileExists($defextmap_dat_File) Then
							$foo_10 = _7Zip_Add($Backup_7z_path, $defextmap_dat_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
							FileWriteLine($LOG_File, _Current_Moment() & "Adding $defextmap_dat_File " & "=" & ' "' & $defextmap_dat_File & '" ' & "Error Code:" & _7z_Errors($foo_10))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $defextmap_dat_File & '"')
						EndIf

						If FileExists($foldresHistory_txt_File) Then
							$foo_11 = _7Zip_Add($Backup_7z_path, $foldresHistory_txt_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
							FileWriteLine($LOG_File, _Current_Moment() & "Adding $foldresHistory_txt_File " & "=" & ' "' & $foldresHistory_txt_File & '" ' & "Error Code:" & _7z_Errors($foo_11))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $foldresHistory_txt_File & '"')
						EndIf

						If FileExists($sts_list_dat_File) Then
							$foo_12 = _7Zip_Add($Backup_7z_path, $sts_list_dat_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
							FileWriteLine($LOG_File, _Current_Moment() & "Adding $sts_list_dat_File " & "=" & ' "' & $sts_list_dat_File & '" ' & "Error Code:" & _7z_Errors($foo_12))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $sts_list_dat_File & '"')
						EndIf

						If FileExists($cnlurllist_dat_File) Then
							$foo_13 = _7Zip_Add($Backup_7z_path, $cnlurllist_dat_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
							FileWriteLine($LOG_File, _Current_Moment() & "Adding $cnlurllist_dat_File " & "=" & ' "' & $cnlurllist_dat_File & '" ' & "Error Code:" & _7z_Errors($foo_13))
						Else
							FileWriteLine($LOG_File, _Current_Moment() & "Not Added Reason: File Does Not Exit= " & '"' & $cnlurllist_dat_File & '"')
						EndIf

						IniWrite($ini_File, "Default", "History_Files", True)
					EndIf

					$foo_16 = _7Zip_Add($Backup_7z_path, $ini_File, GUICtrlRead($Setting_Compression_Level), "") ; update  add idm app
					FileWriteLine($LOG_File, _Current_Moment() & "Adding $ini_File " & "=" & ' "' & $ini_File & '" ' & "Error Code:" & _7z_Errors($foo_16))
				EndIf
			EndIf

			$Temp_File_4 = FileDelete($ini_File)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $ini_File & '" ' & "Error Code:" & @error)
			$Temp_File_5 = FileDelete($reg_File)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $reg_File & '" ' & "Error Code:" & @error)
			FileWriteLine($LOG_File, "============================= Backup Session Ended =============================")

			;==============================================================================================
			GUICtrlSetState($Browse_Button_Backup, $GUI_ENABLE)
			GUICtrlSetState($Backup_Button, $GUI_ENABLE)
			GUICtrlSetData($INFO1, "Done")
			_control_update_default()
			GUICtrlSetState($Backup_Button, $GUI_DISABLE)
			RegWrite($regkey_x86_IDMBM, "Backup Folder", "REG_SZ", $Backup_path)

			;==============================================================================================
		Case $Browse_Button_Restore
			$Restore_path = FileSelectFolder("Choose a folder to restore backup...", "", 2, $Intial_Restore_Path, $IDMBM)
			If StringRight($Restore_path, 1) <> "\" Then $Restore_path &= "\"
			$Restore_7z_path = $Restore_path & "IDMbackup.7z"

			If _FileIsPathValid($Restore_path) = True Then
				If Not FileExists($Restore_7z_path) Then
					MsgBox(48, "Error", "Backup File Does Not Exists in This Folder", 0, $IDMBM)
					If _FileIsPathValid(GUICtrlRead($Restore_Input)) = True Then
						GUICtrlSetState($Restore_Button, $GUI_ENABLE)
					Else
						GUICtrlSetState($Restore_Button, $GUI_DISABLE)
					EndIf
				Else
					GUICtrlSetState($Restore_Button, $GUI_ENABLE)
					GUICtrlSetData($Restore_Input, $Restore_path)
				EndIf
			Else
				If $Restore_path <> "\" Then
					If _FileIsPathValid(GUICtrlRead($Restore_Input)) = True Then
						GUICtrlSetState($Restore_Button, $GUI_ENABLE)
					Else
						GUICtrlSetState($Restore_Button, $GUI_DISABLE)
					EndIf
					MsgBox(48, "Error", '"' & $Restore_path & '"' & " is not Valid Folder", 0, $IDMBM)
				Else
					If _FileIsPathValid(GUICtrlRead($Restore_Input)) = True Then
						GUICtrlSetState($Restore_Button, $GUI_ENABLE)
					Else
						GUICtrlSetState($Restore_Button, $GUI_DISABLE)
					EndIf
				EndIf
			EndIf


			;==============================================================================================
		Case $Restore_Button
			FileWriteLine($LOG_File, "")
			FileWriteLine($LOG_File, "============================= Restore Session Started =============================")

			$Restore_7z_path = GUICtrlRead($Restore_Input) & "IDMbackup.7z"
			FileWriteLine($LOG_File, _Current_Moment() & "$Restore_7z_path= " & '"' & $Restore_7z_path & '"')
			$ini_File = @TempDir & "\" & "idm_guest_Setting.ini"
			FileWriteLine($LOG_File, _Current_Moment() & "$ini_File= " & '"' & $ini_File & '"')
			$reg_File = @TempDir & "\IDMregistry.reg"
			FileWriteLine($LOG_File, _Current_Moment() & "$reg_File= " & '"' & $reg_File & '"')
			FileDelete($ini_File)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $ini_File & '" ' & "Error Code:" & @error)
			FileDelete($reg_File)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $reg_File & '" ' & "Error Code:" & @error)

			$foo_16 = _7Zip_Extract_File($Restore_7z_path, @TempDir, "idm_guest_Setting.ini", "");Check For Password
			FileWriteLine($LOG_File, _Current_Moment() & "Extracting $cnlurllist_dat_File " & "=" & ' "' & $Restore_7z_path & "-->" & "idm_guest_Setting.ini" & '" ' & "Error Code:" & _7z_Errors($foo_13))
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

				If $Guest_Password = True Then
					FileWriteLine($LOG_File, _Current_Moment() & "Password Protected Backup File Detected")
					If GUICtrlRead($Checkbox_restore_Password) = $GUI_CHECKED Then
						If GUICtrlRead($Input_restore_Password) <> "" Then
							$passwd2 = GUICtrlRead($Input_restore_Password)
							$foo_17 = _7Zip_Test($Restore_7z_path, $passwd2)
							If $foo_17 <> 0 Then
								MsgBox(0, "Wrong Password", "CRC Failed May Be Wrong Password !")
								FileWriteLine($LOG_File, _Current_Moment() & "CRC Failed May Be Wrong Password !")
								ContinueLoop
							EndIf
						Else
							MsgBox(0, "Empty Password", "Password Protected Backup Please Enter The Password")
							FileWriteLine($LOG_File, _Current_Moment() & "Empty Password !")
							ContinueLoop
						EndIf
					Else
						MsgBox(0, "Check Checkbox", "Password Protected Backup Please Check Checkbox and Enter The Password")
						FileWriteLine($LOG_File, _Current_Moment() & "Checkbox Not Yet Checked !")
						ContinueLoop
					EndIf
				Else
					$passwd2 = ""
					FileWriteLine($LOG_File, _Current_Moment() & "Backup Files is Not Password Protected")
				EndIf
			Else
				MsgBox(0, "INI File Not Found", "INI File Not Found Inside Backup File or Backup File May Be Damaged.")
				FileWriteLine($LOG_File, _Current_Moment() & "INI File Not Found INI File Not Found Inside Backup File or Backup File May Be Damaged !")
			EndIf

			DirRemove($TempPath)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Delete  " & "=" & ' "' & $TempPath & '" ' & "Error Code:" & @error)
			DirCreate($TempPath)
			If @error Then FileWriteLine($LOG_File, _Current_Moment() & "Could Not Create  " & "=" & ' "' & $TempPath & '" ' & "Error Code:" & @error)

			If $Guest_Mode = "Full" Then
				FileWriteLine($LOG_File, _Current_Moment() & "Full Backup Mode.")
				$foo_18 = _7Zip_Extract($Restore_7z_path, $TempPath, $passwd2)
				FileWriteLine($LOG_File, _Current_Moment() & "Extracting $TempPath " & "=" & ' "' & $TempPath & '" ' & "Error Code:" & _7z_Errors($foo_18))
			Else
				FileWriteLine($LOG_File, _Current_Moment() & "Custom Backup Mode.")

				If $Guest_DwnlData_Folder = True Then
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_DwnlData_Folder= " & '"' & $Guest_DwnlData_Folder & '"')
					$foo_20 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "DwnlData" & "\", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting DwnlData " & "=" & ' "' & $Restore_7z_path & "-->" & "DwnlData\" & '" ' & "Error Code:" & _7z_Errors($foo_20))
				Else
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_DwnlData_Folder= " & '"' & $Guest_DwnlData_Folder & '"')
				EndIf


				If $Guest_Grabber_Folder = True Or $Guest_GrabberData_Folder = True Then
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_GrabberData_Folder= " & '"' & $Guest_GrabberData_Folder & '"')
					$foo_21 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "GrabberData" & "\", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting GrabberData " & "=" & ' "' & $Restore_7z_path & "-->" & "GrabberData\" & '" ' & "Error Code:" & _7z_Errors($foo_21))
					$foo_22 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "Grabber" & "\", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting Grabber " & "=" & ' "' & $Restore_7z_path & "-->" & "Grabber\" & '" ' & "Error Code:" & _7z_Errors($foo_22))
				Else
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_GrabberData_Folder= " & '"' & $Guest_GrabberData_Folder & '"')
				EndIf


				If $Guest_Scheduler_Folder = True Then
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_Scheduler_Folder= " & '"' & $Guest_Scheduler_Folder & '"')
					$foo_23 = _7Zip_Extract_File($Restore_7z_path, $TempPath, "Scheduler", $passwd2)
					FileWriteLine($LOG_File, _Current_Moment() & "Extracting Scheduler " & "=" & ' "' & $Restore_7z_path & "-->" & "Scheduler\" & '" ' & "Error Code:" & _7z_Errors($foo_23))
				Else
					FileWriteLine($LOG_File, _Current_Moment() & "$Guest_Scheduler_Folder= " & '"' & $Guest_Scheduler_Folder & '"')
				EndIf


				If $Guest_History_Files = True Then
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

			$foo_32 = _7Zip_Extract_File($Restore_7z_path, @TempDir, "IDMregistry.reg", $passwd2)
			FileWriteLine($LOG_File, _Current_Moment() & "Extracting IDMregistry.reg " & "=" & ' "' & $Restore_7z_path & "-->" & "IDMregistry.reg" & '" ' & "Error Code:" & _7z_Errors($foo_32))

			If GUICtrlRead($Checkbox_restore_Convert_Registry) = $GUI_CHECKED Then
				FileWriteLine($LOG_File, _Current_Moment() & "Converting Profile")

				_ReplaceStringInFile($reg_File, StringReplace(($Guest_AppDataIDMFolder & "DwnlData" & "\" & $Guest_Username), "\", "\\"), StringReplace($TempPath & "DwnlData" & "\" & @UserName, "\", "\\"))
				ConsoleWrite("Searching-->" & StringReplace(($Guest_AppDataIDMFolder & "DwnlData" & "\" & $Guest_Username), "\", "\\") & @CRLF)
				ConsoleWrite("Replacing-->" & StringReplace($TempPath & "DwnlData" & "\" & @UserName, "\", "\\") & @CRLF & @CRLF)
				FileWriteLine($LOG_File, _Current_Moment() & "Searching-->" & StringReplace(($Guest_AppDataIDMFolder & "DwnlData" & "\" & $Guest_Username), "\", "\\"))
				FileWriteLine($LOG_File, _Current_Moment() & "Replacing-->" & StringReplace($TempPath & "DwnlData" & "\" & @UserName, "\", "\\") & " Error Code" & @error)

				_ReplaceStringInFile($reg_File, StringReplace(($Guest_AppDataIDMFolder & "GrabberData" & "\" & $Guest_Username), "\", "\\"), StringReplace($TempPath & "GrabberData" & "\" & @UserName, "\", "\\"))
				ConsoleWrite("Searching-->" & StringReplace(($Guest_AppDataIDMFolder & "GrabberData" & "\" & $Guest_Username), "\", "\\") & @CRLF)
				ConsoleWrite("Replacing-->" & StringReplace($TempPath & "GrabberData" & "\" & @UserName, "\", "\\") & @CRLF & @CRLF)
				FileWriteLine($LOG_File, _Current_Moment() & "Searching-->" & StringReplace(($Guest_AppDataIDMFolder & "GrabberData" & "\" & $Guest_Username), "\", "\\"))
				FileWriteLine($LOG_File, _Current_Moment() & "Replacing-->" & StringReplace($TempPath & "GrabberData" & "\" & @UserName, "\", "\\") & " Error Code" & @error)

				_ReplaceStringInFile($reg_File, StringReplace(($Guest_AppDataIDMFolder), "\", "\\"), StringReplace($TempPath, "\", "\\"))
				ConsoleWrite("Searching-->" & StringReplace(($Guest_AppDataIDMFolder), "\", "\\") & @CRLF)
				ConsoleWrite("Replacing-->" & StringReplace($TempPath, "\", "\\") & @CRLF & @CRLF)
				FileWriteLine($LOG_File, _Current_Moment() & "Searching-->" & StringReplace(($Guest_AppDataIDMFolder), "\", "\\"))
				FileWriteLine($LOG_File, _Current_Moment() & "Replacing-->" & StringReplace($TempPath, "\", "\\") & " Error Code" & @error)

				DirMove($TempPath & "DwnlData\" & $Guest_Username, $TempPath & "DwnlData\" & @UserName)
				ConsoleWrite("Renaming-->" & $TempPath & "DwnlData\" & $Guest_Username & @CRLF)
				ConsoleWrite("To-->" & $TempPath & "DwnlData\" & @UserName & @CRLF & @CRLF)
				FileWriteLine($LOG_File, _Current_Moment() & "Renaming-->" & $TempPath & "DwnlData\" & $Guest_Username)
				FileWriteLine($LOG_File, _Current_Moment() & "To-->" & $TempPath & "DwnlData\" & @UserName & " Error Code" & @error)

				DirMove($TempPath & "GrabberData\" & $Guest_Username, $TempPath & "GrabberData\" & @UserName)
				ConsoleWrite("Renaming-->" & $TempPath & "GrabberData\" & $Guest_Username & @CRLF)
				ConsoleWrite("To-->" & $TempPath & "GrabberData\" & @UserName & @CRLF & @CRLF)
				FileWriteLine($LOG_File, _Current_Moment() & "Renaming-->" & $TempPath & "GrabberData\" & $Guest_Username)
				FileWriteLine($LOG_File, _Current_Moment() & "To-->" & $TempPath & "GrabberData\" & @UserName & " Error Code" & @error)

			EndIf

			$foo_19 = _reg_import($reg_File)
			ConsoleWrite("Done")

			_control_update_default()
			WinSetTitle($IDMBM, "", $Win_Title)

			FileWriteLine($LOG_File, "============================= Backup Session Ended =============================")

		Case $Tools_Cleaner_Man
			clean()
		Case $Tools_List_Man

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
					Case Else
						MsgBox(64, "Availabe", "You Should Download Following Version" & BinaryToString($Update_VER), 0, $IDMBM)
				EndSwitch
			Else
				MsgBox(48, "Error", "Internet connection could not found.", 0, $IDMBM)
			EndIf

		Case $Help
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/Start_page.htm"')

		Case $Licence
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/General_Information.htm"')

		Case $Website
			ShellExecute("http://gajjartejas26.blogspot.com")

		Case $View_Log
			About()
		Case $Restore_Input
	EndSwitch
WEnd


Func _7Zip_Test($sZipFile, $sPassword)
	If FileExists($sZipFile) = 0 Then
		Return SetError(4, 0, 0)
	EndIf
	If $sPassword <> "" Then
		$sPassword = "-p" & '"' & $sPassword & '" '
	EndIf
	$process = RunWait(@ScriptDir & '\7z.exe' & ' t "' & $sZipFile & '" ' & $sPassword, "", @SW_HIDE)
	Return $process
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
	Return RunWait(@ScriptDir & '\7z.exe' & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"' & " " & $sFile_To_Extracr & " -r", "") ;, @SW_HIDE

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
	Return RunWait(@ScriptDir & "\7z.exe" & " " & "a" & " " & '"' & $s7z_File_Save_Name & '"' & $sCompression & " " & $sPassword & '"' & $sDestinationFolder & '"', "") ;, @SW_HIDE
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
	Return RunWait(@ScriptDir & "\7z.exe" & " " & "a" & " " & '"' & $s7z_File_Save_Name & '"' & $sCompression & " " & $sPassword & '"' & $sDestinationFolder & "\*" & '"', "") ;, @SW_HIDE
EndFunc   ;==>_7Zip_Add_

Func _7Zip_Rename($name_of_archive, $File_Name, $File_New_Name);7z rn a.7z old.txt new.txt 2.txt folder\2new.txt
	If $File_Name = "" Then
		Return SetError(1, 0, 0)
	EndIf
	If $File_New_Name = "" Then
		Return SetError(1, 0, 0)
	EndIf
	If FileExists($name_of_archive) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	Return RunWait(@ScriptDir & "\7z.exe" & " " & "rn" & " " & '"' & $name_of_archive & '"' & " " & $File_Name & " " & $File_New_Name, "") ;, @SW_HIDE
EndFunc   ;==>_7Zip_Rename

; #FUNCTION# ====================================================================================================================
; Name...........:  _Path_Last_Remove
; Description....:  Remove the last path
; Syntax.........:  _Path_Last_Remove($Restore_path)
; Parameters.....:  $Restore_path - "c:\dir1\dir2"
;					$sDestinationFolder - "c:\dir1\dir2\"
; Return values..:  Success - Return Path
;				    Failure -
; Author.........:  Gajjar Tejas
; Modified.......:
; Remarks........:

; Related........:
; Link...........:
; Example........: _Path_Last_Remove(""C:\test path\test path1"")
; Output..........; "C:\test path\"
Func _Path_Last_Remove($Restore_path)
	Local $d_Saved_Path = ""
	If StringRight($Restore_path, 1) <> "\" Then
		$Restore_path &= "\"
	EndIf
	$split_path = StringSplit($Restore_path, "\")
	If @error = 1 Then
		Return $Restore_path
	ElseIf $split_path[0] = 2 Then
		Return $Restore_path
	Else
		For $i = 1 To $split_path[0] - 2 Step 1
			$d_Saved_Path &= $split_path[$i] & "\"
		Next
		Return $d_Saved_Path
	EndIf
EndFunc   ;==>_Path_Last_Remove


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
	GUICtrlSetState($Browse_Button_Backup, $GUI_DISABLE)
	GUICtrlSetState($Backup_Button, $GUI_DISABLE)
	GUICtrlSetState($Browse_Button_Restore, $GUI_DISABLE)
	GUICtrlSetState($Restore_Button, $GUI_DISABLE)
	GUISetCursor(15, 1, $IDMBM)
	GUISetCursor(15, 1, $TabSheet1)
	GUISetCursor(15, 1, $Backup_Input)
	GUISetCursor(15, 1, $TabSheet2)
	GUISetCursor(15, 1, $Restore_Input)
	GUISetCursor(15, 1, $Licence)
	GUISetCursor(15, 1, $Website)
	GUISetCursor(15, 1, $Update)
EndFunc   ;==>_control_update_busy

Func _control_update_default()
	GUICtrlSetState($Browse_Button_Backup, $GUI_ENABLE)
	GUICtrlSetState($Backup_Button, $GUI_ENABLE)
	GUICtrlSetState($Browse_Button_Restore, $GUI_ENABLE)
	GUICtrlSetState($Restore_Button, $GUI_ENABLE)
	GUISetCursor(-1, 1, $IDMBM)
	GUISetCursor(-1, 1, $TabSheet1)
	GUISetCursor(-1, 1, $Backup_Input)
	GUISetCursor(-1, 1, $TabSheet2)
	GUISetCursor(-1, 1, $Restore_Input)
	GUISetCursor(-1, 1, $Licence)
	GUISetCursor(-1, 1, $Website)
	GUISetCursor(-1, 1, $Update)
EndFunc   ;==>_control_update_default

Func _Drive_Get_From_Path($path)
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[1]
EndFunc   ;==>_Drive_Get_From_Path
Exit

Func _Ext_Get_From_Path($path)
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[4]
EndFunc   ;==>_Ext_Get_From_Path
Exit

Func _Name_Get_From_Path($path)
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[3]
EndFunc   ;==>_Name_Get_From_Path
Exit

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

Func _IsFile($sFilePath)
	Return Number(FileExists($sFilePath) And StringInStr(FileGetAttrib($sFilePath), "D", 2, 1) = 0)
EndFunc   ;==>_IsFile


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

Func About()
	GUISetState(@SW_HIDE, $IDMBM)
	$Child_About = GUICreate("About" & $Win_Title, 297, 200, -1, -1, BitAND(BitOR($GUI_SS_DEFAULT_GUI, $WS_DLGFRAME, $DS_MODALFRAME, $DS_SETFOREGROUND), Not $WS_MAXIMIZEBOX, Not $WS_MINIMIZEBOX))
	GUISetBkColor(0xFFFFFF)
	$Child_About_GroupBox = GUICtrlCreateGroup("", 3, 3, 285, 135)
	$Child_Title = GUICtrlCreateLabel($Win_Title, 57, 29, 225, 17)
	$Child_Copyright = GUICtrlCreateLabel("Copyright (c) 2012 Gajjar Tejas", 56, 57, 225, 17)
	$Child_Icon = GUICtrlCreateIcon(@ScriptDir & "\Resorces\icon.ico", -1, 10, 15, 42, 42)
	$Child_Label_Email = GUICtrlCreateLabel("Email:", 12, 90, 40, 17)
	$Child_Label_Website = GUICtrlCreateLabel("Website:", 10, 110, 66, 17)
	$Child_Label_Email_ = GUICtrlCreateLabel("gajjartejas26@gmail.com", 77, 90, 206, 17)
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetCursor(-1, 0)
	$Child_Label_Website_ = GUICtrlCreateLabel("http://www.gajjartejas26.blogspot.com", 77, 110, 206, 17)
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetCursor(-1, 0)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Child_Ok = GUICtrlCreateButton("OK", 149, 143, 135, 25, 0)
	GUISetState(@SW_SHOW, $Child_About)

	While 1
		$msg = GUIGetMsg()
		If $msg = $Child_Ok Or $msg = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd

	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Child_About, "int", 1000, "long", 0x00050010);implode
	GUIDelete()
	GUISetState(@SW_SHOW, $IDMBM)
EndFunc   ;==>About

Func _Current_Moment()
	Return @YEAR & "-" & @MON & "-" & @MDAY & " " & @MIN & ":" & @SEC & " --> "
EndFunc   ;==>_Current_Moment


Func clean()
	GUISetState(@SW_DISABLE, $IDMBM)
	Local $clean = GUICreate("Clean", 261, 259, 311, 255, -1, -1, $IDMBM)

	$Group1 = GUICtrlCreateGroup("Options", 5, 60, 250, 150)
	$Clena_DD = GUICtrlCreateCheckbox("Download Data", 20, 80, 97, 17)
	$Clean_GD = GUICtrlCreateCheckbox("Grabber Data", 20, 105, 97, 17)
	$Clean_SD = GUICtrlCreateCheckbox("Scheduler Data", 20, 130, 97, 17)
	$Clean_HL = GUICtrlCreateCheckbox("Clean History and Logs", 20, 155, 182, 17)
;~ 	$Clean_List = GUICtrlCreateCheckbox("Also Clear Download List", 20, 180, 212, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $Group2 = GUICtrlCreateGroup("Clean Mode", 5, 5, 245, 55)
	Local $Custom_Clean = GUICtrlCreateRadio("Custom Clean", 17, 29, 113, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	Local $Full_Clean = GUICtrlCreateRadio("Full Clean", 167, 29, 113, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Local $Button_Clean = GUICtrlCreateButton("Clean Now", 5, 215, 100, 30)
	Local $Progress1 = GUICtrlCreateProgress(115, 220, 135, 22)
	GUISetState(@SW_SHOW)


	If FileExists($AppDataIDMFolder) Then
		If FileExists($TempPath) Then
		Else
			$TempPath = $AppDataIDMFolder
		EndIf
	Else
		If FileExists($TempPath) Then
			$AppDataIDMFolder = $TempPath
		Else
			$TempPath = @AppDataDir & "\" & "IDM" & "\"
			$AppDataIDMFolder = @AppDataDir & "\" & "IDM" & "\"
		EndIf
	EndIf

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

			Case $Button_Clean
				If GUICtrlRead($Full_Clean) = $GUI_CHECKED Then

					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox(36, "Conform", Round(DirGetSize($TempPath) / 1048576) & " Will Deleted. Continue?")
					Select
						Case $iMsgBoxAnswer = 6 ;Yes
							$Full_Delete = DirRemove($TempPath, 1)
							If @error Then MsgBox(16, "Error", " Could Not Delete. " & $TempPath & " It May be Locked.")
						Case $iMsgBoxAnswer = 7 ;No
					EndSelect

				ElseIf GUICtrlRead($Custom_Clean) = $GUI_CHECKED Then
					Local $size = 0
					If GUICtrlRead($Clena_DD) = $GUI_CHECKED Then $size += Round(DirGetSize($DwnlData_Folder) / 1048576)
					If GUICtrlRead($Clean_GD) = $GUI_CHECKED Then $size += Round(DirGetSize($GrabberData_Folder) / 1048576)
					If GUICtrlRead($Clean_SD) = $GUI_CHECKED Then $size += Round(DirGetSize($Scheduler_Folder) / 1048576)
					$size_ = $size & "MB"
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox(36, "Conform", $size_ & " Will Deleted. Continue?")
					If $iMsgBoxAnswer = 6 Then
						_ProgressMarquee_Start($Progress1)

						If GUICtrlRead($Clena_DD) = $GUI_CHECKED Then
							$Full_Delete1 = DirRemove($DwnlData_Folder, 1)
							If @error Then MsgBox(16, "Error", " Could Not Delete. " & $DwnlData_Folder & " It May be Locked.")
						EndIf

						If GUICtrlRead($Clean_GD) = $GUI_CHECKED Then
							$Full_Delete2 = DirRemove($Grabber_Folder, 1)
							If @error Then MsgBox(16, "Error", " Could Not Delete. " & $Grabber_Folder & " It May be Locked.")
							$Full_Delete3 = DirRemove($GrabberData_Folder, 1)
							If @error Then MsgBox(16, "Error", " Could Not Delete. " & $GrabberData_Folder & " It May be Locked.")
						EndIf

						If GUICtrlRead($Clean_SD) = $GUI_CHECKED Then
							$Full_Delete4 = DirRemove($Scheduler_Folder, 1)
							If @error Then MsgBox(16, "Error", " Could Not Delete. " & $Scheduler_Folder & " It May be Locked.")
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