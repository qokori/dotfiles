#!/bin/bash
if [ -f /tmp/wallpaper_changing.lock ]; then
    exit 0
fi
touch /tmp/wallpaper_changing.lock
trap "rm -f /tmp/wallpaper_changing.lock" EXIT

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Error" "Folder $WALLPAPER_DIR not found"
    exit 1
fi

list_wallpapers() {
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | while read -r file; do
        filename=$(basename "$file")
        echo -en "$filename\0icon\x1f$file\n"
    done
}

SELECTED=$(list_wallpapers | rofi -dmenu -i -p "" -show-icons -theme ~/.config/rofi/theme.rasi)

if [ -z "$SELECTED" ]; then
    exit 0
fi

FULL_PATH="$WALLPAPER_DIR/$SELECTED"

swww img "$FULL_PATH" \
  --transition-type wipe \
  --transition-angle 30 \
  --transition-duration 0.5 \
  --transition-fps 120

wallust run "$FULL_PATH" -C ~/.config/wallust/wallust.toml --skip-sequences
pkill waybar
sleep 1
waybar &
hyprctl reload
