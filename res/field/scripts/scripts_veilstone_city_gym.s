#include "macros/scrcmd.inc"
#include "res/text/bank/veilstone_city_gym.h"


    ScriptEntry VeilstoneGym_OnTransition
    ScriptEntry VeilstoneGym_EnterRedirect
    ScriptEntry VeilstoneGym_Init
    ScriptEntry VeilstoneGym_Maylene
    ScriptEntry VeilstoneGym_GymGuide
    ScriptEntry VeilstoneGym_GymStatue
    ScriptEntry VeilstoneGym_LeftPoster
    ScriptEntry VeilstoneGym_RightPoster
    ScriptEntry VeilstoneGym_MiddlePoster
    ScriptEntry GymExit_TryLeave_VeilstoneGym
    ScriptEntryEnd

VeilstoneGym_OnTransition:
    InitPersistedMapFeaturesForVeilstoneGym
    GoToIfSet FLAG_UNK_0x0FFB, VeilstoneGym_OnTransition_Done
    SetVar VAR_UNK_0x4110, 2
    SetVar VAR_UNK_0x4113, 0
VeilstoneGym_OnTransition_Done:
    End

VeilstoneGym_EnterRedirect:
    SetVar VAR_UNK_0x4113, 1
    WaitFadeScreen
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 8, VeilstoneGym_NoRedirect
    SetFlag FLAG_UNK_0x0FFB
    GetRandom VAR_UNK_0x4111, 8
VeilstoneGym_TryGym:
    GoToIfEq VAR_UNK_0x4111, 0, VeilstoneGym_TryIndex0
    GoToIfEq VAR_UNK_0x4111, 1, VeilstoneGym_TryIndex1
    GoToIfEq VAR_UNK_0x4111, 2, VeilstoneGym_TryIndex2
    GoToIfEq VAR_UNK_0x4111, 3, VeilstoneGym_TryIndex3
    GoToIfEq VAR_UNK_0x4111, 4, VeilstoneGym_TryIndex4
    GoToIfEq VAR_UNK_0x4111, 5, VeilstoneGym_TryIndex5
    GoToIfEq VAR_UNK_0x4111, 6, VeilstoneGym_TryIndex6
    GoTo VeilstoneGym_TryIndex7
VeilstoneGym_TryIndex0:
    GoToIfBadgeAcquired BADGE_ID_COAL, VeilstoneGym_NextIndex
    GoTo VeilstoneGym_WarpToIndex0
VeilstoneGym_TryIndex1:
    GoToIfBadgeAcquired BADGE_ID_FOREST, VeilstoneGym_NextIndex
    GoTo VeilstoneGym_WarpToIndex1
VeilstoneGym_TryIndex2:
    GoToIfBadgeAcquired BADGE_ID_COBBLE, VeilstoneGym_NextIndex
    GoTo VeilstoneGym_NextIndex
VeilstoneGym_TryIndex3:
    GoToIfBadgeAcquired BADGE_ID_FEN, VeilstoneGym_NextIndex
    GoTo VeilstoneGym_WarpToIndex3
VeilstoneGym_TryIndex4:
    GoToIfBadgeAcquired BADGE_ID_RELIC, VeilstoneGym_NextIndex
    GoTo VeilstoneGym_WarpToIndex4
VeilstoneGym_TryIndex5:
    GoToIfBadgeAcquired BADGE_ID_MINE, VeilstoneGym_NextIndex
    GoTo VeilstoneGym_WarpToIndex5
VeilstoneGym_TryIndex6:
    GoToIfBadgeAcquired BADGE_ID_ICICLE, VeilstoneGym_NextIndex
    GoTo VeilstoneGym_WarpToIndex6
VeilstoneGym_TryIndex7:
    GoToIfBadgeAcquired BADGE_ID_BEACON, VeilstoneGym_NextIndex
    GoTo VeilstoneGym_WarpToIndex7
VeilstoneGym_NextIndex:
    AddVar VAR_UNK_0x4111, 1
    GoToIfEq VAR_UNK_0x4111, 8, VeilstoneGym_ResetIndex
    GoTo VeilstoneGym_TryGym
VeilstoneGym_ResetIndex:
    SetVar VAR_UNK_0x4111, 0
    GoTo VeilstoneGym_TryGym
VeilstoneGym_WarpToIndex0:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY_GYM, 0, 5, 22, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
VeilstoneGym_WarpToIndex1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY_GYM, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
VeilstoneGym_WarpToIndex2:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY_GYM, 0, 12, 28, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
VeilstoneGym_WarpToIndex3:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY_GYM, 0, 13, 40, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
VeilstoneGym_WarpToIndex4:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY_GYM_LEADER_ROOM, 0, 4, 13, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
VeilstoneGym_WarpToIndex5:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY_GYM, 0, 16, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
VeilstoneGym_WarpToIndex6:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY_GYM, 0, 11, 26, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
VeilstoneGym_WarpToIndex7:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_3, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
VeilstoneGym_NoRedirect:
    End

VeilstoneGym_Init:
    InitPersistedMapFeaturesForVeilstoneGym
    End

VeilstoneGym_Maylene:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_COBBLE, VeilstoneGym_MayleneAfterBadge
    CreateJournalEvent LOCATION_EVENT_GYM_WAS_TOO_TOUGH, 133, 0, 0, 0
    Message VeilstoneGym_Text_MayleneIntro
    CloseMessage
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 7, Maylene_BattleB7
    GoToIfEq VAR_RESULT, 6, Maylene_BattleB6
    GoToIfEq VAR_RESULT, 5, Maylene_BattleB5
    GoToIfEq VAR_RESULT, 4, Maylene_BattleB4
    GoToIfEq VAR_RESULT, 3, Maylene_BattleB3
    GoToIfEq VAR_RESULT, 2, Maylene_BattleB2
    GoToIfEq VAR_RESULT, 1, Maylene_BattleB1
Maylene_BattleB0:
    StartTrainerBattle TRAINER_LEADER_MAYLENE_B0
    GoTo Maylene_BattleDone
Maylene_BattleB1:
    StartTrainerBattle TRAINER_LEADER_MAYLENE_B1
    GoTo Maylene_BattleDone
Maylene_BattleB2:
    StartTrainerBattle TRAINER_LEADER_MAYLENE_B2
    GoTo Maylene_BattleDone
Maylene_BattleB3:
    StartTrainerBattle TRAINER_LEADER_MAYLENE_B3
    GoTo Maylene_BattleDone
Maylene_BattleB4:
    StartTrainerBattle TRAINER_LEADER_MAYLENE_B4
    GoTo Maylene_BattleDone
Maylene_BattleB5:
    StartTrainerBattle TRAINER_LEADER_MAYLENE_B5
    GoTo Maylene_BattleDone
Maylene_BattleB6:
    StartTrainerBattle TRAINER_LEADER_MAYLENE_B6
    GoTo Maylene_BattleDone
Maylene_BattleB7:
    StartTrainerBattle TRAINER_LEADER_MAYLENE_B7
    GoTo Maylene_BattleDone
Maylene_BattleDone:
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, VeilstoneGym_LostBattle
    Message VeilstoneGym_Text_BeatMaylene
    BufferPlayerName 0
    Message VeilstoneGym_Text_MayleneReceiveBadge
    PlaySound SEQ_BADGE
    WaitSound
    GiveBadge BADGE_ID_COBBLE
    IncrementTrainerScore2 TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_BLACK_BELT_COLBY
    SetTrainerFlag TRAINER_BLACK_BELT_DARREN
    SetTrainerFlag TRAINER_BLACK_BELT_RAFAEL
    SetTrainerFlag TRAINER_BLACK_BELT_JEFFERY
    CreateJournalEvent LOCATION_EVENT_BEAT_GYM_LEADER, 133, TRAINER_LEADER_MAYLENE, 0, 0
    SetFlag FLAG_HIDE_LOOKER_IN_GAME_CORNER
    ClearFlag FLAG_HIDE_VEILSTONE_COUNTERPART
    SetVar VAR_VEILSTONE_WAREHOUSE_GUARDS_FIGHTABLE, TRUE
    SetVar VAR_VEILSTONE_STATE, 1
    Message VeilstoneGym_Text_MayleneExplainBadge
    GoTo VeilstoneGym_MayleneTryGiveTM60
    End

VeilstoneGym_MayleneTryGiveTM60:
    SetVar VAR_0x8004, ITEM_TM60
    SetVar VAR_0x8005, 1
    GoToIfCannotFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT, VeilstoneGym_MayleneCannotGiveTM60
    Common_GiveItemQuantity
    SetFlag FLAG_OBTAINED_MAYLENE_TM60
    BufferItemName 0, VAR_0x8004
    BufferTMHMMoveName 1, VAR_0x8004
    Message VeilstoneGym_Text_MayleneExplainTM60
    WaitABXPadPress
    CloseMessage
    GoTo VeilstoneGym_PostWin
    End

VeilstoneGym_MayleneCannotGiveTM60:
    Common_MessageBagIsFull
    CloseMessage
    GoTo VeilstoneGym_PostWin
    End

VeilstoneGym_PostWin:
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 5, VeilstoneGym_Badge5
    GoToIfEq VAR_RESULT, 6, VeilstoneGym_Badge6
    GoToIfEq VAR_RESULT, 8, VeilstoneGym_Badge8
    GoTo VeilstoneGym_PostWin_End
VeilstoneGym_Badge5:
    GoToIfSet FLAG_UNK_0x0FFC, VeilstoneGym_PostWin_End
    SetFlag FLAG_UNK_0x0FFC
    Message 14
    WaitABXPadPress
    CloseMessage
    AddItem ITEM_HM01, 1, VAR_RESULT
    AddItem ITEM_HM02, 1, VAR_RESULT
    AddItem ITEM_HM03, 1, VAR_RESULT
    AddItem ITEM_HM04, 1, VAR_RESULT
    AddItem ITEM_HM08, 1, VAR_RESULT
    GoTo VeilstoneGym_PostWin_End
VeilstoneGym_Badge6:
    GoToIfSet FLAG_UNK_0x0FFD, VeilstoneGym_PostWin_End
    SetFlag FLAG_UNK_0x0FFD
    SetFlag FLAG_FIRST_ARRIVAL_SNOWPOINT_CITY
    SetFlag FLAG_FIRST_ARRIVAL_SUNYSHORE_CITY
    GoTo VeilstoneGym_PostWin_End
VeilstoneGym_Badge8:
    GoToIfSet FLAG_UNK_0x0FFE, VeilstoneGym_PostWin_End
    SetFlag FLAG_UNK_0x0FFE
    SetFlag FLAG_FIRST_ARRIVAL_OUTSIDE_VICTORY_ROAD
    SetFlag FLAG_FIRST_ARRIVAL_POKEMON_LEAGUE
VeilstoneGym_PostWin_End:
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_VeilstoneGym
    End

VeilstoneGym_MayleneAfterBadge:
    GoToIfUnset FLAG_OBTAINED_MAYLENE_TM60, VeilstoneGym_MayleneTryGiveTM60
    BufferPlayerName 0
    Message VeilstoneGym_Text_MayleneAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_VeilstoneGym
    End

VeilstoneGym_LostBattle:
    BlackOutFromBattle
    ReleaseAll
    End

VeilstoneGym_GymGuide:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_COBBLE, VeilstoneGym_GymGuideAfterbadge
    Message VeilstoneGym_Text_GymGuideBeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

VeilstoneGym_GymGuideAfterbadge:
    BufferPlayerName 0
    Message VeilstoneGym_Text_GymGuideAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

VeilstoneGym_GymStatue:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    GoToIfBadgeAcquired BADGE_ID_COBBLE, VeilstoneGym_GymStatueAfterBadge
    BufferRivalName 0
    BufferRivalName 1
    Message VeilstoneGym_Text_GymStatueBeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

VeilstoneGym_GymStatueAfterBadge:
    BufferRivalName 0
    BufferPlayerName 1
    BufferRivalName 2
    Message VeilstoneGym_Text_GymStatueAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

VeilstoneGym_LeftPoster:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    Message VeilstoneGym_Text_GoodDeedEveryDay
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

VeilstoneGym_RightPoster:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    Message VeilstoneGym_Text_TreasureEveryEncounter
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

VeilstoneGym_MiddlePoster:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    Message VeilstoneGym_Text_OneDayAtATime
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End


GymExit_TryLeave_VeilstoneGym:
    GoToIfSet FLAG_UNK_0x0FFB, GymExit_Blocked_VeilstoneGym
    GoTo RandomGym_ReturnToOriginCity_VeilstoneGym
    End

GymExit_Blocked_VeilstoneGym:
    LockAll
    Message 13
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

# GymExit_Text_MustDefeatLeader_VeilstoneGym = index 13

RandomGym_ReturnToOriginCity_VeilstoneGym:
    GoToIfEq VAR_UNK_0x4110, 0, ReturnTo_City0_VeilstoneGym
    GoToIfEq VAR_UNK_0x4110, 1, ReturnTo_City1_VeilstoneGym
    GoToIfEq VAR_UNK_0x4110, 2, ReturnTo_City2_VeilstoneGym
    GoToIfEq VAR_UNK_0x4110, 3, ReturnTo_City3_VeilstoneGym
    GoToIfEq VAR_UNK_0x4110, 4, ReturnTo_City4_VeilstoneGym
    GoToIfEq VAR_UNK_0x4110, 5, ReturnTo_City5_VeilstoneGym
    GoToIfEq VAR_UNK_0x4110, 6, ReturnTo_City6_VeilstoneGym
    GoToIfEq VAR_UNK_0x4110, 7, ReturnTo_City7_VeilstoneGym
    GoTo ReturnTo_City0_VeilstoneGym

ReturnTo_City0_VeilstoneGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY, 0, 282, 758, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City1_VeilstoneGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY, 0, 312, 564, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City2_VeilstoneGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY, 0, 684, 613, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City3_VeilstoneGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY, 0, 591, 830, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City4_VeilstoneGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY, 0, 499, 699, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City5_VeilstoneGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY, 0, 39, 733, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City6_VeilstoneGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY, 0, 367, 224, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City7_VeilstoneGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY, 0, 845, 749, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End


    .balign 4, 0
