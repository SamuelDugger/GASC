#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=\Icon\NewIcon.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#include <Date.au3>
#include <Color.au3>
#include <ColorConstants.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ColorConstants.au3>
#include <WinAPIFiles.au3>
#include <File.au3>
#include "Au3\GUIScrollbars_Ex.au3"


Opt("GUIOnEventMode", 1) ; Change to OnEvent mode


GUISetIcon("Icon\Icon.ico")    ; Set the icon of the GUI window

global $serviceStatusStart     ; Declare global variables for service statuses
global $serviceStatus         
global $PatchMode = FileReadLine(@WorkingDir&'\PatchMode.txt',1)    ; Read PatchMode from a file
global $Mode = FileReadLine(@WorkingDir&'\Mode.txt',1)              ; Read Mode from a file
global $SiteSelected = FileReadLine(@WorkingDir&'\SiteSelected.txt',1)  ; Read SiteSelected from a file

Sleep(100)      ; Pause execution for 100ms

local $mWidth = 1000     ; Set the width of the GUI window
local $mHeight = 800     ; Set the height of the GUI window

$BLUE = 0x0fb5ff    ; Set color codes
$GREEN = 0x5ed961
$RED = 0xdf4131
$WHITE = 0xffffff

global $Form1 = GUICreate("GASC",$mWidth, $mHeight, 50, 50,$WS_SIZEBOX+$WS_MAXIMIZEBOX+$WS_MINIMIZEBOX)    ; Create the GUI window and set its properties
; Check if Patch Mode is 0
If $PatchMode == "0" Then
	GUISetBkColor(0x101B25)    ; Set the background color of the GUI window
Else
	; Check if site is selected
	If $SiteSelected == "0" Then
		; Check if mode is 0
		If $Mode == "0" Then
			GUISetBkColor(0x0E1E0D)    ; Set the background color of the GUI window
		Else
			GUISetBkColor(0x251010)    ; Set the background color of the GUI window
		EndIf
	Else
		; Check if mode is 0
		If $Mode == "0" Then
			GUISetBkColor(0x0E1E0D)    ; Set the background color of the GUI window
		Else
			GUISetBkColor(0x251010)    ; Set the background color of the GUI window
		EndIf
	EndIf
EndIf
global $hMainGUI = GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")    ; Define the event handler for when the GUI window is closed

const $GWL_STYLE1 = -16
const $WS_SIZEBOX1 = 262144

$hWnd = WinGetHandle("GASC")  ; Get the handle of the GUI window
$style = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE1)  ; Get the window style
If BitXOR($style,$WS_SIZEBOX1) <> BitOr($style,BitXOR($style,$WS_SIZEBOX1)) Then _WinAPI_SetWindowLong($hWnd,$GWL_STYLE1,BitXOR($style,$WS_SIZEBOX1)) ; Modify the window style to allow resizing

global $lblStatusRunning = GUICtrlCreateLabel('Running services:	',60,5,200)   ; Create a label for the status of running services
GUICtrlSetFont(-1,9,600)    ; Set the font of the label
GUICtrlSetColor(-1,$GREEN)  ; Set the color of the label
global $lblStatusStopped = GUICtrlCreateLabel('Stopped services:	',60,20,200)  ; Create a label for the status of stopped services
GUICtrlSetFont(-1,9,600)
GUICtrlSetColor(-1,$RED)
global $lblStatusOther =   GUICtrlCreateLabel('Other:			',60,35,200)    ; Create a label for the status of other services
GUICtrlSetFont(-1,9,600)
GUICtrlSetColor(-1,$BLUE)

; Create a checkbox control labeled "Mute audio alerts" at a specific position
global $chkMute = GUICtrlCreateCheckbox('Mute audio alerts', $mWidth-230, 20)
; Use the UxTheme.dll library to set the theme of the checkbox control to default
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($chkMute), "wstr", 0, "wstr", 0)
; Set the color of the checkbox text to white
GUICtrlSetColor(-1, $WHITE)

; Create a button control labeled "Help" at a specific position and size
global $btnHelp = GUICtrlCreateButton('Help', $mWidth-100, 15, 60, 30)
; Set an event handler for the "Help" button
GUICtrlSetOnEvent(-1, "HelpFile")

; Set a variable to a specific value
local $pad = 25

; Create a button control labeled "Clear Selection" at a specific position and size
global $btnClearChecked = GUICtrlCreateButton('Clear Selection', $mWidth-230, 50+$pad, 125, 20)
; Set an event handler for the "Clear Selection" button
GUICtrlSetOnEvent(-1, "ClearChecked")

; Create a button control labeled "Refresh" at a specific position and size, with a default push button style
global $btnRefresh = GUICtrlCreateButton('Refresh', $mWidth-100, 50+$pad, 60, 20, $BS_DEFPUSHBUTTON)
; Set an event handler for the "Refresh" button
GUICtrlSetOnEvent(-1, "RefreshChecked")

; Create a button control labeled "ATI Startup" at a specific position and size
global $btnATIStartup = GUICtrlCreateButton('ATI Startup', $mWidth-230, 79+$pad, 90, 20)
; Set an event handler for the "ATI Startup" button
GUICtrlSetOnEvent(-1, "StartPatching")

; Create a button control labeled "ATI Shutdown" at a specific position and size
global $btnATIShutown = GUICtrlCreateButton('ATI Shutdown', $mWidth-130, 79+$pad, 90, 20)
; Set an event handler for the "ATI Shutdown" button
GUICtrlSetOnEvent(-1, "ShutdownPatching")

; Create a button control labeled "Start" at a specific position and size
global $btnStart = GUICtrlCreateButton('Start', $mWidth-165, 108+$pad, 60, 20)
; Set an event handler for the "Start" button
GUICtrlSetOnEvent(-1, "StartChecked")

; Create a button control labeled "Stop" at a specific position and size
global $btnStop = GUICtrlCreateButton('Stop', $mWidth-100, 108+$pad, 60, 20)
; Set an event handler for the "Stop" button
GUICtrlSetOnEvent(-1, "StopChecked")

; Create a button control labeled "Set Manual" at a specific position and size
global $btnManual = GUICtrlCreateButton('Set Manual', $mWidth-230, 135+$pad, 60, 20)
; Set an event handler for the "Set Manual" button
GUICtrlSetOnEvent(-1, "SetManualChecked")

; Create a button control labeled "Set Auto" at a specific position and size
global $btnAuto = GUICtrlCreateButton('Set Auto',$mWidth-165,135+$pad,60,20)
; Set an event handler for the "Set Auto" button
GUICtrlSetOnEvent(-1, "SetAutoChecked")

; Create a button control labeled "Set Disable" at a specific position and size
global $btnDisable = GUICtrlCreateButton('Set Disable',$mWidth-100,135+$pad,60,20)
; Set an event handler for the "Set Disabled" button
GUICtrlSetOnEvent(-1, "SetDisableChecked")

; Create a group box labeled 'Controller' and set its position and size on a GUI window
GUICtrlCreateGroup('Controller',$mWidth-240,30+$pad,215,135)
; Call a Windows API function to set the theme of the group box to be the default theme
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
; Set the text color of the group box to white
GUICtrlSetColor(-1,$WHITE)

; Create a button labeled 'Edit Current List' and set its position and size on a GUI window
global $btnEditServices = GUICtrlCreateButton('Edit Current List',$mWidth-130,190+$pad,90,30)
; Assign a function 'EditServiceList' to the button that will be called when the button is clicked
GUICtrlSetOnEvent(-1, "EditServiceList")

; Create a button labeled 'Restart Monitor' and set its position and size on a GUI window
global $btnRestartClient = GUICtrlCreateButton('Restart Monitor',$mWidth-130,230+$pad,90,20)
; Assign a function 'RestartClient' to the button that will be called when the button is clicked
GUICtrlSetOnEvent(-1, "RestartClient")

; Create an input box with no initial text and set its position and size on a GUI window
global $tfListName = GUICtrlCreateInput('',$mWidth-230,270+$pad,90,20)
; Set a cue banner text for the input box to be "( List Name )"
GUICtrlSendMsg(-1, $EM_SETCUEBANNER, False, "( List Name )")

; Create a button labeled 'Save List' and set its position and size on a GUI window
global $btnSaveList = GUICtrlCreateButton('Save List',$mWidth-130,270+$pad,90,20)
; Assign a function 'SaveList' to the button that will be called when the button is clicked
GUICtrlSetOnEvent(-1, "SaveList")

; Create a group box labeled 'List Controls' and set its position and size on a GUI window
GUICtrlCreateGroup('List Controls',$mWidth-240,170+$pad,215,135)
; Call a Windows API function to set the theme of the group box to be the default theme
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
; Set the text color of the group box to white
GUICtrlSetColor(-1,$WHITE)

; Check if Patch Mode is 0
If $PatchMode == "0" Then
	; Open application
	AppOpen()
	; Open Service Form
	ServiceForm()
