(local telescope (require :telescope))
(local builtin (require :telescope.builtin))
(local actions (require :telescope.actions))
(local fb-actions (.. ... :.fb_actions))

(telescope.setup
  {:defaults
   {:border true
    ; TODO: determine whether we need <C-n> et al
    :default_mappings
     {:i
      {"<LeftMouse>"
       {1 actions.mouse_click :type :action :opts {:expr true}}
       "<2-LeftMouse>"
       {1 actions.double_mouse_click :type :action :opts {:expr true}}
       "<Cr>" actions.select_default
       "<C-j>" actions.select_default
       "<C-s>" actions.select_horizontal
       "<C-v>" actions.select_vertical
       "<Tab>" (+ actions.toggle_selection actions.move_selection_worse)
       "<S-Tab>" (+ actions.toggle_selection actions.move_selection_better)}
      :n
      {"<LeftMouse>"
       {1 actions.mouse_click :type :action :opts {:expr true}}
       "<2-LeftMouse>"
       {1 actions.double_mouse_click :type :action :opts {:expr true}}
       "<Esc>" actions.close
       "<Cr>" actions.select_default
       "<C-j>" actions.select_default
       "<C-s>" actions.select_horizontal
       "<C-v>" actions.select_vertical
       "<Tab>" (+ actions.toggle_selection actions.move_selection_worse)
       "<S-Tab>" (+ actions.toggle_selection actions.move_selection_better)
       "j" actions.move_selection_next
       "k" actions.move_selection_previous
       "H" actions.move_to_top
       "L" actions.move_to_bottom
       "gg" actions.move_to_top
       "G" actions.move_to_bottom
       "<C-u>" actions.preview_scrolling_up
       "<C-d>" actions.preview_scrolling_down}}}
   :extensions
   {:file_browser
    {:hijack_netrw true ; TODO: false, use oil.nvim
     :select_buffer true
     :hidden true
     :respect_gitignore false
     :no_ignore true
     :follow_symlinks true
     :hide_parent_dir true ; just type ".." manually
     :dir_icon "D"
     :display_stat {:date true :mode true :size true}
     :prompt_path true
     :mappings
     {:i
      {"<A-Cr>" fb-actions.mithic_rifle
       "<C-Cr>" fb-actions.change_cwd
       "<S-Cr>" fb-actions.create_from_prompt
       "<C-w>" fb-actions.goto_cwd
       "<A-c>" false "<A-r>" false "<A-m>" false "<A-y>" false "<A-d>" false
       "<C-o>" false "<C-g>" false "<C-e>" false "<C-t>" false "<C-f>" false
       "<C-h>" false "<C-s>" false}
      :n
      {"<A-Cr>" fb-actions.mithic_rifle
       "<C-Cr>" fb-actions.change_cwd
       "<S-Cr>" fb-actions.create_from_prompt
       "<C-w>" fb-actions.goto_cwd
       "<Bs>" fb-actions.backspace
       "<localleader>R" fb-actions.move
       "<localleader>d" fb-actions.mithic_dragon_drop
       "<localleader>o" fb-actions.create
       "<localleader>r" fb-actions.rename
       "<localleader>x" fb-actions.mithic_trash
       "<localleader>y" fb-actions.copy
       "u" fb-actions.goto_parent_dir
       "~" fb-actions.goto_home_dir
       "c" false "r" false "m" false "y" false "d" false "o" false "g" false
       "e" false "w" false "t" false "f" false "h" false "s" false}}}
    :zf-native
    {:file {:enable true :highlight_results true :match_filename true}
     :generic {:enable true :highlight_results true :match_filename false}}}
   :pickers
   {:find_files {:find_command ["fd" "--type=f" "--color=never" "--hidden"
                                "--no-require-git" "--exclude=.git"]}
    :live_grep {:additional_args ["--fixed-strings"]}}})

(telescope.load_extension :zf-native)
(telescope.load_extension :file_browser)

(vim.keymap.set :n "<leader> " #(builtin.find_files))
(vim.keymap.set :n "<leader>," #(builtin.buffers))
(vim.keymap.set
  :n
  "<leader><"
  #(builtin.find_files
     {:find_command
      ["fd" "--type=f" "--color=never" "--hidden" "--no-ignore"]}))
(vim.keymap.set :n "<leader>/" #(builtin.live_grep))
(vim.keymap.set :n "<leader><C-p>" #(builtin.registers))
(vim.keymap.set :n "<leader>h" #(builtin.help_tags))
(vim.keymap.set :n "<leader>'" #(builtin.marks))

(vim.keymap.set :n "<leader>."
                #(telescope.extensions.file_browser.file_browser))
(vim.keymap.set
  :n
  "<leader>>"
  #(telescope.extensions.file_browser.file_browser {:path "%:p:h"}))
