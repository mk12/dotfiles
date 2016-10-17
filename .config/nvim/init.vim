" =========== Plugins ==========================================================

if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin()

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter', { 'on': 'Rooter' }
Plug 'altercation/vim-colors-solarized'
Plug 'christoomey/vim-tmux-navigator'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'gabesoft/vim-ags', { 'on': 'Ags' }
Plug 'glts/vim-textobj-comment'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/vim-easy-align', { 'on': 'EasyAlign' }
Plug 'kana/vim-textobj-user'
Plug 'ledger/vim-ledger', { 'for': 'ledger' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'mk12/vim-lean', { 'for': 'lean' }
Plug 'mk12/vim-llvm', { 'for': 'llvm' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone', { 'on': ['Tyank', 'Tput'] }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" =========== General ==========================================================

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
set nofoldenable
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

let g:deoplete#enable_at_startup = 1

let g:easy_align_delimiters = {
	\ '/': {
		\ 'pattern': '//\+\|/\*\|\*/',
		\ 'delimiter_align': 'l',
		\ 'ignore_groups': ['!Comment']
	\ }
\ }

let g:fzf_tags_command = 'ctags -R'

let g:gitgutter_map_keys = 0

let g:go_fmt_command = 'goimports'
let g:go_doc_keywordprg_enabled = 0

let g:lean_auto_replace = 1

let g:rooter_manual_only = 1

let g:undotree_SplitWidth = 35

" =========== Mappings =========================================================

nnoremap <Space> <Nop>

let mapleader = "\<Space>"
let maplocalleader = '\'

inoremap jk <Esc>
inoremap kj <Esc>

noremap ; :
noremap : ;

noremap 0 ^
noremap ^ 0

nnoremap Y y$

nmap Q gqap
xmap Q gq

xnoremap <silent> <expr> p <SID>VisualReplace()

nnoremap <silent> <Tab> :call <SID>NextBufOrTab()<CR>
nnoremap <silent> <S-Tab> :call <SID>PrevBufOrTab()<CR>
inoremap <silent> <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

nnoremap J <C-d>
nnoremap K <C-u>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" https://github.com/neovim/neovim/issues/2048
nnoremap <BS> :<C-u>TmuxNavigateLeft<CR>

nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
xmap ah <Plug>GitGutterTextObjectOuterVisual

nnoremap <Leader>/ :Ag<CR>
nnoremap <Leader>* :Ag <C-r><C-w><CR>
xnoremap <Leader>* y:Ag <C-r>"<CR>
nnoremap <Leader><Tab> :b#<CR>
nnoremap <silent> <Leader><Leader> :call <SID>ProjectFiles()<CR>

nnoremap <Leader>c :Commentary<CR>
xnoremap <Leader>c :Commentary<CR>

nnoremap <Leader>di vip=
nnoremap <Leader>ds vip:sort<CR>
xnoremap <Leader>da :EasyAlign<CR>
xnoremap <Leader>ds :sort<CR>

nnoremap <Leader>ek :bdelete<CR>
nnoremap <Leader>en :enew<CR>
nnoremap <Leader>et :tabnew<CR>
nnoremap <Leader>ev :edit $MYVIMRC<CR>
nnoremap <Leader>er :edit!<CR>
nnoremap <Leader>eR :source $MYVIMRC<CR>

nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gl :Gpull<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gw :Gwrite<CR>

nnoremap <Leader>h :call <SID>ToggleSourceHeader()<CR>

nnoremap <Leader>l :nohlsearch<CR>

nnoremap <Leader>pb :Buffers<CR>
nnoremap <Leader>pc :Commits<CR>
nnoremap <Leader>pf :Files<CR>
nnoremap <Leader>pg :GFiles<CR>
nnoremap <Leader>ph :Helptags<CR>
nnoremap <Leader>pl :Lines<CR>
nnoremap <Leader>pm :Marks<CR>
nnoremap <Leader>pt :Tags<CR>

nnoremap <Leader>q :quit<CR>
nnoremap <Leader>Q :quit!<CR>

nnoremap <Leader>s :write<CR>
nnoremap <Leader>S :write!<CR>

nnoremap <Leader>t8 :call EightyColumns()<CR>
nnoremap <Leader>tg :Goyo<CR>
nnoremap <Leader>th :GitGutterLineHighlightsToggle<CR>
nnoremap <Leader>tn :set number!<CR>
nnoremap <Leader>tp :set paste!<CR>
nnoremap <Leader>tr :set relativenumber!<CR>
nnoremap <Leader>ts :set spell!<CR>
nnoremap <Leader>tu :UndotreeToggle<CR>
nnoremap <Leader>tw :set list!<CR>

nnoremap <Leader>w- :split<CR>
nnoremap <Leader>w/ :vsplit<CR>
nnoremap <Leader>wH <C-w>H
nnoremap <Leader>wJ <C-w>J
nnoremap <Leader>wK <C-w>K
nnoremap <Leader>wL <C-w>L
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wl <C-w>l

" =========== Colour ===========================================================

let g:solarized_termtrans = 1
let g:solarized_termcolors = 16

syntax enable
set background=dark
colorscheme solarized

highlight clear NonText
highlight link NonText Comment

" =========== Lines ============================================================

set listchars=eol:¬,tab:».,trail:~,extends:>,precedes:<

function! EightyColumns(...)
	if a:0 > 0 || &colorcolumn == '' || &colorcolumn == '0'
		setlocal textwidth=80 colorcolumn=+1
	else
		setlocal textwidth=0 colorcolumn=0
	endif
endfunction

augroup columns
	autocmd!
	autocmd BufRead * call EightyColumns(1)
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

" =========== Functions ========================================================

function! s:NextBufOrTab()
	if tabpagenr('$') > 1
		tabnext
	else
		bnext
	endif
endfunction

function! s:PrevBufOrTab()
	if tabpagenr('$') > 1
		tabprev
	else
		bprev
	endif
endfunction

function! s:ProjectFiles()
	if exists('b:git_dir')
		GitFiles
	else
		Files
	endif
endfunction

function! s:ToggleSourceHeader()
	let l:extension = expand('%:e')
	if l:extension == 'h' || l:extension == 'hpp'
		echo expand('%:p:r.cpp')
		if filereadable(expand('%:p:r') . '.c')
			execute 'e ' . expand('%:p:r') . '.c'
		elseif filereadable(expand('%:p:r') . '.cpp')
			execute 'e ' . expand('%:p:r') . '.cpp'
		else
			echo "Can't find source file"
		endif
	elseif l:extension == 'c' || l:extension == 'cpp'
		if filereadable(expand('%:p:r') . '.h')
			execute 'e ' . expand('%:p:r') . '.h'
		elseif filereadable(expand('%:p:r') . '.hpp')
			execute 'e ' . expand('%:p:r') . '.hpp'
		else
			echo "Can't find header file"
		endif
	else
		echo "Not a source file or header file"
	endif
endfunction

function! RestoreRegister()
	let @" = s:restore_reg
	return ''
endfunction

function! s:VisualReplace()
	let s:restore_reg = @"
	return "p@=RestoreRegister()\<CR>"
endfunction
