
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

#Region    ;************ Includes ************
#include-once
#Include <GuiListView.au3>
#EndRegion ;************ Includes ************

; #FUNCTION# =========================================================================================================
; Name...........: _GUICtrlListView_SaveCSV()
; Description ...: Exports the details of a ListView to a .csv file.
; Syntax.........: _GUICtrlListView_SaveCSV($hListView, $sFile, [$sDelimiter = ",", $sQuote = '"']])
; Parameters ....: $hListView - Handle of the ListView.
;                  $sFile - FilePath, this should ideally use the filetype .csv e.g. @ScriptDir & "\Example.csv"
;                  $sDelimiter - [Optional] Delimiter to be used for the csv file. [Default = ,]
;                  $sQuote - [Optional] Style of quotes to be used for the csv file. [Default = "]
; Requirement(s).: v3.2.12.1 or higher
; Return values .: Success - Returns filepath.
;                  Failure - Returns filepath & sets @error = 1
; Author ........: guinness & ProgAndy for the csv idea.
; Example........; Yes
;=====================================================================================================================
Func _GUICtrlListView_SaveCSV($hListView, $sFile, $sDelimiter = ",", $sQuote = '"')
	Local $hFileOpen, $iError = 0, $sItem, $sString
	Local $iColumnCount = _GUICtrlListView_GetColumnCount($hListView)
	Local $iItemCount = _GUICtrlListView_GetItemCount($hListView)

	For $A = 0 To $iItemCount - 1
		For $B = 0 To $iColumnCount - 1
			$sItem = _GUICtrlListView_GetItemText($hListView, $A, $B)
			$sString &= $sQuote & StringReplace($sItem, $sQuote, $sQuote & $sQuote, 0, 1) & $sQuote
			If $B < $iColumnCount - 1 Then
				$sString &= $sDelimiter
			EndIf
		Next
		$sString &= @CRLF
	Next
	$hFileOpen = FileOpen($sFile, 2)
	FileWrite($hFileOpen, $sString)
	FileClose($hFileOpen)
	If @error Then
		$iError = 1
	EndIf
	Return SetError($iError, 0, $sFile)
EndFunc   ;==>_GUICtrlListView_SaveCSV
