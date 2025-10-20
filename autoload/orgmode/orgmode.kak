hook global BufCreate .*[.]org %{
  set-option buffer filetype org
}

declare-user-mode org
hook global WinSetOption filetype=org %{
  add-highlighter window/org ref org
  require-module orgmode-highlight

  map window normal <ret> ': orgmode-jump-link<ret>'
  map window user o ': enter-user-mode org<ret>' -docstring 'Org mode'
  map window org <tab> ': orgmode-toggle<ret>' -docstring 'Toggle checkbox/task'
}

define-command orgmode-toggle %{
  evaluate-commands -save-regs '#/' %{
    try %{ orgmode-toggle-checkbox } catch %{ orgmode-toggle-task-state } catch %{ }
  }
}

define-command orgmode-jump-link %{
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

define-command orgmode-toggle-checkbox %{
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

define-command orgmode-toggle-task-state %{
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

provide-module orgmode-highlight %{
  add-highlighter shared/org regions
  add-highlighter shared/org/inline default-region regions
  add-highlighter shared/org/inline/text default-region group

  add-highlighter shared/org/inline/text/ regex \*[^\n*]+\* 0:inlineBold
  add-highlighter shared/org/inline/text/ regex /[^\n/]+/ 0:inlineItalic
  add-highlighter shared/org/inline/text/ regex _[^\n_]+_ 0:inlineUnderline
  add-highlighter shared/org/inline/text/ regex \+[^\n+]+\+ 0:inlineStrikethrough
  add-highlighter shared/org/inline/text/ regex ~[^\n~]+~ 0:inlineCode
  add-highlighter shared/org/inline/text/ regex \[\[[^\n]+\]\] 0:inlineLink
  add-highlighter shared/org/codeblock region -match-capture \
    ^\h*#\+(?:begin|BEGIN)_([a-zA-Z]*)[^\n]*$ \
    ^\h*#\+(?:end|END)_([a-zA-Z]*)[^\n]*$ \
    regions
  add-highlighter shared/org/codeblock/ default-region fill orgCodeBlock

  add-highlighter shared/org/inline/text/ regex ^[*]{1}[^\n]* 0:header1
  add-highlighter shared/org/inline/text/ regex ^[*]{2}[^\n]* 0:header2
  add-highlighter shared/org/inline/text/ regex ^[*]{3}[^\n]* 0:header3
  add-highlighter shared/org/inline/text/ regex ^[*]{4}[^\n]* 0:header4
  add-highlighter shared/org/inline/text/ regex ^[*]{5}[^\n]* 0:header5
  add-highlighter shared/org/inline/text/ regex ^[*]{6}[^\n]* 0:header6

  add-highlighter shared/org/inline/text/ regex ^[*]*\s+(TODO) 1:orgTaskStateTodo
  add-highlighter shared/org/inline/text/ regex ^[*]*\s+(DONE) 1:orgTaskStateDone
  add-highlighter shared/org/inline/text/ regex ^[*]*\s+(ACTIVE) 1:orgTaskStateActive

  add-highlighter shared/org/inline/text/ regex ^\s*-\s*(\[[xX]\])\h([^\n]+)$ 1:checkboxChecked 2:checkboxCheckedText
  add-highlighter shared/org/inline/text/ regex ^\s*-\s*(\[[\s]\]) 1:checkboxTodo
  add-highlighter shared/org/inline/text/ regex ^\s*-\s*(\[[-]\]) 1:checkboxPending
}
