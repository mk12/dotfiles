scriptencoding utf-8
set nocompatible
set shell=sh

" =========== Plugins ==========================================================

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
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

Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
Plug 'sheerun/vim-polyglot'
Plug 'sunaku/vim-shortcut', { 'on' : 'Shortcut' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wsdjeg/vim-fetch'

Plug 'tpope/vim-sensible'
filetype plugin indent on

call plug#end()

" =========== Options ==========================================================

set backup
set belloff=all
set cmdheight=2
set cursorline
set formatoptions-=t
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
set ruler
set showmode
set nostartofline
set number
set scrolloff=4
set shiftround
set showcmd
set sidescrolloff=4
set smartcase
set suffixes-=.h
set tagcase=match
set undofile
set visualbell
set wildmode=longest,full

" Only set these options on startup.
if has('vim_starting')
    set expandtab
    set hlsearch
    set shiftwidth=4
endif

let &directory = $HOME . '/.vim/tmp'
let &backupdir= $HOME . '/.vim/backup'
let &undodir = $HOME . '/.vim/undo'

if !isdirectory(&directory)
    call mkdir(&directory, 'p')
endif
if !isdirectory(&backupdir)
    call mkdir(&backupdir, 'p')
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, 'p')
endif

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

noremap ; :
noremap : ;

" Matches https://github.com/mk12/fish-fzf.
nnoremap <silent> <C-O> :call MyFzf('file')<CR>
nnoremap <silent> <C-Q> :call MyFzf('directory')<CR>
nnoremap <silent> <M-z> :call MyFzf('z')<CR>

" Top/bottom mappings compatible with less and emacs.
noremap <M-<> <C-Home>
noremap <M->> <C-End>
inoremap <M-<> <C-O><C-Home>
inoremap <M->> <C-O><C-End>

" Undo/redo compatible with fish.
nnoremap <M-\> u
noremap! <M-\> <C-O>u
nnoremap <M-/> <C-R>
noremap! <M-/> <C-O><C-R>

" Jump between open windows.
nnoremap <C-J> <C-W>w

nnoremap Y y$

" Stay in visual mode when indenting/dedenting.
xnoremap < <gv
xnoremap > >gv

" Use gv to select last selection, gV to select last insertion.
nnoremap gV `[v`]

" Jumping to the line number is more useful.
noremap gf gF
noremap gF gf

nnoremap <silent> & :&&<CR>
xnoremap <silent> & :&&<CR>

" Maintain register when pasting over something else.
xnoremap <expr> p VisualReplaceExpr()

