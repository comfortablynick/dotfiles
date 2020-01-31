_direnv_hook() {
  local previous_exit_status=$?;
  trap -- '' SIGINT;
  eval "$("/home/nick/.asdf/installs/direnv/2.21.1/bin/direnv" export bash)";
  trap - SIGINT;
  return $previous_exit_status;
};
if ! [[ "${PROMPT_COMMAND:-}" =~ _direnv_hook ]]; then
  PROMPT_COMMAND="_direnv_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi
