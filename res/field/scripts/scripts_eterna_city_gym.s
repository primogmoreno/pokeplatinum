#include "macros/scrcmd.inc"
#include "res/text/bank/eterna_city_gym.h"
#include "res/field/events/events_eterna_city_gym.h"


    ScriptEntry EternaGym_OnTransition
    ScriptEntry EternaGym_EnterRedirect
    ScriptEntry EternaGym_InitFeatures
    ScriptEntry EternaGym_GymGuide
    ScriptEntry EternaGym_GymStatue
    ScriptEntry EternaGym_Gardenia
    ScriptEntry EternaGym_LassCaroline
    ScriptEntry EternaGym_AromaLadyJenna
    ScriptEntry EternaGym_AromaLadyAngela
    ScriptEntry GymExit_TryLeave_EternaGym
    ScriptEntryEnd

EternaGym_OnTransition:
    InitPersistedMapFeaturesForEternaGym
    GoToIfSet FLAG_UNK_0x0FFB, EternaGym_OnTransition_Done
    SetVar VAR_UNK_0x4110, 1
    SetVar VAR_UNK_0x4113, 0
EternaGym_OnTransition_Done:
    End

EternaGym_EnterRedirect:
    SetVar VAR_UNK_0x4113, 1
    WaitFadeScreen
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 8, EternaGym_NoRedirect
    SetFlag FLAG_UNK_0x0FFB
    GetRandom VAR_UNK_0x4111, 8
EternaGym_TryGym:
    GoToIfEq VAR_UNK_0x4111, 0, EternaGym_TryIndex0
    GoToIfEq VAR_UNK_0x4111, 1, EternaGym_TryIndex1
    GoToIfEq VAR_UNK_0x4111, 2, EternaGym_TryIndex2
    GoToIfEq VAR_UNK_0x4111, 3, EternaGym_TryIndex3
    GoToIfEq VAR_UNK_0x4111, 4, EternaGym_TryIndex4
    GoToIfEq VAR_UNK_0x4111, 5, EternaGym_TryIndex5
    GoToIfEq VAR_UNK_0x4111, 6, EternaGym_TryIndex6
    GoTo EternaGym_TryIndex7
EternaGym_TryIndex0:
    GoToIfBadgeAcquired BADGE_ID_COAL, EternaGym_NextIndex
    GoTo EternaGym_WarpToIndex0
EternaGym_TryIndex1:
    GoToIfBadgeAcquired BADGE_ID_FOREST, EternaGym_NextIndex
    GoTo EternaGym_NextIndex
EternaGym_TryIndex2:
    GoToIfBadgeAcquired BADGE_ID_COBBLE, EternaGym_NextIndex
    GoTo EternaGym_WarpToIndex2
EternaGym_TryIndex3:
    GoToIfBadgeAcquired BADGE_ID_FEN, EternaGym_NextIndex
    GoTo EternaGym_WarpToIndex3
EternaGym_TryIndex4:
    GoToIfBadgeAcquired BADGE_ID_RELIC, EternaGym_NextIndex
    GoTo EternaGym_WarpToIndex4
EternaGym_TryIndex5:
    GoToIfBadgeAcquired BADGE_ID_MINE, EternaGym_NextIndex
    GoTo EternaGym_WarpToIndex5
EternaGym_TryIndex6:
    GoToIfBadgeAcquired BADGE_ID_ICICLE, EternaGym_NextIndex
    GoTo EternaGym_WarpToIndex6
EternaGym_TryIndex7:
    GoToIfBadgeAcquired BADGE_ID_BEACON, EternaGym_NextIndex
    GoTo EternaGym_WarpToIndex7
EternaGym_NextIndex:
    AddVar VAR_UNK_0x4111, 1
    GoToIfEq VAR_UNK_0x4111, 8, EternaGym_ResetIndex
    GoTo EternaGym_TryGym
EternaGym_ResetIndex:
    SetVar VAR_UNK_0x4111, 0
    GoTo EternaGym_TryGym
EternaGym_WarpToIndex0:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY_GYM, 0, 5, 22, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
EternaGym_WarpToIndex1:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY_GYM, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
EternaGym_WarpToIndex2:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY_GYM, 0, 12, 28, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
EternaGym_WarpToIndex3:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY_GYM, 0, 13, 40, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
EternaGym_WarpToIndex4:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY_GYM_LEADER_ROOM, 0, 4, 13, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
EternaGym_WarpToIndex5:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY_GYM, 0, 16, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
EternaGym_WarpToIndex6:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY_GYM, 0, 11, 26, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
EternaGym_WarpToIndex7:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_3, 0, 11, 25, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End
EternaGym_NoRedirect:
    End

