


-----------------------
-- Vim Plugin Settings
-----------------------
local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('majutsushi/tagbar')
Plug('nvim-tree/nvim-web-devicons')
Plug('lewis6991/gitsigns.nvim')
Plug('romgrk/barbar.nvim')

-- All of your Plugins must be added before the following line
-- :PlugInstall to install the plugins
-- :PlugUpdate to install or update the plugins
-- :PlugDiff to review the changes from the last update
-- :PlugClean to remove plugins no longer in the list
vim.call('plug#end')


-----------------------
-- Mapping
-----------------------
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move around buffers by pressing ctrl+h or ctrl+l
map('n', '<C-h>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<C-l>', '<Cmd>BufferNext<CR>', opts)

-- Save and close the buffer
map('n', ',w', '<Cmd>BufferClose<CR>', opts)
