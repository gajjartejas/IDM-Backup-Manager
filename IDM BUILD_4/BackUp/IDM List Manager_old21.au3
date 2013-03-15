#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\IDM BUILD_2\icon.ico
#AutoIt3Wrapper_Outfile=IDM List Manager.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Downloads List Manager
#AutoIt3Wrapper_Res_Description=Downloads List Manager
#AutoIt3Wrapper_Res_Fileversion=0.9.3.0
#AutoIt3Wrapper_Res_LegalCopyright=©Gajjar Tejas 2012
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <StructureConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <GuiButton.au3>
#include <ComboConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <Constants.au3>
#include <ProgressConstants.au3>
#include <String.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <GuiMenu.au3>
#include <GuiImageList.au3>
#include "_FileIsPathValid.au3"
#include "_RegFunc.au3"
#include "_GUICtrlListView_SaveHTML.au3"
#include "_GUICtrlListView_SaveCSV.au3"

Global Enum $idExplore = 1000, $idJoin, $idDetails, $idRemove, $idGoto
Global $B_DESCENDING
Global $a[3], $fChange = False
Global Const $WS_RESIZABLE = 0x00070000 ; Resizing Style
Global $GUIMINWID = 701; Resizing / minimum width
Global $GUIMINHT = 313; Resizing / minimum hight
Global $hGUI, $MenuItem_list_Catagories_[1000]

#region ### START Koda GUI section ### main gui

$hGUI = GUICreate("IDM List Manager", $GUIMINWID, $GUIMINHT, -1, -1, BitOR($WS_RESIZABLE, $WS_CAPTION, $WS_POPUP))

$MenuItem_File = GUICtrlCreateMenu("&File")
$MenuItem_Analyze = GUICtrlCreateMenuItem("Analyze(Refresh)", $MenuItem_File)
$MenuItem_Selected = GUICtrlCreateMenu("Selected", $MenuItem_File)
$MenuItem_ExploreFolder = GUICtrlCreateMenuItem("Explore Folder", $MenuItem_Selected)
GUICtrlSetState(-1, $GUI_DISABLE)
$MenuItem_ForceJoin = GUICtrlCreateMenuItem("Force Join", $MenuItem_Selected)
GUICtrlSetState(-1, $GUI_DISABLE)
$MenuItem_Remove = GUICtrlCreateMenuItem("Remove", $MenuItem_Selected)
GUICtrlSetState(-1, $GUI_DISABLE)

$MenuItem_Goto = GUICtrlCreateMenuItem("Goto", $MenuItem_Selected)
GUICtrlSetState(-1, $GUI_DISABLE)

$MenuItem_Properties = GUICtrlCreateMenuItem("Properties", $MenuItem_Selected)
GUICtrlSetState(-1, $GUI_DISABLE)
$MenuItem_Split1 = GUICtrlCreateMenuItem("", $MenuItem_File)
$MenuItem_Exit = GUICtrlCreateMenuItem("Exit", $MenuItem_File)

$MenuItem_Edit = GUICtrlCreateMenu("&Edit")
$MenuItem_Edit_Remove = GUICtrlCreateMenuItem("Clear Selected Entry", $MenuItem_Edit)
GUICtrlSetState(-1, $GUI_DISABLE)
$MenuItem_Edit_Remove_All = GUICtrlCreateMenuItem("Clear All Entry", $MenuItem_Edit)
$MenuItem_Edit_Find = GUICtrlCreateMenuItem("Find...", $MenuItem_Edit)

$MenuItem_Tools = GUICtrlCreateMenu("&Tools")
$MenuItem_Expert = GUICtrlCreateMenu("Expert", $MenuItem_Tools)
$MenuItem_Expert_AS_IDM = GUICtrlCreateMenuItem("To IDM Expert File", $MenuItem_Expert)
$MenuItem_Expert_AS_Text = GUICtrlCreateMenuItem("To IDM Text File", $MenuItem_Expert_AS_IDM)
$MenuItem_Expert_AS_HTML = GUICtrlCreateMenuItem("As HTML Report File", $MenuItem_Expert_AS_IDM)
$MenuItem_Expert_AS_CSV = GUICtrlCreateMenuItem("As CSV Report File", $MenuItem_Expert_AS_IDM)

