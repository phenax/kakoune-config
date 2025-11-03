hook global BufCreate .*tmux[.]conf %{ set-option buffer filetype tcl }

hook global BufCreate .*zshrc %{ set-option buffer filetype sh }

