"%% SiSU Vim color file
" SoS Maintainer: sohorx
" (originally looked at slate)
set background=dark
highlight clear
set t_Co=16
if version > 580
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let colors_name = "sos"
hi Vertsplit       ctermbg=none     ctermfg=darkgrey    cterm=none 
hi Folded          ctermbg=none     ctermfg=darkgray    term=bold cterm=bold
hi FoldColumn      ctermbg=NONE     ctermfg=darkgrey 
hi IncSearch       ctermbg=green    ctermfg=yellow      cterm=none 
hi ModeMsg                          ctermfg=brown       cterm=none 
hi MoreMsg                          ctermfg=darkgreen
hi NonText                          ctermfg=darkgray    cterm=bold
hi Question                         ctermfg=green
hi Search          ctermbg=darkblue ctermfg=white       cterm=bold 
hi SpecialKey                       ctermfg=darkgray
hi StatusLine      ctermbg=none     ctermfg=darkgrey    cterm=none 
hi StatusLineNC    ctermbg=none     ctermfg=darkgrey    cterm=none 
hi Title                            ctermfg=yellow      cterm=bold
hi Statement                        ctermfg=lightblue
hi Visual                           ctermfg=white       cterm=reverse 
hi WarningMsg                       ctermfg=1
hi String                           ctermfg=darkgreen
hi Comment                          ctermfg=darkgrey    term=bold 
hi Constant                         ctermfg=red
hi Special                          ctermfg=yellow
hi Identifier                       ctermfg=red
hi Include                          ctermfg=red
hi PreProc                          ctermfg=red
hi Operator                         ctermfg=Red
hi Define                           ctermfg=yellow
hi type                             ctermfg=brown
hi Function                         ctermfg=darkblue
hi Structure                        ctermfg=green
hi LineNr          ctermbg=none     ctermfg=darkgrey
hi Ignore                           ctermfg=7           cterm=bold
hi Directory                        ctermfg=darkred
hi ErrorMsg        ctermbg=1        ctermfg=7           cterm=bold 
hi VisualNOS                                            cterm=bold,underline
hi WildMenu        ctermbg=3        ctermfg=0
hi Underlined                       ctermfg=darkmagenta cterm=underline 
hi Error           ctermbg=darkred  ctermfg=gray        cterm=bold  
hi CursorLine      ctermbg=black                        cterm=none
hi CursorColumn    ctermbg=black                        cterm=none
hi CursorLineNr    ctermbg=none     ctermfg=red
hi TabLineFill     ctermbg=none     ctermfg=darkgrey    cterm=none
hi TabLineSel      ctermbg=white    ctermfg=black       cterm=none
hi TabLine         ctermbg=none     ctermfg=darkgrey    cterm=none
hi ColorColumn     ctermbg=black
hi SignColumn      ctermbg=none     term=none
hi Number               ctermfg=red
" Diff:
hi DiffAdd         ctermbg=4
hi DiffChange      ctermbg=5
hi DiffDelete      cterm=bold ctermfg=4 ctermbg=6
hi DiffText        cterm=bold ctermbg=1
" User:
hi User3           ctermbg=none ctermfg=darkgreen term=none cterm=none
hi User2           ctermbg=none ctermfg=grey      term=bold cterm=bold
hi User5           ctermbg=none ctermfg=red       term=bold cterm=bold
hi User6           ctermbg=none ctermfg=darkred   term=none cterm=none
" Syntastic:
hi SyntasticWarningSign    ctermbg=none ctermfg=darkyellow
hi SyntasticErrorSign      ctermbg=none ctermfg=darkred
" Spell:
hi SpellErrors          ctermbg=darkred     ctermfg=gray  cterm=bold  
hi SpellBad             ctermfg=red         ctermbg=none  cterm=underline,bold
hi SpellCap             ctermfg=brown       ctermbg=none  cterm=underline,bold
hi SpellLocal           ctermfg=cyan        ctermbg=none  cterm=underline,bold
"   C:
hi cconstant            ctermfg=darkred
hi cInclude             ctermfg=darkmagenta
hi cnumber              ctermfg=red
hi cSpecial             ctermfg=lightgreen
hi cStorageClass        ctermfg=yellow
hi cOperator            ctermfg=darkred
hi cStatement           ctermfg=darkblue
hi cFormat              ctermfg=lightgreen
hi cdefine              ctermfg=magenta
hi cprecondit           ctermfg=magenta
hi cCharacter           ctermfg=red
hi cCustomClass         ctermfg=darkmagenta
"   CPP:
hi cppSTLnamespace      ctermfg=magenta
hi cppStatement         ctermfg=white
"   Python:
hi pythonNumber         ctermfg=red
hi pythonBuiltin        ctermfg=darkred
"   NerdTree:
hi NERDTreeExecFile     ctermfg=darkgreen
hi NERDTreeDir          ctermfg=darkred
hi NERDTreeDirSlash     ctermfg=white
hi NERDTreeLink         ctermfg=magenta
hi NERDTreeHelp         ctermfg=darkgrey
hi NERDTreeCWD          ctermfg=red
"   Ctags:
hi CTagsMember          ctermfg=white
hi CTagsDefinedName     ctermfg=darkred
hi CTagsGlobalVariable  ctermfg=yellow
hi MyTagListTitle       ctermfg=darkmagenta
hi MyTagListFileName    ctermfg=blue
"   Javascript:
hi javaScriptNumber     ctermfg=red
"   Haskell:
hi haskellIdentifier    ctermfg=darkmagenta
hi hsModuleName         ctermfg=darkmagenta 
hi hs_DeclareFunction   ctermfg=darkmagenta
hi hsTypedef            ctermfg=magenta
hi hsType               ctermfg=brown
hi haskellType          ctermfg=brown
hi hsNiceSpecial        ctermfg=darkred
hi hsLRArrowTail        ctermfg=red
hi hsRLArrowTail        ctermfg=red
hi hsLRArrowHead        ctermfg=red
hi hsRLArrowHead        ctermfg=red
hi hsCharacter          ctermfg=green
hi hsNumber             ctermfg=green
hi hsSpecialChar        ctermfg=green
hi hsDelimiter          ctermfg=yellow
hi ConId                ctermfg=darkyellow
hi WS                   ctermfg=blue
hi HS                   ctermfg=blue
hi ES                   ctermfg=blue
hi RS                   ctermfg=blue
"   Yaml:
hi yamlBlockMappingKey  cterm=bold ctermfg=white 
