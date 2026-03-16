#!/usr/bin/env python3
"""
convert_sprites.py — Convert Gen 1-9 pack PNG sprites to pokeplatinum NDS format.

For each species name, reads from the generation_1_9_pack and writes:
  res/pokemon/<name>/male_front.png   (160×80, 16-color indexed, 2 frames side by side)
  res/pokemon/<name>/female_front.png
  res/pokemon/<name>/male_back.png
  res/pokemon/<name>/female_back.png
  res/pokemon/<name>/icon.png         (32×64, 16-color indexed, 2 frames stacked)
  res/pokemon/<name>/footprint.png    (32×16, 16-color indexed)
  res/pokemon/<name>/normal.pal       (JASC-PAL, 16 colors from normal front sprite)
  res/pokemon/<name>/shiny.pal        (JASC-PAL, 16 colors from shiny front sprite)

Usage:
  python3 convert_sprites.py --pack /path/to/generation_1_9_pack \
                              --pokeplatinum /path/to/pokeplatinum \
                              --species VICTINI SNIVY SERVINE ...
  OR:
  python3 convert_sprites.py --pack /path/to/generation_1_9_pack \
                              --pokeplatinum /path/to/pokeplatinum \
                              --species-file species_list.txt
"""

import argparse
import sys
from pathlib import Path
from PIL import Image

FRONT_SIZE  = (80, 80)
BACK_SIZE   = (80, 80)
ICON_SIZE   = (32, 32)
FOOT_SIZE   = (32, 16)
NUM_COLORS  = 16


def pad_palette(palette_flat: list[int], num_colors: int = 16) -> list[int]:
    """Ensure palette has exactly num_colors RGB entries, padding with black."""
    result = list(palette_flat[: num_colors * 3])
    while len(result) < num_colors * 3:
        result.extend([0, 0, 0])
    return result


def to_jasc_pal(palette_flat: list[int], num_colors: int = 16) -> str:
    """Convert a flat RGB palette list to JASC-PAL text."""
    pal = pad_palette(palette_flat, num_colors)
    lines = ["JASC-PAL", "0100", str(num_colors)]
    for i in range(num_colors):
        r, g, b = pal[i * 3], pal[i * 3 + 1], pal[i * 3 + 2]
        lines.append(f"{r} {g} {b}")
    return "\n".join(lines) + "\n"


def quantize_to_indexed(img: Image.Image, num_colors: int = 16) -> Image.Image:
    """Convert any PIL image to an indexed-color image with exactly num_colors palette slots."""
    rgba = img.convert("RGBA")
    # Composite onto white so transparency doesn't confuse quantization
    bg = Image.new("RGB", rgba.size, (255, 255, 255))
    bg.paste(rgba, mask=rgba.split()[3])
    quantized = bg.quantize(colors=num_colors, method=Image.Quantize.MEDIANCUT)
    # Ensure the palette stored in the image has exactly num_colors entries
    pal = pad_palette(quantized.getpalette(), num_colors)
    quantized.putpalette(pal)
    return quantized


def make_two_frame_wide(frame: Image.Image) -> Image.Image:
    """Duplicate an indexed frame side by side → 2-frame wide sprite."""
    import numpy as np
    w, h = frame.size
    arr = np.array(frame)
    wide = np.concatenate([arr, arr], axis=1)
    out = Image.fromarray(wide, mode="P")
    out.putpalette(frame.getpalette())
    return out


def make_two_frame_tall(frame: Image.Image) -> Image.Image:
    """Duplicate an indexed frame stacked vertically → 2-frame tall icon."""
    import numpy as np
    w, h = frame.size
    arr = np.array(frame)
    tall = np.concatenate([arr, arr], axis=0)
    out = Image.fromarray(tall, mode="P")
    out.putpalette(frame.getpalette())
    return out