$MenuItem_View = GUICtrlCreateMenu("&View")
$MenuItem_list = GUICtrlCreateMenu("List", $MenuItem_View)
$MenuItem_list_AllDownloads = GUICtrlCreateMenuItem("All Downloads", $MenuItem_list, -1, 1)
GUICtrlSetState(-1, $GUI_CHECKED)
$MenuItem_list_FinishedDownloads = GUICtrlCreateMenuItem("Finished Downloads", $MenuItem_list, -1, 1)
$MenuItem_list_UnFinished = GUICtrlCreateMenuItem("UnFinished Downloads", $MenuItem_list, -1, 1)
$MenuItem_list_UnFinished_Data = GUICtrlCreateMenuItem("UnFinished Downloads Data", $MenuItem_list, -1, 1)
$MenuItem_list_Catagories = GUICtrlCreateMenu("Catagories", $MenuItem_View)
$MenuItem_list_Catagories_0 = GUICtrlCreateMenuItem("All", $MenuItem_list_Catagories, -1, 1)
GUICtrlSetState(-1, $GUI_CHECKED)
$i_Cat_Item = _set_cat_to_menu()

$MenuItem5 = GUICtrlCreateMenu("?")

$ListView1 = GUICtrlCreateListView("No.|Name|File Size|MIME Type|ID|Link", 10, 10, 680, 240)
$hListView = GUICtrlGetHandle($ListView1)
_GUICtrlListView_SetExtendedListViewStyle($ListView1, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_DOUBLEBUFFER, $LVS_EX_HEADERDRAGDROP))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

$JoinFile_Lable_Info = GUICtrlCreateLabel("Ready", 10, 252, 400, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKVCENTER + $GUI_DOCKHEIGHT)
$progressbar1 = GUICtrlCreateProgress(10, 270, 260, 12)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)

$Input_Find = GUICtrlCreateInput("", 442, 265, 146, 21)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKVCENTER + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
GUICtrlSendMsg(-1, $EM_SETCUEBANNER, True, "Search...")
GUICtrlSetState(-1, $GUI_HIDE)
$Button_Go = GUICtrlCreateButton("Search", 590, 265, 65, 23)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKVCENTER + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
GUICtrlSetState(-1, $GUI_HIDE)
$Button_x = GUICtrlCreateButton("X", 655, 265, 30, 23)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKVCENTER + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
GUICtrlSetState(-1, $GUI_HIDE)

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUIRegisterMsg(0x0024, "WM_GETMINMAXINFO")
GUIRegisterMsg($WM_SIZE, "MY_WM_SIZE")

GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

;~  If _Analyze() = 1 Then
;~  MsgBox(0, "Info", "No download found", 0, $hGUI)
;~  _Disable_Button()
;~  EndIf

While 1
	$nMsg = GUIGetMsg()

	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $MenuItem_Analyze
			_Analyze()

		Case $MenuItem_Properties
			_Details()

		Case $MenuItem_Goto
			_Goto()

		Case $MenuItem_Edit_Find
			GUICtrlSetState($Button_Go, $GUI_SHOW)
			GUICtrlSetState($Input_Find, $GUI_SHOW)
			GUICtrlSetState($Button_x, $GUI_SHOW)

		Case $Button_x
			GUICtrlSetState($Button_Go, $GUI_HIDE)
			GUICtrlSetState($Input_Find, $GUI_HIDE)
			GUICtrlSetState($Button_x, $GUI_HIDE)
			_Analyze()

		Case $Button_Go
			_find()

		Case $MenuItem_Edit_Remove
			_GUICtrlListView_DeleteItemsSelected($hListView)

		Case $MenuItem_Edit_Remove_All
			_GUICtrlListView_DeleteAllItems($hListView)

		Case $MenuItem_ForceJoin
			If _Join_Fragments() = -2 Then MsgBox(48, "Error", "At Least 2 Fragment Required To Join It.", 0, $hGUI)

		Case $MenuItem_ExploreFolder
			_Open_Folder()

		Case $MenuItem_Remove
			_Remove()

		Case $MenuItem_list_AllDownloads
			_Analyze()

		Case $MenuItem_list_UnFinished
			_Analyze()

		Case $MenuItem_Expert_AS_CSV
			_Expert_csv()

		Case $MenuItem_Expert_AS_HTML
			_Expert_HTML()

		Case $MenuItem_Expert_AS_Text
			_expert_IDM_TXT()

		Case $MenuItem_Expert_AS_IDM
			_Expert_IDM_LIST()


	EndSwitch
	_Disable_Button()
