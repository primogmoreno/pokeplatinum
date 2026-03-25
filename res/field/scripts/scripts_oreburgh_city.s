#include "macros/scrcmd.inc"
#include "res/text/bank/oreburgh_city.h"
#include "res/field/events/events_oreburgh_city.h"

    ScriptEntry OreburghCity_Rival
    ScriptEntry OreburghCity_Youngster
    ScriptEntry OreburghCity_TriggerYoungster
    ScriptEntry OreburghCity_TriggerRival
    ScriptEntry OreburghCity_Hiker
    ScriptEntry OreburghCity_Worker1
    ScriptEntry OreburghCity_Worker2
    ScriptEntry OreburghCity_Worker3
    ScriptEntry OreburghCity_Worker4
    ScriptEntry OreburghCity_BattleGirl1
    ScriptEntry OreburghCity_SchoolKidF
    ScriptEntry OreburghCity_Guitarist
    ScriptEntry OreburghCity_PokefanF
    ScriptEntry OreburghCity_Camper
    ScriptEntry OreburghCity_MapSign
    ScriptEntry OreburghCity_GymSignpost
    ScriptEntry OreburghCity_ScrollingSignOreburghMiningMuseum
    ScriptEntry OreburghCity_ScrollingSignOreburghMine
    ScriptEntry OreburghCity_Machop1
    ScriptEntry OreburghCity_BattleGirl2
    ScriptEntry OreburghCity_Machop3
    ScriptEntry OreburghCity_Machop2
    ScriptEntry RandomGym_Enter_0_OreburghCity
    ScriptEntryEnd

OreburghCity_Rival:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfSet FLAG_TALKED_TO_OREBURGH_CITY_RIVAL, OreburghCity_IToldYouTheGymLeaderWentDownToTheOreburghMine
    BufferRivalName 0
    BufferPlayerName 1
    Message OreburghCity_Text_TheGymLeadersGoneOffToTheCoalMine
    WaitABXPadPress
    SetFlag FLAG_TALKED_TO_OREBURGH_CITY_RIVAL
    CloseMessage
    ReleaseAll
    End

OreburghCity_IToldYouTheGymLeaderWentDownToTheOreburghMine:
    BufferRivalName 0
    Message OreburghCity_Text_IToldYouTheGymLeaderWentDownToTheOreburghMine
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_Youngster:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfBadgeAcquired BADGE_ID_COAL, OreburghCity_CanISeeYourTrainerCase
    GoToIfSet FLAG_ROARK_RETURNED_TO_OREBURGH_GYM, OreburghCity_TheGymLeadersWaitingForYou
    Message OreburghCity_Text_IsThatGuyInFrontOfTheGymYourFriend
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_CanISeeYourTrainerCase:
    Message OreburghCity_Text_CanISeeYourTrainerCase
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_TheGymLeadersWaitingForYou:
    Message OreburghCity_Text_TheGymLeadersWaitingForYou
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_TriggerRival:
    LockAll
    ClearFlag FLAG_HIDE_OREBURGH_CITY_RIVAL
    SetObjectEventMovementType LOCALID_RIVAL, MOVEMENT_TYPE_LOOK_WEST
    SetObjectEventDir LOCALID_RIVAL, DIR_WEST
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    GoToIfEq VAR_0x8005, 748, OreburghCity_RivalRunIntoPlayerZ748
    GoToIfEq VAR_0x8005, 749, OreburghCity_RivalRunIntoPlayerZ749
    GoToIfEq VAR_0x8005, 750, OreburghCity_RivalRunIntoPlayerZ750
    GoTo OreburghCity_RivalRunIntoPlayerZ751
    End

OreburghCity_RivalRunIntoPlayerZ748:
    SetObjectEventPos LOCALID_RIVAL, 271, 748
    AddObject LOCALID_RIVAL
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerGetPushedByRival
    ApplyMovement LOCALID_RIVAL, OreburghCity_Movement_RivalRunIntoPlayer
    WaitMovement
    GoTo OreburghCity_NextStopTheEternaGymBadge
    End

OreburghCity_RivalRunIntoPlayerZ749:
    SetObjectEventPos LOCALID_RIVAL, 271, 749
    AddObject LOCALID_RIVAL
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerGetPushedByRival
    ApplyMovement LOCALID_RIVAL, OreburghCity_Movement_RivalRunIntoPlayer
    WaitMovement
    GoTo OreburghCity_NextStopTheEternaGymBadge
    End

