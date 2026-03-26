#include "macros/scrcmd.inc"
#include "res/text/bank/hearthome_city_gym_entrance_room.h"
#include "res/field/events/events_hearthome_city_gym_entrance_room.h"


    ScriptEntry HearthomeGym_OnTransition
    ScriptEntry HearthomeGym_EnterRedirect
    ScriptEntry EternaGym_GymGuide
    ScriptEntry HearthomeGym_GymStatue
    ScriptEntry HearthomeGym_GymGuide_InitialVisit
    ScriptEntry GymExit_TryLeave_HearthomeGymEntrance
    ScriptEntryEnd

HearthomeGym_OnTransition:
    GoToIfSet FLAG_UNK_0x0FFB, HearthomeGym_OnTransition_Done
    SetVar VAR_UNK_0x4110, 4
    SetVar VAR_UNK_0x4113, 0
    SetVar VAR_HAS_ENTERED_HEARTHOME_GYM_BEFORE, TRUE
HearthomeGym_OnTransition_Done:
    End

HearthomeGym_EnterRedirect:
    SetVar VAR_UNK_0x4113, 1
    WaitFadeScreen
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 8, HearthomeGym_NoRedirect
    SetFlag FLAG_UNK_0x0FFB
    GetRandom VAR_UNK_0x4111, 8
HearthomeGym_TryGym:
    GoToIfEq VAR_UNK_0x4111, 0, HearthomeGym_TryIndex0
    GoToIfEq VAR_UNK_0x4111, 1, HearthomeGym_TryIndex1
    GoToIfEq VAR_UNK_0x4111, 2, HearthomeGym_TryIndex2
    GoToIfEq VAR_UNK_0x4111, 3, HearthomeGym_TryIndex3
    GoToIfEq VAR_UNK_0x4111, 4, HearthomeGym_TryIndex4
    GoToIfEq VAR_UNK_0x4111, 5, HearthomeGym_TryIndex5
    GoToIfEq VAR_UNK_0x4111, 6, HearthomeGym_TryIndex6
    GoTo HearthomeGym_TryIndex7
HearthomeGym_TryIndex0:
    GoToIfBadgeAcquired BADGE_ID_COAL, HearthomeGym_NextIndex
    GoTo HearthomeGym_WarpToIndex0
HearthomeGym_TryIndex1:
    GoToIfBadgeAcquired BADGE_ID_FOREST, HearthomeGym_NextIndex
    GoTo HearthomeGym_WarpToIndex1
HearthomeGym_TryIndex2:
    GoToIfBadgeAcquired BADGE_ID_COBBLE, HearthomeGym_NextIndex
    GoTo HearthomeGym_WarpToIndex2
HearthomeGym_TryIndex3:
    GoToIfBadgeAcquired BADGE_ID_FEN, HearthomeGym_NextIndex
    GoTo HearthomeGym_WarpToIndex3
HearthomeGym_TryIndex4:
    GoToIfBadgeAcquired BADGE_ID_RELIC, HearthomeGym_NextIndex
    GoTo HearthomeGym_NextIndex
HearthomeGym_TryIndex5:
    GoToIfBadgeAcquired BADGE_ID_MINE, HearthomeGym_NextIndex
    GoTo HearthomeGym_WarpToIndex5
HearthomeGym_TryIndex6:
    GoToIfBadgeAcquired BADGE_ID_ICICLE, HearthomeGym_NextIndex
    GoTo HearthomeGym_WarpToIndex6
HearthomeGym_TryIndex7:
    GoToIfBadgeAcquired BADGE_ID_BEACON, HearthomeGym_NextIndex
    GoTo HearthomeGym_WarpToIndex7
HearthomeGym_NextIndex:
    AddVar VAR_UNK_0x4111, 1
    GoToIfEq VAR_UNK_0x4111, 8, HearthomeGym_ResetIndex
    GoTo HearthomeGym_TryGym
HearthomeGym_ResetIndex:
    SetVar VAR_UNK_0x4111, 0
    GoTo HearthomeGym_TryGym
HearthomeGym_WarpToIndex0:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY_GYM, 0, 5, 22, DIR_NORTH
    End
HearthomeGym_WarpToIndex1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY_GYM, 0, 11, 25, DIR_NORTH
    End
HearthomeGym_WarpToIndex2:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY_GYM, 0, 12, 28, DIR_NORTH
    End
HearthomeGym_WarpToIndex3:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY_GYM, 0, 13, 40, DIR_NORTH
    End
HearthomeGym_WarpToIndex4:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY_GYM_LEADER_ROOM, 0, 4, 12, DIR_NORTH
    End
HearthomeGym_WarpToIndex5:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY_GYM, 0, 16, 25, DIR_NORTH
    End
HearthomeGym_WarpToIndex6:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY_GYM, 0, 11, 26, DIR_NORTH
    End
HearthomeGym_WarpToIndex7:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_3, 0, 11, 25, DIR_NORTH
    End
HearthomeGym_NoRedirect:
    End

