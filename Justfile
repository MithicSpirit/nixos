default: format check

format:
    nix fmt -- --width=80 .

check:
    nix flake check --all-systems
    nix run .#deadnix -- --fail

undead: && check
    nix run .#deadnix -- --edit

update: && format check
    nix flake update
