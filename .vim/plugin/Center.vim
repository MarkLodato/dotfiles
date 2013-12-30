" Center text that includes an initial comment marker using "\c<dir>".
" Also, "\C<dir>" centers it and adds -------- markers above and below.
" Author: Mark Lodato <lodatom@gmail.com>

if exists("g:loaded_center") || v:version < 700
  finish
endif
let g:loaded_center = 1

let s:marker_list = '%(//|[ /]\*|[#%"])'
let s:box_char = '-'
let s:box_len = '76'

" Center
function! Center() range
  for s:line in range(a:firstline, a:lastline)
    let s:marker = substitute(getline(s:line),
      \ '^\v(\s*' . s:marker_list . ')?.*', '\1', '')
    silent execute s:line.'s_^\v\s*'.s:marker_list.'\s*(\S.*)_\1_e'
    silent execute s:line.'center'
    if len(s:marker) > 0
      silent execute s:line.'s_^ \{,'.len(s:marker).'} _'.s:marker.' _e'
    endif
  endfor
endfunction

function! CenterMap(type)
  '[,'] call Center()
endfunction

command! -range Center <line1>,<line2>call Center()

nnoremap <silent> <Leader>c :set opfunc=CenterMap<CR>g@
nmap <silent> <Leader>cc <Leader>c$
vnoremap <silent> <Leader>c :Center<CR>

" Center and add box (---'s above and below)
function! CenterBox() range
  silent execute a:firstline.','.a:lastline.'call Center()'
  silent execute 'normal ' . a:lastline . "Go\<ESC>cc// \<ESC>"
    \ . s:box_len . "a" . s:box_char . "\<ESC>"
  silent execute 'normal ' . a:firstline . "GO\<ESC>cc// \<ESC>"
    \ . s:box_len . "a" . s:box_char . "\<ESC>"
endfunction

function! CenterBoxMap(type)
  '[,'] call CenterBox()
endfunction

command! -range CenterBox <line1>,<line2>call CenterBox()

nnoremap <silent> <Leader>C :set opfunc=CenterBoxMap<CR>g@
nmap <silent> <Leader>CC <Leader>C$
nmap <silent> <Leader>Cc <Leader>C$
vnoremap <silent> <Leader>C :CenterBox<CR>
