set-option global makecmd 'echo "Build command not set"; exit 1'

# TODO: For some reason <ret> doesnt jump to error
hook global BufSetOption filetype=(?:typescript|javascript|jsx|tsx) %{
  set-option buffer makecmd "%val{config}/scripts/tsc-vimgrep.sh"
}

hook global BufSetOption filetype=haskell %{ set-option buffer makecmd "cabal build" }

hook global BufSetOption filetype=rust %{ set-option buffer makecmd "cargo build" }

provide-module make-override %{
  define-command -params .. -override -docstring %{
    make [<arguments>]: make utility wrapper
    All the optional arguments are forwarded to the make utility
  } make %{
    evaluate-commands -save-regs m %{
      set-register m %opt{makecmd}
      evaluate-commands -try-client %opt{toolsclient} %{
        fifo -scroll -name *make* -script %{
          trap - INT QUIT
          trap 'echo -e "\n\nExited with $?" >&2' EXIT
          eval "$kak_reg_m \"\$@\""
        } -- %arg{@}
        set-option buffer filetype make
        set-option buffer jump_current_line 0
      }
    }
  }
}

hook -once global KakBegin .* %{ require-module make-override }