EternaGym_InitFeatures:
    InitPersistedMapFeaturesForEternaGym
    End

EternaGym_GymGuide:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_FOREST, EternaGym_GymGuideAfterBadge
    Message EternaGym_Text_GymGuideBeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

EternaGym_GymGuideAfterBadge:
    BufferPlayerName 0
    Message EternaGym_Text_GymGuideAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

EternaGym_GymStatue:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    GoToIfBadgeAcquired BADGE_ID_FOREST, EternaGym_GymStatueAfterBadge
    BufferRivalName 0
    BufferRivalName 1
    Message EternaGym_Text_GymStatueBeforeBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

EternaGym_GymStatueAfterBadge:
    BufferRivalName 0
    BufferPlayerName 1
    BufferRivalName 2
    Message EternaGym_Text_GymStatueAfterBadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

EternaGym_Gardenia:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_FOREST, EternaGym_Gardenia_AlreadyHaveForestbadge
    CreateJournalEvent LOCATION_EVENT_GYM_WAS_TOO_TOUGH, 67, 0, 0, 0
    Message EternaGym_Text_GardeniaIntro
    CloseMessage
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 7, Gardenia_BattleB7
    GoToIfEq VAR_RESULT, 6, Gardenia_BattleB6
    GoToIfEq VAR_RESULT, 5, Gardenia_BattleB5
    GoToIfEq VAR_RESULT, 4, Gardenia_BattleB4
    GoToIfEq VAR_RESULT, 3, Gardenia_BattleB3
    GoToIfEq VAR_RESULT, 2, Gardenia_BattleB2
    GoToIfEq VAR_RESULT, 1, Gardenia_BattleB1
Gardenia_BattleB0:
    StartTrainerBattle TRAINER_LEADER_GARDENIA_B0
    GoTo Gardenia_BattleDone
Gardenia_BattleB1:
    StartTrainerBattle TRAINER_LEADER_GARDENIA_B1
    GoTo Gardenia_BattleDone
Gardenia_BattleB2:
    StartTrainerBattle TRAINER_LEADER_GARDENIA_B2
    GoTo Gardenia_BattleDone
Gardenia_BattleB3:
    StartTrainerBattle TRAINER_LEADER_GARDENIA_B3
    GoTo Gardenia_BattleDone
Gardenia_BattleB4:
    StartTrainerBattle TRAINER_LEADER_GARDENIA_B4
    GoTo Gardenia_BattleDone
Gardenia_BattleB5:
    StartTrainerBattle TRAINER_LEADER_GARDENIA_B5
    GoTo Gardenia_BattleDone
Gardenia_BattleB6:
    StartTrainerBattle TRAINER_LEADER_GARDENIA_B6
    GoTo Gardenia_BattleDone
Gardenia_BattleB7:
    StartTrainerBattle TRAINER_LEADER_GARDENIA_B7
    GoTo Gardenia_BattleDone
Gardenia_BattleDone:
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, EternaGym_LostBattle
    Message EternaGym_Text_BeatGardenia
    BufferPlayerName 0
    Message EternaGym_Text_GardeniaReceiveForestBadge
    PlaySound SEQ_BADGE
    WaitSound
    GiveBadge BADGE_ID_FOREST
    IncrementTrainerScore2 TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_AROMA_LADY_JENNA
    SetTrainerFlag TRAINER_AROMA_LADY_ANGELA
    SetTrainerFlag TRAINER_LASS_CAROLINE
    SetTrainerFlag TRAINER_BEAUTY_LINDSAY
    ClearFlag FLAG_UNK_0x01FC
    CreateJournalEvent LOCATION_EVENT_BEAT_GYM_LEADER, 67, TRAINER_LEADER_GARDENIA, 0, 0
    Message EternaGym_Text_GardeniaExplainForestBadge
    GoTo EternaGym_GardeniaGiveTM86
    End

EternaGym_GardeniaTryGiveTM86Again:
    SetVar VAR_0x8004, ITEM_TM86
    SetVar VAR_0x8005, 1
    GoToIfCannotFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT, EternaGym_GardeniaGiveTM86BagFullAgain
    Common_GiveItemQuantity
    SetFlag FLAG_OBTAINED_GARDENIA_TM86
    BufferItemName 0, VAR_0x8004
    BufferTMHMMoveName 1, VAR_0x8004
    Message EternaGym_Text_GardeniaExplainGrassKnot
    WaitABXPadPress
    CloseMessage
    GoTo EternaGym_PostWin
    End

