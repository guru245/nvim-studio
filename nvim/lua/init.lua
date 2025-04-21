-----------------------
-- Vim General Options
-----------------------
vim = vim
-- disable netrw at the very start of your init.lua
-- This is requested by nvim-tree.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Turn on plugin and indent, depending on file type
vim.cmd("filetype plugin indent on")

vim.opt.termguicolors = true
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.wrap = false
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the lualine
vim.opt.showmode = false

-- Move the cursor to the first non-blank of the line when Vim
-- move commands are used.
vim.opt.startofline = true

vim.opt.guicursor = ""

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Tell Vim to delete the white space at the start of the line, a line break
-- and the character before where Insert mode started.
vim.o.backspace = "indent,eol,start"

-- Set tab size
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Work for C-like programs, but can also be used for other languages
vim.opt.smartindent = true

-- Copy indent from current line when starting a new line. This should be
-- on when smartindent is used.
vim.opt.autoindent = true

-- Set indent for switch statement in C. Just my cup of tea.
vim.opt.cinoptions = ":0"

-- Determine the 'fileencoding' of a file being opened.
vim.o.fileencodings = "utf-8,cp949,cp932,euc-kr,shift-jis,big5,ucs-2le,latin"

-- Represent data in memory
vim.opt.encoding = "utf-8"

-- Use only unix fileformat. "dos" can be added like "unix, dos"
vim.opt.fileformats = "unix"

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
})

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Enable break indent
vim.opt.breakindent = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.winborder = "rounded"

-----------------------
-- Search Options
-----------------------
-- Highlight all matches
vim.opt.hlsearch = true

-- Not search wrap around the end of a file
vim.opt.wrapscan = false

-- Ignore case in search patterns
vim.opt.ignorecase = true

-- Override ignorecase option if the search pattern contains an uppercase character.
vim.opt.smartcase = true

-- Jump to one to the other using %. Various character can be added.
vim.opt.matchpairs:append("<:>")

-----------------------
-- Plugins
-----------------------
local Plug = vim.fn["plug#"]

vim.call("plug#begin")

