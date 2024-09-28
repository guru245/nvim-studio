-----------------------
-- General
-----------------------
vim = vim
-- disable netrw at the very start of your init.lua
-- This is requested by nvim-tree.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.clipboard:append("unnamedplus")

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
Plug("preservim/tagbar")
Plug("ayuanx/vim-mark-standalone")
Plug("mfussenegger/nvim-lint")
Plug("sindrets/diffview.nvim")
Plug("stevearc/conform.nvim")
Plug("numToStr/Comment.nvim")
Plug("folke/which-key.nvim")
Plug("echasnovski/mini.icons")
Plug("brenoprata10/nvim-highlight-colors")

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

-- Plug("lukas-reineke/indent-blankline.nvim")
require("ibl").setup()

-- Plug("nvim-lualine/lualine.nvim")
-- Color for highlights
local colors = {
  green = "#98be65",
  blue = "#51afef",
}
require("lualine").setup({
  sections = {
    lualine_c = {
      "filename",
      {
        "lsp_progress",
        display_components = { "lsp_client_name", { "title", "percentage", "message" } },
        colors = {
          percentage = colors.blue,
          title = colors.blue,
          message = colors.blue,
          spinner = colors.blue,
          lsp_client_name = colors.green,
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

vim.cmd("let g:tagbar_left = 1")
vim.cmd("let g:tagbar_width = 30")
vim.cmd("let g:tagbar_sort = 1")
vim.cmd("let g:tagbar_autofocus = 1")
vim.cmd("let g:tagbar_autoclose = 1")

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
  },
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")

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
    { "<leader>ff", icon = "󰭎'", desc = "Find File", mode = "n" },
    { "<leader>fb", icon = "󰭎'", desc = "Open File Browser", mode = "n" },
    { "<leader>lg", icon = "󰭎'", desc = "Live grep", mode = "n" },
    { "<leader>ct", icon = "󰭎'", desc = "Grep string", mode = "n" },
    { "<leader>cs", icon = "󰭎'", desc = "List LSP references", mode = "n" },
    { "<leader>cc", icon = "󰭎'", desc = "List LSP incoming calls", mode = "n" },
    { "<leader>cg", icon = "󰭎'", desc = "Goto the definition", mode = "n" },
    { "<leader>hs", icon = "󰊢", desc = "Stage hunk", mode = "n" },
    { "<leader>hr", icon = "󰊢", desc = "Reset hunk", mode = "n" },
    { "<leader>hS", icon = "󰊢", desc = "Stage buffer", mode = "n" },
    { "<leader>hu", icon = "󰊢", desc = "Undo stage hunk", mode = "n" },
    { "<leader>hR", icon = "󰊢", desc = "Reset buffer", mode = "n" },
    { "<leader>hb", icon = "󰊢", desc = "Blame line", mode = "n" },
    { "<leader>hd", icon = "󰊢", desc = "Diff this", mode = "n" },
    { "<leader>tb", hidden = true },
    { "<leader>td", hidden = true },
    { "<leader>hp", hidden = true },
    { "]c", desc = "Next hunk", mode = "n" },
    { "[c", desc = "Prev hunk", mode = "n" },
    { "]d", desc = "Next diagnostic", mode = "n" },
    { "[d", desc = "Prev diagnostic", mode = "n" },
    { "<C-W>d", desc = "Open diagnostic", mode = "n" },
    { "<leader>p", desc = "Toggle paste mode", mode = "n" },
  },
})

-----------------------
-- Mapping
-----------------------
-- Move around buffers by pressing ctrl+h or ctrl+l
vim.keymap.set("n", "<C-h>", "<Cmd>BufferPrevious<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>BufferNext<CR>")

vim.keymap.set({ "n", "v" }, "<C-k>", "<Cmd>Format<CR>")

-- Move between split windows
vim.keymap.set("n", "<A-h>", "<Cmd>wincmd h<CR>")
vim.keymap.set("n", "<A-l>", "<Cmd>wincmd l<CR>")
vim.keymap.set("n", "<A-k>", "<Cmd>wincmd k<CR>")
vim.keymap.set("n", "<A-j>", "<Cmd>wincmd j<CR>")

-- Save and close the buffer
vim.keymap.set("n", ",w", "<Cmd>BufferClose<CR>")

vim.keymap.set("n", "<F1>", "<Cmd>WhichKey<CR>")
vim.keymap.set("n", "<F2>", "<Cmd>w!<CR>")
vim.keymap.set("n", "<F3>", "<Cmd>TagbarToggle<CR>")
vim.keymap.set("n", "<F4>", "<Cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<F5>", function()
  if next(require("diffview.lib").views) == nil then
    vim.cmd("DiffviewOpen")
  else
    vim.cmd("DiffviewClose")
  end
end)
vim.keymap.set("n", "<F6>", function()
  if next(require("diffview.lib").views) == nil then
    vim.cmd("DiffviewFileHistory %")
  else
    vim.cmd("DiffviewClose")
  end
end)
vim.keymap.set("n", "<F8>", "<Cmd>MarkClear<CR><Cmd>noh<CR>")

local builtin = require("telescope.builtin")
-- Lists files in your current working directory, respects .gitignore
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
-- Execute File browser
vim.keymap.set("n", "<leader>fb", "<Cmd>Telescope file_browser<CR>")
-- Search for a string in your current working directory and get results live as you type
vim.keymap.set("n", "<leader>lg", builtin.live_grep, {})
-- Searches for the string under your cursor or selection in your current working directory
vim.keymap.set("n", "<leader>ct", builtin.grep_string, {})
-- Lists LSP references for word under the cursor
vim.keymap.set("n", "<leader>cs", builtin.lsp_references, {})
-- Lists LSP incoming calls for word under the cursor
vim.keymap.set("n", "<leader>cc", builtin.lsp_incoming_calls, {})
-- Goto the definition of the type of the word under the cursor
vim.keymap.set("n", "<leader>cg", builtin.lsp_type_definitions, {})
