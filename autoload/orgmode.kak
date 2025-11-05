declare-user-mode org
hook global BufSetOption filetype=org %{
  map buffer normal <ret> ': orgmode-jump-link<ret>' -docstring 'Jump to link'
  map buffer user o ': enter-user-mode org<ret>' -docstring 'Org mode'
  map buffer org <tab> ': orgmode-toggle<ret>' -docstring 'Toggle checkbox/task'
}

def orgmode-toggle %{
  evaluate-commands -save-regs '#/' %{
    try %{ orgmode-toggle-checkbox } catch %{ orgmode-toggle-task-state } catch %{ }
  }
}

def orgmode-jump-link %{
  # TODO: support multiple links in single line
  evaluate-commands %{ try %{
    execute-keys ',xs\[\[([^\n\]]+)\]<ret>'
    evaluate-commands %sh{
      [ -z "$kak_reg_1" ] && exit 0
      case "$kak_reg_1" in
        https://*|http://*) xdg-open "$kak_reg_1" >/dev/null 2>&1 ;;
        /*|~/*) echo "edit %{$kak_reg_1}" ;;
        *)
          current_path="${kak_buffile:-"$kak_bufname"}"
          path="$(realpath -s "$(dirname "$kak_buffile")/$kak_reg_1")"
          echo "edit %{$path}"
        ;;
      esac
    }
  } }
}

def orgmode-toggle-checkbox %{
  evaluate-commands %{
    execute-keys ',xs^(\h*-\h+)\[([Xx\- ])\]<ret>'
    evaluate-commands %sh{
      next="$kak_reg_2"
      case "$kak_reg_2" in
        X|x) next=" " ;;
        -) next="X" ;;
        *) next="-" ;;
      esac
      echo "execute-keys 'c<c-r>1[$next]<esc>'"
    }
  }
}

def orgmode-toggle-task-state %{
  evaluate-commands %{
    execute-keys ',xs^(\*+\h+)(TODO|ACTIVE|DONE)?<ret>'
    evaluate-commands %sh{
      next="TODO " # Add space at end when no state
      case "$kak_reg_2" in
        TODO) next="ACTIVE" ;;
        ACTIVE) next="DONE" ;;
        DONE) next="TODO" ;;
      esac
      echo "execute-keys 'c<c-r>1$next<esc>'"
    }
  }
}
