#region Header

#CS
	Name: 				OnAutoItErrorRegister - Registers a function to be called when AutoIt produces a critical error (syntax error usualy).
	Author: 			Copyright © 2011-2012 CreatoR's Lab (G.Sandler), www.creator-lab.ucoz.ru, www.autoit-script.ru. All rights reserved.
	AutoIt version: 	3.3.6.1+
	UDF version:		1.8

	History:
	[1.8]
	+ Added _OnAutoItErrorUnRegister (see Example 1).
	* Removed the usage of command line to detect second script run.
	* More stability in detecting AutoIt error message (when $bUseStdOutMethod = False).
	* Fixed issue when main script (or other UDF) uses Opt('MustDeclareVars', 1).

	[1.7]
	* Fixed an issue with showing tray icon even if #NoTrayIcon is specified in the main script.
	* Fixed an issue with not passing the original command line parameters to the main script.
	Now added /OAER parameter to the command line at the end, it's an identifier for OnAutoItErrorRegister UDF.

	[1.6]
	* Fixed an issue with COM errors catching (this UDF should not handle COM errors, it was just for sending email function).
	* Removed unneccessary #include <File.au3>.
	* Fixed bug with auto-ckicked buttons on Windows Vista/7.

	[1.5]
	* Fixed issue with high CPU usage
	* "Send bug report" feature improved grately.
	* Added ability to translate all UDF elements (titles, messages, buttons and labels) - see "User Variables" section.
	* Cosmetic changes to the code.

	[1.4]
	* UDF rewrited.

#CE

#include-once
;#NoTrayIcon

#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Inet.au3>

#endregion Header

#region Global Variables

Global $nOAER_ButtonsStyle = 1
Global $nOAER_DefWndBkColor = 0xE0DFE2

Global $oOAER_ErrorData[2]
Global $oOAER_ErrorEvent

Global $MEMORY = MemGetStats()
Global $IOs = ProcessGetStats(-1, 1)
Global $current_version = "0.9.4"
Global $SysInfo = "============================= System Information =============================" & @CRLF
		$SysInfo &= "OS Arc: " & @OSArch & @CRLF
$SysInfo &= "OS Type: " & @OSType & @CRLF
$SysInfo &= "OS Version: " & @OSVersion & @CRLF
$SysInfo &= "Service Package: " & @OSServicePack & @CRLF
$SysInfo &= "Total Memory: " & $MEMORY[1] & @CRLF
$SysInfo &= "Available Memory: " & $MEMORY[2] & @CRLF
$SysInfo &= "============================= I/O Information =============================" & @CRLF
$SysInfo &= "Read Operations: " & $IOs[0] & @CRLF
$SysInfo &= "Write Operations: " & $IOs[1] & @CRLF
$SysInfo &= "Others Operations:" & $IOs[2] & @CRLF
$SysInfo &= "Read Bytes: " & $IOs[3] & @CRLF
$SysInfo &= "Write Bytes: " & $IOs[4] & @CRLF
$SysInfo &= "Other Bytes R\W: " & $IOs[5] & @CRLF
$SysInfo &= "============================= Module Information =============================" & @CRLF
$SysInfo &= "Module Path: " & @ScriptFullPath & @CRLF
$SysInfo &= "Module Version: " & $current_version & @CRLF
$SysInfo &= "=============================== End ==============================="
#endregion Global Variables

#region User Variables

;Translations
Global $sOAER_Title_Msg = "AutoIt3 Error"
Global $sOAER_Attention_Title = "Attention"
Global $sOAER_Error_Title = "Error"
Global $sOAER_Success_Title = "Success"

Global $sOAER_ErrMsgFrmt_Msg = _
		"Program has been Terminated :(.\r\n" & _
		"Please report about this bug to developer, sorry for the inconvenience!\r\n\r\n" & _
		"Program Path: %s\r\n\r\nError Line: %s\r\n\r\nError Description: %s"
Global $sOAER_MainTxt_Msg = "An error occurred in the application."
Global $sOAER_SendBugReport_Btn = "Send bug report"
Global $sOAER_ShowBugReport_Btn = "Show bug report"
Global $sOAER_DeBugScript_Btn = "DeBug script"
Global $sOAER_ContinueApp_Btn = "Continue application"
Global $sOAER_RestartApp_Btn = "Restart application"
Global $sOAER_CloseApp_Btn = "Close application"

