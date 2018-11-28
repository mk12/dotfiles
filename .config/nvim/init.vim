set shell=sh

" =========== Plugins ==========================================================

if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter', { 'on': 'Rooter' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'jiangmiao/auto-pairs'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/vim-easy-align', { 'on': 'EasyAlign' }
Plug 'ledger/vim-ledger', { 'for': 'ledger' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'sheerun/vim-polyglot'
Plug 'sunaku/vim-shortcut', { 'on' : ['Shortcut', 'Shortcut!', 'Shortcuts'] }
Plug 'tpope/vim-commentary', { 'on': 'Commentary' }
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" =========== Plugin settings ==================================================

let g:airline#extensions#default#layout = [['a', 'c'], ['x', 'y' ]]
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_extensions = ['tabline']
let g:airline_highlighting_cache = 1
let g:airline_theme = 'onedark'

let g:AutoPairsMultilineClose = 0
let g:AutoPairsShortcutToggle = ''

let g:easy_align_delimiters = {
	\ '/': {
		\ 'pattern': '//\+\|/\*\|\*/',
		\ 'delimiter_align': 'l',
		\ 'ignore_groups': ['!Comment']
	\ }
\ }

let g:gitgutter_map_keys = 0

let g:rooter_manual_only = 1

let g:undotree_SplitWidth = 35

" =========== Options ==========================================================

set backup
set cmdheight=2
set colorcolumn=+1
set cursorline
set gdefault
set hidden
set ignorecase
set lazyredraw
set linebreak
set listchars=eol:¬,tab:».,trail:~
set mouse=a
set mousefocus
set nofoldenable
set nojoinspaces
set noshowmode
set nostartofline
set number
set scrolloff=4
set shiftround
set shiftwidth=4
set showcmd
set smartcase
set tabstop=4
set textwidth=80
set undofile
set visualbell

let &backupdir = $HOME . '/.local/share/nvim/backup'
call mkdir(&backupdir, 'p')

" =========== Mappings =========================================================

nnoremap <Space> <Nop>

let mapleader = "\<Space>"
let maplocalleader = '\'

inoremap jk <Esc>
inoremap kj <Esc>

noremap ; :
noremap : ;

nnoremap Y y$

xnoremap > >gv
xnoremap < <gv

nnoremap Q gqap
xnoremap Q gq

xnoremap <silent> <expr> p <SID>VisualReplace()

nnoremap <silent> <Tab> :call NextBufOrTab()<CR>
nnoremap <silent> <S-Tab> :call PrevBufOrTab()<CR>

nmap ]c <Plug>GitGutterNextHunk
nmap [c <Plug>GitGutterPrevHunk

omap ic <Plug>GitGutterTextObjectInnerPending
omap ac <Plug>GitGutterTextObjectOuterPending
xmap ic <Plug>GitGutterTextObjectInnerVisual
xmap ac <Plug>GitGutterTextObjectOuterVisual

" =========== Shortcuts ========================================================

" Mnemonics:
" C - comment
" D - do
" E - edit
" F - folder
" G - git
" H - header
" P - pick
" Q - quit
" S - save
" T - toggle
" W - window
" X - exit

Shortcut open shortcut menu
	\ nnoremap <silent> <Leader>? :Shortcuts<CR>
	\|nnoremap <silent> <Leader> :Shortcuts<CR>

Shortcut go to file in project
	\ nnoremap <silent> <Leader><Leader> :call ProjectFiles()<CR>

Shortcut switch to last buffer
	\ nnoremap <Leader><Tab> :b#<CR>

Shortcut project-wide search
	\ nnoremap <Leader>/ :Rg<CR>
Shortcut project-wide search with input
	\ nnoremap <Leader>* :Rg <C-r><C-w><CR>
	\|xnoremap <Leader>* y:Rg <C-r>"<CR>

Shortcut auto-format
	\ nnoremap <Leader>a :w<BAR>silent !clang-format -i %<CR>:e<CR>

Shortcut toggle comment
	\ nnoremap <Leader>c :Commentary<CR>
	\|xnoremap <Leader>c :Commentary<CR>

Shortcut align lines
	\ nnoremap <Leader>da vip:EasyAlign<CR>
	\|xnoremap <Leader>da :EasyAlign<CR>
Shortcut indent lines
	\ nnoremap <Leader>di vip=
	\|xnoremap <Leader>di =
Shortcut show number of search matches
	\ nnoremap <Leader>dm :%s/<C-r>///n<CR>
	\|xnoremap <Leader>dm y:/%s/<C-r>///n<CR>
Shortcut sort lines
	\ nnoremap <Leader>ds vip:sort<CR>
	\|xnoremap <Leader>ds :sort<CR>
Shortcut remove trailing whitespace
	\ nnoremap <Leader>dw :%s/\s\+$//e<CR>''
	\|xnoremap <Leader>dw :s/\s\+$//e<CR>
Shortcut yank to system clipboard
	\ nnoremap <Leader>dy :%y*<BAR>call YankToSystemClipboard(@*)<CR>
	\|xnoremap <Leader>dy "*y:call YankToSystemClipboard(@*)<CR>

Shortcut edit fish config
	\ nnoremap <Leader>ef :edit ~/.config/fish/config.fish<CR>
Shortcut edit journal file
	\ nnoremap <Leader>ej :edit ~/ia/Journal/Journal.txt<CR>
Shortcut delete buffer
	\ nnoremap <Leader>ek :bdelete<CR>
Shortcut force delete buffer
	\ nnoremap <Leader>eK :bdelete!<CR>
Shortcut new buffer
	\ nnoremap <Leader>en :enew<CR>
Shortcut new tab
	\ nnoremap <Leader>et :tabnew<CR>
Shortcut reload vimrc or init.vim
	\ nnoremap <Leader>eR :source $MYVIMRC<CR>
Shortcut reload current buffer
	\ nnoremap <Leader>er :edit!<CR>
Shortcut edit vimrc or init.vim
	\ nnoremap <Leader>ev :edit $MYVIMRC<CR>

Shortcut cd to current file directory
	\ nnoremap <Leader>ff :cd %:h<CR>:pwd<CR>
Shortcut print working directory
	\ nnoremap <Leader>fp :pwd<CR>
Shortcut cd to project root
	\ nnoremap <Leader>fr :Rooter<CR>:pwd<CR>

Shortcut git blame
	\ nnoremap <Leader>gb :Gblame<CR>
Shortcut git commit
	\ nnoremap <Leader>gc :Gcommit<CR>
Shortcut git diff
	\ nnoremap <Leader>gd :Gdiff<CR>
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

Shortcut view buffers
	\ nnoremap <Leader>pb :Buffers<CR>
Shortcut view buffers (full screen)
	\ nnoremap <Leader>pB :Buffers!<CR>
Shortcut view git commits
	\ nnoremap <Leader>pc :Commits<CR>
Shortcut view git commits (full screen)
	\ nnoremap <Leader>pC :Commits!<CR>
Shortcut view files
	\ nnoremap <Leader>pf :Files<CR>
Shortcut view files (full screen)
	\ nnoremap <Leader>pF :Files!<CR>
Shortcut view git files
	\ nnoremap <Leader>pg :GFiles<CR>
Shortcut view git files (full screen)
	\ nnoremap <Leader>pG :GFiles!<CR>
Shortcut view help tags
	\ nnoremap <Leader>ph :Helptags<CR>
Shortcut view help tags (full screen)
	\ nnoremap <Leader>pH :Helptags!<CR>
Shortcut view all lines
	\ nnoremap <Leader>pl :Lines<CR>
Shortcut view all lines (full screen)
	\ nnoremap <Leader>pL :Lines!<CR>
Shortcut view marks
	\ nnoremap <Leader>pm :Marks<CR>
Shortcut view marks (full screen)
	\ nnoremap <Leader>pM :Marks!<CR>
Shortcut view search results
	\ nnoremap <Leader>ps :Rg<CR>
Shortcut view search results (full screen)
	\ nnoremap <Leader>pS :Rg!<CR>
Shortcut view tags
	\ nnoremap <Leader>pt :Tags<CR>
Shortcut view tags (full screen)
	\ nnoremap <Leader>pT :Tags!<CR>

Shortcut force quit
	\ nnoremap <Leader>Q :quit!<CR>
Shortcut quit
	\ nnoremap <Leader>q :quit<CR>

Shortcut force save/write file
	\ nnoremap <Leader>S :write!<CR>
Shortcut save/write file
	\ nnoremap <Leader>s :write<CR>

Shortcut toggle 80-column marker
	\ nnoremap <Leader>t8 :call EightyColumns()<CR>
Shortcut toggle auto-pairs
	\ nnoremap <Leader>ta :call AutoPairsToggle()<CR>
Shortcut toggle Goyo mode
	\ nnoremap <Leader>tg :Goyo<CR>
Shortcut toggle highlight last search
	\ nnoremap <Leader>th
		\ :if v:hlsearch<BAR>noh<BAR>else<BAR>set hls<BAR>endif<CR>
Shortcut toggle git line highlight
	\ nnoremap <Leader>tl :GitGutterLineHighlightsToggle<CR>
Shortcut toggle line numbers
	\ nnoremap <Leader>tn :set number!<CR>
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

Shortcut save/write and exit
	\ nnoremap <Leader>x :exit<CR>

" =========== Autocommands =====================================================

augroup custom
	autocmd!

	autocmd FileType c,cpp setlocal commentstring=//\ %s
	autocmd FileType sql setlocal commentstring=--\ %s

	autocmd FileType markdown setlocal textwidth=0 colorcolumn=0
	autocmd FileType ledger setlocal textwidth=0 colorcolumn=61,81

	" By default GitGutter waits for &updatetime ms before updating.
	autocmd BufWritePost * GitGutter
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
	let l:header_extensions = ['h', 'hpp', 'hh']
	let l:source_extensions = ['c', 'cpp', 'cc']
	if index(l:header_extensions, l:extension) >= 0
		for l:c in l:source_extensions
			let l:file = expand('%:p:r') . '.' . l:c
			if filereadable(l:file)
				execute 'e ' . l:file
				return
			endif
		endfor
		echo "Can't find source file"
	elseif index(l:source_extensions, l:extension) >= 0
		for l:h in l:header_extensions
			let l:file = expand('%:p:r') . '.' . l:h
			if filereadable(l:file)
				execute 'e ' . l:file
				return
			endif
		endfor
		echo "Can't find header file"
	else
		echo "Not a source file or header file"
	endif
endfunction

function! EightyColumns(...)
	let l:on = a:0 > 0 ? a:1 : (&colorcolumn == '' || &colorcolumn == '0')
	if l:on
		setlocal textwidth=80 colorcolumn=+1
	else
		setlocal textwidth=0 colorcolumn=0
	endif
endfunction

" https://sunaku.github.io/tmux-yank-osc52.html
function! YankToSystemClipboard(text)
	let l:escape = system('yank', a:text)
	if v:shell_error
		echoerr l:escape
	else
		call writefile([l:escape], '/dev/tty', 'b')
	endif
endfunction

" =========== Color scheme =====================================================

set termguicolors
set background=dark
syntax enable
colorscheme onedark
