; #FUNCTION# ====================================================================================================================
; Name ..........: _MoveDirEx
; Description ...:
; Syntax ........: _MoveDirEx($source, $dest)
; Parameters ....: $source              - a string value.
;                  $dest                - a binary variant value.
; Return values .: -1					- file move error
;  				   -2					- no file found in folder
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

	FileMove($source & "\*.*", $dest, 1 + 8) ;Move all source files first
	If @error Then Return -1
	$hSearch = FileFindFirstFile($source & "\*.*") ;Now find any remaining (in this case: folders)

	If $hSearch = -1 Then
		Return -2 ;No folders
	EndIf

	While 1
		$hFilename = FileFindNextFile($hSearch)
		If @error Then ExitLoop ;No more files
		DirMove($source & "\" & $hFilename, $dest, 1);move subdir and all contents to new location
	WEnd

	Return 1

EndFunc   ;==>_MoveDirEx

