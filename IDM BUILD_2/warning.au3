#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=Warning.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=IDM Backup Manager Module
#AutoIt3Wrapper_Res_Description=IDM Backup Manager is a free software that can backup files from InterDownload Manager
#AutoIt3Wrapper_Res_Fileversion=0.9.2.0
#AutoIt3Wrapper_Res_LegalCopyright=©Gajjar Tejas 2011-2012
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=CompanyName|http://gajjartejas26.blogspot.in
#AutoIt3Wrapper_Res_Field=LegalTrademarks|GAJJAR TEJAS'S BLOG
#AutoIt3Wrapper_Res_Field=InternalName|IDM Backup Manager Module
#AutoIt3Wrapper_Res_Field=OriginalFilename|IDM Backup Manager Module
#AutoIt3Wrapper_Res_Field=SpecialBuild|v0.9.2(Beta) 10:10 PM 29-06-12(IN)
#AutoIt3Wrapper_Res_Field=PrivateBuild|v0.9.2(Beta) 10:10 PM 29-06-12(IN)
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=C:\Users\Tejas\Desktop\idm1\warning.kxf
$Form1 = GUICreate("Warning", 518, 349, 289, 226)
$Edit1 = GUICtrlCreateEdit("", 0, 0, 516, 306)
GUICtrlSetData(-1, StringFormat("Licence:\r\n----------------------------------------------------------------------\r\nTHIS SOFTWARE IS PROVIDED BY THE AUTHORS "&Chr(34)&"AS IS"&Chr(34)&" AND ANY EXPRESS OR IM\r\nPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIE\r\nS OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIM\r\nED. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY DIRECT, INDIRECT, \r\nINCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, B\r\nUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS O\r\nF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND \r\nON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR \r\nTORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE\r\n USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMA\r\nGE.\r\n\r\nWarning:\r\n----------------------------------------------------------------------\r\n1. You are not allowed to modify it in any way or create an installer \r\n   for it.\r\n2. You are not allowed to sell copies of this software.\r\n3. You are not allowed to distribute it from your website without refe\r\n   rring to the webstie of this software.\r\n4. IDM Backup Manager not allowed to use different PC or Computers\r\n5. IDM Backup Manager is for personal use only"))
GUICtrlSetFont(-1, 9, 400, 0, "Lucida Console")
GUICtrlSetColor(-1, 0x000000)
$Button1 = GUICtrlCreateButton("Accept", 210, 310, 91, 36)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Edit1
		Case $Button1
			RegWrite("HKEY_CURRENT_USER\Software\IDM Backup Manager", "Software Version", "REG_SZ", "0.9.2")
			Exit
	EndSwitch
WEnd

