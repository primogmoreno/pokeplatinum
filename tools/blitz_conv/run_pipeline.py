#!/usr/bin/env python3
"""
run_pipeline.py — Master script that runs the full Gen 5-9 conversion pipeline.

Steps per species:
  1. convert_pbs.py   — write data.json + sprite_data.json + meson.build
  2. convert_sprites.py — write PNG sprites + .pal files
  3. convert_cries.py — write SWAV cries
  4. Update generated/species.txt with new SPECIES_ constants
  5. Print a patch to add new species dirs to res/pokemon/meson.build

Usage:
  python3 run_pipeline.py --pack /path/to/generation_1_9_pack \
                           --pokeplatinum /path/to/pokeplatinum \
                           --generation 5
  OR specify a range:
  python3 run_pipeline.py ... --dex-range 494 649

National Dex ranges:
  Gen 5: 494-649   (Victini → Genesect)
  Gen 6: 650-721   (Chespin → Volcanion)
  Gen 7: 722-809   (Rowlet → Melmetal)
  Gen 8: 810-905   (Grookey → Enamorus)
  Gen 9: 906-1025  (Sprigatito → Pecharunt)
"""

import argparse
import subprocess
import sys
from pathlib import Path

# National Dex number → uppercase PBS species name
# Generated from the full national dex (Gen 5 onward)
# Note: This mapping is based on standard National Dex order.
# Entries that are alternate forms (not base species) are excluded.
GEN5_SPECIES = [
    (494, "VICTINI"), (495, "SNIVY"), (496, "SERVINE"), (497, "SERPERIOR"),
    (498, "TEPIG"), (499, "PIGNITE"), (500, "EMBOAR"), (501, "OSHAWOTT"),
    (502, "DEWOTT"), (503, "SAMUROTT"), (504, "PATRAT"), (505, "WATCHOG"),
    (506, "LILLIPUP"), (507, "HERDIER"), (508, "STOUTLAND"), (509, "PURRLOIN"),
    (510, "LIEPARD"), (511, "PANSAGE"), (512, "SIMISAGE"), (513, "PANSEAR"),
    (514, "SIMISEAR"), (515, "PANPOUR"), (516, "SIMIPOUR"), (517, "MUNNA"),
    (518, "MUSHARNA"), (519, "PIDOVE"), (520, "TRANQUILL"), (521, "UNFEZANT"),
    (522, "BLITZLE"), (523, "ZEBSTRIKA"), (524, "ROGGENROLA"), (525, "BOLDORE"),
    (526, "GIGALITH"), (527, "WOOBAT"), (528, "SWOOBAT"), (529, "DRILBUR"),
    (530, "EXCADRILL"), (531, "AUDINO"), (532, "TIMBURR"), (533, "GURDURR"),
    (534, "CONKELDURR"), (535, "TYMPOLE"), (536, "PALPITOAD"), (537, "SEISMITOAD"),
    (538, "THROH"), (539, "SAWK"), (540, "SEWADDLE"), (541, "SWADLOON"),
    (542, "LEAVANNY"), (543, "VENIPEDE"), (544, "WHIRLIPEDE"), (545, "SCOLIPEDE"),
    (546, "COTTONEE"), (547, "WHIMSICOTT"), (548, "PETILIL"), (549, "LILLIGANT"),
    (550, "BASCULIN"), (551, "SANDILE"), (552, "KROKOROK"), (553, "KROOKODILE"),
    (554, "DARUMAKA"), (555, "DARMANITAN"), (556, "MARACTUS"), (557, "DWEBBLE"),
    (558, "CRUSTLE"), (559, "SCRAGGY"), (560, "SCRAFTY"), (561, "SIGILYPH"),
    (562, "YAMASK"), (563, "COFAGRIGUS"), (564, "TIRTOUGA"), (565, "CARRACOSTA"),
    (566, "ARCHEN"), (567, "ARCHEOPS"), (568, "TRUBBISH"), (569, "GARBODOR"),
    (570, "ZORUA"), (571, "ZOROARK"), (572, "MINCCINO"), (573, "CINCCINO"),
    (574, "GOTHITA"), (575, "GOTHORITA"), (576, "GOTHITELLE"), (577, "SOLOSIS"),
    (578, "DUOSION"), (579, "REUNICLUS"), (580, "DUCKLETT"), (581, "SWANNA"),
    (582, "VANILLITE"), (583, "VANILLISH"), (584, "VANILLUXE"), (585, "DEERLING"),
    (586, "SAWSBUCK"), (587, "EMOLGA"), (588, "KARRABLAST"), (589, "ESCAVALIER"),
    (590, "FOONGUS"), (591, "AMOONGUSS"), (592, "FRILLISH"), (593, "JELLICENT"),
    (594, "ALOMOMOLA"), (595, "JOLTIK"), (596, "GALVANTULA"), (597, "FERROSEED"),
    (598, "FERROTHORN"), (599, "KLINK"), (600, "KLANG"), (601, "KLINKLANG"),
    (602, "TYNAMO"), (603, "EELEKTRIK"), (604, "EELEKTROSS"), (605, "ELGYEM"),
    (606, "BEHEEYEM"), (607, "LITWICK"), (608, "LAMPENT"), (609, "CHANDELURE"),
    (610, "AXEW"), (611, "FRAXURE"), (612, "HAXORUS"), (613, "CUBCHOO"),
    (614, "BEARTIC"), (615, "CRYOGONAL"), (616, "SHELMET"), (617, "ACCELGOR"),
    (618, "STUNFISK"), (619, "MIENFOO"), (620, "MIENSHAO"), (621, "DRUDDIGON"),
    (622, "GOLETT"), (623, "GOLURK"), (624, "PAWNIARD"), (625, "BISHARP"),
    (626, "BOUFFALANT"), (627, "RUFFLET"), (628, "BRAVIARY"), (629, "VULLABY"),
    (630, "MANDIBUZZ"), (631, "HEATMOR"), (632, "DURANT"), (633, "DEINO"),
    (634, "ZWEILOUS"), (635, "HYDREIGON"), (636, "LARVESTA"), (637, "VOLCARONA"),
    (638, "COBALION"), (639, "TERRAKION"), (640, "VIRIZION"), (641, "TORNADUS"),
    (642, "THUNDURUS"), (643, "RESHIRAM"), (644, "ZEKROM"), (645, "LANDORUS"),
    (646, "KYUREM"), (647, "KELDEO"), (648, "MELOETTA"), (649, "GENESECT"),
]

