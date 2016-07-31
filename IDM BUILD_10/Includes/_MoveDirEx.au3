#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

; #FUNCTION# ====================================================================================================================
; Name ..........: _MoveDirEx
; Description ...:
; Syntax ........: _MoveDirEx($source, $dest)
; Parameters ....: $source              - a string value.
;                  $dest                - a binary variant value.
; Return values .: -1					- Counld not create dest dir
;				   -2					- file move error
;  				   -3					- no file found in folder
;				    1					- success
; Author ........: Tejas Gajjar
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _MoveDirEx($source, $dest)

;~ 	$FC_NOOVERWRITE (0) = (default) do not overwrite existing files.
;~  $FC_OVERWRITE (1) = overwrite existing files.
;~  $FC_CREATEPATH (8) = Create destination directory structure if it doesn't exist (See Remarks).

	If Not FileExists($dest) Then
		If Not DirCreate($dest) Then
			Return -1
		EndIf
	EndIf

	FileMove($source & "\*.*", $dest, 1 + 8) ;Move all source files first
	If @error Then Return -2
	Local $hSearch = FileFindFirstFile($source & "\*.*") ;Now find any remaining (in this case: folders)

	If $hSearch = -1 Then
		Return -3 ;No folders
	EndIf

	While 1
		Local $hFilename = FileFindNextFile($hSearch)
		If @error Then ExitLoop ;No more files
		DirMove($source & "\" & $hFilename, $dest, 1);move subdir and all contents to new location
	WEnd

	Return 0

EndFunc   ;==>_MoveDirEx

