#include "macros/scrcmd.inc"
#include "res/text/bank/canalave_city_gym.h"


    ScriptEntry CanalaveGym_OnTransition
    ScriptEntry CanalaveGym_EnterRedirect
    ScriptEntry CanalaveGym_Init
    ScriptEntry CanalaveGym_Byron
    ScriptEntry CanalaveGym_GymGuide
    ScriptEntry CanalaveGym_GymStatue
    ScriptEntry GymExit_TryLeave_CanalaveGym
    ScriptEntryEnd

CanalaveGym_OnTransition:
    InitPersistedMapFeaturesForCanalaveGym
    GoToIfSet FLAG_UNK_0x0FFB, CanalaveGym_OnTransition_Done
    SetVar VAR_UNK_0x4110, 5
    SetVar VAR_UNK_0x4113, 0
CanalaveGym_OnTransition_Done:
    End

CanalaveGym_EnterRedirect:
    SetVar VAR_UNK_0x4113, 1
    WaitFadeScreen
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 8, CanalaveGym_NoRedirect
    SetFlag FLAG_UNK_0x0FFB
    GetRandom VAR_UNK_0x4111, 8
CanalaveGym_TryGym:
    GoToIfEq VAR_UNK_0x4111, 0, CanalaveGym_TryIndex0
    GoToIfEq VAR_UNK_0x4111, 1, CanalaveGym_TryIndex1
    GoToIfEq VAR_UNK_0x4111, 2, CanalaveGym_TryIndex2
    GoToIfEq VAR_UNK_0x4111, 3, CanalaveGym_TryIndex3
    GoToIfEq VAR_UNK_0x4111, 4, CanalaveGym_TryIndex4
    GoToIfEq VAR_UNK_0x4111, 5, CanalaveGym_TryIndex5
    GoToIfEq VAR_UNK_0x4111, 6, CanalaveGym_TryIndex6
    GoTo CanalaveGym_TryIndex7
CanalaveGym_TryIndex0:
    GoToIfBadgeAcquired BADGE_ID_COAL, CanalaveGym_NextIndex
    GoTo CanalaveGym_WarpToIndex0
CanalaveGym_TryIndex1:
    GoToIfBadgeAcquired BADGE_ID_FOREST, CanalaveGym_NextIndex
    GoTo CanalaveGym_WarpToIndex1
CanalaveGym_TryIndex2:
    GoToIfBadgeAcquired BADGE_ID_COBBLE, CanalaveGym_NextIndex
    GoTo CanalaveGym_WarpToIndex2
CanalaveGym_TryIndex3:
    GoToIfBadgeAcquired BADGE_ID_FEN, CanalaveGym_NextIndex
    GoTo CanalaveGym_WarpToIndex3
CanalaveGym_TryIndex4:
    GoToIfBadgeAcquired BADGE_ID_RELIC, CanalaveGym_NextIndex
    GoTo CanalaveGym_WarpToIndex4
CanalaveGym_TryIndex5:
    GoToIfBadgeAcquired BADGE_ID_MINE, CanalaveGym_NextIndex
    GoTo CanalaveGym_NextIndex
CanalaveGym_TryIndex6:
    GoToIfBadgeAcquired BADGE_ID_ICICLE, CanalaveGym_NextIndex
    GoTo CanalaveGym_WarpToIndex6
CanalaveGym_TryIndex7:
    GoToIfBadgeAcquired BADGE_ID_BEACON, CanalaveGym_NextIndex
    GoTo CanalaveGym_WarpToIndex7
CanalaveGym_NextIndex:
    AddVar VAR_UNK_0x4111, 1
    GoToIfEq VAR_UNK_0x4111, 8, CanalaveGym_ResetIndex
    GoTo CanalaveGym_TryGym
CanalaveGym_ResetIndex:
    SetVar VAR_UNK_0x4111, 0
    GoTo CanalaveGym_TryGym
CanalaveGym_WarpToIndex0:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY_GYM, 0, 5, 22, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
CanalaveGym_WarpToIndex1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY_GYM, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
CanalaveGym_WarpToIndex2:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY_GYM, 0, 12, 28, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
CanalaveGym_WarpToIndex3:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY_GYM, 0, 13, 40, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
CanalaveGym_WarpToIndex4:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY_GYM_LEADER_ROOM, 0, 4, 13, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
CanalaveGym_WarpToIndex5:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY_GYM, 0, 16, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
CanalaveGym_WarpToIndex6:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY_GYM, 0, 11, 26, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
CanalaveGym_WarpToIndex7:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_3, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
CanalaveGym_NoRedirect:
    End

