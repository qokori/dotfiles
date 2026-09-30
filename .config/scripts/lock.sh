#!/bin/bash

# Temporary blurred wallpaper path
LOCK_IMAGE=/tmp/lockscreen.png

# Take a screenshot
grim "$LOCK_IMAGE"

# Make sure the screenshot exists
if [[ ! -f "$LOCK_IMAGE" ]]; then
    echo "Error: Screenshot failed"
    exit 1
fi

# Blur it with ImageMagick
magick convert "$LOCK_IMAGE" -resize 50% -blur 0x8 -resize 200% "$LOCK_IMAGE"

swaylock \
    --screenshots \
    --image "$LOCK_IMAGE" \
    --effect-blur 5x5 \
    --indicator \
    --clock \
    --timestr "%H:%M:%S" \
    --datestr "%A, %d %B %Y" \
    --font "Monospace" \
    --font-size 28 \
    --indicator-radius 120 \
    --indicator-thickness 6 \
    --inside-color 000000aa \
    --ring-color ffffffaa \
    --line-color ffffffaa \
    --key-hl-color ff5555aa \
    --bs-hl-color 55ff55aa \
    --layout-bg-color 00000088 \
    --layout-text-color ffffffaa \
    --text-color ffffffaa \
    --indicator-x-position 50% \
    --indicator-y-position 50%
