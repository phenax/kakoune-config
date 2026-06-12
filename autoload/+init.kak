# Link builtin autoloads
nop %sh{
  rm -f "$kak_config/autoload/standard-library" || true
  ln -sf "$kak_runtime/rc" "$kak_config/autoload/standard-library" 2>/dev/null || true
  rm -f "$kak_config/autoload/plugins" || true
  ln -sf "$kak_runtime/autoload/plugins" "$kak_config/autoload/plugins" 2>/dev/null || true
}

# Disabled treesitter because eh
# eval %sh{kak-tree-sitter -dksvv --init "${kak_session}" --with-highlighting --with-text-objects}
eval %sh{kcr init kakoune}

colorscheme phenax
set-option global autoreload yes
set-option global incsearch true
set-option global indentwidth 2
set-option global tabstop 2
set-option -add global path "**"
set-option global startup_info_version 20250603
set-option global scrolloff 10,3
set-option -add global ui_options terminal_enable_mouse=false terminal_set_title=true
# terminal_status_on_top=true

# Modeline
# declare-option -hidden _lsp_modeline_diagnostics "%opt{lsp_diagnostic_error_count}"
# %opt{lsp_modeline_breadcrumbs}
set-option global modelinefmt \
'{StatusLineExtras}%opt{lsp_modeline_progress}
{StatusLineDetails}{{context_info}} {{mode_info}}
%val{cursor_line}/%val{buf_line_count}:%val{cursor_char_column}
{StatusLineBufname}%sh{echo "$kak_bufname" | awk -F/ "{if (NF >= 2) {print \$(NF-1) \"/\" \$NF} else {print \$NF}}"}'

# Highlighters
add-highlighter global/ number-lines -hlcursor -min-digits 3 -separator ' ' -relative
add-highlighter global/ column '%val{cursor_char_column}' ColumnLine
add-highlighter global/ line '%val{cursor_line}' RowLine
add-highlighter global/ regex \h+$ 0:Error # Highlight trailing whitespaces
add-highlighter global/ show-matching -previous
add-highlighter global/ show-whitespaces -spc ' ' -tab '│' -lf '¬' -indent '│'
hook global RegisterModified '/' %{
  # Highlight search
  add-highlighter -override global/search regex "%reg{/}" 0:search
}

# Preserve count for user modes (look for alternatives)
declare-option -hidden int user_mode_count 0
define-command enter-user-mode-with-count -params 1 %{
  set-option window user_mode_count %val{count}
  enter-user-mode %arg{1}
}
