function _aur_helper -d "Get installed aur helper"
    if not set -q aur_helper
        set -f aur_helper (command -v paru; or command -v yay)
    end
    $aur_helper $argv
end