;Send bug report part
Global $sOAER_BugReport_Title = "Bug Report"
Global $sOAER_SendBugReport_Title = "Send Bug Report"
Global $sOAER_SendBugReport_Tip = "Please fill the following data (* requierd fields):"
Global $sOAER_EmailServer_Lbl = "* Email Server:"
Global $sOAER_FromName_Lbl = "* From name:"
Global $sOAER_FromAddress_Lbl = "From address:"
Global $sOAER_ToAddress_Lbl = "* To address:"
Global $sOAER_Subject_Lbl = "* Subject:"
Global $sOAER_Body_Lbl = "* Body (bug report):"
Global $sOAER_SendingStatus_Lbl = "Sending, please wait..."
Global $sOAER_RequierdFields_Msg = "Please fill all requierd fields"
Global $sOAER_UnableToSend_Msg = "Unable to send bug report, please check the fields data.\n\nError Code:\n\t0x%X\nError Description:\n\t%s"
Global $sOAER_BugReportSent_Msg = "Please fill all requierd fields"

;===================== Should be changed =====================
Global $sOAER_DevEmailAddress = "gajjartejas26@gmail.com" ;Developer email address
Global $sOAER_DevEmailSubject = $sOAER_BugReport_Title & " - " & @ScriptName ;email subject
;===================== Should be changed =====================

#endregion User Variables

#region Public Functions

Func _OnAutoItErrorUnRegister()
	ConsoleWriteError(-1)
EndFunc   ;==>_OnAutoItErrorUnRegister

