set shell=sh

" =========== Plugins ==========================================================

if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'airblade/vim-gitgutter'
Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'glts/vim-textobj-comment'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'justinmk/vim-dirvish'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-user'
Plug 'ledger/vim-ledger', { 'for': 'ledger' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'sgur/vim-textobj-parameter'
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
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" =========== Plugin settings ==================================================

let g:AutoPairsMultilineClose = 0
let g:AutoPairsShortcutToggle = ''

let g:airline#extensions#default#layout = [['a', 'c'], ['x', 'y']]
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_base16_improved_contrast = 0
let g:airline_base16_monotone = 1
let g:airline_extensions = ['tabline']
let g:airline_highlighting_cache = 1
let g:airline_theme = 'base16_vim'

let g:dispatch_no_maps = 1
let g:dispatch_quickfix_height = 15
let g:dispatch_tmux_height = 15

let g:gitgutter_map_keys = 0

" =========== Options ==========================================================

set backup
set cmdheight=2
set colorcolumn=+1
set cursorline
set gdefault
set hidden
set hlsearch
set ignorecase
set lazyredraw
set linebreak
set listchars=eol:¬,tab:».,trail:~
set mouse=a
set mousefocus
set noerrorbells
set nofoldenable
set nojoinspaces
set noruler
set noshowmode
set nostartofline
set number
set scrolloff=4
set shiftround
set showcmd
set sidescrolloff=4
set smartcase
set suffixes-=.h
set tagcase=match
set textwidth=80
set undofile
set visualbell
set wildmode=longest,full

if !exists('g:loaded_sleuth')
    set expandtab
    set shiftwidth=4
endif

let &backupdir = $HOME . '/.local/share/nvim/backup'
call mkdir(&backupdir, 'p')

" =========== Color scheme =====================================================

set notermguicolors
colorscheme base16-default-dark

call Base16hi("DiffFile", g:base16_gui05, "", g:base16_cterm05, "", "bold")
call Base16hi("DiffIndexLine", g:base16_gui05, "", g:base16_cterm05, "", "bold")
call Base16hi("DiffNewFile", g:base16_gui05, "", g:base16_cterm05, "", "bold")
call Base16hi("WarningMsg", g:base16_gui0A, "", g:base16_cterm0A, "")

hi clear StatusLine
hi link StatusLine PMenu
hi clear WildMenu
hi link WildMenu PMenuSel
hi Normal ctermbg=NONE

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

nnoremap gV `[v`]

inoremap <C-U> <C-G>u<C-U>

nnoremap <C-N> nzz
nnoremap <C-P> Nzz

nnoremap <silent> & :&&<CR>
xnoremap <silent> & :&&<CR>

xnoremap <expr> p VisualReplaceExpr()

nnoremap <silent> zS :echo SyntaxName()<CR>

nnoremap <silent> Q :call ReflowText()<CR>
xnoremap Q gq

nnoremap <silent> _ :Dirvish<CR>

nnoremap <silent> <Tab> :call NextBufOrTab()<CR>
nnoremap <silent> <S-Tab> :call PrevBufOrTab()<CR>

" Since <Tab> and <C-I> are the same, I need a new mapping for <C-I>.
nnoremap <C-Q> <C-I>

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
Shortcut go to file in same directory
    \ nnoremap <silent> <Leader>. :Files %:h<CR>
Shortcut go to file in a directory
    \ nnoremap <silent> <expr> <Leader>, ':Files ' . InputDirectory() . '<CR>'
Shortcut go to open buffer
    \ nnoremap <silent> <Leader><Tab> :Buffers<CR>
Shortcut go to last buffer
    \ nnoremap <silent> <Leader><BS> :buffer #<CR>

Shortcut project-wide search
    \ nnoremap <silent> <Leader>/ :call SearchProject()<CR>
Shortcut project-wide search with input
    \ nnoremap <silent> <Leader>* :call SearchProject(expand('<cword>'))<CR>
    \|xnoremap <silent> <Leader>* "zy:call SearchProject(@z)<CR>

