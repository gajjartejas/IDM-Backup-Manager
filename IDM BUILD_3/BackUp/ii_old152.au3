
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
#include "_FileIsPathValid.au3"
#include "_RegFunc.au3"
#NoTrayIcon
#RequireAdmin

;==============================================================================================
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\IDM BUILD_2\icon.ico
#AutoIt3Wrapper_Outfile=E:\IDM Backup Manager0.9.4.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=IDM Backup Manager is a free software that can backup files from InterDownload Manager
#AutoIt3Wrapper_Res_Description=IDM Backup Manager is a free software that can backup files from InterDownload Manager
#AutoIt3Wrapper_Res_Fileversion=0.9.3.0
#AutoIt3Wrapper_Res_LegalCopyright=©Gajjar Tejas 2012
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

;==============================================================================================
If @OSArch <> "X86" Then
	MsgBox(16, "Advisory!", "This application is not compatable with the architecture of this operating system." & @CR & "The application will now exit.")
	Exit -1
EndIf

;==============================================================================================
#region ;**** Create title and read registry of IDM Backup Manager and Read IDM registry****
Global Const $regkey_x86_IDM = "HKEY_CURRENT_USER\Software\DownloadManager"
Global Const $regkey_x86_IDMBM = "HKEY_CURRENT_USER\Software\IDM Backup Manager"
Global Const $current_version = "0.9.3"
Global Const $Win_Title = "IDM Backup Manager" & $current_version & "(Beta)"

;==============================================================================================
$AppDataIDMFolder = RegRead($regkey_x86_IDM, "AppDataIDMFolder")
$TempPath = RegRead($regkey_x86_IDM, "TempPath")
;==============================================================================================
#region


If ProcessExists("idman1.exe") Then ;**** Check the process "idman.exe" exists or not ****
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(4, "IDM Need To Close", "Close IDM Before You Can Continue.Do You Want To Close IDM?")
	Select
		Case $iMsgBoxAnswer = 6 ;Yes
			ProcessClose("idman.exe")
		Case $iMsgBoxAnswer = 7 ;No
			Exit
	EndSelect
EndIf

$Intial_Backup_Path = RegRead($regkey_x86_IDMBM, "Backup Folder")
If @error <> 0 Then
	$Intial_Backup_Path = ""
EndIf

$Intial_Restore_Path = RegRead($regkey_x86_IDMBM, "Restore Folder")
If @error <> 0 Then
	$Intial_Restore_Path = ""
EndIf

$version = RegRead($regkey_x86_IDMBM, "Software Version")
If $version <> $current_version Then RegWrite($regkey_x86_IDMBM, "Software Version", "REG_SZ", $current_version)

#endregion

;==============================================================================================
#region
If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
#endregion

;**** Create main GUI of the IDM Backup Manager ****
;==============================================================================================
#region ### START Koda GUI section ### Form=C:\Users\Tejas\Desktop\project\IDM\IDM BUILD_3\Form4.kxf

$Form2 = GUICreate($Win_Title, 439, 276, 401, 252)

$Tab1 = GUICtrlCreateTab(10, 10, 420, 240)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

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
GUICtrlSetData(-1, "2-Fastest Compression|3-Fast Compression|4-Normal Compression|5-Maximum Compression|6-Ultra Compression", "4-Normal Compression")
GUICtrlSetTip(-1, "Here You Can Set The Compression Level of The Backup Files" & @CRLF & "", "Compression Level", 1, 1)

