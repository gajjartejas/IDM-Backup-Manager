#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=11.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#region ### START Koda GUI section ### Form=C:\Users\Tejas\Desktop\idm\Form2.kxf
$Form2 = GUICreate("Form2", 327, 187, 409, 352, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME))
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
$TabSheet3 = GUICtrlCreateTabItem("About Me")
$Button1 = GUICtrlCreateButton("About Me", 26, 107, 276, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Button2 = GUICtrlCreateButton("About", 25, 131, 276, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Button3 = GUICtrlCreateButton("Website", 25, 155, 276, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
GUICtrlCreateTabItem("")
$Pic1 = GUICtrlCreatePic("C:\Users\Tejas\Desktop\steel_most1_notxt1.jpg", 0, 0, 326, 76)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

$key = RegRead("HKEY_CURRENT_USER\Software\DownloadManager", "AppDataIDMFolder")
If @error <> 0 Then
	MsgBox(16, "Error", "IDM is not installed on this system or Unable to open requested registry key.")
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

			$path_msg_1 = "Files Already Exists"
			If FileExists($Backup_path & "\IDMregistry.reg") Or FileExists($Backup_path & "\IDMBACKUP.7z") Then


				If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
				$iMsgBoxAnswer = MsgBox(36, "Confirm Save", "Previous Backup Files Already Exists Do You Want To Replace It?")
				Select
					Case $iMsgBoxAnswer = 6 ;Yes
						FileDelete($Backup_path & "\IDMregistry.reg")
						FileDelete($Backup_path & "\IDMBACKUP.7z")
						Global $mos = 1
					Case $iMsgBoxAnswer = 7 ;No
						GUICtrlSetData($Backup_Input, "")
						Global $mos = 0
				EndSelect

			EndIf

			;==============================================================================================
		Case $Backup_Button
			If $mos = 0 Then
				MsgBox(48, "Error", "Please Choose Path First")
				;MsgBox(48, "Error", $Backup_Input)
			Else
				GUICtrlSetData($Label1, "Working...")
				$path = @TempDir & "\IDMregistry.reg"
				$cache = ""
				ShellExecuteWait("regedit.exe", "/e " & $path & " HKEY_CURRENT_USER\Software\DownloadManager")

				$cache &= FileRead($path)
				FileOpen($path, 2)
				FileWrite($path, $cache)
				FileClose($path)
				FileMove($path, $Backup_path)
				;==============================================================================================
				$c_Saved_Path = _7ZzPath($Backup_path)
				MsgBox(0, "DONE", $c_Saved_Path)
				;==============================================================================================
				$c_key = _7ZzPath($key)
				MsgBox(0, "DONE", $c_key)
				;==============================================================================================
				$foo = RunWait("7z.exe" & " " & "a" & " " & $c_Saved_Path & "\" & "IDMBACKUP.7z" & " " & $c_key)
				If $foo = 1 Then
					MsgBox(48, "Warning (Non fatal error(s))", "For example, one or more files were locked by some other application, so they were not compressed.")
				ElseIf $foo = 2 Then
					MsgBox(48, "Fatal Error", "Fatal error")
				ElseIf $foo = 7 Then
					MsgBox(48, "Error", "Command line error")
				ElseIf $foo = 8 Then
					MsgBox(48, "Error", "Not enough memory for operation.")
				ElseIf $foo = 255 Then
					MsgBox(48, "Error", "Operation Canclled.")
				ElseIf $foo = 0 Then
					MsgBox(0, "Done", "Backup Success.")
					GUICtrlSetData($Label1, " ")
				EndIf
			EndIf
			;==============================================================================================








		Case $Restore_Input
		Case $Browse_Button_Restore
			$Restore_path = FileSelectFolder("Choose a folder to restore backup...", "")
			If $Restore_path <> "" Then GUICtrlSetData($Restore_Input, $Restore_path)
			$p = 0
			$q = 0
			$path_msg_2 = "Please Enter a Valid Backup Path"
			If Not FileExists($Restore_path & "\IDMregistry.reg") Then
				$q = 1
				;MsgBox(16, "File NOT exists", $path_msg_2)
				GUICtrlSetData($Restore_Input, "Please Enter a Valid Backup Path")
			EndIf

			If Not FileExists($Restore_path & "\IDMBACKUP.7z") Then
				$r = 1
				;MsgBox(16, "File NOT exists", $path_msg_2)
				GUICtrlSetData($Restore_Input, "")
			EndIf

			If $p + $q > 0 Then
				MsgBox(16, "File NOT exists", $path_msg_2)
			EndIf

		Case $Restore_Button
			If $Restore_Input <> $path_msg_2 Then
				FileCopy($Restore_path & "\IDMBACKUP.7z", @TempDir)
				FileCopy($Restore_path & "\IDMregistry.reg", @TempDir)

				;==============================================================================================
				;$i = 0
				;$P = 0
				;$split_path = StringSplit($Restore_path, "\")
				;While 1
				;	If StringInStr($split_path[$i], Chr(32)) Then $split_path[$i] = '"' & $split_path[$i] & '"'
				;	If StringInStr($split_path[$i], Chr(32)) Then $P = $P + 1
				;	If $i = $split_path[0] Then ExitLoop
				;	$i = $i + 1
				;WEnd

				;$i = 2
				;$d_Saved_Path = $split_path[1] & ""
				;While 1
				;	$d_Saved_Path = $d_Saved_Path & "\" & $split_path[$i]
				;	If $i = $split_path[0] Then ExitLoop
				;	$i = $i + 1
				;WEnd

				;==============================================================================================
				ShellExecuteWait(@TempDir & "\IDMregistry.reg")
				;==============================================================================================
				$foo = Run("7z.exe" & " x" & " " & @TempDir & "\" & "IDMBACKUP.7z" & " " & $key)
				;==============================================================================================
				$key1 = _7ZzPath1($key)
				;MsgBox(0, "DONE", $key1)
				$key2 = _7ZzPath1($key1)
				;MsgBox(0, "DONE", $key2)
				_7Zip_Extract(@TempDir & "\" & "IDMBACKUP.7z", $key2, "")

			Else
				MsgBox(16, "File NOT exists", $path_msg_2)
			EndIf

		Case $Button1
		Case $Button2
		Case $Button3
		Case $Pic1
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
		FileInstall("7zG.exe", $sDestinationFolder & "\" & "7zG.exe", 0)
	EndIf
	Return RunWait('7zG.exe' & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"', "")
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

