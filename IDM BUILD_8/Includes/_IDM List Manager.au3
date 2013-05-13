#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Extra\icon.ico
#AutoIt3Wrapper_Outfile=IDM List Manager 0.9.8.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=IDM List Manager 0.9.8.0
#AutoIt3Wrapper_Res_Description=Join Unfinished Downloaded Files, Remove Download From List and much more.
#AutoIt3Wrapper_Res_Fileversion=0.9.8.0
#AutoIt3Wrapper_Res_LegalCopyright=©Gajjar Tejas 2012-13
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=CompanyName|Gajjar Tejas
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#AutoIt3Wrapper_Res_Field=Internal Name|IDM List Manager.exe
#AutoIt3Wrapper_Res_Field=Product Name|IDM List Manager
#AutoIt3Wrapper_Res_Field=Product Version|0.9.8 beta
#AutoIt3Wrapper_Res_Field=Total Commits|31
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#AutoIt3Wrapper_Run_cvsWrapper=v
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#region Includes
#Region    ;************ Includes ************
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <GuiMenu.au3>
#include "_GUICtrlListView_SaveHTML.au3"
#include "_GUICtrlListView_SaveCSV.au3"
#include "_AppsConstant.au3"
#EndRegion ;************ Includes ************
#endregion Includes

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

	_GUICtrlListView_DeleteColumn($hListView, 0)
	_GUICtrlListView_SaveHTML($hListView, $join_file, "")
	ShellExecute($join_file)
	_GUICtrlListView_InsertColumn($hListView, 0, "No.", 100)
	_Analyze()
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

	_GUICtrlListView_DeleteColumn($hListView, 0)
	_GUICtrlListView_SaveCSV($hListView, $join_file)
	ShellExecute($join_file)
	_GUICtrlListView_InsertColumn($hListView, 0, "No.", 100)
	_Analyze()
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
		GUICtrlSetData($idLable_Info, "Experting: " & $i & " " & "Please Wait...")
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
	GUICtrlSetData($idLable_Info, "Ready")
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
		GUICtrlSetData($idLable_Info, "Experting: " & $i & " " & "Please Wait...")
		Local $var_Url0 = _RegRead($s_regpath_IDM & "\" & $var, "Url0")
		If @error Then $var_Url0 = ""
		If $var_Url0 <> "" Then
			FileWriteLine($join_file, $var_Url0)
		EndIf
	Next
	GUICtrlSetData($idLable_Info, "Ready")
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
				Case $NM_SETFOCUS ; The control has received the input focus
					ConsoleWrite("$NM_SETFOCUS" & @LF)

					; No return value
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func WM_GETMINMAXINFO($hWnd, $Msg, $WPARAM, $lParam)
	#forceref $hWnd,$Msg,$WPARAM
	Local $tagMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
	DllStructSetData($tagMaxinfo, 7, $i_xWidth_LM ) ; min X
	DllStructSetData($tagMaxinfo, 8, $i_yHight_LM) ; min Y
	Return 0
EndFunc   ;==>WM_GETMINMAXINFO

Func MY_WM_SIZE($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam, $ilParam
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>MY_WM_SIZE

#endregion Windows Messages

#region Events
Func _SwFind()
	GUICtrlSetState($idButton_Find, $GUI_SHOW)
	GUICtrlSetState($idInput_Find, $GUI_SHOW)
	GUICtrlSetState($idButton_Remove_Find, $GUI_SHOW)
EndFunc   ;==>_SwFind

Func _Cancel_Find()
	If GUICtrlRead($idInput_Find) = "" Then
		GUICtrlSetState($idButton_Find, $GUI_HIDE)
		GUICtrlSetState($idInput_Find, $GUI_HIDE)
		GUICtrlSetState($idButton_Remove_Find, $GUI_HIDE)
	Else
		GUICtrlSetData($idInput_Find, "")
	EndIf
	GUICtrlSetData($idLable_Info, "Ready")
EndFunc   ;==>_Cancel_Find

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

	GUICtrlSetState($idProgressBar_Info, $GUI_SHOW)
	Local $LocalFileName_, $file_join
	While 1
		$LocalFileName_ = FileFindNextFile($search_)
		If @error Then ExitLoop
		$file_join = FileOpen($LocalPath & "\" & $LocalFileName_, 0)
		GUICtrlSetData($idProgressBar_Info, ($b * 100) / $total_frag_file)
		While 1
			$sChunk = FileRead($file_join, $iBuffer)
			If @error = -1 Then ExitLoop
			FileWrite($join_file, $sChunk)
			GUICtrlSetData($idLable_Info, "Joining Segment: " & $b & " " & "Please Wait...")
		WEnd
		FileClose($file_join)
		$b += 1
	WEnd
	FileClose($search)
	GUICtrlSetState($idProgressBar_Info, $GUI_HIDE)
	GUICtrlSetData($idLable_Info, "DONE")
	GUICtrlSetData($idProgressBar_Info, 0)
	_Enable_Controls()
EndFunc   ;==>_Join_Fragments

Func _Details()
	Local $avArray[2][6]
	Local $avArray1[6]
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($idListView, "id")), "|")
	$avArray1[0] = _RegRead($s_regpath_IDM & "\" & $ID[5], "FileName") ;Name:
	$avArray1[1] = _RegRead($s_regpath_IDM & "\" & $ID[5], "LocalFileName") ;Path:
	$avArray1[2] = _RegRead($s_regpath_IDM & "\" & $ID[5], "LastModified") ;Last Modified:
	$avArray1[3] = _RegRead($s_regpath_IDM & "\" & $ID[5], "lastTryDate") ;Last Try Date:
	$avArray1[4] = _RegRead($s_regpath_IDM & "\" & $ID[5], "Referer") ;Referer URL:
	$avArray1[5] = _RegRead($s_regpath_IDM & "\" & $ID[5], "Url0") ;Download Link:
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
	GUICtrlSetState($idProgressBar_Info, $GUI_SHOW)
	_GUICtrlListView_BeginUpdate($idListView)
	_GUICtrlListView_DeleteAllItems($idListView)
	Local $i = 1
	Local $no = 1
	Local $s_current_selectde_cat = _get_selected_cat()
	Local $i_TotalKey = _CountKey($s_regpath_IDM)

	While 1
		GUICtrlSetData($idLable_Info, "Analyzing: " & "Please Wait..." & Round($i / $i_TotalKey * 100) & "%")
		GUICtrlSetData($idProgressBar_Info, $i / $i_TotalKey * 100)

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
	GUICtrlSetData($idLable_Info, "Ready")
	GUICtrlSetState($idProgressBar_Info, $GUI_HIDE)
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
	Local $i = 1
	While 1
		Local $var = RegEnumKey($s_regpath_IDM & "\FoldersTree\", $i)
		If @error Then ExitLoop
		$MenuItem_list_Catagories_[$i] = GUICtrlCreateMenuItem($var, $MenuItem_View_Categories_list_all, -1, 1)
		$i += 1
	WEnd
	Return $i
EndFunc   ;==>_set_cat_to_menu

Func _Find()
	Local $sText = GUICtrlRead($idInput_Find)
	Local $i = 0
	If StringLen($sText) <> 0 Then
		_GUICtrlListView_BeginUpdate($idListView)
		GUICtrlSetData($idLable_Info, "Finding Please Wait...")
		While 1
			If $i = _GUICtrlListView_GetItemCount($hListView) Then ExitLoop
			If Not StringInStr(_GUICtrlListView_GetItemTextString($hListView, $i), $sText) Then
				_GUICtrlListView_DeleteItem($hListView, $i)
				$i -= 1
			EndIf
			$i += 1
		WEnd
		_GUICtrlListView_EndUpdate($idListView)
		GUICtrlSetData($idLable_Info, "INFO: " & _GUICtrlListView_GetItemCount($hListView) & " Item Found." & " Contain:" & $sText)
	EndIf
EndFunc   ;==>_Find

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

#region Internal Function
Func _CountKey($sRegpath)
	Local $k = 1
	While 1
		RegEnumKey($sRegpath, $k)
		If @error <> 0 Then ExitLoop
		$k += 1
	WEnd
	Return $k - 1
EndFunc   ;==>_CountKey

Func _Resize_Text($text)
	Return "Goto " & StringLeft($text, 20) & "...."
EndFunc   ;==>_Resize_Text

Func _File_Size($Rn)
	If $Rn > 0 And $Rn <= 1024 Then
		Return $Rn & " BYTES"
	ElseIf $Rn > 1024 And $Rn <= 1048576 Then
		Return Round($Rn / (1024), 2) & " KB"
	ElseIf $Rn > 1048576 And $Rn <= 1073741824 Then
		Return Round($Rn / (1048576), 2) & " MB"
	ElseIf $Rn > 1073741824 Then
		Return Round($Rn / (1073741824), 2) & " GB"
	EndIf
EndFunc   ;==>_File_Size

Func _Drive_Get_From_Path($path)
	Local $szDrive, $szDir, $szFName, $szExt
	Local $TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[1]
EndFunc   ;==>_Drive_Get_From_Path

Func _Ext_Get_From_Path($path)
	Local $szDrive, $szDir, $szFName, $szExt
	Local $TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[4]
EndFunc   ;==>_Ext_Get_From_Path

Func _Name_Get_From_Path($path)
	Local $szDrive, $szDir, $szFName, $szExt
	Local $TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[3]
EndFunc   ;==>_Name_Get_From_Path

#endregion Internal Function

Func _SwLMGUI()
	GUISetState(@SW_DISABLE, $hGUI_BM)
	Local $size = WinGetPos($s_Win_Title_BM)
	#region ### START Koda GUI section ### main gui
	$hGUI_LM = GUICreate($s_Win_Title_LM, $i_xWidth_LM, $i_yHight_LM, $size[0] + $i_xWidth_BM / 2 - $i_xWidth_LM / 2, $size[1] + $i_yHight_BM / 2 - $i_yHight_LM / 2,  BitOR($GUI_SS_DEFAULT_GUI,$WS_SIZEBOX,$WS_THICKFRAME), BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE), $hGUI_BM)

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
	$MenuItem_File_Exit = GUICtrlCreateMenuItem("&Exit", $MenuItem_File)
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
	$idListView = GUICtrlCreateListView("No.|Name|File Size|MIME Type|ID|Link", 10, 10, 550, 100)
	$hListView = GUICtrlGetHandle($idListView)
	_GUICtrlListView_SetExtendedListViewStyle($idListView, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER, $LVS_EX_HEADERDRAGDROP))
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	#endregion List View ;==============================================================================================List View

	#region Info;==============================================================================================Info
	$idLable_Info = GUICtrlCreateLabel("Ready", 10, 115, 325, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKVCENTER + $GUI_DOCKHEIGHT)

	$idProgressBar_Info = GUICtrlCreateProgress(10, 135, 210, 12)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	#endregion Info;==============================================================================================Info

	#region Find;==============================================================================================Find
	$idInput_Find = GUICtrlCreateInput("", 316, 136, 146, 21)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKVCENTER + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
	GUICtrlSendMsg(-1, $EM_SETCUEBANNER, True, "Search...")
	GUICtrlSetState(-1, $GUI_HIDE)

	$idButton_Find = GUICtrlCreateButton("Search", 465, 135, 65, 23)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKVCENTER + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
	GUICtrlSetState(-1, $GUI_HIDE)

	$idButton_Remove_Find = GUICtrlCreateButton("r", 530, 135, 30, 23)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKVCENTER + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
	GUICtrlSetFont(-1, 10, 400, 0, "Webdings")
	GUICtrlSetState(-1, $GUI_HIDE)
	#endregion Find;==============================================================================================Find

	#endregion GUI
	_Disable_Button()
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")
	GUIRegisterMsg($WM_SIZE, "MY_WM_SIZE")

	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###

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
				_SwFind()

			Case $idButton_Remove_Find
				_Cancel_Find()

			Case $idButton_Find
				_Find()

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
	GUISetState(@SW_ENABLE, $hGUI_BM)
	GUIDelete($hGUI_LM)
EndFunc   ;==>_MainLM

Func _RunILM()
	_SwLMGUI()
	_MainLM()
EndFunc   ;==>_RunILM