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
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/vim-easy-align', { 'on': 'EasyAlign' }
Plug 'ledger/vim-ledger', { 'for': 'ledger' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'mk12/vim-lean', { 'for': 'lean' }
Plug 'mk12/vim-llvm', { 'for': 'llvm' }
Plug 'sheerun/vim-polyglot'
Plug 'sunaku/vim-shortcut', { 'on' : ['Shortcut', 'Shortcut!', 'Shortcuts'] }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession', { 'on': 'Obsess' }
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone', { 'on': ['Tyank', 'Tput'] }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

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

let g:fzf_colors = {
	\ 'fg+': ['fg', 'StatusLine'],
	\ 'bg+': ['bg', 'StatusLine'],
	\ 'header': ['fg', 'Constant']
\ }
let g:fzf_tags_command = 'ctags -R'

let g:gitgutter_map_keys = 0

let g:go_fmt_command = 'goimports'
let g:go_doc_keywordprg_enabled = 0

let g:lean_auto_replace = 1

let g:rooter_manual_only = 1

let g:solarized_termcolors = 16
let g:solarized_termtrans = 1

let g:undotree_SplitWidth = 35

" =========== Options ==========================================================

set backup
set backupdir-=.
set cmdheight=2
set cursorline
set gdefault
set hidden
set ignorecase
set lazyredraw
set linebreak
set listchars=eol:¬,tab:».,trail:~
set mousefocus
set nofoldenable
set nojoinspaces
set nostartofline
set number
set scrolloff=4
set shiftround
set shiftwidth=4
set showcmd
set showmode
set smartcase
set tabstop=4
set undofile
set visualbell

call assert_equal(-1, stridx(&backupdir, ','), 'multiple backup directories')
execute 'silent !mkdir -p ' . &backupdir . ' > /dev/null 2>&1'

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

nnoremap Q gqap
xnoremap Q gq

xnoremap <silent> <expr> p <SID>VisualReplace()

nnoremap <silent> <Tab> :call NextBufOrTab()<CR>
nnoremap <silent> <S-Tab> :call PrevBufOrTab()<CR>
inoremap <silent> <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

nnoremap J <C-d>
nnoremap K <C-u>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" https://github.com/neovim/neovim/issues/2048
nnoremap <BS> :<C-u>TmuxNavigateLeft<CR>

nmap ]c <Plug>GitGutterNextHunk
nmap [c <Plug>GitGutterPrevHunk

omap ic <Plug>GitGutterTextObjectInnerPending
omap ac <Plug>GitGutterTextObjectOuterPending
xmap ic <Plug>GitGutterTextObjectInnerVisual
xmap ac <Plug>GitGutterTextObjectOuterVisual

" =========== Shortcuts ========================================================

Shortcut open shortcut menu
	\ nnoremap <silent> <Leader>? :Shortcuts<CR>
	\|nnoremap <silent> <Leader> :Shortcuts<CR>

Shortcut go to file in project
	\ nnoremap <silent> <Leader><Leader> :call ProjectFiles()<CR>

Shortcut switch to last buffer
	\ nnoremap <Leader><Tab> :b#<CR>

Shortcut project-wide search
	\ nnoremap <Leader>/ :Ag<CR>
Shortcut project-wide search with input
	\ nnoremap <Leader>* :Ag <C-r><C-w><CR>
	\|xnoremap <Leader>* y:Ag <C-r>"<CR>

Shortcut toggle comment
	\ nnoremap <Leader>c :Commentary<CR>
	\|xnoremap <Leader>c :Commentary<CR>

Shortcut reindent lines
	\ nnoremap <Leader>di vip=
Shortcut align lines
	\ nnoremap <Leader>da vip:EasyAlign<CR>
	\|xnoremap <Leader>da :EasyAlign<CR>
Shortcut sort lines
	\ nnoremap <Leader>ds vip:sort<CR>
	\|xnoremap <Leader>ds :sort<CR>

Shortcut delete buffer
	\ nnoremap <Leader>ek :bdelete<CR>
Shortcut force delete buffer
	\ nnoremap <Leader>eK :bdelete!<CR>
Shortcut new buffer
	\ nnoremap <Leader>en :enew<CR>
Shortcut new tab
	\ nnoremap <Leader>et :tabnew<CR>
Shortcut reload current buffer
	\ nnoremap <Leader>er :edit!<CR>

Shortcut edit vimrc or init.vim
	\ nnoremap <Leader>ev :edit $MYVIMRC<CR>
Shortcut reload vimrc or init.vim
	\ nnoremap <Leader>eR :source $MYVIMRC<CR>

Shortcut cd to project root
	\ nnoremap <Leader>fr :Rooter<CR>:pwd<CR>
Shortcut cd to current file directory
	\ nnoremap <Leader>ff :cd %:h<CR>:pwd<CR>
Shortcut print working directory
	\ nnoremap <Leader>fp :pwd<CR>

Shortcut git blame
	\ nnoremap <Leader>gb :Gblame<CR>
Shortcut git commit
	\ nnoremap <Leader>gc :Gcommit<CR>
Shortcut git pull
	\ nnoremap <Leader>gl :Gpull<CR>
Shortcut git push
	\ nnoremap <Leader>gp :Gpush<CR>
Shortcut git status
	\ nnoremap <Leader>gs :Gstatus<CR>
Shortcut git write/add
	\ nnoremap <Leader>gw :Gwrite<CR>

Shortcut switch between header/source
	\ nnoremap <Leader>h :call ToggleSourceHeader()<CR>

Shortcut remove search highlight
	\ nnoremap <Leader>l :nohlsearch<CR>

Shortcut view buffers
	\ nnoremap <Leader>pb :Buffers<CR>
Shortcut view git commits
	\ nnoremap <Leader>pc :Commits<CR>
Shortcut view files
	\ nnoremap <Leader>pf :Files<CR>
Shortcut view git files
	\ nnoremap <Leader>pg :GFiles<CR>
Shortcut view help tags
	\ nnoremap <Leader>ph :Helptags<CR>
Shortcut view all lines
	\ nnoremap <Leader>pl :Lines<CR>
Shortcut view marks
	\ nnoremap <Leader>pm :Marks<CR>
Shortcut view tags
	\ nnoremap <Leader>pt :Tags<CR>

Shortcut quit
	\ nnoremap <Leader>q :quit<CR>
Shortcut force quit
	\ nnoremap <Leader>Q :quit!<CR>

Shortcut save/write file
	\ nnoremap <Leader>s :write<CR>
Shortcut force save/write file
	\ nnoremap <Leader>S :write!<CR>

Shortcut toggle 80-column marker
	\ nnoremap <Leader>t8 :call EightyColumns()<CR>
Shortcut toggle auto-pairs
	\ nnoremap <Leader>ta :call AutoPairsToggle()<CR>
Shortcut toggle or fix dark/light background
	\ nnoremap <Leader>tb :call ToggleBackground()<CR>
Shortcut toggle Goyo mode
	\ nnoremap <Leader>tg :Goyo<CR>
Shortcut toggle git line highlight
	\ nnoremap <Leader>th :GitGutterLineHighlightsToggle<CR>
Shortcut toggle line numbers
	\ nnoremap <Leader>tn :set number!<CR>
Shortcut toggle session tracking
	\ nnoremap <Leader>to :Obsess!<CR>
Shortcut toggle paste mode
	\ nnoremap <Leader>tp :set paste!<CR>
Shortcut toggle relative line numbers
	\ nnoremap <Leader>tr :set relativenumber!<CR>
Shortcut toggle spell checker
	\ nnoremap <Leader>ts :set spell!<CR>
Shortcut toggle undo tree
	\ nnoremap <Leader>tu :UndotreeToggle<CR>
Shortcut toggle list/whitespace mode
	\ nnoremap <Leader>tw :set list!<CR>

Shortcut new horizontal split
	\ nnoremap <Leader>w- :split<CR>
Shortcut new vertical split
	\ nnoremap <Leader>w/ :vsplit<CR>
Shortcut move window left
	\ nnoremap <Leader>wH <C-w>H
Shortcut move window down
	\ nnoremap <Leader>wJ <C-w>J
Shortcut move window up
	\ nnoremap <Leader>wK <C-w>K
Shortcut move window right
	\ nnoremap <Leader>wL <C-w>L
Shortcut go to left window
	\ nnoremap <Leader>wh <C-w>h
Shortcut go to down window
	\ nnoremap <Leader>wj <C-w>j
Shortcut go to up window
	\ nnoremap <Leader>wk <C-w>k
Shortcut go to right window
	\ nnoremap <Leader>wl <C-w>l
Shortcut resize windows equally
	\ nnoremap <Leader>w= <C-w>=

" =========== Autocommands =====================================================

augroup comments
	autocmd!
	autocmd FileType c,cpp setlocal commentstring=//\ %s
	autocmd FileType sql setlocal commentstring=--\ %s
augroup END

augroup columns
	autocmd!
	autocmd BufRead * call EightyColumns(1)
	autocmd FileType ledger setlocal textwidth=0 colorcolumn=61,81
augroup END

augroup colors
	autocmd!
	autocmd ColorScheme * call FixColorScheme()
augroup END

" =========== Functions ========================================================

function! s:VisualReplace()
	let s:restore_reg = @"
	return "p@=RestoreRegister()\<CR>"
endfunction

function! RestoreRegister()
	let @" = s:restore_reg
	return ''
endfunction

function! NextBufOrTab()
	if tabpagenr('$') > 1
		tabnext
	else
		bnext
	endif
endfunction

function! PrevBufOrTab()
	if tabpagenr('$') > 1
		tabprev
	else
		bprev
	endif
endfunction

function! ProjectFiles()
	if !empty(glob('.git'))
		GitFiles
	else
		Files
	endif
endfunction

function! ToggleSourceHeader()
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

function! EightyColumns(...)
	if a:0 > 0 || &colorcolumn == '' || &colorcolumn == '0'
		setlocal textwidth=80 colorcolumn=+1
	else
		setlocal textwidth=0 colorcolumn=0
	endif
endfunction

function! s:CurrentBackground()
	return empty(glob('~/.solarized_light')) ? 'dark' : 'light'
endfunction

function! ToggleBackground()
	if &background == s:CurrentBackground()
		silent !darklight.sh
	endif
	let &background = s:CurrentBackground()
endfunction

function! FixColorScheme()
	highlight clear NonText
	highlight link NonText Comment

	highlight clear Visual
	execute 'highlight Visual ctermbg=' . (&background == 'light' ? 0 : 7)
endfunction

" =========== Color scheme =====================================================

let &background = s:CurrentBackground()
syntax enable
colorscheme solarized
