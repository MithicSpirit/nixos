default: format check

format:
    nix fmt -- --width=80 --verify .

check:
    nix flake check --all-systems
    nix run .#deadnix -- --fail

undead: && default
    nix run .#deadnix -- --edit

update: && default
    nix flake update

boot: _sudo _gitadd default
    sudo nixos-rebuild boot --flake ".#$(hostname)"

test: _sudo _gitadd default
    sudo nixos-rebuild test --flake ".#$(hostname)"


_sudo:
    sudo -v
_gitadd:
    git add .
