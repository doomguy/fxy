## curl [s|ssl|tls] [subdir]^: curl -si PROTO://RHOST+SUBDIR | less
if [ "$1" == "curl" ]; then
  CMD="$1"; checkCmd
  PROTO="http"
  SUBDIR="/"
  # more than 1 arg?
  if [ "$#" -ge 2 ]; then
    # https?
    if [ "$2" == "s" ] || [ "$2" == "ssl" ] || [ "$2" == "tls" ]; then
      PROTO="https"
    fi

    if [ "$#" -eq 3 ] && [ "$PROTO" == "https" ]; then
      SUBDIR="$3"
    elif [ "$#" -eq 2 ] && [ "$PROTO" == "http" ]; then
      SUBDIR="$2"
    fi
  fi

  CMD="$CMD -ski -A '$USRAGENT' $PROTO://${RHOST}${SUBDIR} | less"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi
