#include "macros/scrcmd.inc"
#include "res/text/bank/snowpoint_city_gym.h"


    ScriptEntry SnowpointGym_OnTransition
    ScriptEntry SnowpointGym_EnterRedirect
    ScriptEntry SnowpointGym_Init
    ScriptEntry SnowpointGym_Candice
    ScriptEntry SnowpointGym_GymGuide
    ScriptEntry SnowpointGym_GymStatue
    ScriptEntry GymExit_TryLeave_SnowpointGym
    ScriptEntryEnd

SnowpointGym_OnTransition:
    GoToIfUnset FLAG_UNK_0x00EB, SnowpointGym_OnTransition_InitDone
    SetFlag FLAG_UNK_0x01F3
SnowpointGym_OnTransition_InitDone:
    GoToIfSet FLAG_UNK_0x0FFB, SnowpointGym_OnTransition_Done
    SetVar VAR_UNK_0x4110, 6
    SetVar VAR_UNK_0x4113, 0
SnowpointGym_OnTransition_Done:
    End

SnowpointGym_EnterRedirect:
    SetVar VAR_UNK_0x4113, 1
    WaitFadeScreen
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 8, SnowpointGym_NoRedirect
    SetFlag FLAG_UNK_0x0FFB
    GetRandom VAR_UNK_0x4111, 8
SnowpointGym_TryGym:
    GoToIfEq VAR_UNK_0x4111, 0, SnowpointGym_TryIndex0
    GoToIfEq VAR_UNK_0x4111, 1, SnowpointGym_TryIndex1
    GoToIfEq VAR_UNK_0x4111, 2, SnowpointGym_TryIndex2
    GoToIfEq VAR_UNK_0x4111, 3, SnowpointGym_TryIndex3
    GoToIfEq VAR_UNK_0x4111, 4, SnowpointGym_TryIndex4
    GoToIfEq VAR_UNK_0x4111, 5, SnowpointGym_TryIndex5
    GoToIfEq VAR_UNK_0x4111, 6, SnowpointGym_TryIndex6
    GoTo SnowpointGym_TryIndex7
SnowpointGym_TryIndex0:
    GoToIfBadgeAcquired BADGE_ID_COAL, SnowpointGym_NextIndex
    GoTo SnowpointGym_WarpToIndex0
SnowpointGym_TryIndex1:
    GoToIfBadgeAcquired BADGE_ID_FOREST, SnowpointGym_NextIndex
    GoTo SnowpointGym_WarpToIndex1
SnowpointGym_TryIndex2:
    GoToIfBadgeAcquired BADGE_ID_COBBLE, SnowpointGym_NextIndex
    GoTo SnowpointGym_WarpToIndex2
SnowpointGym_TryIndex3:
    GoToIfBadgeAcquired BADGE_ID_FEN, SnowpointGym_NextIndex
    GoTo SnowpointGym_WarpToIndex3
SnowpointGym_TryIndex4:
    GoToIfBadgeAcquired BADGE_ID_RELIC, SnowpointGym_NextIndex
    GoTo SnowpointGym_WarpToIndex4
SnowpointGym_TryIndex5:
    GoToIfBadgeAcquired BADGE_ID_MINE, SnowpointGym_NextIndex
    GoTo SnowpointGym_WarpToIndex5
SnowpointGym_TryIndex6:
    GoToIfBadgeAcquired BADGE_ID_ICICLE, SnowpointGym_NextIndex
    GoTo SnowpointGym_NextIndex
SnowpointGym_TryIndex7:
    GoToIfBadgeAcquired BADGE_ID_BEACON, SnowpointGym_NextIndex
    GoTo SnowpointGym_WarpToIndex7
SnowpointGym_NextIndex:
    AddVar VAR_UNK_0x4111, 1
    GoToIfEq VAR_UNK_0x4111, 8, SnowpointGym_ResetIndex
    GoTo SnowpointGym_TryGym
SnowpointGym_ResetIndex:
    SetVar VAR_UNK_0x4111, 0
    GoTo SnowpointGym_TryGym
SnowpointGym_WarpToIndex0:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY_GYM, 0, 5, 22, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
SnowpointGym_WarpToIndex1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY_GYM, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
SnowpointGym_WarpToIndex2:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY_GYM, 0, 12, 28, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
SnowpointGym_WarpToIndex3:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY_GYM, 0, 13, 40, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
SnowpointGym_WarpToIndex4:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY_GYM_LEADER_ROOM, 0, 4, 13, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
SnowpointGym_WarpToIndex5:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY_GYM, 0, 16, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
SnowpointGym_WarpToIndex6:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY_GYM, 0, 11, 26, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
SnowpointGym_WarpToIndex7:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_3, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
SnowpointGym_NoRedirect:
    End

