" Plugins for neovim using vim-plug (https://github.com/junegunn/vim-plug)
call plug#begin('~/.local/share/nvim/plugged')

Plug 'tpope/vim-fugitive'                                         " git plugin
Plug 'vim-airline/vim-airline'                                    " bottom status bar
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fuzzy finder conf
Plug 'junegunn/fzf.vim'                                           " fuzzy finder
Plug 'scrooloose/nerdtree'                                        " folders tree
Plug 'scrooloose/nerdcommenter'                                   " code commenter
Plug 'dracula/vim'                                                " dark theme
Plug 'morhetz/gruvbox'                                            " color scheme
Plug 'altercation/vim-colors-solarized'
Plug 'luochen1990/rainbow'                                        " Colored parentheses
Plug 'tpope/vim-surround'                                         " quickly edit surroundings (brackets, html tags, etc)
Plug 'junegunn/vim-easy-align'                                    " alignment plugin
Plug 'neomake/neomake'                                            " run programs asynchronously and highlight errors
Plug 'Twinside/vim-hoogle'                                        " Hoogle search (Haskell) in Vim
Plug 'terryma/vim-multiple-cursors'                               " Multiple cursors selection, etc
Plug 'itchyny/lightline.vim'                                      " configurable status line (can be used by coc)
Plug 'Xuyuanp/nerdtree-git-plugin'                                " Shows files git status on the NerdTree
Plug 'airblade/vim-gitgutter'                                     " Show file git status
Plug 'neovimhaskell/haskell-vim'                                  " Haskell Syntax and Identation
Plug 'alx741/vim-stylishask'                                      " Haskell Formatting
Plug 'alx741/vim-hindent'                                         " Haskell Formatting
Plug 'tpope/vim-unimpaired'                                       " better navigation
Plug 'ekalinin/Dockerfile.vim'
Plug 'LnL7/vim-nix'                                               " Nix expressions in vim
Plug 'chrisbra/Recover.vim'                                       " Add compare option to vim recover
Plug 'ervandew/supertab'                                          " Tab completition
Plug 'godlygeek/tabular'                                          " vim-markdown dependency
Plug 'plasticboy/vim-markdown'                                    " Markdown utilities
Plug 'vmchale/pointfree'                                           " Pointfree for haskell
Plug 'vmchale/cabal-project-vim'                                   " Syntax highlight for *.cabal files
Plug 'vmchale/ghci-syntax'                                         " Syntax highlight for ghci configuration files
"Plug 'vmchale/hs-conceal'                                          " Replace forall and so in *.hs files
"Plug 'vmchale/c2hs-vim'                                            " Syntax highlight for *.c2hs files
Plug 'vim-syntastic/syntastic'                                     " Hlint for hs
Plug 'ryanoasis/vim-devicons'                                      " Icons (requires nerd-font comptabile: https://github.com/ryanoasis/vim-devicons#installation)
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }             " Live compilation of .text files
Plug 'KabbAmine/zeavim.vim'                                        " Zeal docs https://zealdocs.org/
Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }                 " ghcid integration :Ghcid
Plug 'SirVer/ultisnips'                                            " Snippets
Plug 'honza/vim-snippets'                                          " Collection of snippets for several languages
Plug 'davidhalter/jedi-vim'                                        " Python auto-completition
Plug 'direnv/direnv.vim'                                           " direnv integration
Plug 'ycm-core/YouCompleteMe'                                      " Completition engine. Requires additional completition steps!
Plug 'rust-lang/rust.vim'                                          " Rust syntax and syntastic integration
Plug 'derekelkins/agda-vim'                                        " Agda vim
Plug 'sdiehl/vim-ormolu'                                           " Opinionated Haskell code formatter


call plug#end()
