set shell=sh

" =========== Plugin settings ==================================================

let g:AutoPairsMultilineClose = 0
let g:AutoPairsShortcutToggle = ''

let g:airline#extensions#default#layout = [['a', 'c'], ['x', 'y']]
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_base16_improved_contrast = 1
let g:airline_base16_monotone = 1
let g:airline_extensions = ['tabline']
let g:airline_highlighting_cache = 1
let g:airline_theme = 'base16_vim'

let g:dispatch_no_maps = 1

" Remove once https://github.com/blankname/vim-fish/pull/6 is merged.
let g:fish_indent_cont = 4

let g:fugitive_legacy_commands = 0

let g:gitgutter_map_keys = 0

let g:VimuxPromptString = "Vimux: "
let g:VimuxHeight = "30"

" =========== Plugins ==========================================================

if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

function! LocalPlugin(name)
    let l:path = substitute(a:name, '^[^/]\+', $PROJECTS, '')
    return isdirectory(l:path) ? l:path : a:name
endfunction

call plug#begin()

Plug LocalPlugin('junegunn/fzf')
Plug LocalPlugin('mk12/base16-vim')
Plug LocalPlugin('mk12/vim-meta')

Plug 'Clavelito/indent-awk.vim'
Plug 'airblade/vim-gitgutter'
Plug 'benmills/vimux'
Plug 'glts/vim-textobj-comment'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/gv.vim'
Plug 'justinmk/vim-dirvish'
Plug 'kana/vim-textobj-user'
Plug 'ledger/vim-ledger'
Plug 'mbbill/undotree'
Plug 'michaeljsmith/vim-indent-object'
Plug 'sgur/vim-textobj-parameter'
Plug 'sheerun/vim-polyglot'
Plug 'sunaku/vim-shortcut', { 'on' : 'Shortcut' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'wsdjeg/vim-fetch'

call plug#end()

" =========== Options ==========================================================

set backup
set belloff=all
set cmdheight=2
set cursorline
set gdefault
set hidden
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

" Only set these options on startup.
if has('vim_starting')
    set colorcolumn=+1
    set expandtab
    set hlsearch
    set shiftwidth=4
endif

" Don't save backup files in the same directory.
let &backupdir = $HOME . '/.local/share/nvim/backup'

" =========== Color scheme =====================================================

" I use terminal colors so that I can swap base16 themes and have everything
" update immediately. That doesn't work with hardcoded 24-bit color.
if has('termguicolors')
    set notermguicolors
end

" I'm not using chriskempson/base16-shell, but I am using mk12/base16-kitty,
" which uses color slots 16-21 in the same way.
let base16colorspace = 256

" Explicitly set background to avoid auto-detection issues. It doesn't
" matter whether it's light or dark for base16.
set background=dark
colorscheme base16

" =========== Mappings =========================================================

nnoremap <Space> <Nop>

let mapleader = "\<Space>"
let maplocalleader = ','

inoremap jk <Esc>
inoremap kj <Esc>

noremap ; :
noremap : ;

" Matches https://github.com/mk12/fish-fzf.
nnoremap <silent> <C-O> :call MyFzf('file')<CR>
nnoremap <silent> <C-Q> :call MyFzf('directory')<CR>
nnoremap <silent> <M-Z> :call MyFzf('z')<CR>

" Top/bottom mappings compatible with less and emacs.
noremap <M-<> <C-Home>
noremap <M->> <C-End>
inoremap <M-<> <C-O><C-Home>
inoremap <M->> <C-O><C-End>

" Undo/redo compatible with fish.
nnoremap <C-_> u
inoremap <C-_> <C-O>u
nnoremap <M-/> u
inoremap <M-/> <C-O>u

" Jump between open windows.
nnoremap <C-J> <C-W>w

" Save quickly.
nnoremap <C-s> :write<CR>
inoremap <C-s> <C-o>:write<CR>

nnoremap Y y$

" Stay in visual mode when indenting/dedenting.
xnoremap < <gv
xnoremap > >gv

" Use gv to select last selection, gV to select last insertion.
nnoremap gV `[v`]