; #FUNCTION# ====================================================================================================
; Name...........:	_OnAutoItErrorRegister
; Description....:	Registers a function to be called when AutoIt produces a critical error (syntax error usualy).
; Syntax.........:	_OnAutoItErrorRegister( [$sFunction = "" [, $vParams = "" [, $sTitleMsg = -1 [, $sErrorMsgFormat = -1 [, $bUseStdOutMethod = True]]]]])
; Parameters.....:	$sFunction        - [Optional] The name of the user function to call.
;                                                 If this parameter is empty (""), then default (built-in) error message function is called.
;					$vParams          - [Optional] Parameter(s) that passed to $sFunction (default is "" - no parameters).
;					$sTitleMsg        - [Optional] The title of the default error message dialog (used only if $sFunction = "").
;					$sErrorMsgFormat  - [Optional] Formated error message string of the default error message dialog (used only if $sFunction = "").
;					$bUseStdOutMethod - [Optional] Defines the method that will be used to catch AutoIt errors (default is True - use StdOut).
;
; Return values..:	None.
; Author.........:	G.Sandler (CreatoR), www.autoit-script.ru, www.creator-lab.ucoz.ru
; Modified.......:
; Remarks........:	The UDF can not handle crashes that triggered by memory leaks, such as DllCall crashes.
;                   This UDF uses StdOut method by default (it's not compatible with CUI application),
;                    if you don't like it you can set "AutoIt error window catching" method by passing False in $bUseStdOutMethod parameter.
; Related........:
; Link...........:
; Example........:	Yes.
; ===============================================================================================================
Func _OnAutoItErrorRegister($sFunction = "", $vParams = "", $sTitleMsg = -1, $sErrorMsgFormat = -1, $bUseStdOutMethod = True)
	Local $hAutoItWin = __OnAutoItErrorRegister_WinGetHandleByPID(@AutoItPID)
	Local $sText = ControlGetText($hAutoItWin, '', 'Edit1')

	If StringInStr($sText, '/OAER') Then
		ControlSetText($hAutoItWin, '', 'Edit1', StringTrimRight($sText, 5))
		Return
	Else
		Opt("TrayIconHide", 1)
	EndIf

	Local $sErrorMsg = "", $sRunLine, $iPID, $iWinExists

	If $bUseStdOutMethod Then
		$sRunLine = @AutoItExe & ' /ErrorStdOut /AutoIt3ExecuteScript "' & @ScriptFullPath & '"'

		If $CmdLine[0] > 0 Then
			For $i = 1 To $CmdLine[0]
				$sRunLine &= ' ' & $CmdLine[$i]
			Next
		EndIf

		$iPID = Run($sRunLine, @ScriptDir, 0, 2 + 4)

		$hAutoItWin = __OnAutoItErrorRegister_WinWaitByPID($iPID, '[CLASS:AutoIt v3]')
		$sText = ControlGetText($hAutoItWin, '', 'Edit1')
		ControlSetText($hAutoItWin, '', 'Edit1', $sText & '/OAER')

		While 1
			$sErrorMsg &= StdoutRead($iPID)

			If @error Or StderrRead($iPID) = -1 Then
				ExitLoop
			EndIf

			Sleep(10)
		WEnd


	Else
		$sRunLine = @AutoItExe & ' /AutoIt3ExecuteScript "' & @ScriptFullPath & '"'

		If $CmdLine[0] > 0 Then
			For $i = 1 To $CmdLine[0]
				$sRunLine &= ' ' & $CmdLine[$i]
			Next
		EndIf

		$iPID = Run($sRunLine, @ScriptDir, 0, 4)

		Opt("WinWaitDelay", 0)

		$hAutoItWin = __OnAutoItErrorRegister_WinWaitByPID($iPID, '[CLASS:AutoIt v3]')
		$sText = ControlGetText($hAutoItWin, '', 'Edit1')
		ControlSetText($hAutoItWin, '', 'Edit1', $sText & '/OAER')

		$iWinExists = 0

		While ProcessExists($iPID)
			$iWinExists = WinExists("[CLASS:#32770;REGEXPTITLE:.*? Error]", "Line ")

			If $iWinExists Or StderrRead($iPID) = -1 Then
				ExitLoop
			EndIf

			Sleep(10)
		WEnd

		If Not $iWinExists Then
			Exit
		EndIf

		$sErrorMsg = ControlGetText("[CLASS:#32770;REGEXPTITLE:.*? Error]", "Line ", "Static2")
		WinClose("[CLASS:#32770;REGEXPTITLE:.*? Error]", "Line ")
	EndIf

	If $sErrorMsg = "" Then
		Exit
	EndIf

	If $sFunction = "" Then
		__OnAutoItErrorRegister_ShowDefaultErrorDbgMsg($sTitleMsg, $sErrorMsgFormat, $sErrorMsg, $bUseStdOutMethod)
	Else
		Call($sFunction, $vParams)

		If @error Then
			Call($sFunction)
		EndIf
	EndIf

	Exit
EndFunc   ;==>_OnAutoItErrorRegister

#endregion Public Functions

#region Internal Functions

Func __OnAutoItErrorRegister_ShowDefaultErrorDbgMsg($sTitleMsg = "", $sErrorMsgFormat = "", $sErrorMsg = "", $bUseStdOutMethod = True)
	Local $hErrGUI, $nMsg, $SendReport_Button, $ShowBugReport_Button, $ContinueApp_Button, $RestartApp_Button, $CloseApp_Button

	If $sTitleMsg = "" Or Not IsString($sTitleMsg) Then
		$sTitleMsg = $sOAER_Title_Msg
	EndIf

	If $sErrorMsgFormat = "" Or Not IsString($sErrorMsgFormat) Then
		$sErrorMsgFormat = $sOAER_ErrMsgFrmt_Msg
	EndIf

	$hErrGUI = GUICreate($sTitleMsg, 385, 90, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU))

	WinSetOnTop($hErrGUI, "", 1)
	GUISetIcon("User32.dll", -1)
	GUISetBkColor($nOAER_DefWndBkColor)

	GUICtrlCreateLabel("", 1, 1, 383, 1)
	GUICtrlSetBkColor(-1, 0x41689E)

	GUICtrlCreateLabel("", 1, 88, 383, 1)
	GUICtrlSetBkColor(-1, 0x41689E)

	GUICtrlCreateLabel("", 1, 1, 1, 88)
	GUICtrlSetBkColor(-1, 0x41689E)

	GUICtrlCreateLabel("", 383, 1, 1, 88)
	GUICtrlSetBkColor(-1, 0x41689E)

	GUICtrlCreateIcon("user32.dll", 103, 11, 11, 32, 32)

	GUICtrlCreateLabel($sOAER_MainTxt_Msg, 52, 22, 175, 15)
	GUICtrlSetBkColor(-1, -2)

	$SendReport_Button = __OnAutoItErrorRegister_CreateButtonEx($sOAER_SendBugReport_Btn, 10, 60, 110, 23, "shell32.dll", -157, 0xEFEEF2, 0x0000FF) ;, 0x706E63)
	$ShowBugReport_Button = __OnAutoItErrorRegister_CreateButtonEx($sOAER_ShowBugReport_Btn, 125, 60, 115, 23, "shell32.dll", 23, 0xEFEEF2)
	$ContinueApp_Button = __OnAutoItErrorRegister_CreateButtonEx($sOAER_ContinueApp_Btn, 245, 5, 130, 23, "shell32.dll", 290, 0xEFEEF2)
	$RestartApp_Button = __OnAutoItErrorRegister_CreateButtonEx($sOAER_RestartApp_Btn, 245, 32, 130, 23, "shell32.dll", 255, 0xEFEEF2)
	$CloseApp_Button = __OnAutoItErrorRegister_CreateButtonEx($sOAER_CloseApp_Btn, 245, 60, 130, 23, "shell32.dll", 240, 0xEFEEF2)

	GUICtrlSetState($ContinueApp_Button[0], $GUI_DISABLE)
	GUICtrlSetState($ContinueApp_Button[1], $GUI_DISABLE)

	If Not @Compiled Then
		GUICtrlSetImage($ShowBugReport_Button[0], "shell32.dll", -81)
		GUICtrlSetData($ShowBugReport_Button[1], "   " & $sOAER_DeBugScript_Btn)
	EndIf

	If $bUseStdOutMethod Then ;Only with StdOut Method we need the sound, otherwise the sound is produced by catched message from AutoIt error itself.
		If FileExists(@WindowsDir & "\Media\chord.wav") Then
			SoundPlay(@WindowsDir & "\Media\chord.wav")
		Else
			DllCall("user32.dll", "int", "MessageBeep", "int", 0x00000010)
		EndIf
	EndIf

	GUISetState(@SW_SHOW, $hErrGUI)

	While 1
		$nMsg = GUIGetMsg()

		If $nMsg = 0 Or ($nMsg > 0 And Not __OnAutoItErrorRegister_ClickProc($nMsg, $hErrGUI)) Then
			ContinueLoop
		EndIf

		Switch $nMsg
			Case $SendReport_Button[0], $SendReport_Button[1]

				_INetMail($sOAER_DevEmailAddress, $sOAER_DevEmailSubject, $sErrorMsg)

			Case $ShowBugReport_Button[0], $ShowBugReport_Button[1]
				Local $sScriptPath = StringRegExpReplace($sErrorMsg, "(?s)\A(.*) \(\d+\) : ==> .*", "\1")
				Local $iScriptLine = StringRegExpReplace($sErrorMsg, "(?s)\A.* \((\d+)\) : ==> .*", "\1")
				Local $sErrDesc = StringRegExpReplace($sErrorMsg, "(?s)\A.* \(\d+\) : ==> (.*)", "\1")

				If @Compiled Then
					$sScriptPath = @ScriptFullPath
					;$iScriptLine = "N/A" ;this one is changed in latest autoit versions, no the error line is shown even in the compiled scripts
					$sErrDesc = StringRegExpReplace($sErrorMsg, '(?s).*: ==> (.*):', '\1')
				Else
					__OnAutoItErrorRegister_DebugProc($hErrGUI, $sTitleMsg, $sScriptPath, $iScriptLine, $sErrDesc)
					ContinueLoop
				EndIf

				MsgBox(262144 + 4096, $sTitleMsg & " - " & $sOAER_BugReport_Title, StringFormat($sErrorMsgFormat, $sScriptPath, $iScriptLine, $sErrDesc), 0, $hErrGUI)
			Case $ContinueApp_Button[0], $ContinueApp_Button[1]
				;Not possible ATM.
			Case $RestartApp_Button[0], $RestartApp_Button[1]
				Local $sRunLine = @AutoItExe & ' "' & @ScriptFullPath & '"'

				If @Compiled Then
					$sRunLine = @ScriptFullPath
				EndIf

				Run($sRunLine, @ScriptDir)

				ContinueCase
			Case $CloseApp_Button[0], $CloseApp_Button[1], $GUI_EVENT_CLOSE
				GUIDelete($hErrGUI)
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>__OnAutoItErrorRegister_ShowDefaultErrorDbgMsg

