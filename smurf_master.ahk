#NoEnv
SetBatchLines -1
#SingleInstance, ignore
#notrayicon
ListLines Off
SetWorkingDir, %A_ScriptDir%

PWpw:="5ZGcTcHQszjKMv764FGkPeYpCbwnppfURpJPPahN9zjsn7zjAE27SxaFpxmgfjF6"

/*
PRIO 1
 - hour collector.exe entweder als code einfügen oder als exe mit anfügen
 - "entwickler passwort" um die ent-/verschlüsselungen zu umgehen?

 - eine readme.txt die geöffnet wird beim 1. start?
 - halten von taste für alpha und beta version erforderlich
 - ODER nur bestimmte mac adressen erlauben => keine verifizierung mehr nötig
 - Nickname anstatt acountname anzeigen lassen
 - bei alternate-login:
	- funktion die vor und nach dem klicken position auf richtigkeit überprüft
	
PRIO 2
 - einfach an neuen/veränderten funktionen eine "neue funktion" msgbox
*/

loop 4
{
	Hotkey, RControl & Numpad%A_Index%,,off
}

if not A_IsAdmin
{
	;Run  *RunAs "%A_ScriptFullPath%" ;wegen blockinput und steam beenden
	;Exitapp
}

#include, SecureProducts.ahk

return

initialize()
{
	global
	
	;update() changelog??
	
	
	;IfNotExist, smurf.ini
	if Buttonverify=1
	{
		IniWrite, C:\Program Files (x86)\Steam\Steam.exe, smurf.ini, settings, steamexelocation
		IniWrite, 0, smurf.ini, settings, silentorcsgo
		IniWrite, 2, smurf.ini, settings, loginmethod
		IniWrite, 100, smurf.ini, settings, donotchange
		IniWrite, 500, smurf.ini, settings, donotchange2
		
		e:=""
		IniWrite, %e%, smurf.ini, account1, username
		IniWrite, %e%, smurf.ini, account1, password
	
		IniWrite, %e%, smurf.ini, account2, username
		IniWrite, %e%, smurf.ini, account2, password
	
		IniWrite, %e%, smurf.ini, account3, username
		IniWrite, %e%, smurf.ini, account3, password
	
		IniWrite, %e%, smurf.ini, account4, username
		IniWrite, %e%, smurf.ini, account4, password
		reload ;fixen...
	} 
	
	IniRead, steamexe , smurf.ini, settings, steamexelocation
	IniRead, silentorcsgo , smurf.ini, settings, silentorcsgo
	IniRead, loginmethod , smurf.ini, settings, loginmethod
	IniRead, sl , smurf.ini, settings, donotchange
	IniRead, sl2 , smurf.ini, settings, donotchange2

	;account infos verarbeiten
	Loop 4
	{
		IniRead, username%A_Index% , smurf.ini, account%A_Index%, username
		IniRead, password%A_Index% , smurf.ini, account%A_Index%, password

			if (username%A_Index%="" or password%A_Index%="")
			{
				B%A_Index%=+disabled
				login%A_Index%=login:`n no Account specified
			
			} else 
			{
				B%A_Index%:=""
				Hotkey, RControl & Numpad%A_Index%,,on
				login%A_Index%=% "login:`n " . username%A_Index%
				password%A_Index%:="abcd"
			}
		
	}
	
	if checkini()=1
		return
	
	checksilentorcsgo1:=""
	checksilentorcsgo2:=""
	checklogin1:=""
	checklogin2:=""
	

	if silentorcsgo=1
	{
		checksilentorcsgo1:="+checked"
	}
	else if silentorcsgo=2
	{
		checksilentorcsgo2:="+checked"
	}
	
	if loginmethod=1
	{
		checklogin1:="+checked"
	}
	else
	{
		checklogin2:="+checked"
	}

	
	;Fileinstall, Bilder\gaben.png, gaben.png

	
	/*
	gui vorschlag:
	man wähl in einer droplist account und hat dann button für die verschiedenen möglichkeiten (silent und csgo)
	*/
	gui, destroy
	settimer, pro, off
	;Gui, Add, Picture, x2 y-1 w420 h280 , gaben.png
	
	Fileinstall, Bilder\silver.jpg, silver.jpg ;selber einstellen?
	Gui, Add, Picture, x0 y0 w532 h345 , silver.jpg
	Filedelete, silver.jpg
	
	Gui, Add, Text, x90 y20 w340 h40 +Center, Der Entwickler übernimmt keinerlei Haftung.`nHint: You can use Pos1/Home to close Smurf Master in every situation`nuse RControl+Numpad[AccountNumbr.] for fast login
	Gui, Add, Link, x40 y330 w450 h15 +Center, contact:peter.holz@hotmail.de - donate if you like my work! <a href="https://www.paypal.me/peterholz1">https://www.paypal.me/peterholz1</a>

	Gui, Add, Button, x213 y73 w100 h25 gopensettings, account settings
	
	Gui, Add, Radio , x92 y235 w150 h30 %checklogin1% vloginmethod +center , use fast login method
	Gui, Add, Radio, x92 y280 w150 h30 %checklogin2% +center , use alternative login method (no param. launch)
	
	Gui, Add, Button, x82 y110 w170 h50 %B1% gButtonaccount1 , %login1%
	Gui, Add, Button, x272 y110 w170 h50 %B2% gButtonaccount2 , %login2%
	Gui, Add, Button, x82 y170 w170 h50 %B3% gButtonaccount3 , %login3%
	Gui, Add, Button, x272 y170 w170 h50 %B4% gButtonaccount4 , %login4%
	
	Gui, Add, Radio, x282 y235 w150 h30 %checksilentorcsgo1%  vsilentorcsgo +center gsilentradio, start steam silently ;checkboxen?
	Gui, Add, Radio, x282 y280 w150 h30 %checksilentorcsgo2% +center gcsgoradio, start CSGO after login ;option für "pw" speichern bei anmelden
	
	Gui, Show, w532  h345 ,  Alpha 0.2.3 (26.04.2016) ;SMURF MASTER by Peter Holz (bananacry) Alpha TESTING DO NOT USE 0.2.2 (24.02.2016)
	
	if silentorcsgo=0
	{
		guicontrol, , silentorcsgo, 0
	}
	
	gui,submit,nohide
	;donating?
	;eigene verschlüsselung des passworts mit eigenem passwort (inputbox) 

}



