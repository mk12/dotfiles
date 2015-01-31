" Disable Vi compatibility (must come first).
set nocompatible

" ---------------- Bundles ------------------------------------------------ {{{1

" This is required for Vundle to work.
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'repeat.vim'
Plugin 'surround.vim'
Plugin 'file-line'
Plugin 'tComment'
Plugin 'ervandew/supertab'
Plugin 'ciaranm/detectindent'
Plugin 'wincent/command-t'
Plugin 'altercation/vim-colors-solarized'
Plugin 'amdt/vim-niji'
Plugin 'tpope/vim-fireplace'
Plugin 'guns/vim-clojure-static'
Plugin 'wting/rust.vim'
Plugin 'JuliaLang/julia-vim'
Plugin 'cespare/vim-toml'
Plugin 'idris-hackers/idris-vim'
Plugin 'bling/vim-airline'
Plugin 'fatih/vim-go'

call vundle#end()
filetype plugin indent on

" ---------------- General ------------------------------------------------ {{{1

set guifont=Triplicate\ T4c:h15  " Triplicate is the best; bigger is better
set number                       " line numbers are good
set numberwidth=4                " most files are in the hundreds
set backspace=indent,eol,start   " allow backspace in insert mode
set undolevels=100               " store lots of undo history
set history=1000                 " store lots of :cmdline history
set showcmd                      " show incomplete commands down the bottom
set showmode                     " show current mode down the bottom
set cmdheight=2                  " show extra stuff
set noerrorbells                 " bells are annoying
set visualbell t_vb=             " no sounds
set autoread                     " reload files changed outside Vim
set viminfo='100,%,f1            " save marks, buffer
set enc=utf-8                    " UTF-8 is the best
set guioptions-=r                " remove scrollbar
set mousefocus                   " let the mouse control splits
set autochdir                    " cd to the file's directory
set lazyredraw                   " don't redraw while executing macros
set hidden                       " allow buffers in the background
set tildeop                      " make ~ (case changer) an operator
set spelllang=en_ca              " use Canadian English

" ---------------- Shortcuts ---------------------------------------------- {{{1

" It's easier to reach than the backslash (default leader).
let mapleader = ","
let maplocalleader = "\\"

" We'll never need to input jj.
inoremap jj <esc>

" Swap ; and : so that you don't have to press shift for commands.
noremap ; :
noremap : ;

" Swap ^ and 0 because ^ is more useful but 0 is easier to use.
noremap 0 ^
noremap ^ 0

" Make Y behave like other capitals.
nnoremap Y y$

" Format a paragraph with one keystroke.
nnoremap Q gqap

" Make navigation easier.
nnoremap <space> <C-f>
nnoremap <S-space> <C-b>
nnoremap J <C-d>
nnoremap K <C-u>
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" These actions need quick access.
nnoremap <silent> <leader>w :w<cr>
nnoremap <silent> <leader>g g<C-g>
nnoremap <silent> <leader>/ :silent :nohlsearch<cr>
nnoremap <silent> <leader>l :setlocal list!<cr>
nnoremap <silent> <leader>s :setlocal spell!<cr>
nnoremap <silent> <leader>f :call ToggleFoldMethod()<cr>

" This requires the tComment bundle.
map <leader>c gcc

" Thou shalt not cross 80 columns in thy file.
nnoremap <leader>7 :call EightyColumns(0)<cr>
nnoremap <leader>8 :call EightyColumns(1)<cr>

" Quickly edit/reload this file.
nnoremap <silent> <leader>v :e $MYVIMRC<cr>
nnoremap <silent> <leader>r :so $MYVIMRC<cr>

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" ---------------- Colour/syntax ------------------------------------------ {{{1

if !has("gui_running")
	let g:solarized_termtrans=1
	let g:solarized_termcolors=16
endif

syntax enable
set background=dark
colorscheme solarized

" Make invisible characters less obtrusive.
highlight clear NonText
highlight link NonText Comment

highlight htmlItalic gui=italic
highlight htmlBold gui=bold
highlight htmlBoldItalic gui=bold,italic

" ---------------- Lines -------------------------------------------------- {{{1

set wrap              " do soft wrapping
set textwidth=0       " no hard wrapping by default
set wrapmargin=0      " don't hard wrap based on terminal width
set linebreak         " wrap at spaces, not in the middle of words
set display=lastline  " show part of really long lines (not @s)
set nojoinspaces      " one space after period in join command
set scrolloff=8       " start scrolling when 8 lines away from margins

