#!/usr/bin/env python3
"""
convert_pbs.py — Convert Pokemon Essentials PBS data to pokeplatinum data.json format.

Reads from:
  PBS/Gen 9 backup/Vanilla PBS Files (with updates)/pokemon.txt  (Gen 1–8)
  PBS/pokemon_base_Gen_9_Pack.txt                                 (Gen 8 Hisui + Gen 9)

Writes:
  res/pokemon/<name>/data.json  for each new species

Also writes:
  tools/blitz_conv/missing_constants.txt  (abilities/moves not in current game)

Usage:
  python3 convert_pbs.py --pack /path/to/generation_1_9_pack \
                          --pokeplatinum /path/to/pokeplatinum \
                          [--start-from VICTINI]
"""

import argparse
import json
import re
import sys
from pathlib import Path

# ── Constant mapping tables ────────────────────────────────────────────────

GENDER_RATIO_MAP = {
    "AlwaysMale":         "GENDER_RATIO_MALE_ONLY",
    "AlwaysFemale":       "GENDER_RATIO_FEMALE_ONLY",
    "Genderless":         "GENDER_RATIO_NO_GENDER",
    "Female50Percent":    "GENDER_RATIO_FEMALE_50",
    "Female75Percent":    "GENDER_RATIO_FEMALE_75",
    "Female25Percent":    "GENDER_RATIO_FEMALE_25",
    "Female12_5Percent":  "GENDER_RATIO_FEMALE_12_5",
    "Female87_5Percent":  "GENDER_RATIO_FEMALE_87_5",
}

GROWTH_RATE_MAP = {
    "Fast":          "EXP_RATE_FAST",
    "MediumFast":    "EXP_RATE_MEDIUM_FAST",
    "MediumSlow":    "EXP_RATE_MEDIUM_SLOW",
    "Slow":          "EXP_RATE_SLOW",
    "Parabolic":     "EXP_RATE_MEDIUM_SLOW",   # closest approximation
    "Erratic":       "EXP_RATE_ERRATIC",
    "Fluctuating":   "EXP_RATE_FLUCTUATING",
}

EGG_GROUP_MAP = {
    "Monster":      "EGG_GROUP_MONSTER",
    "Water1":       "EGG_GROUP_WATER_1",
    "Bug":          "EGG_GROUP_BUG",
    "Flying":       "EGG_GROUP_FLYING",
    "Field":        "EGG_GROUP_FIELD",
    "Fairy":        "EGG_GROUP_FAIRY",
    "Grass":        "EGG_GROUP_GRASS",
    "HumanLike":    "EGG_GROUP_HUMAN_LIKE",
    "Water3":       "EGG_GROUP_WATER_3",
    "Mineral":      "EGG_GROUP_MINERAL",
    "Amorphous":    "EGG_GROUP_AMORPHOUS",
    "Water2":       "EGG_GROUP_WATER_2",
    "Ditto":        "EGG_GROUP_DITTO",
    "Dragon":       "EGG_GROUP_DRAGON",
    "Undiscovered": "EGG_GROUP_UNDISCOVERED",
    "Ground":       "EGG_GROUP_FIELD",
}

TYPE_MAP = {
    "NORMAL":   "TYPE_NORMAL",
    "FIRE":     "TYPE_FIRE",
    "WATER":    "TYPE_WATER",
    "GRASS":    "TYPE_GRASS",
    "ELECTRIC": "TYPE_ELECTRIC",
    "ICE":      "TYPE_ICE",
    "FIGHTING": "TYPE_FIGHTING",
    "POISON":   "TYPE_POISON",
    "GROUND":   "TYPE_GROUND",
    "FLYING":   "TYPE_FLYING",
    "PSYCHIC":  "TYPE_PSYCHIC",
    "BUG":      "TYPE_BUG",
    "ROCK":     "TYPE_ROCK",
    "GHOST":    "TYPE_GHOST",
    "DRAGON":   "TYPE_DRAGON",
    "DARK":     "TYPE_DARK",
    "STEEL":    "TYPE_STEEL",
    "FAIRY":    "TYPE_NORMAL",  # Placeholder until TYPE_FAIRY is added to the engine
}

