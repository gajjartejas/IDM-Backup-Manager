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
			$split_path = StringSplit($Backup_path, "\")
			While 1
				If StringInStr($split_path[$i], Chr(32)) Then $split_path[$i] = '"' & $split_path[$i] & '"'
				If StringInStr($split_path[$i], Chr(32)) Then $P = $P + 1
				If $i = $split_path[0] Then ExitLoop
				$i = $i + 1
			WEnd

			$i = 2
			$c_Saved_Path = $split_path[1] & ""
			While 1
				$c_Saved_Path = $c_Saved_Path & "\" & $split_path[$i]
				If $i = $split_path[0] Then ExitLoop
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

			$path_msg = "Please Enter a Valid Backup Path"
			If Not FileExists($Restore_path & "\IDMregistry.reg") Then
				MsgBox(16, "File NOT exists", $path_msg)
				GUICtrlSetData($Restore_Input, "Please Enter a Valid Backup Path")
			EndIf

			If Not FileExists($Restore_path & "\IDMBACKUP.7z") Then
				MsgBox(16, "File NOT exists", $path_msg)
				GUICtrlSetData($Restore_Input, "")
			EndIf

		Case $Restore_Button
			If $Restore_Input <> $path_msg Then
				ShellExecuteWait($Restore_path & "\IDMregistry.reg")
				FileMove($Restore_path, $key)
				EndIf

			Case $Button1
			Case $Button2
			Case $Button3
			Case $Pic1
;### Tidy Error -> "endswitch" is closing previous "case" on line 47
		EndSwitch
;### Tidy Error -> "wend" is closing previous "switch" on line 46
	WEnd



;### Tidy Error -> while is never closed in your script.