GEN6_SPECIES = [
    (650, "CHESPIN"), (651, "QUILLADIN"), (652, "CHESNAUGHT"), (653, "FENNEKIN"),
    (654, "BRAIXEN"), (655, "DELPHOX"), (656, "FROAKIE"), (657, "FROGADIER"),
    (658, "GRENINJA"), (659, "BUNNELBY"), (660, "DIGGERSBY"), (661, "FLETCHLING"),
    (662, "FLETCHINDER"), (663, "TALONFLAME"), (664, "SCATTERBUG"), (665, "SPEWPA"),
    (666, "VIVILLON"), (667, "LITLEO"), (668, "PYROAR"), (669, "FLABEBE"),
    (670, "FLOETTE"), (671, "FLORGES"), (672, "SKIDDO"), (673, "GOGOAT"),
    (674, "PANCHAM"), (675, "PANGORO"), (676, "FURFROU"), (677, "ESPURR"),
    (678, "MEOWSTIC"), (679, "HONEDGE"), (680, "DOUBLADE"), (681, "AEGISLASH"),
    (682, "SPRITZEE"), (683, "AROMATISSE"), (684, "SWIRLIX"), (685, "SLURPUFF"),
    (686, "INKAY"), (687, "MALAMAR"), (688, "BINACLE"), (689, "BARBARACLE"),
    (690, "SKRELP"), (691, "DRAGALGE"), (692, "CLAUNCHER"), (693, "CLAWITZER"),
    (694, "HELIOPTILE"), (695, "HELIOLISK"), (696, "TYRUNT"), (697, "TYRANTRUM"),
    (698, "AMAURA"), (699, "AURORUS"), (700, "SYLVEON"), (701, "HAWLUCHA"),
    (702, "DEDENNE"), (703, "CARBINK"), (704, "GOOMY"), (705, "SLIGGOO"),
    (706, "GOODRA"), (707, "KLEFKI"), (708, "PHANTUMP"), (709, "TREVENANT"),
    (710, "PUMPKABOO"), (711, "GOURGEIST"), (712, "BERGMITE"), (713, "AVALUGG"),
    (714, "NOIBAT"), (715, "NOIVERN"), (716, "XERNEAS"), (717, "YVELTAL"),
    (718, "ZYGARDE"), (719, "DIANCIE"), (720, "HOOPA"), (721, "VOLCANION"),
]

