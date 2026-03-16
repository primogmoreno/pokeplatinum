#!/usr/bin/env python3
"""
fill_move_data.py — Fill in stub move data.json files from PBS move data.

Reads PBS move entries from the pack's vanilla moves.txt (all gens) and
moves_Gen_9_Pack.txt (Gen 9 additions), then overwrites the stub data.json
files under res/battle/moves/ that still have BATTLE_EFFECT_DO_NOTHING.

Usage:
  python3 fill_move_data.py --pack /path/to/generation_1_9_pack \
                             --pokeplatinum /path/to/pokeplatinum
"""

import argparse
import json
import re
import sys
from pathlib import Path


# ── PBS Target → game RANGE constant ──────────────────────────────────────────
TARGET_MAP = {
    "NearOther":          "RANGE_SINGLE_TARGET",
    "NearFoe":            "RANGE_SINGLE_TARGET",
    "SingleNonUser":      "RANGE_SINGLE_TARGET",
    "RandomNearFoe":      "RANGE_RANDOM_OPPONENT",
    "AllNearFoes":        "RANGE_ADJACENT_OPPONENTS",
    "AllFoes":            "RANGE_ADJACENT_OPPONENTS",
    "NearAlly":           "RANGE_ALLY",
    "AllAllies":          "RANGE_USER_SIDE",
    "UserSide":           "RANGE_USER_SIDE",
    "FoeSide":            "RANGE_OPPONENT_SIDE",
    "AllNearOther":       "RANGE_ALL_ADJACENT",
    "All":                "RANGE_ALL_ADJACENT",
    "BothSides":          "RANGE_FIELD",
    "User":               "RANGE_USER",
    "UserOrNearAlly":     "RANGE_USER_OR_ALLY",
    "MeFirst":            "RANGE_SINGLE_TARGET_ME_FIRST",
}

# ── PBS Category → game CLASS constant ────────────────────────────────────────
CATEGORY_MAP = {
    "Physical": "CLASS_PHYSICAL",
    "Special":  "CLASS_SPECIAL",
    "Status":   "CLASS_STATUS",
}

# ── PBS Flags → game MOVE_FLAG constants ──────────────────────────────────────
FLAG_MAP = {
    "Contact":        "MOVE_FLAG_MAKES_CONTACT",
    "CanProtect":     "MOVE_FLAG_CAN_PROTECT",
    "CanMirrorMove":  "MOVE_FLAG_CAN_MIRROR_MOVE",
    "MagicCoat":      "MOVE_FLAG_CAN_MAGIC_COAT",
    "Snatch":         "MOVE_FLAG_CAN_SNATCH",
    # These PBS flags have no equivalent in Gen 4's engine; ignore them
    "Wind":           None,
    "CannotMetronome": None,
    "Bite":           None,
    "Bullet":         None,
    "Dance":          None,
    "Powder":         None,
    "Pulse":          None,
    "Punch":          None,
    "Sound":          None,
    "Slicing":        None,
    "HealingMove":    None,
    "Gravity":        None,
    "ThawsUser":      None,
    "TramplesMinimize": None,
    "HighCriticalHitRate": None,
}

