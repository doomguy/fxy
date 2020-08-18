## len(gth) [INPUT]^: Show length of input
if [[ "$1" =~ ^len(gth)?$ ]] && [ "$#" -ge 2 ]; then
  CMD="wc"; checkCmd
  INPUT="$(echo -n "$@" | cut -d' ' -f2-)"
  CMD="echo -n '$INPUT' | wc -c"
  echo "> $CMD"
  bash -c "$CMD"
  exit
fi
