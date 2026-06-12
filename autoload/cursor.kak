# Change cursor face based on mode
hook global ModeChange .*:.*:insert %{
  set-face window PrimaryCursor InsertCursor
  set-face window PrimaryCursorEol InsertCursor
}
hook global ModeChange .*:insert:.* %{ try %{
  unset-face window PrimaryCursor
  unset-face window PrimaryCursorEol
} }

# set-option global idle_timeout 100

# hook global NormalIdle .* %{
#   eval -draft %{ try %{
#     exec ,<a-i>w <a-k>\A\w+\z<ret>
#     add-highlighter -override global/curword regex "\b\Q%val{selection}\E\b" 0:CurWord
#   } catch %{
#     add-highlighter -override global/curword group
#   } }
# }