OreburghCity_RivalRunIntoPlayerZ750:
    SetObjectEventPos LOCALID_RIVAL, 271, 750
    AddObject LOCALID_RIVAL
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerGetPushedByRival
    ApplyMovement LOCALID_RIVAL, OreburghCity_Movement_RivalRunIntoPlayer
    WaitMovement
    GoTo OreburghCity_NextStopTheEternaGymBadge
    End

OreburghCity_RivalRunIntoPlayerZ751:
    SetObjectEventPos LOCALID_RIVAL, 271, 751
    AddObject LOCALID_RIVAL
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerGetPushedByRival
    ApplyMovement LOCALID_RIVAL, OreburghCity_Movement_RivalRunIntoPlayer
    WaitMovement
    GoTo OreburghCity_NextStopTheEternaGymBadge
    End

OreburghCity_NextStopTheEternaGymBadge:
    PlayFanfare SEQ_SE_DP_WALL_HIT2
    Message OreburghCity_Text_BigThud
    CloseMessage
    Common_SetRivalBGM
    BufferRivalName 0
    BufferPlayerName 1
    Message OreburghCity_Text_EternaCityIsTheNextPlaceWithAGymThatGivesAwayBadgesRight
    CloseMessage
    ApplyMovement LOCALID_RIVAL, OreburghCity_Movement_RivalWalkOnSpotEast
    WaitMovement
    Message OreburghCity_Text_IWentToRoute207ButYouCantGoThereWithoutABicycle
    ApplyMovement LOCALID_RIVAL, OreburghCity_Movement_RivalWalkOnSpotWest
    WaitMovement
    Message OreburghCity_Text_NextStopTheEternaGymBadge
    CloseMessage
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    GoToIfEq VAR_0x8005, 748, OreburghCity_RivalLeaveZ748
    GoToIfEq VAR_0x8005, 749, OreburghCity_RivalLeaveZ749
    GoToIfEq VAR_0x8005, 750, OreburghCity_RivalLeaveZ750
    GoTo OreburghCity_RivalLeaveZ751
    End

OreburghCity_RivalLeaveZ748:
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerWatchRivalLeaveZ748
    ApplyMovement LOCALID_RIVAL, OreburghCity_Movement_RivalLeaveZ748
    WaitMovement
    GoTo OreburghCity_RemoveRival
    End

OreburghCity_RivalLeaveZ749:
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerWatchRivalLeaveZ749
    ApplyMovement LOCALID_RIVAL, OreburghCity_Movement_RivalLeaveZ749
    WaitMovement
    GoTo OreburghCity_RemoveRival
    End

OreburghCity_RivalLeaveZ750:
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerWatchRivalLeaveZ750
    ApplyMovement LOCALID_RIVAL, OreburghCity_Movement_RivalLeaveZ750
    WaitMovement
    GoTo OreburghCity_RemoveRival
    End

OreburghCity_RivalLeaveZ751:
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerWatchRivalLeaveZ751
    ApplyMovement LOCALID_RIVAL, OreburghCity_Movement_RivalLeaveZ751
    WaitMovement
    GoTo OreburghCity_RemoveRival
    End

OreburghCity_RemoveRival:
    PlayFanfare SEQ_SE_DP_KAIDAN2
    RemoveObject LOCALID_RIVAL
    Common_FadeToDefaultMusic2
    SetVar VAR_OREBURGH_STATE, 3
    ReleaseAll
    End


RandomGym_Enter_0_OreburghCity:
    GoToIfSet FLAG_UNK_0x0FF3, RandomGym_PortalUsed_OreburghCity
    SetFlag FLAG_UNK_0x0FF3
    SetVar VAR_UNK_0x4110, 0
    GoTo RandomGym_PickAndWarp_OreburghCity

RandomGym_PortalUsed_OreburghCity:
    LockAll
    Message 31
    WaitABXPadPress
    CloseMessage
    ApplyMovement LOCALID_PLAYER, RandomGym_PushSouth_OreburghCity
    WaitMovement
    ReleaseAll
    End

RandomGym_PickAndWarp_OreburghCity:
    CountBadgesAcquired VAR_RESULT
    GoToIfEq VAR_RESULT, 8, RandomGym_AllBeaten_OreburghCity
    GetRandom VAR_UNK_0x4111, 8

