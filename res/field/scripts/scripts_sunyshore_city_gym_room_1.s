#include "macros/scrcmd.inc"
#include "res/text/bank/sunyshore_city_gym_room_1.h"


    ScriptEntry SunyshoreGym_OnTransition
    ScriptEntry SunyshoreGym_EnterRedirect
    ScriptEntry SunyshoreGymRoom1_Init
    ScriptEntry SunyshoreGymRoom1_Button
    ScriptEntry SunyshoreGymRoom1_GymGuide
    ScriptEntry SunyshoreGymRoom1_GymStatue
    ScriptEntry GymExit_TryLeave_SunyshorGymRoom1
    ScriptEntryEnd

SunyshoreGym_OnTransition:
    SetVar VAR_MAP_LOCAL_0, 0
    InitPersistedMapFeaturesForSunyshoreGym 0
    GoToIfSet FLAG_UNK_0x0FFB, SunyshoreGym_OnTransition_Done
    SetVar VAR_UNK_0x4110, 7
    SetVar VAR_UNK_0x4113, 0
SunyshoreGym_OnTransition_Done:
    End

SunyshoreGym_EnterRedirect:
    SetVar VAR_UNK_0x4113, 1
    WaitFadeScreen
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 8, SunyshoreGym_NoRedirect
    SetFlag FLAG_UNK_0x0FFB
    GetRandom VAR_UNK_0x4111, 8
SunyshoreGym_TryGym:
    GoToIfEq VAR_UNK_0x4111, 0, SunyshoreGym_TryIndex0
    GoToIfEq VAR_UNK_0x4111, 1, SunyshoreGym_TryIndex1
    GoToIfEq VAR_UNK_0x4111, 2, SunyshoreGym_TryIndex2
    GoToIfEq VAR_UNK_0x4111, 3, SunyshoreGym_TryIndex3
    GoToIfEq VAR_UNK_0x4111, 4, SunyshoreGym_TryIndex4
    GoToIfEq VAR_UNK_0x4111, 5, SunyshoreGym_TryIndex5
    GoToIfEq VAR_UNK_0x4111, 6, SunyshoreGym_TryIndex6
    GoTo SunyshoreGym_TryIndex7
SunyshoreGym_TryIndex0:
    GoToIfBadgeAcquired BADGE_ID_COAL, SunyshoreGym_NextIndex
    GoTo SunyshoreGym_WarpToIndex0
SunyshoreGym_TryIndex1:
    GoToIfBadgeAcquired BADGE_ID_FOREST, SunyshoreGym_NextIndex
    GoTo SunyshoreGym_WarpToIndex1
SunyshoreGym_TryIndex2:
    GoToIfBadgeAcquired BADGE_ID_COBBLE, SunyshoreGym_NextIndex
    GoTo SunyshoreGym_WarpToIndex2
SunyshoreGym_TryIndex3:
    GoToIfBadgeAcquired BADGE_ID_FEN, SunyshoreGym_NextIndex
    GoTo SunyshoreGym_WarpToIndex3
SunyshoreGym_TryIndex4:
    GoToIfBadgeAcquired BADGE_ID_RELIC, SunyshoreGym_NextIndex
    GoTo SunyshoreGym_WarpToIndex4
SunyshoreGym_TryIndex5:
    GoToIfBadgeAcquired BADGE_ID_MINE, SunyshoreGym_NextIndex
    GoTo SunyshoreGym_WarpToIndex5
SunyshoreGym_TryIndex6:
    GoToIfBadgeAcquired BADGE_ID_ICICLE, SunyshoreGym_NextIndex
    GoTo SunyshoreGym_WarpToIndex6
SunyshoreGym_TryIndex7:
    GoToIfBadgeAcquired BADGE_ID_BEACON, SunyshoreGym_NextIndex
    GoTo SunyshoreGym_NextIndex
SunyshoreGym_NextIndex:
    AddVar VAR_UNK_0x4111, 1
    GoToIfEq VAR_UNK_0x4111, 8, SunyshoreGym_ResetIndex
    GoTo SunyshoreGym_TryGym
SunyshoreGym_ResetIndex:
    SetVar VAR_UNK_0x4111, 0
    GoTo SunyshoreGym_TryGym
SunyshoreGym_WarpToIndex0:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY_GYM, 0, 5, 22, DIR_NORTH
    End
SunyshoreGym_WarpToIndex1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY_GYM, 0, 11, 25, DIR_NORTH
    End
SunyshoreGym_WarpToIndex2:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY_GYM, 0, 12, 28, DIR_NORTH
    End