WEnd

Func ListView_RClick()
	Local $aHit
	$aHit = _GUICtrlListView_SubItemHitTest($hListView)
	If ($aHit[0] <> -1) Then
		; Create a standard popup menu
		; -------------------- To Do --------------------
		$hMenu = _GUICtrlMenu_CreatePopup()
		_GUICtrlMenu_AddMenuItem($hMenu, "Open Folder", $idExplore)
		_GUICtrlMenu_AddMenuItem($hMenu, "Force Join", $idJoin)
		_GUICtrlMenu_AddMenuItem($hMenu, "Remove", $idRemove)
		_GUICtrlMenu_AddMenuItem($hMenu, "Goto", $idGoto)
		_GUICtrlMenu_AddMenuItem($hMenu, "Properties", $idDetails)

		; ========================================================================
		; goto action
		; ========================================================================
		Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "id")), "|")
		Local $owWPage = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "owWPage")
		Local $Referer = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "Referer")
		Local $FileName = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalPath")
		Local $LocalFileName = _Name_Get_From_Path(_RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalFileName"))
		Local $FileExt = _Ext_Get_From_Path(_RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalFileName"))
		Local $LocalPath = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalPath")

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
				If _Join_Fragments() = -2 Then MsgBox(48, "Error", "At Least 2 Fragment Required To Join It.", 0, $hGUI)
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

; Our sorting callback funtion
Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
	$hWndListView = $hListView
	If Not IsHWnd($hListView) Then $hWndListView = GUICtrlGetHandle($hListView)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
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
				Case $NM_KILLFOCUS ; The control has lost the input focus
					; No return value
				Case $NM_RCLICK ; Sent by a list-view control when the user clicks an item with the right mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					ListView_RClick()

					;Return 1 ; not to allow the default processing
					Return 0 ; allow the default processing
				Case $NM_RDBLCLK ; Sent by a list-view control when the user double-clicks an item with the right mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)

					; No return value
				Case $NM_RETURN ; The control has the input focus and that the user has pressed the ENTER key

					; No return value
				Case $NM_SETFOCUS ; The control has received the input focus

					; No return value
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _Join_Fragments()
	_Disable_Controls()

	Local $sChunk = ""
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "id")), "|")
	Local $LocalFileName = _Name_Get_From_Path(_RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalFileName"))
	Local $FileExt = _Ext_Get_From_Path(_RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalFileName"))
	Local $LocalPath = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalPath")

	Local $search = FileFindFirstFile($LocalPath & $LocalFileName & $FileExt & "*")
	Local $search_ = FileFindFirstFile($LocalPath & $LocalFileName & $FileExt & "*")
	Local $total_frag_file = 0

	Local $iBuffer = 10 * 1024 * 1024 ;read 10 MB  at a time
	Local $b = 1

	While 1
		Local $LocalFileName__ = FileFindNextFile($search)
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

	$join_file = FileSaveDialog("Save Your File", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", $pattern, 16, $LocalFileName & $FileExt)
	If @error Then
		_Enable_Controls()
		Return -1
	EndIf

	While 1
		Local $a = 1
		Local $LocalFileName_ = FileFindNextFile($search_)
		If @error Then ExitLoop
		$file_join = FileOpen($LocalPath & "\" & $LocalFileName_, 0)
		GUICtrlSetData($progressbar1, ($b * 100) / $total_frag_file)
		While 1
			$sChunk = FileRead($file_join, $iBuffer)
			If @error = -1 Then ExitLoop
			FileWrite($join_file, $sChunk)
			GUICtrlSetData($JoinFile_Lable_Info, "Joining Segment: " & $b & " " & "Please Wait...")
			$a += 1
		WEnd
		FileClose($file_join)
		$b += 1
	WEnd
	FileClose($search)

	GUICtrlSetData($JoinFile_Lable_Info, "DONE")
	GUICtrlSetData($progressbar1, 0)
	_Enable_Controls()
EndFunc   ;==>_Join_Fragments

Func _Details()
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "id")), "|")
	Local $FileName = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "FileName")
	Local $var_LocalFileName = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalFileName")
	Local $var_LastModified = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LastModified")
	Local $var_lastTryDate = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "lastTryDate")
	Local $var_Referer = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "Referer")
	Local $var_Url0 = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "Url0")

	MsgBox(64, "File Info", "Name:" & @CRLF & $FileName & @CRLF & @CRLF _
			 & "Path:" & @CRLF & $var_LocalFileName & @CRLF & @CRLF _
			 & "Last Modified:" & @CRLF & $var_LastModified & @CRLF & @CRLF _
			 & "Last Try Date:" & @CRLF & $var_lastTryDate & @CRLF & @CRLF _
			 & "Referer URL:" & @CRLF & $var_Referer & @CRLF & @CRLF _
			 & "Download Link:" & @CRLF & $var_Url0, 0, $hGUI)
