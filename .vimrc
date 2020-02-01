" --- Start of modules ---
call plug#begin('~/.vim/plugged')

"Plug 'tpope/vim-markdown'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'Lokaltog/vim-easymotion'
Plug 'MarkLodato/vim-markdown'  " until tpope pulls the changes
Plug 'VisIncr'
Plug 'a.vim'
Plug 'cespare/vim-toml'
Plug 'danro/rename.vim'
Plug 'gerw/vim-HiLinkTrace'
Plug 'hynek/vim-python-pep8-indent'
Plug 'kongo2002/fsharp-vim'
Plug 'ledger/vim-ledger'
Plug 'mhinz/vim-signify'
Plug 'nathangrigg/vim-beancount'
Plug 'niklasl/vim-rdf'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'sjl/gundo.vim'
Plug 'thinca/vim-visualstar'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-jp/cpp-vim'
Plug 'vim-scripts/svg.vim'

if !filereadable(expand('~/.at_google'))
  Plug 'google/vim-codefmt'
  Plug 'google/vim-glaive'
  Plug 'google/vim-maktaba'
endif

call plug#end()
if exists("glaive#Install")
  call glaive#Install()
endif
" --- End of modules ---

" General options
set nocompatible
set autoindent
set autoread
set backspace=indent,eol,start
set colorcolumn=+1
set display+=lastline
set expandtab
set formatoptions=tcqj
set guioptions-=L
set guioptions-=T
set guioptions-=m
set guioptions-=r
set history=5000
set hlsearch
set incsearch
set laststatus=2
set noautowrite
set noequalalways
set nrformats-=octal
set ruler
set scrolloff=1
set shiftwidth=2
set showcmd
set sidescrolloff=5
set softtabstop=2
set suffixes+=.pdf,.ps,.lo,.la
set suffixes-=.h
set tags+=~/.tags
set ttimeout
set ttimeoutlen=50  " timeout (in ms) for ESC-based keys
set undodir=~/.vim/undo
set undofile
set viminfo='100,/100,:100,@10,h,s10
set wildmenu
set winaltkeys=no
set textwidth=80
set cinoptions+=g0(0t0p0

syntax on

" Increase sync backwards search for files that often mess up.
autocmd Syntax markdown syntax sync fromstart

if has('autocmd')
  filetype plugin indent on
endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=16
endif

" Conditional options
if has("mouse")
  set mouse=a
  set mousemodel=popup
endif
if v:version >= 700
  set spelllang=en_us
endif

" Plugins
runtime ftplugin/man.vim
runtime macros/matchit.vim

" Restore cursor position when opening a file, except for git commit messages.
function! ResCur()
  if line("'\"") <= line("$") && &filetype != "gitcommit"
    normal! g`"
    return 1
  endif
endfunction
augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" Fix encoding issues.
if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

" Show marker for tabs, and highlight spaces before tabs and at EOL
set list
set listchars=tab:»\ ,nbsp:␣
hi default link WhiteSpaceError Error
match WhiteSpaceError /\(\s\+\%#\@!$\)\|\( \+\ze\t\)/

if has("gui_running") || &t_Co >= 8
  "colorscheme midnight2
  colorscheme darkblue
  " guifont?
else
  set background=dark
endif

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

" Change default behavior of some keys
noremap <Leader>q Q
noremap <Leader>Q gQ
noremap gQ gq
noremap Q gq
noremap Y y$

" Remove annoying keys
map! <C-?> <BS>
nnoremap <F1> <nop>
inoremap <F1> <nop>
vnoremap K k
nnoremap K k
vnoremap <Leader>K K
nnoremap <Leader>K K
vnoremap J j
vnoremap <Leader>J J

" Some useful mappings
map <Leader>m :make<cr>
cnoremap <A-p> <Up>
cnoremap <A-n> <Down>

" Emacs bindings
inoremap <C-a> <Home>
cnoremap <C-a> <Home>
inoremap <C-e> <End>
cnoremap <C-e> <End>
inoremap <A-w> <C-o>w
inoremap <A-W> <C-o>W
inoremap <A-b> <C-o>b
inoremap <A-B> <C-o>B
inoremap <A-BS> x<C-o>dB<C-o>x

" Vi command-mode bindings for insert mode
inoremap <C-t> <C-o>t
inoremap <C-f> <C-o>t
inoremap <A-t> <C-o>t
inoremap <C-t> <C-o>t

" Map \vs to split vertically and scrollbind.
" Source: http://vim.wikia.com/wiki/View_text_file_in_two_columns
noremap <silent> <Leader>vs :<C-u>let @z=&so<CR>:set so=0 noscb<CR>:bo
      \ vs<CR>Ljzt:setl scb<CR><C-w>p:setl scb<CR>:let &so=@z<CR>

" Map \s<motion> to :sort that area, and \ss to :sort in the paragraph.
function! SortMap(type) range
  '[,']sort
endfunction
nnoremap <Leader>s :set opfunc=SortMap<CR>g@
nmap <Leader>ss <Leader>sip
vnoremap <Leader>s :sort<CR>

" Create the window that I like
let g:big_window_signify=1
function! BigWindow()
  top vsplit
  set lines=86
  if g:big_window_signify
    set columns=165
    SignifyEnable
  else
    set columns=161
  endif
  execute "normal \<C-w>="
endfunction
command! BigWindow call BigWindow()

" Syntax file options
let c_gnu=1

" Useful functions
function! ReverseLineOrder() range
  let lnum = a:firstline
  for line in reverse(getline(a:firstline, a:lastline))
    call setline(lnum, line)
    let lnum = lnum+1
  endfor
endfunction
command! -range=% -bar ReverseLineOrder <line1>,<line2>call ReverseLineOrder()

" a.vim
let g:alternateNoDefaultAlternate = 1
let g:alternateRelativeFiles = 1

" visincr.vim
vmap <C-a> :I<CR>
vmap <C-x> :I -1<CR>

" html.vim
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

" vim-visualstar
" Do not map S-LeftMouse, which affects highlighting in visual mode.
let g:visualstar_no_default_key_mappings = 1
silent! xmap <unique> * <Plug>(visualstar-*)
silent! xmap <unique> <kMultiply> <Plug>(visualstar-*)
silent! xmap <unique> # <Plug>(visualstar-#)
silent! xmap <unique> g* <Plug>(visualstar-g*)
silent! xmap <unique> g<kMultiply> <Plug>(visualstar-g*)
silent! xmap <unique> g# <Plug>(visualstar-g#)

" signify.vim
hi SignifyLineAdd    guibg=#002040
hi SignifyLineChange guibg=#101040
hi SignifyLineDelete guibg=#100040
hi link SignifyLineChangeDelete    SignifyLineChange
hi link SignifyLineDeleteFirstLine SignifyLineDelete
hi SignifySignAdd    guifg=#009900 guibg=#000030 ctermfg=2 ctermbg=234
hi SignifySignChange guifg=#bbbb00 guibg=#000030 ctermfg=3 ctermbg=234
hi SignifySignDelete guifg=#ff2222 guibg=#000030 ctermfg=1 ctermbg=234
function! SignifyGitDiffBase(diffbase)
  let g:signify_vcs_cmds['git'] = 'git diff --no-color --no-ext-diff -U0 ' .
        \ a:diffbase . ' -- %f'
  if exists(':SignifyRefresh')
    execute 'SignifyRefresh'
  endif
endfunction
if !exists('g:signify_vcs_cmds')
  let g:signify_vcs_cmds = {}
endif
let g:signify_vcs_list = ['git']
let g:signify_sign_change = '~'
let g:signify_sign_changedelete = '~_'
let g:signify_sign_show_count = 0
nnoremap <Leader>gg :SignifyToggle<CR>
nnoremap <Leader>gl :SignifyToggleHighlight<CR>
nnoremap <Leader>gr :SignifyRefresh<CR>
nnoremap <Leader>gh :call SignifyGitDiffBase('HEAD')<CR>
nnoremap <Leader>gu :call SignifyGitDiffBase('@{upstream}')<CR>
nnoremap <Leader>gi :call SignifyGitDiffBase('')<CR>

" Allow % (matchit.vim) to work with merge conflict markers.
" This is simplified from rhysd/conflict_marker.vim.
" Unfortunately, due to b:match_skip, this will fail if the conflict marker is
" inside a multi-line string or comment.
function! s:add_conflict_markers_to_match_words()
  let l:conflict_words = '^<<<<<<<.*:^\%(|||||||\|=======\).*:^>>>>>>>.*'
  if exists('b:match_words')
    let b:match_words = b:match_words . ',' . l:conflict_words

    " c.vim stupidly sets match_words to contain 'matchpairs', which doesn't
    " work properly and causes our pattern to break for some unknown reason.
    " matchit.vim already honors 'matchpairs', so we should strip it off.
    if b:match_words[:strlen(&matchpairs)] == &matchpairs . ','
      let b:match_words = b:match_words[strlen(&matchpairs)+1:]
    endif
  else
    let b:match_words = l:conflict_words
  endif
endfunction
augroup ConflictMarkers
  autocmd!
  autocmd BufReadPost * call s:add_conflict_markers_to_match_words()
augroup END

" Allow % to work with <>'s in C++.
autocmd FileType cpp set matchpairs+=<:>

" Do not wrap fstab files.
autocmd FileType fstab setlocal textwidth=0

" EasyMotion:
map gs <Plug>(easymotion-s2)
let g:EasyMotion_smartcase = 1

" vim-codefmt:
nnoremap <Leader>f :set opfunc=codefmt#FormatMap<CR>g@
nnoremap <Leader>ff :FormatLines<CR>
nnoremap <Leader>fb :FormatCode<CR>
vnoremap <Leader>f :FormatLines<CR>

" CTRL-Y = yank to clipboard
" Source: https://sunaku.github.io/tmux-yank-osc52.html
if exists('$TMUX')
  " copy to attached terminal using the yank(1) script:
  " https://github.com/sunaku/home/blob/master/bin/yank
  noremap <silent> <C-y> y:call system('yank > /dev/tty', @0)<Return>
else
  noremap <C-y> "+y
endif

" Put anything that shouldn't be sync'd to GitHub in the following file.
if filereadable($HOME.'/.vim/rc-private.vim')
  source ~/.vim/rc-private.vim
endif
