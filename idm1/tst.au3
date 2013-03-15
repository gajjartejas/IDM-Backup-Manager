$key = RegRead("HKEY_CURRENT_USER\Software\DownloadManager", "AppDataIDMFolder")
$Saved_path = FileSelectFolder("Choose a folder to save backup...", "")
MsgBox(16, "Error", "7z.exe" & " " & "a" & " " & $Saved_path & "\" & "IDMBACKUP.7z" & " " & $key)

$i = 0
$P = 0
$days = StringSplit($Saved_path, "\")
$result = StringInStr("I am a String", " ")
While 1
	;MsgBox(0, "New string is", $days[$i])
	If StringInStr($days[$i], Chr(32)) Then $days[$i] = '"' & $days[$i] & '"'
	If StringInStr($days[$i], Chr(32)) Then $P = $P + 1
	If $i = $days[0] Then ExitLoop
	$i = $i + 1
WEnd

$i = 2
$c_Saved_Path = $days[1] & ""
While 1
	$c_Saved_Path = $c_Saved_Path & "\" & $days[$i]
	If $i = $days[0] Then ExitLoop
	$i = $i + 1
WEnd
MsgBox(0, "DONE", $c_Saved_Path)

