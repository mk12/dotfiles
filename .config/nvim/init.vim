set shell=sh

" =========== Plugins ==========================================================

if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'glts/vim-textobj-comment'
Plug 'jiangmiao/auto-pairs'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'kana/vim-textobj-user'
Plug 'ledger/vim-ledger', { 'for': 'ledger' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'sheerun/vim-polyglot'
Plug 'sunaku/vim-shortcut', { 'on' : ['Shortcut', 'Shortcut!', 'Shortcuts'] }
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary', { 'on': 'Commentary' }
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" =========== Plugin settings ==================================================

let g:AutoPairsMultilineClose = 0
let g:AutoPairsShortcutToggle = ''

let g:airline#extensions#default#layout = [['a', 'c'], ['x', 'y']]
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_extensions = ['tabline']
let g:airline_highlighting_cache = 1
let g:airline_theme = 'onedark'

let g:gitgutter_map_keys = 0

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
set showcmd
set smartcase
set suffixes-=.h
set textwidth=80
set undofile
set visualbell

if !exists('g:loaded_sleuth')
    set expandtab
    set shiftwidth=4
endif

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

xnoremap < <gv
xnoremap > >gv

xnoremap <silent> <expr> p VisualReplaceExpr()

nnoremap <silent> Q :call ReflowText()<CR>
xnoremap Q gq

nnoremap <silent> <Tab> :call NextBufOrTab()<CR>
nnoremap <silent> <S-Tab> :call PrevBufOrTab()<CR>

" Since <Tab> and <C-i> are the same, I need a new mapping for <C-i>.
nnoremap <C-q> <C-i>

nnoremap <silent> <C-]> :call CaseSensitiveTagJump()<CR>
nnoremap <silent> <C-w>] <C-w>s:call CaseSensitiveTagJump()<CR>
nnoremap <silent> <C-w><C-]> <C-w>s:call CaseSensitiveTagJump()<CR>

nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk
omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
xmap ah <Plug>GitGutterTextObjectOuterVisual

" =========== Shortcuts ========================================================

Shortcut open shortcut menu
    \ nnoremap <silent> <Leader> :Shortcuts<CR>
    \|nnoremap <silent> <Leader>? :Shortcuts<CR>

Shortcut go to file in project
    \ nnoremap <silent> <Leader><Leader> :call ProjectFiles()<CR>
Shortcut go to open buffer
    \ nnoremap <silent> <Leader><Tab> :Buffers<CR>
Shortcut go to file in same directory
    \ nnoremap <silent> <Leader>. :Files %:h<CR>
Shortcut go to last buffer
    \ nnoremap <silent> <Leader><BS> :buffer #<CR>

Shortcut project-wide search
    \ nnoremap <silent> <Leader>/ :call SearchProject()<CR>
Shortcut project-wide search with input
    \ nnoremap <silent> <Leader>* :call SearchProject(expand('<cword>'))<CR>
    \|xnoremap <silent> <Leader>* "vy:call SearchProject(@v)<CR>

Shortcut go to alternate file
    \ nnoremap <silent> <Leader>a :call AlternateFile()<CR>

Shortcut toggle comment
    \ nnoremap <Leader>c :Commentary<CR>
    \|xnoremap <Leader>c :Commentary<CR>

Shortcut indent lines
    \ nnoremap <Leader>di =ip
    \|xnoremap <Leader>di =
Shortcut show number of search matches
    \ nnoremap <Leader>dm :%s/<C-r>///n<CR>
    \|xnoremap <Leader>dm "vy:%s/<C-r>v//n<CR>
Shortcut sort lines
    \ nnoremap <Leader>ds vip:sort<CR>
    \|xnoremap <Leader>ds :sort<CR>
Shortcut remove trailing whitespace
    \ nnoremap <Leader>dw :%s/\s\+$//e<CR><C-o>
    \|xnoremap <Leader>dw :s/\s\+$//e<CR>
