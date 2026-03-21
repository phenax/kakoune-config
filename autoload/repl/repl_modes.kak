define-repl-mode global s 'Shell' %{ set global xrepl_current_cmd '$SHELL' }
define-repl-mode global n 'Node' %{ set global xrepl_current_cmd 'node' }
define-repl-mode global a 'AI: Claude' %{ set global xrepl_current_cmd 'claude' }

# TODO: doesnt work
# define-repl-mode global C 'Custom' %{
#   prompt -shell-completion 'Command: ' '
#     set global xrepl_current_cmd "node"
#   '
# }

hook global BufSetOption filetype=haskell %{
  define-repl-mode buffer h 'Haskell: cabal test' %{
    set global xrepl_current_cmd 'cabal test'
    set global xrepl_current_clear_screen true
  }
}

hook global BufSetOption filetype=ruby %{
  # TODO: Make generic
  define-repl-mode buffer c 'Rails console' %{
    set global xrepl_current_cmd "just server-rails c"
  }
  define-repl-mode buffer r 'Rspec' %{
    set global xrepl_current_cmd '$SHELL'
    set global xrepl_current_transform 'cat > /dev/null
      path="$kak_buffile"
      if [ $kak_cursor_line -gt 5 ]; then
        path="$path:$kak_cursor_line"
      fi
      KAK_BUNDLE_EXEC=${KAK_BUNDLE_EXEC:-"bundle exec"}
      echo "$KAK_BUNDLE_EXEC rspec -fd $path"
    '
    set global xrepl_current_clear_screen true
  }
}

hook global BufSetOption filetype=(?:javascript|typescript|jsx|tsx) %{
  # TODO: Search for root cypress config file and cd into it
  # set global xrepl_current_cmd '(echo "::$kak_config::" | tee foob) && '
  define-repl-mode buffer c 'Cypress' %{
    set global xrepl_current_cmd '$SHELL'
    set global xrepl_current_transform 'cat > /dev/null
      cypress_config_files="cypress.config.json cypress.config.ts cypress.config.js"
      project=$($kak_config/scripts/utils.sh find_closest "$kak_buffile" $cypress_config_files)
      echo "npx cypress run --headless --e2e -P" "''$project''" "--spec ''$kak_buffile'';"
    '
    set global xrepl_current_clear_screen true
  }
  define-repl-mode global j 'Jest' %{
    set global xrepl_current_cmd '$SHELL'
    set global xrepl_current_transform 'cat > /dev/null
      echo "sh -c \\"cd ''$(dirname "$kak_buffile")''; npx jest --runTestsByPath ''$kak_buffile''\\";"
    '
    set global xrepl_current_clear_screen true
  }
}

hook global BufSetOption filetype=clojure %{
  # TODO: Just temporary for messing around. Remove module name
  map buffer repl r ': xrepl-send-text %{(require ''[pluribus.core :as p] :reload)}; xrepl-send-keys Enter<ret>' -docstring 'Cljs reload'
  define-repl-mode buffer j 'Clojurescript repl' %{
    set global xrepl_current_cmd 'clj -M -m cljs.main --repl-opts "{:launch-browser false}" --compile pluribus.core --repl'
    set global xrepl_current_split_size 30%%
    set global xrepl_current_split_vertical true
  }
}
