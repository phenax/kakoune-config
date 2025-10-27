declare-user-mode win
map global normal <c-w> ':enter-user-mode win<ret>' -docstring 'Window mode'

map global win q ': quit<ret>' -docstring 'Quit'
map global win <c-q> ': quit<ret>' -docstring 'Quit'
map global win v ': tmux-terminal-horizontal kak -c %val{session}<ret>' -docstring 'Split vertical'
map global win s ': tmux-terminal-vertical kak -c %val{session}<ret>' -docstring 'Split horizontal'
map global win z ': wq<ret>'

define-command terminal-singleton -params 2.. -docstring 'terminal-singleton <name> <command> [args...]' %{
  eval %sh{
    name="$1"; shift;
    open-term-win() {
      printf "terminal -n '$name' env"
      printf " 'KAKOUNE_SESSION=$kak_session' 'KAKOUNE_CLIENT=$kak_client'"
      printf " %q" "$@"
    }
    focus-term-win() {
      tmux select-window -t "$name" >/dev/null 2>&1
    }

    focus-term-win || open-term-win "$@";
  }
}
