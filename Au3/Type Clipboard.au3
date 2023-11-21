;Set Hotkey of Ctrl-Shift-V to type clipboard text.
;Useful for situations that don't permit traditional pasting
#include <Clipboard.au3>
;HotKeySet("+^v", "TypeClipText")
HotKeySet("{F8}", "TypeClipText")
HotKeySet("{ESC}", "Terminate")

While 1
Sleep(100)
WEnd


Func TypeClipText()
Sleep(1000)
$Text = ClipGet()
Opt("SendKeyDelay", 25)
Opt("SendKeyDownDelay", 5)
Send($Text, 0)
EndFunc   ;==>TypeClipText

Func Terminate()
Exit 0
EndFunc   ;==>Terminate



