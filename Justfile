default: gitadd standard

alias fmt:=format
format *args:
    nix fmt -- {{ args }}

check:
    nix flake check --all-systems
    nix run .#deadnix -- {{ deadnix-args }} --fail

undead: gitadd && standard
    nix run .#deadnix -- {{ deadnix-args }} --edit

update *inputs: gitadd && standard
    nix flake update {{ inputs }}

[confirm]
gc: sudo && boot clean
    nix-collect-garbage -v --delete-older-than 22d --max-freed 0
    sudo nix-collect-garbage -v --delete-older-than 22d --max-freed 0

build: gitadd
    nixos-rebuild build --flake '.#{{ host }}' |& nom

clean: clean-artifact
    nix store gc -v

package pkg *args: gitadd
    nom build {{ args }} '.#{{ pkg }}'

test: (rebuild 'test') system

boot: (rebuild 'boot')

switch: (rebuild 'switch') system

[private]
rebuild op: build sudo
    sudo nixos-rebuild '{{ op }}' --flake '.#{{ host }}' |& nom

[private]
clean-artifact:
    rm -f result result-*

[private]
sudo:
    #!/usr/bin/env -S sh -eux
    if [ -n "${WAYLAND_DISPLAY:-}" -o -n "${DISPLAY:-}" ]; then
        id="$(notify-send -t 600000 -pea 'NixOS Rebuild' 'Sudo prompt' 'Waiting')"
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

[private]
system:
    -@fastfetch

deadnix-args := "--exclude ./overlays/temporary"
host := `hostname`
