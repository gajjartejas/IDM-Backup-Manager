#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include-once

; #INDEX# =======================================================================================================================
; Title .........: GUI Fading Script
; Description ...: This module contains functions used to fade a GUI in and out with pure AutoIt code.
; AutoIt Version.: 3.3.0.0 (Current Release)
; Author ........: Insignia96 (iWoW Programming)
; ===============================================================================================================================


; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implimented at this time
; ===============================================================================================================================
; NONE
; ===============================================================================================================================

; ===============================================================================================================================
; #CURRENT# =====================================================================================================================
;_FadeGUIIn
;_FadeGUIOut
; ===============================================================================================================================


; #DECLARES# ;===============================================================================
;
Global $GUIFADE_MAXTRANS = 255 ; the current max transparency level
;
; ;==========================================================================================

; #FUNCTION# ;===============================================================================
;
; Name...........: _FadeGUIIn
; Description ...: Gradually shows a GUI.
; Syntax.........: _FadeGUIIn( $hWnd )
; Parameters ....: $hWnd - Handle to GUI you wish to fade in.
;                  $iMax - The transparency level to stop at. (0-255, 0 = hidden, 255 = fully shown)
; Return values .: None
; Author ........: Insignia96 (iWoW Programming)
; Modified.......: Saturday, December 12, 2009
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================

Func _FadeGUIIn($hWnd,$iMax=255)

    $GUIFADE_MAXTRANS = $iMax

    WinSetTrans($hWnd, "", 0)

    GUISetState(@SW_SHOW)

    Local $delay = 0

    For $i = 1 To $iMax Step 1
        WinSetTrans($hWnd, "", $i)
        Sleep($delay)
    Next

EndFunc   ;==>_FadeGUIIn

; #FUNCTION# ;===============================================================================
;
; Name...........: _FadeGUIOut
; Description ...: Gradually fades a GUI out.
; Syntax.........: _FadeGUIOut( $hWnd )
; Parameters ....: $hWnd - Handle to GUI you wish to fade out.
; Return values .: None
; Author ........: Insignia96 (iWoW Programming)
; Modified.......: Saturday, December 12, 2009
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================

Func _FadeGUIOut($hWnd)
    Local $delay = 0

    For $i = $GUIFADE_MAXTRANS To 0 Step -1
        WinSetTrans($hWnd, "", $i)
        Sleep($delay)
    Next

    GUISetState(@SW_HIDE)
EndFunc   ;==>_FadeGUIOut