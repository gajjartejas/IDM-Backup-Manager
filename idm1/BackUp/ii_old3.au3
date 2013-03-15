#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=11.exe
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#region ### START Koda GUI section ### Form=C:\Users\Tejas\Desktop\project\IDM\Form2.kxf
$Form2 = GUICreate("Form2", 328, 185, 442, 361)
GUISetBkColor(0xFFFFFF)
$Tab1 = GUICtrlCreateTab(0, 80, 324, 103)
$TabSheet1 = GUICtrlCreateTabItem("Backup Setting")
$Backup_Input = GUICtrlCreateInput("", 5, 122, 266, 21)
$Browse_Button_Backup = GUICtrlCreateButton("...", 280, 120, 20, 25)
GUICtrlSetTip(-1, "Automatically Detect IDM Backup Path")
$Backup_Button = GUICtrlCreateButton("Backup", 225, 150, 75, 25)
$TabSheet2 = GUICtrlCreateTabItem("Restore Setting")
$Restore_Input = GUICtrlCreateInput("", 5, 122, 266, 21)
$Browse_Button_Restore = GUICtrlCreateButton("...", 280, 120, 20, 25)
$Restore_Button = GUICtrlCreateButton("Restore", 225, 150, 75, 25)
$TabSheet3 = GUICtrlCreateTabItem("About Me")
$Button1 = GUICtrlCreateButton("About Me", 15, 105, 276, 21)
$Button2 = GUICtrlCreateButton("About", 14, 129, 276, 21)
$Button3 = GUICtrlCreateButton("Website", 14, 153, 276, 21)
GUICtrlCreateTabItem("")
$Pic1 = GUICtrlCreatePic("C:\Users\Tejas\Desktop\steel_most1_notxt1.jpg", 0, 0, 326, 76)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

$key = RegRead("HKEY_CURRENT_USER\Software\DownloadManager", "AppDataIDMFolder")
If @error <> 0 Then
	MsgBox(16, "Error", "IDM is not installed on this system or Unable to open requested registry key.")
EndIf

$key = RegRead("HKEY_CURRENT_USER\Software\DownloadManager", "AppDataIDMFolder")
If @error <> 0 Then
	Exit
EndIf

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Form2
		Case $Form2
		Case $Form2
		Case $Form2
		Case $Tab1
		Case $Backup_Input
			;==============================================================================================
		Case $Browse_Button_Backup
			$Backup_path = FileSelectFolder("Choose a folder to save backup...", "")
			If $Backup_path <> "" Then GUICtrlSetData($Backup_Input, $Backup_path)
			;==============================================================================================
		Case $Backup_Button
			$path = @TempDir & "\IDMregistry.reg"
			$cache = ""
			ShellExecuteWait("regedit.exe", "/e " & $path & " HKEY_CURRENT_USER\Software\DownloadManager")

			$cache &= FileRead($path)
			FileOpen($path, 2)
			FileWrite($path, $cache)
			FileClose($path)
			FileMove($path, $Backup_path)
			;==============================================================================================
			$i = 0
			$P = 0
			$days = StringSplit($Backup_path, "\")
			$result = StringInStr("I am a String", " ")
			While 1
				;MsgBox(0, "New string is", $days[$i])
				If StringInStr($days[$i], Chr(32)) Then $days[$i] = '"' & $days[$i] & '"'
				If StringInStr($days[$i], Chr(32)) Then $P = $P + 1
				If $i = $days[0] Then ExitLoop
				$i = $i + 1
			WEnd

			$i = 2
			$c_Saved_Path = $days[1] & ""
			While 1
				$c_Saved_Path = $c_Saved_Path & "\" & $days[$i]
				If $i = $days[0] Then ExitLoop
				$i = $i + 1
			WEnd
			MsgBox(0, "DONE", $c_Saved_Path)

			;==============================================================================================
			$foo = Run("7z.exe" & " " & "a" & " " & $c_Saved_Path & "\" & "IDMBACKUP.7z" & " " & $key)
			;==============================================================================================
		Case $Restore_Input
		Case $Browse_Button_Restore
			$Restore_path = FileSelectFolder("Choose a folder to restore backup...", "")
			If $Restore_path <> "" Then GUICtrlSetData($Restore_Input, $Restore_path)

		;	If FileExists($Restore_path & "\IDMregistry.reg") And FileExists($Restore_path & "IDMBACKUP.7z") Then
		;	MsgBox(0,"dd","dd")
		;	Else
		;	MsgBox(16, "File NOT exists", "Make a Sure IDMBACKUP.7z and IDMREGISTRY.reg Exists in Same Folder")
		;EndIf

If FileExists($Restore_path & "\IDMregistry.reg") Then
	If FileExists($Restore_path & "\IDMBACKUP.7z") Then
	MsgBox(0,"dd","dd")
EndIf
MsgBox(16, "File NOT exists", "Make a Sure IDMBACKUP.7z and IDMREGISTRY.reg Exists in Same Folder")
EndIf


		Case $Restore_Button
		Case $Button1
		Case $Button2
		Case $Button3
		Case $Pic1
	EndSwitch
WEnd