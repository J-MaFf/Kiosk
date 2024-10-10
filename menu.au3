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
    Local $iMsg, $hGraphic, $hImage, $idMainWindow
    #forceref $idSeparator1       ; Force reference to avoid unused variable warning

    ; Create the main GUI window
    $idMainWindow = GUICreate("User Menu", 500, 300)
    If @error Then
        MsgBox(16, "Error", "Failed to create GUI") ; Display error message if GUI creation fails
        Exit
    EndIf

    ; Create buttons with labels and positions
    $idChromeButton = GUICtrlCreateButton("Google Chrome", 20, 100, 120, 40)
    $idQBButton = GUICtrlCreateButton("QuickBooks", 20, 150, 120, 40)
    $idPrintButton = GUICtrlCreateButton("Printers", 150, 100, 120, 40)
    $idCMDButton = GUICtrlCreateButton("Command", 150, 150, 120, 40)

    ; Create labels for date and username
    $idDate = GUICtrlCreateLabel(@HOUR & ":" & @MIN & ":" & @SEC, 320, 260)
    $idUserName = GUICtrlCreateLabel(@UserName, 320, 220)

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

    ; Main event loop
    While 1
        $iMsg = GUIGetMsg() ; Get GUI message
        Select
            Case $iMsg = $GUI_EVENT_CLOSE
                ExitLoop ; Exit loop if close event is triggered
            Case $iMsg = $idChromeButton
                MsgBox(64, "Button Clicked", "Google Chrome button clicked") ; Action for Chrome button
            Case $iMsg = $idQBButton
                MsgBox(64, "Button Clicked", "QuickBooks button clicked") ; Action for QuickBooks button
            Case $iMsg = $idPrintButton
                MsgBox(64, "Button Clicked", "Printers button clicked") ; Action for Printers button
            Case $iMsg = $idCMDButton
                MsgBox(64, "Button Clicked", "Command button clicked") ; Action for Command button
            Case $iMsg = $idButtonDesktop
                MsgBox(64, "Button Clicked", "Desktop button clicked") ; Action for Desktop button
            Case $iMsg = $idButtonclose
                ExitLoop ; Exit loop if close button is clicked
        EndSelect
    WEnd

    ; Delete the GUI window
    GUIDelete($idMainWindow)
EndFunc