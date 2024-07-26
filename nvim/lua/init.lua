-----------------------
-- General
-----------------------
-- disable netrw at the very start of your init.lua
-- This is requested by nvim-tree.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-----------------------
-- Plugins
-----------------------
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })
Plug('lewis6991/gitsigns.nvim')
Plug('lukas-reineke/indent-blankline.nvim')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-vsnip')
Plug('hrsh7th/vim-vsnip')
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('nvim-lualine/lualine.nvim')
Plug('romgrk/barbar.nvim')
Plug('williamboman/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim')
Plug('neovim/nvim-lspconfig')

-- All of your Plugins must be added before the following line
-- :PlugInstall to install the plugins
-- :PlugUpdate to install or update the plugins
-- :PlugDiff to review the changes from the last update
-- :PlugClean to remove plugins no longer in the list
vim.call('plug#end')


-----------------------
-- Plugin Settings
-----------------------
local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', 'CC', api.tree.change_root_to_node, opts('CD'))
  --vim.keymap.set('n', '<F12>',  api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', '?',  api.tree.toggle_help, opts('Help'))
end

require("nvim-tree").setup {
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
}

require'nvim-treesitter.configs'.setup {
  auto_install = true,
  hightlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

vim.cmd.colorscheme "catppuccin"
require("ibl").setup()
require('lualine').setup()

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = {
    "lua_ls",
    "clangd",
    "rust_analyzer" },
}
require("lspconfig").lua_ls.setup {}
require("lspconfig").bashls.setup {}
require("lspconfig").clangd.setup {}
require("lspconfig").cmake.setup {}
require("lspconfig").pyright.setup {}
require("lspconfig").rust_analyzer.setup {}
local cmp = require("cmp")
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
  },
}

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-----------------------
-- Mapping
-----------------------
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move around buffers by pressing ctrl+h or ctrl+l
map('n', '<C-h>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<C-l>', '<Cmd>BufferNext<CR>', opts)

-- Move between split windows
map('n', '<A-h>', '<Cmd>wincmd h<CR>', opts)
map('n', '<A-l>', '<Cmd>wincmd l<CR>', opts)
map('n', '<A-k>', '<Cmd>wincmd k<CR>', opts)
map('n', '<A-j>', '<Cmd>wincmd j<CR>', opts)

-- Save and close the buffer
map('n', ',w', '<Cmd>BufferClose<CR>', opts)

map('n', '<F2>', '<Cmd>w!<CR>', opts)
map('n', '<F4>', '<Cmd>NvimTreeToggle<CR>', opts)

