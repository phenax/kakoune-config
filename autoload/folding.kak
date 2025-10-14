# declare-option range-specs fold_ranges

# define-command fold-range -params 1 %{
#   # TODO: Check if cursor is within range
#   evaluate-commands %sh{
#     if (echo "$kak_opt_fold_ranges" | grep -F "${1}" >/dev/null 2>&1); then
#       echo "set-option -remove buffer fold_ranges '${1}|Texthere'"
#     else
#       echo "set-option -add buffer fold_ranges '${1}|Texthere'"
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