EndFunc   ;==>_Details

Func _Open_Folder()
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "id")), "|")
	Local $FileName = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalPath")
	If FileExists($FileName) Then ShellExecute($FileName)
EndFunc   ;==>_Open_Folder

Func _Analyze()
	_Disable_Controls()
	_ProgressMarquee_Start($progressbar1)
	_GUICtrlListView_BeginUpdate($ListView1)
	_GUICtrlListView_DeleteAllItems($ListView1)
	Local $i = 1
	Local $no = 1
	Local $Flag1 = 0
	Local $s_current_selectde_cat = _get_selected_cat()
	While 1
		GUICtrlSetData($JoinFile_Lable_Info, "Analyzing: " & $i & " " & "Please Wait...")
		Local $var = RegEnumKey("HKEY_CURRENT_USER\Software\DownloadManager", $i)
		If @error <> 0 Then ExitLoop
		Local $var_MIME = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "FRCType")
		Local $LocalFileName = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "LocalFileName")
		If @error = 1 Or @error = 2 Or @error = 3 Or @error = 4 Then $Flag1 = 1
		Local $FileSize = Number(_RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "FileSize"))
		Local $var_Url0 = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "Url0")
		Local $cat_id = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "categoryID")
		Local $status = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "Status")

		If BitAND(GUICtrlRead($MenuItem_list_Catagories_0), $GUI_CHECKED) Then
			If BitAND(GUICtrlRead($MenuItem_list_AllDownloads), $GUI_CHECKED) Then
				If $Flag1 = 0 Then
					GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $ListView1)
					$no += 1
				EndIf
			ElseIf BitAND(GUICtrlRead($MenuItem_list_FinishedDownloads), $GUI_CHECKED) Then
				If $status = 3 And $Flag1 = 0 Then
					GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $ListView1)
					$no += 1
				EndIf
			ElseIf BitAND(GUICtrlRead($MenuItem_list_UnFinished), $GUI_CHECKED) Then
				If $status = 2 Then
					GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $ListView1)
					$no += 1
				EndIf
			ElseIf BitAND(GUICtrlRead($MenuItem_list_UnFinished_Data), $GUI_CHECKED) Then
				If FileExists($LocalFileName) Then
					GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $ListView1)
					$no += 1
				EndIf
			EndIf
			$i += 1
		Else
			If $s_current_selectde_cat = $cat_id Then
			If BitAND(GUICtrlRead($MenuItem_list_AllDownloads), $GUI_CHECKED) Then
				If $Flag1 = 0 Then
					GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $ListView1)
					$no += 1
				EndIf
			ElseIf BitAND(GUICtrlRead($MenuItem_list_FinishedDownloads), $GUI_CHECKED) Then
				If $status = 3 And $Flag1 = 0 Then
					GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $ListView1)
					$no += 1
				EndIf
			ElseIf BitAND(GUICtrlRead($MenuItem_list_UnFinished), $GUI_CHECKED) Then
				If $status = 2 Then
					GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $ListView1)
					$no += 1
				EndIf
			ElseIf BitAND(GUICtrlRead($MenuItem_list_UnFinished_Data), $GUI_CHECKED) Then
				If FileExists($LocalFileName) Then
					GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var & "|" & $var_Url0, $ListView1)
					$no += 1
				EndIf
			EndIf
			EndIf
			$i += 1
		EndIf
	WEnd
	_GUICtrlListView_EndUpdate($ListView1)
	_GUICtrlListView_SetColumnWidth($ListView1, 0, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
	_GUICtrlListView_SetColumnWidth($ListView1, 1, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
	_GUICtrlListView_SetColumnWidth($ListView1, 2, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
	_GUICtrlListView_SetColumnWidth($ListView1, 3, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
	_GUICtrlListView_SetColumnWidth($ListView1, 4, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))

	GUICtrlSetData($JoinFile_Lable_Info, "Ready")
	_ProgressMarquee_Stop($progressbar1, 1)
	_Enable_Controls()
	Return $no
EndFunc   ;==>_Analyze

Func _Remove()
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "id")), "|")
	Local $FileName = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalPath")
	Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(36, "Conform Delete", "Are you sure you want to delete selected downloads from IDM list of downloads?." & @CRLF & "Delete completely downloaded files from your hard disk as well. Be careful ! ", 0, $hGUI)
	Select
		Case $iMsgBoxAnswer = 6 ;Yes
			If FileExists($FileName) Then FileDelete($FileName)
			RegDelete("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5])
			_Analyze()
		Case $iMsgBoxAnswer = 7 ;No
	EndSelect
EndFunc   ;==>_Remove

Func _Goto()
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "id")), "|")
	Local $owWPage = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "owWPage")
	Local $Referer = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "Referer")

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
			If BitAND(GUICtrlGetState($MenuItem_ForceJoin), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_ForceJoin, $GUI_DISABLE)
			If BitAND(GUICtrlGetState($MenuItem_Properties), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_Properties, $GUI_DISABLE)
			If BitAND(GUICtrlGetState($MenuItem_Remove), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_Remove, $GUI_DISABLE)
			If BitAND(GUICtrlGetState($MenuItem_ExploreFolder), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_ExploreFolder, $GUI_DISABLE)
			If BitAND(GUICtrlGetState($MenuItem_Goto), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_Goto, $GUI_DISABLE)
			If BitAND(GUICtrlGetState($MenuItem_Edit_Remove), $GUI_ENABLE) Then GUICtrlSetState($MenuItem_Edit_Remove, $GUI_DISABLE)
		Else
			Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "id")), "|")
			Local $FileName = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalPath")
			Local $LocalFileName = _Name_Get_From_Path(_RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalFileName"))
			Local $FileExt = _Ext_Get_From_Path(_RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalFileName"))
			Local $LocalPath = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalPath")
			Local $owWPage = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "owWPage")
			Local $Referer = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "Referer")

			Local $search = FileFindFirstFile($LocalPath & $LocalFileName & $FileExt & "*")
			If $search = -1 Then
				GUICtrlSetState($MenuItem_ForceJoin, $GUI_DISABLE)
			Else
				GUICtrlSetState($MenuItem_ForceJoin, $GUI_ENABLE)
			EndIf

			GUICtrlSetState($MenuItem_Properties, $GUI_ENABLE)
			GUICtrlSetState($MenuItem_Remove, $GUI_ENABLE)
			GUICtrlSetState($MenuItem_Edit_Remove, $GUI_ENABLE)

			If FileExists($FileName) = 0 Then
				GUICtrlSetState($MenuItem_ExploreFolder, $GUI_DISABLE)
			Else
				GUICtrlSetState($MenuItem_ExploreFolder, $GUI_ENABLE)

			EndIf

			If $owWPage = "" And $Referer = "" Then
				GUICtrlSetData($MenuItem_Goto, "Goto")
				GUICtrlSetState($MenuItem_Goto, $GUI_DISABLE)
			Else
				GUICtrlSetState($MenuItem_Goto, $GUI_ENABLE)
				If $owWPage <> "" Then GUICtrlSetData($MenuItem_Goto, _Resize_Text($owWPage))
				If $Referer <> "" Then GUICtrlSetData($MenuItem_Goto, _Resize_Text($Referer))
			EndIf

		EndIf
		$fChange = False
	EndIf
