{
  lib,
  pkgs,
  config,
  ...
}: let
  toml = (pkgs.formats.toml {}).generate;
  rustfmt = pkgs.rustfmt.override {asNightly = true;};
in {
  home.packages = [pkgs.rustup (lib.hiPrio rustfmt)];

  xdg.configFile."rustfmt/rustfmt.toml".source = toml "rustfmt.toml" {
    edition = "2024";
    hard_tabs = true;
    tab_spaces = 8;
    newline_style = "Unix";
    max_width = 80;
    use_small_heuristics = "Default";
    short_array_element_width_threshold = 0;
    use_field_init_shorthand = true;
    use_try_shorthand = true;
    match_block_trailing_comma = true;
    # nightly
    unstable_features = true;
    fn_single_line = true;
    imports_layout = "HorizontalVertical";
    match_arm_blocks = false;
    match_arm_leading_pipes = "Always";
    match_arm_indent = false;
    imports_granularity = "Module";
    overflow_delimited_expr = true;
    group_imports = "StdExternalCrate";
  };

  home.sessionVariables = {
    "RUSTUP_HOME" = "${config.xdg.dataHome}/rustup";
    "CARGO_HOME" = "${config.xdg.dataHome}/cargo";
  };
}
