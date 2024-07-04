default: format check

format: _gitadd
    nix fmt -- --width=80 --verify .

check: _gitadd
    nix flake check --all-systems
    nix run .#deadnix -- --fail

undead: _gitadd && default
    nix run .#deadnix -- --edit

update: _gitadd && default
    nix flake update

test: _sudo _gitadd
    sudo nixos-rebuild test --flake ".#$(hostname)"

boot: _sudo _gitadd
    sudo nixos-rebuild boot --flake ".#$(hostname)"


_sudo:
    sudo -v
_gitadd:
    git add .