EternaGym_GardeniaGiveTM86BagFullAgain:
    Common_MessageBagIsFull
    CloseMessage
    GoTo EternaGym_PostWin
    End

EternaGym_PostWin:
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 5, EternaGym_Badge5
    GoToIfEq VAR_RESULT, 6, EternaGym_Badge6
    GoToIfEq VAR_RESULT, 8, EternaGym_Badge8
    GoTo EternaGym_PostWin_End
EternaGym_Badge5:
    GoToIfSet FLAG_UNK_0x0FFC, EternaGym_PostWin_End
    SetFlag FLAG_UNK_0x0FFC
    Message 18
    WaitABXPadPress
    CloseMessage
    AddItem ITEM_HM01, 1, VAR_RESULT
    AddItem ITEM_HM02, 1, VAR_RESULT
    AddItem ITEM_HM03, 1, VAR_RESULT
    AddItem ITEM_HM04, 1, VAR_RESULT
    AddItem ITEM_HM08, 1, VAR_RESULT
    GoTo EternaGym_PostWin_End
EternaGym_Badge6:
    GoToIfSet FLAG_UNK_0x0FFD, EternaGym_PostWin_End
    SetFlag FLAG_UNK_0x0FFD
    SetFlag FLAG_FIRST_ARRIVAL_SNOWPOINT_CITY
    SetFlag FLAG_FIRST_ARRIVAL_SUNYSHORE_CITY
    GoTo EternaGym_PostWin_End
EternaGym_Badge8:
    GoToIfSet FLAG_UNK_0x0FFE, EternaGym_PostWin_End
    SetFlag FLAG_UNK_0x0FFE
    SetFlag FLAG_FIRST_ARRIVAL_OUTSIDE_VICTORY_ROAD
    SetFlag FLAG_FIRST_ARRIVAL_POKEMON_LEAGUE
EternaGym_PostWin_End:
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_EternaGym
    End

EternaGym_Gardenia_AlreadyHaveForestbadge:
    GoToIfUnset FLAG_OBTAINED_GARDENIA_TM86, EternaGym_GardeniaTryGiveTM86Again
    Message EternaGym_Text_GardeniaGymBeaten
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_EternaGym
    End

EternaGym_GardeniaGiveTM86:
    SetVar VAR_0x8004, ITEM_TM86
    SetVar VAR_0x8005, 1
    GoToIfCannotFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT, EternaGym_GardeniaGiveTM86BagFull
    Common_GiveItemQuantity
    SetFlag FLAG_OBTAINED_GARDENIA_TM86
    BufferItemName 0, VAR_0x8004
    BufferTMHMMoveName 1, VAR_0x8004
    Message EternaGym_Text_GardeniaExplainGrassKnot
    WaitABXPadPress
    CloseMessage
    AdvanceEternaGymClock
    GoTo EternaGym_PostWin
    End

EternaGym_GardeniaGiveTM86BagFull:
    Common_MessageBagIsFull
    CloseMessage
    AdvanceEternaGymClock
    GoTo EternaGym_PostWin
    End

EternaGym_LostBattle:
    BlackOutFromBattle
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_EternaGym
    End

EternaGym_LassCaroline:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfGe VAR_ETERNA_GYM_TRAINERS_BEATEN, 1, EternaGym_LassCarolineBeaten
    PlayTrainerEncounterBGM TRAINER_LASS_CAROLINE
    Message EternaGym_Text_LassCarolineBeforeBattle
    CloseMessage
    StartTrainerBattle TRAINER_LASS_CAROLINE
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, EternaGym_LostBattle
    Message EternaGym_Text_LassCarolineAfterBattle
    WaitABXPadPress
    SetVar VAR_ETERNA_GYM_TRAINERS_BEATEN, 1
    CloseMessage
    ReleaseAll
    AdvanceEternaGymClock
    End

EternaGym_LassCarolineBeaten:
    Message EternaGym_Text_LassCarolineAfterBattle
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_EternaGym
    End

EternaGym_AromaLadyJenna:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfGe VAR_ETERNA_GYM_TRAINERS_BEATEN, 2, EternaGym_AromaLadyJennaBeaten
    PlayTrainerEncounterBGM TRAINER_AROMA_LADY_JENNA
    SetVar VAR_0x8007, ETERNA_CITY_GYM_AROMA_LADY_JENNA
    Call EternaGym_LookTowardsPlayer
    Message EternaGym_Text_AromaLadyJennaBeforeBattle
    CloseMessage
    StartTrainerBattle TRAINER_AROMA_LADY_JENNA
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, EternaGym_LostBattle
    Message EternaGym_Text_AromaLadyJennaAfterBattle
    WaitABXPadPress
    SetVar VAR_ETERNA_GYM_TRAINERS_BEATEN, 2
    CloseMessage
    ReleaseAll
    AdvanceEternaGymClock
    End