RControl & Numpad1::
Buttonaccount1:
account=account1
goto, loginsteam

RControl & Numpad2::
Buttonaccount2:
account=account2
goto, loginsteam

RControl & Numpad3::
Buttonaccount3:
account=account3
goto, loginsteam

RControl & Numpad4::
Buttonaccount4:
account=account4
goto, loginsteam

Home::
GuiClose:
if modeclose=1
{
	modeclose:=0
	initialize()
	return
	
} else
{
	saveini(0)
	ExitApp
}


loginsteam:

settimer, steamrunerror, off
settimer, check, off
BlockInput OFF
;compatibility

saveini(0)

gui, submit

IniRead, username , smurf.ini, %account%, username
IniRead, pw , smurf.ini, %account%, password

settimer, encryptfail, -10000 ;A_index auslesung

f := A_TickCount

pw := StrDecrypt(pw,PWpw)

time=%a_dd%/%a_mm%/%a_yyyy% %a_hour%:%a_min%:%a_sec%
diff := A_TickCount-f
FileAppend,% "`n" . time . " - password decrypted after " .  diff . "ms", smurf.log

settimer, encryptfail, off

Process, Close , steam.exe
process, Waitclose , steam.exe, 4
if errorlevel!=0
{
	steamrunerror("close")
	return
}

setsteamparameters()

run %steamexe% "-login" %1username% %1pw% %parm0%,,UseErrorLevel%parm1% ;ausführen nicht als admin! (ausgelagerte exe?)
if errorlevel=ERROR 
{
	steamrunerror("start")
	initialize()
	return
}

