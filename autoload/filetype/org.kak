hook global BufCreate .*[.]org %{
  set-option buffer filetype org
}

hook global WinSetOption filetype=org %{
  add-highlighter window/org ref org
  require-module orgmode-highlight
}

provide-module orgmode-highlight %{
  add-highlighter shared/org regions
  add-highlighter shared/org/inline default-region regions
  add-highlighter shared/org/inline/text default-region group

  add-highlighter shared/org/inline/text/ regex \*[^\n*]+\* 0:inlineBold
  add-highlighter shared/org/inline/text/ regex /[^\n/]+/ 0:inlineItalic
  add-highlighter shared/org/inline/text/ regex _[^\n_]+_ 0:inlineUnderline
  add-highlighter shared/org/inline/text/ regex \+[^\n+]+\+ 0:inlineStrikethrough
  add-highlighter shared/org/inline/text/ regex ~[^\n~]+~ 0:inlineCode
  add-highlighter shared/org/inline/text/ regex \[\[[^\n]+\]\] 0:inlineLink
  add-highlighter shared/org/codeblock region -match-capture \
    ^\h*#\+(?:begin|BEGIN)_([a-zA-Z]*)[^\n]*$ \
    ^\h*#\+(?:end|END)_([a-zA-Z]*)[^\n]*$ \
    regions
  add-highlighter shared/org/codeblock/ default-region fill orgCodeBlock

  add-highlighter shared/org/inline/text/ regex ^[*]{1}[^\n]* 0:header1
  add-highlighter shared/org/inline/text/ regex ^[*]{2}[^\n]* 0:header2
  add-highlighter shared/org/inline/text/ regex ^[*]{3}[^\n]* 0:header3
  add-highlighter shared/org/inline/text/ regex ^[*]{4}[^\n]* 0:header4
  add-highlighter shared/org/inline/text/ regex ^[*]{5}[^\n]* 0:header5
  add-highlighter shared/org/inline/text/ regex ^[*]{6}[^\n]* 0:header6

  add-highlighter shared/org/inline/text/ regex ^[*]*\s+(TODO) 1:orgTaskStateTodo
  add-highlighter shared/org/inline/text/ regex ^[*]*\s+(DONE) 1:orgTaskStateDone
  add-highlighter shared/org/inline/text/ regex ^[*]*\s+(ACTIVE) 1:orgTaskStateActive

  add-highlighter shared/org/inline/text/ regex ^\s*-\s*(\[[xX]\])\h([^\n]+)$ 1:checkboxChecked 2:checkboxCheckedText
  add-highlighter shared/org/inline/text/ regex ^\s*-\s*(\[[\s]\]) 1:checkboxTodo
  add-highlighter shared/org/inline/text/ regex ^\s*-\s*(\[[-]\]) 1:checkboxPending
}
