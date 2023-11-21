#include <Timers.au3>

HotKeySet("{ESC}", "On_Exit")

AdlibRegister("_MoveMouse", 20000)

Global $fToggle = True

While 1
    Sleep(10)
WEnd

Func _MoveMouse()
    If _Timer_GetIdleTime() > 570000 Then     ;Change 870000(14.5 min. value if need longer or shorter)
        $fToggle = Not $fToggle
        $aMPos = MouseGetPos()
        ;MouseMove($aMPos[0] + (2 * $fToggle - 1), $aMpos[1])
		MouseClick("")
        ;ConsoleWrite("Mouse Moved" & @CRLF)
    EndIf
EndFunc

Func On_Exit()
    Exit
EndFunc