GEN7_SPECIES = [
    (722, "ROWLET"), (723, "DARTRIX"), (724, "DECIDUEYE"), (725, "LITTEN"),
    (726, "TORRACAT"), (727, "INCINEROAR"), (728, "POPPLIO"), (729, "BRIONNE"),
    (730, "PRIMARINA"), (731, "PIKIPEK"), (732, "TRUMBEAK"), (733, "TOUCANNON"),
    (734, "YUNGOOS"), (735, "GUMSHOOS"), (736, "GRUBBIN"), (737, "CHARJABUG"),
    (738, "VIKAVOLT"), (739, "CRABRAWLER"), (740, "CRABOMINABLE"), (741, "ORICORIO"),
    (742, "CUTIEFLY"), (743, "RIBOMBEE"), (744, "ROCKRUFF"), (745, "LYCANROC"),
    (746, "WISHIWASHI"), (747, "MAREANIE"), (748, "TOXAPEX"), (749, "MUDBRAY"),
    (750, "MUDSDALE"), (751, "DEWPIDER"), (752, "ARAQUANID"), (753, "FOMANTIS"),
    (754, "LURANTIS"), (755, "MORELULL"), (756, "SHIINOTIC"), (757, "SALANDIT"),
    (758, "SALAZZLE"), (759, "STUFFUL"), (760, "BEWEAR"), (761, "BOUNSWEET"),
    (762, "STEENEE"), (763, "TSAREENA"), (764, "COMFEY"), (765, "ORANGURU"),
    (766, "PASSIMIAN"), (767, "WIMPOD"), (768, "GOLISOPOD"), (769, "SANDYGAST"),
    (770, "PALOSSAND"), (771, "PYUKUMUKU"), (772, "TYPENULL"), (773, "SILVALLY"),
    (774, "MINIOR"), (775, "KOMALA"), (776, "TURTONATOR"), (777, "TOGEDEMARU"),
    (778, "MIMIKYU"), (779, "BRUXISH"), (780, "DRAMPA"), (781, "DHELMISE"),
    (782, "JANGMOO"), (783, "HAKAMOO"), (784, "KOMMOO"), (785, "TAPUKOKO"),
    (786, "TAPULELE"), (787, "TAPUBULU"), (788, "TAPUFINI"), (789, "COSMOG"),
    (790, "COSMOEM"), (791, "SOLGALEO"), (792, "LUNALA"), (793, "NIHILEGO"),
    (794, "BUZZWOLE"), (795, "PHEROMOSA"), (796, "XURKITREE"), (797, "CELESTEELA"),
    (798, "KARTANA"), (799, "GUZZLORD"), (800, "NECROZMA"), (801, "MAGEARNA"),
    (802, "MARSHADOW"), (803, "POIPOLE"), (804, "NAGANADEL"), (805, "STAKATAKA"),
    (806, "BLACEPHALON"), (807, "ZERAORA"), (808, "MELTAN"), (809, "MELMETAL"),
]

