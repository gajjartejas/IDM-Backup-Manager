#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

#region    ;************ Includes ************
#include-once
#include "_AppsFun.au3"
#include <GuiStatusBar.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPITheme.au3>
#include <GuiMenu.au3>
#include "_GUICtrlListView_SaveHTML.au3"
#include "_GUICtrlListView_SaveCSV.au3"
#include "_AppsConstant.au3"
#endregion    ;************ Includes ************

#region Export Function
Func _Expert_HTML()
	Local $join_file = FileSaveDialog("Save Your File", $s_Backup_Dir, "webpage (*.htm)", 16, "Download_List.htm")
	If @error Then Return -1
	If $join_file <> "" And StringRight($join_file, 4) <> ".htm" Then $join_file &= ".htm"

	If FileExists($join_file) Then
		If FileDelete($join_file) = 0 Then
			MsgBox(48, "Error", "Could Not Delete: " & $join_file, 0, $hGUI_LM)
			_Expert_HTML()
		EndIf
	EndIf

	_Disable_Controls()
	_GUICtrlListView_SaveHTML($hListView, $join_file, "")
	_Enable_Controls()

	ShellExecute($join_file)
EndFunc   ;==>_Expert_HTML

Func _Expert_CSV()
	Local $join_file = FileSaveDialog("Save Your File", $s_Backup_Dir, "Comma Separated Values (*.csv)", 16, "Download_List.csv")
	If @error Then Return -1
	If $join_file <> "" And StringRight($join_file, 4) <> ".csv" Then $join_file &= ".csv"

	If FileExists($join_file) Then
		If FileDelete($join_file) = 0 Then
			MsgBox(48, "Error", "Could Not Delete: " & $join_file, 0, $hGUI_LM)
			_Expert_CSV()
		EndIf
	EndIf
	_Disable_Controls()
	_GUICtrlListView_SaveCSV($hListView, $join_file)
	_Enable_Controls()

	ShellExecute($join_file)
EndFunc   ;==>_Expert_CSV

