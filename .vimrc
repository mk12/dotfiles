" Disable Vi compatibility (must come first).
set nocompatible

" ---------------- Bundles ------------------------------------------------ {{{1

" This is required for Vundle to work.
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" General
Bundle 'repeat.vim'
Bundle 'surround.vim'
Bundle 'file-line'
Bundle 'tComment'
Bundle 'Engspchk'
Bundle 'Raimondi/YAIFA'
Bundle 'UltiSnips'
Bundle 'ervandew/supertab'

" Language-specific
Bundle 'tex_autoclose.vim'
Bundle 'jnwhiteh/vim-golang'
Bundle 'mk12/vim-pandoc'

" Colour schemes
Bundle 'altercation/vim-colors-solarized'
Bundle 'mk12/vim-iawriter'

filetype plugin indent on

" ---------------- General ------------------------------------------------ {{{1

set number                      " line numbers are good
set numberwidth=3               " most files are in the hundreds
set backspace=indent,eol,start  " allow backspace in insert mode
set undolevels=100              " store lots of undo history
set history=1000                " store lots of :cmdline history
set showcmd                     " show incomplete commands down the bottom
set showmode                    " show current mode down the bottom
set cmdheight=2                 " show extra stuff
set noerrorbells                " bells are annoying
set visualbell t_vb=            " no sounds
set autoread                    " reload files changed outside Vim
set viminfo='100,%,f1           " save marks, buffer
set enc=utf-8                   " UTF-8 is the best
set guioptions-=r               " remove scrollbar
set mousefocus                  " let the mouse control splits
set autochdir                   " cd to the file's directory
set wildmenu                    " enhanced command-line completion
set lazyredraw                  " don't redraw while executing macros
set hidden                      " allow buffers in the background

" ---------------- Shortcuts ---------------------------------------------- {{{1

" It's easier to reach than the backslash (default leader).
let mapleader = ","

" Remap ; to : so that you don't have to press shift for commands.
noremap ; :
noremap : ;

" We'll never need to input 'jj'.
inoremap jj <Esc>

