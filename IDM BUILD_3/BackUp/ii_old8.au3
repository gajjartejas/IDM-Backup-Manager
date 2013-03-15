#NoTrayIcon
#RequireAdmin
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resorces\icon.ico
#AutoIt3Wrapper_Outfile=89.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=IDM Backup Manager is a free software that can backup files from InterDownload Manager
#AutoIt3Wrapper_Res_Description=IDM Backup Manager is a free software that can backup files from InterDownload Manager
#AutoIt3Wrapper_Res_Fileversion=0.9.1.0
#AutoIt3Wrapper_Res_LegalCopyright=©Gajjar Tejas 2012
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include "GUIFade.au3"


#region ### START Koda GUI section ### Form=C:\Users\Tejas\Desktop\idm\Form2.kxf
$Form2 = GUICreate("IDM Backup Manager 0.9.1(Beta)", 327, 187, 409, 352, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME))
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

$TabSheet3 = GUICtrlCreateTabItem("About")
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
$Update = GUICtrlCreateButton("", 20, 107, 66, 66, $BS_ICON)
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




$version = RegRead("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Software Version")
$regkey_x86 = " HKEY_CURRENT_USER\Software\DownloadManager"

If $version <> "0.9.1" Then
	RunWait("Warning.exe")
EndIf

$key = RegRead("HKEY_CURRENT_USER\Software\DownloadManager", "AppDataIDMFolder")
If @error <> 0 Then
	MsgBox(16, "Error", "IDM is not installed on this system or Unable to open requested registry key.")
EndIf

If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")

$Intial_Backup_Path = RegRead("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Backup Folder")
$Intial_Restore_Path = RegRead("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Restore Folder")


If ProcessExists("7z.exe") Then
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(4, "7z Locked", "7z is Running in Background.Do You Want To Close 7z?")
	Select
		Case $iMsgBoxAnswer = 6 ;Yes
			ProcessClose("7z.exe")
		Case $iMsgBoxAnswer = 7 ;No
	EndSelect
EndIf

If ProcessExists("regedit.exe") Then
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(4, "Registry Editor Locked", "Registry Editor is Running in Background.Do You Want To Close Registry Editor?")
	Select
		Case $iMsgBoxAnswer = 6 ;Yes
			ProcessClose("regedit.exe")
		Case $iMsgBoxAnswer = 7 ;No
	EndSelect
EndIf

If ProcessExists("idman.exe") Then
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(4, "Close IDM", "IDM is Running in Background.Do You Want To Close IDM?")
	Select
		Case $iMsgBoxAnswer = 6 ;Yes
			ProcessClose("idman.exe")
		Case $iMsgBoxAnswer = 7 ;No
	EndSelect
EndIf

