# In order to bypass asdf shims. We *only* add the `ASDF_DIR/bin`
# directory to PATH, since we still want to use `asdf` but not its shims.
if [ -d "$HOME/.asdf" ]; then
    export PATH="$HOME/.asdf/bin:$PATH"

    # shell="$(basename "$SHELL")"
    eval "$(asdf exec direnv hook "$CURRENT_SHELL")"

    # Shouldn't need our `.` alias on zsh for this one
    command . "$HOME/.asdf/completions/asdf.bash"
fi
