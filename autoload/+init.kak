# Link builtin autoloads
nop %sh{ ln -sf "$kak_runtime/rc" "$kak_config/autoload/standard-library" 2>/dev/null || true }

eval %sh{kak-tree-sitter -dksvv --init "${kak_session}" --with-highlighting --with-text-objects}
eval %sh{kcr init kakoune}

hook global KakBegin .* %{
  require-module luar
  set-option global luar_interpreter luajit
}

colorscheme phenax
set-option global autoreload yes
set-option global incsearch true
set-option global indentwidth 2
set-option global tabstop 2
set-option -add global path "**"
set-option global startup_info_version 20250603
set-option global scrolloff 10,3
set-option -add global ui_options terminal_enable_mouse=false terminal_set_title=true
set-option global modelinefmt \
'%opt{lsp_modeline_progress} {StatusLineDetails}{{context_info}} {{mode_info}}
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
add-highlighter global/ show-whitespaces -spc ' ' -tab '│' -lf '¬' -indent '│'
hook global RegisterModified '/' %{
  # Highlight current searchterm
  add-highlighter -override global/search regex "%reg{/}" 0:search
}

# Misc keys
map global user '<esc>' ': set-register slash ""<ret>' -docstring 'Clear search highlighting'
map global normal '/' '/(?i)' # Remap / to case-insensitive search
map global user '/' '/'
map global user s ': w<ret>' -docstring 'Save'
map global normal <c-j> 15j -docstring '15 down'
map global normal <c-k> 15k -docstring '15 up'

map global user y "<a-|> xclip -selection clipboard<ret>" -docstring "yank the selection into the clipboard"
map global user p "<a-!> xclip -selection clipboard -o<ret>" -docstring "paste the clipboard"

declare-user-mode system
map global user q ': enter-user-mode system<ret>' -docstring 'System mode'
map global system o ':echo %opt{}<left>' -docstring 'Print opt'
map global system v ':echo %val{}<left>' -docstring 'Print value'
map global system d ': buffer *debug*<ret>' -docstring 'Switch to debug buffer'
map global system f ':set buffer filetype ' -docstring 'Set filetype'
map global system m ':set buffer makecmd ""<left>' -docstring 'Set compile command'
map global system p ': info %val{buffile}<ret>' -docstring 'Print file path'

# Preserve count for user modes (look for alternatives)
# TODO: Reset count on modechange?
declare-option -hidden int user_mode_count 0
define-command enter-user-mode-with-count -params 1 %{
  set-option window user_mode_count %val{count}
  enter-user-mode %arg{1}
}

# Code mode
declare-user-mode code
map global user c ': enter-user-mode code<ret>' -docstring 'Code mode'
map global code c ': comment-line<ret>' -docstring 'Comment/uncomment lines'
map global code f ': apply-formatting<ret>' -docstring 'Apply configured formatter'
def casecamel %{ exec '`s[-_<space>]<ret>d~<a-i>w' }
def casesnake %{ exec '<a-:><a-;>s-|[a-z][A-Z]<ret>;a<space><esc>s[-\s]+<ret>c_<esc><a-i>w`' }
def casekebab %{ exec '<a-:><a-;>s_|[a-z][A-Z]<ret>;a<space><esc>s[_\s]+<ret>c-<esc><a-i>w`' }
map global code <a-minus> ': casekebab<ret>' -docstring 'kebab-casing'
map global code <a-_> ': casesnake<ret>' -docstring 'snake_casing'
map global code <a-c> ': casecamel<ret>' -docstring 'camelCasing'

declare-user-mode ai
map global code a ': enter-user-mode ai<ret>' -docstring 'AI'
map global ai ! '!ai ""<left>' -docstring 'Insert output'
map global ai | '|ai ""<left>' -docstring 'Replace output'

# Editorconfig
hook global BufOpenFile .* %{ try %{ editorconfig-load } }
hook global BufNewFile .* %{ try %{ editorconfig-load } }
