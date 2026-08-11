[default]
default: gitadd standard
standard: gitprepare format check

fmt *args: gitprepare
    nix fmt -- {{ args }}
format: (fmt '.')
    just --fmt

check: gitprepare
    nom flake check --all-systems

undead: gitadd && standard
    deadnix --edit

refresh *inputs: gitprepare && standard
    nom flake update {{ inputs }}
update *inputs: gitadd (refresh inputs)

lock *args: gitprepare && standard
    nom flake lock {{ args }}

[confirm]
[no-cd]
gc: (sudo 'Garbage collection') && boot clean
    nix-collect-garbage -v --delete-older-than 22d --max-freed 0
    sudo nix-collect-garbage -v --delete-older-than 22d --max-freed 0

[no-cd]
clean: clean-artifact
    nix store gc -v

package pkg *args: gitprepare
    nom build '.#{{ pkg }}' {{ args }}

[group('nixos')]
build *args: gitprepare
    nom build '.#nixosConfigurations.{{ host }}.config.system.build.toplevel' {{ args }}

[group('nixos')]
diff: check build
    nvd diff /nix/var/nix/profiles/system ./result

[group('nixos')]
test: check (activate 'test') system

[group('nixos')]
boot: gitadd check (activate 'boot')

[group('nixos')]
switch: gitadd check (activate 'switch') system

[group('nixos')]
[private]
activate op: build (sudo "nixos " + op)
    sudo nixos-rebuild '{{ op }}' --flake '.#{{ host }}'

# helpers

[private]
clean-artifact:
    rm -f result result-* repl-result-*

[no-cd]
[private]
[script]
sudo $reason:
    if [ -n "${WAYLAND_DISPLAY:-}" -o -n "${DISPLAY:-}" ]; then
        id="$(notify-send -pea 'just' 'Sudo prompt' "Waiting (${reason})")"
        if sudo -v; then
            notify-send -r "$id" -t 2000 -u low -ea 'just' 'Sudo prompt' "Done (${reason})"
        else
            notify-send -r "$id" -t 2000 -u low -ea 'just' 'Sudo prompt' "Cancelled (${reason})"
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

[no-cd]
[private]
system:
    -@fastfetch

host := `hostname`

set shell := ['bash', '-euo', 'pipefail', '-c']
set script-interpreter := ['bash', '-euxo', 'pipefail']
set unstable

# nonnix

alias flatpak := flatpak-check

[group('non-nix')]
[no-cd]
flatpak-check:
    flatpak update --no-deploy -yu

[group('non-nix')]
[no-cd]
flatpak-update:
    flatpak update

alias fwupd := fwupd-check

[group('non-nix')]
[no-cd]
fwupd-check: (sudo 'fwupdmgr check')
    sudo fwupdmgr refresh --force --no-unreported-check
    -sudo fwupdmgr get-updates --no-unreported-check

[group('non-nix')]
[no-cd]
fwupd-update: (sudo 'fwupdmgr update')
    sudo fwupdmgr update --no-unreported-check
