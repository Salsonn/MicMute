#NoEnv
#Include VA.ahk
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir% 
;gosub, trayUpdate
return

SC118 & Volume_Up::
vol_tmp := VA_GetVolume("1","","USB Microphone")
vol_Master := (vol_tmp + 1)
VA_SetVolume(vol_Master, "1" , "", "USB Microphone")
vol_new := VA_GetVolume("","","USB Microphone")
return