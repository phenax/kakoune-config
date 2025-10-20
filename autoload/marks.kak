declare-option str marks_path
declare-option str marks_name

hook global KakBegin .* %{
  set-option global marks_path %sh{
    datadir="${XDG_DATA_HOME:-"$HOME/.local/share"}"
    echo "$datadir/kak/marks"
  }
}

hook global EnterDirectory .* %{ evaluate-commands %sh{
  if [ -z "$kak_marks_name" ]; then
    name=$(pwd | tr '/' '-' | tr ' ' '_')
    echo "set-option global marks_name $name"
  fi
} }

define-command marks-add -params 1..2 %{
  nop %sh{
    [ -z "$kak_opt_marks_path" ] && exit 1
    mkdir -p "$kak_opt_marks_path"
    path="$kak_opt_marks_path/$kak_opt_marks_name"
    [ -f "$path" ] || touch "$path"
    newfile="$1"
    pos="$2"
    if [ -z "$pos" ] || [ "$pos" = "0" ]; then
      pos="99";
    else
      pos="$(echo "$pos" | awk '{printf "%.1f", $1 <= 1 ? 0 : $1 - 0.5}')";
    fi
    function append() { cat; echo -e "$pos\t$newfile"; }
    newfiles=$(grep -v -F "$newfile" "$path" \
                | nl | sed 's/^\s*//' \
                | append | LC_ALL=C sort -g -b -k 2 | uniq -f1 | LC_ALL=C sort -g -b \
                | sed 's/^\s*[-.0-9]\+\s\+//')
    echo -e "$newfiles" > "$path.tmp"
    mv "$path.tmp" "$path" || true
    rm -f "$path.tmp" || true
  }
  marks-show
}

define-command marks-delete -params 1 %{
  nop %sh{
    path="$kak_opt_marks_path/$kak_opt_marks_name"
    [ -f "$path" ] && sed -i "/$(echo "$1" | tr '/' '.')/d" "$path" || true
  }
  delete-buffer %arg{1}
  marks-show
}

define-command marks-clear %{
  nop %sh{
    path="$kak_opt_marks_path/$kak_opt_marks_name"
    [ -f "$path" ] && rm -f "$path" || true
  }
}

define-command marks-show %{
  info -title 'marks' -markup %sh{
    path="$kak_opt_marks_path/$kak_opt_marks_name"
    echo -n "{Default}"
    if ! [ -f "$path" ] || [ "$(wc -l "$path")" = "0" ]; then
      echo "{comment}<empty>" && exit 0;
    fi
    cat "$path" | while IFS= read file; do
      short_path=$(echo "$file" | awk -F/ '{if (NF >= 2) {print $(NF-1) "/" $NF} else {print $NF}}')
      hl=$([ "$file" = "$kak_buffile" ] && echo "{keyword}" || echo "{Default}")
      echo "${hl}${short_path} {comment}$(realpath -s --relative-to="$PWD" "$file"){Default}"
    done | nl | sed 's/^\s*//'
  }
}

define-command marks-switch -params 1 %{
  evaluate-commands %sh{
    path="$kak_opt_marks_path/$kak_opt_marks_name"
    [ -f "$path" ] || exit 0
    count="${1:-0}"
    [ "$count" = "0" ] && exit 0
    file=$(cat "$path" | sed -n "${count}p")
    [ -z "$file" ] || echo "edit $file"
  }
  marks-show
}

declare-user-mode marks
map global user a ':enter-user-mode-with-count marks<ret>' -docstring 'Marks mode'
map global user <space> ':marks-switch %val{count}<ret>' -docstring 'Switch marks'
map global marks a ':marks-add %val{buffile} %opt{user_mode_count}<ret>' -docstring 'Create new mark from buffer'
map global marks d ':marks-delete %val{buffile}<ret>' -docstring 'Delete mark'
map global marks C ':marks-clear<ret>' -docstring 'Clear mark'
