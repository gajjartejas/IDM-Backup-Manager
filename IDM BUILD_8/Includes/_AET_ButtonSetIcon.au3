#Region    ;************ Includes ************
#include-once
#Include <GuiImageList.au3>
#Include <GuiButton.au3>
#EndRegion ;************ Includes ************

Func _AET_ButtonSetIcon($hWnd, $iIndex, $iWidth, $iHeight, $iAlign)
	Local $hImageList = _GUIImageList_Create($iWidth, $iHeight, 5, 3)
	_GUIImageList_AddIcon($hImageList, @ScriptFullPath, $iIndex, True)
	_GUICtrlButton_SetImageList($hWnd, $hImageList, $iAlign)
EndFunc   ;==>__AET_ButtonSetIcon