# declare-user-mode surround
# declare-user-mode surround-append
# declare-user-mode surround-delete
# map global user s ': enter-user-mode surround<ret>'
# map global surround a ': enter-user-mode surround-append<ret>'
# map global surround d ': enter-user-mode surround-delete<ret>'

# define-command define-surround -params 3 %{
#   evaluate-commands %sh{
#     echo "map global surround-append %{${1}} %{i${2}<esc>a${3}}"
#     echo "map global surround-delete %{${1}} %{<a-a>${2}<a-S>d,}"
#   }
# }

# hook global KakBegin .* %{
#   define-surround ( ( )
#   define-surround [ [ ]
#   # define-surround < < >
#   # define-surround '{' '{' '}'
#   # define-surround '<' '<' '>'
#   # define-surround '`' '`' '`'
#   define-surround '"' '"' '"'
#   # define-surround "'" "'" "'"
# }
