function cargo-installed --description 'Get list of global crates installed from cargo manifest'
    jq '.installs|keys' $CARGO_HOME/.crates2.json
end
