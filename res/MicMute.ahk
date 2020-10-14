#NoEnv
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%
gosub, micStatusUpdate
return

SC118 Up::micVolumeHandle("mute", "+1")  ;Eject (Mute Mic)
SC118 & Volume_Up::micVolumeHandle("volume", "+1") ;Eject + VolUp (Mic Up)
SC118 & Volume_Down::micVolumeHandle("volume", "-1") ;Eject + VolDown (Mic Down)

micVolumeHandle(type, direction) {
SoundSet, %direction%, MASTER, %type%, 7
SoundGet, newValue, MASTER, %type%, 7
if newValue is alpha
	ToolTip, Mute %newValue%
if newValue is number
	ToolTip % floor(newValue)
SetTimer, RemoveToolTip, -1000
gosub, micStatusUpdate	
}

micStatusUpdate:
SoundGet, micMuted, , mute, 7
SoundGet, micVolume, , volume, 7
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
ToolTip
return