Shortcut go to alternate file
    \ nnoremap <Leader>a :call AlternateFile()<CR>

Shortcut toggle comment
    \ nnoremap <Leader>c :Commentary<CR>
    \|xnoremap <Leader>c :Commentary<CR>

Shortcut indent lines
    \ nnoremap <Leader>di =ip
    \|xnoremap <Leader>di =
Shortcut show number of search matches
    \ nnoremap <Leader>dm :%s/<C-R>///n<CR>
    \|xnoremap <Leader>dm "zy:%s/<C-R>z//n<CR>
Shortcut sort lines
    \ nnoremap <Leader>ds vip:sort<CR>
    \|xnoremap <Leader>ds :sort<CR>
Shortcut remove trailing whitespace
    \ nnoremap <Leader>dw :%s/\s\+$//e<CR>
    \|xnoremap <Leader>dw :s/\s\+$//e<CR>
Shortcut yank to system clipboard
    \ nnoremap <Leader>dy :%y+<Bar>call YankToSystemClipboard(@+)<CR>
    \|xnoremap <Leader>dy "+y:call YankToSystemClipboard(@+)<CR>

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
Shortcut resolve symlinks
    \ nnoremap <Leader>es :call ResolveSymlinks()<CR>
Shortcut edit vimrc or init.vim
    \ nnoremap <Leader>ev :edit $MYVIMRC<CR>
Shortcut source vimrc or init.vim
    \ nnoremap <Leader>eV :source $MYVIMRC<CR>

Shortcut format code
    \ nnoremap <Leader>f :call FormatCode('%')<CR>
    \|xnoremap <Leader>f :call FormatCode()<CR>

Shortcut git blame
    \ nnoremap <Leader>gb :Gblame<CR>
Shortcut git diff current file
    \ nnoremap <Leader>gd :Gdiff<CR>
Shortcut git diff all files
    \ nnoremap <Leader>gD :Gtabedit! diff<CR>
Shortcut browse on GitHub
    \ nnoremap <Leader>gh :Gbrowse<CR>
Shortcut git push
    \ nnoremap <Leader>gp :Gpush<CR>
Shortcut git status
    \ nnoremap <Leader>gs :Gstatus<CR>
Shortcut git update/pull
    \ nnoremap <Leader>gu :Gpull<CR>

Shortcut find help
    \ nnoremap <Leader>h :Helptags<CR>

Shortcut jump to line in any buffer
    \ nnoremap <Leader>ja :Lines<CR>
Shortcut jump to commit
    \ nnoremap <Leader>jc :Commits<CR>
Shortcut jump/switch to filetype
    \ nnoremap <Leader>jf :Filetypes<CR>
Shortcut jump to line in buffer
    \ nnoremap <Leader>jl :BLines<CR>
Shortcut jump to mark
    \ nnoremap <Leader>jm :Marks<CR>
Shortcut jump to symbol/tag in buffer
    \ nnoremap <Leader>js :BTags<CR>
Shortcut jump to tag in project
    \ nnoremap <Leader>jt :call BrowseTags()<CR>

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
Shortcut generate project tags
    \ nnoremap <Leader>mt :call GenerateTags()<CR>

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
    \ nnoremap <Leader>t8 :call ToggleColumnLimit()<CR>
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
    \ nnoremap <Leader>w- <C-W>s
Shortcut new vertical split
    \ nnoremap <Leader>w/ <C-W>v
Shortcut use 2-up vertical split
    \ nnoremap <Leader>w2 <C-W>o<C-W>v
Shortcut use 3-up vertical split
    \ nnoremap <Leader>w3 <C-W>o<C-W>v<C-W>v
Shortcut resize windows equally
    \ nnoremap <Leader>w= <C-W>=
Shortcut go to left window
    \ nnoremap <Leader>wh <C-W>h
Shortcut move window left
    \ nnoremap <Leader>wH <C-W>H
