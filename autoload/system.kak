# Misc keys
map global user '<esc>' ': set-register slash ""<ret>' -docstring 'Clear search highlighting'
map global normal '/' '/(?i)' # Remap / to case-insensitive search
map global user '/' '/'
map global user s ': w<ret>' -docstring 'Save'
map global user Z ': wq<ret>' -docstring 'Save and quit'
map global normal <c-j> 15j -docstring '15 down'
map global normal <c-k> 15k -docstring '15 up'

map global user y "<a-|> xclip -selection clipboard<ret>" -docstring "yank the selection into the clipboard"

declare-user-mode system
map global user q ': enter-user-mode system<ret>' -docstring 'System mode'
map global system o ':info %opt{}<left>' -docstring 'Print opt'
map global system v ':info %val{}<left>' -docstring 'Print value'
map global system d ': buffer *debug*<ret>' -docstring 'Switch to debug buffer'
map global system f ':set buffer filetype ' -docstring 'Set filetype'
map global system M ':set global makecmd ""<left>' -docstring 'Set global compile command'
map global system m ': make<ret>' -docstring 'Compile'
map global system p ': info %sh{ realpath -s --relative-to="$PWD" "$kak_buffile" }<ret>' -docstring 'Print relative file path'
map global system P ': info %val{buffile}<ret>' -docstring 'Print absolute file path'
map global system ! ':info %sh{}<left>' -docstring 'Run command'
map global system t ': terminal %sh{ echo "$SHELL" }<ret>' -docstring 'Open new term'
