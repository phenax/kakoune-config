declare-option str xrepl_mode_config;
declare-option bool xrepl_running false;
declare-option str-to-str-map xrepl_modes;

set-option -add global xrepl_modes %{node={
  "cmd": "node"
}}
set-option -add global xrepl_modes %{shell={
  "cmd": "$SHELL",
  "transform": "echo 'echo 123 $foooo :: \\$kak_buffile :: \\$kak_selection :: \\$kak_seletion_desc'"
}}

define-command xrepl-set-mode -params 1 %{
  xrepl-quit
  # TODO: This preevaluates the params in transform.
  fennel %arg{1} %opt{xrepl_modes} %{
    (local [mode & modestxt] [(args)])
    (each [_ val (ipairs modestxt)]
      (local (key config) (string.match val "^%s*([^=]*)=(.*)$"))
      (kak.info config)
      (when (= key mode)
        (kak.set "global" "xrepl_mode_config" config)))
  }
  xrepl-begin
}

define-command xrepl-select %{
  fennel %opt{xrepl_modes} %{
    (local modes [(args)])
    (local modenames [])
    (each [_ val (ipairs modes)]
      (local (key _config) (string.match val "^%s*([^=]*)=(.*)$"))
      (when key (table.insert modenames key)))
    (local compl (.. "echo -e \"" (table.concat modenames "\n") "\""))
    (kak.prompt :-menu
                :-shell-script-candidates compl
                "repl mode: "
                "xrepl-set-mode %val{text}")
  }
}

define-command xrepl-send-command %{
  evaluate-commands %sh{
    transform="$(echo "$kak_opt_xrepl_mode_config" | jq -rj '.transform? // ""')"
    value="$kak_selection"
    if ! [ -z "$transform" ]; then
      export kak_buffile="$kak_buffile"
      export kak_selection="$kak_selection"
      export kak_selection_desc="$kak_selection_desc"
      value=$(echo "$value" | foooo=qwe sh -c "$transform")
    fi
    echo "info %{$value//$transform\n$kak_opt_xrepl_mode_config}"
    echo "repl-send-text %{$value}"
  }
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
      init_cmd="$(echo "$kak_opt_xrepl_mode_config" | jq -rj '.cmd? // ""')"
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
map global repl <ret> '<c-s><a-i>p: xrepl-send-command<ret><c-o>'
map global repl l ': xrepl-send-command<ret>'
map global repl r ': xrepl-send-keys Enter<ret>'
map global repl c ': xrepl-send-keys C-c<ret>'
map global repl q ': xrepl-quit<ret>'
map global repl <tab> ': xrepl-select<ret>'
