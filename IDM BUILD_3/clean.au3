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
Global $IDMBM, $Win_Title,$AppDataIDMFolder,$TempPath
Func clean()
	GUISetState(@SW_DISABLE, $IDMBM)
	Local $size = WinGetPos($Win_Title)
;~ 	Local $clean = GUICreate("Clean", 261, 259, ($size[0]-261)/2,($size[1]-259)/2, -1, -1, $IDMBM)
	Local $clean = GUICreate("Clean", 261, 259, $size[0], $size[1], -1, -1, $IDMBM)

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
					$iMsgBoxAnswer = MsgBox(36, "Conform", Round(DirGetSize($TempPath) / 1048576) & "MB" & " Will Deleted. Continue?")
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