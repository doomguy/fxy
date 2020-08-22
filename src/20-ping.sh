## p(ing) [count]^: ping -c COUNT RHOST
if [[ "$1" =~ ^p(ing)?$ ]]; then
  CMD="ping"; checkCmd

  if [ "$#" -eq 2 ]; then
    if [[ "$2" =~ ^[0-9]+$ ]]; then # is it a number?
      CMD="$CMD -c $2"
    else
      echo "${warn} Not a number!"; exit
    fi
  fi

  CMD="$CMD $RHOST"
  echo "${bldwht}> $CMD${txtrst}"
  bash -c "$CMD"
  exit
fi
