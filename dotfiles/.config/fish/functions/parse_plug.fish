# Defined in /tmp/fish.OxZZmS/parse_plug.fish @ line 2
function parse_plug --description 'parse fundle plugin call'
	set -l plug "account/repo '{from: gh, if: test 1 -eq 1, after: ./install.py}'"
    echo "Input: $plug"
    set -l commands (echo $plug | grep -Po '{\K[^{]*(?=})')
    echo "Raw commands: $commands"

    # Parse commands
    echo $commands | awk '
        {
            delete vars;
            split($0, cmd, ", ")
            for (i = 0; i < length(cmd); i++) {
                # printf("%s\n", cmd[i]) # debug print
                n = index(cmd[i], ":");
                if(n) {
                    vars[substr(cmd[i], 1, n - 1)] = substr(cmd[i], n + 1)
                }
            }
            cmd_from = vars["from"]
            cmd_if = vars["if"]
            cmd_after = vars["after"]
            cmd_path = vars["path"]

            printf("\nPARSED COMMANDS:\n")
            printf("From:  %s\n", cmd_from)
            printf("If:    %s\n", cmd_if)
            printf("After: %s\n", cmd_after)
            printf("Path:  %s\n", cmd_path)
        }'
end
