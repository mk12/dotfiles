" =========== Plugins ==========================================================

if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin()

Plug 'Valloric/YouCompleteMe'
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dag/vim-fish', { 'for': 'fish' }
Plug 'dietsche/vim-lastplace'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'junegunn/vim-easy-align'
Plug 'lambdatoast/elm.vim', { 'for': 'elm' }
Plug 'ledger/vim-ledger', { 'for': 'ledger' }
Plug 'mk12/vim-lean', { 'for': 'lean' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

set rtp+=/usr/local/opt/fzf

" =========== General ==========================================================

set autochdir
set autoread
set cmdheight=2
set cursorline
set gdefault
set hidden
set ignorecase
set lazyredraw
set linebreak
set mouse=a
set mousefocus
set nojoinspaces
set nostartofline
set number
set ruler
set scrolloff=8
set shiftround
set shiftwidth=4
set showcmd
set showmode
set smartcase
set tabstop=4
set visualbell

" =========== Plugin settings ==================================================

let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

let g:easy_align_delimiters = {
	\ '/': {
		\ 'pattern': '//\+\|/\*\|\*/',
		\ 'delimiter_align': 'l',
		\ 'ignore_groups': ['!Comment']
	\ }
\ }

let g:fzf_tags_command = 'ctags -R'

let g:go_fmt_command = 'goimports'
let g:go_doc_keywordprg_enabled = 0

" =========== Mappings =========================================================

let mapleader = ' '
let maplocalleader = '\\'

inoremap jj <Esc>

noremap ; :
noremap : ;

noremap 0 ^
noremap ^ 0

nnoremap Y y$

vnoremap <silent> <expr> p <SID>VisualReplace()

nnoremap <silent> <Tab> :call NextBufOrTab()<CR>
nnoremap <silent> <S-Tab> :call PrevBufOrTab()<CR>

nnoremap J <C-d>
nnoremap K <C-u>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

nnoremap <Leader>/ :Ag<CR>
nnoremap <Leader>* :Ag <C-r><C-w><CR>
vnoremap <Leader>* y:Ag <C-r>"<CR>
nnoremap <Leader><Tab> :b#<CR>

nnoremap <Leader>bd :bdelete<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bp :bprevious<CR>
nnoremap <Leader>bK :%bdelete \| edit#<CR>

nnoremap <Leader>c :Commentary<CR>
vnoremap <Leader>c :Commentary<CR>

nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fed :edit $MYVIMRC<CR>
nnoremap <Leader>feR :source $MYVIMRC<CR>
nnoremap <Leader>fs :write<CR>
nnoremap <Leader>fS :wall<CR>

nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gh :GitGutterNextHunk<CR>
nnoremap <Leader>gl :Gpull<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gv :GV<CR>
nnoremap <Leader>gw :Gwrite<CR>

nnoremap <Leader>h :call ToggleSourceHeader()<CR>

nnoremap <Leader>l :nohlsearch<CR>

nnoremap <Leader>pb :Buffers<CR>
nnoremap <Leader>pc :Commits<CR>
nnoremap <Leader>pg :GFiles<CR>
nnoremap <Leader>pl :Lines<CR>
nnoremap <Leader>pm :Marks<CR>
nnoremap <Leader>pt :Tags<CR>

nnoremap <Leader>qs :wq<CR>
nnoremap <Leader>qq :quit<CR>

nnoremap <Leader>t8 :call EightyColumns()<CR>
nnoremap <Leader>tc :RainbowParentheses!!<CR>
nnoremap <Leader>tg :Goyo<CR>
nnoremap <Leader>tn :set number!<CR>
nnoremap <Leader>tp :set paste!<CR>
nnoremap <Leader>tr :set relativenumber!<CR>
nnoremap <Leader>ts :set spell!<CR>
nnoremap <Leader>tw :set list!<CR>

nnoremap <Leader>w- :split<CR>
nnoremap <Leader>w/ :vsplit<CR>
nnoremap <Leader>wH <C-w>H
nnoremap <Leader>wJ <C-w>J
nnoremap <Leader>wK <C-w>K
nnoremap <Leader>wL <C-w>L
nnoremap <Leader>wc :close<CR>
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wl <C-w>l

vnoremap <Leader>xa :EasyAlign<CR>
vnoremap <Leader>xs :sort<CR>

" =========== Colour ===========================================================

if !has("gui_running")
	let g:solarized_termtrans = 1
	let g:solarized_termcolors = 16
endif

syntax enable
set background=dark
colorscheme solarized

highlight clear NonText
highlight link NonText Comment

" =========== Lines ============================================================

set listchars=eol:¬,tab:».,trail:~,extends:>,precedes:<

function! EightyColumns()
	if &colorcolumn == "" || &colorcolumn == "0"
		setlocal textwidth=80 colorcolumn=+1
	else
		setlocal textwidth=0 colorcolumn=0
	endif
endfunction

augroup columns
	autocmd!
	autocmd BufWinEnter * call EightyColumns()
	autocmd FileType ledger setlocal textwidth=0 colorcolumn=61,81
augroup END

" =========== Special files ====================================================

silent !mkdir -p ~/.config/nvim/backup > /dev/null 2>&1
silent !mkdir -p ~/.config/nvim/tmp > /dev/null 2>&1
silent !mkdir -p ~/.config/nvim/spell > /dev/null 2>&1

set backup
set undofile
set directory=~/.config/nvim/tmp,~/.tmp,/var/tmp,/tmp
set backupdir=./.backup,~/.config/nvim/backup
set undodir=~/.config/nvim/backup
set spellfile=~/.config/nvim/spell/en.utf-8.add,en.utf-8.add

" =========== Navigation =======================================================

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
			echo "Can't find source file"
		endif
	elseif l:extension == "c" || l:extension == "cpp"
		if filereadable(expand("%:p:r") . ".h")
			execute "e " . expand("%:p:r") . ".h"
		elseif filereadable(expand("%:p:r") . ".hpp")
			execute "e " . expand("%:p:r") . ".hpp"
		else
			echo "Can't find header file"
		endif
	else
		echo "Not a source file or header file"
	end
endfunction

" =========== Registers ========================================================

function! RestoreRegister()
	let @" = s:restore_reg
	return ""
endfunction

function! s:VisualReplace()
	let s:restore_reg = @"
	return "p@=RestoreRegister()\<cr>"
endfunction
