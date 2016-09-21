scriptencoding utf-8
set nocompatible

" ---------------- Plugins ------------------------------------------------ {{{1

" Load vim-plug if it's not there.
if empty(glob("~/.vim/autoload/plug.vim"))
	execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs'
		\ 'https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin()

Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'dag/vim-fish', { 'for': 'fish' }
Plug 'dbakker/vim-projectroot'
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
Plug 'ervandew/supertab'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'file-line'
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'hkmix/vim-george', { 'for': 'george' }
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
Plug 'ledger/vim-ledger', { 'for': 'ledger' }
Plug 'mk12/ag.vim'
Plug 'mk12/vim-lean', { 'for': 'lean' }
Plug 'repeat.vim'
Plug 'scrooloose/syntastic'
Plug 'surround.vim'
Plug 'tComment'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'wting/rust.vim', { 'for': 'rust' }

filetype plugin indent on

call plug#end()

" ---------------- General ------------------------------------------------ {{{1

set guifont=mononoki             " current favourite mono font
set number                       " show line numbers
set numberwidth=4                " most files are in the hundreds
set backspace=indent,eol,start   " allow backspace in insert mode
set undolevels=100               " store lots of undo history
set showcmd                      " show incomplete commands
set showmode                     " show current mode
set cmdheight=2                  " to avoid 'Enter to continue'
set laststatus=2                 " required for airline to work properly
set noerrorbells                 " no bells
set visualbell t_vb=             " no sounds
set autoread                     " reload files changed outside Vim
set viminfo='100,%,f1            " save marks, buffer
set encoding=utf-8               " assume UTF-8
set guioptions-=r                " remove scrollbar
set mouse=a                      " use mouse to select and drag
set ttymouse=sgr                 " best tty mouse mode
set mousefocus                   " let the mouse control splits
set autochdir                    " cd to the file's directory
set lazyredraw                   " don't redraw while executing macros
set ttyfast                      " maybe this makes things smoother?
set hidden                       " allow buffers in the background
set tildeop                      " make ~ (case changer) an operator
set spelllang=en_ca              " use Canadian English

" ---------------- Plugin settings ---------------------------------------- {{{1

" FZF
let g:fzf_command_prefix = 'Fzf'

" Ag
let g:ag_working_path_mode='r'
let g:ag_prg='ag --smart-case --column --ignore tags'

" Airline
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Ctags
set tags+=tags;/

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_mode_map = { 'mode': 'passive' }

" Go
let g:go_fmt_command = 'goimports'
let g:go_doc_keywordprg_enabled = 0

" EasyAlign
let g:easy_align_delimiters = {
	\ '/': {
		\ 'pattern': '//\+\|/\*\|\*/',
		\ 'delimiter_align': 'l',
		\ 'ignore_groups': ['!Comment']
	\ }
\ }

" ---------------- Shortcuts ---------------------------------------------- {{{1

" Comma is easier to reach than backslash (the default leader).
let mapleader = ','
let maplocalleader = '\\'

" We'll never need to input jj.
inoremap jj <esc>

" Swap ; and : so that you don't have to press shift for commands.
noremap ; :
noremap : ;

" Swap ^ and 0 because ^ is more useful but 0 is easier to type.
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
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <silent> <tab> :call NextBufOrTab()<cr>
nnoremap <silent> <S-tab> :call PrevBufOrTab()<cr>
nnoremap <silent> <leader>d :bdel<cr>
nnoremap <silent> <C-n> :tabnew<cr>

" These actions need quick access.
nnoremap <silent> <leader>w :w<cr>
nnoremap <silent> <leader>i g<C-g>
nnoremap <silent> <leader>/ :silent :nohlsearch<cr>
nnoremap <silent> <leader>l :setlocal list!<cr>
nnoremap <silent> <leader>n :set relativenumber!<cr>
nnoremap <silent> <leader>t :set paste!<cr>

" This requires the tComment plugin.
nnoremap <leader>c gcc
vnoremap <leader>c gc

" Thou shalt not cross 80 columns in thy file.
nnoremap <leader>7 :call EightyColumns(0)<cr>
nnoremap <leader>8 :call EightyColumns(1)<cr>

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo, so that
" you can undo CTRL-U after inserting a line break.
inoremap <C-u> <C-g>u<C-u>

