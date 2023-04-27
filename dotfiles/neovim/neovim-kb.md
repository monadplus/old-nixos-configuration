# Keybindings

## Plugins

### [vim-surround](https://github.com/tpope/vim-surround)
cs"'  replace surrouding " for '
ds"   remove surrounding "
yss"  add surrounding "
ysiw" add surround " on current word/object
[visual] S

### [Snippets](https://github.com/neoclide/coc-snippets)
You must add them at `.config/nvim/snippets/`.
<C-j> next placeholder
<C-k> previous placeholder
:CocList snippets

### [gitgutter](https://github.com/airblade/vim-gitgutter)

<leader>hp           Preview hunk
<leader>hu           Undo hunk
<leader>hs           stage hunk

### [vim-fugitive](https://github.com/tpope/vim-fugitive)

:Git command        Raw commands
:Gwrite                :Git add %
:Gread                 :Git checkout %
:Gremove               :Git rm %
:Gmove [relative/abs]  :Git mv from to
:Gcommit
:Gblame
                        g?    show this help
                        q     close blame
                        o     open commit in horizontal
                        O     open commit in new tab

:Gdiff (:Gvdiff)
  Left (index file) Right (working copy)
  :Gwrite (at index file) == :Gread (working copy)
  :Gread (at index file) == :Gwrie(working copy)
  :diffget chunk    index -> working
  :diffput chunk    working -> index
     You can save the index file => will only stage the modified patches
     Check it out with $git diff --cached
  :diffupdate (to update buffer)
  :do                      :diffget
  :dp                      :diffput
  :.diffget                only current line
  [visual] :'<,'>diffget   only some lines

