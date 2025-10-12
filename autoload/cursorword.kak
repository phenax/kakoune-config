declare-option -hidden regex curword

hook global NormalIdle .* %{
  eval -draft %{try %{
    exec <space><a-i>w <a-k>\A\w+\z<ret>
    set-option buffer curword "\b\Q%val{selection}\E\b"
  } catch %{
    set-option buffer curword ''
  }}
}

add-highlighter global/ dynregex '%opt{curword}' 0:CurWord
