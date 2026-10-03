#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#region    ;************ Includes ************
#include-once
#endregion    ;************ Includes ************

Func _ShellFile_Install($sText, $sFileType, $sName = @ScriptName, $sFilePath = @ScriptFullPath, $sIconPath = @ScriptFullPath, $iIcon = 0, $fAllUsers = False, $fExtended = False)
	Local $i64Bit = '', $sRegistryKey = ''

	If $iIcon = Default Then
		$iIcon = 0
	EndIf
	If $sFilePath = Default Then
		$sFilePath = @ScriptFullPath
	EndIf
	If $sIconPath = Default Then
		$sIconPath = @ScriptFullPath
	EndIf
	If $sName = Default Then
		$sName = @ScriptName
	EndIf
	If @OSArch = 'X64' Then
		$i64Bit = '64'
	EndIf
	If $fAllUsers Then
		$sRegistryKey = 'HKEY_LOCAL_MACHINE' & $i64Bit & '\SOFTWARE\Classes\'
	Else
		$sRegistryKey = 'HKEY_CURRENT_USER' & $i64Bit & '\SOFTWARE\Classes\'
	EndIf

	$sFileType = StringRegExpReplace($sFileType, '^\.+', '')
	$sName = StringLower(StringRegExpReplace($sName, '\.[^\.\\/]*$', ''))
	If StringStripWS($sName, 8) = '' Or FileExists($sFilePath) = 0 Or StringStripWS($sFileType, 8) = '' Then
		Return SetError(1, 0, False)
	EndIf

	_ShellFile_Uninstall($sFileType, $fAllUsers)

	Local $iReturn = 0
	$iReturn += RegWrite($sRegistryKey & '.' & $sFileType, '', 'REG_SZ', $sName)
	$iReturn += RegWrite($sRegistryKey & $sName & '\DefaultIcon\', '', 'REG_SZ', $sIconPath & ',' & $iIcon)
	$iReturn += RegWrite($sRegistryKey & $sName & '\shell\open', '', 'REG_SZ', $sText)
	$iReturn += RegWrite($sRegistryKey & $sName & '\shell\open', 'Icon', 'REG_EXPAND_SZ', $sIconPath & ',' & $iIcon)
	$iReturn += RegWrite($sRegistryKey & $sName & '\shell\open\command\', '', 'REG_SZ', '"' & $sFilePath & '" "%1"')
	$iReturn += RegWrite($sRegistryKey & $sName, '', 'REG_SZ', $sText)
	$iReturn += RegWrite($sRegistryKey & $sName, 'Icon', 'REG_EXPAND_SZ', $sIconPath & ',' & $iIcon)
	$iReturn += RegWrite($sRegistryKey & $sName & '\command', '', 'REG_SZ', '"' & $sFilePath & '" "%1"')
	If $fExtended Then
		$iReturn += RegWrite($sRegistryKey & $sName, 'Extended', 'REG_SZ', '')
	EndIf
	Return $iReturn > 0
EndFunc   ;==>_ShellFile_Install

Func _ShellFile_Uninstall($sFileType, $fAllUsers = False)
	Local $i64Bit = '', $sRegistryKey = ''

	If @OSArch = 'X64' Then
		$i64Bit = '64'
	EndIf
	If $fAllUsers Then
		$sRegistryKey = 'HKEY_LOCAL_MACHINE' & $i64Bit & '\SOFTWARE\Classes\'
	Else
		$sRegistryKey = 'HKEY_CURRENT_USER' & $i64Bit & '\SOFTWARE\Classes\'
	EndIf

	$sFileType = StringRegExpReplace($sFileType, '^\.+', '')
	If StringStripWS($sFileType, 8) = '' Then
		Return SetError(1, 0, False)
	EndIf

	Local $iReturn = 0, $sName = RegRead($sRegistryKey & '.' & $sFileType, '')
	If @error Then
		Return SetError(2, 0, False)
	EndIf
	$iReturn += RegDelete($sRegistryKey & '.' & $sFileType)
	$iReturn += RegDelete($sRegistryKey & $sName)
	Return $iReturn > 0
EndFunc   ;==>_ShellFile_Uninstall