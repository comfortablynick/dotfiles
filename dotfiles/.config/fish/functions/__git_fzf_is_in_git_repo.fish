# Defined in /tmp/fish.KmEnCZ/__git_fzf_is_in_git_repo.fish @ line 1
function __git_fzf_is_in_git_repo
	command -s -q git
    and git rev-parse HEAD >/dev/null 2>&1
end
