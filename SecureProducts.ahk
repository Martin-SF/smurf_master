/*
	copy and paste this code on the beginning of your code:
	
	#include, C:\YOUR_PATH\SecureProducts1.0.ahk
	return
	
	initialize() ;will be called when license is valid
	{
		FileAppend, `nLicense valid, SP.log
		;copy and paste everything left from your auto execute
	}
  
*/


#NoEnv
SetBatchLines -1
#SingleInstance, Force
#notrayicon
ListLines Off
SetWorkingDir, %A_ScriptDir%

checklicense()
return

checklicense() {
	global
	
	;MsgBox, 4160, -Secure Products-  by Peter Holz, Booting...`n`nmade by Peter Holz., 0.3
	Gui, destroy
	;Gui, Add, Progress, x32 y39 w270 h30 vloading
	
	Gui, Add, Text, x2 y14 w260 h20 +Center vloadingtext, %programname% is loading
	Gui, Show, w266 h44, Secure Products 1.3
	
	settimer, pro, 500
	pro := 0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Die Computer-spezifische Mac-Adresse auslesen
	RunWait, %comspec% /c ipconfig /all > %A_Temp%\demo.tmp, , hide
	Loop, Read, %A_Temp%\demo.tmp 
	{
		IfInString, A_LoopReadLine, Physi ;MAC sicherstellen!!!
		{
			PPID = %A_LoopReadLine%
			StringRight, PPID, PPID, 18 ;müll abschneiden
			StringLeft, ersteStelle, PPID, 1
			Transform, Code, Asc, %ersteStelle%
			if Code = 32
				StringRight, PPID, PPID, StrLen(PPID)-1
			break
		}
	}
	;Diese Datei entstand bei der Suche ->löschen
	FileDelete, %A_Temp%\demo.tmp
	
	;bei zu kurzer Mac-Adresse wird das Programm beendet
	if (StrLen(PPID) < 17) {  
		MsgBox, 262160, Fatal Error , ERROR 17 contact: peter.holz@hotmail.de
		return
	}
	
	;Wenn das Programm das erste mal gestartet wird, wird eine neue Konfigurationsdatei erstellt
	if !FileExist(programininame) {
		verifyfailure(1,0)
		return
	}
	
	;Bei Existenz werden die Werte ausgelesen...
	
	IniRead, License, %programininame% , License, License
	
	if (License = "blyat") {
		initialize()
		return
	}
	
	;------Überprüfungsfunktion------
	
	if (License=0 or strlen(License)<1) {
		verifyfailure(0,0)
		return
	}
	
	;Die Lizenz entschlüsseln 
	settimer, brockenencrypt, -20000
	
	f := A_TickCount
	License := StrDecrypt(License,Licensepw)
	
	time=%a_dd%/%a_mm%/%a_yyyy% %a_hour%:%a_min%:%a_sec%
	diff := A_TickCount-f
	FileAppend,% "`n" . time . " - license decrypted after " .  diff . "ms", %programlogname%

	settimer, brockenencrypt, off
	
	;B-Werte vorbereiten
	do := ":"
	cutofflicense := License

	pos1 := InStr(cutofflicense, do ,CaseSensitive=false)
	StringTrimLeft, cutofflicense, cutofflicense, pos1

	pos2 := InStr(cutofflicense, do ,CaseSensitive=false)
	StringTrimLeft, cutofflicense, cutofflicense, pos2
	pos2 := pos1+pos2

	pos3 := InStr(cutofflicense, do ,CaseSensitive=false)
	StringTrimLeft, cutofflicense, cutofflicense, pos3
	pos3 := pos2+pos3
	
	pos4 := InStr(cutofflicense, do ,CaseSensitive=false)
	StringTrimLeft, cutofflicense, cutofflicense, pos4
	pos4 := pos3+pos4

	pos5 := InStr(cutofflicense, do ,CaseSensitive=false)
	StringTrimLeft, cutofflicense, cutofflicense, pos5
	pos5 := pos4+pos5
	
	
	stringMid, Bvalue1 ,License,1 ,pos1-1
	stringMid, Bvalue2 ,License,(pos1+1),(pos2-pos1)-1
	stringMid, Bvalue3 ,License,(pos2+1),(pos3-pos2)-1
	stringMid, Bvalue4 ,License,(pos3+1),(pos4-pos3)-1
	stringMid, Bvalue5 ,License,(pos4+1),(pos5-pos4)-1
	stringMid, Bvalue6 ,License,(pos5+1),(StrLen(License))-pos5
	;Nun haben wir in den Bvalue1 bis Bvalue6 die entsprechenden Werte die mit den eigenen Werten (Mac-Adresse) passen sollten

	; A-Werte vorbereiten (Mac-Adresse)
	stringMid, Avalue1 ,PPID,1 ,2
	stringMid, Avalue2 ,PPID,4 ,2
	stringMid, Avalue3 ,PPID,7 ,2
	stringMid, Avalue4 ,PPID,10 ,2
	stringMid, Avalue5 ,PPID,13 ,2
	stringMid, Avalue6 ,PPID,16 ,2
	
	;Werte von Hexadezimal in natürliche Zahlen umwandelt (Datentyp: UShort)
	Avalue1 := HexToUShort(Avalue1)
	Avalue2 := HexToUShort(Avalue2)
	Avalue3 := HexToUShort(Avalue3)
	Avalue4 := HexToUShort(Avalue4)
	Avalue5 := HexToUShort(Avalue5)
	Avalue6 := HexToUShort(Avalue6) ;loop mit A_index


	;A und B Werte vergleichen
	;Wenn die Addition der A und B Werte das richtige Ergebnis liefern, wird die Kontrollvariabel mit verschiedenen Operationen behandelt
	;Diese konfiguration von Vergleichen ist natürlich individuell verstellbar
	if ((Avalue1+Bvalue1)=152)
		Counter += 7
	if ((Avalue2+Bvalue2)=236)
		Counter -= 3
	if ((Avalue3+Bvalue3)=164)
		Counter *= 20
	if ((Avalue4+Bvalue4)=14)
		Counter /= 40
	if ((Avalue5+Bvalue5)=151)
		Counter *= 200
	if ((Avalue6+Bvalue6)=223)
		Counter += 6059
	
	
	;Wenn alle Additionen korrekt waren wird diese if-Anweisung übersprungen und man erhält die Nachricht für die korrekte Lizenz
	;Wenn nicht der richtige Schlüssel verwendet wurde wird die Mac Adresse neu in die Konfigurations-Datei geschrieben und eine Fehlermeldung ausgesandt.
	if (Counter!=6459) {
		verifyfailure(0,1)
		return
	}

	;time=%a_dd%/%a_mm%/%a_yyyy% %a_hour%:%a_min%:%a_sec%
	;FileAppend,% "`n" . time . " - License valid" , %programlogname%.log
	if Buttonverify=1
		MsgBox, 262208, , License correct!`n`nmade by PETER HOLZ`ncontact: peter.holz@hotmail.de, 5
	
	initialize()
}

verifyfailure(one,type) {
	global
	
	PPID := StrEncrypt(PPID,PPIDpw,3000)
	
	Gui, destroy
	
	
	time=%a_dd%/%a_mm%/%a_yyyy% %a_hour%:%a_min%:%a_sec%
	
	if (one=1) {
		FileAppend,% "`n" . time . " - writeini" , %programlogname%
		e:=""
		IniWrite, %e%, %programininame% , License, License
	}
	
	settimer, pro, off
	Gui, Add, Edit, x142 y19 w330 h20 +ReadOnly, %PPID%
	Gui, Add, Edit, x142 y59 w330 h20 vLi,
	Gui, Add, Text, x22 y19 w90 h30 , Personal ID Code (PPID)
	Gui, Add, Button, x212 y89 w170 h30 , verify
	Gui, Add, Text, x22 y59 w90 h20 , License
	Gui, Add, Text, x142 y129 w330 h75 , Write an email to peter.holz@hotmail.de to get a license (dont forget you PPID) 
	Gui, Show, w508 h215, License for %programname%
	
	if (type=0) { ;no .ini
		FileAppend,% "`n" . time . " - Error0" , %programininame%
		MsgBox, 262160, Activation, Write an email to peter.holz@hotmail.de to get a license (dont forget you PPID) `n(Badkey0)
	}
	if (type=1) { ;falscher Key
		FileAppend,% "`n" . time . " - Error1" , %programininame%
		MsgBox, 262160, Activation, Write an email to peter.holz@hotmail.de to get a license (dont forget you PPID) `n(Badkey1) 
	}
	if (type=2) { ;unvollständige License bzw. nicht entschlüsselbar
		FileAppend,% "`n" . time . " - Error2" , %programininame%
		MsgBox, 262160, Activation, Bitte kontaktieren sie den Entwickler unter:`n`npeter.holz@hotmail.de oder TF | CryAndDie `n`num eine gültige Lizenz für ihren Computer zu erhalten.`n(Badkey2) ; altes "zu lange"
	}
}

Buttonverify:

	gui,submit
	IniWrite, %Li%, %programininame%, License, License
	Buttonverify:=1
	checklicense()
return

brockenencrypt:

	verifyfailure(1,2)
return

pro:

	if (pro=0) {
		guicontrol,,loadingtext, %programname% is loading .
		pro:=1
	}
	else if (pro=1) {
		guicontrol,,loadingtext, %programname% is loading ..
		pro:=2
	}
	else if (pro=2) {
		guicontrol,,loadingtext, %programname% is loading ...
		pro:=0
	}
return

/*
*
*
*
-------------decryption functions-------------
credits to nnnik 
source: https://autohotkey.com/board/topic/91439-stringencrypt-decrypt-by-nnnik/
*
*
*/

StrEncrypt(Str,Pass="",Quality=1)
{
Strarr:=[]
PWARR:=[]
Loop,Parse,str
    Strarr.Insert(asc(A_LoopField))
Loop,Parse,Pass
    PWARR.Insert(asc(A_LoopField))
StrArr:=FilterAlgid(StrArr,PwArr,Quality)
s:=""
For each,val in StrArr
    s.=UShortToHex(val)
return s
}

StrDecrypt(Str,Pass="")
{
Strarr:=[]
PWARR:=[]
Loop, % strlen(str)//4
    Strarr.Insert(HexToUShort(SubStr(Str,(A_Index-1)*4+1,4)))
Loop,Parse,Pass
    PWARR.Insert(asc(A_LoopField))
StrArr:=FilterRemoveAlgid(StrArr,PwArr)
s:=""
For each,val in StrArr
   s.=chr(val)
return s
}


FilterAlgid(StrArr,PwArr,Quality=1,modvar=0x10000)
{
Strarr:=strarr.Clone()
PwArr:=Pwarr.Clone()
Strarr:=Filter3(StrArr,modvar)
Loop, % Quality+1
{
PWArr:=Filter1(PWArr,0,modvar)
PWArr:=Filter2(PWarr,0)
buf:=Calcbuf(PWarr,modvar)
strarr:=Filter1(strarr,buf,modvar)
strarr:=Filter2(strarr,buf)
}
strarr.insert(Quality)
return strarr
}

FilterRemoveAlgid(StrArr,PwArr,modvar=0x10000)
{
bufarr:=[]
Strarr:=strarr.Clone()
PwArr:=Pwarr.Clone()
Quality:=strarr[strarr.maxindex()]
strarr.remove()
Loop % Quality+1
{
PWArr:=Filter1(PWArr,0,modvar)
PWArr:=Filter2(PWarr,0)
bufarr.insert(Calcbuf(PWarr,modvar))
}
Loop, % Quality+1
{
strarr:=Filter2Remove(strarr,bufarr[Quality+2-A_Index])
strarr:=Filter1Remove(strarr,bufarr[Quality+2-A_Index],modvar)
}
Strarr:=Filter3Remove(StrArr,modvar)
return strarr
}

Calcbuf(arr,modvar=0x100000000)
{
    buf:=0
    lastnum:=0
    Loop, % arr.Maxindex()
    {
      For each,val in arr
        buf:=mod((val*(buf+1))+val,modvar)
    }
return buf
}

Filter1(arr,buf,modvar=0x100000000)
{
    lastnum:=0
    arr:=arr.Clone()
    Loop, % arr.Maxindex()
    {
      buf:=mod(mod(buf+lastnum+A_Index,modvar)*(buf+1)*(lastnum+1)*mod(A_Index,modvar)*255,modvar)
	  arr[A_Index]:=mod(buf+(lastnum:=arr[A_Index]),modvar)
    }
return arr
}
 
Filter1Remove(arr,buf,modvar=0x100000000)
{
    lastnum:=0
    arr:=arr.Clone()
    Loop, % arr.MaxIndex()
    {
      buf:=mod(mod(buf+lastnum+A_Index,modvar)*(buf+1)*(lastnum+1)*mod(A_Index,modvar)*255,modvar)
       arr[A_Index]:=lastnum:=min(mod(arr[A_Index]-buf,modvar),modvar)
    }
return arr
} 
 
Filter2(arr,PWVar=0)
{
v2:=[],s:=[],buf:=0
x:=arr.Maxindex()
Loop, % x
    s[A_Index]:=A_Index
Loop, % x
    n:=Floor(mod(buf+PWVar,s.Maxindex())+1),w:=s[n],buf:=(v2[w]:=arr[x-A_Index+1]),s.Remove(n,n)
return v2
}
 
Filter2Remove(arr,PWVar=0)
{
v2:=[],s:=[],buf:=0
x:=arr.Maxindex()
Loop, % x
    s[A_Index]:=A_Index
Loop, % x
    n:=Floor(mod(buf+PWVar,s.Maxindex())+1),w:=s[n],buf:=(v2[x-A_Index+1]:=arr[w]),s.Remove(n,n)
return v2
}

Filter3(arr,modvar)
{
cmin:=modvar
cmax:=0
spclmodvar:=1
vmod:=0
strl:=arr.Maxindex()
For each, val in arr
	cmin:=val<cmin?val:cmin,cmax:=val>cmax?val:cmax
while ((cmax-cmin)>spclmodvar-1)
	spclmodvar*=2,vmod:=A_Index
cmin-=(cmin+spclmodvar-1)>(modvar-1)?(cmin+spclmodvar-1)-(modvar-1):0
if (cmax-cmin)<(spclmodvar-1)
	Random,var,0,% (spclmodvar-1)-(cmax-cmin)
cmin-=var
cmin:=cmin<0?cmin:=0:cmin
If (vmod=0)
	return [strl>>16,strl-((strl>>16)<<16),cmin,0]
For each, val in arr
	arr[each]-=cmin
spclmodvar:=1
cmax:=""
vmod2:=""
while ((modvar-1)>spclmodvar-1)
	spclmodvar*=2,vmod2:=A_Index
arr2:=[]
rest:=0
For each, val in arr
{
    w:=ceil((A_Index*vmod)/vmod2)
	rest:=rest+vmod
	If (rest<=vmod2)
	{
		arr2[w]:=(arr2[w]?arr2[w]:0)+(val<<(vmod2-rest))
	}
	else
	{	
		rest:=(rest-vmod2)
		arr2[w-1]:=arr2[w-1]+(val>>rest)
		v:=val-((val>>rest)<<rest)
		arr2[w]:=(v<<(vmod2-rest))
	}
}
arr2.Insert(strl>>16)
arr2.Insert(strl-((strl>>16)<<16))
arr2.Insert(cmin)
arr2.Insert(vmod)
return arr2
}


Filter3Remove(arr,modvar)
{
arr2:=[]
cmin:=arr[arr.maxindex()-1]
vmod:=arr[arr.maxindex()]
strl:=arr[arr.maxindex()-2]+(arr[arr.maxindex()-3]<<16)
arr.remove()
arr.remove()
arr.remove()
arr.remove()
if !vmod
{
	if strl<0x5FFFFF
	Loop, % StrL
		arr2.Insert(cmin)
	return arr2
}
spclmodvar:=1
while ((modvar-1)>spclmodvar-1)
	spclmodvar*=2,vmod2:=A_Index
rest:=0
Loop % strl
{
    w:=ceil((A_Index*vmod)/vmod2)
	rest:=rest+vmod
	if ((rest)<=vmod2)
	{
		arr2[A_Index]:=arr[w]>>(vmod2-rest)
		arr[w]-=arr2[A_Index]<<(vmod2-rest)
	}
	else
	{
		rest:=(rest-vmod2)
		arr2[A_Index]:=arr[w-1]<<(rest)
		arr2[A_index]+=arr[w]>>(vmod2-rest)
		arr[w]-=((arr[w]>>(vmod2-rest))<<(vmod2-rest))
	}
}
For each, v in arr2
	arr2[each]+=cmin
return arr2
}
 
min(val,modvar=0xFFFFFFFF)
{
while val<0
    val+=modvar
return val
}

showarr(arr)
{
str2:="["
For each,key in	arr
	str2.=key "`,"
StringTrimright,str2,str2,1
str2.="]"
return str2
}

HexToUShort(str)
{
static d:={0:"0",1:"1",2:"2",3:"3",4:"4",5:"5",6:"6",7:"7",8:"8",9:"9","A":10,"B":11,"C":12,"D":13,"E":14,"F":15}
val:=0
Loop,Parse,str
	val:=(val<<4)+d[A_Loopfield]
return val
}

UShortToHex(val)
{
static d:={0:"0",1:"1",2:"2",3:"3",4:"4",5:"5",6:"6",7:"7",8:"8",9:"9",10:"A",11:"B",12:"C",13:"D",14:"E",15:"F"}
s:=""
var:=val
Loop, % 4
	val:=var>>(4*(4-A_index)),s.=d[val],var-=val<<(4*(4-A_index))
return s
}