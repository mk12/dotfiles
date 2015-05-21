scriptencoding utf-8
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
Plugin 'Numkil/ag.nvim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-endwise'
Plugin 'scrooloose/syntastic'
Plugin 'bling/vim-airline'
Plugin 'kchmck/vim-coffee-script'
Plugin 'guns/vim-clojure-static'
Plugin 'wting/rust.vim'
Plugin 'fatih/vim-go'
Plugin 'JuliaLang/julia-vim'
Plugin 'dag/vim-fish'
Plugin 'cespare/vim-toml'

call vundle#end()
filetype plugin indent on

" ---------------- General ------------------------------------------------ {{{1

set guifont=Triplicate\ T4c:h15  " Triplicate is the best; bigger is better
set number                       " line numbers are good
set numberwidth=4                " most files are in the hundreds
set relativenumber               " easier for quick navigation
set backspace=indent,eol,start   " allow backspace in insert mode
set undolevels=100               " store lots of undo history
set history=1000                 " store lots of :cmdline history
set showcmd                      " show incomplete commands down the bottom
set showmode                     " show current mode down the bottom
set cmdheight=2                  " show extra stuff
set laststatus=2                 " required for airline to work properly
set noerrorbells                 " bells are annoying
set visualbell t_vb=             " no sounds
set autoread                     " reload files changed outside Vim
set viminfo='100,%,f1            " save marks, buffer
set encoding=utf-8               " UTF-8 is the best
set guioptions-=r                " remove scrollbar
set mousefocus                   " let the mouse control splits
set autochdir                    " cd to the file's directory
set lazyredraw                   " don't redraw while executing macros
set ttyfast                      " maybe this makes things smoother?
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
nnoremap <silent> <leader>i g<C-g>
nnoremap <silent> <leader>/ :silent :nohlsearch<cr>
nnoremap <silent> <leader>l :setlocal list!<cr>
nnoremap <silent> <leader>p :call CycleFoldMethod()<cr>
nnoremap <silent> <leader>n :set relativenumber!<cr>

nnoremap <silent> <tab> :bnext<cr>
nnoremap <silent> <S-tab> :bprev<cr>
nnoremap <silent> <leader>d :bdel<cr>
nnoremap <silent> <C-n> :tabnew<cr>

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
inoremap <C-u> <C-g>u<C-u>

" CtrlP shortcuts
nnoremap <silent> <leader>b :CtrlPBuffer<cr>
nnoremap <silent> <leader>m :CtrlPMRU<cr>

" Search for the word under the cursor with Ag.
nnoremap <silent> <leader>a :Ag "\b<C-r><C-w>\b"<cr>
vnoremap <silent> <leader>a y:Ag "<C-r>""<cr>

" Toggle Syntastic
nnoremap <silent> <leader>s :SyntasticToggleMode<cr>

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

" Airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_mode_map = { 'mode': 'passive' }

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
set tabstop=4      " use 4-wide tabs for most files

" ---------------- Folds -------------------------------------------------- {{{1

set foldmethod=manual  " I would default to syntax, but it's slow
set foldnestmax=3
set nofoldenable

let s:FoldMethod = 0
function! CycleFoldMethod()
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

let g:ag_working_path_mode="r"  " search from the project root
let g:ag_prg="ag --smart-case --column"  " use smart case

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
