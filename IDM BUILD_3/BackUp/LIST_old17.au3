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

Global Enum $idExplore = 1000, $idJoin, $idDetails, $idRemove, $idGoto
Global $B_DESCENDING
Global $a[3], $fChange = False
Dim $nCurCol = -1
Dim $nSortDir = 1
Dim $bSet = 0
Dim $nCol = -1

#region ### START Koda GUI section ### Form=C:\Users\Tejas\Desktop\project\IDM\IDM BUILD_3\11.kxf
$hListview_Win = GUICreate("Form2", 701, 310, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP))
GUISetCursor(2)
$ListView1 = GUICtrlCreateListView("No.|Name|File Size|MIME Type|ID", 10, 10, 680, 240)
$hListView = GUICtrlGetHandle($ListView1)
_GUICtrlListView_SetExtendedListViewStyle($ListView1, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES,$LVS_EX_DOUBLEBUFFER,$LVS_EX_HEADERDRAGDROP))

GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$Details = GUICtrlCreateButton("Properties", 190, 252, 90, 30)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$Analyze = GUICtrlCreateButton("Analyze", 10, 252, 90, 30)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$Start_Join = GUICtrlCreateButton("Start Joining", 100, 252, 90, 30)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$View = GUICtrlCreateButton("Open Folder", 280, 252, 90, 30)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

$JoinFile_Lable_Info = GUICtrlCreateLabel("Ready", 465, 262, 229, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKVCENTER + $GUI_DOCKHEIGHT)
$progressbar1 = GUICtrlCreateProgress(465, 290, 230, 12)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)

GUICtrlSetState($Start_Join, $GUI_DISABLE)
GUICtrlSetState($View, $GUI_DISABLE)
GUICtrlSetState($Details, $GUI_DISABLE)

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUISetState()
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###
If _Analyze() = 1 Then MsgBox(0, "Info", "No pending download found", 0, $hListview_Win)
While 1

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Analyze
			_Analyze()

		Case $Details
			_Details()

		Case $Start_Join
			_Join_Fragments()

		Case $View
			_Open_Folder()

	EndSwitch

	If $fChange Then
		If _GUICtrlListView_GetSelectedCount($hListView) = 0 Then
			If BitAND(GUICtrlGetState($Start_Join), $GUI_ENABLE) Then GUICtrlSetState($Start_Join, $GUI_DISABLE)
			If BitAND(GUICtrlGetState($View), $GUI_ENABLE) Then GUICtrlSetState($View, $GUI_DISABLE)
			If BitAND(GUICtrlGetState($Details), $GUI_ENABLE) Then GUICtrlSetState($Details, $GUI_DISABLE)
		Else
			If BitAND(GUICtrlGetState($Start_Join), $GUI_DISABLE) Then GUICtrlSetState($Start_Join, $GUI_ENABLE)
			If BitAND(GUICtrlGetState($View), $GUI_DISABLE) Then GUICtrlSetState($View, $GUI_ENABLE)
			If BitAND(GUICtrlGetState($Details), $GUI_DISABLE) Then GUICtrlSetState($Details, $GUI_ENABLE)
		EndIf
		$fChange = False
	EndIf
WEnd

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



