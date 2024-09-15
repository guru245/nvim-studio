-----------------------
-- General
-----------------------
-- disable netrw at the very start of your init.lua
-- This is requested by nvim-tree.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.clipboard:append('unnamedplus')

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
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('preservim/tagbar')
Plug('ayuanx/vim-mark-standalone')
Plug('mfussenegger/nvim-lint')
Plug('sindrets/diffview.nvim')
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' })

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
local border = 'rounded'
require("mason").setup({
  ui = {
    border = border,
  },
})
require("mason-lspconfig").setup()

-- vim.diagnostic.disable()
-- Add border to the diagnostic popup window
vim.diagnostic.config({
    virtual_text = {
        --prefix = '■ ', -- Could be '●', '▎', 'x', '■', , 
    },
    float = { border = border },
})
local handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}
require('lspconfig.ui.windows').default_options.border = border
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {
  'clangd',
  'rust_analyzer',
  'pylsp',
  'lua_ls',
  'cmake',
}
local lspconfig = require('lspconfig')
local on_attach = function(_, _)
  print("LSP started.")
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
    --root_dir = lspconfig.util.root_pattern('.git', vim.fn.getcwd()),
  }
end

local cmp = require("cmp")
cmp.setup {
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
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      ['<Tab>'] = cmp.mapping.select_next_item(),
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

vim.cmd("let g:tagbar_left = 1")
vim.cmd("let g:tagbar_width = 30")
vim.cmd("let g:tagbar_sort = 0")

require('gitsigns').setup {
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  current_line_blame = true,
  preview_config = {
    border = border,
  },
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk)
    map('n', '<leader>hr', gitsigns.reset_hunk)
    map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gitsigns.stage_buffer)
    map('n', '<leader>hu', gitsigns.undo_stage_hunk)
    map('n', '<leader>hR', gitsigns.reset_buffer)
    map('n', '<leader>hp', gitsigns.preview_hunk)
    map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
    map('n', '<leader>td', gitsigns.toggle_deleted)

  end
}

require('telescope').setup {
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      vertical = {
        height = 0.9,
        width = 0.95,
        prompt_position = 'top',
        preview_height = 0.6
      },
    },
    path_display = { truncate = true },
    prompt_prefix='🔍 ',
  }
}
require('telescope').load_extension('fzf')

vim.cmd("let g:mwDefaultHighlightingPalette = 'maximum'")

require('lint').linters_by_ft = {
  c = {'clangtidy',},
  cpp = {'clangtidy',},
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()
  end,
})

require("diffview").setup({
  view = {
    merge_tool = {
      -- Config for conflicted files in diff views during a merge or rebase.
      layout = "diff4_mixed",
    },
  },
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
map('n', '<F3>', '<Cmd>:TagbarToggle<CR>', opts)
map('n', '<F4>', '<Cmd>NvimTreeToggle<CR>', opts)
vim.keymap.set('n', '<F5>', function()
  if next(require('diffview.lib').views) == nil then
    vim.cmd('DiffviewOpen')
  else
    vim.cmd('DiffviewClose')
  end
end)
map('n', '<F6>', '<Cmd>DiffviewFileHistory %<CR>', opts)
map('n', '<F8>', '<Cmd>MarkClear<CR><Cmd>noh<CR>', opts)

local builtin = require('telescope.builtin')
-- Lists files in your current working directory, respects .gitignore
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- Search for a string in your current working directory and get results live as you type
vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})
-- Searches for the string under your cursor or selection in your current working directory
vim.keymap.set('n', '<leader>ct', builtin.grep_string, {})
-- Lists LSP references for word under the cursor
vim.keymap.set('n', '<leader>cs', builtin.lsp_references, {})
-- Lists LSP incoming calls for word under the cursor
vim.keymap.set('n', '<leader>cc', builtin.lsp_incoming_calls, {})
-- Goto the definition of the type of the word under the cursor
vim.keymap.set('n', '<leader>cg', builtin.lsp_type_definitions, {})
