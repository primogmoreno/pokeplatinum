#!/usr/bin/env python3
"""
convert_cries.py — Convert Gen 1-9 pack OGG cries to NDS SWAV format.

For each species, reads:
  generation_1_9_pack/Audio/SE/Cries/<NAME>.ogg

And writes:
  res/sound/pl_sound_data/Files/WAVARC/WAVE_ARC_PV<NNN>/00.swav

SWAV format (NDS):
  0x00  4  magic "SWAV"
  0x04  2  BOM 0xFEFF
  0x06  2  version 0x0100
  0x08  4  file size
  0x0C  2  header size = 0x0010
  0x0E  2  num blocks = 1
  0x10  4  "DATA"
  0x14  4  DATA block size (includes this field and what follows)
  0x18  1  codec (0 = PCM8)
  0x19  1  loop flag (0 = no loop)
  0x1A  2  sample rate
  0x1C  2  timer = 16756991 / sample_rate
  0x1E  2  loop offset = 0
  0x20  4  non-loop length = len(pcm_bytes) / 4
  0x24  …  PCM8 audio data (signed 8-bit, mono)

Requires: ffmpeg on PATH

Usage:
  python3 convert_cries.py --pack /path/to/generation_1_9_pack \
                            --pokeplatinum /path/to/pokeplatinum \
                            --species VICTINI:494 SNIVY:495 ...
  OR via a mapping file (one line = SPECIES:DEXNUM):
  python3 convert_cries.py --pack ... --pokeplatinum ... --mapping-file cries_map.txt
"""

import argparse
import array
import struct
import sys
from pathlib import Path

import miniaudio

SAMPLE_RATE = 10512                        # matches existing NDS Platinum cries
TIMER       = 16756991 // SAMPLE_RATE      # = 1594


def pcm8_to_swav(pcm_bytes: bytes, sample_rate: int = SAMPLE_RATE) -> bytes:
    timer        = 16756991 // sample_rate
    non_loop_len = len(pcm_bytes) // 4
    data_block_size = 4 + 4 + 12 + len(pcm_bytes)   # "DATA" + size + fields + audio
    file_size       = 16 + data_block_size

    buf = bytearray()
    # SWAV header
    buf += b"SWAV"
    buf += struct.pack("<H", 0xFEFF)        # BOM
    buf += struct.pack("<H", 0x0100)        # version
    buf += struct.pack("<I", file_size)
    buf += struct.pack("<H", 0x0010)        # header size
    buf += struct.pack("<H", 1)             # num blocks
    # DATA block
    buf += b"DATA"
    buf += struct.pack("<I", data_block_size)
    buf += struct.pack("B",  0)             # codec: PCM8
    buf += struct.pack("B",  0)             # no loop
    buf += struct.pack("<H", sample_rate)
    buf += struct.pack("<H", timer)
    buf += struct.pack("<H", 0)             # loop offset
    buf += struct.pack("<I", non_loop_len)
    buf += pcm_bytes
    return bytes(buf)


def ogg_to_pcm8(ogg_path: Path) -> bytes:
    """Decode OGG → resample to SAMPLE_RATE Hz, convert to signed 8-bit PCM mono."""
    try:
        decoded = miniaudio.decode_file(
            str(ogg_path),
            output_format=miniaudio.SampleFormat.SIGNED16,
            nchannels=1,
            sample_rate=SAMPLE_RATE,
        )
    except Exception as e:
        print(f"  [WARN] miniaudio failed for {ogg_path.name}: {e}", file=sys.stderr)
        return b""

    # decoded.samples is a memoryview of int16 samples (signed 16-bit)
    samples_s16 = array.array("h", decoded.samples)

    # Downscale signed 16-bit → signed 8-bit (divide by 256)
    samples_s8 = bytes(
        max(-128, min(127, s >> 8)) & 0xFF for s in samples_s16
    )

    # Ensure length is a multiple of 4 (required by SWAV non-loop-len field)
    remainder = len(samples_s8) % 4
    if remainder:
        samples_s8 += b"\x00" * (4 - remainder)

    return samples_s8


def convert_cry(pack_dir: Path, poke_dir: Path, pack_name: str, dex_num: int) -> bool:
    cry_src = pack_dir / "Audio" / "SE" / "Cries" / f"{pack_name.upper()}.ogg"
    if not cry_src.exists():
        print(f"  [WARN] No cry found for {pack_name} at {cry_src}", file=sys.stderr)
        return False

    pcm = ogg_to_pcm8(cry_src)
    if not pcm:
        return False

    swav_data = pcm8_to_swav(pcm)

    arc_name  = f"WAVE_ARC_PV{dex_num:03d}"
    arc_dir   = poke_dir / "res" / "sound" / "pl_sound_data" / "Files" / "WAVARC" / arc_name
    arc_dir.mkdir(parents=True, exist_ok=True)

    out_path = arc_dir / "00.swav"
    out_path.write_bytes(swav_data)
    print(f"  [OK] {pack_name} → {arc_name}/00.swav ({len(swav_data)} bytes)")
    return True


def main():
    ap = argparse.ArgumentParser(description="Convert pack OGG cries to SWAV")
    ap.add_argument("--pack",          required=True, help="Path to generation_1_9_pack/")
    ap.add_argument("--pokeplatinum",  required=True, help="Path to pokeplatinum/")
    ap.add_argument("--species",       nargs="*",     help="NAME:DEXNUM pairs e.g. VICTINI:494")
    ap.add_argument("--mapping-file",  help="File with one NAME:DEXNUM per line")
    args = ap.parse_args()

    pack_dir  = Path(args.pack)
    poke_base = Path(args.pokeplatinum)

    pairs: list[tuple[str, int]] = []
    if args.species:
        raw = args.species
    elif args.mapping_file:
        raw = [l.strip() for l in Path(args.mapping_file).read_text().splitlines() if l.strip()]
    else:
        ap.error("Provide --species or --mapping-file")
        return

    for entry in raw:
        if ":" not in entry:
            print(f"[SKIP] Bad format (expected NAME:DEXNUM): {entry}", file=sys.stderr)
            continue
        name, num_str = entry.split(":", 1)
        try:
            pairs.append((name.strip().upper(), int(num_str.strip())))
        except ValueError:
            print(f"[SKIP] Bad dex number in: {entry}", file=sys.stderr)

    ok = 0
    fail = 0
    for pack_name, dex_num in pairs:
        if convert_cry(pack_dir, poke_base, pack_name, dex_num):
            ok += 1
        else:
            fail += 1

    print(f"\nDone: {ok} converted, {fail} skipped/failed")


if __name__ == "__main__":
    main()