;Run, steam://rungameid/730 ;war da nicht was mit wenn man slow login benutzt das er nicht anmeldet?
	
if loginmethod=2
	oldlogin()

gui,show
return


setsteamparameters()
{
	global
	
	parm0:=""
	parm1:=""

	if loginmethod=2
	{
		1username:="smurf_master_alt_login"
		1pw:="1337_gaben_give_knife"
	}
	else
	{
		1username:=username
		1pw:=pw
	}

	if silentorcsgo=1
	{
		parm0:="-silent"
		parm1:="|Hide"
	}
	if silentorcsgo=2
	{
		Process, Close , csgo.exe
		parm0:="-applaunch 730"
	} 

}

oldlogin()
{
	global
	;BlockInput ON
	c:=""
	b:=""
	d:=""
	col1:=""
	col2:=""
	col3:=""
	col4:=""
	
	f := A_TickCount
	settimer, steamrunerror, -30000
	
	loop
	{
		sleep 1
		WinActivate, ahk_exe steam.exe
		WinGetActiveTitle, OutputVar
		if OutputVar=Steam-Login
		{
			break
		}
	}
	settimer, steamrunerror, off
	
	time=%a_dd%/%a_mm%/%a_yyyy% %a_hour%:%a_min%:%a_sec%
	diff := A_TickCount-f
	FileAppend,% "`n" . time . " - steam opened after " .  diff . "ms", smurf.log
	
	settimer, Check, 1
	
	;waiter := 20000+(8*sl)+sl2
	
	settimer, steamrunerror, -10000
	
	BlockInput ON
	
	while (col2!=0x4748A9 and col3!=0xFFFFFF and col4!=0xFFFFFF)
	{
		FileAppend,% "`n" . time . " - colour " .  col2, smurf.log
		PixelGetColor,col2,27,225 ;anmelde "fehler"
		PixelGetColor,col3,401,250 ;weiß 1
		PixelGetColor,col4,382, 253 ;weiß 2
		sleep 250
		if d=1
		{
			return
		}
	}
	settimer, steamrunerror, off
	;FileAppend,% "`n" . time . " - pw = " .  pw, smurf.log
	
	/*
	loop, read, commands.txt
	{
		WinWaitActive, Steam-Login ;read datei in der befehle stehen?
		%A_loopline% 
		sleep sl
	}
	*/
	
	;im grunde genommen keine schleifen nötig vorallem die while Winactive("Steam-Login","","","") fnktioniert
	;glaube ich nicht so wie ich es denke..
	;überprüfen des eingegebenen mit clipboard und ^c ...
	Loop 
	{
		while Winactive("Steam-Login","","","")
		{
			sleep sl2
			WinWaitActive, Steam-Login 
			mousemove, 398, 101
			sleep 100
			WinWaitActive, Steam-Login 
			MouseClick, left,398,101 
			sleep 100
			WinWaitActive, Steam-Login 
			MouseClick, left,398,101 
			sleep sl
			WinWaitActive, Steam-Login 
			Send {backspace}
			sleep sl
			WinWaitActive, Steam-Login 
			Send ^{a}
			sleep sl
			WinWaitActive, Steam-Login 
			SendInput {Raw}%username% 
			sleep sl
			WinWaitActive, Steam-Login 
			Send {tab}
			sleep sl
			WinWaitActive, Steam-Login 
			Send ^{a}
			sleep sl
			WinWaitActive, Steam-Login 
			SendInput {Raw}%pw%
			sleep sl
			WinWaitActive, Steam-Login 
			Send {tab}
			sleep sl
			
			PixelGetColor, col1, 123,164
			if col1=0x262626 
				Send {Space}
			
			sleep sl
			WinWaitActive, Steam-Login 
			Send {tab}
			sleep sl
			WinWaitActive, Steam-Login 
			Send {Enter}
			sleep 500
			WinWaitActive, Steam-Login 
			Loop
			{
				sleep 1
				WinWaitActive, Steam-Login 
				PixelGetColor, col2, 27,225
				if col2=0x4748A9 ;rot
				{
					c:=1
					b:=1
					break
				}
				if (col2!=0x4748A9 and col2!=0x262626) ;nicht rot und steamfenster nicht mehr auf
				{
					c:=1
					break
				}
				if winexist("Steam-Login","","","")=0 
				{
					c:=1
					break
				}
			}
			if c=1
				break
		}
		if c=1
			break
	}
	
	
	
	settimer, check, off
	BlockInput OFF
	

	if b=1
		MsgBox, 4144, , Your saved username or password ist wrong. Maybe you tried this login method to often in the last hour. `n(In this case there is something with "too much login-failures in your network" shown in steam as error).
	
}

saveini(full)
{
	global
	Gui, submit,nohide
	IniWrite, %silentorcsgo%, smurf.ini, settings, silentorcsgo
	IniWrite, %loginmethod%, smurf.ini, settings, loginmethod
	
	
	if full=1
	{
		IniWrite, %steamexe%, smurf.ini, settings, steamexelocation
		
		IniWrite, %username1%, smurf.ini, account1, username
		IniWrite, %username2%, smurf.ini, account2, username
		IniWrite, %username3%, smurf.ini, account3, username
		IniWrite, %username4%, smurf.ini, account4, username
		
		
		gui,destroy
		settimer, pro, 500
		Gui, Add, Text, x2 y14 w260 h20 +Center vloadingtext, Smurf Master is loading
		; Generated using SmartGUI Creator for SciTE	
		Gui, Show, w266 h44, Smurf Master - Secure Products
	
		
		
		loop 4
		{
			if (password%A_Index%!="abcd")
			{
				if (password%A_Index%!="")
				{
				settimer, encryptfail, -10000 ;A_index auslesung?
				
				f := A_TickCount
				Random, q, 1000, 2000
				password%A_Index% := StrEncrypt(password%A_Index%,PWpw,q)
				
				time=%a_dd%/%a_mm%/%a_yyyy% %a_hour%:%a_min%:%a_sec%
				diff := A_TickCount-f
				FileAppend,% "`n" . time . " - password encrypted after " .  diff . "ms", smurf.log
				if fail=1  ;bei allen settimer hinzufügen !
					return
				settimer, encryptfail, off
				}
				IniWrite, % password%A_Index%, smurf.ini, account%A_Index%, password
			}
		}
		
		IniWrite, %sl%, smurf.ini, settings, donotchange
		IniWrite, %sl2%, smurf.ini, settings, donotchange2

	}
}