Func __OnAutoItErrorRegister_DebugProc($hErrGUIWnd, $sTitle, $sScriptPath, $iScriptLine, $sErrDesc)
	If @Compiled Then
		Return SetError(1, 0, 0)
	EndIf

	Local $sError_Line = StringRegExpReplace($sErrDesc, "(?s).*:\r\n(.*)\r\n.*ERROR.*", "\1")

	;Local $sScitePath = RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SciTE.exe", "");
	Local $sScitePath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "InstallDir") & "\SciTE\SciTE.exe"

	Run($sScitePath & ' -check.if.already.open=1 "' & @ScriptFullPath & '" /goto:' & $iScriptLine & ',' & StringLen($sError_Line))

	Local $sCorrected_Line = InputBox($sTitle & " - Debugger", _
			"Script File: 	" & $sScriptPath & @CRLF & @CRLF & _
			"Script Line: 	" & $iScriptLine & @CRLF & @CRLF & _
			"Error Message:" & @CRLF & @CRLF & $sErrDesc & @CRLF & @CRLF & _
			"Please Correct this error:", _
			$sError_Line, "", @DesktopWidth - 200, 320, (@DesktopWidth / 2) - ((@DesktopWidth - 200) / 2), -1, 0, $hErrGUIWnd)

	If @error Or $sCorrected_Line = "" Then
		Return SetError(2, 0, 0)
	EndIf

	Local $aReadScript = StringSplit(FileRead(@ScriptFullPath), @CRLF, 1)
	Local $hFOpen = FileOpen(@ScriptFullPath, 2)

	For $i = 1 To $aReadScript[0]
		If $i = $iScriptLine Then
			$aReadScript[$i] = StringReplace($aReadScript[$i], $sError_Line, $sCorrected_Line, 1, 1)
		EndIf

		FileWriteLine($hFOpen, $aReadScript[$i])
	Next

	FileClose($hFOpen)
