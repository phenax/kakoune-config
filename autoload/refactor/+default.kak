declare-user-mode refactor
map global user r ': enter-user-mode refactor<ret>' -docstring 'Refactor mode'

map global refactor w '*%s<ret>' -docstring 'Select all selections'