nnoremap <silent> & :&&<CR>
xnoremap <silent> & :&&<CR>

" Maintain register when pasting over something else.
xnoremap <expr> p VisualReplaceExpr()

" Use * in visual mode to search for the selection (then cgn and . to repeat).
xnoremap * y:let @/='\V'.escape(@", '\')<Bar>set hls<CR>

nnoremap <silent> zS :echo SyntaxName()<CR>

nnoremap <silent> Q :call ReflowText()<CR>
xnoremap Q gq

nnoremap <silent> _ :Dirvish<CR>

nnoremap <silent> <Tab> :call NextBufOrTab()<CR>
nnoremap <silent> <S-Tab> :call PrevBufOrTab()<CR>

" Since <Tab> and <C-I> are the same, I need a new mapping for <C-I>.
nnoremap <C-P> <C-I>

nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" =========== Shortcuts ========================================================

Shortcut open shortcut menu
    \ nnoremap <silent> <Leader> :Shortcuts<CR>
    \|nnoremap <silent> <Leader>? :Shortcuts<CR>

Shortcut go to file in project
    \ nnoremap <silent> <Leader><Leader> :call MyFzf('file')<CR>
Shortcut go to file in same directory
    \ nnoremap <silent> <Leader>. :call MyFzf('file', expand('%:h'))<CR>
Shortcut go to open buffer
    \ nnoremap <silent> <Leader><Tab> :Buffers<CR>
Shortcut go to last buffer
    \ nnoremap <silent> <Leader><BS> :buffer #<CR>

Shortcut project-wide search
    \ nnoremap <silent> <Leader>/ :call SearchProject()<CR>
Shortcut project-wide search with input
    \ nnoremap <silent> <Leader>* :call SearchProject(expand('<cword>'))<CR>
    \|xnoremap <silent> <Leader>* y:call SearchProject(@")<CR>

Shortcut go to alternate file
    \ nnoremap <Leader>a :call AlternateFile()<CR>

Shortcut toggle comment
    \ nnoremap <Leader>c :Commentary<CR>
    \|xnoremap <Leader>c :Commentary<CR>

Shortcut fix mouse after terminal reset
    \ nnoremap <Leader>da :set mouse=<Bar>set mouse=a<CR>
Shortcut indent lines
    \ nnoremap <Leader>di =ip
    \|xnoremap <Leader>di =
Shortcut show number of search matches
    \ nnoremap <Leader>dm :%s/<C-R>///n<CR>
    \|xnoremap <Leader>dm y:%s/<C-R>"//n<CR>
Shortcut sort lines
    \ nnoremap <Leader>ds vip:sort<CR>
    \|xnoremap <Leader>ds :sort<CR>
Shortcut remove trailing whitespace
    \ nnoremap <Leader>dw :%s/\s\+$//e<CR>
    \|xnoremap <Leader>dw :s/\s\+$//e<CR>
Shortcut set file executable bit
    \ nnoremap <Leader>dx :Chmod +x<CR>
Shortcut unset file executable bit
    \ nnoremap <Leader>dX :Chmod -x<CR>

Shortcut edit fish config
    \ nnoremap <Leader>ef :edit ~/.config/fish/config.fish<CR>
Shortcut edit fish config (local)
    \ nnoremap <Leader>eF :edit ~/.config/fish/local.fish<CR>
Shortcut delete hidden buffers
    \ nnoremap <Leader>eh :call DeleteHiddenBuffers()<CR>
Shortcut edit journal file
    \ nnoremap <Leader>ej :edit $PROJECTS/journal/Journal.txt<CR>
Shortcut edit new buffer
    \ nnoremap <Leader>en :enew<CR>
Shortcut edit shell config/profile
    \ nnoremap <Leader>ep :edit ~/.profile<CR>
Shortcut edit shell config/profile (local)
    \ nnoremap <Leader>eP :edit ~/.local.profile<CR>
Shortcut reload current buffer
    \ nnoremap <Leader>er :edit!<CR>
Shortcut resolve symlinks
    \ nnoremap <Leader>es :call ResolveSymlinks()<CR>
Shortcut edit vimrc or init.vim
    \ nnoremap <Leader>ev :edit $MYVIMRC<CR>

Shortcut format code
    \ nnoremap <Leader>f :call FormatCode('%')<CR>
    \|xnoremap <Leader>f :call FormatCode()<CR>

Shortcut git blame
    \ nnoremap <Leader>gb :Git blame<CR>
Shortcut git diff
    \ nnoremap <Leader>gd :tab Git diff<CR>
Shortcut git diff current file
    \ nnoremap <Leader>gD :tab Gvdiffsplit<CR>
Shortcut git status
    \ nnoremap <Leader>gg :Git<CR>
Shortcut browse on GitHub
    \ nnoremap <Leader>gh :GBrowse<CR>
Shortcut git diff staged/cached/index
    \ nnoremap <Leader>gi :tab Git diff --staged<CR>
Shortcut git diff staged/cached/index current file
    \ nnoremap <Leader>gI :Gtabedit :%<Bar>Gvdiffsplit @<CR>
Shortcut git log
    \ nnoremap <Leader>gl :GV<CR>
    \|xnoremap <Leader>gl :GV<CR>
Shortcut git log current file
    \ nnoremap <Leader>gL :GV!<CR>
Shortcut git push
    \ nnoremap <Leader>gp :Git push<CR>
Shortcut git show HEAD
    \ nnoremap <Leader>gs :tab Git show<CR>
Shortcut git show HEAD current file
    \ nnoremap <Leader>gS :Gtabedit @:%<Bar>Gvdiffsplit @~<CR>
Shortcut git update/pull
    \ nnoremap <Leader>gu :Git pull<CR>
Shortcut git update/pull (autostash)
    \ nnoremap <Leader>gU :Git pull --autostash<CR>

Shortcut find help
    \ nnoremap <Leader>h :Helptags<CR>

Shortcut jump to commit
    \ nnoremap <Leader>jc :Commits!<CR>
Shortcut jump to commit in buffer
    \ nnoremap <Leader>jC :BCommits!<CR>
Shortcut jump/switch to filetype
    \ nnoremap <Leader>jf :Filetypes<CR>
Shortcut jump to line
    \ nnoremap <Leader>jl :Lines<CR>
Shortcut jump to line in buffer
    \ nnoremap <Leader>jL :BLines<CR>
Shortcut jump to mapping
    \ nnoremap <Leader>jm :Maps<CR>
Shortcut jump to project directory
    \ nnoremap <silent> <Leader>jp :call SwitchProject()<CR>
Shortcut jump to command history
    \ nnoremap <Leader>jr :History:<CR>
Shortcut jump to search history
    \ nnoremap <Leader>j/ :History/<CR>

Shortcut kill/delete buffer
    \ nnoremap <silent> <leader>k :call KillBuffer('')<CR>
Shortcut force kill/delete buffer
    \ nnoremap <silent> <Leader>K :call KillBuffer('!')<CR>

Shortcut lint code
    \ nnoremap <silent> <Leader>l :call LintCode('%')<CR>
    \|xnoremap <silent> <Leader>l :call LintCode()<CR>

Shortcut dispatch default task
    \ nnoremap <Leader>m :Dispatch<CR>
Shortcut select default dispatch task
    \ nnoremap <Leader>M :FocusDispatch<Space>

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

Shortcut reload/source vimrc or init.vim
    \ nnoremap <Leader>r :source $MYVIMRC<CR>

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
    \ nnoremap <Leader>to :call ToggleObsession()<CR>
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

Shortcut open horizontal vimux pane
    \ nnoremap <Leader>v- :call OpenVimux('v')<CR>
Shortcut open vertical vimux pane
    \ nnoremap <Leader>v/ :call OpenVimux('h')<CR>
Shortcut interrupt (Ctrl-C) vimux
    \ nnoremap <Leader>vc :VimuxInterruptRunner<CR>
Shortcut inspect vimux pane
    \ nnoremap <Leader>vi :VimuxInspectRunner<CR>
Shortcut clear vimux history
    \ nnoremap <Leader>vk
        \ :call VimuxSendKeys('C-l')<Bar>VimuxClearRunnerHistory<CR>
Shortcut run last vimux command
    \ nnoremap <Leader>vl :VimuxRunLastCommand<CR>
Shortcut close vimux pane
    \ nnoremap <Leader>vq :VimuxCloseRunner<CR>
Shortcut run vimux command
    \ nnoremap <Leader>vv :VimuxPromptCommand<CR>
Shortcut zoom vimux pane
    \ nnoremap <Leader>vz :VimuxZoomRunner<CR>

Shortcut yank to system clipboard
    \ nnoremap <Leader>y :%y+<Bar>call YankToSystemClipboard(@+)<CR>
    \|xnoremap <Leader>y "+y:call YankToSystemClipboard(@+)<CR>

" =========== Autocommands =====================================================

augroup custom
    autocmd!

    autocmd FileType c,cpp setlocal commentstring=//\ %s comments^=:///
    autocmd FileType sql setlocal commentstring=--\ %s

    autocmd FileType text,markdown setlocal textwidth=0 colorcolumn=0
    autocmd FileType ledger setlocal textwidth=0 colorcolumn=61,81,101,121

    autocmd FileType j let b:AutoPairs = {}
    autocmd FileType lisp,scheme
        \ let b:AutoPairs = AutoPairsDefine({"'": "", "'''": ""})

    " Fix it so that crontab -e can save properly.
    autocmd filetype crontab setlocal nobackup nowritebackup textwidth=0

    " Don't do syntax highlighting in diffs.
    autocmd BufEnter * call DisableSyntaxForDiff()
    autocmd OptionSet diff call DisableSyntaxForDiff()

    " By default GitGutter waits for 'updatetime' ms before updating.
    autocmd BufWritePost,WinEnter * GitGutter

    " The Airline tabline gets messed up when reloading the color scheme.
    autocmd ColorScheme * AirlineRefresh

    " Sometimes Airline doesn't clean up properly.
    autocmd BufWipeout * call airline#extensions#tabline#buflist#clean()

    " Exit things with q.
    autocmd filetype help,git,fugitive* nnoremap <buffer> <silent> q :close<CR>
    autocmd filetype dirvish nmap <buffer> <silent> q <Plug>(dirvish_quit)
    autocmd BufEnter fugitive://*//* nnoremap <buffer> <silent> q :tabclose<CR>

    " Redraw after leaving the command-line window to close it.
    " https://vi.stackexchange.com/a/18178
    autocmd CmdWinEnter * nnoremap <buffer><expr><nowait> <C-C>
        \ '<C-C>'.timer_start(0, {-> execute('redraw')})[-1]
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
    " http://vim.wikia.com/wiki/Restore_the_cursor_position_after_undoing_text_change_made_by_a_script
    normal! ix
    normal! x
    let l:view = winsaveview()
    let l:old_shellredir = &shellredir
    let l:errfile = tempname()
    let &shellredir = '>%s 2>' . l:errfile
    try
        silent execute a:cmd
    finally
        let &shellredir = l:old_shellredir
        call winrestview(l:view)
    endtry
    if v:shell_error isnot 0
        call s:Error(readfile(l:errfile)[0])
    endif
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
    if SyntaxName() =~? 'comment'
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
    if tabpagenr('$')   > 1
        tabprevious
    else
        bprevious
    endif
endfunction

function! s:Edit(file)
    execute 'edit' a:file
endfunction

function! MyFzf(type, ...) abort
    let l:root = get(a:, 1, '""')
    let l:helper_dir = $HOME . '/.config/fish/functions/fzf_helpers'
    if !isdirectory(l:helper_dir)
        call s:Error("Directory not found: " . l:helper_dir)
        return
    endif
    let l:command = l:helper_dir . '/fzf_command.sh'
    let l:preview = l:helper_dir . '/fzf_preview.sh'
    let l:temp = tempname()
    let l:cts = l:command . ' ' . l:temp . ' '
    try
        call fzf#run(fzf#wrap({
            \ 'source': join([l:command, l:temp, 'init', l:root, a:type]),
            \ 'options': [
                \ '--keep-right',
                \ '--header-lines', '1',
                \ '--preview', l:preview . ' {} ' . l:temp,
                \ '--bind', 'ctrl-o:reload(' . l:cts . 'file)',
                \ '--bind', 'ctrl-q:reload(' . l:cts . 'directory)',
                \ '--bind', 'alt-z:reload(' . l:cts . 'z)',
                \ '--bind', 'alt-.:reload(' . l:cts . 'toggle-hidden)',
                \ '--bind', 'alt-i:reload(' . l:cts . 'toggle-ignore)',
                \ '--bind', 'alt-h:reload(' . l:cts . 'home)+clear-query',
                \ '--bind', 'alt-up:reload(' . l:cts . 'up)+clear-query',
                \ '--bind', 'alt-down:reload(' . l:cts . 'down {})+clear-query',
                \ '--bind', 'alt-enter:accept',
            \ ],
            \ 'sink': { choice -> s:Edit(system(l:cts . 'finish', choice)) },
        \ }))
    finally
        call delete(l:temp)
    endtry
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
        if l:dir is# '.'
            let l:dir = '%:h'
        endif
        try
            silent execute 'cd' l:dir
        catch
            redraw
            call s:EchoException()
            return
        endtry
    endif
    try
        " Not using silent execute because then pressing enter does not work
        " (only in vim 8.2; in nvim it works fine either way).
        execute 'Rg' l:term
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
    if exists(':A') is 2
        try
            A
        catch
            call s:EchoException()
        endtry
    else
        call s:Error("Cannot find alternate file")
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
    elseif &filetype is# 'rust'
        let l:cmd = 'rustfmt'
    elseif &filetype is# 'python'
        let l:cmd = 'black -l ' . &textwidth . ' -'
    elseif &filetype is# 'fish'
        let l:cmd = 'fish_indent'
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

