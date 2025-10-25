declare-user-mode win
map global normal <c-w> ':enter-user-mode win<ret>' -docstring 'Window mode'

map global win q ': quit<ret>' -docstring 'Quit'
map global win <c-q> ': quit<ret>' -docstring 'Quit'
map global win v ': tmux-terminal-horizontal kak -c %val{session}<ret>' -docstring 'Split vertical'
map global win s ': tmux-terminal-vertical kak -c %val{session}<ret>' -docstring 'Split horizontal'
map global win h ': nop %sh{tmux select-pane -L}<ret>' -docstring 'Jump left'
map global win j ': nop %sh{tmux select-pane -D}<ret>' -docstring 'Jump down'
map global win k ': nop %sh{tmux select-pane -U}<ret>' -docstring 'Jump up'
map global win l ': nop %sh{tmux select-pane -R}<ret>' -docstring 'Jump right'
map global win z ': wq<ret>'

define-command terminal-singleton -params 2.. -docstring 'terminal-singleton <name> <command> [args...]' %{
  eval %sh{
    name="$1"; shift;
    open-term-win() {
      printf "terminal -n '$name' env"
      printf " 'KAKOUNE_SESSION=$kak_session' 'KAKOUNE_CLIENT=$kak_client'"
      printf " 'GIT_EDITOR=kak -c \"$kak_session\"' 'EDITOR=kcr edit' 'VISUAL=kcr edit'"
      printf " %q" "$@"
      echo ""
    }
    focus-term-win() {
      tmux select-window -t "$name" >/dev/null 2>&1
    }

    focus-term-win || open-term-win "$@";
  }
}
