#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Func _ProgressMarquee_Start($iControlID)
	GUICtrlSetStyle($iControlID, BitOR($PBS_SMOOTH, $PBS_MARQUEE, $WS_TABSTOP))
	Return GUICtrlSendMsg($iControlID, $PBM_SETMARQUEE, 1, 10)
EndFunc   ;==>_ProgressMarquee_Start

Func _ProgressMarquee_Stop($iControlID, $iReset = 0)
	GUICtrlSendMsg($iControlID, $PBM_SETMARQUEE, 1, 10)
	Local $iReturn = GUICtrlSendMsg($iControlID, $PBM_SETMARQUEE, 0, 50)
	If $iReset Then
		GUICtrlSetStyle($iControlID, BitOR($PBS_SMOOTH, $WS_TABSTOP))
	EndIf
	Return $iReturn
EndFunc   ;==>_ProgressMarquee_Stop