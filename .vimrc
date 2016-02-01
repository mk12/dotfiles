scriptencoding utf-8
set nocompatible

" ---------------- Plugins ------------------------------------------------ {{{1

" Load vim-plug if it's not there.
if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs'
		\ 'https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'repeat.vim'
Plug 'surround.vim'
Plug 'file-line'
Plug 'tComment'
Plug 'ervandew/supertab'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-endwise'
Plug 'scrooloose/syntastic'
Plug 'bling/vim-airline'
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
Plug 'wting/rust.vim', { 'for': 'rust' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'dag/vim-fish', { 'for': 'fish' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
Plug 'hkmix/vim-george', { 'for': 'george' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'dbakker/vim-projectroot'

filetype plugin indent on

call plug#end()

" ---------------- General ------------------------------------------------ {{{1

set guifont=Triplicate\ T4c:h15  " Triplicate is the best; bigger is better
set number                       " line numbers are good
set numberwidth=4                " most files are in the hundreds
set backspace=indent,eol,start   " allow backspace in insert mode
set undolevels=100               " store lots of undo history
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

" These actions need quick access.
nnoremap <silent> <leader>w :w<cr>
nnoremap <silent> <leader>i g<C-g>
nnoremap <silent> <leader>/ :silent :nohlsearch<cr>
nnoremap <silent> <leader>l :setlocal list!<cr>
nnoremap <silent> <leader>n :set relativenumber!<cr>
nnoremap <silent> <leader>t :set paste!<cr>

" Tab and buffer stuff.
nnoremap <silent> <tab> :bnext<cr>
nnoremap <silent> <S-tab> :bprev<cr>
nnoremap <silent> <leader>d :bdel<cr>
nnoremap <silent> <C-n> :tabnew<cr>

" This requires the tComment plugin.
map <leader>c gcc

" Thou shalt not cross 80 columns in thy file.
nnoremap <leader>7 :call EightyColumns(0)<cr>
nnoremap <leader>8 :call EightyColumns(1)<cr>

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-u> <C-g>u<C-u>

" FZF shortcuts
nnoremap <silent> <leader>p :execute 'Files '.projectroot#guess()<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>m :Marks<cr>

" Search for the word under the cursor with Ag.
nnoremap <silent> <leader>a :Ag "\b<C-r><C-w>\b"<cr>
vnoremap <silent> <leader>a y:Ag "<C-r>""<cr>

" Toggle Syntastic
nnoremap <silent> <leader>s :SyntasticToggleMode<cr>

" Regex to update Ruby hash syntax.
" nnoremap <C-h> :%s/:\([^=,'": ]\{-}\) =>/\1:/c<cr>
" vnoremap <C-h> :/:\([^=,'": ]\{-}\) =>/\1:/c<cr>

" Switch between header and source file
nnoremap <silent> <C-h> :call ToggleSourceHeader()<cr>

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

" ---------------- Colour/syntax ------------------------------------------ {{{1

if !has("gui_running")
	let g:solarized_termtrans = 1
	let g:solarized_termcolors = 16
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
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''

" Ctags
set tags+=tags;/

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

let g:go_fmt_command = "goimports"
let g:go_doc_keywordprg_enabled = 0

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
set ts=4 sw=4      " use 4-wide tabs for most files

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

" ---------------- Search ------------------------------------------------- {{{1

set incsearch   " find the next match as we type the search
set hlsearch    " highlight searches by default
set ignorecase  " ignore case by default
set smartcase   " don't ignore case if the search contains uppercase characters
set gdefault    " use /g by default (match all occurences in the line)

" let g:ag_working_path_mode="r"  " search from the project root
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
