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
; Return values .: Success - 1
;                  Failure - 0
; Author ........: Shafayat (sss13x@yahoo.com)
; Example .......: Yes
; ===============================================================================================================================

Func _IsFilePathValid($Path)
	;List of invalid characters
	Local $Excluded[8] = [7, "\\", "?", "*", '"', "<", ">", "|"]
	Local $Alphabet = StringSplit("ABCDEFGHIJKLMNOPQRSTUVWXYZ", "")
	Local $Valid = 1

	; Lenght Check
	If StringLen($Path) < 3 Then $Valid = 0

	; Drive Check
	If StringInStr($Path, ":\") <> 2 Then
		$Valid = 0
	Else
		Local $chrdrv = StringUpper(StringLeft($Path, 1))
		Local $found = 0
		For $i = 0 To $Alphabet[0]
			If $chrdrv = $Alphabet[$i] Then
				$found = 1
			EndIf
		Next
		If $found = 0 Then
			$Valid = 0
		EndIf
	EndIf
	$Path = StringTrimLeft($Path, 3)
	; Path + Name Check
	For $i = 0 To $Excluded[0]
		If StringInStr($Path, $Excluded[$i]) <> 0 Then
			$Valid = 0
		EndIf
	Next
	Return $Valid
EndFunc   ;==>_IsFilePathValid