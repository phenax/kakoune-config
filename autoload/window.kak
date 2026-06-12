declare-user-mode win
map global normal <c-w> ':enter-user-mode win<ret>' -docstring 'Window mode'

map global win q ': quit<ret>' -docstring 'Quit'
map global win <c-q> ': quit<ret>' -docstring 'Quit'
map global win s ': tmux-terminal-horizontal kak -c %val{session}<ret>' -docstring 'Split vertical'
map global win v ': tmux-terminal-vertical kak -c %val{session}<ret>' -docstring 'Split horizontal'
map global win z ': wq<ret>' -docstring 'Write and quit'
map global win t ': switch-to-tools<ret>' -docstring 'Tools client'

def switch-to-tools %{
  terminal-singleton tools kak -e 'rename-client tools' -c %val{session}
}

def toolsclient %{
  rename-client main
  set global jumpclient main

  try %{ eval -client tools nop } catch %{
    switch-to-tools
    set global toolsclient tools
    focus main
  }
}

def terminal-singleton -params 2.. -docstring 'terminal-singleton <name> <command> [args...]' %{
  eval %sh{
    name="$1"; shift 1;

    open-term-win() {
      printf "tmux-repl-impl new-window -n '$name' env"
      printf " 'KAKOUNE_SESSION=$kak_session' 'KAKOUNE_CLIENT=$kak_client'"
      for arg in "$@"; do
        printf ' "%s"' "$(sed 's|["]|\\"|g' <<< "$arg")"
      done
    }

    focus-term-win() {
      tmux select-window -t "$name" >/dev/null 2>&1
    }

    focus-term-win || open-term-win "$@"
  }
}
