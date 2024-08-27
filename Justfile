default: gitadd standard

format:
    nix fmt -- --width=80 --verify .

check:
    nix flake check --all-systems
    nix run .#deadnix -- --fail

undead: gitadd && standard
    nix run .#deadnix -- --edit

update: gitadd && standard
    nix flake update

[confirm]
gc: sudo
    rm -f result
    sudo nix-collect-garbage -v --delete-older-than 14d

rebuild operation: sudo gitadd
    sudo nixos-rebuild {{operation}} --flake ".#$(hostname)"

test: (rebuild "test")
boot: (rebuild "boot")


[private]
sudo:
    sudo -v

[private]
standard: format check

[private]
gitadd:
    git add .