Merging:
  :Gmerge
  After `git merge branch` conflict may arise.
  open the conflict file and then :Gvdiff
  Left (target = our branch), middle (working copy), right (merge branch)
  :diffget buffer (from the middle) (:ls for buffer, look for //2, //3
  :diffput buffer (from left or right)
  Then :on, :w, :Gstatus, stage merged files, cc (commit conflicts)
  :Gwrite! from left or right if you want to discard the other file.

:Gstatus (press g? to show help)
  <C-n>, <C-n>          to navigate
  -                     to stage/unstage
  X                     discard changes
  =                     inline diff
  dd (dv)               diff on file

:Glog  n [--reverse] (current file)
Load in the buffer all previous revisions
:copen to show a list of the different versions
]q    :cnext
[q    :cprevious
:Gedit  go back

:Glog -- path [% current]
:Glog --
  Then :copen
  use hjkl to move and enter to see the commit
:Glog --grep=.. -- <!-- show commit where message includes-->

:Ggrep word
:copen

:Ggrep 'word' branchName/hash <!--Opens read only buffer-->

<!--Search for a word added or deleted-->
:Glog -S... --

### [fuzzy-finder](https://github.com/junegunn/fzf/blob/master/README-VIM.md)
<C-p> fuzzy find current directory. Same as :FZF
:FZF ~/scala/fs2  Look for files under your home directory

### [nerdtree](https://github.com/scrooloose/nerdtree/blob/master/doc/NERDTree.txt)

<C-f>  :NERDTreeToggle
<C-s>  :NERDTreeFind [<path>] Find and reveal the current directory or the given path.
m (on nerdtree menu)           to open fylesystem options
?  Help, use it !

### [nerdcommenter](https://github.com/scrooloose/nerdcommenter)

<leader>c<space>  toggle comment line; For multiline comments line by line
<leader>cm        multi-line comment; For multiline comments all lines together
<leader>cu        multi-line uncomment; <leader>c<space> also works!

<leader>cc        comment line
<leader>c$        cursor to the end
<leader>cA        comment end of line and insert

### [vim-easy-align](https://github.com/junegunn/vim-easy-align)
[Visual] ga<character_to_align>
gaip=
    2=  around the 2n occurrences
    *=  around all occurrences
    <Enter>  Switching between left/right/center alignment
<space>
,
Regular expression

### [vim-hoogle](https://github.com/Twinside/vim-hoogle)

:Hoogle            current word
:Hoogle <search>

### [multi-cursor](https://github.com/terryma/vim-multiple-cursors)
<C-n> on a word and then
  <C-n> select
  <C-x> skip
  <C-p> previous
  Then you can just use A, I, delete word and insert: c or s

<M-n> select all occurences
<ESC> back to regular

[Visual] Select lines and then <C-n> to add a curson on each line
         Then, for example, you can move to the end of line A

## Basic commands

### Coc

gd            goto definition
gr            goto references
<leader>ac    codeAction on current line
F             format
K             show documentation
<leader>rn    rename
<space>a      diagnostic
<space>o      outline symbol curent document
<space>s      search symbol workspace
<space>j      default action next item
<space>k      default action previous item
<space>p      latest coc list
<leader><ESC> close preview (signature help)
<M-B>         metals build import
<M-C>         metals connect
<M-D>         metals doctor
<C-j>         snippet next placeholder
<C-k>         snippet previous placeholder
;h            haskel import
<leader>hi    Format haskell code with Hident
<leader>hs    Format haskell code with Stylish
<leader>hf    Format haskell code with both


### Switching
<M-h>
<M-j>
<M-k>
<M-l>

### Moving
<M-H>
<M-J>
<M-K>
<M-L>
<M-x>

### Resizing
<M-=>
<M-+>
<M-->
<M-<>
<M->>

### Copy / Paste
In Normal mode:
 d: to cut
 <leader>d  deletes but doesn't save in a buffer
 y: to copy (yank)
 p: paste after cursor
 <leader>p   n times paste
 P: paste before cursor

Press v, move to select, press d/y and then p to paste

### New line
o / O: new line after cursor / new line before cursor.

### Back and forth files/locations
<C-o> and <C-i>:  jump back and forth between recent points in files

### Split screens
<C-w> v     vertical split
<C-w> S     horizontal split
<C-w> q     close window
:on         close all except this

### Files
:w filename.txt           Write current content to file
:new filename.txt         Open new buffer with the given name.

### Open link
gx       on browser
gf       open link on file
         Only works for files in the 'path' (:set path += ...)
         You can actually open this ftp.vim.org/pub/vim/README

### Search
<f char>      ; (next ocurrence)
              , (previous)
<F char>      backwards
/             n and N
   You can use regex:
      /^the  /the$    /t.e
? (backwards) n and N
*             * and #
<C-z>         clear search highlight

### Substitute
:s/old/new/g   line
:%s/old/new/g  file
:%s/old/new/gc file + prompt (to confirm or skip)

### Marks
m[a..z]    mark a line
'[a..z]    jump to   mark
:marks     list marks

### Folding
	zf	F-old creation
	zo	O-pen a fold
	zc	C-lose a fold

### Motions
N w   word forward        e.g. 2dd (delete two lines)
N W   word forward with special characters
      e.g. special-word special/word/yey
      works for W, E, ...
N aw  a word (whitespaces incluses)
N iw  in word
N e   until the end of this word
N ge  until the end of this word (backwards)
N b   word backwards
N $   until end of line
N )   sentence forward
N (   sentence backward
N }   paragraph forward
^ 0 <HOME>  start of line
$ <END>     end of line
A / I: append end of line / insert start of line
50G         Goto line 50
%    matching (, [, {
gg and G   star or end of file
M          cursor in the middle of screen

### Ranges
:1,5s/this/that/g     replace from line 1 to 5
:54s/this/that/g      replace in linne 54
:.,$   from current to end

### Text objects
aw, iw, ...

### Identation
>> and <<
>G      Ident end of file
>ap     Ident a paragraph

### Scrolling
<C-f>   forward screen
<C-b>   backward screen
<C-u>   down half a screen
<C-d>   up half a screen
<C-y>   down line
<C-e>   up line
zz      center line on screen

### Help
<F1> or :help

# Delete, rename and change
d           delete
  df"       delete from cursor to "
c           change
  c2w..
  cc
r           rename (delete + <ESC>)
R           to replace
D           d$
C           d$
s           change char
S           c$
x           delete char
X           delete char (backwards)

### Recording
qa .... q
To apply the record @a (you can 3@a)

### Session & views
:mksession session_01.vim        make session (windows layout, history, etc)
nvim -S session_01.vim           restore session

###  Miscelaneous
:!command
vim -o one.txt two.txt       open all three files in split windows
vim -d main.txt~ main.txt    show file diff
:diffsp help.txt             Diff with backup file
xp                           swap next two characters around

### Option window
:options
  Go th the options you want to change.
  Go to the set and press <Enter> to change it
  Options can be swaped using <Enter> others setting the value

### End of line
unix:  <LF> line feed
apple: <CR> carriage return
dos:   <CR><LF>
Vim automatically recognizes the different file formats and handles things for you.

### Formatting
No formatting by default
:set textwidth=30  # line break
[visual] gq        # format paragraph
gqap               # a paragraph
gg gq G            # Format all text

### Upper/Lower case

~       : invert case
guu     : lowercase line
gUU     : uppercase line<Paste>

### Visual
v         select (o     to change selection directio)
V         line select
<C-v>     block select
   e.g. delete the middle column of a table <c-v>, 3j, w, h and d
gv       Reselect the last visual selection

### Unimpared
To native through the quickfix window: ]q and [q

<C-a>/<C-x>: increment/decrement a number LOL
