# In order to bypass asdf shims. We *only* add the `ASDF_DIR/bin`
# directory to PATH, since we still want to use `asdf` but not its shims.
# It *should* already be on the path from env.toml
# export PATH="$HOME/.asdf/bin:$PATH"

# Hook direnv into your shell.
eval "$(asdf exec direnv hook zsh)"
