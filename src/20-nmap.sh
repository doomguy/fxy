## n(map) [full]^: nmap -v -A (-p-) RHOST | tee
if [ "$1" == "n" ] || [ "$1" == "nmap" ]; then
  CMD="nmap"; checkCmd
  if [ "$#" -eq 2 ] && [[ "$2" =~ ^f(ull)?$ ]]; then
    CMD="$CMD -p-"
  fi
  CMD="$CMD -v -A $RHOST -oA ${RHOST}_$(echo "$CMD" | cut -d' ' -f1)_$(date +%F_%H%M%S)"
  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  exit
fi
