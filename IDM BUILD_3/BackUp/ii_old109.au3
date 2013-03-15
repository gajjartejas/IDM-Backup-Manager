
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
#NoTrayIcon
#RequireAdmin

;==============================================================================================
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\IDM BUILD_2\icon.ico
#AutoIt3Wrapper_Outfile=E:\IDM Backup Manager0.9.4.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=IDM Backup Manager is a free software that can backup files from InterDownload Manager
#AutoIt3Wrapper_Res_Description=IDM Backup Manager is a free software that can backup files from InterDownload Manager
#AutoIt3Wrapper_Res_Fileversion=0.9.3.0
#AutoIt3Wrapper_Res_LegalCopyright=©Gajjar Tejas 2012
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

;==============================================================================================
#region ;**** Create title and read registry of IDM Backup Manager and Read IDM registry****
Global Const $regkey_x86_IDM = "HKEY_CURRENT_USER\Software\DownloadManager"
Global Const $regkey_x86_IDMBM = "HKEY_CURRENT_USER\Software\IDM Backup Manager"
Global Const $current_version = "0.9.3"
Global Const $Win_Title = "IDM Backup Manager" & $current_version & "(Beta)"

;==============================================================================================
#region
If @OSArch <> "X86" Then
	MsgBox(16, "Advisory!", "This application is not compatable with the architecture of this operating system." & @CR & "The application will now exit.")
	Exit
EndIf

If ProcessExists("idman1.exe") Then ;**** Check the process "idman.exe" exists or not ****
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(4, "IDM Need To Close", "Close IDM Before You Can Continue.Do You Want To Close IDM?")
	Select
		Case $iMsgBoxAnswer = 6 ;Yes
			ProcessClose("idman.exe")
		Case $iMsgBoxAnswer = 7 ;No
			Exit
	EndSelect
EndIf
$Intial_Backup_Path = RegRead($regkey_x86_IDMBM, "Backup Folder")
If @error <> 0 Then
	$Intial_Backup_Path = ""
EndIf
$Intial_Restore_Path = RegRead($regkey_x86_IDMBM, "Restore Folder")
If @error <> 0 Then
	$Intial_Restore_Path = ""
EndIf
$version = RegRead($regkey_x86_IDMBM, "Software Version")
If $version <> $current_version Then RegWrite($regkey_x86_IDMBM, "Software Version", "REG_SZ", $current_version)

#endregion

;==============================================================================================
Global $Reg_Read_AppDataIDMFolder = _RegRead($regkey_x86_IDM, "AppDataIDMFolder")
Global $Reg_Read_ExceptionServers = _RegRead($regkey_x86_IDM, "ExceptionServers")
Global $Reg_Read_EnableDriver = _RegRead($regkey_x86_IDM, "EnableDriver")
Global $Reg_Read_isUseWinDialUp = _RegRead($regkey_x86_IDM, "isUseWinDialUp")
Global $Reg_Read_mAttempts = _RegRead($regkey_x86_IDM, "mAttempts")
Global $Reg_Read_mRedialTime = _RegRead($regkey_x86_IDM, "mRedialTime")
Global $Reg_Read_FSSettingsChecked = _RegRead($regkey_x86_IDM, "FSSettingsChecked")
Global $Reg_Read_mzcc_ext_vers = _RegRead($regkey_x86_IDM, "mzcc_ext_vers")
Global $Reg_Read_intAOFRWE = _RegRead($regkey_x86_IDM, "intAOFRWE")
Global $Reg_Read_mzcc_vers = _RegRead($regkey_x86_IDM, "mzcc_vers")
Global $Reg_Read_Extensions = _RegRead($regkey_x86_IDM, "Extensions")
Global $Reg_Read_TempPath = _RegRead($regkey_x86_IDM, "TempPath")
Global $Reg_Read_FindApps = _RegRead($regkey_x86_IDM, "FindApps")
Global $Reg_Read_ExePath = _RegRead($regkey_x86_IDM, "ExePath")
Global $Reg_Read_idmvers = _RegRead($regkey_x86_IDM, "idmvers")
Global $Reg_Read_LastCheck = _RegRead($regkey_x86_IDM, "LastCheck")
Global $Reg_Read_ConnectionType = _RegRead($regkey_x86_IDM, "ConnectionType")
Global $Reg_Read_ConnectionSpeed = _RegRead($regkey_x86_IDM, "ConnectionSpeed")
Global $Reg_Read_LaunchOnStart = _RegRead($regkey_x86_IDM, "LaunchOnStart")
Global $Reg_Read_RememberLastSave = _RegRead($regkey_x86_IDM, "RememberLastSave")
Global $Reg_Read_MonitorUrlClipboard = _RegRead($regkey_x86_IDM, "MonitorUrlClipboard")
Global $Reg_Read_UseHttpProxy = _RegRead($regkey_x86_IDM, "UseHttpProxy")
Global $Reg_Read_UseFtpProxy = _RegRead($regkey_x86_IDM, "UseFtpProxy")
Global $Reg_Read_FtpPasive = _RegRead($regkey_x86_IDM, "FtpPasive")
Global $Reg_Read_IntegrateNN = _RegRead($regkey_x86_IDM, "IntegrateNN")
Global $Reg_Read_nDESC7 = _RegRead($regkey_x86_IDM, "nDESC7")
Global $Reg_Read_nDESC8 = _RegRead($regkey_x86_IDM, "nDESC8")
Global $Reg_Read_isSSW_OK = _RegRead($regkey_x86_IDM, "isSSW_OK")
Global $Reg_Read_LargeButtons = _RegRead($regkey_x86_IDM, "LargeButtons")
Global $Reg_Read_ToolbarStyle = _RegRead($regkey_x86_IDM, "ToolbarStyle")
Global $Reg_Read_windowPlacementV5 = _RegRead($regkey_x86_IDM, "windowPlacementV5")
Global $Reg_Read_sortOrder = _RegRead($regkey_x86_IDM, "sortOrder")
Global $Reg_Read_lstbhotime = _RegRead($regkey_x86_IDM, "lstbhotime")
Global $Reg_Read_lstbhotime2 = _RegRead($regkey_x86_IDM, "lstbhotime2")
Global $Reg_Read_TrayIcon = _RegRead($regkey_x86_IDM, "TrayIcon")
Global $Reg_Read_ShowTipOnFirstCatch = _RegRead($regkey_x86_IDM, "ShowTipOnFirstCatch")
Global $Reg_Read_LastCheckQU = _RegRead($regkey_x86_IDM, "LastCheckQU")
Global $Reg_Read_TipTimeStamp = _RegRead($regkey_x86_IDM, "TipTimeStamp")
Global $Reg_Read_TipStartUp = _RegRead($regkey_x86_IDM, "TipStartUp")
Global $Reg_Read_TipFilePos = _RegRead($regkey_x86_IDM, "TipFilePos")
Global $Reg_Read_tvfrdt = _RegRead($regkey_x86_IDM, "tvfrdt")
Global $Reg_Read_bShBTtFQCI = _RegRead($regkey_x86_IDM, "bShBTtFQCI")
Global $Reg_Read_bShTipDD = _RegRead($regkey_x86_IDM, "bShTipDD")
Global $Reg_Read_DuplLinksA = _RegRead($regkey_x86_IDM, "DuplLinksA")
Global $Reg_Read_ToolbarState_v511 = _RegRead($regkey_x86_IDM, "ToolbarState_v5.11")
Global $Reg_Read_PrgrDlgVisiblity = _RegRead($regkey_x86_IDM, "PrgrDlgVisiblity")
Global $Reg_Read_ComplDlgShowing = _RegRead($regkey_x86_IDM, "ComplDlgShowing")
Global $Reg_Read_bQueueSelPnlOnDlLt = _RegRead($regkey_x86_IDM, "bQueueSelPnlOnDlLt")
Global $Reg_Read_bQueueSelPnlOnGAL = _RegRead($regkey_x86_IDM, "bQueueSelPnlOnGAL")
Global $Reg_Read_bIgnMTCh = _RegRead($regkey_x86_IDM, "bIgnMTCh")
Global $Reg_Read_StartDlgShowing = _RegRead($regkey_x86_IDM, "StartDlgShowing")
Global $Reg_Read_RememberDuplLinksA = _RegRead($regkey_x86_IDM, "RememberDuplLinksA")
Global $Reg_Read_dPrDtVis = _RegRead($regkey_x86_IDM, "dPrDtVis")
Global $Reg_Read_ShowDropTarget = _RegRead($regkey_x86_IDM, "ShowDropTarget")
Global $Reg_Read_GetAllWindowPlacement = _RegRead($regkey_x86_IDM, "GetAllWindowPlacement")
Global $Reg_Read_GrabberWindowPlacement = _RegRead($regkey_x86_IDM, "GrabberWindowPlacement")
Global $Reg_Read_bHDIShwd = _RegRead($regkey_x86_IDM, "bHDIShwd")
Global $Reg_Read_UseHttpsProxy = _RegRead($regkey_x86_IDM, "UseHttpsProxy")
Global $Reg_Read_HttpsProxy = _RegRead($regkey_x86_IDM, "HttpsProxy")
Global $Reg_Read_HttpsPort = _RegRead($regkey_x86_IDM, "HttpsPort")
Global $Reg_Read_ExceptionProxyServers = _RegRead($regkey_x86_IDM, "ExceptionProxyServers")
Global $Reg_Read_HttpProxy = _RegRead($regkey_x86_IDM, "HttpProxy")
Global $Reg_Read_FtpProxy = _RegRead($regkey_x86_IDM, "FtpProxy")
Global $Reg_Read_FtpPort = _RegRead($regkey_x86_IDM, "FtpPort")
Global $Reg_Read_MaxConnectionsNumber = _RegRead($regkey_x86_IDM, "MaxConnectionsNumber")
Global $Reg_Read_evDownloadComplete = _RegRead($regkey_x86_IDM, "evDownloadComplete")
Global $Reg_Read_evDownloadFailed = _RegRead($regkey_x86_IDM, "evDownloadFailed")
Global $Reg_Read_evQueueStarted = _RegRead($regkey_x86_IDM, "evQueueStarted")
Global $Reg_Read_evQueueFinished = _RegRead($regkey_x86_IDM, "evQueueFinished")
Global $Reg_Read_DialUpEntry = _RegRead($regkey_x86_IDM, "DialUpEntry")
Global $Reg_Read_lastintres = _RegRead($regkey_x86_IDM, "lastintres")
Global $Reg_Read_showHTDlFsnMsg = _RegRead($regkey_x86_IDM, "showHTDlFsnMsg")
Global $Reg_Read_StImmMsg = _RegRead($regkey_x86_IDM, "StImmMsg")
Global $Reg_Read_bQueueSelPnlOnDlLtQID = _RegRead($regkey_x86_IDM, "bQueueSelPnlOnDlLtQID")
Global $Reg_Read_bQueueSelPnlOnDlLtSt = _RegRead($regkey_x86_IDM, "bQueueSelPnlOnDlLtSt")
Global $Reg_Read_scansk = _RegRead($regkey_x86_IDM, "scansk")
Global $Reg_Read_FName = _RegRead($regkey_x86_IDM, "FName")
Global $Reg_Read_LName = _RegRead($regkey_x86_IDM, "LName")
Global $Reg_Read_Email = _RegRead($regkey_x86_IDM, "Email")
Global $Reg_Read_Serial = _RegRead($regkey_x86_IDM, "Serial")
Global $Reg_Read_ptrk_scdt = _RegRead($regkey_x86_IDM, "ptrk_scdt")
Global $Reg_Read_bShTipFLVPlayer = _RegRead($regkey_x86_IDM, "bShTipFLVPlayer")
Global $Reg_Read_RunIEMonitor = _RegRead($regkey_x86_IDM, "RunIEMonitor")
Global $Reg_Read_ExpImpIniPath = _RegRead($regkey_x86_IDM, "ExpImpIniPath")
Global $Reg_Read_bShFFTip1 = _RegRead($regkey_x86_IDM, "bShFFTip1")
Global $Reg_Read_MessageID = _RegRead($regkey_x86_IDM, "MessageID")
Global $Reg_Read_IntegrateMIE = _RegRead($regkey_x86_IDM, "IntegrateMIE")
Global $Reg_Read_bComlDlgVMS = _RegRead($regkey_x86_IDM, "bComlDlgVMS")
Global $Reg_Read_LocalPathW = _RegRead($regkey_x86_IDM, "LocalPathW")
Global $Reg_Read_showHTDlShSMsg = _RegRead($regkey_x86_IDM, "showHTDlShSMsg")
#endregion ;**** Create title and read registry of IDM Backup Manager and Read IDM registry****

