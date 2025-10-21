# declare-option -hidden str-list snippet_list

# define-command snippets-insert %{
#   evaluate-commands %sh{
#     cmds="echo $(echo "$kak_opt_snippet_list" | sed 's/=.*//')"
#     # TODO: Fix this shit
#     echo "prompt -menu -shell-script-candidates '$cmd' 'Snippet: ' 'evaluate-commands %val{text}'"
#   }
# }

# map global normal <c-p> ':snippets-insert<ret>'

# define-command define-snippet -params 3 %{
#   set-option -add %arg{1} snippet_list %sh{ echo -e "$2=$3\n" }
# }

# define-snippet global "React component" snip-react-component
# define-snippet global "React useState" snip-react-usestate

# # hook global BufSetOption filetype=(?:javascript|typescript) %{
# #   define-snippet buffer "React component" snip-react-component
# #   define-snippet buffer "React useState" snip-react-usestate
# # }

# define-command snip-react-usestate %{
#   prompt 'Name: ' %{
#     evaluate-commands %sh{
#       echo "info %{$kak_text}"
#       st=$(echo "$kak_text" | sed 's/^[A-Z]/\L\0/')
#       setst="set$(echo "$kak_text" | sed 's/^[a-z]/\U\0/')"
#       echo "execute-keys '<esc>,iconst [$st, $setst] = useState();<esc>'"
#     }
#   }
# }

# define-command snip-react-component %{
#   prompt 'Component name: ' %{
#     execute-keys "<esc>,iconst %val{text} = ({ children }: React.PropsWithChildren) => {<ret>"
#     execute-keys "  return <lt>div><lt>/div>;"
#     execute-keys "<ret>}<esc>"
#   }
# }
