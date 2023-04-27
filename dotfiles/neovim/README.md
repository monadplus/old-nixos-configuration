# Neovim

Plugins are managed by [vim-plug](https://github.com/junegunn/vim-plug)

### Installation

Execute the following commands:

```bash
# Clone this repo into your .dotfiles directory
cd ~/.dotfiles
git clone git@github.com:monadplus/nvim-setup.git nvim

# Link this directory to neovim's init.vim directory
mkdir ~/.config
ln -s "$(pwd)/nvim" ~/.config/nvim/

# Install nvim (and its dependencies: pip3, git), Python 3 and fast-tags (for ctags)
# fast-tags may not be in APT.. manual installaction https://github.com/elaforge/fast-tags
#
# https://github.com/neovim/neovim/wiki/Installing-Neovim#debian
sudo apt update
sudo apt install neovim python3 python3-pip git curl python-neovim python3-neovim fast-tags -y

# Install vim-plug plugin manager
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# (Optional but recommended) Install a nerd font for icons and a beautiful airline bar (https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts) (I'll be using Iosevka for Powerline)
curl -fLo ~/.fonts/Iosevka\ Term\ Nerd\ Font\ Complete.ttf --create-dirs https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Regular/complete/Iosevka%20Term%20Nerd%20Font%20Complete.ttf

# (Optional) Alias vim -> nvim
# echo "alias vim='nvim'" >> ~/.bashrc

# Enter Neovim and install plugins
nvim -c ':PlugInstall' -c ':UpdateRemotePlugins' -c ':qall'
```

#### Additional steps

Some plugins require node, yarn and python installed in the system.

For python plugins, you must also run `$ pip install pynvim`.

### Tags for haskell

Tags require `fast-tags` on the `$PATH` in order to work.

Tags are created/updated after each save on an `.hs`/`.hsc` file.
It's as simple as saving an `.hs` in order to create them.

### YouCompleteMe

Requires [additional installation steps](https://github.com/ycm-core/YouCompleteMe#linux-64-bit)