Shortcut yank to system clipboard
    \ nnoremap <Leader>dy :%y*<Bar>call YankToSystemClipboard(@*)<CR>
    \|xnoremap <Leader>dy "*y:call YankToSystemClipboard(@*)<CR>

Shortcut edit fish config
    \ nnoremap <Leader>ef :edit ~/.config/fish/config.fish<CR>
Shortcut delete hidden buffers
    \ nnoremap <Leader>eh :call DeleteHiddenBuffers()<CR>
Shortcut edit journal file
    \ nnoremap <Leader>ej :edit ~/ia/Journal/Journal.txt<CR>
Shortcut edit new buffer
    \ nnoremap <Leader>en :enew<CR>
Shortcut reload current buffer
    \ nnoremap <Leader>er :edit!<CR>
Shortcut reload vimrc or init.vim
    \ nnoremap <Leader>eR :source $MYVIMRC<CR>
Shortcut edit vimrc or init.vim
    \ nnoremap <Leader>ev :edit $MYVIMRC<CR>

Shortcut format code
    \ nnoremap <Leader>f :call FormatCode()<CR>

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
Shortcut git read/checkout
    \ nnoremap <Leader>gr :Gread<CR>
Shortcut git read/checkout hunk
    \ nmap <Leader>gR <Plug>GitGutterUndoHunk
Shortcut git status
    \ nnoremap <Leader>gs :Gstatus<CR>
Shortcut git write/add
    \ nnoremap <Leader>gw :Gwrite<CR>
Shortcut git write/add hunk
    \ nmap <Leader>gW <Plug>GitGutterStageHunk

Shortcut get help
    \ nnoremap <Leader>h :Helptags<CR>

Shortcut jump to line in any buffer
    \ nnoremap <Leader>ja :Lines<CR>
Shortcut jump to git commit
    \ nnoremap <Leader>jc :Commits<CR>
Shortcut jump to file in a directory
    \ nnoremap <expr> <Leader>jd ':Files ' . InputDirectory() . '<CR>'
Shortcut jump to file in working directory
    \ nnoremap <Leader>jf :Files<CR>
Shortcut jump to git file
    \ nnoremap <Leader>jg :GFiles<CR>
Shortcut jump to line in buffer
    \ nnoremap <Leader>jl :BLines<CR>
Shortcut jump to symbol/tag in buffer
    \ nnoremap <Leader>js :BTags<CR>
Shortcut jump to tag in project
    \ nnoremap <Leader>jt :Tags<CR>

Shortcut kill/delete buffer
    \ nnoremap <silent> <leader>k :call KillBuffer('')<CR>
Shortcut force kill/delete buffer
    \ nnoremap <silent> <Leader>K :call KillBuffer('!')<CR>

Shortcut open console
    \ nnoremap <Leader>mc :Console<CR>
Shortcut open console in background
    \ nnoremap <Leader>mC :Console!<CR>
Shortcut dispatch default task
    \ nnoremap <Leader>md :Dispatch<CR>
Shortcut dispatch default task in background
    \ nnoremap <Leader>mD :Dispatch!<CR>
Shortcut make/build project
    \ nnoremap <Leader>mm :Make<CR>
Shortcut make/build project in background
    \ nnoremap <Leader>mM :Make!<CR>
Shortcut open build results
    \ nnoremap <Leader>mo :Copen<CR>
Shortcut open catch-all build results
    \ nnoremap <Leader>mO :Copen!<CR>
Shortcut start project
    \ nnoremap <Leader>ms :Start<CR>
Shortcut start project in background
    \ nnoremap <Leader>mS :Start!<CR>

Shortcut stop highlighting the search
    \ nnoremap <Leader>n :nohlsearch<CR>

Shortcut clean plugins
    \ nnoremap <Leader>pc :PlugClean<CR>
Shortcut install plugins
    \ nnoremap <Leader>pi :PlugInstall<CR>
Shortcut update plugins
    \ nnoremap <Leader>pu :PlugUpdate<CR>

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
Shortcut toggle Goyo mode
    \ nnoremap <Leader>tg :Goyo<CR>
