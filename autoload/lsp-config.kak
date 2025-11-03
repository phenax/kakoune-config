eval %sh{kak-lsp}
# Disable default server configs
remove-hooks global lsp-filetype-javascript
remove-hooks global lsp-filetype-c-family
remove-hooks global lsp-filetype-ruby
remove-hooks global lsp-filetype-haskell

set-option global lsp_file_watch_support true
set-option global lsp_snippet_support true
set-option global lsp_diagnostic_line_error_sign ''
set-option global lsp_diagnostic_line_warning_sign ''
set-option global lsp_diagnostic_line_info_sign '■'
set-option global lsp_diagnostic_line_hint_sign '■'
lsp-enable

lsp-inlay-diagnostics-enable global

map global user l ': enter-user-mode lsp<ret>' -docstring 'LSP mode'
# map global user t ':enter-user-mode tree-sitter<ret>' -docstring 'Treesitter mode'
map global object f '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
map global object t '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
map global object d '<a-semicolon>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'

map global insert <c-n> '<a-;>: lsp-snippets-select-next-placeholders<ret>' -docstring 'Select next snippet placeholder'
hook global InsertCompletionShow .* %{
  unmap global insert <c-n> '<a-;>: lsp-snippets-select-next-placeholders<ret>'
}
hook global InsertCompletionHide .* %{
  map global insert <c-n> '<a-;>: lsp-snippets-select-next-placeholders<ret>' -docstring 'Select next snippet placeholder'
}

hook global BufSetOption filetype=(?:javascript|typescript|tsx|jsx) %{
  set-option buffer lsp_servers %{
    [typescript-language-server]
    args = ["--stdio"]
    root_globs = ["package.json", "tsconfig.json", "jsconfig.json", ".git"]
    settings_section = "_"
    [typescript-language-server.settings]
    format = { enable = false }
    [typescript-language-server.settings._]
    quotePreference = "single"

    [tailwindcss-language-server]
    args = ["--stdio"]
    root_globs = ["tailwind.*", "postcss.config.*"]
    [tailwindcss-language-server.settings.tailwindCSS]
    editor = {}

    [biome]
    args = ["lsp-proxy"]
    root_globs = ["biome.json"]
  }
}

hook global BufSetOption filetype=(?:c|cpp|objc) %{
  set-option buffer lsp_servers %{
    [clangd]
    args = [ "--log=info", "--clang-tidy" ]
    root_globs = ["compile_commands.json", ".clangd", ".git"]
  }
}

hook global BufSetOption filetype=ruby %{
  set-option buffer lsp_servers %{
    [ruby-lsp]
    args = ["stdio"]
    root_globs = ["Gemfile"]

    [rubocop]
    command = "bundle"
    args = ["exec", "rubocop", "--lsp"]
    root_globs = ["Gemfile", ".git"]
  }
}

hook -group lsp-filetype-haskell global BufSetOption filetype=haskell %{
  set-option buffer lsp_servers %{
    [haskell-language-server]
    command = "haskell-language-server-wrapper"
    args = ["--lsp"]
    root_globs = ["hie.yaml", "cabal.project", "Setup.hs", "stack.yaml", "*.cabal"]
    settings_section = "_"
    [haskell-language-server.settings]
    hlintOn = true
    [haskell-language-server.settings._]
    haskell.formattingProvider = "ormolu"
  }
}

hook global WinSetOption filetype=.* %{
  hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
  hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
  hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
  hook -once -always window WinSetOption filetype=.* %{ remove-hooks window semantic-tokens }

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
