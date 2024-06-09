default: format check

format:
    nix fmt -- --width=80 --verify .

check:
    nix flake check --all-systems
    nix run .#deadnix -- --fail

undead: && format check
    nix run .#deadnix -- --edit

update: && format check
    nix flake update
