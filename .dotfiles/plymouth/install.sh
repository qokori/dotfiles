#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIF="$SCRIPT_DIR/arch-i-use-arch-btw.gif"

# Extract frames
ffmpeg -i "$GIF" \
  -vf "scale=300:300:force_original_aspect_ratio=decrease,pad=300:300:(ow-iw)/2:(oh-ih)/2:color=black" \
  /tmp/arch-frame-%02d.png

# Replace cachyos theme frames
sudo bash -c 'for i in $(seq 0 87); do cp /tmp/arch-frame-$(printf "%02d" $i).png /usr/share/plymouth/themes/cachyos-bootanimation/animation-$(printf "%02d" $i).png; done'

# Rebuild initramfs
sudo plymouth-set-default-theme cachyos-bootanimation --rebuild-initrd

echo "Done! Reboot to see the animation."