Shortcut toggle git line highlight
    \ nnoremap <Leader>tl :GitGutterLineHighlightsToggle<CR>
Shortcut toggle line numbers
    \ nnoremap <Leader>tn :set number!<CR>
Shortcut toggle obsess/session tracking
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
    \ nnoremap <Leader>w- <C-w>s
Shortcut new vertical split
    \ nnoremap <Leader>w/ <C-w>v
Shortcut use 2-up vertical split
    \ nnoremap <Leader>w2 <C-w>o<C-w>v
Shortcut use 3-up vertical split
    \ nnoremap <Leader>w3 <C-w>o<C-w>v<C-w>v
Shortcut resize windows equally
    \ nnoremap <Leader>w= <C-w>=
Shortcut go to left window
    \ nnoremap <Leader>wh <C-w>h
Shortcut move window left
    \ nnoremap <Leader>wH <C-w>H
Shortcut go to down window
    \ nnoremap <Leader>wj <C-w>j
Shortcut move window down
    \ nnoremap <Leader>wJ <C-w>J
Shortcut go to up window
    \ nnoremap <Leader>wk <C-w>k
Shortcut move window up
    \ nnoremap <Leader>wK <C-w>K
Shortcut go to right window
    \ nnoremap <Leader>wl <C-w>l
Shortcut move window right
    \ nnoremap <Leader>wL <C-w>L
Shortcut close all other windows
    \ nnoremap <Leader>wo <C-w>o
Shortcut new tab
    \ nnoremap <Leader>wt :tabnew %<CR>

Shortcut save/write and exit
    \ nnoremap <Leader>x :exit<CR>
Shortcut save/write all and exit
    \ nnoremap <Leader>X :xall<CR>

" =========== Autocommands =====================================================

augroup custom
    autocmd!

    autocmd FileType c,cpp setlocal commentstring=//\ %s comments^=:///
    autocmd FileType sql setlocal commentstring=--\ %s

    autocmd FileType text,markdown setlocal textwidth=0 colorcolumn=0
    autocmd FileType ledger setlocal textwidth=0 colorcolumn=61,81

    " By default GitGutter waits for 'updatetime' ms before updating.
    autocmd BufWritePost * GitGutter
augroup END

" =========== Functions ========================================================

function! s:Error(msg) abort
    echohl ErrorMSg
    echomsg a:msg
    echohl Normal
endfunction

function! s:Warning(msg) abort
    echohl WarningMsg
    echomsg a:msg
    echohl Normal
endfunction

function! s:EchoException() abort
    call s:Error(substitute(v:exception, '^Vim.\{-}:', '', ''))
endfunction

function! InputDirectory() abort
    return input("From dir: ", getcwd() . '/', 'dir')
endfunction

function! VisualReplaceExpr() abort
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<CR>"
endfunction

function! RestoreRegister() abort
    let @" = s:restore_reg
    return ''
endfunction

function! ReflowText() abort
    if synIDattr(synID(line('.'), col('.'), 1), 'name') =~? 'comment'
        normal! gqac
    else
        normal! gqap
    endif
endfunction

function! NextBufOrTab() abort
    if tabpagenr('$') > 1
        tabnext
    else
        bnext
    endif
endfunction

function! PrevBufOrTab() abort
    if tabpagenr('$') > 1
        tabprevious
    else
        bprevious
    endif
endfunction

function! CaseSensitiveTagJump() abort
    let l:save_ic = &ignorecase
    set noignorecase
    try
        execute 'tag' expand('<cword>')
    catch
        call s:EchoException()
    finally
        let &ignorecase = l:save_ic
    endtry
endfunction

function! ProjectFiles() abort
    if !empty(glob('.git'))
        GitFiles
    else
        Files
    endif
endfunction

function! SearchProject(...) abort
    let l:term = input("Search: ", a:0 > 0 ? a:1 : '')
    if empty(l:term)
        return
    endif
    let l:old_dir = getcwd()
    let l:dir = InputDirectory()
    if l:dir !=# ''
        try
            silent execute 'cd' l:dir
        catch
            return
        endtry
    endif
    silent execute 'Rg' l:term
    if l:dir !=# ''
        silent execute 'cd' l:old_dir
    endif
    let @/ = l:term