Else
	; Open application
	AppOpen()
	; Check if site is selected
	If $SiteSelected == "0" Then
		; Check if mode is 0
		If $Mode == "0" Then
			; Open Patch Form
			PatchForm()
		Else
			; Open Patch Form
			PatchForm()
		EndIf
	Else
		; Check if mode is 0
		If $Mode == "0" Then
			; Show message box
			MsgBox(0, "Notice", 'You may need to run this as admin (Right click app and click "Run as admin".')
			; Create button to start services
			Global $btnStartup = GUICtrlCreateButton('Startup Services', $mWidth-450, 20, 150, 20)
			GUICtrlSetOnEvent(-1, "StartupServices")
			; Open Patch Service Form
			PatchServiceForm()
		Else
			; Show message box
			MsgBox(0, "Notice", 'You may need to run this as admin (Right click app and click "Run as admin".')
			; Create button to shutdown services
			Global $btnShutown = GUICtrlCreateButton('Shutdown Services', $mWidth-450, 20, 150, 20)
			GUICtrlSetOnEvent(-1, "ShutdownServices")
			; Open Patch Service Form
			PatchServiceForm()
		EndIf
	EndIf
EndIf

; Close PatchMode, Mode and SiteSelected files
FileClose($PatchMode)
FileClose($Mode)
FileClose($SiteSelected)

Func AppOpen()
	; This function initializes the application window and creates buttons for each service listed in the service directory.
	
	; Set initial button positioning variables.
	local $oTemp = 320 ; original starting position
	local $dif = 25 ; difference between each button position
	local $temp = $oTemp + $dif ; current button position

	; Declare global variable to store button control IDs.
	global $listButtons[0];

	local $tCtrl ; Temporary variable to store button control IDs.
	local $names = GetServiceListFiles() ; Get list of service names.

	$arr = $names ; Copy the service names list to a new array.

	If IsArray($arr) Then ; If the service names list is not empty, continue.

		; Calculate the mid-point of the list.
		$iMax = UBound($arr); ; Get the number of items in the array.
		$bp = Floor(($iMax) / 2) ; Calculate the mid-point of the list.

		; Loop through each service name in the list.
		For $i = 1 to $iMax - 1 ; Subtract 1 from size to prevent an out of bounds error.

			; Get the current service name.
			$name = $arr[$i]

			; Determine which column to place the button in based on the mid-point.
			If $i <= $bp Then
				$tCtrl = GUICtrlCreateButton($name,$mWidth-230,$temp,90,20) ; Create button in left column.
			Else
				$tCtrl = GUICtrlCreateButton($name,$mWidth-130,$temp,90,20) ; Create button in right column.
			EndIf

			; If the current button is in the middle row, reset the current button position.
			If $i == $bp Then
				$temp = $oTemp
			EndIf

			; Set the button click event to call the "GetServiceList" function.
			GUICtrlSetOnEvent(-1, 'GetServiceList')

			; Add the button control ID and service name to the global button list array.
			_ArrayAdd($listButtons, $tCtrl)
			_ArrayAdd($listButtons, $name)

			; Increment the current button position by the difference value.
			$temp += $dif
		Next
	EndIf

	; Show the main application window.
	GUISwitch($hMainGUI)
	GUISetState(@SW_SHOW)

	; Declare global variables to store checked checkboxes and control IDs of monitor GUIs.
	global $arrChecked[0] ; Array containing only the ControlID's of currently checked check boxes.
	global $arrControls[0][5] ; Array containing ControlID's returned from the creation of the gui's in the monitor.
EndFunc

Func ServiceForm()
    ; Declare and initialize the global variable $GarrServices
    global $GarrServices[0][9]
    
    ; Populate $GarrServices with data from a text file named Services.txt
    GetServices($GarrServices)
    
    ; Declare and initialize some local variables for controlling the placement of GUI controls
    local $topPadding = 40
    local $leftPadding = 60
    Local $spaceHInit = 15
    local $spacingH = $spaceHInit
    local $spacingHamount = 20
    local $lTop = $spaceHInit
    local $lHeight
    local $tempName
    local $groupID = 1000
    global $buttonLength
    
    ; Dynamically create GUI controls according to the data in $GarrServices
    For $i=0 To UBound($GarrServices)-1 Step +1
        
        ; If this is the first line of Services.txt, create a group header with a checkbox
        If $i==0 then
            $tempName=$GarrServices[$i][0]
            $GarrServices[$i][3] = GUICtrlCreateCheckbox('',$leftPadding-30,($lTop)+$topPadding+$spacingHamount,13,13)
            GUICtrlSetOnEvent(-1, "GroupCheckBox")
            $GarrServices[$i][8]=$groupID
            $GarrServices[$i][4]='X'
        
        ; If this is a group header in Services.txt, create a new group and set the current group name to the new header
        elseIf ($GarrServices[$i][1] == '') Then
            $spacingH += $spacingHamount*2
            $lHeight += $spacingHamount*2
            GUICtrlCreateGroup($tempName,$leftPadding-10,($lTop)+$topPadding,650,$lHeight-$spacingHamount/2)
            DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
            GUICtrlSetColor(-1,$WHITE)
            $tempName=$GarrServices[$i][0]
            $lTop = $spacingH
            $lHeight = 0
            $groupID += 1
            $GarrServices[$i][3] = GUICtrlCreateCheckbox('',$leftPadding-30,($lTop)+$topPadding+$spacingHamount,13,13)
            GUICtrlSetOnEvent(-1, "GroupCheckBox")
            $GarrServices[$i][8]=$groupID
            $GarrServices[$i][4]='X'
        
        ; If this is not a group header, create a new service item with a label, checkbox, and waiting status
        Else
            $lHeight += $spacingHamount
            $spacingH += $spacingHamount
            local $lCtrl1 = GUICtrlCreateLabel($GarrServices[$i][0]&'  ||  '&$GarrServices[$i][1],$leftPadding+80 + 30,$spacingH+$topPadding,565,13)
            GUICtrlSetColor(-1,$WHITE)
            local $lCtrl2 = GUICtrlCreateLabel('Waiting',$leftPadding + 30,$spacingH+$topPadding,70,13)
            GUICtrlSetColor(-1,$WHITE)
			local $lCtrl3 = GUICtrlCreateCheckbox('',$leftPadding-30 + 30,$spacingH+$topPadding,13,13)
			GUICtrlSetOnEvent($lCtrl3, "CheckCheckboxes")
			local $lCtrl4 = GUICtrlCreateGroup('',$leftPadding-10,$spacingH+$topPadding-7,650,22)
			GuiCtrlSetState(-1,$GUI_HIDE)
		
		; Assign values to certain elements of $GarrServices array and add them to $arrControls array
		$GarrServices[$i][3]=$lCtrl1
		$GarrServices[$i][4]=$lCtrl2
		$GarrServices[$i][5]=$lCtrl3
		$GarrServices[$i][6]=$lCtrl4
		$GarrServices[$i][7]='g'&$i
		$GarrServices[$i][8]=$groupID
		_ArrayAdd($arrControls,$lCtrl1&'|'&$lCtrl2&'|'&$lCtrl3&'|'&$lCtrl4&'|'&'g'&$i)

		EndIf

	Next

	; Create last group gui in $GarrServices and set its theme and color
	$spacingH += $spacingHamount*2
	$lHeight += $spacingHamount*2
	GUICtrlCreateGroup($tempName,$leftPadding-10,($lTop)+$topPadding,650,$lHeight-$spacingHamount/2)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
	GUICtrlSetColor(-1,$WHITE)
	
	
	; Declare two global variables and set their values
	; Used for determining scrollbar length
	global $buttonLength
	global $serviceLength
	$buttonLength = UBound($listButtons)
	$serviceLength = UBound($GarrServices)
	
	; Determine the size of the scrollbar based on the length of $listButtons and $GarrServices arrays
	If $serviceLength < 34 Then
		If $buttonLength < 34 Then
			_GUIScrollbars_Generate($Form1, 0, ($buttonLength*15) + 250)
		Else
			_GUIScrollbars_Generate($Form1, 0, ($buttonLength*7.5) + 300)
		EndIf
	ElseIf $serviceLength < 120 Then
		_GUIScrollbars_Generate($Form1, 0, ($serviceLength*24) + 300)
	ElseIf $serviceLength > 300 Then
		_GUIScrollbars_Generate($Form1, 0, ($serviceLength*26.5) + 300)
	Else
		_GUIScrollbars_Generate($Form1, 0, ($serviceLength*25) + 300)
	EndIf

	; Set a hotkey and call the CLOSEButton function when the hotkey is pressed
	HotKeySet('{ESC}', "CLOSEButton")
	
	; Call the IndexControls function
	IndexControls()
	
	; Start an infinite loop that performs different actions and updates the status
	While 1
		; Perform a Ping test on each element of $GarrServices array
		for $i=0 to (UBound($GarrServices)-1) step +1
			If $GarrServices[$i][1]<>'' Then
			PingTest($GarrServices[$i][0],$GarrServices[$i][1],'query',$arrControls[$GarrServices[$i][2]][4])
			EndIf
		Next
		; Perform a service command on each element of $GarrServices array and update the status
		for $i=0 to (UBound($GarrServices)-1) step +1
			If $GarrServices[$i][1]<>'' Then
			ServiceCommand($GarrServices[$i][0],$GarrServices[$i][1],'query',$arrControls[$GarrServices[$i][2]][0],$arrControls[$GarrServices[$i][2]][4],$arrControls[$GarrServices[$i][2]][1])
			EndIf
			UpdateStatus()
		Next
		Sleep(5000)
	WEnd
