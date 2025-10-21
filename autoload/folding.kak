# declare-option range-specs fold_ranges

# define-command fold-range -params 1 %{
#   # TODO: Check if cursor is within range
#   evaluate-commands %sh{
#     if (echo "$kak_opt_fold_ranges" | grep -F "${1}" >/dev/null 2>&1); then
#       echo "set-option -remove buffer fold_ranges '${1}|++++'"
#     else
#       echo "set-option -add buffer fold_ranges '${1}|++++'"
#     fi
#   }
# }

# define-command fold-enable %{
#   add-highlighter global/folding replace-ranges fold_ranges
# }

# define-command fold-indent %{
#   execute-keys '<a-i>i'
#   fold-range %val{selection_desc}
# }

# fold-enable

# declare-user-mode foldmode
# map global normal <c-^> ': enter-user-mode foldmode<ret>'
# map global foldmode a ': fold-indent<ret>'