EndFunc   ;==>_Disable_Button

Func _Resize_Text($text)
	Return "Goto " & StringLeft($text, 20) & "...."
EndFunc   ;==>_Resize_Text


; #FUNCTION# ====================================================================================================================
; Name ..........: _ProgressMarquee_Start
; Description ...: Start the marquee effect.
; Syntax ........: _ProgressMarquee_Start($iControlID)
; Parameters ....: $iControlID          - ControlID of a progressbar using the $PBS_MARQUEE style.
; Return values .: Return value of GUICtrlSendMsg.
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func _ProgressMarquee_Start($iControlID)
	GUICtrlSetStyle($iControlID, BitOR($PBS_SMOOTH, $PBS_MARQUEE, $WS_TABSTOP))
	Return GUICtrlSendMsg($iControlID, $PBM_SETMARQUEE, 1, 50)
EndFunc   ;==>_ProgressMarquee_Start

; #FUNCTION# ====================================================================================================================
; Name ..........: _ProgressMarquee_Stop
; Description ...:  Stop the marquee effect.
; Syntax ........: _ProgressMarquee_Stop($iControlID[, $iReset = 0])
; Parameters ....: $iControlID          - ControlID of a progressbar using the $PBS_MARQUEE style.
;                  $iReset              - [optional] Reset the progressbar, 1 - Reset or 0 - Don't reset. Default is 0.
; Return values .: Return value of GUICtrlSendMsg.
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func _ProgressMarquee_Stop($iControlID, $iReset = 0)
	GUICtrlSendMsg($iControlID, $PBM_SETMARQUEE, 1, 50)
	Local $iReturn = GUICtrlSendMsg($iControlID, $PBM_SETMARQUEE, 0, 50)
	If $iReset Then
		GUICtrlSetStyle($iControlID, BitOR($PBS_SMOOTH, $WS_TABSTOP))
	EndIf
	Return $iReturn