Shortcut go to down window
    \ nnoremap <Leader>wj <C-W>j
Shortcut move window down
    \ nnoremap <Leader>wJ <C-W>J
Shortcut go to up window
    \ nnoremap <Leader>wk <C-W>k
Shortcut move window up
    \ nnoremap <Leader>wK <C-W>K
Shortcut go to right window
    \ nnoremap <Leader>wl <C-W>l
Shortcut move window right
    \ nnoremap <Leader>wL <C-W>L
Shortcut close all other windows
    \ nnoremap <Leader>wo <C-W>o
Shortcut new tab
    \ nnoremap <Leader>wt :tabnew %<CR>

Shortcut save/write and exit
    \ nnoremap <Leader>x :exit<CR>
Shortcut save/write all and exit
    \ nnoremap <Leader>X :xall<CR>

" =========== Autocommands =====================================================

augroup custom
    autocmd!

    " Automatically load Obsession sessions.
    autocmd VimEnter * if argc() is 0 | silent! source Session.vim | endif

    autocmd FileType c,cpp setlocal commentstring=//\ %s comments^=:///
    autocmd FileType sql setlocal commentstring=--\ %s

    autocmd FileType text,markdown setlocal textwidth=0 colorcolumn=0
    autocmd FileType ledger setlocal textwidth=0 colorcolumn=61,81

    autocmd BufEnter * call DisableSyntaxForDiff()
    autocmd User ProjectionistActivate call LoadCustomProjections()

    " By default GitGutter waits for 'updatetime' ms before updating.
    autocmd BufWritePost,WinEnter * GitGutter

    " Sometimes Airline doesn't clean up properly.
    autocmd BufWipeout * call airline#extensions#tabline#buflist#clean()
augroup END

" =========== Functions ========================================================

function! s:Error(msg) abort
    echohl ErrorMsg
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

function! s:ExecuteRestoringView(cmd) abort
    " http://vim.wikia.com/wiki/
    " Restore_the_cursor_position_after_undoing_text_change_made_by_a_script
    normal! ix
    normal! x
    let l:view = winsaveview()
    silent execute a:cmd
    call winrestview(l:view)
endfunction

function! InputDirectory() abort
    let l:default_dir = get(s:, 'last_input_dir', '')
    let l:dir = input('From dir: ', l:default_dir, 'dir')
    let s:last_input_dir = l:dir
    return l:dir
endfunction

function! VisualReplaceExpr() abort
    let s:saved_register = @"
    return "p@=RestoreRegister()\<CR>"
endfunction

function! RestoreRegister() abort
    let @" = s:saved_register
    return ''
endfunction

function! SyntaxName() abort
    return synIDattr(synID(line('.'), col('.'), 1), 'name')
endfunction

function! ReflowText() abort
    if SyntaxName() is? 'comment'
        normal gqac
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

function! ProjectFiles() abort
    if !empty(glob('.git'))
        GFiles
    else
        Files
    endif
endfunction

function! SearchProject(...) abort
    let l:default_term = get(a:, 1, get(s:, 'last_search_term', ''))
    let l:term = input('Search: ', l:default_term)
    if empty(l:term)
        return
    endif
    let s:last_search_term = l:term
    let l:old_dir = getcwd()
    let l:dir = InputDirectory()
    if !empty(l:dir)
        try
            silent execute 'cd' l:dir
        catch
            redraw
            call s:EchoException()
            return
        endtry
    endif
    try
        silent execute 'Rg' l:term
    finally
        if !empty(l:dir)
            silent execute 'cd' l:old_dir
        endif
    endtry
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

function! DeleteHiddenBuffers() abort
    let l:tpbl = []
    let l:deleted = 0
    call map(range(1, tabpagenr('$')), 'extend(l:tpbl, tabpagebuflist(v:val))')
    let l:filter = 'buflisted(v:val) && index(l:tpbl, v:val) is -1'
    for buf in filter(range(1, bufnr('$')), l:filter)
        if getbufvar(buf, '&mod') is 0
            silent execute 'bdelete' buf
            let l:deleted += 1
        endif
    endfor
    echomsg 'Deleted ' . l:deleted . ' hidden buffers'
