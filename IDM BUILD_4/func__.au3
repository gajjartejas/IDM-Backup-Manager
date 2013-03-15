Func _7Zip_Rename($name_of_archive, $File_Name, $File_New_Name);7z rn a.7z old.txt new.txt 2.txt folder\2new.txt
	If $File_Name = "" Then
		Return SetError(1, 0, 0)
	EndIf
	If $File_New_Name = "" Then
		Return SetError(1, 0, 0)
	EndIf
	If FileExists($name_of_archive) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	Return RunWait(@ScriptDir & "\7z.exe" & " " & "rn" & " " & '"' & $name_of_archive & '"' & " " & $File_Name & " " & $File_New_Name, "") ;, @SW_HIDE
EndFunc   ;==>_7Zip_Rename

; #FUNCTION# ====================================================================================================================
; Name...........:  _Path_Last_Remove
; Description....:  Remove the last path
; Syntax.........:  _Path_Last_Remove($Restore_path)
; Parameters.....:  $Restore_path - "c:\dir1\dir2"
;					$sDestinationFolder - "c:\dir1\dir2\"
; Return values..:  Success - Return Path
;				    Failure -
; Author.........:  Gajjar Tejas
; Modified.......:
; Remarks........:

; Related........:
; Link...........:
; Example........: _Path_Last_Remove(""C:\test path\test path1"")
; Output..........; "C:\test path\"
Func _Path_Last_Remove($Restore_path)
	Local $d_Saved_Path = ""
	If StringRight($Restore_path, 1) <> "\" Then
		$Restore_path &= "\"
	EndIf
	$split_path = StringSplit($Restore_path, "\")
	If @error = 1 Then
		Return $Restore_path
	ElseIf $split_path[0] = 2 Then
		Return $Restore_path
	Else
		For $i = 1 To $split_path[0] - 2 Step 1
			$d_Saved_Path &= $split_path[$i] & "\"
		Next
		Return $d_Saved_Path
	EndIf
EndFunc   ;==>_Path_Last_Remove