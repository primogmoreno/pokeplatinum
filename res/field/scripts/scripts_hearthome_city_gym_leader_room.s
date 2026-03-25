#include "macros/scrcmd.inc"
#include "res/text/bank/hearthome_city_gym_leader_room.h"
#include "res/field/events/events_hearthome_city_gym_leader_room.h"


    ScriptEntry HearthomeGym_Fantina
    ScriptEntry HearthomeGym_FantinaTryGiveTM65
    ScriptEntry HearthomeGym_FantinaCannotGiveTM65
    ScriptEntry HearthomeGym_FantinaAfterBadge
    ScriptEntry HearthomeGym_LostBattle
    ScriptEntry HearthomeGym_TryRemoveBollards
    ScriptEntry HearthomeGym_LeaderRoom_OnTransition
    ScriptEntry HearthomeGym_LeaderRoom_EnterRedirect
    ScriptEntryEnd

HearthomeGym_TryRemoveBollards:
    GoToIfSet FLAG_MAP_LOCAL, HearthomeGym_RemoveBollards
    End

HearthomeGym_RemoveBollards:
    SetFlag FLAG_HIDE_HEARTHOME_GYM_BOLLARDS
    RemoveObject HEARTHOME_CITY_GYM_LEADER_ROOM_BOLLARD_2
    RemoveObject HEARTHOME_CITY_GYM_LEADER_ROOM_BOLLARD_1
    ClearFlag FLAG_MAP_LOCAL
    End

HearthomeGym_Fantina:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GetPlayerDir VAR_RESULT
    GoToIfEq VAR_RESULT, DIR_NORTH, HearthomeGym_FantinaPrepareSpinFaceSouth
    GoToIfEq VAR_RESULT, DIR_SOUTH, HearthomeGym_FantinaPrepareSpinFaceNorth
    GoToIfEq VAR_RESULT, DIR_WEST, HearthomeGym_FantinaPrepareSpinFaceEast
    GoToIfEq VAR_RESULT, DIR_EAST, HearthomeGym_FantinaPrepareSpinFaceWest
    End

HearthomeGym_FantinaPrepareSpinFaceSouth:
    ApplyMovement HEARTHOME_CITY_GYM_LEADER_ROOM_FANTINA, HearthomeGym_FantinaSpinFaceSouth
    WaitMovement
    GoTo HearthomeGym_FantinaMain

HearthomeGym_FantinaPrepareSpinFaceNorth:
    ApplyMovement HEARTHOME_CITY_GYM_LEADER_ROOM_FANTINA, HearthomeGym_FantinaSpinFaceNorth
    WaitMovement
    GoTo HearthomeGym_FantinaMain

HearthomeGym_FantinaPrepareSpinFaceEast:
    ApplyMovement HEARTHOME_CITY_GYM_LEADER_ROOM_FANTINA, HearthomeGym_FantinaSpinFaceEast
    WaitMovement
    GoTo HearthomeGym_FantinaMain

HearthomeGym_FantinaPrepareSpinFaceWest:
    ApplyMovement HEARTHOME_CITY_GYM_LEADER_ROOM_FANTINA, HearthomeGym_FantinaSpinFaceWest
    WaitMovement
    GoTo HearthomeGym_FantinaMain

HearthomeGym_FantinaMain:
    GoToIfBadgeAcquired BADGE_ID_RELIC, HearthomeGym_FantinaAfterBadge
    CreateJournalEvent LOCATION_EVENT_GYM_WAS_TOO_TOUGH, 91, 0, 0, 0
    Message HearthomeGym_Text_FantinaIntro
    CloseMessage
    SetFlag FLAG_MAP_LOCAL
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 7, Fantina_BattleB7
    GoToIfEq VAR_RESULT, 6, Fantina_BattleB6
    GoToIfEq VAR_RESULT, 5, Fantina_BattleB5
    GoToIfEq VAR_RESULT, 4, Fantina_BattleB4
    GoToIfEq VAR_RESULT, 3, Fantina_BattleB3
    GoToIfEq VAR_RESULT, 2, Fantina_BattleB2
    GoToIfEq VAR_RESULT, 1, Fantina_BattleB1
