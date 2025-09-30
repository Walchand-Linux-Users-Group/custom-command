#!/usr/bin/env python3
"""
generate_ascii.py

Download a Pokémon sprite from PokeAPI and convert it to ASCII art.
Caches results in ~/.cache/pokemon-ascii/<name>.txt

Dependencies: Pillow (PIL) only. Uses only standard library for HTTP.
"""
import argparse
import io
import json
import os
import sys
import urllib.request
from pathlib import Path

ASCII_CHARS = "@%#*+=-:. "


def fetch_pokemon_sprite(name):
    url = f"https://pokeapi.co/api/v2/pokemon/{name.lower()}"
    try:
        with urllib.request.urlopen(url, timeout=10) as r:
            data = json.load(r)
    except Exception as e:
        raise RuntimeError(f"failed to fetch pokedata: {e}")

    # try official-artwork first, then front_default
    sprites = data.get("sprites", {})
    sprite_url = None
    try:
        sprite_url = sprites.get("other", {}).get("official-artwork", {}).get("front_default")
    except Exception:
        sprite_url = None
    if not sprite_url:
        sprite_url = sprites.get("front_default")
    if not sprite_url:
        raise RuntimeError("no sprite available for this Pokémon")

    try:
        with urllib.request.urlopen(sprite_url, timeout=10) as img_r:
            return img_r.read()
    except Exception as e:
        raise RuntimeError(f"failed to download sprite: {e}")


def image_to_ascii(img_bytes, width=60):
    try:
        from PIL import Image
    except Exception as e:
        raise RuntimeError("Pillow (PIL) is required. Install with: pip3 install pillow")

    img = Image.open(io.BytesIO(img_bytes)).convert("L")

    # maintain aspect ratio, adjust for font height
    w, h = img.size
    aspect = h / w
    new_w = max(10, int(width))
    new_h = max(3, int(aspect * new_w * 0.55))
    img = img.resize((new_w, new_h))

    pixels = img.getdata()
    chars = [ASCII_CHARS[pixel * (len(ASCII_CHARS) - 1) // 255] for pixel in pixels]
    lines = ["".join(chars[i:i+new_w]) for i in range(0, len(chars), new_w)]
    return "\n".join(lines)


def main():
    p = argparse.ArgumentParser(description="Generate ASCII art for a Pokémon by name or id")
    p.add_argument("name", help="Pokémon name or id")
    p.add_argument("--width", type=int, default=60, help="ASCII width (default 60)")
    p.add_argument("--cache-dir", default=str(Path.home() / ".cache" / "pokemon-ascii"))
    args = p.parse_args()

    cache_dir = Path(args.cache_dir)
    cache_dir.mkdir(parents=True, exist_ok=True)
    cache_file = cache_dir / f"{args.name.lower()}.txt"

    # if cached, print and exit
    if cache_file.exists():
        sys.stdout.write(cache_file.read_text())
        return

    try:
        img_bytes = fetch_pokemon_sprite(args.name)
    except Exception as e:
        sys.stderr.write(str(e) + "\n")
        sys.exit(2)

    try:
        ascii_art = image_to_ascii(img_bytes, width=args.width)
    except Exception as e:
        sys.stderr.write(str(e) + "\n")
        sys.exit(3)

    try:
        cache_file.write_text(ascii_art)
    except Exception:
        # ignore cache write errors
        pass

    sys.stdout.write(ascii_art)


if __name__ == "__main__":
    main()