EndFunc

Func PatchForm()
	; Set some local variables to determine the layout of the form
	local $topPadding = 40
	local $leftPadding = 60
	Local $spaceHInit = 15
	local $spacingH = $spaceHInit
	local $spacingHamount = 20
	local $lTop = $spaceHInit
	local $lHeight
	local $tempName
	local $groupID = 1000
	local $oTemp = 320
	local $dif = 30
	local $temp = $oTemp + $dif
	
	; Create an array to store the patch buttons
	global $patchButtons[0];
	local $tCtrl
	
	; Get the list of patch files to display as buttons
	local $names = GetPatchListFiles()

	; Check if the array of patch files is valid and create buttons for each one
	$arrPatch = $names
	If IsArray($arrPatch) Then
		; Calculate the number of buttons that can fit in each column
		$iMax = UBound($arrPatch); get array size
		$bp = Floor(($iMax) / 2)

		; Loop through each patch file and create a button for it
		For $i = 1 to $iMax - 1; subtract 1 from size to prevent an out of bounds error
			$name = $arrPatch[$i]
			; Determine which column the button should be placed in
			If $i <= $bp Then
				$tCtrl = GUICtrlCreateButton($name,$mWidth-750,$temp-250,150,20)
			Else
				$tCtrl = GUICtrlCreateButton($name,$mWidth-550,$temp-250,150,20)
			EndIf

			; If the button is in the middle of the two columns, reset the position of the next button to the top of the column
			If $i == $bp Then
				$temp = $oTemp
			EndIf
			
			; Set the button to trigger the GetPatchList function when clicked
			GUICtrlSetOnEvent(-1, 'GetPatchList')
			
			; Add the button control ID and name to the patchButtons array
			$temp += $dif
			_ArrayAdd($patchButtons, $tCtrl)
			_ArrayAdd($patchButtons, $name)
		Next
	EndIf
	
	; Show the main GUI window
	GUISwitch($hMainGUI)
	GUISetState(@SW_SHOW)

	; Create an array to store the ControlIDs of the currently checked check boxes
	global $arrChecked[0]

	; Create an array to store the ControlIDs returned from the creation of the GUIs in the monitor
	global $arrControls[0][5]
	
	; Set the length of the listButtons array to a global variable called buttonLength
	global $buttonLength
	$buttonLength = UBound($listButtons)
	
	; Set the size of the scrollbars based on the length of the button list
	If $buttonLength < 34 Then
		_GUIScrollbars_Generate($Form1, 0, ($buttonLength*15) + 250)
	Else
		_GUIScrollbars_Generate($Form1, 0, ($buttonLength*7.5) + 300)
	EndIf
	
	; Set the hotkey for closing the window to the ESC key
	HotKeySet('{ESC}', "CLOSEButton")

	; Enter a loop that sleeps to keep the window open
	While 1
		Sleep(10000)
	WEnd
EndFunc

Func PatchServiceForm()
	
	; Declare and initialize the global variable $GarrServices
	global $GarrServices[0][9]

	;Populate $GarrServices with data from text file PatchingServices.txt
	GetPatchServices($GarrServices)

	; Declare and initialize some local variables for controlling the placement of GUI controls
	local $topPadding = 40
	local $leftPadding = 60
	Local $spaceHInit = 15
	local $spacingH = $spaceHInit
	local $spacingHamount = 20
	local $lTop = $spaceHInit
	local $lHeight
	local $tempName
	local $groupID = 1000

	;Dynamically create gui controls according to what data is in $GarrServices
	For $i=0 To UBound($GarrServices)-1 Step +1

		; If this is the first line of Services.txt, create a group header with a checkbox
		If $i==0 then
			$tempName=$GarrServices[$i][0]
			$GarrServices[$i][3] = GUICtrlCreateCheckbox('',$leftPadding-30,($lTop)+$topPadding+$spacingHamount,13,13)
			GUICtrlSetOnEvent(-1, "GroupCheckBox")
			$GarrServices[$i][8]=$groupID
			$GarrServices[$i][4]='X'
		 ; If this is a group header in Services.txt, create a new group and set the current group name to the new header
		elseIf ($GarrServices[$i][1] == '') Then
			$spacingH += $spacingHamount*2
			$lHeight += $spacingHamount*2
			GUICtrlCreateGroup($tempName,$leftPadding-10,($lTop)+$topPadding,650,$lHeight-$spacingHamount/2)
			DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
			GUICtrlSetColor(-1,$WHITE)
			$tempName=$GarrServices[$i][0]
			$lTop = $spacingH
			$lHeight = 0
			$groupID += 1
			$GarrServices[$i][3] = GUICtrlCreateCheckbox('',$leftPadding-30,($lTop)+$topPadding+$spacingHamount,13,13)
			GUICtrlSetOnEvent(-1, "GroupCheckBox")
			$GarrServices[$i][8]=$groupID
			$GarrServices[$i][4]='X'
		; If this is not a group header, create a new service item with a label, checkbox, and waiting status
		Else
		$lHeight += $spacingHamount
		$spacingH += $spacingHamount
		local $lCtrl1 = GUICtrlCreateLabel($GarrServices[$i][0]&'  ||  '&$GarrServices[$i][1],$leftPadding+80 + 30,$spacingH+$topPadding,565,13)
		GUICtrlSetColor(-1,$WHITE)
		local $lCtrl2 = GUICtrlCreateLabel('Waiting',$leftPadding + 30,$spacingH+$topPadding,70,13)
		GUICtrlSetColor(-1,$WHITE)
		local $lCtrl3 = GUICtrlCreateCheckbox('',$leftPadding-30 + 30,$spacingH+$topPadding,13,13)
		GUICtrlSetOnEvent($lCtrl3, "CheckCheckboxes")
		local $lCtrl4 = GUICtrlCreateGroup('',$leftPadding-10,$spacingH+$topPadding-7,650,22)
		GuiCtrlSetState(-1,$GUI_HIDE)
		
		; Assign values to certain elements of $GarrServices array and add them to $arrControls array
		$GarrServices[$i][3]=$lCtrl1
		$GarrServices[$i][4]=$lCtrl2
		$GarrServices[$i][5]=$lCtrl3
		$GarrServices[$i][6]=$lCtrl4
		$GarrServices[$i][7]='g'&$i
		$GarrServices[$i][8]=$groupID
		_ArrayAdd($arrControls,$lCtrl1&'|'&$lCtrl2&'|'&$lCtrl3&'|'&$lCtrl4&'|'&'g'&$i)

		EndIf

	Next

	; Create last group gui in $GarrServices and set its theme and color
	$spacingH += $spacingHamount*2
	$lHeight += $spacingHamount*2
	GUICtrlCreateGroup($tempName,$leftPadding-10,($lTop)+$topPadding,650,$lHeight-$spacingHamount/2)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
	GUICtrlSetColor(-1,$WHITE)
	
	
	; Declare two global variables and set their values
	; Used for determining scrollbar length
	global $buttonLength
	global $serviceLength
	$buttonLength = UBound($listButtons)
	$serviceLength = UBound($GarrServices)
	
	; Determine the size of the scrollbar based on the length of $listButtons and $GarrServices arrays
	If $serviceLength < 34 Then
		If $buttonLength < 34 Then
			_GUIScrollbars_Generate($Form1, 0, ($buttonLength*15) + 250)
		Else
			_GUIScrollbars_Generate($Form1, 0, ($buttonLength*7.5) + 300)
		EndIf
	ElseIf $serviceLength < 120 Then
		_GUIScrollbars_Generate($Form1, 0, ($serviceLength*23.5) + 300)
	ElseIf $serviceLength > 300 Then
		_GUIScrollbars_Generate($Form1, 0, ($serviceLength*26.5) + 300)
	Else
		_GUIScrollbars_Generate($Form1, 0, ($serviceLength*25) + 300)
	EndIf
	
	; Set a hotkey and call the CLOSEButton function when the hotkey is pressed
	HotKeySet('{ESC}', "CLOSEButton")

	; Call the IndexControls function
	IndexControls()

	; Start an infinite loop that performs different actions and updates the status
	While 1
		; Perform a Ping test on each element of $GarrServices array
		for $i=0 to (UBound($GarrServices)-1) step +1
			If $GarrServices[$i][1]<>'' Then
			PingTest($GarrServices[$i][0],$GarrServices[$i][1],'query',$arrControls[$GarrServices[$i][2]][4])
			EndIf
		Next
		; Perform a service command on each element of $GarrServices array and update the status
		for $i=0 to (UBound($GarrServices)-1) step +1
			If $GarrServices[$i][1]<>'' Then
			ServiceCommand($GarrServices[$i][0],$GarrServices[$i][1],'query',$arrControls[$GarrServices[$i][2]][0],$arrControls[$GarrServices[$i][2]][4],$arrControls[$GarrServices[$i][2]][1])
			EndIf
			UpdateStatus()
		Next
		Sleep(5000)
	WEnd
