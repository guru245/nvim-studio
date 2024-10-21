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
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-vsnip")
Plug("hrsh7th/vim-vsnip")
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
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim")
Plug("nvim-telescope/telescope-file-browser.nvim")
Plug(
  "nvim-telescope/telescope-fzf-native.nvim",
  { ["do"] = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release" }
)
Plug("nvim-telescope/telescope-ui-select.nvim")
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
  hightlight = {
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

-- vim.diagnostic.disable()
-- Add border to the diagnostic popup window
vim.diagnostic.config({
  virtual_text = {
    --prefix = '■ ', -- Could be '●', '▎', 'x', '■', , 
  },
  float = { border = border },
})
local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}
require("lspconfig.ui.windows").default_options.border = border
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
  vim.keymap.set("n", "K", vim.lsp.buf.hover, {})

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
end
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
    --root_dir = lspconfig.util.root_pattern('.git', vim.fn.getcwd()),
  })
end
lspconfig["efm"].setup({
  on_attach = on_attach,
  capabilities = capabilities,
  handlers = handlers,
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
    ["*"] = { "trim_whitespace" },
  },
  default_format_opts = {
    lsp_format = "never",
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
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }),
  formatting = {
    format = require("nvim-highlight-colors").format,
  },
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
  matching = { disallow_symbol_nonprefix_matching = false },
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
    map("n", "<leader>hu", gitsigns.undo_stage_hunk)
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
  },
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("ui-select")

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
    { "<leader>s", group = "Search" },
    { "<leader>d", icon = "󰊢", group = "Diffview" },
    { "]c", desc = "Next hunk", mode = "n" },
    { "[c", desc = "Prev hunk", mode = "n" },
    { "]d", desc = "Next diagnostic", mode = "n" },
    { "[d", desc = "Prev diagnostic", mode = "n" },
    { "<C-W>d", desc = "Open diagnostic", mode = "n" },
    { "<leader>p", desc = "Toggle paste mode", mode = "n" },
  },
})

require("treesitter-context").setup({
  trim_scope = "inner",
})

-----------------------
-- Mappings
-----------------------
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<Cmd>MarkClear<CR><Cmd>noh<CR>", { desc = "Clear highlights" })

-- Move source codes by tab size. Tab is right move and Shift+tab is left.
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
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
-- Execute File browser
vim.keymap.set("n", "<leader>fb", "<Cmd>Telescope file_browser<CR>", { desc = "Open [F]ile[B]rowers" })
-- Search for a string in your current working directory and get results live as you type
vim.keymap.set("n", "<leader>lg", builtin.live_grep, { desc = "[L]ive [G]rep" })
-- Searches for the string under your cursor or selection in your current working directory
vim.keymap.set("n", "<leader>ct", builtin.grep_string, { desc = "Grep string" })
-- Lists LSP references for word under the cursor
vim.keymap.set("n", "<leader>cs", builtin.lsp_references, { desc = "List LSP references" })
-- Lists LSP incoming calls for word under the cursor
vim.keymap.set("n", "<leader>cc", builtin.lsp_incoming_calls, { desc = "List LSP incoming calls" })
-- Goto the definition of the type of the word under the cursor
vim.keymap.set("n", "<leader>cg", builtin.lsp_type_definitions, { desc = "Goto the definition" })
