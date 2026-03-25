#include "macros/btlcmd.inc"


_000:
    // Acrobatics: double power if user has no held item
    CompareMonDataToValue OPCODE_NEQ, BTLSCR_ATTACKER, BATTLEMON_HELD_ITEM, ITEM_NONE, _009
    UpdateVar OPCODE_SET, BTLVAR_POWER_MULTI, 20
_009:
    CalcCrit
    CalcDamage
    End