Plug("catppuccin/nvim", { ["as"] = "catppuccin" })
Plug("lewis6991/gitsigns.nvim")
Plug("lukas-reineke/indent-blankline.nvim")
Plug("nvim-tree/nvim-web-devicons")
Plug("nvim-tree/nvim-tree.lua")
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
Plug("guru245/lualine.nvim")
Plug("arkav/lualine-lsp-progress")
Plug("romgrk/barbar.nvim")
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
Plug("WhoIsSethDaniel/mason-tool-installer.nvim")
Plug("neovim/nvim-lspconfig")
Plug("L3MON4D3/LuaSnip", { ["tag"] = "v2.*", ["do"] = "make install_jsregexp" })
Plug("folke/lazydev.nvim")
Plug("saghen/blink.cmp")
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim")
Plug("nvim-telescope/telescope-file-browser.nvim")
Plug(
  "nvim-telescope/telescope-fzf-native.nvim",
  { ["do"] = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release" }
)
Plug("nvim-telescope/telescope-ui-select.nvim")
Plug("brookhong/telescope-pathogen.nvim")
Plug("preservim/tagbar")
Plug("ayuanx/vim-mark-standalone")
Plug("mfussenegger/nvim-lint")
Plug("sindrets/diffview.nvim")
Plug("stevearc/conform.nvim")
Plug("numToStr/Comment.nvim")
Plug("folke/which-key.nvim")
Plug("echasnovski/mini.icons")
Plug("brenoprata10/nvim-highlight-colors")
Plug("nvim-treesitter/nvim-treesitter-context")
Plug("OXY2DEV/markview.nvim")
Plug("nmac427/guess-indent.nvim")

-- All of your Plugins must be added before the following line
-- :PlugInstall to install the plugins
-- :PlugUpdate to install or update the plugins
-- :PlugDiff to review the changes from the last update
-- :PlugClean to remove plugins no longer in the list
vim.call("plug#end")

-----------------------
-- Plugin Settings
-----------------------
local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "CC", api.tree.change_root_to_node, opts("CD"))
  --vim.keymap.set('n', '<F12>',  api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end
require("nvim-tree").setup({
  on_attach = my_on_attach,
  respect_buf_cwd = true,
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    side = "right",
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

require("nvim-treesitter.configs").setup({
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

-- Plug("catppuccin/nvim", { ["as"] = "catppuccin" })
vim.cmd.colorscheme("catppuccin")
--[[ require("catppuccin").setup({
  integrations = {
    barbar = true,
    diffview = true,
    mason = true,
    which_key = true,
  }
}) ]]

-- Plug("lukas-reineke/indent-blankline.nvim")
require("ibl").setup()

-- Plug("nvim-lualine/lualine.nvim")
-- Colors per colorscheme
local colors = require("catppuccin.palettes").get_palette("macchiato")
require("lualine").setup({
  sections = {
    lualine_c = {
      "filename",
      {
        "lsp_progress",
        display_components = { "lsp_client_name", { "title", "percentage", "message" } },
        colors = {
          percentage = colors.yellow,
          title = colors.yellow,
          message = colors.yellow,
          spinner = colors.yellow,
          lsp_client_name = colors.yellow,
          use = true,
        },
      },
    },
  },
  extensions = {
    "nvim-tree",
    "man",
    "mason",
    "tagbar",
  },
})

local border = "rounded"
require("mason").setup({
  ui = {
    border = border,
  },
})
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
  ensure_installed = {
    "clangd",
    "rust_analyzer",
    "pylsp",
    "lua_ls",
    "cmake",
    "efm",
  },
})
vim.api.nvim_create_autocmd("User", {
  pattern = "MasonToolsStartingInstall",
  callback = function()
    vim.schedule(function()
      print("mason-tool-installer is starting")
    end)
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "MasonToolsUpdateCompleted",
  callback = function(e)
    vim.schedule(function()
      print(vim.inspect(e.data)) -- print the table that lists the programs that were installed
    end)
  end,
})

-- vim.diagnostic.enable(false)
vim.diagnostic.config({
  jump = { float = true, wrap = false },
  severity_sort = true,
  float = { source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
})

-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
local capabilities = require("blink.cmp").get_lsp_capabilities()
-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {
  "clangd",
  "rust_analyzer",
  "pylsp",
  "lua_ls",
  "cmake",
}
local lspconfig = require("lspconfig")
local on_attach = function(_, _)
  print("LSP started.")

  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local map = function(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { desc = "LSP: " .. desc })
  end

  -- Rename the variable under your cursor.
  --  Most Language Servers support renaming across files, etc.
  map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
  vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })

  -- Find references for the word under your cursor.
  map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header.
  map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
end
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    --root_dir = lspconfig.util.root_pattern('.git', vim.fn.getcwd()),
  })
end
lspconfig["efm"].setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "sh" },

  --root_dir = lspconfig.util.root_pattern('.git', vim.fn.getcwd()),
})

require("lint").linters_by_ft = {
  c = { "clangtidy" },
  cpp = { "clangtidy" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()
  end,
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "autopep8" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    sh = { "shfmt" },
    ["*"] = { "trim_whitespace" },
  },
  formatters = {
    shfmt = {
      prepend_args = { "-i", "4" },
    },
  },
  default_format_opts = {
    lsp_format = "never",
    async = false, -- not recommended to change
    quiet = false, -- not recommended to change
  },
})
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_gt_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({
    async = false,
    range = range,
  })
end, { range = true })