RandomGym_FindUnbeaten_OreburghCity:
    GoToIfEq VAR_UNK_0x4111, 0, RandomGym_Check0_OreburghCity
    GoToIfEq VAR_UNK_0x4111, 1, RandomGym_Check1_OreburghCity
    GoToIfEq VAR_UNK_0x4111, 2, RandomGym_Check2_OreburghCity
    GoToIfEq VAR_UNK_0x4111, 3, RandomGym_Check3_OreburghCity
    GoToIfEq VAR_UNK_0x4111, 4, RandomGym_Check4_OreburghCity
    GoToIfEq VAR_UNK_0x4111, 5, RandomGym_Check5_OreburghCity
    GoToIfEq VAR_UNK_0x4111, 6, RandomGym_Check6_OreburghCity
    GoToIfEq VAR_UNK_0x4111, 7, RandomGym_Check7_OreburghCity
    GoTo RandomGym_TryNext_OreburghCity

RandomGym_Check0_OreburghCity:
    GoToIfBadgeAcquired BADGE_ID_COAL, RandomGym_TryNext_OreburghCity
    GoTo RandomGym_WarpToGym0_OreburghCity

RandomGym_Check1_OreburghCity:
    GoToIfBadgeAcquired BADGE_ID_FOREST, RandomGym_TryNext_OreburghCity
    GoTo RandomGym_WarpToGym1_OreburghCity

RandomGym_Check2_OreburghCity:
    GoToIfBadgeAcquired BADGE_ID_COBBLE, RandomGym_TryNext_OreburghCity
    GoTo RandomGym_WarpToGym2_OreburghCity

RandomGym_Check3_OreburghCity:
    GoToIfBadgeAcquired BADGE_ID_FEN, RandomGym_TryNext_OreburghCity
    GoTo RandomGym_WarpToGym3_OreburghCity

RandomGym_Check4_OreburghCity:
    GoToIfBadgeAcquired BADGE_ID_RELIC, RandomGym_TryNext_OreburghCity
    GoTo RandomGym_WarpToGym4_OreburghCity

RandomGym_Check5_OreburghCity:
    GoToIfBadgeAcquired BADGE_ID_MINE, RandomGym_TryNext_OreburghCity
    GoTo RandomGym_WarpToGym5_OreburghCity

RandomGym_Check6_OreburghCity:
    GoToIfBadgeAcquired BADGE_ID_ICICLE, RandomGym_TryNext_OreburghCity
    GoTo RandomGym_WarpToGym6_OreburghCity

RandomGym_Check7_OreburghCity:
    GoToIfBadgeAcquired BADGE_ID_BEACON, RandomGym_TryNext_OreburghCity
    GoTo RandomGym_WarpToGym7_OreburghCity

RandomGym_TryNext_OreburghCity:
    AddVar VAR_UNK_0x4111, 1
    GoToIfEq VAR_UNK_0x4111, 8, RandomGym_ResetRoll_OreburghCity
    GoTo RandomGym_FindUnbeaten_OreburghCity
RandomGym_ResetRoll_OreburghCity:
    SetVar VAR_UNK_0x4111, 0
    GoTo RandomGym_FindUnbeaten_OreburghCity

RandomGym_WarpToGym0_OreburghCity:
    SetFlag FLAG_UNK_0x0FFB
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY_GYM, 0, 5, 23, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End

RandomGym_WarpToGym1_OreburghCity:
    SetFlag FLAG_UNK_0x0FFB
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_ETERNA_CITY_GYM, 0, 11, 26, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End

RandomGym_WarpToGym2_OreburghCity:
    SetFlag FLAG_UNK_0x0FFB
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_VEILSTONE_CITY_GYM, 0, 12, 29, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End

RandomGym_WarpToGym3_OreburghCity:
    SetFlag FLAG_UNK_0x0FFB
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_PASTORIA_CITY_GYM, 0, 13, 41, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End

RandomGym_WarpToGym4_OreburghCity:
    SetFlag FLAG_UNK_0x0FFB
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_HEARTHOME_CITY_GYM_LEADER_ROOM, 0, 4, 12, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End

RandomGym_WarpToGym5_OreburghCity:
    SetFlag FLAG_UNK_0x0FFB
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_CANALAVE_CITY_GYM, 0, 16, 26, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End

RandomGym_WarpToGym6_OreburghCity:
    SetFlag FLAG_UNK_0x0FFB
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SNOWPOINT_CITY_GYM, 0, 11, 27, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End

RandomGym_WarpToGym7_OreburghCity:
    SetFlag FLAG_UNK_0x0FFB
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_3, 0, 11, 24, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End

