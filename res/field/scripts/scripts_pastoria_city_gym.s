#include "macros/scrcmd.inc"
#include "res/text/bank/pastoria_city_gym.h"


    ScriptEntry PastoriaGym_OnTransition
    ScriptEntry PastoriaGym_EnterRedirect
    ScriptEntry PastoriaGym_Init
    ScriptEntry PastoriaGym_BlueButton
    ScriptEntry PastoriaGym_GreenButton
    ScriptEntry PastoriaGym_YellowButton
    ScriptEntry PastoriaGym_Wake
    ScriptEntry PastoriaGym_GymGuide
    ScriptEntry PastoriaGym_GymStatue
    ScriptEntry GymExit_TryLeave_PastoriaGym
    ScriptEntryEnd

PastoriaGym_OnTransition:
    SetVar VAR_MAP_LOCAL_1, 0
    SetVar VAR_MAP_LOCAL_2, 1
    SetVar VAR_MAP_LOCAL_3, 0
    InitPersistedMapFeaturesForPastoriaGym
    GoToIfSet FLAG_UNK_0x0FFB, PastoriaGym_OnTransition_Done
    SetVar VAR_UNK_0x4110, 3
    SetVar VAR_UNK_0x4113, 0
PastoriaGym_OnTransition_Done:
    End

PastoriaGym_EnterRedirect:
    SetVar VAR_UNK_0x4113, 1
    WaitFadeScreen
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 8, PastoriaGym_NoRedirect
    SetFlag FLAG_UNK_0x0FFB
    GetRandom VAR_UNK_0x4111, 8
PastoriaGym_TryGym:
    GoToIfEq VAR_UNK_0x4111, 0, PastoriaGym_TryIndex0
    GoToIfEq VAR_UNK_0x4111, 1, PastoriaGym_TryIndex1
    GoToIfEq VAR_UNK_0x4111, 2, PastoriaGym_TryIndex2
    GoToIfEq VAR_UNK_0x4111, 3, PastoriaGym_TryIndex3
    GoToIfEq VAR_UNK_0x4111, 4, PastoriaGym_TryIndex4
    GoToIfEq VAR_UNK_0x4111, 5, PastoriaGym_TryIndex5
    GoToIfEq VAR_UNK_0x4111, 6, PastoriaGym_TryIndex6
    GoTo PastoriaGym_TryIndex7
PastoriaGym_TryIndex0:
    GoToIfBadgeAcquired BADGE_ID_COAL, PastoriaGym_NextIndex
    GoTo PastoriaGym_WarpToIndex0
PastoriaGym_TryIndex1:
    GoToIfBadgeAcquired BADGE_ID_FOREST, PastoriaGym_NextIndex
    GoTo PastoriaGym_WarpToIndex1
PastoriaGym_TryIndex2:
    GoToIfBadgeAcquired BADGE_ID_COBBLE, PastoriaGym_NextIndex
    GoTo PastoriaGym_WarpToIndex2
PastoriaGym_TryIndex3:
    GoToIfBadgeAcquired BADGE_ID_FEN, PastoriaGym_NextIndex
    GoTo PastoriaGym_NextIndex
PastoriaGym_TryIndex4:
    GoToIfBadgeAcquired BADGE_ID_RELIC, PastoriaGym_NextIndex
    GoTo PastoriaGym_WarpToIndex4
PastoriaGym_TryIndex5:
    GoToIfBadgeAcquired BADGE_ID_MINE, PastoriaGym_NextIndex
    GoTo PastoriaGym_WarpToIndex5
PastoriaGym_TryIndex6:
    GoToIfBadgeAcquired BADGE_ID_ICICLE, PastoriaGym_NextIndex
    GoTo PastoriaGym_WarpToIndex6
PastoriaGym_TryIndex7:
    GoToIfBadgeAcquired BADGE_ID_BEACON, PastoriaGym_NextIndex
    GoTo PastoriaGym_WarpToIndex7
PastoriaGym_NextIndex:
    AddVar VAR_UNK_0x4111, 1
    GoToIfEq VAR_UNK_0x4111, 8, PastoriaGym_ResetIndex
    GoTo PastoriaGym_TryGym
PastoriaGym_ResetIndex:
    SetVar VAR_UNK_0x4111, 0
    GoTo PastoriaGym_TryGym