SunyshoreGym_WarpToIndex3:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY_GYM, 0, 13, 40, DIR_NORTH
    End
SunyshoreGym_WarpToIndex4:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY_GYM_LEADER_ROOM, 0, 4, 13, DIR_NORTH
    End
SunyshoreGym_WarpToIndex5:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY_GYM, 0, 16, 25, DIR_NORTH
    End
SunyshoreGym_WarpToIndex6:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY_GYM, 0, 11, 26, DIR_NORTH
    End
SunyshoreGym_WarpToIndex7:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_3, 0, 11, 25, DIR_NORTH
    End
SunyshoreGym_NoRedirect:
    End

SunyshoreGymRoom1_Init:
    SetVar VAR_MAP_LOCAL_0, 0
    InitPersistedMapFeaturesForSunyshoreGym 0
    End

SunyshoreGymRoom1_Button:
    SunyshoreGymButton 0
    End

SunyshoreGymRoom1_GymGuide:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_BEACON, SunyshoreGymRoom1_GymGuideAfterbadge
    Message SunyshoreGymRoom1_Text_GymGuideBeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

SunyshoreGymRoom1_GymGuideAfterbadge:
    BufferPlayerName 0
    Message SunyshoreGymRoom1_Text_GymGuideAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

SunyshoreGymRoom1_GymStatue:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    GoToIfBadgeAcquired BADGE_ID_BEACON, SunyshoreGymRoom1_GymStatue_AfterBadge
    Message SunyshoreGymRoom1_Text_GymStatue_BeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

SunyshoreGymRoom1_GymStatue_AfterBadge:
    GoToIfGe VAR_RIVAL_BEAT_SUNYSHORE_GYM, TRUE, SunyshoreGymRoom1_GymStatue_AfterRivalBadge
    BufferPlayerName 0
    BufferRivalName 1
    Message SunyshoreGymRoom1_Text_GymStatue_AfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

SunyshoreGymRoom1_GymStatue_AfterRivalBadge:
    BufferPlayerName 0
    BufferRivalName 1
    Message SunyshoreGymRoom1_Text_GymStatue_AfterRivalBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End


GymExit_TryLeave_SunyshorGymRoom1:
    GoToIfSet FLAG_UNK_0x0FFB, GymExit_Blocked_SunyshorGymRoom1
    GoTo RandomGym_ReturnToOriginCity_SunyshorGymRoom1
    End

GymExit_Blocked_SunyshorGymRoom1:
    LockAll
    Message 5
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

# GymExit_Text_MustDefeatLeader_SunyshorGymRoom1 = index 5

RandomGym_ReturnToOriginCity_SunyshorGymRoom1:
    GoToIfEq VAR_UNK_0x4110, 0, ReturnTo_City0_SunyshorGymRoom1
    GoToIfEq VAR_UNK_0x4110, 1, ReturnTo_City1_SunyshorGymRoom1
    GoToIfEq VAR_UNK_0x4110, 2, ReturnTo_City2_SunyshorGymRoom1
    GoToIfEq VAR_UNK_0x4110, 3, ReturnTo_City3_SunyshorGymRoom1
    GoToIfEq VAR_UNK_0x4110, 4, ReturnTo_City4_SunyshorGymRoom1
    GoToIfEq VAR_UNK_0x4110, 5, ReturnTo_City5_SunyshorGymRoom1
    GoToIfEq VAR_UNK_0x4110, 6, ReturnTo_City6_SunyshorGymRoom1
    GoToIfEq VAR_UNK_0x4110, 7, ReturnTo_City7_SunyshorGymRoom1
    GoTo ReturnTo_City0_SunyshorGymRoom1

ReturnTo_City0_SunyshorGymRoom1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY, 0, 282, 758, DIR_SOUTH
    End

ReturnTo_City1_SunyshorGymRoom1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY, 0, 312, 564, DIR_SOUTH
    End

ReturnTo_City2_SunyshorGymRoom1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY, 0, 684, 613, DIR_SOUTH
    End

ReturnTo_City3_SunyshorGymRoom1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY, 0, 591, 830, DIR_SOUTH
    End

ReturnTo_City4_SunyshorGymRoom1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY, 0, 499, 699, DIR_SOUTH
    End

ReturnTo_City5_SunyshorGymRoom1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY, 0, 39, 733, DIR_SOUTH
    End

ReturnTo_City6_SunyshorGymRoom1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY, 0, 367, 224, DIR_SOUTH
    End

ReturnTo_City7_SunyshorGymRoom1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY, 0, 845, 749, DIR_SOUTH
    End


    .balign 4, 0
