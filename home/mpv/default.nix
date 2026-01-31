{
  pkgs,
  config,
  ...
}: {
  programs.mpv = {
    enable = true;

    scripts = with pkgs.mpvScripts; [
      mpris
      thumbfast
      sponsorblock
      quality-menu
    ];

    config = {
      hwdec = "auto-safe";
      video-sync = "display-resample";
      interpolation = true;
      tscale = "oversample";

      af = "scaletempo2=min-speed=1/4:max-speed=4";
      volume = "70";
      replaygain = "album";
      ao = "pipewire,pulse,jack,alsa";

      ytdl-raw-options-append = "format-sort=+res:1080";

      keep-open = "yes";

      cache = "yes";
      cache-on-disk = "no";
      cache-pause = "yes";
      cache-pause-wait = "10";
      demuxer-max-bytes = "128MiB";

      osd-font = "'${builtins.head config.fonts.fontconfig.defaultFonts.monospace}'";
      osd-font-size = "30";
      sub-font = "'${builtins.head config.fonts.fontconfig.defaultFonts.sansSerif}'";
      sub-font-size = "45";
    };

    bindings = {
      "[" = "multiply speed 1/1.1892";
      "]" = "multiply speed 1.1892";
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

  home.packages = [pkgs.yt-dlp];
}
