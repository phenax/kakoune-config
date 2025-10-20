def find -docstring "find files" -menu -params 1 %{ edit -existing %arg{1} } \
         -shell-script-candidates %{ fd -t f --hidden --color=never -E .git }

def file-manager -params .. %{ connect terminal env "EDITOR=kcr edit" daffm -c @kak %arg{@} }

declare-user-mode buffer
map global user b ': enter-user-mode buffer<ret>' -docstring 'Buffer mode'
map global buffer b ': buffer ' -docstring 'Switch buffer'
map global buffer d ': delete-buffer<ret>' -docstring 'Delete buffer'
map global buffer s ': write<ret>' -docstring 'Save'

declare-user-mode file
map global user f ': enter-user-mode file<ret>' -docstring 'File mode'
map global file f ': find ' -docstring 'Find files'
map global file n ': file-manager %val{buffile}<ret>' -docstring 'File manager'
