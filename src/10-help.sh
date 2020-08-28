## h(elp) [keyword]^: Show this help
if [ "$#" -lt 1 ] || { [ "$#" -eq 1 ] && [[ "$1" =~ ^h(elp)?$ ]]; }; then
  showHelp
  exit
fi

if [ "$#" -eq 2 ] && [[ "$1" =~ ^h(elp)?$ ]]; then
  echo "Found entries for '$2':"
  fxy | grep --color "$2"
  exit
fi

# Show generic help
# if [ "$#" -eq 2 ] && [ "$2" == "help" ]; then
#   help=$(fxy | tr -d '()' | grep -E "$1.*help.*:")
#   if [ -z "$help" ]; then
#     echo "Found entries for '$1':"
#     RES=$(fxy | grep -E "$1")
#     if [ -z "$RES" ]; then
#       RES=$(fxy | tr -d '()' | grep "$1")
#     fi
#     if [ -n "$RES" ]; then
#       echo "$RES" | grep --color "$1"
#       exit
#     fi
#   fi
# fi

# 2DO:
# - fxy ssh help
# - fcy cyberchef help
