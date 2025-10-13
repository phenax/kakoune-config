set-option global grepcmd "rg -S --vimgrep --hidden -g '!**/.git/**'"

map global file g ':grep ' -docstring 'Grep'

define-command grep-write %{
  execute-keys '%' # Consider selecting manually
  evaluate-commands %sh{
    echo "$kak_selections" | "$kak_config/scripts/apply_vimgrep_updates.js" | xargs -i echo "info '{}'"
  }
}

# TODO: Proper mappings for next/prev on results
hook global -always BufOpenFifo '\*grep\*' %{ map global normal <minus> ': grep-next-match<ret>' }
hook global -always BufOpenFifo '\*make\*' %{ map global normal <minus> ': make-next-error<ret>' }
