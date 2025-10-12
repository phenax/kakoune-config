evaluate-commands %sh{
  foreground="rgb:c5c8c6"
  foreground2="rgb:809090"
  background="default"
  accent1="rgb:007070"
  accent2="rgb:009090"
  selection="rgb:373b41"
  window="rgb:282a2e"
  linenr_bg="default"
  linenr_fg="rgb:606262"
  linenr_fg_cur="rgb:ffffff"
  menu="rgb:101414"
  mildhighlight="rgb:101414"
  comment="rgb:434545"
  red="rgb:cc6666"
  orange="rgb:de935f"
  yellow="rgb:f0c674"
  green="rgb:b3f6c0"
  lightblue="rgb:81a2be"
  brightblue="rgb:82aaff"
  aqua="rgb:8abeb7"
  purple="rgb:b294bb"

  ## code
  echo "
    face global value ${orange}
    face global type ${yellow}
    face global variable ${red}
    face global module ${lightblue}
    face global function ${lightblue}
    face global string ${green}
    face global keyword ${accent2}
    face global operator ${aqua}
    face global attribute ${lightblue}
    face global comment ${comment}
    face global documentation comment
    face global meta ${foreground}
    face global builtin ${yellow}
  "

  ## markup
  echo "
    face global title ${lightblue}
    face global header ${aqua}
    face global mono ${green}
    face global block ${orange}
    face global link ${lightblue}
    face global bullet ${red}
    face global list ${red}
  "

  ## Custom
  echo "
    face global search default,rgb:212121+b
    face global CurWord default,default+u
    face global ColumnLine default,rgb:101010
    face global RowLine default,rgb:101010
    face global WrapLine default,rgb:101010
    face global StatusLineBufname ${accent1},default+b
    face global StatusLineDetails ${comment},default+b
  "

  ## builtin
  echo "
    face global Default ${foreground},${background}
    face global PrimarySelection ${foreground},${selection}+fg
    face global SecondarySelection ${foreground},${window}+fg
    face global PrimaryCursor ${background},${foreground}+fg
    face global SecondaryCursor ${background},${aqua}+fg
    face global PrimaryCursorEol ${background},${green}+fg
    face global SecondaryCursorEol ${background},${green}+fg
    face global LineNumbers ${linenr_fg},${linenr_bg}
    face global LineNumberCursor ${linenr_fg_cur},${linenr_bg}+b
    face global LineNumbersWrapped ${mildhighlight},${linenr_bg}+b
    face global MenuForeground ${menu},${foreground}
    face global MenuBackground ${foreground},${menu}
    face global MenuInfo ${red}
    face global Information ${foreground2},${background}
    face global Error ${foreground},${red}
    face global DiagnosticError ${red}
    face global DiagnosticWarning ${yellow}
    face global StatusLine ${foreground},${background}
    face global StatusLineMode ${yellow}+b
    face global StatusLineInfo ${aqua},default
    face global StatusLineValue ${green}
    face global StatusCursor ${window},${aqua}
    face global Prompt ${accent1},${background}
    face global MatchingChar ${yellow},${background}+b
    face global BufferPadding ${aqua},${background}
    face global Whitespace ${comment}+f
  "

  ## code
  echo "
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
  "
}
