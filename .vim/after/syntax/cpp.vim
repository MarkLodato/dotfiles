" Vim syntax file
"
" This file adds C++11 support to cpp.vim,
" put it in ~/.vim/after/syntax/cpp.vim

" C++11 extensions
syn keyword cppType		final constexpr
syn keyword cppExceptions	noexcept
syn keyword cppOperator		decltype
syn keyword cppStorageClass	thread_local
syn keyword cppConstant		nullptr

" A raw-string looks like R"d(...)d" where d is a (possibly empty) sequence of
" A-Z a-z 0-9 _ { } [ ] # < > % : ; . ? * + - / ^ & | ~ ! = , " '
syn region cppRawString  matchgroup=cppRawDelim start=+R"\z([A-Za-z0-9_{}[\]#<>%:;.?*+\-/\^&|~!=,"']\{,16\}\)(+ end=+)\z1"+ contains=@Spell

" Default highlighting
if version >= 508 || !exists("did_cpp11_syntax_inits")
  if version < 508
    let did_cpp11_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink cppConstant		Constant
  HiLink cppRawDelim		cFormat
  HiLink cppRawString		String
  delcommand HiLink
endif

" vim: ts=8 noet