EndFunc   ;==>__OnAutoItErrorRegister_DebugProc

Func __OnAutoItErrorRegister_ClickProc($nCtrlID, $hWnd)
	Local $aCursorInfo

	While 1
		$aCursorInfo = GUIGetCursorInfo($hWnd)

		If Not @error And $aCursorInfo[2] <> 1 Then
			ExitLoop
		EndIf
	WEnd

	If IsArray($aCursorInfo) And $aCursorInfo[4] = $nCtrlID Then
		Return 1
	EndIf

	Return 0
EndFunc   ;==>__OnAutoItErrorRegister_ClickProc

Func __OnAutoItErrorRegister_CreateButtonEx($sText, $iLeft, $iTop, $iWidth, $iHeight, $sIconFile = "", $nIconIndex = 0, $nFrameBkColor = -1, $nTxtColor = -1)
	Local $aRet[2]

	If $nOAER_ButtonsStyle = 1 Then
		$aRet[0] = GUICtrlCreateIcon($sIconFile, $nIconIndex, $iLeft + 5, $iTop + (($iHeight - 15) / 2), 15, 15)
		;GUICtrlSetState(-1, $GUI_DISABLE)
		;GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

		$aRet[1] = GUICtrlCreateButton("       " & $sText & " ", $iLeft, $iTop, $iWidth, $iHeight, $WS_CLIPSIBLINGS)
		GUICtrlSetBkColor(-1, $nOAER_DefWndBkColor)
	Else
		GUICtrlCreateLabel("", $iLeft, $iTop, $iWidth, $iHeight, $SS_BLACKFRAME)
		GUICtrlSetBkColor(-1, $nFrameBkColor)
		GUICtrlSetState(-1, $GUI_DISABLE)

		$aRet[0] = GUICtrlCreateIcon($sIconFile, $nIconIndex, $iLeft + 3, $iTop + (($iHeight - 15) / 2), 15, 15)
		GUICtrlSetCursor(-1, 0)

		$aRet[1] = GUICtrlCreateLabel("   " & $sText, $iLeft + 19, $iTop + 4, $iWidth - 15, $iHeight - 7)
		GUICtrlSetColor(-1, $nTxtColor)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetCursor(-1, 0)
	EndIf

	Return $aRet
EndFunc   ;==>__OnAutoItErrorRegister_CreateButtonEx

Func __OnAutoItErrorRegister_WinGetHandleByPID($iPID, $sTitle = '[CLASS:AutoIt v3]')
	Local $aWinList = WinList($sTitle)

	For $i = 1 To UBound($aWinList) - 1
		;Hidden and belong to process in $iPID
		If Not BitAND(WinGetState($aWinList[$i][1]), 2) And WinGetProcess($aWinList[$i][1]) = $iPID Then
			Return $aWinList[$i][1]
		EndIf
	Next

	Return 0
EndFunc   ;==>__OnAutoItErrorRegister_WinGetHandleByPID

Func __OnAutoItErrorRegister_WinWaitByPID($iPID, $sTitle = '[CLASS:AutoIt v3]', $iTimeout = 0)
	Local $iTimer = TimerInit(), $hWin

	While 1
		$hWin = __OnAutoItErrorRegister_WinGetHandleByPID($iPID, $sTitle)

		If $hWin <> 0 Then
			Return $hWin
		EndIf

		If $iTimeout > 0 And TimerDiff($iTimer) >= $iTimeout Then
			ExitLoop
		EndIf

		Sleep(10)
	WEnd

	Return 0
EndFunc   ;==>__OnAutoItErrorRegister_WinWaitByPID


Func __OnAutoItErrorRegister_ISMComErrHndlr()
	$oOAER_ErrorData[0] = $oOAER_ErrorEvent.Number
	$oOAER_ErrorData[1] = StringStripWS($oOAER_ErrorEvent.Description, 3)
	SetError(1)
	Return
EndFunc   ;==>__OnAutoItErrorRegister_ISMComErrHndlr

#endregion Internal Functions