Fantina_BattleB0:
    StartTrainerBattle TRAINER_LEADER_FANTINA_B0
    GoTo Fantina_BattleDone
Fantina_BattleB1:
    StartTrainerBattle TRAINER_LEADER_FANTINA_B1
    GoTo Fantina_BattleDone
Fantina_BattleB2:
    StartTrainerBattle TRAINER_LEADER_FANTINA_B2
    GoTo Fantina_BattleDone
Fantina_BattleB3:
    StartTrainerBattle TRAINER_LEADER_FANTINA_B3
    GoTo Fantina_BattleDone
Fantina_BattleB4:
    StartTrainerBattle TRAINER_LEADER_FANTINA_B4
    GoTo Fantina_BattleDone
Fantina_BattleB5:
    StartTrainerBattle TRAINER_LEADER_FANTINA_B5
    GoTo Fantina_BattleDone
Fantina_BattleB6:
    StartTrainerBattle TRAINER_LEADER_FANTINA_B6
    GoTo Fantina_BattleDone
Fantina_BattleB7:
    StartTrainerBattle TRAINER_LEADER_FANTINA_B7
    GoTo Fantina_BattleDone
Fantina_BattleDone:
    ClearFlag FLAG_MAP_LOCAL
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, HearthomeGym_LostBattle
    Message HearthomeGym_Text_BeatFantina
    BufferPlayerName 0
    Message HearthomeGym_Text_FantinaReceiveRelicBadge
    PlaySound SEQ_BADGE
    WaitSound
    GiveBadge BADGE_ID_RELIC
    IncrementTrainerScore2 TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_CAMPER_DREW
    SetTrainerFlag TRAINER_ACE_TRAINER_ALLEN
    SetTrainerFlag TRAINER_ACE_TRAINER_CATHERINE
    SetTrainerFlag TRAINER_LASS_MOLLY
    SetTrainerFlag TRAINER_PICNICKER_CHEYENNE
    SetTrainerFlag TRAINER_SCHOOL_KID_CHANCE
    SetTrainerFlag TRAINER_SCHOOL_KID_MACKENZIE
    SetTrainerFlag TRAINER_YOUNGSTER_DONNY
    CreateJournalEvent LOCATION_EVENT_BEAT_GYM_LEADER, 91, TRAINER_LEADER_FANTINA, 0, 0
    SetVar VAR_HEARTHOME_STATE, 1
    SetFlag FLAG_HIDE_HEARTHOME_ROUTE_209_ROADBLOCK
    ClearFlag FLAG_HIDE_HEARTHOME_ROUTE_209_GATE_RIVAL
    Message HearthomeGym_Text_FantinaExplainRelicBadge
    GoTo HearthomeGym_FantinaTryGiveTM65

HearthomeGym_FantinaTryGiveTM65:
    SetVar VAR_0x8004, ITEM_TM65
    SetVar VAR_0x8005, 1
    GoToIfCannotFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT, HearthomeGym_FantinaCannotGiveTM65
    Common_GiveItemQuantity
    SetFlag FLAG_OBTAINED_FANTINA_TM65
    BufferItemName 0, VAR_0x8004
    BufferTMHMMoveName 1, VAR_0x8004
    Message HearthomeGym_FantinaExplainTM65
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_HearthomeGym
    End

HearthomeGym_FantinaCannotGiveTM65:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_HearthomeGym
    End

HearthomeGym_FantinaAfterBadge:
    GoToIfUnset FLAG_OBTAINED_FANTINA_TM65, HearthomeGym_FantinaTryGiveTM65
    Message HearthomeGym_Text_FantinaAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_HearthomeGym
    End


