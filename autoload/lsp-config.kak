eval %sh{kak-lsp}
set-option global lsp_file_watch_support true
set-option global lsp_snippet_support true
set-option global lsp_diagnostic_line_error_sign ''
set-option global lsp_diagnostic_line_warning_sign ''
set-option global lsp_diagnostic_line_info_sign '■'
set-option global lsp_diagnostic_line_hint_sign '■'
lsp-enable

map global user l ':enter-user-mode lsp<ret>' -docstring 'LSP mode'

map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object f '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
map global object t '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
map global object d '<a-semicolon>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
map global object D '<a-semicolon>lsp-diagnostic-object<ret>' -docstring 'LSP errors'

map global insert <c-n> '<a-;>:lsp-snippets-select-next-placeholders<ret>' -docstring 'Select next snippet placeholder'
hook global InsertCompletionShow .* %{
  unmap global insert <c-n> '<a-;>:lsp-snippets-select-next-placeholders<ret>'
}
hook global InsertCompletionHide .* %{
  map global insert <c-n> '<a-;>:lsp-snippets-select-next-placeholders<ret>' -docstring 'Select next snippet placeholder'
}

hook global BufSetOption filetype=(?:javascript|typescript) %{
  set-option buffer lsp_servers %{
    [typescript-language-server]
    root_globs = ["package.json", "tsconfig.json", "jsconfig.json", ".git"]
    args = ["--stdio"]
    [tailwindcss-language-server]
    root_globs = ["tailwind.*", "postcss.*"]
    args = ["--stdio"]
    [tailwindcss-language-server.settings.tailwindCSS]
    editor = {}
    # [biome]
    # root_globs = ["biome.json", "package.json", "tsconfig.json", "jsconfig.json"]
    # args = ["lsp-proxy"]
  }
}

hook global BufSetOption filetype=ruby %{
  set-option buffer lsp_servers %{
    [ruby-lsp]
    root_globs = ["Gemfile"]
    args = ["stdio"]
  }
}

hook global WinSetOption filetype=(?:javascript|typescript|ruby) %{
  hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
  hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
  hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
  hook -once -always window WinSetOption filetype=.* %{
    remove-hooks window semantic-tokens
  }

  set-option window lsp_semantic_tokens %{
    [
      {face="documentation", token="comment", modifiers=["documentation"]},
      {face="comment", token="comment"},
      {face="function", token="function"},
      {face="function", token="method"},
      {face="keyword", token="keyword"},
      {face="module", token="namespace"},
      {face="operator", token="operator"},
      {face="string", token="string"},
      {face="type", token="type"},
      {face="variable", token="variable"},
      {face="const_variable", token="variable", modifiers=["readonly"]},
      {face="const_variable", token="variable", modifiers=["constant"]},
    ]
  }
}