RandomGym_AllBeaten_OreburghCity:
    FadeScreenOut
    WaitFadeScreen
    Warp MAP_HEADER_OREBURGH_CITY_GYM, 0, 5, 23, DIR_NORTH
    FadeScreenIn
    WaitFadeScreen
    End

    .balign 4, 0
OreburghCity_Movement_PlayerGetPushedByRival:
    Delay4 7
    LockDir
    WalkFastWest
    UnlockDir
    FaceEast
    EndMovement

    .balign 4, 0
OreburghCity_Movement_RivalRunIntoPlayer:
    WalkFastWest 9
    EndMovement

    .balign 4, 0
OreburghCity_Movement_RivalLeaveZ748:
    WalkFastSouth
    WalkFastWest 4
    WalkOnSpotFastWest
    EndMovement

    .balign 4, 0
OreburghCity_Movement_RivalLeaveZ749:
    WalkFastSouth
    WalkFastWest 3
    WalkFastNorth
    WalkFastWest
    WalkOnSpotFastWest
    EndMovement

    .balign 4, 0
OreburghCity_Movement_RivalLeaveZ750:
    WalkFastNorth
    WalkFastWest 4
    WalkOnSpotFastWest
    EndMovement

    .balign 4, 0
OreburghCity_Movement_RivalLeaveZ751:
    WalkFastNorth
    WalkFastWest 3
    WalkFastNorth
    WalkFastWest
    WalkOnSpotFastWest
    EndMovement

    .balign 4, 0
OreburghCity_Movement_PlayerWatchRivalLeaveZ748:
    WalkOnSpotNormalSouth
    WalkOnSpotNormalWest
    EndMovement

    .balign 4, 0
OreburghCity_Movement_PlayerWatchRivalLeaveZ749:
    WalkOnSpotNormalSouth
    WalkOnSpotNormalWest
    EndMovement

    .balign 4, 0
OreburghCity_Movement_PlayerWatchRivalLeaveZ750:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    EndMovement

    .balign 4, 0
OreburghCity_Movement_PlayerWatchRivalLeaveZ751:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    EndMovement

    .balign 4, 0
OreburghCity_Movement_RivalWalkOnSpotEast:
    WalkOnSpotNormalEast
    EndMovement

    .balign 4, 0
OreburghCity_Movement_RivalWalkOnSpotWest:
    WalkOnSpotNormalWest
    EndMovement

OreburghCity_Hiker:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    Message OreburghCity_Text_UpAheadTheresAHugeMountainThatTowersAboveEverything
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_Worker1:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    Message OreburghCity_Text_TheseVentsExchangeTheHotAirDownBelowWithTheFreshAirOutside
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_Worker2:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfSet FLAG_RECEIVED_OREBURGH_CITY_SUPER_POTION, OreburghCity_FeelingHaleAndHeartyPutsASmileOnMyFace
    Message OreburghCity_Text_HereTakeOneOfThese
    SetVar VAR_0x8004, ITEM_SUPER_POTION
    SetVar VAR_0x8005, 1
    GoToIfCannotFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT, OreburghCity_BagIsFull
    Common_GiveItemQuantity
    SetFlag FLAG_RECEIVED_OREBURGH_CITY_SUPER_POTION
    GoTo OreburghCity_FeelingHaleAndHeartyPutsASmileOnMyFace
    End

OreburghCity_FeelingHaleAndHeartyPutsASmileOnMyFace:
    Message OreburghCity_Text_FeelingHaleAndHeartyPutsASmileOnMyFace
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_BagIsFull:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End

OreburghCity_Worker3:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    Message OreburghCity_Text_ThisPileOfDirtySandIsCalledASlagHeap
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_Worker4:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    Message OreburghCity_Text_ChopChopMachopChopChopAwayOnRocks
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_TriggerYoungster:
    LockAll
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    GoToIfEq VAR_0x8005, 748, OreburghCity_YoungsterWalkToPlayerZ748
    GoToIfEq VAR_0x8005, 749, OreburghCity_YoungsterWalkToPlayerZ749
    GoToIfEq VAR_0x8005, 750, OreburghCity_YoungsterWalkToPlayerZ750
    GoTo OreburghCity_YoungsterWalkToPlayerZ751
    End

