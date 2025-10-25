define-command marks-add -params 1..2 %{
  nop %sh{ "$kak_config/scripts/marks.fnl" add "$1" "$2" }
  marks-show
}

define-command marks-delete -params 1 %{
  nop %sh{ "$kak_config/scripts/marks.fnl" delete "$1" }
  delete-buffer %arg{1}
  marks-show
}

define-command marks-clear %{
  nop %sh{ "$kak_config/scripts/marks.fnl" clear }
}

define-command marks-show %{
  info -title 'marks' -markup %sh{
    path="$kak_opt_marks_path/$kak_opt_marks_name"
    echo -n "{Default}"
    marks=$("$kak_config/scripts/marks.fnl" show)
    if [ -z "$marks" ]; then
      echo "{comment}<empty>" && exit 0;
    fi
    echo "$marks" | while IFS= read file; do
      short_path=$(echo "$file" | awk -F/ '{if (NF >= 2) {print $(NF-1) "/" $NF} else {print $NF}}')
      hl=$([ "$file" = "$kak_buffile" ] && echo "{keyword}" || echo "{Default}")
      echo "${hl}${short_path} {comment}$(realpath -s --relative-to="$PWD" "$file"){Default}"
    done | nl | sed 's/^\s*//'
  }
}

define-command marks-switch -params 1 %{
  evaluate-commands %sh{
    mark=$("$kak_config/scripts/marks.fnl" get "${1:-0}")
    [ -z "$mark" ] || echo "edit $mark"
  }
  marks-show
}

declare-user-mode marks
map global user a ':enter-user-mode-with-count marks<ret>' -docstring 'Marks mode'
map global user <space> ':marks-switch %val{count}<ret>' -docstring 'Switch marks'
map global marks a ':marks-add %val{buffile} %opt{user_mode_count}<ret>' -docstring 'Create new mark from buffer'
map global marks d ':marks-delete %val{buffile}<ret>' -docstring 'Delete mark'
map global marks C ':marks-clear<ret>' -docstring 'Clear mark'