EndFunc
Func StartPatching()
	; Open file "Mode.txt" in the current working directory in overwrite mode and save the file handle in $FileOpen variable
	local $FileOpen = FileOpen('Mode.txt',$FO_OVERWRITE)
	
	; Write "0" to the file handle stored in $FileOpen variable
	; The mode text having 0 indicates it is in Startup patching mode
	FileWrite($FileOpen,"0")
	
	; Close the file handle stored in $FileOpen variable
	FileClose($FileOpen)
	
	; Open file "SiteSelected.txt" in the current working directory in overwrite mode and save the file handle in $OpenFile variable
	local $OpenFile = FileOpen('SiteSelected.txt',$FO_OVERWRITE)
	
	; Write "0" to the file handle stored in $OpenFile variable
	; This changes the Site Selected text back to 0 allowing the user to pick a site.
	FileWrite($OpenFile,"0")
	
	; Close the file handle stored in $OpenFile variable
	FileClose($OpenFile)
	
	; Call the function RestartClientPatch()
	; Sets the patch mode to 1 to display the patching site information
	RestartClientPatch()
EndFunc

Func ShutdownPatching()
	; Open file "Mode.txt" in the current working directory in overwrite mode and save the file handle in $FileOpen variable
	local $FileOpen = FileOpen('Mode.txt',$FO_OVERWRITE)
	
	; Write "1" to the file handle stored in $FileOpen variable
	; The mode text having 1 indicates it is in Shutdown patching mode
	FileWrite($FileOpen,"1")
	
	; Close the file handle stored in $FileOpen variable
	FileClose($FileOpen)
	
	; Open file "SiteSelected.txt" in the current working directory in overwrite mode and save the file handle in $OpenFile variable
	local $OpenFile = FileOpen('SiteSelected.txt',$FO_OVERWRITE)
	
	; Write "0" to the file handle stored in $OpenFile variable
	; This changes the Site Selected text back to 0 allowing the user to pick a site.
	FileWrite($OpenFile,"0")
	
	; Close the file handle stored in $OpenFile variable
	FileClose($OpenFile)
	
	; Call the function RestartClientPatch()
	; Sets the patch mode to 1 to display the patching site information
	RestartClientPatch()
EndFunc


Func StartupServices()
    ; Display a message box to confirm whether to shutdown services
    Local $answer = MsgBox(BitOR($MB_YESNO,$MB_ICONWARNING),'CAUTION',"You are about to start multiple services. Continue?")
    If $answer == 7 Then
        ; If the user selects No, exit the function
        Return
    Else
		Run("Exe\StartupShutdown.exe")
        ; Display a message box to indicate that the services are being shut down
		MsgBox(BitOR($MB_OK,$MB_ICONINFORMATION),'Notice',"Starting Service Startup.")
        ; Initialize the index to the last element in the array
        Local $i = UBound($GarrServices) - 1
        ; Initialize the group ID to the last group ID in the array
        Local $groupID = $GarrServices[$i][8]
        While $i >= 0
            ; If the current group ID is different from the previous one, display a message box indicating the group that was stopped
           If $groupID <> $GarrServices[$i][8] Then
                $groupID = $GarrServices[$i][8]
                MsgBox(BitOR($MB_OK,$MB_ICONINFORMATION),'Notice',"Services started for: " & $GarrServices[$i+1][0] & ".")
            EndIf
			; If the service name is IIS, then it runs the IIS bat file to stop the IIS services for that server.
			If $GarrServices[$i][1] == 'IIS' Then
				local $tempP = Run("Bat\IISReset.bat "&$GarrServices[$i][0],@SW_HIDE)
			Else
				; Start the service by calling the PingTest function with the 'start' parameter
				PingTest($GarrServices[$i][0],$GarrServices[$i][1], 'auto', $GarrServices[$i][7])
				PingTest($GarrServices[$i][0],$GarrServices[$i][1], 'start', $GarrServices[$i][7])
			Endif
            ; Decrement the index to move to the previous element in the array
            $i -= 1
        WEnd
    EndIf
	MsgBox(BitOR($MB_OK,$MB_ICONINFORMATION),'Notice',"Services started for: " & $GarrServices[$i+1][0] & ".")
    ; Display a message box to indicate that the shutdown is complete
    MsgBox(BitOR($MB_OK,$MB_ICONINFORMATION),'Notice',"Startup Complete")
EndFunc
Func ShutdownServices()
	; Display a warning message box to ask for confirmation before starting multiple services
	local $answer = MsgBox(BitOR($MB_YESNO, $MB_ICONWARNING), 'CAUTION', "You are about to stop multiple services. Continue?")
	
	; If the user chooses "No", then exit the function
	if $answer == 7 Then
		Return
	Else
		Run("Exe\StartupShutdown.exe")
		; Initialize loop variables
		$i = 0
		$groupID = 0
		
		; Loop through all the services in the global array
		While $i < UBound($GarrServices)
			; If the service is in a new group, display a message box to indicate starting the group
			If $groupID <> $GarrServices[$i][8] Then
				$groupID = $GarrServices[$i][8]
				MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION), 'Notice', "Stopping Group: " & $GarrServices[$i][0] & ".")
			EndIf
			If $GarrServices[$i][1] == 'IIS' Then
					local $tempP = Run("Bat\IISStop.bat "&$GarrServices[$i][0])
			Else
				; Stop the service by calling the PingTest function with the 'stop' parameter
				PingTest($GarrServices[$i][0], $GarrServices[$i][1], 'stop', $GarrServices[$i][7])
				PingTest($GarrServices[$i][0], $GarrServices[$i][1], 'demand', $GarrServices[$i][7])
			EndIf
			$i += 1
		WEnd
	EndIf
	; Display a message box to indicate that the startup is complete
	MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION), 'Notice', "Shutdown Complete")