GEN8_SPECIES = [
    (810, "GROOKEY"), (811, "THWACKEY"), (812, "RILLABOOM"), (813, "SCORBUNNY"),
    (814, "RABOOT"), (815, "CINDERACE"), (816, "SOBBLE"), (817, "DRIZZILE"),
    (818, "INTELEON"), (819, "SKWOVET"), (820, "GREEDENT"), (821, "ROOKIDEE"),
    (822, "CORVISQUIRE"), (823, "CORVIKNIGHT"), (824, "BLIPBUG"), (825, "DOTTLER"),
    (826, "ORBEETLE"), (827, "NICKIT"), (828, "THIEVUL"), (829, "GOSSIFLEUR"),
    (830, "ELDEGOSS"), (831, "WOOLOO"), (832, "DUBWOOL"), (833, "CHEWTLE"),
    (834, "DREDNAW"), (835, "YAMPER"), (836, "BOLTUND"), (837, "ROLYCOLY"),
    (838, "CARKOL"), (839, "COALOSSAL"), (840, "APPLIN"), (841, "FLAPPLE"),
    (842, "APPLETUN"), (843, "SILICOBRA"), (844, "SANDACONDA"), (845, "CRAMORANT"),
    (846, "ARROKUDA"), (847, "BARRASKEWDA"), (848, "TOXEL"), (849, "TOXTRICITY"),
    (850, "SIZZLIPEDE"), (851, "CENTISKORCH"), (852, "CLOBBOPUS"), (853, "GRAPPLOCT"),
    (854, "SINISTEA"), (855, "POLTEAGEIST"), (856, "HATENNA"), (857, "HATTREM"),
    (858, "HATTERENE"), (859, "IMPIDIMP"), (860, "MORGREM"), (861, "GRIMMSNARL"),
    (862, "OBSTAGOON"), (863, "PERRSERKER"), (864, "CURSOLA"), (865, "SIRFETCHD"),
    (866, "MRRIME"), (867, "RUNERIGUS"), (868, "MILCERY"), (869, "ALCREMIE"),
    (870, "FALINKS"), (871, "PINCURCHIN"), (872, "SNOM"), (873, "FROSMOTH"),
    (874, "STONJOURNER"), (875, "EISCUE"), (876, "INDEEDEE"), (877, "MORPEKO"),
    (878, "CUFANT"), (879, "COPPERAJAH"), (880, "DRACOZOLT"), (881, "ARCTOZOLT"),
    (882, "DRACOVISH"), (883, "ARCTOVISH"), (884, "DURALUDON"), (885, "DREEPY"),
    (886, "DRAKLOAK"), (887, "DRAGAPULT"), (888, "ZACIAN"), (889, "ZAMAZENTA"),
    (890, "ETERNATUS"), (891, "KUBFU"), (892, "URSHIFU"), (893, "ZARUDE"),
    (894, "REGIELEKI"), (895, "REGIDRAGO"), (896, "GLASTRIER"), (897, "SPECTRIER"),
    (898, "CALYREX"), (899, "WYRDEER"), (900, "KLEAVOR"), (901, "URSALUNA"),
    (902, "BASCULEGION"), (903, "SNEASLER"), (904, "OVERQWIL"), (905, "ENAMORUS"),
]

