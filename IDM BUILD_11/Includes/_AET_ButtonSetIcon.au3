#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#region    ;************ Includes ************
#include-once
#include <GuiImageList.au3>
#include <GuiButton.au3>
#endregion    ;************ Includes ************

Func _AET_ButtonSetIcon($hWnd, $iIndex, $iWidth, $iHeight, $iAlign)
	Local $hImageList = _GUIImageList_Create($iWidth, $iHeight, 5, 3)
	_GUIImageList_AddIcon($hImageList, @ScriptFullPath, $iIndex, True)
	_GUICtrlButton_SetImageList($hWnd, $hImageList, $iAlign)
EndFunc   ;==>_AET_ButtonSetIcon