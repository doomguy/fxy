## h(elp)^: Show this help
if [ "$#" -lt 1 ]; then
  showHelp
  exit
fi

# Show generic help
if [ "$#" -eq 2 ] && [[ "$2" =~ ^help|\?$ ]]; then
  help=$(fxy | grep  "$1")
  if [ -n "$help" ] && [[ ! "$help" =~ help ]]; then
    echo "Available commands:"
    fxy | grep  "$1"
    exit
  fi
fi