BODY_COLOR_MAP = {
    "Red":    "MON_COLOR_RED",
    "Blue":   "MON_COLOR_BLUE",
    "Yellow": "MON_COLOR_YELLOW",
    "Green":  "MON_COLOR_GREEN",
    "Black":  "MON_COLOR_BLACK",
    "Brown":  "MON_COLOR_BROWN",
    "Purple": "MON_COLOR_PURPLE",
    "Gray":   "MON_COLOR_GRAY",
    "White":  "MON_COLOR_WHITE",
    "Pink":   "MON_COLOR_PINK",
}

# Default sprite_data.json template (matches typical Gen 4 Pokemon)
SPRITE_DATA_TEMPLATE = {
    "front": {
        "y_offset": {"female": 20, "male": 20},
        "addl_y_offset": 1,
        "animation": 2,
        "cry_delay": 12,
        "start_delay": 12,
        "frames": [
            {"sprite_frame": 0,  "frame_delay": 12, "x_shift": 0, "y_shift": 0},
            {"sprite_frame": 1,  "frame_delay": 12, "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 3,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
        ],
    },
    "back": {
        "y_offset": {"female": 8, "male": 8},
        "animation": 6,
        "cry_delay": 12,
        "start_delay": 12,
        "frames": [
            {"sprite_frame": 0,  "frame_delay": 12, "x_shift": 0, "y_shift": 0},
            {"sprite_frame": 1,  "frame_delay": 12, "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
            {"sprite_frame": -1, "frame_delay": 0,  "x_shift": 0, "y_shift": 0},
        ],
    },
    "shadow": {"x_offset": 0, "size": "SHADOW_SIZE_MEDIUM"},
}

MESON_BUILD_TEMPLATE = """\
species_data_files += files('data.json')

poke_icon_files += files('icon.png')

pokegra_files += files('female_back.png')
pokegra_files += files('male_back.png')
pokegra_files += files('female_front.png')
pokegra_files += files('male_front.png')

pokefoot_files += files('footprint.png')
"""


# ── PBS parser ────────────────────────────────────────────────────────────

def parse_pbs_file(pbs_path: Path) -> dict[str, dict[str, str]]:
    """Parse a PBS file into {species_name: {key: raw_value}}."""
    entries: dict[str, dict[str, str]] = {}
    current: str | None = None
    current_data: dict[str, str] = {}

    for line in pbs_path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        m = re.match(r"^\[(\w+)\]$", line)
        if m:
            if current is not None:
                entries[current] = current_data
            current = m.group(1).upper()
            current_data = {}
        elif "=" in line and current is not None:
            key, _, val = line.partition("=")
            current_data[key.strip()] = val.strip()

    if current is not None:
        entries[current] = current_data

    return entries


def ability_const(name: str, known_abilities: set[str], missing: set[str],
                  ability_nounder_map: dict[str, str]) -> str:
    const = "ABILITY_" + name.upper().replace(" ", "")
    if const in known_abilities:
        return const
    fuzzy = ability_nounder_map.get(const.replace("_", ""))
    if fuzzy:
        return fuzzy
    missing.add(const)
    return "ABILITY_NONE"


def move_const(name: str, known_moves: set[str], missing: set[str],
               move_nounder_map: dict[str, str]) -> str:
    const = "MOVE_" + name.upper().replace(" ", "")
    if const in known_moves:
        return const
    fuzzy = move_nounder_map.get(const.replace("_", ""))
    if fuzzy:
        return fuzzy
    missing.add(const)
    return "MOVE_NONE"


def pbs_to_data_json(name: str, pbs: dict[str, str],
                     known_abilities: set[str], known_moves: set[str],
                     missing_abilities: set[str], missing_moves: set[str],
                     ability_nounder_map: dict[str, str],
                     move_nounder_map: dict[str, str]) -> dict:
    # Base stats (HP,ATK,DEF,SPD,SPATK,SPDEF)
    stats_csv = pbs.get("BaseStats", "50,50,50,50,50,50").split(",")
    while len(stats_csv) < 6:
        stats_csv.append("50")
    hp, atk, def_, spd, spatk, spdef = [int(x.strip()) for x in stats_csv[:6]]

    # Types
    types_raw = pbs.get("Types", "NORMAL").split(",")
    t1 = TYPE_MAP.get(types_raw[0].strip().upper(), "TYPE_NORMAL")
    t2 = TYPE_MAP.get(types_raw[1].strip().upper() if len(types_raw) > 1 else types_raw[0].strip().upper(), t1)

    # EVs — PBS format: STAT,amount[,STAT,amount...]
    ev_yields = {"hp": 0, "attack": 0, "defense": 0, "speed": 0, "special_attack": 0, "special_defense": 0}
    ev_raw = pbs.get("EVs", "")
    if ev_raw:
        ev_parts = [x.strip() for x in ev_raw.split(",")]
        for i in range(0, len(ev_parts) - 1, 2):
            stat_name = ev_parts[i].upper()
            amount = int(ev_parts[i + 1])
            stat_map = {
                "HP": "hp", "ATTACK": "attack", "DEFENSE": "defense",
                "SPEED": "speed", "SPECIALATTACK": "special_attack", "SPECIALDEFENSE": "special_defense",
                "SPATK": "special_attack", "SPDEF": "special_defense",
                "SPATTACK": "special_attack", "SPDEFENSE": "special_defense",
            }
            key = stat_map.get(stat_name.replace(" ", ""), None)
            if key:
                ev_yields[key] = amount

    # Gender ratio
    gender_ratio = GENDER_RATIO_MAP.get(pbs.get("GenderRatio", "Female50Percent"), "GENDER_RATIO_FEMALE_50")

    # Hatch cycles — PBS uses HatchSteps (steps), game uses hatch_cycles
    hatch_steps = int(pbs.get("HatchSteps", "5120"))
    hatch_cycles = max(1, hatch_steps // 256)

    # Happiness
    base_friendship = int(pbs.get("Happiness", "70"))

    # Growth rate
    exp_rate = GROWTH_RATE_MAP.get(pbs.get("GrowthRate", "MediumFast"), "EXP_RATE_MEDIUM_FAST")

    # Egg groups
    egg_raw = pbs.get("EggGroups", "Field").split(",")
    egg_groups = [EGG_GROUP_MAP.get(e.strip(), "EGG_GROUP_FIELD") for e in egg_raw[:2]]
    while len(egg_groups) < 2:
        egg_groups.append(egg_groups[0])

    # Abilities (up to 2 — ignore HiddenAbilities for now)
    ab_raw = pbs.get("Abilities", "").split(",")
    ab1 = ability_const(ab_raw[0].strip(), known_abilities, missing_abilities, ability_nounder_map) if ab_raw[0].strip() else "ABILITY_NONE"
    ab2 = ability_const(ab_raw[1].strip(), known_abilities, missing_abilities, ability_nounder_map) if len(ab_raw) > 1 and ab_raw[1].strip() else "ABILITY_NONE"

    # Learnset (Moves field: level,MOVE,level,MOVE,...)
    by_level = []
    moves_raw = pbs.get("Moves", "")
    if moves_raw:
        move_parts = [x.strip() for x in moves_raw.split(",")]
        for i in range(0, len(move_parts) - 1, 2):
            try:
                lvl = int(move_parts[i])
                if lvl < 0:
                    lvl = 1  # PBS uses -1 for relearner moves; map to level 1
                mv  = move_const(move_parts[i + 1], known_moves, missing_moves, move_nounder_map)
                by_level.append([lvl, mv])
            except (ValueError, IndexError):
                pass

    # Height/weight
    height = int(float(pbs.get("Height", "1.0")) * 10)
    weight = int(float(pbs.get("Weight", "10.0")) * 10)

    # Body color
    body_color = BODY_COLOR_MAP.get(pbs.get("Color", "Brown"), "MON_COLOR_BROWN")

    # Pokedex entry text — sanitize chars not in NDS charmap
    entry_text = (pbs.get("Pokedex", f"{name} Pokemon.")
                  .replace("'", "\u2019")   # straight apostrophe → curly
                  .replace("\u2014", "-")   # em dash → hyphen
                  .replace("\u2013", "-"))  # en dash → hyphen

    data = {
        "base_stats": {
            "hp": hp, "attack": atk, "defense": def_,
            "speed": spd, "special_attack": spatk, "special_defense": spdef,
        },
        "types": [t1, t2],
        "catch_rate": int(pbs.get("CatchRate", "45")),
        "base_exp_reward": int(pbs.get("BaseExp", "100")),
        "ev_yields": ev_yields,
        "held_items": {"common": "ITEM_NONE", "rare": "ITEM_NONE"},
        "gender_ratio": gender_ratio,
        "hatch_cycles": hatch_cycles,
        "base_friendship": base_friendship,
        "exp_rate": exp_rate,
        "egg_groups": egg_groups,
        "abilities": [ab1, ab2],
        "safari_flee_rate": 0,
        "body_color": body_color,
        "flip_sprite": False,
        "icon_palette": 1,
        "learnset": {
            "by_level": by_level,
            "by_tm": [],
            "by_tutor": [],
            "egg_moves": [],
        },
        "evolutions": [],
        "offspring": f"SPECIES_{name.upper()}",
        "footprint": {
            "has": True,
            "size": "FOOTPRINT_MEDIUM",
            "type": "FOOTPRINT_TYPE_CUTE",
        },
        "pokedex_data": {
            "height": height,
            "weight": weight,
            "body_shape": "SHAPE_QUADRUPED",
            "trainer_scale_f": 256,
            "pokemon_scale_f": 256,
            "trainer_scale_m": 256,
            "pokemon_scale_m": 256,
            "trainer_pos_f": 0,
            "pokemon_pos_f": 0,
            "trainer_pos_m": 0,
            "pokemon_pos_m": 0,
            "en": {
                "name": pbs.get("Name", name.title()).upper().replace("'", "\u2019"),
                "category": pbs.get("Category", "Pokemon") + " Pokémon",
                "entry_text": [entry_text],
            },
            "fr": {
                "name": pbs.get("Name", name.title()).upper().replace("'", "\u2019"),
                "category": pbs.get("Category", "Pokemon") + " Pokémon",
                "entry_text": [entry_text],
            },
            "de": {
                "name": pbs.get("Name", name.title()).upper().replace("'", "\u2019"),
                "category": pbs.get("Category", "Pokemon") + " Pokémon",
                "entry_text": [entry_text],
            },
            "it": {
                "name": pbs.get("Name", name.title()).upper().replace("'", "\u2019"),
                "category": pbs.get("Category", "Pokemon") + " Pokémon",
                "entry_text": [entry_text],
            },
            "es": {
                "name": pbs.get("Name", name.title()).upper().replace("'", "\u2019"),
                "category": pbs.get("Category", "Pokemon") + " Pokémon",
                "entry_text": [entry_text],
            },
            "jp": {
                "name": pbs.get("Name", name.title()).upper().replace("'", "\u2019"),
                "category": pbs.get("Category", "Pokemon") + " Pokémon",
                "entry_text": [entry_text],
            },
        },
        "catching_show": {
            "pal_park_land_area": "PAL_PARK_AREA_LAND_NONE",
            "pal_park_water_area": "PAL_PARK_AREA_WATER_NONE",
            "catching_points": 50,
            "rarity": 30,
            "unused": 0,
        },
    }

    return data


# ── Main ──────────────────────────────────────────────────────────────────

def load_constants_set(filepath: Path) -> set[str]:
    if not filepath.exists():
        return set()
    return {line.strip() for line in filepath.read_text().splitlines() if line.strip()}


def main():
    ap = argparse.ArgumentParser(description="Convert PBS pokemon data to pokeplatinum data.json")
    ap.add_argument("--pack",          required=True)
    ap.add_argument("--pokeplatinum",  required=True)
    ap.add_argument("--start-from",    default=None,
                    help="Only process species starting at this name (e.g. VICTINI)")
    ap.add_argument("--only",          nargs="*",
                    help="Process only these species names")
    args = ap.parse_args()

    pack_dir = Path(args.pack)
    poke_dir = Path(args.pokeplatinum)

    vanilla_pbs = pack_dir / "PBS" / "Gen 9 backup" / "Vanilla PBS Files (with updates)" / "pokemon.txt"
    gen9_pbs    = pack_dir / "PBS" / "pokemon_base_Gen_9_Pack.txt"

    # Load all PBS entries
    all_entries: dict[str, dict[str, str]] = {}
    if vanilla_pbs.exists():
        all_entries.update(parse_pbs_file(vanilla_pbs))
        print(f"Loaded {len(all_entries)} entries from vanilla PBS")
    else:
        print(f"[WARN] vanilla PBS not found: {vanilla_pbs}", file=sys.stderr)

    if gen9_pbs.exists():
        gen9 = parse_pbs_file(gen9_pbs)
        all_entries.update(gen9)
        print(f"Loaded {len(gen9)} entries from Gen 9 pack PBS (total: {len(all_entries)})")
    else:
        print(f"[WARN] Gen 9 PBS not found: {gen9_pbs}", file=sys.stderr)

    # Load existing constants (files already contain full constant names with prefixes)
    known_abilities = load_constants_set(poke_dir / "generated" / "abilities.txt")
    known_moves     = load_constants_set(poke_dir / "generated" / "moves.txt")
    existing_species = load_constants_set(poke_dir / "generated" / "species.txt")

    # Reverse maps: stripped-underscore name → actual constant (for fuzzy matching)
    ability_nounder_map = {c.replace("_", ""): c for c in known_abilities}
    move_nounder_map    = {c.replace("_", ""): c for c in known_moves}

    # Filter to new species only (not already in the game)
    missing_abilities: set[str] = set()
    missing_moves:     set[str] = set()

    # Determine which species to process
    if args.only:
        to_process = [n.upper() for n in args.only]
    else:
        to_process = list(all_entries.keys())
        if args.start_from:
            start = args.start_from.upper()
            if start in to_process:
                to_process = to_process[to_process.index(start):]

    ok = 0
    skip = 0
    for name in to_process:
        species_const = f"SPECIES_{name}"
        if species_const in existing_species:
            skip += 1
            continue

        if name not in all_entries:
            print(f"  [WARN] {name} not in PBS data, skipping", file=sys.stderr)
            skip += 1
            continue

        pbs_data  = all_entries[name]
        data_json = pbs_to_data_json(
            name, pbs_data,
            known_abilities, known_moves,
            missing_abilities, missing_moves,
            ability_nounder_map, move_nounder_map,
        )

        species_dir = poke_dir / "res" / "pokemon" / name.lower()
        species_dir.mkdir(parents=True, exist_ok=True)

        (species_dir / "data.json").write_text(
            json.dumps(data_json, indent=2) + "\n"
        )

        # Write sprite_data.json template
        if not (species_dir / "sprite_data.json").exists():
            (species_dir / "sprite_data.json").write_text(
                json.dumps(SPRITE_DATA_TEMPLATE, indent=4) + "\n"
            )

        # Write meson.build
        if not (species_dir / "meson.build").exists():
            (species_dir / "meson.build").write_text(MESON_BUILD_TEMPLATE)

        print(f"  [OK] {name}")
        ok += 1

    # Write missing constants report
    missing_path = Path(args.pokeplatinum) / "tools" / "blitz_conv" / "missing_constants.txt"
    with missing_path.open("w") as f:
        f.write("# Abilities referenced in PBS but not in generated/abilities.txt\n")
        for a in sorted(missing_abilities):
            f.write(a + "\n")
        f.write("\n# Moves referenced in PBS but not in generated/moves.txt\n")
        for m in sorted(missing_moves):
            f.write(m + "\n")

    print(f"\nDone: {ok} written, {skip} skipped (already exist or not in PBS)")
    print(f"Missing constants logged to: {missing_path}")
    print(f"  {len(missing_abilities)} unknown abilities, {len(missing_moves)} unknown moves")


if __name__ == "__main__":
    main()
