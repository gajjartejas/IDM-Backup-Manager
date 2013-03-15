
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <ComboConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <String.au3>
#include <File.au3>
#include <Crypt.au3>
#include "GUIFade.au3"
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
Global $regkey_x86_IDM = "HKEY_CURRENT_USER\Software\DownloadManager"
Global $regkey_x86_IDMBM = "HKEY_CURRENT_USER\Software\IDM Backup Manager"
Global $current_version = "0.9.3"
Global $Win_Title = "IDM Backup Manager" & $current_version & "(Beta)"

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
If @OSArch = "X64" Then ;**** Check the OS version ****
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(16, "Exiting", "OS Not Support.", 5)
	Select
		Case $iMsgBoxAnswer = -1
			Exit -1
		Case Else
			Exit -1
	EndSelect
EndIf

If ProcessExists("idman.exe1") Then ;**** Check the process "idman.exe" exists or not ****
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(4, "IDM Need To Close", "Close IDM Before You Can Continue.Do You Want To Close IDM?")
	Select
		Case $iMsgBoxAnswer = 6 ;Yes
			ProcessClose("idman.exe")
		Case $iMsgBoxAnswer = 7 ;No
			Exit (2)
	EndSelect
EndIf

If Not FileExists("setting.ini") Then
	MsgBox(48, "setting.ini", "Setting.ini Not Found! Restoring Default Setting.")
	If Not _FileCreate("setting.ini") Then
		MsgBox(4096, "setting.ini", "Error While Creating Setting.ini Restoring Default Setting.")
	EndIf
	$ini_Data = "Setting_Encrypt=No" & @LF & "Setting_Compression_Level=4-Normal" & @LF & "Setting_Convert_Registry=Yes"
	IniWriteSection("setting.ini", "Setting", $ini_Data)
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
#region
If ProcessExists("7z.exe") Then ProcessClose("7z.exe")
If ProcessExists("regedit.exe") Then ProcessClose("regedit.exe")
If FileExists(@TempDir & "\IDMregistry.reg") Then FileDelete(@TempDir & "\IDMregistry.reg")
If FileExists(@TempDir & "\IDMbackup.7z") Then FileDelete(@TempDir & "\IDMregistry.reg")
If FileExists(@TempDir & "\IDMregistry_Encrypted1.reg") Then FileDelete(@TempDir & "\IDMregistry_Encrypted1.reg")
#endregion

;==============================================================================================
#region
$p = 0
$p2 = 0
$Increase = 0
#endregion


;**** Create main GUI of the IDM Backup Manager ****
;==============================================================================================
#region ### START Koda GUI section ### Form=C:\Users\Tejas\Desktop\idm\Form2.kxf
$Form2 = GUICreate($Win_Title, 327, 187, (@DesktopWidth - 327) / 2, (@DesktopHeight - 187) / 2) ;BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME)

GUISetBkColor(0xFFFFFF)

$Tab1 = GUICtrlCreateTab(0, 80, 324, 103)

GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

$TabSheet1 = GUICtrlCreateTabItem("Backup Setting")
$Backup_Input = GUICtrlCreateInput(" ", 6, 119, 266, 22, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$Browse_Button_Backup = GUICtrlCreateButton("", 276, 117, 40, 25, $BS_ICON)
GUICtrlSetImage(-1, "Resorces\Browse_Save.ico", -1)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "If You Want To Encrypt Your Backup Please Do" & @CRLF & "Setting--> Encyypt Backup-->Yes", "Browse For Backup Folder", 1, 1)
GUICtrlSetCursor(-1, 0)
$Backup_Button = GUICtrlCreateButton("Backup", 241, 147, 75, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "If You Want To Compress Your Backup Please Do" & @CRLF & "Setting--> Compression Level-->Very High or Ultra", "Backup Button", 1, 1)
GUICtrlSetCursor(-1, 0)
$Label1 = GUICtrlCreateLabel("", 4, 155, 161, 24)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)
GUICtrlSetData(-1, "Ready")

