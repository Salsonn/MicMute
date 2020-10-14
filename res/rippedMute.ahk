#Include VA.ahk
#SingleInstance, Force
deviceName := "USB Microphone"
SetTimer, feedback, 250
if VA_GetMasterMute("USB Microphone")
{
	menu, tray, icon, MicMuted.ico,,1
	}
else
{
	menu, tray, icon, MicLow.ico,,1
	}

SC118 Up::
;msgbox % VA_GetMute("2","USB Microphone")
;VA_SetMute(!VA_GetMute("1","USB Microphone"),"1","USB Microphone")
VA_SetMasterMute(!VA_GetMasterMute("USB Microphone"),"USB Microphone")
;msgbox % VA_GetMasterMute("USB Microphone")
CoordMode, ToolTip, Screen
if VA_GetMasterMute("USB Microphone")
{
	;TrayTip, Microphone state changed, Microphone muted, 10, 1
	menu, tray, icon, MicMuted.ico,,1
	}
else
{
	;TrayTip, Microphone state changed, Microphone unmuted, 10, 1
	menu, tray, icon, MicLow.ico,,1
	}
	return

SC118 & Volume_Up::
vol_tmp := VA_GetVolume("1","","USB Microphone")
vol_Master := (vol_tmp + 1)
VA_SetVolume(vol_Master, "1" , "", "USB Microphone")
vol_new := VA_GetVolume("","","USB Microphone")
	;TrayTip, Microphone state changed, "Microphone volume set to" %vol_new%, 10, 1
if VA_GetMasterMute("USB Microphone")
{
	menu, tray, icon, MicMuted.ico,,1
	}
else
{
	menu, tray, icon, MicLow.ico,,1
	}
return

SC118 & Volume_Down::
vol_tmp := VA_GetVolume("","","USB Microphone")
vol_Master := (vol_tmp - 1)
VA_SetVolume(vol_Master, "" , "", "USB Microphone")
vol_new := VA_GetVolume("","","USB Microphone")
	;TrayTip, Microphone state changed, "Microphone volume set to" %vol_new%, 10, 1
if VA_GetMasterMute("USB Microphone")
{
	menu, tray, icon, MicMuted.ico,,1
	}
else
{
	menu, tray, icon, MicLow.ico,,1
	}
return

feedback:
;Tooltip % VA_GetDeviceName("USB Microphone") . ": " . floor(VA_GetMasterVolume("", "USB Microphone")) . " | " . VA_GetVolume(1, 1, "USB Microphone") . " | " . VA_Scalar2dB(VA_GetVolume(1, 1, "USB Microphone"), 0, 100), 0, 0
return