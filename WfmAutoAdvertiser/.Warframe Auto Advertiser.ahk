; --------------------------- CHANGE THIS ----------------------


wts := "WTB [DEEZ] | WTS [NUTS]" ; The advertisement to be sent (paste it inside the "")
startHotkey := "F1" ; Starting script Key, change it to your liking DEFAULT = "F1"

; FEATURES
; Send advertisements in the Trading chat while AFK
; Send advertisements while you use another application. eg: youtube video
; The script search for the chatbox location, so you do not have to worry aboout not finding the Trading chat

; NOTE (Im working on it, wait for later updates)
; you should have 5 chat tabs opened
; (Squad / Clan / Alliance or Region / Recruiting / Trading chat)   or   (Squad / Dojo / Clan / Alliance or Recruiting / Trading chat)
; If you are not in a clan, you can activate any another chats (eg: region), but it will only work if youre in orbiter, not in dojo
; you should reload (right click on tray icon > reload script) everytime you change your advertisement above

; If you encounter any bugs, contact me via discord: the_funeral_pyre



; -----------------------DO NOT CHANGE BELOW --------------------
; Initialize variables
isRunning := false
originalWindowTitle := ""

CoordMode, Pixel, Screen

; toggle script on/off
Hotkey, %startHotkey%, StartRun
return

StartRun:
    isRunning := !isRunning
    if (isRunning) {
	Tooltip, WARFRAME AUTO ADVERTISER -- ON, 0, 0, 1
        ; Store the current active window title
        WinGetActiveTitle, originalWindowTitle
        SetTimer, CheckAndSendText, 100 ; Start timer for the first time
    } else {
	Tooltip, WARFRAME AUTO ADVERTISER -- OFF, 0, 0, 1
        SetTimer, CheckAndSendText, Off ; Stop the timer
    }
return

; Function to check and send text
CheckAndSendText:
    if (isRunning) {


        SetTimer, CheckAndSendText, 5000 ; Start timer to run every 121 seconds
        ; Store the current active window title
        currentWindowTitle := ""
        WinGetActiveTitle, currentWindowTitle

        ; Check if "Warframe" window is open
        IfWinExist, Warframe
        {
            WinActivate, Warframe ; Activate the "Warframe" window
            WinGetPos, wfmX, wfmY, wfmWidth, wfmHeight, Warframe ; Get window POS to ImageSearch
            
            ; Checks if the chat is opened
            ImageSearch, OutputRightX, OutputRightY, %wfmX%, %wfmY%, %wfmWidth%, %wfmHeight%, *50 *TransBlack %A_WorkingDir%\ChatMarkerRight.jpeg

            ; If its not, open it up
            if (ErrorLevel = 1) {
                SendInput, t
                Sleep, 100
            } else if (ErrorLevel = 2) { ; "Catches" the error of the file not been located by the script
                MsgBox, Chat marker detectors images not found in script directory
            } else { ; Get Chatbox Position
                ImageSearch, OutputRightX, OutputRightY, %wfmX%, %wfmY%, %wfmWidth%, %wfmHeight%, *50 *TransBlack %A_WorkingDir%\ChatMarkerRight.jpeg
                ImageSearch, OutputLeftX, OutputLeftY, %wfmX%, %wfmY%, %wfmWidth%, %wfmHeight%, *50 *TransBlack %A_WorkingDir%\ChatMarkerLeft.png
            }
            ClickX := OutputLeftX + 185

            BlockInput, MouseMove ; Block your mouse to not interfere with the script
            MouseGetPos, currentMouseX, currentMouseY

            FixClick := ClickX - 30
            Click, %FixClick%, %OutputLeftY%
            Sleep, 10
            Click, %ClickX%, %OutputLeftY% 
            Sleep, 200
            BlockInput, MouseMoveOff ; Enable your mouse back

            ; Send the advertising string
            Sleep, 100
            SendInput, %wts%
            Sleep, 100
            SendInput, {Enter}
            ; Return to the original window
	        Sleep, 100
            WinActivate, %originalWindowTitle%
        }
    }
return
