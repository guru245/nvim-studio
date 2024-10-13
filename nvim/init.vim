scripte utf-8
" vim: set fenc=utf-8 tw=0:

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn on plugin and indent, depending on file type
filetype plugin indent on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Locate the cursor in the last position when Vim is closed
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "norm g`\"" |
\ endif

" Set 80, 100 column guideline
set colorcolumn=100
let &colorcolumn="80,".join(range(100,100),",")


" Toggle paste option. This is useful if you want to cut or copy some text
" from one window and paste it in Vim. Don't forget to toggle paste again once
" you're done with pasting.
map <leader>p :set invpaste paste?<CR>
set pastetoggle=<leader>p


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Must be located at the end of init.vim
lua require('init')
