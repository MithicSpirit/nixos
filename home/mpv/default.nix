{ config, pkgs, ... }: {
  programs.mpv = {
    enable = true;

    scripts = with pkgs.mpvScripts; [
      mpris
      thumbfast
      sponsorblock
      quality-menu
      autoload
    ];

    config = {
      hwdec = "auto-safe";
      video-sync = "display-resample";
      interpolation = true;
      tscale = "oversample";

      af = "scaletempo2=min-speed=1/4:max-speed=4";
      volume = "74";
      ao = "pipewire,pulse,jack,alsa";

      ytdl-raw-options-append = "format-sort=+res:1080,mark-watched=true";

      keep-open = "yes";

      cache = "yes";
      cache-on-disk = "no";
      cache-pause = "yes";
      cache-pause-wait = "10";
      demuxer-max-bytes = "128MiB";

      osd-font = "'Iosevka Mithic'";
      osd-font-size = "30";
      sub-font = "'Overpass'";
      sub-font-size = "45";
    };

    bindings = {
      "[" = "multiply speed 1/1.2599";
      "]" = "multiply speed 1.2599";
      "Q" = "quit";
      "q" = "ignore";
      "ctrl+w" = "ignore";
      "k" = "cycle pause";
      "l" = "cycle-values loop-file inf no";
      "L" = "cycle-values loop-playlist inf no";
      "ctrl+l" = "ab-loop";
      "," = "set pause yes; cycle-values play-dir backward forward";
      "." = "frame-step";
    };
  };

  xdg.configFile."mpv/sponsorblock.toml".text = ''
    # Server address
    server_address = "https://sponsor.ajay.app"
    # Categories: sponsor, selfpromo, interaction, poi_highlight, intro, outro,
    # preview, music_offtopic, filler, exclusive_access
    categories = ["sponsor"]
    # Action types: skip, mute, poi, full
    action_types = ["skip"]
    # Get segments for a video with extra privacy
    privacy_api = false
    # Third party YouTube domains like Piped, Invidious or CloudTube
    domains = ["piped.kavin.rocks", "invidious.kavin.rocks"]
    # Use OSD when a segment is skipped or muted
    skip_notice = true
  '';
}
