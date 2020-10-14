#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir% 
SetFormat, float, 0
#SingleInstance, Force
#Include VA.ahk
gosub, micStatusUpdate
deviceName := USB Microphone
micDevice := VA_GetDevice("USB Microphone")
;%micDevice% := VA_GetDevice("Surround Speakers")
SetTimer, feedback, 64
return

F12::F12
;SC118 Up::micVolumeHandle("mute", "+1")  ;Eject (Mute Mic)
;SC118 & Volume_Up::micVolumeHandle("volume", 2) ;Eject + VolUp (Mic Up)
;SC118 & Volume_Down::micVolumeHandle("volume", -2) ;Eject + VolDown (Mic Down)

micVolumeHandle(type, direction) {
	instVol := VA_GetMasterVolume(1, %micDevice%)
	newVol := instVol + direction
	VA_SetMasterVolume(Max(newVol, 0), 1, %micDevice%)
	;~ SoundSet, %direction%, MASTER, %type%, 8
	;~ SoundGet, newValue, MASTER, %type%, 8
	;~ if newValue is alpha
		;~ ToolTip, Mute %newValue%
	;~ if newValue is number
		;~ ToolTip % floor(newValue)
	
	;Tooltip % VA_GetMasterVolume(1, %micDevice%)
	;SetTimer, RemoveToolTip, -1000
	;gosub, micStatusUpdate	
}

micStatusUpdate:
return
SoundGet, micMuted, , mute, 8
SoundGet, micVolume, , volume, 8
if (micMuted = "On") {
	if A_IconFile != micMuted.ico
		Menu, Tray, Icon, micMuted.ico, , 1 
} else {
	if (micVolume <= 50) {
			if A_IconFile != micLow.ico
				Menu, Tray, Icon, micLow.ico, , 1 
		} else {
			if A_IconFile != micHigh.ico
				Menu, Tray, Icon, micHigh.ico, , 1 
		}
}
return

RemoveToolTip:
Tooltip
return

feedback:
Tooltip % VA_GetDeviceName(micDevice) . ": " . floor(VA_GetMasterVolume(0, micDevice)) . " | " . VA_GetVolume(1, 1, micDevice) . " | " . VA_dB2Scalar(VA_GetVolume(1, 1, micDevice), 0, 100), 0, 0
return