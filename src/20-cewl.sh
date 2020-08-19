## cewl [s|ssl|tls] [subdir]^: cewl PROTO://RHOST+SUBDIR -w RHOST_cewl.txt
if [ "$1" == "cewl" ]; then
  CMD="$1"; checkCmd
  PROTO="http"
  SUBDIR="/"
  # more than 1 arg?
  if [ "$#" -ge 2 ]; then
    # https?
    if [ "$2" == "s" ] || [ "$2" == "ssl" ] || [ "$2" == "tls" ]; then
      PROTO="https"
    fi
    # subdir?
    if [ "$#" -eq 3 ] && [ "$PROTO" == "https" ]; then
      SUBDIR="$3"
    elif [ "$#" -eq 2 ] && [ "$PROTO" == "http" ]; then
      SUBDIR="$2"
    fi
  fi

  CMD="$CMD $PROTO://${RHOST}${SUBDIR} -w ${RHOST}_cewl.txt"
  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  exit
fi
