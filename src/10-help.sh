## h(elp) [search keyword]^: Show help or search for keyword
if [ "$#" -lt 1 ] || { [ "$#" -eq 1 ] && [[ "$1" =~ ^h(elp)?$ ]]; }; then
  showHelp
  exit
fi

if [ "$#" -eq 2 ] && [[ "$1" =~ ^h(elp)?$ ]]; then
  if [ -n "$(fxy | tr -d '()' | grep "$2")" ]; then
    echo "Found entries for '$2':"
    fxy | tr -d '()' | grep --color "$2"
  else
    echo "${warn} Nothing found!"
  fi
  exit
fi

# 2DO:
# - fcy cyberchef help