require("nvim-highlight-colors").setup({})
require("blink.cmp").setup({
  keymap = {
    -- 'default' (recommended) for mappings similar to built-in completions
    --   <c-y> to accept ([y]es) the completion.
    --    This will auto-import if your LSP supports it.
    --    This will expand snippets if the LSP sent a snippet.
    -- 'super-tab' for tab to accept
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- For an understanding of why the 'default' preset is recommended,
    -- you will need to read `:help ins-completion`
    --
    -- No, but seriously. Please read `:help ins-completion`, it is really good!
    --
    -- All presets have the following mappings:
    -- <tab>/<s-tab>: move to right/left of your snippet expansion
    -- <c-space>: Open menu or open docs if already open
    -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
    -- <c-e>: Hide menu
    -- <c-k>: Toggle signature help
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    preset = "default",

    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = "mono",
  },

  completion = {
    -- By default, you may press `<c-space>` to show the documentation.
    -- Optionally, set `auto_show = true` to show the documentation after a delay.
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
    menu = {
      draw = {
        components = {
          -- customize the drawing of kind icons
          kind_icon = {
            text = function(ctx)
              -- default kind icon
              local icon = ctx.kind_icon
              -- if LSP source, check for color derived from documentation
              if ctx.item.source_name == "LSP" then
                local color_item = require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                if color_item and color_item.abbr ~= "" then
                  icon = color_item.abbr
                end
              end
              return icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              -- default highlight group
              local highlight = "BlinkCmpKind" .. ctx.kind
              -- if LSP source, check for color derived from documentation
              if ctx.item.source_name == "LSP" then
                local color_item = require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                if color_item and color_item.abbr_hl_group then
                  highlight = color_item.abbr_hl_group
                end
              end
              return highlight
            end,
          },
        },
      },
    },
  },

  sources = {
    default = { "lsp", "path", "snippets", "lazydev" },
    providers = {
      lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
    },
  },

  snippets = { preset = "luasnip" },

  -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
  -- which automatically downloads a prebuilt binary when enabled.
  --
  -- By default, we use the Lua implementation instead, but you may enable
  -- the rust implementation via `'prefer_rust_with_warning'`
  --
  -- See :h blink-cmp-config-fuzzy for more information
  fuzzy = { implementation = "lua" },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
  cmdline = {
    keymap = {
      -- recommended, as the default keymap will only show and select the next item
      ["<Tab>"] = { "show", "accept" },
    },
    completion = { menu = { auto_show = true } },
  },
})

-- Plug("preservim/tagbar")
vim.cmd("let g:tagbar_left = 1")
vim.cmd("let g:tagbar_width = 30")
vim.cmd("let g:tagbar_sort = 1")
vim.cmd("let g:tagbar_autofocus = 1")

require("gitsigns").setup({
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  current_line_blame = true,
  preview_config = {
    border = border,
  },
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end)

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end)

    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk)
    map("n", "<leader>hr", gitsigns.reset_hunk)
    map("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end)
    map("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end)
    map("n", "<leader>hS", gitsigns.stage_buffer)
    map("n", "<leader>hu", gitsigns.stage_hunk)
    map("n", "<leader>hR", gitsigns.reset_buffer)
    map("n", "<leader>hp", gitsigns.preview_hunk)
    map("n", "<leader>hb", function()
      gitsigns.blame_line({ full = true })
    end)
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
    map("n", "<leader>td", gitsigns.toggle_deleted)
  end,
})

