"""Generates the Medzee launcher icons (legacy + adaptive) from one geometry.

The same capsule geometry lives in lib/presentation/shared/medzee_logo.dart.
Run: python tool/make_icons.py
"""
import os
from PIL import Image, ImageDraw

RES = os.path.join(os.path.dirname(__file__), "..", "android", "app", "src", "main", "res")
SS = 4  # supersampling


def lerp(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


def gradient(size):
    """Flat brand colour (name kept for call sites)."""
    return Image.new("RGB", (size, size), (91, 91, 240))


def capsule_layer(size, scale):
    """Capsule (white + mint halves) rotated -45deg on transparent bg."""
    L, W = size * 0.56 * scale, size * 0.27 * scale
    s = size * SS
    big = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    cx = cy = s / 2
    l, w = L * SS, W * SS
    cap = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    d = ImageDraw.Draw(cap)
    d.rounded_rectangle([cx - l / 2, cy - w / 2, cx + l / 2, cy + w / 2], radius=w / 2, fill=(255, 255, 255, 255))
    half = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    hd = ImageDraw.Draw(half)
    hd.rectangle([cx, cy - w, cx + l, cy + w], fill=(201, 201, 255, 255))
    mask = cap.split()[3]
    tint = Image.composite(half, Image.new("RGBA", (s, s), (0, 0, 0, 0)), mask)
    cap.alpha_composite(tint)
    # seam highlight
    d2 = ImageDraw.Draw(cap)
    d2.rectangle([cx - w * 0.02, cy - w / 2 + 2, cx + w * 0.02, cy + w / 2 - 2], fill=(61, 61, 209, 70))
    # leaf sprout on the white end
    lf = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    ld = ImageDraw.Draw(lf)
    r = w * 0.17
    ex = cx - l / 2 + w * 0.5
    cap.alpha_composite(lf)
    rot = cap.rotate(45, resample=Image.BICUBIC, center=(cx, cy))
    # soft shadow
    sh = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    sh.paste((20, 20, 80, 60), mask=rot.split()[3])
    from PIL import ImageFilter
    sh = sh.filter(ImageFilter.GaussianBlur(s * 0.018))
    sh = sh.transform(sh.size, Image.AFFINE, (1, 0, 0, 0, 1, -s * 0.014))
    big.alpha_composite(sh)
    big.alpha_composite(rot)
    return big.resize((size, size), Image.LANCZOS)


def legacy(size):
    bg = gradient(size).convert("RGBA")
    bg.alpha_composite(capsule_layer(size, 1.3))
    return bg


def foreground(size):
    return capsule_layer(size, 0.8)


def save(img, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path)


def main():
    for d, px in {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}.items():
        sq = legacy(px)
        save(sq, f"{RES}/mipmap-{d}/ic_launcher.png")
    for d, px in {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}.items():
        save(foreground(px), f"{RES}/mipmap-{d}/ic_launcher_foreground.png")
    save(gradient(432), f"{RES}/mipmap-xxxhdpi/ic_launcher_background.png")
    xml = ('<?xml version="1.0" encoding="utf-8"?>\n'
           '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
           '    <background android:drawable="@mipmap/ic_launcher_background"/>\n'
           '    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>\n'
           '</adaptive-icon>\n')
    os.makedirs(f"{RES}/mipmap-anydpi-v26", exist_ok=True)
    open(f"{RES}/mipmap-anydpi-v26/ic_launcher.xml", "w").write(xml)
    save(legacy(1024), os.path.join(os.path.dirname(__file__), "..", "assets", "brand", "medzee_icon.png"))
    save(foreground(1024), os.path.join(os.path.dirname(__file__), "..", "assets", "brand", "medzee_mark.png"))


main()
