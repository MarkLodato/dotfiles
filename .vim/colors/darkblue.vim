" Vim color file
" Maintainer:   Bohdan Vlasyuk <bohdan@vstu.edu.ua>
" Modified by:  Mark Lodato <lodatom@gmail.com>
" Last Change:  2008 Jul 18

" darkblue -- for those who prefer dark background
" [note: looks bit uglier with come terminal palettes,
" but is fine on default linux console palette.]

set bg=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

let colors_name = "darkblue"

hi Normal       guifg=#c0c0c0   ctermfg=gray        guibg=#000040   ctermbg=black
hi ErrorMsg     guifg=#ffffff   ctermfg=white       guibg=#287eff   ctermbg=33
hi Visual       guibg=fg        ctermbg=fg          guibg=#8080ff   ctermbg=lightblue
hi VisualNOS    guibg=fg        ctermbg=fg          guibg=#8080ff   ctermbg=lightblue gui=underline cterm=underline
hi Todo         guifg=#d14a14   ctermfg=red         guibg=#1248d1   ctermbg=darkblue
hi Search       guifg=#90fff0   ctermfg=white       guibg=#2050d0   ctermbg=darkblue  cterm=underline term=underline
hi IncSearch    guifg=#b0ffff   ctermfg=darkblue    guibg=#2050d0   ctermbg=gray
hi SpellBad                                                         ctermbg=52

hi SpecialKey   guifg=#00ffff   ctermfg=cyan
hi Directory    guifg=#00ffff   ctermfg=darkcyan
hi Title        guifg=#ff00ff   ctermfg=magenta     gui=none cterm=bold
hi WarningMsg   guifg=#ff0000   ctermfg=red
hi WildMenu     guifg=#ffff00   ctermfg=yellow      guibg=#000000   ctermbg=black   cterm=none term=none
hi ModeMsg      guifg=#22cce2   ctermfg=lightblue
hi MoreMsg                      ctermfg=darkgreen
hi Question     guifg=#00ff00   ctermfg=green       gui=none cterm=none
hi NonText      guifg=#0030ff   ctermfg=darkblue

hi StatusLine   guifg=#0000ff   ctermfg=black       guibg=#a9a9a9   ctermbg=gray    gui=none cterm=none term=none
hi StatusLineNC guifg=#000000   ctermfg=none        guibg=#a9a9a9   ctermbg=240     gui=none cterm=none term=none
hi VertSplit    guifg=#000000   ctermfg=black       guibg=#a9a9a9   ctermbg=gray    gui=none cterm=none term=none

hi Folded       guifg=#808080   ctermfg=darkgrey    guibg=#000040   ctermbg=black   cterm=bold term=bold
hi FoldColumn   guifg=#808080   ctermfg=darkgrey    guibg=#000040   ctermbg=black   cterm=bold term=bold
hi LineNr       guifg=#90f020   ctermfg=green                                       cterm=none
hi SignColumn   guifg=#90f020   ctermfg=green       guibg=#000030   ctermbg=234     term=none
hi ColorColumn                                      guibg=#202050   ctermbg=234     term=none


hi DiffAdd                                          guibg=#00008b   ctermbg=darkblue term=none cterm=none
hi DiffChange                                       guibg=#8b008b   ctermbg=magenta  cterm=none
hi DiffDelete   guifg=#0000ff   ctermfg=blue        guibg=#008b8b   ctermbg=cyan     gui=bold
hi DiffText                                         guibg=#ff0000   ctermbg=red      gui=bold cterm=bold

hi Cursor       guifg=#000000   ctermfg=black       guibg=#ffff00   ctermbg=yellow
hi lCursor      guifg=#000000   ctermfg=black       guibg=#ffffff   ctermbg=white

hi Comment      guifg=#80a0ff   ctermfg=darkred
hi Constant     guifg=#ffa0a0   ctermfg=magenta     cterm=none
hi Special      guifg=#ffa500   ctermfg=brown       cterm=none gui=none
hi Identifier   guifg=#30c0c0   ctermfg=darkcyan    cterm=none
hi Statement    guifg=#ffff60   ctermfg=yellow      cterm=none gui=none
hi PreProc      guifg=#ff80ff   ctermfg=magenta     gui=none cterm=none
hi type         guifg=#60ff60   ctermfg=green       gui=none cterm=none
hi Underlined   cterm=underline term=underline
hi Ignore       guifg=bg        ctermfg=bg

hi Pmenu        guifg=#c0c0c0   ctermfg=145         guibg=#404080   ctermbg=60
hi PmenuSel     guifg=#c0c0c0   ctermfg=145         guibg=#2050d0   ctermbg=26
hi PmenuSbar    guifg=#0000ff   ctermfg=blue        guibg=#a9a9a9   ctermbg=darkgray
hi PmenuThumb   guifg=#c0c0c0   ctermfg=145
