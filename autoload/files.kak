def find -docstring "find files" -menu -params 1 \
  %{ edit -existing %arg{1} } \
  -shell-script-candidates %{ fd -t f --hidden --color=never -E .git }

def file-manager -params .. %{
  terminal-singleton files env "DAFFM_PATH_RELATIVE_TO=%val{client_env_PWD}" daffm -c @kak %arg{@}
}

declare-user-mode file
map global user f ': enter-user-mode file<ret>' -docstring 'File mode'
map global file f ': find ' -docstring 'Find files'
map global file n ': file-manager %val{buffile}<ret>' -docstring 'File manager'

declare-user-mode buffer
map global user b ': enter-user-mode buffer<ret>' -docstring 'Buffer mode'
map global buffer b ': buffer ' -docstring 'Switch buffer'
map global buffer <ret> ': buffers-show<ret>' -docstring 'Show buflist'
map global buffer n ': buffer-next; buffers-show<ret>' -docstring 'Next buffer'
map global buffer p ': buffer-previous; buffers-show<ret>' -docstring 'Previous buffer'
map global buffer d ': delete-buffer; buffers-show<ret>' -docstring 'Delete buffer'
map global buffer s ': write<ret>' -docstring 'Save'

def buffers-show %{
  info -title 'buffers' -markup %sh{
    echo "$kak_quoted_buflist" | xargs -n1 | while IFS= read buf; do
      if [ -z "$buf" ]; then echo "{comment}<scratch>{Normal}"
      elif [ "$buf" == "$kak_bufname" ]; then echo "{keyword}$buf{Normal}"
      else echo "{Default}$buf{Normal}"
      fi
    done | nl -w 2
  }
}

