## help^: Show this help
if [ "$#" -lt 1 ]; then
  showHelp
  exit
fi

# Show generic help
if [ "$#" -eq 2 ] && [ "$2" == "help" ]; then
  help=$(fxy | tr -d '()' | grep  "$1")
  if [ -n "$help" ] && [[ ! "$help" =~ help ]]; then
    echo "Available commands for '$1':"
    RES=$(fxy | grep "$1")
    if [[ ! "$RES" =~ "$1" ]]; then
      RES=$(fxy | tr -d '()' | grep "$1")
    fi
    echo "$RES" | grep --color "$1"
    exit
  fi
fi
