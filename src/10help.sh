## h(elp)^: Show this help
if [ "$#" -lt 1 ] || [[ "$1" =~ ^h(elp)?$ ]]; then
  showHelp
  exit
fi
