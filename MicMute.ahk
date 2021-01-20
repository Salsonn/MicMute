/* MicMute v1.1 
Redirects the Eject button found on some keyboards to mute and change volume for the specified audio device.
A secondary script is included to allow other external utilites to accomplish these items as well.
*/

;{██ AHK Settings
	#NoEnv
	#Include res\VA.ahk
	#SingleInstance, Force
;}

;{██ AHK2EXE Directives
	;@AHK2EXE-AddResource res\MicMuted.ico, Muted.ico
	;@AHK2EXE-AddResource res\MicLow.ico, Low.ico
	;@AHK2EXE-AddResource res\MicHigh.ico, High.ico
;}

;{██ AHK Variables
	SendMode Input
	SetWorkingDir %A_ScriptDir%
;}

;{██ MicMute Variables
	ProgName := StrSplit(A_ScriptName, .), ProgName := ProgName[1]
	IniRead, targetDevice, config.ini, MicMute, deviceDisplayName
	if (targetDevice == "ERROR" || targetDevice = "")
		gosub chooseDevice
;}

;{██ Initialization

	;{██ GUI and Tray Menu
		if (A_IsCompiled)
			Menu, Tray, NoStandard
		Menu, Tray, Add, MicMute (v1.0), micSettings
		Menu, Tray, Add, View Microphone, micSettings
		Menu, Tray, Add, Change Audio Device, chooseDevice
		Menu, Tray, Add, Reload MicMute, reloadMicMute
		Menu, Tray, Add, Exit MicMute, exitMicMute
		Menu, Tray, Disable, MicMute (v1.0)
		Menu, Tray, Default, MicMute (v1.0)
		GUI, Add, Edit, w50 h20 vcommand gremoteInterface
		GUI, Show, Hide, MicMuteController
		micVolumeHandle("vol", 0)
	;}
return
;}

;{██ Hotkeys
	SC118 Up::micVolumeHandle("mute", 0)
	SC118 & Volume_Up::micVolumeHandle("vol", 1)
	SC118 & Volume_Down::micVolumeHandle("vol", -1)
;}

;{██ Functions and Subroutines

	micVolumeHandle(behavior, modifier) {
		global
		if (behavior = "mute")
			VA_SetMasterMute(!VA_GetMasterMute(targetDevice), targetDevice)
		VA_SetVolume((max(min(VA_GetVolume("1", "", targetDevice) + modifier, 9.8), 0)), "1", "", targetDevice)
		
		;@Ahk2Exe-IgnoreBegin
		if VA_GetMasterMute(targetDevice)
			Menu, Tray, Icon, res\MicMuted.ico,,1
		else if (VA_GetVolume("","",targetDevice) <= 3)
			Menu, Tray, Icon, res\MicLow.ico,,1
		else
			Menu, Tray, Icon, res\MicHigh.ico,,1
		;@Ahk2Exe-IgnoreEnd
		
		/*@Ahk2Exe-Keep
		if VA_GetMasterMute(targetDevice)
			Menu, Tray, Icon, %A_ScriptName%, 6
		else if (VA_GetVolume("","",targetDevice) <= 3)
			Menu, Tray, Icon, %A_ScriptName%, 7
		else
			Menu, Tray, Icon, %A_ScriptName%, 8
		*/
	}

	chooseDevice: ;{
		InputBox, targetDevice, Change target device..., Enter the display name of the device you wish %ProgName% to control:,, 256, 148,,, Locale,, Microphone
		IniWrite, %targetDevice%, config.ini, MicMute, deviceDisplayName
	return ;}

	remoteInterface: ;{
		GuiControlGet, command
		if (command = "mute")
			micVolumeHandle("mute", 0)
		else if (command = "vol+")
			micVolumeHandle("vol", 1)
		else if (command = "vol-")
			micVolumeHandle("vol", -1)
	return ;}

	micSettings: ;{
		run, control.exe mmsys.cpl`,`,1
	return ;}

	reloadMicMute: ;{
		Reload ;}
	
	exitMicMute: ;{
		ExitApp ;}