GEN9_SPECIES = [
    (906, "SPRIGATITO"), (907, "FLORAGATO"), (908, "MEOWSCARADA"), (909, "FUECOCO"),
    (910, "CROCALOR"), (911, "SKELEDIRGE"), (912, "QUAXLY"), (913, "QUAXWELL"),
    (914, "QUAQUAVAL"), (915, "LECHONK"), (916, "OINKOLOGNE"), (917, "TAROUNTULA"),
    (918, "SPIDOPS"), (919, "NYMBLE"), (920, "LOKIX"), (921, "PAWMI"),
    (922, "PAWMO"), (923, "PAWMOT"), (924, "TANDEMAUS"), (925, "MAUSHOLD"),
    (926, "FIDOUGH"), (927, "DACHSBUN"), (928, "SMOLIV"), (929, "DOLLIV"),
    (930, "ARBOLIVA"), (931, "SQUAWKABILLY"), (932, "NACLI"), (933, "NACLSTACK"),
    (934, "GARGANACL"), (935, "CHARCADET"), (936, "ARMAROUGE"), (937, "CERULEDGE"),
    (938, "TADBULB"), (939, "BELLIBOLT"), (940, "WATTREL"), (941, "KILOWATTREL"),
    (942, "MASCHIFF"), (943, "MABOSSTIFF"), (944, "SHROODLE"), (945, "GRAFAIAI"),
    (946, "BRAMBLIN"), (947, "BRAMBLEGHAST"), (948, "TOEDSCOOL"), (949, "TOEDSCRUEL"),
    (950, "KLAWF"), (951, "CAPSAKID"), (952, "SCOVILLAIN"), (953, "RELLOR"),
    (954, "RABSCA"), (955, "FLITTLE"), (956, "ESPATHRA"), (957, "TINKATINK"),
    (958, "TINKATUFF"), (959, "TINKATON"), (960, "WIGLETT"), (961, "WUGTRIO"),
    (962, "BOMBIRDIER"), (963, "FINIZEN"), (964, "PALAFIN"), (965, "VAROOM"),
    (966, "REVAVROOM"), (967, "CYCLIZAR"), (968, "ORTHWORM"), (969, "GLIMMET"),
    (970, "GLIMMORA"), (971, "GREAVARD"), (972, "HOUNDSTONE"), (973, "FLAMIGO"),
    (974, "CETODDLE"), (975, "CETITAN"), (976, "VELUZA"), (977, "DONDOZO"),
    (978, "TATSUGIRI"), (979, "ANNIHILAPE"), (980, "CLODSIRE"), (981, "FARIGIRAF"),
    (982, "DUDUNSPARCE"), (983, "KINGAMBIT"), (984, "GREATTUSK"), (985, "SCREAMTAIL"),
    (986, "BRUTEBONNET"), (987, "FLUTTERMANE"), (988, "SLITHERWING"), (989, "SANDYSHOCKS"),
    (990, "IRONTREADS"), (991, "IRONBUNDLE"), (992, "IRONHANDS"), (993, "IRONJUGULIS"),
    (994, "IRONMOTH"), (995, "IRONTHORNS"), (996, "FRIGIBAX"), (997, "ARCTIBAX"),
    (998, "BAXCALIBUR"), (999, "GIMMIGHOUL"), (1000, "GHOLDENGO"), (1001, "WOCHIEN"),
    (1002, "CHIENPAO"), (1003, "TINGLU"), (1004, "CHIYU"), (1005, "ROARINGMOON"),
    (1006, "IRONVALIANT"), (1007, "KORAIDON"), (1008, "MIRAIDON"), (1009, "WALKINGWAKE"),
    (1010, "IRONLEAVES"), (1011, "DIPPLIN"), (1012, "POLTCHAGEIST"), (1013, "SINISTCHA"),
    (1014, "OKIDOGI"), (1015, "MUNKIDORI"), (1016, "FEZANDIPITI"), (1017, "OGERPON"),
    (1018, "ARCHALUDON"), (1019, "HYDRAPPLE"), (1020, "GOUGINGFIRE"), (1021, "RAGINGBOLT"),
    (1022, "IRONBOULDER"), (1023, "IRONCROWN"), (1024, "TERAPAGOS"), (1025, "PECHARUNT"),
]