" I almost never want to replace the " register when pasting in visual mode.
vnoremap <silent> <expr> p <sid>VisualReplace()

" FZF shortcuts
nnoremap <silent> <leader>p :execute 'FzfFiles '.projectroot#guess()<cr>
nnoremap <silent> <leader>b :FzfBuffers<cr>

" Search for the word under the cursor with Ag.
nnoremap <leader>a :Ag "\b<C-r><C-w>\b"<cr>
vnoremap <leader>a y:Ag "<C-r>""<cr>

" Toggle Syntastic
nnoremap <silent> <leader>s :SyntasticToggleMode<cr>

" Switch between header and source file
nnoremap <silent> H :call ToggleSourceHeader()<cr>

" Jump to next Git hunk
nnoremap <silent> <C-f> :GitGutterNextHunk<cr>

" Toggle Goyo (distraction-free mode).
nnoremap <leader>g :Goyo<cr>

" EasyAlign
vnoremap ga :EasyAlign<cr>

" Filetype-specific shortcuts
augroup shortcuts
	autocmd!
	autocmd filetype lean nnoremap <silent> <leader>m :LeanCheck<cr> | \
		nnoremap <silent> <leader>r :LeanReplace<cr>
augroup END

" ---------------- Colour ------------------------------------------------- {{{1

if !has("gui_running")
	let g:solarized_termtrans = 1
	let g:solarized_termcolors = 16
endif

syntax enable
set background=dark
colorscheme solarized

" Toggle light/dark background
command! DarkLight call ToggleBackground()

" Make invisible characters less obtrusive.
highlight clear NonText
highlight link NonText Comment

" Toggle the Terminal profile and the Vim background colour
function! ToggleBackground()
	silent !darklight.applescript
	let &background=(&background == "light" ? "dark" : "light")
endfunction

" Toggle the Terminal profile and the Vim background colour
function! RestoreBackground()
	if &background == "light"
		call ToggleBackground()
	endif
endfunction

augroup background
	autocmd!
	autocmd VimLeave * call RestoreBackground()
augroup END

" ---------------- Navigation --------------------------------------------- {{{1

function! NextBufOrTab()
	if tabpagenr('$') > 1
		tabnext
	else
		bnext
	end
endfunction

function! PrevBufOrTab()
	if tabpagenr('$') > 1
		tabprev
	else
		bprev
	end
endfunction

function! ToggleSourceHeader()
	let l:extension = expand("%:e")
	if l:extension == "h" || l:extension == "hpp"
		echo expand("%:p:r.cpp")
		if filereadable(expand("%:p:r") . ".c")
			execute "e " . expand("%:p:r") . ".c"
		elseif filereadable(expand("%:p:r") . ".cpp")
			execute "e " . expand("%:p:r") . ".cpp"
		else
			echo "can't find source file"
		endif
	elseif l:extension == "c" || l:extension == "cpp"
		if filereadable(expand("%:p:r") . ".h")
			execute "e " . expand("%:p:r") . ".h"
		elseif filereadable(expand("%:p:r") . ".hpp")
			execute "e " . expand("%:p:r") . ".hpp"
		else
			echo "can't find header file"
		endif
	else
		echo "not a source file or header file"
	end
endfunction

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
augroup columns
	autocmd!
	autocmd BufWinEnter * call EightyColumns(1)
	" Use markers for 60 and 80 columns in ledger journals.
	autocmd FileType ledger setlocal tw=0 cc=61,81
augroup END

" ---------------- Registers ---------------------------------------------- {{{1

function! RestoreRegister()
	let @" = s:restore_reg
	return ''
endfunction

function! s:VisualReplace()
	let s:restore_reg = @"
	return "p@=RestoreRegister()\<cr>"
endfunction

" ---------------- Indentation -------------------------------------------- {{{1

set autoindent     " stay indented on new line
set shiftround     " round indents to multiples of shiftwidth
set ts=4 sw=4      " use 4-wide tabs for most files

" ---------------- Folds -------------------------------------------------- {{{1

set foldmethod=manual  " I would default to syntax, but it's slow
set foldnestmax=3
set nofoldenable

" ---------------- Tab completion ----------------------------------------- {{{1

" Use enhanced command completion.
set wildmenu
set wildmode=longest,full

" Put SuperTab in longest mode as well.
" asdfasdf
set completeopt+=longest
let g:SuperTabLongestEnhanced = 1

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
