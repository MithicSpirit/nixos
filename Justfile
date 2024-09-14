default: gitadd standard

format: clean
    nix fmt -- --width=80 --verify .

check:
    nix flake check --all-systems
    nix run .#deadnix -- --fail

undead: gitadd && standard
    nix run .#deadnix -- --edit

update: gitadd && standard
    nix flake update

[confirm]
gc: clean sudo
    nix-env -v --delete-generations 14d  # delete user roots
    sudo nix-env -v --delete-generations 14d
    sudo nix-store -v --gc

build: gitadd
    nixos-rebuild build --flake ".#$(hostname)"

clean:
    rm -f result

rebuild operation: build sudo
    sudo nixos-rebuild '{{operation}}' --flake ".#$(hostname)"

package pkg: gitadd
    nix build '.#{{pkg}}'

test: (rebuild 'test')
boot: (rebuild 'boot')

[private]
sudo:
    #!/usr/bin/env -S sh -eux
    if [ -n "${WAYLAND_DISPLAY:-}" ] || [ -n "${DISPLAY:-}" ]; then
        id="$(notify-send -t 60000 -pea 'NixOS Rebuild' 'Sudo prompt' 'Waiting')"
        sudo -v
        notify-send -r "$id" -t 2000 -u low -ea 'NixOS Rebuild' 'Sudo prompt' 'Done'
    else
        sudo -v
    fi

[private]
standard: format check

[private]
gitadd:
    git add .
