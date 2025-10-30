hook global BufSetOption filetype=(?:ruby) %{
  define-snippet buffer snip-rails-class
}

define-command snip-rails-class %{
  eval %sh{
    class_name=$(basename "$kak_bufname" .rb | sed -e 's/[^A-Za-z0-9]\(\w\)/\U\1/g' -e 's/^\w/\U\0/g')
    echo "set-register c $class_name"
  }
  execute-keys '<esc>,i# frozen_string_literal: true<ret><ret>'
  execute-keys 'class <c-r>c<ret>'
  execute-keys 'end'
}
