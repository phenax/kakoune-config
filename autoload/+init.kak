# Link builtin autoloads
nop %sh{ ln -s "$kak_runtime/rc" "$kak_config/autoload/standard-library" 2>/dev/null || true }
# evaluate-commands %sh{kak-tree-sitter -dksvv --init "${kak_session}"}
evaluate-commands %sh{kcr init kakoune}

hook global KakBegin .* %{
  require-module luar
  set-option global luar_interpreter luajit
}

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
                       terminal_enable_mouse=false
                       # terminal_assistant=none \
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

# Search
hook global RegisterModified '/' %{ add-highlighter -override global/search regex "%reg{/}" 0:search }
map global user '<esc>' ': set-register slash ""<ret>'
map global user '/' '/(?i)'
map global user 'r' '*%s<ret>'

# Preserve count for user modes (look for alternatives)
# TODO: Reset count on modechange?
declare-option -hidden int user_mode_count 0
define-command enter-user-mode-with-count -params 1 %{
  set-option window user_mode_count %val{count}
  enter-user-mode %arg{1}
}

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

# Tmux window mode
declare-user-mode win
map global normal <c-w> ':enter-user-mode win<ret>' -docstring 'Window mode'
map global win q ': quit<ret>' -docstring 'Quit'
map global win v ': tmux-terminal-horizontal kak -c %val{session}<ret>' -docstring 'Split vertical'
map global win s ': tmux-terminal-vertical kak -c %val{session}<ret>' -docstring 'Split horizontal'
map global win h ': nop %sh{tmux select-pane -L}<ret>' -docstring 'Jump left'
map global win j ': nop %sh{tmux select-pane -D}<ret>' -docstring 'Jump down'
map global win k ': nop %sh{tmux select-pane -U}<ret>' -docstring 'Jump up'
map global win l ': nop %sh{tmux select-pane -R}<ret>' -docstring 'Jump right'
map global win z ': wq<ret>'

# Clipboard management mappings
map global user y "<a-|> xclip -selection clipboard<ret>" -docstring "yank the selection into the clipboard"
map global user p "<a-!> xclip -selection clipboard -o<ret>" -docstring "paste the clipboard"

# Code mode
declare-user-mode code
map global user c ':enter-user-mode code<ret>' -docstring 'Code mode'
map global code c :comment-line<ret> -docstring 'Comment/uncomment lines'
def casecamel %{ exec '`s[-_<space>]<ret>d~<a-i>w' }
def casesnake %{ exec '<a-:><a-;>s-|[a-z][A-Z]<ret>;a<space><esc>s[-\s]+<ret>c_<esc><a-i>w`' }
def casekebab %{ exec '<a-:><a-;>s_|[a-z][A-Z]<ret>;a<space><esc>s[_\s]+<ret>c-<esc><a-i>w`' }
map global code <a-k> :casekebab<ret> -docstring 'kebab-casing'
map global code <a-_> :casesnake<ret> -docstring 'snake_casing'
map global code <a-c> :casecamel<ret> -docstring 'camelCasing'

# Quick move
map global normal <c-j> 15j
map global normal <c-k> 15k

# Editorconfig
hook global BufOpenFile .* %{ try %{editorconfig-load} }
hook global BufNewFile .* %{ try %{editorconfig-load} }

