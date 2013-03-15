#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Associate extension with command
;
;version initial
;
;$extension - self explanative - without dot
;$fileclass   - just a name of file class - purpose of it is to define several extensions of one class
;$description - anything
;$icon		   - should be familiar "path\to\some.exe,2' - where 2 is icon number in file
;$command   - command to be executed
;
;Ex.: fDefineOpenAssociation("mye", "mye_class", "Cool MYE type", @SystemDir & "\SHELL32.dll,1", "myapp.exe %1")
;
fDefineOpenAssociation("ibf", "ibf", "", @ScriptFullPath & ",20", @ScriptFullPath & ' "' & "%1" & '"')
Func fDefineOpenAssociation($extension, $fileclass, $description, $icon, $command)
  RegWrite("HKCR\." & $extension, "", "REG_SZ", $fileclass)

  RegWrite("HKCR\" & $fileclass, "", "REG_SZ", $description)
  RegWrite("HKCR\" & $fileclass & "\DefaultIcon", "", "REG_SZ", $icon)
  RegWrite("HKCR\" & $fileclass & "\shell", "", "REG_SZ", "open")
  RegWrite("HKCR\" & $fileclass & "\shell\open\command", "", "REG_SZ", $command)
EndFunc