EternaGym_AromaLadyJennaBeaten:
    Message EternaGym_Text_AromaLadyJennaAfterBattle
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

EternaGym_AromaLadyAngela:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfGe VAR_ETERNA_GYM_TRAINERS_BEATEN, 3, EternaGym_AromaLadyAngelaBeaten
    PlayTrainerEncounterBGM TRAINER_AROMA_LADY_ANGELA
    SetVar VAR_0x8007, ETERNA_CITY_GYM_AROMA_LADY_ANGELA
    Call EternaGym_LookTowardsPlayer
    Message EternaGym_Text_AromaLadyAngelaBeforeBattle
    CloseMessage
    StartTrainerBattle TRAINER_AROMA_LADY_ANGELA
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, EternaGym_LostBattle
    Message EternaGym_Text_AromaLadyAngelaAfterBattle
    WaitABXPadPress
    SetVar VAR_ETERNA_GYM_TRAINERS_BEATEN, 3
    CloseMessage
    ReleaseAll
    AdvanceEternaGymClock
    End

EternaGym_AromaLadyAngelaBeaten:
    Message EternaGym_Text_AromaLadyAngelaAfterBattle
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

EternaGym_LookTowardsPlayer:
    GetPlayerDir VAR_RESULT
    CallIfEq VAR_RESULT, DIR_NORTH, EternaGym_FaceSouth
    CallIfEq VAR_RESULT, DIR_SOUTH, EternaGym_FaceNorth
    CallIfEq VAR_RESULT, DIR_WEST, EternaGym_FaceEast
    CallIfEq VAR_RESULT, DIR_EAST, EternaGym_FaceWest
    Return

EternaGym_FaceSouth:
    SetObjectEventMovementType VAR_0x8007, MOVEMENT_TYPE_LOOK_SOUTH
    SetObjectEventDir VAR_0x8007, DIR_SOUTH
    Return

EternaGym_FaceNorth:
    SetObjectEventMovementType VAR_0x8007, MOVEMENT_TYPE_LOOK_NORTH
    SetObjectEventDir VAR_0x8007, DIR_NORTH
    Return

EternaGym_FaceEast:
    SetObjectEventMovementType VAR_0x8007, MOVEMENT_TYPE_LOOK_EAST
    SetObjectEventDir VAR_0x8007, DIR_EAST
    Return

EternaGym_FaceWest:
    SetObjectEventMovementType VAR_0x8007, MOVEMENT_TYPE_LOOK_WEST
    SetObjectEventDir VAR_0x8007, DIR_WEST
    Return

GymExit_TryLeave_EternaGym:
    GoToIfSet FLAG_UNK_0x0FFB, GymExit_Blocked_EternaGym
    GoTo RandomGym_ReturnToOriginCity_EternaGym
    End

GymExit_Blocked_EternaGym:
    LockAll
    Message 17
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

# GymExit_Text_MustDefeatLeader_EternaGym = index 17

RandomGym_ReturnToOriginCity_EternaGym:
    GoToIfEq VAR_UNK_0x4110, 0, ReturnTo_City0_EternaGym
    GoToIfEq VAR_UNK_0x4110, 1, ReturnTo_City1_EternaGym
    GoToIfEq VAR_UNK_0x4110, 2, ReturnTo_City2_EternaGym
    GoToIfEq VAR_UNK_0x4110, 3, ReturnTo_City3_EternaGym
    GoToIfEq VAR_UNK_0x4110, 4, ReturnTo_City4_EternaGym
    GoToIfEq VAR_UNK_0x4110, 5, ReturnTo_City5_EternaGym
    GoToIfEq VAR_UNK_0x4110, 6, ReturnTo_City6_EternaGym
    GoToIfEq VAR_UNK_0x4110, 7, ReturnTo_City7_EternaGym
    GoTo ReturnTo_City0_EternaGym

ReturnTo_City0_EternaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY, 0, 282, 758, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City1_EternaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY, 0, 312, 564, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City2_EternaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY, 0, 684, 613, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City3_EternaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY, 0, 591, 830, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City4_EternaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY, 0, 499, 699, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City5_EternaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY, 0, 39, 733, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City6_EternaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY, 0, 367, 224, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City7_EternaGym:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY, 0, 845, 749, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End


    .balign 4, 0