SnowpointGym_Init:
    GoToIfSet FLAG_UNK_0x00EB, _001F
    End

_001F:
    SetFlag FLAG_UNK_0x01F3
    End

SnowpointGym_Candice:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_ICICLE, SnowpointGym_CandiceAfterBadge
    CreateJournalEvent LOCATION_EVENT_GYM_WAS_TOO_TOUGH, 167, 0, 0, 0
    Message SnowpointGym_Text_CandiceIntro
    CloseMessage
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 7, Candice_BattleB7
    GoToIfEq VAR_RESULT, 6, Candice_BattleB6
    GoToIfEq VAR_RESULT, 5, Candice_BattleB5
    GoToIfEq VAR_RESULT, 4, Candice_BattleB4
    GoToIfEq VAR_RESULT, 3, Candice_BattleB3
    GoToIfEq VAR_RESULT, 2, Candice_BattleB2
    GoToIfEq VAR_RESULT, 1, Candice_BattleB1
Candice_BattleB0:
    StartTrainerBattle TRAINER_LEADER_CANDICE_B0
    GoTo Candice_BattleDone
Candice_BattleB1:
    StartTrainerBattle TRAINER_LEADER_CANDICE_B1
    GoTo Candice_BattleDone
Candice_BattleB2:
    StartTrainerBattle TRAINER_LEADER_CANDICE_B2
    GoTo Candice_BattleDone
Candice_BattleB3:
    StartTrainerBattle TRAINER_LEADER_CANDICE_B3
    GoTo Candice_BattleDone
Candice_BattleB4:
    StartTrainerBattle TRAINER_LEADER_CANDICE_B4
    GoTo Candice_BattleDone
Candice_BattleB5:
    StartTrainerBattle TRAINER_LEADER_CANDICE_B5
    GoTo Candice_BattleDone
Candice_BattleB6:
    StartTrainerBattle TRAINER_LEADER_CANDICE_B6
    GoTo Candice_BattleDone
Candice_BattleB7:
    StartTrainerBattle TRAINER_LEADER_CANDICE_B7
    GoTo Candice_BattleDone
Candice_BattleDone:
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, SnowpointGym_LostBattle
    Message SnowpointGym_Text_BeatCandice
    BufferPlayerName 0
    Message SnowpointGym_Text_CandiceReceiveIciclebadge
    PlaySound SEQ_BADGE
    WaitSound
    GiveBadge BADGE_ID_ICICLE
    IncrementTrainerScore2 TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_ACE_TRAINER_SERGIO
    SetTrainerFlag TRAINER_ACE_TRAINER_ISAIAH
    SetTrainerFlag TRAINER_ACE_TRAINER_ANTON
    SetTrainerFlag TRAINER_ACE_TRAINER_SAVANNAH
    SetTrainerFlag TRAINER_ACE_TRAINER_ALICIA
    SetTrainerFlag TRAINER_ACE_TRAINER_BRENNA
    CreateJournalEvent LOCATION_EVENT_BEAT_GYM_LEADER, 167, TRAINER_LEADER_CANDICE, 0, 0
    SetFlag FLAG_HIDE_VEILSTONE_GALACTIC_GRUNTS
    Message SnowpointGym_Text_CandiceExplainIcicleBadge
    GoTo SnowpointGym_CandiceTryGiveTM72

SnowpointGym_CandiceTryGiveTM72:
    SetVar VAR_0x8004, ITEM_TM72
    SetVar VAR_0x8005, 1
    GoToIfCannotFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT, SnowpointGym_CandiceCannotGiveTM72
    Common_GiveItemQuantity
    SetFlag FLAG_OBTAINED_CANDICE_TM72
    BufferItemName 0, VAR_0x8004
    BufferTMHMMoveName 1, VAR_0x8004
    Message SnowpointGym_Text_CandiceExplainTM72
    WaitABXPadPress
    CloseMessage
    GoTo SnowpointGym_PostWin
    End

SnowpointGym_CandiceCannotGiveTM72:
    Common_MessageBagIsFull
    CloseMessage
    GoTo SnowpointGym_PostWin
    End

SnowpointGym_PostWin:
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 5, SnowpointGym_Badge5
    GoToIfEq VAR_RESULT, 6, SnowpointGym_Badge6
    GoToIfEq VAR_RESULT, 8, SnowpointGym_Badge8
    GoTo SnowpointGym_PostWin_End