EndFunc
Func ServiceCommand($lServer, $lService, $lCommand, $lCID, $ID, $lsCID)
	;Grabs the passed ID variable
	$ID = $ID
	local $t1 = 0

	;if the server doesn't respond to ping, write error message to monitor and error log, set label color to red, and play alert sound
	if not PingWait($ID) Then
		AppendToMonitor($lServer&' | '&$lService&' | ERROR: Ping test failed.  ',$lCID)
		AppendToErrorLog('ERROR: Ping test failed. $lServer variable contained: '&$lServer)
		SetStateLabel('Ping test failed',$RED,$lsCID)
		SoundPlay('Audio\Alert.mp3')
		Return
	EndIf

	local $lhTemp

	;Check if the command is for altering the start type
	local $lStartFlag = False
	Switch $lCommand
		Case 'disabled'
			$lStartFlag = true
		Case 'auto'
			$lStartFlag = true
		Case 'demand'
			$lStartFlag = true
	EndSwitch

	;wait until the ServiceStatusStart file size is at least 50 bytes, or timeout after 5 seconds
	$t1 = 0
	while (FileGetSize('Temp\ServiceStatusStart'&$ID&'.txt') < 50) and ($t1 <= 5000)
		Sleep(50)
		$t1 += 50
	WEnd
	if $t1 == 5000 Then
		MsgBox(0,'','Timeout on ServiceStart file size check.')
		Return
	EndIf

	$t1 = 0
	;if $lStartFlag is true, wait until the ServiceStatus file size is at least 30 bytes; otherwise, wait until it is at least 100 bytes, or timeout after 5 seconds
	If $lStartFlag Then
		while FileGetSize('Temp\ServiceStatus'&$ID&'.txt') < 30 and ($t1 <= 5000)
			Sleep(50)
			$t1 += 50
		WEnd
	Else
		while FileGetSize('Temp\ServiceStatus'&$ID&'.txt') < 100 and ($t1 <= 5000)
			Sleep(50)
			$t1 += 50
		WEnd
	EndIf

	if $t1 == 5000 Then
		MsgBox(0,'','Timeout on ServiceStart file size check.')
		Return
	EndIf

	Sleep(100)

	; Read the contents of the ServiceStatusStart and ServiceStatus files into variables
	local $StartStatus = FileRead('Temp\ServiceStatusStart'&$ID&'.txt')
	local $StateStatus = FileRead('Temp\ServiceStatus'&$ID&'.txt')

	; If no status was returned in the ServiceStatus file
	if $StateStatus == '' Then
		; Log an error message and close the process if it exists
		AppendToMonitor($lServer&' | '&$lService&' | ERROR: No status returned.  ',$lCID)
		$lhTemp = FileOpen("ErrorLog.txt",$FO_APPEND)
		FileWriteLine($lhTemp,@CRLF&_NowTime()&@CRLF&'ERROR: No status returned.'&@CRLF&'$lServer variable contained: '&$lServer)
		SetStateLabel('No status returned',$RED,$lsCID)
		FileClose($lhTemp)
		if ProcessExists($serviceStatus) then
			ProcessClose($serviceStatus)
		EndIf
		if ProcessExists($serviceStatusStart) then
			ProcessClose($serviceStatusStart)
		EndIf
		Return
	EndIf

	; Declare variables for the service state and start type codes and names
	local $StateCode
	local $StartCode
	local $StateName
	local $StartName

	; If the command is to alter the service start type
	If $lStartFlag Then
		; Get the service state code from the ServiceStatus file
		$StateCode = StringMid($StateStatus,(StringInStr($StateStatus,'ChangeServiceConfig '))+20,7)
		; If the state code is not 'SUCCESS', set a warning message
		If $StateCode <> 'SUCCESS' Then
			$StateCode = 'WARNING: Service found but status was NOT success.'
		EndIf
	Else
		; Get the service state code from the ServiceStatus file
		$StateCode = StringMid($StateStatus,(StringInStr($StateStatus,'STATE              : '))+21,1)
	EndIf

	; If the service was not found
	if StringInStr($StateStatus,'specified service does not exist') <> 0 Then
		; Log an error message and set the state label to red
		AppendToMonitor($lServer&' | '&$lService&' | ERROR: Service not found.  ',$lCID)
		AppendToErrorLog('ERROR: Service not found. '&@CRLF&'$lServer variable contained: '&$lServer&@CRLF&'$lService variable contained: '&$lService)
		SetStateLabel('Service not found',$RED,$lsCID)
		Return
	; If permission was denied
	Elseif StringInStr($StateStatus,'access is denied') <> 0 Then
		; Log an error message and set the state label to blue
		AppendToMonitor($lServer&' | '&$lService&' | ERROR: Access denied.',$lCID)
		AppendToErrorLog('ERROR: Permission denied. '&@CRLF&'$lServer variable contained: '&$lServer&@CRLF&'$lService variable contained: '&$lService)
		SetStateLabel('Permission',$BLUE,$lsCID)
		Return
	EndIf

	; Get the service start type code from the ServiceStatusStart file
	$StartCode = StringMid($StartStatus,(StringInStr($StartStatus,'START_TYPE         : '))+21,1)



	#cs

	Codes put in the $StateCode variable.

	SERVICE_STOPPED				1 -> The service is not running.

	SERVICE_START_PENDING		2 -> The service is starting.

	SERVICE_STOP_PENDING		3 -> The service is stopping.

	SERVICE_RUNNING				4 -> The service is running.

	SERVICE_CONTINUE_PENDING	5 -> The service continue is pending.

	SERVICE_PAUSE_PENDING		6 -> The service pause is pending.

	SERVICE_PAUSED				7 -> The service is paused.
	#ce

	; If $lStartFlag is true, do nothing. Otherwise, execute the following code:
	if $lStartFlag Then
	Else
		; Switch on the value of $StateCode:
		Switch $StateCode
			Case 1
				; Set $StateName to 'Stopped' and update the GUI state label to reflect this.
				$StateName='Stopped'
				SetStateLabel('Stopped',$RED,$lsCID)
				
				; If the 'Mute' checkbox is checked, do nothing. Otherwise, play an alert sound.
				if GUICtrlRead($chkMute) == $GUI_CHECKED Then
				Else
				SoundPlay('Audio\Alert.mp3')
				EndIf
			Case 2
				; Set $StateName to 'Starting' and update the GUI state label to reflect this.
				$StateName='Starting'
				SetStateLabel('Starting',$BLUE,$lsCID)
			Case 3
				; Set $StateName to 'Stop Pending' and update the GUI state label to reflect this.
				$StateName='Stop Pending'
				SetStateLabel('Stopping',$BLUE,$lsCID)
			Case 4
				; Set $StateName to 'Running' and update the GUI state label to reflect this.
				$StateName='Running'
				SetStateLabel('Running',$GREEN,$lsCID)
			Case 5
				; Set $StateName to 'Continue Pending'.
				$StateName='Continue Pending'
			Case 6
				; Set $StateName to 'Pause Pending'.
				$StateName='Pause Pending'
			Case 7
				; Set $StateName to 'Paused'.
				$StateName='Paused'
			Case Else
				; If the value of $StateStatus contains the substring 'service is already running', update the monitor with this information and update the GUI state label to reflect that the service is running.
				if StringInStr($StateStatus,'service is already running') <> 0 Then
					AppendToMonitor($lServer&' | '&$lService&' | already running',$lCID)
					SetStateLabel('Running',$GREEN,$lsCID)
				; If the value of $StateStatus contains the substring 'service has not been started', update the monitor with this information and update the GUI state label to reflect that the service is stopped.
				ElseIf StringInStr($StateStatus,'service has not been started') <> 0 Then
					AppendToMonitor($lServer&' | '&$lService&' | already stopped',$lCID)
					SetStateLabel('Stopped',$RED,$lsCID)
				; If none of the above cases match, update the monitor with an error message, write the error to the error log, update the GUI state label to 'Caution', and play an alert sound.
				Else
					AppendToMonitor($lServer&' | '&$lService&' | ERROR: Invalid state code returned.  ',$lCID)
					AppendToErrorLog('ERROR: Invalid state code returned. '&@CRLF&'$StateCode variable contained: '&$StateCode)
					SetStateLabel('Caution',$BLUE,$lsCID)
					SoundPlay('Audio\Alert.mp3')
				EndIf
				; Exit the Switch statement.
				Return
		EndSwitch
	EndIf


	#cs

	Codes put in the $StartCode variable.

	Manual		 -> 3	Service must be manually started when server powers on

	Automatic	 -> 2	Service should automatically start when server powers on

	Disabled	 -> 4	Service cannot start until this status is changed

	#ce

	if $lStartFlag then  ; check if $lStartFlag is true
		AppendToMonitor($lServer&'  ||  '&$lService&'  ||  set '&$lCommand&'  ||  '&$StateCode,$lCID)  ; log a message to the monitor
	Else  ; if $lStartFlag is false
		Switch $StartCode  ; evaluate $StartCode
			Case 2  ; if $StartCode is 2
				$StartName='Automatic'  ; set $StartName to 'Automatic'
			Case 3  ; if $StartCode is 3
				$StartName='Manual'  ; set $StartName to 'Manual'
			Case 4  ; if $StartCode is 4
				$StartName='Disabled'  ; set $StartName to 'Disabled'
			Case Else  ; if $StartCode is not 2, 3, or 4
				AppendToMonitor($lServer&' | '&$lService&' | ERROR: Invalid start code returned.  ',$lCID)  ; log an error message to the monitor
				AppendToErrorLog('ERROR: Invalid start code returned. '&@CRLF&'$StartCode variable contained: '&$StartCode&@CRLF&'$ID: '&$ID&@CRLF&'$StartStatus: '&$StartStatus)  ; log an error message to the error log
				SetStateLabel('Caution',$BLUE,$lsCID)  ; set the state label to 'Caution'
				Return  ; exit the function
		EndSwitch
		AppendToMonitor($lServer&'  ||  '&$lService&'  ||  '&$StartName,$lCID)  ; log a message to the monitor
	EndIf 	;==ServiceCommand
EndFunc
Func PingTest($lServer, $lService, $lCommand, $lID)
	;Used to check connection to server before attempting command because attempting command to an unreachable server causes a very long wait
	
	; Set up a string variable for the path to a temporary file to store ping results
	local $pingString = '.\Temp\PingTest'
	; Set $lID variable to the input parameter
	$lID = $lID
	
	; Delete any existing temporary files related to service status or ping results
	FileDelete('Temp\ServiceStatus'&$lID&'.txt')
	FileDelete('Temp\ServiceStatusStart'&$lID&'.txt')
	FileDelete($pingString&$lID&'.txt')
	
	; Set $lStartFlag to False as a default value
    local $lStartFlag = False
	
	; Use a switch statement to determine whether the service should be started based on the input parameter $lCommand
	Switch $lCommand
		Case 'disabled'
			; If $lCommand is 'disabled', set $lStartFlag to true to prevent the service from starting
			$lStartFlag = true
		Case 'auto'
			; If $lCommand is 'auto', set $lStartFlag to true to start the service automatically
			$lStartFlag = true
		Case 'demand'
			; If $lCommand is 'demand', set $lStartFlag to true to start the service on demand
			$lStartFlag = true
	EndSwitch
	
	; Use another switch statement to determine how to start the service based on the value of $lStartFlag
	Switch $lStartFlag
		Case true
			; If $lStartFlag is true, use the 'sc' command to start the service with the specified parameters and save the output to a temporary file
			$serviceStatus = Run(@ComSpec & " /c " & 'sc \\'&$lServer&' config '&$lService&' start='&$lCommand&' > Temp\ServiceStatus'&$lID&'.txt','',@SW_HIDE)
		Case Else
			; If $lStartFlag is false, use the 'sc' command to control the service with the specified parameters and save the output to a temporary file
			$serviceStatus = Run(@ComSpec & " /c " & 'sc \\'&$lServer&' '&$lCommand&' '&$lService&' > Temp\ServiceStatus'&$lID&'.txt','',@SW_HIDE)
	EndSwitch
	
	; Use the 'sc' command to query the status of the service and save the output to a temporary file
	$serviceStatusStart = Run(@ComSpec & " /c " & 'sc \\'&$lServer&' qc '&$lService&' > Temp\ServiceStatusStart'&$lID&'.txt','',@SW_HIDE)
	
	; Set $checkFlag to False as a default value
	local $checkFlag = False
	
	; Use the 'Run' command to execute a batch file named 'PingTest.bat' with the specified input parameters and save the output to a variable
	local $tempP = Run("Bat\PingTest.bat "&$lServer&' '&$pingString&$lID,'',@SW_HIDE)
	
	; Return the result of the PingWait function with the input parameter $lID
    return PingWait($lID)

