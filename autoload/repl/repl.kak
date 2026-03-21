declare-user-mode repl
map global normal <c-t> ': enter-user-mode repl<ret>' -docstring 'Repl mode'
map global repl <tab> ': enter-user-mode repl-mode-select<ret>' -docstring 'Select repl'
map global repl <c-t> ': xrepl-begin<ret>' -docstring 'Start repl'
map global repl t ': xrepl-begin<ret>' -docstring 'Start repl'
map global repl l ': xrepl-send-command<ret>' -docstring 'Send to selection to repl'
map global repl <ret> ': xrepl-send-paragraph<ret>' -docstring 'Send paragraph to repl'
map global repl r ': xrepl-send-keys Enter<ret>' -docstring 'Send return key to repl'
map global repl c ': xrepl-send-keys C-c<ret>' -docstring 'Send Ctrl+c interrupt to repl'
map global repl p ': xrepl-send-prompt<ret>' -docstring 'Prompt for text to send to repl'
map global repl q ': xrepl-quit<ret>' -docstring 'Quit repl'

declare-option bool xrepl_running false;
declare-option str xrepl_tmux_id;
declare-option str xrepl_current_name;
declare-option str xrepl_current_cmd;
declare-option str xrepl_current_transform;
declare-option str xrepl_current_split_size;
declare-option bool xrepl_current_split_vertical false;
declare-option bool xrepl_current_clear_screen false;

# TODO: "Custom" repl mode
# TODO: Use register set to selection (paragraph) instead of selection
# TODO: Add env
# TODO: Preserve original selection with send paragraph

declare-user-mode repl-mode-select
define-command define-repl-mode -params 4 %{
  # TODO: Use a hidden command and use for keymap
  # define-command %sh{ echo "repl-mode--$2" } %{
  #   xrepl-quit
  #   set global xrepl_current_name %arg{3}
  #   set global xrepl_current_cmd "$SHELL"
  #   set global xrepl_current_transform ""
  #   set global xrepl_current_split_size '45%'
  #   set global xrepl_current_split_vertical false
  #   set global xrepl_current_clear_screen false
  #   evaluate-commands %sh{
  #     kak_escape() { printf "'"; printf '%s' "$1" | sed "s/'/''/g"; printf "'"; }
  #     kak_escape "$(echo "$4" | tr '\n' ';')"
  #   }
  #   xrepl-begin
  # }
  map %arg{1} repl-mode-select %arg{2} -docstring %arg{3} %sh{
    kak_escape() { printf "'"; printf '%s' "$1" | sed "s/'/''/g"; printf "'"; }
    printf ": xrepl-quit<ret>"
    printf ": set global xrepl_current_name '$3'<ret>"
    printf ": set global xrepl_current_cmd \"\$SHELL\"<ret>"
    printf ": set global xrepl_current_transform \"\"<ret>"
    printf ": set global xrepl_current_split_size 45%%<ret>"
    printf ": set global xrepl_current_split_vertical false<ret>"
    printf ": set global xrepl_current_clear_screen false<ret>"
    printf ": evaluate-commands $(kak_escape "$(echo "$4" | tr '\n' ';')")<ret>"
    printf ": xrepl-begin<ret>"
  }
}

define-command xrepl-send-prompt %{
  prompt -buffer-completion 'Send to repl: ' %{ xrepl-send-text %val{text} }
}

define-command xrepl-send-command %{
  evaluate-commands -draft %sh{
    if [ "$kak_opt_xrepl_current_clear_screen" == "true" ]; then
      echo "xrepl-send-keys C-l"
    fi

    transform="$kak_opt_xrepl_current_transform"
    value="$kak_selection"
    if ! [ -z "$transform" ]; then
      # Available values in transform script
      export kak_buffile kak_selection kak_selection_desc kak_cursor_line kak_cursor_column kak_config
      value=$(echo "$kak_selection" | sh -c "$transform")
    fi
    echo -e "xrepl-send-text %{$value\n}"
  }
}

define-command xrepl-send-paragraph %{
  execute-keys '<a-i>p'
  xrepl-send-command
}

define-command xrepl-send-keys -params 1.. %{
  nop %sh{ tmux send-keys -t "$kak_opt_xrepl_tmux_id" "$@" }
}

define-command xrepl-quit %{
  set-option global xrepl_running false
  try %{ nop %sh{
    if ! [ -z "$kak_opt_xrepl_tmux_id" ]; then
      tmux kill-pane -t "$kak_opt_xrepl_tmux_id";
    fi
  } }
}

define-command xrepl-begin %{
  evaluate-commands %sh{
    if [ "$kak_opt_xrepl_running" = "false" ]; then
      init_cmd="$kak_opt_xrepl_current_cmd"
      if [ -z "$init_cmd" ]; then init_cmd="$SHELL"; fi
      # echo "info %opt{xrepl_current_name}"
      echo "set-option global xrepl_running true"
      cmd=$([ "$kak_opt_xrepl_current_split_vertical" == "true" ] && echo "tmux-xrepl-vertical" || echo "tmux-xrepl-horizontal")
      echo "$cmd -l $kak_opt_xrepl_current_split_size $init_cmd"
      echo "nop %sh{ tmux last-pane }"
    fi
  }
}

define-command -hidden -params 1.. tmux-xrepl-impl %{
  evaluate-commands %sh{
    if [ -z "$TMUX" ]; then
      echo 'fail This command is only available in a tmux session'
      exit
    fi
    tmux_args="split-window $1 -t ${kak_client_env_TMUX_PANE}"
    shift
    repl_pane_id=$(tmux $tmux_args -P -F '#{pane_id}' "$@")
    printf "set-option current xrepl_tmux_id '%s'" "$repl_pane_id"
  }
}

define-command tmux-xrepl-vertical -params 0.. %{ tmux-xrepl-impl '-v' %arg{@} }
define-command tmux-xrepl-horizontal -params 0.. %{ tmux-xrepl-impl '-h' %arg{@} }

define-command xrepl-send-text -params 0..1 %{
  evaluate-commands %sh{
    if [ $# -eq 0 ]; then
        tmux set-buffer -b kak_selection -- "${kak_selection}"
    else
        tmux set-buffer -b kak_selection -- "$1"
    fi
    tmux paste-buffer -b kak_selection -t "$kak_opt_xrepl_tmux_id" ||
    echo 'fail tmux-send-text: failed to send text, see *debug* buffer for details'
  }
}