# ── PBS FunctionCode → BATTLE_EFFECT_* ────────────────────────────────────────
# Map the most common FunctionCodes to their closest Gen 4 equivalents.
# Unmapped damaging moves fall back to BATTLE_EFFECT_HIT.
# Unmapped status moves fall back to BATTLE_EFFECT_DO_NOTHING.
FUNCTION_MAP = {
    # Basic hit
    "NormalHit":                          "BATTLE_EFFECT_HIT",
    "Hit":                                "BATTLE_EFFECT_HIT",

    # Status conditions - hit + inflict
    "BurnTarget":                         "BATTLE_EFFECT_BURN_HIT",
    "PoisonTarget":                       "BATTLE_EFFECT_POISON_HIT",
    "BadlyPoisonTarget":                  "BATTLE_EFFECT_BADLY_POISON_HIT",
    "ParalyzeTarget":                     "BATTLE_EFFECT_PARALYZE_HIT",
    "FreezeTarget":                       "BATTLE_EFFECT_FREEZE_HIT",
    "SleepTarget":                        "BATTLE_EFFECT_STATUS_SLEEP",
    "ConfuseTarget":                      "BATTLE_EFFECT_CONFUSE_HIT",
    "FlinchTarget":                       "BATTLE_EFFECT_FLINCH_HIT",
    "BurnHit":                            "BATTLE_EFFECT_BURN_HIT",
    "PoisonHit":                          "BATTLE_EFFECT_POISON_HIT",
    "ParalyzeHit":                        "BATTLE_EFFECT_PARALYZE_HIT",
    "FreezeHit":                          "BATTLE_EFFECT_FREEZE_HIT",
    "FlinchHit":                          "BATTLE_EFFECT_FLINCH_HIT",
    "PoisonParalyzeOrSleepTarget":        "BATTLE_EFFECT_POISON_HIT",
    "BurnParalyzeOrFreezeTarget":         "BATTLE_EFFECT_BURN_HIT",

    # Stat lowering - hit
    "LowerTargetAttack1":                 "BATTLE_EFFECT_LOWER_ATTACK_HIT",
    "LowerTargetDefense1":                "BATTLE_EFFECT_LOWER_DEFENSE_HIT",
    "LowerTargetSpeed1":                  "BATTLE_EFFECT_LOWER_SPEED_HIT",
    "LowerTargetSpAtk1":                  "BATTLE_EFFECT_LOWER_SP_ATK_HIT",
    "LowerTargetSpDef1":                  "BATTLE_EFFECT_LOWER_SP_DEF_HIT",
    "LowerTargetAccuracy1":               "BATTLE_EFFECT_LOWER_ACCURACY_HIT",
    "LowerTargetAttack2":                 "BATTLE_EFFECT_LOWER_ATTACK_HIT",    # no _2 variant
    "LowerTargetDefense2":                "BATTLE_EFFECT_LOWER_DEFENSE_HIT",   # no _2 variant
    "LowerTargetSpeed2":                  "BATTLE_EFFECT_LOWER_SPEED_HIT",     # no _2 variant
    "LowerTargetSpAtk2":                  "BATTLE_EFFECT_LOWER_SP_ATK_HIT",    # no _2 variant
    "LowerTargetSpDef2":                  "BATTLE_EFFECT_LOWER_SP_DEF_2_HIT",
    "LowerTargetEvasion1":                "BATTLE_EFFECT_LOWER_EVASION_HIT",
    "LowerTargetEvasion2":                "BATTLE_EFFECT_LOWER_EVASION_HIT",   # no _2 variant
    "LowerTargetAllStats1":               "BATTLE_EFFECT_HIT",                  # no all-stats-down-hit variant

    # Stat raising - self (status moves)
    "RaiseUserAttack1":                   "BATTLE_EFFECT_ATK_UP",
    "RaiseUserDefense1":                  "BATTLE_EFFECT_DEF_UP",
    "RaiseUserSpAtk1":                    "BATTLE_EFFECT_SP_ATK_UP",
    "RaiseUserSpDef1":                    "BATTLE_EFFECT_SP_DEF_UP",
    "RaiseUserSpeed1":                    "BATTLE_EFFECT_SPEED_UP",
    "RaiseUserAttack2":                   "BATTLE_EFFECT_ATK_UP_2",
    "RaiseUserDefense2":                  "BATTLE_EFFECT_DEF_UP_2",
    "RaiseUserSpAtk2":                    "BATTLE_EFFECT_SP_ATK_UP_2",
    "RaiseUserSpDef2":                    "BATTLE_EFFECT_SP_DEF_UP_2",
    "RaiseUserSpeed2":                    "BATTLE_EFFECT_SPEED_UP_2",
    "RaiseUserAtkAndSpAtk1":              "BATTLE_EFFECT_ATK_UP",               # no combined variant
    "RaiseUserAtkAndDef1":                "BATTLE_EFFECT_ATK_DEF_UP",
    "RaiseUserAtkAndSpd1":                "BATTLE_EFFECT_ATK_SPD_UP",
    "RaiseUserDefAndSpDef1":              "BATTLE_EFFECT_DEF_UP",               # no combined variant
    "RaiseUserAtkDefSpd1":                "BATTLE_EFFECT_ATK_DEF_UP",           # no 3-stat variant
    "RaiseUserAllStats1":                 "BATTLE_EFFECT_RAISE_ALL_STATS_HIT",  # closest match

    # Self-stat changes (status moves)
    "RaiseUserAttack1SleepTarget":        "BATTLE_EFFECT_ATK_UP",
    "LowerUserAttackAndDefense":          "BATTLE_EFFECT_ATK_DEF_DOWN",
    "LowerUserSpAtk2":                    "BATTLE_EFFECT_SP_ATK_DOWN_2",

    # Healing
    "HealUserHalfMaxHP":                  "BATTLE_EFFECT_RESTORE_HALF_HP",
    "HealUserFullHP":                     "BATTLE_EFFECT_RESTORE_HALF_HP",
    "HealUserByHalfOfTotalHP":            "BATTLE_EFFECT_RESTORE_HALF_HP",

    # Multi-hit
    "HitTwice":                           "BATTLE_EFFECT_MULTI_HIT",
    "HitTwoToFiveTimes":                  "BATTLE_EFFECT_MULTI_HIT",
    "HitThreeTimes":                      "BATTLE_EFFECT_MULTI_HIT",
    "MultiHit":                           "BATTLE_EFFECT_MULTI_HIT",
    "HitMultipleTimes":                   "BATTLE_EFFECT_MULTI_HIT",

    # Priority
    "IncreasePriorityByOne":              "BATTLE_EFFECT_PRIORITY_1",
    "AlwaysGoesFirst":                    "BATTLE_EFFECT_PRIORITY_1",
    "AlwaysGoesLast":                     "BATTLE_EFFECT_BYPASS_ACCURACY",

    # High crit
    "HighCriticalHitRate":                "BATTLE_EFFECT_HIGH_CRITICAL",
    "AlwaysCriticalHit":                  "BATTLE_EFFECT_HIGH_CRITICAL",

    # Recoil
    "RecoilQuarterOfDamageDealt":         "BATTLE_EFFECT_RECOVER_HALF_DAMAGE_DEALT",
    "RecoilThirdOfDamageDealt":           "BATTLE_EFFECT_RECOVER_HALF_DAMAGE_DEALT",
    "RecoilHalfOfDamageDealt":            "BATTLE_EFFECT_RECOVER_HALF_DAMAGE_DEALT",
    "UserFaintsExplosion":                "BATTLE_EFFECT_DO_NOTHING",  # no self-faint explosion effect

    # Drain
    "HealUserByHalfOfDamageDone":         "BATTLE_EFFECT_RECOVER_HALF_DAMAGE_DEALT",
    "DrainHP":                            "BATTLE_EFFECT_RECOVER_HALF_DAMAGE_DEALT",

    # Charge / two-turn
    "TwoTurnAttack":                      "BATTLE_EFFECT_RECHARGE_AFTER",
    "MultiTurnAttackConfuseUserAtEnd":    "BATTLE_EFFECT_CONTINUE_AND_CONFUSE_SELF",
    "RechargingMove":                     "BATTLE_EFFECT_RECHARGE_AFTER",

    # Faint-based
    "UserFaintsHealReplacementHalfHP":    "BATTLE_EFFECT_DO_NOTHING",
    "ReviveTargetHalfHP":                 "BATTLE_EFFECT_DO_NOTHING",

    # Weather
    "StartSunWeather":                    "BATTLE_EFFECT_WEATHER_SUN",
    "StartRainWeather":                   "BATTLE_EFFECT_WEATHER_RAIN",
    "StartSandstormWeather":              "BATTLE_EFFECT_WEATHER_SANDSTORM",
    "StartHailWeather":                   "BATTLE_EFFECT_WEATHER_HAIL",
    "StartSnowWeather":                   "BATTLE_EFFECT_WEATHER_HAIL",

    # Trap
    "BindTarget":                         "BATTLE_EFFECT_BIND_HIT",

    # Flinch + conditions
    "FlinchAndBurnTarget":                "BATTLE_EFFECT_FLINCH_HIT",
    "FlinchAndParalyzeTarget":            "BATTLE_EFFECT_FLINCH_HIT",
    "FlinchAndFreezeTarget":              "BATTLE_EFFECT_FLINCH_HIT",

    # Protect / Endure
    "ProtectUser":                        "BATTLE_EFFECT_PROTECT",
    "EndureUser":                         "BATTLE_EFFECT_PROTECT",  # no Endure variant

    # Misc attack effects
    "FlinchTargetDoublePowerIfTargetUnderground": "BATTLE_EFFECT_FLINCH_HIT",
    "FlinchTargetDoublePowerIfTargetUnderwater":  "BATTLE_EFFECT_FLINCH_HIT",
    "FlinchTargetDoublePowerIfTargetMinimized":   "BATTLE_EFFECT_FLINCH_HIT",
    "DoublePowerIfTargetUnderground":     "BATTLE_EFFECT_DOUBLE_DAMAGE_DIG",
    "DoublePowerIfTargetUnderwater":      "BATTLE_EFFECT_DOUBLE_DAMAGE_DIVE",
    "DoublePowerIfTargetAsleep":          "BATTLE_EFFECT_DOUBLE_POWER_HEAL_SLEEP",
    "DoublePowerIfTargetParalyzed":       "BATTLE_EFFECT_HIT",
    "DoublePowerIfUserHalfHP":            "BATTLE_EFFECT_HIT",

    # Screen
    "SetUpAuroraVeil":                    "BATTLE_EFFECT_DO_NOTHING",   # no Aurora Veil in Gen 4
    "SetUpReflect":                       "BATTLE_EFFECT_SET_REFLECT",
    "SetUpLightScreen":                   "BATTLE_EFFECT_SET_LIGHT_SCREEN",
    "SetUpMist":                          "BATTLE_EFFECT_DO_NOTHING",   # no Mist in the effect list

    # Field conditions
    "SetUpSpikes":                        "BATTLE_EFFECT_SET_SPIKES",
    "RemoveHazards":                      "BATTLE_EFFECT_DO_NOTHING",   # no Rapid Spin effect

    # Misc
    "CounterPhysicalDamage":              "BATTLE_EFFECT_COUNTER",
    "CounterSpecialDamage":               "BATTLE_EFFECT_MIRROR_COAT",
    "CureUserStatusCondition":            "BATTLE_EFFECT_CURE_PARTY_STATUS",
    "SwitchOutTargetStatusMove":          "BATTLE_EFFECT_DO_NOTHING",
    "SleepTarget":                        "BATTLE_EFFECT_STATUS_SLEEP",
    "ConfuseTargetStatusMove":            "BATTLE_EFFECT_STATUS_CONFUSE",
    "ParalyzeTargetStatusMove":           "BATTLE_EFFECT_STATUS_PARALYZE",
    "BurnTargetStatusMove":               "BATTLE_EFFECT_STATUS_BURN",
    "PoisonTargetStatusMove":             "BATTLE_EFFECT_STATUS_POISON",
    "BadlyPoisonTargetStatusMove":        "BATTLE_EFFECT_STATUS_BADLY_POISON",

    # Gen 5-9 new mechanics (stub out as HIT or DO_NOTHING)
    "IncreasePokemonAbilityPower":        "BATTLE_EFFECT_HIT",
    "HitWithType":                        "BATTLE_EFFECT_HIT",
    "RandomPowerMove":                    "BATTLE_EFFECT_HIT",
    "StrikeFirstIfTargetMoveIsPhysical":  "BATTLE_EFFECT_HIT",
    "StrikeFirstIfTargetMoveIsSpecial":   "BATTLE_EFFECT_HIT",
    "RandomStatusConditionHit":           "BATTLE_EFFECT_HIT",
    "GiveItemToTarget":                   "BATTLE_EFFECT_DO_NOTHING",
    "UserCopiesTargetAbility":            "BATTLE_EFFECT_DO_NOTHING",
    "CopyCatMove":                        "BATTLE_EFFECT_COPY_MOVE_FOR_BATTLE",
    "SleepHit":                           "BATTLE_EFFECT_STATUS_SLEEP",
    "HealingWish":                        "BATTLE_EFFECT_DO_NOTHING",
    "LunarDance":                         "BATTLE_EFFECT_DO_NOTHING",
    "TeraBlastMove":                      "BATTLE_EFFECT_HIT",
    "FailsIfTargetIsWater":               "BATTLE_EFFECT_HIT",
    "FailsIfTargetHasItem":               "BATTLE_EFFECT_HIT",
    "IgnoreTargetDefense":                "BATTLE_EFFECT_HIGH_CRITICAL",
    "HitTargetWithHigherAttackStat":      "BATTLE_EFFECT_HIT",
    "DoublePowerIfAllyFainted":           "BATTLE_EFFECT_HIT",
    "DoublePowerIfTargetFlinched":        "BATTLE_EFFECT_HIT",
    "HighCriticalHitRateAndFlinch":       "BATTLE_EFFECT_FLINCH_HIT",
    "SwitchAndPassStatsToAlly":           "BATTLE_EFFECT_DO_NOTHING",  # no Baton Pass effect constant
}