CanalaveGym_Init:
    InitPersistedMapFeaturesForCanalaveGym
    End

CanalaveGym_Byron:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_MINE, CanalaveGym_ByronAfterBadge
    CreateJournalEvent LOCATION_EVENT_GYM_WAS_TOO_TOUGH, 35, 0, 0, 0
    Message CanalaveGym_Text_ByronIntro
    CloseMessage
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 7, Byron_BattleB7
    GoToIfEq VAR_RESULT, 6, Byron_BattleB6
    GoToIfEq VAR_RESULT, 5, Byron_BattleB5
    GoToIfEq VAR_RESULT, 4, Byron_BattleB4
    GoToIfEq VAR_RESULT, 3, Byron_BattleB3
    GoToIfEq VAR_RESULT, 2, Byron_BattleB2
    GoToIfEq VAR_RESULT, 1, Byron_BattleB1
Byron_BattleB0:
    StartTrainerBattle TRAINER_LEADER_BYRON_B0
    GoTo Byron_BattleDone
Byron_BattleB1:
    StartTrainerBattle TRAINER_LEADER_BYRON_B1
    GoTo Byron_BattleDone
Byron_BattleB2:
    StartTrainerBattle TRAINER_LEADER_BYRON_B2
    GoTo Byron_BattleDone
Byron_BattleB3:
    StartTrainerBattle TRAINER_LEADER_BYRON_B3
    GoTo Byron_BattleDone
Byron_BattleB4:
    StartTrainerBattle TRAINER_LEADER_BYRON_B4
    GoTo Byron_BattleDone
Byron_BattleB5:
    StartTrainerBattle TRAINER_LEADER_BYRON_B5
    GoTo Byron_BattleDone
Byron_BattleB6:
    StartTrainerBattle TRAINER_LEADER_BYRON_B6
    GoTo Byron_BattleDone
Byron_BattleB7:
    StartTrainerBattle TRAINER_LEADER_BYRON_B7
    GoTo Byron_BattleDone
Byron_BattleDone:
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, CanalaveGym_Lostbattle
    Message CanalaveGym_Text_BeatByron
    BufferPlayerName 0
    Message CanalaveGym_Text_ByronReceiveMineBadge
    PlaySound SEQ_BADGE
    WaitSound
    GiveBadge BADGE_ID_MINE
    IncrementTrainerScore2 TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_BLACK_BELT_DAVID
    SetTrainerFlag TRAINER_WORKER_JACKSON
    SetTrainerFlag TRAINER_WORKER_GARY
    SetTrainerFlag TRAINER_ACE_TRAINER_CESAR
    SetTrainerFlag TRAINER_ACE_TRAINER_BREANNA
    SetTrainerFlag TRAINER_BLACK_BELT_RICKY
    SetTrainerFlag TRAINER_WORKER_GERARDO
    CreateJournalEvent LOCATION_EVENT_BEAT_GYM_LEADER, 35, TRAINER_LEADER_BYRON, 0, 0
    ClearFlag FLAG_HIDE_CANALAVE_RIVAL
    ClearFlag FLAG_HIDE_CANALAVE_CITY_RIVAL
    ClearFlag FLAG_HIDE_CANALAVE_LIBRARY_RIVAL
    ClearFlag FLAG_HIDE_CANALAVE_LIBRARY_COUNTERPART
    ClearFlag FLAG_HIDE_CANALAVE_LIBRARY_ROWAN
    SetVar VAR_CANALAVE_STATE, 2
    SetFlag FLAG_HIDE_SANDGEM_TOWN_LAB_PROF_ROWAN
    Message CanalaveGym_Text_ByronExplainMineBadge
    GoTo CanalaveGym_ByronTryGiveTM91

CanalaveGym_ByronTryGiveTM91:
    SetVar VAR_0x8004, ITEM_TM91
    SetVar VAR_0x8005, 1
    GoToIfCannotFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT, CanalaveGym_ByronCannotGiveTM91
    Common_GiveItemQuantity
    SetFlag FLAG_OBTAINED_BYRON_TM91
    BufferItemName 0, VAR_0x8004
    BufferTMHMMoveName 1, VAR_0x8004
    Message CanalaveGym_Text_ByronExplainTM91
    WaitABXPadPress
    CloseMessage
    GoTo CanalaveGym_PostWin
    End

CanalaveGym_ByronCannotGiveTM91:
    Common_MessageBagIsFull
    CloseMessage
    GoTo CanalaveGym_PostWin
    End

CanalaveGym_PostWin:
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 5, CanalaveGym_Badge5
    GoToIfEq VAR_RESULT, 6, CanalaveGym_Badge6
    GoToIfEq VAR_RESULT, 8, CanalaveGym_Badge8
    GoTo CanalaveGym_PostWin_End
CanalaveGym_Badge5:
    GoToIfSet FLAG_UNK_0x0FFC, CanalaveGym_PostWin_End
    SetFlag FLAG_UNK_0x0FFC
    Message 10
    WaitABXPadPress
    CloseMessage
    AddItem ITEM_HM01, 1, VAR_RESULT
    AddItem ITEM_HM02, 1, VAR_RESULT
    AddItem ITEM_HM03, 1, VAR_RESULT
    AddItem ITEM_HM04, 1, VAR_RESULT
    AddItem ITEM_HM08, 1, VAR_RESULT
    GoTo CanalaveGym_PostWin_End
CanalaveGym_Badge6:
    GoToIfSet FLAG_UNK_0x0FFD, CanalaveGym_PostWin_End
    SetFlag FLAG_UNK_0x0FFD
    SetFlag FLAG_FIRST_ARRIVAL_SNOWPOINT_CITY
    SetFlag FLAG_FIRST_ARRIVAL_SUNYSHORE_CITY
    GoTo CanalaveGym_PostWin_End
CanalaveGym_Badge8:
    GoToIfSet FLAG_UNK_0x0FFE, CanalaveGym_PostWin_End
    SetFlag FLAG_UNK_0x0FFE
    SetFlag FLAG_FIRST_ARRIVAL_OUTSIDE_VICTORY_ROAD
    SetFlag FLAG_FIRST_ARRIVAL_POKEMON_LEAGUE
CanalaveGym_PostWin_End:
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_CanalaveGym
    End

CanalaveGym_ByronAfterBadge:
    GoToIfUnset FLAG_OBTAINED_BYRON_TM91, CanalaveGym_ByronTryGiveTM91
    BufferRivalName 1
    Message CanalaveGym_Text_ByronAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_CanalaveGym
    End

CanalaveGym_Lostbattle:
    BlackOutFromBattle
    ReleaseAll
    End

CanalaveGym_GymGuide:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_MINE, CanalaveGym_GymGuideAfterBadge
    Message CanalaveGym_Text_GymGuideBeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

CanalaveGym_GymGuideAfterBadge:
    BufferPlayerName 0
    Message CanalaveGym_Text_GymGuideAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

CanalaveGym_GymStatue:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    GoToIfBadgeAcquired BADGE_ID_MINE, CanalaveGym_GymStatueAfterBadge
    BufferRivalName 0
    BufferRivalName 1
    Message CanalaveGym_Text_GymStatueBeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

CanalaveGym_GymStatueAfterBadge:
    BufferRivalName 0
    BufferPlayerName 1
    BufferRivalName 2
    Message CanalaveGym_Text_GymStatueAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

GymExit_TryLeave_CanalaveGym:
    GoToIfSet FLAG_UNK_0x0FFB, GymExit_Blocked_CanalaveGym
    GoTo RandomGym_ReturnToOriginCity_CanalaveGym
    End

GymExit_Blocked_CanalaveGym:
    LockAll
    Message 10
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

# GymExit_Text_MustDefeatLeader_CanalaveGym = index 10

RandomGym_ReturnToOriginCity_CanalaveGym:
    GoToIfEq VAR_UNK_0x4110, 0, ReturnTo_City0_CanalaveGym
    GoToIfEq VAR_UNK_0x4110, 1, ReturnTo_City1_CanalaveGym
    GoToIfEq VAR_UNK_0x4110, 2, ReturnTo_City2_CanalaveGym
    GoToIfEq VAR_UNK_0x4110, 3, ReturnTo_City3_CanalaveGym
    GoToIfEq VAR_UNK_0x4110, 4, ReturnTo_City4_CanalaveGym
    GoToIfEq VAR_UNK_0x4110, 5, ReturnTo_City5_CanalaveGym
    GoToIfEq VAR_UNK_0x4110, 6, ReturnTo_City6_CanalaveGym
    GoToIfEq VAR_UNK_0x4110, 7, ReturnTo_City7_CanalaveGym
    GoTo ReturnTo_City0_CanalaveGym

ReturnTo_City0_CanalaveGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY, 0, 282, 758, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City1_CanalaveGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY, 0, 312, 564, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City2_CanalaveGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY, 0, 684, 613, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City3_CanalaveGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY, 0, 591, 830, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City4_CanalaveGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY, 0, 499, 699, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City5_CanalaveGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY, 0, 39, 733, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City6_CanalaveGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY, 0, 367, 224, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City7_CanalaveGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY, 0, 845, 749, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End


    .balign 4, 0
