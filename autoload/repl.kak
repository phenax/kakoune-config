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
declare-option str xrepl_current_name;
declare-option str xrepl_current_cmd;
declare-option str xrepl_current_transform;
declare-option str xrepl_current_split_size;
declare-option bool xrepl_current_split_vertical false;
declare-option bool xrepl_current_clear_screen false;

# TODO: Use register set to selection (paragraph) instead of selection
# TODO: Add env
# TODO: Migrate curly
# TODO: Preserve original selection with send paragraph
# TODO: Sometimes repl stops working (tmux repl id changed?)

declare-user-mode repl-mode-select
define-command define-repl-mode -params 4 %{
  # TODO: Use a hidden command and use for keymap
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

define-repl-mode global s 'Shell' %{ set global xrepl_current_cmd '$SHELL' }
define-repl-mode global n 'Node' %{ set global xrepl_current_cmd 'node' }
define-repl-mode global a 'AI: Local' %{ set global xrepl_current_cmd 'aichat' }
define-repl-mode global g 'AI: Gemini' %{ set global xrepl_current_cmd 'gemini' }

hook global BufSetOption filetype=haskell %{
  define-repl-mode buffer h 'Haskell: cabal test' %{
    set global xrepl_current_cmd 'cabal test'
    set global xrepl_current_clear_screen true
  }
}

hook global BufSetOption filetype=ruby %{
  define-repl-mode buffer r 'Rspec' %{
    # TODO: Make generic
    set global xrepl_current_cmd 'docker compose exec shape-api -T sh'
    set global xrepl_current_transform 'cat > /dev/null
      path="$kak_buffile"
      if [ $kak_cursor_line -gt 5 ]; then
        path="$path:$kak_cursor_line"
      fi
      echo "rspec -fd $path"
    '
    set global xrepl_current_clear_screen true
  }
}

hook global BufSetOption filetype=clojure %{
  # TODO: Just temporary for messing around. Remove module name
  map buffer repl r ': repl-send-text %{(require ''[pluribus.core :as p] :reload)}; xrepl-send-keys Enter<ret>' -docstring 'Cljs reload'
  define-repl-mode buffer j 'Clojurescript repl' %{
    set global xrepl_current_cmd 'clj -M -m cljs.main --repl-opts "{:launch-browser false}" --compile pluribus.core --repl'
    set global xrepl_current_split_size 30%%
    set global xrepl_current_split_vertical true
  }
}

hook global BufSetOption filetype=(?:javascript|typescript|jsx|tsx) %{
  # TODO: Search for root cypress config file and cd into it
  define-repl-mode buffer c 'Cypress' %{
    set global xrepl_current_cmd '$SHELL'
    set global xrepl_current_transform 'cat > /dev/null
      echo "npx cypress run --headless --e2e --spec ''$kak_buffile'';"
    '
    set global xrepl_current_clear_screen true
  }
  define-repl-mode global j 'Jest' %{
    set global xrepl_current_cmd '$SHELL'
    set global xrepl_current_transform 'cat > /dev/null
      echo "sh -c \\"cd ''$(dirname "$kak_buffile")''; npx jest --runTestsByPath ''$kak_buffile''\\";"
    '
    set global xrepl_current_clear_screen true
  }
}

define-command xrepl-send-prompt %{
  prompt -buffer-completion 'Send to repl: ' %{ repl-send-text %val{text} }
}

define-command xrepl-send-command %{
  evaluate-commands -draft %sh{
    if [ "$kak_opt_xrepl_current_clear_screen" == "true" ]; then
      echo "xrepl-send-keys C-l"
    fi

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
      echo "info %opt{xrepl_current_name}"
      echo "set-option global xrepl_running true"
      cmd=$([ "$kak_opt_xrepl_current_split_vertical" == "true" ] && echo "tmux-repl-vertical" || echo "tmux-repl-horizontal")
      echo "$cmd -l $kak_opt_xrepl_current_split_size $init_cmd"
      echo "nop %sh{ tmux last-pane }"
    fi
  }
}