RandomGym_ReturnToOriginCity_HearthomeGym:
    GoToIfEq VAR_UNK_0x4110, 0, ReturnTo_City0_HearthomeGym
    GoToIfEq VAR_UNK_0x4110, 1, ReturnTo_City1_HearthomeGym
    GoToIfEq VAR_UNK_0x4110, 2, ReturnTo_City2_HearthomeGym
    GoToIfEq VAR_UNK_0x4110, 3, ReturnTo_City3_HearthomeGym
    GoToIfEq VAR_UNK_0x4110, 4, ReturnTo_City4_HearthomeGym
    GoToIfEq VAR_UNK_0x4110, 5, ReturnTo_City5_HearthomeGym
    GoToIfEq VAR_UNK_0x4110, 6, ReturnTo_City6_HearthomeGym
    GoToIfEq VAR_UNK_0x4110, 7, ReturnTo_City7_HearthomeGym
    GoTo ReturnTo_City0_HearthomeGym

ReturnTo_City0_HearthomeGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY, 0, 282, 758, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City1_HearthomeGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY, 0, 312, 564, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City2_HearthomeGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY, 0, 684, 613, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City3_HearthomeGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY, 0, 589, 835, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City4_HearthomeGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY, 0, 499, 699, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City5_HearthomeGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY, 0, 39, 733, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City6_HearthomeGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY, 0, 367, 224, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City7_HearthomeGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY, 0, 845, 749, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End


HearthomeGym_LeaderRoom_OnTransition:
    GoToIfSet FLAG_UNK_0x0FFB, HearthomeGym_LeaderRoom_OnTransition_Done
    SetVar VAR_UNK_0x4110, 4
    SetVar VAR_UNK_0x4113, 0
HearthomeGym_LeaderRoom_OnTransition_Done:
    End

HearthomeGym_LeaderRoom_EnterRedirect:
    SetVar VAR_UNK_0x4113, 1
    GoToIfSet FLAG_UNK_0x0FF7, HearthomeGym_LeaderRoom_NoRedirect
    SetFlag FLAG_UNK_0x0FF7
    WaitFadeScreen
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 8, HearthomeGym_LeaderRoom_NoRedirect
    SetFlag FLAG_UNK_0x0FFB
    GetRandom VAR_UNK_0x4111, 8
HearthomeGym_LeaderRoom_TryGym:
    GoToIfEq VAR_UNK_0x4111, 0, HearthomeGym_LeaderRoom_TryIndex0
    GoToIfEq VAR_UNK_0x4111, 1, HearthomeGym_LeaderRoom_TryIndex1
    GoToIfEq VAR_UNK_0x4111, 2, HearthomeGym_LeaderRoom_TryIndex2
    GoToIfEq VAR_UNK_0x4111, 3, HearthomeGym_LeaderRoom_TryIndex3
    GoToIfEq VAR_UNK_0x4111, 4, HearthomeGym_LeaderRoom_TryIndex4
    GoToIfEq VAR_UNK_0x4111, 5, HearthomeGym_LeaderRoom_TryIndex5
    GoToIfEq VAR_UNK_0x4111, 6, HearthomeGym_LeaderRoom_TryIndex6
    GoTo HearthomeGym_LeaderRoom_TryIndex7
HearthomeGym_LeaderRoom_TryIndex0:
    GoToIfBadgeAcquired BADGE_ID_COAL, HearthomeGym_LeaderRoom_NextIndex
    GoTo HearthomeGym_LeaderRoom_WarpToIndex0
HearthomeGym_LeaderRoom_TryIndex1:
    GoToIfBadgeAcquired BADGE_ID_FOREST, HearthomeGym_LeaderRoom_NextIndex
    GoTo HearthomeGym_LeaderRoom_WarpToIndex1
HearthomeGym_LeaderRoom_TryIndex2:
    GoToIfBadgeAcquired BADGE_ID_COBBLE, HearthomeGym_LeaderRoom_NextIndex
    GoTo HearthomeGym_LeaderRoom_WarpToIndex2
