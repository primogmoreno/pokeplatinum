#include "macros/btlcmd.inc"


_000:
    // Hex: double power if target has any non-volatile status condition
    CompareMonDataToValue OPCODE_FLAG_NOT, BTLSCR_DEFENDER, BATTLEMON_STATUS, MON_CONDITION_ANY, _009
    UpdateVar OPCODE_SET, BTLVAR_POWER_MULTI, 20
_009:
    CalcCrit
    CalcDamage
    End
