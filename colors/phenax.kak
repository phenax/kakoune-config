evaluate-commands %sh{
  foreground="rgb:c5c8c6"
  foreground2="rgb:90a0a0"
  foreground3="rgb:709090"
  foreground4="rgb:405050"
  background="default"
  accent1="rgb:007070"
  accent2="rgb:009090"
  accent3="rgb:2dd4bf"
  selection="rgb:373b41"
  window="rgb:282a2e"
  linenr_bg="default"
  linenr_fg="rgb:606262"
  linenr_fg_cur="rgb:ffffff"
  menu="rgb:101414"
  mildhighlight1="rgb:101414"
  mildhighlight2="rgb:202424"
  comment="rgb:434545"
  red="rgb:cc6666"
  orange="rgb:de935f"
  yellow="rgb:f0c674"
  green="rgb:b3f6c0"
  blue1="rgb:81a2be"
  blue2="rgb:81dad9"
  blue3="rgb:82aaff"
  aqua="rgb:8abeb7"
  purple="rgb:b294bb"
  black="rgb:000000"

  ## code
  echo "
    face global value ${blue1}
    face global type ${blue1}
    face global variable ${blue1}
    face global module ${blue1}
    face global function ${blue2}
    face global string ${green}
    face global keyword ${accent2}
    face global operator ${aqua}
    face global attribute ${blue1}
    face global comment ${comment}
    face global documentation comment
    face global meta ${foreground}
    face global builtin ${yellow}
    face global const_variable ${blue1}
  "

  ## markup
  echo "
    face global title ${blue1}
    face global header ${accent2}
    face global mono ${green}
    face global block ${orange}
    face global link ${blue1}
    face global bullet ${red}
    face global list ${red}
    face global inlineBold ${green}+b
    face global inlineItalic +i
    face global inlineStrikethrough ${foreground3}+fs
    face global inlineUnderline ${foreground}+fu
    face global inlineCode ${foreground2},${mildhighlight2}+a
    face global inlineLink ${accent2}+a
    face global header1 ${accent3}+b
    face global header2 ${accent1}+b
    face global header3 ${blue1}+b
    face global header4 ${green}+b
    face global header5 ${purple}+b
    face global header6 ${aqua}+b
    face global checkboxChecked ${foreground3}
    face global checkboxCheckedText ${foreground3}+s
    face global checkboxPending ${orange}
    face global checkboxTodo ${red}
    face global orgTaskStateTodo ${black},${red}+b
    face global orgTaskStateDone ${black},${green}+b
    face global orgTaskStateActive ${black},${orange}+b
    face global markup_codeblock ${foreground2},${mildhighlight1}+a
    face global orgCodeBlock markup_codeblock
  "

  ## Custom
  echo "
    face global search default,rgb:212121+b
    face global CurWord +u
    face global ColumnLine default,rgb:101010
    face global RowLine default,rgb:101010
    face global WrapLine default,rgb:101010
    face global StatusLineBufname ${accent1},default+b
    face global WrapLine default,rgb:101010
  "

  # Cursor
  echo "
    face global PrimaryCursor black,${foreground}+fg
    face global SecondaryCursor black,${foreground3}+fg
    face global PrimaryCursorEol ${background},${green}
    face global SecondaryCursorEol ${background},${green}
    face global InsertCursor black,${orange}+fg
  "

  ## builtin
  echo "
    face global Default ${foreground},${background}
    face global PrimarySelection default,${selection}
    face global SecondarySelection default,${window}
    face global LineNumbers ${linenr_fg},${linenr_bg}
    face global LineNumberCursor ${linenr_fg_cur},${linenr_bg}+b
    face global LineNumbersWrapped ${mildhighlight1},${linenr_bg}+b
    face global MenuForeground ${background},${accent1}
    face global MenuBackground ${foreground},${menu}
    face global MenuInfo ${red}
    face global Information ${foreground2},${background}
    face global Error ${foreground},${red}
    face global StatusLine ${foreground},${background}
    face global StatusLineMode ${yellow}+b
    face global StatusLineInfo ${aqua},default
    face global StatusLineValue ${green}
    face global StatusCursor ${window},${aqua}
    face global Prompt ${accent1},${background}
    face global MatchingChar ${yellow},${background}+b
    face global BufferPadding ${aqua},${background}
    face global Whitespace ${mildhighlight2}+f
  "

  ## treesitter
  echo "
    face global ts_title title
    face global ts_heading heading
    face global ts_markup_heading_1 header1
    face global ts_markup_heading_2 header2
    face global ts_markup_heading_3 header3
    face global ts_markup_heading_4 header4
    face global ts_markup_heading_5 header5
    face global ts_markup_heading_6 header6
    face global ts_markup_raw_inline markup_codeblock
    face global ts_value value
    face global ts_type type
    face global ts_variable variable
    face global ts_module module
    face global ts_function function
    face global ts_string string
    face global ts_keyword keyword
    face global ts_operator operator
    face global ts_attribute attribute
    face global ts_comment comment
    face global ts_documentation documentation
    face global ts_meta meta
    face global ts_builtin builtin
    face global ts_punctuation_bracket ${foreground4},default
  "

  ## lsp
  echo "
    face global LineFlagError             ${red},default
    face global LineFlagWarning           ${orange},default
    face global LineFlagHint              ${purple},default
    face global LineFlagInfo              ${purple},default
    face global InfoDefault               Information
    face global InfoBlock                 Information
    face global InfoBlockQuote            Information
    face global InfoBullet                Information
    face global InfoHeader                default,default+b
    face global InfoLink                  Information
    face global InfoLinkMono              Information
    face global InfoMono                  Information
    face global InfoRule                  Information
    face global InfoDiagnosticError       ${red},default
    face global InfoDiagnosticWarning     ${orange},default
    face global InfoDiagnosticHint        ${purple},default
    face global InfoDiagnosticInformation ${purple},default
    face global DiagnosticError ${red}+uf
    face global DiagnosticWarning ${yellow}+uf
    face global DiagnosticInfo ${purple}+f
    face global DiagnosticHint ${purple}+f
    face global InlayDiagnosticError ${red}
    face global InlayDiagnosticWarning ${yellow}
    face global InlayDiagnosticHint ${purple}
    face global InlayDiagnosticInfo ${purple}
  "
}
