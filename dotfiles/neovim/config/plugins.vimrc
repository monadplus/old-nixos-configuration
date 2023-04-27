" airline: status bar at the bottom
let g:airline_powerline_fonts=1

" if you want to disable auto detect, comment out those two lines (COC)
"let g:airline#extensions#disable_rtp_load = 1
"let g:airline_extensions = ['branch', 'hunks', 'coc']

"let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
"let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" Nerd commenter
filetype plugin on

" Nerdtree git plugin symbols
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "m",
    \ "Staged"    : "s",
    \ "Untracked" : "u",
    \ "Renamed"   : "r",
    \ "Unmerged"  : "n",
    \ "Deleted"   : "x",
    \ "Dirty"     : "~",
    \ "Clean"     : "c",
    \ "Unknown"   : "?"
    \ }

" Open Nerdtree when nvim starts with no file opened
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close Nerdtree when it is  the last window opened
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NerdTree config
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeShowHidden = 1

let g:NERDTreeShowGitStatus = 1

" Rainbow brackets
let g:rainbow_active = 1

" haskell-vim
let g:haskell_indent_if = 2               " Align 'then' two spaces after 'if'
let g:haskell_indent_before_where = 2     " Indent 'where' block two spaces under previous body
let g:haskell_indent_case_alternative = 1 " Allow a second case indent style (see haskell-vim README)
let g:haskell_indent_let_no_in = 0        " Only next under 'let' if there's an equals sign
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

" ----- hindent & stylish-haskell -----

let g:stylishask_config_file = "~/.stylish-haskell.yaml"
let g:stylishask_on_save = 0
let g:hindent_on_save    = 0

" ----- w0rp/ale -----
"  I prefer ghcid over ghc-mod for large projects
"  ghcid integration: https://github.com/aiya000/vim-ghcid-quickfix
"let g:ale_linters = {'haskell': ['ghc-mod', 'hlint']}

" -- Deactivated
"let g:ale_linters = {'haskell': ['hlint']}

" Create/Update tags on save file
augroup tags
au BufWritePost *.hs            silent !fast-tags -R . --nomerge
au BufWritePost *.hsc           silent !fast-tags -R . --nomerge
augroup END

" Folding is disabled (https://github.com/plasticboy/vim-markdown#disable-folding)
let g:vim_markdown_folding_disabled = 1

"""" Syntastic Configuration
" A syntactic checker like hlint should be installed in your PATH
" Run :SyntasticInfo to see what syntactic checkers are supported and enabled.
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0 " closed on open, not displayed until the file is saved
let g:syntastic_check_on_wq = 0
"""" Ignore hs - annoying
let g:syntastic_mode_map = { "mode": "active", "passive_filetypes": ["haskell", "hs"] }

"""" Pointfree Configuration (:help pointfree)
au BufNewFile,BufRead *.hs nmap pf <Plug>Pointfree

"""" jedi-vim
let g:jedi#completions_enabled = 0

"""" zealvim.vim
let g:zv_file_types = {
            \   'py': 'python3,numpy,pandas,matplotlib',
            \   'tex' : 'latex'
            \ }

"""" vim-latex-live-preview
let g:livepreview_previewer = 'zathura'
let g:livepreview_engine = 'lualatex' . ' -shell-escape'
let g:livepreview_cursorhold_recompile = 0 " do not recompile on cursor hold over.

"""" UltiSnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" TODO
"let g:UltiSnipsSnippetDirectories=['/etc/nixos/dotfiles/neovim/UltiSnips']
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
" ^^^^^^^^^^^ required to make tab complete snippets

" rust.vim
let g:rustfmt_autosave = 1
let g:syntastic_rust_checkers = ['cargo']
let g:rust_cargo_avoid_whole_workspace = 0

" vim-ormolu
let g:ormolu_options=["-o -XTypeApplications"]
