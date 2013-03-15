#NoTrayIcon
#RequireAdmin

If @OSArch = "X64" Then
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(16, "Exiting", "OS Not Support.", 5)
	Select
		Case $iMsgBoxAnswer = -1
			Exit
	EndSelect
EndIf

Global $regkey_x86_IDM = "HKEY_CURRENT_USER\Software\DownloadManager"
Global $regkey_x86_IDMBM = "HKEY_CURRENT_USER\Software\IDM Backup Manager"
Global $current_version = "0.9.3"
Global $Win_Title = "IDM Backup Manager" & $current_version & "(Beta)"

#endregion
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\IDM BUILD_2\icon.ico
#AutoIt3Wrapper_Outfile=IDM Backup Manager0.9.4.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=IDM Backup Manager is a free software that can backup files from InterDownload Manager
#AutoIt3Wrapper_Res_Description=IDM Backup Manager is a free software that can backup files from InterDownload Manager
#AutoIt3Wrapper_Res_Fileversion=0.9.3.0
#AutoIt3Wrapper_Res_LegalCopyright=©Gajjar Tejas 2012
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
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
#include <File.au3>
#include <Crypt.au3>
#include "GUIFade.au3"
#include "_FileIsPathValid.au3"

#region ### START Koda GUI section ### Form=C:\Users\Tejas\Desktop\idm\Form2.kxf
$Form2 = GUICreate($Win_Title, 327, 187, 409, 352) ;BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME)
_FadeGUIIn($Form2, 200)
GUISetBkColor(0xFFFFFF)

$Tab1 = GUICtrlCreateTab(0, 80, 324, 103)

GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$TabSheet1 = GUICtrlCreateTabItem("Backup Setting")
GUICtrlSetState(-1, $GUI_SHOW)
$Backup_Input = GUICtrlCreateInput("", 6, 119, 266, 22, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$Browse_Button_Backup = GUICtrlCreateButton("...", 276, 117, 40, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Browse For Backup Path")
GUICtrlSetCursor(-1, 0)
$Backup_Button = GUICtrlCreateButton("Backup", 241, 147, 75, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Backup Now")
GUICtrlSetCursor(-1, 0)
$Label1 = GUICtrlCreateLabel("", 4, 155, 161, 24)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)

$TabSheet2 = GUICtrlCreateTabItem("Restore Setting")
$Restore_Input = GUICtrlCreateInput("", 6, 119, 266, 22, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$Browse_Button_Restore = GUICtrlCreateButton("...", 276, 117, 40, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Browse For Restore Path")
GUICtrlSetCursor(-1, 0)
$Restore_Button = GUICtrlCreateButton("Restore", 241, 147, 75, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Restore Now")
GUICtrlSetCursor(-1, 0)
$Label2 = GUICtrlCreateLabel("", 4, 155, 161, 24)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)

$TabSheet3 = GUICtrlCreateTabItem("Setting")
GUICtrlSetState(-1, $GUI_SHOW)
$Encrypt_Backup_Label = GUICtrlCreateLabel("Encrypt Backup", 10, 105, 80, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)
$Compression_Level_Label = GUICtrlCreateLabel("Compression Level", 10, 130, 93, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)
$Convert_Registry_Label = GUICtrlCreateLabel("Convert Registry", 10, 155, 82, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)
$Setting_Encrypt = GUICtrlCreateCombo("Yes", 115, 105, 120, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "No", "No")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$Setting_Compression_Level = GUICtrlCreateCombo("1-Store/None", 115, 130, 120, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "2-Fastest|3-Fast|4-Normal|5-Maximum|6-Ultra", "4-Normal")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$Setting_Convert_Registry = GUICtrlCreateCombo("Yes", 115, 155, 120, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "No", "Yes")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$Save_Setting_Button = GUICtrlCreateButton("Save Setting", 240, 120, 75, 45)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlCreateTabItem("")

$TabSheet4 = GUICtrlCreateTabItem("About")
$Help = GUICtrlCreateButton("Help", 125, 107, 85, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Read_ME = GUICtrlCreateButton("Read Me", 125, 131, 86, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Licence = GUICtrlCreateButton("Licence", 125, 155, 86, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Thanks = GUICtrlCreateButton("Thanks", 230, 107, 86, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Aurther = GUICtrlCreateButton("Aurther", 230, 131, 86, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Website = GUICtrlCreateButton("Website", 230, 155, 86, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Update = GUICtrlCreateButton(" ", 20, 107, 66, 66, $BS_ICON)
GUICtrlSetImage(-1, "Resorces\66x66.ico", -1)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Check For Latest Version")
GUICtrlSetCursor(-1, 0)

GUICtrlCreateTabItem("")
$Pic1 = GUICtrlCreatePic("Resorces\Banner.jpg", 0, 0, 326, 76)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

$p = 0
$p2 = 0
$Increase = 0

If Not FileExists("setting.ini") Then
	If Not _FileCreate("setting.ini") Then
		MsgBox(4096, "setting.ini", " Error Creating and Resetting log.", 0, $Form2)
	EndIf
	$ini_Data = "Setting_Encrypt=No" & @LF & "Setting_Compression_Level=4-Normal" & @LF & "Setting_Convert_Registry=Yes"
	IniWriteSection("setting.ini", "Setting", $ini_Data)
Else
	GUICtrlSetData($Setting_Encrypt, IniRead("setting.ini", "Setting", "Setting_Encrypt", "No"))
	GUICtrlSetData($Setting_Compression_Level, IniRead("setting.ini", "Setting", "Setting_Compression_Level", "4-Normal"))
	GUICtrlSetData($Setting_Convert_Registry, IniRead("setting.ini", "Setting", "Setting_Convert_Registry", "Yes"))
EndIf

If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
If FileExists(@TempDir & "\IDMbackup.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
If FileExists(@TempDir & "\IDMregistry_Encrypted1.reg") Then FileDelete(@TempDir & "\IDMregistry_Encrypted1.reg")

_GUICtrlButton_Enable($Restore_Button, False)
_GUICtrlButton_Enable($Backup_Button, False)
GUICtrlSetData($Label1, "Ready")
GUICtrlSetData($Label2, "Ready")

$version = RegRead($regkey_x86_IDMBM, "Software Version")
If $version <> $current_version Then RegWrite($regkey_x86_IDMBM, "Software Version", "REG_SZ", $current_version)

$Intial_Backup_Path = RegRead($regkey_x86_IDMBM, "Backup Folder")
If @error <> 0 Then
	$Intial_Backup_Path = ""
EndIf

$Intial_Restore_Path = RegRead($regkey_x86_IDMBM, "Restore Folder")
If @error <> 0 Then
	$Intial_Restore_Path = ""
EndIf

$key = RegRead($regkey_x86_IDM, "AppDataIDMFolder")
If @error <> 0 Then
	MsgBox(16, "Error", "IDM is not installed on this system or Unable to open requested registry key.", 0, $Form2)
EndIf

If ProcessExists("idman.exe") Then
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(4, "IDM Need To Close", "Close IDM Before You Can Continue.Do You Want To Close IDM?", 0, $Form2)
	Select
		Case $iMsgBoxAnswer = 6 ;Yes
			ProcessWaitClose("idman.exe")
		Case $iMsgBoxAnswer = 7 ;No
			_FadeGUIOut($Form2)
			Exit
	EndSelect
EndIf

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
			If FileExists(@TempDir & "\IDMbackup.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
			_FadeGUIOut($Form2)
			Exit

			;==============================================================================================
		Case $Browse_Button_Backup

			$Backup_path = FileSelectFolder("Choose a folder to save backup...", "", 7, $Intial_Backup_Path, $Form2)
			If @error = 1 Then _GUICtrlButton_Enable($Backup_Button, False)
			GUICtrlSetData($Backup_Input, $Backup_path)

			If GUICtrlRead($Setting_Encrypt) = "Yes" Then
				If _FileIsPathValid($Backup_path) = "True" Then
					_GUICtrlButton_Enable($Backup_Button, True)
					$mos = 1
					If FileExists($Backup_path & "\IDMregistry_Encrypted.reg") Or FileExists($Backup_path & "\IDMbackup_Encrypted.7z") Then
						If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
						$iMsgBoxAnswer = MsgBox(36, "Confirm Save", "Previous Backup Files(Encrypted) Already Exists Do You Want To Replace It?", 0, $Form2)
						Select
							Case $iMsgBoxAnswer = 6 ;Yes
								$file_delete_1 = FileDelete($Backup_path & "\IDMregistry_Encrypted.reg")
								$file_delete_2 = FileDelete($Backup_path & "\IDMbackup_Encrypted.7z")
								If $file_delete_1 = 0 Then MsgBox(48, "Warning", "File Could Not Deleted." & @CRLF & @CRLF & $Backup_path & "\IDMregistry_Encrypted.reg", 0, $Form2)
								If $file_delete_2 = 0 Then MsgBox(48, "Warning", "Files Could Not Deleted." & @CRLF & @CRLF & $Backup_path & "\IDMbackup_Encrypted.7z", 0, $Form2)
								$mos = 11
							Case $iMsgBoxAnswer = 7 ;No
								GUICtrlSetData($Backup_Input, "")
								_GUICtrlButton_Enable($Backup_Button, False)
								$mos = 10
						EndSelect
					EndIf
				Else
					;MsgBox(48, "Error", "Please Choose Valid Path First",0,$Form2)
					GUICtrlSetData($Backup_Input, "")
				EndIf

			ElseIf GUICtrlRead($Setting_Encrypt) = "No" Then
				If _FileIsPathValid($Backup_path) = "True" Then
					_GUICtrlButton_Enable($Backup_Button, True)
					$mos = 1
					If FileExists($Backup_path & "\IDMregistry.reg") Or FileExists($Backup_path & "\IDMbackup.7z") Then
						If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
						$iMsgBoxAnswer = MsgBox(36, "Confirm Save", "Previous Backup Files Already Exists Do You Want To Replace It?", 0, $Form2)
						Select
							Case $iMsgBoxAnswer = 6 ;Yes
								$file_delete_1 = FileDelete($Backup_path & "\IDMregistry.reg")
								$file_delete_2 = FileDelete($Backup_path & "\IDMbackup.7z")
								If $file_delete_1 = 0 Then MsgBox(48, "Warning", "Following File Could Not Deleted." & @CRLF & @CRLF & $Backup_path & "\IDMregistry.reg", 0, $Form2)
								If $file_delete_2 = 0 Then MsgBox(48, "Warning", "Following Files Could Not Deleted." & @CRLF & @CRLF & $Backup_path & "\IDMbackup.7z", 0, $Form2)
								$mos = 11
							Case $iMsgBoxAnswer = 7 ;No
								GUICtrlSetData($Backup_Input, "")
								_GUICtrlButton_Enable($Backup_Button, False)
								$mos = 10
						EndSelect
					EndIf

				Else
					MsgBox(48, "Error", "Please Choose Valid Path First", 0, $Form2)
					GUICtrlSetData($Backup_Input, "")
				EndIf
			EndIf


			;==============================================================================================
		Case $Backup_Button

			If GUICtrlRead($Backup_Input) = "" Then $mos = 10
			If _FileIsPathValid(GUICtrlRead($Backup_Input), 1) = False Then $mos = 10

			Switch $mos
				Case 10
					MsgBox(48, "Error", "Please Choose Valid Path First", 0, $Form2)
				Case 11 And 1

					;==============================================================================================
					If GUICtrlRead($Setting_Encrypt) = "Yes" Then
						$passwd = InputBox("Security Check", "Enter your password.", "", "")
						If $passwd = "" Then
							MsgBox(0, "Password", "Password Can not Blanck", 0, $Form2)
							ContinueLoop
						EndIf
						$passwd_Validate = InputBox("Validate Password", "ReEnter your password.", "", "*")
						If $passwd = "" Then
							MsgBox(0, "Password", "Password Can not Blanck", 0, $Form2)
							ContinueLoop
						EndIf
						If $passwd = $passwd_Validate Then
							If $passwd <> "" Then
								$p = 1
							EndIf
						Else
							MsgBox(0, "Password", "Password Not Match", 0, $Form2)
							ContinueLoop
						EndIf
					EndIf
					;==============================================================================================
					Switch GUICtrlRead($Setting_Compression_Level)
						Case "1-Store/None"
							$compression_ratio = " -mx0"
						Case "2-Fastest"
							$compression_ratio = " -mx1"
						Case "3-Fast"
							$compression_ratio = " -mx3"
						Case "4-Normal"
							$compression_ratio = " -mx5"
						Case "5-Maximum"
							$compression_ratio = " -mx7"
						Case "6-Ultra"
							$compression_ratio = " -mx9"
						Case Else
							$compression_ratio = ""
					EndSwitch


					;==============================================================================================
					AdlibRegister("Update", 333)
					GUICtrlSetData($Label1, "Working...")
					_GUICtrlButton_Enable($Browse_Button_Backup, False)
					_GUICtrlButton_Enable($Backup_Button, False)
					_control_update_busy()
					;==============================================================================================


					;==============================================================================================
					If FileExists($Backup_path & "\" & "IDMbackup.7z") Then FileDelete($Backup_path & "\" & "IDMbackup.7z")
					If FileExists($Backup_path & "\IDMregistry.reg") Then FileDelete($Backup_path & "\IDMregistry.reg")


					;==============================================================================================
					If $p = 1 Then
						_regbackup($Backup_path, "IDMregistry_Encrypted.reg", $regkey_x86_IDM)
						$Enc_Reg = FileRead($Backup_path & "\IDMregistry_Encrypted.reg")
						_Crypt_Startup()
						$hKey = _Crypt_DeriveKey($passwd, $CALG_RC4)
						MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @LF & '$hKey' & @LF & @LF & 'Return:' & @LF & $hKey) ;### Debug MSGBOX
						$bEncrypted = _Crypt_EncryptData($Enc_Reg, $hKey, $CALG_USERKEY)
						FileOpen($Backup_path & "\IDMregistry_Encrypted.reg", 10)
						FileWrite($Backup_path & "\IDMregistry_Encrypted.reg", $bEncrypted)
						FileClose($Backup_path & "\IDMregistry_Encrypted.reg")
						_Crypt_DestroyKey($hKey)
						_Crypt_Shutdown()
					Else
						_regbackup($Backup_path, "IDMregistry.reg", $regkey_x86_IDM)
					EndIf
					;==============================================================================================


					;==============================================================================================
					$c_Saved_Path = _7ZzPath_Convert($Backup_path)
					$c_key = _7ZzPath_Convert($key)
					If $p = 1 Then
						$foo_2 = RunWait("7z.exe" & " " & "a" & " " & $c_Saved_Path & "\" & "IDMbackup_Encrypted.7z" & $compression_ratio & " -p" & '" ' & $passwd & '" ' & " " & $c_key, "") ;, @SW_HIDE
					Else
						$foo_2 = RunWait("7z.exe" & " " & "a" & " " & $c_Saved_Path & "\" & "IDMbackup.7z" & " " & $compression_ratio & " " & $c_key, "") ;, @SW_HIDE
					EndIf
					;==============================================================================================



					;==============================================================================================
					_GUICtrlButton_Enable($Browse_Button_Backup, True)
					_GUICtrlButton_Enable($Backup_Button, True)
					_control_update_default()
					AdlibUnRegister("Update")
					WinSetTitle($Form2, "", $Win_Title)
					;==============================================================================================

					If $foo_2 = 1 Then
						MsgBox(48, "Warning (Non fatal error(s))", "For example, one or more files were locked by some other application, so they were not compressed.", 0, $Form2)
						GUICtrlSetData($Label1, "Done But Error")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMbackup.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite($regkey_x86_IDMBM, "Backup Folder", "REG_SZ", $Backup_path)
					ElseIf $foo_2 = 2 Then
						MsgBox(48, "Fatal Error", "Fatal error", 0, $Form2)
						GUICtrlSetData($Label1, "Done But Error")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMbackup.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite($regkey_x86_IDMBM, "Backup Folder", "REG_SZ", $Backup_path)
					ElseIf $foo_2 = 7 Then
						MsgBox(48, "Error", "Command line error", 0, $Form2)
						GUICtrlSetData($Label1, "Done But Error")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMbackup.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite($regkey_x86_IDMBM, "Backup Folder", "REG_SZ", $Backup_path)
					ElseIf $foo_2 = 8 Then
						MsgBox(48, "Error", "Not enough memory for operation.", $Form2)
						GUICtrlSetData($Label1, "Done But Error")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMbackup.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite($regkey_x86_IDMBM, "Backup Folder", "REG_SZ", $Backup_path)
					ElseIf $foo_2 = 255 Then
						MsgBox(48, "Error", "Operation Canclled.", $Form2)
						GUICtrlSetData($Label1, "Done But Error")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMbackup.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite($regkey_x86_IDMBM, "Backup Folder", "REG_SZ", $Backup_path)
					ElseIf $foo_2 = 0 Then
						MsgBox(0, "Done", "Backup Success.", $Form2)
						GUICtrlSetData($Label1, "Backup Success.")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMbackup.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite($regkey_x86_IDMBM, "Backup Folder", "REG_SZ", $Backup_path)
					EndIf
					_GUICtrlButton_Enable($Backup_Button, False)
			EndSwitch
			;==============================================================================================

		Case $Browse_Button_Restore
			$Restore_path = FileSelectFolder("Choose a folder to restore backup...", "", 7, $Intial_Restore_Path, $Form2)
			If @error = 1 Then _GUICtrlButton_Enable($Restore_Button, False)
			GUICtrlSetData($Restore_Input, $Restore_path)

			If GUICtrlRead($Setting_Encrypt) = "Yes" Then
				If _FileIsPathValid($Restore_path) = "True" Then
					_GUICtrlButton_Enable($Restore_Button, True)
					If FileExists($Restore_path & "\IDMregistry_Encrypted.reg") And FileExists($Restore_path & "\IDMbackup_Encrypted.7z") Then
						$mos_1 = 1
					Else
						$mos_1 = 0
						MsgBox(48, "Error", "Backup File Does Not Exists in This Folder", $Form2)
						GUICtrlSetData($Restore_Input, "")
						_GUICtrlButton_Enable($Restore_Button, False)
					EndIf
				EndIf


			ElseIf GUICtrlRead($Setting_Encrypt) = "No" Then
				If _FileIsPathValid($Restore_path) = "True" Then
					_GUICtrlButton_Enable($Restore_Button, True)
					If FileExists($Restore_path & "\IDMregistry.reg") And FileExists($Restore_path & "\IDMbackup.7z") Then
						$mos_1 = 1
					Else
						$mos_1 = 0
						MsgBox(48, "Error", "Backup File Does Not Exists in This Folder", $Form2)
						GUICtrlSetData($Restore_Input, "")
						_GUICtrlButton_Enable($Restore_Button, False)
					EndIf
				Else
					MsgBox(48, "Error", "Please Choose Valid Path First", $Form2)
					GUICtrlSetData($Backup_Input, "")
					_GUICtrlButton_Enable($Restore_Button, False)
				EndIf
			EndIf
			;==============================================================================================


		Case $Restore_Button
			If GUICtrlRead($Restore_Input) = "" Then $mos_1 = 0
			If _FileIsPathValid(GUICtrlRead($Restore_Input), 1) = False Then $mos_1 = 0


			Switch $mos_1
				Case 1
					GUICtrlSetData($Label2, "Working...")
					AdlibRegister("Update", 333)
					_GUICtrlButton_Enable($Browse_Button_Restore, False)
					_GUICtrlButton_Enable($Restore_Button, False)
					_control_update_busy()

					;==============================================================================================
					If GUICtrlRead($Setting_Encrypt) = "Yes" Then
						$passwd2 = InputBox("Security Check", "Enter your password.", "", "*")
						If $passwd2 = "" Then
							MsgBox(0, "Password", "Password Can not Blanck", $Form2)
							ContinueLoop
						EndIf
						$passwd_Validate2 = InputBox("Validate Password", "ReEnter your password.", "", "*")
						If $passwd2 = "" Then
							MsgBox(0, "Password", "Password Can not Blanck", $Form2)
							ContinueLoop
						EndIf
						If $passwd2 = $passwd_Validate2 Then
							If $passwd2 <> "" Then
								$p2 = 1
							EndIf
						Else
							MsgBox(0, "Password", "Password Not Match", $Form2)
							ContinueLoop
						EndIf
					EndIf
					;==============================================================================================
					;RegDelete("HKEY_CURRENT_USER\Software\DownloadManager")
					If @error = 1 Then MsgBox(48, "Warning", "Unable to open Requested key.", $Form2)
					If @error = 2 Then MsgBox(48, "Warning", "Unable to open Requested Main key.", $Form2)
					If @error = -1 Then MsgBox(48, "Warning", "Unable to delete Requested Value", $Form2)
					If @error = -2 Then MsgBox(48, "Warning", "Unable to delete Requested Key/Value", $Form2)
					;==============================================================================================
					If $p2 = 1 Then
						If FileExists(@TempDir & "\IDMregistry_Encrypted.reg") Then FileDelete(@TempDir & "\IDMregistry_Encrypted.reg")
						If FileExists(@TempDir & "\IDMregistry_Encrypted.reg") Then FileDelete(@TempDir & "\IDMregistry_Encrypted.reg")
						If FileExists(@TempDir & "\IDMregistry_Encrypted1.reg") Then FileDelete(@TempDir & "\IDMregistry_Encrypted1.reg")
						FileCopy($Restore_path & "\IDMbackup_Encrypted.7z", @TempDir)
						FileCopy($Restore_path & "\IDMregistry_Encrypted.reg", @TempDir)
						_Crypt_Startup()
						$Enc_Reg2 = FileRead(@TempDir & "\IDMregistry_Encrypted.reg")
						$hKey2 = _Crypt_DeriveKey($passwd2, $CALG_RC4)
						$bDecrypted = _Crypt_DecryptData($Enc_Reg2, $hKey2, $CALG_USERKEY)
						FileOpen(@TempDir & "\IDMregistry_Encrypted.reg", 10)
						FileWrite(@TempDir & "\IDMregistry_Encrypted.reg", $bDecrypted)
						FileClose(@TempDir & "\IDMregistry_Encrypted.reg")
						_Crypt_DestroyKey($hKey2)
						_Crypt_Shutdown()


						If GUICtrlRead($Setting_Convert_Registry) = "Yes" Then
							FileCopy(@TempDir & "\IDMregistry_Encrypted.reg", @TempDir & "\IDMregistry_Encrypted1.ini", 1)
							$guest_reg_folder = StringReplace(IniRead(@TempDir & "\IDMregistry_Encrypted1.ini", $regkey_x86_IDM, '"AppDataIDMFolder"', ""), "\\", "\")
							MsgBox(48, "Fatal Error", $guest_reg_folder, $Form2) ;debug
							$host_reg_folder = StringReplace($key, "\", "\\")
							MsgBox(48, "Fatal Error", $host_reg_folder, $Form2) ;debug
							_ReplaceStringInFile(@TempDir & "\IDMregistry_Encrypted1.ini", $host_reg_folder, $guest_reg_folder)
							FileMove(@TempDir & "\IDMregistry_Encrypted1.ini", @TempDir & "\IDMregistry_Encrypted1.reg")
							ShellExecuteWait(@TempDir & "\IDMregistry_Encrypted1.reg")
						EndIf


						;==============================================================================================
						ShellExecuteWait(@TempDir & "\IDMregistry_Encrypted1.reg")
						;==============================================================================================
						FileDelete($key)
						$key1 = _7ZzPath_Last_Remove($key)
						$key2 = _7ZzPath_Last_Remove($key1)
						;==============================================================================================
						;$foo_1 = _7Zip_Extract(@TempDir & "\" & "IDMbackup.7z", $key2, $passwd2)
						$foo_1 = 0
						;==============================================================================================
					Else
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMbackup.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						FileCopy($Restore_path & "\IDMbackup.7z", @TempDir)
						FileCopy($Restore_path & "\IDMregistry.reg", @TempDir)
						;==============================================================================================
						;ShellExecuteWait(@TempDir & "\IDMregistry.reg")
						;==============================================================================================
						FileDelete($key)
						$key1 = _7ZzPath_Last_Remove($key)
						$key2 = _7ZzPath_Last_Remove($key1)
						;==============================================================================================
						$foo_1 = _7Zip_Extract(@TempDir & "\" & "IDMbackup.7z", $key2, "")
						;==============================================================================================
					EndIf

					If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
					If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
					;If FileExists(@TempDir & "\IDMregistry_Encrypted.reg") Then FileDelete(@TempDir & "\IDMregistry_Encrypted.reg")
					;If FileExists(@TempDir & "\IDMregistry_Encrypted.reg") Then FileDelete(@TempDir & "\IDMregistry_Encrypted.reg")
					;If FileExists(@TempDir & "\IDMregistry_Encrypted1.reg") Then FileDelete(@TempDir & "\IDMregistry_Encrypted1.reg")
					;If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
					;If FileExists(@TempDir & "\IDMbackup.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
					RegWrite($regkey_x86_IDMBM, "Restore Folder", "REG_SZ", $Restore_path)

					_GUICtrlButton_Enable($Browse_Button_Restore, True)
					_GUICtrlButton_Enable($Restore_Button, True)
					_control_update_default()

					AdlibUnRegister("Update")
					WinSetTitle($Form2, "", $Win_Title)

					If $foo_1 = 1 Then
						MsgBox(48, "Warning (Non fatal error(s))", "For example, one or more files were locked by some other application, so they were not compressed.", 0, $Form2)
						GUICtrlSetData($Label2, "Done But Error")

					ElseIf $foo_1 = 2 Then
						MsgBox(48, "Fatal Error", "Fatal error", 0, $Form2)
						GUICtrlSetData($Label2, "Done But Error")

					ElseIf $foo_1 = 7 Then
						MsgBox(48, "Error", "Command line error", 0, $Form2)
						GUICtrlSetData($Label2, "Done But Error")

					ElseIf $foo_1 = 8 Then
						MsgBox(48, "Error", "Not enough memory for operation.", 0, $Form2)
						GUICtrlSetData($Label2, "Done But Error")

					ElseIf $foo_1 = 255 Then
						MsgBox(48, "Error", "Operation Canclled.", 0, $Form2)
						GUICtrlSetData($Label2, "Done But Error")

					ElseIf $foo_1 = 0 Then
						MsgBox(0, "Done", "Restore Success.", 0, $Form2)
						GUICtrlSetData($Label2, "Restore Success.")
					EndIf
				Case 0
					MsgBox(48, "Error", "Please Choose a Valid Backup Folder", 0, $Form2)
				Case 11

			EndSwitch

		Case $Update
			_GUICtrlButton_Enable($Update, False)
			Local $Update_VER = InetRead("http://www.geocities.ws/gajjartejas/IDM_Backup_Manager/v0.9.1/update.txt")

			Switch BinaryToString($Update_VER)
				Case ""
					MsgBox(48, "Error", "Internet connection could not found", 0, $Form2)
				Case "0.9.1"
					MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $Form2)
				Case "0.9.2"
					MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $Form2)
				Case "0.9.3"
					MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $Form2)
				Case Else
					MsgBox(64, "Availabe", "You Should Download Following Version" & BinaryToString($Update_VER), 0, $Form2)
			EndSwitch

		Case $Help
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/Start_page.htm"')
		Case $Read_ME
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/Using_IDM_Backup_Manager.htm"')
		Case $Licence
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/General_Information.htm"')
		Case $Thanks
			MsgBox(64, "Thanks...", "I would like to thank:" & @CRLF & @CRLF & "·        Whole Auto IT Team (http://www.autoitscript.com/forum)" & @CRLF & "·        Igor Pavlov (www.7-zip.org)", 0, $Form2)
		Case $Aurther
			ShellExecute("http://gajjartejas26.blogspot.com/p/about-me.html")
		Case $Website
			ShellExecute("http://gajjartejas26.blogspot.com")

		Case $Save_Setting_Button
			If GUICtrlRead($Setting_Encrypt) = "Yes" Or GUICtrlRead($Setting_Encrypt) = "No" Then
				IniWrite("setting.ini", "Setting", "Setting_Encrypt", GUICtrlRead($Setting_Encrypt))
			Else
				MsgBox(48, "Setting.ini", "Invalid setting found at" & @CRLF & "Setting Tab-->Encrypt Value is  Invalid" & @CRLF & "Restored Default", 0, $Form2)
				GUICtrlSetData($Setting_Encrypt, IniRead("setting.ini", "Setting", "Setting_Encrypt", "No"))
				IniWrite("setting.ini", "Setting", "Setting_Encrypt", "No")
			EndIf

			If GUICtrlRead($Setting_Compression_Level) = "1-Store/None" Or GUICtrlRead($Setting_Compression_Level) = "2-Fastest" Or GUICtrlRead($Setting_Compression_Level) = "3-Fast" Or GUICtrlRead($Setting_Compression_Level) = "4-Normal" Or GUICtrlRead($Setting_Compression_Level) = "5-Maximum" Or GUICtrlRead($Setting_Compression_Level) = "6-Ultra" Then
				IniWrite("setting.ini", "Setting", "Setting_Compression_Level", GUICtrlRead($Setting_Compression_Level))
			Else
				MsgBox(48, "Setting.ini", "Invalid setting found at" & @CRLF & "Setting Tab-->Compression Value is  Invalid" & @CRLF & "Restored Default", 0, $Form2)
				GUICtrlSetData($Setting_Compression_Level, IniRead("setting.ini", "Setting", "Setting_Compression_Level", "4-Normal"))
				IniWrite("setting.ini", "Setting", "Setting_Compression_Level", "4-Normal")
			EndIf

			If GUICtrlRead($Setting_Convert_Registry) = "Yes" Or GUICtrlRead($Setting_Convert_Registry) = "No" Then
				IniWrite("setting.ini", "Setting", "Setting_Convert_Registry", GUICtrlRead($Setting_Convert_Registry))
			Else
				MsgBox(48, "Setting.ini", "Invalid setting found at" & @CRLF & "Setting Tab-->Reistry Value is Invalid" & @CRLF & "Restored Default", 0, $Form2)
				GUICtrlSetData($Setting_Convert_Registry, IniRead("setting.ini", "Setting", "Setting_Convert_Registry", "Yes"))
				IniWrite("setting.ini", "Setting", "Setting_Convert_Registry", "Yes")
			EndIf
			MsgBox(64, "Setting.ini", "Saved", 0, $Form2)


		Case $Form2
		Case $Tab1
		Case $Backup_Input
		Case $Restore_Input
	EndSwitch
WEnd



Func _7Zip_Extract($sZipFile, $sDestinationFolder, $sPassword = "")
	If FileExists($sZipFile) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If StringRight($sDestinationFolder, 1) <> "\" Then
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
	Return RunWait('7z.exe' & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"', "", @SW_HIDE)
EndFunc   ;==>_7Zip_Extract


Func _7ZzPath_Convert($Restore_path)
	Local $i = 0
	Local $p = 0
	$split_path = StringSplit($Restore_path, "\")
	While 1
		If StringInStr($split_path[$i], Chr(32)) Then $split_path[$i] = '"' & $split_path[$i] & '"'
		If StringInStr($split_path[$i], Chr(32)) Then $p = $p + 1
		If $i = $split_path[0] Then ExitLoop
		$i = $i + 1
	WEnd

	Local $i = 2
	Local $d_Saved_Path = $split_path[1] & ""
	While 1
		$d_Saved_Path = $d_Saved_Path & "\" & $split_path[$i]
		If $i = $split_path[0] Then ExitLoop
		$i = $i + 1
	WEnd
	Return $d_Saved_Path
EndFunc   ;==>_7ZzPath

Func _7ZzPath_Last_Remove($Restore_path)
	Local $i = 0
	Local $p = 0
	$split_path = StringSplit($Restore_path, "\")
	While 1
		If StringInStr($split_path[$i], Chr(32)) Then $split_path[$i] = '"' & $split_path[$i] & '"'
		If StringInStr($split_path[$i], Chr(32)) Then $p = $p + 1
		If $i = $split_path[0] Then ExitLoop
		$i = $i + 1
	WEnd

	Local $i = 2
	Local $d_Saved_Path = $split_path[1] & ""
	While 1
		If $i = $split_path[0] Then ExitLoop
		$d_Saved_Path = $d_Saved_Path & "\" & $split_path[$i]
		$i = $i + 1
	WEnd
	Return $d_Saved_Path
EndFunc   ;==>_7ZzPath1

Func _regbackup($backup_dir, $name_to_save, $regkey)
	;$cache = ""
	ShellExecuteWait('regedit.exe', '/e "' & $backup_dir & '\' & $name_to_save & '"' & " "& $regkey)
	;$cache &= FileRead($backup_dir & "\" & $name_to_save)
	;FileOpen($backup_dir & "\" & $name_to_save, 2)
	;FileWrite($backup_dir & "\" & $name_to_save, $cache)
	;FileClose($backup_dir & "\" & $name_to_save)
EndFunc   ;==>_regbackup

Func Update()
	Switch Mod($Increase, 4)
		Case 0
			WinSetTitle($Form2, "", "Processing... |")
		Case 1
			WinSetTitle($Form2, "", "Processing... /")
		Case 2
			WinSetTitle($Form2, "", "Processing... —")
		Case 3
			WinSetTitle($Form2, "", "Processing... \")
	EndSwitch

	$Increase += 1
EndFunc   ;==>Update

Func _control_update_busy()
	GUISetCursor(15, 1, $Form2)
	GUISetCursor(15, 1, $Pic1)
	GUISetCursor(15, 1, $TabSheet1)
	GUISetCursor(15, 1, $Backup_Input)
	GUISetCursor(15, 1, $Label1)
	GUISetCursor(15, 1, $TabSheet2)
	GUISetCursor(15, 1, $Restore_Input)
	GUISetCursor(15, 1, $Label2)
	GUISetCursor(15, 1, $TabSheet3)
	GUISetCursor(15, 1, $Read_ME)
	GUISetCursor(15, 1, $Licence)
	GUISetCursor(15, 1, $Thanks)
	GUISetCursor(15, 1, $Aurther)
	GUISetCursor(15, 1, $Website)
	GUISetCursor(15, 1, $Update)
EndFunc   ;==>_control_update_busy

Func _control_update_default()
	GUISetCursor(-1, 1, $Form2)
	GUISetCursor(-1, 1, $Pic1)
	GUISetCursor(-1, 1, $TabSheet1)
	GUISetCursor(-1, 1, $Backup_Input)
	GUISetCursor(-1, 1, $Label1)
	GUISetCursor(-1, 1, $TabSheet2)
	GUISetCursor(-1, 1, $Restore_Input)
	GUISetCursor(-1, 1, $Label2)
	GUISetCursor(-1, 1, $TabSheet3)
	GUISetCursor(-1, 1, $Read_ME)
	GUISetCursor(-1, 1, $Licence)
	GUISetCursor(-1, 1, $Thanks)
	GUISetCursor(-1, 1, $Aurther)
	GUISetCursor(-1, 1, $Website)
	GUISetCursor(-1, 1, $Update)
EndFunc   ;==>_control_update_default
