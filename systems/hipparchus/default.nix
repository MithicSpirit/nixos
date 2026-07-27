{
  config,
  pkgs,
  lib,
  inputs,
  root,
  overlays,
  ...
}: {
  nix = {
    package = pkgs.nixVersions.latest;
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = true;
      cores = builtins.ceil (16 * 0.5);
    };
    extraOptions = ''
      warn-dirty = false
    '';
  };

  imports =
    [
      inputs.hardware.nixosModules.framework-16-7040-amd
      inputs.disko.nixosModules.default
      inputs.home-manager.nixosModules.default
      ./hardware-configuration.nix
      ./disko.nix
    ]
    ++ map (path: root + /host + path) [
      /secure-boot
      /man
      /sshd
      /pipewire
      /dnscrypt
      /logitech
      /virt
      /gaming
      /keyd
      /bluetooth
      /tuned # or tlp, ppd
      # /sway (niri)
      /amdgpu
      # /fw-fanctrl
      /zswap # or zram
      /timezone
      /printing
    ];

  nixpkgs.overlays = overlays ++ [(final: _prev: {nix = final.nixVersions.latest;})];

  nixpkgs.config = {
    rocmSupport = true;
    allowUnfree = false; # TODO: make global?
    allowlistedLicenses = [
      {
        fullName = "Graphite Branding License";
        url = "https://graphite.art/license/#branding";
        free = false;
        redistributable = true;
      }
    ];
    permittedInsecurePackages = assert pkgs.electron_39.version == "39.8.10";
    assert lib.functionArgs pkgs.bitwarden-desktop.override ? electron_39; ["electron-39.8.10"];
  };

  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    memtest86.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.plymouth = {
    enable = false; # TODO?
    font = pkgs.iosevka-mithic + /share/fonts/truetype/iosevka-mithic.ttc;
    theme = "breeze";
  };

  boot.kernelPackages = pkgs.linuxPackages_6_18; # TODO: bump to latest.  waiting due to eve crash
  boot.kernel.sysctl = {
    "kernel.sysrq" = 244;
    "net.ipv4.tcp_keepalive_time" = 120;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = "all";

  services.fwupd.enable = true;
  systemd.services.fwupd-refresh.enable = false;
  systemd.timers.fwupd-refresh.enable = false;

  services.smartd.enable = true;
  services.btrfs.autoScrub.enable = true;

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "100%"; # fine because of swap
  };

  networking = {
    hostName = "hipparchus";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      wifi.powersave = true;
    };
    wireless.iwd.settings = {
      DriverQuirks.DefaultInterface = null;
    };
  };

  console = {
    enable = true; # default, but just to be safe
    earlySetup = true;
    keyMap = "us";
    colors = with (import (root + /common/colorscheme.nix)).raw; [
      base00
      base01
      base02
      base03
      base04
      base05
      base06
      base07
      base08
      base09
      base10
      base11
      base12
      base13
      base14
      base15
    ];
  };

  hardware.enableRedistributableFirmware = true;

  services.flatpak.enable = true;
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = ["gtk"];
  };
  services.gnome.gnome-keyring.enable = true; # TODO: use keepassxc (or bitwarden)
  services.gnome.gcr-ssh-agent.enable = false;

  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.kdeconnect = {
    enable = true; # open firewall
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  services.locate = {
    enable = true;
    package = pkgs.plocate;
    pruneBindMounts = true;
  };

  services.gpm.enable = true;

  environment.systemPackages =
    (with pkgs; [
      coreutils-full
      moreutils
      util-linux
      usbutils
      busybox
      procps
      psmisc
      (lib.lowPrio plan9port)
      comma
      nvd
      nix-tree
      nix-diff
      which
      dash
      curl
      openssh
      tmux
      ed
      vim
      emacs
      git
      alejandra
      nix-index
      htop
      findutils
      rename
      lsof
      mtr
      ldns
      smartmontools
      testdisk
      tree
      bees
      file
      zip
      unzip
      unrar-wrapper
      xkill
      fastfetch
      dotacat
      cmatrix
      neo-cowsay
      bsdgames
      sl
      fw-ectool
    ])
    ++ # get all packages from unixtools
    (
      with builtins;
        filter (p: typeOf p == "set") (attrValues pkgs.unixtools)
    );
  # TODO: environment.binsh = with pkgs; lib.getExe dash;

  programs.zsh = {
    enable = true;
    enableLsColors = true;
    enableCompletion = true;
  };
  environment.pathsToLink = ["/share/zsh"]; # fix zsh completions

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = false;
    package = null;
  };

  environment.enableDebugInfo = true;

  environment.enableAllTerminfo = true;

  users.users."mithic" = {
    description = "MithicSpirit";
    extraGroups = [
      "wheel"
      "video"
      "gamemode"
      "libvirtd"
    ];
    isNormalUser = true;
    shell = pkgs.zsh;
    initialPassword = "";
    createHome = true;
    homeMode = "755";
    linger = true;
    uid = 1000;
  };
  home-manager = {
    extraSpecialArgs = {
      inherit inputs root overlays;
      hostConfig = config;
    };
    useUserPackages = true;
    useGlobalPkgs = true;
    users."mithic" = import ./home/mithic.nix;
  };
  systemd.services."user@${toString config.users.users."mithic".uid}" = {
    environment =
      builtins.mapAttrs (
        _name: toString
      )
      config.home-manager.users."mithic".home.sessionVariables;
    overrideStrategy = "asDropin";
  };

  services.geoclue2 = {
    enable = true;
    geoProviderUrl = "https://beacondb.net/v1/geolocate";
    submitData = true;
    submissionUrl = "https://beacondb.net/v2/geosubmit";
  };

  programs.nano.enable = false;

  services.logind.settings.Login = rec {
    HandlePowerKey = HandleSuspendKey;
    HandlePowerKeyLongPress = "poweroff";
    HandleLidSwitch = HandleSuspendKey;

    HandleSuspendKey = "suspend-then-hibernate";
    HandleSuspendKeyLongPress = HandleHibernateKey;

    HandleHibernateKey = "hibernate";
    HandleHibernateKeyLongPress = HandleSuspendKey;
  };

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "1day";
    SuspendEstimationSec = "0s";
  };

  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "60s";
  };

  services.upower.enable = true;
  services.dbus.implementation = "broker";

  security.pam.services."hyprlock" = {
    fprintAuth = false;
  };

  programs.gamemode.settings.gpu.gpu_device = 1;

  services.languagetool = {
    enable = true;
    jvmOptions = ["-Xmx512m"];
    allowOrigin = "*";
    settings = {
      fasttextModel = pkgs.fetchurl {
        url = "https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin";
        hash = "sha256-fmnsVFG8JhzHhE5J5HkqhdfwnAZ4nsgA/EpErsNidk4=";
      };
      fasttextBinary = "${lib.getExe pkgs.fasttext}";
      maxCheckThreads = 1;
    };
  };

  # weird framework 16 stuff. see arch and nixos wikis
  services.udev.extraRules =
    # udev
    ''
      # trackpad
      ACTION=="add", SUBSYSTEM=="i2c", DRIVERS=="i2c_hid_acpi", ATTRS{name}=="PIXA3854:00", ATTR{power/wakeup}="disabled"
    '';

  # remove when properly cooled
  services.tlp.settings = {
    PLATFORM_PROFILE_ON_AC = lib.mkForce "low-power";
    CPU_ENERGY_PERF_POLICY_ON_AC = lib.mkForce "power";
  };

  systemd.services.bluetooth-rfkill-resume = {
    preStart = "${pkgs.coreutils}/bin/sleep 1";
  };

  programs.gamescope.args = [
    "-w2560"
    "-h1600"
    "-r165"
    "--adaptive-sync"
  ];
}
