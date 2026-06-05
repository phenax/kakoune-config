hook global BufSetOption filetype=(?:nix) %{
  define-snippet buffer snip-flake-mkderivation
  define-snippet buffer snip-flake-mkshell
}

define-command snip-flake-mkderivation %{
  prompt 'pname: ' %{
    set-register c %val{text}
    execute-keys '<esc>,istdenv.mkDerivation {<ret>'
    execute-keys '  pname = "<c-r>c";<ret>'
    execute-keys '  version = "0.0.0";<ret>'
    execute-keys '  src = fetchGithub {<ret>'
    execute-keys '    owner = "owner";<ret>'
    execute-keys '    repo = "repo";<ret>'
    execute-keys '    rev = "master";<ret>'
    execute-keys '    hash = lib.fakeHash;<ret>'
    execute-keys '  };<ret>'
    execute-keys '}'
  }
}

define-command snip-flake-mkshell %{
  execute-keys '<esc>,ipkgs.mkShell {<ret>'
  execute-keys '  buildInputs = with pkgs; [];<ret>'
  execute-keys '}'
}
