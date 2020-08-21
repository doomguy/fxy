## b(ase)64(e|d) [input]^: Base64 Encode/Decode
if [[ "$1" =~ ^b(ase)?64(e|d)?$ ]] && [ "$#" -ge 2 ]; then
  CMD="base64"; checkCmd
  case "$1" in
    "b64"|"b64e"|"base64"|"base64e")  CMD="base64" ;;
    "b64d"|"base64d")                 CMD="base64 -d" ;;
    *)                                echo "${warn} Error parsing type of operation!"; exit ;;
  esac

  # in encoding mode:
    # if more than 2 args, use args >=2 as input
  INPUT="$2"
  if [ "$CMD" == "base64" ] && [ "$#" -ge 3 ]; then
    INPUT="$(echo "$@" | cut -d' ' -f2-)"
  fi

  CMD="echo -n $INPUT | $CMD";
  bash -c "$CMD"
  exit
fi