EternaGym_GymGuide:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_RELIC, EternaGym_GymGuideAfterBadge
    Message HearthomeGym_Text_GymGuideHearLongSpielAgain
    ShowYesNoMenu VAR_RESULT
    GoToIfEq VAR_RESULT, MENU_YES, EternaGym_GymGuideExplanation
    GoToIfEq VAR_RESULT, MENU_NO, EternaGym_GymGuideEncouragement
    End

EternaGym_GymGuideExplanation:
    Message HearthomeGym_Text_GymGuideExplanation
    GoTo EternaGym_GymGuideEnd
    End

EternaGym_GymGuideEncouragement:
    Message HearthomeGym_Text_GymGuideGoGetEm
    GoTo EternaGym_GymGuideEnd
    End

EternaGym_GymGuideEnd:
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

EternaGym_GymGuideAfterBadge:
    BufferPlayerName 0
    Message HearthomeGym_Text_GymGuideAfterBadge
    GoTo EternaGym_GymGuideEnd
    End

HearthomeGym_GymStatue:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    GoToIfBadgeAcquired BADGE_ID_RELIC, HearthomeGym_GymStatueAfterBadge
    BufferRivalName 0
    BufferRivalName 1
    Message HearthomeGym_Text_GymStatueBeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

HearthomeGym_GymStatueAfterBadge:
    BufferRivalName 0
    BufferPlayerName 1
    BufferRivalName 2
    Message HearthomeGym_Text_GymStatueAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

HearthomeGym_GymGuide_InitialVisit:
    LockAll
    ApplyMovement HEARTHOME_CITY_GYM_ENTRANCE_ROOM_GYM_GUIDE, HearthomeGym_GymGuideMoveToPlayer
    WaitMovement
    Message HearthomeGym_Text_GymGuideInitialVisit
    CloseMessage
    ApplyMovement HEARTHOME_CITY_GYM_ENTRANCE_ROOM_GYM_GUIDE, HearthomeGym_GymGuideReturnToPosition
    WaitMovement
    SetVar VAR_HAS_ENTERED_HEARTHOME_GYM_BEFORE, TRUE
    ReleaseAll
    End


GymExit_TryLeave_HearthomeGymEntrance:
    GoToIfSet FLAG_UNK_0x0FFB, GymExit_Blocked_HearthomeGymEntrance
    GoTo RandomGym_ReturnToOriginCity_HearthomeGymEntrance
    End

GymExit_Blocked_HearthomeGymEntrance:
    LockAll
    Message 7
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

# GymExit_Text_MustDefeatLeader_HearthomeGymEntrance = index 7

RandomGym_ReturnToOriginCity_HearthomeGymEntrance:
    GoToIfEq VAR_UNK_0x4110, 0, ReturnTo_City0_HearthomeGymEntrance
    GoToIfEq VAR_UNK_0x4110, 1, ReturnTo_City1_HearthomeGymEntrance
    GoToIfEq VAR_UNK_0x4110, 2, ReturnTo_City2_HearthomeGymEntrance
    GoToIfEq VAR_UNK_0x4110, 3, ReturnTo_City3_HearthomeGymEntrance
    GoToIfEq VAR_UNK_0x4110, 4, ReturnTo_City4_HearthomeGymEntrance
    GoToIfEq VAR_UNK_0x4110, 5, ReturnTo_City5_HearthomeGymEntrance
    GoToIfEq VAR_UNK_0x4110, 6, ReturnTo_City6_HearthomeGymEntrance
    GoToIfEq VAR_UNK_0x4110, 7, ReturnTo_City7_HearthomeGymEntrance
    GoTo ReturnTo_City0_HearthomeGymEntrance

ReturnTo_City0_HearthomeGymEntrance:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY, 0, 282, 758, DIR_SOUTH
    End

ReturnTo_City1_HearthomeGymEntrance:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY, 0, 312, 564, DIR_SOUTH
    End

ReturnTo_City2_HearthomeGymEntrance:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY, 0, 684, 613, DIR_SOUTH
    End

ReturnTo_City3_HearthomeGymEntrance:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY, 0, 591, 830, DIR_SOUTH
    End

ReturnTo_City4_HearthomeGymEntrance:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY, 0, 499, 699, DIR_SOUTH
    End

ReturnTo_City5_HearthomeGymEntrance:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY, 0, 39, 733, DIR_SOUTH
    End

ReturnTo_City6_HearthomeGymEntrance:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY, 0, 367, 224, DIR_SOUTH
    End

ReturnTo_City7_HearthomeGymEntrance:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY, 0, 845, 749, DIR_SOUTH
    End


    .balign 4, 0
HearthomeGym_GymGuideMoveToPlayer:
    EmoteExclamationMark
    Delay8
    WalkNormalWest
    WalkNormalSouth
    EndMovement

    .balign 4, 0
HearthomeGym_GymGuideReturnToPosition:
    WalkNormalNorth
    WalkNormalEast
    WalkOnSpotNormalSouth
    EndMovement
