# declare-option line-specs relative_markers

# define-command -hidden update_relative_markers %{
#   evaluate-commands %sh{
#     indicators=14
#     line_specs=$(seq $(($indicators + 1)) | while IFS= read n; do
#       diff=$(echo "($n - ($indicators/2) - 1) * 5" | bc)
#       line=$(echo "$kak_cursor_line + $diff" | bc)
#       if [ "$line" -gt 0 ] && [ ! "$line" = "$kak_cursor_line" ]; then
#         echo -e "$line|{gray}$(echo "$diff" | sed 's/^-//')"
#       fi
#     done);
#     echo "set-option window relative_markers %val{timestamp} $(printf ' %s' $line_specs)"
#   }
# }

# hook global WinCreate .* %{
#   hook window NormalIdle .* %{ update_relative_markers }
# }

# add-highlighter global/ flag-lines blue relative_markers