SnowpointGym_Badge5:
    GoToIfSet FLAG_UNK_0x0FFC, SnowpointGym_PostWin_End
    SetFlag FLAG_UNK_0x0FFC
    Message 10
    WaitABXPadPress
    CloseMessage
    AddItem ITEM_HM01, 1, VAR_RESULT
    AddItem ITEM_HM02, 1, VAR_RESULT
    AddItem ITEM_HM03, 1, VAR_RESULT
    AddItem ITEM_HM04, 1, VAR_RESULT
    AddItem ITEM_HM08, 1, VAR_RESULT
    GoTo SnowpointGym_PostWin_End
SnowpointGym_Badge6:
    GoToIfSet FLAG_UNK_0x0FFD, SnowpointGym_PostWin_End
    SetFlag FLAG_UNK_0x0FFD
    SetFlag FLAG_FIRST_ARRIVAL_SNOWPOINT_CITY
    SetFlag FLAG_FIRST_ARRIVAL_SUNYSHORE_CITY
    GoTo SnowpointGym_PostWin_End
SnowpointGym_Badge8:
    GoToIfSet FLAG_UNK_0x0FFE, SnowpointGym_PostWin_End
    SetFlag FLAG_UNK_0x0FFE
    SetFlag FLAG_FIRST_ARRIVAL_OUTSIDE_VICTORY_ROAD
    SetFlag FLAG_FIRST_ARRIVAL_POKEMON_LEAGUE
SnowpointGym_PostWin_End:
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_SnowpointGym
    End

SnowpointGym_CandiceAfterBadge:
    GoToIfUnset FLAG_OBTAINED_CANDICE_TM72, SnowpointGym_CandiceTryGiveTM72
    Message SnowpointGym_Text_CandiceAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_SnowpointGym
    End

SnowpointGym_LostBattle:
    BlackOutFromBattle
    ReleaseAll
    End

SnowpointGym_GymGuide:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_ICICLE, SnowpointGym_GymGuideAfterBadge
    Message SnowpointGym_Text_GymGuideBeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

SnowpointGym_GymGuideAfterBadge:
    BufferPlayerName 0
    Message SnowpointGym_Text_GymGuideAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

SnowpointGym_GymStatue:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    GoToIfBadgeAcquired BADGE_ID_ICICLE, SnowpointGym_GymStatueAfterBadge
    BufferRivalName 0
    BufferRivalName 1
    Message SnowpointGym_Text_GymStatueBeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

SnowpointGym_GymStatueAfterBadge:
    BufferRivalName 0
    BufferPlayerName 1
    BufferRivalName 2
    Message SnowpointGym_Text_GymStatueAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End


GymExit_TryLeave_SnowpointGym:
    GoToIfSet FLAG_UNK_0x0FFB, GymExit_Blocked_SnowpointGym
    GoTo RandomGym_ReturnToOriginCity_SnowpointGym
    End

GymExit_Blocked_SnowpointGym:
    LockAll
    Message 10
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

# GymExit_Text_MustDefeatLeader_SnowpointGym = index 10

RandomGym_ReturnToOriginCity_SnowpointGym:
    GoToIfEq VAR_UNK_0x4110, 0, ReturnTo_City0_SnowpointGym
    GoToIfEq VAR_UNK_0x4110, 1, ReturnTo_City1_SnowpointGym
    GoToIfEq VAR_UNK_0x4110, 2, ReturnTo_City2_SnowpointGym
    GoToIfEq VAR_UNK_0x4110, 3, ReturnTo_City3_SnowpointGym
    GoToIfEq VAR_UNK_0x4110, 4, ReturnTo_City4_SnowpointGym
    GoToIfEq VAR_UNK_0x4110, 5, ReturnTo_City5_SnowpointGym
    GoToIfEq VAR_UNK_0x4110, 6, ReturnTo_City6_SnowpointGym
    GoToIfEq VAR_UNK_0x4110, 7, ReturnTo_City7_SnowpointGym
    GoTo ReturnTo_City0_SnowpointGym

ReturnTo_City0_SnowpointGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY, 0, 282, 758, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City1_SnowpointGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY, 0, 312, 564, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City2_SnowpointGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY, 0, 684, 613, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City3_SnowpointGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY, 0, 591, 830, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City4_SnowpointGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY, 0, 499, 699, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City5_SnowpointGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY, 0, 39, 733, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City6_SnowpointGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY, 0, 367, 224, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City7_SnowpointGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY, 0, 845, 749, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End


    .balign 4, 0
