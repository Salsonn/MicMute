#NoEnv
#Include VA.ahk
#SingleInstance, Force
FileInstall, MicMuted.ico, %A_Temp%\MicMuted.ico, 1
FileInstall, MicLow.ico, %A_Temp%\MicLow.ico, 1
FileInstall, MicHigh.ico, %A_Temp%\MicHigh.ico, 1
SendMode Input
SetWorkingDir %A_ScriptDir%
micVolumeHandle("vol", 0)
Menu, Tray, NoStandard
Menu, Tray, Add, MicMute (v1.0), micSettings, 
Menu, Tray, Add, View Microphone, micSettings
Menu, Tray, Add, Reload MicMute, reloadMicMute
Menu, Tray, Add, Exit MicMute, exitMicMute
Menu, Tray, Disable, MicMute (v1.0)
Menu, Tray, Default, MicMute (v1.0)
Menu, Tray, Color, Silver
return

SC118 Up::micVolumeHandle("mute", 0)
SC118 & Volume_Up::micVolumeHandle("vol", 1)
SC118 & Volume_Down::micVolumeHandle("vol", -1)

micVolumeHandle(behavior, modifier) {
if (behavior == "mute")
	VA_SetMasterMute(!VA_GetMasterMute("USB Microphone"), "USB Microphone")
VA_SetVolume((max(min(VA_GetVolume("1", "", "USB Microphone") + modifier, 9.8), 0)), "1", "", "USB Microphone")
if VA_GetMasterMute("USB Microphone")
	Menu, Tray, Icon, %A_Temp%\MicMuted.ico,,1
else if (VA_GetVolume("","","USB Microphone") <= 3)
	Menu, Tray, Icon, %A_Temp%\MicLow.ico,,1
else
	Menu, Tray, Icon, %A_Temp%\MicHigh.ico,,1
}

micSettings:
run, control.exe mmsys.cpl,,1
return
reloadMicMute:
Reload
exitMicMute:
ExitApp