#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.1
	Author:         myName

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <WindowsConstants.au3>
#region ### START Koda GUI section ### Form=C:\Users\Tejas\Desktop\project\IDM\IDM BUILD_3\Clean.kxf

Global $regkey_x86_IDM = "HKEY_CURRENT_USER\Software\DownloadManager"
$AppDataIDMFolder = RegRead($regkey_x86_IDM, "AppDataIDMFolder")
$TempPath = RegRead($regkey_x86_IDM, "TempPath")


$Form2 = GUICreate("Clean", 261, 259, 311, 255)

$Group1 = GUICtrlCreateGroup("Options", 5, 60, 250, 150)
$Clena_DD = GUICtrlCreateCheckbox("Download Data", 20, 80, 97, 17)
$Clean_GD = GUICtrlCreateCheckbox("Grabber Data", 20, 105, 97, 17)
$Clean_SD = GUICtrlCreateCheckbox("Scheduler Data", 20, 130, 97, 17)
$Clean_HL = GUICtrlCreateCheckbox("Clean History and Logs", 20, 155, 182, 17)
$Clean_List = GUICtrlCreateCheckbox("Also Clear Download List", 20, 180, 212, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group2 = GUICtrlCreateGroup("Clean Mode", 5, 5, 245, 55)
$Custom_Clean = GUICtrlCreateRadio("Custom Clean", 17, 29, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Full_Clean = GUICtrlCreateRadio("Full Clean", 167, 29, 113, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button_Clean = GUICtrlCreateButton("Clean Now", 5, 215, 100, 30)
$Progress1 = GUICtrlCreateProgress(115, 220, 135, 22)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###


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

$DwnlData_Folder = $TempPath & "DwnlData"
$Grabber_Folder = $TempPath & "Grabber"
$GrabberData_Folder = $TempPath & "GrabberData"
$Scheduler_Folder = $TempPath & "Scheduler"

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Clena_DD
		Case $Clean_GD
		Case $Clean_SD
		Case $Clean_HL
		Case $Clean_List

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
				FileDelete($TempPath)
				If GUICtrlRead($Clean_List) = $GUI_CHECKED Then
					RegDelete($regkey_x86_IDM)
				EndIf
			Else
				If GUICtrlRead($Clena_DD) = $GUI_CHECKED Then FileDelete($DwnlData_Folder)
				If GUICtrlRead($Clean_GD) = $GUI_CHECKED Then
					FileDelete($Grabber_Folder)
					FileDelete($GrabberData_Folder)
				EndIf
				If GUICtrlRead($Clean_SD) = $GUI_CHECKED Then FileDelete($Scheduler_Folder)
				If GUICtrlRead($Clean_HL) = $GUI_CHECKED Then FileDelete($DwnlData_Folder)

				If GUICtrlRead($Clean_List) = $GUI_CHECKED Then
					If GUICtrlRead($Clena_DD) = $GUI_CHECKED Then
						Local $i = 1
						Local $no = 1
						Local $Flag1 = 0

						While 1
							Local $var = RegEnumKey("HKEY_CURRENT_USER\Software\DownloadManager", $i)
							If @error <> 0 Then ExitLoop
							Local $LocalFileName = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "LocalFileName")
							If Not @error Then
								RegDelete("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var)
								$i += 1
								$no += 1
							EndIf
						WEnd
					EndIf
					EndIf








;~ 					If GUICtrlRead($Clean_GD) = $GUI_CHECKED Then
;~ 					If GUICtrlRead($Clean_SD) = $GUI_CHECKED Then
;~ 					If GUICtrlRead($Clean_HL) = $GUI_CHECKED Then


				EndIf
;### Tidy Error -> "endswitch" is closing previous "case" on line 67
		EndSwitch
;### Tidy Error -> "wend" is closing previous "switch" on line 66
	WEnd


;### Tidy Error -> while is never closed in your script.
