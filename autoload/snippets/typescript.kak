hook global BufSetOption filetype=(?:javascript|typescript|jsx|tsx) %{
  define-snippet buffer snip-react-component
  define-snippet buffer snip-react-usestate
}

define-command snip-react-usestate %{
  prompt 'Name: ' %{
    set-register n %val{text}
    prompt 'Initial value: ' %{
      set-register v %val{text}
      evaluate-commands %sh{
        st=$(echo "$kak_reg_n" | sed 's/^[A-Z]/\L\0/')
        setst="set$(echo "$kak_reg_n" | sed 's/^[a-z]/\U\0/')"
        echo "execute-keys '<esc>,iconst [$st, $setst] = useState($kak_reg_v);<esc>'"
      }
    }
  }
}

define-command snip-react-component %{
  prompt 'Component name: ' %{
    execute-keys "<esc>,itype %val{text}Prop = {<ret>}<ret><ret>"
    execute-keys "<esc>,iexport const %val{text} = ({  }: %val{text}Prop) => {<ret>"
    execute-keys "  return <lt>div><lt>/div>;"
    execute-keys "<ret>};<esc>kwlt;"
  }
}
