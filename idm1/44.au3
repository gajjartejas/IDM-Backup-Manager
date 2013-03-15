
$Backup_path = RegRead("HKEY_CURRENT_USER\Software\DownloadManager", "AppDataIDMFolder")
MsgBox(0, "DONE", $Backup_path)
MsgBox(0, "DONE", _7ZzPath($Backup_path))
MsgBox(0, "DONE", _7ZzPath($Backup_path))

Func _7ZzPath($Restore_path)
	Local $i = 0
	Local $P = 0
	$split_path = StringSplit($Restore_path, "\")
	While 1
		If StringInStr($split_path[$i], Chr(32)) Then $split_path[$i] = '"' & $split_path[$i] & '"'
		If StringInStr($split_path[$i], Chr(32)) Then $P = $P + 1
		If $i = $split_path[0] Then ExitLoop
		$i = $i + 1
	WEnd

	Local $i = 2
	Local $d_Saved_Path = $split_path[1] & ""
	While 1
		If $i = $split_path[0]  Then ExitLoop
		$d_Saved_Path = $d_Saved_Path & "\" & $split_path[$i]
		$i = $i + 1
	WEnd
	Return $d_Saved_Path
EndFunc   ;==>_7ZzPath
