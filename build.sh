#!/usr/bin/env bash
set -euo pipefail

echo -e "\n[*] Building script"
cat src/*.sh > build/fxy
echo -e "\n[*] Making script executable"
chmod +x build/fxy
echo -e "\n[*] Running shellcheck"
set +e; shellcheck -s bash build/fxy; set -e

#echo
#read -p "[?] Run tests? (y/N): " -n 1 -r
#echo
#if [[ ! "$REPLY" =~ ^[Yy]$ ]]; the
#  exit
#fi
echo -e "\n[*] Running tests"
bats test/*

# build readme.md
echo "
# fxy
FXY is a small and smart bash script for fast command generation of common hacking and CTF related tasks. The source is completely modularized and adding new commands is super easy.
" > readme.md
echo '```' >> readme.md
fxy help >> readme.md
echo '```' >> readme.md
cat readme.tmpl >> readme.md
