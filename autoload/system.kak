# Misc keys
map global user '<esc>' ': set-register slash ""<ret>' -docstring 'Clear search highlighting'
map global normal '/' '/(?i)' # Remap / to case-insensitive search
map global user '/' '/'
map global user s ': w<ret>' -docstring 'Save'
map global user Z ': wq<ret>' -docstring 'Save and quit'
map global normal <c-j> 15j -docstring '15 down'
map global normal <c-k> 15k -docstring '15 up'

# Clipboard stuff
map global user y "<a-|> xclip -selection clipboard<ret>" -docstring "yank the selection into the clipboard"
map global user p "<a-!> xclip -selection clipboard -o<ret>" -docstring "paste from clipboard after selection"
map global user P "! xclip -selection clipboard -o<ret>" -docstring "paste from clipboard before selection"

# System mode
declare-user-mode system
map global user q ': enter-user-mode system<ret>' -docstring 'System mode'
map global system o ':info %opt{}<left>' -docstring 'Print opt'
map global system v ':info %val{}<left>' -docstring 'Print value'
map global system d ': buffer *debug*<ret>' -docstring 'Switch to debug buffer'
map global system f ':set buffer filetype ' -docstring 'Set filetype'
# Path
map global system p ': info %sh{realpath -s --relative-to="$PWD" "$kak_buffile"}<ret>' -docstring 'Print relative file path'
map global system P ': info %sh{realpath -s "$kak_buffile"}<ret>' -docstring 'Print absolute file path'
map global system y ': info %sh{realpath -s --relative-to="$PWD" "$kak_buffile" | xclip -selection clipboard}<ret>' -docstring 'Copy relative file path'
map global system Y ': info %sh{realpath -s "$kak_buffile" | xclip -selection clipboard}<ret>' -docstring 'Copy absolute file path'

# Make cmd
map global system M ':set global makecmd ""<left>' -docstring 'Set global compile command'
map global system m ': make<ret>' -docstring 'Compile'
# Run oneshot shell command
map global system ! ':info %sh{}<left>' -docstring 'Run command with %sh'
# New term
map global system t ': terminal %sh{ echo "$SHELL" }<ret>' -docstring 'Open new term'
