#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#region    ;************ Includes ************
#include-once
#endregion    ;************ Includes ************
; #INDEX# =======================================================================================================================
; Title .........: _FileIsPathValid UDF
; AutoIt Version : 3.3.6+
; Language ......: English
; Description ...: Functions for checking if a File/Directory Path is Valid
; Author(s) .....: Shafayat (sss13x@yahoo.com)
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _FileIsPathValid()
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _FileIsPathValid
; Description ...: checks if a File/Directory Path is Valid
; Syntax.........: _FileIsPathValid($Path, $Verbose = 0)
; Parameters ....: $Path - File/Directory Path to work with
;                  $Verbose  - OutPut (ConsoleWrite) additional information of invalidity of Path
;				   |0 - No OutPut
;				   |1 - OutPut to Console if Not Compiled
;				   |1 - OutPut to Console Always
; Return values .: Success - True
;                  Failure - False
; Author ........: Shafayat (sss13x@yahoo.com)
; Example .......: Yes
; ===============================================================================================================================

Func _IsFilePathValid($Path)
	Local $Excluded[8] = [7, "\\", "?", "*", '"', "<", ">", "|"] ;List of invalid characters
	Local $Alphabet = StringSplit("ABCDEFGHIJKLMNOPQRSTUVWXYZ", "")
	Local $Reasons = ""
	Local $Valid = True
	; Lenght Check
	If StringLen($Path) < 3 Then
		$Reasons = $Reasons & @CRLF & "LENGTH: Entire Pathname must be more than 3 characters (including drive)."
		$Valid = False
	EndIf
	; Drive Check
	Local $pos = StringInStr($Path, ":\")
	If $pos <> 2 Then
		$Reasons = $Reasons & @CRLF & 'STRUCTURE: Drive letter must be one chars long and must be followed by ":\".'
		$Valid = False
	Else
		Local $chrdrv = StringUpper(StringLeft($Path, 1))
		Local $found = 0
		For $i = 0 To $Alphabet[0]
			If $chrdrv = $Alphabet[$i] Then
				$found = 1
			EndIf
		Next
		If $found = 0 Then
			$Reasons = $Reasons & @CRLF & "ILLEGAL CHARACTER: Illegal character used as drive letter."
			$Valid = False
		EndIf
	EndIf
	$Path = StringTrimLeft($Path, 3)
	; Path + Name Check
	For $i = 0 To $Excluded[0]
		If StringInStr($Path, $Excluded[$i]) <> 0 Then
			$Reasons = $Reasons & @CRLF & "ILLEGAL CHARACTER: " & $Excluded[$i]
			$Valid = False
		EndIf
	Next
	Return $Valid
EndFunc   ;==>_IsFilePathValid