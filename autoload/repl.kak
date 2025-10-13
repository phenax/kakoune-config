declare-option str xrepl_init_cmd "$SHELL";
declare-option str xrepl_input_transform;
declare-option bool xrepl_running false;

declare-option str-list xrepl_modes;

set-option -add global xrepl_modes "node"
declare-option str xrepl_init_cmd_node "node"

define-command xrepl-set-mode -params 1 %{
  xrepl-quit
  evaluate-commands %sh{
    cmd="$(eval echo "\$kak_opt_xrepl_init_cmd_$1")"
    input_transform="$(eval echo "\$kak_opt_xrepl_input_transform_$1")"
    echo "info %{$kak_opt_xrepl_init_cmd_node; $cmd:$input_transform}"
    if [ -z "$cmd" ]; then cmd="$SHELL"; fi
    if [ -z "$input_transform" ]; then input_transform=""; fi
    echo "set global xrepl_init_cmd '$(printf '%q' $cmd)'"
    echo "set global xrepl_input_transform '$(printf '%q' $input_transform)'"
  }
}

define-command xrepl-send-command %{
  evaluate-commands %sh{
    value="$kak_selection"
    if ! [ -z "$kak_xrepl_input_transform" ]; then
      value=$(echo "$value" | "$kak_xrepl_input_transform")
    fi
    echo "repl-send-text %{$value}"
  }
}

define-command xrepl-send-keys -params 1.. %{
   nop %sh{ tmux send-keys -t "$kak_opt_tmux_repl_id" "$@" }
}

define-command xrepl-quit %{
  set-option global xrepl_running false
  try %{ nop %sh{
    [ -z "$kak_opt_tmux_repl_id" ] && exit 0;
    tmux kill-pane -t "$kak_opt_tmux_repl_id";
  } }
}

define-command xrepl-begin %{
  # TODO: Open if not running
  evaluate-commands %sh{
    if [ "$kak_opt_xrepl_running" = "false" ]; then
      echo "repl-new %opt{xrepl_init_cmd}"
      echo "nop %sh{ tmux last-pane }"
      echo "set-option global xrepl_running true"
    fi
  }
}

declare-user-mode repl
map global normal <c-t> ': enter-user-mode repl<ret>'
map global repl <c-t> ': xrepl-begin<ret>'
map global repl t ': xrepl-begin<ret>'
map global repl <ret> '<a-i>p: xrepl-send-command<ret>'
map global repl l ': xrepl-send-command<ret>'
map global repl r ': xrepl-send-keys Enter<ret>'
map global repl c ': xrepl-send-keys C-c<ret>'
map global repl q ': xrepl-quit<ret>'
