#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <ComboConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <ProgressConstants.au3>
#include <String.au3>
#include <File.au3>
#include <GuiListView.au3>
#include "_FileIsPathValid.au3"
#include "_RegFunc.au3"


#region ### START Koda GUI section ### Form=C:\Users\Tejas\Desktop\project\IDM\IDM BUILD_3\11.kxf
$hListview_Win = GUICreate("Form2", 701, 302, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP))
GUISetCursor(2)
$ListView1 = GUICtrlCreateListView("No.|Name|File Size|Extension|ID", 10, 10, 680, 240)
_GUICtrlListView_SetExtendedListViewStyle($ListView1, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 400)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 80)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 90)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 50)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$Details = GUICtrlCreateButton("Details", 190, 252, 90, 30)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$Analyze = GUICtrlCreateButton("Analyze", 10, 252, 90, 30)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$Start_Join = GUICtrlCreateButton("Start Joining", 100, 252, 90, 30)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Analyze
			_GUICtrlListView_DeleteAllItems($ListView1)
			Local $i = 1
			While 1
				Local $var = RegEnumKey("HKEY_CURRENT_USER\Software\DownloadManager", $i)
				If @error <> 0 Then ExitLoop
				Local $LocalFileName = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "LocalFileName")
				Local $FileSize = Number(_RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "FileSize"))
				If FileExists($LocalFileName) Then GUICtrlCreateListViewItem(_Name_Get_From_Path($LocalFileName) & "|" & _Ext_Get_From_Path($LocalFileName) & "|" & _File_Size($FileSize), $ListView1)
				$i += 1
WEnd
			Case $Details
				Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "Size")), "|")
				Local $FileName = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "FileName")
				Local $var_LocalFileName = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "LocalFileName")
				Local $var_LastModified = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "LastModified")
				Local $var_lastTryDate = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "lastTryDate")
				Local $var_Referer = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "Referer")
				Local $var_Url0 = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "Url0")

				MsgBox(64, "File Info", "Name:" & @CRLF & $FileName & @CRLF & @CRLF _
						 & "Path:" & @CRLF & $var_LocalFileName & @CRLF & @CRLF _
						 & "Last Modified:" & @CRLF & $var_LastModified & @CRLF & @CRLF _
						 & "Last Try Date:" & @CRLF & $var_lastTryDate & @CRLF & @CRLF _
						 & "Referer URL:" & @CRLF & $var_Referer & @CRLF & @CRLF _
						 & "Download Link:" & @CRLF & $var_Url0)

			Case $Start_Join
				Local $file_join1 = ""
				Local $ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "Size")), "|")
				Local $LocalFileName = _Name_Get_From_Path(RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "LocalFileName"))
				Local $FileExt = _Ext_Get_From_Path(RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "LocalFileName"))
				Local $LocalPath = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "LocalPath")
				Local $search = FileFindFirstFile($LocalPath & $LocalFileName & "*.*")

				If $search = -1 Then
					MsgBox(0, "Error", "No files/directories matched the search pattern")
				EndIf

				If $FileExt = "" Then
					$pattern = "Unknown File (*.*)"
				Else
					$pattern = "Known File (*" & $FileExt & ")"
				EndIf

				$join_file = FileSaveDialog("Save Your File", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", $pattern, 16, $LocalFileName)

				While 1
					Local $LocalFileName = FileFindNextFile($search)
					If @error Then ExitLoop
					$file_join = FileOpen($LocalPath & "\" & $LocalFileName, 0)
					$file_join1 &= FileRead($file_join)
				WEnd
				FileWrite($join_file, $file_join1)
				FileClose($search)

			WEnd


	EndSwitch
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
Exit

Func _Ext_Get_From_Path($path)
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[4]
EndFunc   ;==>_Ext_Get_From_Path
Exit

Func _Name_Get_From_Path($path)
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[3]
EndFunc   ;==>_Name_Get_From_Path
Exit