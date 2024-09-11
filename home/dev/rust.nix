{ pkgs, config, ... }:
let
  toml = (pkgs.formats.toml { }).generate;
in
{

  home.packages = [ pkgs.rustup ];

  xdg.configFile."rustfmt/rustfmt.toml".source = toml "rustfmt.toml" {
    edition = "2021";
    hard_tabs = true;
    tab_spaces = 8;
    newline_style = "Unix";
    max_width = 80;
    use_small_heuristics = "Default";
    short_array_element_width_threshold = 0;
    use_field_init_shorthand = true;
    use_try_shorthand = true;
    match_block_trailing_comma = true;
  };

  home.sessionVariables = {
    "RUSTUP_HOME" = "${config.xdg.dataHome}/rustup";
    "CARGO_HOME" = "${config.xdg.dataHome}/cargo";
  };

}
