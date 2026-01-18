# Change cursor face based on mode
hook global ModeChange .*:.*:insert %{
  set-face window PrimaryCursor InsertCursor
  set-face window PrimaryCursorEol InsertCursor
}
hook global ModeChange .*:insert:.* %{ try %{
  unset-face window PrimaryCursor
  unset-face window PrimaryCursorEol
} }