steamrunerror(mode="")
{
	global
	Blockinput off
	if (mode="exist")
		MsgBox, 262160, Error, steam.exe was not found in the given directory`n`n%steamexe%
	if (mode="start")
		MsgBox, 262160, Error, steam.exe could not be started`n`n%steamexe%
	if (mode="close")
	{
		modeclose:=1
		gui, destroy
		settimer, pro, off
		Fileinstall, Bilder\admin.png, %A_Temp%\admin.png 
		Gui, Add, Picture, x22 y49 w380 h540 , %A_Temp%\admin.png ;DIESE DATEI EINBINDEN!!!!
		Filedelete, %A_Temp%\admin.png
		Gui, Add, Text, x22 y19 w350 h30 +Center, You can solve the problem permanently if you check this:
		Gui, Show, w428 h595, Smurf Master admin-problem
		MsgBox, 262160, Error, steam.exe could not be closed.`nTry to run Smurf Master everytime as admin (shown in the opened gui) or close steam manually and prevent in the future to start steam as admin
	}
}

settinggui(backbutton)
{
	global
	gui destroy
	
	Gui, Add, Text, x50 y15 w400 h30 , here you can set your accounts and steam directory`nIf you set a password the program shows 4 characters
	
	Gui, Add, GroupBox, x22 y89 w520 h300 , your accounts
	Gui, Add, Edit, x182 y59 w350 h20 vsteamexe, %steamexe%
	Gui, Add, Edit, x182 y119 w350 h20 vusername1, %username1%
	Gui, Add, Edit, x182 y149 w350 h20 vpassword1 +password, %password1%
	Gui, Add, Edit, x182 y189 w350 h20 vusername2, %username2%
	Gui, Add, Edit, x182 y219 w350 h20 vpassword2 +password, %password2% 
	Gui, Add, Edit, x182 y259 w350 h20 vusername3, %username3% 
	Gui, Add, Edit, x182 y289 w350 h20 vpassword3 +password, %password3%
	Gui, Add, Edit, x182 y329 w350 h20 vusername4, %username4% 
	Gui, Add, Edit, x182 y359 w350 h20 vpassword4 +password, %password4% 
	Gui, Add, Text, x32 y59 w130 h20  , Steam directory
	Gui, Add, Text, x32 y119 w130 h20 , account 1
	Gui, Add, Text, x32 y149 w130 h20 , password
	Gui, Add, Text, x32 y189 w130 h20 , account 2
	Gui, Add, Text, x32 y219 w130 h20 , password
	Gui, Add, Text, x32 y259 w130 h20 , account 3
	Gui, Add, Text, x32 y289 w130 h20 , password
	Gui, Add, Text, x32 y329 w130 h20 , account 4
	Gui, Add, Text, x32 y359 w130 h20 , password
	
	Gui, Add, GroupBox, x22 y400 w520 h100 , timings for alternative login method
	Gui, Add, Text, x32 y430 w170 h20 , wait after steam login fail
	Gui, Add, Text, x32 y460 w170 h20 , wait between every input
	Gui, Add, Text, x290 y430 w170 h20 , milliseconds
	Gui, Add, Text, x290 y460 w170 h20 , milliseconds
	Gui, Add, Edit, x200 y430 w50 h20 vsl +number, %sl%
	Gui, Add, Edit, x200 y460 w50 h20 vsl2 +number, %sl2%
	
	Gui, Add, Button, x32 y510 w500 h40 , save

	if backbutton=1
		Gui, Add, Button, x430 y12 w120 h35, back to main program (no save)
	
	Gui, Show, w562 h564, Smurf Master - settings
}

checkini() ;in saveini() einbetten?
{
	global
	Gui, submit, nohide
	IfNotExist, %steamexe%
	{
		steamrunerror("exist")
		settinggui(0)
		return 1
	}
		
	if (loginmethod!=1 and loginmethod!=2)
	{	
		loginmethod:=1
	}
	
	if (silentorcsgo!=1 and silentorcsgo!=2 and silentorcsgo!=0)
	{	
		silentorcsgo:=0
	}
	
	if (username1="" or password1="")
	{
		MsgBox, 262192, , please set at minimum 1 account with username and password
		settinggui(0)	
		return 1
	}
}

Buttonsave:
if checkini()=1 
	return
saveini(1)
gui, destroy
initialize()
return

Buttonbacktomainprogram(nosave):
initialize()
return

opensettings:
saveini(0)
settinggui(1)
return

Check:
IfWinNotActive, ahk_exe steam.exe
{
	WinActivate, ahk_exe steam.exe
}
return

steamrunerror:
c:=1
steamrunerror("start")
initialize()
return


silentradio:

if silentorcsgo=1
	guicontrol,,silentorcsgo,0

if silentorcsgo=0
	guicontrol,,silentorcsgo,1
gui,submit,nohide
return

csgoradio:
gui, submit, nohide
return

encryptfail:
settinggui(1)
MsgBox, 4112, ERROR, password decryption failure please retype the password for account%A_index%
return

/*
slowerlogin: ;erklärung? mit checkbox nicht mehr anzeigen über ifmsgbox
GuiControl, disable, silent
return

fastlogin:
GuiControl, enable, silent
return
*/