PastoriaGym_WarpToIndex0:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY_GYM, 0, 5, 22, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
PastoriaGym_WarpToIndex1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY_GYM, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
PastoriaGym_WarpToIndex2:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY_GYM, 0, 12, 28, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
PastoriaGym_WarpToIndex3:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY_GYM, 0, 13, 40, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
PastoriaGym_WarpToIndex4:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY_GYM_LEADER_ROOM, 0, 4, 13, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
PastoriaGym_WarpToIndex5:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY_GYM, 0, 16, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
PastoriaGym_WarpToIndex6:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY_GYM, 0, 11, 26, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
PastoriaGym_WarpToIndex7:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_3, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
PastoriaGym_NoRedirect:
    End

PastoriaGym_Init:
    SetVar VAR_MAP_LOCAL_1, 0
    SetVar VAR_MAP_LOCAL_2, 1
    SetVar VAR_MAP_LOCAL_3, 0
    InitPersistedMapFeaturesForPastoriaGym
    End

PastoriaGym_BlueButton:
    PressPastoriaGymButton
    SetVar VAR_MAP_LOCAL_1, 1
    SetVar VAR_MAP_LOCAL_2, 0
    SetVar VAR_MAP_LOCAL_3, 0
    End

PastoriaGym_GreenButton:
    PressPastoriaGymButton
    SetVar VAR_MAP_LOCAL_1, 0
    SetVar VAR_MAP_LOCAL_2, 1
    SetVar VAR_MAP_LOCAL_3, 0
    End

PastoriaGym_YellowButton:
    PressPastoriaGymButton
    SetVar VAR_MAP_LOCAL_1, 0
    SetVar VAR_MAP_LOCAL_2, 0
    SetVar VAR_MAP_LOCAL_3, 1
    End

PastoriaGym_Wake:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_FEN, PastoriaGym_WakeAlreadyHaveFenBadge
    CreateJournalEvent LOCATION_EVENT_GYM_WAS_TOO_TOUGH, 122, 0, 0, 0
    Message PastoriaGym_Text_WakeIntro
    CloseMessage
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 7, Wake_BattleB7
    GoToIfEq VAR_RESULT, 6, Wake_BattleB6
    GoToIfEq VAR_RESULT, 5, Wake_BattleB5
    GoToIfEq VAR_RESULT, 4, Wake_BattleB4
    GoToIfEq VAR_RESULT, 3, Wake_BattleB3
    GoToIfEq VAR_RESULT, 2, Wake_BattleB2
    GoToIfEq VAR_RESULT, 1, Wake_BattleB1
Wake_BattleB0:
    StartTrainerBattle TRAINER_LEADER_WAKE_B0
    GoTo Wake_BattleDone
Wake_BattleB1:
    StartTrainerBattle TRAINER_LEADER_WAKE_B1
    GoTo Wake_BattleDone
Wake_BattleB2:
    StartTrainerBattle TRAINER_LEADER_WAKE_B2
    GoTo Wake_BattleDone
Wake_BattleB3:
    StartTrainerBattle TRAINER_LEADER_WAKE_B3
    GoTo Wake_BattleDone
Wake_BattleB4:
    StartTrainerBattle TRAINER_LEADER_WAKE_B4
    GoTo Wake_BattleDone
Wake_BattleB5:
    StartTrainerBattle TRAINER_LEADER_WAKE_B5
    GoTo Wake_BattleDone
Wake_BattleB6:
    StartTrainerBattle TRAINER_LEADER_WAKE_B6
    GoTo Wake_BattleDone
Wake_BattleB7:
    StartTrainerBattle TRAINER_LEADER_WAKE_B7
    GoTo Wake_BattleDone