OreburghCity_YoungsterWalkToPlayerZ748:
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerWalkOnSpotSouth
    ApplyMovement LOCALID_YOUNGSTER, OreburghCity_Movement_YoungsterWalkToPlayerZ748
    WaitMovement
    GoTo OreburghCity_IllTakeYouToThePokemonGym
    End

OreburghCity_YoungsterWalkToPlayerZ749:
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerWalkOnSpotSouth
    ApplyMovement LOCALID_YOUNGSTER, OreburghCity_Movement_YoungsterWalkToPlayerZ749
    WaitMovement
    GoTo OreburghCity_IllTakeYouToThePokemonGym
    End

OreburghCity_YoungsterWalkToPlayerZ750:
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerWalkOnSpotSouth
    ApplyMovement LOCALID_YOUNGSTER, OreburghCity_Movement_YoungsterWalkToPlayerZ750
    WaitMovement
    GoTo OreburghCity_IllTakeYouToThePokemonGym
    End

OreburghCity_YoungsterWalkToPlayerZ751:
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerWalkOnSpotSouth
    ApplyMovement LOCALID_YOUNGSTER, OreburghCity_Movement_YoungsterWalkToPlayerZ751
    WaitMovement
    GoTo OreburghCity_IllTakeYouToThePokemonGym
    End

OreburghCity_IllTakeYouToThePokemonGym:
    Message OreburghCity_Text_IllTakeYouToThePokemonGym
    CloseMessage
    Common_SetFollowMeBGM
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    GoToIfEq VAR_0x8005, 748, OreburghCity_WalkWithYoungsterToTheGymZ748
    GoToIfEq VAR_0x8005, 749, OreburghCity_WalkWithYoungsterToTheGymZ749
    GoToIfEq VAR_0x8005, 750, OreburghCity_WalkWithYoungsterToTheGymZ750
    GoToIfEq VAR_0x8005, 751, OreburghCity_WalkWithYoungsterToTheGymZ751
    End

OreburghCity_WalkWithYoungsterToTheGymZ748:
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerWalkToTheGymZ748
    ApplyMovement LOCALID_YOUNGSTER, OreburghCity_Movement_YoungsterWalkToTheGymZ748
    WaitMovement
    GoTo OreburghCity_HuhTheresSomeoneThere
    End

OreburghCity_WalkWithYoungsterToTheGymZ749:
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerWalkToTheGymZ749
    ApplyMovement LOCALID_YOUNGSTER, OreburghCity_Movement_YoungsterWalkToTheGymZ749
    WaitMovement
    GoTo OreburghCity_HuhTheresSomeoneThere
    End

OreburghCity_WalkWithYoungsterToTheGymZ750:
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerWalkToTheGymZ750
    ApplyMovement LOCALID_YOUNGSTER, OreburghCity_Movement_YoungsterWalkToTheGymZ750
    WaitMovement
    GoTo OreburghCity_HuhTheresSomeoneThere
    End

OreburghCity_WalkWithYoungsterToTheGymZ751:
    ApplyMovement LOCALID_PLAYER, OreburghCity_Movement_PlayerWalkToTheGymZ751
    ApplyMovement LOCALID_YOUNGSTER, OreburghCity_Movement_YoungsterWalkToTheGymZ751
    WaitMovement
    GoTo OreburghCity_HuhTheresSomeoneThere
    End

OreburghCity_HuhTheresSomeoneThere:
    Message OreburghCity_Text_HuhTheresSomeoneThere
    WaitABXPadPress
    CloseMessage
    Common_FadeToDefaultMusic3
    SetVar VAR_OREBURGH_STATE, 1
    ReleaseAll
    End

    .balign 4, 0
OreburghCity_Movement_PlayerWalkOnSpotSouth:
    WalkOnSpotNormalSouth
    EndMovement

    .balign 4, 0
OreburghCity_Movement_PlayerWalkToTheGymZ748:
    WalkNormalSouth
    WalkNormalEast
    WalkNormalSouth 10
    WalkNormalEast 12
    EndMovement

    .balign 4, 0
OreburghCity_Movement_PlayerWalkToTheGymZ749:
    WalkNormalSouth
    WalkNormalEast
    WalkNormalSouth 9
    WalkNormalEast 12
    EndMovement

    .balign 4, 0
OreburghCity_Movement_PlayerWalkToTheGymZ750:
    WalkNormalSouth
    WalkNormalEast
    WalkNormalSouth 8
    WalkNormalEast 12
    EndMovement

    .balign 4, 0
