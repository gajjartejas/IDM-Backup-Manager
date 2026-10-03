#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#region    ;************ Includes ************
#include-once
#include <GuiImageList.au3>
#include <GuiButton.au3>
#endregion    ;************ Includes ************

Global $g_aAET_IconFiles[24] = [ _
	"", _
	"Backup.ico", _
	"open.ico", _
	"Forum.ico", _
	"Help.ico", _
	"Internet.ico", _
	"License.ico", _
	"History.ico", _
	"Ok.ico", _
	"ok32.ico", _
	"Restore.ico", _
	"search.ico", _
	"Tool.ico", _
	"Update.ico", _
	"FileType.ico", _
	"Save.ico", _
	"Setting.ico", _
	"refresh.ico", _
	"Log.ico", _
	"StatusInfo.ico", _
	"StatusWarning.ico", _
	"StatusCompled.ico", _
	"StatusError.ico", _
	"StatusWorking.ico" _
]

Func _AET_GetResourcePath($sFileName)
	Local $ScriptDir = @ScriptDir
	If StringRight($ScriptDir, 1) <> "\" Then $ScriptDir &= "\"
	If FileExists($ScriptDir & "Resources\" & $sFileName) Then
		Return $ScriptDir & "Resources\" & $sFileName
	ElseIf FileExists($ScriptDir & "..\Resources\" & $sFileName) Then
		Return $ScriptDir & "..\Resources\" & $sFileName
	EndIf
	Return $ScriptDir & "Resources\" & $sFileName
EndFunc   ;==>_AET_GetResourcePath

Func _AET_ButtonSetIcon($hWnd, $iIndex, $iWidth, $iHeight, $iAlign)
	Local $hImageList = _GUIImageList_Create($iWidth, $iHeight, 5, 3)
	Local $iAdded = -1
	If $iIndex >= 1 And $iIndex <= 23 Then
		Local $sIconPath = _AET_GetResourcePath($g_aAET_IconFiles[$iIndex])
		If FileExists($sIconPath) Then
			$iAdded = _GUIImageList_AddIcon($hImageList, $sIconPath, 0, True)
		EndIf
	EndIf
	If $iAdded = -1 And @Compiled Then
		_GUIImageList_AddIcon($hImageList, @ScriptFullPath, $iIndex, True)
	EndIf
	_GUICtrlButton_SetImageList($hWnd, $hImageList, $iAlign)
EndFunc   ;==>_AET_ButtonSetIcon

Func _AET_TabSetIcon($iTabCtrl, $iIconIndex, $iResourceIndex = 0)
	Local $sIconPath = ""
	If $iIconIndex >= 1 And $iIconIndex <= 23 Then
		$sIconPath = _AET_GetResourcePath($g_aAET_IconFiles[$iIconIndex])
	EndIf
	If FileExists($sIconPath) Then
		GUICtrlSetImage($iTabCtrl, $sIconPath)
	ElseIf @Compiled And $iResourceIndex <> 0 Then
		GUICtrlSetImage($iTabCtrl, @ScriptFullPath, $iResourceIndex)
	EndIf
EndFunc   ;==>_AET_TabSetIcon