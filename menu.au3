#include <Constants.au3>          ; Include standard constants
#include <GDIPlus.au3>            ; Include GDI+ library for graphics
#include <ButtonConstants.au3>    ; Include button constants
#include <GUIConstantsEx.au3>     ; Include extended GUI constants
#include <Date.au3>               ; Include date functions
_GDIPlus_Startup()                ; Initialize GDI+ library

_Main()                           ; Call the main function

Func _Main()
    ; Declare local variables
    Local $idSeparator1, $idDate, $aUser, $sFQDN_Group, $sFQDN_User, $iResult
    Local $idCancelButton, $idUserName, $idCMDButton
    Local $iMsg, $hGraphic, $hImage, $idMainWindow, $iTimer
    #forceref $idSeparator1       ; Force reference to avoid unused variable warning

    ; Create the main GUI window
    $idMainWindow = GUICreate("User Menu", 500, 300)
    If @error Then
        MsgBox(16, "Error", "Failed to create GUI") ; Display error message if GUI creation fails
        Exit
    EndIf

    ; Create buttons with labels and positions
    $idUPSButton = GUICtrlCreateButton("UPS Worldship", 20, 100, 120, 40)
    $idExplorerButton = GUICtrlCreateButton("Explorer", 20, 150, 120, 40)

    ; Create labels for date and username
    $idDate = GUICtrlCreateLabel(@HOUR & ":" & @MIN & ":" & @SEC, 320, 260, 100, 20) ; Increase width to 100
    GUICtrlSetFont($idDate, 16, 400, 0, "Arial") ; Set font size to 16, weight to 400, and font to Arial
    GUICtrlSetColor($idDate, 0x0000FF) ; Set text color to blue

    $idUserName = GUICtrlCreateLabel(@UserName, 320, 220, 150, 20) ; Increase width to 150
    GUICtrlSetFont($idUserName, 12, 400, 0, "Arial") ; Set font size to 12, weight to 400, and font to Arial
    GUICtrlSetColor($idUserName, 0x000000) ; Set text color to black

    ; Create buttons with icons
    $idButtonDesktop = GUICtrlCreateButton("desktop", 0, 0, 40, 40, $BS_ICON)
    GUICtrlSetImage(-1, "shell32.dll", 35) ; Set icon for desktop button
    $idButtonclose = GUICtrlCreateButton("close", 460, 0, 40, 40, $BS_ICON)
    GUICtrlSetImage(-1, "shell32.dll", 28) ; Set icon for close button

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
                ExitLoop ; Exit loop if close event is triggered
            Case $iMsg = $idButtonDesktop
                MsgBox(0, "Desktop Button", "Desktop button was clicked")
            Case $iMsg = $idUPSButton
                Run("C:\Program Files (x86)\UPS\WSTD\WorldShipTD.exe") ; Open UPS Worldship application
            Case $iMsg = $idExplorerButton
                Run("explorer.exe") ; Open Windows Explorer
            Case $iMsg = $idButtonclose
                Shutdown(0) ; Log off user
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