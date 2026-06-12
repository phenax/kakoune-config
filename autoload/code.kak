# Disable indent trimming
set-option global disabled_hooks .*-trim-indent

# Wrapping
set-option global autowrap_column 100
hook global WinSetOption filetype=git-commit %{
  set window autowrap_column 72
  autowrap-enable
}
add-highlighter global/ column '%opt{autowrap_column}' WrapLine
add-highlighter global/ wrap -word -indent # Softwrap long lines
map global normal = '|fmt -w $kak_opt_autowrap_column<ret>' -docstring 'Wrap text with fmt'

# Code mode
declare-user-mode code
map global user c ': enter-user-mode code<ret>' -docstring 'Code mode'
map global code c ': comment-line<ret>' -docstring 'Comment/uncomment lines'
map global code C ': comment-block<ret>' -docstring 'Comment/uncomment lines'
map global code f ': apply-formatting<ret>' -docstring 'Apply configured formatter'
def casecamel %{ exec '`s[-_<space>]<ret>d~<a-i>w' }
def casesnake %{ exec '<a-:><a-;>s-|[a-z][A-Z]<ret>;a<space><esc>s[-\s]+<ret>c_<esc><a-i>w`' }
def casekebab %{ exec '<a-:><a-;>s_|[a-z][A-Z]<ret>;a<space><esc>s[_\s]+<ret>c-<esc><a-i>w`' }
map global code <a-minus> ': casekebab<ret>' -docstring 'kebab-casing'
map global code <a-_> ': casesnake<ret>' -docstring 'snake_casing'
map global code <a-c> ': casecamel<ret>' -docstring 'camelCasing'

# Editorconfig
hook global BufOpenFile .* %{ editorconfig-load }
hook global BufNewFile .* %{ editorconfig-load }

# XML tag object
map -docstring "xml tag objet" global object t %{c<lt>([\w.]+)\b[^>]*?(?<lt>!/)>,<lt>/([\w.]+)\b[^>]*?(?<lt>!/)><ret>}

# Highlighters
add-highlighter global/ regex \b(TODO|FIXME)\b 0:default+rb
add-highlighter global/ regex @(todo|fixme) 0:default+rb