EndFunc ;==PingTest
Func PingWait($lID)
	; This function waits for a ping test file to be created and checks its size and content.
	
    ; Initialize variables
    local $checkFlag = False	
	local $pingString = '.\Temp\PingTest'
    local $t1 = 0
	
    ; Wait for ping test file to be created or timeout after 5 seconds
	while not (FileExists($pingString&$lID&'.txt')) and ($t1 <= 5000)
		Sleep(100)
		$t1 += 100
	WEnd
	
    ; If timeout occurred, display an error message and return false
	if $t1 == 5000 Then
		MsgBox(0,'','Timeout on pingtest file creation.')
		Return $checkFlag
	EndIf

    ; Reset timer and wait for ping test file to have a size greater than or equal to 100 bytes or timeout after 5 seconds
	$t1 = 0
	
	while FileGetSize($pingString&$lID&'.txt')<100  and ($t1 <= 5000)
		Sleep(100)
		$t1 += 100
	WEnd
	
    ; If timeout occurred, display an error message and return false
	if $t1 == 5000 Then
		MsgBox(0,'','Timeout on pingtest file size check')
		Return $checkFlag
	EndIf

    ; Read the content of the ping test file and check if it contains '1', set $checkFlag to true if it does
	local $tempString = FileRead($pingString&$lID&'.txt')

	if StringInStr($tempString,'1') <> 0 Then
		$checkFlag = true
	EndIf

    ; Return whether the ping test file contains '1' or not
	Return $checkFlag
EndFunc

Func AppendToMonitor($lString,$idControlID)
	;Used to update the individual displays per service

	GUICtrlSetData($idControlID,$lString)

EndFunc ;==AppendToMonitor

Func AppendToErrorLog($lString)
	; This function appends a given string to an error log file, along with a timestamp and a delimiter.
	
    ; Open the error log file in append mode and write the given string along with a timestamp and delimiter to a new line
	local $lhTemp = FileOpen("ErrorLog.txt",$FO_APPEND)
	FileWriteLine($lhTemp,@CRLF&_NowTime()&@CRLF&$lString&@CRLF&'-------------------------')
	
    ; Close the error log file
	FileClose($lhTemp)
EndFunc

Func SetStateLabel($lString,$lColor,$idControlID)
	;Used to update the individual displays per service

	GUICtrlSetData($idControlID,$lString)
	GUICtrlSetColor($idControlID,$lColor)

EndFunc

Func GetServices(ByRef $ary1)
	; This function reads in a file containing a list of services and their statuses and populates an array with the data.
	
	; Open the file containing the service information in read mode and split its contents by line
	local $newFileRead = FileOpen("Services.txt",$FO_READ)
	local $fromFile = StringSplit(FileRead($newFileRead),@CR)
	FileClose($newFileRead)

	local $counter = 1

	; Loop through each line of the file
	while ($counter < UBound($fromFile))
		; Split the line by tab and store each element in an array
		local $aData = StringSplit($fromFile[$counter],@TAB)

		; Check if there was an error splitting the line
		if @error == 1 Then
			; Display an error message and ask the user if they want to load the backup file
			MsgBox($MB_ICONERROR,'ERROR','Error loading Services.txt file.'&@CRLF&'No TAB character was found at line '&$counter&'.'&@CRLF&'Correct the Services.txt file manually or load the backup.')
			local $answer = MsgBox(BitOR($MB_YESNO,$MB_ICONWARNING),'',"Load backup Service.txt file?")
			if $answer == 6 Then
				; Copy the backup file to the main folder and restart the client
				local $sTextFile = FileRead(@WorkingDir&'\Backups\Services.txt')
				local $oFile = FileOpen(@WorkingDir&'\Services.txt',$FO_OVERWRITE)
				FileWrite($oFile,$sTextFile)
				FileClose($oFile)
				RestartClient()
			Else
				; If the user does not want to load the backup file, exit the function
				Exit
			EndIf
		EndIf
		
		; Add the service name and status to the output array, stripping leading whitespace from the service name
		$counter += 1
		_ArrayAdd($ary1,StringStripWS($aData[1], $STR_STRIPLEADING)&'|'&$aData[2])
	WEnd
EndFunc

Func GetPatchServices(ByRef $ary1)
	; This function reads in a file containing a list of services and their statuses and populates an array with the data.

	; Open the file containing the service information in read mode and split its contents by line
	local $newFileRead = FileOpen("PatchingServices.txt",$FO_READ)
	local $fromFile = StringSplit(FileRead($newFileRead),@CR)
	FileClose($newFileRead)

	local $counter = 1
	
	; Loop through each line of the file
	while ($counter < UBound($fromFile))
		; Split the line by tab and store each element in an array
		local $aData = StringSplit($fromFile[$counter],@TAB)

		; Check if there was an error splitting the line
		if @error == 1 Then
			; Display an error message and ask the user if they want to load the backup file
			MsgBox($MB_ICONERROR,'ERROR','Error loading PatchingServices.txt file.'&@CRLF&'No TAB character was found at line '&$counter&'.'&@CRLF&'Correct the Services.txt file manually or load the backup.')
			local $answer = MsgBox(BitOR($MB_YESNO,$MB_ICONWARNING),'',"Load backup Service.txt file?")
			if $answer == 6 Then
				; Copy the backup file to the main folder and restart the client
				local $sTextFile = FileRead(@WorkingDir&'\Backups\PatchingServices.txt')
				local $oFile = FileOpen(@WorkingDir&'\PatchingServices.txt',$FO_OVERWRITE)
				FileWrite($oFile,$sTextFile)
				FileClose($oFile)
				RestartClient()
			Else
				; If the user does not want to load the backup file, exit the function
				Exit
			EndIf
		EndIf
		
		; Add the service name and status to the output array, stripping leading whitespace from the service name
		$counter += 1
		_ArrayAdd($ary1,StringStripWS($aData[1], $STR_STRIPLEADING)&'|'&$aData[2])
	WEnd
EndFunc
Func IndexControls()
    ; Initialize variable $t1 to 0
    local $t1 = 0
    
    ; Loop through the array $GarrServices using the index variable $i
    for $i=0 to (UBound($GarrServices)-1) step +1
        ; Check if the first element of the current row is not empty
        If $GarrServices[$i][1]<>'' Then
            ; Set the second element of the current row to the value of $t1
            $GarrServices[$i][2] = $t1
            
            ; Increment $t1 by 1
            $t1 += 1
        EndIf
    Next
EndFunc

Func CheckCheckBoxes()

    ; Loop through the array $arrChecked and delete all elements until the array is empty
    While UBound($arrChecked)<>0
        _ArrayDelete($arrChecked,0)
    WEnd

    ; Initialize variable $counter to 0
    local $counter = 0
    
    ; Loop through the array $arrControls using the index variable $counter
    while ($counter < UBound($arrControls))
        ; Check if the checkbox corresponding to the current control is checked
        if GUICtrlRead($arrControls[$counter][2])==$GUI_CHECKED Then
            ; Add the ID of the checkbox to the array $arrChecked
            _ArrayAdd($arrChecked,$arrControls[$counter][2])
            ; Set the state of the associated control to $GUI_SHOW
            GUICtrlSetState($arrControls[$counter][3],$GUI_SHOW)
        Else
            ; Set the state of the associated control to $GUI_HIDE
            GUICtrlSetState($arrControls[$counter][3],$GUI_HIDE)
        EndIf
        ; Increment $counter by 1 for the next iteration
        $counter += 1
    WEnd
EndFunc

Func RefreshChecked()
    ; Check if the array $arrChecked is not empty
    if UBound($arrChecked)<>0 Then
        ; Initialize index variable $i to 0
        $i=0
        
        ; Loop through the array $arrChecked using the index variable $i
        While $i<UBound($arrChecked)
            ; Search for the position of the service in the array $GarrServices that corresponds to the current checked item
            $tPos = _ArraySearch($GarrServices,$arrChecked[$i])
            
            ; Call the function ServiceCommand to query the status of the service
            ServiceCommand($GarrServices[$tPos][0],$GarrServices[$tPos][1],'query',$GarrServices[$tPos][3],$GarrServices[$tPos][7],$GarrServices[$tPos][4])
            
            ; Increment $i by 1 for the next iteration
            $i += 1
        WEnd
    Else
        ; Display an error message if no services are selected and exit the function
        MsgBox($MB_ICONERROR,'Way to go!','No services selected.')
        Return
    EndIf
EndFunc

