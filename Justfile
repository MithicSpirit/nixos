default: gitadd standard

format: clean-artifact
    nix fmt -- --width=80 --verify .

check:
    nix flake check --all-systems
    nix run .#deadnix -- --fail

undead: gitadd && standard
    nix run .#deadnix -- --edit

update: gitadd && standard
    nix flake update

[confirm]
gc: sudo && boot clean
    # delete user roots first
    nix-collect-garbage -v --delete-older-than 17d --max-freed 0
    sudo nix-collect-garbage -v --delete-older-than 17d --max-freed 0

build: gitadd
    nixos-rebuild build --flake ".#$(hostname)"

clean: clean-artifact
    nix-collect-garbage -v

package pkg: gitadd
    nix build '.#{{ pkg }}'

test: (rebuild 'test')

boot: (rebuild 'boot')

switch: (rebuild 'switch')

[private]
rebuild op: build sudo
    sudo nixos-rebuild '{{ op }}' --flake ".#$(hostname)"

[private]
clean-artifact:
    -[ -h result ] && rm -f result

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
