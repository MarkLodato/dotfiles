" --- Start of modules ---
call plug#begin('~/.vim/plugged')

Plug 'HerringtonDarkholme/yats.vim'
Plug 'Lokaltog/vim-easymotion'
Plug 'cespare/vim-toml'
Plug 'chrisbra/unicode.vim'
Plug 'danro/rename.vim'
Plug 'gerw/vim-HiLinkTrace'
Plug 'gutenye/json5.vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'inkarkat/vim-ReplaceWithRegister'
Plug 'kongo2002/fsharp-vim'
Plug 'ledger/vim-ledger'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-signify'
Plug 'nathangrigg/vim-beancount'
Plug 'niklasl/vim-rdf'
Plug 'ojroques/vim-oscyank'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'rhysd/conflict-marker.vim'
Plug 'rhysd/vim-gfm-syntax'
Plug 'thinca/vim-visualstar'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'tsandall/vim-rego'
Plug 'vim-jp/cpp-vim'
Plug 'vim-scripts/VisIncr'
Plug 'vim-scripts/a.vim'
Plug 'vim-scripts/svg.vim'

if !filereadable(expand('~/.at_google'))
  Plug 'google/vim-codefmt'
  Plug 'google/vim-glaive'
  Plug 'google/vim-maktaba'
endif

call plug#end()

if !filereadable(expand('~/.at_google'))
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
set ignorecase
set incsearch
set laststatus=2
set noautowrite
set noequalalways
set nofoldenable
set nojoinspaces
set nrformats-=octal
set ruler
set scrolloff=1
set shiftwidth=2
set showcmd
set sidescrolloff=5
set smartcase
set softtabstop=2
set splitright
set suffixes+=.pdf,.ps,.lo,.la
set suffixes-=.h
set tags+=~/.tags
set ttimeout
set ttimeoutlen=50  " timeout (in ms) for ESC-based keys
if !has('nvim')
  set undodir=~/.vim/undo
endif
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

" Enable 24-bit truecolor mode under tmux.
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors
colorscheme darkblue

" Increase default gui size to include the gutter and have more lines.
if has("gui_running")
  set columns=82
  set lines=50
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

" Digraphs
digraph vv 10003  " CHECK MARK (✓)
digraph VV 10004  " HEAVY CHECK MARK (✔)
digraph vV 9989   " WHITE HEAVY CHECK MARK (✅)
digraph xx 10007  " BALLOT X (✗)
digraph XX 10008  " HEAVY BALLOT X (✘)
digraph xX 10060  " CROSS MARK (❌)
digraph up 128077 " THUMBS UP (👍)
digraph dn 128078 " THUMBS UP (👎)

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

" ReplaceWithRegister
nmap grr grl

" visincr.vim
vmap <C-a> :I<CR>
vmap <C-x> :I -1<CR>

" unicode.vim
nnoremap ga :UnicodeName<CR>

" html.vim
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

" vim-markdown
let g:markdown_fenced_languages = [ 'bash', 'build=bzl', "c++=cpp", 'cpp', 'dot', 'html', 'javascript', 'json', 'jsonc=json5', 'json5', 'proto', 'python', 'sh', 'shell=bash', 'sql' ]
let g:gfm_syntax_highlight_issue_number = 0

" vim-visualstar
" Do not map S-LeftMouse, which affects highlighting in visual mode.
let g:visualstar_no_default_key_mappings = 1
silent! xmap <unique> * <Plug>(visualstar-*)
silent! xmap <unique> <kMultiply> <Plug>(visualstar-*)
silent! xmap <unique> # <Plug>(visualstar-#)
silent! xmap <unique> g* <Plug>(visualstar-g*)
silent! xmap <unique> g<kMultiply> <Plug>(visualstar-g*)
silent! xmap <unique> g# <Plug>(visualstar-g#)

" conflict-marker.vim
"let g:conflict_marker_highlight_group = ''
let g:conflict_marker_begin = '^<<<<<<< .*$'
let g:conflict_marker_common_ancestors = '^||||||| .*$'
let g:conflict_marker_end   = '^>>>>>>> .*$'
hi link ConflictMarkerOurs DiffAdd
hi link ConflictMarkerCommonAncestorsHunk DiffDelete
hi link ConflictMarkerTheirs DiffChange

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
vnoremap <C-y> :OSCYank<CR>
nmap <C-y> <Plug>OSCYank

" Automatically enable 'paste' when pasting from the terminal.
" https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" Put anything that shouldn't be sync'd to GitHub in the following file.
if filereadable($HOME.'/.vim/rc-private.vim')
  source ~/.vim/rc-private.vim
endif