;==============================================================================================
#region
If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
If FileExists(@TempDir & "\IDMbackup.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
If FileExists(@TempDir & "\IDMregistry_Encrypted1.reg") Then FileDelete(@TempDir & "\IDMregistry_Encrypted1.reg")
$Increase = 0
#endregion

;**** Create main GUI of the IDM Backup Manager ****
;==============================================================================================
#region ### START Koda GUI section ### Form=C:\Users\Tejas\Desktop\project\IDM\IDM BUILD_3\Form4.kxf
$Form2 = GUICreate($Win_Title, 411, 248, 346, 339)

$Tab1 = GUICtrlCreateTab(10, 10, 395, 193)

$TabSheet1 = GUICtrlCreateTabItem("Backup Data")

$Group1 = GUICtrlCreateGroup("Backup Location", 24, 44, 371, 56)

$Backup_Input = GUICtrlCreateInput("", 33, 64, 311, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Browse_Button_Backup = GUICtrlCreateButton("...", 351, 64, 30, 22)
GUICtrlSetTip(-1, "Browse For Backup Path")
GUICtrlSetCursor(-1, 0)

$Backup_Button = GUICtrlCreateButton("Backup", 319, 107, 75, 25)
GUICtrlSetTip(-1, "Backup Now")
GUICtrlSetCursor(-1, 0)

$Group6 = GUICtrlCreateGroup("Options", 24, 104, 220, 90)

$Checkbox_backup_Password = GUICtrlCreateCheckbox("", 38, 129, 12, 17)
GUICtrlSetTip(-1, "Choose Yes If You Want Encryption of Your Backup Files Which Is Required Strong Password", "Backup Password", 1, 1)
GUICtrlSetCursor(-1, 0)

$Input_backup_Password = GUICtrlCreateInput("Password", 54, 128, 171, 21, $ES_PASSWORD)
GUICtrlSetTip(-1, "Choose Yes If You Want Encryption of Your Backup Files Which Is Required Strong Password", "Backup Password", 1, 1)

$Checkbox_restore_Setting_Compression = GUICtrlCreateCheckbox("", 39, 158, 12, 17)
GUICtrlSetTip(-1, "Here You Can Set The Compression Level of The Backup Files" & @CRLF & "", "Compression Level", 1, 1)
GUICtrlSetCursor(-1, 0)

$Setting_Compression_Level = GUICtrlCreateCombo("1-No Compression", 54, 157, 170, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "2-Fastest Compression|3-Fast Compression|4-Normal Compression|5-Maximum Compression|6-Ultra Compression", "4-Normal Compression")
GUICtrlSetTip(-1, "Here You Can Set The Compression Level of The Backup Files" & @CRLF & "", "Compression Level", 1, 1)
GUICtrlSetCursor(-1, 0)

GUICtrlCreateGroup("", -99, -99, 1, 1)
;==============================================================================================
$TabSheet2 = GUICtrlCreateTabItem("Restore Data")

$Group2 = GUICtrlCreateGroup("Restore Location", 24, 44, 371, 56)

$Restore_Input = GUICtrlCreateInput("", 33, 64, 311, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))

$Browse_Button_Restore = GUICtrlCreateButton("...", 351, 64, 30, 22)
GUICtrlSetTip(-1, "Browse For Restore Path")
GUICtrlSetCursor(-1, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Restore_Button = GUICtrlCreateButton("Restore", 319, 107, 75, 25)
GUICtrlSetTip(-1, "Restore Now")
GUICtrlSetCursor(-1, 0)

$Group7 = GUICtrlCreateGroup("Options", 24, 104, 220, 90)

$Checkbox_restore_Password = GUICtrlCreateCheckbox("", 38, 129, 12, 17)
GUICtrlSetTip(-1, "Choose Yes If Your backup is Encrypted", "Restore Encryption", 1, 1)
GUICtrlSetCursor(-1, 0)

$Input_restore_Password = GUICtrlCreateInput("Password", 54, 128, 171, 21, $ES_PASSWORD)
GUICtrlSetTip(-1, "Choose Yes If Your backup is Encrypted", "Restore Encryption", 1, 1)

$Checkbox_restore_Convert_Registry = GUICtrlCreateCheckbox("", 39, 158, 12, 17)
GUICtrlSetTip(-1, "Choose Yes If Destination Backup is another System" & @CRLF & @CRLF & "EXAMPLE:" & @CRLF & "Incase of If You Want To Restore Backup of Cybercafe to Your Home PC", "Convert Profile", 1, 1)
GUICtrlSetCursor(-1, 0)

$Label_Convert_Registry = GUICtrlCreateLabel("Convert Profile", 60, 159, 82, 17)
GUICtrlSetTip(-1, "Choose Yes If Destination Backup is another System" & @CRLF & @CRLF & "EXAMPLE:" & @CRLF & "Incase of If You Want To Restore Backup of Cybercafe to Your Home PC", "Convert Profile", 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
;==============================================================================================
$TabSheet3 = GUICtrlCreateTabItem("Join Files")
$ListView1 = GUICtrlCreateListView("File Name|Type|ID", 19, 39, 375, 125)
_GUICtrlListView_SetColumnWidth(-1, 0, 200)
$Analyze = GUICtrlCreateButton("Analyze", 50, 165, 100, 30)
$Start_Join = GUICtrlCreateButton("Start Joining", 158, 165, 100, 30)
$Details = GUICtrlCreateButton("Details", 267, 165, 100, 30)
GUICtrlCreateTabItem("")
;==============================================================================================
$TabSheet4 = GUICtrlCreateTabItem("Help")
GUICtrlSetState(-1, $GUI_SHOW)
$Help_Tab = GUICtrlCreateGroup("Help and Update", 24, 44, 370, 145)
$Website = GUICtrlCreateButton("Website", 37, 126, 100, 30)
$Help = GUICtrlCreateButton("Help", 37, 66, 100, 30)
GUICtrlSetCursor(-1, 4)
$Licence = GUICtrlCreateButton("Licence", 37, 96, 100, 30)
GUICtrlSetCursor(-1, 4)
$View_Log = GUICtrlCreateButton("View Log", 146, 66, 100, 30)
$Bug_Report = GUICtrlCreateButton("Bug Report", 146, 96, 100, 30)
$Update = GUICtrlCreateButton("Update", 146, 126, 100, 30)
$Pic1 = GUICtrlCreatePic("C:\Users\Tejas\Desktop\project\IDM\IDM BUILD_3\Resorces\contactme.jpg", 250, 55, 140, 130)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
;==============================================================================================
$Exit = GUICtrlCreateButton("Exit", 328, 216, 75, 25)
GUICtrlSetCursor(-1, 0)

$Website_Label = GUICtrlCreateLabel("http://www.gajjartejas26.blogspot.com", 10, 221, 226, 17)
GUICtrlSetCursor(-1, 0)
GUICtrlSetColor(-1, 0x0000FF)

$Progress1 = GUICtrlCreateProgress(250, 220, 76, 16, $PBS_MARQUEE)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

;==============================================================================================
GUICtrlSetState($Backup_Button, $GUI_DISABLE)
GUICtrlSetState($Restore_Button, $GUI_DISABLE)
GUICtrlSetState($Input_backup_Password, $GUI_DISABLE)
GUICtrlSetState($Input_restore_Password, $GUI_DISABLE)
GUICtrlSetState($Setting_Compression_Level, $GUI_DISABLE)
GUICtrlSetState($Label_Convert_Registry, $GUI_DISABLE)

$AppDataIDMFolder = RegRead($regkey_x86_IDM, "AppDataIDMFolder")
If @error <> 0 Then
	MsgBox(16, "Error", "IDM is not installed on this system or Unable to open requested registry key.", 0, $Form2)
	GUICtrlSetState($Browse_Button_Backup, $GUI_DISABLE)
EndIf

;==============================================================================================
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg

		Case $GUI_EVENT_CLOSE
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Form2, "int", 1000, "long", 0x00050010);implode
			Exit

		Case $Checkbox_backup_Password
			If GUICtrlRead($Checkbox_backup_Password) = $GUI_CHECKED Then
				GUICtrlSetState($Input_backup_Password, $GUI_ENABLE)
			Else
				GUICtrlSetState($Input_backup_Password, $GUI_DISABLE)
			EndIf

		Case $Checkbox_restore_Password
			If GUICtrlRead($Checkbox_restore_Password) = $GUI_CHECKED Then
				GUICtrlSetState($Input_restore_Password, $GUI_ENABLE)
			Else
				GUICtrlSetState($Input_restore_Password, $GUI_DISABLE)
			EndIf

		Case $Checkbox_restore_Setting_Compression
			If GUICtrlRead($Checkbox_restore_Setting_Compression) = $GUI_CHECKED Then
				GUICtrlSetState($Setting_Compression_Level, $GUI_ENABLE)
			Else
				GUICtrlSetState($Setting_Compression_Level, $GUI_DISABLE)
			EndIf

		Case $Checkbox_restore_Convert_Registry
			If GUICtrlRead($Checkbox_restore_Convert_Registry) = $GUI_CHECKED Then
				GUICtrlSetState($Label_Convert_Registry, $GUI_ENABLE)
			Else
				GUICtrlSetState($Label_Convert_Registry, $GUI_DISABLE)
			EndIf
			;==============================================================================================
		Case $Browse_Button_Backup
			$Backup_path = FileSelectFolder("Choose a folder to save backup...", "", 7, $Intial_Backup_Path, $Form2)
			If StringRight($Backup_path, 1) <> "\" Then $Backup_path &= "\"
			If _FileIsPathValid($Backup_path) = True Then
				If GUICtrlRead($Checkbox_backup_Password) = $GUI_CHECKED Then
					$Backup_7z_path = $Backup_path & "IDMbackup_Encrypted.7z"
				Else
					$Backup_7z_path = $Backup_path & "IDMbackup.7z"
				EndIf
				If FileExists($Backup_7z_path) Then
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox(36, "Confirm Save", "Previous Backup File :-" & @CRLF & $Backup_7z_path & @CRLF & "Already Exists Do You Want To Replace It?", 0, $Form2)
					Select
						Case $iMsgBoxAnswer = 6 ;Yes
							If FileDelete($Backup_7z_path) = 0 Then MsgBox(48, "Warning", "Files Could Not Deleted." & @CRLF & @CRLF & $Backup_7z_path, 0, $Form2)
							GUICtrlSetState($Backup_Button, $GUI_ENABLE)
							GUICtrlSetData($Backup_Input, $Backup_path)
						Case $iMsgBoxAnswer = 7 ;No
							GUICtrlSetData($Backup_Input, "")
							GUICtrlSetState($Backup_Button, $GUI_DISABLE)
					EndSelect
				Else
					GUICtrlSetState($Backup_Button, $GUI_ENABLE)
					GUICtrlSetData($Backup_Input, $Backup_path)
				EndIf
			Else
				MsgBox(48, "Error", "Please Choose Valid Path First", 0, $Form2)
				GUICtrlSetState($Backup_Button, $GUI_DISABLE)
			EndIf

			;==============================================================================================
		Case $Backup_Button
			If GUICtrlRead($Checkbox_backup_Password) = $GUI_CHECKED Then
				$passwd = GUICtrlRead($Input_backup_Password)
				$Backup_7z_temp_path = @TempDir & "\" & "IDMbackup_Encrypted.7z"
				$Backup_reg_temp_path = @TempDir & "\" & "IDMregistry_Encrypted.reg"
			Else
				$passwd = ""
				$Backup_7z_temp_path = @TempDir & "\" & "IDMbackup.7z"
				$Backup_reg_temp_path = @TempDir & "\" & "IDMregistry.reg"
			EndIf

			;==============================================================================================
			AdlibRegister("Update", 333)
			_control_update_busy()

			;==============================================================================================
			$foo_2 = _7Zip_Add($Backup_7z_temp_path, $AppDataIDMFolder, GUICtrlRead($Setting_Compression_Level), $passwd)
			;$foo_2 = 1
			;==============================================================================================
			_regbackup($Backup_reg_temp_path, $regkey_x86_IDM)
			$foo_3 = _7Zip_Update($Backup_7z_temp_path, $Backup_reg_temp_path, GUICtrlRead($Setting_Compression_Level), $passwd)
			FileDelete($Backup_reg_temp_path)
			FileMove($Backup_7z_temp_path, $Backup_path, 1)
			FileDelete($Backup_7z_temp_path)
			;==============================================================================================
			GUICtrlSetState($Browse_Button_Backup, $GUI_ENABLE)
			GUICtrlSetState($Backup_Button, $GUI_ENABLE)
			_control_update_default()
			AdlibUnRegister("Update")
			WinSetTitle($Form2, "", $Win_Title)

			;==============================================================================================
			If $foo_2 = 1 Then
				MsgBox(48, "Warning (Non fatal error(s))", "For example, one or more files were locked by some other application, so they were not compressed.", 0, $Form2)
			ElseIf $foo_2 = 2 Then
				MsgBox(48, "Fatal Error", "Fatal error", 0, $Form2)
			ElseIf $foo_2 = 7 Then
				MsgBox(48, "Error", "Command line error", 0, $Form2)
			ElseIf $foo_2 = 8 Then
				MsgBox(48, "Error", "Not enough memory for operation.", $Form2)
			ElseIf $foo_2 = 255 Then
				MsgBox(48, "Error", "Operation Canclled.", $Form2)
			ElseIf $foo_2 = 0 Then
				MsgBox(0, "Done", "Backup Success.", $Form2)
			EndIf

			GUICtrlSetState($Backup_Button, $GUI_DISABLE)
			RegWrite($regkey_x86_IDMBM, "Backup Folder", "REG_SZ", $Backup_path)

			;==============================================================================================
		Case $Browse_Button_Restore
			$Restore_path = FileSelectFolder("Choose a folder to restore backup...", "", 7, $Intial_Restore_Path, $Form2)
			If StringRight($Restore_path, 1) <> "\" Then $Restore_path &= "\"
			If _FileIsPathValid($Restore_path) = True Then
				If GUICtrlRead($Checkbox_restore_Password) = $GUI_CHECKED Then
					$Restore_7z_path = $Restore_path & "IDMbackup_Encrypted.7z"
				Else
					$Restore_7z_path = $Restore_path & "IDMbackup.7z"
				EndIf
				If Not FileExists($Restore_7z_path) Then
					MsgBox(48, "Error", "Backup File Does Not Exists in This Folder", $Form2)
					GUICtrlSetState($Restore_Button, $GUI_DISABLE)
					GUICtrlSetData($Restore_Input, "")
				Else
					GUICtrlSetState($Restore_Button, $GUI_ENABLE)
					GUICtrlSetData($Restore_Input, $Restore_path)
				EndIf
			Else
				MsgBox(48, "Error", "Please Choose Valid Path First", 0, $Form2)
				GUICtrlSetState($Restore_Button, $GUI_DISABLE)
				GUICtrlSetData($Restore_Input, "")
			EndIf


			;==============================================================================================
		Case $Restore_Button

			If GUICtrlRead($Checkbox_restore_Password) = $GUI_CHECKED Then
				$passwd2 = GUICtrlRead($Input_restore_Password)
				If $passwd2 = "" Then
					MsgBox(0, "Password", "Password Can not Blanck", $Form2)
					ContinueLoop
				EndIf
				$Restore_7z_temp_path = @TempDir & "\" & "IDMbackup_Encrypted.7z"
				$Restore_reg_temp_path = $AppDataIDMFolder & "\" & "IDMregistry_Encrypted.reg"
			Else
				$Restore_7z_temp_path = @TempDir & "\" & "IDMbackup.7z"
				$Restore_reg_temp_path = $AppDataIDMFolder & "\IDMregistry.reg"
				$passwd2 = ""
			EndIf

			;==============================================================================================
			AdlibRegister("Update", 333)
			_control_update_busy()

			;==============================================================================================
			_regbackup(@TempDir & "\" & "ConfigTime.reg", $regkey_x86_IDM & "\ConfigTime")
			_regbackup(@TempDir & "\" & "DwnlPanel.reg", $regkey_x86_IDM & "\DwnlPanel")
			_regbackup(@TempDir & "\" & "DwnlSelPanel.reg", $regkey_x86_IDM & "\DwnlSelPanel")
			_regbackup(@TempDir & "\" & "FoldersTree.reg", $regkey_x86_IDM & "\FoldersTree")
			_regbackup(@TempDir & "\" & "GetAllDlgLS.reg", $regkey_x86_IDM & "\GetAllDlgLS")
			_regbackup(@TempDir & "\" & "GrabberDlgLS.reg", $regkey_x86_IDM & "\GrabberDlgLS")
			_regbackup(@TempDir & "\" & "GrabberSts.reg", $regkey_x86_IDM & "\GrabberSts")
			_regbackup(@TempDir & "\" & "IDMBI.reg", $regkey_x86_IDM & "\IDMBI")
			_regbackup(@TempDir & "\" & "ListSettings.reg", $regkey_x86_IDM & "\ListSettings")
			_regbackup(@TempDir & "\" & "maxID.reg", $regkey_x86_IDM & "\maxID")
			_regbackup(@TempDir & "\" & "MCN.reg", $regkey_x86_IDM & "\MCN")
			_regbackup(@TempDir & "\" & "menuExt.reg", $regkey_x86_IDM & "\menuExt")
			_regbackup(@TempDir & "\" & "netApps.reg", $regkey_x86_IDM & "\netApps")
			_regbackup(@TempDir & "\" & "Passwords.reg", $regkey_x86_IDM & "\Passwords")
			_regbackup(@TempDir & "\" & "Queue.reg", $regkey_x86_IDM & "\Queue")
			_regbackup(@TempDir & "\" & "Scheduler.reg", $regkey_x86_IDM & "\Scheduler")
			_regbackup(@TempDir & "\" & "SpecialKeys.reg", $regkey_x86_IDM & "\SpecialKeys")

			;==============================================================================================
			;RegDelete($regkey_x86_IDM)
			If @error = 1 Then MsgBox(48, "Warning", "Unable to open Requested key.", $Form2)
			If @error = 2 Then MsgBox(48, "Warning", "Unable to open Requested Main key.", $Form2)
			If @error = -1 Then MsgBox(48, "Warning", "Unable to delete Requested Value", $Form2)
			If @error = -2 Then MsgBox(48, "Warning", "Unable to delete Requested Key/Value", $Form2)

			;==============================================================================================
			FileCopy($Restore_7z_path, @TempDir)
			FileDelete($AppDataIDMFolder)
			DirCreate($AppDataIDMFolder)
			$foo_1 = _7Zip_Extract($Restore_7z_temp_path, $AppDataIDMFolder, $passwd2)

			If GUICtrlRead($Checkbox_restore_Convert_Registry) = $GUI_CHECKED Then
				FileCopy($Restore_reg_temp_path, @TempDir & "\IDMregistry_Encrypted.ini", 1)
				$guest_App_Path = IniRead(@TempDir & "\IDMregistry_Encrypted.ini", $regkey_x86_IDM, '"AppDataIDMFolder"', "")
				$guest_Drive = _Drive_Get_From_Path($guest_App_Path)
				MsgBox(48, "Fatal Error", $guest_App_Path, $Form2) ;debug = d:\\asit\\
				MsgBox(48, "Fatal Error", $guest_Drive, $Form2) ;debug  = d:
				$host_App_Path = StringReplace(($AppDataIDMFolder), "\", "\\")
				$host_drive = _Drive_Get_From_Path($host_App_Path)
				MsgBox(48, "Fatal Error", $host_App_Path, $Form2) ;debug c:\\asit\\
				MsgBox(48, "Fatal Error", $host_drive, $Form2) ;debug c:
				_ReplaceStringInFile(@TempDir & "\IDMregistry_Encrypted.ini", $guest_App_Path, $host_App_Path)
				FileMove(@TempDir & "\IDMregistry_Encrypted.ini", @TempDir & "\IDMregistry_Encrypted.reg", 1)
				ShellExecuteWait(@TempDir & "\IDMregistry_Encrypted.reg")
			Else
				ShellExecuteWait($Restore_reg_temp_path)
			EndIf

			If FileExists(@TempDir & "\" & "ConfigTime.reg") Then ShellExecuteWait(@TempDir & "\" & "ConfigTime.reg")
			If FileExists(@TempDir & "\" & "DwnlPanel.reg") Then ShellExecuteWait(@TempDir & "\" & "DwnlPanel.reg")
			If FileExists(@TempDir & "\" & "DwnlSelPanel.reg") Then ShellExecuteWait(@TempDir & "\" & "DwnlSelPanel.reg")
			If FileExists(@TempDir & "\" & "FoldersTree.reg") Then ShellExecuteWait(@TempDir & "\" & "FoldersTree.reg")
			If FileExists(@TempDir & "\" & "GetAllDlgLS.reg") Then ShellExecuteWait(@TempDir & "\" & "GetAllDlgLS.reg")
			If FileExists(@TempDir & "\" & "GrabberDlgLS.reg") Then ShellExecuteWait(@TempDir & "\" & "GrabberDlgLS.reg")
			If FileExists(@TempDir & "\" & "GrabberSts.reg") Then ShellExecuteWait(@TempDir & "\" & "GrabberSts.reg")
			If FileExists(@TempDir & "\" & "IDMBI.reg") Then ShellExecuteWait(@TempDir & "\" & "IDMBI.reg")
			If FileExists(@TempDir & "\" & "ListSettings.reg") Then ShellExecuteWait(@TempDir & "\" & "ListSettings.reg")
			If FileExists(@TempDir & "\" & "maxID.reg") Then ShellExecuteWait(@TempDir & "\" & "maxID.reg")
			If FileExists(@TempDir & "\" & "MCN.reg") Then ShellExecuteWait(@TempDir & "\" & "MCN.reg")
			If FileExists(@TempDir & "\" & "menuExt.reg") Then ShellExecuteWait(@TempDir & "\" & "menuExt.reg")
			If FileExists(@TempDir & "\" & "netApps.reg") Then ShellExecuteWait(@TempDir & "\" & "netApps.reg")
			If FileExists(@TempDir & "\" & "Passwords.reg") Then ShellExecuteWait(@TempDir & "\" & "Passwords.reg")
			If FileExists(@TempDir & "\" & "Queue.reg") Then ShellExecuteWait(@TempDir & "\" & "Queue.reg")
			If FileExists(@TempDir & "\" & "Scheduler.reg") Then ShellExecuteWait(@TempDir & "\" & "Scheduler.reg")
			If FileExists(@TempDir & "\" & "SpecialKeys.reg") Then ShellExecuteWait(@TempDir & "\" & "SpecialKeys.reg")

			_RegWrite($regkey_x86_IDM, "AppDataIDMFolder", $REG_SZ, $Reg_Read_AppDataIDMFolder)
			_RegWrite($regkey_x86_IDM, "bComlDlgVMS", $REG_DWORD, $Reg_Read_bComlDlgVMS)
			_RegWrite($regkey_x86_IDM, "bHDIShwd", $REG_DWORD, $Reg_Read_bHDIShwd)
			_RegWrite($regkey_x86_IDM, "bIgnMTCh", $REG_DWORD, $Reg_Read_bIgnMTCh)
			_RegWrite($regkey_x86_IDM, "bQueueSelPnlOnDlLt", $REG_DWORD, $Reg_Read_bQueueSelPnlOnDlLt)
			_RegWrite($regkey_x86_IDM, "bQueueSelPnlOnDlLtQID", $REG_DWORD, $Reg_Read_bQueueSelPnlOnDlLtQID)
			_RegWrite($regkey_x86_IDM, "bQueueSelPnlOnDlLtSt", $REG_DWORD, $Reg_Read_bQueueSelPnlOnDlLtSt)
			_RegWrite($regkey_x86_IDM, "bQueueSelPnlOnGAL", $REG_DWORD, $Reg_Read_bQueueSelPnlOnGAL)
			_RegWrite($regkey_x86_IDM, "bShBTtFQCI", $REG_DWORD, $Reg_Read_bShBTtFQCI)
			_RegWrite($regkey_x86_IDM, "bShFFTip1", $REG_DWORD, $Reg_Read_bShFFTip1)
			_RegWrite($regkey_x86_IDM, "bShTipDD", $REG_DWORD, $Reg_Read_bShTipDD)
			_RegWrite($regkey_x86_IDM, "bShTipFLVPlayer", $REG_DWORD, $Reg_Read_bShTipFLVPlayer)
			_RegWrite($regkey_x86_IDM, "ComplDlgShowing", $REG_DWORD, $Reg_Read_ComplDlgShowing)
			_RegWrite($regkey_x86_IDM, "ConnectionSpeed", $REG_DWORD, $Reg_Read_ConnectionSpeed)
			_RegWrite($regkey_x86_IDM, "ConnectionType", $REG_DWORD, $Reg_Read_ConnectionType)
			_RegWrite($regkey_x86_IDM, "DialUpEntry", $REG_SZ, $Reg_Read_DialUpEntry)
			_RegWrite($regkey_x86_IDM, "dPrDtVis", $REG_DWORD, $Reg_Read_dPrDtVis)
			_RegWrite($regkey_x86_IDM, "DuplLinksA", $REG_DWORD, $Reg_Read_DuplLinksA)
			_RegWrite($regkey_x86_IDM, "Email", $REG_SZ, $Reg_Read_Email)
			_RegWrite($regkey_x86_IDM, "EnableDriver", $REG_DWORD, $Reg_Read_EnableDriver)
			_RegWrite($regkey_x86_IDM, "evDownloadComplete", $REG_NONE, $Reg_Read_evDownloadComplete)
			_RegWrite($regkey_x86_IDM, "evDownloadFailed", $REG_NONE, $Reg_Read_evDownloadFailed)
			_RegWrite($regkey_x86_IDM, "evQueueFinished", $REG_NONE, $Reg_Read_evQueueFinished)
			_RegWrite($regkey_x86_IDM, "evQueueStarted", $REG_NONE, $Reg_Read_evQueueStarted)
			_RegWrite($regkey_x86_IDM, "ExceptionProxyServers", $REG_SZ, $Reg_Read_ExceptionProxyServers)
			_RegWrite($regkey_x86_IDM, "ExceptionServers", $REG_SZ, $Reg_Read_ExceptionServers)
			_RegWrite($regkey_x86_IDM, "ExePath", $REG_SZ, $Reg_Read_ExePath)
			_RegWrite($regkey_x86_IDM, "ExpImpIniPath", $REG_SZ, $Reg_Read_ExpImpIniPath)
			_RegWrite($regkey_x86_IDM, "Extensions", $REG_SZ, $Reg_Read_Extensions)
			_RegWrite($regkey_x86_IDM, "FindApps", $REG_DWORD, $Reg_Read_FindApps)
			_RegWrite($regkey_x86_IDM, "FName", $REG_SZ, $Reg_Read_FName)
			_RegWrite($regkey_x86_IDM, "FSSettingsChecked", $REG_DWORD, $Reg_Read_FSSettingsChecked)
			_RegWrite($regkey_x86_IDM, "FtpPasive", $REG_DWORD, $Reg_Read_FtpPasive)
			_RegWrite($regkey_x86_IDM, "FtpPort", $REG_SZ, $Reg_Read_FtpPort)
			_RegWrite($regkey_x86_IDM, "FtpProxy", $REG_SZ, $Reg_Read_FtpProxy)
			_RegWrite($regkey_x86_IDM, "GetAllWindowPlacement", $REG_NONE, $Reg_Read_GetAllWindowPlacement)
			_RegWrite($regkey_x86_IDM, "GrabberWindowPlacement", $REG_NONE, $Reg_Read_GrabberWindowPlacement)
			_RegWrite($regkey_x86_IDM, "HttpProxy", $REG_SZ, $Reg_Read_HttpProxy)
			_RegWrite($regkey_x86_IDM, "HttpsPort", $REG_SZ, $Reg_Read_HttpsPort)
			_RegWrite($regkey_x86_IDM, "HttpsProxy", $REG_SZ, $Reg_Read_HttpsProxy)
			_RegWrite($regkey_x86_IDM, "idmvers", $REG_SZ, $Reg_Read_idmvers)
			_RegWrite($regkey_x86_IDM, "intAOFRWE", $REG_DWORD, $Reg_Read_intAOFRWE)
			_RegWrite($regkey_x86_IDM, "IntegrateMIE", $REG_DWORD, $Reg_Read_IntegrateMIE)
			_RegWrite($regkey_x86_IDM, "IntegrateNN", $REG_DWORD, $Reg_Read_IntegrateNN)
			_RegWrite($regkey_x86_IDM, "isSSW_OK", $REG_DWORD, $Reg_Read_isSSW_OK)
			_RegWrite($regkey_x86_IDM, "isUseWinDialUp", $REG_DWORD, $Reg_Read_isUseWinDialUp)
			_RegWrite($regkey_x86_IDM, "LargeButtons", $REG_DWORD, $Reg_Read_LargeButtons)
			_RegWrite($regkey_x86_IDM, "LastCheck", $REG_SZ, $Reg_Read_LastCheck)
			_RegWrite($regkey_x86_IDM, "LastCheckQU", $REG_NONE, $Reg_Read_LastCheckQU)
			_RegWrite($regkey_x86_IDM, "lastintres", $REG_DWORD, $Reg_Read_lastintres)
			_RegWrite($regkey_x86_IDM, "LaunchOnStart", $REG_DWORD, $Reg_Read_LaunchOnStart)
			_RegWrite($regkey_x86_IDM, "LName", $REG_SZ, $Reg_Read_LName)
			_RegWrite($regkey_x86_IDM, "LocalPathW", $REG_NONE, $Reg_Read_LocalPathW)
			_RegWrite($regkey_x86_IDM, "lstbhotime", $REG_NONE, $Reg_Read_lstbhotime)
			_RegWrite($regkey_x86_IDM, "lstbhotime2", $REG_NONE, $Reg_Read_lstbhotime2)
			_RegWrite($regkey_x86_IDM, "mAttempts", $REG_DWORD, $Reg_Read_mAttempts)
			_RegWrite($regkey_x86_IDM, "MaxConnectionsNumber", $REG_DWORD, $Reg_Read_MaxConnectionsNumber)
			_RegWrite($regkey_x86_IDM, "MessageID", $REG_SZ, $Reg_Read_MessageID)
			_RegWrite($regkey_x86_IDM, "MonitorUrlClipboard", $REG_DWORD, $Reg_Read_MonitorUrlClipboard)
			_RegWrite($regkey_x86_IDM, "mRedialTime", $REG_DWORD, $Reg_Read_mRedialTime)
			_RegWrite($regkey_x86_IDM, "mzcc_ext_vers", $REG_DWORD, $Reg_Read_mzcc_ext_vers)
			_RegWrite($regkey_x86_IDM, "mzcc_vers", $REG_DWORD, $Reg_Read_mzcc_vers)
			_RegWrite($regkey_x86_IDM, "nDESC7", $REG_DWORD, $Reg_Read_nDESC7)
			_RegWrite($regkey_x86_IDM, "nDESC8", $REG_DWORD, $Reg_Read_nDESC8)
			_RegWrite($regkey_x86_IDM, "PrgrDlgVisiblity", $REG_DWORD, $Reg_Read_PrgrDlgVisiblity)
			_RegWrite($regkey_x86_IDM, "ptrk_scdt", $REG_NONE, $Reg_Read_ptrk_scdt)
			_RegWrite($regkey_x86_IDM, "RememberDuplLinksA", $REG_DWORD, $Reg_Read_RememberDuplLinksA)
			_RegWrite($regkey_x86_IDM, "RememberLastSave", $REG_DWORD, $Reg_Read_RememberLastSave)
			_RegWrite($regkey_x86_IDM, "RunIEMonitor", $REG_DWORD, $Reg_Read_RunIEMonitor)
			_RegWrite($regkey_x86_IDM, "scansk", $REG_NONE, $Reg_Read_scansk)
			_RegWrite($regkey_x86_IDM, "Serial", $REG_SZ, $Reg_Read_Serial)
			_RegWrite($regkey_x86_IDM, "ShowDropTarget", $REG_DWORD, $Reg_Read_ShowDropTarget)
			_RegWrite($regkey_x86_IDM, "showHTDlFsnMsg", $REG_NONE, $Reg_Read_showHTDlFsnMsg)
			_RegWrite($regkey_x86_IDM, "showHTDlShSMsg", $REG_NONE, $Reg_Read_showHTDlShSMsg)
			_RegWrite($regkey_x86_IDM, "ShowTipOnFirstCatch", $REG_DWORD, $Reg_Read_ShowTipOnFirstCatch)
			_RegWrite($regkey_x86_IDM, "sortOrder", $REG_DWORD, $Reg_Read_sortOrder)
			_RegWrite($regkey_x86_IDM, "StartDlgShowing", $REG_DWORD, $Reg_Read_StartDlgShowing)
			_RegWrite($regkey_x86_IDM, "StImmMsg", $REG_DWORD, $Reg_Read_StImmMsg)
			_RegWrite($regkey_x86_IDM, "TempPath", $REG_SZ, $Reg_Read_TempPath)
			_RegWrite($regkey_x86_IDM, "TipFilePos", $REG_DWORD, $Reg_Read_TipFilePos)
			_RegWrite($regkey_x86_IDM, "TipStartUp", $REG_DWORD, $Reg_Read_TipStartUp)
			_RegWrite($regkey_x86_IDM, "TipTimeStamp", $REG_SZ, $Reg_Read_TipTimeStamp)
			_RegWrite($regkey_x86_IDM, "ToolbarState_v5.11", $REG_BINARY, $Reg_Read_ToolbarState_v511)
			_RegWrite($regkey_x86_IDM, "ToolbarStyle", $REG_SZ, $Reg_Read_ToolbarStyle)
			_RegWrite($regkey_x86_IDM, "TrayIcon", $REG_DWORD, $Reg_Read_TrayIcon)
			_RegWrite($regkey_x86_IDM, "tvfrdt", $REG_NONE, $Reg_Read_tvfrdt)
			_RegWrite($regkey_x86_IDM, "UseFtpProxy", $REG_DWORD, $Reg_Read_UseFtpProxy)
			_RegWrite($regkey_x86_IDM, "UseHttpProxy", $REG_DWORD, $Reg_Read_UseHttpProxy)
			_RegWrite($regkey_x86_IDM, "UseHttpsProxy", $REG_DWORD, $Reg_Read_UseHttpsProxy)
			_RegWrite($regkey_x86_IDM, "windowPlacementV5", $REG_NONE, $Reg_Read_windowPlacementV5)

			If FileExists(@TempDir & "\" & "ConfigTime.reg") Then FileDelete(@TempDir & "\" & "ConfigTime.reg")
			If FileExists(@TempDir & "\" & "DwnlPanel.reg") Then FileDelete(@TempDir & "\" & "DwnlPanel.reg")
			If FileExists(@TempDir & "\" & "DwnlSelPanel.reg") Then FileDelete(@TempDir & "\" & "DwnlSelPanel.reg")
			If FileExists(@TempDir & "\" & "FoldersTree.reg") Then FileDelete(@TempDir & "\" & "FoldersTree.reg")
			If FileExists(@TempDir & "\" & "GetAllDlgLS.reg") Then FileDelete(@TempDir & "\" & "GetAllDlgLS.reg")
			If FileExists(@TempDir & "\" & "GrabberDlgLS.reg") Then FileDelete(@TempDir & "\" & "GrabberDlgLS.reg")
			If FileExists(@TempDir & "\" & "GrabberSts.reg") Then FileDelete(@TempDir & "\" & "GrabberSts.reg")
			If FileExists(@TempDir & "\" & "IDMBI.reg") Then FileDelete(@TempDir & "\" & "IDMBI.reg")
			If FileExists(@TempDir & "\" & "ListSettings.reg") Then FileDelete(@TempDir & "\" & "ListSettings.reg")
			If FileExists(@TempDir & "\" & "maxID.reg") Then FileDelete(@TempDir & "\" & "maxID.reg")
			If FileExists(@TempDir & "\" & "MCN.reg") Then FileDelete(@TempDir & "\" & "MCN.reg")
			If FileExists(@TempDir & "\" & "menuExt.reg") Then FileDelete(@TempDir & "\" & "menuExt.reg")
			If FileExists(@TempDir & "\" & "netApps.reg") Then FileDelete(@TempDir & "\" & "netApps.reg")
			If FileExists(@TempDir & "\" & "Passwords.reg") Then FileDelete(@TempDir & "\" & "Passwords.reg")
			If FileExists(@TempDir & "\" & "Queue.reg") Then FileDelete(@TempDir & "\" & "Queue.reg")
			If FileExists(@TempDir & "\" & "Scheduler.reg") Then FileDelete(@TempDir & "\" & "Scheduler.reg")
			If FileExists(@TempDir & "\" & "SpecialKeys.reg") Then FileDelete(@TempDir & "\" & "SpecialKeys.reg")
			;==============================================================================================
			_control_update_default()
			AdlibUnRegister("Update")
			WinSetTitle($Form2, "", $Win_Title)

			If $foo_1 = 1 Then
				MsgBox(48, "Warning (Non fatal error(s))", "For example, one or more files were locked by some other application, so they were not compressed.", 0, $Form2)
			ElseIf $foo_1 = 2 Then
				MsgBox(48, "Fatal Error", "Fatal error", 0, $Form2)
			ElseIf $foo_1 = 7 Then
				MsgBox(48, "Error", "Command line error", 0, $Form2)
			ElseIf $foo_1 = 8 Then
				MsgBox(48, "Error", "Not enough memory for operation.", 0, $Form2)
			ElseIf $foo_1 = 255 Then
				MsgBox(48, "Error", "Operation Canclled.", 0, $Form2)
			ElseIf $foo_1 = 0 Then
				MsgBox(0, "Done", "Restore Success.", 0, $Form2)
			EndIf

		Case $Analyze
			_GUICtrlListView_DeleteAllItems($ListView1)
			Local $i = 1
			While 1
				Local $var = RegEnumKey("HKEY_CURRENT_USER\Software\DownloadManager", $i)
				If @error <> 0 Then ExitLoop
				Local $var2 = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $var, "LocalFileName")
				If FileExists($var2) Then GUICtrlCreateListViewItem(_Name_Get_From_Path($var2) & "|" & _Ext_Get_From_Path($var2) & "|" & $var, $ListView1)
				$i += 1
			WEnd

		Case $Details
			$ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "ID")), "|")
			Local $var_fILE_NAME = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "FileName")
			Local $var_fILE_LocalFileName = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "LocalFileName")
			Local $var_fILE_LastModified = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "LastModified")
			Local $var_fILE_lastTryDate = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "lastTryDate")
			Local $var_fILE_Referer = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "Referer")
			Local $var_fILE_Url0 = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "Url0")

			MsgBox(64, "File Info", "Name:" & @CRLF & $var_fILE_NAME & @CRLF & @CRLF _
					 & "Path:" & @CRLF & $var_fILE_LocalFileName & @CRLF & @CRLF _
					 & "Last Modified:" & @CRLF & $var_fILE_LastModified & @CRLF & @CRLF _
					 & "Last Try Date:" & @CRLF & $var_fILE_lastTryDate & @CRLF & @CRLF _
					 & "Referer URL:" & @CRLF & $var_fILE_Referer & @CRLF & @CRLF _
					 & "Download Link:" & @CRLF & $var_fILE_Url0)

		Case $Start_Join
			$ID = StringSplit(GUICtrlRead(GUICtrlRead($ListView1, "ID")), "|")
			Local $var_fILE_NAME = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "FileName")
			Local $var_fILE_LocalPath = RegRead("HKEY_CURRENT_USER\Software\DownloadManager" & "\" & $ID[3], "LocalPath")

			Local $search = FileFindFirstFile($var_fILE_LocalPath &  $var_fILE_NAME & "*.*")
			If $search = -1 Then
				MsgBox(0, "Error", "No files/directories matched the search pattern")
				Exit
			EndIf
Local $file_join = ""
			While 1

				Local $file = FileFindNextFile($search)
				If @error Then ExitLoop
				$file_join += FileOpen($file)
				MsgBox(4096, "File:", $file)
			WEnd
FileWrite("e:\11.ee",$file)
			; Close the search handle
			FileClose($search)

			;FileOpen()












		Case $Update
			If _IsInternetConnected() = "True" Then
				Local $Update_VER = InetRead("http://www.geocities.ws/gajjartejas/IDM_Backup_Manager/v0.9.1/update.txt", 1)
				Switch BinaryToString($Update_VER)
					Case ""
						MsgBox(48, "Error", "Time Out!", 0, $Form2)
					Case "0.9.1"
						MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $Form2)
					Case "0.9.2"
						MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $Form2)
					Case "0.9.3"
						MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $Form2)
					Case Else
						MsgBox(64, "Availabe", "You Should Download Following Version" & BinaryToString($Update_VER), 0, $Form2)
				EndSwitch
			Else
				MsgBox(48, "Error", "Internet connection could not found.", 0, $Form2)
			EndIf

		Case $Help
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/Start_page.htm"')

		Case $Licence
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/General_Information.htm"')

		Case $Website
			ShellExecute("http://gajjartejas26.blogspot.com")
		Case $Website_Label
			ShellExecute("http://gajjartejas26.blogspot.com")

		Case $Exit
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Form2, "int", 1000, "long", 0x00050010);implode
			Exit
		Case $Backup_Input
		Case $Restore_Input
	EndSwitch
WEnd

Func _7Zip_Extract($sZipFile, $sDestinationFolder, $sPassword = "")
	If FileExists($sZipFile) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If StringRight($sDestinationFolder, 1) <> "\" Then
		$sDestinationFolder &= "\"
	EndIf
	If FileExists($sDestinationFolder) = 0 Then
		DirCreate($sDestinationFolder)
	EndIf
	If $sPassword <> "" Then
		$sPassword = "-p" & '"' & $sPassword & '" '
	EndIf
	If FileExists($sDestinationFolder & "\" & "7z.exe") = 0 Then
		FileInstall("7z.exe", $sDestinationFolder & "\" & "7z.exe", 0)
	EndIf
	Return RunWait(@ScriptDir & '\7z.exe' & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"', "", @SW_HIDE)
EndFunc   ;==>_7Zip_Extract

; #FUNCTION# ====================================================================================================================
; Name...........:  _7Zip_Add
; Description....:  Add a folder to 7z file
; Syntax.........:  _7Zip_Add($sZipFile, $sDestinationFolder, $sCompression, $sPassword)
; Parameters.....:  $sZipFile - "c:\dir1\dir2\name.7z"
;					$sDestinationFolder - "c:\dir1\dir2\"
;					$sCompression   - "1-Store/None"
;									- "2-Fastest"
;									- "3-Fast"
;									- "4-Normal"
;									- "5-Maximum"
;									- "6-Ultra"
;					$sPassword - "any password
; Return values..: Success - 1.
;				   Failure - 0 and sets the @error flag to non-zero.
; Author.........: Gajjar Tejas
; Modified.......:
; Remarks........: This Function adds all files and subfolders from folder subdir to archive $s7z_File_Save_Name ="c:\dir1\dir2\name.7z". The filenames in archive will not contain subdir\ prefix.

; Related........:
; Link...........:
; Example........: _7Zip_Add("C:\Users\Tejas\Desktop\New folder (2)\Name.7z", "C:\Users\Tejas\Desktop\New folder (2)", "1-Store/None", "11")
Func _7Zip_Add($s7z_File_Save_Name, $sDestinationFolder, $sCompression, $sPassword)
	If FileExists($sDestinationFolder) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If StringRight($sDestinationFolder, 1) <> "\" Then
		$sDestinationFolder &= "\"
	EndIf
	If $sPassword <> "" Then
		$sPassword = "-p" & '"' & $sPassword & '" '
	EndIf
	If $sCompression <> "" Then
		Switch $sCompression
			Case "1-No Compression"
				$sCompression = " -mx0"
			Case "2-Fastest Compression"
				$sCompression = " -mx1"
			Case "3-Fast Compression"
				$sCompression = " -mx3"
			Case "4-Normal Compression"
				$sCompression = " -mx5"
			Case "5-Maximum Compression"
				$sCompression = " -mx7"
			Case "6-Ultra Compression"
				$sCompression = " -mx9"
		EndSwitch
	EndIf
	Return RunWait(@ScriptDir & "\7z.exe" & " " & "a" & " " & '"' & $s7z_File_Save_Name & '"' & $sCompression & " " & $sPassword & '"' & $sDestinationFolder & "\*" & '"', "") ;, @SW_HIDE
EndFunc   ;==>_7Zip_Add

Func _7Zip_Update($name_of_archive, $name_file_to_update, $sCompression, $sPassword)
	If FileExists($name_of_archive) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If FileExists($name_file_to_update) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If $sPassword <> "" Then
		$sPassword = "-p" & '"' & $sPassword & '" '
	EndIf
	If $sCompression <> "" Then
		Switch $sCompression
			Case "1-No Compression"
				$sCompression = " -mx0"
			Case "2-Fastest Compression"
				$sCompression = " -mx1"
			Case "3-Fast Compression"
				$sCompression = " -mx3"
			Case "4-Normal Compression"
				$sCompression = " -mx5"
			Case "5-Maximum Compression"
				$sCompression = " -mx7"
			Case "6-Ultra Compression"
				$sCompression = " -mx9"
		EndSwitch
	EndIf
	Return RunWait(@ScriptDir & "\7z.exe" & " " & "u" & " " & '"' & $name_of_archive & '"' & $sCompression & " " & $sPassword & " " & '"' & $name_file_to_update & '"', "") ;, @SW_HIDE
EndFunc   ;==>_7Zip_Update


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


;_regbackup(c:\path\name1.reg",     hku\folder1\folder2)
;_regbackup(@TempDir & "\" & "Scheduler.reg", $regkey_x86_IDM & "\Scheduler")
Func _regbackup($s7z_File_Save_Name, $regkey)
	ShellExecuteWait('regedit.exe', '/e "' & $s7z_File_Save_Name & '"' & " " & $regkey)
EndFunc   ;==>_regbackup

;_regbackup(c:\path\name1.reg",     hku\folder1\folder2)
;_regbackup(@TempDir & "\" & "Scheduler.reg", $regkey_x86_IDM & "\Scheduler")
Func _reg_import($s7z_File_Save_Name, $regkey)
	ShellExecuteWait('regedit.exe', '/s /c "' & $s7z_File_Save_Name & '"' & " " & $regkey)
EndFunc   ;==>_reg_import

Func Update()
	GUICtrlSetData($Progress1, -1)
EndFunc   ;==>Update

Func _control_update_busy()
	GUICtrlSetState($Browse_Button_Backup, $GUI_DISABLE)
	GUICtrlSetState($Browse_Button_Backup, $GUI_DISABLE)
	GUICtrlSetState($Backup_Button, $GUI_DISABLE)
	GUICtrlSetState($Browse_Button_Restore, $GUI_DISABLE)
	GUICtrlSetState($Restore_Button, $GUI_DISABLE)
	GUICtrlSetState($Exit, $GUI_DISABLE)
	GUISetCursor(15, 1, $Form2)
	GUISetCursor(-1, 1, $Exit)
	GUISetCursor(15, 1, $TabSheet1)
	GUISetCursor(15, 1, $Backup_Input)
	GUISetCursor(15, 1, $TabSheet2)
	GUISetCursor(15, 1, $Restore_Input)
	GUISetCursor(15, 1, $Licence)
	GUISetCursor(15, 1, $Website)
	GUISetCursor(15, 1, $Update)
EndFunc   ;==>_control_update_busy

Func _control_update_default()
	GUICtrlSetState($Browse_Button_Backup, $GUI_ENABLE)
	GUICtrlSetState($Backup_Button, $GUI_ENABLE)
	GUICtrlSetState($Browse_Button_Restore, $GUI_ENABLE)
	GUICtrlSetState($Restore_Button, $GUI_ENABLE)
	GUICtrlSetState($Exit, $GUI_ENABLE)
	GUISetCursor(-1, 1, $Form2)
	GUISetCursor(-1, 1, $Exit)
	GUISetCursor(-1, 1, $TabSheet1)
	GUISetCursor(-1, 1, $Backup_Input)
	GUISetCursor(-1, 1, $TabSheet2)
	GUISetCursor(-1, 1, $Restore_Input)
	GUISetCursor(-1, 1, $Licence)
	GUISetCursor(-1, 1, $Website)
	GUISetCursor(-1, 1, $Update)
EndFunc   ;==>_control_update_default

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

Func _IsInternetConnected()
	Local $aReturn = DllCall('connect.dll', 'long', 'IsInternetConnected')
	If @error Then
		Return SetError(1, 0, False)
	EndIf
	Return $aReturn[0] = 0
EndFunc   ;==>_IsInternetConnected