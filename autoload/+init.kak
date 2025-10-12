# Link builtin autoloads
nop %sh{ ln -s "$kak_runtime/rc" "$kak_config/autoload/standard-library" 2>/dev/null || true }
# evaluate-commands %sh{kak-tree-sitter -dksvv --init "${kak_session}"}
evaluate-commands %sh{kcr init kakoune}

colorscheme phenax
set-option global autoreload yes
set-option global incsearch true
set-option global indentwidth 2
set-option global tabstop 2
set-option global path -add "**"
set-option global startup_info_version 20250603
set-option global scrolloff 10,3
set-option global makecmd 'make -j8' # Override for others
set-option -add global ui_options \
                       terminal_assistant=none \
                       terminal_enable_mouse=false
set-option global modelinefmt \
  '{StatusLineDetails}{{context_info}} {{mode_info}}
%val{cursor_line}/%val{buf_line_count}:%val{cursor_char_column}
{StatusLineBufname}%sh{echo "$kak_bufname" | awk -F/ "{if (NF >= 2) {print \$(NF-1) \"/\" \$NF} else {print \$NF}}"}'

# Highlighters
add-highlighter global/ number-lines -relative -hlcursor -min-digits 3 -separator ' '
add-highlighter global/ column '%opt{autowrap_column}' WrapLine
add-highlighter global/ column '%val{cursor_char_column}' ColumnLine
add-highlighter global/ line '%val{cursor_line}' RowLine
add-highlighter global/ regex \h+$ 0:Error # Highlight trailing whitespaces
add-highlighter global/ wrap -word -indent # Softwrap long lines
add-highlighter global/ show-matching -previous
# add-highlighter global/search dynregex '%reg{/}' 0:search
hook global RegisterModified '/' %{ add-highlighter -override global/search regex "%reg{/}" 0:search }
map global user '<esc>' ':set-register slash ""<ret>'

# Mode cursors
set-face global InsertCursor default,red+B
hook global ModeChange .*:.*:insert %{
  set-face window PrimaryCursor InsertCursor
  set-face window PrimaryCursorEol InsertCursor
}
hook global ModeChange .*:insert:.* %{ try %{
  unset-face window PrimaryCursor
  unset-face window PrimaryCursorEol
} }

# File/buffer management
def find -docstring "find files" -menu -params 1 %{ edit -existing %arg{1} } \
         -shell-script-candidates %{ fd -t f --hidden --color=never -E .git }
set-option global grepcmd "rg -S --vimgrep --hidden -g '!**/.git/**'"

def file-manager -params .. %{ connect terminal env "EDITOR=kcr edit" daffm -c @kak %arg{@} }

declare-user-mode buffer
map global user b ':enter-user-mode buffer<ret>' -docstring 'Buffer mode'
map global buffer b ':buffer ' -docstring 'Switch buffer'
map global buffer d ':delete-buffer<ret>' -docstring 'Delete buffer'
map global buffer s ':write<ret>' -docstring 'Save'

declare-user-mode file
map global user f ':enter-user-mode file<ret>' -docstring 'File mode'
map global file f ':find ' -docstring 'Find files'
map global file g ':grep ' -docstring 'Grep'
map global file n ':file-manager %val{buffile}<ret>' -docstring 'File manager'

# TODO: Proper mappings for next/prev on results
hook global -always BufOpenFifo '\*grep\*' %{ map global normal <minus> ': grep-next-match<ret>' }
hook global -always BufOpenFifo '\*make\*' %{ map global normal <minus> ': make-next-error<ret>' }

# Git
def gitui -params .. %{ connect terminal env "EDITOR=kcr edit" gitu %arg{@} }

declare-user-mode git
map global user g ':enter-user-mode git<ret>' -docstring 'Git mode'
map global git n ':git next-hunk<ret>' -docstring 'Next hunk'
map global git p ':git prev-hunk<ret>' -docstring 'Previous hunk'
map global git s ':gitui<ret>' -docstring 'Git status UI'
set-option global git_diff_add_char "+"
set-option global git_diff_del_char "-"
set-option global git_diff_mod_char "~"
set-option global git_diff_top_char "^"
# hook global -group git-diff ModeChange .*:.*:normal %{ try %{git show-diff} }
# hook global -group git-diff WinCreate .* %{ try %{git show-diff} }

# Tmux window mode
declare-user-mode win
map global normal <c-w> ':enter-user-mode win<ret>' -docstring 'Window mode'
map global win q ':quit<ret>' -docstring 'Find files'
map global win v ':tmux-terminal-horizontal kak -c %val{session}<ret>' -docstring 'Split vertical'
map global win s ':tmux-terminal-vertical kak -c %val{session}<ret>' -docstring 'Split horizontal'
map global win h ':nop %sh{tmux select-pane -L}<ret>' -docstring 'Jump left'
map global win j ':nop %sh{tmux select-pane -D}<ret>' -docstring 'Jump down'
map global win k ':nop %sh{tmux select-pane -U}<ret>' -docstring 'Jump up'
map global win l ':nop %sh{tmux select-pane -R}<ret>' -docstring 'Jump right'

# Clipboard management mappings
map global user y "<a-|> xclip -selection clipboard<ret>" -docstring "yank the selection into the clipboard"
map global user p "<a-!> xclip -selection clipboard -o<ret>" -docstring "paste the clipboard"

declare-user-mode code
map global user c ':enter-user-mode code<ret>' -docstring 'Code mode'
map global code c :comment-line<ret> -docstring 'Comment/uncomment lines'
def casecamel %{ exec '`s[-_<space>]<ret>d~<a-i>w' }
def casesnake %{ exec '<a-:><a-;>s-|[a-z][A-Z]<ret>;a<space><esc>s[-\s]+<ret>c_<esc><a-i>w`' }
def casekebab %{ exec '<a-:><a-;>s_|[a-z][A-Z]<ret>;a<space><esc>s[_\s]+<ret>c-<esc><a-i>w`' }
map global code <a-k> :casekebab<ret> -docstring 'kebab-casing'
map global code <a-s> :casesnake<ret> -docstring 'snake_casing'
map global code <a-c> :casecamel<ret> -docstring 'camelCasing'

map global normal <c-j> 15j
map global normal <c-k> 15k

# Editorconfig
hook global BufOpenFile .* %{ try %{editorconfig-load} }
hook global BufNewFile .* %{ try %{editorconfig-load} }

