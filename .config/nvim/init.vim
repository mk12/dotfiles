set shell=sh

" =========== Plugins ==========================================================

if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

function! MyPlugin(name)
    let l:path = $PROJECTS . '/' . a:name
    if isdirectory(l:path)
        return l:path
    endif
    return 'mk12/' . a:name
endfunction

call plug#begin()

Plug MyPlugin('base16-vim')
Plug MyPlugin('vim-fish')

Plug 'Clavelito/indent-awk.vim'
Plug 'airblade/vim-gitgutter'
Plug 'benmills/vimux'
Plug 'glts/vim-textobj-comment'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/gv.vim'
Plug 'justinmk/vim-dirvish'
Plug 'kana/vim-textobj-user'
Plug 'ledger/vim-ledger'
Plug 'mbbill/undotree'
Plug 'sgur/vim-textobj-parameter'
Plug 'sheerun/vim-polyglot'
Plug 'sunaku/vim-shortcut', { 'on' : ['Shortcut', 'Shortcut!', 'Shortcuts'] }
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-commentary'
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
let g:airline_base16_improved_contrast = 1
let g:airline_base16_monotone = 1
let g:airline_extensions = ['tabline']
let g:airline_highlighting_cache = 1
let g:airline_theme = 'base16_vim'

let g:dispatch_no_maps = 1

let g:gitgutter_map_keys = 0

let g:polyglot_disabled = ['fish']

let g:VimuxPromptString = "Vimux: "
let g:VimuxHeight = "30"

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

" Avoid highlighting searches when reloading vimrc.
nohlsearch

if !exists('g:loaded_sleuth')
    set expandtab
    set shiftwidth=4
endif

let &backupdir = $HOME . '/.local/share/nvim/backup'
if !isdirectory(&backupdir)
    call mkdir(&backupdir, 'p')
endif

" =========== Color scheme =====================================================

" I use terminal colors so that I can swap base16 themes and have everything
" update immediately. That doesn't work with hardcoded 24-bit color.
if has('termguicolors')
    set notermguicolors
end

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

" Jump between open windows.
nnoremap <C-J> <C-W>w

nnoremap Y y$

" Stay in visual mode when indenting/dedenting.
xnoremap < <gv
xnoremap > >gv

" Use gv to select last selection, gV to select last insertion.
nnoremap gV `[v`]

inoremap <C-U> <C-G>u<C-U>

" Use C-N and C-P to keep search results centred.
nnoremap <C-N> nzz
nnoremap <C-P> Nzz

nnoremap <silent> & :&&<CR>
xnoremap <silent> & :&&<CR>

" Maintain register when pasting over something else.
xnoremap <expr> p VisualReplaceExpr()

nnoremap <silent> zS :echo SyntaxName()<CR>

nnoremap <silent> Q :call ReflowText()<CR>
xnoremap Q gq

nnoremap <silent> _ :Dirvish<CR>

nnoremap <silent> <Tab> :call NextBufOrTab()<CR>
nnoremap <silent> <S-Tab> :call PrevBufOrTab()<CR>

" Since <Tab> and <C-I> are the same, I need a new mapping for <C-I>.
nnoremap <C-Q> <C-I>

nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" Emacs style bindings. In concert with kitty config, this provides C-A and
" Cmd-Left, C-E and Cmd-Right, C-U and Cmd-Backspace, C-K and Cmd-Delete,
" Alt-Left and Alt-Right (like b and el), Alt-Shift-Left and Alt-Shift-Right
" (like B and El), Alt-Backspace and Alt-Delete (like db and de), and
" Alt-Shift-Backspace and Alt-Shift-Delete (like dB and dE).
noremap <C-A> <Home>
noremap! <C-A> <Home>
noremap <C-E> <End>
noremap! <C-E> <End>
inoremap <expr> <C-K> col('.') is col('$') ? '' : '<C-O>D'
cnoremap <C-K> <C-\>e getcmdpos() is 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
noremap <M-Left> b
inoremap <M-Left> <C-O>b
cnoremap <M-Left> <C-\>e CmdLineNavigate('b')<CR>
noremap <expr> <M-Right> col('.') is 1
    \ ? 'wge<Right>'
    \ : col('.') is col('$') - 1 ? 'e<Right>' : '<Left>e<Right>'
inoremap <expr> <M-Right> col('.') is 1
    \ ? '<C-O>w<C-O>ge<Right>'
    \ : '<Left><C-O>e<Right>'
cnoremap <M-Right> <C-\>e CmdLineNavigate('e')<CR>
noremap <M-S-Left> B
inoremap <M-S-Left> <C-O>B
" We could just use <C-Left>, but it doesn't skip over multiple spaces.
cnoremap <M-S-Left> <C-\>e CmdLineNavigate('B')<CR>
noremap <expr> <M-S-Right> col('.') is 1
    \ ? 'WgE<Right>'
    \ : col('.') is col('$') - 1 ? 'E<Right>' : '<Left>E<Right>'
