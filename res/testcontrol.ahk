#include va.ahk

gosub main

return
GuiClose:
ExitApp
CPAudio:
Run rundll32.exe shell32.dll`,Control_RunDLL mmsys.cpl`,`, ; use a number at end to select option 
Return
CPMixer:
Run ,sndvol
Return
main:

meter_display :="playback"
Gui,1:Default
gui,1:destroy
Menu, ShowMenu, Add, S&ound(windows), CPAudio
Menu, ShowMenu, Add, Volume M&ixer(windows), CPmixer
Menu, MyMenuBar, Add, &Show, :ShowMenu
Gui, Menu, MyMenuBar
Gui, Add, Text, x500 y1 w400 h340 hwndParent         
Gui, Add, Text, x1 y200 w300 h250 hwndParent2        
Gui,Add,Button,x5 y310 gGuiClose,EXIT
Gui,Add,Button,x330 y310 gMeterMain,Show Meter

Gui, Add, Tab2,x5 y5 w450 h170 cblue, Playback|Capture
inout1=playback
inout2=capture
index:=1
loop 2
	{
	inout:=inout%A_index%
if A_index=1
{
Gui, Tab,Playback  
}
if A_index=2
{
Gui, Tab,Capture 
}

inoutsav:=A_index
	loop 
		{

		deviceid := VA_GetDevice(inout  ":" A_index)
		if deviceid>0
			{
			devicename:=VA_GetDeviceName(deviceid)
			volume := VA_GetMasterVolume(A_index,devicename)
			label:=inout%inoutsav%
			muted := VA_GetMasterMute(label)
			mutes := VA_GetMasterMute(devicename)
			channels:=VA_GetChannelCount( "1",devicename)
			ObjRelease(deviceid)
s%index%:=A_index
l%index%:=label
c%index%:=channels
n%index%:=devicename
Gui,Add,Button,y+10 gDetails v%index%, %devicename% Channels (%channels%)
index+=1
			}
		else
			{
			break
			}
		}
	}
Gui,Tab
Gui, Color, 0xF5e2A0

Gui, Show,w480 h350,Audio
return
Details:
Gui,2:destroy
Gui,1:Default
index :=A_GuiControl
Dev_seq:=s%index%
Dev_type:=l%index%
no_of_channels:=c%index%
Dev_clicked:=n%index%
meter_display :=Dev_clicked
msg :=
loop 8
{
Vol_n%A_index%:=A_index
}
;default values
vol_n1=L 
vol_n2=R
if SubStr(Dev_clicked, 1 , 8) ="Speakers" ; AC97 Speakers names
{
vol_n1=L
vol_n2=R
vol_n3=C
vol_n4=Sub
vol_n5=RL
vol_n6=RR
vol_n7=SL
vol_n8=SR
}
if Dev_type = 2
{
vol_n1=Boost 
vol_n2=Reserved
}
label:=inout%Dev_type%
meter_inout:=inout%Dev_type%
Dev_mute:=VA_GetMasterMute(label)
if Dev_mute= 0
{
Gui, 2:Add,Button,x10 y10 w200 gmmute vDev_mute,  Mute %label% Default Device
}
else
{
Gui, 2:Add,Button,x10 y10 w200 gmmute vDev_mute,  unMute %label% Default Device
}
Mvol:= VA_GetMasterVolume(,inout%Dev_type%)
Gui, 2:Add, text,x10 y40 cblue,1
Gui, 2:Add, Slider,x+1 w100 y40 h30 vMvol Range1-100  ToolTip gSliderMove cblue, %Mvol%
Gui, 2:Add, text,x+1 y40 cblue,100 
label:=inout%Dev_type%
Seq_mute :=VA_GetMasterMute(Dev_clicked)
if Seq_mute  = 0
{
Gui, 2:Add,Button,x10 y65 gmmute vSeq_mute,  Mute %Dev_clicked%
}
else
{
if Seq_mute <>
{
Gui, 2:Add,Button,x10 y65 gmmute vSeq_mute,  unMute %Dev_clicked%
}
}
if no_of_channels >0
{
Dvol := VA_GetMasterVolume(, Dev_clicked) 
Gui, 2:Add, text,x10 y95 cblue,1
Gui, 2:Add, Slider,x+1 y95 w100 h30 vDvol Range1-100  ToolTip gSliderMove, %Dvol%
Gui, 2:Add, text,x+1 y95 cblue,100 
Gui, 2:Add, text, x10 y190 cblue,100
Gui, 2:Add, text, x10 y230 cblue,50
Gui, 2:Add, text,x10 y270 cblue,1
loop %no_of_channels%
{
xx:=A_index* 50
sp_dev:=vol_n%A_index%
Gui, 2:Add, text,x%xx% y160 cgreen,%sp_dev%
line_volume := VA_GetVolume(Dev_type,A_index, Dev_clicked)
Gui, 2:Add, Slider, x%xx% y180 w40 h100 invert  vertical vline_volume%A_index% Range1-100   gSliderMove, %line_volume%
}
}
Gui, 2:Add,Button,x10 y310  g2close, Close Volume Control
Gui,2:Add,Button,x200 y310 gMeter,Show Meter
Gui, 2:Color, 0xF5e2A0
Gui, 2:+Lastfound -Resize -caption -border
Gui,2:show,x1 y1 ,Child1
child1:= WinExist()

DllCall("SetParent", "UInt", child1, "Uint", parent)      ; set parent for child window 1
Gui, Show,w980 h350,Audio
return
SliderMove:
Gui, Submit, nohide
GuiControlGet, slid, FocusV 
slidval :=%slid%
StringRight, slidindex, slid, 1
StringLeft, slidwhich, slid, 1
if slidwhich=M
{
;msgbox adjust master
VA_SetMasterVolume(slidval,,inout%Dev_type%) 
}
if slidwhich=D 
{
;msgbox adjust master with sequence
VA_SetMasterVolume(slidval,, Dev_clicked) 
}
if slidwhich=l 
{
;msgbox adjust sub
VA_SetVolume(slidval,Dev_type,slidindex, Dev_clicked)
}
; need to refresh as one can afect others
Gui,2:destroy
gosub Details
return
mmute:
GuiControlGet, mute_this, FocusV 
; msgbox %mute_this% %Dev_type% ,%Dev_clicked%
label:=inout%Dev_type%
if mute_this=Dev_mute
{
if VA_GetMasterMute(label)
{
VA_SetMasterMute(0,label)
}
Else
{
VA_SetMasterMute(1,label)
}
}
else
{
if VA_GetMasterMute(Dev_clicked)
{
VA_SetMasterMute(0,Dev_clicked)
}
Else
{
VA_SetMasterMute(1,Dev_clicked)
}
}
Gui,2:destroy
gosub Details
return
2close:
Gui,2:destroy
gosub main
return
3close:
Gui,3:destroy
gosub main
return
MeterMain:
meter_display:="playback"
meter_inout:=inout1
Gui,2:destroy
Gui, Show,w480
Meter:
Gui,3:destroy
MeterLength = 30
audioMeter := VA_GetAudioMeter(meter_display)
VA_IAudioMeterInformation_GetMeteringChannelCount(audioMeter, channelCount)
Gui, 3:Add,Text,x10 y10, %meter_display% has %channelCount% Channels
if channelCount>0
{
loop %channelCount%
{
Gui,3:Add, Progress, w350 h10 cBlue vMyProgress%A_index%
}
Gui 3: -Caption -border
Gui, 3:Color, 0xF5e2A0
Gui, 3:+Lastfound -Resize -caption -border
Gui,3:show,x1 y1 ,Child2
child2:= WinExist()

DllCall("SetParent", "UInt", child2, "Uint", parent2)     
Gui, Show

VA_GetDevicePeriod(meter_display, devicePeriod)
Loop
{
VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue)    
meter := MakeMeter(peakValue, MeterLength)
VarSetCapacity(peakValues, channelCount*4)
VA_IAudioMeterInformation_GetChannelsPeakValues(audioMeter, channelCount, &peakValues)
Loop %channelCount%
{
which=MyProgress%A_index%
valmeter:=MakeMeter(NumGet(peakValues, A_Index*4-4, "float"), MeterLength) * 100
GuiControl,3:, %which%, %valmeter%
gui ,3:show,NoActivate,Audio Meter
sleep 500
}
}
MakeMeter(fraction, size)
{
return fraction
}
}
return