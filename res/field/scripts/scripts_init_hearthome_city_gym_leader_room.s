#include "macros/scrcmd.inc"


    InitScriptEntry_OnLoad 6
    InitScriptEntry_OnTransition 7
    InitScriptEntry_OnFrameTable InitScriptFrameTable
    InitScriptEntryEnd

InitScriptFrameTable:
    InitScriptGoToIfEqual VAR_UNK_0x4113, 0, 8
    InitScriptFrameTableEnd

    InitScriptEnd
