function tide-pure
    echo 1 1 2 2 1 1 1 y | tide configure >/dev/null
    set -U tide_cmd_duration_threshold 0
    set -U tide_cmd_duration_decimals 3
end
