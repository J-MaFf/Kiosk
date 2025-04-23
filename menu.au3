#include <Constants.au3>          ; Include standard constants
#include <GDIPlus.au3>            ; Include GDI+ library for graphics
#include <ButtonConstants.au3>    ; Include button constants
#include <GUIConstantsEx.au3>     ; Include extended GUI constants
#include <Date.au3>               ; Include date functions
#include <WindowsConstants.au3>   ; Include Windows constants
_GDIPlus_Startup()                ; Initialize GDI+ library

_Main()                           ; Call the main function

Func _Main()
    ; Declare local variables
    Local $idDate, $idUserName
    Local $iMsg, $idMainWindow, $iTimer

    ; Create the main GUI window
    $idMainWindow = GUICreate("User Menu", 480, 300, -1, -1, $WS_POPUP) ; Reduced size for better layout
    If @error Then
        MsgBox(16, "Error", "Failed to create GUI") ; Display error message if GUI creation fails
        Exit
    EndIf

    ; Create a hidden label to receive initial focus
    $idHiddenLabel = GUICtrlCreateLabel("", 0, 0, 1, 1)

    ; Create labels with modern fonts and colors (now above the buttons, aligned horizontally)
    $idDate = GUICtrlCreateLabel(@HOUR & ":" & @MIN & ":" & @SEC, 40, 20, 200, 40)
    GUICtrlSetFont($idDate, 18, 400, 0, "Segoe UI")
    GUICtrlSetColor($idDate, 0x0000FF)

    $idUserName = GUICtrlCreateLabel(@UserName, 260, 20, 180, 40)
    GUICtrlSetFont($idUserName, 18, 400, 0, "Segoe UI")
    GUICtrlSetColor($idUserName, 0x000000)

    ; Create buttons with modern styles and icons
    $idUPSButton = GUICtrlCreateButton("UPS Worldship", 20, 100, 200, 80)
    GUICtrlSetFont($idUPSButton, 16, 400, 0, "Segoe UI")
    GUICtrlSetColor($idUPSButton, 0xFFFFFF)
    GUICtrlSetBkColor($idUPSButton, 0xff0000)

    $idExplorerButton = GUICtrlCreateButton("Explorer", 20, 200, 200, 80)
    GUICtrlSetFont($idExplorerButton, 16, 400, 0, "Segoe UI")
    GUICtrlSetColor($idExplorerButton, 0xFFFFFF)
    GUICtrlSetBkColor($idExplorerButton, 0x0078D7)

    $idGmailButton = GUICtrlCreateButton("Gmail", 240, 100, 200, 80)
    GUICtrlSetFont($idGmailButton, 16, 400, 0, "Segoe UI")
    GUICtrlSetColor($idGmailButton, 0xFFFFFF)
    GUICtrlSetBkColor($idGmailButton, 0x34A853) ; Gmail green

    $idIKATButton = GUICtrlCreateButton("iKAT", 240, 200, 200, 80)
    GUICtrlSetFont($idIKATButton, 16, 400, 0, "Segoe UI")
    GUICtrlSetColor($idIKATButton, 0xFFFFFF)
    GUICtrlSetBkColor($idIKATButton, 0x008080) ; Teal color for iKAT
    GUICtrlSetImage($idIKATButton, "shell32.dll", 44) ; RDP icon (icon index 44 in shell32.dll)

    ; Create buttons with icons
    $idButtonDesktop = GUICtrlCreateButton("", 0, 0, 40, 40, $BS_ICON)
    GUICtrlSetImage(-1, "shell32.dll", 35) ; Set icon for desktop button
    $idButtonclose = GUICtrlCreateButton("", 420, 0, 40, 40, $BS_ICON) ; Moved left from 460 to 420
    GUICtrlSetImage(-1, "shell32.dll", 28) ; Set icon for close button

    ; Set focus to the hidden label to prevent auto-selection of buttons
    GUICtrlSetState($idHiddenLabel, $GUI_FOCUS)

    ; Set the GUI state to show the window
    GUISetState(@SW_SHOW)
    If @error Then
        MsgBox(16, "Error", "Failed to set GUI state") ; Display error message if setting GUI state fails
        Exit
    EndIf

    ; Initialize timer
    $iTimer = TimerInit()

    ; Main event loop
    While 1
        $iMsg = GUIGetMsg() ; Get GUI message
        Select
            Case $iMsg = $GUI_EVENT_CLOSE
                ; Ignore the close event to prevent the window from closing
                ContinueLoop
            Case $iMsg = $idButtonDesktop
                ;MsgBox(0, "Desktop", "Desktop button clicked") ; Display message when desktop button is clicked

                ; prompt the user with a text box. if the user enters "exit" then exit the program
                $sInput = InputBox("Desktop", "Enter command:", "", "", 200, 125)
                If $sInput = "exit" Then Exit
                If $sInput = "cmd" Then
                    ShellExecute("cmd.exe", "", "", "runas") ; Open Command Prompt as administrator
                EndIf
                If $sInput = "powershell" Then
                    ShellExecute("powershell.exe", "", "", "runas") ; Open PowerShell as administrator
                EndIf
                If $sInput = "explorer" Then
                    Run("explorer.exe") ; Open Windows Explorer
                EndIf
                If $sInput = "terminal" Then
                    ShellExecute("wt.exe", "", "", "runas") ; Open Windows Terminal as administrator
                Else
                    Run($sInput) ; Run the command entered by the user
                EndIf
                
            Case $iMsg = $idUPSButton
                Run("C:\Program Files (x86)\UPS\WSTD\WorldShipTD.exe") ; Open UPS Worldship application
            Case $iMsg = $idExplorerButton
                Run("explorer.exe /n, /e, C:\Users\ups") ; Open Windows Explorer
            Case $iMsg = $idGmailButton
                ; Launch Edge in app mode to gmail.com (windowed, with close button)
                Run('msedge.exe --app=https://mail.google.com')
            Case $iMsg = $idIKATButton
                ; Launch a specific RDP shortcut
                Run('mstsc.exe "C:\\Users\\jmaffiola\\Documents\\Scripts\\Kiosk\\iKAT.rdp"')
            Case $iMsg = $idButtonclose
                ; Show confirmation box
                $iResponse = MsgBox(4, "Confirmation", "Are you sure you want to log out?")
                If $iResponse = 6 Then ; If Yes is clicked (6 is the return value for Yes)
                    Shutdown(0) ; Log off the user
                EndIf
        EndSelect

        ; Update the clock label every second
        If TimerDiff($iTimer) > 1000 Then
            GUICtrlSetData($idDate, @HOUR & ":" & @MIN & ":" & @SEC)
            $iTimer = TimerInit() ; Reset the timer
        EndIf

        Sleep(10) ; Sleep for a short interval to allow frequent event checking
    WEnd

    ; Delete the GUI window
    GUIDelete($idMainWindow)
EndFunc