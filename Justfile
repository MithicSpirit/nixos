default: format check

format: gitadd
    nix fmt -- --width=80 --verify .

check: gitadd
    nix flake check --all-systems
    nix run .#deadnix -- --fail

undead: gitadd && default
    nix run .#deadnix -- --edit

update: gitadd && default
    nix flake update

gc: sudo
    sudo nix-collect-garbage -v --delete-older-than 14d

rebuild operation: sudo gitadd
    sudo nixos-rebuild {{operation}} --flake ".#$(hostname)"

test: (rebuild "test")
boot: (rebuild "boot")


[private]
sudo:
    sudo -v

[private]
gitadd:
    git add .
