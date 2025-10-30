hook global BufSetOption filetype=(?:kak) %{
  define-snippet buffer snip-kak-define
  define-snippet buffer snip-kak-hook
}

define-command snip-kak-define %{
  prompt 'Command: ' %{
    set-register c %val{text}
    execute-keys '<esc>,idefine-command <c-r>c %{<ret>'
    execute-keys '}'
  }
}

define-command snip-kak-hook %{
  prompt 'Event: ' %{
    set-register c %val{text}
    execute-keys '<esc>,ihook global <c-r>c .* %{<ret>'
    execute-keys '}'
  }
}
