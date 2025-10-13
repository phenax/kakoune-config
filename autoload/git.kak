define-command gitui -params .. %{ connect terminal env "EDITOR=kcr edit" gitu %arg{@} }

declare-user-mode git
map global user g ':enter-user-mode git<ret>' -docstring 'Git mode'
map global git s ':gitu<ret>' -docstring 'Gitu tui'
map global git A ':git add %val{buffile}<ret>' -docstring 'Add file'
map global git c ':git add commit<ret>' -docstring 'Commit'
map global git C ':git add commit --amend<ret>' -docstring 'Amend commit'

# Hunk
map global git n ':git next-hunk<ret>' -docstring 'Next hunk'
map global git p ':git prev-hunk<ret>' -docstring 'Previous hunk'

set-option global git_diff_add_char "+"
set-option global git_diff_del_char "-"
set-option global git_diff_mod_char "~"
set-option global git_diff_top_char "^"

hook global -group git-diff-if-repo EnterDirectory .* %{
  # TODO: Disable git hunk highlight for non-git repos
  remove-hooks global git-diff
  hook global -group git-diff ModeChange .*:.*:normal %{ try %{git show-diff} }
  hook global -group git-diff WinCreate .* %{ try %{git show-diff} }
}

# Git window actions

# declare-option -hidden str git_file
# define-command -hidden git-eval-status-line %{
#   evaluate-commands %sh{
#     file=$(echo "$kak_selection" | sed 's/^\s*[A-Z?]\+\s\+//')
#     echo "set-option window git_file '$file'"
#   }
# }

# declare-user-mode git-status-commit
# declare-user-mode git-status-log
# map global git s ':git status -bs<ret>' -docstring 'Git status UI'
# hook -group git-status global WinSetOption filetype=git-status %{
#   set-option buffer readonly true
#   map window normal R ':git status -bs<ret>'
#   map window normal q ': delete-buffer %val{buffile}<ret>'

#   map window user l ': enter-user-mode git-status-log<ret>'
#   map window git-status-log l ': git log --oneline<ret>'
#   map window normal d 'x: git-eval-status-line<ret>: git diff -- %opt{git_file}'

#   map window normal c ': enter-user-mode git-status-commit<ret>'
#   map window git-status-commit c ': git commit<ret>'
#   map window git-status-commit a ': git commit --amend<ret>'
# }

# hook -group git-log global WinSetOption filetype=git-log %{
#   set-option buffer readonly true
#   map window normal q ': git status -bs<ret>'
# }

# hook -group git-diff global WinSetOption filetype=git-diff %{
#   set-option buffer readonly true
#   map window normal q ': git status -bs<ret>'
# }
