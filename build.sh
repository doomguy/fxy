#!/usr/bin/env bash
set -euo pipefail

# Text color variables
#txtund=$(tput sgr 0 1)          # Underline
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldblu=${txtbld}$(tput setaf 4) #  blue
bldgreen=${txtbld}$(tput setaf 2)
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset
info="${bldwht}[*]${txtrst}"    # Feedback
#pass="${bldblu}\[*\]${txtrst}"
warn="${bldred}[!]${txtrst}"
ques="${bldblu}[?]${txtrst}"

prompt() {
  read -p "${ques} ${bldwht}Run command? (y/N): ${txtrst}" -n 1 -r
  echo
  if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    exit
  fi
}

INSTCMD=""
checkCmd() {
  if [ ! "$(which "$CMD")" ]; then
    echo "${warn} '$CMD' required but missing."
    if [ -n "$INSTCMD" ]; then
      echo "${bldwht}> $INSTCMD${txtrst}"; prompt; bash -c "$INSTCMD";
    else
      exit
    fi
  fi
}

echo -e "\n${info} Check for missing build commands"
CMD="shellcheck"
INSTCMD="sudo apt-get install shellcheck -y"
checkCmd

CMD="bats"
INSTCMD="sudo apt-get install bats -y"
checkCmd

echo -e "\n${info} Building script"
cat src/*.sh > build/fxy
echo -e "\n${info} Making script executable"
chmod +x build/fxy

echo -e "\n${info} Building readme.md"
{
echo '
# fxy - Fox in the $hell
fxy is a small and smart bash script for fast command generation of common hacking and CTF related tasks. The source is completely modularized and adding new commands is super easy.
'
echo '```'
fxy help
echo '```'
cat readme.tmpl
} > readme.md

echo -e "\n${info} Running shellcheck"
set +e; shellcheck -s bash build/fxy; set -e

#read -p "[?] Run tests? (y/N): " -n 1 -r
#echo
#if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
#  exit
#fi
echo -e "\n[*] Running tests"
set +e; bats test/* | tee bats.log
if [ "$?" -eq 0 ]; then
  echo -e "\n${info} ${bldgreen}Build successful!\n"
else
  echo -e "\n${warn} ${txtbld}Build failed!\n"
fi