GEN_MAP = {
    5: GEN5_SPECIES,
    6: GEN6_SPECIES,
    7: GEN7_SPECIES,
    8: GEN8_SPECIES,
    9: GEN9_SPECIES,
}


def run_step(script: Path, extra_args: list[str], label: str):
    cmd = [sys.executable, str(script)] + extra_args
    print(f"\n{'─'*60}")
    print(f"  {label}")
    print(f"{'─'*60}")
    result = subprocess.run(cmd)
    if result.returncode != 0:
        print(f"[ERROR] {label} failed (exit {result.returncode})", file=sys.stderr)
        sys.exit(result.returncode)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pack",         required=True)
    ap.add_argument("--pokeplatinum", required=True)
    ap.add_argument("--generation",   type=int, choices=[5, 6, 7, 8, 9],
                    help="Process a full generation")
    ap.add_argument("--dex-range",    nargs=2, type=int, metavar=("START", "END"),
                    help="Process dex numbers START through END (inclusive)")
    args = ap.parse_args()

    pack = args.pack
    pt   = args.pokeplatinum
    here = Path(__file__).parent

    # Collect species for this run
    if args.generation:
        species_list = GEN_MAP[args.generation]
    elif args.dex_range:
        start, end = args.dex_range
        species_list = [
            (num, name)
            for gen_list in GEN_MAP.values()
            for num, name in gen_list
            if start <= num <= end
        ]
        species_list.sort(key=lambda x: x[0])
    else:
        ap.error("Provide --generation or --dex-range")
        return

    if not species_list:
        print("No species matched.", file=sys.stderr)
        sys.exit(1)

    names        = [name        for _, name in species_list]
    name_num     = [f"{name}:{num}" for num, name in species_list]

    print(f"Processing {len(species_list)} species")

    # Step 1: PBS → data.json
    run_step(
        here / "convert_pbs.py",
        ["--pack", pack, "--pokeplatinum", pt, "--only"] + names,
        "Step 1: PBS → data.json",
    )

    # Step 2: sprites
    run_step(
        here / "convert_sprites.py",
        ["--pack", pack, "--pokeplatinum", pt, "--species"] + names,
        "Step 2: Sprites",
    )

    # Step 3: cries
    run_step(
        here / "convert_cries.py",
        ["--pack", pack, "--pokeplatinum", pt, "--species"] + name_num,
        "Step 3: Cries",
    )

    # Step 4: update generated/species.txt
    species_txt = Path(pt) / "generated" / "species.txt"
    existing    = species_txt.read_text().splitlines()
    existing_set = set(existing)

    new_lines = []
    for _, name in species_list:
        const = f"SPECIES_{name}"
        if const not in existing_set:
            new_lines.append(const)

    if new_lines:
        # Insert before SPECIES_EGG and SPECIES_BAD_EGG if present
        if "SPECIES_EGG" in existing:
            idx = existing.index("SPECIES_EGG")
            updated = existing[:idx] + new_lines + existing[idx:]
        else:
            updated = existing + new_lines

        species_txt.write_text("\n".join(updated) + "\n")
        print(f"\n[OK] Added {len(new_lines)} entries to generated/species.txt")
    else:
        print(f"\n[OK] generated/species.txt already up to date")

    # Step 5: print the meson.build patch needed
    print(f"\n{'─'*60}")
    print("Step 5: Add these lines to res/pokemon/meson.build")
    print("        (find the existing species list and append before the closing bracket)")
    print(f"{'─'*60}")
    pt_path = Path(pt)
    for _, name in species_list:
        folder = name.lower()
        poke_dir = pt_path / "res" / "pokemon" / folder
        if poke_dir.exists():
            print(f"  subdir('{folder}')")

    print(f"\nAll steps complete for {len(species_list)} species.")
    print("Next: add entries to res/pokemon/meson.build, then run: cd pokeplatinum && make rom")


if __name__ == "__main__":
    main()
