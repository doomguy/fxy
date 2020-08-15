## dirb [s|ssl|tls] [subdir]^: dirb PROTO://RHOST+SUBDIR | tee
if [ "$1" == "dirb" ]; then
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

  CMD="$CMD $PROTO://${RHOST}${SUBDIR} | tee ${RHOST}_$(echo "$CMD" | cut -d' ' -f1)_$(date +%F_%H%M%S).log"
  echo "> $CMD"
  prompt
  bash -c "$CMD"
  exit
fi