$Unfinished_DD = GUICtrlCreateCheckbox("Downloaded Data", 200, 149, 107, 17)
$Unfinished_GD = GUICtrlCreateCheckbox("Grabber Data", 310, 149, 97, 17)
$Unfinished_SD = GUICtrlCreateCheckbox("Scheduler Data", 200, 170, 107, 17)
$Full_Backup = GUICtrlCreateCheckbox("Full Backup", 200, 128, 107, 17)
$Unfinished_HL = GUICtrlCreateCheckbox("History and Logs", 310, 170, 97, 17)
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
$Group3 = GUICtrlCreateGroup("Tools", 24, 44, 390, 160)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$join_expand = GUICtrlCreateButton("Join Unfinished Filed  >>>", 232, 66, 155, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;==============================================================================================
$TabSheet4 = GUICtrlCreateTabItem("Help")
$Help_Tab = GUICtrlCreateGroup("Help and Update", 24, 44, 390, 160)
$Website = GUICtrlCreateButton("Website", 37, 126, 100, 30)
$Help = GUICtrlCreateButton("Help", 37, 66, 100, 30)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Licence = GUICtrlCreateButton("Licence", 37, 96, 100, 30)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$View_Log = GUICtrlCreateButton("View Log", 146, 66, 100, 30)
$Bug_Report = GUICtrlCreateButton("Bug Report", 146, 96, 100, 30)
$Update = GUICtrlCreateButton("Update", 146, 126, 100, 30)
$Pic1 = GUICtrlCreatePic("C:\Users\Tejas\Desktop\project\IDM\IDM BUILD_3\Resorces\contactme.jpg", 260, 55, 150, 145)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")

GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

;==============================================================================================
GUICtrlSetState($Backup_Button, $GUI_DISABLE)
GUICtrlSetState($Restore_Button, $GUI_DISABLE)
GUICtrlSetState($Input_backup_Password, $GUI_DISABLE)
GUICtrlSetState($Input_restore_Password, $GUI_DISABLE)
GUICtrlSetState($Setting_Compression_Level, $GUI_DISABLE)
GUICtrlSetState($Label_Convert_Registry, $GUI_DISABLE)

If $AppDataIDMFolder = "" And $TempPath = "" Then
	MsgBox(16, "Error", "IDM is not installed on this system or Unable to open requested registry key.")
	GUICtrlSetState($Browse_Button_Backup, $GUI_DISABLE)
Else
	If $AppDataIDMFolder = "" And $TempPath <> "" Then $AppDataIDMFolder = $TempPath
	If $AppDataIDMFolder <> "" And $TempPath = "" Then $TempPath = $AppDataIDMFolder
EndIf



;==============================================================================================
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg

		Case $GUI_EVENT_CLOSE
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Form2, "int", 1000, "long", 0x00050010);implode
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
			$Backup_path = FileSelectFolder("Choose a folder to save backup...", "", 7, $Intial_Backup_Path, $Form2)
			If StringRight($Backup_path, 1) <> "\" Then $Backup_path &= "\"
			$Backup_7z_path = $Backup_path & "IDMbackup.7z"


			If _FileIsPathValid($Backup_path) = True Then
				If FileExists($Backup_7z_path) Then
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox(36, "Confirm Save", "Previous Backup File :-" & @CRLF & $Backup_7z_path & @CRLF & "Already Exists Do You Want To Replace It?", 0, $Form2)
					Select
						Case $iMsgBoxAnswer = 6 ;Yes
							If FileDelete($Backup_7z_path) = 0 Then
								GUICtrlSetState($Backup_Button, $GUI_DISABLE)
								GUICtrlSetData($Backup_Input, "")
								MsgBox(48, "Warning", "Files Could Not Deleted." & @CRLF & @CRLF & $Backup_7z_path, 0, $Form2)
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
					MsgBox(48, "Error", '"' & $Backup_path & '"' & " is not Valid Folder", 0, $Form2)
				Else
					If _FileIsPathValid(GUICtrlRead($Backup_Input)) = True Then
						GUICtrlSetState($Backup_Button, $GUI_ENABLE)
					Else
						GUICtrlSetState($Backup_Button, $GUI_DISABLE)
					EndIf
				EndIf
			EndIf

		Case $Backup_Button
			If GUICtrlRead($Checkbox_backup_Password) = $GUI_CHECKED Then
				$passwd = GUICtrlRead($Input_backup_Password)
				If $passwd = "" Then
					MsgBox(48, "Alert", "Password is Empty", 0, $Form2)
					ContinueLoop
				EndIf
				$password_exists = True
			Else
				$password_exists = False
				$passwd = ""
			EndIf
			_control_update_busy()

			$ini_File = @TempDir & "\" & "idm_guest_Setting.ini"
			$reg_File = @TempDir & "\" & "IDMregistry.reg"

			If GUICtrlRead($Full_Backup) = $GUI_CHECKED Then
				IniWrite($ini_File, "Default", "AppDataIDMFolder", RegRead($regkey_x86_IDM, "AppDataIDMFolder"))
				IniWrite($ini_File, "Default", "TempPath", RegRead($regkey_x86_IDM, "TempPath"))
				IniWrite($ini_File, "Default", "idmvers", RegRead($regkey_x86_IDM, "idmvers"))
				IniWrite($ini_File, "Default", "Password", $password_exists)
				IniWrite($ini_File, "Default", "Mode", "Full")
				IniWrite($ini_File, "Default", "Username", @UserName)

				_regbackup($reg_File, "HKEY_CURRENT_USER\Software\DownloadManager\")
				$foo_2 = _7Zip_Add_($Backup_7z_path, $TempPath, GUICtrlRead($Setting_Compression_Level), $passwd) ;add idm app
				$foo_3 = _7Zip_Update($Backup_7z_path, $reg_File, GUICtrlRead($Setting_Compression_Level), $passwd) ;add Reg
				$foo_16 = _7Zip_Update($Backup_7z_path, $ini_File, GUICtrlRead($Setting_Compression_Level), "") ; update  add ini
			Else
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

				If $k = 1 Then
					MsgBox(48, "Error", "Could not get registry key", 0, $Form2)
				Else

					$foo_15 = _7Zip_Add($Backup_7z_path, $reg_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app

					IniWrite($ini_File, "Default", "AppDataIDMFolder", RegRead($regkey_x86_IDM, "AppDataIDMFolder"))
					IniWrite($ini_File, "Default", "TempPath", RegRead($regkey_x86_IDM, "TempPath"))
					IniWrite($ini_File, "Default", "idmvers", RegRead($regkey_x86_IDM, "idmvers"))
					IniWrite($ini_File, "Default", "Keys", $k)
					IniWrite($ini_File, "Default", "Password", $password_exists)
					IniWrite($ini_File, "Default", "Mode", "Custom")
					IniWrite($ini_File, "Default", "Username", @UserName)

					If FileExists($DwnlData_Folder) And GUICtrlRead($Unfinished_DD) = $GUI_CHECKED Then
						$foo_2 = _7Zip_Update($Backup_7z_path, $DwnlData_Folder, GUICtrlRead($Setting_Compression_Level), $passwd) ;add DwnlData_Folder
						IniWrite($ini_File, "Default", "DwnlData_Folder", True)
					EndIf

					If FileExists($Grabber_Folder) And GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Then
						$foo_3 = _7Zip_Update($Backup_7z_path, $Grabber_Folder, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						IniWrite($ini_File, "Default", "Grabber_Folder", True)
					EndIf

					If FileExists($GrabberData_Folder) And GUICtrlRead($Unfinished_GD) = $GUI_CHECKED Then
						$foo_3 = _7Zip_Update($Backup_7z_path, $GrabberData_Folder, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						IniWrite($ini_File, "Default", "GrabberData_Folder", True)
					EndIf

					If FileExists($Scheduler_Folder) And GUICtrlRead($Unfinished_SD) = $GUI_CHECKED Then
						$foo_5 = _7Zip_Update($Backup_7z_path, $Scheduler_Folder, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						IniWrite($ini_File, "Default", "Scheduler_Folder", True)
					EndIf

					If GUICtrlRead($Unfinished_HL) = $GUI_CHECKED Then
						$foo_6 = _7Zip_Update($Backup_7z_path, $UrlHistory_txt_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						$foo_7 = _7Zip_Update($Backup_7z_path, $UrlHistory2_txt_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						$foo_8 = _7Zip_Update($Backup_7z_path, $GlobalErrors_log_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						$foo_9 = _7Zip_Update($Backup_7z_path, $urlexclist_dat_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						$foo_10 = _7Zip_Update($Backup_7z_path, $defextmap_dat_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						$foo_11 = _7Zip_Update($Backup_7z_path, $foldresHistory_txt_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						$foo_12 = _7Zip_Update($Backup_7z_path, $sts_list_dat_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						$foo_13 = _7Zip_Update($Backup_7z_path, $cnlurllist_dat_File, GUICtrlRead($Setting_Compression_Level), $passwd) ; update  add idm app
						IniWrite($ini_File, "Default", "History_Files", True)
					EndIf

					$foo_16 = _7Zip_Update($Backup_7z_path, $ini_File, GUICtrlRead($Setting_Compression_Level), "") ; update  add idm app
				EndIf
			EndIf


			;==============================================================================================
			GUICtrlSetState($Browse_Button_Backup, $GUI_ENABLE)
			GUICtrlSetState($Backup_Button, $GUI_ENABLE)
			GUICtrlSetData($INFO1, "Done")
			_control_update_default()
			GUICtrlSetState($Backup_Button, $GUI_DISABLE)
			RegWrite($regkey_x86_IDMBM, "Backup Folder", "REG_SZ", $Backup_path)

			;==============================================================================================
		Case $Browse_Button_Restore
			$Restore_path = FileSelectFolder("Choose a folder to restore backup...", "", 2, $Intial_Restore_Path, $Form2)
			If StringRight($Restore_path, 1) <> "\" Then $Restore_path &= "\"
			$Restore_7z_path = $Restore_path & "IDMbackup.7z"

			If _FileIsPathValid($Restore_path) = True Then
				If Not FileExists($Restore_7z_path) Then
					MsgBox(48, "Error", "Backup File Does Not Exists in This Folder", 0, $Form2)
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
					MsgBox(48, "Error", '"' & $Restore_path & '"' & " is not Valid Folder", 0, $Form2)
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
			FileDelete(@TempDir & "\idm_guest_Setting.ini")

			$Restore_7z_path = GUICtrlRead($Restore_Input) & "IDMbackup.7z"
			$ini_File = @TempDir & "\" & "idm_guest_Setting.ini"
			$reg_File = @TempDir & "\IDMregistry.reg"

			$foo_16 = _7Zip_Extract_File($Restore_7z_path, @TempDir, "idm_guest_Setting.ini", "");Check For Password
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
					If GUICtrlRead($Checkbox_restore_Password) = $GUI_CHECKED Then
						If GUICtrlRead($Input_restore_Password) <> "" Then
							$passwd2 = GUICtrlRead($Input_restore_Password)
							$foo_17 = _7Zip_Test($Restore_7z_path, $passwd2)
							If $foo_17 <> 0 Then
								MsgBox(0, "Wrong Password", "CRC Failed May Be Wrong Password !")
								ContinueLoop
							EndIf
						Else
							MsgBox(0, "Empty Password", "Password Protected Backup Please Enter The Password")
							ContinueLoop
						EndIf
					Else
						MsgBox(0, "Check Checkbox", "Password Protected Backup Please Check Checkbox and Enter The Password")
						ContinueLoop
					EndIf
				Else
					$passwd2 = ""
				EndIf
			Else
				MsgBox(0, "INI File Not Found", "INI File Not Found Inside Backup File or Backup File May Be Damaged.")
			EndIf

			$foo_16 = _7Zip_Extract_File($Restore_7z_path, @TempDir, "IDMregistry.reg", $passwd2)
			If GUICtrlRead($Checkbox_restore_Convert_Registry) = $GUI_CHECKED Then

				_ReplaceStringInFile($reg_File, StringReplace(($Guest_AppDataIDMFolder & "DwnlData" & "\" & $Guest_Username), "\", "\\"),StringReplace($TempPath & "DwnlData" & "\" & @UserName, "\", "\\" ))
				ConsoleWrite("Searching-->" & StringReplace(($Guest_AppDataIDMFolder & "DwnlData" & "\" & $Guest_Username), "\", "\\") & @CRLF)
				ConsoleWrite("Replacing-->" & StringReplace($TempPath & "DwnlData" & "\" & @UserName, "\", "\\" )& @CRLF & @CRLF)

				_ReplaceStringInFile($reg_File,StringReplace(($Guest_AppDataIDMFolder & "GrabberData" & "\" & $Guest_Username), "\", "\\") ,StringReplace($TempPath & "GrabberData" & "\" & @UserName, "\", "\\") )
				ConsoleWrite("Searching-->" & StringReplace(($Guest_AppDataIDMFolder & "GrabberData" & "\" & $Guest_Username), "\", "\\") & @CRLF)
				ConsoleWrite("Replacing-->" & StringReplace($TempPath & "GrabberData" & "\" & @UserName, "\", "\\") & @CRLF & @CRLF)

				_ReplaceStringInFile($reg_File,StringReplace(($Guest_AppDataIDMFolder), "\", "\\") ,StringReplace($TempPath, "\", "\\"))
				ConsoleWrite("Searching-->" & StringReplace(($Guest_AppDataIDMFolder), "\", "\\") & @CRLF)
				ConsoleWrite("Replacing-->" & StringReplace($TempPath, "\", "\\") & @CRLF & @CRLF)
			EndIf


			If $Guest_Mode = "Full" Then
				$foo_18 = _7Zip_Extract($Restore_7z_path, $TempPath, $passwd2)
				$foo_19 = _reg_import($reg_File)
			Else
				If $Guest_DwnlData_Folder = True Then
				$foo_20 = _7Zip_Extract_File($Restore_7z_path, $TempPath & "DwnlData" & "\" & @UserName & "\" , "\" & "DwnlData" & "\" & $Guest_Username & "\", $passwd2)
				EndIf

				If $Guest_Grabber_Folder = True Or $Guest_GrabberData_Folder = True Then
				$foo_21 = _7Zip_Extract_File($Restore_7z_path, $TempPath & "GrabberData" & "\" & @UserName & "\" , "\" & "GrabberData" & "\" & $Guest_Username & "\", $passwd2)
				$foo_21 = _7Zip_Extract_File($Restore_7z_path, $TempPath & "Grabber" & "\"  , "\" & "Grabber" & "\" , $passwd2)
				EndIf

				If $Guest_Scheduler_Folder = True Then
				$foo_21 = _7Zip_Extract_File($Restore_7z_path, $TempPath & "Scheduler" & "\"  , "\" & "Scheduler" & "\" , $passwd2)
				EndIf

				If $Guest_History_Files = True Then
				$foo_21 = _7Zip_Extract_File($Restore_7z_path, $TempPath & "UrlHistory.txt"   , "\" & "UrlHistory.txt" , $passwd2)
				$foo_21 = _7Zip_Extract_File($Restore_7z_path, $TempPath & "UrlHistory2.txt"   , "\" & "UrlHistory2.txt" , $passwd2)
				$foo_21 = _7Zip_Extract_File($Restore_7z_path, $TempPath & "GlobalErrors.log"   , "\" & "GlobalErrors.log" , $passwd2)
				$foo_21 = _7Zip_Extract_File($Restore_7z_path, $TempPath & "urlexclist.dat"   , "\" & "urlexclist.dat" , $passwd2)
				$foo_21 = _7Zip_Extract_File($Restore_7z_path, $TempPath & "defextmap.dat"   , "\" & "defextmap.dat" , $passwd2)
				$foo_21 = _7Zip_Extract_File($Restore_7z_path, $TempPath & "foldresHistory.txt"   , "\" & "foldresHistory.txt" , $passwd2)
				$foo_21 = _7Zip_Extract_File($Restore_7z_path, $TempPath & "sts_list.dat"   , "\" & "sts_list.dat" , $passwd2)
				$foo_21 = _7Zip_Extract_File($Restore_7z_path, $TempPath & "cnlurllist.dat"   , "\" & "cnlurllist.dat" , $passwd2)
				EndIf
			EndIf

			ConsoleWrite("Done")

			_control_update_default()
			WinSetTitle($Form2, "", $Win_Title)

;~ 			If $foo_1 = 1 Then
;~ 				MsgBox(48, "Warning (Non fatal error(s))", "For example, one or more files were locked by some other application, so they were not compressed.", 0, $Form2)
;~ 			ElseIf $foo_1 = 2 Then
;~ 				MsgBox(48, "Fatal Error", "Fatal error", 0, $Form2)
;~ 			ElseIf $foo_1 = 7 Then
;~ 				MsgBox(48, "Error", "Command line error", 0, $Form2)
;~ 			ElseIf $foo_1 = 8 Then
;~ 				MsgBox(48, "Error", "Not enough memory for operation.", 0, $Form2)
;~ 			ElseIf $foo_1 = 255 Then
;~ 				MsgBox(48, "Error", "Operation Canclled.", 0, $Form2)
;~ 			ElseIf $foo_1 = 0 Then
;~ 				MsgBox(0, "Done", "Restore Success.", 0, $Form2)
;~ 			EndIf

		Case $join_expand

		Case $Update
			If _IsInternetConnected() = "True" Then
				Local $Update_VER = InetRead("http://www.geocities.ws/gajjartejas/IDM_Backup_Manager/v0.9.1/update.txt", 1)
				Switch BinaryToString($Update_VER)
					Case ""
						MsgBox(48, "Error", "Time Out!", 0, $Form2)
					Case "0.9.1"
						MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $Form2)
					Case "0.9.2"
						MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $Form2)
					Case "0.9.3"
						MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $Form2)
					Case Else
						MsgBox(64, "Availabe", "You Should Download Following Version" & BinaryToString($Update_VER), 0, $Form2)
				EndSwitch
			Else
				MsgBox(48, "Error", "Internet connection could not found.", 0, $Form2)
			EndIf

		Case $Help
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/Start_page.htm"')

		Case $Licence
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/General_Information.htm"')

		Case $Website
			ShellExecute("http://gajjartejas26.blogspot.com")

		Case $Backup_Input
		Case $Restore_Input
	EndSwitch
WEnd


Func _7Zip_Test($sZipFile, $sPassword)
	If FileExists($sZipFile) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If $sPassword <> "" Then
		$sPassword = "-p" & '"' & $sPassword & '" '
	EndIf
	$process = RunWait(@ScriptDir & '\7z.exe' & ' t "' & $sZipFile & '" ' & $sPassword, "", @SW_HIDE)
	Return $process
EndFunc   ;==>_7Zip_Test


Func _7Zip_Extract($sZipFile, $sDestinationFolder, $sPassword = "")

	If FileExists($sZipFile) = 0 Then
		Return SetError(1, 0, 0)
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
	If FileExists($sDestinationFolder & "\" & "7z.exe") = 0 Then
		FileInstall("7z.exe", $sDestinationFolder & "\" & "7z.exe", 0)
	EndIf
	Return RunWait(@ScriptDir & '\7z.exe' & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"', "", @SW_HIDE)
EndFunc   ;==>_7Zip_Extract

Func _7Zip_Extract_File($sZipFile, $sDestinationFolder, $sFile_To_Extracr, $sPassword)

	If FileExists($sZipFile) = 0 Then
		Return SetError(1, 0, 0)
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
	Return RunWait(@ScriptDir & '\7z.exe' & ' e "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"' & " " & $sFile_To_Extracr & " -r", "") ;, @SW_HIDE

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
		Return SetError(1, 0, 0)
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
		Return SetError(1, 0, 0)
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

Func _7Zip_Update($name_of_archive, $name_file_to_update, $sCompression, $sPassword)
	If FileExists($name_of_archive) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If FileExists($name_file_to_update) = 0 Then
		Return SetError(1, 0, 0)
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
	Return RunWait(@ScriptDir & "\7z.exe" & " " & "u" & " " & '"' & $name_of_archive & '"' & $sCompression & " " & $sPassword & " " & '"' & $name_file_to_update & '"', "") ;, @SW_HIDE
EndFunc   ;==>_7Zip_Update


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

;_regbackup(c:\path\name1.reg",     hku\folder1\folder2)
;_regbackup(@TempDir & "\" & "Scheduler.reg", $regkey_x86_IDM & "\Scheduler")
Func _reg_import($s7z_File_Save_Name)
	ShellExecuteWait('regedit.exe', "/s /c "  &  $s7z_File_Save_Name )
EndFunc   ;==>_reg_import



Func _control_update_busy()
	GUICtrlSetState($Browse_Button_Backup, $GUI_DISABLE)
	GUICtrlSetState($Browse_Button_Backup, $GUI_DISABLE)
	GUICtrlSetState($Backup_Button, $GUI_DISABLE)
	GUICtrlSetState($Browse_Button_Restore, $GUI_DISABLE)
	GUICtrlSetState($Restore_Button, $GUI_DISABLE)
	GUISetCursor(15, 1, $Form2)
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
	GUISetCursor(-1, 1, $Form2)
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