$TabSheet2 = GUICtrlCreateTabItem("Restore Setting")
$Restore_Input = GUICtrlCreateInput("", 6, 119, 266, 22, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$Browse_Button_Restore = GUICtrlCreateButton("", 276, 117, 40, 25, $BS_ICON)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetImage(-1, "Resorces\Browse_Open.ico", -1)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "If You Want To Restore Encrypt Backup Please Do" & @CRLF & "Setting--> Encyypt Backup-->Yes" & @CRLF & @CRLF & "If You Want To Restore Normal Backup Please Do" & @CRLF & "Setting--> Encyypt Backup-->No", "Browse For Backup Folder", 1, 1)
GUICtrlSetCursor(-1, 0)
$Restore_Button = GUICtrlCreateButton("Restore", 241, 147, 75, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "If You Want To Convert Path Please Do" & @CRLF & "Setting--> Convert Registry-->Yes(Default)", "Restore Now", 1, 1)
GUICtrlSetCursor(-1, 0)
$Label2 = GUICtrlCreateLabel("", 4, 155, 161, 24)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)
GUICtrlSetData($Label2, "Ready")

$TabSheet3 = GUICtrlCreateTabItem("Setting")
GUICtrlSetState(-1, $GUI_SHOW)
$Encrypt_Backup_Label = GUICtrlCreateLabel("Encrypt Backup", 10, 105, 80, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)
$Compression_Level_Label = GUICtrlCreateLabel("Compression Level", 10, 130, 93, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)
$Convert_Registry_Label = GUICtrlCreateLabel("Convert Registry", 10, 155, 82, 17)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)

$Setting_Encrypt = GUICtrlCreateCombo("Yes", 115, 105, 120, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "No", IniRead("setting.ini", "Setting", "Setting_Encrypt", "No"))
GUICtrlSetTip(-1, "Choose Yes If You Want Encryption of Your Backup Files Which Is Required Strong Password", "Backup Encryption", 1, 1)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$Setting_Compression_Level = GUICtrlCreateCombo("1-Store/None", 115, 130, 120, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "2-Fastest|3-Fast|4-Normal|5-Maximum|6-Ultra", IniRead("setting.ini", "Setting", "Setting_Compression_Level", "4-Normal"))
GUICtrlSetTip(-1, "Here You Can Set The Compression Ratio of The Backup Files" & @CRLF & "", "Compression Ratio", 1, 1)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$Setting_Convert_Registry = GUICtrlCreateCombo("Yes", 115, 155, 120, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "No", IniRead("setting.ini", "Setting", "Setting_Convert_Registry", "Yes"))
GUICtrlSetTip(-1, "Choose Yes If Destination Backup is another System" & @CRLF & @CRLF & "EXAMPLE:" & @CRLF & "Incase of If You Want To Restore Backup of Cybercafe to Your Home PC", "Convert Registry", 1, 1)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
$Save_Setting_Button = GUICtrlCreateButton("Save Setting", 240, 120, 75, 45)
GUICtrlSetTip(-1, "Save Current Setting In INI File", "Save Setting", 1, 1)
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlCreateTabItem("")

