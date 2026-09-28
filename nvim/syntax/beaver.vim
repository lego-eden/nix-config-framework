" Vim syntax file
" Language:   Beaver LALR(1) parser generator grammar
" Maintainer: (custom, community-written; no official upstream syntax exists)

if exists("b:current_syntax")
  finish
endif

" Include java syntax {{{
if version >= 600
	runtime! syntax/java.vim
	unlet b:current_syntax
else
	so $VIMRUNTIME/syntax/java.vim
endif
"}}}

" Comments
syn keyword beaverTodo     TODO FIXME XXX contained
syn match   beaverComment  "//.*$" contains=beaverTodo
syn region  beaverComment  start="/\*" end="\*/" contains=beaverTodo

" Strings (used after %package, %class, %import, %embed, etc.)
syn region  beaverString   start=+"+ skip=+\\"+ end=+"+

" Numbers
syn match   beaverNumber   "\<\d\+\>"

" Directives - everything Beaver reads before the rule section
syn match   beaverDirective "%package\>"
syn match   beaverDirective "%class\>"
syn match   beaverDirective "%import\>"
syn match   beaverDirective "%embed\>"
syn match   beaverDirective "%init\>"
syn match   beaverDirective "%terminals\?\>"
syn match   beaverDirective "%typeof\>"
syn match   beaverDirective "%left\>"
syn match   beaverDirective "%right\>"
syn match   beaverDirective "%nonassoc\>"
syn match   beaverDirective "%goal\>"
syn match   beaverDirective "%eof\>"

" Grammar-rule operators / punctuation
syn match   beaverOperator "::="
syn match   beaverOperator "="
syn match   beaverOperator "|"
syn match   beaverOperator ";"
syn match   beaverOperator ","
syn match   beaverOperator "\."

" Semantic action blocks: {: ... java/embedded code ... :}
syn region  beaverAction   start="{:" end=":}" contains=@javaTop contained

" Terminal-name convention: ALL_CAPS symbols used on rule right-hand sides
syn match   beaverTerminal "\<[A-Z][A-Z0-9_]*\>"

" Rule (nonterminal) names: lower_case identifiers followed by = or ::=
syn match   beaverNonTerm  "^\s*[a-z][A-Za-z0-9_]*\ze\s*\(::=\|=\)"

let b:current_syntax = "beaver"

hi def link beaverTodo      Todo
hi def link beaverComment   Comment
hi def link beaverString    String
hi def link beaverNumber    Number
hi def link beaverDirective PreProc
hi def link beaverOperator  Operator
hi def link beaverAction    Special
hi def link beaverTerminal  Constant
hi def link beaverNonTerm   Function
