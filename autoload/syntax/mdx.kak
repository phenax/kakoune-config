hook global BufCreate .*[.]mdx %{
  set-option buffer filetype markdown
}