" Backtick is more useful than apostrophe (goes to row AND column of mark).
nnoremap ' `
nnoremap ` '

" Make Y behave like other capitals.
nnoremap  Y y$

" Make navigation easier.
nnoremap <Space> <C-f>
nnoremap <S-space> <C-b>
nnoremap J <C-d>
nnoremap K <C-u>
nnoremap j gj
nnoremap k gk

" These actions need quick access.
nnoremap <silent> <leader>w :w<cr>
nnoremap <silent> <leader>c :silent :nohlsearch<cr>
nnoremap <silent> <leader>l :setlocal list!<cr>
nnoremap <silent> <leader>f :call ToggleFoldMethod()<cr>
nnoremap <silent> <leader>m :call ToggleWritingFS()<cr>
nnoremap <silent> <leader>s :call ToggleSpellchecker()<cr>

" This requires the tComment bundle.
nmap <leader>/ gcc
vmap <leader>/ gc

" Thou shalt not cross 80 columns in thy file.
nnoremap <leader>7 :setlocal textwidth=0 colorcolumn=0<cr>
nnoremap <leader>8 :setlocal textwidth=80 colorcolumn=81<cr>

" CTRL-U in insert mode deletes a lot.	Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" ---------------- Theme -------------------------------------------------- {{{1

syntax enable
colorscheme solarized

" Make invisible characters less obtrusive.
highligh clear NonText
highlight link NonText Comment

" This affects HTML and Markdown.
function! HighlightHTML()
	highlight htmlItalic gui=italic
	highlight htmlBold gui=bold
endfunction

" For some reason it doesn't work unless I use a function + autocmd.
autocmd VimEnter * call HighlightHTML()

if has("gui_running")
	autocmd Filetype markdown call WritingMode()
endif

" ---------------- Writing ------------------------------------------------ {{{1

function! WritingMode()
	colorscheme iawriter
	syntax enable
	setlocal guifont=Cousine:h14
	setlocal linespace=5
	setlocal noruler
endfunction

" Toggle full screen mode for writing.
function! ToggleWritingFS()
	if &fullscreen == 1
		if exists("s_prev_background")
			exec "set background=" . s:prev_background
			exec "set lines=" . s:prev_lines
			exec "set columns=" . s:prev_columns
			exec "set laststatus=" . s:prev_laststatus
			exec "set fuoptions=" . s:prev_fuoptions
		endif
		set nofullscreen
		redraw!
	else
		let s:prev_background = &background
		let s:prev_lines = &lines
		let s:prev_columns = &columns
		let s:prev_laststatus = &laststatus
		let s:prev_fuoptions = &fuoptions

		set lines=40 columns=100
		set laststatus=0
		set fuoptions=background:#00f5f6f6
		set fullscreen
	endif
endfunction

" ---------------- Lines -------------------------------------------------- {{{1

set wrap              " do soft wrapping
set textwidth=0       " no hard wrapping by default
set wrapmargin=0      " don't hard wrap based on terminal width
set linebreak         " wrap at spaces, not in the middle of words
set display=lastline  " show part of really long lines (not @s)
set nojoinspaces      " one space after period in join command
set scrolloff=8       " start scrolling when 8 lines away from margins

" Modify characters used for ":set list".
set listchars=eol:¬,tab:».,trail:~,extends:>,precedes:<

" ---------------- Indentation -------------------------------------------- {{{1

" These are defaults for new files. For existing files, YAIFA will detect
" indentation settings. (YAIFA uses the value of shiftwidth here, though.)
set noexpandtab    " tabs for indentation, spaces for alignment
set autoindent     " stay indented on new line
set smarttab       " <tab> adds shiftwidth spaces
set shiftwidth=4   " indentation width (>>, <<)
set tabstop=4      " eight spaces is too many
set softtabstop=4  " make sure this is the same
set shiftround     " round indents to multiples of shiftwidth

" Use custom indentation for specific file types (YAIFA stills overrides here).
autocmd Filetype objc,objcpp,ruby,python,haskell,scheme setlocal et
autocmd Filetype ruby,scheme setlocal sw=2

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

" Hitting tab is easier than the using the default triggers.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" ---------------- Search ------------------------------------------------- {{{1

set incsearch   " find the next match as we type the search
set hlsearch    " highlight searches by default
set ignorecase  " ignore case by default
set smartcase   " don't ignore case if the search contains uppercase characters
set gdefault    " /g : all occurrences in the line

" ---------------- Spelling ----------------------------------------------- {{{1

let g:spchkdialect = "can"  " use Canadian English
let g:spchkacronym = 1      " acronyms are not errors

" This function toggles Engspchk and links the highlighting groups it uses to
" the proper ones after enabling it. Also, if the file's type is Markdown, it
" will temporarily clear filetype to avoid conflicting highlighting.
let s:SpellcheckerOn = 0
let s:WasMarkdown = 0
function! ToggleSpellchecker()
	if s:SpellcheckerOn == 0
		if &filetype == "markdown"
			let s:WasMarkdown = 1
			set filetype=
		endif
		exec "normal " . g:mapleader . "ec"
		let s:SpellcheckerOn = 1
		highlight link BadWord SpellBad
		highlight link Dialect SpellLocal
		highlight link RareWord SpellRare
	else
		if s:WasMarkdown == 1
			set filetype=markdown
		endif
		exec "normal " . g:mapleader . "ee"
		let s:SpellcheckerOn = 0
	endif
endfunction

" ---------------- Cursor position ---------------------------------------- {{{1

set ruler          " display row & column in status bar
set cursorline     " highlight current line
set nostartofline  " don't return to start of line after page down

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

" ---------------- Special files ------------------------------------------ {{{1

" Create these directories is they don't already exist.
silent !mkdir -p ~/.vim/backup > /dev/null 2>&1
silent !mkdir -p ~/.vim/tmp > /dev/null 2>&1

" Don't clutter the working directory with swap files or backups.
set directory=~/.vim/tmp,~/.tmp,/var/tmp,/tmp
set backupdir=./.backup,~/.vim/backup
set undodir=~/.vim/backup
set backup
set undofile

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

autocmd BufRead * call DisableViminfo()
