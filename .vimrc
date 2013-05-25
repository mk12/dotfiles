" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" ==================== General Config ==================== {{{1

set number                      " Line numbers are good
set numberwidth=3               " Most files are in the hundreds
set backspace=indent,eol,start  " Allow backspace in insert mode
set history=1000                " Store lots of :cmdline history
set showcmd                     " Show incomplete cmds down the bottom
set showmode                    " Show current mode down the bottom
set cmdheight=2                 " Show extra stuff
set noerrorbells                " Bells are annoying
set visualbell t_vb=            " No sounds
set autoread                    " Reload files changed outside vim
set viminfo='100,%,f1           " Save marks, buffer
set enc=utf-8                   " UTF-8 is the best
set autochdir                   " Auto cd to the file's directory

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" It's easier to reach than backslash (default)
let mapleader = ","

" ==================== Vundle ==================== {{{1

" Required for Vundle to work
filetype on | filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'repeat.vim'
Bundle 'surround.vim'
Bundle 'file-line'
Bundle 'tComment'
Bundle 'Rip-Rip/clang_complete'
Bundle 'altercation/vim-colors-solarized'
Bundle 'Raimondi/YAIFA'
Bundle 'thinca/vim-ft-markdown_fold'
Bundle 'tex_autoclose.vim'

" My bundles
Bundle 'mk12/openssl.vim'
Bundle 'mk12/tex-pdf'

" ==================== File Type ==================== {{{1

filetype plugin indent on

autocmd BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}
    \ setlocal filetype=markdown fdm=expr
autocmd BufRead,BufNewFile *.json setlocal filetype=javascript
autocmd BufRead,BufNewFile *.less setlocal filetype=css

let pascal_fpc=1

" Quickly enable markdown syntax highlighting
nnoremap <leader>d :setlocal filetype=markdown<cr> :setlocal fdm=expr<cr>

" ==================== Colorscheme / Syntax ==================== {{{1

syntax enable
set background=light
colorscheme solarized

" Make invisible characters less obtrusive when using ":set list"
highlight link Visual Comment

let g:tex_conceal="adgm"
set concealcursor="c"
set conceallevel=2

" ==================== Nice Shortcuts ==================== {{{1

" Remap ; to : so that you don't have to press shift for commands
noremap ; :
noremap : ;

" We'll never need to input 'jj'
imap jj <Esc>

" Backtick is more useful than apostrophe (goes to row AND column) of mark
nnoremap ' `
nnoremap ` '

" Save as sudo using ":w!!"
cnoreabbrev <expr> w!!
    \((getcmdtype() == ':' && getcmdline() == 'w!!')
    \?('!sudo tee % >/dev/null'):('w!!'))

" ==================== Abbreviations ==================== {{{1

" LaTeX
autocmd Filetype tex ab ... \dots | ab Mr. Mr.~ | ab Mrs. Mrs.~ | ab Ms. Ms.~ | ab Dr. Dr.~

" ==================== Navigation ==================== {{{1

" The second one doesn't work
nnoremap <Space> <C-f>
nnoremap <S-space> <C-b>

" Go down wrapped lines one visual line at a time
nnoremap <leader>w :nnoremap j gj<cr> :nnoremap k gk<cr>

" Half page scanning
nnoremap J <C-d>
nnoremap K <C-u>

" ==================== Cursor Position ==================== {{{1

set ruler          " Display row & column in status bar
set cursorline     " Highlight current line
set nostartofline  " Don't return to start of line after page down

" Go back to same cursor position
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

" ==================== Spelling ==================== {{{1

if v:version >= 700
    setlocal spell spelllang=en
    set nospell
endif

" ==================== Search ==================== {{{1

set incsearch   " Find the next match as we type the search
set hlsearch    " Hilight searches by default
set ignorecase  " Ignore case by default
set smartcase   " Don't ignore case if the search contains uppercase characters
set gdefault    " /g : all occurences in the line

" ==================== Backups ==================== {{{1

silent !mkdir -p ~/.vim/backup > /dev/null 2>&1
silent !mkdir -p ~/.vim/tmp > /dev/null 2>&1

set backup
set backupdir=./.backup,~/.vim/backup
set directory=~/.vim/tmp,~/.tmp,/var/tmp,/tmp

" ==================== Undo ==================== {{{1

set undolevels=100

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Keep undo history across sessions, by storing in file.
set undodir=~/.vim/backup
set undofile

" ==================== Indentation ==================== {{{1

" These are defaults for new files. For existing files, YAIFA will detect
" indentation settings. (YAIFA uses the value of shiftwidth here, though)
set autoindent     " Stay indented on new line
set smarttab       " <Tab> adds shiftwidth spaces
set shiftwidth=4   " Indentation width (>>, <<)
set tabstop=4      " Real tabs are four spaces
set softtabstop=4  " Make sure this is the same
set shiftround     " Round indents to multiples of shiftwidth

" Custom indentation for specific filetypes (YAIFA stills overrides here)
autocmd Filetype c,objc,cpp,objcpp,ruby,python,haskell,scheme,vim,sh setlocal et
autocmd Filetype ruby setlocal sw=2

" ==================== Mouse ==================== {{{1

if has('gui_running')
    set mousefocus  " Mouse can control splits
endif

if has('mouse')
    set mouse=a
endif

" ==================== Folds ==================== {{{1

set foldmethod=syntax  " Fold based on indent
set foldnestmax=3      " Deepest fold is 3 levels
set nofoldenable       " Dont fold by default

let g:FoldMethod=0
function! ToggleFoldMethod()
    if g:FoldMethod == 0
        exe 'set foldmethod=indent'
        echo 'foldmethod: indent'
        let g:FoldMethod=1
    elseif g:FoldMethod == 1
        exe 'set foldmethod=marker'
        echo 'foldmethod: marker'
        let g:FoldMethod=2
    elseif g:FoldMethod == 2
        exe 'set foldmethod=syntax'
        echo 'foldmethod: syntax'
        let g:FoldMethod=0
    endif
endfunction

" Easily switch between fold methods
nnoremap <leader>f :call ToggleFoldMethod()<cr>

" ==================== Lines / Wrapping ==================== {{{1

set wrap              " Do soft wrapping
set textwidth=0       " No hard wrapping by default
set wrapmargin=0      " Don't hard wrap based on terminal width
set linebreak         " Wrap at spaces, not in the middle of words
set display=lastline  " Show part of really long lines (not @s)

" Modify characters used for ":set list"
set listchars=eol:¬,tab:».,trail:~,extends:>,precedes:<

" Only one space after period in join command
set nojoinspaces

" Thou shalt not cross 80 columns in thy file.
nnoremap <leader>8 :set colorcolumn=81<cr>:set textwidth=80<cr>
nnoremap <leader>7 :set colorcolumn=0<cr>:set textwidth=0<cr>
nnoremap <leader>9 :call EightyCharsToggle()<cr>

" Highlight columns over 80 in red for quick scanning
let s:eightychars = 1
function! EightyCharsToggle()
    if s:eightychars
        highlight OverLength ctermbg=red ctermfg=white
        match OverLength /\%81v.\+/
        let s:eightychars = 0
    else
        highlight OverLength none
        let s:eightychars = 1
    endif
endfunction

" ==================== Scrolling ==================== {{{1

set scrolloff=8  " Start scrolling when at 8 lines away from margins

" ==================== Autocomplete ==================== {{{1

set completeopt=menu,preview,longest

let g:clang_use_library=1
let g:clang_library_path='/usr/lib/'
let g:clang_complete_auto=0
let g:clang_auto_select=0
let g:clang_snippets_engine='clang_complete'
let g:clang_close_preview=1
let g:clang_complete_copen=1    " Open quickfix on error
let g:clang_complete_patterns=1
let g:clang_complete_macros=1
let g:clang_snippets=1
let g:clang_conceal_snippets=1

nnoremap <leader>q :call g:ClangUpdateQuickFix()<cr>

" This function determines, wether we are on the start of the line text (then
" tab indents) or if we want to try autocompletion. This is simpler than
" Supertab.
function InsertTabWrapper()
    if pumvisible()
        return "\<c-n>"
    endif
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    elseif exists('&omnifunc') && &omnifunc != ''
        return "\<c-x>\<c-o>"
    else
        return "\<c-p>"
    endif
endfunction

" Remap the tab key to select action with InsertTabWrapper
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