endfunction

function! ResolveSymlinks() abort
    let l:current = expand('%')
    let l:resolved = resolve(l:current)
    if l:current is# l:resolved
        echomsg 'No symlinks to resolve'
        return
    endif
    if &mod is 1
        call s:Error('E37: No write since last change')
        return
    endif
    try
        silent execute 'keepalt file' fnameescape(l:resolved)
        try
            silent write
        catch /^Vim\%((\a\+)\)\=:E13/
            silent write!
            " Reload so that fugitive picks it up.
            silent edit
        endtry
        echomsg 'Resolved to ' . l:resolved
    catch
        call s:EchoException()
    endtry
endfunction

function! FormatCode(...) abort range
    if exists('b:format_command')
        let l:cmd = b:format_command
    elseif &filetype is# 'c' || &filetype is# 'cpp'
        let l:cmd = 'clang-format'
    else
        let l:ft = empty(&filetype) ? '<no filetype>' : &filetype
        call s:Error('Unable to format ' . l:ft . ' file')
        return
    endif
    let l:first = split(l:cmd)[0]
    if !executable(l:first)
        call s:Error('Executable not found: ' . l:first)
        return
    endif
    let l:range = get(a:, 1, a:firstline . ',' . a:lastline)
    call s:ExecuteRestoringView(l:range . '!' . l:cmd)
endfunction

function! BrowseTags() abort
    if empty(tagfiles())
        call s:Error('No tags file found')
        return
    endif
    try
        Tags
    catch
        call s:EchoException()
    endtry
endfunction

" http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window#Script
function! KillBuffer(bang) abort
    if empty(a:bang) && (&modified is 1 || &buftype is# 'terminal')
        try
            bdelete
        catch
            call s:EchoException()
        endtry
        return
    endif
    let l:btarget = bufnr('%')
    let l:wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) is l:btarget')
    let l:wcurrent = winnr()
    for l:w in l:wnums
        silent execute l:w 'wincmd w'
        let l:balt = bufnr('#')
        if l:balt > 0 && buflisted(l:balt) && l:balt isnot l:btarget
            buffer #
        else
            bprevious
        endif
        if bufnr('%') is l:btarget
            " Listed buffers that are not the target.
            let l:blisted = filter(range(1, bufnr('$')),
                \ 'buflisted(v:val) && v:val isnot l:btarget')
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

function! GenerateTags() abort
    call s:Warning('Preparing tags')
    call system(get(b:, 'tags_command', 'ctags -R'))
    if empty(tagfiles())
        call s:Warning('Failed to create tags')
    else
        echomsg 'Finished generating tags'
    endif
endfunction

function! ToggleColumnLimit() abort
    if &tw is 0 || empty(&colorcolumn) || &colorcolumn is# '0'
        let &l:textwidth = get(b:, 'ColumnLimit', 80)
        setlocal colorcolumn=+1
    else
        setlocal textwidth=0 colorcolumn=0
    endif
endfunction

function! DisableSyntaxForDiff() abort
    if &diff is 1
        setlocal syntax=
    elseif empty(&syntax)
        let &l:filetype = &filetype
    endif
endfunction

function! LoadCustomProjections() abort
    for [l:root, l:value] in projectionist#query('filetype')
        let &l:filetype = l:value
        break
    endfor
    for [l:root, l:value] in projectionist#query('textwidth')
        let b:column_limit = l:value
        let &l:textwidth = l:value
        break
    endfor
    for [l:root, l:value] in projectionist#query('format_command')
        let b:format_command = l:value
        break
    endfor
    for [l:root, l:value] in projectionist#query('tags_command')
        let b:tags_command = l:value
        break
    endfor
endfunction
