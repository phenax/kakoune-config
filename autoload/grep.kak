set-option global grepcmd "rg -S --vimgrep --hidden -g '!**/.git/**'"

map global file g ":grep ''<left>" -docstring 'Grep'

define-command grep-write %{
  execute-keys '%' # Consider selecting manually
  evaluate-commands %sh{
    echo "$kak_selections" | "$kak_config/scripts/apply_vimgrep_updates.fnl" | xargs -i echo "info '{}'"
  }
}

hook global -always BufOpenFifo '\*grep\*' %{
  map global file ] ': grep-next-match<ret>'
  map global file [ ': grep-previous-match<ret>'
}
hook global -always BufOpenFifo '\*make\*' %{
  map global file ] ': make-next-error<ret>'
  map global file [ ': make-previous-error<ret>'
}