def convert_species(pack_dir: Path, poke_dir: Path, pack_name: str, already_exists: bool) -> bool:
    """
    Convert all sprite assets for one species.
    pack_name: uppercase name used in the pack (e.g. "VICTINI")
    poke_dir:  output directory (e.g. res/pokemon/victini/)
    Returns True on success.
    """
    front_dir  = pack_dir / "Graphics" / "Pokemon" / "Front"
    back_dir   = pack_dir / "Graphics" / "Pokemon" / "Back"
    icon_dir   = pack_dir / "Graphics" / "Pokemon" / "Icons"
    foot_dir   = pack_dir / "Graphics" / "Pokemon" / "Footprints"
    shiny_dir  = pack_dir / "Graphics" / "Pokemon" / "Front shiny"

    # Locate source files — try exact name, lowercase, and uppercase .PNG extension
    def find_src(directory: Path, name: str) -> Path | None:
        for candidate in [name + ".png", name.lower() + ".png", name + ".PNG", name.lower() + ".PNG"]:
            p = directory / candidate
            if p.exists():
                return p
        return None

    front_src  = find_src(front_dir,  pack_name)
    back_src   = find_src(back_dir,   pack_name)
    icon_src   = find_src(icon_dir,   pack_name)
    shiny_src  = find_src(shiny_dir,  pack_name)
    foot_src   = find_src(foot_dir,   pack_name)

    if front_src is None:
        print(f"  [WARN] No front sprite found for {pack_name}, skipping", file=sys.stderr)
        return False

    poke_dir.mkdir(parents=True, exist_ok=True)

    # ── Normal front sprite → normal.pal + male_front.png + female_front.png ──
    front_img = Image.open(front_src)
    front_q   = quantize_to_indexed(front_img, NUM_COLORS)
    front_q   = front_q.resize(FRONT_SIZE, Image.LANCZOS).quantize(NUM_COLORS)

    (poke_dir / "normal.pal").write_text(
        to_jasc_pal(front_q.getpalette(), NUM_COLORS)
    )

    front_2f = make_two_frame_wide(front_q)
    front_2f.save(poke_dir / "male_front.png")

    # Female: use gender variant if present, else reuse male
    female_front_src = find_src(front_dir, pack_name + "_female") or front_src
    if female_front_src == front_src:
        front_2f.save(poke_dir / "female_front.png")
    else:
        ff_img = Image.open(female_front_src)
        ff_q   = quantize_to_indexed(ff_img, NUM_COLORS).resize(FRONT_SIZE, Image.LANCZOS).quantize(NUM_COLORS)
        make_two_frame_wide(ff_q).save(poke_dir / "female_front.png")

    # ── Shiny front sprite → shiny.pal ──
    if shiny_src is not None:
        shiny_img = Image.open(shiny_src)
        shiny_q   = quantize_to_indexed(shiny_img, NUM_COLORS).resize(FRONT_SIZE, Image.LANCZOS).quantize(NUM_COLORS)
        (poke_dir / "shiny.pal").write_text(
            to_jasc_pal(shiny_q.getpalette(), NUM_COLORS)
        )
    else:
        # Fall back to normal palette for shiny
        (poke_dir / "shiny.pal").write_text(
            to_jasc_pal(front_q.getpalette(), NUM_COLORS)
        )

    # ── Back sprite ──
    if back_src is not None:
        back_img = Image.open(back_src)
        back_q   = quantize_to_indexed(back_img, NUM_COLORS).resize(BACK_SIZE, Image.LANCZOS).quantize(NUM_COLORS)
        back_2f  = make_two_frame_wide(back_q)
        back_2f.save(poke_dir / "male_back.png")

        female_back_src = find_src(back_dir, pack_name + "_female")
        if female_back_src is not None:
            fb_img = Image.open(female_back_src)
            fb_q   = quantize_to_indexed(fb_img, NUM_COLORS).resize(BACK_SIZE, Image.LANCZOS).quantize(NUM_COLORS)
            make_two_frame_wide(fb_q).save(poke_dir / "female_back.png")
        else:
            back_2f.save(poke_dir / "female_back.png")
    else:
        # Use mirrored front as fallback back sprite
        mirrored = front_q.transpose(Image.FLIP_LEFT_RIGHT)
        make_two_frame_wide(mirrored).save(poke_dir / "male_back.png")
        make_two_frame_wide(mirrored).save(poke_dir / "female_back.png")

    # ── Icon ──
    if icon_src is not None:
        icon_img = Image.open(icon_src)
        icon_q   = quantize_to_indexed(icon_img, NUM_COLORS).resize(ICON_SIZE, Image.LANCZOS).quantize(NUM_COLORS)
        make_two_frame_tall(icon_q).save(poke_dir / "icon.png")
    else:
        # Thumbnail of front as fallback icon
        icon_q = front_img.copy()
        icon_q = quantize_to_indexed(icon_q, NUM_COLORS).resize(ICON_SIZE, Image.LANCZOS).quantize(NUM_COLORS)
        make_two_frame_tall(icon_q).save(poke_dir / "icon.png")

    # ── Footprint ──
    if foot_src is not None:
        foot_img = Image.open(foot_src)
        foot_q   = quantize_to_indexed(foot_img, 2).resize(FOOT_SIZE, Image.LANCZOS).quantize(2)
        # Expand to 16-color palette (NDS expects 16-color footprint too)
        foot_16  = foot_q.quantize(NUM_COLORS)
        foot_16.save(poke_dir / "footprint.png")
    else:
        # Blank footprint
        blank = Image.new("P", FOOT_SIZE, 0)
        blank.putpalette([0, 0, 0] + [255, 255, 255] + [0, 0, 0] * 14)
        blank.save(poke_dir / "footprint.png")

    print(f"  [OK] {pack_name} → {poke_dir.name}/")
    return True


def main():
    ap = argparse.ArgumentParser(description="Convert pack sprites to pokeplatinum format")
    ap.add_argument("--pack", required=True, help="Path to generation_1_9_pack/")
    ap.add_argument("--pokeplatinum", required=True, help="Path to pokeplatinum/")
    ap.add_argument("--species", nargs="*", help="Uppercase species names (e.g. VICTINI SNIVY)")
    ap.add_argument("--species-file", help="File with one species per line")
    args = ap.parse_args()

    pack_dir  = Path(args.pack)
    poke_base = Path(args.pokeplatinum) / "res" / "pokemon"

    species_list: list[str] = []
    if args.species:
        species_list = args.species
    elif args.species_file:
        species_list = [l.strip() for l in Path(args.species_file).read_text().splitlines() if l.strip()]
    else:
        ap.error("Provide --species or --species-file")

    ok = 0
    fail = 0
    for pack_name in species_list:
        folder_name = pack_name.lower()
        poke_dir    = poke_base / folder_name
        success = convert_species(pack_dir, poke_dir, pack_name, poke_dir.exists())
        if success:
            ok += 1
        else:
            fail += 1

    print(f"\nDone: {ok} converted, {fail} skipped/failed")


if __name__ == "__main__":
    main()
