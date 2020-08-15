## p(ing) [count]^: ping -c COUNT RHOST
if [ "$1" == "p" ] || [ "$1" == "ping" ]; then
  CMD="ping"; checkCmd

  if [ "$#" -eq 2 ]; then
    CMD="$CMD -c $2"
  fi

  CMD="$CMD $RHOST"
  echo "> $CMD"
  bash -c "$CMD"
  exit
fi
