#include "macros/scrcmd.inc"
#include "res/text/bank/sunyshore_city_gym_room_3.h"


    ScriptEntry SunyshoreGymRoom3_Init
    ScriptEntry SunyshoreGymRoom3_TopButtons
    ScriptEntry SunyshoreGymRoom3_BottomButtons
    ScriptEntry SunyshoreGymRoom3_Volkner
    ScriptEntryEnd

SunyshoreGymRoom3_Init:
    SetVar VAR_MAP_LOCAL_0, 0
    InitPersistedMapFeaturesForSunyshoreGym 2
    End

SunyshoreGymRoom3_TopButtons:
    SunyshoreGymButton 0
    End

SunyshoreGymRoom3_BottomButtons:
    SunyshoreGymButton 2
    End

SunyshoreGymRoom3_Volkner:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_BEACON, SunyshoreGymRoom3_VolknerAlreadyHaveBeaconBadge
    CreateJournalEvent LOCATION_EVENT_GYM_WAS_TOO_TOUGH, 156, 0, 0, 0
    Message SunyshoreGymRoom3_Text_VolknerIntro
    CloseMessage
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 7, Volkner_BattleB7
    GoToIfEq VAR_RESULT, 6, Volkner_BattleB6
    GoToIfEq VAR_RESULT, 5, Volkner_BattleB5
    GoToIfEq VAR_RESULT, 4, Volkner_BattleB4
    GoToIfEq VAR_RESULT, 3, Volkner_BattleB3
    GoToIfEq VAR_RESULT, 2, Volkner_BattleB2
    GoToIfEq VAR_RESULT, 1, Volkner_BattleB1
Volkner_BattleB0:
    StartTrainerBattle TRAINER_LEADER_VOLKNER_B0
    GoTo Volkner_BattleDone
Volkner_BattleB1:
    StartTrainerBattle TRAINER_LEADER_VOLKNER_B1
    GoTo Volkner_BattleDone
Volkner_BattleB2:
    StartTrainerBattle TRAINER_LEADER_VOLKNER_B2
    GoTo Volkner_BattleDone
Volkner_BattleB3:
    StartTrainerBattle TRAINER_LEADER_VOLKNER_B3
    GoTo Volkner_BattleDone
Volkner_BattleB4:
    StartTrainerBattle TRAINER_LEADER_VOLKNER_B4
    GoTo Volkner_BattleDone
Volkner_BattleB5:
    StartTrainerBattle TRAINER_LEADER_VOLKNER_B5
    GoTo Volkner_BattleDone
Volkner_BattleB6:
    StartTrainerBattle TRAINER_LEADER_VOLKNER_B6
    GoTo Volkner_BattleDone
Volkner_BattleB7:
    StartTrainerBattle TRAINER_LEADER_VOLKNER_B7
    GoTo Volkner_BattleDone
Volkner_BattleDone:
    CheckWonBattle VAR_RESULT
    GoToIfEq VAR_RESULT, FALSE, SunyshoreGymRoom3_LostBattle
    Message SunyshoreGymRoom3_Text_BeatVolkner
    BufferPlayerName 0
    Message SunyshoreGymRoom3_Text_VolknerReceiveBeaconBadge
    PlaySound SEQ_BADGE
    WaitSound
    GiveBadge BADGE_ID_BEACON
    IncrementTrainerScore2 TRAINER_SCORE_EVENT_BADGE_EARNED
    SetTrainerFlag TRAINER_ACE_TRAINER_ZACHERY
    SetTrainerFlag TRAINER_ACE_TRAINER_DESTINY
    SetTrainerFlag TRAINER_GUITARIST_JERRY
    SetTrainerFlag TRAINER_GUITARIST_PRESTON
    SetTrainerFlag TRAINER_GUITARIST_LONNIE
    SetTrainerFlag TRAINER_POKE_KID_MEGHAN
    SetTrainerFlag TRAINER_SCHOOL_KID_FORREST
    SetTrainerFlag TRAINER_SCHOOL_KID_TIERA
    SetVar VAR_SUNYSHORE_STATE, 2
    // BUG: TRAINER_LEADER_ROARK should be TRAINER_LEADER_VOLKNER
    CreateJournalEvent LOCATION_EVENT_BEAT_GYM_LEADER, 156, TRAINER_LEADER_ROARK, 0, 0
    Message SunyshoreGymRoom3_Text_VolknerExplainBeaconBadge
    GoTo SunyshoreGymRoom3_VolknerTryGiveTM57

SunyshoreGymRoom3_VolknerTryGiveTM57:
    SetVar VAR_0x8004, ITEM_TM57
    SetVar VAR_0x8005, 1
    GoToIfCannotFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT, SunyshoreGymRoom3_VolknerCannotGiveTM57
    Common_GiveItemQuantity
    SetFlag FLAG_OBTAINED_VOLKNER_TM57
    BufferItemName 0, VAR_0x8004
    BufferTMHMMoveName 1, VAR_0x8004
    Message SunyshoreGymRoom3_Text_VolknerExplainTM57
    WaitABXPadPress
    CloseMessage
    GoTo SunyshoreGymRoom3_PostWin
    End