HearthomeGym_LeaderRoom_TryIndex3:
    GoToIfBadgeAcquired BADGE_ID_FEN, HearthomeGym_LeaderRoom_NextIndex
    GoTo HearthomeGym_LeaderRoom_WarpToIndex3
HearthomeGym_LeaderRoom_TryIndex4:
    GoToIfBadgeAcquired BADGE_ID_RELIC, HearthomeGym_LeaderRoom_NextIndex
    GoTo HearthomeGym_LeaderRoom_NoRedirect
HearthomeGym_LeaderRoom_TryIndex5:
    GoToIfBadgeAcquired BADGE_ID_MINE, HearthomeGym_LeaderRoom_NextIndex
    GoTo HearthomeGym_LeaderRoom_WarpToIndex5
HearthomeGym_LeaderRoom_TryIndex6:
    GoToIfBadgeAcquired BADGE_ID_ICICLE, HearthomeGym_LeaderRoom_NextIndex
    GoTo HearthomeGym_LeaderRoom_WarpToIndex6
HearthomeGym_LeaderRoom_TryIndex7:
    GoToIfBadgeAcquired BADGE_ID_BEACON, HearthomeGym_LeaderRoom_NextIndex
    GoTo HearthomeGym_LeaderRoom_WarpToIndex7
HearthomeGym_LeaderRoom_NextIndex:
    AddVar VAR_UNK_0x4111, 1
    GoToIfEq VAR_UNK_0x4111, 8, HearthomeGym_LeaderRoom_ResetIndex
    GoTo HearthomeGym_LeaderRoom_TryGym
HearthomeGym_LeaderRoom_ResetIndex:
    SetVar VAR_UNK_0x4111, 0
    GoTo HearthomeGym_LeaderRoom_TryGym
HearthomeGym_LeaderRoom_WarpToIndex0:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY_GYM, 0, 5, 22, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
HearthomeGym_LeaderRoom_WarpToIndex1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY_GYM, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
HearthomeGym_LeaderRoom_WarpToIndex2:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY_GYM, 0, 12, 28, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
HearthomeGym_LeaderRoom_WarpToIndex3:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY_GYM, 0, 13, 40, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
HearthomeGym_LeaderRoom_WarpToIndex5:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY_GYM, 0, 16, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
HearthomeGym_LeaderRoom_WarpToIndex6:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY_GYM, 0, 11, 26, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
HearthomeGym_LeaderRoom_WarpToIndex7:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_3, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
HearthomeGym_LeaderRoom_NoRedirect:
    ClearFlag FLAG_UNK_0x0FFB
    End

    .balign 4, 0
HearthomeGym_FantinaSpinFaceSouth:
    FaceWest 4
    FaceNorth 4
    FaceEast 4
    FaceSouth 4
    FaceWest 4
    FaceNorth 4
    FaceEast 4
    FaceSouth 4
    EndMovement

    .balign 4, 0
HearthomeGym_FantinaSpinFaceNorth:
    FaceEast 4
    FaceSouth 4
    FaceWest 4
    FaceNorth 4
    FaceEast 4
    FaceSouth 4
    FaceWest 4
    FaceNorth 4
    EndMovement

    .balign 4, 0
HearthomeGym_FantinaSpinFaceEast:
    FaceNorth 4
    FaceWest 4
    FaceSouth 4
    FaceEast 4
    FaceNorth 4
    FaceWest 4
    FaceSouth 4
    FaceEast 4
    EndMovement

    .balign 4, 0
HearthomeGym_FantinaSpinFaceWest:
    FaceNorth 4
    FaceEast 4
    FaceSouth 4
    FaceWest 4
    FaceNorth 4
    FaceEast 4
    FaceSouth 4
    FaceWest 4
    EndMovement

HearthomeGym_LostBattle:
    ClearFlag FLAG_HIDE_HEARTHOME_GYM_BOLLARDS
    BlackOutFromBattle
    ReleaseAll
    End

    .balign 4, 0
