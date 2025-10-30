declare-option -hidden str-list snippet_list

map global normal <c-p> ': snippets-insert<ret>'

define-command snippets-insert %{
  prompt -menu \
    -shell-script-candidates 'echo "$kak_opt_snippet_list"' \
    'Snippet: ' 'evaluate-commands %val{text}'
}

define-command define-snippet -params 2 %{
  set-option -add %arg{1} snippet_list %sh{ echo -e "$2\n" }
}