function! SwitchProject() abort
    call fzf#run(fzf#wrap({
        \ 'source': 'z-projects',
        \ 'options': [
            \ '--prompt', 'Projects> ',
            \ '--preview', 'bat --plain --color=always $PROJECTS/{}/README.md',
        \ ],
        \ 'sink': {dir -> s:SwitchProjectSink(dir)},
    \ }))
endfunction

function! s:SwitchProjectSink(dir) abort
    execute 'cd ' . $PROJECTS . '/' . a:dir
    let l:cwd = substitute(getcwd(), '\V\^' . $HOME . '/', '~/', '')
    echomsg 'Switched to ' . l:cwd
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

function! LintCode(...) abort range
    if exists('b:lint_command')
        let l:cmd = b:lint_command
    elseif &filetype is# 'sh'
        let l:cmd = 'shellcheck -'
    else
        let l:ft = empty(&filetype) ? '<no filetype>' : &filetype
        call s:Error('Unable to lint ' . l:ft . ' file')
        return
    endif
    let l:first = split(l:cmd)[0]
    if !executable(l:first)
        call s:Error('Executable not found: ' . l:first)
        return
    endif
    let l:range = get(a:, 1, a:firstline . ',' . a:lastline)
    execute l:range . 'w !' . l:cmd
endfunction

function! ToggleColumnLimit() abort
    if &tw is 0 || empty(&colorcolumn) || &colorcolumn is# '0'
        let &l:textwidth = get(b:, 'ColumnLimit', 80)
        setlocal colorcolumn=+1
    else
        setlocal textwidth=0 colorcolumn=0
    endif
endfunction

function! ToggleObsession() abort
    if empty(ObsessionStatus()) && argc() is 0 && &modified is 0
                \ && empty(v:this_session) && filereadable('Session.vim')
        source Session.vim
    else
        Obsession!
    endif
endfunction

function! OpenVimux(orientation) abort
    VimuxCloseRunner
    let g:VimuxOrientation = a:orientation
    call VimuxOpenRunner()
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

function! DisableSyntaxForDiff() abort
    if &diff is 1
        setlocal syntax=
    elseif empty(&syntax)
        let &l:filetype = &filetype
    endif
endfunction