set listchars=eol:¬,tab:».,trail:~,extends:>,precedes:<

function! EightyColumns(yes)
	if a:yes
		setlocal textwidth=80 colorcolumn=+1
	else
		setlocal textwidth=0 colorcolumn=0
	endif
endfunction

" Make the eighty-column marker the default.
augroup eighty
	autocmd!
	autocmd BufWinEnter * call EightyColumns(1)
augroup END

" ---------------- Indentation -------------------------------------------- {{{1

set autoindent     " stay indented on new line
set shiftround     " round indents to multiples of shiftwidth
set noexpandtab    " use tabs, not spaces
set tabstop=8      " tabs are 8 columns wide
set softtabstop=0  " disable soft tab stops
set shiftwidth=0   " 0 = use the value of tabstop

augroup indentation
	autocmd!
	" Tabs for indentation, spaces for alignment. I prefer 4-column indents.
	autocmd Filetype c,cpp,css,go,html,xml,java,javascript,php,sh,perl,vim,
		\rust,julia call Tabs(4)
	" These languages work better with spaces for everything. I prefer 4 spaces.
	autocmd Filetype haskell,objc,python call Spaces(4)
	" These languages look better with two-space indents.
	autocmd Filetype ruby,lisp,scheme,clojure call Spaces(2)
augroup END

function! Tabs(width)
	exec "setlocal noet sts=0 sw=0 ts=" . a:width
endfunction

function! Spaces(width)
	" sts: -1 = use the value of shiftwidth
	exec "setlocal et ts=8 sts=-1 sw=" . a:width
endfunction

" ---------------- Folds -------------------------------------------------- {{{1

set foldmethod=syntax
set foldnestmax=3
set nofoldenable

let s:FoldMethod = 0
function! ToggleFoldMethod()
	if s:FoldMethod == 0
		setlocal foldmethod=marker
		echo 'foldmethod: marker'
		let s:FoldMethod = 1
	elseif s:FoldMethod == 1
		setlocal foldmethod=expr
		echo 'foldmethod: expr'
		let s:FoldMethod = 2
	elseif s:FoldMethod == 2
		setlocal foldmethod=syntax
		echo 'foldmethod: syntax'
		let s:FoldMethod = 0
	endif
endfunction

" ---------------- Tab completion ----------------------------------------- {{{1

" Use enhanced command completion.
set wildmenu
set wildmode=longest,full

" Put SuperTab in longest mode as well.
set completeopt+=longest
let g:SuperTabLongestEnhanced = 1

" Hitting tab is easier than the using the default triggers.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"

" ---------------- Search ------------------------------------------------- {{{1

set incsearch   " find the next match as we type the search
set hlsearch    " highlight searches by default
set ignorecase  " ignore case by default
set smartcase   " don't ignore case if the search contains uppercase characters
set gdefault    " use /g by default (match all occurences in the line)

" ---------------- Cursor ------------------------------------------------- {{{1

set ruler          " display row & column in status bar
set cursorline     " highlight current line
set nostartofline  " don't return to start of line after page down

" Don't blink the block cursor in normal mode or in visual mode.
set guicursor+=n-v:blinkon0

" Remember the cursor position in a file between sessions.
function! ResCur()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction

augroup resCur
	autocmd!
	autocmd BufWinEnter * call ResCur()
augroup END

" ---------------- Encryption --------------------------------------------- {{{1

" Blowfish is much more secure than the default (zip).
set cryptmethod=blowfish

" Turn off viminfo when editing encrypted files. Vim handles the rest for us
" (swap, undo, and backup files).
function! DisableViminfo()
	if !empty(&key)
		set viminfo=
	endif
endfunction

augroup encryption
	autocmd!
	autocmd BufRead * call DisableViminfo()
augroup END

" ---------------- Special files ------------------------------------------ {{{1

" Create these directories is they don't already exist.
silent !mkdir -p ~/.vim/backup > /dev/null 2>&1
silent !mkdir -p ~/.vim/tmp > /dev/null 2>&1
silent !mkdir -p ~/.vim/spell > /dev/null 2>&1

" Don't clutter the working directory with swap files or backups.
set directory=~/.vim/tmp,~/.tmp,/var/tmp,/tmp
set backupdir=./.backup,~/.vim/backup
set undodir=~/.vim/backup
set spellfile=~/.vim/spell/en.utf-8.add,en.utf-8.add
set backup
set undofile
