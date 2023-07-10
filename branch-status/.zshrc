# get current branch and status
function parse_git_info() {
    BRANCH=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    if [ -n "${BRANCH}" ]; then
        STAT=$(parse_git_status)
        echo "(${BRANCH}${STAT}) "
    else
        echo ""
    fi
}

function parse_git_status {
    git_status=$(git status 2>&1)
    unstaged=$(
        echo -n "${git_status}" 2>/dev/null | grep "Changes not staged for commit" >/dev/null
        echo "$?"
    )
    staged=$(
        echo -n "${git_status}" 2>/dev/null | grep "Changes to be committed" >/dev/null
        echo "$?"
    )
    untracked=$(
        echo -n "${git_status}" 2>/dev/null | grep "Untracked files" >/dev/null
        echo "$?"
    )
    upstream=$(echo -n "${git_status}" 2>/dev/null | grep "Your branch")
    stash=$(git stash list | wc -l | tr -d '[:space:]')

    bits=''

    if [ "${unstaged}" = "0" ]; then
        bits="*${bits}"
    fi

    if [ "${staged}" = "0" ]; then
        bits="+${bits}"
    fi

    if [ "${untracked}" = "0" ]; then
        bits="%${bits}"
    fi

    if [ -n "${upstream}" ]; then
        if [[ ${upstream} == *"behind"* ]]; then
            bits="<${bits}"
        elif [[ ${upstream} == *"ahead"* ]]; then
            bits=">${bits}"
        elif [[ ${upstream} == *"diverged"* ]]; then
            bits="<>${bits}"
        fi
    fi

    if [ "${stash}" != "0" ]; then
        bits="\$${bits}"
    fi

    if [ -n "${bits}" ]; then
        echo " ${bits}"
    else
        echo ""
    fi
}

PROMPT="%F{green}➤➤%f "               # start prompt
PROMPT+="%F{blue}%1d%f "              # current directory
PROMPT+="%F{cyan}$(parse_git_info)%f" # git status
PROMPT+="%F{green}$%f "               # end prompt

export PROMPT