Func ListView_RClick()
	Local $aHit
	$aHit = _GUICtrlListView_SubItemHitTest($hListView)
	If ($aHit[0] <> -1) Then
		; Create a standard popup menu
		; -------------------- To Do --------------------
		$hMenu = _GUICtrlMenu_CreatePopup()
		_GUICtrlMenu_AddMenuItem($hMenu, "Open Folder", $idExplore)
		_GUICtrlMenu_AddMenuItem($hMenu, "Join", $idJoin)
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

		If $FileName = "" Then _GUICtrlMenu_SetItemDisabled($hMenu, 0)

		Local $search = FileFindFirstFile($LocalPath & $LocalFileName & $FileExt & "*")
	If $search = -1 Then _GUICtrlMenu_SetItemDisabled($hMenu, 1)




		; ========================================================================
		; Shows how to capture the context menu selections
		; ========================================================================
		Switch _GUICtrlMenu_TrackPopupMenu($hMenu, $hListView, -1, -1, 1, 1, 2)
			Case $idExplore
				_Open_Folder()
			Case $idJoin
				_Join_Fragments()
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
	Local $sChunk = ""
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "id")), "|")
	Local $LocalFileName = _Name_Get_From_Path(_RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalFileName"))
	Local $FileExt = _Ext_Get_From_Path(_RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalFileName"))
	Local $LocalPath = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalPath")
	Local $iBuffer = 10 * 1024 * 1024 ;read 30 MB  at a time

	If $FileExt = "" Then
		$pattern = "Unknown File (*.*)"
	Else
		$pattern = "Known File (*" & $FileExt & ")"
	EndIf

	$join_file = FileSaveDialog("Save Your File", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", $pattern, 16, $LocalFileName & $FileExt)

	;===================================================================================================================================
	Local $search = FileFindFirstFile($LocalPath & $LocalFileName & $FileExt & "*")
	Local $total_frag_file = 0
	While 1
		Local $LocalFileName_ = FileFindNextFile($search)
		If @error Then ExitLoop
		$total_frag_file += 1
	WEnd
	FileClose($search)
	;===================================================================================================================================
	;===================================================================================================================================
	Local $search = FileFindFirstFile($LocalPath & $LocalFileName & $FileExt & "*")
	If $search = -1 Then
		MsgBox(0, "Error", "No files/directories matched the search pattern")
	EndIf
	;===================================================================================================================================
	Local $b = 1
	While 1
		Local $a = 1
		Local $LocalFileName_ = FileFindNextFile($search)
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
	GUICtrlSetData($JoinFile_Lable_Info, "DONE")
	GUICtrlSetData($progressbar1, 0)
	FileClose($search)
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
			 & "Download Link:" & @CRLF & $var_Url0)
EndFunc   ;==>_Details

Func _Open_Folder()
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "id")), "|")
	Local $FileName = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalPath")
	ShellExecute($FileName)
EndFunc   ;==>_Open_Folder

Func _Analyze()
	_GUICtrlListView_DeleteAllItems($ListView1)
	Local $i = 1
	Local $no = 1
	While 1
		GUICtrlSetData($JoinFile_Lable_Info, "Analyzing: " & $i & " " & "Please Wait...")
		Local $var = RegEnumKey("HKEY_CURRENT_USER\Software\DownloadManager", $i)
		If @error <> 0 Then ExitLoop
		Local $var_MIME = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "FRCType")
		Local $LocalFileName = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "LocalFileName")
		Local $FileSize = Number(_RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "FileSize"))
		If FileExists($LocalFileName) Then
			GUICtrlCreateListViewItem($no & "|" & _Name_Get_From_Path($LocalFileName) & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize) & "|" & $var_MIME & "|" & $var, $ListView1)
			$no += 1
			_GUICtrlListView_SetColumnWidth($ListView1, 0, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
			_GUICtrlListView_SetColumnWidth($ListView1, 1, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
			_GUICtrlListView_SetColumnWidth($ListView1, 2, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
			_GUICtrlListView_SetColumnWidth($ListView1, 3, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
			_GUICtrlListView_SetColumnWidth($ListView1, 4, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
		EndIf
		$i += 1
	WEnd
	GUICtrlSetData($JoinFile_Lable_Info, "Ready")
	Return $no
EndFunc   ;==>_Analyze

Func _Remove()
	Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "id")), "|")
	Local $FileName = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[5], "LocalPath")
	Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(36, "Conform Delete", "Are you sure you want to delete selected downloads from IDM list of downloads?." & @CRLF & "Delete completely downloaded files from your hard disk as well. Be careful ! ", 0, $hListview_Win)
	Select
		Case $iMsgBoxAnswer = 6 ;Yes
			FileDelete($FileName)
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

Func _Resize_Text($text)
	Return "Goto " & StringLeft($text, 20) & "...."
EndFunc   ;==>_Resize_Text