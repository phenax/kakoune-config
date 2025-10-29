define-command gitui -params .. %{
  terminal-singleton git \
    env "GIT_EDITOR=kak -c %val{session}" 'EDITOR=kcr edit' 'VISUAL=kcr edit' \
    gitu %arg{@}
}

declare-user-mode git
declare-user-mode git-r
map global user g ': enter-user-mode git<ret>' -docstring 'Git mode'
map global git s ': gitui<ret>' -docstring 'Git tui'
map global git A ': git add %val{buffile}<ret>' -docstring 'Add file'
map global git m ': git-line-blame<ret>' -docstring 'Blame selection lines'

map global git r ': enter-user-mode git-r<ret>' -docstring 'Git re(base/set) mode'
map global git-r f ': git reset HEAD^1 -- %val{buffile}<ret>' -docstring 'Split file out of last commit'

# Hunk
map global git n ': git next-hunk<ret>' -docstring 'Next hunk'
map global git p ': git prev-hunk<ret>' -docstring 'Previous hunk'
map global git h ': git-toggle-diff<ret>' -docstring 'Toggle hunk indicators'

set-option global git_diff_add_char "+"
set-option global git_diff_del_char "-"
set-option global git_diff_mod_char "~"
set-option global git_diff_top_char "^"

define-command git-toggle-diff %{
  try %{ remove-highlighter window/git-diff } catch %{ git show-diff } catch %{ }
}

define-command git-line-blame %{
  terminal-singleton git-blame sh -c \
    "git -p log -u -L '%sh{echo ""$kak_selection_desc"" | sed -E 's/\.[0-9]+//g'}:%val{buffile}' --color=always"
}
