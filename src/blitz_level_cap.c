#include "blitz_level_cap.h"

#include "save_player.h"
#include "trainer_info.h"

// Level caps indexed by badge count (0–8 badges).
// Badge 0 = no badges (before Roark), badge 8 = all 8 badges (E4 + Cynthia).
static const u8 sBlitzLevelCaps[] = {
    15, // 0 badges (before Coal Badge)
    23, // 1 badge  (Coal — Roark)
    29, // 2 badges (Forest — Gardenia)
    35, // 3 badges (Cobble — Maylene)
    40, // 4 badges (Fen — Wake)
    45, // 5 badges (Relic — Fantina)
    52, // 6 badges (Mine — Byron)
    58, // 7 badges (Icicle — Candice)
    62, // 8 badges (Beacon — Volkner / E4 entry)
};

u8 BlitzLevelCap_GetCurrent(SaveData *saveData)
{
    TrainerInfo *info = SaveData_GetTrainerInfo(saveData);
    int badges = TrainerInfo_BadgeCount(info);

    if (badges < 0) {
        badges = 0;
    }
    if (badges >= (int)(sizeof(sBlitzLevelCaps) / sizeof(sBlitzLevelCaps[0]))) {
        badges = (int)(sizeof(sBlitzLevelCaps) / sizeof(sBlitzLevelCaps[0])) - 1;
    }

    return sBlitzLevelCaps[badges];
}