" Use * in visual mode to search for the selection (then cgn and . to repeat).
xnoremap * y:let @/='\V'.escape(@", '\')<Bar>set hls<CR>

nnoremap <silent> zS :echo SyntaxName()<CR>

nnoremap <silent> <M-q> :call ReflowText()<CR>
xnoremap <M-q> gq
imap <M-q> <C-O><M-q>

nnoremap <silent> _ :Dirvish<CR>

nnoremap <silent> <Tab> :call NextBufOrTab()<CR>
nnoremap <silent> <S-Tab> :call PrevBufOrTab()<CR>

" Navigate backward and forward like in VS Code.
noremap <C--> <C-O>
inoremap <C--> <C-O><C-O>
noremap <C-S--> <C-I>
inoremap <C-S--> <C-O><C-I>

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

Shortcut toggle comment
    \ nnoremap <Leader>c :Commentary<CR>
    \|xnoremap <Leader>c :Commentary<CR>

Shortcut edit fish config
    \ nnoremap <Leader>ef :edit ~/.config/fish/config.fish<CR>
Shortcut edit fish config (local)
    \ nnoremap <Leader>eF :edit ~/.config/fish/local.fish<CR>
Shortcut delete hidden buffers
    \ nnoremap <Leader>eh :call DeleteHiddenBuffers()<CR>
Shortcut edit journal file
    \ nnoremap <expr> <Leader>ej ':edit $PROJECTS/journal/' . strftime("%Y") . '.md<CR>'
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

Shortcut find help
    \ nnoremap <Leader>h :Helptags<CR>

Shortcut kill/delete buffer
    \ nnoremap <silent> <leader>k :call KillBuffer('')<CR>
Shortcut force kill/delete buffer
    \ nnoremap <silent> <Leader>K :call KillBuffer('!')<CR>

Shortcut show number of search matches
    \ nnoremap <Leader>m :%s/<C-R>///n<CR>
    \|xnoremap <Leader>m y:%s/<C-R>"//n<CR>

Shortcut stop highlighting the search
    \ nnoremap <Leader>n :nohlsearch<CR>

Shortcut open in GUI editor
    \ nnoremap <Leader>o :call OpenInGuiEditor()<CR>

Shortcut quit
    \ nnoremap <Leader>q :quit<CR>
Shortcut force quit
    \ nnoremap <Leader>Q :quit!<CR>

Shortcut toggle 80-column marker
    \ nnoremap <Leader>t8 :call ToggleColumnLimit()<CR>
Shortcut toggle line numbers
    \ nnoremap <Leader>tn :set number!<CR>
Shortcut toggle paste mode
    \ nnoremap <Leader>tp :set paste!<CR>
Shortcut toggle spell checker
    \ nnoremap <Leader>ts :set spell!<CR>
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

Shortcut yank to system clipboard
    \ nnoremap <Leader>y :%y+<Bar>call YankToSystemClipboard(@+)<CR>
    \|xnoremap <Leader>y "+y:call YankToSystemClipboard(@+)<CR>

" =========== Autocommands =====================================================

augroup custom
    autocmd!

    autocmd FileType c,cpp setlocal commentstring=//\ %s comments^=:///
    autocmd FileType sql setlocal commentstring=--\ %s

    autocmd FileType * call SetTextWidthForFileType()

    " Fix it so that crontab -e can save properly.
    autocmd filetype crontab setlocal nobackup nowritebackup textwidth=0

    " Don't do syntax highlighting in diffs.
    autocmd BufEnter * call DisableSyntaxForDiff()
    autocmd OptionSet diff call DisableSyntaxForDiff()

    " Exit things with q.
    autocmd filetype help nnoremap <buffer> <silent> q :close<CR>
    autocmd filetype dirvish nmap <buffer> <silent> q <Plug>(dirvish_quit)

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

function! s:FinishFzf(temp, choice)
    call delete(a:temp)
    if !empty(a:choice)
        execute 'edit' a:choice
    endif
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
        \ 'exit': { code -> code == 0 ? 0 : s:FinishFzf(l:temp, "") },
        \ 'sink': { choice ->
        \   s:FinishFzf(l:temp, system(l:cts . 'finish', choice)) },
    \ }))
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

function! OpenInGuiEditor() abort
    let l:arg = expand('%p') . ':' . line('.') . ':' . col('.')
    execute '!fish -c "zed ''' . l:arg . '''"'
endfunction

function! ToggleColumnLimit() abort
    if &tw is 0 || empty(&colorcolumn) || &colorcolumn is# '0'
        let &l:textwidth = get(b:, 'ColumnLimit', 80)
        setlocal colorcolumn=+1
    else
        setlocal textwidth=0 colorcolumn=0
    endif
endfunction

" https://sunaku.github.io/tmux-yank-osc52.html
function! YankToSystemClipboard(text) abort
    let l:escape = system('yank', a:text)
    if v:shell_error
        echoerr l:escape
    elseif has('nvim')
        " https://github.com/neovim/neovim/issues/8450#issuecomment-402314394
        call chansend(v:stderr, l:escape)
    else
        call writefile([l:escape], '/dev/tty', 'b')
    endif
endfunction

function! SetTextWidthForFileType() abort
    " Check if someone else already set it, e.g. for gitcommit.
    if &l:textwidth != 0 && &filetype isnot# 'vim'
        setlocal colorcolumn=+1
        return
    endif
    if empty(&filetype) || &filetype is# 'text' || &filetype is# 'markdown'
        setlocal textwidth=0 colorcolumn=0
    elseif &filetype is# 'ledger'
        setlocal textwidth=0 colorcolumn=61,81,101,121
    else
        setlocal textwidth=80 colorcolumn=+1
    endif
endfunction

function! DisableSyntaxForDiff() abort
    if &diff is 1
        setlocal syntax=
    elseif empty(&syntax)
        let &l:filetype = &filetype
    endif
endfunction