OreburghCity_Movement_PlayerWalkToTheGymZ751:
    WalkNormalSouth
    WalkNormalEast
    WalkNormalSouth 7
    WalkNormalEast 12
    EndMovement

    .balign 4, 0
OreburghCity_Movement_YoungsterWalkToTheGymZ748:
    WalkNormalEast
    WalkNormalSouth 10
    WalkNormalEast 13
    WalkOnSpotNormalWest
    EndMovement

    .balign 4, 0
OreburghCity_Movement_YoungsterWalkToTheGymZ749:
    WalkNormalEast
    WalkNormalSouth 9
    WalkNormalEast 13
    WalkOnSpotNormalWest
    EndMovement

    .balign 4, 0
OreburghCity_Movement_YoungsterWalkToTheGymZ750:
    WalkNormalEast
    WalkNormalSouth 8
    WalkNormalEast 13
    WalkOnSpotNormalWest
    EndMovement

    .balign 4, 0
OreburghCity_Movement_YoungsterWalkToTheGymZ751:
    WalkNormalEast
    WalkNormalSouth 7
    WalkNormalEast 13
    WalkOnSpotNormalWest
    EndMovement

    .balign 4, 0
OreburghCity_Movement_YoungsterWalkToPlayerZ748:
    EmoteExclamationMark
    WalkNormalNorth 3
    EndMovement

    .balign 4, 0
OreburghCity_Movement_YoungsterWalkToPlayerZ749:
    EmoteExclamationMark
    WalkNormalNorth 2
    EndMovement

    .balign 4, 0
OreburghCity_Movement_YoungsterWalkToPlayerZ750:
    EmoteExclamationMark
    WalkNormalNorth
    EndMovement

    .balign 4, 0
OreburghCity_Movement_YoungsterWalkToPlayerZ751:
    EmoteExclamationMark
    WalkOnSpotNormalNorth
    EndMovement

OreburghCity_BattleGirl1:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    Message OreburghCity_Text_TMsAreSingleUseOnlyButHMsCanBeUsedOverAndOver
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_SchoolKidF:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    GoToIfSet FLAG_ROARK_RETURNED_TO_OREBURGH_GYM, OreburghCity_TheGymLeaderIsYoungButHesTheMinesSafetySupervisor
    Message OreburghCity_Text_TheGymLeaderWentOffToWorkInTheMine
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_TheGymLeaderIsYoungButHesTheMinesSafetySupervisor:
    Message OreburghCity_Text_TheGymLeaderIsYoungButHesTheMinesSafetySupervisor
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_Guitarist:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    Message OreburghCity_Text_HaveYouSeenTheVents
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_PokefanF:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    Message OreburghCity_Text_EveryonesProudOfTheMine
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_Camper:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    Message OreburghCity_Text_WhenIRunAroundWithMyRunningShoesOnImTheCenterOfAttention
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_MapSign:
    ShowMapSign OreburghCity_Text_MapSign
    End

OreburghCity_GymSignpost:
    ShowScrollingSign OreburghCity_Text_OreburgCityPokemonGymCallMeRoarkTheRock
    End

OreburghCity_ScrollingSignOreburghMiningMuseum:
    ShowLandmarkSign OreburghCity_Text_OreburghMiningMuseumCoalMiningAndYou
    End

OreburghCity_ScrollingSignOreburghMine:
    ShowLandmarkSign OreburghCity_Text_OreburghMineBewareOfBusyPokemon
    End

OreburghCity_Machop1:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    WaitFanfare SEQ_SE_CONFIRM
    PlayCry SPECIES_MACHOP
    Message OreburghCity_Text_MachopMachoChopo
    WaitCry
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_BattleGirl2:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    Message OreburghCity_Text_ThatsWhatFossilsAre
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_Machop3:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    WaitFanfare SEQ_SE_CONFIRM
    PlayCry SPECIES_MACHOP
    Message OreburghCity_Text_MachopPigyooh
    WaitCry
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

OreburghCity_Machop2:
    PlayFanfare SEQ_SE_CONFIRM
    LockAll
    FacePlayer
    WaitFanfare SEQ_SE_CONFIRM
    PlayCry SPECIES_MACHOP
    Message OreburghCity_Text_MachopGwoohGogogooh
    WaitCry
    WaitABXPadPress
    CloseMessage
    ReleaseAll
    End

    .balign 4, 0

    .balign 4, 0
RandomGym_PushSouth_OreburghCity:
    WalkNormalSouth
    EndMovement
