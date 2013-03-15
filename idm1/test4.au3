			$i = 0
			$P = 0
			$split_path = StringSplit($Restore_path, "\")
			While 1
				If StringInStr($split_path[$i], Chr(32)) Then $split_path[$i] = '"' & $split_path[$i] & '"'
				If StringInStr($split_path[$i], Chr(32)) Then $P = $P + 1
				If $i = $split_path[0] Then ExitLoop
				$i = $i + 1
			WEnd

			$i = 2
			$d_Saved_Path = $split_path[1] & ""
			While 1
				$d_Saved_Path = $d_Saved_Path & "\" & $split_path[$i]
				If $i = $split_path[0] Then ExitLoop
				$i = $i + 1
			WEnd
			MsgBox(0, "DONE", $d_Saved_Path)