def parse_pbs_sections(filepath: Path) -> dict:
    """Parse a PBS file into a dict of {MOVE_ID: {field: value}}."""
    sections = {}
    current = None
    with open(filepath, encoding="utf-8-sig") as f:
        for line in f:
            line = line.rstrip("\n")
            m = re.match(r"^\[(\w+)\]", line)
            if m:
                current = m.group(1).upper()
                sections[current] = {}
                continue
            if current is None:
                continue
            if "=" in line and not line.strip().startswith("#"):
                key, _, val = line.partition("=")
                sections[current][key.strip()] = val.strip()
    return sections


def pbs_to_data_json(pbs: dict, move_dir_name: str) -> dict:
    """Convert a PBS move entry to a data.json dict."""
    category  = pbs.get("Category", "Status")
    cls       = CATEGORY_MAP.get(category, "CLASS_STATUS")
    type_raw  = pbs.get("Type", "NORMAL")
    move_type = f"TYPE_{type_raw.upper()}"
    # TYPE_FAIRY → TYPE_NORMAL placeholder (no Fairy type in engine)
    if move_type == "TYPE_FAIRY":
        move_type = "TYPE_NORMAL"

    power    = int(pbs.get("Power",    0))
    accuracy = int(pbs.get("Accuracy", 0))
    pp       = int(pbs.get("TotalPP",  5))

    target     = pbs.get("Target", "NearOther")
    range_val  = TARGET_MAP.get(target, "RANGE_SINGLE_TARGET")

    priority   = int(pbs.get("Priority", 0))

    func_code  = pbs.get("FunctionCode", "")
    eff_chance = int(pbs.get("EffectChance", 0))

    # Choose battle effect
    if func_code in FUNCTION_MAP:
        effect_type = FUNCTION_MAP[func_code]
    else:
        # Unknown function: use HIT for damaging moves, DO_NOTHING for status
        if cls in ("CLASS_PHYSICAL", "CLASS_SPECIAL") and power > 0:
            effect_type = "BATTLE_EFFECT_HIT"
        else:
            effect_type = "BATTLE_EFFECT_DO_NOTHING"

    # Build flags list
    flags_raw = [f.strip() for f in pbs.get("Flags", "").split(",") if f.strip()]
    flags = []
    for f in flags_raw:
        mapped = FLAG_MAP.get(f)
        if mapped:
            flags.append(mapped)

    # Always add TRIGGERS_KINGS_ROCK for standard damaging moves
    if (cls in ("CLASS_PHYSICAL", "CLASS_SPECIAL")
            and power > 0
            and "MOVE_FLAG_MAKES_CONTACT" not in flags
            and "MOVE_FLAG_TRIGGERS_KINGS_ROCK" not in flags):
        flags.append("MOVE_FLAG_TRIGGERS_KINGS_ROCK")

    name = pbs.get("Name", move_dir_name.replace("_", " ").title())

    return {
        "name":     name,
        "class":    cls,
        "type":     move_type,
        "power":    power,
        "accuracy": accuracy,
        "pp":       pp,
        "effect": {
            "type":   effect_type,
            "chance": eff_chance,
        },
        "range":    range_val,
        "priority": priority,
        "flags":    flags,
        "contest": {
            "effect": "CONTEST_EFFECT_NONE",
            "type":   "CONTEST_TYPE_COOL",
        },
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pack",         required=True)
    ap.add_argument("--pokeplatinum", required=True)
    ap.add_argument("--force", action="store_true",
                    help="Update all moves that have PBS data, not just DO_NOTHING stubs")
    args = ap.parse_args()

    pack_dir  = Path(args.pack)
    poke_dir  = Path(args.pokeplatinum)
    moves_dir = poke_dir / "res" / "battle" / "moves"

    # Load PBS data from both sources
    vanilla_pbs = parse_pbs_sections(
        pack_dir / "PBS" / "Gen 9 backup" / "Vanilla PBS Files (with updates)" / "moves.txt"
    )
    gen9_pbs = parse_pbs_sections(
        pack_dir / "PBS" / "moves_Gen_9_Pack.txt"
    )
    # Gen 9 pack takes precedence (more up to date)
    all_pbs = {**vanilla_pbs, **gen9_pbs}
    print(f"Loaded {len(all_pbs)} PBS move entries")

    # Build a fuzzy lookup: stripped-lowercase → PBS key
    fuzzy = {k.lower().replace("_", ""): k for k in all_pbs}

    updated = 0
    skipped = 0
    not_found = []

    for move_dir in sorted(moves_dir.iterdir()):
        if not move_dir.is_dir():
            continue
        data_path = move_dir / "data.json"
        if not data_path.exists():
            continue

        with open(data_path) as f:
            current = json.load(f)

        # By default only update stubs; --force updates any move with PBS data
        if not args.force and current.get("effect", {}).get("type") != "BATTLE_EFFECT_DO_NOTHING":
            continue

        dir_name = move_dir.name  # e.g. "drumbeating"
        lookup_key = dir_name.upper().replace("_", "")

        # Try exact, then fuzzy
        pbs_key = None
        if lookup_key in all_pbs:
            pbs_key = lookup_key
        else:
            pbs_key = fuzzy.get(dir_name.lower().replace("_", ""))

        if pbs_key is None:
            not_found.append(dir_name)
            skipped += 1
            continue

        pbs_entry = all_pbs[pbs_key]
        new_data  = pbs_to_data_json(pbs_entry, dir_name)

        with open(data_path, "w") as f:
            json.dump(new_data, f, indent=4)

        updated += 1

    print(f"\nUpdated: {updated}  Skipped (no PBS data): {skipped}")
    if not_found:
        print(f"Not found in PBS ({len(not_found)}):")
        for m in sorted(not_found):
            print(f"  {m}")


if __name__ == "__main__":
    main()
