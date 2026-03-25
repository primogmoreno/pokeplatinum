#include "macros/scrcmd.inc"
#include "res/text/bank/oreburgh_city_gym.h"


    ScriptEntry OreburghGym_OnTransition
    ScriptEntry OreburghGym_EnterRedirect
    ScriptEntry OreburghGym_Roark
    ScriptEntry OreburghGym_GymGuide
    ScriptEntry OreburghGym_GymStatue
    ScriptEntry GymExit_TryLeave_OreburghGym
    ScriptEntryEnd

OreburghGym_OnTransition:
    GoToIfSet FLAG_UNK_0x0FFB, OreburghGym_OnTransition_Done
    SetVar VAR_UNK_0x4110, 0
    SetVar VAR_UNK_0x4113, 0
OreburghGym_OnTransition_Done:
    End

OreburghGym_EnterRedirect:
    SetVar VAR_UNK_0x4113, 1
    WaitFadeScreen
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 8, OreburghGym_NoRedirect
    SetFlag FLAG_UNK_0x0FFB
    GetRandom VAR_UNK_0x4111, 8
OreburghGym_TryGym:
    GoToIfEq VAR_UNK_0x4111, 0, OreburghGym_TryIndex0
    GoToIfEq VAR_UNK_0x4111, 1, OreburghGym_TryIndex1
    GoToIfEq VAR_UNK_0x4111, 2, OreburghGym_TryIndex2
    GoToIfEq VAR_UNK_0x4111, 3, OreburghGym_TryIndex3
    GoToIfEq VAR_UNK_0x4111, 4, OreburghGym_TryIndex4
    GoToIfEq VAR_UNK_0x4111, 5, OreburghGym_TryIndex5
    GoToIfEq VAR_UNK_0x4111, 6, OreburghGym_TryIndex6
    GoTo OreburghGym_TryIndex7
OreburghGym_TryIndex0:
    GoToIfBadgeAcquired BADGE_ID_COAL, OreburghGym_NextIndex
    GoTo OreburghGym_NextIndex
OreburghGym_TryIndex1:
    GoToIfBadgeAcquired BADGE_ID_FOREST, OreburghGym_NextIndex
    GoTo OreburghGym_WarpToIndex1
OreburghGym_TryIndex2:
    GoToIfBadgeAcquired BADGE_ID_COBBLE, OreburghGym_NextIndex
    GoTo OreburghGym_WarpToIndex2
OreburghGym_TryIndex3:
    GoToIfBadgeAcquired BADGE_ID_FEN, OreburghGym_NextIndex
    GoTo OreburghGym_WarpToIndex3
OreburghGym_TryIndex4:
    GoToIfBadgeAcquired BADGE_ID_RELIC, OreburghGym_NextIndex
    GoTo OreburghGym_WarpToIndex4
OreburghGym_TryIndex5:
    GoToIfBadgeAcquired BADGE_ID_MINE, OreburghGym_NextIndex
    GoTo OreburghGym_WarpToIndex5
OreburghGym_TryIndex6:
    GoToIfBadgeAcquired BADGE_ID_ICICLE, OreburghGym_NextIndex
    GoTo OreburghGym_WarpToIndex6
OreburghGym_TryIndex7:
    GoToIfBadgeAcquired BADGE_ID_BEACON, OreburghGym_NextIndex
    GoTo OreburghGym_WarpToIndex7
OreburghGym_NextIndex:
    AddVar VAR_UNK_0x4111, 1
    GoToIfEq VAR_UNK_0x4111, 8, OreburghGym_ResetIndex
    GoTo OreburghGym_TryGym
OreburghGym_ResetIndex:
    SetVar VAR_UNK_0x4111, 0
    GoTo OreburghGym_TryGym
OreburghGym_WarpToIndex0:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY_GYM, 0, 5, 22, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
OreburghGym_WarpToIndex1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY_GYM, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
OreburghGym_WarpToIndex2:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY_GYM, 0, 12, 28, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
OreburghGym_WarpToIndex3:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY_GYM, 0, 13, 40, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
OreburghGym_WarpToIndex4:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY_GYM_LEADER_ROOM, 0, 4, 13, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
OreburghGym_WarpToIndex5:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY_GYM, 0, 16, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
OreburghGym_WarpToIndex6:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY_GYM, 0, 11, 26, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
OreburghGym_WarpToIndex7:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_3, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
OreburghGym_NoRedirect:
    End

OreburghGym_Roark:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_COAL, OreburghGym_AlreadyHaveCoalBadge
    CreateJournalEvent LOCATION_EVENT_GYM_WAS_TOO_TOUGH, 47, 0, 0, 0
    Message OreburghGym_Text_RoarkIntro
    CloseMessage
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 7, Roark_BattleB7
    GoToIfEq VAR_RESULT, 6, Roark_BattleB6
    GoToIfEq VAR_RESULT, 5, Roark_BattleB5
    GoToIfEq VAR_RESULT, 4, Roark_BattleB4
    GoToIfEq VAR_RESULT, 3, Roark_BattleB3
    GoToIfEq VAR_RESULT, 2, Roark_BattleB2
    GoToIfEq VAR_RESULT, 1, Roark_BattleB1
Roark_BattleB0:
    StartTrainerBattle TRAINER_LEADER_ROARK_B0
    GoTo Roark_BattleDone
Roark_BattleB1:
    StartTrainerBattle TRAINER_LEADER_ROARK_B1
    GoTo Roark_BattleDone
Roark_BattleB2:
    StartTrainerBattle TRAINER_LEADER_ROARK_B2
    GoTo Roark_BattleDone
Roark_BattleB3:
    StartTrainerBattle TRAINER_LEADER_ROARK_B3
    GoTo Roark_BattleDone
