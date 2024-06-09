(local telescope (require :telescope))
(local builtin (require :telescope.builtin))
(local fb-actions (.. ... :.fb_actions))

(telescope.setup
  {:defaults {:border true}
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
       "<Bs>" fb-actions.backspace
       "<C-Cr>" fb-actions.change_cwd
       "<C-h>" fb-actions.toggle_hidden
       "<C-w>" fb-actions.goto_cwd
       "<S-Cr>" fb-actions.create_from_prompt
       "<A-c>" false "<A-d>" false "<A-m>" false "<A-r>" false
       "<A-y>" false "<C-e>" false "<C-f>" false "<C-g>" false
       "<C-o>" false "<C-s>" false}
      :n
      {"<A-Cr>" fb-actions.mithic_rifle
       "<Bs>" fb-actions.backspace
       "<C-Cr>" fb-actions.change_cwd
       "<C-h>" fb-actions.toggle_hidden
       "<C-w>" fb-actions.goto_cwd
       "<S-Cr>" fb-actions.create_from_prompt
       "<localleader>R" fb-actions.move
       "<localleader>d" fb-actions.mithic_dragon_drop
       "<localleader>o" fb-actions.create
       "<localleader>r" fb-actions.rename
       "<localleader>x" fb-actions.mithic_trash
       "<localleader>y" fb-actions.copy
       "u" fb-actions.goto_parent_dir
       "~" fb-actions.goto_home_dir}}
     :zf-native
     {:file {:enable true :highlight_results true :match_filename true}
      :generic {:enable true :highlight_results true :match_filename false}}}}
   :pickers
   {:find_files {:find_command ["fd" "--type=f" "--color=never" "--hidden"
                                "--no-require-git" "--exclude=.git"]}}})

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
(vim.keymap.set :n "<leader><C-p>" #(builtin.register))
(vim.keymap.set :n "<leader>h" #(builtin.help_tags))
(vim.keymap.set :n "<leader>'" #(builtin.marks))

(vim.keymap.set :n "<leader>."
                #(telescope.extensions.file_browser.file_browser))
(vim.keymap.set
  :n
  "<leader>>"
  #(telescope.extensions.file_browser.file_browser {:path "%:p:h"}))
