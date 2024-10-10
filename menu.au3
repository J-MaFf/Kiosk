#include <Constants.au3>
#include <GDIPlus.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <Date.au3>
_GDIPlus_Startup()

MsgBox(64, "Debug", "Script started") ; Debugging message

_Main()

Func _Main()
    MsgBox(64, "Debug", "Entered _Main function") ; Debugging message

    Local $idSeparator1, $idDate, $aUser, $sFQDN_Group, $sFQDN_User, $iResult
    Local $idCancelButton, $idUserName, $idCMDButton
    Local $iMsg, $hGraphic, $hImage, $idMainWindow
    #forceref $idSeparator1

    $idMainWindow = GUICreate("User Menu", 500, 300)
    If @error Then
        MsgBox(16, "Error", "Failed to create GUI")
        Exit
    EndIf

    MsgBox(64, "Debug", "GUI created") ; Debugging message

    $idChromeButton = GUICtrlCreateButton("Google Chrome", 20, 100, 120, 40)
    $idQBButton = GUICtrlCreateButton("QuickBooks", 20, 150, 120, 40)
    $idPrintButton = GUICtrlCreateButton("Printers", 150, 100, 120, 40)
    $idCMDButton = GUICtrlCreateButton("Command", 150, 150, 120, 40)

    $idDate = GUICtrlCreateLabel(@HOUR & ":" & @MIN & ":" & @SEC, 320, 260)
    $idUserName = GUICtrlCreateLabel(@UserName, 320, 220)

    $idButtonDesktop = GUICtrlCreateButton("desktop", 0, 0, 40, 40, $BS_ICON)
    GUICtrlSetImage(-1, "shell32.dll", 35)
    $idButtonclose = GUICtrlCreateButton("close", 460, 0, 40, 40, $BS_ICON)
    GUICtrlSetImage(-1, "shell32.dll", 28)

    GUISetState(@SW_SHOW)
    If @error Then
        MsgBox(16, "Error", "Failed to set GUI state")
        Exit
    EndIf

    MsgBox(64, "Debug", "GUI state set to show") ; Debugging message

    ; Message loop
    While 1
        $iMsg = GUIGetMsg()
        Select
            Case $iMsg = $GUI_EVENT_CLOSE
                ExitLoop
        EndSelect
    WEnd

    GUIDelete($idMainWindow)
EndFunc