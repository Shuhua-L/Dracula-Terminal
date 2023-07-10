# get current branch
function parse_git_branch() {
  BRANCH=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  if [ ! "${BRANCH}" == "" ]; then
    echo "(${BRANCH}) "
  else
    echo ""
  fi
}

PS1="\[\e[1;32m\]➤➤\[\e[m\] "                   # start prompt
PS1+="\[\e[1;34m\]\W\[\e[m\] "                  # current directory
PS1+="\[\e[1;36m\]\`parse_git_branch\`\[\e[m\]" # current branch
PS1+="\[\e[1;32m\]\\$\[\e[m\] "                 # end prompt

export PS1