local fb_actions = require("telescope").extensions.file_browser.actions
require("telescope").setup({
  defaults = {
    layout_strategy = "vertical",
    sorting_strategy = "ascending",
    layout_config = {
      vertical = {
        height = 0.9,
        width = 0.95,
        prompt_position = "top",
        preview_height = 0.6,
      },
    },
    path_display = { truncate = true },
    prompt_prefix = "🔍 ",
  },
  extensions = {
    file_browser = {
      layout_strategy = "horizontal",
      path = "%:p:h",
      cwd = "%:p:h",
      grouped = true,
      display_stat = false,
      auto_depth = true,
      hidden = { file_browser = true, folder_browser = true },
      mappings = {
        ["n"] = {
          ["u"] = fb_actions.goto_parent_dir,
        },
      },
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown(),
    },
    ["pathogen"] = {
      use_last_search_for_live_grep = false,
      prompt_prefix_length = 50,
    },
  },
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("pathogen")

-- require("nvim-tree").setup({
vim.cmd("let g:mwDefaultHighlightingPalette = 'maximum'")

require("diffview").setup({
  view = {
    merge_tool = {
      -- Config for conflicted files in diff views during a merge or rebase.
      layout = "diff4_mixed",
    },
  },
})

require("Comment").setup()

require("which-key").setup({
  preset = "modern",
  sort = { "manual" },
  spec = {
    { "<leader>h", icon = "󰊢", group = "Git hunk", mode = { "n", "v" } },
    { "<leader>hs", icon = "󰊢", desc = "Stage hunk", mode = { "n", "v" } },
    { "<leader>hr", icon = "󰊢", desc = "Reset hunk", mode = { "n", "v" } },
    { "<leader>hS", icon = "󰊢", desc = "Stage buffer", mode = { "n", "v" } },
    { "<leader>hu", icon = "󰊢", desc = "Undo stage hunk", mode = { "n", "v" } },
    { "<leader>hR", icon = "󰊢", desc = "Reset buffer", mode = { "n", "v" } },
    { "<leader>hb", icon = "󰊢", desc = "Blame line", mode = { "n", "v" } },
    { "<leader>tb", hidden = true },
    { "<leader>td", hidden = true },
    { "<leader>hp", hidden = true },
    { "<leader>n", hidden = true },
    { "<leader>r", hidden = true },
    { "<leader>c", icon = "󰭎'", group = "LSP.." },
    { "gr", icon = "󰭎'", group = "LSP.." },
    { "<leader>s", group = "Search" },
    { "<leader>d", icon = "󰊢", group = "Diffview" },
    { "]c", desc = "Next hunk", mode = "n" },
    { "[c", desc = "Prev hunk", mode = "n" },
    { "]d", desc = "Next diagnostic", mode = "n" },
    { "[d", desc = "Prev diagnostic", mode = "n" },
    { "<C-W>d", desc = "Open diagnostic", mode = "n" },
  },
})

require("treesitter-context").setup({
  max_lines = 3,
  trim_scope = "inner",
})

-- Plug("nmac427/guess-indent.nvim")
require("guess-indent").setup({})

-----------------------
-- Mappings
-----------------------
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<Cmd>MarkClear<CR><Cmd>noh<CR>", { desc = "Clear highlights" })

-- Move source code by tab size. Tab is right move and Shift+tab is left.
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

-- Move around buffers by pressing ctrl+h or ctrl+l
vim.keymap.set("n", "<C-h>", "<Cmd>BufferPrevious<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>BufferNext<CR>")

vim.keymap.set({ "n", "v" }, "<C-k>", "<Cmd>Format<CR>")

-- Move between split windows
vim.keymap.set("n", "<A-h>", "<Cmd>wincmd h<CR>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<A-l>", "<Cmd>wincmd l<CR>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<A-k>", "<Cmd>wincmd k<CR>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<A-j>", "<Cmd>wincmd j<CR>", { desc = "Move focus to the lower window" })

-- Save and close the buffer
vim.keymap.set("n", ",w", "<Cmd>BufferClose<CR>")

vim.keymap.set("n", "<F1>", "<Cmd>WhichKey<CR>")
vim.keymap.set("n", "<F2>", "<Cmd>w!<CR>")
vim.keymap.set("n", "<F3>", "<Cmd>TagbarToggle<CR>")
vim.keymap.set("n", "<F4>", "<Cmd>NvimTreeToggle<CR>")

vim.keymap.set("n", "<leader>do", "<Cmd>DiffviewOpen<CR>", { desc = "[D]iffview [O]pen" })
vim.keymap.set("n", "<leader>df", "<Cmd>DiffviewFileHistory %<CR>", { desc = "[D]iffview [F]ile History" })
vim.keymap.set("n", "<leader>dF", "<Cmd>DiffviewFileHistory<CR>", { desc = "[D]iffview [F]iles History" })
vim.keymap.set("n", "<leader>dc", "<Cmd>DiffviewClose<CR>", { desc = "[D]iffview [C]lose" })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
-- Lists files in your current working directory, respects .gitignore
vim.keymap.set("n", "<leader>ff", ":Telescope pathogen find_files<CR>", { desc = "[F]ind [F]iles" })
-- Execute File browser
vim.keymap.set("n", "<leader>fb", "<Cmd>Telescope file_browser<CR>", { desc = "Open [F]ile[B]rowers" })
-- Search for a string in your current working directory and get results live as you type
vim.keymap.set("n", "<leader>lg", ":Telescope pathogen live_grep<CR>", { desc = "[L]ive [G]rep" })
-- Searches for the string under your cursor or selection in your current working directory
vim.keymap.set("n", "<leader>ct", ":Telescope pathogen grep_string<CR>", { desc = "Grep string" })
-- Lists LSP incoming calls for word under the cursor
vim.keymap.set("n", "<leader>cc", builtin.lsp_incoming_calls, { desc = "List LSP incoming calls" })

-- The following is deprecated
-- Lists LSP references for word under the cursor
vim.keymap.set("n", "<leader>cs", builtin.lsp_references, { desc = "List LSP references" })
-- Goto the definition of the type of the word under the cursor
vim.keymap.set("n", "<leader>cg", builtin.lsp_type_definitions, { desc = "Goto the definition" })