Func ClearChecked()
    ; Initialize index variable $i to 0
    local $i = 0
    
    ; Loop through the array $GarrServices using the index variable $i
    While $i<UBound($GarrServices)
        ; Check if the checkbox for the current service is checked
        If GUICtrlRead($GarrServices[$i][5]) == $GUI_CHECKED Then
            ; Uncheck the checkbox
            GUICtrlSetState($GarrServices[$i][5],$GUI_UNCHECKED)
        EndIf
        ; Increment $i by 1 for the next iteration
        $i += 1
    WEnd

    ; Call the function CheckCheckBoxes to update the list of checked checkboxes
    CheckCheckBoxes()
EndFunc

Func GroupCheckBox()
    ; Initialize index variable $counter to 0
    local $counter = 0
    
    ; Loop through the array $GarrServices using the index variable $counter
    while ($counter < UBound($GarrServices))
        ; Check if the current service is a grouped service and if its associated checkbox is checked
        if $GarrServices[$counter][4] == 'X' and GUICtrlRead($GarrServices[$counter][3]) == $GUI_CHECKED Then
            ; Store the group name of the current service in a temporary variable $temp
            local $temp = $GarrServices[$counter][8]
            ; Initialize index variable $counter1 to 0
            local $counter1 = 0
            ; Loop through the array $GarrServices again using the index variable $counter1
            while ($counter1 < UBound($GarrServices))
                ; Check if the group name of the current service matches the group name stored in the temporary variable $temp
                if $GarrServices[$counter1][8] == $temp Then
                    ; Check the checkbox for the current service in the group
                    GUICtrlSetState($GarrServices[$counter1][5],$GUI_CHECKED)
                EndIf
                ; Increment $counter1 by 1 for the next iteration
                $counter1 += 1
            WEnd
            ; Uncheck the checkbox for the current grouped service
            GUICtrlSetState($GarrServices[$counter][3],$GUI_UNCHECKED)
        EndIf
        ; Increment $counter by 1 for the next iteration
        $counter += 1
    WEnd
    
    ; Call the function CheckCheckBoxes to update the list of checked checkboxes
    CheckCheckBoxes()
EndFunc
Func StartChecked()
	; This function starts selected services from an array using PingTest and RefreshChecked functions
	
    ; Check if the $arrChecked array has any elements
    if UBound($arrChecked) <> 0 Then
        ; Initialize a counter variable
        $i = 0
        ; Loop through the elements of the $arrChecked array
        While $i < UBound($arrChecked)
            ; Find the position of the current element in the $GarrServices array
            $tPos = _ArraySearch($GarrServices, $arrChecked[$i])
            ; Call the PingTest function to start the service with the parameters from the $GarrServices array
            PingTest($GarrServices[$tPos][0], $GarrServices[$tPos][1], 'start', $GarrServices[$tPos][7])
            ; Increment the counter variable
            $i += 1
        WEnd
    Else
        ; If the $arrChecked array is empty, display an error message
        MsgBox($MB_ICONERROR, 'Way to go!', 'No services selected.')
        ; Exit the function
        Return
    EndIf
    ; Wait for 1 second
    Sleep(1000)
    ; Call the RefreshChecked function to refresh the list of selected services
    RefreshChecked()
EndFunc

Func StopChecked()
	; This function stops selected services from an array using PingTest and RefreshChecked functions
	
	; Check if the $arrChecked array has more than one element
	if UBound($arrChecked) > 1 Then
		; Display a warning message asking for confirmation to stop multiple services
		Local $answer = MsgBox(BitOR($MB_YESNO, $MB_ICONWARNING), 'CAUTION', "You are about to stop multiple services. Continue?")
		; If the user clicks No, exit the function
		If $answer == 7 Then
			Return
		EndIf
	EndIf
	; Check if the $arrChecked array has any elements
	if UBound($arrChecked) <> 0 Then
		; Initialize a counter variable
		$i = 0
		; Loop through the elements of the $arrChecked array
		While $i < UBound($arrChecked)
			; Find the position of the current element in the $GarrServices array
			$tPos = _ArraySearch($GarrServices, $arrChecked[$i])
			; Call the PingTest function to stop the service with the parameters from the $GarrServices array
			PingTest($GarrServices[$tPos][0], $GarrServices[$tPos][1], 'stop', $GarrServices[$tPos][7])
			; Increment the counter variable
			$i += 1
		WEnd
	Else
		; If the $arrChecked array is empty, display an error message
		MsgBox($MB_ICONERROR, 'Way to go!', 'No services selected.')
		; Exit the function
		Return
	EndIf
	; Wait for 1 second
	Sleep(1000)
	; Call the RefreshChecked function to refresh the list of selected services
	RefreshChecked()
EndFunc

Func SetAutoChecked()
	; This function sets selected services to automatic using PingTest and RefreshChecked functions
	
	; Check if the $arrChecked array has more than one element
	if UBound($arrChecked) > 1 Then
		; Display a warning message asking for confirmation to configure multiple services
		Local $answer = MsgBox(BitOR($MB_YESNO, $MB_ICONWARNING), 'CAUTION', "You are about to configure multiple services. Continue?")
		; If the user clicks No, exit the function
		If $answer == 7 Then
			Return
		EndIf
	EndIf
	; Check if the $arrChecked array has any elements
	if UBound($arrChecked) <> 0 Then
		; Initialize a counter variable
		$i = 0
		; Loop through the elements of the $arrChecked array
		While $i < UBound($arrChecked)
			; Find the position of the current element in the $GarrServices array
			$tPos = _ArraySearch($GarrServices, $arrChecked[$i])
			; Call the PingTest function to set the service to automatic with the parameters from the $GarrServices array
			PingTest($GarrServices[$tPos][0], $GarrServices[$tPos][1], 'auto', $GarrServices[$tPos][7])
			; Increment the counter variable
			$i += 1
		WEnd
	Else
		; If the $arrChecked array is empty, display an error message
		MsgBox($MB_ICONERROR, 'Way to go!', 'No services selected.')
		; Exit the function
		Return
	EndIf
	; Wait for 1 second
	Sleep(1000)
	; Call the RefreshChecked function to refresh the list of selected services
	RefreshChecked()
EndFunc

Func SetManualChecked()
	; This function sets selected services to manual using PingTest and RefreshChecked functions
	
	; If more than one service is selected, display a warning message box with Yes/No buttons.
	if UBound($arrChecked)>1 Then
		local $answer = MsgBox(BitOR($MB_YESNO,$MB_ICONWARNING),'CAUTION',"You are about to configure multiple services. Continue?")
		
		; If the user clicks "No" in the message box, return from the function.
		if $answer == 7 Then
			Return
		EndIf
	EndIf

	; If at least one service is selected, iterate through each selected service and perform a "PingTest" function call with its parameters.
	if UBound($arrChecked)<>0 Then
		$i=0
		While $i<UBound($arrChecked)
			; Find the position of the current service in the global array of services.
			$tPos = _ArraySearch($GarrServices,$arrChecked[$i])
			
			; Call the "PingTest" function with the parameters of the current service.
			PingTest($GarrServices[$tPos][0],$GarrServices[$tPos][1], 'demand', $GarrServices[$tPos][7])
			$i += 1
		WEnd
	
	; If no services are selected, display an error message box.
	Else
		MsgBox($MB_ICONERROR,'Way to go!','No services selected.')
		Return
	EndIf

	; Wait for 1 second to allow time for the "PingTest" function calls to complete.
	Sleep(1000)

	; Refresh the list of checked services.
	RefreshChecked()

EndFunc

Func SetDisableChecked()
	; This function sets selected services to disabled using PingTest and RefreshChecked functions
	
	; If more than one service is selected, display a warning message box with Yes/No buttons.
	if UBound($arrChecked)>1 Then
		local $answer = MsgBox(BitOR($MB_YESNO,$MB_ICONWARNING),'CAUTION',"You are about to configure multiple services. Continue?")
		
		; If the user clicks "No" in the message box, return from the function.
		if $answer == 7 Then
			Return
		EndIf
	EndIf

	; If at least one service is selected, iterate through each selected service and perform a "PingTest" function call with its parameters, setting the service to "disabled".
	if UBound($arrChecked)<>0 Then
		$i=0
		While $i<UBound($arrChecked)
			; Find the position of the current service in the global array of services.
			$tPos = _ArraySearch($GarrServices,$arrChecked[$i])
			
			; Call the "PingTest" function with the parameters of the current service, setting the service to "disabled".
			PingTest($GarrServices[$tPos][0],$GarrServices[$tPos][1], 'disabled', $GarrServices[$tPos][7])
			$i += 1
		WEnd
	
	; If no services are selected, display an error message box.
	Else
		MsgBox($MB_ICONERROR,'Way to go!','No services selected.')
		Return
	EndIf

	; Wait for 1 second to allow time for the "PingTest" function calls to complete.
	Sleep(1000)

	; Refresh the list of checked services.
	RefreshChecked()

EndFunc