GUICtrlSetData($Label1, "Ready")
GUICtrlSetData($Label2, "Ready")


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
			If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
			_FadeGUIOut($Form2)
			Exit

			;==============================================================================================
		Case $Browse_Button_Backup
			$Backup_path = FileSelectFolder("Choose a folder to save backup...", "", 1 And 2 And 4, $Intial_Backup_Path)
			If $Backup_path <> "" Then GUICtrlSetData($Backup_Input, $Backup_path)
			$mos = 1
			$path_msg_1 = "Files Already Exists"
			If FileExists($Backup_path & "\IDMregistry.reg") Or FileExists($Backup_path & "\IDMBACKUP.7z") Then
				If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
				$iMsgBoxAnswer = MsgBox(36, "Confirm Save", "Previous Backup Files Already Exists Do You Want To Replace It?")
				Select
					Case $iMsgBoxAnswer = 6 ;Yes
						$file_delete_1 = FileDelete($Backup_path & "\IDMregistry.reg")
						$file_delete_2 = FileDelete($Backup_path & "\IDMBACKUP.7z")
						If $file_delete_1 = 0 Or $file_delete_2 = 0 Then
							MsgBox(48, "Warning", "Files Could Not Deleted.It May Be Locked.")
						EndIf
						$mos = 11
					Case $iMsgBoxAnswer = 7 ;No
						GUICtrlSetData($Backup_Input, "")
						$mos = 10
				EndSelect
			EndIf
			;==============================================================================================
		Case $Backup_Button

			$Backup_path = GUICtrlRead($Backup_Input)
			If $Backup_path = "" Then $mos = 10
			;MsgBox(48, "Error11", $mos)
			Switch $mos
				Case 10
					MsgBox(48, "Error", "Please Choose Path First")
				Case 11 And 1
			_GUICtrlButton_Enable($Browse_Button_Backup, False)
			_GUICtrlButton_Enable($Backup_Button, False)
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
					GUICtrlSetData($Label1, "Working...")

					;==============================================================================================
					_regbackup($Backup_path, "IDMregistry.reg", $regkey_x86)
					;==============================================================================================
					$c_Saved_Path = _7ZzPath($Backup_path)
					;==============================================================================================
					$c_key = _7ZzPath($key)
					;==============================================================================================
					$foo_2 = RunWait("7z.exe" & " " & "a" & " " & $c_Saved_Path & "\" & "IDMBACKUP.7z" & " " & $c_key, "", @SW_HIDE)
					;==============================================================================================

					If $foo_2 = 1 Then
						MsgBox(48, "Warning (Non fatal error(s))", "For example, one or more files were locked by some other application, so they were not compressed.")
						GUICtrlSetData($Label1, "Done But Error")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Backup Folder", "REG_SZ", $Backup_path)
					ElseIf $foo_2 = 2 Then
						MsgBox(48, "Fatal Error", "Fatal error")
						GUICtrlSetData($Label1, "Done But Error")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Backup Folder", "REG_SZ", $Backup_path)
					ElseIf $foo_2 = 7 Then
						MsgBox(48, "Error", "Command line error")
						GUICtrlSetData($Label1, "Done But Error")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Backup Folder", "REG_SZ", $Backup_path)
					ElseIf $foo_2 = 8 Then
						MsgBox(48, "Error", "Not enough memory for operation.")
						GUICtrlSetData($Label1, "Done But Error")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Backup Folder", "REG_SZ", $Backup_path)
					ElseIf $foo_2 = 255 Then
						MsgBox(48, "Error", "Operation Canclled.")
						GUICtrlSetData($Label1, "Done But Error")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Backup Folder", "REG_SZ", $Backup_path)
					ElseIf $foo_2 = 0 Then
						MsgBox(0, "Done", "Backup Success.")
						GUICtrlSetData($Label1, "Backup Success.")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Backup Folder", "REG_SZ", $Backup_path)
					EndIf
			EndSwitch
			;==============================================================================================

		Case $Browse_Button_Restore
			$Restore_path = FileSelectFolder("Choose a folder to restore backup...", "", 1 And 2 And 4, $Intial_Restore_Path)
			If $Restore_path <> "" Then
				GUICtrlSetData($Restore_Input, $Restore_path)
				$mos_1 = 11
			EndIf
			If FileExists($Restore_path & "\IDMregistry.reg") Or FileExists($Restore_path & "\IDMBACKUP.7z") Then
				$mos_1 = 1
			Else
				$mos_1 = 0
				MsgBox(48, "Error", "Backup File Does Not Exists in This Folder")
				GUICtrlSetData($Restore_Input, "")
			EndIf

			;==============================================================================================
		Case $Restore_Button
			$Restore_path = GUICtrlRead($Restore_Input)
			If $Restore_path = "" Then $mos_1 = 0
			Switch $mos_1
				Case 1
					GUICtrlSetData($Label2, "Working...")
					If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
					If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
					FileCopy($Restore_path & "\IDMBACKUP.7z", @TempDir)
					FileCopy($Restore_path & "\IDMregistry.reg", @TempDir)

					;==============================================================================================
					RegDelete("HKEY_CURRENT_USER\Software\DownloadManager")
					If @error = 1 Then MsgBox(48, "Warning", "Unable to open Requested key.")
					If @error = 2 Then MsgBox(48, "Warning", "Unable to open Requested Main key.")
					If @error = -1 Then MsgBox(48, "Warning", "Unable to delete Requested Value")
					If @error = -2 Then MsgBox(48, "Warning", "Unable to delete Requested Key/Value")
					;==============================================================================================
					ShellExecuteWait(@TempDir & "\IDMregistry.reg")
					;==============================================================================================
					FileDelete($key)
					$key1 = _7ZzPath1($key)
					$key2 = _7ZzPath1($key1)
					$foo_1 = _7Zip_Extract(@TempDir & "\" & "IDMBACKUP.7z", $key2, "")
					If $foo_1 = 1 Then
						MsgBox(48, "Warning (Non fatal error(s))", "For example, one or more files were locked by some other application, so they were not compressed.")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Restore Folder", "REG_SZ", $Restore_path)
					ElseIf $foo_1 = 2 Then
						MsgBox(48, "Fatal Error", "Fatal error")
						GUICtrlSetData($Label2, "Done But Error")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Restore Folder", "REG_SZ", $Restore_path)
					ElseIf $foo_1 = 7 Then
						MsgBox(48, "Error", "Command line error")
						GUICtrlSetData($Label2, "Done But Error")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Restore Folder", "REG_SZ", $Restore_path)
					ElseIf $foo_1 = 8 Then
						MsgBox(48, "Error", "Not enough memory for operation.")
						GUICtrlSetData($Label2, "Done But Error")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Restore Folder", "REG_SZ", $Restore_path)
					ElseIf $foo_1 = 255 Then
						MsgBox(48, "Error", "Operation Canclled.")
						GUICtrlSetData($Label2, "Done But Error")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Restore Folder", "REG_SZ", $Restore_path)
					ElseIf $foo_1 = 0 Then
						MsgBox(0, "Done", "Backup Success.")
						GUICtrlSetData($Label2, "Backup Success.")
						If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
						If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
						If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
						If FileExists(@TempDir & "\IDMBACKUP.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
						RegWrite("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Restore Folder", "REG_SZ", $Restore_path)
					EndIf
				Case 0
					MsgBox(48, "Error", "Please Choose a Valid Backup Folder")
					If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
					If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
				Case 11

			EndSwitch

		Case $Update
			_GUICtrlButton_Enable($Update, False)
			Local $Update_VER = InetRead("http://www.geocities.ws/gajjartejas/IDM_Backup_Manager/v0.9.1/update.txt")
			Switch BinaryToString($Update_VER)
				Case ""
					MsgBox(48, "Error", "Internet connection could not found")
				Case "0.9.1"
					MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.")
				Case Else
					MsgBox(64, "Availabe", "You Should Download Latest Version.")
			EndSwitch

		Case $Help
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/Start_page.htm"')
		Case $Read_ME
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/Using_IDM_Backup_Manager.htm"')
		Case $Licence
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/General_Information.htm"')
		Case $Thanks
			MsgBox(64, "Thanks...", "I would like to thank:" & @CRLF & @CRLF & "·        Whole Auto IT Team (http://www.autoitscript.com/forum)" & @CRLF & "·        Igor Pavlov (www.7-zip.org)")
		Case $Aurther
			ShellExecute("http://gajjartejas26.blogspot.com/p/about-me.html")
		Case $Website
			ShellExecute("http://gajjartejas26.blogspot.com")

		Case $Form2
		Case $Form2
		Case $Form2
		Case $Form2
		Case $Tab1
		Case $Backup_Input
		Case $Restore_Input
	EndSwitch
WEnd



Func _7Zip_Extract($sZipFile, $sDestinationFolder = @ScriptDir, $sPassword = "")
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
	If FileExists($sDestinationFolder & "\" & "7zG.exe") = 0 Then
		FileInstall("7z.exe", $sDestinationFolder & "\" & "7zG.exe", 0)
	EndIf
	Return RunWait('7z.exe' & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"', "", @SW_HIDE)
EndFunc   ;==>_7Zip_Extract


Func _7ZzPath($Restore_path)
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

Func _7ZzPath1($Restore_path)
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
	$cache = ""
	ShellExecuteWait('regedit.exe', '/e "' & $backup_dir & '\' & $name_to_save & '"' & $regkey)
	$cache &= FileRead($backup_dir & "\" & $name_to_save)
	FileOpen($backup_dir & "\" & $name_to_save, 2)
	FileWrite($backup_dir & "\" & $name_to_save, $cache)
	FileClose($backup_dir & "\" & $name_to_save)
EndFunc   ;==>_regbackup
