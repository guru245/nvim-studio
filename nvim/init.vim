scripte utf-8
" vim: set fenc=utf-8 tw=0:

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Revert all command settings before proceeding with other settings below
"set all&

" Work in Vim compatible not Vi compatible
set nocompatible

" Keep 50 commands and 50 search patterns in the history.
" 50 is undo limit.
set history=100

" No need to understand this. Leave this when using Vim.
set magic

" No swap file. It's messy.
set noswapfile

" No backup file. You take your risk on your own.
set nobackup

" Turn on plugin and indent, depending on file type
filetype plugin indent on

" Wait for a key code forever.
" Wait for a mapped key sequence to complete within ttimeoutlen.
set notimeout ttimeout

" In Milliseconds
set timeoutlen=3000 ttimeoutlen=100

" Not redraw while executing macros, and commands.
set lazyredraw

"set visualbell

" set mouse=a


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" These settings go to init.lua
call plug#begin()

" Plug 'liuchengxu/vista.vim'

" All of your Plugins must be added before the following line
" :PlugInstall to install the plugins
" :PlugUpdate to install or update the plugins
" :PlugDiff to review the changes from the last update
" :PlugClean to remove plugins no longer in the list
call plug#end()


" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
let g:vista_default_executive = 'nvim_lsp'
let g:vista#renderer#enable_icon = 1
let g:vista_sidebar_position = 'vertical topleft'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tell Vim to delete the white space at the start of the line, a line break
"  and the character before where Insert mode started.
set backspace=indent,eol,start

" Display the current cursor position in the lower right corner of the
" Vim window. But for now this is no londer used thanks to airline plugin.
"set ruler

" Display an incomplete vim command in the lower right corner of the Vim window
" This is no longer used thanks to AutoComplPop plugin
"set showcmd

" Display line numbers
set nu

" Set line number width
set numberwidth=5

" Do not wrap lines
set nowrap

" Move the cursor to the first non-blank of the line when Vim
" move commands are used.
set startofline

" Turn on syntax highlighting
syntax on

" Whatever floats in your boat
set background=dark
"set background=light

set guicursor=

" Delete trailing spaces at eol when a file is saved.
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite * :call DeleteTrailingWS()

" Locate the cursor in the last position when Vim is closed
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "norm g`\"" |
\ endif

" Set 80, 100 column guideline
set colorcolumn=100
highlight ColorColumn ctermbg=red
let &colorcolumn="80,".join(range(100,100),",")


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tab & Indent
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set tab size
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Use spaces instead of tabs
set expandtab

" Work for C-like programs, but can also be used for other languages
set smartindent

" Copy indent from current line when starting a new line. This should be
" on when smartindent is used.
set autoindent

" Set indent for switch statement in C. Just my cup of tea.
set cinoptions=:0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Encoding and Format
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Determine the 'fileencoding' of a file being opened.
set fileencodings=utf-8,cp949,cp932,euc-kr,shift-jis,big5,ucs-2le,latin1

" Represent data in memory
set encoding=utf-8

" Use only unix fileformat. "dos" can be added like "unix, dos"
" if you are a coward.
set fileformats=unix


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight all matches
set hlsearch

" Not search wrap around the end of a file
set nowrapscan

" Ignore case in search patterns
set ignorecase

" Override ignorecase option if the search pattern contains an uppercase
" character.
set smartcase

" Show where the pattern matches as it was typed so far.
set incsearch

" Jump to one to the other using %. Various character can be added.
set matchpairs+=<:>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show the man page when you press F1
func! Man()
    let sm = expand("<cword>")
    exe "!man -S 2:3:4:5:6:7:8:9:tcl:n:1:p:o ".sm
endfunc
map <F1> :call Man()<cr>g

" Save
map <F2> :w!<cr>

" Clear all markers
map <F8> :MarkClear<cr> :noh<cr>
"map <F8> [i
"Map <F9> gd

" Format source codes by clang-format. To use this clang-format must be
" installed.
map <C-K> :py3f ~/.vim/clang-format.py<cr>
imap <C-K> <c-o>:py3f ~/.vim/clang-format.py<cr>

" Move source codes by tab size. Tab is right move and Shift+tab is left.
vmap <Tab> >gv
vmap <S-Tab> <gv

" Toggle line number display
fu! ToggleNu()
    let &nu = 1 - &nu
endf
map <leader>d :call ToggleNu()<CR>

" Toggle paste option. This is useful if you want to cut or copy some text
" from one window and paste it in Vim. Don't forget to toggle paste again once
" you're done with pasting.
map <leader>p :set invpaste paste?<CR>
set pastetoggle=<leader>p

" Must be located at the end of init.vim
lua require('init')