Wake_BattleDone:
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, PastoriaGym_LostBattle
    Message PastoriaGym_Text_BeatWake
    BufferPlayerName 0
    Message PastoriaGym_Text_WakeReveiveFenBadge
    PlaySound SEQ_BADGE
    WaitSound
    GiveBadge BADGE_ID_FEN
    IncrementTrainerScore2 TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_FISHERMAN_ERICK
    SetTrainerFlag TRAINER_SAILOR_DAMIAN
    SetTrainerFlag TRAINER_FISHERMAN_WALTER
    SetTrainerFlag TRAINER_SAILOR_SAMSON
    SetTrainerFlag TRAINER_TUBER_JACKY
    SetTrainerFlag TRAINER_TUBER_CAITLYN
    SetVar VAR_PASTORIA_STATE, 3
    SetFlag FLAG_UNK_0x020C
    SetFlag FLAG_UNK_0x0156
    CreateJournalEvent LOCATION_EVENT_BEAT_GYM_LEADER, 122, TRAINER_LEADER_WAKE, 0, 0
    Message PastoriaGym_Text_WakeExplainFenBadge
    GoTo PastoriaGym_WakeTryGiveTm55
    End

PastoriaGym_WakeTryGiveTm55:
    SetVar VAR_0x8004, ITEM_TM55
    SetVar VAR_0x8005, 1
    GoToIfCannotFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT, PastoriaGym_WakeCannotGiveTm55
    Common_GiveItemQuantity
    SetFlag FLAG_OBTAINED_WAKE_TM55
    BufferItemName 0, VAR_0x8004
    BufferTMHMMoveName 1, VAR_0x8004
    Message PastoriaGym_Text_WakeExplainTM55
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_PastoriaGym
    End

PastoriaGym_WakeCannotGiveTm55:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_PastoriaGym
    End

PastoriaGym_WakeAlreadyHaveFenBadge:
    GoToIfUnset FLAG_OBTAINED_WAKE_TM55, PastoriaGym_WakeTryGiveTm55
    Message PastoriaGym_Text_WakeAfterbadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_PastoriaGym
    End

PastoriaGym_LostBattle:
    BlackOutFromBattle
    ReleaseAll
    End

PastoriaGym_GymGuide:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_FEN, PastoriaGym_GymGuideAfterBadge
    Message PastoriaGym_Text_GymGuideBeforebadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

PastoriaGym_GymGuideAfterBadge:
    BufferPlayerName 0
    Message PastoriaGym_Text_GymGuideAfterbadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

PastoriaGym_GymStatue:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    GoToIfBadgeAcquired BADGE_ID_FEN, PastoriaGym_GymStatueAfterBadge
    BufferRivalName 0
    BufferRivalName 1
    Message PastoriaGym_Text_GymStatueBeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

PastoriaGym_GymStatueAfterBadge:
    BufferRivalName 0
    BufferPlayerName 1
    BufferRivalName 2
    Message PastoriaGym_Text_GymStatueAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End


GymExit_TryLeave_PastoriaGym:
    GoToIfSet FLAG_UNK_0x0FFB, GymExit_Blocked_PastoriaGym
    GoTo RandomGym_ReturnToOriginCity_PastoriaGym
    End

GymExit_Blocked_PastoriaGym:
    LockAll
    Message 10
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

# GymExit_Text_MustDefeatLeader_PastoriaGym = index 10

RandomGym_ReturnToOriginCity_PastoriaGym:
    GoToIfEq VAR_UNK_0x4110, 0, ReturnTo_City0_PastoriaGym
    GoToIfEq VAR_UNK_0x4110, 1, ReturnTo_City1_PastoriaGym
    GoToIfEq VAR_UNK_0x4110, 2, ReturnTo_City2_PastoriaGym
    GoToIfEq VAR_UNK_0x4110, 3, ReturnTo_City3_PastoriaGym
    GoToIfEq VAR_UNK_0x4110, 4, ReturnTo_City4_PastoriaGym
    GoToIfEq VAR_UNK_0x4110, 5, ReturnTo_City5_PastoriaGym
    GoToIfEq VAR_UNK_0x4110, 6, ReturnTo_City6_PastoriaGym
    GoToIfEq VAR_UNK_0x4110, 7, ReturnTo_City7_PastoriaGym
    GoTo ReturnTo_City0_PastoriaGym

ReturnTo_City0_PastoriaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY, 0, 282, 758, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City1_PastoriaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY, 0, 312, 564, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City2_PastoriaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY, 0, 684, 613, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City3_PastoriaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY, 0, 589, 835, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City4_PastoriaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY, 0, 499, 699, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City5_PastoriaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY, 0, 39, 733, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City6_PastoriaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY, 0, 367, 224, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City7_PastoriaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY, 0, 845, 749, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End


    .balign 4, 0
