## (cyber)chef [magic]^: Open CyberChef in your browser
if [ "$1" == "chef" ] || [ "$1" == "cyberchef" ]; then
  CMD="firefox"; checkCmd
  CMD="firefox https://gchq.github.io/CyberChef/"

  if [ "$#" -eq 3 ] && [ "$2" == "magic" ]; then
    INPUT=$(echo -n "$3" | base64 | sed 's,=,,g')
    echo "Run this in your browser (I can't do it for you!):"
    echo "  https://gchq.github.io/CyberChef/#recipe=Magic(3,false,false,'')&input=$INPUT"
    exit
  fi

  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi
