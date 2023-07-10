# get current branch
function parse_git_branch() {
    BRANCH=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    if [ -n "${BRANCH}" ]; then
        echo "(${BRANCH}) "
    else
        echo ""
    fi
}

PROMPT="%F{green}➤➤%f "                 # start prompt
PROMPT+="%F{blue}%1d%f "                # current directory
PROMPT+="%F{cyan}$(parse_git_branch)%f" # current branch
PROMPT+="%F{green}$%f "                 # end prompt

export PROMPT