SunyshoreGymRoom3_VolknerCannotGiveTM57:
    Common_MessageBagIsFull
    CloseMessage
    GoTo SunyshoreGymRoom3_PostWin
    End

SunyshoreGymRoom3_PostWin:
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 5, SunyshoreGymRoom3_Badge5
    GoToIfEq VAR_RESULT, 6, SunyshoreGymRoom3_Badge6
    GoToIfEq VAR_RESULT, 8, SunyshoreGymRoom3_Badge8
    GoTo SunyshoreGymRoom3_PostWin_End
SunyshoreGymRoom3_Badge5:
    GoToIfSet FLAG_UNK_0x0FFC, SunyshoreGymRoom3_PostWin_End
    SetFlag FLAG_UNK_0x0FFC
    Message 6
    WaitABXPadPress
    CloseMessage
    AddItem ITEM_HM01, 1, VAR_RESULT
    AddItem ITEM_HM02, 1, VAR_RESULT
    AddItem ITEM_HM03, 1, VAR_RESULT
    AddItem ITEM_HM04, 1, VAR_RESULT
    AddItem ITEM_HM08, 1, VAR_RESULT
    GoTo SunyshoreGymRoom3_PostWin_End
SunyshoreGymRoom3_Badge6:
    GoToIfSet FLAG_UNK_0x0FFD, SunyshoreGymRoom3_PostWin_End
    SetFlag FLAG_UNK_0x0FFD
    SetFlag FLAG_FIRST_ARRIVAL_SNOWPOINT_CITY
    SetFlag FLAG_FIRST_ARRIVAL_SUNYSHORE_CITY
    GoTo SunyshoreGymRoom3_PostWin_End
SunyshoreGymRoom3_Badge8:
    GoToIfSet FLAG_UNK_0x0FFE, SunyshoreGymRoom3_PostWin_End
    SetFlag FLAG_UNK_0x0FFE
    SetFlag FLAG_FIRST_ARRIVAL_OUTSIDE_VICTORY_ROAD
    SetFlag FLAG_FIRST_ARRIVAL_POKEMON_LEAGUE
SunyshoreGymRoom3_PostWin_End:
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_SunyshorGymRoom3
    End

SunyshoreGymRoom3_VolknerAlreadyHaveBeaconBadge:
    GoToIfUnset FLAG_OBTAINED_VOLKNER_TM57, SunyshoreGymRoom3_VolknerTryGiveTM57
    Message SunyshoreGymRoom3_Text_Afterbadge
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    ClearFlag FLAG_UNK_0x0FFB
    GoTo RandomGym_ReturnToOriginCity_SunyshorGymRoom3
    End

SunyshoreGymRoom3_LostBattle:
    BlackOutFromBattle
    ReleaseAll
    End

RandomGym_ReturnToOriginCity_SunyshorGymRoom3:
    GoToIfEq VAR_UNK_0x4110, 0, ReturnTo_City0_SunyshorGymRoom3
    GoToIfEq VAR_UNK_0x4110, 1, ReturnTo_City1_SunyshorGymRoom3
    GoToIfEq VAR_UNK_0x4110, 2, ReturnTo_City2_SunyshorGymRoom3
    GoToIfEq VAR_UNK_0x4110, 3, ReturnTo_City3_SunyshorGymRoom3
    GoToIfEq VAR_UNK_0x4110, 4, ReturnTo_City4_SunyshorGymRoom3
    GoToIfEq VAR_UNK_0x4110, 5, ReturnTo_City5_SunyshorGymRoom3
    GoToIfEq VAR_UNK_0x4110, 6, ReturnTo_City6_SunyshorGymRoom3
    GoToIfEq VAR_UNK_0x4110, 7, ReturnTo_City7_SunyshorGymRoom3
    GoTo ReturnTo_City0_SunyshorGymRoom3

ReturnTo_City0_SunyshorGymRoom3:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY, 0, 282, 758, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City1_SunyshorGymRoom3:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY, 0, 312, 564, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City2_SunyshorGymRoom3:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY, 0, 684, 613, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City3_SunyshorGymRoom3:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY, 0, 591, 830, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City4_SunyshorGymRoom3:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY, 0, 499, 699, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City5_SunyshorGymRoom3:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY, 0, 39, 733, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City6_SunyshorGymRoom3:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY, 0, 367, 224, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End

ReturnTo_City7_SunyshorGymRoom3:
    WaitFadeScreen
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY, 0, 845, 749, DIR_SOUTH
    FadeScreenIn
    WaitFadeScreen
    End


    .balign 4, 0
