## nikto [s(sl)|tls] [subdir]^: nikto -host PROTO://RHOST+SUBDIR | tee
if [ "$1" == "nikto" ]; then
  CMD="$1"
  export INSTCMD="apt install nikto -y"
  checkCmd
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

  CMD="$CMD -host $PROTO://${RHOST}${SUBDIR} | tee ${RHOST}_$(echo "$CMD" | cut -d' ' -f1)_$(date +%F_%H%M%S).log"
  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  exit
fi
