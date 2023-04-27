set directory=~/.vim/backup
set backupdir=~/.vim/backup " keep swap files here
filetype off                " required

" Highlighting for jsonc filetype
autocmd FileType json syntax match Comment +\/\/.\+$+

" Latex
let g:tex_flavor = 'latex'

" Better Unix support
set viewoptions=folds,options,cursor,unix,slash
set encoding=utf-8

function! TrimWhitespace()
    let l:save_cursor = getpos('.')
    %s/\s\+$//e   " Trim trailing whitespaces
    " %s/\t/  /g    " Replace tabs for whitespaces
    call setpos('.', l:save_cursor)
endfun

command! TrimWhitespace call TrimWhitespace() " Trim whitespace with command
autocmd BufWritePre * :call TrimWhitespace()  " Trim whitespace on every save

" Non-mapped function for tab toggles
function! TabToggle()
  if &expandtab
    set noexpandtab
  else
    set expandtab
  endif
endfunc

" map leader
let mapleader=','
let maplocalleader = ','

set backspace=2

set background=dark
"Fix https://github.com/dracula/vim/issues/161
au VimEnter * colorscheme dracula "colorscheme dracula
let g:airline_theme='dracula'
"let g:solarized_termcolors=256
"colorscheme solarized

syntax on
filetype plugin indent on

"set shell=/bin/zsh

set laststatus=2
set noshowmode

" Fixes broken cursor on Linux
set guicursor=

" General editor options
set hidden                  " Hide files when leaving them.
set number                  " Show line numbers.
set numberwidth=1           " Minimum line number column width.
set cmdheight=2             " Number of screen lines to use for the commandline.
"set textwidth=120           " Lines length limit (0 if no limit).
set formatoptions=jtcrq     " Sensible default line auto cutting and formatting.
set linebreak               " Don't cut lines in the middle of a word .
set showmatch               " Shows matching parenthesis.
set matchtime=2             " Time during which the matching parenthesis is shown.
set listchars=tab:▸\ ,eol:¬ " Invisible characters representation when :set list.
set clipboard=unnamedplus   " Copy/Paste to/from clipboard
set cursorline              " Highlight line cursor is currently on
set completeopt+=noinsert   " Select the first item of popup menu automatically without inserting it

" Search
set incsearch  " Incremental search.
set ignorecase " Case insensitive.
set smartcase  " Case insensitive if no uppercase letter in pattern, case sensitive otherwise.
set nowrapscan " Don't go back to first match after the last match is found.

" Fold
" set foldmethod=indent
" set foldlevelstart=1

" Tabs
set tabstop=2       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=2    " Indents will have a width of 4

set softtabstop=2   " Sets the number of columns for a TAB

set expandtab       " Expand TABs to spaces

" Disable mouse / touchpad (only in vim)
set mouse=nicr

