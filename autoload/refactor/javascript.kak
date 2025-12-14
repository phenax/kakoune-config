hook global BufSetOption filetype=(?:javascript|typescript|jsx|tsx) %{
  map global refactor o ': js-test-toggle-it-state<ret>' -docstring 'Toggle it/it.only'
}

# TODO: Doesnt work right. Switch to treesitter code mods
define-command js-test-toggle-it-state %{
  try %{
    execute-keys 'Z<a-;><a-i>imxsit\(<ret>cit.only(<esc>z'
  } catch %{
    execute-keys 'Z<a-;><a-i>imxsit\.only\(<ret>cit(<esc>z'
  }
}