Func _Expert_IDM_LIST()
	Local $join_file = FileSaveDialog("Save Your File", $s_Backup_Dir, "IDM Export File (*.ef2)", 16, "Download_List.ef2")
	If @error Then Return -1
	If $join_file <> "" And StringRight($join_file, 4) <> ".ef2" Then $join_file &= ".ef2"

	If FileExists($join_file) Then
		If FileDelete($join_file) = 0 Then
			MsgBox(48, "Error", "Could Not Delete: " & $join_file, 0, $hGUI_LM)
			_Expert_IDM_LIST()
		EndIf
	EndIf
	_Disable_Controls()

	Local $i = 0, $var
	For $i = 0 To _GUICtrlListView_GetItemCount($hListView) - 1
		_GUICtrlStatusBar_SetText($h_Status_Info_LM, "Experting: " & $i & " " & "Please Wait...")
		$var = _GUICtrlListView_GetItemText($hListView, $i, 4)
		Local $var_Url0 = _RegRead($s_regpath_IDM & "\" & $var, "Url0") & @CRLF
		If @error Then $var_Url0 = ""
		Local $var_Referer = "referer: " & _RegRead($s_regpath_IDM & "\" & $var, "Referer") & @CRLF
		If @error Then $var_Referer = ""
		Local $var_cookie = "cookie: " & _RegRead($s_regpath_IDM & "\" & $var, "Cookie") & @CRLF
		If @error Then $var_cookie = ""
		If $var_Url0 <> "" Then
			FileWrite($join_file, "<" & @CRLF)
			FileWrite($join_file, $var_Url0)
			FileWrite($join_file, $var_Referer)
			FileWrite($join_file, $var_cookie)
			FileWrite($join_file, ">" & @CRLF)
		EndIf
	Next
	_GUICtrlStatusBar_SetText($h_Status_Info_LM, "Ready")

	_Enable_Controls()
EndFunc   ;==>_Expert_IDM_LIST

Func _Expert_IDM_TXT()
	Local $join_file = FileSaveDialog("Save Your File", $s_Backup_Dir, "Plain Text File (*txt)", 16, "Download_List.txt")
	If @error Then Return -1
	If $join_file <> "" And StringRight($join_file, 4) <> ".txt" Then $join_file &= ".txt"

	If FileExists($join_file) Then
		If FileDelete($join_file) = 0 Then
			MsgBox(48, "Error", "Could Not Delete: " & $join_file, 0, $hGUI_LM)
			_Expert_IDM_TXT()
		EndIf
	EndIf
	_Disable_Controls()
	Local $var
	For $i = 0 To _GUICtrlListView_GetItemCount($hListView) - 1
		$var = _GUICtrlListView_GetItemText($hListView, $i, 4)
		_GUICtrlStatusBar_SetText($h_Status_Info_LM, "Experting: " & $i & " " & "Please Wait...")
		Local $var_Url0 = _RegRead($s_regpath_IDM & "\" & $var, "Url0")
		If @error Then $var_Url0 = ""
		If $var_Url0 <> "" Then
			FileWriteLine($join_file, $var_Url0)
		EndIf
	Next
	_GUICtrlStatusBar_SetText($h_Status_Info_LM, "Ready")
	_Enable_Controls()
EndFunc   ;==>_Expert_IDM_TXT
#endregion Export Function

#region Windows Messages
Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iCode, $tNMHDR, $hWndListView, $tInfo, $B_DESCENDING
;~ 	Local $iIDFrom
	$hWndListView = $hListView
	If Not IsHWnd($hListView) Then $hWndListView = GUICtrlGetHandle($hListView)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
;~ 	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode

				Case $LVN_ITEMCHANGING
					$fChange = True

				Case $LVN_COLUMNCLICK ; A column was clicked
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					_GUICtrlListView_SimpleSort($hWndListView, $B_DESCENDING, DllStructGetData($tInfo, "SubItem"))
					; No return value

				Case $LVN_KEYDOWN ; A key has been pressed
					$tInfo = DllStructCreate($tagNMLVKEYDOWN, $ilParam)
					; No return value

				Case $NM_CLICK ; Sent by a list-view control when the user clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					; No return value

				Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_Open_Folder()

					; No return value

				Case $NM_RCLICK ; Sent by a list-view control when the user clicks an item with the right mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					ListView_RClick()

					Return 0 ; allow the default processing
				Case $NM_RDBLCLK ; Sent by a list-view control when the user double-clicks an item with the right mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)

					; No return value
				Case $NM_RETURN ; The control has the input focus and that the user has pressed the ENTER key

					; No return value
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func WM_GETMINMAXINFO($hWnd, $Msg, $WPARAM, $lParam)
	#forceref $hWnd,$Msg,$WPARAM
	Local $tagMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
	DllStructSetData($tagMaxinfo, 7, $i_xWidth_LM) ; min X
	DllStructSetData($tagMaxinfo, 8, $i_yHight_LM) ; min Y
	Return 0
EndFunc   ;==>WM_GETMINMAXINFO

Func MY_WM_SIZE($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam, $ilParam
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>MY_WM_SIZE

#endregion Windows Messages

#region Events
Func _SwGrid()
	If BitAND(GUICtrlRead($MenuItem_View_SwGrid), $GUI_CHECKED) Then
		GUICtrlSetState($MenuItem_View_SwGrid, $GUI_UNCHECKED)
		_GUICtrlListView_SetExtendedListViewStyle($idListView, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_DOUBLEBUFFER, $LVS_EX_HEADERDRAGDROP))
	Else
		_GUICtrlListView_SetExtendedListViewStyle($idListView, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER, $LVS_EX_HEADERDRAGDROP))
		GUICtrlSetState($MenuItem_View_SwGrid, $GUI_CHECKED)
	EndIf
EndFunc   ;==>_SwGrid

Func _Auto_Arrange()
	_GUICtrlListView_SetColumnWidth($idListView, 0, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
	_GUICtrlListView_SetColumnWidth($idListView, 1, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
	_GUICtrlListView_SetColumnWidth($idListView, 2, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
	_GUICtrlListView_SetColumnWidth($idListView, 3, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
	_GUICtrlListView_SetColumnWidth($idListView, 4, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
EndFunc   ;==>_Auto_Arrange

Func _Join_Fragments()
	_Disable_Controls()

	Local $sChunk = ""
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($idListView, "id")), "|")
	Local $LocalFileName = _Name_Get_From_Path(_RegRead($s_regpath_IDM & "\" & $ID[5], "LocalFileName"))
	Local $FileExt = _Ext_Get_From_Path(_RegRead($s_regpath_IDM & "\" & $ID[5], "LocalFileName"))
	Local $LocalPath = _RegRead($s_regpath_IDM & "\" & $ID[5], "LocalPath")

	Local $search = FileFindFirstFile($LocalPath & $LocalFileName & $FileExt & "*")
	Local $search_ = FileFindFirstFile($LocalPath & $LocalFileName & $FileExt & "*")
	Local $total_frag_file = 0

	Local $iBuffer = 10 * 1024 * 1024 ;read 10 MB  at a time
	Local $b = 1, $pattern

	While 1
		FileFindNextFile($search)
		If @error Then ExitLoop
		$total_frag_file += 1
	WEnd
	FileClose($search)

	If $total_frag_file < 2 Then
		_Enable_Controls()
		Return -2
	EndIf

	If $FileExt = "" Then
		$pattern = "Unknown File (*.*)"
	Else
		$pattern = "Known File (*" & $FileExt & ")"
	EndIf

	Local $join_file = FileSaveDialog("Save Your File", $s_Backup_Dir, $pattern, 16, $LocalFileName & $FileExt)
	If @error Then
		_Enable_Controls()
		Return -1
	EndIf

	Local $LocalFileName_, $file_join
	While 1
		$LocalFileName_ = FileFindNextFile($search_)
		If @error Then ExitLoop
		$file_join = FileOpen($LocalPath & "\" & $LocalFileName_, 0)
		While 1
			$sChunk = FileRead($file_join, $iBuffer)
			If @error = -1 Then ExitLoop
			FileWrite($join_file, $sChunk)
			_GUICtrlStatusBar_SetText($h_Status_Info_LM, "Joining Segment: " & $b & " " & "Please Wait...")
		WEnd
		FileClose($file_join)
		$b += 1
	WEnd
	FileClose($search)
	_GUICtrlStatusBar_SetText($h_Status_Info_LM, "DONE")
	_Enable_Controls()
EndFunc   ;==>_Join_Fragments

Func _Details()
	Local $avArray[2][6]
	Local $avArray1[6]
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($idListView, "id")), "|")
;~ 	$avArray1[0] = _RegRead($s_regpath_IDM & "\" & $ID[5], "FileName") ;Name:
;~ 	$avArray1[1] = _RegRead($s_regpath_IDM & "\" & $ID[5], "LocalFileName") ;Path:
;~ 	$avArray1[2] = _RegRead($s_regpath_IDM & "\" & $ID[5], "LastModified") ;Last Modified:
;~ 	$avArray1[3] = _RegRead($s_regpath_IDM & "\" & $ID[5], "lastTryDate") ;Last Try Date:
;~ 	$avArray1[4] = _RegRead($s_regpath_IDM & "\" & $ID[5], "Referer") ;Referer URL:
;~ 	$avArray1[5] = _RegRead($s_regpath_IDM & "\" & $ID[5], "Url0") ;Download Link:
$avArray1[	1	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "LocalFileName") ;Download Link:
$avArray1[	2	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "LocalPath") ;Download Link:
$avArray1[	3	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "LogFileName") ;Download Link:
$avArray1[	4	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "Host") ;Download Link:
$avArray1[	5	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "Path") ;Download Link:
$avArray1[	6	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "FileName") ;Download Link:
$avArray1[	7	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "User") ;Download Link:
$avArray1[	8	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "EncPassword") ;Download Link:
$avArray1[	9	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "UA") ;Download Link:
$avArray1[	10	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "Referer") ;Download Link:
$avArray1[	11	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "Cookie") ;Download Link:
$avArray1[	12	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "TPswitch") ;Download Link:
$avArray1[	13	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "Port") ;Download Link:
$avArray1[	14	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "categoryID") ;Download Link:
$avArray1[	15	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "CISBU") ;Download Link:
$avArray1[	16	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "cFlags") ;Download Link:
$avArray1[	17	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "cFromDll") ;Download Link:
$avArray1[	18	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "FRCType") ;Download Link:
$avArray1[	19	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "owWPage") ;Download Link:
$avArray1[	20	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "Url0") ;Download Link:
$avArray1[	21	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "FRFileSize") ;Download Link:
$avArray1[	22	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "AccLngH") ;Download Link:
$avArray1[	23	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "AccH") ;Download Link:
$avArray1[	24	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "st_time") ;Download Link:
$avArray1[	25	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "dateAdded") ;Download Link:
$avArray1[	26	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "Status") ;Download Link:
$avArray1[	27	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "queueID") ;Download Link:
$avArray1[	28	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "lastTryDate") ;Download Link:
$avArray1[	29	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "U0_c") ;Download Link:
$avArray1[	30	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "U0_u") ;Download Link:
$avArray1[	31	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "U0_EncP") ;Download Link:
$avArray1[	32	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "bOUD_Ch") ;Download Link:
$avArray1[	33	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "EncLNFSW") ;Download Link:
$avArray1[	34	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "FR_FNCD") ;Download Link:
$avArray1[	35	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "bGICompl") ;Download Link:
$avArray1[	36	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "bRetAfFR") ;Download Link:
$avArray1[	37	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "FileSize") ;Download Link:
$avArray1[	38	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "Downloaded") ;Download Link:
$avArray1[	39	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "Speed") ;Download Link:
$avArray1[	40	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "needER") ;Download Link:
$avArray1[	41	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "fGDFE") ;Download Link:
$avArray1[	42	]=	 _RegRead($s_regpath_IDM & "\" & $ID[5], "bSaved") ;Download Link:

	Local $avArray[2][6] = [["Name", "Path", "Last Modified", "Last Try Date", "Referer URL", "Download Link"],[$avArray1[0], $avArray1[1], $avArray1[2], $avArray1[3], $avArray1[4], $avArray1[5]]]

	_ArrayDisplay($avArray, "Properites", 6, 1)
EndFunc   ;==>_Details

Func _Open_Folder()
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($idListView, "id")), "|")
	If _GUICtrlListView_GetSelectedCount($hListView) > 0 Then
		Local $FileName = _RegRead($s_regpath_IDM & "\" & $ID[5], "LocalPath")
		If FileExists($FileName) Then ShellExecute($FileName)
	EndIf
EndFunc   ;==>_Open_Folder

Func _Analyze()
	_Disable_Controls()
	_GUICtrlListView_BeginUpdate($idListView)
	_GUICtrlListView_DeleteAllItems($idListView)
	Local $i = 1
	Local $no = 1
	Local $s_current_selectde_cat = _get_selected_cat()
	Local $i_TotalKey = _CountKey($s_regpath_IDM)

	While 1
		_GUICtrlStatusBar_SetText($h_Status_Info_LM, "Analyzing: " & "Please Wait..." & Round($i / $i_TotalKey * 100) & "%")

		Local $var = RegEnumKey($s_regpath_IDM, $i)
		If @error <> 0 Then ExitLoop

		Local $LocalFileName = _RegRead($s_regpath_IDM & "\" & $var, "LocalFileName")
		If @error <> 0 Then
			$i += 1
			ContinueLoop
		EndIf

		Local $var_MIME = _RegRead($s_regpath_IDM & "\" & $var, "FRCType")
		Local $FileSize = Number(_RegRead($s_regpath_IDM & "\" & $var, "FileSize"))
		Local $var_Url0 = _RegRead($s_regpath_IDM & "\" & $var, "Url0")
		Local $cat_id = _RegRead($s_regpath_IDM & "\" & $var, "categoryID")
		Local $status = _RegRead($s_regpath_IDM & "\" & $var, "Status")

		If BitAND(GUICtrlRead($MenuItem_View_Categories_list_CatArray), $GUI_CHECKED) Then
			If BitAND(GUICtrlRead($MenuItem_View_List_AllDownloads), $GUI_CHECKED) Then
				GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $idListView)
				$no += 1
			ElseIf BitAND(GUICtrlRead($MenuItem_View_List_FinishedDownloads), $GUI_CHECKED) Then
				If $status = 3 Then
					GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $idListView)
					$no += 1
				EndIf
			ElseIf BitAND(GUICtrlRead($MenuItem_View_List_UnFinished), $GUI_CHECKED) Then
				If $status = 2 Or $status = 0 Then
					GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $idListView)
					$no += 1
				EndIf
			ElseIf BitAND(GUICtrlRead($MenuItem_View_List_UnFinished_Data), $GUI_CHECKED) Then
				If FileExists($LocalFileName) Then
					GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $idListView)
					$no += 1
				EndIf
			EndIf
			$i += 1
		Else
			If $s_current_selectde_cat = $cat_id Then
				If BitAND(GUICtrlRead($MenuItem_View_List_AllDownloads), $GUI_CHECKED) Then
					GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $idListView)
					$no += 1
				ElseIf BitAND(GUICtrlRead($MenuItem_View_List_FinishedDownloads), $GUI_CHECKED) Then
					If $status = 3 Then
						GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $idListView)
						$no += 1
					EndIf
				ElseIf BitAND(GUICtrlRead($MenuItem_View_List_UnFinished), $GUI_CHECKED) Then
					If $status = 2 Or $status = 0 Then
						GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $idListView)
						$no += 1
					EndIf
				ElseIf BitAND(GUICtrlRead($MenuItem_View_List_UnFinished_Data), $GUI_CHECKED) Then
					If FileExists($LocalFileName) Then
						GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $idListView)
						$no += 1
					EndIf
				EndIf
			EndIf
			$i += 1
		EndIf
	WEnd

	_GUICtrlListView_EndUpdate($idListView)
	_GUICtrlStatusBar_SetText($h_Status_Info_LM, "Ready")
	_Enable_Controls()
	Return $no
EndFunc   ;==>_Analyze

Func _Remove()
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($idListView, "id")), "|")
	Local $FileName = _RegRead($s_regpath_IDM & "\" & $ID[5], "LocalPath")
	Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(36, "Conform Delete", "Are you sure you want to delete selected downloads from IDM list of downloads?." & @CRLF & "Delete completely downloaded files from your hard disk as well. Be careful ! ", 0, $hGUI_LM)
	Select
		Case $iMsgBoxAnswer = 6 ;Yes
			If FileExists($FileName) Then FileDelete($FileName)
			RegDelete($s_regpath_IDM & "\" & $ID[5])
			_GUICtrlListView_DeleteItemsSelected($hListView)
		Case $iMsgBoxAnswer = 7 ;No
	EndSelect
EndFunc   ;==>_Remove

Func _Goto()
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($idListView, "id")), "|")
	Local $owWPage = _RegRead($s_regpath_IDM & "\" & $ID[5], "owWPage")
	Local $Referer = _RegRead($s_regpath_IDM & "\" & $ID[5], "Referer")

	If $owWPage <> "" And $Referer <> "" Then
		If $owWPage <> "" Then
			ShellExecute($owWPage)
		Else
			If $Referer <> "" Then
				ShellExecute($Referer)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_Goto

Func _Disable_Button()
	If $fChange Then
		If _GUICtrlListView_GetSelectedCount($hListView) = 0 Then
			If BitAND(GUICtrlRead($MenuItem_File_Selected_ForceJoin), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_File_Selected_ForceJoin, $GUI_DISABLE)
			If BitAND(GUICtrlRead($MenuItem_File_Selected_Properties), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_File_Selected_Properties, $GUI_DISABLE)
			If BitAND(GUICtrlRead($MenuItem_File_Selected_Remove), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_File_Selected_Remove, $GUI_DISABLE)
			If BitAND(GUICtrlRead($MenuItem_File_Selected_ExploreFolder), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_File_Selected_ExploreFolder, $GUI_DISABLE)
			If BitAND(GUICtrlRead($MenuItem_File_Selected_Goto), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_File_Selected_Goto, $GUI_DISABLE)
			If BitAND(GUICtrlRead($MenuItem_Edit_Remove), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_Edit_Remove, $GUI_DISABLE)
		Else
			Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($idListView, "id")), "|")
			Local $FileName = _RegRead($s_regpath_IDM & "\" & $ID[5], "LocalPath")
			Local $LocalFileName = _Name_Get_From_Path(_RegRead($s_regpath_IDM & "\" & $ID[5], "LocalFileName"))
			Local $FileExt = _Ext_Get_From_Path(_RegRead($s_regpath_IDM & "\" & $ID[5], "LocalFileName"))
			Local $LocalPath = _RegRead($s_regpath_IDM & "\" & $ID[5], "LocalPath")
			Local $owWPage = _RegRead($s_regpath_IDM & "\" & $ID[5], "owWPage")
			Local $Referer = _RegRead($s_regpath_IDM & "\" & $ID[5], "Referer")

			Local $search = FileFindFirstFile($LocalPath & $LocalFileName & $FileExt & "*")
			If $search = -1 Then
				GUICtrlSetState($MenuItem_File_Selected_ForceJoin, $GUI_DISABLE)
			Else
				GUICtrlSetState($MenuItem_File_Selected_ForceJoin, $GUI_ENABLE)
			EndIf

			GUICtrlSetState($MenuItem_File_Selected_Properties, $GUI_ENABLE)
			GUICtrlSetState($MenuItem_File_Selected_Remove, $GUI_ENABLE)
			GUICtrlSetState($MenuItem_Edit_Remove, $GUI_ENABLE)

			If FileExists($FileName) = 0 Then
				GUICtrlSetState($MenuItem_File_Selected_ExploreFolder, $GUI_DISABLE)
			Else
				GUICtrlSetState($MenuItem_File_Selected_ExploreFolder, $GUI_ENABLE)
			EndIf

			If $owWPage = "" And $Referer = "" Then
				GUICtrlSetData($MenuItem_File_Selected_Goto, "Goto")
				GUICtrlSetState($MenuItem_File_Selected_Goto, $GUI_DISABLE)
			Else
				GUICtrlSetState($MenuItem_File_Selected_Goto, $GUI_ENABLE)
				If $owWPage <> "" Then GUICtrlSetData($MenuItem_File_Selected_Goto, _Resize_Text($owWPage))
				If $Referer <> "" Then GUICtrlSetData($MenuItem_File_Selected_Goto, _Resize_Text($Referer))
			EndIf

		EndIf
		$fChange = False
	EndIf

	If _GUICtrlListView_GetItemCount($idListView) = 0 Then
		If BitAND(GUICtrlRead($MenuItem_Edit_Remove_All), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_Edit_Remove_All, $GUI_DISABLE)
		If BitAND(GUICtrlRead($MenuItem_Edit_Find), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_Edit_Find, $GUI_DISABLE)
		If BitAND(GUICtrlRead($MenuItem__Tools_Expert_asIDM), $GUI_ENABLE) Then GUICtrlSetState($MenuItem__Tools_Expert_asIDM, $GUI_DISABLE)
		If BitAND(GUICtrlRead($MenuItem_Tools_Expert_asText), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_Tools_Expert_asText, $GUI_DISABLE)
		If BitAND(GUICtrlRead($MenuItem__Tools_Expert_asHTML), $GUI_ENABLE) Then GUICtrlSetState($MenuItem__Tools_Expert_asHTML, $GUI_DISABLE)
		If BitAND(GUICtrlRead($MenuItem__Tools_Expert_asCSV), $GUI_ENABLE) Then GUICtrlSetState($MenuItem__Tools_Expert_asCSV, $GUI_DISABLE)
	Else
		If BitAND(GUICtrlRead($MenuItem_Edit_Remove_All), $GUI_DISABLE) Then GUICtrlSetState($MenuItem_Edit_Remove_All, $GUI_ENABLE)
		If BitAND(GUICtrlRead($MenuItem_Edit_Find), $GUI_DISABLE) Then GUICtrlSetState($MenuItem_Edit_Find, $GUI_ENABLE)
		If BitAND(GUICtrlRead($MenuItem__Tools_Expert_asIDM), $GUI_DISABLE) Then GUICtrlSetState($MenuItem__Tools_Expert_asIDM, $GUI_ENABLE)
		If BitAND(GUICtrlRead($MenuItem_Tools_Expert_asText), $GUI_DISABLE) Then GUICtrlSetState($MenuItem_Tools_Expert_asText, $GUI_ENABLE)
		If BitAND(GUICtrlRead($MenuItem__Tools_Expert_asHTML), $GUI_DISABLE) Then GUICtrlSetState($MenuItem__Tools_Expert_asHTML, $GUI_ENABLE)
		If BitAND(GUICtrlRead($MenuItem__Tools_Expert_asCSV), $GUI_DISABLE) Then GUICtrlSetState($MenuItem__Tools_Expert_asCSV, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_Disable_Button

Func _set_cat_to_menu()
	ReDim $MenuItem_list_Catagories_[_iCountKey($s_regpath_IDM) + 1]
	Local $i = 1
	While 1
		Local $var = RegEnumKey($s_regpath_IDM & "\FoldersTree\", $i)
		If @error Then ExitLoop
		$MenuItem_list_Catagories_[$i] = GUICtrlCreateMenuItem($var, $MenuItem_View_Categories_list_all, -1, 1)
		$i += 1
	WEnd
	Return $i
EndFunc   ;==>_set_cat_to_menu

Func _get_selected_cat()
	Local $i
	For $i = 0 To $i_Cat_Item - 1
		If BitAND(GUICtrlRead($MenuItem_list_Catagories_[$i]), $GUI_CHECKED) Then
			Return _RegRead($s_regpath_IDM & "\FoldersTree\" & GUICtrlRead($MenuItem_list_Catagories_[$i], 1), "ID")
		EndIf
	Next
EndFunc   ;==>_get_selected_cat

Func _Disable_Controls()
	GUISetCursor(15, -1, $hGUI_LM)
	GUICtrlSetState($idListView, $GUI_DISABLE)
	GUICtrlSetState($MenuItem_File, $GUI_DISABLE)
	GUICtrlSetState($MenuItem_Edit, $GUI_DISABLE)
	GUICtrlSetState($MenuItem_Tools, $GUI_DISABLE)
	GUICtrlSetState($MenuItem_View, $GUI_DISABLE)
	GUICtrlSetState($MenuItem_Help, $GUI_DISABLE)
EndFunc   ;==>_Disable_Controls

Func _Enable_Controls()
	GUISetCursor(-1, -1, $hGUI_LM)
	GUICtrlSetState($idListView, $GUI_ENABLE)

	GUICtrlSetState($MenuItem_File, $GUI_ENABLE)
	GUICtrlSetState($MenuItem_Edit, $GUI_ENABLE)
	GUICtrlSetState($MenuItem_Tools, $GUI_ENABLE)
	GUICtrlSetState($MenuItem_View, $GUI_ENABLE)
	GUICtrlSetState($MenuItem_Help, $GUI_ENABLE)
EndFunc   ;==>_Enable_Controls

Func ListView_RClick()
	Local $aHit
	$aHit = _GUICtrlListView_SubItemHitTest($hListView)
	If ($aHit[0] <> -1) Then
		; Create a standard popup menu
		; -------------------- To Do --------------------
		Local $hMenu = _GUICtrlMenu_CreatePopup()
		_GUICtrlMenu_AddMenuItem($hMenu, "Explore Folder", $idExplore)
		_GUICtrlMenu_AddMenuItem($hMenu, "Force Join", $idJoin)
		_GUICtrlMenu_AddMenuItem($hMenu, "Remove", $idRemove)
		_GUICtrlMenu_AddMenuItem($hMenu, "Goto", $idGoto)
		_GUICtrlMenu_AddMenuItem($hMenu, "Properties", $idDetails)

		; ========================================================================
		; goto action
		; ========================================================================
		Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($idListView, "id")), "|")
		Local $owWPage = _RegRead($s_regpath_IDM & "\" & $ID[5], "owWPage")
		Local $Referer = _RegRead($s_regpath_IDM & "\" & $ID[5], "Referer")
		Local $FileName = _RegRead($s_regpath_IDM & "\" & $ID[5], "LocalPath")
		Local $LocalFileName = _Name_Get_From_Path(_RegRead($s_regpath_IDM & "\" & $ID[5], "LocalFileName"))
		Local $FileExt = _Ext_Get_From_Path(_RegRead($s_regpath_IDM & "\" & $ID[5], "LocalFileName"))
		Local $LocalPath = _RegRead($s_regpath_IDM & "\" & $ID[5], "LocalPath")

		If $owWPage = "" And $Referer = "" Then
			_GUICtrlMenu_SetItemDisabled($hMenu, 3)
		Else
			If $owWPage <> "" Then _GUICtrlMenu_SetItemText($hMenu, 3, _Resize_Text($owWPage))
			If $Referer <> "" Then _GUICtrlMenu_SetItemText($hMenu, 3, _Resize_Text($Referer))
		EndIf

		If FileExists($FileName) = 0 Then _GUICtrlMenu_SetItemDisabled($hMenu, 0)

		Local $search = FileFindFirstFile($LocalPath & $LocalFileName & $FileExt & "*")
		If $search = -1 Then _GUICtrlMenu_SetItemDisabled($hMenu, 1)

		; ========================================================================
		; Shows how to capture the context menu selections
		; ========================================================================
		Switch _GUICtrlMenu_TrackPopupMenu($hMenu, $hListView, -1, -1, 1, 1, 2)
			Case $idExplore
				_Open_Folder()
			Case $idJoin
				If _Join_Fragments() = -2 Then MsgBox(48, "Error", "At Least 2 Fragment Required To Join It.", 0, $hGUI_LM)
			Case $idDetails
				_Details()
			Case $idRemove
				_Remove()
			Case $idGoto
				_Goto()
		EndSwitch
		_GUICtrlMenu_DestroyMenu($hMenu)
	EndIf
EndFunc   ;==>ListView_RClick

#endregion Events

Func _SwLMGUI()
	GUISetState(@SW_HIDE, $hGUI_BM)

	Local $sizea = WinGetPos($s_Win_Title_BM)
	If @error Then
		;If windows not Found Place it to centre
		Local $size[2] = [(@DesktopWidth - $i_xWidth_LM) / 2, (@DesktopHeight - $i_yHight_LM) / 2]
	Else
		Local $size[2] = [$sizea[0] + $i_xWidth_BM / 2 - $i_xWidth_LM / 2, $sizea[1] + $i_yHight_BM / 2 - $i_yHight_LM / 2]
	EndIf

	If IsHWnd($hGUI_LM) Then
		GUISetState(@SW_SHOW, $hGUI_LM)
	Else
		#region ### START Koda GUI section ### main gui
		$hGUI_LM = GUICreate($s_Win_Title_LM, $i_xWidth_LM, $i_yHight_LM, $size[0], $size[1], BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP))
;~ 		GUISetFont(8.5, 400, 0, 'Microsoft Sans Serif')

		#region Menu
		#region File Menu ;============================================================================================== File Menu
		$MenuItem_File = GUICtrlCreateMenu("&File")
		$MenuItem_File_Analyze = GUICtrlCreateMenuItem("&Analyze(Refresh)", $MenuItem_File)
		$MenuItem_File_Selected = GUICtrlCreateMenu("&Selected", $MenuItem_File)
		$MenuItem_File_Selected_ExploreFolder = GUICtrlCreateMenuItem("&Explore Folder", $MenuItem_File_Selected)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$MenuItem_File_Selected_ForceJoin = GUICtrlCreateMenuItem("F&orce Join", $MenuItem_File_Selected)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$MenuItem_File_Selected_Remove = GUICtrlCreateMenuItem("&Remove", $MenuItem_File_Selected)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$MenuItem_File_Selected_Goto = GUICtrlCreateMenuItem("&Goto", $MenuItem_File_Selected)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$MenuItem_File_Selected_Properties = GUICtrlCreateMenuItem("&Properties", $MenuItem_File_Selected)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$MenuItem_File_Split = GUICtrlCreateMenuItem("", $MenuItem_File)
		$MenuItem_File_Exit = GUICtrlCreateMenuItem("&Close", $MenuItem_File)
		#endregion File Menu ;============================================================================================== File Menu

		#region Edit Menu ;==============================================================================================Edit Menu
		$MenuItem_Edit = GUICtrlCreateMenu("&Edit")
		$MenuItem_Edit_Remove = GUICtrlCreateMenuItem("&Clear Selected Entry", $MenuItem_Edit)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$MenuItem_Edit_Remove_All = GUICtrlCreateMenuItem("C&lear All Entry", $MenuItem_Edit)
		$MenuItem_Edit_Find = GUICtrlCreateMenuItem("&Find...", $MenuItem_Edit)
		#endregion Edit Menu ;==============================================================================================Edit Menu

		#region Tools Menu ;==============================================================================================Tools Menu
		$MenuItem_Tools = GUICtrlCreateMenu("T&ools")
		$MenuItem_Tools_Expert = GUICtrlCreateMenu("&Expert", $MenuItem_Tools)
		$MenuItem__Tools_Expert_asIDM = GUICtrlCreateMenuItem("To IDM E&xpert File", $MenuItem_Tools_Expert)
		$MenuItem_Tools_Expert_asText = GUICtrlCreateMenuItem("To IDM &Text File", $MenuItem__Tools_Expert_asIDM)
		$MenuItem__Tools_Expert_asHTML = GUICtrlCreateMenuItem("As HTML Re&port File", $MenuItem__Tools_Expert_asIDM)
		$MenuItem__Tools_Expert_asCSV = GUICtrlCreateMenuItem("As CSV &Report File", $MenuItem__Tools_Expert_asIDM)
		#endregion Tools Menu ;==============================================================================================Tools Menu

		#region View Menu ;==============================================================================================View Menu
		$MenuItem_View = GUICtrlCreateMenu("&View")

		$MenuItem_list = GUICtrlCreateMenu("L&ist", $MenuItem_View)
		$MenuItem_View_List_AllDownloads = GUICtrlCreateMenuItem("&All Downloads", $MenuItem_list, -1, 1)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$MenuItem_View_List_FinishedDownloads = GUICtrlCreateMenuItem("&Finished Downloads", $MenuItem_list, -1, 1)
		$MenuItem_View_List_UnFinished = GUICtrlCreateMenuItem("&UnFinished Downloads", $MenuItem_list, -1, 1)
		$MenuItem_View_List_UnFinished_Data = GUICtrlCreateMenuItem("UnFinished Downloads &Data", $MenuItem_list, -1, 1)

		$MenuItem_View_Categories_list_all = GUICtrlCreateMenu("&Catagories", $MenuItem_View)
		$MenuItem_View_Categories_list_CatArray = GUICtrlCreateMenuItem("A&ll", $MenuItem_View_Categories_list_all, -1, 1)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$i_Cat_Item = _set_cat_to_menu()

		$MenuItem_View_SwGrid = GUICtrlCreateMenuItem("&Show Grid Lines", $MenuItem_View)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$MenuItem_View_AutoArrange = GUICtrlCreateMenuItem("A&uto Arrange", $MenuItem_View)

		$MenuItem_Help = GUICtrlCreateMenu("&?")
		$MenuItem_Help_h = GUICtrlCreateMenuItem("Help", $MenuItem_Help)
		#endregion View Menu ;==============================================================================================View Menu
		#endregion Menu

		#region GUI
		#region List View ;==============================================================================================List View
		$idListView = GUICtrlCreateListView("No.|Name|File Size|MIME Type|ID|Link", 0, 0, 570, 110)
		GUICtrlSetFont(-1, 8.5, 400, 0, 'Tahoma')
		$hListView = GUICtrlGetHandle($idListView)
;~ 		_GUICtrlListView_SetExtendedListViewStyle($idListView, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER, $LVS_EX_HEADERDRAGDROP))
		_GUICtrlListView_SetExtendedListViewStyle($idListView, BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT, $LVS_EX_INFOTIP, $LVS_EX_GRIDLINES, $LVS_EX_HEADERDRAGDROP))
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		If $__WINVER >= 0x0600 Then
			_WinAPI_SetWindowTheme($hListView, 'Explorer');Require Windows Vista or later.
		EndIf
		_GUICtrlListView_SetColumn($hListView, 0, "No.", -1, 1)
		_GUICtrlListView_SetColumn($hListView, 2, "File Size", -1, 1)
		_GUICtrlListView_SetColumn($hListView, 4, "ID", -1, 1)
		#endregion List View ;==============================================================================================List View

		#region Info;==============================================================================================Info
		Local $aParts[1] = [-1]
		Local $aText[1] = ["INFO: Ready"]
		$h_Status_Info_LM = _GUICtrlStatusBar_Create($hGUI_LM, $aParts, $aText)
		#endregion Info;==============================================================================================Info

		#endregion GUI
		#endregion ### END Koda GUI section ###
	EndIf

	_Disable_Button()
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")
	GUIRegisterMsg($WM_SIZE, "MY_WM_SIZE")
	GUIRegisterMsg($WM_SIZE, "stb_resize")
	GUISetState(@SW_SHOW)
EndFunc   ;==>_SwLMGUI

Func _MainLM()
	While 1
		$nMsg = GUIGetMsg()

		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $MenuItem_File_Exit
				ExitLoop

			Case $MenuItem_File_Analyze
				_Analyze()
				$fChange = True
				_Disable_Button()

			Case $MenuItem_File_Selected_Properties
				_Details()

			Case $MenuItem_File_Selected_Goto
				_Goto()

			Case $MenuItem_Edit_Find
				_SwFindGUI()

			Case $MenuItem_Edit_Remove
				_GUICtrlListView_DeleteItemsSelected($hListView)
				$fChange = True
				_Disable_Button()

			Case $MenuItem_Edit_Remove_All
				_GUICtrlListView_DeleteAllItems($hListView)
				$fChange = True
				_Disable_Button()

			Case $MenuItem_View_SwGrid
				_SwGrid()

			Case $MenuItem_View_AutoArrange
				_Auto_Arrange()

			Case $MenuItem_File_Selected_ForceJoin
				If _Join_Fragments() = -2 Then MsgBox(48, "Error", "At Least 2 Fragment Required To Join It.", 0, $hGUI_LM)

			Case $MenuItem_File_Selected_ExploreFolder
				_Open_Folder()

			Case $MenuItem_File_Selected_Remove
				_Remove()
				$fChange = True
				_Disable_Button()

			Case $MenuItem__Tools_Expert_asCSV
				_Expert_CSV()

			Case $MenuItem__Tools_Expert_asHTML
				_Expert_HTML()

			Case $MenuItem_Tools_Expert_asText
				_Expert_IDM_TXT()

			Case $MenuItem__Tools_Expert_asIDM
				_Expert_IDM_LIST()

			Case $MenuItem_Help_h
				_SwHelp()
		EndSwitch
		_Disable_Button()
	WEnd
	GUISetState(@SW_SHOW, $hGUI_BM)
	GUISetState(@SW_HIDE, $hGUI_LM)
EndFunc   ;==>_MainLM

Func _SwFindGUI()
	GUISetState(@SW_DISABLE, $hGUI_LM)

	Local $size = WinGetPos($s_Win_Title_LM)
	Local $hSearchGUI = GUICreate("Search", 264, 57, $size[0] + $i_xWidth_LM / 2 - 264 / 2, $size[1] + $i_yHight_LM / 2 - 57 / 2, BitXOR($GUI_SS_DEFAULT_GUI, $WS_MINIMIZEBOX), BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE), $hGUI_LM)
	Local $hInputFind = GUICtrlCreateInput("", 46, 21, 146, 21)
	Local $Button_Go = GUICtrlCreateButton("Search", 194, 20, 65, 23)
	Local $Button_x = GUICtrlCreateButton("X", 11, 20, 30, 23)
	GUISetState(@SW_SHOW)
	Local $nMsg
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop

			Case $Button_Go
				Local $sText = GUICtrlRead($hInputFind)
				ConsoleWrite($sText & @LF)
				Local $i = 0
				If StringLen($sText) <> 0 Then
					_GUICtrlListView_BeginUpdate($idListView)
					While 1
						_GUICtrlStatusBar_SetText($h_Status_Info_LM, "Finding item: " & $i & " So far...")
						If $i = _GUICtrlListView_GetItemCount($hListView) Then ExitLoop
						If Not StringInStr(_GUICtrlListView_GetItemTextString($hListView, $i), $sText) Then
							_GUICtrlListView_DeleteItem($hListView, $i)
							$i -= 1
						EndIf
						$i += 1
					WEnd
					_GUICtrlListView_EndUpdate($idListView)
					_GUICtrlStatusBar_SetText($h_Status_Info_LM, "INFO: " & _GUICtrlListView_GetItemCount($hListView) & " Item Found." & " Contain:" & $sText)
				EndIf

			Case $Button_x
				GUICtrlSetData($hInputFind, "")
				_GUICtrlStatusBar_SetText($h_Status_Info_LM, "Ready")
		EndSwitch
	WEnd

	GUISetState(@SW_ENABLE, $hGUI_LM)
	GUIDelete($hSearchGUI)
EndFunc   ;==>_SwFindGUI

Func _RunILM()
	_SwLMGUI()
	_MainLM()
EndFunc   ;==>_RunILM

Func stb_resize($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref  $iMsg, $iwParam, $ilParam, $hWnd
	_GUICtrlStatusBar_Resize($h_Status_Info_LM)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>stb_resize