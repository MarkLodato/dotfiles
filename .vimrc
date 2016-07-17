" Vundle - all of the following is required
set nocompatible
filetype off
if isdirectory(expand("~/.vim/bundle/vundle/"))
  set rtp+=~/.vim/bundle/vundle/
  call vundle#begin()
  Plugin 'gmarik/vundle'

  " Bundles
  Plugin 'Lokaltog/vim-easymotion'
  Plugin 'VisIncr'
  Plugin 'a.vim'
  Plugin 'airblade/vim-gitgutter'
  Plugin 'danro/rename.vim'
  Plugin 'gerw/vim-HiLinkTrace'
  Plugin 'google/vim-codefmt'
  Plugin 'google/vim-glaive'
  Plugin 'google/vim-maktaba'
  Plugin 'hynek/vim-python-pep8-indent'
  Plugin 'othree/html5.vim'
  Plugin 'pangloss/vim-javascript'
  Plugin 'sjl/gundo.vim'
  Plugin 'vim-jp/cpp-vim'
  Plugin 'thinca/vim-visualstar'
  Plugin 'tpope/vim-abolish'
  Plugin 'tpope/vim-characterize'
  Plugin 'tpope/vim-commentary'
  Plugin 'tpope/vim-fugitive'
  Plugin 'tpope/vim-git'
  Plugin 'tpope/vim-liquid'
  "Plugin 'tpope/vim-markdown'
  Plugin 'MarkLodato/vim-markdown'  " until tpope pulls the changes
  Plugin 'tpope/vim-repeat'
  Plugin 'tpope/vim-rsi'
  Plugin 'tpope/vim-surround'
  Plugin 'tpope/vim-unimpaired'
  Plugin 'vim-scripts/svg.vim'
  " Consider installing conque (which i don't think is Vundle-compatible)

  " Bundles that are nice but that I don't need anymore:
  "Plugin 'scrooloose/nerdcommenter'  " vim-commentary is good enough

  call vundle#end()
  if exists("glaive#Install")
    call glaive#Install()
  endif
endif  " vundle directory exists

" General options
set autoindent
set autoread
set backspace=indent,eol,start
set colorcolumn=+1
set display+=lastline
set expandtab
set formatoptions=tcq1
set guioptions-=T
set guioptions-=m
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
set smarttab
set suffixes+=.pdf,.ps,.lo,.la
set suffixes-=.h
set tags+=~/.tags
set ttimeout
set ttimeoutlen=50  " timeout (in ms) for ESC-based keys
set undodir=~/.vim/undo
set undofile
set viminfo='100,<500,s10,h
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
let g:big_window_gitgutter=1
function! BigWindow()
  top vsplit
  set lines=90
  if g:big_window_gitgutter
    set columns=165
    GitGutterEnable
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

" gitgutter.vim
" The default styles link to diff styles, which are too bright for me.
hi GitGutterAddLine    guibg=#002040
hi GitGutterChangeLine guibg=#101040
hi GitGutterDeleteLine guibg=#100040
hi link GitGutterChangeDeleteLine GitGutterChangeLine
let g:gitgutter_enabled = 0
let g:gitgutter_escape_grep = 1
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 2000
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_sign_column_always = 1
let g:gitgutter_diff_base = 'HEAD'
nnoremap <Leader>gg :GitGutterToggle<CR>
nnoremap <Leader>gl :GitGutterLineHighlightsToggle<CR>
nnoremap <Leader>gn :GitGutterNextHunk<CR>
nnoremap <Leader>gp :GitGutterPrevHunk<CR>
nnoremap <Leader>gu :GitGutterAll<CR>
" Toggle the diff base.
nnoremap <Leader>gh :let g:gitgutter_diff_base='HEAD'<CR>
nnoremap <Leader>gi :let g:gitgutter_diff_base=''<CR>

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

" EasyMotion:
map gs <Plug>(easymotion-s2)
let g:EasyMotion_smartcase = 1

" vim-codefmt:
nnoremap <Leader>f :set opfunc=codefmt#FormatMap<CR>g@
nnoremap <Leader>ff :FormatLines<CR>
nnoremap <Leader>fb :FormatCode<CR>
vnoremap <Leader>f :FormatLines<CR>

" Put anything that shouldn't be sync'd to GitHub in the following file.
if filereadable($HOME.'/.vim/rc-private.vim')
  source ~/.vim/rc-private.vim
endif
