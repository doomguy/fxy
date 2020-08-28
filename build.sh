#!/usr/bin/env bash
set -euo pipefail

# Text color variables
#txtund=$(tput sgr 0 1)          # Underline
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
#bldblu=${txtbld}$(tput setaf 4) #  blue
bldgreen=${txtbld}$(tput setaf 2)
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset
info="${bldwht}[*]${txtrst}"    # Feedback
#pass="${bldblu}\[*\]${txtrst}"
warn="${bldred}[!]${txtrst}"
#ques="${bldblu}[?]${txtrst}"


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
  echo -e "\n${warn} Build failed!\n"
fi
