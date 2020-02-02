# In order to bypass asdf shims. We *only* add the `ASDF_DIR/bin`
# directory to PATH, since we still want to use `asdf` but not its shims.
# It *should* already be on the path from env.toml
# export PATH="$HOME/.asdf/bin:$PATH"

# Hook direnv into your shell.
eval "$(asdf exec direnv hook zsh)"

local shims=(~/.asdf/shims/*)
local hashfile="$HOME/.asdf_shim_sha"
local funcfile="$XDG_CONFIG_HOME/zsh/conf.d/functions.zsh"

local new_hash=$(hashdir "$HOME/.asdf/shims")

if [[ ! -f $hashfile ]] || [[ $new_hash != $(<$hashfile) ]]; then
    echo "ASDF shims have changed since last shell start...recreating shim functions"
    echo "# File created by direnv.zsh" >"$funcfile"
    for f in "${shims[@]}"; do
        local s=$(basename "$f")
        echo "$s() { asdf exec $s \$@ }" >>"$funcfile"
    done
    echo "$new_hash" >"$hashfile"
fi
