/*
 * * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\Live Enhancement Suite.exe
Compression=0
No_UPX=1
Created_Date=1
[VERSION]
Set_Version_Info=1
Company_Name=Inverted Silence & Dylan Tallchief
File_Description=Live Enhancement Suite
File_Version=0.1.3.3
Inc_File_Version=0
Internal_Name=Live Enhancement Suite
Legal_Copyright=© 2019
Original_Filename=Live Enhancement Suite
Product_Name=Live Enhancement Suite
Product_Version=0.1.3.2
[ICONS]
Icon_1=%In_Dir%\resources\blueico.ico
Icon_2=%In_Dir%\resources\blueico.ico
Icon_3=%In_Dir%\resources\redico.ico
Icon_4=%In_Dir%\resources\redico.ico
Icon_5=%In_Dir%\resources\redico.ico

* * * Compile_AHK SETTINGS END * * *
*/

; AHK Setup
#MaxThreadsPerHotkey 2
CoordMode, Menu, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetTitleMatchMode, Regex
SetWorkingDir %A_ScriptDir%
SetDefaultMouseSpeed, 0
#InstallKeybdHook
#KeyHistory 100
#SingleInstance Force
setmousedelay, -1 
setbatchlines, -1
#UseHook
#MaxHotkeysPerInterval 400

OnExit, exitfunc

; Tray Menu Setup
Menu, Tray, NoStandard
Menu, Tray, Add, Configure Settings, settingsini
Menu, Tray, Add, Configure Menu, menuini
Menu, Tray, Add,
Menu, Tray, Add, Donate 💲, monatpls
Menu, Tray, Add,
Menu, Tray, Add, Strict Time, stricttime
Menu, Tray, Add, Check Project Time 🕒, requesttime
Menu, Tray, Add,
Menu, Tray, Add,
Menu, Tray, Add, Install InsertWhere, InsertWhere
Menu, Tray, Add, Manual 📖, Manual
Menu, Tray, Add, Exit ❌, quitnow
Menu, Tray, Default, Exit ❌
Menu, Tray, insert, 9&, Reload ⟳️, doreload
Menu, Tray, insert, 10&, Pause && Suspend, freeze

Random, randomgen, 1, 13
randomTips := ["Ableton Live 2: Electric Boogaloo", "Super Live Bros: Lost Levels", "LES is more", "Live HD Audio Manager", "Vitableton Enhancement 100mg [Now with extra vitamin C!]", "hey`, pshh!! hit both shift keys with debug on", "Do more with LES", "*Cowbell*", "OTT.exe", "Live Sweet", "Ableton Gratis Saus", "The biggest thing since sliced bread"]
Menu, Tray, Tip, % randomTips[randomgen]

FileRead, stricttxt, %A_ScriptDir%\resources\strict.txt
stricton := (ErrorLevel = 1) ? 1 : stricttxt
if (stricttxt = 1) {
    Menu, Tray, Check, Strict Time
}