endfunction

function! AlternateFile() abort
    let l:header_extensions = ['h', 'hpp', 'hh']
    let l:source_extensions = ['c', 'cpp', 'cc']
    if index(l:header_extensions, expand('%:e')) >= 0
        for l:c in l:source_extensions
            let l:file = expand('%:r') . '.' . l:c
            if filereadable(l:file)
                silent execute 'edit' l:file
                echo l:file
                return
            endif
        endfor
    elseif index(l:source_extensions, expand('%:e')) >= 0
        for l:h in l:header_extensions
            let l:file = expand('%:r') . '.' . l:h
            if filereadable(l:file)
                silent execute 'edit' l:file
                echo l:file
                return
            endif
        endfor
    endif
    try
        A
    catch
        call s:EchoException()
    endtry
endfunction

" https://sunaku.github.io/tmux-yank-osc52.html
function! YankToSystemClipboard(text) abort
    let l:escape = system('yank', a:text)
    if v:shell_error
        echoerr l:escape
    else
        call writefile([l:escape], '/dev/tty', 'b')
    endif
endfunction

function! FormatCode() abort
    if &filetype ==# 'c' || &filetype ==# 'cpp'
        silent write
        let l:view = winsaveview()
        silent !clang-format -i %
        winrestview(l:view)
    else
        call s:Error("Unable to format " . &filetype . " file")
    endif
endfunction

" http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window#Script
function! KillBuffer(bang) abort
    if &modified == 1 && empty(a:bang)
        try
            bdelete
        catch
            call s:EchoException()
        endtry
        return
    endif
    let l:btarget = bufnr('%')
    let l:wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == l:btarget')
    let l:wcurrent = winnr()
    for l:w in l:wnums
        silent execute l:w 'wincmd w'
        let l:balt = bufnr('#')
        if l:balt > 0 && buflisted(l:balt) && l:balt != l:btarget
            buffer #
        else
            bprevious
        endif
        if bufnr('%') == l:btarget
            " Listed buffers that are not the target.
            let l:blisted = filter(range(1, bufnr('$')),
                \ 'buflisted(v:val) && v:val != l:btarget')
            " Listed buffers that are not the target and not displayed.
            let l:bhidden = filter(copy(l:blisted), 'bufwinnr(v:val) < 0')
            " Take the first buffer, if any (could be more intelligent).
            let l:bjump = (l:bhidden + l:blisted + [-1])[0]
            if l:bjump > 0
                silent execute 'buffer' l:bjump
            else
                silent execute 'enew' . a:bang
            endif
        endif
    endfor
    " Might have been auto-deleted, for example if it was a FZF buffer.
    if buflisted(l:btarget)
        silent execute 'bdelete' . a:bang l:btarget
    endif
    silent execute l:wcurrent 'wincmd w'
endfunction

function! EightyColumns(...) abort
    let l:on = a:0 > 0 ? a:1 : (empty(&colorcolumn) || &colorcolumn ==# '0')
    if l:on
        setlocal textwidth=80 colorcolumn=+1
    else
        setlocal textwidth=0 colorcolumn=0
    endif
endfunction

function! DeleteHiddenBuffers() abort
    let l:tpbl = []
    let l:closed = 0
    call map(range(1, tabpagenr('$')), 'extend(l:tpbl, tabpagebuflist(v:val))')
    let l:filter = 'buflisted(v:val) && index(l:tpbl, v:val) == -1'
    for buf in filter(range(1, bufnr('$')), l:filter)
        if getbufvar(buf, '&mod') == 0
            silent execute 'bdelete' buf
            let l:closed += 1
        endif
    endfor
    echo "Deleted " . l:closed . " hidden buffers"
endfunction

" =========== Color scheme =====================================================

set termguicolors
set background=dark
colorscheme onedark
highlight clear NonText
highlight link NonText Comment
