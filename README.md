# Install nixos
```
# mount /dev/disk/by-label/nixos /mnt
# mkdir -p /mnt/boot
# mount /dev/disk/by-label/EFI /mnt/boot 
```

# Install these dotfiles
```
nix-shell -p git nixFlakes

# Set HOST to the desired hostname of this system
HOST=k6-nix
# Set USER to your desired username (defaults to hlissner)
USER=...

git clone https://github.com/stanosaka/nixnad /mnt/etc/nixos
cd /mnt/etc/nixos

# Create a host config in `nodess/`
rm -f nodes/$HOST/hardware-configuration.nix
nixos-generate-config --root /mnt --dir /etc/nixos/nodes/$HOST
git add nodes/$HOST

# Install nixOS
USER=$USER nixos-install --root /mnt --impure --flake .#$HOST

# If you get 'unrecognized option: --impure', replace '--impure' with
# `--option pure-eval no`.
```