Roark_BattleB4:
    StartTrainerBattle TRAINER_LEADER_ROARK_B4
    GoTo Roark_BattleDone
Roark_BattleB5:
    StartTrainerBattle TRAINER_LEADER_ROARK_B5
    GoTo Roark_BattleDone
Roark_BattleB6:
    StartTrainerBattle TRAINER_LEADER_ROARK_B6
    GoTo Roark_BattleDone
Roark_BattleB7:
    StartTrainerBattle TRAINER_LEADER_ROARK_B7
    GoTo Roark_BattleDone
Roark_BattleDone:
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, OreburghGym_LostBattle
    Message OreburghGym_Text_BeatRoark
    BufferPlayerName 0
    Message OreburghGym_Text_RoarkReceiveCoalBadge
    PlaySound SEQ_BADGE
    WaitSound
    SetTrainerFlag TRAINER_YOUNGSTER_JONATHON
    SetTrainerFlag TRAINER_YOUNGSTER_DARIUS
    GiveBadge BADGE_ID_COAL
    IncrementTrainerScore2 TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_YOUNGSTER_JONATHON
    SetTrainerFlag TRAINER_YOUNGSTER_DARIUS
    SetFlag FLAG_HIDE_BLOCK_POKECENTER_BASEMENT
    SetVar VAR_GTS_ACCESS_STATE, 1
    SetVar VAR_JUBILIFE_LOOKER_PAL_PAD_STATE, 1
    SetVar VAR_OREBURGH_STATE, 2
    CreateJournalEvent LOCATION_EVENT_BEAT_GYM_LEADER, 47, TRAINER_LEADER_ROARK, 0, 0
    SetVar VAR_JUBILIFE_CITY_STATE, 3
    ClearFlag FLAG_HIDE_JUBILIFE_CITY_COUNTERPART
    ClearFlag FLAG_HIDE_JUBILIFE_ROWAN
    ClearFlag FLAG_HIDE_JUBILIFE_GALACTIC_GRUNTS
    SetFlag FLAG_HIDE_SANDGEM_TOWN_LAB_PROF_ROWAN
    Message OreburghGym_Text_RoarkExplainCoalBadge
    GoTo OreburghGym_RoarkGiveTM76
    End

OreburghGym_RoarkGiveTM76:
    SetVar VAR_0x8004, ITEM_TM76
    SetVar VAR_0x8005, 1
    GoToIfCannotFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT, OreburghGym_RoarkGiveTM76BagFull
    Common_GiveItemQuantity
    SetFlag FLAG_OBTAINED_ROARK_TM76
    BufferItemName 0, VAR_0x8004
    BufferTMHMMoveName 1, VAR_0x8004
    Message OreburghGym_Text_RoarkExplainStealthRock
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_OreburghGym
    End

OreburghGym_RoarkGiveTM76BagFull:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_OreburghGym
    End

OreburghGym_AlreadyHaveCoalBadge:
    GoToIfUnset FLAG_OBTAINED_ROARK_TM76, OreburghGym_RoarkGiveTM76
    Message OreburghGym_Text_RoarkGymBeaten
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_OreburghGym
    End

OreburghGym_LostBattle:
    BlackOutFromBattle
    ReleaseAll
    End

OreburghGym_GymGuide:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_COAL, OreburghGym_GymGuideAfterBadge
    Message OreburghGym_Text_GymGuideBeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghGym_GymGuideAfterBadge:
    BufferPlayerName 0
    Message OreburghGym_Text_GymGuideAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghGym_GymStatue:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    GoToIfBadgeAcquired BADGE_ID_COAL, OreburghGym_GymStatueAfterBadge
    BufferRivalName 0
    BufferRivalName 1
    Message OreburghGym_Text_GymStatueBeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghGym_GymStatueAfterBadge:
    BufferRivalName 0
    BufferPlayerName 1
    BufferRivalName 2
    Message OreburghGym_Text_GymStatueAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End


GymExit_TryLeave_OreburghGym:
    GoToIfSet FLAG_UNK_0x0FFB, GymExit_Blocked_OreburghGym
    GoTo RandomGym_ReturnToOriginCity_OreburghGym
    End

GymExit_Blocked_OreburghGym:
    LockAll
    Message 10
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

# GymExit_Text_MustDefeatLeader_OreburghGym = index 10

RandomGym_ReturnToOriginCity_OreburghGym:
    GoToIfEq VAR_UNK_0x4110, 0, ReturnTo_City0_OreburghGym
    GoToIfEq VAR_UNK_0x4110, 1, ReturnTo_City1_OreburghGym
    GoToIfEq VAR_UNK_0x4110, 2, ReturnTo_City2_OreburghGym
    GoToIfEq VAR_UNK_0x4110, 3, ReturnTo_City3_OreburghGym
    GoToIfEq VAR_UNK_0x4110, 4, ReturnTo_City4_OreburghGym
    GoToIfEq VAR_UNK_0x4110, 5, ReturnTo_City5_OreburghGym
    GoToIfEq VAR_UNK_0x4110, 6, ReturnTo_City6_OreburghGym
    GoToIfEq VAR_UNK_0x4110, 7, ReturnTo_City7_OreburghGym
    GoTo ReturnTo_City0_OreburghGym

ReturnTo_City0_OreburghGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY, 0, 282, 758, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City1_OreburghGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY, 0, 312, 564, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City2_OreburghGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY, 0, 684, 613, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City3_OreburghGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY, 0, 589, 835, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City4_OreburghGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY, 0, 499, 699, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City5_OreburghGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY, 0, 39, 733, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City6_OreburghGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY, 0, 367, 224, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City7_OreburghGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY, 0, 845, 749, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End


    .balign 4, 0
