function fuck --description 'Correct your previous console command'
    set fucked_up_command $history[1]
    # env TF_SHELL=fish TF_ALIAS=fuck PYTHONIOENCODING=utf-8 thefuck $fucked_up_command THEFUCK_ARGUMENT_PLACEHOLDER $argv | read -l unfucked_command
    set TF_SHELL fish
    set TF_ALIAS fuck
    set PYTHONIOENCODING utf-8

    set unfucked_command (thefuck $fucked_up_command THEFUCK_ARGUMENT_PLACEHOLDER $argv)
    if test -n $unfucked_command
        eval $unfucked_command
        history delete --exact --case-sensitive -- $fucked_up_command
        history merge
    end
end
