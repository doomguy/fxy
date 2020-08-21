## curl [s(sl)|tls] [subdir]^: curl -si PROTO://RHOST+SUBDIR | less
if [ "$1" == "curl" ]; then
  CMD="$1"; checkCmd
  PROTO="http"
  SUBDIR="/"
  # more than 1 arg?
  if [ "$#" -ge 2 ]; then
    # https?
    if [[ "$2" =~ ^s(sl)?|tls$ ]]; then
      PROTO="https"
    fi

    if [ "$#" -eq 3 ] && [ "$PROTO" == "https" ]; then
      SUBDIR="$3"
    elif [ "$#" -eq 2 ] && [ "$PROTO" == "http" ]; then
      SUBDIR="$2"
    fi
  fi

  CMD="$CMD -ski -A '$USRAGENT' $PROTO://${RHOST}${SUBDIR} | less"
  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  exit
fi
