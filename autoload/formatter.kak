hook global BufSetOption filetype=json %{ set-option buffer formatcmd "jq" }

hook global BufSetOption filetype=fennel %{ set-option buffer formatcmd "fnlfmt -" }

hook global BufSetOption filetype=nix %{ set-option buffer formatcmd "nixfmt -" }

hook global BufSetOption filetype=(?:javascript|typescript) %{
  evaluate-commands %sh{
    if [ -f "$PWD/biome.json" ]; then
      echo "set-option buffer formatcmd %{npx biome check --fix --stdin-file-path=$kak_buffile 2>/dev/null}"
    fi
  }
}

hook global BufSetOption filetype=(?:ruby) %{
  evaluate-commands %sh{
    echo "set-option buffer formatcmd %{rubocop -x --stderr -s '$kak_buffile'}"
  }
}