EndFunc   ;==>_ProgressMarquee_Stop

Func _Disable_Controls()
	GUISetCursor(15, -1, $hGUI)
	GUISetCursor(15, -1, $MenuItem_list_UnFinished)
	GUISetCursor(15, -1, $MenuItem_list_AllDownloads)
	GUISetCursor(15, -1, $MenuItem_ForceJoin)
	GUISetCursor(15, -1, $MenuItem_Analyze)
	GUISetCursor(15, -1, $MenuItem_Properties)
	GUISetCursor(15, -1, $ListView1)
	GUICtrlSetState($MenuItem_list_UnFinished, $GUI_DISABLE)
	GUICtrlSetState($MenuItem_list_AllDownloads, $GUI_DISABLE)
	GUICtrlSetState($MenuItem_ForceJoin, $GUI_DISABLE)
	GUICtrlSetState($MenuItem_Analyze, $GUI_DISABLE)
	GUICtrlSetState($MenuItem_Properties, $GUI_DISABLE)
	GUICtrlSetState($ListView1, $GUI_DISABLE)
EndFunc   ;==>_Disable_Controls

Func _Enable_Controls()
	GUISetCursor(-1, -1, $hGUI)
	GUISetCursor(-1, -1, $MenuItem_list_UnFinished)
	GUISetCursor(-1, -1, $MenuItem_list_AllDownloads)
	GUISetCursor(-1, -1, $MenuItem_ForceJoin)
	GUISetCursor(-1, -1, $MenuItem_Analyze)
	GUISetCursor(-1, -1, $MenuItem_Properties)
	GUISetCursor(-1, -1, $ListView1)
	GUICtrlSetState($MenuItem_list_UnFinished, $GUI_ENABLE)
	GUICtrlSetState($MenuItem_list_AllDownloads, $GUI_ENABLE)
