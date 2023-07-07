# get current branch and status
function parse_git_info() {
  BRANCH=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  if [ ! "${BRANCH}" == "" ]; then
    STAT=$(parse_git_status)
    echo "(${BRANCH}${STAT}) "
  else
    echo ""
  fi
}

function parse_git_status {
  status=$(git status 2>&1 | tee)
  unstaged=$(
    echo -n "${status}" 2>/dev/null | grep "Changes not staged for commit" &>/dev/null
    echo "$?"
  )
  staged=$(
    echo -n "${status}" 2>/dev/null | grep "Changes to be committed" &>/dev/null
    echo "$?"
  )
  untracked=$(
    echo -n "${status}" 2>/dev/null | grep "Untracked files" &>/dev/null
    echo "$?"
  )
  upstream=$(echo -n "${status}" 2>/dev/null | grep "Your branch")
  stash=$(git stash list | wc -l | tr -d '[:space:]')

  bits=''

  if [ "${unstaged}" == "0" ]; then
    bits="*${bits}"
  fi

  if [ "${staged}" == "0" ]; then
    bits="+${bits}"
  fi

  if [ "${untracked}" == "0" ]; then
    bits="%${bits}"
  fi

  if [ "${upstream}" != "" ]; then
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

  if [ ! "${bits}" == "" ]; then
    echo " ${bits}"
  else
    echo ""
  fi
}

PS1="\[\e[1;32m\]➤➤\[\e[m\] "                 # start prompt
PS1+="\[\e[1;34m\]\W\[\e[m\] "                # current directory
PS1+="\[\e[1;36m\]\`parse_git_info\`\[\e[m\]" # git status
PS1+="\[\e[1;32m\]\\$\[\e[m\] "               # end prompt

export PS1
