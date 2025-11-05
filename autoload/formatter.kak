declare-option str formatlspserver;

hook global BufSetOption filetype=json %{ set-option buffer formatcmd "jq" }

hook global BufSetOption filetype=fennel %{ set-option buffer formatcmd "fnlfmt -" }

hook global BufSetOption filetype=nix %{ set-option buffer formatcmd "nixfmt -" }

hook global BufSetOption filetype=ruby %{ set-option buffer formatlspserver rubocop }

hook global BufSetOption filetype=(?:javascript|typescript|jsx|tsx) %{
  evaluate-commands %sh{
    if [ -f "$PWD/biome.json" ]; then
      echo "set-option buffer formatlspserver biome"
    else
      echo "set-option buffer formatlspserver typescript-language-server"
    fi
  }
}
define-command biome -docstring 'Format file on disk using biome' %{
  nop %sh{ npx biome check --fix --stdin-file-path=$kak_buffile }
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
