# declare-option -hidden regex curword

# # Highlight word under cursor
# add-highlighter global/ dynregex '%opt{curword}' 0:CurWord
# hook global NormalIdle .* %{
#   eval -draft %{ try %{
#     exec <a-i>w<a-k>\A\w+\z<ret>
#     set-option buffer curword "\b\Q%val{selection}\E\b"
#   } catch %{
#     set-option buffer curword ''
#   } }
# }

# Change cursor face based on mode
hook global ModeChange .*:.*:insert %{
  set-face window PrimaryCursor InsertCursor
  set-face window PrimaryCursorEol InsertCursor
}
hook global ModeChange .*:insert:.* %{ try %{
  unset-face window PrimaryCursor
  unset-face window PrimaryCursorEol
} }