inoremap <expr> <M-S-Right> col('.') is 1
    \ ? '<C-O>W<C-O>gE<Right>'
    \ : '<Left><C-O>E<Right>'
" We could just use <C-Right>, but it doesn't skip over multiple spaces.
cnoremap <M-S-Right> <C-\>e CmdLineNavigate('E')<CR>
noremap! <M-BS> <C-W>
inoremap <M-Del> <C-O>de
cnoremap <M-Del> <C-\>e CmdLineDelete('e')<CR>
inoremap <M-B> x<C-O>dB<BS>
cnoremap <M-B> <C-\>e CmdLineDelete('B')<CR>
inoremap <M-S-Del> <C-O>dE
cnoremap <M-S-Del> <C-\>e CmdLineDelete('E')<CR>

" New mapping for <C-E> scroll down.
nnoremap <C-H> <C-E>

" VS Code style bindings. a-b a b
nmap <M-Up> [e
xmap <M-Up> [egv
imap <M-Up> <C-O>[e
nmap <M-Down> ]e
xmap <M-Down> ]egv
imap <M-Down> <C-O>]e
nnoremap <M-S-Up> "zyyP
nnoremap <M-S-Down> "zyyp
xnoremap <M-S-Up> "zy`>pgv
xnoremap <M-S-Down> "zyPgv
inoremap <M-S-Up> <C-O>"zyy<C-O>P
inoremap <M-S-Down> <C-O>"zyy<C-O>p

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

Shortcut fix mouse after terminal reset
    \ nnoremap <Leader>da :set mouse=<Bar>set mouse=a<CR>
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

Shortcut edit fish config
    \ nnoremap <Leader>ef :edit ~/.config/fish/config.fish<CR>
Shortcut edit fish config (local)
    \ nnoremap <Leader>eF :edit ~/.config/fish/local.fish<CR>
Shortcut delete hidden buffers
    \ nnoremap <Leader>eh :call DeleteHiddenBuffers()<CR>
Shortcut edit journal file
    \ nnoremap <Leader>ej :edit ~/ia/Journal/Journal.txt<CR>
Shortcut resolve symlinks
    \ nnoremap <Leader>el :call ResolveSymlinks()<CR>
Shortcut edit new buffer
    \ nnoremap <Leader>en :enew<CR>
Shortcut reload current buffer
    \ nnoremap <Leader>er :edit!<CR>
Shortcut edit shell config
    \ nnoremap <Leader>es :edit ~/.profile<CR>
Shortcut edit shell config (local)
    \ nnoremap <Leader>eS :edit ~/.profile.local<CR>
Shortcut edit vimrc or init.vim
    \ nnoremap <Leader>ev :edit $MYVIMRC<CR>

Shortcut format code
    \ nnoremap <Leader>f :call FormatCode('%')<CR>
    \|xnoremap <Leader>f :call FormatCode()<CR>

Shortcut git blame
    \ nnoremap <Leader>gb :Gblame<CR>
Shortcut git diff
    \ nnoremap <Leader>gd :Gtabedit! diff<CR>
Shortcut git diff current file
    \ nnoremap <Leader>gD :Gdiff<CR>
Shortcut git status
    \ nnoremap <Leader>gg :Gstatus<CR>
Shortcut browse on GitHub
    \ nnoremap <Leader>gh :Gbrowse<CR>
Shortcut git diff staged/cached/index
    \ nnoremap <Leader>gi :Gtabedit! diff --staged<CR>
Shortcut git diff staged/cached/index current file
    \ nnoremap <Leader>gI :Gtabedit @:%<Bar>Gdiff :<CR>
Shortcut git log
    \ nnoremap <Leader>gl :GV<CR>
    \|xnoremap <Leader>gl :GV<CR>
Shortcut git log current file
    \ nnoremap <Leader>gL :GV!<CR>
Shortcut git push
    \ nnoremap <Leader>gp :Gpush<CR>
Shortcut git show HEAD
    \ nnoremap <Leader>gs :Gtabedit! show<CR>
Shortcut git show HEAD current file
    \ nnoremap <Leader>gS :Gtabedit @~:%<Bar>Gdiff @<CR>
Shortcut git update/pull
    \ nnoremap <Leader>gu :Gpull<CR>
Shortcut git update/pull (autostash)
    \ nnoremap <Leader>gU :Gpull --autostash<CR>

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
Shortcut jump to command history
    \ nnoremap <Leader>jr :History:<CR>
Shortcut jump to tag
    \ nnoremap <Leader>jt :call BrowseTags()<CR>
Shortcut jump to tag in buffer
    \ nnoremap <Leader>jT :BTags<CR>
Shortcut jump to search history
    \ nnoremap <Leader>j/ :History/<CR>

Shortcut kill/delete buffer
    \ nnoremap <silent> <leader>k :call KillBuffer('')<CR>