$TabSheet4 = GUICtrlCreateTabItem("About")
$Help = GUICtrlCreateButton("Help", 125, 107, 85, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Read_ME = GUICtrlCreateButton("Read Me", 125, 131, 86, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Licence = GUICtrlCreateButton("Licence", 125, 155, 86, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Thanks = GUICtrlCreateButton("Thanks", 230, 107, 86, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Aurther = GUICtrlCreateButton("Aurther", 230, 131, 86, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Website = GUICtrlCreateButton("Website", 230, 155, 86, 21)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetCursor(-1, 4)
$Update = GUICtrlCreateButton(" ", 20, 107, 66, 66, $BS_ICON)
GUICtrlSetImage(-1, "Resorces\66x66.ico", -1)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GUICtrlSetTip(-1, "Check For Latest Version", "Update", 1, 1)
GUICtrlSetCursor(-1, 0)

GUICtrlCreateTabItem("")
$Pic1 = GUICtrlCreatePic("Resorces\Banner.jpg", 0, 0, 326, 76, "-1", $GUI_WS_EX_PARENTDRAG)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
_FadeGUIIn($Form2, 255)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###


;==============================================================================================
_GUICtrlButton_Enable($Restore_Button, False)
_GUICtrlButton_Enable($Backup_Button, False)

$AppDataIDMFolder = RegRead($regkey_x86_IDM, "AppDataIDMFolder")
If @error <> 0 Then
	MsgBox(16, "Error", "IDM is not installed on this system or Unable to open requested registry key.", 0, $Form2)
	_GUICtrlButton_Enable($Browse_Button_Backup, False)
EndIf

;==============================================================================================
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg

		;==============================================================================================
		Case $GUI_EVENT_CLOSE
			_FadeGUIOut($Form2)
			IniWrite("setting.ini", "Setting", "Setting_Encrypt", GUICtrlRead($Setting_Encrypt))
			IniWrite("setting.ini", "Setting", "Setting_Compression_Level", GUICtrlRead($Setting_Compression_Level))
			IniWrite("setting.ini", "Setting", "Setting_Convert_Registry", GUICtrlRead($Setting_Convert_Registry))
			Exit

			;==============================================================================================
		Case $Browse_Button_Backup
			$Backup_path = FileSelectFolder("Choose a folder to save backup...", "", 7, $Intial_Backup_Path, $Form2) & "\"

			If _FileIsPathValid($Backup_path) = True Then
				If GUICtrlRead($Setting_Encrypt) = "Yes" Then
					$Backup_7z_path = $Backup_path & "IDMbackup_Encrypted.7z"
				Else
					$Backup_7z_path = $Backup_path & "IDMbackup.7z"
				EndIf
				If FileExists($Backup_7z_path) Then
					If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
					$iMsgBoxAnswer = MsgBox(36, "Confirm Save", "Previous Backup Files(Encrypted) Already Exists Do You Want To Replace It?", 0, $Form2)
					Select
						Case $iMsgBoxAnswer = 6 ;Yes
							If FileDelete($Backup_7z_path) = 0 Then MsgBox(48, "Warning", "Files Could Not Deleted." & @CRLF & @CRLF & $Backup_7z_path, 0, $Form2)
							_GUICtrlButton_Enable($Backup_Button, True)
							GUICtrlSetData($Backup_Input, $Backup_path)
						Case $iMsgBoxAnswer = 7 ;No
							GUICtrlSetData($Backup_Input, "")
							_GUICtrlButton_Enable($Backup_Button, False)
					EndSelect
				Else
					_GUICtrlButton_Enable($Backup_Button, True)
					GUICtrlSetData($Backup_Input, $Backup_path)
				EndIf
			Else
				MsgBox(48, "Error", "Please Choose Valid Path First", 0, $Form2)
				_GUICtrlButton_Enable($Backup_Button, False)
			EndIf

			;==============================================================================================
		Case $Backup_Button

			If GUICtrlRead($Setting_Encrypt) = "Yes" Then
				$passwd = InputBox("Security Check", "Enter your password.", "", "*", 271, 126, "", "", "", $Form2)
				If $passwd = "" Then
					MsgBox(0, "Password", "Password Can not Blanck", 0, $Form2)
					ContinueLoop
				EndIf
				$passwd_validate = InputBox("Validate Password", "ReEnter your password.", "", "*", 271, 126, "", "", "", $Form2)
				If $passwd = "" Then
					MsgBox(0, "Password", "Password Can not Blanck", 0, $Form2)
					ContinueLoop
				EndIf
				If $passwd = $passwd_validate Then
					If $passwd <> "" Then
						$p = 1
						$Backup_7z_temp_path = @TempDir & "\" & "IDMbackup_Encrypted.7z"
						$Backup_reg_temp_path = @TempDir & "\" & "IDMregistry_Encrypted.reg"
					EndIf
				Else
					MsgBox(0, "Password", "Password Not Match", 0, $Form2)
					ContinueLoop
				EndIf
			Else
				$passwd = ""
				$Backup_7z_temp_path = @TempDir & "\" & "IDMbackup.7z"
				$Backup_reg_temp_path = @TempDir & "\" & "IDMregistry.reg"
			EndIf

			;==============================================================================================
			AdlibRegister("Update", 333)
			GUICtrlSetData($Label1, "Working...")
			_GUICtrlButton_Enable($Browse_Button_Backup, False)
			_GUICtrlButton_Enable($Backup_Button, False)
			_control_update_busy()

			;==============================================================================================
			$foo_2 = _7Zip_Add($Backup_7z_temp_path, $AppDataIDMFolder, GUICtrlRead($Setting_Compression_Level), $passwd)

			;==============================================================================================
			_regbackup($Backup_reg_temp_path, $regkey_x86_IDM)
			$foo_3 = _7Zip_Update($Backup_7z_temp_path, $Backup_reg_temp_path)
			FileDelete($Backup_reg_temp_path)
			FileMove($Backup_7z_temp_path, $Backup_path, 1)
			FileDelete($Backup_7z_temp_path)
			;==============================================================================================
			_GUICtrlButton_Enable($Browse_Button_Backup, True)
			_GUICtrlButton_Enable($Backup_Button, True)
			_control_update_default()
			AdlibUnRegister("Update")
			WinSetTitle($Form2, "", $Win_Title)

			;==============================================================================================
			If $foo_2 = 1 Then
				MsgBox(48, "Warning (Non fatal error(s))", "For example, one or more files were locked by some other application, so they were not compressed.", 0, $Form2)
				GUICtrlSetData($Label1, "Done But Error")

			ElseIf $foo_2 = 2 Then
				MsgBox(48, "Fatal Error", "Fatal error", 0, $Form2)
				GUICtrlSetData($Label1, "Done But Error")

				RegWrite($regkey_x86_IDMBM, "Backup Folder", "REG_SZ", $Backup_path)
			ElseIf $foo_2 = 7 Then
				MsgBox(48, "Error", "Command line error", 0, $Form2)
				GUICtrlSetData($Label1, "Done But Error")

			ElseIf $foo_2 = 8 Then
				MsgBox(48, "Error", "Not enough memory for operation.", $Form2)
				GUICtrlSetData($Label1, "Done But Error")

			ElseIf $foo_2 = 255 Then
				MsgBox(48, "Error", "Operation Canclled.", $Form2)
				GUICtrlSetData($Label1, "Done But Error")

			ElseIf $foo_2 = 0 Then
				MsgBox(0, "Done", "Backup Success.", $Form2)
				GUICtrlSetData($Label1, "Backup Success.")
			EndIf

			_GUICtrlButton_Enable($Backup_Button, False)
			RegWrite($regkey_x86_IDMBM, "Backup Folder", "REG_SZ", $Backup_path)

			;==============================================================================================
		Case $Browse_Button_Restore
			$Restore_path = FileSelectFolder("Choose a folder to restore backup...", "", 7, $Intial_Restore_Path, $Form2) & "\"
			If _FileIsPathValid($Restore_path) = True Then
				If GUICtrlRead($Setting_Encrypt) = "Yes" Then
					$Restore_7z_path = $Restore_path & "IDMbackup_Encrypted.7z"
				Else
					$Restore_7z_path = $Restore_path & "IDMbackup.7z"
				EndIf

				If Not FileExists($Restore_7z_path) Then
					MsgBox(48, "Error", "Backup File Does Not Exists in This Folder", $Form2)
					_GUICtrlButton_Enable($Restore_Button, False)
					GUICtrlSetData($Restore_Input, "")
				Else
					_GUICtrlButton_Enable($Restore_Button, True)
					GUICtrlSetData($Restore_Input, $Restore_path)
				EndIf
			Else
				MsgBox(48, "Error", "Please Choose Valid Path First", 0, $Form2)
				_GUICtrlButton_Enable($Restore_Button, False)
				GUICtrlSetData($Restore_Input, "")
			EndIf


			;==============================================================================================
		Case $Restore_Button

			If GUICtrlRead($Setting_Encrypt) = "Yes" Then
				$passwd2 = InputBox("Security Check", "Enter your password.", "", "*", 271, 126, (@DesktopWidth - 271) / 2, (@DesktopHeight - 126) / 2, "", $Form2)
				If $passwd2 = "" Then
					MsgBox(0, "Password", "Password Can not Blanck", $Form2)
					ContinueLoop
				EndIf
				$Restore_7z_temp_path = @TempDir & "\" & "IDMbackup_Encrypted.7z"
				$Restore_reg_temp_path = $AppDataIDMFolder & "\" & "IDMregistry_Encrypted.reg"
			Else
				$Restore_7z_temp_path = @TempDir & "\" & "IDMbackup.7z"
				$Restore_reg_temp_path = $AppDataIDMFolder & "\IDMregistry.reg"
			EndIf


			;==============================================================================================
			GUICtrlSetData($Label2, "Working...")
			AdlibRegister("Update", 333)
			_GUICtrlButton_Enable($Browse_Button_Restore, False)
			_GUICtrlButton_Enable($Restore_Button, False)
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
			;FileDelete($AppDataIDMFolder)
			DirCreate($AppDataIDMFolder)

			$foo_1 = _7Zip_Extract($Restore_7z_temp_path, $AppDataIDMFolder, $passwd2)

			If GUICtrlRead($Setting_Convert_Registry) = "Yes" Then
				FileCopy($Restore_reg_temp_path, @TempDir & "\IDMregistry_Encrypted.ini", 1)

				$guest_App_Path = IniRead(@TempDir & "\IDMregistry_Encrypted.ini", $regkey_x86_IDM, '"AppDataIDMFolder"', "")
				$guest_Drive = _Drive_Get_From_Path($guest_App_Path)
				MsgBox(48, "Fatal Error", $guest_App_Path, $Form2) ;debug = d:\\asit\\
				MsgBox(48, "Fatal Error", $guest_Drive, $Form2) ;debug  = d:

				$host_App_Path = StringReplace(($AppDataIDMFolder), "\", "\\")
				$host_drive = _Drive_Get_From_Path($host_App_Path)
				MsgBox(48, "Fatal Error", $host_App_Path, $Form2) ;debug c:\\asit\\
				MsgBox(48, "Fatal Error", $host_drive, $Form2) ;debug c:

				_ReplaceStringInFile(@TempDir & "\IDMregistry_Encrypted1.ini", $guest_App_Path, $host_App_Path)

				FileMove(@TempDir & "\IDMregistry_Encrypted.ini", @TempDir & "\IDMregistry_Encrypted.reg", 1)
				FileMove(@TempDir & "\IDMregistry_Encrypted1.reg", $Restore_reg_temp_path, 1)
			EndIf

			ShellExecuteWait($Restore_reg_temp_path)

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
;$REG_SZ
;$REG_DWORD
;$REG_NONE
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


			;==============================================================================================
			_GUICtrlButton_Enable($Browse_Button_Restore, True)
			_GUICtrlButton_Enable($Restore_Button, True)
			_control_update_default()
			AdlibUnRegister("Update")
			WinSetTitle($Form2, "", $Win_Title)

			If $foo_1 = 1 Then
				MsgBox(48, "Warning (Non fatal error(s))", "For example, one or more files were locked by some other application, so they were not compressed.", 0, $Form2)
				GUICtrlSetData($Label2, "Done But Error")

			ElseIf $foo_1 = 2 Then
				MsgBox(48, "Fatal Error", "Fatal error", 0, $Form2)
				GUICtrlSetData($Label2, "Done But Error")

			ElseIf $foo_1 = 7 Then
				MsgBox(48, "Error", "Command line error", 0, $Form2)
				GUICtrlSetData($Label2, "Done But Error")

			ElseIf $foo_1 = 8 Then
				MsgBox(48, "Error", "Not enough memory for operation.", 0, $Form2)
				GUICtrlSetData($Label2, "Done But Error")

			ElseIf $foo_1 = 255 Then
				MsgBox(48, "Error", "Operation Canclled.", 0, $Form2)
				GUICtrlSetData($Label2, "Done But Error")

			ElseIf $foo_1 = 0 Then
				MsgBox(0, "Done", "Restore Success.", 0, $Form2)
				GUICtrlSetData($Label2, "Restore Success.")
			EndIf


		Case $Update
			_GUICtrlButton_Enable($Update, False)
			Local $Update_VER = InetRead("http://www.geocities.ws/gajjartejas/IDM_Backup_Manager/v0.9.1/update.txt")

			Switch BinaryToString($Update_VER)
				Case ""
					MsgBox(48, "Error", "Internet connection could not found", 0, $Form2)
				Case "0.9.1"
					MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $Form2)
				Case "0.9.2"
					MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $Form2)
				Case "0.9.3"
					MsgBox(64, "Update Not Availabe", "You Have Most Recent Version.", 0, $Form2)
				Case Else
					MsgBox(64, "Availabe", "You Should Download Following Version" & BinaryToString($Update_VER), 0, $Form2)
			EndSwitch

		Case $Help
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/Start_page.htm"')
		Case $Read_ME
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/Using_IDM_Backup_Manager.htm"')
		Case $Licence
			Run('"' & @WindowsDir & '\hh.exe" "' & 'Help.chm::/General_Information.htm"')
		Case $Thanks
			MsgBox(64, "Thanks...", "I would like to thank:" & @CRLF & @CRLF & "·        Whole Auto IT Team (http://www.autoitscript.com/forum)" & @CRLF & "·        Igor Pavlov (www.7-zip.org)", 0, $Form2)
		Case $Aurther
			ShellExecute("http://gajjartejas26.blogspot.com/p/about-me.html")
		Case $Website
			ShellExecute("http://gajjartejas26.blogspot.com")

		Case $Save_Setting_Button
			If GUICtrlRead($Setting_Encrypt) = "Yes" Or GUICtrlRead($Setting_Encrypt) = "No" Then
				IniWrite("setting.ini", "Setting", "Setting_Encrypt", GUICtrlRead($Setting_Encrypt))
			Else
				MsgBox(48, "Setting.ini", "Invalid setting found at" & @CRLF & "Setting Tab-->Encrypt Value is  Invalid" & @CRLF & "Restored Default", 0, $Form2)
				GUICtrlSetData($Setting_Encrypt, IniRead("setting.ini", "Setting", "Setting_Encrypt", "No"))
				IniWrite("setting.ini", "Setting", "Setting_Encrypt", "No")
			EndIf

			If GUICtrlRead($Setting_Compression_Level) = "1-Store/None" Or GUICtrlRead($Setting_Compression_Level) = "2-Fastest" Or GUICtrlRead($Setting_Compression_Level) = "3-Fast" Or GUICtrlRead($Setting_Compression_Level) = "4-Normal" Or GUICtrlRead($Setting_Compression_Level) = "5-Maximum" Or GUICtrlRead($Setting_Compression_Level) = "6-Ultra" Then
				IniWrite("setting.ini", "Setting", "Setting_Compression_Level", GUICtrlRead($Setting_Compression_Level))
			Else
				MsgBox(48, "Setting.ini", "Invalid setting found at" & @CRLF & "Setting Tab-->Compression Value is  Invalid" & @CRLF & "Restored Default", 0, $Form2)
				GUICtrlSetData($Setting_Compression_Level, IniRead("setting.ini", "Setting", "Setting_Compression_Level", "4-Normal"))
				IniWrite("setting.ini", "Setting", "Setting_Compression_Level", "4-Normal")
			EndIf

			If GUICtrlRead($Setting_Convert_Registry) = "Yes" Or GUICtrlRead($Setting_Convert_Registry) = "No" Then
				IniWrite("setting.ini", "Setting", "Setting_Convert_Registry", GUICtrlRead($Setting_Convert_Registry))
			Else
				MsgBox(48, "Setting.ini", "Invalid setting found at" & @CRLF & "Setting Tab-->Reistry Value is Invalid" & @CRLF & "Restored Default", 0, $Form2)
				GUICtrlSetData($Setting_Convert_Registry, IniRead("setting.ini", "Setting", "Setting_Convert_Registry", "Yes"))
				IniWrite("setting.ini", "Setting", "Setting_Convert_Registry", "Yes")
			EndIf
			MsgBox(64, "Setting.ini", "Saved", 0, $Form2)

		Case $Form2
		Case $Tab1
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
	Return RunWait('7z.exe' & ' x "' & $sZipFile & '" ' & $sPassword & "-y -o" & '"' & $sDestinationFolder & '"', "", @SW_HIDE)
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
			Case "1-Store/None"
				$sCompression = " -mx0"
			Case "2-Fastest"
				$sCompression = " -mx1"
			Case "3-Fast"
				$sCompression = " -mx3"
			Case "4-Normal"
				$sCompression = " -mx5"
			Case "5-Maximum"
				$sCompression = " -mx7"
			Case "6-Ultra"
				$sCompression = " -mx9"
		EndSwitch
	EndIf
	Return RunWait("7z.exe" & " " & "a" & " " & '"' & $s7z_File_Save_Name & '"' & $sCompression & " " & $sPassword & '"' & $sDestinationFolder & "\*" & '"', "") ;, @SW_HIDE
EndFunc   ;==>_7Zip_Add


Func _7Zip_Update($name_of_archive, $name_file_to_update)
	If FileExists($name_of_archive) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If FileExists($name_file_to_update) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	Return RunWait("7z.exe" & " " & "u" & " " & '"' & $name_of_archive & '"' & " " & '"' & $name_file_to_update & '"', "") ;, @SW_HIDE
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


;_regbackup(c:\path\,        "name1.reg",     hku\folder1\folder2)
;_regbackup(@TempDir & "\" , "Scheduler.reg", $regkey_x86_IDM & "\Scheduler")

Func _regbackup($s7z_File_Save_Name, $regkey)
	ShellExecuteWait('regedit.exe', '/e "' & $s7z_File_Save_Name & '"' & " " & $regkey)
EndFunc   ;==>_regbackup

Func Update()
	Switch Mod($Increase, 4)
		Case 0
			WinSetTitle($Form2, "", "Processing... |")
		Case 1
			WinSetTitle($Form2, "", "Processing... /")
		Case 2
			WinSetTitle($Form2, "", "Processing... —")
		Case 3
			WinSetTitle($Form2, "", "Processing... \")
	EndSwitch
	$Increase += 1
EndFunc   ;==>Update

Func _control_update_busy()
	GUISetCursor(15, 1, $Form2)
	GUISetCursor(15, 1, $Pic1)
	GUISetCursor(15, 1, $TabSheet1)
	GUISetCursor(15, 1, $Backup_Input)
	GUISetCursor(15, 1, $Label1)
	GUISetCursor(15, 1, $TabSheet2)
	GUISetCursor(15, 1, $Restore_Input)
	GUISetCursor(15, 1, $Label2)
	GUISetCursor(15, 1, $TabSheet3)
	GUISetCursor(15, 1, $Read_ME)
	GUISetCursor(15, 1, $Licence)
	GUISetCursor(15, 1, $Thanks)
	GUISetCursor(15, 1, $Aurther)
	GUISetCursor(15, 1, $Website)
	GUISetCursor(15, 1, $Update)
EndFunc   ;==>_control_update_busy

Func _control_update_default()
	GUISetCursor(-1, 1, $Form2)
	GUISetCursor(-1, 1, $Pic1)
	GUISetCursor(-1, 1, $TabSheet1)
	GUISetCursor(-1, 1, $Backup_Input)
	GUISetCursor(-1, 1, $Label1)
	GUISetCursor(-1, 1, $TabSheet2)
	GUISetCursor(-1, 1, $Restore_Input)
	GUISetCursor(-1, 1, $Label2)
	GUISetCursor(-1, 1, $TabSheet3)
	GUISetCursor(-1, 1, $Read_ME)
	GUISetCursor(-1, 1, $Licence)
	GUISetCursor(-1, 1, $Thanks)
	GUISetCursor(-1, 1, $Aurther)
	GUISetCursor(-1, 1, $Website)
	GUISetCursor(-1, 1, $Update)
EndFunc   ;==>_control_update_default

Func _Drive_Get_From_Path($path)
	Dim $szDrive, $szDir, $szFName, $szExt
	$TestPath = _PathSplit($path, $szDrive, $szDir, $szFName, $szExt)
	Return $TestPath[1]
EndFunc   ;==>_Drive_Get_From_Path
