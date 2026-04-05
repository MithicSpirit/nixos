[default]
default: gitadd standard
standard: gitprepare format check

fmt *args: gitprepare
    nix fmt -- {{ args }}
format: (fmt '.')

check: gitprepare
    nix flake check --all-systems
    nix run .#deadnix -- {{ deadnix-args }} --fail

undead: gitadd && standard
    nix run .#deadnix -- {{ deadnix-args }} --edit


refresh *inputs: gitprepare && standard
    nix flake update {{ inputs }}
update *inputs: gitadd (refresh inputs)

lock *args: gitprepare && standard
    nix flake lock {{ args }}

[confirm]
gc: sudo && boot clean
    nix-collect-garbage -v --delete-older-than 22d --max-freed 0
    sudo nix-collect-garbage -v --delete-older-than 22d --max-freed 0

build: gitprepare
    nixos-rebuild build --flake '.#{{ host }}' |& nom

diff: build
    nvd diff /nix/var/nix/profiles/system result

clean: clean-artifact
    nix store gc -v

package pkg *args: gitprepare
    nom build {{ args }} '.#{{ pkg }}'

test: check (rebuild 'test') system

boot: gitadd check (rebuild 'boot')

switch: gitadd check (rebuild 'switch') system

[private]
rebuild op: build sudo
    sudo nixos-rebuild '{{ op }}' --flake '.#{{ host }}' |& nom

[private]
clean-artifact:
    rm -f result result-* repl-result-*

[private, script]
sudo:
    if [ -n "${WAYLAND_DISPLAY:-}" -o -n "${DISPLAY:-}" ]; then
        id="$(notify-send -t 600000 -pea 'NixOS Rebuild' 'Sudo prompt' 'Waiting')"
        if sudo -v; then
            notify-send -r "$id" -t 2000 -u low -ea 'NixOS Rebuild' 'Sudo prompt' 'Done'
        else
            notify-send -r "$id" -t 2000 -u low -ea 'NixOS Rebuild' 'Sudo prompt' 'Cancelled'
            exit 1
        fi
    else
        sudo -v
    fi

[private]
gitadd:
    git add .

[private]
gitprepare:
    git add --intent-to-add .

[private]
system:
    -@fastfetch

deadnix-args := "--exclude ./overlays/temporary"
host := `hostname`

set shell := ['bash', '-euo', 'pipefail', '-c']
set script-interpreter := ['bash', '-euxo', 'pipefail']
set unstable