;~ 	GUICtrlSetState($MenuItem_ForceJoin, $GUI_ENABLE)
	GUICtrlSetState($MenuItem_Analyze, $GUI_ENABLE)
;~ 	GUICtrlSetState($MenuItem_Properties, $GUI_ENABLE)
	GUICtrlSetState($ListView1, $GUI_ENABLE)
EndFunc   ;==>_Enable_Controls

Func WM_GETMINMAXINFO($hWnd, $Msg, $WPARAM, $lParam)
	Local $tagMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
	DllStructSetData($tagMaxinfo, 7, $GUIMINWID / 1.2) ; min X
	DllStructSetData($tagMaxinfo, 8, $GUIMINHT / 1.4) ; min Y
	Return 0
EndFunc   ;==>WM_GETMINMAXINFO

Func MY_WM_SIZE($hWnd, $iMsg, $iwParam, $ilParam)
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>MY_WM_SIZE

Func _Expert_HTML()
	Local $join_file = FileSaveDialog("Save Your File", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "webpage (*.htm)", 16, "Download_List.htm")
	If @error Then Return -1
	_GUICtrlListView_DeleteColumn($hListView, 0)
	_GUICtrlListView_SaveHTML($hListView, $join_file, "")
	ShellExecute($join_file)
	_GUICtrlListView_InsertColumn($hListView, 0, "No.", 100)
	_Analyze()
EndFunc   ;==>_Expert_HTML

Func _Expert_csv()
	Local $join_file = FileSaveDialog("Save Your File", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "Comma Separated Values (*csv)", 16, "Download_List.csv")
	If @error Then Return -1
	_GUICtrlListView_DeleteColumn($hListView, 0)
	_GUICtrlListView_SaveCSV($hListView, $join_file)
	ShellExecute($join_file)
	_GUICtrlListView_InsertColumn($hListView, 0, "No.", 100)
	_Analyze()
EndFunc   ;==>_Expert_csv

Func _Expert_IDM_LIST()
	Local $join_file = FileSaveDialog("Save Your File", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "IDM Export File (*ef2)", 16, "Download_List.ef3")
	If @error Then Return -1

	If FileExists($join_file) Then
		If FileDelete($join_file) = 0 Then
			MsgBox(48, "Error", "Could Not Delete: " & $join_file, 0, $hGUI)
			_Expert_IDM_LIST()
		EndIf
	EndIf
	_Disable_Controls()
	_ProgressMarquee_Start($progressbar1)

	Local $i = 1
	Local $no = 1
	While 1
		GUICtrlSetData($JoinFile_Lable_Info, "Experting: " & $i & " " & "Please Wait...")
		Local $var = RegEnumKey("HKEY_CURRENT_USER\Software\DownloadManager", $i)
		If @error <> 0 Then ExitLoop
		Local $LocalFileName = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "LocalFileName")
		Local $var_Url0 = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "Url0") & @CRLF
		If @error Then $var_Url0 = ""
		Local $var_Referer = "referer: " & _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "Referer") & @CRLF
		If @error Then $var_Referer = ""
		Local $var_cookie = "cookie: " & _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "Cookie") & @CRLF
		If @error Then $var_cookie = ""
		If $var_Url0 <> "" Then
			If GUICtrlRead($MenuItem_list_AllDownloads) = $GUI_CHECKED Then
				FileWrite($join_file, "<" & @CRLF)
				FileWrite($join_file, $var_Url0)
				FileWrite($join_file, $var_Referer)
				FileWrite($join_file, $var_cookie)
				FileWrite($join_file, ">" & @CRLF)
				$no += 1
			Else
				If FileExists($LocalFileName) Then
					FileWrite($join_file, "<" & @CRLF)
					FileWrite($join_file, $var_Url0)
					FileWrite($join_file, $var_Referer)
					FileWrite($join_file, $var_cookie)
					FileWrite($join_file, ">" & @CRLF)
					$no += 1
				EndIf
			EndIf
		EndIf
		$i += 1
	WEnd
	GUICtrlSetData($JoinFile_Lable_Info, "Ready")
	_ProgressMarquee_Stop($progressbar1, 1)
	_Enable_Controls()
