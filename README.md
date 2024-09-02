# NVIM Studio

Are you still using Vim?Can we turn Vim into an IDE? Yes, we can. It works even better and faster than
any traditional IDE. Let's dive right in.

![overview](./.imgs/overview.png)

## Features

* File system explorer browses directory hierarchies, and performs file system
  operations

* Source code browser provides an overview of the structure of the source code

* Statusbar at the bottom displays useful information

* Source tab at the top displays all opened source via tab interface

  ![tab](./.imgs/tab.gif)

* Git wrapper works with Git without leaving Vim studio.

* Auto completion opens a popup menu to complete using tab

  ![auto completion](./.imgs/autocomp.gif)

* Automatic index searches and browses source code thanks to lsp

* [Clang-format](https://clang.llvm.org/docs/ClangFormat.html) integration formats code with the desired style.

## Environment

NVIM studio has been tested on the following environments:

* Ubuntu 18.04 or above, Fedora 24, and WSL2
* Neovim 9.0
* [Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal/get-started)

## Installation

1. Install exuberant-ctags and global.

   - `apt install exuberant-ctags global`
   - If you are used to building things from source, [universal-ctags](https://github.com/universal-ctags/ctags) is recommended instead of exuberant-ctags because exuberant-ctags is very old and is not maintained.

2. Install [CaskaydiaCove](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip) fonts for glyphs.

   * Set CaskaydiaCoveNerdFontMono-Regular.ttf by default to your terminal. For your reference, see
   [Windows Terminal Powerline Setup | Microsoft Docs](https://docs.microsoft.com/en-us/windows/terminal/tutorials/powerline-setup)

3. d

   ```
   apt install fd-find
   ln -s $(which fdfind) ~/.local/bin/fd
   apt install ripgrep, npm, libjansson-dev
   ```



4. Set up Vim config

   ```bash
   git clone --depth 1 --recurse-submodules https://github.com/guru245/nvim-studio.git [nvim-studio where you want]
   ln -s [nvim-studio]/nvim ~/.config/nvim/
   Note https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
   or
   sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
   nvim -es -u init.vim -i NONE -c "PlugInstall" -c "qa"
   ```

5. LSPInstall

   ```
   ssdsd

   ```



## Usage

This section describes mapping keys for Vim studio. Note that normal Vim
commands and other detailed configurations of [.vimrc](.vimrc) are not
explained. If you are not familiar with the Vim commands or [.vimrc](.vimrc),
check out [Vim help](http://vimdoc.sourceforge.net/htmldoc/help.html) or
[Vim options](http://vimdoc.sourceforge.net/htmldoc/options.html).

* F1: Show a man page for the keyword under the cursor.
* F2: Save the current file
* F3: Toggle tagbar, source code browser on the left side
* F4: Toggle NERDTree, file system explorer on the right side
* F7: Empty
* F8: Clear all marks
* F9: Empty
* F10: Empty
* `ctrl+h`, `ctrl+l`: Go to the tab on the left/right
* `shift+h`, `shift+l`, `shift+k`, `shift+j`:  Move between split windows
* `,w`: Save and close the current file. *Well~ we call it buffer in Vim*
* `ctrl+k`: Format code style as per clang-format style options
* `<leader>d`: Toggle line number
* `<leader>p`: Toggle paste option. This is useful if you want to cut or copy
  some text from one window and paste it in Vim. Don't forget to toggle paste
  again once you finish pasting.
* `<leader>m`: Mark the keyword under the cursor

To perform cscope searching, use `:GscopeFind {querytype} {name}`. Where
`{querytype}` corresponds to the actual cscope line interface numbers as
well as default nvi commands:

Or you can use the following keymaps:

| keymap | desc |
|--------|------|
| `<leader>cs` | Find symbol (reference) under cursor |
| `<leader>cg` | Find symbol definition under cursor |
| `<leader>cc` | Functions calling this function |
| `<leader>ct` | Find text string under cursor |


## Powered by:

* [Vundle.vim](https://github.com/VundleVim/Vundle.vim)

