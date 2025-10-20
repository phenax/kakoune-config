set-option global makecmd 'make -j8'

# TODO: For some reason <ret> doesnt jump to error
hook global BufSetOption filetype=(?:typescript|javascript) %{
  set-option global makecmd "%val{config}/scripts/tsc-vimgrep.sh"
}

hook global BufSetOption filetype=haskell %{
  set-option global makecmd "cabal build"
}

hook global BufSetOption filetype=rust %{
  set-option global makecmd "cargo build"
}
