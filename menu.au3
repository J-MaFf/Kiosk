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
    Local $idSeparator1, $idDate, $aUser, $sFQDN_Group, $sFQDN_User, $iResult
    Local $idCancelButton, $idUserName, $idCMDButton
    Local $iMsg, $hGraphic, $hImage, $idMainWindow, $iTimer
    #forceref $idSeparator1       ; Force reference to avoid unused variable warning

    ; Create the main GUI window
    $idMainWindow = GUICreate("User Menu", 500, 300, -1, -1, $WS_POPUP)
    If @error Then
        MsgBox(16, "Error", "Failed to create GUI") ; Display error message if GUI creation fails
        Exit
    EndIf

    ; Create a hidden label to receive initial focus
    $idHiddenLabel = GUICtrlCreateLabel("", 0, 0, 1, 1)

    ; Create buttons with modern styles and icons
    $idUPSButton = GUICtrlCreateButton("UPS Worldship", 20, 100, 160, 60) ; Increased width to 160 and height to 60
    GUICtrlSetFont($idUPSButton, 14, 400, 0, "Segoe UI")
    GUICtrlSetColor($idUPSButton, 0xFFFFFF)
    GUICtrlSetBkColor($idUPSButton, 0xff0000)

    $idExplorerButton = GUICtrlCreateButton("Explorer", 20, 180, 160, 60) ; Adjusted Y position to 180
    GUICtrlSetFont($idExplorerButton, 14, 400, 0, "Segoe UI")
    GUICtrlSetColor($idExplorerButton, 0xFFFFFF)
    GUICtrlSetBkColor($idExplorerButton, 0x0078D7)

    ; Create labels with modern fonts and colors
    $idDate = GUICtrlCreateLabel(@HOUR & ":" & @MIN & ":" & @SEC, 320, 175, 100, 50)
    GUICtrlSetFont($idDate, 16, 400, 0, "Segoe UI")
    GUICtrlSetColor($idDate, 0x0000FF)

    $idUserName = GUICtrlCreateLabel(@UserName, 320, 220, 150, 20)
    GUICtrlSetFont($idUserName, 12, 400, 0, "Segoe UI")
    GUICtrlSetColor($idUserName, 0x000000)

    ; Create buttons with icons
    $idButtonDesktop = GUICtrlCreateButton("", 0, 0, 40, 40, $BS_ICON)
    GUICtrlSetImage(-1, "shell32.dll", 35) ; Set icon for desktop button
    $idButtonclose = GUICtrlCreateButton("", 460, 0, 40, 40, $BS_ICON)
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

            Case $iMsg = $idUPSButton
                Run("C:\Program Files (x86)\UPS\WSTD\WorldShipTD.exe") ; Open UPS Worldship application
            Case $iMsg = $idExplorerButton
                Run("explorer.exe /n, /e, C:\Users\ups") ; Open Windows Explorer
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