#include "macros/btlcmd.inc"


_000:
    // Venoshock: double power if target is poisoned (regular or toxic)
    CompareMonDataToValue OPCODE_FLAG_NOT, BTLSCR_DEFENDER, BATTLEMON_STATUS, MON_CONDITION_ANY_POISON, _009
    UpdateVar OPCODE_SET, BTLVAR_POWER_MULTI, 20
_009:
    CalcCrit
    CalcDamage
    End