EndFunc   ;==>_Expert_IDM_LIST

Func _expert_IDM_TXT()
	Local $join_file = FileSaveDialog("Save Your File", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "Plain Text File (*txt)", 16, "Download_List.txt")
	If @error Then Return -1

	If FileExists($join_file) Then
		If FileDelete($join_file) = 0 Then
			MsgBox(48, "Error", "Could Not Delete: " & $join_file, 0, $hGUI)
			_expert_IDM_TXT()
		EndIf
	EndIf
	_Disable_Controls()
	_ProgressMarquee_Start($progressbar1)
	Local $i = 1
	Local $no = 1
	While 1
		GUICtrlSetData($JoinFile_Lable_Info, "Experting: " & $i & " " & "Please Wait...")
		Local $var = RegEnumKey("HKEY_CURRENT_USER\Software\DownloadManager", $i)
		If @error <> 0 Then ExitLoop
		Local $LocalFileName = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "LocalFileName")
		Local $var_Url0 = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "Url0")
		If @error Then $var_Url0 = ""
		If $var_Url0 <> "" Then
			If GUICtrlRead($MenuItem_list_AllDownloads) = $GUI_CHECKED Then
				FileWriteLine($join_file, $var_Url0)
				$no += 1
			Else
				If FileExists($LocalFileName) Then
					FileWriteLine($join_file, $var_Url0)
					$no += 1
				EndIf
			EndIf
		EndIf
		$i += 1
	WEnd
	GUICtrlSetData($JoinFile_Lable_Info, "Ready")
	_ProgressMarquee_Stop($progressbar1, 1)
	_Enable_Controls()
EndFunc   ;==>_expert_IDM_TXT

Func _set_cat_to_menu()
	Local $i = 1
;~ 	Local $m = 1
	While 1
		Local $var = RegEnumKey("HKEY_CURRENT_USER\Software\DownloadManager\FoldersTree", $i)
		If @error Then ExitLoop
		$MenuItem_list_Catagories_[$i] = GUICtrlCreateMenuItem($var, $MenuItem_list_Catagories, -1, 1)
;~ 		$m += 1
		$i += 1
	WEnd
	Return $i
EndFunc   ;==>_set_cat_to_menu

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
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[1]
EndFunc   ;==>_Drive_Get_From_Path


Func _Ext_Get_From_Path($path)
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[4]
EndFunc   ;==>_Ext_Get_From_Path


Func _Name_Get_From_Path($path)
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[3]
EndFunc   ;==>_Name_Get_From_Path

Func _Find()
	$sText = GUICtrlRead($Input_Find)
	Local $i = 0
	If StringLen($sText) <> 0 Then
		_ProgressMarquee_Start($progressbar1)
		_GUICtrlListView_BeginUpdate($ListView1)
		GUICtrlSetData($JoinFile_Lable_Info, "Finding Please Wait...")
		While 1
			If $i = _GUICtrlListView_GetItemCount($hListView) Then ExitLoop
			If Not StringInStr(_GUICtrlListView_GetItemTextString($hListView, $i), $sText) Then
				_GUICtrlListView_DeleteItem($hListView, $i)
				$i -= 1
			EndIf
			$i += 1
		WEnd
		_GUICtrlListView_EndUpdate($ListView1)
		_ProgressMarquee_Stop($progressbar1, 1)
		GUICtrlSetData($JoinFile_Lable_Info, "Ready")
	EndIf
EndFunc   ;==>_Find

Func _get_selected_cat()
	Local $i = 0
	For $i = 1 To $i_Cat_Item
		If BitAND(GUICtrlRead($MenuItem_list_Catagories_[$i]), $GUI_CHECKED) Then
			Return _RegRead("HKEY_CURRENT_USER\Software\DownloadManager\FoldersTree\" & GUICtrlRead($MenuItem_list_Catagories_[$i], 1), "ID")
		EndIf
	Next
EndFunc   ;==>_get_selected_cat