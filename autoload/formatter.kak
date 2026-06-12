declare-option str formatlspserver;

hook global BufSetOption filetype=json %{ set-option buffer formatcmd "jq" }

hook global BufSetOption filetype=fennel %{ set-option buffer formatcmd "fnlfmt -" }

hook global BufSetOption filetype=nix %{ set-option buffer formatcmd "nixfmt -" }

hook global BufSetOption filetype=ruby %{
  set-option buffer formatcmd "bundle exec rubocop -a --stderr --stdin '%val{buffile}'"
}

hook global BufSetOption filetype=(?:javascript|typescript|jsx|tsx) %{
  set-option buffer formatcmd "biome format --stdin-file-path='%val{buffile}'"
}

hook global BufSetOption filetype=(?:c|cpp) %{
  set-option buffer formatcmd "clang-format --assume-filename='%val{buffile}'"
}

define-command apply-formatting -docstring 'Apply formatting with formatcmd or lsp' %{
  eval %sh{
    if [ -n "$kak_opt_formatcmd" ]; then
      echo format-buffer
    elif [ -n "$kak_opt_formatlspserver" ]; then
      echo "lsp-formatting-sync $kak_opt_formatlspserver"
    else
      echo lsp-formatting-sync
    fi
  }
}

define-command biome -params .. -docstring 'Format project using biome' %{
  info %sh{ npx biome check --fix "$@" && echo "Success" || echo "Failed" }
}
