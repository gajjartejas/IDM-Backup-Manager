#include "_RegFunc.au3"
#include <String.au3>

	Local $i = 1
	While 1

		Local $var = RegEnumKey("HKEY_CURRENT_USER\Software\DownloadManager\Passwords\", $i)
		If @error <> 0 Then ExitLoop
		Local $real = ""
		Local $real1 = ""
		Local $FileName = _RegRead("HKEY_CURRENT_USER\Software\DownloadManager\Passwords\" & $var, "EncPassword")



		$P = _HexToString($FileName)
		$aCharacters = StringSplit($P,"")

$aCharacters = StringSplit($P,"")         ;<---  Breaks the input string into an array
                                               ;      of characters
For $i = 1 To $aCharacters[0]                  ;<---  Loops through the array one character
                                               ;      at a time
    ConsoleWrite(Asc($aCharacters[$i]) & " ")  ;<---  Write the ASCII value of each
                                               ;      character to the console
Next;                                          ;<---  Next loop iteration

		ConsoleWrite($var & " -->: " & $FileName & " -->: ")
		ConsoleWrite($real1)
		ConsoleWrite(@CRLF & @CRLF)

		$i += 1

	WEnd