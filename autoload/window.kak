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
