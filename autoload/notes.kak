define-command create-log -params 1.. %{
  connect run env "EDITOR=kcr edit" "%val{config}/scripts/logger.sh" %arg{@}
}
