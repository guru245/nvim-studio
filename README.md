# NVIM Studio

![overview](./.imgs/overview.png)

## Features

* TBD
  

## Prerequisites

You should set up a good environment to make your NVIM life easier. NVIM Studio is running in the following environments:

* Ubuntu 20.04 or above

* [Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal/get-started)

* Set [CaskaydiaCoveNerdFont-Regular.ttf](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip) by default to your terminal.

  

## Setting up the Environment

1. Install the following packages. It could be a overkill to install all packages. Some of them might not be necessary depending on your environment. However, note that if you encounter any unexpected symptom throughout this guide, come back here and see what is missing.

   ```bash
   sudo apt install ssh keychain make cmake python3-cryptography clang-format automake autoconf pkg-config python3-pip clang libtool-bin npm curl build-essential unzip gettext ninja-build clang-tidy
   ```

2. Install [universal-ctags](https://github.com/universal-ctags/ctags)

   ```bash
   sudo apt-get install libjansson-dev
   mkdir ~/.local/src; cd ~/.local/src
   git clone https://github.com/universal-ctags/ctags.git --depth=1
   cd ctags
   ./autogen.sh
   ./configure --prefix=$HOME/.local/
   make
   make install 

3. Install tmux

   I strongly recommend using tmux if you haven't already. If you have a root privilege, `sudo apt install tmux` will do. If the version is lower than 3.2a in your Ubuntu or if you don't have a root privilege, you may as well build tmux >= 3.2a to enjoy true color. libevent and ncurses are prerequisites. See [this page](https://github.com/tmux/tmux/wiki/Installing). I describe the tmux build command as an example as follows:   

   ```bash
   cd ~/.local/src
   git clone https://github.com/tmux/tmux.git
   cd tmux
   ./autogen.sh
   ./configure --prefix=${ROOT_DIR}/.local CFLAGS="-I${ROOT_DIR}/.local/include -I${ROOT_DIR}/.local/include/ncurses" LDFLAGS="-L${ROOT_DIR}/.local/include -L${ROOT_DIR}/.local/include/ncurses -L${ROOT_DIR}/.local/lib"
   make && make install
   ```

   Install tpm (Tmux Plugin Manager)

   ```bash
   cd
   wget https://github.com/guru245/dotfiles/blob/main/.tmux.conf
   wget https://github.com/guru245/dotfiles/blob/main/truecolor-test
   cd ~/.local/src
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   tmux
   ```

   Press `Ctrl+a` and then press `I` (captital) to install tmux plugins. You may want to run `~/trucolor-test` to check if true color is working correctly.

4. Install misc packages for Neovim

   ```
   sudo apt install ripgrep fzf fd-find bear
   ln -s $(which fdfind) ~/.local/bin/fd
   ```



## Installing Neovim

```bash
sudo apt install ninja-build gettext cmake unzip curl build-essential
cd ~/.local/src
git clone https://github.com/neovim/neovim
cd neovim
git checkout tags/v0.10.1
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local" CMAKE_BUILD_TYPE=Release
make install
pip3 install pynvim
```



## Installing NVIM Studio

```bash
cd ~/.local/src
git clone --depth 1 --recurse-submodules https://github.com/guru245/nvim-studio.git
ln -s ~/.local/src/nvim-studio ~/.config/nvim/
Note https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
or
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -es -u init.vim -i NONE -c "PlugInstall" -c "qa"
```

4. LSPInstall

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