Shortcut force kill/delete buffer
    \ nnoremap <silent> <Leader>K :call KillBuffer('!')<CR>

Shortcut lint code
    \ nnoremap <silent> <Leader>l :call LintCode('%')<CR>
    \|xnoremap <silent> <Leader>l :call LintCode()<CR>

Shortcut open console
    \ nnoremap <Leader>mc :Console<CR>
Shortcut open console in background
    \ nnoremap <Leader>mC :Console!<CR>
Shortcut dispatch default task
    \ nnoremap <Leader>md :Dispatch<CR>
Shortcut dispatch default task in background
    \ nnoremap <Leader>mD :Dispatch!<CR>
Shortcut select default dispatch task
    \ nnoremap <Leader>mf :FocusDispatch<Space>
Shortcut clear default dispatch task
    \ nnoremap <Leader>mF :FocusDispatch<CR>
Shortcut make/build project
    \ nnoremap <Leader>mm :Make<CR>
Shortcut make/build project in background
    \ nnoremap <Leader>mM :Make!<CR>
Shortcut open build results
    \ nnoremap <Leader>mo :Copen<CR>
Shortcut open catch-all build results
    \ nnoremap <Leader>mO :Copen<CR>
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

    autocmd User ProjectionistActivate call LoadCustomProjections()

    autocmd FileType c,cpp setlocal commentstring=//\ %s comments^=:///
    autocmd FileType sql setlocal commentstring=--\ %s

    autocmd FileType text,markdown setlocal textwidth=0 colorcolumn=0
    autocmd FileType ledger setlocal textwidth=0 colorcolumn=61,81

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

    " Exit help window with q.
    autocmd filetype help nnoremap <buffer> <silent> q :close<cr>

    " Exit dirvish with q.
    autocmd filetype dirvish nmap <buffer> <silent> q <Plug>(dirvish_quit)

    " Exit fugitive windows consistently with q.
    autocmd BufEnter fugitive://*//* nnoremap <buffer> <silent> q :bdelete<CR>

    " Recognize my .profile.local file.
    autocmd BufNewFile,BufRead .profile.local setfiletype sh

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

function! s:CmdLineIndex(char) abort
    let l:cmd = getcmdline()
    if a:char is? 'B'
        let l:i = getcmdpos() - 1
        while l:i > 0
            let l:i = l:i - 1
            if match(l:cmd[l:i], '\s') is -1
                break
            endif
        endwhile
        if a:char is# 'B'
            while l:i > 0 && match(l:cmd[l:i - 1], '\s') is -1
                let l:i = l:i - 1
            endwhile
        else
            if match(l:cmd[l:i], '\k') isnot -1
                while l:i > 0 && match(l:cmd[l:i - 1], '\k') isnot -1
                    let l:i = l:i - 1
                endwhile
            else
                while l:i > 0 && match(l:cmd[l:i - 1], '\k\|\s') is -1
                    let l:i = l:i - 1
                endwhile
            endif
        endif
    elseif a:char is? 'E'
        let l:i = getcmdpos() - 1
        let l:max = len(l:cmd) - 1
        while l:i < l:max && match(l:cmd[l:i], '\s') isnot -1
            let l:i = l:i + 1
        endwhile
        if a:char is# 'E'
            while l:i < l:max + 1
                let l:i = l:i + 1
                if l:i == l:max + 1 || match(l:cmd[l:i], '\s') isnot -1
                    break
                endif
            endwhile
        else
            if match(l:cmd[l:i], '\k') isnot -1
                while l:i <= l:max
                    let l:i = l:i + 1
                    if l:i == l:max + 1 || match(l:cmd[l:i], '\k') is -1
                        break
                    endif
                endwhile
            else
                while l:i <= l:max
                    let l:i = l:i + 1
                    if l:i == l:max + 1 || match(l:cmd[l:i], '\k\|\s') isnot -1
                        break
                    endif
                endwhile
            endif
        endif
    else
        call s:Error("Invalid CmdLineIndex arg: " . a:char)
    end
    return l:i + 1
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

function! CmdLineNavigate(char) abort
    call setcmdpos(s:CmdLineIndex(a:char))
    return getcmdline()
endfunction

function! CmdLineDelete(char) abort
    let l:cmd = getcmdline()
    let l:i = getcmdpos() - 1
    let l:j = s:CmdLineIndex(a:char) - 1
    if a:char is? 'B'
        return (l:j is 0 ? '' : l:cmd[:l:j-1]) . l:cmd[l:i:]
    endif
    if a:char is? 'E'
        return (l:i is 0 ? '' : l:cmd[:l:i-1]) . l:cmd[l:j:]
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

function! GenerateTags() abort
    call s:Warning('Preparing tags')
    call system(get(b:, 'tags_command', 'ctags -R'))
    if empty(tagfiles())
        call s:Error('Failed to create tags')
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
