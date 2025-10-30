# declare-user-mode surround
# declare-user-mode surround-append
# declare-user-mode surround-delete
# map global user k ': enter-user-mode surround<ret>'
# map global surround a ': enter-user-mode surround-append<ret>'
# map global surround d ': enter-user-mode surround-delete<ret>'

# define-command define-surround -params 4 -docstring ': <trigger> <surrounddesc> <start> <end>' %{
#   map global surround-append %arg{1} %sh{ echo "i${3}<esc>a${4}" }
#   map global surround-delete %arg{1} %sh{ echo "<a-a>${2}<a-S>d," }
# }

# define-surround '(' '(' '(' ')'
# define-surround '[' '[' '[' ']'
# define-surround '{' '{' '{' '}'
# define-surround '`' '`' '`' '`'
# define-surround '"' '"' '"' '"'
# define-surround "'" "'" "'" "'"
# define-surround t "c<lt>div,<lt>/div<gt><ret>" "<lt>div<gt>" "<lt>/div<gt>"
