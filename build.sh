#!/usr/bin/env bash
set -euo pipefail

echo -e "\n[*] Building script"
cat src/* > build/fxy
echo -e "\n[*] Making script executable"
chmod +x build/fxy
echo -e "\n[*] Running shellcheck"
set +e; shellcheck build/fxy; set -e

#echo
#read -p "[?] Run tests? (y/N): " -n 1 -r
#echo
#if [[ ! "$REPLY" =~ ^[Yy]$ ]]; the
#  exit
#fi
echo -e "\n[*] Running tests"
bats test/*

# readme.md
echo '
# fxy
Shell wizardry for hacking and CTF.
' > readme.md
echo '```' >> readme.md
fxy help >> readme.md
echo '```' >> readme.md