; Installation
FileReadLine, OutputVar, %A_ScriptDir%/resources/firstrun.txt, 1
if (ErrorLevel = 1 || OutputVar != 0) {
    If !InStr(FileExist("resources"), "D") {
        Loop, %A_ScriptDir%\*.*, 1, 1
        If (A_Index > 3) {
            MsgBox, 48, Live Enhancement Suite, You have placed LES in a directory that contains other files.`n LES will create new files when used for the first time.`n Please move the program to a dedicated directory.
            ExitApp
        }
    }

    if InStr(A_ScriptDir, "Windows\Temp") or InStr(A_ScriptDir, "\AppData\Local\Temp") {
        MsgBox, 48, Live Enhancement Suite, You executed LES from within your file extraction software.`nThis placed it inside of a temporary cache folder, which will cause it to be deleted by Windows' cleanup routine.`nPlease extract LES into its own folder before proceeding.
        ExitApp
    }

    if (InStr(A_ScriptDir, "C:\Program Files") || InStr(A_ScriptDir, "C:\Program Files (x86)")) {
        MsgBox, 4, Live Enhancement Suite, You may have executed LES from within a system folder.`nThis may cause LES to not function properly, as it will not have enough permissions to self-extract in this location.`nAre you sure you want to install LES in this location?`nPlease move this folder to another location to remove this warning.
        IfMsgBox No {
            ExitApp
        }
    }

    ; Extract resources from the .exe
    FileCreateDir, resources
    FileInstall, resources/readmejingle.wav, %A_ScriptDir%/resources/readmejingle.wav
    FileInstall, resources/piano.png, %A_ScriptDir%/resources/piano.png
    FileInstall, resources/piano2.png, %A_ScriptDir%/resources/piano2.png
    FileInstall, resources/pianoblack.png, %A_ScriptDir%/resources/pianoblack.png
    FileInstall, menuconfig.ini, %A_ScriptDir%/menuconfig.ini
    FileInstall, settings.ini, %A_ScriptDir%/settings.ini

    MsgBox, 4, Live Enhancement Suite, Welcome to the Live Enhancement Suite!`nWould you like to add the Live Enhancement Suite to startup?`nIt won't do anything when you're not using Ableton Live.`n(This can be changed anytime)
    IfMsgBox Yes {
        Loop, Read, %A_ScriptDir%/settings.ini, %A_ScriptDir%/settingstemp.ini
        {
            testforstartup := Instr(A_LoopReadLine, "addtostartup")
            If (testforstartup = 1) {
                FileAppend, addtostartup = 1`n, %A_ScriptDir%/settingstemp.ini
                FileAppend, `;`causes the script to launch on startup`n, %A_ScriptDir%/settingstemp.ini
            } Else {
                FileAppend, %A_LoopReadLine%`n, %A_ScriptDir%/settingstemp.ini
            }
        }
        goto, donewithintro
    }

    Loop, Read, %A_ScriptDir%/settings.ini, %A_ScriptDir%/settingstemp.ini
    {
        testforstartup := Instr(A_LoopReadLine, "addtostartup")
        If (testforstartup = 1) {
            FileAppend, addtostartup = 0`n, %A_ScriptDir%/settingstemp.ini
            FileAppend, `;`causes the script to launch on startup`n, %A_ScriptDir%/settingstemp.ini
        } Else {
            FileAppend, %A_LoopReadLine%`n, %A_ScriptDir%/settingstemp.ini
        }
    }

donewithintro:
    FileDelete, %A_ScriptDir%/resources/firstrun.txt
    FileAppend, 0, %A_ScriptDir%/resources/firstrun.txt
    FileDelete, %A_ScriptDir%/settings.ini
    FileMove, %A_ScriptDir%/settingstemp.ini, %A_ScriptDir%/settings.ini
    Sleep, 50
    SetTimer, tooltipboi, 1
    Sleep, 2
}

FileReadLine, OutputVar, %A_ScriptDir%\resources\firstrun.txt, 2
coolpath := A_ScriptFullPath
if (ErrorLevel = 1 or OutputVar != coolpath) {
    FileReadLine, line1, %A_ScriptDir%\resources\firstrun.txt, 1
    FileReadLine, line2, %A_ScriptDir%\resources\firstrun.txt, 2
    if (Errorlevel = 0) {
        RegDelete, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %line2%
    }
    FileDelete, %A_ScriptDir%/resources/firstrun.txt
    FileAppend, %line1%, %A_ScriptDir%/resources/firstrun.txt
    FileAppend, `n%A_ScriptFullPath%, %A_ScriptDir%/resources/firstrun.txt
    RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %A_ScriptFullPath%, ~ HIGHDPIAWARE
}

loop, 1 { ;test if configuration files are present
    FileReadLine, OutputVar, settings.ini, 1
    if (ErrorLevel = 1) {
        Msgbox, 4, Oops!, The settings.ini file is missing and is required for operation. Create new?
        IfMsgBox Yes {
            FileInstall, settings.ini, %A_ScriptDir%/settings.ini
        } Else {
            ExitApp
        }
    }
    FileReadLine, OutputVar, menuconfig.ini, 1
    if (ErrorLevel = 1) {
        Msgbox, 4, Oops!, The menuconfig.ini file is missing and is required for operation. Create new?
        IfMsgBox Yes {
            FileInstall, menuconfig.ini, %A_ScriptDir%/menuconfig.ini
        } Else {
            ExitApp
        }
    }
}

gui, +AlwaysOnTop
Gui, Show, w0 h0
Gui, Color, 4D4D4D
guicontrol, font, s12
gui, font, s12
Gui, Add, Edit, w0 h0
sleep, 50
Settimer, testing, 50
Gui, Submit

gosub menufile

IniRead, result, settings.ini, main, autoadd
if !(result in "0,1") {
    MsgBox % "Invalid parameter for " . Chr(34) "autoadd" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
    Run, %A_ScriptDir%\settings.ini
    ExitApp
}
IniRead, result, settings.ini, main, autodelete
if !(result in "0,1") {
    MsgBox % "Invalid parameter for " . Chr(34) "autodelete" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
    Run, %A_ScriptDir%\settings.ini
    ExitApp
}
IniRead, result, settings.ini, main, autoq
if !(result in "0,1") {
    MsgBox % "Invalid parameter for " . Chr(34) "autoq" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
    Run, %A_ScriptDir%\settings.ini
    ExitApp
}
IniRead, result, settings.ini, main, logauto
if !(result in "0,1") {
    MsgBox % "Invalid parameter for " . Chr(34) "logauto" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
    Run, %A_ScriptDir%\settings.ini
    ExitApp
}
IniRead, result, settings.ini, main, launchmini
if !(result in "0,1") {
    MsgBox % "Invalid parameter for " . Chr(34) "launchmini" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
    Run, %A_ScriptDir%\settings.ini
    ExitApp
}
IniRead, result, settings.ini, main, qprev
if !(result in "0,1") {
    MsgBox % "Invalid parameter for " . Chr(34) "qprev" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
    Run, %A_ScriptDir%\settings.ini
    ExitApp
}
IniRead, result, settings.ini, main, mmove
if !(result in "0,1") {
    MsgBox % "Invalid parameter for " . Chr(34) "mmove" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
    Run, %A_ScriptDir%\settings.ini
    ExitApp
}
IniRead, result, settings.ini, main, mk
if !(result in "0,1") {
    MsgBox % "Invalid parameter for " . Chr(34) "mk" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
    Run, %A_ScriptDir%\settings.ini
    ExitApp
}
IniRead, result, settings.ini, main, xtra
if !(result in "0,1") {
    MsgBox % "Invalid parameter for " . Chr(34) "xtra" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
    Run, %A_ScriptDir%\settings.ini
    ExitApp
}

IniRead, result, settings.ini, main, setting4
If !InStr(result, ".") {
    MsgBox % "Invalid parameter for " . Chr(34) "setting4" . Chr(34) . ". Valid parameters are floating point numbers. The program will shut down now."
    Run, %A_ScriptDir%\settings.ini
    ExitApp
}
IniRead, result, settings.ini, main, checkbpm
If !InStr(result, "0,1,2,3,4,5,6,7,8,9") {
    MsgBox % "Invalid parameter for " . Chr(34) "checkbpm" . Chr(34) . ". Valid parameters are single digit numbers. The program will shut down now."
    Run, %A_ScriptDir%\settings.ini
    ExitApp
}
IniRead, result, settings.ini, main, notelength
If !InStr(result, "1,2,4,8,16,32,64") {
    MsgBox % "Invalid parameter for " . Chr(34) "notelength" . Chr(34) . ". Valid parameters are one of the following: 1, 2, 4, 8, 16, 32, 64. The program will shut down now."
    Run, %A_ScriptDir%\settings.ini
    ExitApp
}
IniRead, result, settings.ini, main, noteheight
If !InStr(result, "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16") {
    MsgBox % "Invalid parameter for " . Chr(34) "noteheight" . Chr(34) . ". Valid parameters are one of the following: 1-16. The program will shut down now."
    Run, %A_ScriptDir%\settings.ini
    ExitApp
}

if !FileExist("path.txt") {
    FileAppend, `n, path.txt
}

If (launchmini = 1) {
    Reload
    run, %A_ScriptDir%\miniversion.exe
    ExitApp
}

tooltip, Loading...
IniRead, shortcuts, settings.ini, main, shortcut
IniRead, audiorate, settings.ini, main, audiorate
IniRead, peak, settings.ini, main, peak
IniRead, peakmsg, settings.ini, main, peakmsg
IniRead, randominterval, settings.ini, main, randominterval
IniRead, dontsend, settings.ini, main, dontsend
IniRead, autostart, settings.ini, main, autostart
IniRead, autoclose, settings.ini, main, autoclose
IniRead, idle, settings.ini, main, idle
IniRead, idlewarn, settings.ini, main, idlewarn
IniRead, tick, settings.ini, main, tick

; Safe Mode
IniRead, safemode, settings.ini, main, safemode
IniRead, safemodeaction, settings.ini, main, safemodeaction
IniRead, safemodeval, settings.ini, main, safemodeval
If (safemode = 1) {
    Sleep, 1000
    If !ProcessExist("Ableton Live.exe") {
        If (safemodeaction = "exit") {
            ExitApp
        } Else If (safemodeaction = "warning") {
            MsgBox % "Warning: Ableton Live is not running."
        }
    }
    safemodeactive := 1
}

; Define Hotkeys
#IfWinActive ahk_class LiveApplicationMainWindow
    Hotkey, %shortcuts%, autohotkey, On
    Hotkey, F1, runahk, On
    Hotkey, F2, runahk, On
    Hotkey, F3, runahk, On
    Hotkey, F4, runahk, On
    Hotkey, F5, runahk, On
    Hotkey, F6, runahk, On
    Hotkey, F7, runahk, On
    Hotkey, F8, runahk, On
    Hotkey, F9, runahk, On
    Hotkey, F10, runahk, On
    Hotkey, F11, runahk, On
    Hotkey, F12, runahk, On
    Hotkey, ^!f1, runahk, On
    Hotkey, ^!f2, runahk, On
    Hotkey, ^!f3, runahk, On
    Hotkey, ^!f4, runahk, On
    Hotkey, ^!f5, runahk, On
    Hotkey, ^!f6, runahk, On
    Hotkey, ^!f7, runahk, On
    Hotkey, ^!f8, runahk, On
    Hotkey, ^!f9, runahk, On
    Hotkey, ^!f10, runahk, On
    Hotkey, ^!f11, runahk, On
    Hotkey, ^!f12, runahk, On
    Hotkey, !^f1, runahk, On
    Hotkey, !^f2, runahk, On
    Hotkey, !^f3, runahk, On
    Hotkey, !^f4, runahk, On
    Hotkey, !^f5, runahk, On
    Hotkey, !^f6, runahk, On
    Hotkey, !^f7, runahk, On
    Hotkey, !^f8, runahk, On
    Hotkey, !^f9, runahk, On
    Hotkey, !^f10, runahk, On
    Hotkey, !^f11, runahk, On
    Hotkey, !^f12, runahk, On
#IfWinActive

#IfWinActive ahk_class Notepad
    Hotkey, ^!f1, runahk, On
    Hotkey, ^!f2, runahk, On
    Hotkey, ^!f3, runahk, On
    Hotkey, ^!f4, runahk, On
    Hotkey, ^!f5, runahk, On
    Hotkey, ^!f6, runahk, On
    Hotkey, ^!f7, runahk, On
    Hotkey, ^!f8, runahk, On
    Hotkey, ^!f9, runahk, On
    Hotkey, ^!f10, runahk, On
    Hotkey, ^!f11, runahk, On
    Hotkey, ^!f12, runahk, On
    Hotkey, !^f1, runahk, On
    Hotkey, !^f2, runahk, On
    Hotkey, !^f3, runahk, On
    Hotkey, !^f4, runahk, On
    Hotkey, !^f5, runahk, On
    Hotkey, !^f6, runahk, On
    Hotkey, !^f7, runahk, On
    Hotkey, !^f8, runahk, On
    Hotkey, !^f9, runahk, On
    Hotkey, !^f10, runahk, On
    Hotkey, !^f11, runahk, On
    Hotkey, !^f12, runahk, On
#IfWinActive

#IfWinActive

; Main Functionality
autohotkey:
runahk:
    ; Your existing autohotkey logic
    Return

; Additional Functions
doreload:
    Reload
    Return

freeze:
    Pause, Toggle
    Return

settingsini:
    Run, %A_ScriptDir%\settings.ini
    Return

menuini:
    Run, %A_ScriptDir%\menuconfig.ini
    Return

monatpls:
    Run, https://paypal.me/DylanTallchief
    Return

stricttime:
    if (stricttxt = 1) {
        FileDelete, %A_ScriptDir%\resources\strict.txt
        stricttxt := 0
        Menu, Tray, Uncheck, Strict Time
    } else {
        FileAppend, 1, %A_ScriptDir%\resources\strict.txt
        stricttxt := 1
        Menu, Tray, Check, Strict Time
    }
    Return

requesttime:
    MsgBox % "Current time: " . A_Now
    Return

InsertWhere:
    Run, %A_ScriptDir%\InsertWhere.exe
    Return

Manual:
    Run, %A_ScriptDir%\Manual.pdf
    Return

quitnow:
    ExitApp
    Return

tooltipboi:
    tooltip, % "Live Enhancement Suite"
    SetTimer, tooltipboi, Off
    Return

testing:
    ; Your existing testing logic
    Return

menufile:
    ; Your existing menu file logic
    Return

ProcessExist(name) {
    Process, Exist, %name%
    return !!ErrorLevel
}

exitfunc:
    ExitApp
