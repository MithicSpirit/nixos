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
    sudo nix-collect-garbage -v --delete-older-than 14d

build: gitadd
    nixos-rebuild build --flake ".#$(hostname)"

clean:
    rm -f result

rebuild operation: build sudo
    sudo nixos-rebuild {{operation}} --flake ".#$(hostname)"

package pkg:
    nix build '.#'{{pkg}}

test: (rebuild 'test')
boot: (rebuild 'boot')

[private]
sudo:
    #!/usr/bin/env -S sh -eux
    id="$(notify-send -pea 'NixOS Rebuild' 'Sudo prompt' 'Waiting')"
    sudo -v
    notify-send -r "$id" -t 2000 -u low -ea 'NixOS Rebuild' 'Sudo prompt' 'Done'

[private]
standard: format check

[private]
gitadd:
    git add .
