#include "macros/btlcmd.inc"


_000:
    TryLightScreen _light_done
    Call BATTLE_SUBSCRIPT_ANIMATION_PREPARED_MESSAGE
_light_done:
    TryReflect _reflect_done
    Call BATTLE_SUBSCRIPT_ANIMATION_PREPARED_MESSAGE
_reflect_done:
    End