Func EditServiceList()
	; This function opens the "Services.txt" file in Notepad for editing and performs some warning checks.

	; If the current script has not yet been used to edit the service list, display a warning message box and append a line to the "Checks.txt" file to indicate that the script has been used.
	if StringInStr(FileRead(@WorkingDir&'\Checks.txt'),"EditServiceList") == 0 Then
		MsgBox($MB_ICONWARNING,'LISTEN!','Click the "Help" button to understand how this file works. The "Restart Monitor" button must be used before changes can take effect.')
		local $oFile = FileOpen(@WorkingDir&'\Checks.txt',$FO_APPEND)
		FileWrite($oFile,"EditServiceList"&@CRLF)
		FileClose($oFile)
	Else
	EndIf

	; Set the file path to the "Services.txt" file in the working directory.
	local $sTextFile = @WorkingDir&'\Services.txt'
	
	; Open Notepad and load the "Services.txt" file for editing.
	Run ("notepad.exe " & $sTextFile, @WindowsDir)

EndFunc

Func HelpFile()
	; Opens the Help text file to give information about the application.
	local $sTextFile = @WorkingDir&'\Help.txt'
	Run ("notepad.exe " & $sTextFile, @WindowsDir)
EndFunc



Func SaveList()
	; This function saves the current list of services to a new file in the "Premade" directory.
	
	; Read the name of the new list from the text field in the GUI.
	local $Name = GUICtrlRead($tfListName)
	
	; Read the contents of the "Services.txt" file.
	local $read = FileRead("Services.txt")

	; Check if a file with the same name already exists in the "Premade" directory. If so, display a warning message box and ask if the user wants to overwrite the file.
	if FileExists(@WorkingDir&'\Premade\'&$Name&'.txt') Then
		local $answer = MsgBox(BitOR($MB_YESNO,$MB_ICONWARNING),'Warning','File already exists. Overwrite?')
		if $answer == 6 Then
		Else
			Return
		EndIf
	EndIf

	; Open the new file for writing and overwrite it if it already exists.
	local $open = FileOpen(@WorkingDir&'\Premade\'&$Name&'.txt',$FO_OVERWRITE)
	
	; Write the contents of the "Services.txt" file to the new file.
	FileWrite($open,$read)

	; Restart the monitoring client to ensure that the new file is loaded.
    RestartClient()

EndFunc

Func RestartClient()
	; This function restarts the monitoring client by writing to two text files reseting the modes and sites selected and running an executable.
	
	; Open the "PatchMode.txt" file for writing and set its contents to "0".
	local $FileOpen = FileOpen(@WorkingDir&'\PatchMode.txt',$FO_OVERWRITE)
	FileWrite($FileOpen,"0")
	FileClose($FileOpen)
	
	; Open the "SiteSelected.txt" file for writing and set its contents to "0".
	local $OpenFile = FileOpen(@WorkingDir&'\SiteSelected.txt',$FO_OVERWRITE)
	FileWrite($OpenFile,"0")
	FileClose($OpenFile)

	; Run the "Restart.exe" executable located in the "Exe" directory.
	Run("Exe\Restart.exe")
EndFunc

Func RestartClientPatch()
	; This function restarts the monitoring client by writing to a text file reseting the patch mode and running an executable.
	
	; Open the "PatchMode.txt" file for writing and set its contents to "1" putting the app in patching mode.
	local $FileOpen = FileOpen(@WorkingDir&'\PatchMode.txt',$FO_OVERWRITE)
	FileWrite($FileOpen,"1")
	FileClose($FileOpen)
	
	; Run the "Restart.exe" executable located in the "Exe" directory.
	Run("Exe\Restart.exe")

EndFunc

Func UpdateStatus()
	;~The function initializes counters for running, stopped, and other services. 
	;It then loops through an array of services and checks the status of each service. 
	;Based on the status, it increments the appropriate counter. 
	;~Finally, the function updates the GUI labels with the counts for each status.
	
	; Initialize counters for running, stopped, and other services
	local $running = 0
	local $stopped = 0
	local $other = 0
	
	; Loop through all services in the $GarrServices array
	local $t1 = 0
	for $i=0 to (UBound($GarrServices)-1) step +1
	
		; Check if the current service is not marked with an 'X'
		if $GarrServices[$t1][4] <> 'X' Then
		
			; Determine the current status of the service
			Switch GUICtrlRead($GarrServices[$t1][4])
				Case 'Running'
					$running += 1
				Case 'Stopped'
					$stopped += 1
				Case 'Waiting'
				
				Case Else
					$other += 1
			EndSwitch
		EndIf
		
		; Increment the index for the next service
		$t1 += 1
	Next
	
	; Update the GUI labels with the counts for each status
	GUICtrlSetData($lblStatusRunning,'Running services:	'&$running)
	GUICtrlSetData($lblStatusStopped,'Stopped services:	'&$stopped)
	GUICtrlSetData($lblStatusOther,'Other:			'&$other)
EndFunc

Func GetServiceListFiles()
	; This function retrieves a list of files from a directory and returns an array containing the file names
	
    ; Initialize an empty output array
    local $output[0]
    
    ; Retrieve a list of files from the "Premade" directory and store the count in $fileCount
    local $arr = _FileListToArray("Premade")
    local $fileCount = $arr[0]
    
    ; If the list of files is not empty
    If IsArray($arr) Then
        ; Get the size of the array
        $iMax = UBound($arr)

        ; Loop through each file in the array
        For $i = 0 to $iMax - 1
            ; Extract the file name without the file extension
            $file = StringLeft($arr[$i],StringInStr($arr[$i],'.')-1)
            
            ; Add the file name to the output array
            _ArrayAdd($output,$file)
        Next
    EndIf
    
    ; Return the output array containing the file names
    return $output
EndFunc

Func GetPatchListFiles()
	; This function retrieves a list of files from the patch directory and returns an array containing the file names
	
    ; Initialize an empty output array
    local $output[0]
    
    ; Retrieve a list of files from the "Patch" directory and store the count in $fileCount
    local $arr = _FileListToArray("Patch")
    local $fileCount = $arr[0]
    
    ; If the list of files is not empty
    If IsArray($arr) Then
        ; Get the size of the array
        $iMax = UBound($arr)

        ; Loop through each file in the array
        For $i = 0 to $iMax - 1
            ; Extract the patch file name without the file extension
            $file = StringLeft($arr[$i],StringInStr($arr[$i],'.')-1)
            
            ; Add the patch file name to the output array
            _ArrayAdd($output,$file)
        Next
    Else
        ; If the list of files is empty, display an error popup
        ;~ Throw Error popup?
    EndIf
    
    ; Return the output array containing the patch file names
    return $output
EndFunc
Func GetServiceList()
	; This function retrieves the name of a service list file based on the button ID, reads the contents of the file, writes the contents to a new file named "Services.txt", and then restarts the client application
	
    ; Initialize the $list variable
    local $list
    
    ; Set $arr to the listButtons array
    $arr = $listButtons
    
    ; If $arr is an array
    If IsArray($arr) Then
        ; Get the size of the array
        $iMax = UBound($arr)
        
        ; Loop through each element in the array
        For $i = 0 to $iMax - 1     ; subtract 1 from size to prevent an out of bounds error
            ; If the element matches the current button ID
            If $arr[$i] == @GUI_CtrlId Then
                ; Set $list to the next element in the array
                $list = $arr[$i+1]
            EndIf
        Next
    EndIf
    
    ; Read the contents of the service list file
    local $file = FileRead(@WorkingDir&"\Premade\"&$list&".txt")

    ; Open a new file named "Services.txt" and write the contents of the service list file to it, overwriting any existing file
    local $FileOpen = FileOpen("Services.txt",$FO_OVERWRITE)
    FileWrite($FileOpen,$file)
    FileClose($FileOpen)

    ; Restart the client application
    RestartClient()

EndFunc

Func GetPatchList()
	; This function retrieves the name of the patch services list file based on the button ID, reads the contents of the file, writes the contents to a new file named "PatchingServices.txt", and then restarts the client application
    
	; Initialize a variable to store the patch list
    local $list
    
    ; Get the patchButtons array
    $arrPatch = $patchButtons
    
    ; Check if the array exists and has values
    If IsArray($arrPatch) Then
        ; Get the size of the array
        $iMax = UBound($arrPatch)
        
        ; Loop through the array
        For $i = 0 to $iMax - 1
            ; If the current array element matches the GUI control ID
            If $arrPatch[$i] == @GUI_CtrlId Then
                ; Store the next element in the array as the patch list
                $list = $arrPatch[$i+1]
            EndIf
        Next
    EndIf
    
    ; Read the contents of the patch file
    local $file = FileRead(@WorkingDir&"\Patch\"&$list&".txt")

    ; Open a file to write the contents of the patch file
    local $FileOpen = FileOpen("PatchingServices.txt",$FO_OVERWRITE)
    
    ; Write the contents of the patch file to the newly opened file
    FileWrite($FileOpen,$file)
    
    ; Close the file
    FileClose($FileOpen)
    
    ; Open a file to indicate that a site has been selected
    local $OpenFile = FileOpen(@WorkingDir&'\SiteSelected.txt',$FO_OVERWRITE)
    
    ; Write a value of "1" to the newly opened file to indicate a site has been selected
    FileWrite($OpenFile,"1")
    
    ; Close the file
    FileClose($OpenFile)
    
    ; Restart the client patch process
    RestartClientPatch()
EndFunc

Func CLOSEButton()
	;Exits the application when function is called
	Exit

EndFunc   ;==>CLOSEButton