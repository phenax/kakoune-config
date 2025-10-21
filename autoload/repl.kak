declare-option bool xrepl_running false;
declare-option str xrepl_current_cmd;
declare-option str xrepl_current_transform;

# TODO: Add env
# TODO: Add clear screen
# TODO: Migrate curly
# TODO: Preserve original selection with send paragraph
# TODO: Add prompt
# TODO: Add send c-c
# TODO: Add send buffile

declare-user-mode repl-mode-select
define-command define-repl-mode -params 3 %{
  map global repl-mode-select %arg{1} -docstring %arg{2} %sh{
    kak_escape() { printf "'"; printf '%s' "$1" | sed "s/'/''/g"; printf "'"; }
    printf ": xrepl-quit<ret>"
    printf ": evaluate-commands $(kak_escape "$(echo "$3" | tr '\n' ';')")<ret>"
    printf ": xrepl-begin<ret>"
  }
}

define-repl-mode n 'Node' %{
  set global xrepl_current_cmd 'node'
  set global xrepl_current_transform ""
}
define-repl-mode s 'Shell' %{
  set global xrepl_current_cmd '$SHELL'
  set global xrepl_current_transform ""
}
define-repl-mode j 'Jest' %{
  set global xrepl_current_cmd '$SHELL'
  set global xrepl_current_transform 'cat > /dev/null
    echo "cd \"$(dirname "$kak_buffile")\" && npx jest --runTestsByPath \\\"$kak_buffile\\\";"
  '
}
define-repl-mode c 'Cypress' %{
  set global xrepl_current_cmd '$SHELL'
  set global xrepl_current_transform 'cat > /dev/null
    echo "npx cypress run --headless --e2e --spec $kak_buffile;"
  '
}
define-repl-mode a 'AI: Gemini' %{
  set global xrepl_current_cmd 'gemini'
  set global xrepl_current_transform ""
}

define-command xrepl-send-command %{
  evaluate-commands -draft %sh{
    transform="$kak_opt_xrepl_current_transform"
    value="$kak_selection"
    if ! [ -z "$transform" ]; then
      export kak_buffile kak_selection kak_selection_desc kak_cursor_line kak_cursor_column
      value=$(echo "$kak_selection" | sh -c "$transform")
    fi
    echo -e "repl-send-text %{$value\n}"
  }
}

define-command xrepl-send-paragraph %{
  execute-keys '<a-i>p'
  xrepl-send-command
}

define-command xrepl-send-keys -params 1.. %{
  nop %sh{ tmux send-keys -t "$kak_opt_tmux_repl_id" "$@" }
}

define-command xrepl-quit %{
  set-option global xrepl_running false
  try %{ nop %sh{
    if ! [ -z "$kak_opt_tmux_repl_id" ]; then
      tmux kill-pane -t "$kak_opt_tmux_repl_id";
    fi
  } }
}

define-command xrepl-begin %{
  evaluate-commands %sh{
    if [ "$kak_opt_xrepl_running" = "false" ]; then
      init_cmd="$kak_opt_xrepl_current_cmd"
      if [ -z "$init_cmd" ]; then init_cmd="$SHELL"; fi
      echo "set-option global xrepl_running true"
      echo "repl-new $init_cmd"
      echo "nop %sh{ tmux last-pane }"
    fi
  }
}

declare-user-mode repl
map global normal <c-t> ': enter-user-mode repl<ret>'
map global repl <c-t> ': xrepl-begin<ret>'
map global repl t ': xrepl-begin<ret>'
map global repl <ret> ': xrepl-send-paragraph<ret>'
map global repl l ': xrepl-send-command<ret>'
map global repl r ': xrepl-send-keys Enter<ret>'
map global repl c ': xrepl-send-keys C-c<ret>'
map global repl q ': xrepl-quit<ret>'
# map global repl <tab> ': xrepl-select<ret>'
map global repl <tab> ': enter-user-mode repl-mode-select<ret>'
